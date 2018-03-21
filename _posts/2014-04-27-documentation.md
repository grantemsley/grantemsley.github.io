---
title: IT Documentation
category: IT

---

Documentation is one of the most overlooked things in IT.  Maybe it's because writing documentation is boring.  Maybe because you don't have time to write it all down before moving on to put out the next fire.

## Why do I need any documentation?  I know how it all works...

Documentation is important!  Without it, nobody knows what other people on their team have changed.   Nobody knows how things are setup, and more importantly **why** they are setup that way.  Bringing on a new person to the IT staff is much easier if they have a document they can reference, rather than ask about every little detail. 

In a crisis having good documentation of your backup and restore procedures is essential.  You need to restore things quickly, people will be yelling at you, and it becomes very stressful.  Write yourself a nice step by step guide while you test the backups, so when you need to do it for real you just follow the instructions.

From the IT staff's perspective, having good documentation has direct benefits. You can't take a real vacation if you are the only person who knows how parts of the network work.  Those parts will break, and you will get a phone call.  And if you have a terrible memory like me, you'll come across things that are setup strangely - that you setup yourself, several years and many projects ago.  You'll remember there's a reason you did it that way, but not what the reason was.  That information is just lost.

From a business standpoint, having no documentation is terrible.  IT staff can quit, get sick, or even die.  When someone comes in to take over for them, it will take them weeks to figure out where everything is and how everything runs.  I have personally run into situations where the only thing we could do was rebuild a service from scratch, because nobody knew the passwords and they couldn't be reset.

## Ok, I'm sold.  I'll write things down.  Now where to put them?

I have gone through a lot of different systems for keeping documentation.  At one point it was a physical binder in my office.  At another a bunch of text files on my laptop.  Then a Sharepoint site for the IT staff.  All of them had limitations.

The binder never got updated properly.  The text files were hard to navigate, and couldn't easily be shared with the team.  Sharepoint worked ok for awhile.  But what about the notes I need to fix Sharepoint when it breaks...they had to be stored separately, or I wouldn't be able to reach them when I needed them.

## Criteria for a good documentation system
Your needs may be different, but this is what I was looking for to store our documentation:
* Easy to add to and update.  If it's hard or time consuming, nobody will do it.  Documentation is useless if nobody ever updates it.
* Able to link to other parts of the documentation.  Specific information should only be added ones, but referenced from anywhere that it might be relevant.  You don't want to repeat the same information over and over, since you'll have to find every instance of it when it changes.
* Basic formatting and pictures.
* Hosted ourselves.  There are cloud based platforms that do this kind of thing.  But I don't want my data inaccessible if they fail.
* Accessible to and editable by the whole IT staff, without any extra effort to share our changes.
* Accessible from anywhere and from any device - sometimes I need to fix things via remote desktop from my phone.
* Accessible even in the event of a catastrophic network failure.
Those last few points are tricky.  Making it accessible to all the staff from any device is easy - put it on a web server.  But what if the web server dies?  Or I don't have a working internet connection when I really need it?  My solution is to use DokuWiki with Dropbox

## Dokuwiki with Dropbox
DokuWiki is a simple open source PHP based wiki.  It's syntax is relatively easy to read and use.  It can store pictures and other things like saved config files.  It has decent access control to make sure only authorized staff can access it.  It takes care of everything except that last bullet point - accessible in a catastrophic network failure.

There are lots of similar wiki packages, but DokuWiki has one very important distinction for my purposes - **it does not use a database**.  Everything is stored in plain text files in it's data folder.

Dropbox is a great service.  You run a program on each of your computers, and it syncs the files in your Dropbox folder between them.  Your files are also accessible from their website.  It also allows you to share folders with other people, and all the files in that folder will show up in their Dropbox folder on their computer too.  I've been using it for years, and it's dead simple to use.

The best thing about Dropbox is that it keeps a local copy of all your files.  Unlike other cloud storage services, if Dropbox goes down, I still have access to all of my files.  This is important, because it means using Dropbox isn't adding a single point of failure.  If Dropbox stops working, changes start getting synced, but all the existing data is stored on every computer.

Since everything in DokuWiki is a regular text file, no databases, Dropbox can sync it to everyone's computer.  Add in a tiny web server like MicroApache, and you can load it directly from your Dropbox.  DokuWiki On a Stick is a prepackaged version that comes with the web server portion ready to go.  That covers loading it from our work and even personal computers.  Any file someone edits automatically gets synced to everyone else within a few seconds. 

What it doesn't cover is accessing it from mobile devices or computers that don't have Dropbox installed.  That's covered by loading Dropbox onto a webserver running the full Apache, and pointing the DocumentRoot at our shared Dropbox folder.  The biggest trick here is that all the files must be writable by both Dropbox and Apache - either they have to run as the same user, or you have to be in each other's groups, and set their umask to ensure group has write permissions.

Now, in normal operation, I can access the wiki from its web server.  If the web server is unreachable, I can fire it up on my laptop.  If I don't even have my laptop, at the very worst I can read the text files directly with the Dropbox client on my phone - I don't get the pretty formatting, but all the content is there.

I think it works brilliantly.

## What about passwords?
I'm a very security conscientious person.  Storing passwords in plain text in a third party service like Dropbox isn't a great idea.  So we do not record passwords in the wiki.

That's what [KeePass](http://keepass.info) is for.  It stores passwords for all our services, nicely organized and encrypted.  There is a portable version that runs directly from Dropbox, so all the staff have access to it and it is automatically kept up to date.
