GLOBAL_LIST_INIT(brain_default_emotes, list(
	/datum/decl/emote/audible/alarm,
	/datum/decl/emote/audible/alert,
	/datum/decl/emote/audible/notice,
	/datum/decl/emote/audible/whistle,
	/datum/decl/emote/audible/synth,
	/datum/decl/emote/audible/beep,
	/datum/decl/emote/audible/boop,
	/datum/decl/emote/visible/blink,
	/datum/decl/emote/visible/flash
))

/mob/living/carbon/brain/can_emote()
	return (istype(container, /obj/item/mmi) && ..())

/mob/living/carbon/brain/get_available_emotes()
	return GLOB.brain_default_emotes.Copy()
