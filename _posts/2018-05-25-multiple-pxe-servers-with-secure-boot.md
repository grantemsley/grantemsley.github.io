---
title: Network Booting - Multiple Servers, UEFI, and Secure Boot
category: Configuration Manager
---

In the process of migrating from ConfigMgr 2012R2 to Current Branch, I have 2 ConfigMgr servers on the same network.  In addition to that, I have a regular WDS server that is used for imaging servers, and a Ubuntu PXE server that netboots various utilities.

But how to choose which server a computer uses to boot?  With a normal setup, the computer will just boot from whichever server responds first.  This setup avoids that problem.

## What makes this hard to do?

UEFI and Secure Boot.  I want to use Secure Boot on some machines.  But with secure boot enabled, you can only load a Microsoft signed bootloader.  It also requires disabling the legacy boot mode for network booting/

My previous setup just had a Ubuntu server running DNSMasq and booting PXELINUX.  That pxelinux gave a menu with options for WDS and ConfigMgr servers, and other utilities.

It doesn't work in UEFI mode however, only legacy network boot mode.  Supposedly you can boot SYSLINUX over pxe in UEFI mode, but it's buggy and doesn't work for me.  And SYSLINUX hasn't had a release in years from what I can see, so it doesn't
look like it's getting fixed any time soon. On top of that, neither pxelinux nor syslinux is signed by Microsoft.  So on a secure boot system, it can't be loaded.  Again, there are supposed to be ways around that, like using a Microsoft signed shim
and a Cannonical signed version of grub to do the loading, but I couldn't get that working properly either.  Even if I could, it might work on physical machines, but VMs require you to choose either the Microsoft Windows or Microsoft 3rd party secure boot
template - you can't have both.  Which means even if it did work, there's no way to get secure boot to go from the Microsoft 3rd party signed shim to a Microsoft Windows signed WDS bootloader.

That's fine, I can accept that. But I still need to be able to choose between several WDS/ConfigMgr boot servers, which do use Microsoft signed bootloaders and work with Secure Boot.

This setup does that - BIOS clients can still use the menu and utilities.  UEFI clients can only use WDS/ConfigMgr, but get a menu where they can choose which server to use.

## Network Setup

In almost every topic I've read, DHCP options and IP Helpers comes up a lot.  Everyone seems to be very confused by them.

DHCP Options are set on your DHCP server.  They will not work with both BIOS and UEFI, because you can only point clients at a single boot program.  There are ways around this, but its complex and hard to configure.
IP Helpers are configured on your switch or router, to forward the DHCP broadcast packets beyond their local subnet to remote DHCP/WDS/PXE/ConfigMgr servers.

If your DHCP server, WDS/PXE/ConfigMgr server(s) and clients are all on the same subnet, you don't need any of that.  It will just work.

My network has:

- `ad1` (192.168.0.2) and `ad2` (192.168.0.3) - Server 2012R2 AD Domain controllers, running DNS and DHCP as well.
- `sccm2012` (192.168.0.10) - ConfigMgr 2012R2 server
- `sccmcb` (192.168.0.11) - ConfigMgr Current Branch
- `wds` (192.168.0.12) - Server 2012R2 WDS server
- `pxe` (192.168.0.4) - Ubuntu 18.04 server
- `biosclient` - A generation 1 Hyper-V VM using the legacy network adapter, on a Windows 10 machine
- `ueficlient` - A generation 2 Hyper-V VM with Secure Boot enabled and set to the Microsoft Windows template

### ConfigMgr Server(s)

Enable PXE on the configuration manager server normally.  In the distribution point's PXE settings, set a PXE server response delay of 15 seconds on both servers.

You may also want to disable the "Press F12 to network boot" prompt.  In the RemoteInstall folder, under SMSBoot, do this in both the x64 and x86 folders:
- Rename `pxeboot.com` to `pxeboot.f12`
- Copy `pxeboot.n12` to `pxeboot.com`

That removes the F12 prompt with booting.

### WDS Server

Even if you don't plan to use WDS and just want 2 configuration manager servers, you still need the WDS server.  It's part fo the magic.

Setup WDS like normal.  Set the PXE Response Delay to 2 seconds.

You'll also need to enable the WDS boot menu.  This is a hidden (and unsupported) feature of WDS.  In regedit, change `HKLM\System\CurrentControlSet\Services\WDSServer\Providers\WDSPXE\Providers\BINLSVC\AllowServerSelection` to 1 and restart the WDS service.

### Ubuntu Server Setup

The Ubuntu server is only needed if you want to boot other utilities like memtest, linux live images, etc.  If you are strictly interested in WDS and ConfigMgr and don't want any of those, you can skip this step.

Anything you configure here *will not* work on systems using native UEFI booting (but legacy network booting in UEFI mode should still work).  I set it up this way to allow secure boot systems to still use the WDS/ConfigMgr servers - they will not load
pxelinux since it isn't signed by Microsoft.

Install Ubuntu 18.04 Server. Set a static IP address for it (the method is different from previous versions, so look up how to do it).

#### Fix DNSMasq

Dnsmasq is installed in Ubuntu 18.04 by default, but doesn't work properly.  To get it running as a full server instead of a DNS client, you need to:

Edit `/etc/systemd/resolved.conf` to set `DNSStubListener=no`

Remove the symlink `/etc/resolv.conf` and replace with a resolv.conf containing:

```
nameserver 4.2.2.1
nameserver 4.2.2.2
search your.domain.here
```
Replace the nameservers there with whatever you want to use, preferably your AD DNS servers.

The default install doesn't have the configuration to run as a service. Create `/etc/systemd/system/dnsmasq.service`:

```
[Unit]
Description = Self-created DNSMasq service unit file
After=sys-subsystem-net-devices-enp4s0.device

[Service]
Type=forking
ExecStartPre=/lib/systemd/systemd-networkd-wait-online -i enp4s0
ExecStart=/usr/sbin/dnsmasq
Restart=on-failure
RestartSec=15

[Install]
WantedBy=sys-subsystem-net-devices-enp4s0.device
```

Replace enp4s0 with the name of your network card, eg. eth0. Thanks to https://nucco.org/2018/05/ubuntu-18-04-chronicles-creating-a-dnsmasq-service.html for the guide on how to fix that


Create `/etc/dnsmasq.conf` with:

```
port=0
log-dhcp
enable-tftp
tftp-root=/var/lib/tftpboot
dhcp-range=192.168.0.1,proxy,255.255.255.0
pxe-prompt="Press F8 for Dnsmasq options", 1
pxe-service=x86PC, "Go to main menu", lpxelinux
pxe-service=x86-64_UEFI, "WDS Server for UEFI", boot\x64\wdsmgfw.efi,192.168.0.12
```

Replace the `dhcp-range` with your subnet, and 192.168.0.12 with the IP address of your standard WDS server.

This configuration tells Dnsmasq to only act as a PXE proxy server, for BIOS clients telling them to boot `lpxelinux` from this server's tftp directory and for UEFI clients to skip that and boot directly to the WDS server.

#### TFTPBoot files

Create the directory `/var/lib/tftpboot`. Download syslinux from https://mirrors.edge.kernel.org/pub/linux/utils/boot/syslinux/Testing/6.04/syslinux-6.04-pre1.tar.gz, and extract it.  From that folder copy these files:
- `bios/core/lpxelinux.0` to `/var/lib/tftpboot/lpxelinux.0`
- `bios/com32/elflink/ldlinux/ldlinux.c32` to `/var/lib/tftpboot/ldlinux.c32`
- `bios/com32/menu/menu.c32` to `/var/lib/tftpboot/menu.c32`
- `bios/com32/menu/vesamenu.c32` to `/var/lib/tftpboot/vesamenu.c32`
- `bios/com32/libutil/libutil.c32` to `/var/lib/tftpboot/libutil.c32`
- `bios/com32/lib/libcom32.c32` to `/var/lib/tftpboot/libcom32.c32`
- `bios/com32/modules/pxechn.c32` to `/var/lib/tftpboot/pxechn.c32`

I also copied the Parted Magic PXE boot files to a folder, and Memtest86+ V5.01.  I also found a nice background and saved it as `background.jpg`.

`lpxelinux.0` is used instead of `pxelinux.0` because it also supports HTTP loading.  You can setup an HTTP server and point to files like `LINUX http://192.168.0.12/pmagic/bzImage64` which will load them over HTTP instead of TFTP.  
I didn't fully document that here, but it's much faster.

Create a `/var/lib/tftpboot/pxelinux.cfg` folder, and a file named `default` in there with:

```
DEFAULT vesamenu.c32
NOESCAPE 1

MENU TITLE Network Boot Menu
MENU RESOLUTION 1024 768
MENU BACKGROUND background.jpg

LABEL -
  MENU LABEL OS Deployment:
  MENU DISABLE

LABEL wds
  MENU LABEL WDS Server at 192.168.0.12
  MENU INDENT 2
  KERNEL pxechn.c32 192.168.0.12::Boot\x64\wdsnbp.com -W
  TEXT HELP
  Standard WDS server
  ENDTEXT

LABEL configmgr2012
  MENU LABEL ConfigMgr 2012R2 at 192.168.0.10
  MENU INDENT 2
  KERNEL pxechn.c32 192.168.0.10::Boot\x64\wdsnbp.com -W
  TEXT HELP
  Configuration Manager 2012R2
  ENDTEXT

LABEL configmgrcb
  MENU LABEL ConfigMgr Current Branch at 192.168.0.11
  MENU INDENT 2
  KERNEL pxechn.c32 192.168.0.11::Boot\x64\wdsnbp.com -W

LABEL -
  MENU LABEL Diagnostics:
  MENU DISABLE

LABEL pmagic
  MENU LABEL Parted Magic Utilities
  MENU INDENT 2
  LINUX pmagic/bzImage64
  INITRD pmagic/initrd.img,pmagic/fu.img,pmagic/m64.img,pmagic/files.cgz
  APPEND edd=on vga=normal
  TEXT HELP
Parted Magic (https://partedmagic.com)

- Disk Partitioning and cloning
- Erase HDDs, SSDs and NVME drives with proper Secure Erase support
- Benchmark and stress testing
- Reset local administrator password for Windows
  ENDTEXT

LABEL memtest
  MENU LABEL MemTest
  MENU INDENT 2
  KERNEL utils\memtest
  TEXT HELP
Memtest86+ 5.01
Runs memory diagnostics
  ENDTEXT
```

Edit the IP addresses for your own servers.  You can add more network boot items as desired.  Most network bootable utilities and OSes come with instructions on how to put them in pxelinux's menu.

## Boot Process

### BIOS Client

#### With Ubuntu server:

- Starts network booting
- Dnsmasq on pxe server responds first.  Computer boots from that and loads the pxelinux menu
- From the pxelinux menu, user selects which server or utility to run, with the ability to choose any of the 3 windows deployment servers.

This lets you directly choose any server you want.  There's no function key to forget to press in time.  And you can choose from any other utilities you add.

#### Without Ubuntu server:

- Starts network booting
- WDS server responds first, loading it's ndsnbp.com boot program.
- WDS boot program gives the option to press F11 to select a boot server.
- If you press F11, it will search for other WDS servers, and list all 3 available servers (itself, plus the two ConfigMgr servers).  You can choose any of the servers.
- If you don't, it boots from the WDS server

### UEFI Client

- Starts network booting
- Dnsmasq responds first.  It points to the WDS server's network boot program.  If you skipped the Ubuntu setup, The WDS server would respond first and you'd end up in the same place.
- The WDS boot program gives the option to press F9 to select a boot server. (Yes, it's F9 on UEFI and F11 on BIOS, no idea why it's different.)
- If you press F9, it will search for other WDS servers, and list all 3 available servers (itself, plus the two ConfigMgr servers).  You can choose any of the servers.
- If you don't, it boots from the WDS server

This does NOT allow booting anything utilities, but works in Secure Boot mode.

The one downside to this is the ConfigMgr servers get listed like `192.168.0.11 [Unknown]`.  You have to know which IP address corresponds to the server you want. There doesn't seem to be any way to set their name.