
/obj/item/mecha_parts/component/electrical
	name = "mecha electrical harness"
	desc = "The sum of capacitors, switches, resistors, sensors, cabling and ports that make everything talk to everything else inside the mech."
	icon = 'icons/mecha/mech_component.dmi'
	icon_state = "board"
	w_class = ITEMSIZE_HUGE

	component_type = MECH_ELECTRIC

	emp_resistance = 1

	integrity_danger_mod = 0.4
	max_integrity = 40

	step_delay = 0

	relative_size = 20

	internal_damage_flag = MECHA_INT_SHORT_CIRCUIT

	var/charge_cost_mod = 1

/obj/item/mecha_parts/component/electrical/high_current
	name = "efficient mecha electrical harness"
	desc = "The sum of capacitors, switches, resistors, sensors, cabling and ports that make everything talk to everything else inside the mech. This one stripped most of the passive capacitors aimed at stabilizing the system in the event of a surge, in exchange for faster charging, and a smaller size."
	emp_resistance = 0
	max_integrity = 30

	relative_size = 10
	charge_cost_mod = 0.6
