
/obj/item/mecha_parts/component/gas
	name = "mecha life-support"
	icon = 'icons/mecha/mech_component.dmi'
	icon_state = "lifesupport"
	w_class = ITEMSIZE_HUGE
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)

	component_type = MECH_GAS

	emp_resistance = 1

	integrity_danger_mod = 0.4
	max_integrity = 40

	step_delay = 0

	relative_size = 20

	internal_damage_flag = MECHA_INT_TANK_BREACH

/obj/item/mecha_parts/component/gas/reinforced
	name = "reinforced mecha life-support"

	emp_resistance = 2
	max_integrity = 80

	relative_size = 40
