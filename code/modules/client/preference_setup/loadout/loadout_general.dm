/datum/gear/cane
	display_name = "cane"
	path = /obj/item/cane

/datum/gear/cane/white
	display_name = "white cane"
	path = /obj/item/cane/white

/datum/gear/cane/white2
	display_name = "telescopic white cane"
	path = /obj/item/cane/white/collapsible

/datum/gear/crutch
	display_name = "crutch"
	path = /obj/item/cane/crutch

/datum/gear/dice
	display_name = "dice pack"
	path = /obj/item/storage/pill_bottle/dice

/datum/gear/dice/nerd
	display_name = "dice pack (gaming)"
	path = /obj/item/storage/pill_bottle/dice_nerd

/datum/gear/dice/cup
	display_name = "dice cup and dice"
	path = /obj/item/storage/dicecup/loaded

/datum/gear/cards
	display_name = "deck of cards"
	path = /obj/item/deck/cards

/datum/gear/tarot
	display_name = "deck of tarot cards"
	path = /obj/item/deck/tarot

/datum/gear/holder
	display_name = "card holder"
	path = /obj/item/deck/holder

/datum/gear/cardemon_pack
	display_name = "Cardemon booster pack"
	path = /obj/item/pack/cardemon

/datum/gear/spaceball_pack
	display_name = "Spaceball booster pack"
	path = /obj/item/pack/spaceball

/datum/gear/plushie
	display_name = "plushie selection"
	path = /obj/item/toy/plushie/

/datum/gear/plushie/New()
	..()
	var/list/plushies = list()
	var/list/blacklisted_types = list()
	// look if theres a better way to do this im all ears
	blacklisted_types += subtypesof(/obj/item/toy/plushie/therapy)
	blacklisted_types += subtypesof(/obj/item/toy/plushie/fluff)
	blacklisted_types += /obj/item/toy/plushie/borgplushie/drake //VOREStation addition
	for(var/obj/item/toy/plushie/plushie_type as anything in subtypesof(/obj/item/toy/plushie) - blacklisted_types)
		plushies[initial(plushie_type.name)] = plushie_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(plushies))

/datum/gear/figure
	display_name = "action figure selection"
	description = "A \"Space Life\" brand action figure."
	path = /obj/item/toy/figure/

/datum/gear/figure/New()
	..()
	var/list/figures = list()
	for(var/obj/item/toy/figure/figure_type as anything in subtypesof(/obj/item/toy/figure))
		figures[initial(figure_type.name)] = figure_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(figures))

/datum/gear/toy
	display_name = "toy selection"
	description = "Choose from a number of toys."
	path = /obj/item/toy/

/* VOREStation removal
/datum/gear/toy/New()
	..()
	var/toytype = list()
	toytype["Blink toy"] = /obj/item/toy/blink
	toytype["Gravitational singularity"] = /obj/item/toy/spinningtoy
	toytype["Water flower"] = /obj/item/reagent_containers/spray/waterflower
	toytype["Bosun's whistle"] = /obj/item/toy/bosunwhistle
	toytype["Magic 8 Ball"] = /obj/item/toy/eight_ball
	toytype["Magic Conch shell"] = /obj/item/toy/eight_ball/conch
	gear_tweaks += new/datum/gear_tweak/path(toytype)
*/

/datum/gear/flask
	display_name = "flask"
	path = /obj/item/reagent_containers/food/drinks/flask/barflask

/datum/gear/flask/New()
	..()
	gear_tweaks += new/datum/gear_tweak/reagents(lunchables_ethanol_reagents())

/datum/gear/vacflask
	display_name = "vacuum-flask"
	path = /obj/item/reagent_containers/food/drinks/flask/vacuumflask

/datum/gear/vacflask/New()
	..()
	gear_tweaks += new/datum/gear_tweak/reagents(lunchables_drink_reagents())

/datum/gear/lunchbox
	display_name = "lunchbox"
	description = "A little lunchbox."
	cost = 2
	path = /obj/item/storage/toolbox/lunchbox

/datum/gear/lunchbox/New()
	..()
	var/list/lunchboxes = list()
	for(var/lunchbox_type in typesof(/obj/item/storage/toolbox/lunchbox))
		var/obj/item/storage/toolbox/lunchbox/lunchbox = lunchbox_type
		if(!initial(lunchbox.filled))
			lunchboxes[initial(lunchbox.name)] = lunchbox_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(lunchboxes))
	gear_tweaks += new/datum/gear_tweak/contents(lunchables_lunches(), lunchables_snacks(), lunchables_drinks())

/datum/gear/towel
	display_name = "towel"
	path = /obj/item/towel

/datum/gear/towel/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/cahwhite
	display_name = "Cards Against The Galaxy (white deck)"
	path = /obj/item/deck/cah
	description = "The ever-popular Cards Against The Galaxy word game. Warning: may include traces of broken fourth wall. This is the white deck."

/datum/gear/cahblack
	display_name = "Cards Against The Galaxy (black deck)"
	path = /obj/item/deck/cah/black
	description = "The ever-popular Cards Against The Galaxy word game. Warning: may include traces of broken fourth wall. This is the black deck."

/datum/gear/wizoff
	display_name = "WizOff"
	path = /obj/item/deck/wizoff

/datum/gear/wizoffguide
	display_name = "WizOff Guide"
	path = /obj/item/book/manual/wizzoffguide
	description = "The guide to playing the ever popular card game: Wiz-Off!"

/datum/gear/coffeemug
	display_name = "coffee mugs"
	description = "A coffee mug in various designs."
	cost = 1
	path = /obj/item/reagent_containers/food/drinks/glass2/coffeemug

/datum/gear/coffeemug/New()
	..()
	var/list/coffeemugs = list()
	coffeemugs["plain coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug
	coffeemugs["SCG coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/sol
	coffeemugs["Fleet coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/fleet
	coffeemugs["Five Arrows coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/fivearrows
	coffeemugs["Pearlshield coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/psc
	coffeemugs["Almach Association coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/alma
	coffeemugs["Almach Protectorate coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/almp
	coffeemugs["NT coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/nt
	coffeemugs["Wulf Aeronautics mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/metal/wulf
	coffeemugs["Gilthari Exports coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/gilthari
	coffeemugs["Zeng-Hu coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/zeng
	coffeemugs["Ward-Takahashi coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/wt
	coffeemugs["Aether Atmospherics coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/aether
	coffeemugs["Bishop Cybernetics coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/bishop
	coffeemugs["Oculum Broadcast coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/oculum
	coffeemugs["#1 coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/one
	coffeemugs["#1 monkey coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/puni
	coffeemugs["heart coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/heart
	coffeemugs["pawn coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/pawn
	coffeemugs["diona coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/diona
	coffeemugs["british coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/britcup
	coffeemugs["flame coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/flame
	coffeemugs["blue coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/blue
	coffeemugs["black coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/black
	coffeemugs["green coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/green
	coffeemugs["dark green coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/green/dark
	coffeemugs["rainbow coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/rainbow
	coffeemugs["metal coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/metal
	coffeemugs["glass coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/glass
	coffeemugs["tall coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/tall
	coffeemugs["tall black coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/tall/black
	coffeemugs["tall metal coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/tall/metal
	coffeemugs["tall rainbow coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/tall/rainbow
	coffeemugs["Talon coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/talon
	gear_tweaks += new /datum/gear_tweak/path(coffeemugs)
	gear_tweaks += new /datum/gear_tweak/reagents(lunchables_drink_reagents())

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
