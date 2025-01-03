# GitHub Actions Scripts

This folder contains all the script and tools required for GitHub actions. If you add something to this directory, **PLEASE** document it in here (also this is actually only used for nanomap generation)

- `nanomap-renderer` - No longer used due to being out of date. A linux application to render NanoMap images of the ingame maps automatically. Based off of SpacemanDMM (Modified source [here](https://github.com/AffectedArc07/ParaSpacemanDMM), original source [here](https://github.com/Spacemaniac/SpacemanDMM))
- `nanomap-renderer-invoker.sh` - A script which invokes dmm-tools from [SpacemanDMM](https://github.com/Spacemaniac/SpacemanDMM) to dynamically render maps in specified directories and [ImageMagick](https://imagemagick.org/index.php) to resize and compress them before moving them to the correct directory. To change which map directories are rendered, edit the mapdir variable as directed in the file.
