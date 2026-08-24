/// Centi Borgs

/// CARGO
/datum/robot_sprite/dogborg/tall/mining/centiborg
	name = "Centiborg - Cargo"
	sprite_icon_state = "base"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_vore_belly_resting_sprites = TRUE
	has_glow_sprites = TRUE
	has_dead_sprite_overlay = FALSE
	has_custom_open_sprites = TRUE
	sprite_icon = 'icons/mob/robot/centiborgs/departmental/centiborg_cargo.dmi'
	rest_sprite_options = list("Default")
	sprite_decals = list("spikes", "tail", "fins", "antennae")
	belly_capacity_list = list("sleeper" = 3, "throat" = 2)
	hat_offset = CENTIBORG_HAT_OFFSET

/datum/robot_sprite/dogborg/tall/mining/centiborg/miner
	name = "Centiborg - Miner"
	sprite_icon_state = "base"
	sprite_icon = 'icons/mob/robot/centiborgs/departmental/centiborg_mining.dmi'
	rest_sprite_options = list("Default")
	sprite_decals = list("spikes", "tail", "fins", "antennae")
	belly_capacity_list = list("sleeper" = 3, "throat" = 2)
	sprite_flags = ROBOT_HAS_GUN_SPRITE | ROBOT_HAS_MELEE_SPRITE
	hat_offset = CENTIBORG_HAT_OFFSET


/// Engineering
/datum/robot_sprite/dogborg/tall/engineering/centiborg
	name = "Centiborg"
	sprite_icon_state = "base"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_vore_belly_resting_sprites = TRUE
	has_glow_sprites = TRUE
	has_dead_sprite_overlay = FALSE
	has_custom_open_sprites = TRUE
	sprite_icon = 'icons/mob/robot/centiborgs/departmental/centiborg_engi.dmi'
	rest_sprite_options = list("Default")
	sprite_decals = list("spikes", "tail", "fins", "antennae")
	belly_capacity_list = list("sleeper" = 3, "throat" = 2)
	hat_offset = CENTIBORG_HAT_OFFSET


/// Janitor
/datum/robot_sprite/dogborg/tall/janitor/centiborg
	name = "Centiborg"
	sprite_icon_state = "base"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_vore_belly_resting_sprites = TRUE
	has_glow_sprites = TRUE
	has_dead_sprite_overlay = FALSE
	has_custom_open_sprites = TRUE
	sprite_icon = 'icons/mob/robot/centiborgs/departmental/centiborg_jani.dmi'
	rest_sprite_options = list("Default")
	sprite_decals = list("spikes", "tail", "fins", "antennae")
	belly_capacity_list = list("sleeper" = 3, "throat" = 2)
	hat_offset = CENTIBORG_HAT_OFFSET

/// Medical
/datum/robot_sprite/dogborg/tall/crisis/centiborg
	name = "Centiborg"
	sprite_icon_state = "base"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_vore_belly_resting_sprites = TRUE
	has_glow_sprites = TRUE
	has_dead_sprite_overlay = FALSE
	has_custom_open_sprites = TRUE
	sprite_icon = 'icons/mob/robot/centiborgs/departmental/centiborg_med.dmi'
	rest_sprite_options = list("Default")
	sprite_decals = list("spikes", "tail", "fins", "antennae")
	belly_capacity_list = list("sleeper" = 3, "throat" = 2)
	module_type = list("Crisis", "Surgeon")
	hat_offset = CENTIBORG_HAT_OFFSET

/// Science
/datum/robot_sprite/dogborg/tall/science/centiborg
	name = "Centiborg"
	sprite_icon_state = "base"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_vore_belly_resting_sprites = TRUE
	has_glow_sprites = TRUE
	has_dead_sprite_overlay = FALSE
	has_custom_open_sprites = TRUE
	sprite_icon = 'icons/mob/robot/centiborgs/departmental/centiborg_sci.dmi'
	rest_sprite_options = list("Default")
	sprite_decals = list("spikes", "tail", "fins", "antennae")
	belly_capacity_list = list("sleeper" = 3, "throat" = 2)
	hat_offset = CENTIBORG_HAT_OFFSET

/// Security
/datum/robot_sprite/dogborg/tall/security/centiborg
	name = "Centiborg"
	sprite_icon_state = "base"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_vore_belly_resting_sprites = TRUE
	has_glow_sprites = TRUE
	has_dead_sprite_overlay = FALSE
	has_custom_open_sprites = TRUE
	sprite_icon = 'icons/mob/robot/centiborgs/departmental/centiborg_sec.dmi'
	rest_sprite_options = list("Default")
	sprite_decals = list("spikes", "tail", "fins", "antennae")
	belly_capacity_list = list("sleeper" = 3, "throat" = 2)
	sprite_flags = ROBOT_HAS_SHIELD_SPRITE | ROBOT_HAS_MELEE_SPRITE | ROBOT_HAS_GUN_SPRITE
	hat_offset = CENTIBORG_HAT_OFFSET

/// Service
/datum/robot_sprite/dogborg/tall/service/centiborg
	name = "Centiborg"
	sprite_icon_state = "base"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_vore_belly_resting_sprites = TRUE
	has_glow_sprites = TRUE
	has_dead_sprite_overlay = FALSE
	has_custom_open_sprites = TRUE
	sprite_icon = 'icons/mob/robot/centiborgs/departmental/centiborg_service.dmi'
	rest_sprite_options = list("Default")
	sprite_decals = list("spikes", "tail", "fins", "antennae")
	belly_capacity_list = list("sleeper" = 3, "throat" = 2)
	module_type = list("Service", "Clerical")
	hat_offset = CENTIBORG_HAT_OFFSET

/// CLOWN
/datum/robot_sprite/dogborg/tall/clown/centiborg
	name = "Centiborg"
	sprite_icon_state = "base"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_vore_belly_resting_sprites = TRUE
	has_glow_sprites = TRUE
	has_dead_sprite_overlay = FALSE
	has_custom_open_sprites = TRUE
	sprite_icon = 'icons/mob/robot/centiborgs/departmental/centiborg_clown.dmi'
	rest_sprite_options = list("Default")
	sprite_decals = list("spikes", "tail", "fins", "antennae")
	belly_capacity_list = list("sleeper" = 3, "throat" = 2)
	hat_offset = CENTIBORG_HAT_OFFSET

/// COMMAND
/datum/robot_sprite/dogborg/tall/command/centiborg
	name = "Centiborg"
	sprite_icon_state = "base"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_vore_belly_resting_sprites = TRUE
	has_glow_sprites = TRUE
	has_dead_sprite_overlay = FALSE
	has_custom_open_sprites = TRUE
	sprite_icon = 'icons/mob/robot/centiborgs/departmental/centiborg_captain.dmi'
	rest_sprite_options = list("Default")
	sprite_decals = list("spikes", "tail", "fins", "antennae")
	belly_capacity_list = list("sleeper" = 3, "throat" = 2)
	sprite_flags = ROBOT_HAS_SHIELD_SPRITE | ROBOT_HAS_MELEE_SPRITE | ROBOT_HAS_GUN_SPRITE
	hat_offset = CENTIBORG_HAT_OFFSET

/// EXPLORATION
/datum/robot_sprite/dogborg/tall/explorer/centiborg
	name = "Centiborg"
	sprite_icon_state = "base"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_vore_belly_resting_sprites = TRUE
	has_glow_sprites = TRUE
	has_dead_sprite_overlay = FALSE
	has_custom_open_sprites = TRUE
	sprite_icon = 'icons/mob/robot/centiborgs/departmental/centiborg_base.dmi'
	rest_sprite_options = list("Default")
	sprite_decals = list("spikes", "tail", "fins", "antennae")
	belly_capacity_list = list("sleeper" = 3, "throat" = 2)
	sprite_flags = ROBOT_HAS_SHIELD_SPRITE | ROBOT_HAS_MELEE_SPRITE | ROBOT_HAS_GUN_SPRITE
	hat_offset = CENTIBORG_HAT_OFFSET

/// STANDARD
/datum/robot_sprite/dogborg/tall/standard/centiborg
	name = "Centiborg"
	sprite_icon_state = "base"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_vore_belly_resting_sprites = TRUE
	has_glow_sprites = TRUE
	has_dead_sprite_overlay = FALSE
	has_custom_open_sprites = TRUE
	sprite_icon = 'icons/mob/robot/centiborgs/departmental/centiborg_base.dmi'
	rest_sprite_options = list("Default")
	sprite_decals = list("spikes", "tail", "fins", "antennae")
	belly_capacity_list = list("sleeper" = 3, "throat" = 2)
	sprite_flags = ROBOT_HAS_SHIELD_SPRITE | ROBOT_HAS_MELEE_SPRITE | ROBOT_HAS_GUN_SPRITE
	hat_offset = CENTIBORG_HAT_OFFSET

/datum/robot_sprite/dogborg/tall/ninja/centiborg
	name = "Centiborg"
	sprite_icon_state = "base"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_vore_belly_resting_sprites = TRUE
	has_glow_sprites = TRUE
	has_dead_sprite_overlay = FALSE
	has_custom_open_sprites = TRUE
	sprite_icon = 'icons/mob/robot/centiborgs/custom/centiborg_ninja.dmi'
	rest_sprite_options = list("Default")
	belly_capacity_list = list("sleeper" = 3, "throat" = 2)
	sprite_flags = ROBOT_HAS_SHIELD_SPRITE | ROBOT_HAS_BLADE_SPRITE //esword
	hat_offset = CENTIBORG_HAT_OFFSET

//Syndicate
/datum/robot_sprite/dogborg/tall/combat_medic/centiborg
	name = "Centiborg"
	sprite_icon_state = "base"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_vore_belly_resting_sprites = TRUE
	has_glow_sprites = TRUE
	has_dead_sprite_overlay = FALSE
	has_custom_open_sprites = TRUE
	sprite_icon = 'icons/mob/robot/centiborgs/custom/centiborg_syndi.dmi'
	rest_sprite_options = list("Default")
	belly_capacity_list = list("sleeper" = 3, "throat" = 2)
	sprite_flags = ROBOT_HAS_SHIELD_SPRITE | ROBOT_HAS_GUN_SPRITE | ROBOT_HAS_BLADE_SPRITE //esword
	module_type = list("Combat Medic", "Mechanist", "Protector") //You get all three modules.
	hat_offset = CENTIBORG_HAT_OFFSET
