/datum/robot_sprite
	var/name
	var/module_type
	var/default_sprite = FALSE
	var/sprite_flags

	var/sprite_icon
	var/sprite_icon_state
	var/sprite_hud_icon_state

	var/has_eye_sprites = TRUE
	var/has_eye_light_sprites = FALSE
	var/has_custom_open_sprites = FALSE
	var/has_vore_belly_sprites = FALSE
	var/has_vore_belly_resting_sprites = FALSE
	var/has_sleeper_light_indicator = FALSE //Moved here because there's no reason lights should be limited to just medical borgs. Or redefined every time they ARE used.
	var/has_vore_struggle_sprite = FALSE
	var/max_belly_size = 1 //If larger bellies are made, set this to the value of the largest size
	var/has_rest_sprites = FALSE
	var/list/rest_sprite_options
	var/has_dead_sprite = FALSE
	var/has_dead_sprite_overlay = FALSE
	var/has_extra_customization = FALSE
	var/has_custom_equipment_sprites = FALSE
	var/has_glow_sprites = FALSE
	var/vis_height = 32
	var/pixel_x = 0
	var/icon_x = 32
	var/icon_y = 32

	var/is_whitelisted = FALSE
	var/whitelist_ckey
	var/whitelist_charname
	var/list/belly_light_list = list() // Support multiple sleepers with r/g light "sleeper"
	var/list/belly_capacity_list = list() //Support multiple bellies with multiple sizes, default: "sleeper" = 1
	var/list/sprite_decals = list() // Allow extra decals
	var/list/sprite_animations = list() // Allows to flick animations

/// Determines if the borg has the proper flags to show an overlay.
/datum/robot_sprite/proc/sprite_flag_check(var/flag_to_check)
	return (sprite_flags & flag_to_check)

/datum/robot_sprite/proc/handle_extra_icon_updates(var/mob/living/silicon/robot/ourborg)
	if(ourborg.resting) //Don't do ANY of the overlay code if we're resting. It just won't look right!
		return
	if(sprite_flag_check(ROBOT_HAS_SHIELD_SPEED_SPRITE))
		if(ourborg.has_active_type(/obj/item/borg/combat/shield) && ourborg.has_active_type(/obj/item/borg/combat/mobility))
			ourborg.add_overlay("[sprite_icon_state]-speed_shield")
			return //Stop here. No need to add more overlays. Nothing else is compatible.

	if(sprite_flag_check(ROBOT_HAS_SPEED_SPRITE) && ourborg.has_active_type(/obj/item/borg/combat/mobility))
		ourborg.icon_state = "[sprite_icon_state]-roll"
		return //Stop here. No need to add more overlays. Nothing else is compatible.

	if(sprite_flag_check(ROBOT_HAS_SHIELD_SPRITE))
		if(ourborg.has_active_type(/obj/item/borg/combat/shield))
			var/obj/item/borg/combat/shield/shield = locate() in ourborg
			if(shield && shield.active)
				ourborg.add_overlay("[sprite_icon_state]-shield")

	if(ourborg.activated_module_type_list(list(/obj/item/melee/robotic, /obj/item/gun/energy/robotic)))
		for(var/thing_to_check in ourborg.get_active_modules()) //We look at our active modules. Let's peep!

			//Melee Check
			if(istype(thing_to_check, /obj/item/melee/robotic))
				var/obj/item/melee/robotic/melee = thing_to_check
				if(sprite_flag_check(ROBOT_HAS_MELEE_SPRITE) && melee.weapon_flag_check(COUNTS_AS_ROBOTIC_MELEE))
					ourborg.add_overlay("[sprite_icon_state]-melee")
					continue
				if(sprite_flag_check(ROBOT_HAS_DAGGER_SPRITE) && melee.weapon_flag_check(COUNTS_AS_ROBOT_DAGGER))
					ourborg.add_overlay("[sprite_icon_state]-dagger")
					continue
				if(sprite_flag_check(ROBOT_HAS_BLADE_SPRITE) && melee.weapon_flag_check(COUNTS_AS_ROBOT_BLADE))
					ourborg.add_overlay("[sprite_icon_state]-blade")
					continue

			//Gun Check
			if(istype(thing_to_check, /obj/item/gun/energy/robotic))
				var/obj/item/gun/energy/robotic/gun = thing_to_check
				if(sprite_flag_check(ROBOT_HAS_GUN_SPRITE) && gun.gun_flag_check(COUNTS_AS_ROBOT_GUN))
					ourborg.add_overlay("[sprite_icon_state]-gun")
					continue
				if(sprite_flag_check(ROBOT_HAS_LASER_SPRITE) && gun.gun_flag_check(COUNTS_AS_ROBOT_LASER))
					ourborg.add_overlay("[sprite_icon_state]-laser")
					continue
				if(sprite_flag_check(ROBOT_HAS_TASER_SPRITE) && gun.gun_flag_check(COUNTS_AS_ROBOT_TASER))
					ourborg.add_overlay("[sprite_icon_state]-taser")
					continue
				if(sprite_flag_check(ROBOT_HAS_DISABLER_SPRITE) && gun.gun_flag_check(COUNTS_AS_ROBOT_DISABLER))
					ourborg.add_overlay("[sprite_icon_state]-disabler")
					continue
	//These are outliers that don't fit the normal sprite flags. These should not be expanded unless absolutely neccessary.
	if(ourborg.activated_module_type_list(list(/obj/item/pickaxe)))
		for(var/thing_to_check in ourborg.get_active_modules()) //We look at our active modules. Let's peep!
			if(istype(thing_to_check, /obj/item/pickaxe))
				var/obj/item/pickaxe/melee = thing_to_check
				if(sprite_flag_check(ROBOT_HAS_MELEE_SPRITE) && melee.weapon_flag_check(COUNTS_AS_ROBOTIC_MELEE))
					ourborg.add_overlay("[sprite_icon_state]-melee")
					continue

/datum/robot_sprite/proc/get_belly_overlay(var/mob/living/silicon/robot/ourborg, var/size = 1, var/b_class)
	//Size
	if(has_sleeper_light_indicator || belly_light_list.len)
		if(belly_light_list.len)
			if(belly_light_list.Find(b_class))
				//First, Sleeper base icon is input. Second the belly class, supposedly taken from the borg's vore_fullness_ex list.
				//The belly class should be the same as the belly sprite's name, with as many size values as you defined in the
				//vore_capacity_ex list. Finally, if the borg has a red/green light sleeper, it'll use g or r appended to the end.
				//Bellies with lights should be defined in belly_light_list
				var/sleeperColor = "g"
				if(ourborg.sleeper_state == 1 || ourborg.vore_light_states[b_class] == 1) // Is our belly safe, or gurgling cuties?
					sleeperColor = "r"
				return "[sprite_icon_state]-[b_class]-[size]-[sleeperColor]"

			return "[sprite_icon_state]-[b_class]-[size]"
		else
			var/sleeperColor = "g"
			if(ourborg.sleeper_state == 1) // Is our belly safe, or gurgling cuties?
				sleeperColor = "r"
			return "[sprite_icon_state]-[b_class]-[size]-[sleeperColor]"
	return "[sprite_icon_state]-[b_class]-[size]"

/datum/robot_sprite/proc/get_belly_resting_overlay(var/mob/living/silicon/robot/ourborg, var/size = 1, var/b_class)
	if(!(ourborg.rest_style in rest_sprite_options))
		ourborg.rest_style = "Default"
	switch(ourborg.rest_style)
		if("Sit")
			return "[get_belly_overlay(ourborg, size, b_class)]-sit"
		if("Bellyup")
			return "[get_belly_overlay(ourborg, size, b_class)]-bellyup"
		else
			return "[get_belly_overlay(ourborg, size, b_class)]-rest"

/datum/robot_sprite/proc/get_glow_overlay(var/mob/living/silicon/robot/ourborg)
	if(!ourborg.resting)
		return "[sprite_icon_state]-glow"
	return "[get_rest_sprite(ourborg)]-glow"

/datum/robot_sprite/proc/get_eyes_overlay(var/mob/living/silicon/robot/ourborg)
	if(!(ourborg.resting && has_rest_sprites))
		return "[sprite_icon_state]-eyes"
	else
		return

/datum/robot_sprite/proc/get_eye_light_overlay(var/mob/living/silicon/robot/ourborg)
	if(!(ourborg.resting && has_rest_sprites))
		return "[sprite_icon_state]-lights"
	else
		return

/datum/robot_sprite/proc/get_robotdecal_overlay(var/mob/living/silicon/robot/ourborg, var/type)
	if(LAZYLEN(sprite_decals))
		if(!ourborg.resting)
			return "[sprite_icon_state]-[type]"
		switch(ourborg.rest_style)
			if("Sit")
				return "[sprite_icon_state]-[type]-sit"
			if("Bellyup")
				return "[sprite_icon_state]-[type]-bellyup"
			else
				return "[sprite_icon_state]-[type]-rest"


/datum/robot_sprite/proc/get_rest_sprite(var/mob/living/silicon/robot/ourborg)
	if(!(ourborg.rest_style in rest_sprite_options))
		ourborg.rest_style = "Default"
	switch(ourborg.rest_style)
		if("Sit")
			return "[sprite_icon_state]-sit"
		if("Bellyup")
			return "[sprite_icon_state]-bellyup"
		else
			return "[sprite_icon_state]-rest"

/datum/robot_sprite/proc/get_dead_sprite(var/mob/living/silicon/robot/ourborg)
	return "[sprite_icon_state]-wreck"

/datum/robot_sprite/proc/get_dead_sprite_overlay(var/mob/living/silicon/robot/ourborg)
	return "wreck-overlay"

/datum/robot_sprite/proc/get_open_sprite(var/mob/living/silicon/robot/ourborg)
	if(!ourborg.opened)
		return
	if(ourborg.wiresexposed)
		. = "openpanel_w"
	else if(ourborg.cell)
		. = "openpanel_c"
	else
		. = "openpanel_nc"

	if(has_custom_open_sprites)
		. = "[sprite_icon_state]-[.]"

	return

/datum/robot_sprite/proc/handle_extra_customization(var/mob/living/silicon/robot/ourborg)
	return

/datum/robot_sprite/proc/do_equipment_glamour(var/obj/item/robot_module/module)
	return

// Dogborgs and not-dogborgs that use dogborg stuff. Oh no.
// Not really necessary to be used by any specific sprite actually, even newly added dogborgs.
// Mostly a combination of all features dogborgs had prior to conversion to datums for convinience of conversion itself.

/datum/robot_sprite/dogborg
	has_vore_belly_sprites = TRUE
	has_rest_sprites = TRUE
	rest_sprite_options = list("Default", "Sit", "Bellyup")
	has_dead_sprite = TRUE
	has_dead_sprite_overlay = TRUE
	has_custom_equipment_sprites = TRUE
	pixel_x = -16
	icon_x = 64
	icon_y = 32

/datum/robot_sprite/dogborg/do_equipment_glamour(var/obj/item/robot_module/module)
	if(!has_custom_equipment_sprites)
		return

	var/obj/item/tool/crowbar/cyborg/C = locate() in module.modules
	if(C)
		C.name = "puppy jaws"
		C.desc = "The jaws of a small dog. Still strong enough to pry things."
		C.icon = 'icons/mob/dogborg_vr.dmi'
		C.icon_state = "smalljaws_textless"
		C.hitsound = 'sound/weapons/bite.ogg'
		C.attack_verb = list("nibbled", "bit", "gnawed", "chomped", "nommed")


/datum/robot_sprite/dogborg/tall
	has_dead_sprite_overlay = FALSE
	has_custom_equipment_sprites = FALSE
	vis_height = 64
	icon_x = 64
	icon_y = 64


// Default module sprite

/datum/robot_sprite/default
	name = DEFAULT_ROBOT_SPRITE_NAME
	module_type = "Default"
	sprite_icon = 'icons/mob/robot/default.dmi'
	sprite_icon_state = "default"
	default_sprite = TRUE
