---
title: Using Fusion 360 with MPCNC
category: CNC
---

Now that I have a way to connect directly to the machine from the PC, I have a lot more options for software.  Lightburn is doing everything I need with the laser, but for milling I need something else.

The best something else I've found so far is Fusion 360 + Universal GCODE Sender, though it does take awhile to learn everything.

## Custom Postprocessor

I created a custom postprocessor to generate my gcode.  It has a few advantages over the stock GRBL one:

- It doesn't try to do tool changes, since the machine doesn't support them
- The stock postprocessor moves it's X and Y into position, then moves Z up.  It assumes Z is already at a safe height.  But that's not always the case on my machine, and if I forgot to raise it, it would drag the endmill through the work at full speed.  Mine raises it 15mm above the stock surface first.  If you have clamps or anything that are higher than that, edit the postprocessor on line 221 to change the height.
- At the end, stock moves the machine to home, potentially cutting through the workpiece.  Mine just raises the spindle and turns off.
- Stock left the spindle running, mine turns it off when done.
- My postprocessor starts by raising Z, turning the spindle on, then **holding the machine**.  This lets me verify the tool is actually turned on and plugged in, and lets me get into position to watch it before proceeding.  I can then start the job by pressing resume on the control panel I made for the machine.

So far it's been working very well for me.

Just download [mpcnc.cps](/files/cnc/mpcnc.cps) and copy it to C:\Users\username\AppData\Roaming\Autodesk\Fusion 360 CAM\Posts

## Milling Settings with Fusion 360

I'm not going to give a complete tutorial here - some things are self explainatory, for everything else there's a million tutorials already.  I'm just going to cover some of the settings that work well on my specific machine.

### Creating round holes

I had a tough time getting perfect 8mm diameter 4mm deep holes for inserting magnets into.  I want them ever so slightly more than 8mm so that there is a nice press fit with the magnets.

The settings I finally settled on, using an 1/8" 2 flute endmill were:

* 2D Circular
* Feed rate 100mm/min (this might be to slow, sometimes get a bit of burning)
* Lead rate 600/min
* Ramp/Plunge rage 1000/min
* Retract height 1mm from stock top (this saves time over it going a full centimeter above on every pass)
* Repeat passes (spring pass, helps make sure it removed any material deflection made it not remove on the first pass)
* Conventional milling
* Multiple depths - 2mm per pass
* Stock to leave 0
* Lead to centre ON (this ensures it removes the center of the hole too)

Works well in red oak.

### Creating large slots

For my dice vault I wanted slots that are about 12mm deep, about 125mm long and 25mm wide.

The best way I've found to do that and get clean good looking side walls that don't require much sanding is to do two operations.  The first is 2D adaptive clearing, the second is 2D contour

For the adaptive clearing:
- Cutting, leadout, ramp and plunge feedrates:  600-850 (850 is pushing it, there's noticable bending and tilting when it's cutting)
- lead in feedrate: about 100mm/min lower than the rest
- Optimal load: 1.27mm
- Both ways: Enabled
- Optimal load other way: 1.27mm
- Other way feedrate: 100mm/min lower than cutting
- Use slot clearing: Disabled
- Direction: Conventional
- Multiple depths: Enabled, 6mm
- Stock to leave: 0.6mm radial, 0 axial
- Entry position:  close to one corner of the slot

For the contour:
- Cutting feedrate 600mm/min, rest 500mm/min
- Sideways compensation: conventional
- Finish feedrate: 600mm/min
- Repeat finishing pass enabled