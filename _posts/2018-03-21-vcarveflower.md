---
title: Project: VCarve flower
category: CNC
---
I've been wanting to try out relief carving on my CNC machine for awhile now, but hadn't found a decent set of tools to do it.

[Vectric VCarve](http://www.vectric.com/products/vcarve.htm) looks awesome, but it's pricy!  The desktop version (which would be fine for my needs) is USD$349.  That's more than my CNC machine cost to build. Luckily, there are some smart people who made, perhaps less pretty, but fully functional software to do the task.

[Scorch Works dmap2gcode](http://www.scorchworks.com/Dmap2gcode/dmap2gcode.html) is a GPL program that takes a [depth map](https://en.wikipedia.org/wiki/Depth_map) and creates the gcode to send to the machine.

## Source Image

{% include image.html url="vcarveflower/source.jpg" description="Depth map image" %}

I found this image searching google images for "depth map".  There are plenty of images available.  There are also tutorials out there for taking a 3D object like an STL file and converting it to a depth map, though I haven't tried that yet.

## Machine setup

I hooked up the DW660 cut out tool and used this [Milescraft V Groove Router Bit](https://www.amazon.ca/gp/product/B002YD7ZJK/).  The specs don't list the exact angle, but it's somewhere around 60 degrees, so that's what I used.

I then screwed a scrap piece of about 3/4 inch thick wood, I think pine, to the spoil board.  I drilled and countersunk the screw holes to ensure the bit wouldn't hit them if it passed over that section while homing.

## dmap2gcode settings

I changed the settings for Gcode Header to `$32=0|G90|M04 S1000` and Postscript to `M05` to match what I normally use on the machine. Also disabled G-code arcs and made sure comments are suppressed (the software I use to send the gcode does not like the comments).  Also change the units to mm, since that's what all the other software expects.

I used these settings for the image:
* Image height: 100mm
* Depth color: Black
* Tool diameter: 6.35mm
* Tool end: V
* V-Bit Angle: 60
* Scan Pattern R then C
* Feed rate: 600mm/min
* Plunge feed: 180mm/min
* Stepover 0.5mm
* Z Safe: 1mm
* Max depth: -8mm

What I should have done was generate roughing gcode to cut out the bulk of the material in thiner, faster layers.  But I didn't do that.  It would have had 2 advantages:
1. When the cutting first started, it plunged the bit 8mm deep and started cutting at a fairly fast speed.  That burnt the wood and burnt the tool, probably dulling it quite a bit.  I'll have to be careful about that in the future.
2. Would have let me use a much higher feed rate for the final pass.  With the settings I used, this too over 3 hours to cut.

## Running the job

I loaded the gcode into LaserWeb, homed and zero set the machine at the bottom left corner of where I wanted to cut, with Z at the surface of the wood.

Then I raise Z and hit the check outline button to make sure it is fully on the wood.  Then run the job.

## Results

I'm pretty happy with my first attempt at this.  I can see a lot of room for improvement, particularly in making it faster without burning the wood by cutting too deep.  I might also have to adjust the controller's max Z rates, since I think that was limiting the overall speed.
Using a ball tipped bit instead of a V bit would also speed things up, since the stepover wouldn't have to be quite as small.

<div class="gallery">
{% include image.html url="vcarveflower/1.jpg" description="Photo 1"%}
{% include image.html url="vcarveflower/2.jpg" description="Photo 2"%}
{% include image.html url="vcarveflower/3.jpg" description="Photo 3"%}
{% include image.html url="vcarveflower/4.jpg" description="Photo 4"%}
{% include image.html url="vcarveflower/5.jpg" description="Photo 5"%}
{% include image.html url="vcarveflower/6.jpg" description="Photo 6"%}
</div>









