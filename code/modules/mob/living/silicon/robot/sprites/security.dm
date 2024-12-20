// Regular sprites

/datum/robot_sprite/security
	module_type = "Security"
	sprite_icon = 'icons/mob/robot/security.dmi'

/datum/robot_sprite/security/default
	name = DEFAULT_ROBOT_SPRITE_NAME
	default_sprite = TRUE
	sprite_icon_state = "default"

/datum/robot_sprite/security/eyebot
	name = "Cabeiri"
	sprite_icon_state = "eyebot"

/datum/robot_sprite/security/bloodhound
	name = "Cerberus"
	sprite_icon_state = "bloodhound"

/datum/robot_sprite/security/treadhound
	name = "Cerberus-Treaded"
	sprite_icon_state = "treadhound"

/datum/robot_sprite/security/marina
	name = "Haruka"
	sprite_icon_state = "marina"

/datum/robot_sprite/security/tall
	name = "Usagi"
	sprite_icon_state = "tall"

/datum/robot_sprite/security/toiletbot
	name = "Telemachus"
	sprite_icon_state = "toiletbot"

/datum/robot_sprite/security/sleek
	name = "WTOperator"
	sprite_icon_state = "sleek"

/datum/robot_sprite/security/spider
	name = "XI-GUS"
	sprite_icon_state = "spider"

/datum/robot_sprite/security/heavy
	name = "XI-ALP"
	sprite_icon_state = "heavy"

/datum/robot_sprite/security/old
	name = "Basic"
	sprite_icon_state = "old"
	has_eye_sprites = FALSE

/datum/robot_sprite/security/oldbot
	name = "Black Knight"
	sprite_icon_state = "oldbot"
	has_eye_sprites = FALSE

/datum/robot_sprite/security/drone
	name = "AG Model"
	sprite_icon_state = "drone"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/security/insekt
	name = "Insekt"
	sprite_icon_state = "insekt"

/datum/robot_sprite/security/tall2
	name = "Usagi-II"
	sprite_icon_state = "tall2"

/datum/robot_sprite/security/glitterfly
	name = "Pyralis"
	sprite_icon_state = "glitterfly"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/security/decapod
	name = "Decapod"
	sprite_icon_state = "decapod"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/security/pneuma
	name = "Pneuma"
	sprite_icon_state = "pneuma"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/security/drider
	name = "Tower"
	sprite_icon_state = "drider"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/security/handy
	name = "Handy"
	sprite_icon_state = "handy"

/datum/robot_sprite/security/mechoid
	name = "Acheron"
	sprite_icon_state = "mechoid"

/datum/robot_sprite/security/noble
	name = "Shellguard Noble"
	sprite_icon_state = "noble"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/security/zoomba
	name = "ZOOM-BA"
	sprite_icon_state = "zoomba"
	has_dead_sprite = TRUE

/datum/robot_sprite/security/worm
	name = "W02M"
	sprite_icon_state = "worm"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/security/uptall
	name = "Feminine Humanoid"
	sprite_icon_state = "uptall"

// Wide/dogborg sprites

/datum/robot_sprite/dogborg/security
	module_type = "Security"
	sprite_icon = 'icons/mob/robot/security_wide.dmi'

/datum/robot_sprite/dogborg/security/k9
	name = "K9"
	sprite_icon_state = "k9"
	sprite_hud_icon_state = "k9"
	has_eye_light_sprites = TRUE
	sprite_flags = ROBOT_HAS_TASER_SPRITE | ROBOT_HAS_LASER_SPRITE

/datum/robot_sprite/dogborg/security/k92
	name = "K9 Alt"
	sprite_icon_state = "k92"
	sprite_hud_icon_state = "k9"
	has_eye_sprites = FALSE
	sprite_flags = ROBOT_HAS_TASER_SPRITE | ROBOT_HAS_LASER_SPRITE

/datum/robot_sprite/dogborg/security/vale
	name = "Hound V2"
	sprite_icon_state = "vale"
	sprite_hud_icon_state = "k9"
	has_eye_light_sprites = TRUE
	sprite_flags = ROBOT_HAS_TASER_SPRITE | ROBOT_HAS_LASER_SPRITE

/datum/robot_sprite/dogborg/security/borgi
	name = "Borgi"
	sprite_icon_state = "borgi"
	sprite_hud_icon_state = "k9"
	has_eye_sprites = FALSE
	has_eye_light_sprites = TRUE
	has_dead_sprite_overlay = FALSE

/datum/robot_sprite/dogborg/security/otie
	name = "Otieborg"
	sprite_icon_state = "otie"
	sprite_hud_icon_state = "k9"
	has_eye_light_sprites = TRUE
	sprite_flags = ROBOT_HAS_TASER_SPRITE | ROBOT_HAS_LASER_SPRITE

/datum/robot_sprite/dogborg/security/drake
	name = "Drake"
	sprite_icon_state = "drake"
	sprite_flags = ROBOT_HAS_TASER_SPRITE | ROBOT_HAS_LASER_SPRITE

// Tall sprites

/datum/robot_sprite/dogborg/tall/security
	module_type = "Security"
	sprite_icon = 'icons/mob/robot/security_large.dmi'

/datum/robot_sprite/dogborg/tall/security/raptor
	name = "Raptor V-4"
	sprite_icon_state = "raptor"
	has_custom_equipment_sprites = TRUE
	sprite_flags = ROBOT_HAS_TASER_SPRITE | ROBOT_HAS_LASER_SPRITE
	rest_sprite_options = list("Default", "Bellyup")

/datum/robot_sprite/dogborg/tall/security/meka
	name = "MEKA"
	sprite_icon_state = "meka"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = TRUE
	has_vore_belly_sprites = FALSE
	rest_sprite_options = list("Default", "Sit")

/datum/robot_sprite/dogborg/tall/security/newmeka
	name = "MEKA v2"
	sprite_icon_state = "newmeka"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = TRUE
	rest_sprite_options = list("Default", "Sit")

/datum/robot_sprite/dogborg/tall/security/mmeka
	name = "NIKO"
	sprite_icon_state = "mmeka"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = TRUE
	rest_sprite_options = list("Default", "Sit")

/datum/robot_sprite/dogborg/tall/security/fmeka
	name = "NIKA"
	sprite_icon_state = "fmeka"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = TRUE
	rest_sprite_options = list("Default", "Sit")

/datum/robot_sprite/dogborg/tall/security/k4t
	name = "K4T"
	sprite_icon_state = "k4t"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = TRUE
	has_vore_belly_sprites = FALSE
	rest_sprite_options = list("Default", "Bellyup")
