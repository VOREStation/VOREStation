/decl/emote/audible/whistle
	key = "whistle"
	emote_message_1p = "You whistle a tune."
	emote_message_3p = "whistles a tune."
	emote_sound = 'sound/voice/longwhistle.ogg'
	emote_message_muffled = "makes a light spitting noise, a poor attempt at a whistle."
	emote_sound_synthetic = 'sound/voice/longwhistle_robot.ogg'
	emote_message_synthetic_1p = "You whistle a robotic tune."
	emote_message_synthetic_3p = "whistles a robotic tune."

/decl/emote/audible/whistle/quiet
	key = "qwhistle"
	emote_message_1p = "You whistle quietly."
	emote_message_3p = "whistles quietly."
	emote_sound = 'sound/voice/shortwhistle.ogg'
	emote_message_synthetic_1p = "You whistle robotically."
	emote_message_synthetic_3p = "whistles robotically."
	emote_sound_synthetic = 'sound/voice/shortwhistle_robot.ogg'

/decl/emote/audible/whistle/wolf
	key = "wwhistle"
	emote_message_1p = "You whistle inappropriately."
	emote_message_3p = "whistles inappropriately."
	emote_sound = 'sound/voice/wolfwhistle.ogg'
	emote_message_synthetic_1p = "You beep inappropriately."
	emote_message_synthetic_3p = "beeps inappropriately."
	emote_sound_synthetic = 'sound/voice/wolfwhistle_robot.ogg'

/decl/emote/audible/whistle/summon
	key = "swhistle"
	emote_message_1p = "You whistle a tune."
	emote_message_3p = "whistles a tune."
	emote_sound = 'sound/voice/summon_whistle.ogg'
	emote_message_synthetic_1p = "You whistle a robotic tune."
	emote_message_synthetic_3p = "whistles a robotic tune."
	emote_sound_synthetic = 'sound/voice/summon_whistle_robot.ogg'
<<<<<<< HEAD
=======
	broadcast_sound = 'sound/voice/summon_whistle.ogg'
	broadcast_sound_synthetic = 'sound/voice/summon_whistle_robot.ogg'
	emote_cooldown = 20 SECONDS
	broadcast_distance = 65

/decl/emote/audible/whistle/summon/broadcast_emote_to(var/send_sound, var/mob/target, var/origin_z, var/direction)
	. = ..()
	if (.)
		var/turf/T = get_turf(target)
		if(!T || T.z == origin_z)
			to_chat(target, SPAN_NOTICE("You hear a piercing whistle from somewhere to the [dir2text(direction)]."))
		else if(T.z < origin_z)
			to_chat(target, SPAN_NOTICE("You hear a piercing whistle from somewhere above you, to the [dir2text(direction)]."))
		else
			to_chat(target, SPAN_NOTICE("You hear a piercing whistle from somewhere below you, to the [dir2text(direction)]."))
>>>>>>> 19d999bf63a... Merge pull request #8922 from MistakeNot4892/drakeemotes
