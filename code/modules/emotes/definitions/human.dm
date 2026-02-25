/datum/decl/emote/human/mob_can_use(var/mob/living/carbon/human/user)
	return ..() && (istype(user))//What does a mouth have to do with wagging?? && user.check_has_mouth() && !user.isSynthetic())

/datum/decl/emote/human/deathgasp
	key = "deathgasp"

/datum/decl/emote/human/deathgasp/get_emote_sound(user)
	var/mob/living/carbon/human/H = user
	var/vol = H.species.death_volume
	return list(
			"sound" = get_species_sound(get_gendered_sound(H))["death"],
			"vol" = vol,
			"volchannel" = VOLUME_CHANNEL_SPECIES_SOUNDS
		)

/datum/decl/emote/human/deathgasp/do_emote(mob/living/carbon/human/user)
	if(istype(user) && user.species.get_death_message(user) == DEATHGASP_NO_MESSAGE)
		to_chat(user, span_warning("Your species has no deathgasp."))
		return
	. = ..()

/datum/decl/emote/human/deathgasp/get_emote_message_3p(var/mob/living/carbon/human/user)
	return "[user.species.get_death_message(user)]"

/datum/decl/emote/human/swish
	key = "swish"

/datum/decl/emote/human/swish/do_emote(var/mob/living/carbon/human/user)
	user.animate_tail_once()

/datum/decl/emote/human/wag
	key = "wag"

/datum/decl/emote/human/wag/do_emote(var/mob/living/carbon/human/user)
	user.animate_tail_start()

/datum/decl/emote/human/sway
	key = "sway"

/datum/decl/emote/human/sway/do_emote(var/mob/living/carbon/human/user)
	user.animate_tail_start()

/datum/decl/emote/human/qwag
	key = "qwag"

/datum/decl/emote/human/qwag/do_emote(var/mob/living/carbon/human/user)
	user.animate_tail_fast()

/datum/decl/emote/human/fastsway
	key = "fastsway"

/datum/decl/emote/human/fastsway/do_emote(var/mob/living/carbon/human/user)
	user.animate_tail_fast()

/datum/decl/emote/human/swag
	key = "swag"

/datum/decl/emote/human/swag/do_emote(var/mob/living/carbon/human/user)
	user.animate_tail_stop()

/datum/decl/emote/human/stopsway
	key = "stopsway"

/datum/decl/emote/human/stopsway/do_emote(var/mob/living/carbon/human/user)
	user.animate_tail_stop()
