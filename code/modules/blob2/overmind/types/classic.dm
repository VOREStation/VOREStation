// Mostly a classic blob.  No nodes, no other blob types.
/datum/blob_type/classic
	name = "lethargic blob"
	desc = "A mass that seems bound to its core."
	ai_desc = "unambitious"
	effect_desc = "Will not create any nodes.  Has average strength and resistances."
	difficulty = BLOB_DIFFICULTY_EASY // Behaves almost like oldblob, and as such is about as easy as oldblob.
	color = "#AAFF00"
	complementary_color = "#57787B"
	can_build_nodes = FALSE
	spread_modifier = 1.0
	ai_aggressiveness = 0

/datum/blob_type/classic/on_chunk_use(obj/item/blobcore_chunk/B, mob/living/user)
	var/turf/T = get_turf(B)

	to_chat(user, "<span class='alien'>\The [B] produces a soothing ooze!</span>")

	T.visible_message("<span class='alium'>\The [B] shudders at \the [user]'s touch, before disgorging a disgusting ooze.</span>")

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
			blood.reagents.add_reagent("tricorlidaze", 5)
			blood.update_icon()

	return
