/obj/item/mecha_parts/mecha_equipment/tool/powertool
	name = "pneumatic wrench"
	desc = "An exosuit-mounted hydraulic wrench."
	icon_state = "mecha_wrench"
	origin_tech = list(TECH_MATERIAL = 2, TECH_MAGNET = 2, TECH_POWER = 2)
	equip_cooldown = 3
	energy_drain = 15
	range = MELEE
	equip_type = EQUIP_UTILITY
	ready_sound = 'sound/items/Ratchet.ogg'
	required_type = list(/obj/mecha/working/ripley)

	var/obj/item/my_tool = null
	var/tooltype = /obj/item/weapon/tool/wrench/power

/obj/item/mecha_parts/mecha_equipment/tool/powertool/Initialize()
	my_tool = new tooltype(src)
	my_tool.name = name
	my_tool.anchored = TRUE
	my_tool.canremove = FALSE
	return ..()

/obj/item/mecha_parts/mecha_equipment/tool/powertool/Destroy()
	QDEL_NULL(my_tool)
	return ..()

/obj/item/mecha_parts/mecha_equipment/tool/powertool/action(var/atom/target)
	if(!action_checks(target))
		return FALSE

	if(isliving(target))
		my_tool.attack(target, chassis.occupant, BP_TORSO)

	target.attackby(my_tool,chassis.occupant)

/obj/item/mecha_parts/mecha_equipment/tool/powertool/prybar
	name = "pneumatic prybar"
	desc = "An exosuit-mounted pneumatic prybar."
	icon_state = "mecha_crowbar"
	tooltype = /obj/item/weapon/tool/crowbar/power
	ready_sound = 'sound/mecha/gasdisconnected.ogg'