/datum/robot_sprite/standard
	module_type = "Standard"
	sprite_icon = 'icons/mob/robot/standard.dmi'

/datum/robot_sprite/standard/default
	name = DEFAULT_ROBOT_SPRITE_NAME
	default_sprite = TRUE
	sprite_icon_state = "default"

/datum/robot_sprite/standard/eyebot
	name = "Cabeiri"
	sprite_icon_state = "eyebot"

/datum/robot_sprite/standard/marina
	name = "Haruka"
	sprite_icon_state = "marina"

/datum/robot_sprite/standard/tallflower
	name = "Usagi"
	sprite_icon_state = "tallflower"

/datum/robot_sprite/standard/toiletbot
	name = "Telemachus"
	sprite_icon_state = "toiletbot"

/datum/robot_sprite/standard/sleek
	name = "WTOperator"
	sprite_icon_state = "sleek"

/datum/robot_sprite/standard/omoikane
	name = "WTOmni"
	sprite_icon_state = "omoikane"

/datum/robot_sprite/standard/spider			//There's like 4 different spider borg types, but this one has seniority
	name = "XI-GUS"
	sprite_icon_state = "spider"

/datum/robot_sprite/standard/heavy
	name = "XI-ALP"
	sprite_icon_state = "heavy"

/datum/robot_sprite/standard/old
	name = "Basic"
	sprite_icon_state = "old"

/datum/robot_sprite/standard/droid
	name = "Android"
	sprite_icon_state = "droid"

/datum/robot_sprite/standard/drone
	name = "AG Model"
	sprite_icon_state = "drone"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/standard/insekt
	name = "Insekt"
	sprite_icon_state = "insekt"

/datum/robot_sprite/standard/tall2
	name = "Usagi-II"
	sprite_icon_state = "tall2"

/datum/robot_sprite/standard/glitterfly
	name = "Pyralis"
	sprite_icon_state = "glitterfly"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/standard/decapod
	name = "Decapod"
	sprite_icon_state = "decapod"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/standard/pneuma
	name = "Pneuma"
	sprite_icon_state = "pneuma"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/standard/drider
	name = "Tower"
	sprite_icon_state = "drider"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/standard/handy
	name = "Handy"
	sprite_icon_state = "handy"

/datum/robot_sprite/standard/mechoid
	name = "Acheron"
	sprite_icon_state = "mechoid"

/datum/robot_sprite/standard/noble
	name = "Shellguard Noble"
	sprite_icon_state = "noble"
	has_custom_open_sprites = TRUE

/datum/robot_sprite/standard/zoomba
	name = "ZOOM-BA"
	sprite_icon_state = "zoomba"
	has_dead_sprite = TRUE

/datum/robot_sprite/standard/worm
	name = "W02M"
	sprite_icon_state = "worm-standard"
	sprite_icon = 'icons/mob/robot/wormborg.dmi'
	has_dead_sprite_overlay = FALSE
	has_custom_open_sprites = FALSE
	has_vore_belly_sprites = TRUE
	has_dead_sprite = TRUE

/datum/robot_sprite/standard/uptall
	name = "Feminine Humanoid"
	sprite_icon_state = "uptall"

/datum/robot_sprite/standard/uptall2
	name = "Feminine Humanoid, Variant 2"
	sprite_icon_state = "uptall2"

// Wide/dogborg sprites
/*
/datum/robot_sprite/dogborg/standard
	module_type = "Standard"
	sprite_icon = 'icons/mob/robot/standard_wide.dmi'

		// None yet
*/
// Tall sprites
/*
/datum/robot_sprite/dogborg/tall/standard
	module_type = "Standard"
	sprite_icon = 'icons/mob/robot/standard_large.dmi'

		// None yet
*/

/datum/robot_sprite/dogborg/tall/standard
	module_type = "Standard"
	//sprite_icon = 'icons/mob/robot/standard_large.dmi' NOT USED YET

/datum/robot_sprite/dogborg/tall/standard/dullataurstandard
	name = "Dullataur"
	sprite_icon_state = "dullataurstandard"
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

/datum/robot_sprite/dogborg/tall/standard/dullahanv3/standarddully
	name = "Dullahan standard v3"
	sprite_icon = 'icons/mob/robot/dullahan/v3/standard.dmi'
	sprite_icon_state = "dullahanstandard"
	has_vore_belly_sprites = TRUE
	sprite_decals = list("decals")
	rest_sprite_options = list("Default", "sit")


/* //This used to be Widerobot_Standard_ch.dm. It was unticked, so it shall be put here instead.
//Modular Standard borg hound edition
//This restructures how borg additions are done to make them sane/modular/maintainable
//Also makes it easier to make new borgs

//INCOMPLETE and not ready, no sprites other than tall and basically useless, also lacking a belly

//Add ourselves to the borg list
/hook/startup/proc/Modular_Borg_init_standardhound()
	//robot_modules["Honk-Hound"] = /obj/item/robot_module/robot/clerical/honkborg - done in station_vr modular chomp for ordering reasons
	robot_module_types += "Standard-Hound" //Add ourselves to global
	return 1

/obj/item/robot_module/robot/standard/hound
	name = "Standard-Hound"
	sprites = list(
					"MEKA" = 		list(SKIN_ICON_STATE = "mekastandard", SKIN_ICON = 'icons/mob/robot/tallrobot/tallrobots.dmi', SKIN_OFFSET = 0, SKIN_HEIGHT = 64),
					"NIKO" = 		list(SKIN_ICON_STATE = "mmekastandard", SKIN_ICON = 'icons/mob/robot/tallrobot/tallrobots.dmi', SKIN_OFFSET = 0, SKIN_HEIGHT = 64),
					"NIKA" = 		list(SKIN_ICON_STATE = "fmekastandard", SKIN_ICON = 'icons/mob/robot/tallrobot/tallrobots.dmi', SKIN_OFFSET = 0, SKIN_HEIGHT = 64),
					"K4T" = 		list(SKIN_ICON_STATE = "k4tclown", SKIN_ICON = 'icons/mob/robot/tallrobot/tallrobots.dmi', SKIN_OFFSET = 0, SKIN_HEIGHT = 64)
					)

	can_be_pushed = 0

/obj/item/robot_module/robot/standard/hound/create_equipment(mob/living/silicon/robot/robot)
	..()
	src.modules += new /obj/item/melee/baton/loaded(src)
	src.modules += new /obj/item/tool/wrench/cyborg(src)
	src.modules += new /obj/item/healthanalyzer(src)
	src.emag += new /obj/item/melee/energy/sword(src)

	var/datum/matter_synth/water = new /datum/matter_synth(500)
	water.name = "Water reserves"
	water.recharge_rate = 10
	water.max_energy = 1000
	R.water_res = water
	synths += water

	var/obj/item/dogborg/tongue/T = new /obj/item/dogborg/tongue(src)
	T.water = water
	src.modules += T

	R.icon 		 = 'modular_chomp/icons/mob/widerobot_ch.dmi'
	R.wideborg_dept  = 'modular_chomp/icons/mob/widerobot_ch.dmi'
	R.hands.icon = 'icons/mob/screen1_robot_vr.dmi'
	R.ui_style_vr = TRUE
	R.pixel_x 	 = -16
	R.old_x 	 = -16
	R.default_pixel_x = -16
	R.dogborg = TRUE
	R.vore_capacity = 1
	R.vore_capacity_ex = list("stomach" = 1)
	R.wideborg = TRUE
	add_verb(R,/mob/living/silicon/robot/proc/ex_reserve_refill)
	add_verb(R,/mob/living/silicon/robot/proc/robot_mount)
	add_verb(R,/mob/living/proc/toggle_rider_reins)
	add_verb(R,/mob/living/proc/shred_limb)
	add_verb(R,/mob/living/silicon/robot/proc/rest_style)
*/
