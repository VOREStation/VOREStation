/// EXAMPLE.
/*
/datum/robot_sprite/dogborg/DEPARTMENT/gooborg
	name = "Gooborg - DEPARTMENTL"
	sprite_icon_state = "engi"
	sprite_hud_icon_state = "engi"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_vore_belly_resting_sprites = TRUE
	sprite_icon = 'icons/mob/robot/gooborgs/departmental/XXXX.dmi'
	rest_sprite_options = list("Default", "Bellyup", "Sit")
	belly_capacity_list = list("sleeper" = 2, "throat" =2)
	module_type = list("Standard", "Engineering", "Crisis", "Miner", "Janitor", "Service", "Clerical", "Security", "Research") //Select whichever ones they apply to.
*/

/// Cargo
/datum/robot_sprite/dogborg/mining/gooborg
	name = "Gooborg - Cargo"
	sprite_icon_state = "base"
	//sprite_hud_icon_state = "catgo"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_vore_belly_resting_sprites = TRUE
	has_vore_struggle_sprite = TRUE
	has_dead_sprite_overlay = FALSE
	has_glow_sprites = TRUE
	sprite_icon = 'icons/mob/robot/gooborgs/departmental/gooborg_cargo.dmi'
	rest_sprite_options = list("Default", "Bellyup", "Sit")
	belly_capacity_list = list("sleeper" = 2, "throat" =2)
	sprite_flags = ROBOT_HAS_MELEE_SPRITE //Hammer
	icon_y = 64
	vis_height = 64

/datum/robot_sprite/dogborg/mining/gooborg/miner
	name = "Gooborg - Miner"
	sprite_icon_state = "base"
	//sprite_hud_icon_state = "catgo"
	sprite_icon = 'icons/mob/robot/gooborgs/departmental/gooborg_miner.dmi'
	rest_sprite_options = list("Default", "Bellyup", "Sit")
	belly_capacity_list = list("sleeper" = 2, "throat" =2)
	sprite_flags = ROBOT_HAS_MELEE_SPRITE | ROBOT_HAS_GUN_SPRITE //Hammer & PKA
	icon_y = 64
	vis_height = 64

/// Engineering
/datum/robot_sprite/dogborg/engineering/gooborg
	name = "Gooborg"
	sprite_icon_state = "base"
	//sprite_hud_icon_state = "engi"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_vore_belly_resting_sprites = TRUE
	has_vore_struggle_sprite = TRUE
	has_dead_sprite_overlay = FALSE
	has_glow_sprites = TRUE
	sprite_icon = 'icons/mob/robot/gooborgs/departmental/gooborg_engi.dmi'
	rest_sprite_options = list("Default", "Bellyup", "Sit")
	belly_capacity_list = list("sleeper" = 2, "throat" =2)
	icon_y = 64
	vis_height = 64

/// Crisis
/datum/robot_sprite/dogborg/crisis/gooborg
	name = "Gooborg"
	sprite_icon_state = "base"
	//sprite_hud_icon_state = "meowdical"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_vore_belly_resting_sprites = TRUE
	has_vore_struggle_sprite = TRUE
	has_dead_sprite_overlay = FALSE
	has_glow_sprites = TRUE
	sprite_icon = 'icons/mob/robot/gooborgs/departmental/gooborg_med.dmi'
	rest_sprite_options = list("Default", "Bellyup", "Sit")
	belly_capacity_list = list("sleeper" = 2, "throat" =2)
	module_type = list("Crisis", "Surgeon")
	icon_y = 64
	vis_height = 64

/// Science
/datum/robot_sprite/dogborg/science/gooborg
	name = "Gooborg"
	sprite_icon_state = "base"
	//sprite_hud_icon_state = "sci"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_vore_belly_resting_sprites = TRUE
	has_vore_struggle_sprite = TRUE
	has_dead_sprite_overlay = FALSE
	has_glow_sprites = TRUE
	sprite_icon = 'icons/mob/robot/gooborgs/departmental/gooborg_sci.dmi'
	rest_sprite_options = list("Default", "Bellyup", "Sit")
	belly_capacity_list = list("sleeper" = 2, "throat" =2)
	icon_y = 64
	vis_height = 64

/// Security
/datum/robot_sprite/dogborg/security/gooborg
	name = "Gooborg"
	sprite_icon_state = "base"
	//sprite_hud_icon_state = "sec"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_vore_belly_resting_sprites = TRUE
	has_vore_struggle_sprite = TRUE
	has_dead_sprite_overlay = FALSE
	has_glow_sprites = TRUE
	sprite_icon = 'icons/mob/robot/gooborgs/departmental/gooborg_sec.dmi'
	rest_sprite_options = list("Default", "Bellyup", "Sit")
	belly_capacity_list = list("sleeper" = 2, "throat" =2)
	sprite_flags = ROBOT_HAS_SPEED_SPRITE | ROBOT_HAS_SHIELD_SPRITE | ROBOT_HAS_DISABLER_SPRITE | ROBOT_HAS_TASER_SPRITE | ROBOT_HAS_LASER_SPRITE | ROBOT_HAS_MELEE_SPRITE //Melee is baton.
	icon_y = 64
	vis_height = 64

/datum/robot_sprite/dogborg/security/gooborg/get_eyes_overlay(var/mob/living/silicon/robot/ourborg)
	if(ourborg.has_active_type(/obj/item/borg/combat/mobility))
		return
	else
		return ..()

/// Service
/datum/robot_sprite/dogborg/service/gooborg
	name = "Gooborg"
	sprite_icon_state = "base"
	//sprite_hud_icon_state = "service"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_vore_belly_resting_sprites = TRUE
	has_vore_struggle_sprite = TRUE
	has_dead_sprite_overlay = FALSE
	has_glow_sprites = TRUE
	sprite_icon = 'icons/mob/robot/gooborgs/departmental/gooborg_service.dmi'
	rest_sprite_options = list("Default", "Bellyup", "Sit")
	belly_capacity_list = list("sleeper" = 2, "throat" =2)
	module_type = list("Service", "Clerical")
	icon_y = 64
	vis_height = 64

/datum/robot_sprite/dogborg/janitor/gooborg
	name = "Gooborg"
	sprite_icon_state = "base"
	//sprite_hud_icon_state = "service"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_vore_belly_resting_sprites = TRUE
	has_vore_struggle_sprite = TRUE
	has_dead_sprite_overlay = FALSE
	has_glow_sprites = TRUE
	sprite_icon = 'icons/mob/robot/gooborgs/departmental/gooborg_jani.dmi'
	rest_sprite_options = list("Default", "Bellyup", "Sit")
	belly_capacity_list = list("sleeper" = 2, "throat" =2)
	icon_y = 64
	vis_height = 64

/datum/robot_sprite/dogborg/combat_gooborg
	name = "Gooborg"
	sprite_icon_state = "base"
	//sprite_hud_icon_state = "malf"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_vore_belly_resting_sprites = TRUE
	has_vore_struggle_sprite = TRUE
	has_dead_sprite_overlay = FALSE
	has_glow_sprites = TRUE
	sprite_icon = 'icons/mob/robot/gooborgs/departmental/gooborg_peacekeeper.dmi'
	rest_sprite_options = list("Default", "Bellyup", "Sit")
	belly_capacity_list = list("sleeper" = 2, "throat" =2)
	sprite_flags = ROBOT_HAS_SPEED_SPRITE | ROBOT_HAS_DISABLER_SPRITE | ROBOT_HAS_TASER_SPRITE | ROBOT_HAS_LASER_SPRITE | ROBOT_HAS_MELEE_SPRITE //Baton
	module_type = "Combat"
	icon_y = 64
	vis_height = 64

/datum/robot_sprite/dogborg/combat_gooborg/get_eyes_overlay(var/mob/living/silicon/robot/ourborg)
	if(ourborg.has_active_type(/obj/item/borg/combat/mobility))
		return
	return ..()

/datum/robot_sprite/dogborg/clown/gooborg
	name = "Gooborg"
	sprite_icon_state = "base"
	//sprite_hud_icon_state = "syndicat"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_vore_belly_resting_sprites = TRUE
	has_vore_struggle_sprite = TRUE
	has_dead_sprite_overlay = FALSE
	has_glow_sprites = TRUE
	sprite_icon = 'icons/mob/robot/gooborgs/departmental/gooborg_jester.dmi'
	rest_sprite_options = list("Default", "Bellyup", "Sit")
	belly_capacity_list = list("sleeper" = 2, "throat" =2)
	icon_y = 64
	vis_height = 64

//Exploration.
/datum/robot_sprite/dogborg/explo_gooborg
	name = "Gooborg"
	sprite_icon_state = "base"
	//sprite_hud_icon_state = "syndicat"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_vore_belly_resting_sprites = TRUE
	has_vore_struggle_sprite = TRUE
	has_dead_sprite_overlay = FALSE
	has_glow_sprites = TRUE
	sprite_icon = 'icons/mob/robot/gooborgs/custom/gooborg_ninja.dmi'
	rest_sprite_options = list("Default", "Bellyup", "Sit")
	belly_capacity_list = list("sleeper" = 2, "throat" =2)
	module_type = "Exploration"
	icon_y = 64
	vis_height = 64

/datum/robot_sprite/dogborg/explo_gooborg/get_eyes_overlay(var/mob/living/silicon/robot/ourborg)
	if(ourborg.has_active_type(/obj/item/borg/combat/mobility))
		return
	else
		return ..()

//Syndicate
/datum/robot_sprite/dogborg/combat_medic/gooborg
	name = "Gooborg"
	sprite_icon_state = "base"
	//sprite_hud_icon_state = "malf"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_vore_belly_resting_sprites = TRUE
	has_vore_struggle_sprite = TRUE
	has_dead_sprite_overlay = FALSE
	has_glow_sprites = TRUE
	sprite_icon = 'icons/mob/robot/gooborgs/custom/gooborg_syndi.dmi'
	rest_sprite_options = list("Default", "Bellyup", "Sit")
	belly_capacity_list = list("sleeper" = 2, "throat" =2)
	sprite_flags = ROBOT_HAS_SPEED_SPRITE | ROBOT_HAS_GUN_SPRITE | ROBOT_HAS_BLADE_SPRITE //esword
	module_type = list("Combat Medic", "Mechanist", "Protector") //You get all three modules.
	icon_y = 64
	vis_height = 64

/datum/robot_sprite/dogborg/combat_medic/gooborg/get_eyes_overlay(var/mob/living/silicon/robot/ourborg)
	if(ourborg.has_active_type(/obj/item/borg/combat/mobility))
		return
	else
		return ..()
