<<<<<<< HEAD:code/modules/mob/living/carbon/brain/emote.dm
var/list/_brain_default_emotes = list(
	/decl/emote/audible/alarm,
	/decl/emote/audible/alert,
	/decl/emote/audible/notice,
	/decl/emote/audible/whistle,
	/decl/emote/audible/synth,
	/decl/emote/audible/beep,
	/decl/emote/audible/boop,
	/decl/emote/visible/blink,
	/decl/emote/visible/flash
)

/mob/living/carbon/brain/can_emote()
	return (istype(container, /obj/item/device/mmi) && ..())

/mob/living/carbon/brain/get_available_emotes()
	return global._brain_default_emotes
=======
var/list/_brain_default_emotes = list(
	/decl/emote/audible/alarm,
	/decl/emote/audible/alert,
	/decl/emote/audible/notice,
	/decl/emote/audible/whistle,
	/decl/emote/audible/synth,
	/decl/emote/audible/beep,
	/decl/emote/audible/boop,
	/decl/emote/visible/blink,
	/decl/emote/visible/flash
)

/mob/living/carbon/brain/can_emote()
	return (istype(container, /obj/item/mmi) && ..())

/mob/living/carbon/brain/get_available_emotes()
	return global._brain_default_emotes
>>>>>>> f1e82ef21af... Merge pull request #8561 from Atermonera/remove_carbonmob_dependencies:code/modules/mob/living/brain/emote.dm
