GLOBAL_LIST_INIT(robot_default_emotes, list(
	/datum/decl/emote/audible/clap,
	/datum/decl/emote/visible/bow,
	/datum/decl/emote/visible/salute,
	/datum/decl/emote/visible/flap,
	/datum/decl/emote/visible/aflap,
	/datum/decl/emote/visible/twitch,
	/datum/decl/emote/visible/twitch_v,
	/datum/decl/emote/visible/dance,
	/datum/decl/emote/visible/nod,
	/datum/decl/emote/visible/shake,
	/datum/decl/emote/visible/glare,
	/datum/decl/emote/visible/look,
	/datum/decl/emote/visible/stare,
	/datum/decl/emote/visible/deathgasp_robot,
	/datum/decl/emote/visible/spin,
	/datum/decl/emote/visible/sidestep,
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
	/datum/decl/emote/audible/synth/security/halt,
	/datum/decl/emote/visible/mlem,
	/datum/decl/emote/visible/blep
))

/mob/living/silicon/robot/get_available_emotes()
	var/list/fulllist = GLOB.robot_default_emotes.Copy()
	fulllist |= GLOB.human_default_emotes
	return fulllist
