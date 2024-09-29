/obj/item/mecha_parts/mecha_equipment/tool/powertool/welding
	name = "welding laser"
	desc = "An exosuit-mounted welding laser."
	icon_state = "mecha_laser-rig"
	origin_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 3, TECH_POWER = 4, TECH_PHORON = 2)
	equip_cooldown = 3
	energy_drain = 15
	range = MELEE
	equip_type = EQUIP_UTILITY
	ready_sound = 'sound/items/Ratchet.ogg'
	required_type = list(/obj/mecha/working/ripley)

	tooltype = /obj/item/weldingtool/electric/mounted/exosuit

/obj/item/mecha_parts/mecha_equipment/tool/powertool/welding/action(var/atom/target)
	..()

	var/datum/beam/weld_beam = null
	if(is_ranged())
		var/atom/movable/beam_origin = chassis
		weld_beam = beam_origin.Beam(target, icon_state = "solar_beam", time = 0.3 SECONDS)

	if(!do_after(chassis.occupant, 0.3 SECONDS, target))
		qdel(weld_beam)

/obj/item/mecha_parts/mecha_equipment/tool/powertool/welding/attach(obj/mecha/M as obj)
	..()

	if(enable_special)
		range = MELEE|RANGED
		my_tool.reach = 7
	else
		range = MELEE
		my_tool.reach = 1
