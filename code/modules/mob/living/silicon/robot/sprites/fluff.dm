#define CUSTOM_BORGSPRITE(x) "Custom - " + (x)

// All whitelisted dogborg sprites go here.

/datum/robot_sprite/fluff
	is_whitelisted = TRUE

// A

/datum/robot_sprite/fluff/argonne
	name = CUSTOM_BORGSPRITE("RUSS")

	sprite_icon = 'icons/mob/robot/fluff_wide.dmi'

	has_eye_light_sprites = TRUE
	has_vore_belly_sprites = TRUE
	has_rest_sprites = TRUE
	rest_sprite_options = list("Default", "Sit", "Bellyup")
	has_dead_sprite = TRUE
	has_dead_sprite_overlay = TRUE
	pixel_x = -16

	whitelist_ckey = "argonne"
	whitelist_charname = "RUSS"

/datum/robot_sprite/fluff/argonne/security
	module_type = "Security"

	sprite_icon_state = "argonne-russ-sec"
	sprite_hud_icon_state = "k9"

/datum/robot_sprite/fluff/argonne/crisis
	module_type = "Crisis"

	sprite_icon_state = "argonne-russ-crisis"
	sprite_hud_icon_state = "medihound"

/datum/robot_sprite/fluff/argonne/surgical
	module_type = "Surgeon"

	sprite_icon_state = "argonne-russ-surg"
	sprite_hud_icon_state = "medihound"

/datum/robot_sprite/fluff/argonne/engineering
	module_type = "Engineering"

	sprite_icon_state = "argonne-russ-eng"
	sprite_hud_icon_state = "pupdozer"

/datum/robot_sprite/fluff/argonne/science
	module_type = "Research"

	sprite_icon_state = "argonne-russ-sci"
	sprite_hud_icon_state = "sci-borg"

/datum/robot_sprite/fluff/argonne/mining
	module_type = "Miner"

	sprite_icon_state = "argonne-russ-mine"

/datum/robot_sprite/fluff/argonne/service
	module_type = "Service"

	sprite_icon_state = "argonne-russ-serv"

// J

/datum/robot_sprite/fluff/jademanique
	name = CUSTOM_BORGSPRITE("B.A.U-Kingside")
	module_type = "Security"

	sprite_icon = 'icons/mob/robot/fluff_wide.dmi'
	sprite_icon_state = "jademanique-kingside"
	sprite_hud_icon_state = "k9"

	has_eye_light_sprites = TRUE
	has_vore_belly_sprites = TRUE
	has_rest_sprites = TRUE
	rest_sprite_options = list("Default", "Sit", "Bellyup")
	has_dead_sprite = TRUE
	has_dead_sprite_overlay = TRUE
	pixel_x = -16

	whitelist_ckey = "jademanique"
	whitelist_charname = "B.A.U-Kingside"

// L

/datum/robot_sprite/fluff/lunarfleet
	name = CUSTOM_BORGSPRITE("Clea-Nor")
	module_type = "Engineering"

	sprite_icon = 'icons/mob/robot/fluff_wide.dmi'
	sprite_icon_state = "lunarfleet-cleanor"
	sprite_hud_icon_state = "pupdozer"

	has_eye_light_sprites = TRUE
	has_vore_belly_sprites = TRUE
	has_rest_sprites = TRUE
	rest_sprite_options = list("Default", "Sit", "Bellyup")
	has_dead_sprite = TRUE
	has_dead_sprite_overlay = TRUE
	pixel_x = -16

	whitelist_ckey = "lunarfleet"
	whitelist_charname = "Clea-Nor"

#undef CUSTOM_BORGSPRITE
