//THESE AREN'T OBJECTS THESE ARE AREAS WTF BURRITO!!!
/area/gateway/atoll
	name = "Away Site - Lake"
	dynamic_lighting = 0

/area/gateway/atoll/powered
	requires_power = 0

/obj/structure/railing/overhang
	name = "bronze ledge"
	desc = "An overhang made of a bronze-looking material. There's a lip on it to conveniently stub a toe into."
	icon = 'maps/atoll/icons/objs/bronze_overhang.dmi'
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

/obj/structure/bed/chair/sofa/bench/marble
	name = "marble bench"
	desc = "Somewhat of an ornate looking bench with faded blue etchings."
	icon = 'maps/atoll/icons/objs/benches.dmi'
	icon_state = "bench"

/obj/structure/lightpost/atoll
	name = "rusty light post"
	desc = "Actually it's more like a rod with a trapped gas glowing inside some glass, but that's basically what a lightpost is."
	icon = 'maps/atoll/icons/objs/lamp.dmi'
	icon_state = "lamp"

/obj/structure/flora/tree/atoll
	name = "mossy tree"
	desc = "A messy looking tree with a purple trunk. Vines seem to droop from it."
	icon = 'maps/atoll/icons/objs/trees.dmi'
	icon_state = "green"

/obj/structure/flora/tree/atoll/huge
	name = "massive mossy tree"
	icon = 'maps/atoll/icons/objs/trees_xl.dmi'
	icon_state = "tree"

/obj/structure/flora/moss
	name = "hanging moss"
	desc = "Some unsightly moss. Clearly the groundskeepers here aren't doing their jobs."
	icon = 'maps/atoll/icons/objs/moss.dmi'
	icon_state = "moss"

//TELEPORTER
/obj/effect/step_trigger/teleporter/atoll
	name = "strange field"
	desc = "A prismatic field of... energy, probably. You should definitely rub your face in it."
	icon = 'maps/atoll/icons/decals/marble_decals.dmi'
	icon_state = "teleporter"
	invisibility = 0

//teleport_z must be populated but this is a gateway map
//switching between tether or another map will change the z
//so we just do this lmfao
/obj/effect/step_trigger/teleporter/atoll/Initialize()
	. = ..()
	teleport_z = z
