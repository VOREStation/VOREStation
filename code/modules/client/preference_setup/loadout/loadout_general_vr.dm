/datum/gear/ball
	display_name = "tennis ball selection"
	description = "Choose from a num- BALL!"
	path = /obj/item/toy/tennis

/datum/gear/ball/New()
	..()
	var/list/balls = list()
	for(var/obj/item/toy/tennis/ball_type as anything in typesof(/obj/item/toy/tennis/))
		balls[initial(ball_type.name)] = ball_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(balls))

/datum/gear/character/
	display_name = "miniature selection"
	description = "Choose from a number of miniatures. From Battlemace 40 million to Grottos and Ghouls."
	path = /obj/item/toy/character/alien

/datum/gear/character/New()
	..()
	var/list/characters = list()
	for(var/obj/item/toy/character/character_type as anything in subtypesof(/obj/item/toy/character))
		characters[initial(character_type.name)] = character_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(characters))

/datum/gear/mechtoy/
	display_name = "mecha toy selection"
	description = "Choose from a number of mech toys."
	path = /obj/item/toy/mecha/ripley

/datum/gear/mechtoy/New()
	..()
	var/list/mechs = list()
	for(var/obj/item/toy/mecha/mech_type as anything in subtypesof(/obj/item/toy/mecha))
		mechs[initial(mech_type.name)] = mech_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(mechs))

/datum/gear/toy/New()
	..()
	var/toytype = list()
	toytype["Blink toy"] = /obj/item/toy/blink
	toytype["Foam dart crossbow"] = /obj/item/toy/blink
	toytype["Toy sword"] = /obj/item/toy/sword
	toytype["Toy katana"] = /obj/item/toy/katana
	toytype["Snap pops"] = /obj/item/storage/box/snappops
	toytype["Plastic flowers"] = /obj/item/toy/bouquet/fake
	toytype["Stick horse"] = /obj/item/toy/stickhorse
	toytype["Toy X-mas tree"] = /obj/item/toy/xmastree
	toytype["Fake handcuff kit"] = /obj/item/storage/box/handcuffs/fake
	toytype["Gravitational singularity"] = /obj/item/toy/spinningtoy
	toytype["Water flower"] = /obj/item/reagent_containers/spray/waterflower
	toytype["Bosun's whistle"] = /obj/item/toy/bosunwhistle
	toytype["Magic 8 Ball"] = /obj/item/toy/eight_ball
	toytype["Magic Conch shell"] = /obj/item/toy/eight_ball/conch
	toytype["Pet rock"] = /obj/item/toy/rock
	toytype["Toy flash"] = /obj/item/toy/flash
	toytype["Big Red Button"] = /obj/item/toy/redbutton
	toytype["Garden gnome"] = /obj/item/toy/gnome
	toytype["Toy AI"] = /obj/item/toy/AI
	toytype["Hand buzzer"] = /obj/item/clothing/gloves/ring/buzzer/toy
	toytype["Toy nuke"] = /obj/item/toy/nuke
	toytype["Toy gibber"] = /obj/item/toy/minigibber
	toytype["Toy xeno"] = /obj/item/toy/toy_xeno
	gear_tweaks += new/datum/gear_tweak/path(toytype)

/datum/gear/chewtoy
	display_name = "animal toy selection"
	path = /obj/item/toy/chewtoy

/datum/gear/chewtoy/New()
	..()
	var/toytype = list()
	toytype["Bone"] = /obj/item/toy/chewtoy
	toytype["Classic"] = /obj/item/toy/chewtoy/tall
	toytype["Mouse"] = /obj/item/toy/cat_toy
	toytype["Feather rod"] = /obj/item/toy/cat_toy/rod
	gear_tweaks += new/datum/gear_tweak/path(toytype)

/datum/gear/chewtoy_poly
	display_name = "animal toy selection, colorable"
	path = /obj/item/toy/chewtoy/poly

/datum/gear/chewtoy_poly/New()
	..()
	var/toytype = list()
	toytype["Bone"] = /obj/item/toy/chewtoy/poly
	toytype["Classic"] = /obj/item/toy/chewtoy/tall/poly
	gear_tweaks += new/datum/gear_tweak/path(toytype)
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/textmug
	display_name = "mug with text"
	description = "A mug with something written on it."
	path = /obj/item/reagent_containers/food/drinks/textmug

/datum/gear/schnapsen
	display_name = "schnapsen playing cards"
	description = "An ancient Austro-Hungarian suit of cards!"
	path = /obj/item/deck/schnapsen

/datum/gear/egy_game
	display_name = "EGY playing cards"
	description = "A deck of cards for playing EGY! Be the first to lose all cards!"
	path = /obj/item/deck/egy

/datum/gear/fluff_permit
	display_name = "Customizable Permit"
	description = "A customizable permit you can use for... just about anything! Be sure to customize the name and description. It is meant to represent generic driver's or pilot's licenses, and similar fluff items. It includes an irremovable disclaimer and may be freely confiscated or revoked at the discretion of Security and/or Command if you attempt to abuse it!"
	path = /obj/item/card_fluff
