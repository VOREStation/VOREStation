GLOBAL_LIST_INIT(silicon_default_emotes, list(
	/datum/decl/emote/audible/synth,
	/datum/decl/emote/audible/synth/beep,
	/datum/decl/emote/audible/synth/bing,
	/datum/decl/emote/audible/synth/buzz,
	/datum/decl/emote/audible/synth/confirm,
	/datum/decl/emote/audible/synth/deny,
	/datum/decl/emote/audible/synth/scary,
	/datum/decl/emote/audible/synth/dwoop,
	/datum/decl/emote/audible/synth/boop,
	/datum/decl/emote/audible/synth/robochirp,
	/datum/decl/emote/audible/synth/ding,
	/datum/decl/emote/audible/synth/microwave,
	/datum/decl/emote/audible/synth/security,
	/datum/decl/emote/audible/synth/security/halt
))

/mob/living/silicon/get_available_emotes()
	return GLOB.silicon_default_emotes.Copy()

/mob/living/silicon/pai/get_available_emotes()

	var/list/fulllist = list()
	fulllist |= GLOB.silicon_default_emotes
	fulllist |= GLOB.robot_default_emotes
	fulllist |= GLOB.human_default_emotes
	return fulllist
