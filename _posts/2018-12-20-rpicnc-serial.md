---
title: Connecting to RPI-CNC board over serial
category: CNC
---

The Raspberry PI CNC board I use is great - but one limitation is that the software has to run on the PI.  For some programs, this works fine, and I can use a web interface in Laserweb or other software.  Or just send gcode to run.

But there are some programs that only run on Windows, and work better if they are directly connected to the machine's COM/USB port rather than exporting gcode.  In particular, I'm trying out [LightBurn](https://lightburnsoftware.com/), which so far
works so much better than Laserweb.  For the $40 the author asks for it, it's a steal!

So here's how you can do a serial port over the network, to connect Lightburn "directly" to the machine without having to rip out the RPI CNC controller for something else.

### PI Side ###

We will use ser2net to make it so we can telnet to the PI, and be connected to the serial port the GRBL controller uses.

Install ser2net with `apt-get install ser2net`

Then edit `/etc/ser2net.conf` and add this line to the bottom:

```
7000:telnet:0:/dev/ttyAMA0:115200 8DATABITS NONE 1STOPBIT
```

Then `service ser2net restart`

From now on, you'll be able to telnet to port 7000 on the PI, and be connected to the COM port. This can stay running even along side Laserweb or other programs - as long as they only open the serial port on demand, and you only use one at a time, they won't interfere with each other.

### Windows Side ###

Now we have to make a telnet connection look like a serial port.  Thankfully, someone already wrote software to do that!

Download and extract [com2com](https://github.com/Raggles/com0com/releases), open a command prompt as administrator, and run `setupc.exe` from the folder you extracted it to. In it's command line, type:

```
install 0 PortName=COM7 -
quit
```

This creates a virtual serial port COM7 on your computer.  That step only has to be done once.

From now on, when you want to connect that virtual serial port to the PI, you need to run
```
com2tcp.exe --telnet --baud 115200 \\.\CNCB0 ip.address.of.pi 7000
```

Leave that window open while using the machine.  Now your program can connect to COM7 of your windows PC, and the commands will go over the network, through the PI, and to the GRBL controller. As far as the software is concerned, it's connected directly to the controller.