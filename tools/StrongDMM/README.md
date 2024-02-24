# StrongDMM

### LICENSE
The contents of this folder are licensed under the GNU General Public License version 3, which can be found in full in ~/LICENSE-GPL3.txt.

The source code can be found at https://github.com/SpaiR/StrongDMM

### Overview
[SpaiR/StrongDMM](https://github.com/SpaiR/StrongDMM) is a 3rd-party program licensed under GPL-v3 that loads in the object tree from a .dme file, and provides an interface very similar to DreamMaker's own mapping interface with which to make and edit .dmm map files. Generally speaking, it loads faster than DM, has several useful features and a cleaner interface, but requires compilation from a separate program (With some care required to ensure that changes are properly copied over). Executables for both Windows and Linux are provided, differentiated by the windows executable being suffixed with `.exe`. There are also instructions on StrongDMM's github page (Linked above) on how to build it from the source code (Not provided)

### Setup
Navigate to `/tools/StrongDMM` and run the launcher appropriate for your operating system. If you're on windows, it ends in `.exe`. If you're on linux, it has no suffix. Because going into those folders is considered tedious by ~~lazy coders~~ basically everyone, it's recommended to set up a shortcut in the root directory. The launcher will automatically update to the latest build and then open the editor. You should see something like this:

![.png](https://puu.sh/H75QH/28c4a5917c.png)

It's important to note the format of the map files you intend to be working with. Byond's native format is very compact, both by organization and actual storage, where single tile definitions and rows of map tiles are each one line, and tile definitions are re-used where possible. This tends to make map diffs much larger and merge conflicts more tedious to deal with. /tg/ has designed their own format, `TGM`, which spreads out tile and map-row definitions across multiple lines, making the file much more human-readable. It also uses a unique definition for each map tile, which increases the size of the map files by a fair margin. DreamMaker doesn't really care what format it loads in, but it only knows how to save to the native format. StrongDMM has a preference to save maps according to either format, and this can be set by going to `File`->`Preferences`, and selecting the appropriate format, as shown:

![.png](https://puu.sh/H75Uj/8b666b11b0.png)

You can also change the other settings as you see fit, but the map save format and nudge mode are most important. Unless you know what you're doing, you probably don't want to change nudge mode, as `step_x/step_y` breaks the commonly-used glide movement animations. Ticking the `Alternate Scrolling Behaviour` will allow you to zoom while holding Space, and scrolling otherwise pans like DreamMaker. With the option unticked, scrolling will only affect zoom. The middle mouse button can always be used to pan, in either case.


### Loading a map
If this is the first time you're using StrongDMM, the panel on the left will be blank except for the `Open Environment...` button at the top. You'll want to click that (Or go `File`->`Open Environment`, or open one directly from `Recent Environments`) and then navigate to the `.dme` file for the project you're working on. StrongDMM needs this to load in the object tree so it can understand the map files that you try to load. It's generally a good idea to make sure that the map files you want to load successfully compile, which generally means making sure the right files for their map-specific objects and areas are ticked when you compile. Once you've loaded an environment, the panel on the left should show the object tree, which looks very similar to DreamMaker's UI, but is notably not a blinding white.

![.png](https://puu.sh/H75YM/dc455a1b42.png)

Next is to load a map. Go to `File`->`Open Available Map...` (Ctrl+Shift+o) and it'll show all map files that exist within the environment you've loaded. Note that some, or even many, of them may not load correctly because you didn't compile all their necessary objects. You can also use `File`->`Open Map` (Ctrl+o) to navigate to the desired map files yourself. Once you click `Open`, it'll take (up to) a couple of seconds to load the map file into the program, and your screen should show whatever's in the bottom-left corner of the map:

![.png](https://puu.sh/H762D/90894c7e49.png)

If the map cannot load correctly because objects aren't defined in the environment tree, you'll see a UI that looks pretty similar to DreamMaker's "Hey this doesn't exist" UI, but again, isn't bright white, and also lets you set variables on the replacements.

![.png](https://puu.sh/H763d/c609eaff27.png)

### Mapping
Once a map is loaded, you're pretty much free to start mapping, just as you would in DreamMaker. You can use Ctrl+[1, 2, 3, 4] to toggle the various layers or do so manually from the `Options` menu, which notably _doesn't_ require ticking any extra boxes. By default, in the bottom right of the screen will be one or two small UI elements. The bottommost one will show the map coordinates of the cursor, and the top one, if present, will allow you to move between Z-levels on maps with multiple Z levels (But not when multiple map _files_ are stitched together into multi-Z).

![.png](https://puu.sh/H7685/da1121bfef.png)

Shift+Right Click will open up the Edit-Variables interface for whatever you clicked on, which can be tricky to do for small things or things on very cluttered tiles, but you can also right click on the tile, and navigate to the appropriate object and click `Edit`. Note that while the Edit-Variables interface is open, you cannot pan or edit the map, the interface consumes all input. This interface also has a filter, so you can quickly and easily find the variable that you're trying to set!

![.png](https://puu.sh/H76aI/0726f5ebc4.png)

The only other really important thing to note is that all these panels can be moved about the whole window, so if you find something is in the way, you're totally free to move it. And again, remember to save (Ctrl+S) and compile your changes before you start your test server and wonder where in the hells all your changes went.