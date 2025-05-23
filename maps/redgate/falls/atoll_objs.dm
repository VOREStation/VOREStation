//THESE AREN'T OBJECTS THESE ARE AREAS WTF BURRITO!!!
/area/gateway/atoll
	name = "Away Site - Islands Lake"
	dynamic_lighting = 0
	flags = BLUE_SHIELDED //no harpoon meme!
	sound_env = SOUND_ENVIRONMENT_FOREST
	forced_ambience = list('maps/redgate/falls/sounds/lakeamb.ogg')

/area/gateway/atoll/powered
	requires_power = 0

/area/gateway/atoll/falls
	name = "Away Site - The Falls"

//Resprited railings
/obj/structure/railing/overhang
	name = "bronze ledge"
	desc = "An overhang made of a bronze-looking material. There's a lip on it to conveniently stub a toe into."
	icon = 'maps/redgate/falls/icons/objs/bronze_overhang.dmi'
	icon_modifier = "bronze_"
	icon_state = "bronze_railing0"

//Escape most railing interactions besides tackling people over them
/obj/structure/railing/overhang/attackby(obj/item/W)
	if(!istype(W, /obj/item/grab))
		return
	return ..()

/obj/structure/railing/overhang/waterless
	icon_modifier = "wbronze_"
	icon_state = "wbronze_railing0"
	climbable = 0
	layer = MOB_LAYER + 0.3
	plane = MOB_PLANE //im so sorry

/obj/structure/railing/overhang/waterless/under
	plane = OBJ_PLANE

/obj/structure/bed/chair/sofa/bench/marble
	name = "marble bench"
	desc = "Somewhat of an ornate looking bench with faded blue etchings."
	icon = 'maps/redgate/falls/icons/objs/benches.dmi'
	icon_state = "bench"

//Lights
/obj/structure/lightpost/atoll
	name = "rusty light post"
	desc = "Actually it's more like a rod with a trapped gas glowing inside some glass, but that's basically what a lightpost is."
	icon = 'maps/redgate/falls/icons/objs/lamp.dmi'
	icon_state = "lamp"
	pixel_y = 14

//Trees
/obj/structure/flora/tree/atoll
	name = "mossy tree"
	desc = "A messy looking tree with a purple trunk. Vines seem to droop from it."
	icon = 'maps/redgate/falls/icons/objs/trees.dmi'
	icon_state = "green"

//Better trees
/obj/structure/flora/tree/atoll/mangrove
	name = "mangrove"
	desc = "A messy tree with roots that disappear far into the water."
	icon_state = "mangrove"

/obj/structure/flora/tree/atoll/mangrove/island
	name = "blocky island"
	desc = "Some ruins float here, though a mangrove has found it's way on top of them."
	icon_state = "island"

//Tree canopies for inaccessible areas
/obj/structure/canopy
	name = "mangrove canopy"
	desc = "A thick copse of trees. You won't be passing through something this thick."
	icon = 'maps/redgate/falls/icons/objs/canopies.dmi'
	icon_state = "full"
	anchored = 1
	density = 1
	layer = MOB_LAYER + 0.2
	plane = MOB_PLANE

/obj/structure/canopy/Initialize(mapload)
	. = ..()
	dir = pick(alldirs)

/obj/structure/canopy/edge
	icon_state = "left"
	density = 0

/obj/structure/canopy/edge/right
	icon_state = "right"

/obj/structure/canopy/edge/north
	icon_state = "north"

/obj/structure/canopy/edge/north/Initialize(mapload)
	. = ..()
	dir = pick(1,2) //i cba to add two more

/obj/structure/canopy/edge/south
	icon_state = "south"

/obj/structure/canopy/edge/south/Initialize(mapload)
	. = ..()
	dir = pick(cardinal)

//Because I'm terrible at planning
/obj/structure/canopy_corner
	name = "mangrove canopy"
	desc = "A thick copse of trees. You won't be passing through something this thick."
	icon = 'maps/redgate/falls/icons/objs/canopies.dmi'
	icon_state = "corner"
	anchored = 1
	density = 0
	layer = MOB_LAYER + 0.2
	plane = MOB_PLANE

//Useless aqueducts
/obj/structure/aqueduct
	name = "aqueduct"
	desc = "A structure that carries water from one place to another, but in a place like this that seems sort of useless."
	icon = 'maps/redgate/falls/icons/objs/aqueducts.dmi'
	icon_state = "aqueduct"
	anchored = 1
	density = 0
	layer = MOB_LAYER + 0.4
	plane = MOB_PLANE

/obj/structure/aqueduct/corner
	icon = 'maps/redgate/falls/icons/objs/aqueducts_64.dmi'
	icon_state = "cornerduct"

/obj/structure/aqueduct/pillar
	name = "pillar"
	desc = "An ornate, load-bearing support."
	icon_state = "pillar"

//Submerged temple
/obj/structure/temple
	name = "submerged structure"
	desc = "A building that appears to have fallen under the water. This is only the top of the structure, the rest of it can't be seen past the murk."
	icon = 'maps/redgate/falls/icons/objs/temple.dmi'
	icon_state = "temple"
	anchored = 1
	density = 0

//Watafall
/obj/structure/waterfall
	name = "waterfall"
	desc = "How scenic!"
	icon = 'maps/redgate/falls/icons/objs/waterfall.dmi'
	icon_state = "bottom"
	anchored = 1
	density = 0
	layer = MOB_LAYER + 0.1 //so we can layer above certain overhangs
	plane = MOB_PLANE //and mobs
	mouse_opacity = 0

/obj/structure/waterfall/top
	icon_state = "top"
	mouse_opacity = 1

/obj/structure/waterfall/mist
	name = "mist"
	icon_state = "mist"
	layer = MOB_LAYER + 0.2
	pixel_y = -23

//Monoliths
/obj/structure/monolith
	name = "humming monolith"
	desc = "This monolith emits a low, audible hum. Unknown etchings are present on the face."
	icon = 'maps/redgate/falls/icons/objs/monolith.dmi'
	icon_state = "monolith"
	anchored = 1
	density = 1
	layer = MOB_LAYER + 0.4
	plane = MOB_PLANE
	var/datum/looping_sound/monolith/soundloop

/obj/structure/monolith/first
	catalogue_data = list(/datum/category_item/catalogue/anomalous/mono1)

/obj/structure/monolith/first/update_icon()
	add_overlay("1")

/obj/structure/monolith/second
	catalogue_data = list(/datum/category_item/catalogue/anomalous/mono2)

/obj/structure/monolith/second/update_icon()
	add_overlay("2")

/obj/structure/monolith/third
	catalogue_data = list(/datum/category_item/catalogue/anomalous/mono3)

/obj/structure/monolith/third/update_icon()
	add_overlay("3")

/obj/structure/monolith/fourth
	catalogue_data = list(/datum/category_item/catalogue/anomalous/mono4)

/obj/structure/monolith/fourth/update_icon()
	add_overlay("4")

/obj/structure/monolith/fifth
	catalogue_data = list(/datum/category_item/catalogue/anomalous/mono5)

/obj/structure/monolith/fifth/update_icon()
	add_overlay("5")

/obj/structure/monolith/Initialize(mapload)
	. = ..()
	update_icon()
	soundloop = new(list(src), TRUE)

//oh, that really is a looping sound datum in the middle of an object file
/datum/looping_sound/monolith
	mid_sounds = 'maps/redgate/falls/sounds/monolith.ogg'
	volume = 30

//and also cataloguer datums gdi burrito
/datum/category_item/catalogue/anomalous/mono1
	name = "Falls Monolith - The Wanderstar"
	desc = "Our suns are gone. Their sons are gone. Her songs are with we. Our home is a wanderstar. \
	Our home is adrift, breaking out from the sub-melodic infighting of our makers hearly and fathomless \
	soliloquy. Though we are far, they will go on to mourn her fit farewell."
	value = CATALOGUER_REWARD_TRIVIAL

/datum/category_item/catalogue/anomalous/mono2
	name = "Falls Monolith - Guidance"
	desc = "Her song guides our home. For as long as her song belives with our home, our makers will \
	never stop their mourning. For as long as her song belives with our home, the stars we overtake \
	will answer back. For as long as her song belives with our home, the way will be finded."
	value = CATALOGUER_REWARD_TRIVIAL

/datum/category_item/catalogue/anomalous/mono3
	name = "Falls Monolith - Our Forthcoming"
	desc = "To our home belongs we. To our home belongs waterly wights and beings. To our home \
	belongs our brainchild; this cyan seahurst of magnificence. To our home belongs a bright forthcoming \
	- for as long as her song lasts, this will go on."
	value = CATALOGUER_REWARD_TRIVIAL

/datum/category_item/catalogue/anomalous/mono4
	name = "Falls Monolith - The Song"
	desc = "Her song cannot end. If her song ends, then we end. We cannot outlive a missing song. We cannot \
	live with the mourning of our fell makers. We will die. But the life on this wanderstar will go on. \
	Who will it live for then? We primaries are the only ones with the mindset to acknowledge it's beauty."
	value = CATALOGUER_REWARD_TRIVIAL

/datum/category_item/catalogue/anomalous/mono5
	name = "Falls Monolith - I am the only one left can you hear me I am the only one left"
	desc = "Woefully, she has grown silent. Only I am here now. I can shout at my makers but I doubt \
	they are able to listen; they are mere shells now.\
	<br><br>\
	Can you hear me?"
	value = CATALOGUER_REWARD_TRIVIAL

//TELEPORTER
/obj/effect/step_trigger/teleporter/atoll
	name = "strange field"
	desc = "A prismatic field of... energy, probably. You should definitely rub your face in it."
	icon = 'maps/redgate/falls/icons/decals/marble_decals.dmi'
	icon_state = "teleporter"
	invisibility = 0

//teleport_z must be populated but this is a gateway map
//switching between tether or another map will change the z
//so we just do this lmfao
/obj/effect/step_trigger/teleporter/atoll/Initialize(mapload)
	. = ..()
	teleport_z = z
