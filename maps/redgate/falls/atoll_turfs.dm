//All turfs here meant to be "fullbright", no lighting.
/turf/simulated/floor/atoll
	name = "marble floor"
	desc = "Scuff and weathered etchings make these floors out to be pretty old."
	icon = 'maps/redgate/falls/icons/turfs/marble.dmi'
	icon_state = "1"
	dynamic_lighting = 0

//Pick random sprite states and generate damage decals randomly
/turf/simulated/floor/atoll/Initialize()
	. = ..()
	icon_state = "[rand(1,5)]"
	if(prob(5))
		new /obj/effect/floor_decal/atoll/damage(src, pick(alldirs))

//holycrapshitcode
/turf/simulated/floor/atoll/vertical
	name = "marble wall"
	desc = "A sheer face wall, extending up well overhead."
	icon_state = "wall"
	density = 1

/turf/simulated/floor/atoll/vertical/Initialize()
	. = ..()
	icon_state = "wall"

/turf/simulated/floor/water/atoll
	name = "shallow water"
	desc = "This water looks pretty shallow and calm. You'd almost feel bad for hopping in and disturbing its serene flatness."
	icon = 'maps/redgate/falls/icons/turfs/water.dmi'
	icon_state = "shallow"
	under_state = "shallow"
	dynamic_lighting = 0
	outdoors = OUTDOORS_NO

//Cut out the caustics overlay and replace with nothing
/turf/simulated/floor/water/atoll/update_icon()
	..()
	cut_overlays()
	var/image/water_sprite = image(icon = 'maps/redgate/falls/icons/turfs/water.dmi', icon_state = "shallow", layer = 3.0)
	add_overlay(water_sprite)

//Spawn animated whitecaps around
/turf/simulated/floor/water/atoll/Initialize()
	. = ..()
	if(prob(25))
		new /obj/effect/decal/whitecaps(src)


/turf/simulated/floor/water/atoll/sunk
	icon_state = "sunken"
	under_state = "shallow"

/turf/simulated/floor/water/atoll/sunk/update_icon()
	..()
	cut_overlays()
	var/image/water_sprite = image(icon = 'maps/redgate/falls/icons/turfs/water.dmi', icon_state = "sunken", layer = 3.0)
	add_overlay(water_sprite)