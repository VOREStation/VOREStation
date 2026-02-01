//Handle a mob struggling
// Called from /mob/living/carbon/relaymove()
/obj/belly/proc/relay_resist(mob/living/living_prey, obj/item/prey_item)
	if (!(living_prey in contents))
		if(!prey_item)
			return  // User is not in this belly

	living_prey.setClickCooldown(50)

	if(owner.stat) //If owner is stat (dead, KO) we can actually escape
		resist_default_escape(living_prey, prey_item)
		return

	if(displayed_message_flags & MS_FLAG_STRUGGLE_OUTSIDE)
		resist_struggle_outside(living_prey)

	if((vore_sprite_flags & DM_FLAG_VORESPRITE_BELLY) && (owner.vore_capacity_ex[belly_sprite_to_affect] >= 1) && !private_struggle && resist_triggers_animation && affects_vore_sprites)
		owner.vs_animate(belly_sprite_to_affect)

	if(!private_struggle)
		resist_play_sound()

	if (prob(belchchance) && (escapable != B_ESCAPABLE_INTENT || (living_prey.a_intent == I_HELP && escapable == B_ESCAPABLE_INTENT)))
		owner.emote("belch")

	if(!escapable) //If the stomach has escapable enabled.
		var/struggle_user_message = span_valert(belly_format_string(struggle_messages_inside, living_prey))
		to_chat(living_prey, struggle_user_message)
		return

	if(escapable == B_ESCAPABLE_INTENT)
		switch(living_prey.a_intent)
			if(I_HURT)
				if(resist_check_escapechance(living_prey, prey_item))
					return
			if(I_DISARM)
				if(resist_check_transferchance(living_prey, prey_item))
					return
				if(resist_check_secondary_transferchance(living_prey,prey_item))
					return
			if(I_GRAB)
				if(resist_check_absorbchance(living_prey))
					return
				if(resist_check_digestchance(living_prey))
					return
				if(resist_check_selectchance(living_prey))
					return
	else
		if(resist_check_escapechance(living_prey, prey_item))
			return
		if(resist_check_transferchance(living_prey, prey_item))
			return
		if(resist_check_secondary_transferchance(living_prey,prey_item))
			return
		if(resist_check_absorbchance(living_prey))
			return
		if(resist_check_digestchance(living_prey))
			return
		if(resist_check_selectchance(living_prey))
			return

	var/struggle_user_message = span_valert(belly_format_string(struggle_messages_inside, living_prey))
	to_chat(living_prey, struggle_user_message)
	to_chat(owner, span_vwarning("Your prey appears to be unable to make any progress in escaping your [lowertext(name)]."))

/obj/belly/proc/resist_default_escape(mob/living/living_prey, obj/item/prey_item)
	var/escape_attempt_owner_message = span_vwarning(belly_format_string(escape_attempt_messages_owner, living_prey))
	var/escape_attempt_prey_message = span_vwarning(belly_format_string(escape_attempt_messages_prey, living_prey))
	var/escape_fail_owner_message = span_vwarning(belly_format_string(escape_fail_messages_owner, living_prey))
	var/escape_fail_prey_message = span_vnotice(belly_format_string(escape_fail_messages_prey, living_prey))
	escape_attempt_prey_message = span_vwarning("[escape_attempt_prey_message] (will take around [escapetime/10] seconds.)")
	to_chat(living_prey, escape_attempt_prey_message)
	to_chat(owner, escape_attempt_owner_message)

	if(do_after(living_prey, escapetime, owner, target = src, timed_action_flags = IGNORE_INCAPACITATED))
		if((owner.stat || escapable)) //Can still escape?
			if(prey_item)
				release_specific_contents(prey_item)
				return

			if(living_prey.loc == src)
				release_specific_contents(living_prey)
				return

		if(living_prey.loc != src) //Aren't even in the belly. Quietly fail.
			return

	//Belly became inescapable or mob revived
	to_chat(living_prey, escape_fail_prey_message)
	to_chat(owner, escape_fail_owner_message)

/obj/belly/proc/resist_struggle_outside(mob/living/living_prey)
	var/struggle_outer_message = span_valert(belly_format_string(struggle_messages_outside, living_prey))
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

/obj/belly/proc/resist_check_escapechance(mob/living/living_prey, obj/item/prey_item)
	if(!prob(escapechance)) //Let's have it check to see if the prey escapes first.
		return FALSE

	var/escape_attempt_owner_message = span_vwarning(belly_format_string(escape_attempt_messages_owner, living_prey))
	var/escape_attempt_prey_message = span_vwarning(belly_format_string(escape_attempt_messages_prey, living_prey))
	var/escape_fail_owner_message = span_vwarning(belly_format_string(escape_fail_messages_owner, living_prey))
	var/escape_fail_prey_message = span_vnotice(belly_format_string(escape_fail_messages_prey, living_prey))
	to_chat(living_prey, escape_attempt_prey_message)
	to_chat(owner, escape_attempt_owner_message)
	if(do_after(living_prey, escapetime, target = src))
		if(escapable && prey_item)
			var/escape_item_owner_message = span_vwarning(belly_format_string(escape_item_messages_owner, living_prey, item = prey_item))
			var/escape_item_prey_message = span_vwarning(belly_format_string(escape_item_messages_prey, living_prey, item = prey_item))
			var/escape_item_outside_message = span_vwarning(belly_format_string(escape_item_messages_outside, living_prey, item = prey_item))

			release_specific_contents(prey_item)
			to_chat(living_prey, escape_item_prey_message)
			to_chat(owner, escape_item_owner_message)
			if(!private_struggle)
				for(var/mob/M in hearers(4, owner))
					M.show_message(escape_item_outside_message, 2)
			return TRUE

		if(escapable && (living_prey.loc == src) && !living_prey.absorbed) //Does the owner still have escapable enabled?
			var/escape_owner_message = span_vwarning(belly_format_string(escape_messages_owner, living_prey))
			var/escape_prey_message = span_vwarning(belly_format_string(escape_messages_prey, living_prey))
			var/escape_outside_message = span_vwarning(belly_format_string(escape_messages_outside, living_prey))

			release_specific_contents(living_prey)
			to_chat(living_prey, escape_prey_message)
			to_chat(owner, escape_owner_message)
			if(!private_struggle)
				for(var/mob/M in hearers(4, owner))
					M.show_message(escape_outside_message, 2)
			return TRUE

		if(!(living_prey.loc == src)) //Aren't even in the belly. Quietly fail.
			return TRUE

		//Belly became inescapable.
		to_chat(living_prey, escape_fail_prey_message)
		to_chat(owner, escape_fail_owner_message)
		return TRUE

/obj/belly/proc/resist_check_transferchance(mob/living/living_prey, obj/item/prey_item)
	if(!prob(transferchance) || !transferlocation) //Next, let's have it see if they end up getting into an even bigger mess then when they started.
		return FALSE

	var/obj/belly/dest_belly
	for(var/obj/belly/current_belly as anything in owner.vore_organs)
		if(current_belly.name == transferlocation)
			dest_belly = current_belly
			break

	if(!dest_belly)
		to_chat(owner, span_vwarning("Something went wrong with your belly transfer settings. Your <b>[lowertext(name)]</b> has had it's transfer chance and transfer location cleared as a precaution."))
		transferchance = 0
		transferlocation = null
		return TRUE

	var/primary_transfer_owner_message = span_vwarning(belly_format_string(primary_transfer_messages_owner, living_prey, dest = transferlocation))
	var/primary_transfer_prey_message = span_vwarning(belly_format_string(primary_transfer_messages_prey, living_prey, dest = transferlocation))

	to_chat(living_prey, primary_transfer_prey_message)
	to_chat(owner, primary_transfer_owner_message)
	if(prey_item)
		transfer_contents(prey_item, dest_belly)
		return TRUE

	transfer_contents(living_prey, dest_belly)
	return TRUE

/obj/belly/proc/resist_check_secondary_transferchance(mob/living/living_prey, obj/item/prey_item)
	if(!prob(transferchance_secondary) || !transferlocation_secondary) //After the first potential mess getting into, run the secondary one which might be even bigger of a mess.
		return FALSE

	var/obj/belly/dest_belly
	for(var/obj/belly/current_belly as anything in owner.vore_organs)
		if(current_belly.name == transferlocation_secondary)
			dest_belly = current_belly
			break

	if(!dest_belly)
		to_chat(owner, span_vwarning("Something went wrong with your belly transfer settings. Your <b>[lowertext(name)]</b> has had it's transfer chance and transfer location cleared as a precaution."))
		transferchance_secondary = 0
		transferlocation_secondary = null
		return TRUE

	var/secondary_transfer_owner_message = span_vwarning(belly_format_string(secondary_transfer_messages_owner, living_prey, dest = transferlocation_secondary))
	var/secondary_transfer_prey_message = span_vwarning(belly_format_string(secondary_transfer_messages_prey, living_prey, dest = transferlocation_secondary))

	to_chat(living_prey, secondary_transfer_prey_message)
	to_chat(owner, secondary_transfer_owner_message)
	if(prey_item)
		transfer_contents(prey_item, dest_belly)
		return TRUE

	transfer_contents(living_prey, dest_belly)
	return TRUE

/obj/belly/proc/resist_check_absorbchance(mob/living/living_prey)
	if(!prob(absorbchance) || digest_mode == DM_ABSORB) //After that, let's have it run the absorb chance.
		return FALSE
	var/absorb_chance_owner_message = span_vwarning(belly_format_string(absorb_chance_messages_owner, living_prey))
	var/absorb_chance_prey_message = span_vwarning(belly_format_string(absorb_chance_messages_prey, living_prey))

	to_chat(living_prey, absorb_chance_prey_message)
	to_chat(owner, absorb_chance_owner_message)
	digest_mode = DM_ABSORB
	return TRUE

/obj/belly/proc/resist_check_digestchance(mob/living/living_prey)
	if(!prob(digestchance) || digest_mode == DM_DIGEST) //Then, let's see if it should run the digest chance.
		return FALSE
	var/digest_chance_owner_message = span_vwarning(belly_format_string(digest_chance_messages_owner, living_prey))
	var/digest_chance_prey_message = span_vwarning(belly_format_string(digest_chance_messages_prey, living_prey))

	to_chat(living_prey, digest_chance_prey_message)
	to_chat(owner, digest_chance_owner_message)
	digest_mode = DM_DIGEST
	return TRUE

/obj/belly/proc/resist_check_selectchance(mob/living/living_prey)
	if(!prob(selectchance) || digest_mode == DM_SELECT) //Finally, let's see if it should run the selective mode chance.
		return FALSE
	var/select_chance_owner_message = span_vwarning(belly_format_string(select_chance_messages_owner, living_prey))
	var/select_chance_prey_message = span_vwarning(belly_format_string(select_chance_messages_prey, living_prey))

	to_chat(living_prey, select_chance_prey_message)
	to_chat(owner, select_chance_owner_message)
	digest_mode = DM_SELECT
	return TRUE

// Absorbed resist handling
/obj/belly/proc/relay_absorbed_resist(mob/living/living_prey)
	if (!(living_prey in contents) || !living_prey.absorbed)
		return  // User is not in this belly or isn't actually absorbed

	living_prey.setClickCooldown(50)

	if(displayed_message_flags & MS_FLAG_STRUGGLE_ABSORBED_OUTSIDE)
		absorbed_resist_struggle_outside(living_prey)

	if(!private_struggle)
		resist_play_sound()

	//absorb resists
	if(escapable || owner.stat) //If the stomach has escapable enabled or the owner is dead/unconscious
		if(absorbed_resist_check_escapechance(living_prey))
			return

	var/struggle_user_message = span_valert(belly_format_string(absorbed_struggle_messages_inside, living_prey, use_absorbed_count = TRUE))
	to_chat(living_prey, struggle_user_message)

/obj/belly/proc/absorbed_resist_struggle_outside(mob/living/living_prey)
	var/struggle_outer_message = span_valert(belly_format_string(absorbed_struggle_messages_outside, living_prey, use_absorbed_count = TRUE))
	if(private_struggle)
		to_chat(owner, struggle_outer_message)
		return

	for(var/mob/M in hearers(4, owner))
		M.show_message(struggle_outer_message, 2) // hearable

/obj/belly/proc/absorbed_resist_check_escapechance(mob/living/living_prey)
	if(!(prob(escapechance_absorbed) || owner.stat)) //Let's have it check to see if the prey's escape attempt starts.
		return FALSE
	var/escape_attempt_absorbed_owner_message = span_vwarning(belly_format_string(escape_attempt_absorbed_messages_owner, living_prey))
	var/escape_attempt_absorbed_prey_message = span_vwarning(belly_format_string(escape_attempt_absorbed_messages_prey, living_prey))

	to_chat(living_prey, escape_attempt_absorbed_prey_message)
	to_chat(owner, escape_attempt_absorbed_owner_message)
	if(do_after(living_prey, escapetime, target = src))
		if((escapable || owner.stat) && (living_prey.loc == src) && prob(escapechance_absorbed)) //Does the escape attempt succeed?
			var/escape_absorbed_owner_message = span_vwarning(belly_format_string(escape_absorbed_messages_owner, living_prey))
			var/escape_absorbed_prey_message = span_vwarning(belly_format_string(escape_absorbed_messages_prey, living_prey))
			var/escape_absorbed_outside_message = span_vwarning(belly_format_string(escape_absorbed_messages_outside, living_prey))

			release_specific_contents(living_prey)
			to_chat(living_prey, escape_absorbed_prey_message)
			to_chat(owner, escape_absorbed_owner_message)
			if(!private_struggle)
				for(var/mob/M in hearers(4, owner))
					M.show_message(escape_absorbed_outside_message, 2)
			return TRUE

		if(!(living_prey.loc == src)) //Aren't even in the belly. Quietly fail.
			return TRUE

		//Belly became inescapable or you failed your roll.
		var/escape_fail_absorbed_owner_message = span_vwarning(belly_format_string(escape_fail_absorbed_messages_owner, living_prey))
		var/escape_fail_absorbed_prey_message = span_vnotice(belly_format_string(escape_fail_absorbed_messages_prey, living_prey))

		to_chat(living_prey, escape_fail_absorbed_prey_message)
		to_chat(owner, escape_fail_absorbed_owner_message)
		return TRUE
