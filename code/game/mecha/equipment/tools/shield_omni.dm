#define OMNI_SHIELD_DRAIN 30

/obj/item/mecha_parts/mecha_equipment/omni_shield
	name = "omni shield"
	desc = "A shield generator that forms an ennlosing, omnidirectional shield around the exosuit."
	icon_state = "shield"
	origin_tech = list(TECH_PHORON = 3, TECH_MAGNET = 6, TECH_ILLEGAL = 4)
	equip_cooldown = 5
	energy_drain = OMNI_SHIELD_DRAIN
	range = 0

	step_delay = 0.2

	var/obj/item/shield_projector/shields = null
	var/shield_type = /obj/item/shield_projector/rectangle/mecha

	equip_type = EQUIP_HULL

/obj/item/mecha_parts/mecha_equipment/omni_shield/critfail()
	..()
	shields.adjust_health(-200)

/obj/item/mecha_parts/mecha_equipment/omni_shield/Destroy()
	QDEL_NULL(shields)
	..()

/obj/item/mecha_parts/mecha_equipment/omni_shield/attach(obj/mecha/M as obj)
	. = ..()
	if(chassis)
		shields = new shield_type(chassis)

/obj/item/mecha_parts/mecha_equipment/omni_shield/detach()
	if(chassis)
		QDEL_NULL(shields)
	. = ..()

/obj/item/mecha_parts/mecha_equipment/omni_shield/handle_movement_action()
	if(chassis && shields)
		shields.update_shield_positions()

/obj/item/mecha_parts/mecha_equipment/omni_shield/proc/toggle_shield()
	if(shields)
		shields.set_on(!shields.active)
		if(shields.active)
			set_ready_state(FALSE)
			step_delay = 4
			log_message("Activated.")
		else
			set_ready_state(TRUE)
			step_delay = initial(step_delay)
			log_message("Deactivated.")

/obj/item/mecha_parts/mecha_equipment/omni_shield/Topic(href, href_list)
	..()
	if(href_list["toggle_omnishield"])
		toggle_shield()

/obj/item/mecha_parts/mecha_equipment/omni_shield/get_equip_info()
	if(!chassis) return
	return (equip_ready ? span_green("*") : span_red("*")) + "&nbsp;[src.name] - <a href='byond://?src=\ref[src];toggle_omnishield=1'>[shields?.active?"Dea":"A"]ctivate</a>"


////// The shield projector object
/obj/item/shield_projector/rectangle/mecha
	shield_health = 200
	max_shield_health = 200
	shield_regen_delay = 10 SECONDS
	shield_regen_amount = 10
	size_x = 1
	size_y = 1

	var/shift_x = 0
	var/shift_y = 0

	var/obj/mecha/my_mech = null

/obj/item/shield_projector/rectangle/mecha/Initialize(mapload)
	. = ..()
	my_mech = loc
	RegisterSignal(my_mech, COMSIG_OBSERVER_MOVED, /obj/item/shield_projector/proc/update_shield_positions)
	my_mech.AddComponent(/datum/component/recursive_move)
	update_shift(my_mech)

/obj/item/shield_projector/rectangle/mecha/proc/update_shift(atom/movable/mech)
	var/icon/my_icon = icon(mech.icon) //holy heck
	var/x_dif = (my_icon.Width() - world.icon_size) / 2
	shift_x = round(x_dif, 1)
	var/y_dif = (my_icon.Height() - world.icon_size) / 2
	shift_y = round(y_dif, 1)

/obj/item/shield_projector/rectangle/mecha/Destroy()
	UnregisterSignal(my_mech, COMSIG_OBSERVER_MOVED)
	my_mech = null
	..()

/obj/item/shield_projector/rectangle/mecha/create_shield()
	. = ..()
	if(shift_x || shift_y)
		var/obj/effect/directional_shield/newshield = active_shields[active_shields.len]
		newshield.pixel_x = shift_x
		newshield.pixel_y = shift_y

/obj/item/shield_projector/rectangle/mecha/adjust_health(amount)
	. = ..()
	my_mech.use_power(OMNI_SHIELD_DRAIN)
	if(!active && shield_health < shield_regen_amount)
		my_mech.use_power(OMNI_SHIELD_DRAIN * 4)

#undef OMNI_SHIELD_DRAIN
