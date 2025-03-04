/// There's a few of these that don't really fall into one file or the other.
/// Examples being the service kittyborg being both service & clerical
/// The medical kittyborg also gets surgical and Crisis
/// While the service catborg has service, clerical, and janitor.
/// Additionally, the gryphonborg only has one sprite and gets all the departments
/// And the two custom-whitelisted ones also have all the departments.
/// So to keep it neat and organized, I put them all in one file for ease of viewing instead of copy and pasting all over the place.

/// ADDITIONALLY, SOME NOTES:
/// The only two borgs here that have sleeper color sprites are the Secborg and the Crisis borg (That also has surgery. Surgery shouldn't even be a borg module, but I digress)
/// If you want to add them to the rest of the borgs in here that have sleepers (or want to make your own and add sleeper colors)
/// Let's do an example.
/// Go to the .dmi for the borg (catborg_security.dmi), copy the sec-sleeper-1, sec-sleeper-2 (the static and moving states) as many times as you have sleeper states.
/// Rename them to sec-sleeper-1-g sec-sleeper-1-r sec-sleeper-2-g sec-sleeper-2-r respectively
/// Copy the sleeper-g, sleeper-g(moving), sleeper-r, sleeper-r(moving) and copy & paste them on the sprites.
/// Save it and boom, you're done. You should now have 8 new icon states. 4 static 4 moving.

/// EXAMPLE.
/*
/datum/robot_sprite/dogborg/DEPARTMENT/catborg
	name = "Catborg - DEPARTMENTL"
	sprite_icon_state = "engi"
	sprite_hud_icon_state = "engi"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_vore_belly_resting_sprites = TRUE
	sprite_icon = 'icons/mob/catborgs/Departmental/catborgs/catborg_engineering.dmi'
	rest_sprite_options = list("Default", "Bellyup", "Sit")
	belly_capacity_list = list("sleeper" = 2, "throat" =2)
	module_type = list("Standard", "Engineering", "Crisis", "Miner", "Janitor", "Service", "Clerical", "Security", "Research") //Select whichever ones they apply to.
*/

/// Kitty Borgs

/// CARGO
/datum/robot_sprite/dogborg/mining/kittyborg
	name = "Kittyborg"
	sprite_icon_state = "cargo"
	sprite_hud_icon_state = "cargo"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_vore_belly_resting_sprites = TRUE
	has_dead_sprite_overlay = FALSE
	sprite_icon = 'icons/mob/robot/catborgs/departmental/small/kittyborg_cargo.dmi'
	rest_sprite_options = list("Default", "Bellyup", "Sit")
	belly_capacity_list = list("sleeper" = 2)
	sprite_flags = ROBOT_HAS_SHIELD_SPRITE | ROBOT_HAS_GUN_SPRITE

/// Engineering
/datum/robot_sprite/dogborg/engineering/kittyborg
	name = "Kittyborg"
	sprite_icon_state = "engi"
	sprite_hud_icon_state = "engi"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_vore_belly_resting_sprites = TRUE
	has_dead_sprite_overlay = FALSE
	sprite_icon = 'icons/mob/robot/catborgs/departmental/small/kittyborg_engi.dmi'
	rest_sprite_options = list("Default", "Bellyup", "Sit")
	belly_capacity_list = list("sleeper" = 2)
	sprite_flags = ROBOT_HAS_SHIELD_SPRITE | ROBOT_HAS_GUN_SPRITE


/// Janitor
/datum/robot_sprite/dogborg/janitor/kittyborg
	name = "Kittyborg"
	sprite_icon_state = "jani"
	sprite_hud_icon_state = "jani"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_vore_belly_resting_sprites = TRUE
	has_dead_sprite_overlay = FALSE
	sprite_icon = 'icons/mob/robot/catborgs/departmental/small/kittyborg_jani.dmi'
	rest_sprite_options = list("Default", "Bellyup", "Sit")
	belly_capacity_list = list("sleeper" = 2)
	sprite_flags = ROBOT_HAS_SHIELD_SPRITE | ROBOT_HAS_GUN_SPRITE

/// Medical
/datum/robot_sprite/dogborg/crisis/kittyborg
	name = "Kittyborg"
	sprite_icon_state = "medicat"
	sprite_hud_icon_state = "medicat"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_vore_belly_resting_sprites = TRUE
	has_dead_sprite_overlay = FALSE
	sprite_icon = 'icons/mob/robot/catborgs/departmental/small/kittyborg_medicat.dmi'
	rest_sprite_options = list("Default", "Bellyup", "Sit")
	belly_capacity_list = list("sleeper" = 2)
	sprite_flags = ROBOT_HAS_SHIELD_SPRITE | ROBOT_HAS_GUN_SPRITE
	module_type = list("Crisis", "Surgeon")

/// Science
/datum/robot_sprite/dogborg/science/kittyborg
	name = "Kittyborg"
	sprite_icon_state = "sci"
	sprite_hud_icon_state = "sci"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_vore_belly_resting_sprites = TRUE
	has_dead_sprite_overlay = FALSE
	sprite_icon = 'icons/mob/robot/catborgs/departmental/small/kittyborg_sci.dmi'
	rest_sprite_options = list("Default", "Bellyup", "Sit")
	belly_capacity_list = list("sleeper" = 2)
	sprite_flags = ROBOT_HAS_SHIELD_SPRITE | ROBOT_HAS_GUN_SPRITE

/// Security
/datum/robot_sprite/dogborg/security/kittyborg
	name = "Kittyborg"
	sprite_icon_state = "sec"
	sprite_hud_icon_state = "sec"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_vore_belly_resting_sprites = TRUE
	has_dead_sprite_overlay = FALSE
	sprite_icon = 'icons/mob/robot/catborgs/departmental/small/kittyborg_sec.dmi'
	rest_sprite_options = list("Default", "Bellyup", "Sit")
	belly_capacity_list = list("sleeper" = 2)
	sprite_flags = ROBOT_HAS_SHIELD_SPRITE | ROBOT_HAS_GUN_SPRITE

/// Service
/datum/robot_sprite/dogborg/service/kittyborg
	name = "Kittyborg"
	sprite_icon_state = "service"
	sprite_hud_icon_state = "service"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_vore_belly_resting_sprites = TRUE
	has_dead_sprite_overlay = FALSE
	sprite_icon = 'icons/mob/robot/catborgs/departmental/small/kittyborg_service.dmi'
	rest_sprite_options = list("Default", "Bellyup", "Sit")
	belly_capacity_list = list("sleeper" = 2)
	sprite_flags = ROBOT_HAS_SHIELD_SPRITE | ROBOT_HAS_GUN_SPRITE
	module_type = list("Service", "Clerical")










/// CAT BORGS
/// ALL THE CAT BORG SPRITES BELOW HERE

/// Cargo
/datum/robot_sprite/dogborg/mining/catborg
	name = "Catborg"
	sprite_icon_state = "catgo"
	sprite_hud_icon_state = "catgo"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_vore_belly_resting_sprites = TRUE
	sprite_icon = 'icons/mob/robot/catborgs/departmental/large/catborg_cargo.dmi'
	rest_sprite_options = list("Default", "Bellyup", "Sit")
	belly_capacity_list = list("sleeper" = 2, "throat" =2)
	sprite_flags = ROBOT_HAS_SHIELD_SPRITE | ROBOT_HAS_DISABLER_SPRITE | ROBOT_HAS_TASER_SPRITE | ROBOT_HAS_LASER_SPRITE

/// Engineering
/datum/robot_sprite/dogborg/engineering/catborg
	name = "Catborg"
	sprite_icon_state = "engi"
	sprite_hud_icon_state = "engi"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_vore_belly_resting_sprites = TRUE
	sprite_icon = 'icons/mob/robot/catborgs/departmental/large/catborg_engineering.dmi'
	rest_sprite_options = list("Default", "Bellyup", "Sit")
	belly_capacity_list = list("sleeper" = 2, "throat" =2)
	sprite_flags = ROBOT_HAS_SHIELD_SPRITE | ROBOT_HAS_DISABLER_SPRITE | ROBOT_HAS_TASER_SPRITE | ROBOT_HAS_LASER_SPRITE

/// Crisis
/datum/robot_sprite/dogborg/crisis/catborg
	name = "Catborg"
	sprite_icon_state = "meowdical"
	sprite_hud_icon_state = "meowdical"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_vore_belly_resting_sprites = TRUE
	sprite_icon = 'icons/mob/robot/catborgs/departmental/large/catborg_medical.dmi'
	rest_sprite_options = list("Default", "Bellyup", "Sit")
	belly_capacity_list = list("sleeper" = 2, "throat" =2)
	belly_light_list = list("sleeper" = 2)
	sprite_flags = ROBOT_HAS_SHIELD_SPRITE | ROBOT_HAS_DISABLER_SPRITE | ROBOT_HAS_TASER_SPRITE | ROBOT_HAS_LASER_SPRITE
	module_type = list("Crisis", "Surgeon")

/// Science
/datum/robot_sprite/dogborg/science/catborg
	name = "Catborg"
	sprite_icon_state = "sci"
	sprite_hud_icon_state = "sci"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_vore_belly_resting_sprites = TRUE
	sprite_icon = 'icons/mob/robot/catborgs/departmental/large/catborg_science.dmi'
	rest_sprite_options = list("Default", "Bellyup", "Sit")
	belly_capacity_list = list("sleeper" = 2, "throat" =2)
	sprite_flags = ROBOT_HAS_SHIELD_SPRITE | ROBOT_HAS_DISABLER_SPRITE | ROBOT_HAS_TASER_SPRITE | ROBOT_HAS_LASER_SPRITE

/// Security
/datum/robot_sprite/dogborg/security/catborg
	name = "Catborg"
	sprite_icon_state = "sec"
	sprite_hud_icon_state = "sec"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_vore_belly_resting_sprites = TRUE
	sprite_icon = 'icons/mob/robot/catborgs/departmental/large/catborg_security.dmi'
	rest_sprite_options = list("Default", "Bellyup", "Sit")
	belly_capacity_list = list("sleeper" = 2, "throat" =2)
	belly_light_list = list("sleeper" = 2)
	sprite_flags = ROBOT_HAS_SHIELD_SPRITE | ROBOT_HAS_DISABLER_SPRITE | ROBOT_HAS_TASER_SPRITE | ROBOT_HAS_LASER_SPRITE

/// Service
/datum/robot_sprite/dogborg/service/catborg
	name = "Catborg"
	sprite_icon_state = "service"
	sprite_hud_icon_state = "service"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_vore_belly_resting_sprites = TRUE
	sprite_icon = 'icons/mob/robot/catborgs/departmental/large/catborg_service.dmi'
	rest_sprite_options = list("Default", "Bellyup", "Sit")
	belly_capacity_list = list("sleeper" = 2, "throat" =2)
	sprite_flags = ROBOT_HAS_SHIELD_SPRITE | ROBOT_HAS_DISABLER_SPRITE | ROBOT_HAS_TASER_SPRITE | ROBOT_HAS_LASER_SPRITE
	module_type = list("Service", "Clerical", "Janitor") //They get Janitor because no specific janitor sprite.

/datum/robot_sprite/dogborg/combat_medic/catborg
	name = "Catborg"
	sprite_icon_state = "syndicat"
	sprite_hud_icon_state = "syndicat"
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_vore_belly_resting_sprites = TRUE
	sprite_icon = 'icons/mob/robot/catborgs/departmental/large/catborg_combatmed.dmi'
	rest_sprite_options = list("Default", "Bellyup", "Sit")
	belly_capacity_list = list("sleeper" = 2, "throat" =2)
	belly_light_list = list("sleeper" = 2)
	sprite_flags = ROBOT_HAS_SHIELD_SPRITE | ROBOT_HAS_DISABLER_SPRITE | ROBOT_HAS_TASER_SPRITE | ROBOT_HAS_LASER_SPRITE

/// CUSTOM

/// Custom Catborg set up like a gryphon.
/// Technically - this is my character.
/// However, there's no birdborgs for people to be so why not open this up to everyone.
/// And besides, if I see some I'll be happy.
/datum/robot_sprite/dogborg/catborg/gryphon
	name = "Gryphonborg"
	sprite_icon_state = "borb"
	sprite_hud_icon_state = "borb"
	sprite_icon = 'icons/mob/robot/catborgs/custom/catborg_cameron.dmi'
	belly_capacity_list = list("sleeper" = 3, "throat" =2)
	rest_sprite_options = list("Default", "Bellyup", "Sit")
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_vore_belly_resting_sprites = TRUE
	sprite_decals = list("decals")
	is_whitelisted = FALSE //Putting this here as a declaration that it is NOT whitelisted.
	// whitelist_ckey = "cameron653" //The owner of the character.
	// There is only one version of this borg, so it gets all the departments.
	// Feel free to recolor it if you want to make it have specific sprites for specific departments.
	module_type = list("Standard", "Engineering", "Surgeon", "Crisis", "Miner", "Janitor", "Service", "Clerical", "Security", "Research")
	sprite_flags = ROBOT_HAS_SHIELD_SPRITE | ROBOT_HAS_DISABLER_SPRITE | ROBOT_HAS_TASER_SPRITE | ROBOT_HAS_LASER_SPRITE

/* //These are in the game and can be enabled to enable the sprites. They were added to fluff.dm, but they're also included here commented out as they're part of the catborgs and it's easy to track them down from here.
/// Custom Catborg Matica
/datum/robot_sprite/dogborg/catborg/matica
	name = "Catborg - Matica"
	sprite_icon_state = "chonker"
	sprite_hud_icon_state = "chonker"
	sprite_icon = 'icons/mob/catborgs/custom/catborg_matica_custom.dmi'
	belly_capacity_list = list("sleeper" = 1, "throat" =2)
	rest_sprite_options = list("Default", "Bellyup", "Sit")
	has_eye_sprites = TRUE
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = FALSE
	has_vore_belly_resting_sprites = TRUE
	is_whitelisted = TRUE
	whitelist_ckey = "somememeguy"
	module_type = list("Standard", "Engineering", "Surgeon", "Crisis", "Miner", "Janitor", "Service", "Clerical", "Security", "Research")
	sprite_flags = ROBOT_HAS_SHIELD_SPRITE | ROBOT_HAS_DISABLER_SPRITE | ROBOT_HAS_TASER_SPRITE | ROBOT_HAS_LASER_SPRITE
*/
