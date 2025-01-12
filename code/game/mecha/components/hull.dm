
/obj/item/mecha_parts/component/hull
	name = "mecha hull"
	icon = 'icons/mecha/mech_component.dmi'
	icon_state = "hull"
	w_class = ITEMSIZE_HUGE
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)

	component_type = MECH_HULL

	emp_resistance = 0	// Amount of emp 'levels' removed.

	required_type = null	// List, if it exists. Exosuits meant to use the component.

	integrity_danger_mod = 0.5	// Multiplier for comparison to max_integrity before problems start.
	max_integrity = 50

	internal_damage_flag = MECHA_INT_FIRE

	step_delay = 2

/obj/item/mecha_parts/component/hull/durable
	name = "durable mecha hull"

	step_delay = 4
	integrity_danger_mod = 0.3
	max_integrity = 100

/obj/item/mecha_parts/component/hull/lightweight
	name = "lightweight mecha hull"

	step_delay = 1
	integrity_danger_mod = 0.3

/obj/item/mecha_parts/component/hull/fighter
	name = "fighter hull"

	step_delay = 0
	integrity_danger_mod = 0.5
	required_type = list(/obj/mecha/combat/fighter)
