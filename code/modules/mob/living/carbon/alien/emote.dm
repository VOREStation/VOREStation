var/list/_alien_default_emotes = list(
	/decl/emote/visible,
	/decl/emote/visible/scratch,
	/decl/emote/visible/drool,
	/decl/emote/visible/nod,
	/decl/emote/visible/sway,
	/decl/emote/visible/sulk,
	/decl/emote/visible/twitch,
	/decl/emote/visible/twitch_v,
	/decl/emote/visible/dance,
	/decl/emote/visible/roll,
	/decl/emote/visible/shake,
	/decl/emote/visible/jump,
	/decl/emote/visible/shiver,
	/decl/emote/visible/collapse,
	/decl/emote/visible/spin,
	/decl/emote/visible/sidestep,
	/decl/emote/audible/hiss,
	/decl/emote/audible,
	/decl/emote/audible/deathgasp_alien,
	/decl/emote/audible/whimper,
	/decl/emote/audible/gasp,
	/decl/emote/audible/scretch,
	/decl/emote/audible/choke,
	/decl/emote/audible/moan,
	/decl/emote/audible/gnarl,
	/decl/emote/audible/chirp
)

/mob/living/carbon/alien/get_default_emotes()
	. = global._alien_default_emotes
