---
title: Home File Server
category: Hardware
---

## What do I need?
I have a few requirements for a home file server:

* Needs to be fairly reliable and easy to fix - all the TVs in the house use it for media storage, and my 3 year old daughter demands high uptime for her cartoons!
* Support lots of hard drives.  I don't have money to go out and buy all new 4 or 6TB drives, so I need room for more smaller drives.  It also needs to be easy to upgrade those drives later on.
* Needs to be a full computer - not an appliance.  I want to be able to run whatever software I need on it with ease.
* Not cost a fortune.
Notably absent from that list are "low power" and "quiet".  I'm ok with it using a bit more power if I get a lot more functionality and reliability out of it.  And noise isn't much of an issue - it sits in the basement with all the network gear.

## My New Server
I managed to snag an older IBM 3500 (the original 7977 model, not the more modern M3 or M4) very cheaply - as well as some spare parts like extra fans and power supplies for it.

![IBM server](/images/ibm3500.jpg)

This server has 8 3.5" drive slots,  There are two backplane boards which I have previously written about built in.

I had considered making a custom case that could use the backplanes, with small motherboard and a SAS RAID card...but that's a lot of work, and would cost more as well.  The biggest downside is that I wouldn't have been able to use the server's power supplies.  The server's power supplies provide 12.1V (at 69 amps!), but no 5V or 3.3V - those voltage regulators are all built into the motherboard.  So it ends up being far simpler to just use the server as is.

## SAS controller
The biggest problem is the server's ServeRAID 8k controller.  With the latest firmware updates, it supports drives up to 2TB - but nothing past that.  Any drive larger than 2TB either gets detected as 2TB, or not properly detected at all.

The backplanes use standard SFF-8087 ports, so it's easy to find HBAs that can use them.  I had it narrowed down to:
* IBM M1015
* Dell H200
* Dell H310
* LSI MegaRAID 9240-8i
All of those cards are pretty similar - all LSI chipsets, and practically identical for my purposes - they are have 2 SFF-8087 ports, and can be used as JBOD or pass through without any RAID.  That was very important that it properly support JBOD - otherwise the disks wouldn't be readable with a different controller card later on.  The IBM and Dell branded ones would have had to be flashed with LSI IT firmware to do that properly, but that's not hard to do.

I ended up getting the LSI branded one on ebay for around $110.

I also picked up 2x 1M SFF-8087 SAS cables on ebay for $23.70, since the ones that come with the server aren't going to be long enough to reach the new card.

Once the parts arrived, installing the card was pretty straight forward.  The only tricky part was actually running the cables.  The entire section of the case between the motherboard and drive bays is full of fans on a big mount that slides out.

Luckily, if you remove the mount there is a small gap between two of the fan connectors where the cables can run.  You just need to be very careful reinstalling the fan mount so the cables don't move and get pinched. ![SAS cables](/images/ibm3500_sascables.jpg)

The server detected the new card without any issues, and the card detected all of the hard drives properly.  This card can do RAID, but it's default is to act as a regular HBA and just use the disks normally - that is exactly what I want for this setup.  The OS can manage the disks directly, and unlike controllers that do tricks like single drive RAID 0 arrays for each disk, the drives can be pulled out and used in another system or the card replaced with a different model without any trouble.

## Why is there a jet engine in our basement?
So, quiet wasn't on the list of requirements.  But quiet is a relative thing.  I don't need it to be silent, but by default this server is **noisy**!  It has 6 fans running.  If you try to remove the fans, the others won't slow down anymore, so it gets even louder.

Luckily, I don't actually need all those fans.  You only need all 6 fans if you have either a second CPU or a second power supply installed.  Without a second CPU or PSU, fans 4-6 can be removed and blanking panels installed over slots 5 and 6.  That quiets it down quite a bit.

I didn't have a second CPU to begin with, but since I have it, I did want a second power supply installed.  But having the server shutdown until I swap in a new power supply is a small price to pay for a large noise reduction.

![Server inside](/images/ibm3500_2.jpg)

Next up is to install and configure the OS.
