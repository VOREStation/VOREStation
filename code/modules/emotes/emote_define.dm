// Note about emote messages:
// - USER / TARGET will be replaced with the relevant name, in bold.
// - USER_THEM / TARGET_THEM / USER_THEIR / TARGET_THEIR will be replaced with a
//   gender-appropriate version of the same.
// - Impaired messages do not do any substitutions.

var/global/list/emotes_by_key

/proc/get_emote_by_key(var/key)
	if(!global.emotes_by_key)
		decls_repository.get_decls_of_type(/decl/emote) // emotes_by_key will be updated in emote Initialize()
	return global.emotes_by_key[key]

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
	var/emote_delay = 1.2 SECONDS                       // Time in ds that this emote will block further emote use (spam prevention). // VOREStation Edit

	var/broadcast_sound                                 // This sound will be passed to the entire connected z-chunk if set.
	var/broadcast_sound_synthetic                       // As above but for synthetics.
	var/broadcast_volume = 15                           // Volume for broadcast sound.
	var/broadcast_distance                              // How far does the sound broadcast.

	var/message_type = VISIBLE_MESSAGE                  // Audible/visual flag
	var/check_restraints                                // Can this emote be used while restrained?
	var/check_range                                     // falsy, or a range outside which the emote will not work
	var/conscious = TRUE                                // Do we need to be awake to emote this?
	var/emote_range = 0                                 // If >0, restricts emote visibility to viewers within range.
	
	var/sound_preferences = list(/datum/client_preference/emote_noises) // Default emote sound_preferences is just emote_noises. Belch emote overrides this list for pref-checks.
	var/sound_vary = FALSE

	var/emote_cooldown                                  // How long will we be on cooldown for this emote.
	var/list/emote_cooldowns = list()                   // Assoc list of weakref to mob to next emote.

/decl/emote/Initialize()
	. = ..()
	if(key)
		LAZYSET(global.emotes_by_key, key, src)

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
	var/synth = check_synthetic(user)
	if(synth && emote_sound_synthetic)
		. = list(
			"sound" = emote_sound_synthetic,
			"vol" =   emote_volume_synthetic
		)
	else if(emote_sound)
		. = list(
			"sound" = emote_sound,
			"vol" =   emote_volume
		)

	if(synth && broadcast_sound_synthetic)
		LAZYINITLIST(.)
		.["broadcast"] = broadcast_sound_synthetic
	else if(broadcast_sound)
		LAZYINITLIST(.)
		.["broadcast"] = broadcast_sound

/decl/emote/proc/do_emote(var/atom/user, var/extra_params)

	if(ismob(user) && check_restraints)
		var/mob/M = user
		if(M.restrained())
			to_chat(user, SPAN_WARNING("You are restrained and cannot do that."))
			return

	if(emote_cooldown)
		var/user_ref = "\ref[user]"
		var/next_emote = emote_cooldowns[user_ref]
		if(world.time < next_emote)
			to_chat(user, SPAN_WARNING("You cannot use this emote again for another [round((next_emote - world.time)/(1 SECOND))] second\s."))
			return FALSE
		emote_cooldowns[user_ref] = (world.time + emote_cooldown)

	var/atom/target
	if(can_target() && extra_params)
		var/target_dist
		extra_params = trim(lowertext(extra_params))
		for(var/atom/thing in view((isnull(check_range) ? world.view : check_range), user))

			if(!isturf(thing.loc))
				continue

			var/new_target_dist = get_dist(thing, user)
			if(!isnull(target_dist) && target_dist > new_target_dist)
				continue

			if(findtext(lowertext(thing.name), extra_params))
				target_dist = new_target_dist
				target = thing

		if(!target)
			to_chat(user, SPAN_WARNING("You cannot see a '[extra_params]' within range."))
			return

	var/use_1p = get_emote_message_1p(user, target, extra_params)
	if(use_1p)
		if(target)
			use_1p = replace_target_tokens(use_1p, target)
		use_1p = "<span class='emote'>[capitalize(replace_user_tokens(use_1p, user))]</span>"
	var/prefinal_3p
	var/use_3p
	var/raw_3p = get_emote_message_3p(user, target, extra_params)
	if(raw_3p)
		if(target)
			raw_3p = replace_target_tokens(raw_3p, target)
		prefinal_3p = replace_user_tokens(raw_3p, user)
		use_3p = "<span class='emote'><b>\The [user]</b> [prefinal_3p]</span>"
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
					M.visible_message(message = "[user] opens their mouth silently!", self_message = "You cannot say anything!", blind_message = emote_message_impaired, runemessage = "opens their mouth silently!")
					return
				else
					M.audible_message(message = use_3p, self_message = use_1p, deaf_message = emote_message_impaired, hearing_distance = use_range, radio_message = use_radio, runemessage = prefinal_3p)
		else
			M.visible_message(message = use_3p, self_message = use_1p, blind_message = emote_message_impaired, range = use_range, runemessage = prefinal_3p)

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

	var/turf/user_turf = get_turf(user)
	if(!istype(user_turf))
		return

	var/list/use_sound = get_emote_sound(user)
	if(!islist(use_sound) || length(use_sound) < 2)
		return

	var/sound_to_play = use_sound["sound"]
	if(sound_to_play)
<<<<<<< HEAD
		playsound(user.loc, sound_to_play, use_sound["vol"], sound_vary, frequency = null, preference = sound_preferences) //VOREStation Add - Preference
=======
		if(islist(sound_to_play))
			if(sound_to_play[user.gender])
				sound_to_play = sound_to_play[user.gender]
			if(islist(sound_to_play) && length(sound_to_play))
				sound_to_play = pick(sound_to_play)
		if(sound_to_play)
			playsound(user.loc, sound_to_play, use_sound["vol"], 0)

	var/sound_to_broadcast = use_sound["broadcast"]
	if(!sound_to_broadcast)
		return

	// We can't always use GetConnectedZlevels() here because it includes horizontally connected z-levels, which don't work well with our distance checking.
	var/list/affected_levels
	if(isnull(broadcast_distance))
		affected_levels = GetConnectedZlevels(user_turf.z)
	else
		affected_levels = list(user_turf.z)
		// Climb to the top of the stack.
		var/turf/checking = user_turf
		while(checking && HasAbove(checking.z))
			checking = GetAbove(checking)
			affected_levels += checking.z
		// Fall to the bottom of the stack.
		checking = user_turf
		while(checking && HasBelow(checking.z))
			checking = GetBelow(checking)
			affected_levels += checking.z

	var/list/close_listeners = hearers(world.view, user_turf)
	for(var/listener in player_list)
		var/turf/T = get_turf(listener)
		if(!istype(T) || !(T.z in affected_levels) || (listener in close_listeners))
			continue
		var/turf/reference_point = locate(T.x, T.y, user_turf.z)
		if(!reference_point)
			continue
		var/direction = get_dir(reference_point, user_turf)
		if(!direction)
			continue
		if(!isnull(broadcast_distance) && get_dist(reference_point, user_turf) > broadcast_distance)
			continue
		broadcast_emote_to(sound_to_broadcast, listener, direction)

/decl/emote/proc/broadcast_emote_to(var/send_sound, var/mob/target, var/direction)
	var/turf/sound_origin = get_turf(target)
	target.playsound_local(get_step(sound_origin, direction) || sound_origin, send_sound, broadcast_volume)
	return TRUE
>>>>>>> 8ce2659f02a... Merge pull request #8693 from MistakeNot4892/doggo

/decl/emote/proc/mob_can_use(var/mob/user)
	return istype(user) && user.stat != DEAD && (type in user.get_available_emotes())

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
