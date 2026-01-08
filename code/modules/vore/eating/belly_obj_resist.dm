//Handle a mob struggling
// Called from /mob/living/carbon/relaymove()
/obj/belly/proc/relay_resist(mob/living/R, obj/item/C)
	if (!(R in contents))
		if(!C)
			return  // User is not in this belly

	R.setClickCooldown(50)

	if(owner.stat) //If owner is stat (dead, KO) we can actually escape
		resist_default_escape(R, C)
		return

	if(displayed_message_flags & MS_FLAG_STRUGGLE_OUTSIDE)
		resist_struggle_outside(R)

	if((vore_sprite_flags & DM_FLAG_VORESPRITE_BELLY) && (owner.vore_capacity_ex[belly_sprite_to_affect] >= 1) && !private_struggle && resist_triggers_animation && affects_vore_sprites)
		owner.vs_animate(belly_sprite_to_affect)

	if(!private_struggle)
		resist_play_sound()

	if(prob(belchchance))//Unsure if this should go in escapable or not, leaving it here for now.
		owner.emote("belch")

	if(escapable) //If the stomach has escapable enabled.
		if(resist_check_escapechance(R, C))
			return
		if(resist_check_transferchance(R, C))
			return
		if(resist_check_secondary_transferchance(R,C))
			return
		if(resist_check_absorbchance(R))
			return
		if(resist_check_digestchance(R))
			return
		if(resist_check_selectchance(R))
			return

		var/struggle_user_message = span_valert(belly_format_string(struggle_messages_inside, R))
		to_chat(R, struggle_user_message)
		to_chat(owner, span_vwarning("Your prey appears to be unable to make any progress in escaping your [lowertext(name)]."))

		return

	var/struggle_user_message = span_valert(belly_format_string(struggle_messages_inside, R))
	to_chat(R, struggle_user_message)

/obj/belly/proc/resist_default_escape(mob/living/R, obj/item/C)
	var/escape_attempt_owner_message = span_vwarning(belly_format_string(escape_attempt_messages_owner, R))
	var/escape_attempt_prey_message = span_vwarning(belly_format_string(escape_attempt_messages_prey, R))
	var/escape_fail_owner_message = span_vwarning(belly_format_string(escape_fail_messages_owner, R))
	var/escape_fail_prey_message = span_vnotice(belly_format_string(escape_fail_messages_prey, R))
	escape_attempt_prey_message = span_vwarning("[escape_attempt_prey_message] (will take around [escapetime/10] seconds.)")
	to_chat(R, escape_attempt_prey_message)
	to_chat(owner, escape_attempt_owner_message)

	if(do_after(R, escapetime, owner, target = src, timed_action_flags = IGNORE_INCAPACITATED))
		if((owner.stat || escapable)) //Can still escape?
			if(C)
				release_specific_contents(C)
				return

			if(R.loc == src)
				release_specific_contents(R)
				return

		if(R.loc != src) //Aren't even in the belly. Quietly fail.
			return

	//Belly became inescapable or mob revived
	to_chat(R, escape_fail_prey_message)
	to_chat(owner, escape_fail_owner_message)

/obj/belly/proc/resist_struggle_outside(mob/living/R)
	var/struggle_outer_message = span_valert(belly_format_string(struggle_messages_outside, R))
	if(private_struggle)
		to_chat(owner, struggle_outer_message)
		return

	for(var/mob/M in hearers(4, owner))
		M.show_message(struggle_outer_message, 2) // hearable

/obj/belly/proc/resist_play_sound()
	if(is_wet)
		var/sound/struggle_snuggle
		if(!fancy_vore)
			struggle_snuggle = sound(get_sfx("classic_struggle_sounds"))
		else
			struggle_snuggle = sound(get_sfx("fancy_prey_struggle"))
		playsound(src, struggle_snuggle, vary = 1, vol = 75, falloff = VORE_SOUND_FALLOFF, frequency = noise_freq, preference = /datum/preference/toggle/digestion_noises, volume_channel = VOLUME_CHANNEL_VORE)
		return
	var/sound/struggle_rustle = sound(get_sfx("rustle"))
	playsound(src, struggle_rustle, vary = 1, vol = 75, falloff = VORE_SOUND_FALLOFF, frequency = noise_freq, preference = /datum/preference/toggle/digestion_noises, volume_channel = VOLUME_CHANNEL_VORE)

/obj/belly/proc/resist_check_escapechance(mob/living/R, obj/item/C)
	if(!prob(escapechance)) //Let's have it check to see if the prey escapes first.
		return FALSE

	var/escape_attempt_owner_message = span_vwarning(belly_format_string(escape_attempt_messages_owner, R))
	var/escape_attempt_prey_message = span_vwarning(belly_format_string(escape_attempt_messages_prey, R))
	var/escape_fail_owner_message = span_vwarning(belly_format_string(escape_fail_messages_owner, R))
	var/escape_fail_prey_message = span_vnotice(belly_format_string(escape_fail_messages_prey, R))
	to_chat(R, escape_attempt_prey_message)
	to_chat(owner, escape_attempt_owner_message)
	if(do_after(R, escapetime, target = src))
		if(escapable && C)
			var/escape_item_owner_message = span_vwarning(belly_format_string(escape_item_messages_owner, R, item = C))
			var/escape_item_prey_message = span_vwarning(belly_format_string(escape_item_messages_prey, R, item = C))
			var/escape_item_outside_message = span_vwarning(belly_format_string(escape_item_messages_outside, R, item = C))

			release_specific_contents(C)
			to_chat(R, escape_item_prey_message)
			to_chat(owner, escape_item_owner_message)
			if(!private_struggle)
				for(var/mob/M in hearers(4, owner))
					M.show_message(escape_item_outside_message, 2)
			return TRUE

		if(escapable && (R.loc == src) && !R.absorbed) //Does the owner still have escapable enabled?
			var/escape_owner_message = span_vwarning(belly_format_string(escape_messages_owner, R))
			var/escape_prey_message = span_vwarning(belly_format_string(escape_messages_prey, R))
			var/escape_outside_message = span_vwarning(belly_format_string(escape_messages_outside, R))

			release_specific_contents(R)
			to_chat(R, escape_prey_message)
			to_chat(owner, escape_owner_message)
			if(!private_struggle)
				for(var/mob/M in hearers(4, owner))
					M.show_message(escape_outside_message, 2)
			return TRUE

		if(!(R.loc == src)) //Aren't even in the belly. Quietly fail.
			return TRUE

		//Belly became inescapable.
		to_chat(R, escape_fail_prey_message)
		to_chat(owner, escape_fail_owner_message)
		return TRUE

/obj/belly/proc/resist_check_transferchance(mob/living/R, obj/item/C)
	if(!prob(transferchance) || !transferlocation) //Next, let's have it see if they end up getting into an even bigger mess then when they started.
		return FALSE

	var/obj/belly/dest_belly
	for(var/obj/belly/B as anything in owner.vore_organs)
		if(B.name == transferlocation)
			dest_belly = B
			break

	if(!dest_belly)
		to_chat(owner, span_vwarning("Something went wrong with your belly transfer settings. Your <b>[lowertext(name)]</b> has had it's transfer chance and transfer location cleared as a precaution."))
		transferchance = 0
		transferlocation = null
		return TRUE

	var/primary_transfer_owner_message = span_vwarning(belly_format_string(primary_transfer_messages_owner, R, dest = transferlocation))
	var/primary_transfer_prey_message = span_vwarning(belly_format_string(primary_transfer_messages_prey, R, dest = transferlocation))

	to_chat(R, primary_transfer_prey_message)
	to_chat(owner, primary_transfer_owner_message)
	if(C)
		transfer_contents(C, dest_belly)
		return TRUE

	transfer_contents(R, dest_belly)
	return TRUE

/obj/belly/proc/resist_check_secondary_transferchance(mob/living/R, obj/item/C)
	if(!prob(transferchance_secondary) || !transferlocation_secondary) //After the first potential mess getting into, run the secondary one which might be even bigger of a mess.
		return FALSE

	var/obj/belly/dest_belly
	for(var/obj/belly/B as anything in owner.vore_organs)
		if(B.name == transferlocation_secondary)
			dest_belly = B
			break

	if(!dest_belly)
		to_chat(owner, span_vwarning("Something went wrong with your belly transfer settings. Your <b>[lowertext(name)]</b> has had it's transfer chance and transfer location cleared as a precaution."))
		transferchance_secondary = 0
		transferlocation_secondary = null
		return TRUE

	var/secondary_transfer_owner_message = span_vwarning(belly_format_string(secondary_transfer_messages_owner, R, dest = transferlocation_secondary))
	var/secondary_transfer_prey_message = span_vwarning(belly_format_string(secondary_transfer_messages_prey, R, dest = transferlocation_secondary))

	to_chat(R, secondary_transfer_prey_message)
	to_chat(owner, secondary_transfer_owner_message)
	if(C)
		transfer_contents(C, dest_belly)
		return TRUE

	transfer_contents(R, dest_belly)
	return TRUE

/obj/belly/proc/resist_check_absorbchance(mob/living/R)
	if(!prob(absorbchance) || digest_mode == DM_ABSORB) //After that, let's have it run the absorb chance.
		return FALSE
	var/absorb_chance_owner_message = span_vwarning(belly_format_string(absorb_chance_messages_owner, R))
	var/absorb_chance_prey_message = span_vwarning(belly_format_string(absorb_chance_messages_prey, R))

	to_chat(R, absorb_chance_prey_message)
	to_chat(owner, absorb_chance_owner_message)
	digest_mode = DM_ABSORB
	return TRUE

/obj/belly/proc/resist_check_digestchance(mob/living/R)
	if(!prob(digestchance) || digest_mode == DM_DIGEST) //Then, let's see if it should run the digest chance.
		return FALSE
	var/digest_chance_owner_message = span_vwarning(belly_format_string(digest_chance_messages_owner, R))
	var/digest_chance_prey_message = span_vwarning(belly_format_string(digest_chance_messages_prey, R))

	to_chat(R, digest_chance_prey_message)
	to_chat(owner, digest_chance_owner_message)
	digest_mode = DM_DIGEST
	return TRUE

/obj/belly/proc/resist_check_selectchance(mob/living/R)
	if(!prob(selectchance) || digest_mode == DM_SELECT) //Finally, let's see if it should run the selective mode chance.
		return FALSE
	var/select_chance_owner_message = span_vwarning(belly_format_string(select_chance_messages_owner, R))
	var/select_chance_prey_message = span_vwarning(belly_format_string(select_chance_messages_prey, R))

	to_chat(R, select_chance_prey_message)
	to_chat(owner, select_chance_owner_message)
	digest_mode = DM_SELECT
	return TRUE

// Absorbed resist handling
/obj/belly/proc/relay_absorbed_resist(mob/living/R)
	if (!(R in contents) || !R.absorbed)
		return  // User is not in this belly or isn't actually absorbed

	R.setClickCooldown(50)

	if(displayed_message_flags & MS_FLAG_STRUGGLE_ABSORBED_OUTSIDE)
		absorbed_resist_struggle_outside(R)

	if(!private_struggle)
		resist_play_sound()

	//absorb resists
	if(escapable || owner.stat) //If the stomach has escapable enabled or the owner is dead/unconscious
		if(absorbed_resist_check_escapechance(R))
			return

	var/struggle_user_message = span_valert(belly_format_string(absorbed_struggle_messages_inside, R, use_absorbed_count = TRUE))
	to_chat(R, struggle_user_message)

/obj/belly/proc/absorbed_resist_struggle_outside(mob/living/R)
	var/struggle_outer_message = span_valert(belly_format_string(absorbed_struggle_messages_outside, R, use_absorbed_count = TRUE))
	if(private_struggle)
		to_chat(owner, struggle_outer_message)
		return

	for(var/mob/M in hearers(4, owner))
		M.show_message(struggle_outer_message, 2) // hearable

/obj/belly/proc/absorbed_resist_check_escapechance(mob/living/R)
	if(!(prob(escapechance_absorbed) || owner.stat)) //Let's have it check to see if the prey's escape attempt starts.
		return FALSE
	var/escape_attempt_absorbed_owner_message = span_vwarning(belly_format_string(escape_attempt_absorbed_messages_owner, R))
	var/escape_attempt_absorbed_prey_message = span_vwarning(belly_format_string(escape_attempt_absorbed_messages_prey, R))

	to_chat(R, escape_attempt_absorbed_prey_message)
	to_chat(owner, escape_attempt_absorbed_owner_message)
	if(do_after(R, escapetime, target = src))
		if((escapable || owner.stat) && (R.loc == src) && prob(escapechance_absorbed)) //Does the escape attempt succeed?
			var/escape_absorbed_owner_message = span_vwarning(belly_format_string(escape_absorbed_messages_owner, R))
			var/escape_absorbed_prey_message = span_vwarning(belly_format_string(escape_absorbed_messages_prey, R))
			var/escape_absorbed_outside_message = span_vwarning(belly_format_string(escape_absorbed_messages_outside, R))

			release_specific_contents(R)
			to_chat(R, escape_absorbed_prey_message)
			to_chat(owner, escape_absorbed_owner_message)
			if(!private_struggle)
				for(var/mob/M in hearers(4, owner))
					M.show_message(escape_absorbed_outside_message, 2)
			return TRUE

		if(!(R.loc == src)) //Aren't even in the belly. Quietly fail.
			return TRUE

		//Belly became inescapable or you failed your roll.
		var/escape_fail_absorbed_owner_message = span_vwarning(belly_format_string(escape_fail_absorbed_messages_owner, R))
		var/escape_fail_absorbed_prey_message = span_vnotice(belly_format_string(escape_fail_absorbed_messages_prey, R))

		to_chat(R, escape_fail_absorbed_prey_message)
		to_chat(owner, escape_fail_absorbed_owner_message)
		return TRUE
