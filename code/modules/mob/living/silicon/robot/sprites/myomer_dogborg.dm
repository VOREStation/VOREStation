/datum/robot_sprite/dogborg/mining/myomer
	name = "Myomer"
	sprite_icon_state = "base"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_dead_sprite = FALSE
	has_dead_sprite_overlay = FALSE
	has_glow_sprites = TRUE
	sprite_icon = 'icons/mob/robot/myomer_dogborg/ProjectMyomerCargo.dmi'
	rest_sprite_options = list("Default", "Sit")
	belly_capacity_list = list("sleeper" = 3, "throat" = 2)

/datum/robot_sprite/dogborg/mining/myomer/mining
	name = "Myomer - Miner"
	sprite_icon_state = "base"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_dead_sprite = FALSE
	has_dead_sprite_overlay = FALSE
	has_glow_sprites = TRUE
	sprite_icon = 'icons/mob/robot/myomer_dogborg/ProjectMyomerMining.dmi'
	rest_sprite_options = list("Default", "Sit")
	belly_capacity_list = list("sleeper" = 3, "throat" = 2)
	sprite_flags = ROBOT_HAS_GUN_SPRITE

/datum/robot_sprite/dogborg/engineering/myomer
	name = "Myomer"
	sprite_icon_state = "base"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_dead_sprite = FALSE
	has_dead_sprite_overlay = FALSE
	has_glow_sprites = TRUE
	sprite_icon = 'icons/mob/robot/myomer_dogborg/ProjectMyomerEngi.dmi'
	rest_sprite_options = list("Default", "Sit")
	belly_capacity_list = list("sleeper" = 3, "throat" = 2)

/datum/robot_sprite/dogborg/janitor/myomer
	name = "Myomer"
	sprite_icon_state = "base"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_dead_sprite = FALSE
	has_dead_sprite_overlay = FALSE
	has_glow_sprites = TRUE
	sprite_icon = 'icons/mob/robot/myomer_dogborg/ProjectMyomerJani.dmi'
	rest_sprite_options = list("Default", "Sit")
	belly_capacity_list = list("sleeper" = 3, "throat" = 2)
/datum/robot_sprite/dogborg/crisis/myomer
	name = "Myomer"
	sprite_icon_state = "base"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_dead_sprite = FALSE
	has_dead_sprite_overlay = FALSE
	has_glow_sprites = TRUE
	sprite_icon = 'icons/mob/robot/myomer_dogborg/ProjectMyomerMedical.dmi'
	rest_sprite_options = list("Default", "Sit")
	belly_capacity_list = list("sleeper" = 3, "throat" = 2)
	module_type = list("Crisis", "Surgeon")

/datum/robot_sprite/dogborg/science/myomer
	name = "Myomer"
	sprite_icon_state = "base"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_dead_sprite = FALSE
	has_dead_sprite_overlay = FALSE
	has_glow_sprites = TRUE
	sprite_icon = 'icons/mob/robot/myomer_dogborg/ProjectMyomerSci.dmi'
	rest_sprite_options = list("Default", "Sit")
	belly_capacity_list = list("sleeper" = 3, "throat" = 2)

/datum/robot_sprite/dogborg/security/myomer
	name = "Myomer"
	sprite_icon_state = "base"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_dead_sprite = FALSE
	has_dead_sprite_overlay = FALSE
	has_glow_sprites = TRUE
	sprite_icon = 'icons/mob/robot/myomer_dogborg/ProjectMyomerSec.dmi'
	rest_sprite_options = list("Default", "Sit")
	belly_capacity_list = list("sleeper" = 3, "throat" = 2)
	sprite_flags = ROBOT_HAS_DISABLER_SPRITE | ROBOT_HAS_MELEE_SPRITE | ROBOT_HAS_LASER_SPRITE | ROBOT_HAS_SHIELD_SPRITE

/datum/robot_sprite/dogborg/service/myomer
	name = "Myomer"
	sprite_icon_state = "base"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_dead_sprite = FALSE
	has_dead_sprite_overlay = FALSE
	has_glow_sprites = TRUE
	sprite_icon = 'icons/mob/robot/myomer_dogborg/ProjectMyomerService.dmi'
	rest_sprite_options = list("Default", "Sit")
	belly_capacity_list = list("sleeper" = 3, "throat" = 2)

/datum/robot_sprite/dogborg/combat_medic/myomer
	name = "Myomer"
	sprite_icon_state = "base"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_dead_sprite = FALSE
	has_dead_sprite_overlay = FALSE
	has_glow_sprites = TRUE
	sprite_icon = 'icons/mob/robot/myomer_dogborg/ProjectMyomerSyndi.dmi'
	rest_sprite_options = list("Default", "Sit")
	belly_capacity_list = list("sleeper" = 3, "throat" = 2)
	sprite_flags = ROBOT_HAS_DISABLER_SPRITE | ROBOT_HAS_LASER_SPRITE | ROBOT_HAS_SHIELD_SPRITE | ROBOT_HAS_MELEE_SPRITE

/// Custom sprite added to fluff.dm
/*
/datum/robot_sprite/dogborg/custom_myomer
	name = "Myomer - HERO"
	sprite_icon_state = "base"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_dead_sprite = FALSE
	has_dead_sprite_overlay = FALSE
	has_glow_sprites = TRUE
	sprite_icon = 'icons/mob/robot/myomer_dogborg/custom/ProjectMyomerCustom.dmi'
	rest_sprite_options = list("Default", "Sit")
	belly_capacity_list = list("sleeper" = 3, "throat" = 2)
	module_type = list("Standard", "Engineering", "Surgeon", "Crisis", "Miner", "Janitor", "Service", "Clerical", "Security", "Research")
	sprite_flags = ROBOT_HAS_DISABLER_SPRITE | ROBOT_HAS_LASER_SPRITE | ROBOT_HAS_SHIELD_SPRITE
	is_whitelisted = TRUE
	whitelist_ckey = "thesharkenning"
*/
