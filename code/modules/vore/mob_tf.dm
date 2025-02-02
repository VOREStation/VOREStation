// Procs for living mobs based around mob transformation. Initially made for the mouseray, they are now used in various other places and the main procs are now called from here.


/mob/living/proc/mob_tf(var/mob/living/M)
	if(!istype(M))
		return
	if(src && isliving(src))
		faction = M.faction
		if(istype(src, /mob/living/simple_mob))
			var/mob/living/simple_mob/S = src
			if(!S.voremob_loaded)
				S.voremob_loaded = TRUE
				S.init_vore()
		for(var/obj/belly/B as anything in src.vore_organs)
			src.vore_organs -= B
			qdel(B)
		src.vore_organs = list()
		src.name = M.name
		src.real_name = M.real_name
		for(var/lang in M.languages)
			src.languages |= lang
		M.copy_vore_prefs_to_mob(src)
		src.vore_selected = M.vore_selected
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(ishuman(src))
				var/mob/living/carbon/human/N = src
				N.gender = H.gender
				N.identifying_gender = H.identifying_gender
			else
				src.gender = H.gender
		else
			src.gender = M.gender
			if(ishuman(src))
				var/mob/living/carbon/human/N = src
				N.identifying_gender = M.gender

		mob_belly_transfer(M)

		nutrition = M.nutrition
		src.ckey = M.ckey
		if(M.ai_holder && src.ai_holder)
			var/datum/ai_holder/old_AI = M.ai_holder
			old_AI.set_stance(STANCE_SLEEP)
			var/datum/ai_holder/new_AI = src.ai_holder
			new_AI.hostile = old_AI.hostile
			new_AI.retaliate = old_AI.retaliate
		M.loc = src
		M.forceMove(src)
		src.tf_mob_holder = M

/mob/living/proc/mob_belly_transfer(var/mob/living/M)
	for(var/obj/belly/B as anything in M.vore_organs)
		B.loc = src
		B.forceMove(src)
		B.owner = src
		M.vore_organs -= B
		src.vore_organs += B

/mob/living
	var/mob/living/tf_mob_holder = null

/mob/living/proc/revert_mob_tf()
	if(!tf_mob_holder)
		return
	var/mob/living/ourmob = tf_mob_holder
	if(ourmob.ai_holder)
		var/datum/ai_holder/our_AI = ourmob.ai_holder
		our_AI.set_stance(STANCE_IDLE)
	tf_mob_holder = null
	ourmob.ckey = ckey
	var/turf/get_dat_turf = get_turf(src)
	ourmob.loc = get_dat_turf
	ourmob.forceMove(get_dat_turf)
	ourmob.vore_selected = vore_selected
	vore_selected = null
	for(var/obj/belly/B as anything in vore_organs)
		B.loc = ourmob
		B.forceMove(ourmob)
		B.owner = ourmob
		vore_organs -= B
		ourmob.vore_organs += B

	ourmob.Life(1)

	if(ishuman(src))
		for(var/obj/item/W in src)
			if(istype(W, /obj/item/implant/backup) || istype(W, /obj/item/nif))
				continue
			src.drop_from_inventory(W)

	qdel(src)

/mob/living/proc/handle_tf_holder()
	if(!tf_mob_holder)
		return
	if(stat != tf_mob_holder.stat)
		if(stat == DEAD)
			tf_mob_holder.death(FALSE, null)
		if(tf_mob_holder.stat == DEAD)
			death()

/mob/living/proc/copy_vore_prefs_to_mob(var/mob/living/new_mob)
	//For primarily copying vore preference settings from a carbon mob to a simplemob
	//It can be used for other things, but be advised, if you're using it to put a simplemob into a carbon mob, you're gonna be overriding a bunch of prefs
	new_mob.ooc_notes = ooc_notes
	new_mob.ooc_notes_likes = ooc_notes_likes
	new_mob.ooc_notes_dislikes = ooc_notes_dislikes
	new_mob.digestable = digestable
	new_mob.devourable = devourable
	new_mob.absorbable = absorbable
	new_mob.feeding = feeding
	new_mob.can_be_drop_prey = can_be_drop_prey
	new_mob.can_be_drop_pred = can_be_drop_pred
	new_mob.allow_inbelly_spawning = allow_inbelly_spawning
	new_mob.digest_leave_remains = digest_leave_remains
	new_mob.allowmobvore = allowmobvore
	new_mob.permit_healbelly = permit_healbelly
	new_mob.noisy = noisy
	new_mob.selective_preference = selective_preference
	new_mob.appendage_color = appendage_color
	new_mob.appendage_alt_setting = appendage_alt_setting
	new_mob.drop_vore = drop_vore
	new_mob.stumble_vore = stumble_vore
	new_mob.slip_vore = slip_vore
	new_mob.throw_vore = throw_vore
	new_mob.food_vore = food_vore
	new_mob.resizable = resizable
	new_mob.show_vore_fx = show_vore_fx
	new_mob.step_mechanics_pref = step_mechanics_pref
	new_mob.pickup_pref = pickup_pref
	new_mob.vore_taste = vore_taste
	new_mob.vore_smell = vore_smell
	new_mob.nutrition_message_visible = nutrition_message_visible
	new_mob.allow_spontaneous_tf = allow_spontaneous_tf
	new_mob.eating_privacy_global = eating_privacy_global
	new_mob.allow_mimicry = allow_mimicry
	new_mob.text_warnings = text_warnings
	new_mob.allow_mind_transfer = allow_mind_transfer
