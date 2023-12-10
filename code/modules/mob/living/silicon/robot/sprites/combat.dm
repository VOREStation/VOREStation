// Regular sprites

/datum/robot_sprite/combat
	module_type = "Combat"
	sprite_icon = 'icons/mob/robot/combat.dmi'

	var/has_speed_sprite = FALSE
	var/has_shield_sprite = FALSE

/datum/robot_sprite/combat/handle_extra_icon_updates(var/mob/living/silicon/robot/ourborg)
	if(has_speed_sprite)
		if(istype(ourborg.module_active,/obj/item/borg/combat/mobility))
			ourborg.icon_state = "[sprite_icon_state]-roll"
	if(has_shield_sprite)
		if(ourborg.has_active_type(/obj/item/borg/combat/shield))
			var/obj/item/borg/combat/shield/shield = locate() in ourborg
			if(shield && shield.active)
				ourborg.add_overlay("[sprite_icon_state]-shield")

/datum/robot_sprite/combat/default
	name = DEFAULT_ROBOT_SPRITE_NAME
	default_sprite = TRUE
	sprite_icon_state = "default"

/datum/robot_sprite/combat/marina
	name = "Haruka"
	sprite_icon_state = "marina"
	has_speed_sprite = TRUE
	has_shield_sprite = TRUE

/datum/robot_sprite/combat/droid
	name = "Android"
	sprite_icon_state = "droid"
	has_speed_sprite = TRUE
	has_shield_sprite = TRUE

/datum/robot_sprite/combat/droid/get_eyes_overlay(var/mob/living/silicon/robot/ourborg)
	if(istype(ourborg.module_active,/obj/item/borg/combat/mobility))
		return
	else
		return ..()

/datum/robot_sprite/combat/insekt
	name = "Insekt"
	sprite_icon_state = "insekt"
	has_shield_sprite = TRUE

/datum/robot_sprite/combat/decapod
	name = "Decapod"
	sprite_icon_state = "decapod"
	has_custom_open_sprites = TRUE
	has_shield_sprite = TRUE

/datum/robot_sprite/combat/mechoid
	name = "Acheron"
	sprite_icon_state = "mechoid"
	has_speed_sprite = TRUE
	has_shield_sprite = TRUE

/datum/robot_sprite/combat/zoomba
	name = "ZOOM-BA"
	sprite_icon_state = "zoomba"
	has_dead_sprite = TRUE
	has_speed_sprite = TRUE
	has_shield_sprite = TRUE

/datum/robot_sprite/combat/worm
	name = "W02M"
	sprite_icon_state = "worm"
	has_custom_open_sprites = TRUE
	has_shield_sprite = TRUE

/datum/robot_sprite/combat/uptall
	name = "Feminine Humanoid"
	sprite_icon_state = "uptall"

// Wide/dogborg sprites
/*
/datum/robot_sprite/dogborg/combat
	module_type = "Combat"
	sprite_icon = 'icons/mob/robot/combat_wide.dmi'

		// None yet
*/
// Tall sprites

/datum/robot_sprite/dogborg/tall/combat
	module_type = "Combat"
	sprite_icon = 'icons/mob/robot/combat_large.dmi'
	has_custom_equipment_sprites = TRUE

	var/has_gun_sprite = FALSE

/datum/robot_sprite/dogborg/tall/combat/handle_extra_icon_updates(var/mob/living/silicon/robot/ourborg)
	if(has_gun_sprite && (istype(ourborg.module_active, /obj/item/weapon/gun/energy/laser/mounted) || istype(ourborg.module_active, /obj/item/weapon/gun/energy/taser/mounted/cyborg/ertgun) || istype(ourborg.module_active, /obj/item/weapon/gun/energy/lasercannon/mounted)))
		ourborg.add_overlay("[sprite_icon_state]-gun")

/datum/robot_sprite/dogborg/tall/combat/do_equipment_glamour(var/obj/item/weapon/robot_module/module)
	if(!has_custom_equipment_sprites)
		return

	..()

	var/obj/item/weapon/combat_borgblade/CBB = locate() in module.modules
	if(CBB)
		CBB.name = "sword tail"
		CBB.desc = "A glowing dagger normally attached to the end of a cyborg's tail. It appears to be extremely sharp."
	var/obj/item/weapon/borg_combat_shocker/BCS = locate() in module.modules
	if(BCS)
		BCS.name = "combat jaws"
		BCS.desc = "Shockingly chompy!"
		BCS.icon_state = "ertjaws"
		BCS.hitsound = 'sound/weapons/bite.ogg'
		BCS.attack_verb = list("chomped", "bit", "ripped", "mauled", "enforced")
		BCS.dogborg = TRUE

/datum/robot_sprite/dogborg/tall/combat/derg
	name = "ERT"
	sprite_icon_state = "derg"
	rest_sprite_options = list("Default")
	has_gun_sprite = TRUE

/datum/robot_sprite/dogborg/tall/combat/hound
	name = "Hound"
	sprite_icon_state = "hound"
	sprite_hud_icon_state = "ert"
	rest_sprite_options = list("Default")

/datum/robot_sprite/dogborg/tall/combat/borgi
	name = "Borgi"
	sprite_icon_state = "borgi"
	sprite_hud_icon_state = "ert"
	rest_sprite_options = list("Default")
	has_eye_sprites = FALSE
	has_eye_light_sprites = TRUE