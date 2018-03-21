---
title: Network Monitoring
category: IT
---

I have spent the last 2 years or so using Zabbix for monitoring the servers I'm responsible for.  Overall it works pretty well, but lately I've run into some shortcomings that made me investigate alternative solutions.

Particularly, Zabbix stores it's data in MySQL.  The performance data and history keeps growing, until the tables have millions of rows and starts slowing down the web interface to the point that it takes several minutes to load some pages.  It's supposed to have housekeeping processes that clean up old data, but they often don't work properly.  Even after scaling back the frequency of checks and how long they are kept for, I still run into this problem every few months and have to wipe all my historical data.  I could throw more hardware at the problem, but between that and some other limitations (SNMP traps are hard to setup, flapping detection is hard, etc.) I wanted to see what else was out there.

It's been awhile since I've looked at Nagios or any Nagios based solutions.  Open Monitoring Distribution seems like it may work well for me.  It installs on Ubuntu in just a few minutes, and comes with Nagios plus a bunch of addons and plugins that make it easier to configure, faster, and eliminate a lot of the shortcomings of the old Nagios setups I used to work with.  So I intend to set it up along side my existing Zabbix install and see how well it does.

I already have a lot of time and effort invested in Zabbix.  So switching to something that works just as well isn't going to happen.  If I switch, it will be because the new setup works better and offers features Zabbix doesn't provide.

There are quite a few criteria I've decided upon for evaluating a new monitoring system:

## Ease of Configuration
How hard is it to get the software setup to start with?  A monitoring system has to be customized to the environment it's monitoring.  Once everything is running, how hard is it to add new hosts and start monitoring them?  Are there templates or other tools that help deciding what to monitor on each host?

How much can be done from a web interface, and what needs to be done from the command line or editing config files?  I'm comfortable with both, but some of my peers would rather have a GUI.

## Monitoring Custom Services and Data
I have a lot of hardware and software that often doesn't come with monitoring templates.  One key feature is how easy it is to write scripts to monitor things that don't come included in a typical monitoring solution.  We have a few appliance type devices that don't give the stats I want over SNMP, so require using a web service or other tricks to get at the data.  I also want detailed statistics on the spam filters on my Exchange server, which can only be accessed through powershell.

## Windows and Linux Support
I prefer to use the best tool for each job.  As such, we have a mixture of Windows and Linux servers.  A good monitoring system needs to be able to easily monitor both, with custom scripts written in Powershell or VBS for windows.

Particularly, I don't want to have to install PHP, Python, or other software on every Windows server.  I want a native self contained agent.  For custom monitoring, I want to be able to write my checks in whatever programming or scripting language is most convenient for that device, from that operating system.

## Good Support for SNMP
Every decent monitoring system supports SNMP.  But few do it well.  Thanks mostly to copyright issues, MIBs are a nightmare no matter what system you use.  But if I have all the MIBs and know what data I want to monitor, I expect it to be easy to setup.

SNMP Traps are a whole separate mess.  The biggest problem is that devices will send a trap when they have a problem, but not send anything when they recover.  So it's difficult to tell if the problem still exists.  It also takes a lot of trial and error to determine which traps you actually care about, and which are considered normal.  I don't expect setting up traps to be very easy, but I do need them to work well once they are setup.

## Graphs and Data Storage
I want pretty graphs.  My boss wants pretty graphs.  My boss's boss wants pretty graphs.  I expect graphs to be easy to setup, quick to load, and customizable to show what I need them to.

Storing the data in something like RRD graphs is preferable - they automatically average out older data so the database never actually grows, you just get fewer individual data points for older data.  It might keep data for every minute for the first few weeks, then average them out to every 5 minutes for a month, then every hours for a year.  This also makes displaying graphs for long time spans much faster.  Systems that keep check every minute would have over half a million data points for a 1 year graph if you don't do any averaging.

## Good Notifications - Tell Me What's Really Wrong
Another limitation I've run into is dumb notifications.  I have several separate physical sites to monitor.  If the internet goes down at one of them, I'll receive notifications that every service on every server at that site is down.  When that happens, it's easy to guess that it's the internet that's really down, but it does cause my phone to ring non stop.  The ability to tell the monitoring system "If firewall A goes down, you won't be able to reach X, Y and Z." helps prevent that.

Likewise, if something sits at the threshold of it's alerting value, I get sent dozens of alerts.  "It's ok." "It's broken." "It's ok again." "It's broken again." over and over.  It should be easy to setup flapping detection or separate thresholds for problem and recovery to avoid that.

I also need intelligent selection of notification methods.  For example, if the mail server is down, sending me an email probably isn't the best way to inform me of that.  Instead, send me a text message using my phone provider's email gateway.  I also want to feed the notifications into our ticketing system, so we have a single place to see all issues.  With Zabbix, I have some custom scripts for the ticketing system that closes the ticket when it receives a recovery notification.  I want to keep doing that.

Business impact also falls into this category.  I would like to define certain services, like Email, Website, Sharepoint, etc. and tell the monitoring system "If checks X, Y or Z fail, Email is down.  If checks A, B or C fail, Email is up but will be running slow."  This makes it easier for me and my boss to see what end user services are affected, and help prioritize what gets fixed.  In the end, I already know all this information, but it saves a conversation explaining why something isn't working and what is affected - that's time that could be better spent fixing the problem.

## API For Getting Data Out of the System
Email alerts are great.  Irritating, but great.  But sometimes there are minor problems I don't want alerts about - software updates waiting, short bursts of high CPU, or temporarily high disk usage.  I want events like that monitored and recorded so I find out of about them, but I don't need to be actively interrupted for them.  To help with that, I built a heads up display that sits over my desk.  It's a TV connected to a raspberry pi, that flips through screens showing graphs and alerts all day.

One thing I like about Zabbix is that it has an API for getting alerts and graphs.  It's not a very good API for some things, but it works.  If I switch monitoring systems, the new one needs to make it easy for me to get data out of it and onto the screen.

## Open Source
It's not that I don't want to pay for things.  If there were a paid solution that did everything I want easily, I'd get a cheque cut today.  But it's rare that any software does exactly what you want, how you want it.  The amount of money you spend is rarely a good indicator of how good of a job it will do.

The brilliant thing about open source software is that I can change it.  I've had to make a few minor changes to Zabbix to work with my display system and to monitor everything I want it to.  With open source I can do that.  I generally see it as a last resort - if I make a bunch of custom changes, I have to maintain those changes every time a new version is released.  But sometimes it's the only way to get the job done.  If they are changes that would benefit others, I can even eventually get them included in future releases.  Other people do the same, and contribute changes that are useful to me, and everyone ends up having to do less work to get things going.

## Conclusion
I will be testing OMD to see how well it fits these criteria.  Out of all the monitoring systems I've taken a look at, it looks like it will come closest to covering all my criteria.  I'll have to make another post with how well it does.
