---
title: KB2919355 and LSI Raid Controllers Part 2
category: IT
---

Microsoft has finally released a [knowledge base article about this issue](http://support.microsoft.com/kb/2967012)

The problem affects a lot of LSI based cards, including the Dell H200 my servers have, as well as some from HP, IBM and Supermicro.

Unfortunately, while there is a temporary workaround, there is no fix yet.  They did however figure out what is causing it:

> This problem occurs if the storage controller receives a memory allocation that starts on a 4 gigabyte (GB) boundary. In this situation, the storage driver does not load. Therefore, the system does not detect the boot disk and returns the Stop error message that is mentioned in the "Symptoms" section.

> Note This problem may not always occur in this situation. The problem is affected by the computer’s startup process, the driver load sequence, and the memory allocation of the storage controller driver at startup.
 Microsoft's workaround is to limit the system to 4GB of RAM long enough to remove the update.

This is actually an interesting bug.  4GB is the limit for 32 bit memory addresses.  But this is a 64 bit OS.  Those limits should be well behind us.  The driver itself didn't change with KB2919355, so something else in the update triggers this bug.

I'm quite curious to see what they changed that caused this issue, and why the Server 2008 drivers aren't affected by it.  Hopefully Microsoft will be releasing a fix soon.

On the upside, they seem to have [extended the cutoff for future updates to June 10th](http://blogs.windows.com/windows/b/windowsexperience/archive/2014/05/12/windows-8-1-update-requirement-extended.aspx).  That post doesn't say if it applies to Server 2012R2, or just Windows 8.1.  I'm hoping it applies to both.  People who use WSUS to update their systems have until August before KB2919355 becomes required to receive further updates.  Unfortunately, I am working on rolling out WSUS, but it ready quite yet.

For now all I can do is sit back and hope Microsoft, Dell and/or LSI come out with a fix soon.
