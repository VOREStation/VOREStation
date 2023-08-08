// Event/special borg sprites

// Lost

// Regular sprites

/datum/robot_sprite/lost
	module_type = "Lost"
	sprite_icon = 'icons/mob/robot/lost.dmi'

	var/has_shield_sprite = FALSE

/datum/robot_sprite/lost/handle_extra_icon_updates(var/mob/living/silicon/robot/ourborg)
	if(has_shield_sprite)
		if(ourborg.has_active_type(/obj/item/borg/combat/shield))
			var/obj/item/borg/combat/shield/shield = locate() in ourborg
			if(shield && shield.active)
				ourborg.add_overlay("[sprite_icon_state]-shield")

/datum/robot_sprite/lost/drone
	name = "Drone"
	sprite_icon_state = "drone"
	has_shield_sprite = TRUE

// Wide/dogborg sprites

/datum/robot_sprite/dogborg/lost
	module_type = "Lost"
	sprite_icon = 'icons/mob/robot/lost_wide.dmi'

/datum/robot_sprite/dogborg/lost/stray
	name = "Stray"
	sprite_icon_state = "stray"


// Gravekeeper

// Regular sprites

/datum/robot_sprite/gravekeeper
	module_type = "Gravekeeper"
	sprite_icon = 'icons/mob/robot/gravekeeper.dmi'
	sprite_hud_icon_state = "lost"

	var/has_shield_sprite = FALSE

/datum/robot_sprite/gravekeeper/handle_extra_icon_updates(var/mob/living/silicon/robot/ourborg)
	if(has_shield_sprite)
		if(ourborg.has_active_type(/obj/item/borg/combat/shield))
			var/obj/item/borg/combat/shield/shield = locate() in ourborg
			if(shield && shield.active)
				ourborg.add_overlay("[sprite_icon_state]-shield")

/datum/robot_sprite/gravekeeper/drone
	name = "Drone"
	sprite_icon_state = "drone"
	has_shield_sprite = TRUE

/datum/robot_sprite/gravekeeper/sleek
	name = "WTOperator"
	sprite_icon_state = "sleek"
	has_shield_sprite = TRUE