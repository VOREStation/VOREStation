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
	do_colouration = 0 // Set to 1 to blend (ICON_ADD) hair color

	var/color_blend_mode = ICON_ADD // Only appliciable if do_coloration = 1
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

/datum/sprite_accessory/ears/bunny_white
	name = "bunny, white"
	desc = ""
	icon_state = "bunny"

/datum/sprite_accessory/ears/bear_brown
	name = "bear, brown"
	desc = ""
	icon_state = "bear-brown"

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

/datum/sprite_accessory/ears/mouse_grey
	name = "mouse, grey"
	desc = ""
	icon_state = "mouse-grey"

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

/datum/sprite_accessory/ears/foxears
	name = "highlander zorren ears"
	desc = ""
	icon_state = "foxears"

/datum/sprite_accessory/ears/fenears
	name = "flatland zorren ears"
	desc = ""
	icon_state = "fenears"

/datum/sprite_accessory/ears/sergal
	name = "Sergal ears"
	icon_state = "serg_plain_s"

/datum/sprite_accessory/ears/foxearshc
	name = "highlander zorren ears, colorable"
	desc = ""
	icon_state = "foxearshc"
	do_colouration = 1

/datum/sprite_accessory/ears/fenearshc
	name = "flatland zorren ears, colorable"
	desc = ""
	icon_state = "fenearshc"
	do_colouration = 1

/datum/sprite_accessory/ears/sergalhc
	name = "Sergal ears, colorable"
	icon_state = "serg_plain_s"
	do_colouration = 1

/datum/sprite_accessory/ears/mousehc
	name = "mouse, colorable"
	desc = ""
	icon_state = "mouse"
	do_colouration = 1
	extra_overlay = "mouseinner"

/datum/sprite_accessory/ears/wolfhc
	name = "wolf, colorable"
	desc = ""
	icon_state = "wolf"
	do_colouration = 1
	extra_overlay = "wolfinner"

/datum/sprite_accessory/ears/bearhc
	name = "bear, colorable"
	desc = ""
	icon_state = "bear"
	do_colouration = 1

/datum/sprite_accessory/ears/squirrelhc
	name = "squirrel, colorable"
	desc = ""
	icon_state = "squirrel"
	do_colouration = 1

/datum/sprite_accessory/ears/kittyhc
	name = "kitty, colorable"
	desc = ""
	icon_state = "kitty"
	do_colouration = 1
	extra_overlay = "kittyinner"

/datum/sprite_accessory/ears/bunnyhc
	name = "bunny, colorable"
	desc = ""
	icon_state = "bunny"
	do_colouration = 1

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
	do_colouration = 0 //Set to 1 to enable coloration using the tail color.

	var/color_blend_mode = ICON_ADD // Only appliciable if do_coloration = 1
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
	name = "squirrel, colorable"
	desc = ""
	icon_state = "squirrel"
	do_colouration = 1

/datum/sprite_accessory/tail/kitty
	name = "kitty, colorable, downwards"
	desc = ""
	icon_state = "kittydown"
	do_colouration = 1

/datum/sprite_accessory/tail/kittyup
	name = "kitty, colorable, upwards"
	desc = ""
	icon_state = "kittyup"
	do_colouration = 1

/datum/sprite_accessory/tail/tiger_white
	name = "tiger, colorable, white stripes"
	desc = ""
	icon_state = "tiger"
	do_colouration = 1
	extra_overlay = "tigerinnerwhite"

/datum/sprite_accessory/tail/tiger_black
	name = "tiger, colorable, black stripes"
	desc = ""
	icon_state = "tiger"
	do_colouration = 1
	extra_overlay = "tigerinnerblack"

/datum/sprite_accessory/tail/stripey
	name = "stripey taj, colorable"
	desc = ""
	icon_state = "stripeytail"
	do_colouration = 1

/datum/sprite_accessory/tail/stripeytail_brown
	name = "stripey taj, brown"
	desc = ""
	icon_state = "stripeytail-brown"

/datum/sprite_accessory/tail/bunny
	name = "bunny, colorable"
	desc = ""
	icon_state = "bunny"
	do_colouration = 1

/datum/sprite_accessory/tail/mothc
	name = "moth wings, colorable"
	desc = ""
	icon_state = "moth"
	do_colouration = 1

/datum/sprite_accessory/tail/moth
	name = "moth wings"
	desc = ""
	icon_state = "moth"

/datum/sprite_accessory/tail/bear_brown
	name = "bear, brown"
	desc = ""
	icon_state = "bear-brown"

/datum/sprite_accessory/tail/bear
	name = "bear, colorable"
	desc = ""
	icon_state = "bear"
	do_colouration = 1

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
	name = "wolf, colorable"
	desc = ""
	icon_state = "wolf"
	do_colouration = 1
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
	name = "mouse, colorable"
	desc = ""
	icon_state = "mouse"
	do_colouration = 1
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

//For all species tails. Includes haircolored tails.
/datum/sprite_accessory/tail/special
	name = "Blank tail. Do not select."
	icon = 'icons/effects/species_tails_vr.dmi'

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
	icon_state = "nevreantail_s"

/datum/sprite_accessory/tail/special/armalis
	name = "armalis tail"
	desc = ""
	icon_state = "armalis_tail_humanoid_s"

/datum/sprite_accessory/tail/special/xenodrone
	name = "xenomorph drone tail"
	desc = ""
	icon_state = "xenos_drone_tail_s"

/datum/sprite_accessory/tail/special/xenosentinel
	name = "xenomorph sentinel tail"
	desc = ""
	icon_state = "xenos_sentinel_tail_s"

/datum/sprite_accessory/tail/special/xenohunter
	name = "xenomorph hunter tail"
	desc = ""
	icon_state = "xenos_hunter_tail_s"

/datum/sprite_accessory/tail/special/xenoqueen
	name = "xenomorph queen tail"
	desc = ""
	icon_state = "xenos_queen_tail_s"

/datum/sprite_accessory/tail/special/monkey
	name = "monkey tail"
	desc = ""
	icon_state = "chimptail_s"

/datum/sprite_accessory/tail/special/seromitail
	name = "seromi tail"
	desc = ""
	icon_state = "seromitail_s"

/datum/sprite_accessory/tail/special/seromitailfeathered
	name = "seromi tail w/ feathers"
	desc = ""
	icon_state = "seromitail_feathers_s"

/datum/sprite_accessory/tail/special/unathihc
	name = "unathi tail, colorable"
	desc = ""
	icon_state = "sogtail_hc_s"
	do_colouration = 1

/datum/sprite_accessory/tail/special/tajaranhc
	name = "tajaran tail, colorable"
	desc = ""
	icon_state = "tajtail_hc_s"
	do_colouration = 1

/datum/sprite_accessory/tail/special/sergalhc
	name = "sergal tail, colorable"
	desc = ""
	icon_state = "sergtail_hc_s"
	do_colouration = 1

/datum/sprite_accessory/tail/special/akulahc
	name = "akula tail, colorable"
	desc = ""
	icon_state = "sharktail_hc_s"
	do_colouration = 1

/datum/sprite_accessory/tail/special/nevreanhc
	name = "nevrean tail, colorable"
	desc = ""
	icon_state = "nevreantail_hc_s"
	do_colouration = 1

/datum/sprite_accessory/tail/special/foxhc
	name = "highlander zorren tail, colorable"
	desc = ""
	icon_state = "foxtail_hc_s"
	do_colouration = 1

/datum/sprite_accessory/tail/special/fennechc
	name = "flatland zorren tail, colorable"
	desc = ""
	icon_state = "fentail_hc_s"
	do_colouration = 1

/datum/sprite_accessory/tail/special/armalishc
	name = "armalis tail, colorable"
	desc = ""
	icon_state = "armalis_tail_humanoid_hc_s"
	do_colouration = 1

/datum/sprite_accessory/tail/special/xenodronehc
	name = "xenomorph drone tail, colorable"
	desc = ""
	icon_state = "xenos_drone_tail_hc_s"
	do_colouration = 1

/datum/sprite_accessory/tail/special/xenosentinelhc
	name = "xenomorph sentinel tail, colorable"
	desc = ""
	icon_state = "xenos_sentinel_tail_hc_s"
	do_colouration = 1

/datum/sprite_accessory/tail/special/xenohunterhc
	name = "xenomorph hunter tail, colorable"
	desc = ""
	icon_state = "xenos_hunter_tail_hc_s"
	do_colouration = 1

/datum/sprite_accessory/tail/special/xenoqueenhc
	name = "xenomorph queen tail, colorable"
	desc = ""
	icon_state = "xenos_queen_tail_hc_s"
	do_colouration = 1

/datum/sprite_accessory/tail/special/monkeyhc
	name = "monkey tail, colorable, colorable"
	desc = ""
	icon_state = "chimptail_hc_s"
	do_colouration = 1

/datum/sprite_accessory/tail/special/seromitailhc
	name = "seromi tail, colorable"
	desc = ""
	icon_state = "seromitail_hc_s"
	do_colouration = 1

/datum/sprite_accessory/tail/special/seromitailfeatheredhc
	name = "seromi tail w/ feathers, colorable"
	desc = ""
	icon_state = "seromitail_feathers_hc_s"
	do_colouration = 1

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
	do_colouration = 1 // Yes color, using tail color
	color_blend_mode = ICON_MULTIPLY  // The sprites for taurs are designed for ICON_MULTIPLY

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
