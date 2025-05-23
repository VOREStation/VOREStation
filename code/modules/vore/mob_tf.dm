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
		new /obj/effect/effect/teleport_greyscale(M.loc)
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
	if(ourmob.loc != src)
		if(isnull(ourmob.loc))
			to_chat(src,span_notice("You have no body."))
			tf_mob_holder = null
			return
		if(istype(ourmob.loc, /mob/living)) //Check for if body was transformed
			ourmob = ourmob.loc
		if(ourmob.ckey)
			if(ourmob.tf_mob_holder && ourmob.tf_mob_holder == src)
				//Body Swap
				var/datum/mind/ourmind = src.mind
				var/datum/mind/theirmind = ourmob.mind
				ourmob.ghostize()
				src.ghostize()
				ourmob.mind = null
				src.mind = null
				ourmind.current = null
				theirmind.current = null
				ourmind.active = TRUE
				ourmind.transfer_to(ourmob)
				theirmind.active = TRUE
				theirmind.transfer_to(src)
				ourmob.tf_mob_holder = null
				src.tf_mob_holder = null
			else
				to_chat(src,span_notice("Your body appears to be in someone else's control."))
			return
		src.mind.transfer_to(ourmob)
		tf_mob_holder = null
		return
	new /obj/effect/effect/teleport_greyscale(src.loc)
	if(ourmob.ai_holder)
		var/datum/ai_holder/our_AI = ourmob.ai_holder
		our_AI.set_stance(STANCE_IDLE)
	tf_mob_holder = null
	ourmob.ckey = ckey
	var/turf/get_dat_turf = get_turf(src)
	ourmob.loc = get_dat_turf
	ourmob.forceMove(get_dat_turf)
	if(!tf_form_ckey)
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

	if(tf_form == ourmob)
		if(tf_form_ckey)
			src.ckey = tf_form_ckey
		else
			src.mind = null
		ourmob.tf_form = src
		src.forceMove(ourmob)
	else
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

// Requires a /mob/living type path for transformation. Returns the new mob on success, null in all other cases.
// Just handles mob TF right now, but maybe we'll want to do something similar for items in the future.
/mob/living/proc/transform_into_mob(mob/living/new_form, pref_override = FALSE, revert = FALSE, shapeshifting = FALSE)
	if(!src.mind)
		return
	if(!src.allow_spontaneous_tf && !pref_override)
		return
	if(src.tf_mob_holder) //If we're already transformed
		if(revert)
			revert_mob_tf()
			return
		else
			return
	else
		if(src.stat == DEAD)
			return
		if(!ispath(new_form, /mob/living) && !ismob(new_form))
			return
		var/mob/living/new_mob
		if(shapeshifting && src.tf_form)
			new_mob = src.tf_form
			add_verb(new_mob,/mob/living/proc/shapeshift_form)
			new_mob.tf_form = src
			new_mob.forceMove(src.loc)
			visible_message(span_warning("[src] twists and contorts, shapeshifting into a different form!"))
			if(new_mob.ckey)
				new_mob.tf_form_ckey = new_mob.ckey
		else
			new_mob = new new_form(get_turf(src))

		if(new_mob && isliving(new_mob))
			new_mob.faction = src.faction
			if(istype(new_mob, /mob/living/simple_mob))
				var/mob/living/simple_mob/S = new_mob
				if(!S.voremob_loaded)
					S.voremob_loaded = TRUE
					S.init_vore()
			new /obj/effect/effect/teleport_greyscale(src.loc)
			if(!new_mob.ckey)
				for(var/obj/belly/B as anything in new_mob.vore_organs)
					new_mob.vore_organs -= B
					qdel(B)
				new_mob.vore_organs = list()
				new_mob.name = src.name
				new_mob.real_name = src.real_name
				for(var/lang in src.languages)
					new_mob.languages |= lang
				src.copy_vore_prefs_to_mob(new_mob)
				new_mob.vore_selected = src.vore_selected
				if(ishuman(src))
					var/mob/living/carbon/human/H = src
					if(ishuman(new_mob))
						var/mob/living/carbon/human/N = new_mob
						N.gender = H.gender
						N.identifying_gender = H.identifying_gender
					else
						new_mob.gender = H.gender
				else
					new_mob.gender = src.gender
					if(ishuman(new_mob))
						var/mob/living/carbon/human/N = new_mob
						N.identifying_gender = src.gender

				for(var/obj/belly/B as anything in src.vore_organs)
					B.loc = new_mob
					B.forceMove(new_mob)
					B.owner = new_mob
					src.vore_organs -= B
					new_mob.vore_organs += B
				new_mob.nutrition = src.nutrition

				src.soulgem?.transfer_self(new_mob)

			new_mob.ckey = src.ckey
			if(new_mob.tf_form_ckey)
				src.ckey = new_mob.tf_form_ckey
			if(src.ai_holder && new_mob.ai_holder)
				var/datum/ai_holder/old_AI = src.ai_holder
				old_AI.set_stance(STANCE_SLEEP)
				var/datum/ai_holder/new_AI = new_mob.ai_holder
				new_AI.hostile = old_AI.hostile
				new_AI.retaliate = old_AI.retaliate
			src.loc = new_mob
			src.forceMove(new_mob)
			new_mob.tf_mob_holder = src
			return new_mob

// Used to check if THIS MOB has been transformed into a different mob, as only the NEW mob uses tf_mob_holder.
// Necessary in niche cases where a proc interacts with the old body and needs to know it's been transformed (such as transforming into a mob then dying in virtual reality).
// Use this if you cannot use the tf_mob_holder var. Returns TRUE if transformed, FALSE if not.
/mob/living/proc/tfed_into_mob_check()
	if(loc && isliving(loc))
		var/mob/living/M = loc
		if(istype(M) && M.tf_mob_holder && (M.tf_mob_holder == src))
			return TRUE
		else
			return FALSE
	else
		return FALSE

/mob/living/proc/shapeshift_form()
	set name = "Shapeshift Form"
	set category = "Abilities.Shapeshift"
	set desc = "Shape shift between set mob forms. (Requires a spawned mob to be varedited into the user's tf_form var as mob reference.)"
	if(!istype(tf_form))
		to_chat(src, span_notice("No shapeshift form set. (Requires a spawned mob to be varedited into the user's tf_form var as mob reference.)"))
		return
	else
		transform_into_mob(tf_form, TRUE, TRUE, TRUE)

/mob/living/set_dir(var/new_dir)
	. = ..()
	if(size_multiplier != 1 || icon_scale_x != 1 && center_offset > 0)
		update_transform(TRUE)
