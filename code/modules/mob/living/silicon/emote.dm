var/global/list/_silicon_default_emotes = list(
	/decl/emote/audible/synth,
	/decl/emote/audible/synth/ping,
	/decl/emote/audible/synth/buzz,
	/decl/emote/audible/synth/confirm,
	/decl/emote/audible/synth/deny,
	/decl/emote/audible/synth/scary,
	/decl/emote/audible/synth/dwoop,
	/decl/emote/audible/synth/security,
	/decl/emote/audible/synth/security/halt
)

/mob/living/silicon/get_available_emotes()
	return global._silicon_default_emotes
