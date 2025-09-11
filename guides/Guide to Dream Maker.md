Guide to the Dream Maker
To begin: We’ll need to open Dream Maker, of course. Locate the dreammaker.exe in your BYOND/bin file and run that (or launch it from Start, however you prefer.)

You’ll be greeted with this:
https://i.imgur.com/aJXB9sN.png

We’re going to go to File, Open Environment, like so:
https://i.imgur.com/F8K8Nmz.png

You’ll then locate your VOREStation folder, and the .dme inside. Shown is mine:
https://i.imgur.com/tvTDBWp.png

Choose “Open”
You will be greeted with:
https://i.imgur.com/oAbOjwR.png

If you’d prefer to skip right to codestuff/the wiki, this is a good start. Otherwise, continue below:
https://wiki.vore-station.net/Basics_of_Coding_in_BYOND

MAPPERS:
If you are looking to MAP, the first thing we need to do is go to the top of the screen, choose “Build”, and Compile.

Tether is located in /maps/tether/, and each level of the station is Tether 01-07. 08 is the Mining Outpost and 09 is Toxins/Xenoarch and Solars.
Submaps are in the /submaps/ folder, and, for instance, if you are looking to add new submaps to the Underdark, you’ll expand underdark_pois and create a new .dmm in the folder by clicking on it, and then going to New. Example here:
https://i.imgur.com/Q1Cqfll.png

If you are adding a submap, ensure you add it to \_templates.dm, a small snippet is here:
https://i.imgur.com/Ek9jaCe.png

Cost is how much the POI system has to spend to spawn that .dmm, and name/mappath are self-explanatory.

Regarding new submaps, refer to Guide to Map Folders.md!

If you have questions, ask in Discord in #dev-general! <3

SPRITERS:
If you are looking to edit icons, skip that, and just go to “icons” (expand it by hitting the +), and then find the icon file you’re looking for. Most people go to adding new drinks + foods for their first foray into DM, so:
If you want to add a new drink, VOREStation-specific drinks are in icons/obj/drinks_vr.dmi, and VOREStation-specific food is icons/obj/food_vr.dmi.

If you have questions, ask in Discord in #dev-general! <3

CODERS:
Refer to the pins in #dev-general for Visual Studio Code, but you can still code in Dream Maker (Although it’s not a very good interface for it, and it’s WHY Visual Studio Code is recommended).

Coding is fairly self-explanatory, find the things you want to change and change it. There’s no robust tutorial to coding, but we have a coding tutorial of sorts and explanation on our wiki:
https://wiki.vore-station.net/Basics_of_Coding_in_BYOND

As with spriters/mappers, if you have questions, ask in Discord in #dev-general! <3
