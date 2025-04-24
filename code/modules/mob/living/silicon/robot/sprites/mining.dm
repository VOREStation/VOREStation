// Regular sprites

/datum/robot_sprite/mining
	module_type = "Miner"
	sprite_icon = 'icons/mob/robot/mining.dmi'

/datum/robot_sprite/mining/default
	name = DEFAULT_ROBOT_SPRITE_NAME
	default_sprite = TRUE
	sprite_icon_state = "default"

/datum/robot_sprite/mining/eyebot
	name = "Cabeiri"
	sprite_icon_state = "eyebot"

/datum/robot_sprite/mining/marina
	name = "Haruka"
	sprite_icon_state = "marina"

/datum/robot_sprite/mining/toiletbot
	name = "Telemachus"
	sprite_icon_state = "toiletbot"

/datum/robot_sprite/mining/sleek
	name = "WTOperator"
	sprite_icon_state = "sleek"

/datum/robot_sprite/mining/spider
	name = "XI-GUS"
	sprite_icon_state = "spider"

/datum/robot_sprite/mining/heavy
	name = "XI-ALP"
	sprite_icon_state = "heavy"

/datum/robot_sprite/mining/old
	name = "Basic"
	sprite_icon_state = "old"
	has_eye_sprites = FALSE

/datum/robot_sprite/mining/droid
	name = "Advanced Droid"
	sprite_icon_state = "droid"

/datum/robot_sprite/mining/treadhead
	name = "Treadhead"
	sprite_icon_state = "treadhead"

/datum/robot_sprite/mining/drone
	name = "AG Model"
	sprite_icon_state = "drone"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/mining/tall2
	name = "Usagi-II"
	sprite_icon_state = "tall2"

/datum/robot_sprite/mining/glitterfly
	name = "Pyralis"
	sprite_icon_state = "glitterfly"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/mining/decapod
	name = "Decapod"
	sprite_icon_state = "decapod"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/mining/pneuma
	name = "Pneuma"
	sprite_icon_state = "pneuma"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/mining/drider
	name = "Tower"
	sprite_icon_state = "drider"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/mining/handy
	name = "Handy"
	sprite_icon_state = "handy"

/datum/robot_sprite/mining/mechoid
	name = "Acheron"
	sprite_icon_state = "mechoid"

/datum/robot_sprite/mining/noble
	name = "Shellguard Noble"
	sprite_icon_state = "noble"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/mining/zoomba
	name = "ZOOM-BA"
	sprite_icon_state = "zoomba"
	has_dead_sprite = TRUE

/datum/robot_sprite/mining/worm
	name = "W02M"
	sprite_icon_state = "worm-miner"
	sprite_icon = 'icons/mob/robot/wormborg.dmi'
	has_dead_sprite_overlay = FALSE
	has_custom_open_sprites = FALSE
	has_vore_belly_sprites = TRUE
	has_dead_sprite = TRUE

/datum/robot_sprite/mining/uptall
	name = "Feminine Humanoid"
	sprite_icon_state = "uptall"

// Wide/dogborg sprites

/datum/robot_sprite/dogborg/mining
	module_type = "Miner"
	sprite_icon = 'icons/mob/robot/mining_wide.dmi'

/datum/robot_sprite/dogborg/mining/vale
	name = "KMine"
	sprite_icon_state = "vale"
	has_eye_light_sprites = TRUE

/datum/robot_sprite/dogborg/mining/hound
	name = "Cargohound"
	sprite_icon_state = "hound"
	has_eye_light_sprites = TRUE

/datum/robot_sprite/dogborg/mining/hounddark
	name = "Cargohound Dark"
	sprite_icon_state = "hounddark"
	has_eye_light_sprites = TRUE

/datum/robot_sprite/dogborg/mining/drake
	name = "Drake"
	sprite_icon_state = "drake"

// Tall sprites

/datum/robot_sprite/dogborg/tall/mining
	module_type = "Miner"
	sprite_icon = 'icons/mob/robot/mining_large.dmi'

/datum/robot_sprite/dogborg/tall/mining/raptor
	name = "Raptor V-4"
	sprite_icon_state = "raptor"
	has_custom_equipment_sprites = TRUE
	rest_sprite_options = list("Default", "Bellyup")

/datum/robot_sprite/dogborg/tall/mining/meka
	name = "MEKA"
	sprite_icon_state = "meka"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = TRUE
	has_vore_belly_sprites = FALSE
	rest_sprite_options = list("Default", "Sit")

/datum/robot_sprite/dogborg/tall/mining/newmeka
	name = "MEKA v2"
	sprite_icon_state = "newmeka"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = TRUE
	rest_sprite_options = list("Default", "Sit")

/datum/robot_sprite/dogborg/tall/mining/mmeka
	name = "NIKO"
	sprite_icon_state = "mmeka"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = TRUE
	rest_sprite_options = list("Default", "Sit")

/datum/robot_sprite/dogborg/tall/mining/fmeka
	name = "NIKA"
	sprite_icon_state = "fmeka"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = TRUE
	rest_sprite_options = list("Default", "Sit")

/datum/robot_sprite/dogborg/tall/mining/k4t
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

/datum/robot_sprite/dogborg/tall/mining/dullahan
	name = "Dullahan Mining unit"
	sprite_icon_state = "dullahanmine"
	sprite_icon = 'icons/mob/robot/dullahan/v1/dullahan_mine.dmi'
	has_eye_light_sprites = TRUE
	has_rest_sprites = TRUE
	has_vore_belly_sprites = TRUE
	has_vore_belly_resting_sprites = TRUE
	has_rest_lights_sprites = TRUE
	has_rest_eyes_sprites = TRUE
	sprite_decals = list("breastplate","loincloth","eyecover")
	rest_sprite_options = list("Default", "sit")
	icon_x = 32
	pixel_x = 0

/datum/robot_sprite/dogborg/tall/mining/dullahanv3
	name = "Dullahan mining v3"
	sprite_icon = 'icons/mob/robot/dullahan/v3/mining.dmi'
	sprite_icon_state = "dullahanmining"
	has_eye_light_sprites = TRUE
	has_rest_sprites = TRUE
	has_vore_belly_sprites = TRUE
	rest_sprite_options = list("Default", "Sit")
	sprite_decals = list("decals")
	icon_x = 64
	pixel_x = -16

/datum/robot_sprite/dogborg/tall/mining/dullahancargo
	name = "Dullahan Cargo unit"
	sprite_icon_state = "dullahancargo"
	sprite_icon = 'icons/mob/robot/dullahan/v1/dullahan_cargo.dmi'
	has_eye_light_sprites = TRUE
	has_rest_sprites = TRUE
	has_vore_belly_sprites = TRUE
	has_vore_belly_resting_sprites = TRUE
	has_rest_lights_sprites = TRUE
	has_rest_eyes_sprites = TRUE
	rest_sprite_options = list("Default", "Sit")
	sprite_decals = list("breastplate","eyecover")
	icon_x = 32
	pixel_x = 0

/datum/robot_sprite/dogborg/mining/cat
	name = "Cat - Mining"
	sprite_icon = 'icons/mob/robot/catborg_variant.dmi'
	sprite_icon_state = "vixmine"
	has_vore_belly_resting_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_dead_sprite_overlay = FALSE

/datum/robot_sprite/dogborg/mining/catcargo
	name = "Cat - Cargo"
	sprite_icon = 'icons/mob/robot/catborg_variant.dmi'
	sprite_icon_state = "vixcargo"
	has_vore_belly_resting_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_dead_sprite_overlay = FALSE

/datum/robot_sprite/dogborg/tall/mining/tall
	sprite_icon = 'icons/mob/robot/tallrobot/tallrobots.dmi'
	pixel_x = 0

/datum/robot_sprite/dogborg/tall/mining/tall/mekacargo
	name = "MEKA - Cargo"
	sprite_icon_state = "mekacargo"
	has_eye_light_sprites = TRUE
	has_vore_belly_sprites = FALSE
	rest_sprite_options = list("Default", "Sit")
	icon_x = 32
	pixel_x = 0

/datum/robot_sprite/dogborg/tall/mining/tall/mmekacargo
	name = "NIKO - Cargo"
	sprite_icon_state = "mmekacargo"
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = TRUE
	rest_sprite_options = list("Default", "Sit")
	icon_x = 32
	pixel_x = 0

/datum/robot_sprite/dogborg/tall/mining/tall/fmekacargo
	name = "NIKA - Cargo"
	sprite_icon_state = "fmekacargo"
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = TRUE
	rest_sprite_options = list("Default", "Sit")
	icon_x = 32
	pixel_x = 0

/datum/robot_sprite/dogborg/tall/mining/tall/k4tcargo
	name = "K4T - Cargo"
	sprite_icon_state = "k4tcargo"
	has_eye_light_sprites = TRUE
	has_vore_belly_sprites = FALSE
	rest_sprite_options = list("Default", "Bellyup")
	icon_x = 32
	pixel_x = 0

/datum/robot_sprite/dogborg/tall/mining/tall/k4t_alt1cargo
	name = "K4Talt - Cargo"
	sprite_icon_state = "k4tcargo_alt1"
	has_eye_light_sprites = TRUE
	has_vore_belly_sprites = FALSE
	rest_sprite_options = list("Default", "Bellyup")
	icon_x = 32
	pixel_x = 0

/datum/robot_sprite/dogborg/mining/smolraptorminer
	sprite_icon = 'icons/mob/robot/smallraptors/smolraptor_min.dmi'
	name = "Small Raptor Miner"
	sprite_icon_state = "smolraptor"
	has_eye_light_sprites = TRUE
	has_vore_belly_sprites = TRUE
	has_dead_sprite_overlay = FALSE
	rest_sprite_options = list("Default", "Sit")

/datum/robot_sprite/dogborg/mining/smolraptorcargo
	sprite_icon = 'icons/mob/robot/smallraptors/smolraptor_car.dmi'
	name = "Small Raptor Cargo"
	sprite_icon_state = "smolraptor"
	has_eye_light_sprites = TRUE
	has_vore_belly_sprites = TRUE
	has_dead_sprite_overlay = FALSE
	rest_sprite_options = list("Default", "Sit")
