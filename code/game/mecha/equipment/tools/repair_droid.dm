/obj/item/mecha_parts/mecha_equipment/repair_droid
	name = "repair droid"
	desc = "Automated repair droid. Scans exosuit for damage and repairs it. Can fix almost any type of external or internal damage."
	icon_state = "repair_droid"
	origin_tech = list(TECH_MAGNET = 3, TECH_DATA = 3)
	equip_cooldown = 20
	energy_drain = 100
	range = 0
	var/health_boost = 2
	var/icon/droid_overlay
	var/list/repairable_damage = list(MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH)

	step_delay = 1

	equip_type = EQUIP_HULL

/obj/item/mecha_parts/mecha_equipment/repair_droid/add_equip_overlay(obj/mecha/M as obj)
	..()
	if(!droid_overlay)
		droid_overlay = new(src.icon, icon_state = "repair_droid")
	M.add_overlay(droid_overlay)
	return

/obj/item/mecha_parts/mecha_equipment/repair_droid/destroy()
	chassis.cut_overlay(droid_overlay)
	..()
	return

/obj/item/mecha_parts/mecha_equipment/repair_droid/detach()
	chassis.cut_overlay(droid_overlay)
	STOP_PROCESSING(SSobj, src)
	..()
	return

/obj/item/mecha_parts/mecha_equipment/repair_droid/get_equip_info()
	if(!chassis) return
	return "<span style=\"color:[equip_ready?"#0f0":"#f00"];\">*</span>&nbsp;[src.name] - <a href='?src=\ref[src];toggle_repairs=1'>[(datum_flags & DF_ISPROCESSING)?"Dea":"A"]ctivate</a>"


/obj/item/mecha_parts/mecha_equipment/repair_droid/Topic(href, href_list)
	..()
	if(href_list["toggle_repairs"])
		chassis.cut_overlay(droid_overlay)
		if(datum_flags & DF_ISPROCESSING)
			droid_overlay = new(src.icon, icon_state = "repair_droid")
			STOP_PROCESSING(SSobj, src)
			log_message("Deactivated.")
			set_ready_state(TRUE)
		else
			droid_overlay = new(src.icon, icon_state = "repair_droid_a")
			log_message("Activated.")
			START_PROCESSING(SSobj, src)
		chassis.add_overlay(droid_overlay)
		send_byjax(chassis.occupant,"exosuit.browser","\ref[src]",src.get_equip_info())
	return

/obj/item/mecha_parts/mecha_equipment/repair_droid/process()
	if(!chassis)
		set_ready_state(TRUE)
		return PROCESS_KILL
	var/repaired = 0
	var/effective_boost = health_boost
	if(chassis.hasInternalDamage(MECHA_INT_SHORT_CIRCUIT))
		effective_boost *= -2
	else if(chassis.hasInternalDamage() && prob(15))
		for(var/int_dam_flag in repairable_damage)
			if(chassis.hasInternalDamage(int_dam_flag))
				chassis.clearInternalDamage(int_dam_flag)
				repaired = 1
				break

	var/obj/item/mecha_parts/component/AC = chassis.internal_components[MECH_ARMOR]
	var/obj/item/mecha_parts/component/HC = chassis.internal_components[MECH_HULL]

	var/damaged_armor = AC.integrity < AC.max_integrity

	var/damaged_hull = HC.integrity < HC.max_integrity

	if(effective_boost<0 || chassis.health < initial(chassis.health) || damaged_armor || damaged_hull)
		chassis.health += min(effective_boost, initial(chassis.health)-chassis.health)

		if(AC)
			AC.adjust_integrity(round(effective_boost * 0.5, 0.5))

		if(HC)
			HC.adjust_integrity(round(effective_boost * 0.5, 0.5))

		repaired = 1
	if(repaired)
		if(chassis.use_power(energy_drain))
			set_ready_state(FALSE)
		else
			set_ready_state(TRUE)
			return PROCESS_KILL
	else
		set_ready_state(TRUE)
	return