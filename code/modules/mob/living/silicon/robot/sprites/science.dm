// Regular sprites

/datum/robot_sprite/science
	module_type = "Research"
	sprite_icon = 'icons/mob/robot/science.dmi'

/datum/robot_sprite/science/default
	name = DEFAULT_ROBOT_SPRITE_NAME
	default_sprite = TRUE
	sprite_icon_state = "default"

/datum/robot_sprite/science/peaceborg
	name = "L'Ouef"
	sprite_icon_state = "peaceborg"

/datum/robot_sprite/science/eyebot
	name = "Cabeiri"
	sprite_icon_state = "eyebot"

/datum/robot_sprite/science/marina
	name = "Haruka"
	sprite_icon_state = "marina"

/datum/robot_sprite/science/whitespider
	name = "WTDove"
	sprite_icon_state = "whitespider"

/datum/robot_sprite/science/sleek
	name = "WTOperator"
	sprite_icon_state = "sleek"

/datum/robot_sprite/science/droid
	name = "Droid"
	sprite_icon_state = "droid"

/datum/robot_sprite/science/drone
	name = "AG Model"
	sprite_icon_state = "drone"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/science/handy
	name = "Handy"
	sprite_icon_state = "handy"

/datum/robot_sprite/science/insekt
	name = "Insekt"
	sprite_icon_state = "insekt"

/datum/robot_sprite/science/tall2
	name = "Usagi-II"
	sprite_icon_state = "tall2"

/datum/robot_sprite/science/glitterfly
	name = "Pyralis"
	sprite_icon_state = "glitterfly"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/science/decapod
	name = "Decapod"
	sprite_icon_state = "decapod"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/science/pneuma
	name = "Pneuma"
	sprite_icon_state = "pneuma"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/science/drider
	name = "Tower"
	sprite_icon_state = "drider"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/science/mechoid
	name = "Acheron"
	sprite_icon_state = "mechoid"

/datum/robot_sprite/science/zoomba
	name = "ZOOM-BA"
	sprite_icon_state = "zoomba"
	has_dead_sprite = TRUE

/datum/robot_sprite/science/spider
	name = "XI-GUS"
	sprite_icon_state = "spider"


/datum/robot_sprite/science/worm
	name = "W02M"
	sprite_icon_state = "worm-science"
	sprite_icon = 'icons/mob/robot/wormborg.dmi'
	has_dead_sprite_overlay = FALSE
	has_custom_open_sprites = FALSE
	has_vore_belly_sprites = TRUE
	has_dead_sprite = TRUE

/datum/robot_sprite/science/uptall
	name = "Feminine Humanoid"
	sprite_icon_state = "uptall"

// Wide sprites

/datum/robot_sprite/dogborg/science
	module_type = "Research"
	sprite_icon = 'icons/mob/robot/science_wide.dmi'

/datum/robot_sprite/dogborg/science/do_equipment_glamour(var/obj/item/robot_module/module)
	if(!has_custom_equipment_sprites)
		return

	..()

	var/obj/item/shockpaddles/robot/jumper/J = locate() in module.modules
	if(J)
		J.name = "jumper paws"
		J.desc = "Zappy paws. For rebooting a full body prostetic."
		J.icon = 'icons/mob/dogborg_vr.dmi'
		J.icon_state = "defibpaddles0"
		J.attack_verb = list("batted", "pawed", "bopped", "whapped")

/datum/robot_sprite/dogborg/science/vale
	name = "Hound V2"
	sprite_icon_state = "vale"
	sprite_hud_icon_state = "sci-borg"
	has_eye_light_sprites = TRUE

/datum/robot_sprite/dogborg/science/borgi
	name = "Borgi"
	sprite_icon_state = "borgi"
	sprite_hud_icon_state = "sci-borg"
	has_eye_sprites = FALSE
	has_eye_light_sprites = TRUE
	has_dead_sprite_overlay = FALSE

/datum/robot_sprite/dogborg/science/hound
	name = "Hound"
	sprite_icon_state = "hound"
	sprite_hud_icon_state = "sci-borg"
	has_eye_light_sprites = TRUE

/datum/robot_sprite/dogborg/science/darkhound
	name = "Hound Dark"
	sprite_icon_state = "hounddark"
	sprite_hud_icon_state = "sci-borg"
	has_eye_light_sprites = TRUE

/datum/robot_sprite/dogborg/science/drake
	name = "Drake"
	sprite_icon_state = "drake"

// Tall sprites

/datum/robot_sprite/dogborg/tall/science
	module_type = "Research"
	sprite_icon = 'icons/mob/robot/science_large.dmi'

/datum/robot_sprite/dogborg/tall/science/do_equipment_glamour(var/obj/item/robot_module/module)
	if(!has_custom_equipment_sprites)
		return

	..()

	var/obj/item/shockpaddles/robot/jumper/J = locate() in module.modules
	if(J)
		J.name = "jumper paws"
		J.desc = "Zappy paws. For rebooting a full body prostetic."
		J.icon = 'icons/mob/dogborg_vr.dmi'
		J.icon_state = "defibpaddles0"
		J.attack_verb = list("batted", "pawed", "bopped", "whapped")

/datum/robot_sprite/dogborg/tall/science/raptor
	name = "Raptor V-4"
	sprite_icon_state = "raptor"
	has_custom_equipment_sprites = TRUE
	sprite_flags = ROBOT_HAS_TASER_SPRITE
	rest_sprite_options = list("Default", "Bellyup")

/datum/robot_sprite/dogborg/tall/science/meka
	name = "MEKA"
	sprite_icon_state = "meka"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = TRUE
	has_vore_belly_sprites = FALSE
	rest_sprite_options = list("Default", "Sit")

/datum/robot_sprite/dogborg/tall/science/newmeka
	name = "MEKA v2"
	sprite_icon_state = "newmeka"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = TRUE
	rest_sprite_options = list("Default", "Sit")

/datum/robot_sprite/dogborg/tall/science/mmeka
	name = "NIKO"
	sprite_icon_state = "mmeka"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = TRUE
	rest_sprite_options = list("Default", "Sit")

/datum/robot_sprite/dogborg/tall/science/fmeka
	name = "NIKA"
	sprite_icon_state = "fmeka"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = TRUE
	rest_sprite_options = list("Default", "Sit")

/datum/robot_sprite/dogborg/tall/science/k4t
	name = "K4T"
	sprite_icon_state = "k4t"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = TRUE
	has_vore_belly_sprites = FALSE
	rest_sprite_options = list("Default", "Bellyup")


/datum/robot_sprite/dogborg/tall/science/dullahan
	name = "Dullahan"
	sprite_icon_state = "dullahansci"
	sprite_icon = 'icons/mob/robot/dullahan/v1/dullahan_sci.dmi'
	has_vore_belly_sprites = TRUE
	has_eye_light_sprites = TRUE
	sprite_hud_icon_state = "sci-borg"
	rest_sprite_options = list("Default", "Sit")
	pixel_x = 0

/datum/robot_sprite/dogborg/tall/science/dullahan/scialt
	name = "Dullahan v2"
	sprite_icon_state = "dullahansci_alt"

/datum/robot_sprite/dogborg/tall/science/dullahan/scialt2
	name = "Dullahan v3"
	sprite_icon = 'icons/mob/robot/dullahan/v3/science.dmi'
	sprite_icon_state = "dullahanscience"
	sprite_decals = list("decals")

/datum/robot_sprite/dogborg/science/cat
	name = "Cat"
	sprite_icon = 'icons/mob/robot/catborg_variant.dmi'
	sprite_icon_state = "vixsci"
	sprite_hud_icon_state = "sci-borg"
	has_vore_belly_resting_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_dead_sprite_overlay = FALSE


/datum/robot_sprite/dogborg/science/smolraptor
	sprite_icon = 'icons/mob/robot/smallraptors/smolraptor_sci.dmi'
	name = "Small Raptor"
	sprite_icon_state = "smolraptor"
	has_dead_sprite_overlay = FALSE
	has_eye_light_sprites = TRUE
	has_vore_belly_sprites = TRUE
	rest_sprite_options = list("Default", "Sit")
