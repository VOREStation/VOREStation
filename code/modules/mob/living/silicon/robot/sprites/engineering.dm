// Regular sprites

/datum/robot_sprite/engineering
	module_type = "Engineering"
	sprite_icon = 'icons/mob/robot/engineering.dmi'

/datum/robot_sprite/engineering/default
	name = DEFAULT_ROBOT_SPRITE_NAME
	default_sprite = TRUE
	sprite_icon_state = "default"

/datum/robot_sprite/engineering/eyebot
	name = "Cabeiri"
	sprite_icon_state = "eyebot"

/datum/robot_sprite/engineering/marina
	name = "Haruka"
	sprite_icon_state = "marina"

/datum/robot_sprite/engineering/tall
	name = "Usagi"
	sprite_icon_state = "tall"

/datum/robot_sprite/engineering/toiletbot
	name = "Telemachus"
	sprite_icon_state = "toiletbot"

/datum/robot_sprite/engineering/sleek
	name = "WTOperator"
	sprite_icon_state = "sleek"

/datum/robot_sprite/engineering/spider
	name = "XI-GUS"
	sprite_icon_state = "spider"

/datum/robot_sprite/engineering/heavy
	name = "XI-ALP"
	sprite_icon_state = "heavy"

/datum/robot_sprite/engineering/old
	name = "Basic"
	sprite_icon_state = "old"

/datum/robot_sprite/engineering/oldbot
	name = "Antique"
	sprite_icon_state = "oldbot"
	has_eye_sprites = FALSE

/datum/robot_sprite/engineering/landmate
	name = "Landmate"
	sprite_icon_state = "landmate"

/datum/robot_sprite/engineering/landmatetread
	name = "Landmate-Treaded"
	sprite_icon_state = "landmatetread"

/datum/robot_sprite/engineering/drone
	name = "AG Model"
	sprite_icon_state = "drone"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/engineering/treadwell
	name = "Treadwell"
	sprite_icon_state = "treadwell"

/datum/robot_sprite/engineering/handy
	name = "Handy"
	sprite_icon_state = "handy"

/datum/robot_sprite/engineering/tall2
	name = "Usagi-II"
	sprite_icon_state = "tall2"

/datum/robot_sprite/engineering/glitterfly
	name = "Pyralis"
	sprite_icon_state = "glitterfly"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/engineering/decapod
	name = "Decapod"
	sprite_icon_state = "decapod"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/engineering/pneuma
	name = "Pneuma"
	sprite_icon_state = "pneuma"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/engineering/drider
	name = "Tower"
	sprite_icon_state = "drider"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/engineering/mechoid
	name = "Acheron"
	sprite_icon_state = "mechoid"

/datum/robot_sprite/engineering/noble
	name = "Shellguard Noble"
	sprite_icon_state = "noble"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/engineering/zoomba
	name = "ZOOM-BA"
	sprite_icon_state = "zoomba"
	has_dead_sprite = TRUE


/datum/robot_sprite/engineering/worm
	name = "W02M"
	sprite_icon_state = "worm-engineering"

	sprite_icon = 'icons/mob/robot/wormborg.dmi'
	has_dead_sprite_overlay = FALSE
	has_custom_open_sprites = FALSE
	has_vore_belly_sprites = TRUE
	has_dead_sprite = TRUE

/datum/robot_sprite/engineering/uptall
	name = "Feminine Humanoid"
	sprite_icon_state = "uptall"

// Wide/dogborg sprites

/datum/robot_sprite/dogborg/engineering
	module_type = "Engineering"
	sprite_icon = 'icons/mob/robot/engineering_wide.dmi'

/datum/robot_sprite/dogborg/engineering/pupdozer
	name = "Pupdozer"
	sprite_icon_state = "pupdozer"
	sprite_hud_icon_state = "pupdozer"
	rest_sprite_options = list("Default")
	has_eye_light_sprites = TRUE

/datum/robot_sprite/dogborg/engineering/borgi
	name = "Borgi"
	sprite_icon_state = "borgi"
	sprite_hud_icon_state = "pupdozer"
	has_eye_sprites = FALSE
	has_eye_light_sprites = TRUE
	has_dead_sprite_overlay = FALSE

/datum/robot_sprite/dogborg/engineering/vale
	name = "Hound V2"
	sprite_icon_state = "vale"
	sprite_hud_icon_state = "pupdozer"
	has_eye_light_sprites = TRUE

/datum/robot_sprite/dogborg/engineering/hound
	name = "Hound"
	sprite_icon_state = "hound"
	sprite_hud_icon_state = "pupdozer"
	has_eye_light_sprites = TRUE

/datum/robot_sprite/dogborg/engineering/hounddark
	name = "Hound Dark"
	sprite_icon_state = "hounddark"
	sprite_hud_icon_state = "pupdozer"
	has_eye_light_sprites = TRUE

/datum/robot_sprite/dogborg/engineering/drake
	name = "Drake"
	sprite_icon_state = "drake"

// Tall sprites

/datum/robot_sprite/dogborg/tall/engineering
	module_type = "Engineering"
	sprite_icon = 'icons/mob/robot/engineering_large.dmi'

/datum/robot_sprite/dogborg/tall/engineering/raptor
	name = "Raptor V-4"
	sprite_icon_state = "raptor"
	has_custom_equipment_sprites = TRUE
	rest_sprite_options = list("Default", "Bellyup")

/datum/robot_sprite/dogborg/tall/engineering/meka
	name = "MEKA"
	sprite_icon_state = "meka"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = TRUE
	has_vore_belly_sprites = FALSE
	rest_sprite_options = list("Default", "Sit")

/datum/robot_sprite/dogborg/tall/engineering/newmeka
	name = "MEKA v2"
	sprite_icon_state = "newmeka"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = TRUE
	rest_sprite_options = list("Default", "Sit")

/datum/robot_sprite/dogborg/tall/engineering/mmeka
	name = "NIKO"
	sprite_icon_state = "mmeka"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = TRUE
	rest_sprite_options = list("Default", "Sit")

/datum/robot_sprite/dogborg/tall/engineering/fmeka
	name = "NIKA"
	sprite_icon_state = "fmeka"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = TRUE
	rest_sprite_options = list("Default", "Sit")

/datum/robot_sprite/dogborg/tall/engineering/k4t
	name = "K4T"
	sprite_icon_state = "k4t"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = TRUE
	has_vore_belly_sprites = FALSE
	rest_sprite_options = list("Default", "Bellyup")

/datum/robot_sprite/dogborg/tall/engineering/k4t_alt1
	name = "K4T Alt"
	sprite_icon_state = "k4t_alt1"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = TRUE
	has_vore_belly_sprites = FALSE
	rest_sprite_options = list("Default", "Bellyup")

/datum/robot_sprite/dogborg/tall/engineering/dullahan
	name = "Dullahan"
	sprite_icon_state = "dullahaneng"
	sprite_icon = 'icons/mob/robot/dullahan/v1/dullahan_eng.dmi'
	rest_sprite_options = list("Default", "Sit")
	sprite_decals = list("breastplate","loincloth","eyecover")
	has_eye_light_sprites = TRUE
	has_rest_sprites = TRUE
	has_vore_belly_sprites = TRUE
	has_vore_belly_resting_sprites = TRUE
	icon_x = 32
	pixel_x = 0

/datum/robot_sprite/dogborg/tall/engineering/dullahanv3
	name = "Dullahan v3"
	sprite_icon = 'icons/mob/robot/dullahan/v3/engineer.dmi'
	sprite_icon_state = "dullahanengineer"
	has_eye_light_sprites = TRUE
	has_rest_sprites = TRUE
	has_vore_belly_sprites = TRUE
	rest_sprite_options = list("Default", "Sit")
	icon_x = 64
	pixel_x = -16

/datum/robot_sprite/dogborg/engineering/cat
	name = "Cat"
	sprite_icon = 'icons/mob/robot/catborg_variant.dmi'
	sprite_icon_state = "vixengi"
	has_eye_light_sprites = TRUE
	has_vore_belly_resting_sprites = TRUE
	has_dead_sprite_overlay = FALSE

/datum/robot_sprite/dogborg/engineering/smolraptorengineeringsprite
	sprite_icon = 'icons/mob/robot/smallraptors/smolraptor_eng.dmi'
	name = "Small Raptor"
	sprite_icon_state = "smolraptor"
	has_dead_sprite_overlay = FALSE
	has_eye_light_sprites = TRUE
	has_vore_belly_sprites = TRUE
	rest_sprite_options = list("Default", "Sit")
