---
title: IBM x3500 SAS Backplane Pinout
category: Hardware
---

![Backplane and cables](/images/backplane.jpg)

I have a few of these from old decomissioned servers.  You can get them fairly cheap on ebay these days.  Even if you don't have the server it belongs do, they could still be useful for DIY storage projects. The IBM FRU is 44E8783. There are likely other similar IBM parts that use the same pinout, but no guarantees.

Unfortunately as far as I can tell, nobody bothered to document the cabling for them!  As luck would have it, I still have a working one, so I was able to map out the power cable with a multimeter.

This is just a regular backplane, not a SAS expander - one SFF-8087 connector for 4 drives.  The data connector is standard, it's just the power cable that is strange.  It looks similar to an ATX 24 pin power connector, but smaller.  If you are buying one to use in a different device, make sure it comes with the power cable - you may not be able to easily find the right connector.

I measured this by removing the cable from the backplane and measuring the voltage on each pin, with the black probe on the metal of the case (ground).  The picture shows how I numbered the pins.

![Backplane power connector](/images/backplane_connector.jpg)

| Pin | Voltage | Pin | Voltage |
| --- | ------- | --- | ------- |
|1|5v|13|5v|
|2|Ground|14|Ground|
|3|5v|15|5v|
|4|Ground|16|Ground|
|5|5v|17|3.3v|
|6|Ground|18|Ground|
|7|5v|19|5v|
|8|5v|20|5v|
|9|Ground|21|Ground|
|10|12v|22|12v|
|11|Ground|23|Ground|
|12|12v|24|12v|
