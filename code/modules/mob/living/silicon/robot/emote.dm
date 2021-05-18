var/list/_robot_default_emotes = list(
	/decl/emote/audible/clap,
	/decl/emote/visible/bow,
	/decl/emote/visible/salute,
	/decl/emote/visible/flap,
	/decl/emote/visible/aflap,
	/decl/emote/visible/twitch,
	/decl/emote/visible/twitch_v,
	/decl/emote/visible/dance,
	/decl/emote/visible/nod,
	/decl/emote/visible/shake,
	/decl/emote/visible/glare,
	/decl/emote/visible/look,
	/decl/emote/visible/stare,
	/decl/emote/visible/deathgasp_robot,
	/decl/emote/visible/spin,
	/decl/emote/visible/sidestep,
	/decl/emote/audible/synth,
	/decl/emote/audible/synth/ping,
	/decl/emote/audible/synth/buzz,
	/decl/emote/audible/synth/confirm,
	/decl/emote/audible/synth/deny,
	/decl/emote/audible/synth/dwoop,
	/decl/emote/audible/synth/security,
	/decl/emote/audible/synth/security/halt,
	//VOREStation Add
	/decl/emote/visible/mlem,
	/decl/emote/visible/blep
	//VOREStation Add End
)

/mob/living/silicon/robot/get_default_emotes()
	return global._robot_default_emotes
