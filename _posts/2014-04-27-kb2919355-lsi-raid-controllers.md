---
title: KB2919355 and LSI Raid Controllers (Dell H200)
category: IT
---

I ran into an interesting problem last week.

I have 3 Dell R715 servers setup as a Server 2012R2 Hyper-V cluster.  I did my normal maintenance of pausing a node and installing windows updates.  One of those updates was KB2919355 - the massive Update 1, that should have been a service pack but isn't for political reasons.  Oh, and if you don't install this update, you won't be getting any more updates starting in May.

After installing [KB2919355](http://support.microsoft.com/kb/2919355), I rebooted again, and got a BSOD - `INACCESSIBLE_BOOT_VOLUME`.

Uh oh.

I messed around with recovery mode, googled for other people having this problem, etc.  Didn't turn up any solutions.  What I did find was some people with LSI RAID cards on SuperMicro machines having the same issue.  I posted on ServerFault to see if anyone had the same problem or knew of a fix.  Nobody did.

Two of the servers have H200 raid controllers.  The third was for some reason ordered with an H700.  Both of the servers with H200 controllers have this issue.  The one with the H700 took the update without any issues.  Time to open a support case with Dell.  I rarely have to use our support contracts, but they are nice to have for times like this - it's pretty clear this isn't something I'm going to be able to fix on my own.  It's either a driver or firmware issue.

Since the server was dead anyways, I tried to reproduce it to see if it was a conflict with something else I had installed.  But reproducing it is simple.
* Install Server 2012R2
* Install windows updates.  Keep installing them until it offers KB2919355
* After installing the update, the server will boot properly.  Everything seems fine.
* Reboot again, and you get a BSOD on every boot.
Thankfully, the 3rd server had just been installed so we would have room for more VMs.  We haven't actually done that yet, so the cluster can still run on a single machine, though without any redundancy.

Dell support has been very helpful.  But they tell me they built an identical machine in their lab and still can't reproduce the issue.  I can't imagine why - I can trivially reproduce it on both of my machines.

In any case, Dell is exchanging one of the systems and taking it back for testing.  Hopefully they are able to reproduce the problem this time and find a solution.  In the mean time, I have to live without windows updates on these servers.

If you have a Dell server with an H200 raid controller, I'd highly recommend waiting until Dell has this fixed before installing KB2919355.  It may not affect all servers, but the ones it does affect it kills.
