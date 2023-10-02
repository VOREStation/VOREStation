// Syndie borg sprites

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

/datum/robot_sprite/dogborg/mechanist/pupdozer
	name = "Pupdozer"
	sprite_icon_state = "pupdozer"
	has_eye_light_sprites = TRUE
	rest_sprite_options = list("Default")


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

/* //Handled by the normal belly code now.
/datum/robot_sprite/dogborg/crisis/get_belly_overlay(var/mob/living/silicon/robot/ourborg)
	if(has_sleeper_light_indicator)
		if(ourborg.sleeper_state == 2 && !(ourborg.vore_selected?.silicon_belly_overlay_preference == "Vorebelly")) return "[sprite_icon_state]-sleeper_g"
		else return "[sprite_icon_state]-sleeper_r"
	else
		return ..()
*/
/datum/robot_sprite/dogborg/combat_medic/do_equipment_glamour(var/obj/item/weapon/robot_module/module)
	if(!has_custom_equipment_sprites)
		return

	..()

	var/obj/item/weapon/shockpaddles/robot/SP = locate() in module.modules
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
