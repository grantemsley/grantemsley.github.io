---
title: Engraving Images with Lightburn
category: Laser
---

[Lightburn](https://lightburnsoftware.com/) is a program for controlling laser cutters and engravers.  
The license for GCode based machines is US$40, and it's worth every penny.

It does have a few quirks though, which I've mostly sorted out.

## Lightburn Setup

I'll go over most of the settings that are important:

* Settings:
** Units - mm/min
* Device Settings:
** Width - 558.0mm
** Height - 343.0mm
** Origin: Bottom left
** Enable Z axis on
** Enable laser fire button on
** S-value max - 1000
** Baud Rate - 115200

## Macros

There are two **very** important macros for using lightburn on my machine. Lightburn doesn't like negative coordinates - it works much better if everything starts at the bottom left and goes to positive coordinates from there.
So to accomodate that, we'll use macros to set the coordinate offsets.  One macro turns that on, one turns it off for when we are going back to other programs that expect the machine origin to be in the top right.
This macro also enables laser mode, where GRBL will adjust the laser depending on speed, and turn it off when doing quick moves.

### Set Lightburn Coord System Macro
```
$32 = 1
G54
G10 L2 P1 X-568 Y-350
```

### Reset Coordinate System
```
G54
G10 L2 P1 X0 Y0 Z0
```

Note:  This macro does NOT turn off laser mode. I make sure that any milling gcode I run explicitly turns it off.

### Zero Z Axis

I always set lightburn to engrave at Z=0. To make it work well, I use the move tab, fire the laser at 1% power, and jog up and down until it's roughly focused.  Then I use the knob of the lens to focus it perfectly.
After it's focused, I click the Zero Z axis macro.  If I forget this set, it will return to whatever height the machine started at and probably ruin my workpiece.  So don't forget!

The software already has a Set Origin button for setting up X and Y properly.

```
G92 Z0
```

## Running a Job

I'm not going to cover setting up your artwork to engrave - lightburn has tutorial videos that cover it nicely.  But I will go over my process for running the job.

* Put on laser glasses.
* Turn the machine on with the laser hooked up.
* Make sure the PWM mode switch is set to laser.
* Fix the workpiece to the bed.
* Run com2com as documented in another page here to connect to the serial port of the raspberry pi over ethernet.
* Double check that the job is setup properly - things are in the right layers, speeds are set properly, etc.
* Jog the laser over to the workpiece. Then raise or lower the Z axis to focus it. Click the Zero Z axis macro.
* On the laser tab, pick a job origin. I usually pick center but it depends on what's easiest to align properly on the piece you are engraving.
* Jog the machine to the orign selected. Click Set Origin.
* Hold Ctrl while clicking Frame to make sure it will engrave where you want - holding control makes it turn on the laser at lower power to see the outline.
* Click start



## Engraving Settings

Different woods will need different settings, but I'll record here what settings I use.


| Type of Wood | Speed (mm/min) | Max Power | Mode | Passes | Other Info |
| ------------ | -------------- | --------- | ---- | ------ | ---------- |
| Light woods like maple | 1200 | 60% | Cut | 1 | For engraving line art. Works best if you slightly UNfocus the laser to make slightly wider lines. |
| Walnut | 1000 | 95% | Cut | 1 | Line art. Gives a nice groove you can feel with your fingernail. |





