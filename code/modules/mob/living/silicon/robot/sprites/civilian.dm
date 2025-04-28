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
	sprite_icon_state = "worm-service"
	sprite_icon = 'icons/mob/robot/wormborg.dmi'
	has_dead_sprite_overlay = FALSE
	has_custom_open_sprites = FALSE
	has_vore_belly_sprites = TRUE
	has_dead_sprite = TRUE

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
	sprite_icon_state = "drone"
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

	var/list/booze_options = list(REAGENT_BEER = "booze",
								  "Space Mountain Wind" = "boozegreen",
								  "Curacao" = "boozeblue",
								  REAGENT_GRAPESODA = "boozepurple",
								  "Demon's Blood" = "boozered",
								  REAGENT_WHISKEYSODA = "boozeorange",
								  REAGENT_COFFEE = "boozebrown")

/datum/robot_sprite/dogborg/service/booze/handle_extra_icon_updates(var/mob/living/silicon/robot/ourborg)
	if(!("boozehound" in ourborg.sprite_extra_customization) || !ourborg.sprite_extra_customization["boozehound"])
		return ..()
	else
		ourborg.icon_state = booze_options[ourborg.sprite_extra_customization["boozehound"]]

/datum/robot_sprite/dogborg/service/booze/get_belly_overlay(var/mob/living/silicon/robot/ourborg, var/size = 1, var/b_class)
	if(!("boozehound" in ourborg.sprite_extra_customization) || !ourborg.sprite_extra_customization["boozehound"] || b_class != "sleeper")
		return ..()
	else
		return "[booze_options[ourborg.sprite_extra_customization["boozehound"]]]-[b_class]-[size]"

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
		to_chat(ourborg, span_filter_notice("Your tank now displays [choice]. Drink up and enjoy!"))
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
	rest_sprite_options = list("Default", "Sit")

/datum/robot_sprite/dogborg/tall/service/mmeka
	name = "NIKO"
	sprite_icon_state = "mmeka"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = TRUE
	rest_sprite_options = list("Default", "Sit")

/datum/robot_sprite/dogborg/tall/service/fmeka
	name = "NIKA"
	sprite_icon_state = "fmeka"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = TRUE
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

/datum/robot_sprite/dogborg/tall/service/dullahan
	name = "Dullahan"
	sprite_icon_state = "dullahanserv"
	sprite_icon = 'icons/mob/robot/dullahan/v1/dullahan_serv.dmi'
	rest_sprite_options = list("Default", "Sit")
	has_eye_light_sprites = TRUE
	has_rest_sprites = TRUE
	has_vore_belly_sprites = TRUE
	has_vore_belly_resting_sprites = TRUE
	has_rest_lights_sprites = TRUE
	has_rest_eyes_sprites = TRUE
	sprite_decals = list("breastplate", "loincloth","loinclothbreastplate","eyecover")
	pixel_x = 0
	icon_x = 32

/datum/robot_sprite/dogborg/tall/service/dullataur
	name = "Dullataur"
	sprite_icon_state = "dullataurserv"
	sprite_icon = 'icons/mob/robot/dullahan/dullataurs/dullataur.dmi'
	rest_sprite_options = list("Default")
	has_eye_light_sprites = TRUE
	has_rest_sprites = TRUE
	has_vore_belly_sprites = FALSE
	has_vore_belly_resting_sprites = FALSE
	has_rest_lights_sprites = TRUE
	has_rest_eyes_sprites = TRUE
	sprite_decals = list("breastplate")
	icon_x = 32
	pixel_x = 0

/datum/robot_sprite/dogborg/tall/service/dullahanv3
	name = "Dullahan v3"
	sprite_icon = 'icons/mob/robot/dullahan/v3/service.dmi'
	sprite_icon_state = "dullahanservice"
	sprite_decals = list("decals")
	has_eye_light_sprites = TRUE
	has_rest_sprites = TRUE
	has_vore_belly_sprites = TRUE
	rest_sprite_options = list("Default", "Sit")
	icon_x = 64
	pixel_x = -16

/datum/robot_sprite/dogborg/tall/service/dullahanv3/servicealt3
	name = "Dullahan v3 matcha"
	sprite_icon = 'icons/mob/robot/dullahan/v3/barista.dmi'
	sprite_icon_state = "dullahanbarista"
	sprite_decals = list("decals")
	icon_x = 64
	pixel_x = -16

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

/datum/robot_sprite/dogborg/clown
	module_type = "Clown"
	sprite_icon = 'icons/mob/robot/widerobot/widerobot.dmi'

/datum/robot_sprite/dogborg/clown/vale
	name = "Honkhound V2"
	sprite_icon_state = "honkborg"
	has_eye_light_sprites = TRUE

/datum/robot_sprite/dogborg/tall/clown
	module_type = "Clown"
	sprite_icon = 'icons/mob/robot/tallrobot/tallrobots.dmi'
	pixel_x = 0

/datum/robot_sprite/dogborg/tall/clown/k4t
	name = "K4T"
	sprite_icon_state = "k4tclown"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = FALSE
	has_vore_belly_sprites = FALSE
	rest_sprite_options = list("Default", "Bellyup")
	icon_x = 32

/datum/robot_sprite/dogborg/tall/clown/dullahan
	name = "Dullahan"
	sprite_icon = 'icons/mob/robot/dullahan/v1/dullahan_clown.dmi'
	sprite_icon_state = "dullahanclown"
	has_eye_light_sprites = TRUE
	has_vore_belly_sprites = TRUE
	sprite_decals = list("breastplate")
	rest_sprite_options = list("Default", "Sit")
	pixel_x = 0
	icon_x = 32

/datum/robot_sprite/dogborg/clown/stoat
	name = "ST-04t"
	sprite_icon = 'icons/mob/robot/stoatborg.dmi'
	sprite_icon_state = "stoatclown"
	has_eye_light_sprites = TRUE
	has_vore_belly_resting_sprites = TRUE
	has_dead_sprite_overlay = FALSE
	rest_sprite_options = list("Default")

/datum/robot_sprite/dogborg/service/valech
	name = "ServicehoundV2 - Alt"
	sprite_icon = 'icons/mob/robot/widerobot/widerobot.dmi'
	sprite_icon_state = "servborg"
	rest_sprite_options = list("Default")
	has_eye_light_sprites = TRUE

/datum/robot_sprite/dogborg/service/cat
	name = "Cat"
	sprite_icon = 'icons/mob/robot/catborg_variant.dmi'
	sprite_icon_state = "vixserv"
	has_vore_belly_resting_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_dead_sprite_overlay = FALSE

/datum/robot_sprite/dogborg/tall/service/mekaserve_alt
	sprite_icon = 'icons/mob/robot/tallrobot/tallrobots.dmi'
	name = "MEKA Alt"
	sprite_icon_state = "mekaserve_alt"
	rest_sprite_options = list("Default", "Sit")
	icon_x = 32
	pixel_x = 0


/datum/robot_sprite/dogborg/service/smolraptorservicesprite
	sprite_icon = 'icons/mob/robot/smallraptors/smolraptor_serv.dmi'

/datum/robot_sprite/dogborg/service/smolraptorservicesprite/smolraptorserv
	name = "Small Raptor"
	sprite_icon_state = "smolraptor"
	has_dead_sprite_overlay = FALSE
	has_eye_light_sprites = TRUE
	has_vore_belly_sprites = TRUE
	rest_sprite_options = list("Default", "Sit")
