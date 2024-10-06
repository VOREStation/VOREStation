/decl/emote/audible/slap
	key = "slap"
	emote_message_1p_target = "You slap TARGET across the face. Ouch!"
	emote_message_1p = "You slap yourself across the face!"
	emote_message_3p_target = "slaps TARGET across the face. Ouch!"
	emote_message_3p = "slaps USER_SELF across the face!"
	emote_sound = 'sound/effects/snap.ogg'
	check_restraints = TRUE
	check_range = 1

/decl/emote/audible/slap/New()
	..()
	emote_message_1p_target = span_danger(emote_message_1p_target)
	emote_message_1p =        span_danger(emote_message_1p)
	emote_message_3p_target = span_danger(emote_message_3p_target)
	emote_message_3p =        span_danger(emote_message_3p)

/decl/emote/audible/slap/do_extra(var/atom/user, var/atom/target)
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		var/obj/item/clothing/mask/smokable/mask = H.wear_mask
		if(istype(mask) && H.unEquip(mask))
			mask.forceMove(get_turf(H))
