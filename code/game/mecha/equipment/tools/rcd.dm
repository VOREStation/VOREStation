/obj/item/mecha_parts/mecha_equipment/tool/rcd
	name = "mounted RCD"
	desc = "An exosuit-mounted Rapid Construction Device. (Can be attached to: Any exosuit)"
	mech_flags = EXOSUIT_MODULE_WORKING|EXOSUIT_MODULE_COMBAT|EXOSUIT_MODULE_MEDICAL
	icon_state = "mecha_rcd"
	origin_tech = list(TECH_MATERIAL = 4, TECH_BLUESPACE = 3, TECH_MAGNET = 4, TECH_POWER = 4)
	equip_cooldown = 10
	energy_drain = 250
	range = MELEE|RANGED
	equip_type = EQUIP_SPECIAL
	var/obj/item/rcd/electric/mounted/mecha/my_rcd = null

/obj/item/mecha_parts/mecha_equipment/tool/rcd/Initialize(mapload)
	my_rcd = new(src)
	return ..()

/obj/item/mecha_parts/mecha_equipment/tool/rcd/Destroy()
	QDEL_NULL(my_rcd)
	return ..()

/obj/item/mecha_parts/mecha_equipment/tool/rcd/action(atom/target)
	if(!action_checks(target) || get_dist(chassis, target) > 3)
		return FALSE

	my_rcd.use_rcd(target, chassis.occupant)

/obj/item/mecha_parts/mecha_equipment/tool/rcd/Topic(href,href_list)
	..()
	if(href_list["mode"])
		my_rcd.mode_index = text2num(href_list["mode"])
		occupant_message("RCD reconfigured to '[my_rcd.modes[my_rcd.mode_index]]'.")
/*
/obj/item/mecha_parts/mecha_equipment/tool/rcd/get_equip_info()
	return "[..()] \[<a href='byond://?src=\ref[src];mode=0'>D</a>|<a href='byond://?src=\ref[src];mode=1'>C</a>|<a href='byond://?src=\ref[src];mode=2'>A</a>\]"
*/
/obj/item/mecha_parts/mecha_equipment/tool/rcd/get_equip_info()
	var/list/content = list(..()) // This is all for one line, in the interest of string tree conservation.
	var/i = 1
	content += "<br>"
	for(var/mode in my_rcd.modes)
		content += "     <a href='byond://?src=\ref[src];mode=[i]'>[mode]</a>"
		if(i < my_rcd.modes.len)
			content += "<br>"
		i++

	return content.Join()
