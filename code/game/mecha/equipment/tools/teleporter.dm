/obj/item/mecha_parts/mecha_equipment/teleporter
	name = "teleporter"
	desc = "An exosuit module that allows exosuits to teleport to any position in view."
	icon_state = "mecha_teleport"
	origin_tech = list(TECH_BLUESPACE = 10)
	equip_cooldown = 150
	energy_drain = 1000
	range = RANGED

	equip_type = EQUIP_SPECIAL

/obj/item/mecha_parts/mecha_equipment/teleporter/action(atom/target)
	if(!action_checks(target) || src.loc.z == 2) return
	var/turf/T = get_turf(target)
	if(T)
		set_ready_state(0)
		chassis.use_power(energy_drain)
		do_teleport(chassis, T, 4)
		do_after_cooldown()
	return