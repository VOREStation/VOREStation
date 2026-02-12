GLOBAL_LIST_INIT(brain_default_emotes, list(
	/decl/emote/audible/alarm,
	/decl/emote/audible/alert,
	/decl/emote/audible/notice,
	/decl/emote/audible/whistle,
	/decl/emote/audible/synth,
	/decl/emote/audible/beep,
	/decl/emote/audible/boop,
	/decl/emote/visible/blink,
	/decl/emote/visible/flash
))

/mob/living/carbon/brain/can_emote()
	return (istype(container, /obj/item/mmi) && ..())

/mob/living/carbon/brain/get_available_emotes()
	return GLOB.brain_default_emotes.Copy()
