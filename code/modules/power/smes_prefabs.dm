// Defaults to maximum charge, no change to input or output levels
/obj/machinery/power/smes/buildable/max_charge/apply_mapped_settings()
	// Set charge
	charge = capacity

// Defaults to 100% input and output settings, starts with maximum charge
/obj/machinery/power/smes/buildable/engine_default/apply_mapped_settings()
	// Set charge
	charge = capacity
	// Set output to max
	inputting(TRUE)
	outputting(TRUE)
	input_level = input_level_max
	output_level = output_level_max

// Poi prop
/obj/machinery/power/smes/buildable/alien_royal
	name = "Alien Royal Capacitor"
	icon_state = "unit"
	icon = 'icons/obj/alien_smes.dmi'
	input_level = 950000
	output_level = 950000
