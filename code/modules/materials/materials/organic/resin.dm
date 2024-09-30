/datum/material/resin
	name = "resin"
	icon_colour = "#35343a"
	icon_base = "resin"
	table_icon_base = "stone"
	dooropen_noise = 'sound/effects/attackblob.ogg'
	door_icon_base = "resin"
	icon_reinf = "reinf_mesh"
	melting_point = T0C+300
	sheet_singular_name = "blob"
	sheet_plural_name = "blobs"
	conductive = 0
	explosion_resistance = 60
	radiation_resistance = 10
	stack_origin_tech = list(TECH_MATERIAL = 8, TECH_PHORON = 4, TECH_BLUESPACE = 4, TECH_BIO = 7)
	stack_type = /obj/item/stack/material/resin

/datum/material/resin/can_open_material_door(var/mob/living/user)
	var/mob/living/carbon/M = user
	if(istype(M) && locate(/obj/item/organ/internal/xenos/hivenode) in M.internal_organs)
		return TRUE
	if(istype(M) && locate(/obj/item/organ/internal/xenos/resinspinner/replicant) in M.internal_organs)
		return TRUE
	return FALSE

/datum/material/resin/wall_touch_special(var/turf/simulated/wall/W, var/mob/living/L)
	var/mob/living/carbon/M = L
	if(istype(M) && locate(/obj/item/organ/internal/xenos/hivenode) in M.internal_organs)
		to_chat(M, "\The [W] shudders under your touch, starting to become porous.")
		playsound(W, 'sound/effects/attackblob.ogg', 50, 1)
		if(!do_after(L, 5 SECONDS))
			return FALSE
		playsound(W, 'sound/effects/attackblob.ogg', 100, 1)
		W.dismantle_wall()
		return TRUE
	if(istype(M) && locate(/obj/item/organ/internal/xenos/resinspinner/replicant) in M.internal_organs)
		to_chat(M, "\The [W] shudders under your touch, starting to become porous.")
		playsound(W, 'sound/effects/attackblob.ogg', 50, 1)
		if(!do_after(L, 5 SECONDS))
			return FALSE
		playsound(W, 'sound/effects/attackblob.ogg', 100, 1)
		W.dismantle_wall()
		return TRUE
	return FALSE

/datum/material/resin/generate_recipes()
	recipes = list(
		new /datum/stack_recipe("[display_name] door", /obj/structure/simple_door/resin, 10, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE),
		new /datum/stack_recipe("[display_name] barricade", /obj/structure/alien/wall, 5, time = 5 SECONDS, one_per_turf = 1, on_floor = 1, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("[display_name] nest", /obj/structure/bed/nest, 2, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE),
		new /datum/stack_recipe("[display_name] wall girders", /obj/structure/girder/resin, 2, time = 5 SECONDS, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE),
		new /datum/stack_recipe("crude [display_name] bandage", /obj/item/stack/medical/crude_pack, 1, time = 2 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("[display_name] net", /obj/item/material/fishing_net, 10, time = 5 SECONDS, supplied_material = "[name]", pass_stack_color = TRUE),
		new /datum/stack_recipe("[display_name] membrane", /obj/structure/alien/membrane, 1, time = 2 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("[display_name] node", /obj/effect/alien/weeds/node, 1, time = 4 SECONDS, recycle_material = "[name]")
	)