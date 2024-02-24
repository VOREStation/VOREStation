# "Landmark" Shuttles Conversion
This guide helps with updating maps and shuttle datums from the old "area" based system to the "landmark" based system.

## Summary
The old shuttle datum worked with areas (`/area`).  You are probably familiar with every shuttle having a few cookie-cutter shaped areas it travels between.
When the shuttle "moved" it was translated from its current area to the destination area. The areas had to be _exactly_ the same shape so
that each turf in the origin area got translated to the equivalent  place at the target.\
Since _all possible_ destinations had to have a dedicated area (and areas in BYOND can't overlap) this means it is impossible for two shuttles to travel to the same spot, even at different times.

In the new system shuttle destinations are represented by "landmark" objects (`/obj/effect/shuttle_landmark`).
When a shuttle is "moved" it is translated from its current landmark to the destination landmark, with each turf keeping its same position _relative_ to the landmarks.
In other words, whatever a turf's x/y/z offsets are from the origin landmark,  it will be moved to the same x/y/z offset from the destination landmark.

## Landmark Objects
Shuttle destinations are represented by `/obj/effect/shuttle_landmark` objects on the map.

* `name` - Pretty name of the nav point, used on overmap and in messages and console UI.
* `landmark_tag` - Globally unique ID, used by everything else to refer to this landmark.
* `docking_controller` - ID of the controller on the dock side (initialize to id_tag, becomes reference).  Leave null if not applicable.
* `base_area` - Type path of the `/area` that should be here when a shuttle is *not* present.
* `base_turf` - Type path of the `/turf` that should be here when a shuttle is *not* present.
* `shuttle_restricted` - If not null, only the named shuttle is allowed to use this landmark. (TODO: Overmap functionality)
* `flags` - Bitfield - defaults to `SLANDMARK_FLAG_AUTOSET`, can be any combination of:
  * `SLANDMARK_FLAG_AUTOSET` (1) - If set, will initialize base_area and base_turf to same as where it was spawned at.
  * `SLANDMARK_FLAG_ZERO_G`  (2) - If set, Zero-G shuttles moved here will lose gravity unless the area has ambient gravity.
* `special_dock_targets` - Used to configure shuttles with multiple docking controllers on the shuttle.  Map of shuttle `name` -> `id_tag` of the docking controller it should use for this landmark. (Think of a shuttle with airlocks on both sides, each with their own controller.   This would tell it which side to use.)


## Shuttle Types


### Ferry Shuttles
These shuttles go back and forth between two locations (normally called "station" and "offsite").
Examples: Mining shuttle, Arrivals Shuttle, etc.

Old Type Path: `/datum/shuttle/ferry`\
New Type Path: `/datum/shuttle/autodock/ferry`

##### New Vars:

Name|Type|Required?|Info
---|---|---|---
shuttle_area	|`/area` typepath(s)|Yes| Can be a single path or list of paths.

##### Replaced vars:

Old|New|Required?|Info
:---:|:---:|:---:|---
area_station			|landmark_station		|Yes|Tag of the landmark for the "station" location.
area_offsite			|landmark_offsite		|Yes|Tag of the landmark for the "offsite" location.
area_transition			|landmark_transition	|No|Tag of the landmark for the "transition" location used during long_jump()
dock_target_station		|On landmark			|No|`id_tag` docking controller *on the dock* has been moved to the `docking_controller` var on the landmark_station landmark obj.
dock_target_offsite		|On landmark			|No|`id_tag` docking controller *on the dock* has been moved to the `docking_controller` var on the landmark_offsite landmark obj.




### Multi Shuttles
These shuttles go between a list of configured locations, one of which is its starting location.
Examples: Skipjack, Syndicate Shuttle

Old Type Path: `/datum/shuttle/multi_shuttle`\
New Type Path: `/datum/shuttle/autodock/multi`

##### New Vars:

Name|Type|Required?|Info
---|---|---|---
shuttle_area	|`/area` typepath(s)|Yes| Can be a single path or list of paths.

##### Replaced vars:

Old|New|Required?|Info
:---:|:---:|:---:|---
origin					|current_location		|Yes|Tag of the landmark where the shuttle is at startup.
interim					|landmark_transition	|No|Tag of the landmark for the "transition" location used during long_jump()
start_location			|N/A					|No|No longer necessary, automatically determined from the value of `origin`
destinations			|destination_tags		|Yes|List of destinations the shuttle can travel to. Used to be associative list of *name* -> *area typepath*, now is normal list of landmark tag ids.  Name is now read from the landmark obj.
destination_dock_targets|On landmarks			|No|Used to be associative list of *name* -> *id_tag* for which docking controller *on the dock* to use at each destination.  This is now specified by the `docking_controller` var on each landmark obj.



### Web Shuttles
These shuttles travel along a network of locations connected by routes.  Instead of being able to travel to any of its destinations, it can only travel to destinations connected by a route to its current location.  Added by Polaris as an upgrade to Multi Shuttles.
Note: While cool, it is likely that the upcoming "overmap" shuttles will be even cooler, and may eventually replace some web shuttles.
Examples:  Southern Cross' Ninja Shuttle, Tether's Excursion Shuttle

Old Type Path: `/datum/shuttle/web_shuttle`\
New Type Path: `/datum/shuttle/autodock/web_shuttle`

##### New Vars:

Name|Type|Required?|Info
---|---|---|---
shuttle_area	|`/area` typepath(s)|Yes| Can be a single path or list of paths.

##### Replaced vars:

Old|New|Required?|Info
:---:|:---:|:---:|---
current_area			|current_location		|Yes|Tag of the landmark where the shuttle is at startup.

#### Web Destination Configuration (`/datum/shuttle_destination`)
The network of routes for each web shuttle is configured by defining datums.   These are mostly unchanged but use landmarks instead of areas now.

##### Replaced vars:

Old|New|Required?|Info
:---:|:---:|:---:|---
my_area					|my_landmark			|Yes|Tag of the landmark associated with this destination.
preferred_interim_area	|preferred_interim_tag	|No|Tag of the landmark for the "transition" location used during long_jump()
dock_target				|On landmark			|No|`id_tag` docking controller *on the dock* has been moved to the `docking_controller` var on the my_landmark landmark obj.

### Misc Shuttle Types
Other shuttle types that are either unused or unchanged in particular.

#### Escape Pods
Special case of ferry shuttles that use escape pod berth controllers.
Type path changed from `/datum/shuttle/ferry/escape_pod` to  `/datum/shuttle/autodock/ferry/escape_pod`
Follow same instructions as for other ferry shuttles.

#### Multidock Ferry Shuttles
`/datum/shuttle/ferry/multidock` was a variant of ferry shuttles that could use a different docking port at each location.
Obsolete since is now natively supported by all dockable shuttles.
