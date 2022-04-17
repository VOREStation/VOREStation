Overmap Ships + Places, the Guide
This is a very basic list of just "what is needed". It is assumed you'll lookup where these go.
Proper, full-length guide will be added later to here + the wiki.
For now, just use this as reference for what is needed for Overmap ships + locations.

**CREATED IN-EDITOR:**
```
/obj/effect/shuttle_landmark
  var edits:
    base_area: what area to replace the shuttle's area with when it's left
    base_turf: what turf to replace the shuttle's location when it's left
    landmark_tag: lowercase identifier. Used in current_location
    name: the landmark's name.
```

**CREATED IN-CODE:**
```c
/area/shuttle/SHIPNAME
  name = "\improper [Name]" // Just replace [Name] with whatever your want to name the ship
  icon_state = "shuttlered"
  requires_power = 1 // Or 0 if you don't want to have to power the ship yourself. 
//Area should probably be placed in southern-cross-areas.dm but the rest can go into some file all together.
  
/datum/shuttle/autodock/overmap/SHIPNAME
    name = "[Name]"
    warmup_time = 0
    current_location = "" // See CREATED IN-EDITOR
    shuttle_area = /area/shuttle/SHIPNAME // See above area. Can also be list of multiple areas.
    fuel_consumption = 1 // Typically defines how much fuel the shuttle uses per jump. 1-3 is reasonable, base it on size.
    move_direction = NORTH / SOUTH / EAST / WEST

/obj/effect/overmap/visitable/ship/landable/SHIPNAME
    name = "[Name]" // Can be named whatever, best to keep it similar to actual ship name.
    desc = "Some description goes here."
    vessel_mass = 1000 // Some factor for speed. For reference, 1000 is fucking fast, 10000 is only fast when maxed on engines and very costly.
    vessel_size = SHIP_SIZE_TINY / SHIP_SIZE_SMALL / SHIP_SIZE_LARGE
    shuttle = "[Name]" // Direct reference to above shuttle. MUST be the same as name.

/obj/machinery/computer/shuttle_control/explore/SHIPNAME
    name = "short jump console"
    shuttle_tag = "[Name]" // Direct reference to above shuttle. MUST be the same as name.
    req_one_access = list(access_pilot)
```

**OVERMAP SHIP CREATION INSTRUCTIONS:**
Build your shuttle however you'd like, though it MUST have:
- Phoron cannister(s) hooked up to proper engines. /obj/machinery/atmospherics/unary/engine
- Engine Control. `/obj/machinery/computer/ship/engines`
- Helm Control. `/obj/machinery/computer/ship/helm`
- Fuel port, for short distance jumps and docking. `/obj/structure/fuel_port`
- Short jump console, defined in code earlier. `/obj/machinery/computer/shuttle_control/explore/SHIPNAME`
- A spawned in effect, defined in code earlier, inside of the ship area. `/obj/effect/overmap/visitable/ship/landable/SHIPNAME`
- A docking point, made through the map editor, mentioned earlier. `/obj/effect/ship_landmark`. Typically this is placed inside the ship, directly in front of the exterior door. This dictates where it places the shuttles so be sure to actually test how your shuttles react to landing in odd locations. The landmark's tag also needs to be added to the appropriate area in `maps/southern_cross/overmap/sectors.dm` or else ships cannot dock there.
- The shuttle also needs to be placed entirely in the designated area that you made in the above code, since shuttles are based off of the area everything is in.

It would be **RECOMMENDED** to also have:
- Sensors, controlled by `/obj/machinery/computer/ship/sensors` and `/obj/machinery/shipsensors` (maybe the /weak variant for small ships if you add them at all?)
- Docking Controller. Not 100% sure on how these work yet, but will be updated as needed. Not necessary, just nice to have for ease of access.
- A pump somewhere in the fuel intake to your engines, for better fuel management.