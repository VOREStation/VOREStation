/decl/emote/audible/synth
	key = "ping"
	emote_message_3p = "pings."
	emote_sound = 'sound/machines/ping.ogg'

/decl/emote/audible/synth/mob_can_use(var/mob/living/user)
	if(istype(user) && user.isSynthetic())
		return ..()
	return FALSE

/decl/emote/audible/synth/beep
	key = "beep"
	emote_message_3p = "beeps."
	emote_sound = 'sound/machines/twobeep.ogg'
	sound_vary = FALSE

/decl/emote/audible/synth/buzz
	key = "buzz"
	emote_message_3p = "buzzes."
	emote_sound = 'sound/machines/buzz-sigh.ogg'

/decl/emote/audible/synth/confirm
	key = "confirm"
	emote_message_3p = "emits an affirmative blip."
	emote_sound = 'sound/machines/synth_yes.ogg'

/decl/emote/audible/synth/deny
	key = "deny"
	emote_message_3p = "emits a negative blip."
	emote_sound = 'sound/machines/synth_no.ogg'

/decl/emote/audible/synth/scary
	key = "scary"
	emote_message_3p = "emits a disconcerting tone."
	emote_sound = 'sound/machines/synth_alert.ogg'

/decl/emote/audible/synth/security
	key = "law"
	emote_message_3p = "shows USER_THEIR legal authorization barcode."
	emote_message_3p_target = "shows TARGET USER_THEIR legal authorization barcode."
	emote_sound = 'sound/voice/biamthelaw.ogg'

/decl/emote/audible/synth/security/mob_can_use(var/mob/living/silicon/robot/user)
<<<<<<< HEAD
	return ..() && (istype(user) && (istype(user.module, /obj/item/weapon/robot_module/robot/security) || istype(user.module, /obj/item/weapon/robot_module/robot/knine))) //VOREStation Add - knine module
=======
	return ..() && istype(user) && istype(user.module, /obj/item/robot_module/robot/security)
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon

/decl/emote/audible/synth/security/halt
	key = "halt"
	emote_message_3p = "USER's speakers skreech, \"Halt! Security!\"."
	emote_sound = 'sound/voice/halt.ogg'

/decl/emote/audible/synth/dwoop
	key = "dwoop"
	emote_message_1p_target = "You chirp happily at TARGET!"
	emote_message_1p = "You chirp happily."
	emote_message_3p_target = "chirps happily at TARGET!"
	emote_message_3p = "chirps happily."
	emote_sound = 'sound/machines/dwoop.ogg'

/decl/emote/audible/synth/boop
	key = "roboboop"
	emote_message_1p_target = "You boop at TARGET!"
	emote_message_1p = "You boop."
	emote_message_3p_target = "boops at TARGET!"
	emote_message_3p = "boops."
	emote_sound = 'sound/voice/roboboop.ogg'
	sound_vary = TRUE

/decl/emote/audible/synth/robochirp
	key = "robochirp"
	emote_message_1p_target = "You chirp at TARGET!"
	emote_message_1p = "You chirp."
	emote_message_3p_target = "chirps at TARGET!"
	emote_message_3p = "chirps."
	emote_sound = 'sound/voice/robochirp.ogg'
	sound_vary = TRUE
