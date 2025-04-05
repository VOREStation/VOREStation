// Syndie borg sprites

/* none yet
/datum/robot_sprite/syndie
	module_type = list("Protector", "Mechanist", "Combat Medic")
	sprite_icon = 'icons/mob/robot/syndie.dmi'
	sprite_hud_icon_state = "malf"
*/

// Wide/dogborg sprites

/datum/robot_sprite/dogborg/syndie
	module_type = list("Protector", "Mechanist", "Combat Medic")
	sprite_icon = 'icons/mob/robot/syndie_wide.dmi'
	sprite_hud_icon_state = "malf"

/datum/robot_sprite/dogborg/syndie/borgi
	name = "Borgi"
	sprite_icon_state = "borgi"
	has_eye_sprites = FALSE
	has_eye_light_sprites = TRUE
	has_dead_sprite_overlay = FALSE

/datum/robot_sprite/dogborg/syndie/drake
	name = "Drake"
	sprite_icon_state = "drake"

// Tall sprites

/datum/robot_sprite/dogborg/tall/syndie
	module_type = list("Protector", "Mechanist", "Combat Medic")
	sprite_icon = 'icons/mob/robot/syndie_large.dmi'
	sprite_hud_icon_state = "malf"

/datum/robot_sprite/dogborg/tall/syndie/meka
	name = "MEKA"
	sprite_icon_state = "meka"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = TRUE
	has_vore_belly_sprites = FALSE
	rest_sprite_options = list("Default", "Sit")

/datum/robot_sprite/dogborg/tall/syndie/newmeka
	name = "MEKA v2"
	sprite_icon_state = "newmeka"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = TRUE
	rest_sprite_options = list("Default", "Sit")

/datum/robot_sprite/dogborg/tall/syndie/mmeka
	name = "NIKO"
	sprite_icon_state = "mmeka"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = TRUE
	rest_sprite_options = list("Default", "Sit")

/datum/robot_sprite/dogborg/tall/syndie/fmeka
	name = "NIKA"
	sprite_icon_state = "fmeka"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = TRUE
	rest_sprite_options = list("Default", "Sit")

/datum/robot_sprite/dogborg/tall/syndie/k4t
	name = "K4T"
	sprite_icon_state = "k4t"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = TRUE
	has_vore_belly_sprites = FALSE
	rest_sprite_options = list("Default", "Bellyup")

/datum/robot_sprite/dogborg/tall/combat_medic/dullahancombatmedic
	name = "Dullahan Combat Medic"
	sprite_icon = 'icons/mob/robot/dullahan/v1/dullahan_syndie.dmi'
	sprite_icon_state = "dullahansyndi"
	has_eye_light_sprites = TRUE
	has_vore_belly_sprites = TRUE
	rest_sprite_options = list("Default", "Sit")
	icon_x = 32
	pixel_x = 0

/datum/robot_sprite/dogborg/tall/syndie/dullahanv3syndi
	sprite_icon = 'icons/mob/robot/dullahan/v3/syndi.dmi'
	sprite_icon_state = "dullahansyndi"
	name = "Dullahan syndie v3"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = TRUE
	has_vore_belly_sprites = TRUE
	sprite_decals = list("decals")
	rest_sprite_options = list("Default", "Sit")


// Protector

// Regular sprites

/datum/robot_sprite/protector
	module_type = "Protector"
	sprite_icon = 'icons/mob/robot/protector.dmi'
	sprite_hud_icon_state = "malf"

/datum/robot_sprite/protector/bloodhound
	name = "Cerberus"
	sprite_icon_state = "bloodhound"

/datum/robot_sprite/protector/treadhound
	name = "Cerberus-Treaded"
	sprite_icon_state = "treadhound"

/datum/robot_sprite/protector/squats
	name = "Ares"
	sprite_icon_state = "squats"

/datum/robot_sprite/protector/heavy
	name = "XI-ALP"
	sprite_icon_state = "heavy"

// Wide/dogborg sprites

/datum/robot_sprite/dogborg/protector
	module_type = "Protector"
	sprite_icon = 'icons/mob/robot/protector_wide.dmi'
	sprite_hud_icon_state = "malf"

/datum/robot_sprite/dogborg/protector/k9
	name = "K9"
	sprite_icon_state = "k9"
	has_eye_light_sprites = TRUE

// Tall sprites

/datum/robot_sprite/dogborg/tall/protector
	module_type = "Protector"
	sprite_icon = 'icons/mob/robot/syndie_large.dmi'
	sprite_hud_icon_state = "malf"

/datum/robot_sprite/dogborg/tall/protector/syndiprotraptor
	name = "Raptor V-4"
	sprite_icon_state = "syndiprotraptor"
	has_eye_light_sprites = TRUE
	sprite_flags = ROBOT_HAS_GUN_SPRITE
	rest_sprite_options = list("Default", "Bellyup")

// Mechanist

// Regular sprites

/datum/robot_sprite/mechanist
	module_type = "Mechanist"
	sprite_icon = 'icons/mob/robot/mechanist.dmi'
	sprite_hud_icon_state = "malf"

/datum/robot_sprite/mechanist/spider
	name = "XI-GUS"
	sprite_icon_state = "spider"

/datum/robot_sprite/mechanist/sleek
	name = "WTOperator"
	sprite_icon_state = "sleek"

// Wide/dogborg sprites

/datum/robot_sprite/dogborg/mechanist
	module_type = "Mechanist"
	sprite_icon = 'icons/mob/robot/mechanist_wide.dmi'
	sprite_hud_icon_state = "malf"

/datum/robot_sprite/dogborg/mechanist/pupdozer
	name = "Pupdozer"
	sprite_icon_state = "pupdozer"
	has_eye_light_sprites = TRUE
	rest_sprite_options = list("Default")

// Tall sprites

/datum/robot_sprite/dogborg/tall/mechanist
	module_type = "Mechanist"
	sprite_icon = 'icons/mob/robot/syndie_large.dmi'
	sprite_hud_icon_state = "malf"

/datum/robot_sprite/dogborg/tall/mechanist/dullahanv3mech
	sprite_icon = 'icons/mob/robot/dullahan/v3/mechanist.dmi'
	sprite_icon_state = "dullahanmechanist"
	name = "Dullahan mechanist v3"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = TRUE
	has_vore_belly_sprites = TRUE
	sprite_decals = list("decals")
	rest_sprite_options = list("Default", "Sit")

/datum/robot_sprite/dogborg/tall/mechanist/syndimechraptor
	name = "Raptor V-4"
	sprite_icon_state = "syndimechraptor"
	has_eye_light_sprites = TRUE
	rest_sprite_options = list("Default", "Bellyup")

// Combat Medic

// Regular sprites

/datum/robot_sprite/combat_medic
	module_type = "Combat Medic"
	sprite_icon = 'icons/mob/robot/combat_medic.dmi'
	sprite_hud_icon_state = "malf"

/datum/robot_sprite/combat_medic/toiletbot
	name = "Telemachus"
	sprite_icon_state = "toiletbot"

// Wide/dogborg sprites

/datum/robot_sprite/dogborg/combat_medic
	module_type = "Combat Medic"
	sprite_icon = 'icons/mob/robot/combat_medic_wide.dmi'
	sprite_hud_icon_state = "malf"

/datum/robot_sprite/dogborg/combat_medic/do_equipment_glamour(var/obj/item/robot_module/module)
	if(!has_custom_equipment_sprites)
		return

	..()

	var/obj/item/shockpaddles/robot/SP = locate() in module.modules
	if(SP)
		SP.name = "paws of life"
		SP.desc = "Zappy paws. For fixing cardiac arrest."
		SP.icon = 'icons/mob/dogborg_vr.dmi'
		SP.icon_state = "defibpaddles0"
		SP.attack_verb = list("batted", "pawed", "bopped", "whapped")

/datum/robot_sprite/dogborg/combat_medic/vale
	name = "Hound V2"
	sprite_icon_state = "vale"
	has_eye_light_sprites = TRUE
	has_sleeper_light_indicator = TRUE

// Tall sprites

/datum/robot_sprite/dogborg/tall/combat_medic
	module_type = "Combat Medic"
	sprite_icon = 'icons/mob/robot/syndie_large.dmi'
	sprite_hud_icon_state = "malf"

/datum/robot_sprite/dogborg/tall/combat_medic/syndimediraptor
	name = "Raptor V-4"
	sprite_icon_state = "syndimediraptor"
	has_eye_light_sprites = TRUE
	rest_sprite_options = list("Default", "Bellyup")
