/datum/ai_holder/simple_mob/melee/pack_mob
	cooperative = TRUE
	call_distance = 28 // pack mobs should be able to communicate quite a ways - we can assume by howls/etc
	can_flee = TRUE
	mauling = TRUE // Kill/finish off unconscious people.
	vision_range = 12 // This is a bit cheaty - normal vision range is 7 tiles, one screen, setting that to 10 allows us to track targets offscreen by up to 5 tiles, and make for an easier time keeping chase of targets.
	flee_when_dying = TRUE // animals know to run when wounded/overmatched
	flee_when_outmatched = TRUE // animals know to run when wounded/overmatched

/datum/ai_holder/simple_mob/melee/pack_mob/post_melee_attack(atom/A)
	if(holder.Adjacent(A))
		holder.IMove(get_step(holder, pick(alldirs)))
		holder.face_atom(A)

/datum/ai_holder/simple_mob/melee/pack_mob/nyria
	hostile = FALSE
	retaliate = TRUE

/datum/ai_holder/simple_mob/armadillo
	hostile = FALSE
	retaliate = TRUE
	can_flee = TRUE
	flee_when_dying = TRUE
	dying_threshold = 0.9
	speak_chance = 1
