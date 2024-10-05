/obj/item/mecha_parts/mecha_equipment/cloak
	name = "cloaking device"
	desc = "Integrated cloaking system. High power usage, but does render you invisible to the naked eye. Doesn't prevent noise, however."
	icon_state = "tesla"
	origin_tech = list(TECH_MAGNET = 5, TECH_DATA = 5)
	energy_drain = 300
	range = 0
	equip_type = EQUIP_SPECIAL

/obj/item/mecha_parts/mecha_equipment/cloak/process()
	..()
	//Removed from chassis or ran out of power
	if(!chassis || !chassis.use_power(energy_drain))
		stop_cloak()
		return

/obj/item/mecha_parts/mecha_equipment/cloak/detach()
	if(!equip_ready) //We were running
		stop_cloak()
	return ..()

/obj/item/mecha_parts/mecha_equipment/cloak/get_equip_info()
	if(!chassis)
		return
	return (equip_ready ? span_green("*") : span_red("*")) + "&nbsp;[src.name] - <a href='?src=\ref[src];toggle_cloak=1'>[equip_ready ? "A" : "Dea"]ctivate</a>"

/obj/item/mecha_parts/mecha_equipment/cloak/Topic(href, href_list)
	..()
	if(href_list["toggle_cloak"])
		if(equip_ready)
			start_cloak()
		else
			stop_cloak()
	return

/obj/item/mecha_parts/mecha_equipment/cloak/proc/start_cloak()
	if(chassis)
		chassis.cloak()
	log_message("Activated.")
	START_PROCESSING(SSobj, src)
	set_ready_state(FALSE)
	playsound(src, 'sound/effects/EMPulse.ogg', 100, 1)

/obj/item/mecha_parts/mecha_equipment/cloak/proc/stop_cloak()
	if(chassis)
		chassis.uncloak()
	log_message("Deactivated.")
	STOP_PROCESSING(SSobj, src)
	set_ready_state(TRUE)
	playsound(src, 'sound/effects/EMPulse.ogg', 100, 1)
