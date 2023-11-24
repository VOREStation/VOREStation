	// Clerical and Service modules have a lot of shared sprites so they're in same file
// (some of those sprites are also shared with Standard, but ive already done it as its own thing, so some duplicates are fine)

// Both Service and Clerical

// Regular sprites

/datum/robot_sprite/civilian
	module_type = list("Service", "Clerical")
	sprite_icon = 'icons/mob/robot/civilian.dmi'

/datum/robot_sprite/civilian/eyebot
	name = "Cabeiri"
	sprite_icon_state = "eyebot"

/datum/robot_sprite/civilian/marina
	name = "Haruka"
	sprite_icon_state = "marina"

/datum/robot_sprite/civilian/tall
	name = "Usagi"
	sprite_icon_state = "tall"
	has_eye_sprites = FALSE

/datum/robot_sprite/civilian/toiletbot
	name = "Telemachus"
	sprite_icon_state = "toiletbot"

/datum/robot_sprite/civilian/omoikane
	name = "WTOmni"
	sprite_icon_state = "omoikane"

/datum/robot_sprite/civilian/heavy
	name = "XI-ALP"
	sprite_icon_state = "heavy"

/datum/robot_sprite/civilian/waitress
	name = "Waitress"
	sprite_icon_state = "waitress"
	has_eye_sprites = FALSE

/datum/robot_sprite/civilian/waiter
	name = "Waiter"
	sprite_icon_state = "waiter"
	has_eye_sprites = FALSE

/datum/robot_sprite/civilian/bro
	name = "Bro"
	sprite_icon_state = "bro"
	sprite_hud_icon_state = "brobot"
	has_eye_sprites = FALSE

/datum/robot_sprite/civilian/maximillion
	name = "Rich"
	sprite_icon_state = "maximillion"
	has_eye_sprites = FALSE

/datum/robot_sprite/civilian/tall2
	name = "Usagi-II"
	sprite_icon_state = "tall2"

/datum/robot_sprite/civilian/mechoid
	name = "Acheron"
	sprite_icon_state = "mechoid"

/datum/robot_sprite/civilian/noble
	name = "Shellguard Noble"
	sprite_icon_state = "noble"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/civilian/worm
	name = "W02M"
	sprite_icon_state = "worm"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/civilian/uptall
	name = "Feminine Humanoid"
	sprite_icon_state = "uptall"

// Wide/dogborg sprites
/*
/datum/robot_sprite/dogborg/civilian
	module_type = list("Service", "Clerical")
	sprite_icon = 'icons/mob/robot/civilian_wide.dmi'

		// None yet
*/
// Tall sprites
/*
/datum/robot_sprite/dogborg/tall/civilian
	module_type = list("Service", "Clerical")
	sprite_icon = 'icons/mob/robot/civilian_large.dmi'

		// None yet
*/

// Service

// Regular sprites

/datum/robot_sprite/service
	module_type = "Service"
	sprite_icon = 'icons/mob/robot/service.dmi'

/datum/robot_sprite/service/default
	name = DEFAULT_ROBOT_SPRITE_NAME
	default_sprite = TRUE
	sprite_icon_state = "default"

/datum/robot_sprite/service/maid
	name = "Michiru"
	sprite_icon_state = "maid"

/datum/robot_sprite/service/sleek
	name = "WTOperator"
	sprite_icon_state = "sleek"

/datum/robot_sprite/service/spider
	name = "XI-GUS"
	sprite_icon_state = "spider"

/datum/robot_sprite/service/drone
	name = "AG Model-Serv"
	sprite_icon_state = "drone-crisis"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/service/drone_hydro
	name = "AG Model-Hydro"
	sprite_icon_state = "drone-hydro"
	sprite_hud_icon_state = "hydroponics"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/service/glitterfly
	name = "Pyralis"
	sprite_icon_state = "glitterfly"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/service/decapod
	name = "Decapod"
	sprite_icon_state = "decapod"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/service/pneuma
	name = "Pneuma"
	sprite_icon_state = "pneuma"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/service/drider
	name = "Tower"
	sprite_icon_state = "drider"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/service/handy
	name = "Handy-Serv"
	sprite_icon_state = "handy"

/datum/robot_sprite/service/handy_hydro
	name = "Handy-Hydro"
	sprite_icon_state = "handy-hydro"
	sprite_hud_icon_state = "hydroponics"

/datum/robot_sprite/service/zoomba
	name = "ZOOM-BA"
	sprite_icon_state = "zoomba"
	has_dead_sprite = TRUE

// Wide/dogborg sprites

/datum/robot_sprite/dogborg/service
	module_type = "Service"
	sprite_icon = 'icons/mob/robot/service_wide.dmi'

/datum/robot_sprite/dogborg/service/hound
	name = "Blackhound"
	sprite_icon_state = "hound"
	has_eye_light_sprites = TRUE
	has_vore_belly_sprites = FALSE

/datum/robot_sprite/dogborg/service/houndpink
	name = "Pinkhound"
	sprite_icon_state = "houndpink"
	has_eye_light_sprites = TRUE
	has_vore_belly_sprites = FALSE

/datum/robot_sprite/dogborg/service/vale
	name = "Hound V2"
	sprite_icon_state = "vale"
	has_eye_light_sprites = TRUE
	has_vore_belly_sprites = TRUE

/datum/robot_sprite/dogborg/service/valedark
	name = "Hound V2 Darkmode"
	sprite_icon_state = "valedark"
	has_eye_light_sprites = TRUE
	has_vore_belly_sprites = TRUE

/datum/robot_sprite/dogborg/service/drake
	name = "Drake"
	sprite_icon_state = "drake"

/datum/robot_sprite/dogborg/service/booze
	name = "Boozehound"
	sprite_icon = 'icons/mob/robot/service_wide_booze.dmi'
	sprite_icon_state = "booze"
	sprite_hud_icon_state = "boozehound"
	rest_sprite_options = list("Default")
	has_extra_customization = TRUE

	var/list/booze_options = list("Beer" = "booze",
								  "Space Mountain Wind" = "boozegreen",
								  "Curacao" = "boozeblue",
								  "Grape Soda" = "boozepurple",
								  "Demon's Blood" = "boozered",
								  "Whiskey Soda" = "boozeorange",
								  "Coffee" = "boozebrown")

/datum/robot_sprite/dogborg/service/booze/handle_extra_icon_updates(var/mob/living/silicon/robot/ourborg)
	if(!("boozehound" in ourborg.sprite_extra_customization) || !ourborg.sprite_extra_customization["boozehound"])
		return ..()
	else
		ourborg.icon_state = booze_options[ourborg.sprite_extra_customization["boozehound"]]

/datum/robot_sprite/dogborg/service/booze/get_belly_overlay(var/mob/living/silicon/robot/ourborg, var/size = 1)
	if(!("boozehound" in ourborg.sprite_extra_customization) || !ourborg.sprite_extra_customization["boozehound"])
		return ..()
	else
		return "[booze_options[ourborg.sprite_extra_customization["boozehound"]]]-sleeper-[size]"

/datum/robot_sprite/dogborg/service/booze/get_rest_sprite(var/mob/living/silicon/robot/ourborg)
	if(!(ourborg.rest_style in rest_sprite_options))
		ourborg.rest_style = "Default"
	if(!("boozehound" in ourborg.sprite_extra_customization) || !ourborg.sprite_extra_customization["boozehound"])
		return ..()
	else
		return "[booze_options[ourborg.sprite_extra_customization["boozehound"]]]-rest"

/datum/robot_sprite/dogborg/service/booze/handle_extra_customization(var/mob/living/silicon/robot/ourborg)
	var/choice = tgui_input_list(ourborg, "Choose your drink!", "Drink Choice", booze_options)
	if(ourborg && choice && !ourborg.stat)
		if(!("boozehound" in ourborg.sprite_extra_customization))
			ourborg.sprite_extra_customization += "boozehound"
		ourborg.sprite_extra_customization["boozehound"] = choice
		playsound(ourborg.loc, 'sound/effects/bubbles.ogg', 100, 0, 4)
		to_chat(ourborg, "<span class='filter_notice'>Your tank now displays [choice]. Drink up and enjoy!</span>")
		ourborg.update_icon()
		return 1

// Tall sprites

/datum/robot_sprite/dogborg/tall/service
	module_type = "Service"
	sprite_icon = 'icons/mob/robot/service_large.dmi'

/datum/robot_sprite/dogborg/tall/service/raptor
	name = "Raptor V-4"
	sprite_icon_state = "raptor"
	has_custom_equipment_sprites = TRUE
	rest_sprite_options = list("Default", "Bellyup")

/datum/robot_sprite/dogborg/tall/service/fancyraptor
	name = "Raptor V-4000"
	sprite_icon_state = "fancyraptor"
	has_custom_equipment_sprites = TRUE
	rest_sprite_options = list("Default", "Bellyup")

/datum/robot_sprite/dogborg/tall/service/meka
	name = "MEKA"
	sprite_icon_state = "meka"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = TRUE
	has_vore_belly_sprites = FALSE
	rest_sprite_options = list("Default", "Sit")

/datum/robot_sprite/dogborg/tall/service/newmeka
	name = "MEKA v2"
	sprite_icon_state = "newmeka"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = TRUE
	has_vore_belly_sprites = FALSE
	rest_sprite_options = list("Default", "Sit")

/datum/robot_sprite/dogborg/tall/service/mmeka
	name = "NIKO"
	sprite_icon_state = "mmeka"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = TRUE
	has_vore_belly_sprites = FALSE
	rest_sprite_options = list("Default", "Sit")

/datum/robot_sprite/dogborg/tall/service/fmeka
	name = "NIKA"
	sprite_icon_state = "fmeka"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = TRUE
	has_vore_belly_sprites = FALSE
	rest_sprite_options = list("Default", "Sit")

/datum/robot_sprite/dogborg/tall/service/k4t
	name = "K4T"
	sprite_icon_state = "k4t"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = TRUE
	has_vore_belly_sprites = FALSE
	rest_sprite_options = list("Default", "Bellyup")

/datum/robot_sprite/dogborg/tall/service/k4t_alt1
	name = "K4T Alt"
	sprite_icon_state = "k4t_alt1"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = TRUE
	has_vore_belly_sprites = FALSE
	rest_sprite_options = list("Default", "Bellyup")


// Clerical

// Regular sprites

/datum/robot_sprite/clerical
	module_type = "Clerical"
	sprite_icon = 'icons/mob/robot/clerical.dmi'

/datum/robot_sprite/clerical/default
	name = DEFAULT_ROBOT_SPRITE_NAME
	default_sprite = TRUE
	sprite_icon_state = "default"

/datum/robot_sprite/clerical/sleek
	name = "WTOperator"
	sprite_icon_state = "sleek"

/datum/robot_sprite/clerical/spider
	name = "XI-GUS"
	sprite_icon_state = "spider"

/datum/robot_sprite/clerical/drone
	name = "AG Model"
	sprite_icon_state = "drone"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/clerical/glitterfly
	name = "Pyralis"
	sprite_icon_state = "glitterfly"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/clerical/decapod
	name = "Decapod"
	sprite_icon_state = "decapod"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/clerical/pneuma
	name = "Pneuma"
	sprite_icon_state = "pneuma"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/clerical/drider
	name = "Tower"
	sprite_icon_state = "drider"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/clerical/zoomba
	name = "ZOOM-BA"
	sprite_icon_state = "zoomba"
	has_dead_sprite = TRUE

// Wide/dogborg sprites

/datum/robot_sprite/dogborg/clerical
	module_type = "Clerical"
	sprite_icon = 'icons/mob/robot/clerical_wide.dmi'

/datum/robot_sprite/dogborg/clerical/vale
	name = "Hound V2"
	sprite_icon_state = "vale"
	has_eye_light_sprites = TRUE

/datum/robot_sprite/dogborg/clerical/otie
	name = "Otieborg"
	sprite_icon_state = "otie"
	has_eye_light_sprites = TRUE

// Tall sprites
/*
/datum/robot_sprite/dogborg/tall/clerical
	module_type = "Clerical"
	sprite_icon = 'icons/mob/robot/clerical_large.dmi'

		// None yet
*/
