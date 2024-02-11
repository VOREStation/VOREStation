# VOREStation

[![forthebadge](http://forthebadge.com/images/badges/60-percent-of-the-time-works-every-time.svg)](http://forthebadge.com) [![forthebadge](http://forthebadge.com/images/badges/compatibility-club-penguin.svg)](http://forthebadge.com) [![forthebadge](http://forthebadge.com/images/badges/no-ragrets.svg)](http://forthebadge.com)

[Website](https://vore-station.net) - [Forums](https://forum.vore-station.net/) - [Wiki](https://wiki.vore-station.net/)

Going to make a Pull Request? Make sure you read the [CONTRIBUTING.md](.github/CONTRIBUTING.md) first!

Want to make a test server or your own private server? Read our [GitHub Wiki!](https://github.com/VOREStation/VOREStation/wiki)

VOREStation is a fork of the Polaris code branch, itself a fork of the Baystation12 code branch, for the game Space Station 13.

![Render Nanomaps](https://github.com/VOREStation/VOREStation/workflows/Render%20Nanomaps/badge.svg)

---

### LICENSE
The code for VOREStation is licensed under the [GNU Affero General Public License](http://www.gnu.org/licenses/agpl.html) version 3, which can be found in full in LICENSE-AGPL3.txt.

Code with a git authorship date prior to `1420675200 +0000` (2015/01/08 00:00) are licensed under the GNU General Public License version 3, which can be found in full in LICENSE-GPL3.txt.

All code whose authorship dates are not prior to `1420675200 +0000` is assumed to be licensed under AGPL v3, if you wish to license under GPL v3 please make this clear in the commit message and any added files.

If you wish to develop and host this codebase in a closed source manner you may use all code prior to `1420675200 +0000`, which is licensed under GPL v3.  The major change here is that if you host a server using any code licensed under AGPLv3 you are required to provide full source code for your servers users as well including addons and modifications you have made.

See [here](https://www.gnu.org/licenses/why-affero-gpl.html) for more information.

Any files located in the
`vorestation/goon`,
`vorestation/icons/goonstation`, or
`vorestation/sound/goonstation`
directories, or any subdirectories of mentioned directories are licensed under the
Creative Commons 3.0 BY-NC-SA license
(https://creativecommons.org/licenses/by-nc-sa/3.0)

All assets including icons and sound are under a [CC BY-SA 3.0](http://creativecommons.org/licenses/by-sa/3.0/) license unless otherwise indicated.

Attributions and other licenses with links to original works are noted in [ATTRIBUTIONS.md](./ATTRIBUTIONS.md).

### GETTING THE CODE
The simplest way to obtain the code is using the github .zip feature. If you do this, you won't be able to make a Pull Request later, though. You'll need to use the git method.

Click [here](https://github.com/VOREStation/VOREStation/archive/master.zip) to get the latest code as a .zip file, then unzip it to wherever you want.

The more complicated and easier to update method is using git.  You'll need to download git or some client from [here](http://git-scm.com/).  When that's installed, right click in any folder and click on "Git Bash".  When that opens, type in:

    git clone https://github.com/VOREStation/VOREStation.git

(hint: hold down ctrl and press insert to paste into git bash)

This will take a while to download, but it provides an easier method for updating.

### INSTALLATION

First-time installation should be fairly straightforward.  First, you'll need BYOND installed.  You can get it from [here](http://www.byond.com/).

This is a sourcecode-only release, so the next step is to compile the server files.  Open vorestation.dme by double-clicking it, open the Build menu, and click compile.  This'll take a little while, and if everything's done right you'll get a message like this:

    saving vorestation.dmb (DEBUG mode)

    vorestation.dmb - 0 errors, 0 warnings

If you see any errors or warnings, something has gone wrong - possibly a corrupt download or the files extracted wrong, or a code issue on the main repo.  Ask on IRC.

Once that's done, open up the config folder.  You'll want to edit config.txt to set the probabilities for different gamemodes in Secret and to set your server location so that all your players don't get disconnected at the end of each round.  It's recommended you don't turn on the gamemodes with probability 0, as they have various issues and aren't currently being tested, so they may have unknown and bizarre bugs.

You'll also want to edit admins.txt to remove the default admins and add your own.  "Host" is the highest level of access, and the other recommended admin levels for now are "Game Admin" and "Moderator".  The format is:

    byondkey - Rank

where the BYOND key must be in lowercase and the admin rank must be properly capitalised.  There are a bunch more admin ranks, but these two should be enough for most servers, assuming you have trustworthy admins.

Finally, to start the server, run Dream Daemon and enter the path to your compiled vorestation.dmb file.  Make sure to set the port to the one you  specified in the config.txt, and set the Security box to 'Trusted'.  Then press GO and the server should start up and be ready to join.

---

### UPDATING

To update an existing installation, first back up your /config and /data folders
as these store your server configuration, player preferences and banlist.

If you used the zip method, you'll need to download the zip file again and unzip it somewhere else, and then copy the /config and /data folders over.

If you used the git method, you simply need to type this in to git bash:

    git pull

When this completes, copy over your /data and /config folders again, just in case.

When you have done this, you'll need to recompile the code, but then it should work fine.

---

### Configuration

For a basic setup, simply copy every file from config/example to config.

---

### SQL Setup

The SQL backend for the library and stats tracking requires a MySQL server.  Your server details go in /config/dbconfig.txt, and the SQL schema is in /SQL/tgstation_schema.sql.  More detailed setup instructions arecoming soon, for now ask in our Discord.
