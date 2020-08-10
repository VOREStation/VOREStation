
/obj/item/mecha_parts/component/electrical
	name = "mecha electrical harness"
	icon = 'icons/mecha/mech_component.dmi'
	icon_state = "board"
	w_class = ITEMSIZE_HUGE
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)

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

	emp_resistance = 0
	max_integrity = 30

	relative_size = 10
	charge_cost_mod = 0.6
