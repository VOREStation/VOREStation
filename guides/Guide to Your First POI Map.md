Welcome!

This guide **ASSUMES** you have gone through the Guide to Opening your First PR. If you have NOT done so yet, please refer here, and ask in Discord's #ss13-development channel (For CHOMPStation), #dev-general (for VOREStation), or #code (for Polaris) if you have any questions, or need assistance with completing these steps. 

You can also @ maintainers or staff devs, which can be viewed in the sidebar of each codebase’s Discord, and will usually have roles such as “Maintainer” (For VOREStation), “StaffDev/StaffMaintainer” (for CHOMPStation), and “Maintainer” (for Polaris).

[CHOMPStation]([https://github.com/CHOMPStation2/CHOMPStation2/blob/master/guides/Guide%20to%20Opening%20Your%20First%20PR.md](https://github.com/CHOMPStation2/CHOMPStation2/blob/master/guides/Guide%20to%20Opening%20Your%20First%20PR.md))

[VOREStation]([https://github.com/VOREStation/VOREStation/blob/master/guides/Guide%20to%20Opening%20Your%20First%20PR.md](https://github.com/VOREStation/VOREStation/blob/master/guides/Guide%20to%20Opening%20Your%20First%20PR.md))

[Polaris - TBD]

You will also WANT VSCode to edit the files, but this is not required, as DM can also do so. See Guide to VSCode/Editor Setup, or check the wiki pages on how to contribute to learn more. (These are currently TBD but will be done soon:™:)

Before proceeding, remember to make your branch! We should have a new branch titled “x-dev-POI”, or whatever you want to name it. We’ll assume it’s named “shep-dev-POI” for this tutorial’s context.

With that out of the way, congrats on getting setup! Let’s dive into how to make your first POI. \
 \
To start, we need to open up the repo you downloaded earlier. If you’re not sure where that is, Gitkraken should be able to tell you by hovering over the codebase name, in the top left, and hitting **Alt+O** will open the file manager. \
Either way, we should see [this]([https://i.imgur.com/FOUVK4n.png](https://i.imgur.com/FOUVK4n.png)) - Image references CHOMPStation, but the general folders should be the same for Polaris + VOREStation.

Before we can map, we need to setup several code prerequisites in order to actually have a new area for our map. In order to do so, we are going to locate the POI folder. We are going to add a POI to the Wilderness area for our tutorial.

Follow this reference: \
Go to /maps/, and then find the folder the POIs for the given map are saved. This is code-base specific, so Polaris + CHOMP use /maps/submaps/surface_submaps/ for theirs, and then each folder (mountains, wilderness, plains) is a different area. If you’re on Southern Cross, Plains is the area around the outpost, Mountains is the mines, and Wilderness is the deep wilds. Polaris, TBD. 

VORE has their submaps for SPECIFIC areas defined in /mapused (IE Tether)/submaps. This sub-main folder should only be used for map-specific POIs, for example, POIs that would only exist if Tether was loaded.

Otherwise, refer to /submaps/ and locate the folder in question. If you’re not sure, poke around, or ask in the channel for the codebase you’re currently working on for help.

Once we’ve gotten to the folder in question, scroll down until you see, for this reference, wilderness.dm, and wilderness_areas.dm.

Double click to open wilderness_areas.dm. Follow the subheadings depending on the tool you’re using.

VSCode: If you’ve already installed VSCode and told it to associate with .dm files as per the tutorial, it’ll open here and error. We need to open the main folder, by going to File, Open Folder, and then navigate to our base repository. This is where all the folders like maps, guides, etc are.

Hit Select Folder. We’ll open to a blank screen. Hit Ctrl + P to open a specific file, and type in wilderness_areas, and select wilderness_areas.dm. From here, refer to the joint section below.

DreamMaker: This should have opened with our filetree, as screenshotted. [https://i.imgur.com/m8FjRAs.png](https://i.imgur.com/m8FjRAs.png) If it did not, navigate to File, Open Environment, and select vorestation.dme. Then, navigate to maps, submaps, surface submaps, wilderness, and open wilderness_areas.dm.

Joint (This assumes we’ve located the file as per instructions above. If you’re not using Dream Maker or VSCode, you’re expected to understand how to open the file yourself.) This section will be done in VSCode, but later iterations will screenshot the process in Dream Maker (it’s basically identical, just waiting on the wiki page to bother doing so.)

Go ahead and look over the areas. We’ll notice something, even if you don’t quite know how to read code: each new area only has name + ambience changed, likely, right?

Image here [https://i.imgur.com/A2pMluj.png](https://i.imgur.com/A2pMluj.png)

Without getting too deep into code, BYOND uses OOP, which in layman’s terms, means every single new object created with the same path as another will inherit things. This saves us having to redefine it every time we make a new one.

For YOU this means all we’re going to do is highlight an area subsection (I’ll be using Black-Op Shuttle’s area for this) [https://i.imgur.com/zCUu0R3.png](https://i.imgur.com/zCUu0R3.png), hit copy, and then scroll down to the bottom, hit enter once to generate a new line, and hit paste. You should see this, if in VSCode: [https://i.imgur.com/AtQvNV6.png](https://i.imgur.com/AtQvNV6.png)

Now we’re going to change “Blackshuttledown” to “myfirstPOI”. Change it to whatever you like, but I’m simply using a tutorial name here. Then, at the “name = “POI - blahblah”, we’re going to change it to “POI - Newbie”. Leave everything else alone for now unless you want a special ambience, though you can easily just replace AMBIENCE_HIGHSEC with AMBIENCE_OTHERWORLDLY.

Once we’ve done that, our new area should look like this: [https://i.imgur.com/ttVNbYq.png](https://i.imgur.com/ttVNbYq.png)

With that, we save, and exit the code. We’ll come back to it at a later step to ADD our POI to the actual map template section, but for now, we need to MAKE the POI first, no?

For this next step, return to the BASE folder, where the .dme and maps/etc folders are.

 \
We’re going to navigate to *tools* and then StrongDMM. This is not REQUIRED, but is heavily recommended - maintainers will ask you to run mapmerge where possible if you use DreamMaker. The rest of this guide WILL ASSUME YOU ARE USING STRONGDMM. The wiki will offer sections for DreamMaker as well as StrongDMM. \
 \
Run sdmmlauncher.exe. Screenshot here: \
[https://i.imgur.com/VxvRntf.png](https://i.imgur.com/VxvRntf.png)

You should be greeted with this: [https://i.imgur.com/9dhRcz3.png](https://i.imgur.com/9dhRcz3.png)

We are going to do something first before opening any environments. Go to File, Preferences in the top left. Then, in Interface Options, select a style you like. Rykka (hi, the author of this) uses Dark Coast. Use whatever you like.

Under Save Options, **change this to TGM.** Check Sanitize Variables. Also check Clean Unused Keys, if this is not already checked. Nudge mode should be pixel_x/pixel_y.

With that done, hit Open Environment, and navigate to the folder we downloaded in the earlier step. Open vorestation.dme, for VORE + CHOMP, or Polaris.dme for Polaris.

The file will load, and then you’ll still be at a blank screen, but now the Environment Tree should have 4 directories under it. \
This is what it looks like. [https://i.imgur.com/RtURzx8.png](https://i.imgur.com/RtURzx8.png)

You should also be able to see the name in the top left.

Now, we are going to go to File, New Map. \
This will open a dialogue box with the base folder of our repo. Don’t panic. \
Go to /maps/, and then find the folder the POIs for the given map are saved. This is code-base specific, so Polaris + CHOMP use /maps/submaps/surface_submaps/ for theirs, and then each folder (mountains, wilderness, plains) is a different area. If you’re on Southern Cross, Plains is the area around the outpost, Mountains is the mines, and Wilderness is the deep wilds. Polaris, TBD. 

VORE has their submaps for SPECIFIC areas defined in /mapused (IE Tether)/submaps. This sub-main folder should only be used for map-specific POIs, for example, POIs that would only exist if Tether was loaded.

Otherwise, refer to /submaps/ and locate the folder in question. If you’re not sure, poke around, or ask in the channel for the codebase you’re currently working on for help.

Once we’ve located the folder, we’ll assume we’re doing Wilderness for this one - we’ll be in this folder, and we’ll type the name of our new map and hit Save. Image here: [https://i.imgur.com/CCIuuwy.png](https://i.imgur.com/CCIuuwy.png)

Now, it is going to bring up a dialogue box on map size. ALWAYS leave the Z at 1. \
Set the X + Y to whatever you prefer, this will be the SIZE of our POI. For example, six tiles across would be 6 X, and 5 tiles tall would be 5 Y. The layout referenced in the tutorial is here: [https://i.imgur.com/T2jQwZB.png](https://i.imgur.com/T2jQwZB.png)

Hit Ok. \
 \
Your new map will load in the bottom-left corner, depending on SDMM. Scroll in using your mouse, and hold the middle mouse button (or whatever the hotkey is if SDMM ever changes) to pan.

Once we’ve navigated and zoomed so our POI is relatively sized, we should see this: [https://i.imgur.com/e8VhPxk.png](https://i.imgur.com/e8VhPxk.png) 

Hit Save (Ctrl + S) now! Just in case.

In the top left, where it says “Types Filter”, type the name of our new area. This will be “myfirstPOI”. Click to select. You should see this. [https://i.imgur.com/mG458sl.png](https://i.imgur.com/mG458sl.png)

Go to the map editor, and drag it over the interior tiles. Then, go back to types filter (where we typed in prior), clear it, and find template. We’ll see two things come up, /turf/template_noop, and /area/template_noop. Do turf template around the outside of our new area, and then do area template around the outside of our new area. \
 \
We should see this: \
[https://i.imgur.com/z722p97.png](https://i.imgur.com/z722p97.png)

Now go to Options, and hit “Toggle Area”. This will turn off the area display. Clear the types filter select, and hit the big - button next to it to collapse all trees again so we just have 4, these being (area/turf/obj/mob), our base BYOND types.

Go to turf, then simulated, then floor, then outdoors, then dirt. Drag it over the center tiles, so now there should only be dirt + passthrough. (the template turf is also called passthrough in coder parlance). Obviously, we can add more turfs and get more complex if you like, but you’ll need to worry about atmos composition and etc. We’re not going to stress about that for now, as we can learn about all that later.

For now, collapse all trees again, and then go to “mob”, then living, then simple_mob (do not use simple_animal, it is deprecated), then select a mob from any of these subtrees. For our example, we’re going to go to animal, wolf, direwolf, and choose a regular direwolf (or Rykka, if you’re on a VORE downstream).

Place it anywhere on the dirt or passthrough tiles, and hit save. I recommend NOT placing on the passthrough tiles, as they may suddenly spawn inside solid rock.

Make sure to save. We’ve accomplished adding a rudimentary, if not-super-featured POI.

This is what it should look like before we close the editor. [https://i.imgur.com/MU1YuKs.png](https://i.imgur.com/MU1YuKs.png)

Now, we’re going to go back to our editor of choice. Refer above for instructions on how to open the codebase on each editor, but we’re going to, instead of opening wilderness_areas, open wilderness.dm.

This will bring you to a bunch of new stuff. You’re going to see an #if and etc.

DON’T PANIC.

All we’re going to do is scroll down the list, and find where our POI would slot in alphabetically. For instance, ours, via this tutorial, is myfirstPOI.dmm. We’re going to insert this after musk.dmm.

Click at the end of #include “musk.dmm” and hit enter once, then type #include “myfirstPOI.dmm”. Name will vary, of course, depending on your POI, but for this tutorial, that’s the name we used.

You should see this if the step was completed successfully. [https://i.imgur.com/c686Ji4.png](https://i.imgur.com/c686Ji4.png)

Now, we’re going to scroll down. Remember earlier how it was explained that you only need to change the variables that DO change on your new map?

Copy line 76, or this area snippet: `/datum/map_template/surface/wilderness/deep/BSD`

At the end of the file, hit paste after inserting a new line underneath the last entry, so there’s always a line of space between the end of one thing and the next.

Then, as with adding the area, change the “BSD” to your name, then “name = “blah”” to whatever your name is.

Change the name of the .dmm in mappath to match your .dmm, and change the cost down to 5 (this is a very tiny POI). Remove the template_group, as we don’t use it presently.

It should look like this afterwards:

[https://i.imgur.com/HguoHxT.png](https://i.imgur.com/HguoHxT.png)

And we’ve added it! Woo!

Before you go “man that was way too much work fuck this” we still need to PR it. \
Open your git client of choice - if you’ve been following the guide up to this point, we’ll reference Gitkraken.

As explained in the Guide to Opening your First PR, you’ll need to Stage + Commit these files. If you’ve followed instructions and still need help, contact maintainers or ask for help in the development channels.

Commit, and then again, as per prior, we are going to start a pull request. At this point, you should be done!

As with the other guides, if you run into issues, please let maintainers know and we’ll help you out. DON’T FEEL BAD FOR BEING NEW AND GOING “AAA”. \
 \
We all started somewhere. I hope this guide helps give you the confidence you need to contribute to this codebase and help keep our project going. Thank you for your time and effort. <3