/*
	Hello and welcome to VOREStation sprite_accessories: For a more general overview
	please read sprite_accessories.dm. This file is for ears, tails, and taur bodies!

	This is intended to be friendly for people with little to no actual coding experience.

	!!WARNING!!: changing existing accessory information can be VERY hazardous to savefiles,
	to the point where you may completely corrupt a server's savefiles. Please refrain
	from doing this unless you absolutely know what you are doing, and have defined a
	conversion in savefile.dm
*/

// Add Additional variable onto sprite_accessory
/datum/sprite_accessory
	// Ckey of person allowed to use this, if defined.
	var/list/ckeys_allowed = null

/*
////////////////////////////
/  =--------------------=  /
/  == Ear Definitions  ==  /
/  =--------------------=  /
////////////////////////////
*/
/datum/sprite_accessory/ears
	name = "You should not see this..."
	icon = 'icons/mob/vore/ears_vr.dmi'
	do_colouration = 0 //Set to ICON_MULTIPLY or ICON_ADD to convert greyscale to the haircolor

	var/extra_overlay // Icon state of an additional overlay to blend in.
	var/desc = "You should not see this..."

// Ears avaliable to anyone

/datum/sprite_accessory/ears/squirrel_orange
	name = "squirel, orange"
	desc = ""
	icon_state = "squirrel-orange"

/datum/sprite_accessory/ears/squirrel_red
	name = "squirrel, red"
	desc = ""
	icon_state = "squirrel-red"

/datum/sprite_accessory/ears/squirrel
	name = "squirrel, hair-colored"
	desc = ""
	icon_state = "squirrel"
	do_colouration = ICON_ADD

/datum/sprite_accessory/ears/kitty
	name = "kitty, hair-colored"
	desc = ""
	icon_state = "kitty"
	do_colouration = ICON_ADD
	extra_overlay = "kittyinner"

/datum/sprite_accessory/ears/bunny
	name = "bunny, hair-colored"
	desc = ""
	icon_state = "bunny"
	do_colouration = ICON_ADD

/datum/sprite_accessory/ears/bunny_white
	name = "bunny, white"
	desc = ""
	icon_state = "bunny"

/datum/sprite_accessory/ears/bear_brown
	name = "bear, brown"
	desc = ""
	icon_state = "bear-brown"

/datum/sprite_accessory/ears/bear
	name = "bear, hair-colored"
	desc = ""
	icon_state = "bear"
	do_colouration = ICON_ADD

/datum/sprite_accessory/ears/wolf_grey
	name = "wolf, grey"
	desc = ""
	icon_state = "wolf-grey"

/datum/sprite_accessory/ears/wolf_green
	name = "wolf, green"
	desc = ""
	icon_state = "wolf-green"

/datum/sprite_accessory/ears/wisewolf
	name = "wolf, wise"
	desc = ""
	icon_state = "wolf-wise"

/datum/sprite_accessory/ears/wolf
	name = "wolf, hair-colored"
	desc = ""
	icon_state = "wolf"
	do_colouration = ICON_ADD
	extra_overlay = "wolfinner"

/datum/sprite_accessory/ears/mouse_grey
	name = "mouse, grey"
	desc = ""
	icon_state = "mouse-grey"

/datum/sprite_accessory/ears/mouse
	name = "mouse, hair-colored"
	desc = ""
	icon_state = "mouse"
	do_colouration = ICON_ADD
	extra_overlay = "mouseinner"

/datum/sprite_accessory/ears/bee
	name = "bee antennae"
	desc = ""
	icon_state = "bee"

/datum/sprite_accessory/ears/oni_h1
	name = "oni horns"
	desc = ""
	icon_state = "oni-h1"

/datum/sprite_accessory/ears/demon_horns1
	name = "demon horns"
	desc = ""
	icon_state = "demon-horns1"

// Special snowflake ears go below here.

/datum/sprite_accessory/ears/molenar_kitsune
	name = "quintail kitsune ears (Molenar)"
	desc = ""
	icon_state = "molenar-kitsune"
	ckeys_allowed = list("molenar")

/datum/sprite_accessory/ears/molenar_deathclaw
	name = "deathclaw ears (Molenar)"
	desc = ""
	icon_state = "molenar-deathclaw"
	ckeys_allowed = list("molenar")

/datum/sprite_accessory/ears/runac
	name = "fennecsune ears (Runac)"
	desc = ""
	icon_state = "runac"
	ckeys_allowed = list("rebcom1807")

/datum/sprite_accessory/ears/kerena
	name = "wingwolf ears (Kerena)"
	desc = ""
	icon_state = "kerena"
	ckeys_allowed = list("somekindofpony")

/datum/sprite_accessory/ears/rosey
	name = "tritail kitsune ears (Rosey)"
	desc = ""
	icon_state = "rosey"
	ckeys_allowed = list("joey4298")

/datum/sprite_accessory/ears/aronai
	name = "aronai ears/head (Aronai)"
	desc = ""
	icon_state = "aronai"
	ckeys_allowed = list("arokha")

/*
////////////////////////////
/  =--------------------=  /
/  == Tail Definitions ==  /
/  =--------------------=  /
////////////////////////////
*/
/datum/sprite_accessory/tail
	name = "You should not see this..."
	icon = 'icons/mob/vore/tails_vr.dmi'
	do_colouration = 0 //Set to ICON_MULTIPLY or ICON_ADD to convert greyscale to the haircolor

	var/extra_overlay // Icon state of an additional overlay to blend in.
	var/show_species_tail = 0 // If false, do not render species' tail.
	var/clothing_can_hide = 1 // If true, clothing with HIDETAIL hides it
	var/desc = "You should not see this..."

/datum/sprite_accessory/tail/invisible
	name = "hide species-sprite tail"
	icon = null
	icon_state = null

/datum/sprite_accessory/tail/squirrel_orange
	name = "squirel, orange"
	desc = ""
	icon_state = "squirrel-orange"

/datum/sprite_accessory/tail/squirrel_red
	name = "squirrel, red"
	desc = ""
	icon_state = "squirrel-red"

/datum/sprite_accessory/tail/squirrel
	name = "squirrel, hair-colored"
	desc = ""
	icon_state = "squirrel"
	do_colouration = ICON_ADD

/datum/sprite_accessory/tail/kitty
	name = "kitty, hair-colored, downwards"
	desc = ""
	icon_state = "kittydown"
	do_colouration = ICON_ADD

/datum/sprite_accessory/tail/kittyup
	name = "kitty, hair-colored, upwards"
	desc = ""
	icon_state = "kittyup"
	do_colouration = ICON_ADD

/datum/sprite_accessory/tail/tiger_white
	name = "tiger, hair-colored, white stripes"
	desc = ""
	icon_state = "tiger"
	do_colouration = ICON_ADD
	extra_overlay = "tigerinnerwhite"

/datum/sprite_accessory/tail/tiger_black
	name = "tiger, hair-colored, black stripes"
	desc = ""
	icon_state = "tiger"
	do_colouration = ICON_ADD
	extra_overlay = "tigerinnerblack"

/datum/sprite_accessory/tail/stripey
	name = "stripey taj, hair-colored"
	desc = ""
	icon_state = "stripeytail"
	do_colouration = ICON_ADD

/datum/sprite_accessory/tail/stripeytail_brown
	name = "stripey taj, brown"
	desc = ""
	icon_state = "stripeytail-brown"

/datum/sprite_accessory/tail/bunny
	name = "bunny, hair-colored"
	desc = ""
	icon_state = "bunny"
	do_colouration = ICON_ADD

/datum/sprite_accessory/tail/bear_brown
	name = "bear, brown"
	desc = ""
	icon_state = "bear-brown"

/datum/sprite_accessory/tail/bear
	name = "bear, hair-colored"
	desc = ""
	icon_state = "bear"
	do_colouration = ICON_ADD

/datum/sprite_accessory/tail/wolf_grey
	name = "wolf, grey"
	desc = ""
	icon_state = "wolf-grey"

/datum/sprite_accessory/tail/wolf_green
	name = "wolf, green"
	desc = ""
	icon_state = "wolf-green"

/datum/sprite_accessory/tail/wisewolf
	name = "wolf, wise"
	desc = ""
	icon_state = "wolf-wise"

/datum/sprite_accessory/tail/blackwolf
	name = "wolf, black"
	desc = ""
	icon_state = "wolf"

/datum/sprite_accessory/tail/wolf
	name = "wolf, hair-colored"
	desc = ""
	icon_state = "wolf"
	do_colouration = ICON_ADD
	extra_overlay = "wolfinner"

/datum/sprite_accessory/tail/mouse_grey
	name = "mouse, grey"
	desc = ""
	icon_state = "mouse-grey"

/datum/sprite_accessory/tail/crossfox
	name = "cross fox"
	desc = ""
	icon_state = "crossfox"

/datum/sprite_accessory/tail/mouse
	name = "mouse, hair-colored"
	desc = ""
	icon_state = "mouse"
	do_colouration = ICON_ADD
	extra_overlay = "mouseinner"

/datum/sprite_accessory/tail/bee
	name = "bee thorax (+wings)"
	desc = ""
	icon_state = "bee"

/datum/sprite_accessory/tail/succubus_purple
	name = "succubus, purple (+wings)"
	desc = ""
	icon_state = "succubus-purple"

/datum/sprite_accessory/tail/succubus_red
	name = "succubus, red (+wings)"
	desc = ""
	icon_state = "succubus-red"

/datum/sprite_accessory/tail/succubus_black
	name = "succubus, black (+wings)"
	desc = ""
	icon_state = "succubus-black"

/datum/sprite_accessory/tail/bat_black
	name = "bat wings, black"
	desc = ""
	icon_state = "bat-black"
	show_species_tail = 1

/datum/sprite_accessory/tail/bat_red
	name = "bat wings, red"
	desc = ""
	icon_state = "bat-red"
	show_species_tail = 1

/datum/sprite_accessory/tail/snag
	name = "xenomorph tail w/ backplate"
	desc = ""
	icon_state = "snag"

/datum/sprite_accessory/tail/xenotail
	name = "xenomorph tail"
	desc = ""
	icon_state = "xenotail"

/datum/sprite_accessory/tail/molenar_kitsune
	name = "quintail kitsune tails (Molenar)"
	desc = ""
	icon_state = "molenar-kitsune"
	ckeys_allowed = list("molenar")

/datum/sprite_accessory/tail/molenar_deathclaw
	name = "deathclaw bits (Molenar)"
	desc = ""
	icon_state = "molenar-deathclaw"
	ckeys_allowed = list("molenar","jertheace")

/datum/sprite_accessory/tail/runac
	name = "fennecsune tails (Runac)"
	desc = ""
	icon_state = "runac"
	ckeys_allowed = list("rebcom1807")

/datum/sprite_accessory/tail/kerena
	name = "wingwolf tail (+wings) (Kerena)"
	desc = ""
	icon_state = "kerena"
	ckeys_allowed = list("somekindofpony")

/datum/sprite_accessory/tail/rosey
	name = "tritail kitsune tails (Rosey)"
	desc = ""
	icon_state = "rosey"
	ckeys_allowed = list("joey4298")

/datum/sprite_accessory/tail/scree
	name = "green taj tail (+wings) (Scree)"
	desc = ""
	icon_state = "scree"
	ckeys_allowed = list("scree")

/datum/sprite_accessory/tail/aronai
	name = "aronai tail (Aronai)"
	desc = ""
	icon_state = "aronai"
	ckeys_allowed = list("arokha")

/datum/sprite_accessory/tail/feathered
	name = "feathered wings"
	desc = ""
	icon_state = "feathered"

// TODO - Leshana - What is this?
/datum/sprite_accessory/tail/special
	name = "Blank tail. Do not select."
	icon = 'icons/effects/species.dmi'

/datum/sprite_accessory/tail/special/unathi
	name = "unathi tail"
	desc = ""
	icon_state = "sogtail_s"

/datum/sprite_accessory/tail/special/tajaran
	name = "tajaran tail"
	desc = ""
	icon_state = "tajtail_s"

/datum/sprite_accessory/tail/special/sergal
	name = "sergal tail"
	desc = ""
	icon_state = "sergtail_s"

/datum/sprite_accessory/tail/special/akula
	name = "akula tail"
	desc = ""
	icon_state = "sharktail_s"

/datum/sprite_accessory/tail/special/nevrean
	name = "nevrean tail"
	desc = ""
	icon_state = "nevrean_s"

/datum/sprite_accessory/tail/special/unathihc
	name = "unathi tail, hair colored"
	desc = ""
	icon_state = "sogtail_s"
	do_colouration = ICON_ADD

/datum/sprite_accessory/tail/special/tajaranhc
	name = "tajaran tail, hair colored"
	desc = ""
	icon_state = "tajtail_s"
	do_colouration = ICON_ADD

/datum/sprite_accessory/tail/special/sergalhc
	name = "sergal tail, hair colored"
	desc = ""
	icon_state = "sergtail_s"
	do_colouration = ICON_ADD

/datum/sprite_accessory/tail/special/akulahc
	name = "akula tail, hair colored"
	desc = ""
	icon_state = "sharktail_s"
	do_colouration = ICON_ADD

/datum/sprite_accessory/tail/special/nevreanhc
	name = "nevrean tail, hair colored"
	desc = ""
	icon_state = "nevrean_s"
	do_colouration = ICON_ADD


/*
////////////////////////////
/  =--------------------=  /
/  == Taur Definitions ==  /
/  =--------------------=  /
////////////////////////////
*/

// Taur sprites are now a subtype of tail since they are mutually exclusive anyway.

/datum/sprite_accessory/tail/taur
	name = "You should not see this..."
	icon = 'icons/mob/vore/taurs_vr.dmi'
	do_colouration = ICON_MULTIPLY  // In fact, it should use tail color!

/datum/sprite_accessory/tail/taur/wolf
	name = "Wolf"
	icon_state = "wolf_s"

/datum/sprite_accessory/tail/taur/naga
	name = "Naga"
	icon_state = "naga_s"

/datum/sprite_accessory/tail/taur/horse
	name = "Horse"
	icon_state = "horse_s"

/datum/sprite_accessory/tail/taur/cow
	name = "Cow"
	icon_state = "cow_s"

/datum/sprite_accessory/tail/taur/lizard
	name = "Lizard"
	icon_state = "lizard_s"

/datum/sprite_accessory/tail/taur/spider
	name = "Spider"
	icon_state = "spider_s"
