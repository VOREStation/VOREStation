/datum/category_item/catalogue/fauna/karik
	name = "Meralar Fauna - Karik"
	desc = "Classification: M Vulpes etari \
	<br><br>\
	A common fox-like mammalian species originating from the cool coastal sand dunes of the Etari \
	Archipelago on Meralar, though they are a common sight throughout Tajaran society due to the \
	breeding of a domestic variety, the 'karik ekan' by the Njarjirii as far back as the 18th Century.\
	<br><br>\
	The Karik is primarily a piscivore in its natural habitat, hunting by submerging its head in \
    shallow waters and detecting even the smallest movements of shore fish with its large, highly \
    sensitive ears. When access to fish is limited, increasingly the case due to modern ocean pollution \
    and loss of habitat, the Karik may survive on an omnivorous diet of opportunistic forage.\
	<br><br>\
	Wild Karik are rare outside of Meralar, though feral populations have proven fairly well \
	adapted to the Sivian environment."
	value = CATALOGUER_REWARD_MEDIUM

var/global/list/_karik_default_emotes = list(
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
	/decl/emote/visible/zoom,
	/decl/emote/audible,
	/decl/emote/audible/whimper,
	/decl/emote/audible/gasp,
	/decl/emote/audible/scretch,
	/decl/emote/audible/choke,
	/decl/emote/audible/moan,
	/decl/emote/audible/gnarl,
	/decl/emote/audible/karikscream
)

/mob/living/simple_mob/animal/passive/karik
	name = "karik"
	desc = "A fox-like creature from the coastal dunes of Meralar, known for its ear-piercing cry."
	tt_desc = "M Vulpes Etari"
	icon_state = "fennec"
	item_state = "fennec"

	movement_cooldown = 0.5 SECONDS

	see_in_dark = 6
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"

	holder_type = /obj/item/holder/karik
	mob_size = MOB_SMALL

	has_langs = list("Cat, Dog") //they're similar, why not.

/mob/living/simple_mob/animal/passive/karik/tame
	name = "karik ekan"
	desc = "A domesticated variety of karik. Seems to like screaming just as much though."

/mob/living/simple_mob/animal/passive/karik/Initialize()
	icon_living = "[initial(icon_state)]"
	icon_dead = "[initial(icon_state)]_dead"
	icon_rest = "[initial(icon_state)]_rest"
	update_icon()
	return ..()
