
/obj/item/mecha_parts/component/actuator
	name = "mecha actuator"
	icon = 'icons/mecha/mech_component.dmi'
	icon_state = "motor"
	w_class = ITEMSIZE_HUGE
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)

	component_type = MECH_ACTUATOR

	start_damaged = FALSE

	emp_resistance = 1

	required_type = null	// List, if it exists. Exosuits meant to use the component.

	integrity_danger_mod = 0.6	// Multiplier for comparison to max_integrity before problems start.
	max_integrity = 50

	internal_damage_flag = MECHA_INT_CONTROL_LOST

	var/strafing_multiplier = 1

/obj/item/mecha_parts/component/actuator/get_step_delay()
	return step_delay

/obj/item/mecha_parts/component/actuator/hispeed
	name = "overclocked mecha actuator"

	step_delay = -1

	emp_resistance = -1

	integrity_danger_mod = 0.7
	max_integrity = 60

	strafing_multiplier = 1.2
