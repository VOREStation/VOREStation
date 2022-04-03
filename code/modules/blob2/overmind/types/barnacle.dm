
/datum/blob_type/barnacle
	name = "barnacloid blob"
	desc = "A mass that seems densely wound around its core."
	ai_desc = "sedentary"
	effect_desc = "Will not create any nodes. Has slightly higher resistances."
	difficulty = BLOB_DIFFICULTY_EASY
	color = "#383838"
	complementary_color = "#c04761"
	can_build_nodes = FALSE
	spread_modifier = 0.1
	ai_aggressiveness = 0

	brute_multiplier = 0.35
	burn_multiplier = 0.8

/datum/blob_type/barnacle/on_chunk_use(obj/item/weapon/blobcore_chunk/B, mob/living/user)
	var/turf/T = get_turf(B)

	to_chat(user, "<span class='alien'>\The [B] produces a cauterizing ooze!</span>")

	T.visible_message("<span class='alium'>\The [B] shudders at \the [user]'s touch, before disgorging a disgusting ooze.</span>", "<span class='notice'>A fleshy slop hits the ground.</span>", list(user))

	for(var/turf/simulated/floor/F in view(2, T))
		spawn()
			var/obj/effect/vfx/water/splash = new(T)
			splash.create_reagents(15)
			splash.reagents.add_reagent("blood", 10,list("blood_colour" = color))
			splash.set_color()

			splash.set_up(F, 2, 3)

		var/obj/effect/decal/cleanable/chemcoating/blood = locate() in T
		if(!istype(blood))
			blood = new(T)
			blood.reagents.add_reagent("blood", 10,list("blood_colour" = color))
			blood.reagents.add_reagent("dermalaze", 5)
			blood.update_icon()

	return
