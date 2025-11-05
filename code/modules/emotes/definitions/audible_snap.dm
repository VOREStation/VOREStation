/decl/emote/audible/snap
	key = "snap"
	emote_message_1p = "You snap your fingers."
	emote_message_3p = "snaps USER_THEIR fingers."
	emote_message_1p_target = "You snap your fingers at TARGET."
	emote_message_3p_target = "snaps USER_THEIR fingers at TARGET."
	emote_sound = 'sound/effects/fingersnap.ogg'

/decl/emote/audible/snap/proc/can_snap(var/atom/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		for(var/limb in list(BP_L_HAND, BP_R_HAND))
			var/obj/item/organ/external/L = H.get_organ(limb)
			if(istype(L) && L.is_usable() && !L.splinted)
				return TRUE
	else if(isanimal(user))		//VOREStation Addition Start
		var/mob/living/simple_mob/S = user
		if(S.has_hands)
			return TRUE
	else if(ispAI(user))
		return TRUE
	else						//VOREStation Addition End
		return FALSE

/decl/emote/audible/snap/do_emote(var/atom/user, var/extra_params)
	if(!can_snap(user))
		to_chat(user, span_warning("You need at least one working hand to snap your fingers."))
		return FALSE
	. = ..()

/decl/emote/audible/snap/do_extra(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_UNLUCKY) && prob(0.1) && ishuman(user)) //1 in a thousand
		var/mob/living/carbon/human/unlucky_human = user
		var/datum/component/omen/bad_luck = unlucky_human.GetComponent(/datum/component/omen) //Also going to make sure they got the EVIL version.
		if(bad_luck.evil)
			unlucky_human.visible_message(span_danger("[unlucky_human] snaps, their hand fading to ash!"), span_danger(span_huge("OH GOD YOUR HAND")))
			for(var/limb in list(BP_L_HAND, BP_R_HAND))
				var/obj/item/organ/external/L = unlucky_human.get_organ(limb)
				if(istype(L) && L.is_usable() && !L.splinted)
					L.droplimb(TRUE, DROPLIMB_BURN)
				break
