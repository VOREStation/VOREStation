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
		M.soulgem.transfer_self(src) // Soulcatcher

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
	if(soulgem) //Should always be the case, but...Safety. Done here first
		soulgem.transfer_self(ourmob)
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
	if(tf_mob_holder.loc != src) return // Prevent bodyswapped creatures having their life linked
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
	new_mob.appendage_color = appendage_color
	new_mob.appendage_alt_setting = appendage_alt_setting
	new_mob.text_warnings = text_warnings

	VORE_PREF_TRANSFER(new_mob, src)
