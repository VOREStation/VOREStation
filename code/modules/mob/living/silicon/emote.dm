var/list/_silicon_default_emotes = list(
	/decl/emote/audible/synth,
<<<<<<< HEAD
	/decl/emote/audible/synth/beep,
=======
	/decl/emote/audible/synth/ping,
	/decl/emote/audible/synth/bing,
>>>>>>> ca0065ea05e... Merge pull request #9033 from Varlaisvea/goodbing
	/decl/emote/audible/synth/buzz,
	/decl/emote/audible/synth/confirm,
	/decl/emote/audible/synth/deny,
	/decl/emote/audible/synth/scary,
	/decl/emote/audible/synth/dwoop,
	/decl/emote/audible/synth/boop,
	/decl/emote/audible/synth/robochirp,
	/decl/emote/audible/synth/security,
	/decl/emote/audible/synth/security/halt
)

/mob/living/silicon/get_available_emotes()
	return global._silicon_default_emotes.Copy()

/mob/living/silicon/pai/get_available_emotes()

	var/list/fulllist = list()
	fulllist |= _silicon_default_emotes
	fulllist |= _robot_default_emotes
	fulllist |= _human_default_emotes
	return fulllist
