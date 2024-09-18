// Regular sprites

/datum/robot_sprite/janitor
	module_type = "Janitor"
	sprite_icon = 'icons/mob/robot/janitor.dmi'

/datum/robot_sprite/janitor/default
	name = DEFAULT_ROBOT_SPRITE_NAME
	default_sprite = TRUE
	sprite_icon_state = "default"

/datum/robot_sprite/janitor/crawler
	name = "Arachne"
	sprite_icon_state = "crawler"

/datum/robot_sprite/janitor/eyebot
	name = "Cabeiri"
	sprite_icon_state = "eyebot"

/datum/robot_sprite/janitor/marina
	name = "Haruka"
	sprite_icon_state = "marina"

/datum/robot_sprite/janitor/toiletbot
	name = "Telemachus"
	sprite_icon_state = "toiletbot"

/datum/robot_sprite/janitor/sleek
	name = "WTOperator"
	sprite_icon_state = "sleek"

/datum/robot_sprite/janitor/heavy
	name = "XI-ALP"
	sprite_icon_state = "heavy"

/datum/robot_sprite/janitor/old
	name = "Basic"
	sprite_icon_state = "old"
	has_eye_sprites = FALSE

/datum/robot_sprite/janitor/mopbot
	name = "Mopbot"
	sprite_icon_state = "mopbot"
	has_eye_sprites = FALSE

/datum/robot_sprite/janitor/mopgearrex
	name = "Mop Gear Rex"
	sprite_icon_state = "mopgearrex"

/datum/robot_sprite/janitor/drone
	name = "AG Model"
	sprite_icon_state = "drone"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/janitor/tall2
	name = "Usagi-II"
	sprite_icon_state = "tall2"

/datum/robot_sprite/janitor/glitterfly
	name = "Pyralis"
	sprite_icon_state = "glitterfly"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/janitor/decapod
	name = "Decapod"
	sprite_icon_state = "decapod"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/janitor/pneuma
	name = "Pneuma"
	sprite_icon_state = "pneuma"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/janitor/drider
	name = "Tower"
	sprite_icon_state = "drider"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/janitor/handy
	name = "Handy"
	sprite_icon_state = "handy"

/datum/robot_sprite/janitor/mechoid
	name = "Acheron"
	sprite_icon_state = "mechoid"

/datum/robot_sprite/janitor/noble
	name = "Shellguard Noble"
	sprite_icon_state = "noble"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/janitor/zoomba
	name = "ZOOM-BA"
	sprite_icon_state = "zoomba"
	has_dead_sprite = TRUE

/datum/robot_sprite/janitor/worm
	name = "W02M"
	sprite_icon_state = "worm"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/janitor/uptall
	name = "Feminine Humanoid"
	sprite_icon_state = "uptall"

// Wide/dogborg sprites

/datum/robot_sprite/dogborg/janitor
	module_type = "Janitor"
	sprite_icon = 'icons/mob/robot/janitor_wide.dmi'

/datum/robot_sprite/dogborg/janitor/scrubpup
	name = "Scrubpup"
	sprite_icon_state = "scrubpup"
	sprite_hud_icon_state = "janihound"
	has_eye_light_sprites = TRUE

/datum/robot_sprite/dogborg/janitor/vale
	name = "Hound V2"
	sprite_icon_state = "vale"
	sprite_hud_icon_state = "janihound"
	has_eye_light_sprites = TRUE

/datum/robot_sprite/dogborg/janitor/borgi
	name = "Borgi"
	sprite_icon_state = "borgi"
	sprite_hud_icon_state = "janihound"
	has_eye_sprites = FALSE
	has_eye_light_sprites = TRUE
	has_dead_sprite_overlay = FALSE

/datum/robot_sprite/dogborg/janitor/otie
	name = "Otieborg"
	sprite_icon_state = "otie"
	sprite_hud_icon_state = "janihound"
	has_eye_light_sprites = TRUE

/datum/robot_sprite/dogborg/janitor/drake
	name = "Drake"
	sprite_icon_state = "drake"

// Tall sprites

/datum/robot_sprite/dogborg/tall/janitor
	module_type = "Janitor"
	sprite_icon = 'icons/mob/robot/janitor_large.dmi'

/datum/robot_sprite/dogborg/tall/janitor/raptor
	name = "Raptor V-4"
	sprite_icon_state = "raptor"
	has_custom_equipment_sprites = TRUE
	rest_sprite_options = list("Default", "Bellyup")

/datum/robot_sprite/dogborg/tall/janitor/meka
	name = "MEKA"
	sprite_icon_state = "meka"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = TRUE
	has_vore_belly_sprites = FALSE
	rest_sprite_options = list("Default", "Sit")

/datum/robot_sprite/dogborg/tall/janitor/newmeka
	name = "MEKA v2"
	sprite_icon_state = "newmeka"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = TRUE
	has_vore_belly_sprites = FALSE
	rest_sprite_options = list("Default", "Sit")

/datum/robot_sprite/dogborg/tall/janitor/mmeka
	name = "NIKO"
	sprite_icon_state = "mmeka"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = TRUE
	has_vore_belly_sprites = FALSE
	rest_sprite_options = list("Default", "Sit")

/datum/robot_sprite/dogborg/tall/janitor/fmeka
	name = "NIKA"
	sprite_icon_state = "fmeka"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = TRUE
	has_vore_belly_sprites = FALSE
	rest_sprite_options = list("Default", "Sit")

/datum/robot_sprite/dogborg/tall/janitor/k4t
	name = "K4T"
	sprite_icon_state = "k4t"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = TRUE
	has_vore_belly_sprites = FALSE
	rest_sprite_options = list("Default", "Bellyup")

/datum/robot_sprite/dogborg/tall/mining/k4t_alt1
	name = "K4T Alt"
	sprite_icon_state = "k4t_alt1"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = TRUE
	has_vore_belly_sprites = FALSE
	rest_sprite_options = list("Default", "Bellyup")
