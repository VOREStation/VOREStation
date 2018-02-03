# Map Merge 2

**Map Merge 2** is an improvement over previous map merging scripts, with
better merge-conflict prevention, multi-Z support, and automatic handling of
key overflow.

## What Map Merging Is

The "map merge" operation describes the process of rewriting a map file written
by the DreamMaker map editor to A) use a format more amenable to Git's conflict
resolution and B) differ in the least amount textually from the previous
version of the map while maintaining all the actual changes. It requires an old
version of the map to use as a reference and a new version of the map which
contains the desired changes.

## Installation

* Install Python 3.6.X from the [Python website]
  * Make sure to check 'Add Python to PATH' on the first screen of the setup!
* Run `requirements-install.bat` in the tools/mapmerge2 folder (or run `python -m pip install -r requirements.txt`).
* Run `install.bat` in the tools/mapmerge2/hooks folder.

After this point, any time you make commits in Git, the maps should automatically be converted to tgm format for you.

If you find it necessary to convert them by hand, there are batch files in the tools/mapmerge2 folder to do so.

If you re-clone, you will need to re-run `install.bat`.


## Code Structure

Frontend scripts are meant to be run directly. They obey the environment
variables `TGM` to set whether files are saved in TGM (1) or DMM (0) format,
and `MAPROOT` to determine where maps are kept. By default, TGM is used and
the map root is autodetected. Each script may either prompt for the desired map
or be run with command-line parameters indicating which maps to act on. The
scripts include:

* `convert.py` for converting maps to and from the TGM format. Used by
  `tgm2dmm.bat` and `dmm2tgm.bat`.
* `mapmerge.py` for running the map merge on map backups saved by
  `Prepare Maps.bat`. Used by `mapmerge.bat`

Implementation modules:

* `dmm.py` includes the map reader and writer.
* `mapmerge.py` includes the implementation of the map merge operation.
* `frontend.py` includes the common code for the frontend scripts.

`precommit.py` is run by the Git hooks if installed, and merges the new
version of any map saved in the index (`git add`ed) with the old version stored
in Git when run.

[Python website]: https://www.python.org/downloads/
