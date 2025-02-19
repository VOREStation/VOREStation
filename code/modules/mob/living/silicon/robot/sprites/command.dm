/obj/item/robot_module/robot/chound
	languages = list(
					LANGUAGE_SOL_COMMON	= 1,
					LANGUAGE_TRADEBAND	= 1,
					LANGUAGE_UNATHI		= 1,
					LANGUAGE_SIIK		= 1,
					LANGUAGE_SKRELLIAN	= 1,
					LANGUAGE_ROOTLOCAL	= 0,
					LANGUAGE_GUTTER		= 0,
					LANGUAGE_SCHECHI	= 1,
					LANGUAGE_EAL		= 1,
					LANGUAGE_SIGN		= 0,
					LANGUAGE_BIRDSONG	= 1,
					LANGUAGE_SAGARU		= 1,
					LANGUAGE_CANILUNZT	= 1,
					LANGUAGE_ECUREUILIAN= 1,
					LANGUAGE_DAEMON		= 1,
					LANGUAGE_ENOCHIAN	= 1,
					LANGUAGE_DRUDAKAR	= 1,
					LANGUAGE_TAVAN		= 1
					)

//Build our Module
/obj/item/robot_module/robot/chound
	name = "command robot module"
	channels = list(
			"Medical" = 1,
			"Engineering" = 1,
			"Security" = 1,
			"Service" = 1,
			"Supply" = 0,
			"Science" = 1,
			"Command" = 1,
			"Explorer" = 0
			)
	pto_type = PTO_CIVILIAN
	can_be_pushed = 0

/obj/item/robot_module/robot/chound/create_equipment(var/mob/living/silicon/robot/R)
	src.modules += new /obj/item/pen/robopen(src)
	src.modules += new /obj/item/form_printer(src)
	src.modules += new /obj/item/gripper/paperwork(src)
	src.modules += new /obj/item/hand_labeler(src)
	src.modules += new /obj/item/stamp(src)
	src.modules += new /obj/item/stamp/denied(src)
	//src.modules += new /obj/item/taskmanager(src) //Needs to be ported over.
	src.emag += new /obj/item/stamp/chameleon(src)
	src.emag += new /obj/item/pen/chameleon(src)

	src.modules += new /obj/item/dogborg/sleeper/command(src)
	src.emag += new /obj/item/dogborg/pounce(src)
	..()

/datum/robot_sprite/dogborg/command
	name = "Commandhound V2"
	sprite_icon_state = "kcom"
	has_eye_light_sprites = TRUE
	module_type = "Command"
	sprite_icon = 'icons/mob/robot/widerobot/widerobot.dmi'

/datum/robot_sprite/dogborg/command/borgi
	name = "Borgi"
	sprite_icon_state = "borgi"
	has_eye_light_sprites = TRUE

/datum/robot_sprite/dogborg/tall/command
	module_type = "Command"
	sprite_icon = 'icons/mob/robot/tallrobot/tallrobots.dmi'
	pixel_x = 0

/datum/robot_sprite/dogborg/raptor/command
	module_type = "Command"
	sprite_icon = 'icons/mob/robot/raptor.dmi'

/datum/robot_sprite/dogborg/raptor/command/raptor
	name = "Raptor"
	sprite_icon_state = "chraptor"
	has_dead_sprite_overlay = FALSE
	has_custom_equipment_sprites = TRUE
	rest_sprite_options = list("Default", "Bellyup")

/datum/robot_sprite/dogborg/tall/command/meka
	name = "MEKA"
	sprite_icon_state = "mekaunity"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = FALSE
	has_vore_belly_sprites = TRUE
	rest_sprite_options = list("Default", "Sit")

/datum/robot_sprite/dogborg/tall/command/mmeka
	name = "NIKO"
	sprite_icon_state = "mmekaunity"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = FALSE
	has_vore_belly_sprites = TRUE
	rest_sprite_options = list("Default", "Sit")

/datum/robot_sprite/dogborg/tall/command/fmeka
	name = "NIKA"
	sprite_icon_state = "fmekaunity"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = FALSE
	has_vore_belly_sprites = TRUE
	rest_sprite_options = list("Default", "Sit")

/datum/robot_sprite/dogborg/command/smolraptorcommand
	name = "Small Raptor"
	sprite_icon = 'icons/mob/robot/smallraptors/smolraptor_cc.dmi'
	sprite_icon_state = "smolraptor"
	has_dead_sprite_overlay = FALSE
	has_eye_light_sprites = TRUE
	has_vore_belly_sprites = TRUE
	rest_sprite_options = list("Default", "Sit")
