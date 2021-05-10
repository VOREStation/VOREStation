// Note about emote messages:
// - USER / TARGET will be replaced with the relevant name, in bold.
// - USER_THEM / TARGET_THEM / USER_THEIR / TARGET_THEIR will be replaced with a
//   gender-appropriate version of the same.
// - Impaired messages do not do any substitutions.

/decl/emote
	var/key                                             // Command to use emote ie. '*[key]'
	var/emote_message_1p                                // First person message ('You do a flip!')
	var/emote_message_3p                                // Third person message ('Urist McBackflip does a flip!')
	var/emote_message_synthetic_1p                      // First person message for robits.
	var/emote_message_synthetic_3p                      // Third person message for robits.

	var/emote_message_impaired                          // Deaf/blind message ('You hear someone flipping out.', 'You see someone opening and closing their mouth')

	var/emote_message_1p_target                         // 'You do a flip at Urist McTarget!'
	var/emote_message_3p_target                         // 'Urist McShitter does a flip at Urist McTarget!'
	var/emote_message_synthetic_1p_target               // First person targeted message for robits.
	var/emote_message_synthetic_3p_target               // Third person targeted message for robits.

	var/emote_message_radio                             // A message to send over the radio if one picks up this emote.
	var/emote_message_radio_synthetic                   // As above, but for synthetics.
	var/emote_message_muffled                           // A message to show if the emote is audible and the user is muzzled.

	var/list/emote_sound                                // A sound for the emote to play. 
	                                                    // Can either be a single sound, a list of sounds to pick from, or an 
	                                                    // associative array of gender to single sounds/a list of sounds.
	var/list/emote_sound_synthetic                      // As above, but used when check_synthetic() is true.
	var/emote_volume = 50                               // Volume of sound to play.
	var/emote_volume_synthetic = 50                     // As above, but used when check_synthetic() is true.

	var/message_type = VISIBLE_MESSAGE                  // Audible/visual flag
	var/check_restraints                                // Can this emote be used while restrained?
	var/check_range                                     // falsy, or a range outside which the emote will not work
	var/conscious = TRUE                                // Do we need to be awake to emote this?
	var/emote_range = 0                                 // If >0, restricts emote visibility to viewers within range.

/decl/emote/proc/get_emote_message_1p(var/atom/user, var/atom/target, var/extra_params)
	if(target)
		if(emote_message_synthetic_1p_target && check_synthetic(user))
			return emote_message_synthetic_1p_target
		return emote_message_1p_target
	if(emote_message_synthetic_1p && check_synthetic(user))
		return emote_message_synthetic_1p
	return emote_message_1p

/decl/emote/proc/get_emote_message_3p(var/atom/user, var/atom/target, var/extra_params)
	if(target)
		if(emote_message_synthetic_3p_target && check_synthetic(user))
			return emote_message_synthetic_3p_target
		return emote_message_3p_target
	if(emote_message_synthetic_3p && check_synthetic(user))
		return emote_message_synthetic_3p
	return emote_message_3p

/decl/emote/proc/get_emote_sound(var/atom/user)
	if(check_synthetic(user) && emote_sound_synthetic)
		return list(
			"sound" = emote_sound_synthetic,
			"vol" =   emote_volume_synthetic
		)
	if(emote_sound)
		return list(
			"sound" = emote_sound,
			"vol" =   emote_volume
		)

/decl/emote/proc/do_emote(var/atom/user, var/extra_params)
	if(ismob(user) && check_restraints)
		var/mob/M = user
		if(M.restrained())
			to_chat(user, SPAN_WARNING("You are restrained and cannot do that."))
			return

	var/atom/target
	if(can_target() && extra_params)
		extra_params = lowertext(extra_params)
		for(var/atom/thing in view(user))
			if(extra_params == lowertext(thing.name))
				target = thing
				break

	if(target && target != user && check_range)
		if (get_dist(user, target) > check_range)
			to_chat(user, SPAN_WARNING("\The [target] is too far away."))
			return

	var/use_1p = get_emote_message_1p(user, target, extra_params)
	if(use_1p)
		if(target)
			use_1p = replace_target_tokens(use_1p, target)
		use_1p = "<span class='emote'>[capitalize(replace_user_tokens(use_1p, user))]</span>"
	var/use_3p = get_emote_message_3p(user, target, extra_params)
	if(use_3p)
		if(target)
			use_3p = replace_target_tokens(use_3p, target)
		use_3p = "<span class='emote'><b>\The [user]</b> [replace_user_tokens(use_3p, user)]</span>"
	var/use_radio = get_radio_message(user)
	if(use_radio)
		if(target)
			use_radio = replace_target_tokens(use_radio, target)
		use_radio = replace_user_tokens(use_radio, user)

	var/use_range = emote_range
	if (!use_range)
		use_range = world.view

	if(ismob(user))
		var/mob/M = user
		if(message_type == AUDIBLE_MESSAGE)
			if(isliving(user))
				var/mob/living/L = user
				if(L.silent)
					M.visible_message(message = "[user] opens their mouth silently!", self_message = "You cannot say anything!", blind_message = emote_message_impaired)
					return
				else
					M.audible_message(message = use_3p, self_message = use_1p, deaf_message = emote_message_impaired, hearing_distance = use_range, radio_message = use_radio)
		else
			M.visible_message(message = use_3p, self_message = use_1p, blind_message = emote_message_impaired, range = use_range)

	do_extra(user, target)
	do_sound(user)

/decl/emote/proc/replace_target_tokens(var/msg, var/atom/target)
	. = msg
	if(istype(target))
		var/datum/gender/target_gender = gender_datums[target.get_visible_gender()]
		. = replacetext(., "TARGET_THEM",  target_gender.him)
		. = replacetext(., "TARGET_THEIR", target_gender.his)
		. = replacetext(., "TARGET_SELF",  target_gender.himself)
		. = replacetext(., "TARGET",       "<b>\the [target]</b>")

/decl/emote/proc/replace_user_tokens(var/msg, var/atom/user)
	. = msg
	if(istype(user))
		var/datum/gender/user_gender = gender_datums[user.get_visible_gender()]
		. = replacetext(., "USER_THEM",  user_gender.him)
		. = replacetext(., "USER_THEIR", user_gender.his)
		. = replacetext(., "USER_SELF",  user_gender.himself)
		. = replacetext(., "USER",       "<b>\the [user]</b>")

/decl/emote/proc/get_radio_message(var/atom/user)
	if(emote_message_radio_synthetic && check_synthetic(user))
		return emote_message_radio_synthetic
	return emote_message_radio

/decl/emote/proc/do_extra(var/atom/user, var/atom/target)
	return

/decl/emote/proc/do_sound(var/atom/user)
	var/list/use_sound = get_emote_sound(user)
	if(!islist(use_sound) || length(use_sound) < 2)
		return
	var/sound_to_play = use_sound["sound"]
	if(!sound_to_play)
		return
	if(islist(sound_to_play))
		if(sound_to_play[user.gender])
			sound_to_play = sound_to_play[user.gender]
		if(islist(sound_to_play) && length(sound_to_play))
			sound_to_play = pick(sound_to_play)
	if(sound_to_play)
		playsound(user.loc, sound_to_play, use_sound["vol"], 0, preference = /datum/client_preference/emote_noises) //VOREStation Add - Preference

/decl/emote/proc/check_user(var/atom/user)
	return TRUE

/decl/emote/proc/can_target()
	return (emote_message_1p_target || emote_message_3p_target)

/decl/emote/dd_SortValue()
	return key

/decl/emote/proc/check_synthetic(var/mob/living/user)
	. = istype(user) && user.isSynthetic()
	if(!. && ishuman(user) && message_type == AUDIBLE_MESSAGE)
		var/mob/living/carbon/human/H = user
		if(H.should_have_organ(O_LUNGS))
			var/obj/item/organ/internal/lungs/L = H.internal_organs_by_name[O_LUNGS]
			if(L && L.robotic == 2)	//Hard-coded to 2, incase we add lifelike robotic lungs
				. = TRUE
