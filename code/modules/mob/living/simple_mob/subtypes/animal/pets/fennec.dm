var/global/list/_fennec_default_emotes = list(
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
	/decl/emote/audible,
	/decl/emote/audible/whimper,
	/decl/emote/audible/gasp,
	/decl/emote/audible/scretch,
	/decl/emote/audible/choke,
	/decl/emote/audible/moan,
	/decl/emote/audible/gnarl,
	/decl/emote/audible/fennecscream,
	/decl/emote/audible/zoom
)

/mob/living/simple_mob/animal/passive/fennec
	name = "fennec"
	desc = "A fox preferring arid climates, also known as a dingler, or a goob."
	tt_desc = "Vulpes Zerda"
	icon_state = "fennec"
	item_state = "fennec"

	movement_cooldown = 0.5 SECONDS

	see_in_dark = 6
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"

	holder_type = /obj/item/holder/fennec
	mob_size = MOB_SMALL

	has_langs = list("Cat, Dog") //they're similar, why not.

/mob/living/simple_mob/animal/passive/fennec/faux
	name = "faux"
	desc = "Domesticated fennec. Seems to like screaming just as much though."

/mob/living/simple_mob/animal/passive/fennec/Initialize()
	icon_living = "[initial(icon_state)]"
	icon_dead = "[initial(icon_state)]_dead"
	icon_rest = "[initial(icon_state)]_rest"
	update_icon()
	return ..()
