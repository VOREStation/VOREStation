/obj/effect/step_trigger/teleporter/innland_to_bedrooms
	name = "stairs to bedrooms"
	desc = "These stairs go up!"
	icon = 'icons/obj/structures/stairs_64x64.dmi'
	icon_state = ""
	invisibility = INVISIBILITY_NONE
	layer = STAIRS_LAYER

/obj/effect/step_trigger/teleporter/innland_to_lower
	name = "stairs to lower level"
	desc = "These stairs go down..."
	icon = 'icons/obj/structures/stairs_64x64.dmi'
	icon_state = ""
	invisibility = INVISIBILITY_NONE
	layer = STAIRS_LAYER

/obj/effect/step_trigger/teleporter/innland_to_bedrooms/Initialize(mapload)
	. = ..()
	teleport_x = 8
	teleport_y = 130
	teleport_z = src.z

/obj/effect/step_trigger/teleporter/innland_to_lower/Initialize(mapload)
	. = ..()
	teleport_x = 33
	teleport_y = 95
	teleport_z = src.z
