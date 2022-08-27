/obj/item/mecha_parts/mecha_equipment/combat_shield
	name = "linear combat shield"
	desc = "A shield generator that forms a rectangular, unidirectionally projectile-blocking wall in front of the exosuit."
	icon_state = "shield"
	origin_tech = list(TECH_PHORON = 3, TECH_MAGNET = 6, TECH_ILLEGAL = 4)
	equip_cooldown = 5
	energy_drain = 20
	range = 0

	step_delay = 0.2

	var/obj/item/shield_projector/line/exosuit/my_shield = null
	var/my_shield_type = /obj/item/shield_projector/line/exosuit
	var/icon/drone_overlay

	equip_type = EQUIP_HULL

/obj/item/mecha_parts/mecha_equipment/combat_shield/Initialize()
	. = ..()
	my_shield = new my_shield_type
	my_shield.shield_regen_delay = equip_cooldown
	my_shield.my_tool = src
	return

/obj/item/mecha_parts/mecha_equipment/combat_shield/critfail()
	..()
	my_shield.adjust_health(-200)
	return

/obj/item/mecha_parts/mecha_equipment/combat_shield/Destroy()
	chassis.cut_overlay(drone_overlay)
	my_shield.forceMove(src)
	my_shield.destroy_shields()
	my_shield.my_tool = null
	my_shield.my_mecha = null
	qdel(my_shield)
	my_shield = null
	..()

/obj/item/mecha_parts/mecha_equipment/combat_shield/add_equip_overlay(obj/mecha/M as obj)
	..()
	if(!drone_overlay)
		drone_overlay = new(src.icon, icon_state = "shield_droid")
	M.add_overlay(drone_overlay)
	return

/obj/item/mecha_parts/mecha_equipment/combat_shield/attach(obj/mecha/M as obj)
	..()
	if(chassis)
		my_shield.shield_health = 0
		my_shield.my_mecha = chassis
		my_shield.forceMove(chassis)
	return

/obj/item/mecha_parts/mecha_equipment/combat_shield/detach()
	chassis.cut_overlay(drone_overlay)
	..()
	my_shield.destroy_shields()
	my_shield.my_mecha = null
	my_shield.shield_health = my_shield.max_shield_health
	my_shield.forceMove(src)
	return

/obj/item/mecha_parts/mecha_equipment/combat_shield/handle_movement_action()
	if(chassis)
		my_shield.update_shield_positions()
	return

/obj/item/mecha_parts/mecha_equipment/combat_shield/proc/toggle_shield()
	if(chassis)
		my_shield.attack_self(chassis.occupant)
		if(my_shield.active)
			set_ready_state(FALSE)
			step_delay = 4
			log_message("Activated.")
		else
			set_ready_state(TRUE)
			step_delay = 1
			log_message("Deactivated.")

/obj/item/mecha_parts/mecha_equipment/combat_shield/Topic(href, href_list)
	..()
	if(href_list["toggle_shield"])
		toggle_shield()
	return

/obj/item/mecha_parts/mecha_equipment/combat_shield/get_equip_info()
	if(!chassis) return
	return "<span style=\"color:[equip_ready?"#0f0":"#f00"];\">*</span>&nbsp;[src.name] - <a href='?src=\ref[src];toggle_shield=1'>[my_shield.active?"Dea":"A"]ctivate</a>"