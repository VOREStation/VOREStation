/// Defaults to maximum charge, no change to input or output levels by default
/obj/machinery/power/smes/buildable/max_charge/apply_mapped_settings()
	// Set charge
	charge = capacity

/// Defaults to 100% input and output settings, starts with maximum charge by default
/obj/machinery/power/smes/buildable/engine_default/apply_mapped_settings()
	// Set charge
	charge = capacity
	// Set input and output to max
	inputting(TRUE)
	outputting(TRUE)
	input_level = input_level_max
	output_level = output_level_max

/// Standard charge, but with 100% output by default
/obj/machinery/power/smes/buildable/max_output/apply_mapped_settings()
	outputting(TRUE)
	output_level = output_level_max

/// Standard charge, but with 100% input by default
/obj/machinery/power/smes/buildable/max_input/apply_mapped_settings()
	inputting(TRUE)
	input_level = input_level_max

/// Standard charge, no output by default
/obj/machinery/power/smes/buildable/disable_output/apply_mapped_settings()
	outputting(FALSE)
	output_level = 0

/// Max charge, but with 100% input by default
/obj/machinery/power/smes/buildable/max_charge_max_input/apply_mapped_settings()
	// Set charge
	charge = capacity
	// Set input to max
	inputting(TRUE)
	input_level = input_level_max

/// Max charge, but with 100% output by default
/obj/machinery/power/smes/buildable/max_charge_max_output/apply_mapped_settings()
	// Set charge
	charge = capacity
	// Set input to max
	outputting(TRUE)
	output_level = output_level_max

// Poi prop
/obj/machinery/power/smes/buildable/alien_royal
	name = "Alien Royal Capacitor"
	icon_state = "unit"
	icon = 'icons/obj/alien_smes.dmi'
	input_level = 950000
	output_level = 950000


////////////////////////////////////////////////////////////////////////////////////
// Hybrids
////////////////////////////////////////////////////////////////////////////////////
/obj/machinery/power/smes/buildable/hybrid/max_charge/apply_mapped_settings()
	// Set charge
	charge = capacity

/obj/machinery/power/smes/buildable/hybrid/engine_default/apply_mapped_settings()
	// Set charge
	charge = capacity
	// Set input and output to max
	inputting(TRUE)
	outputting(TRUE)
	input_level = input_level_max
	output_level = output_level_max

/obj/machinery/power/smes/buildable/hybrid/max_output/apply_mapped_settings()
	outputting(TRUE)
	output_level = output_level_max

/obj/machinery/power/smes/buildable/hybrid/max_input/apply_mapped_settings()
	inputting(TRUE)
	input_level = input_level_max

/obj/machinery/power/smes/buildable/hybrid/high_recharge_rate/apply_mapped_settings()
	recharge_rate = 10000


////////////////////////////////////////////////////////////////////////////////////
// Preconfigured specials
////////////////////////////////////////////////////////////////////////////////////
/obj/machinery/power/smes/buildable/outpost_substation/max_charge/apply_mapped_settings()
	// Set charge
	charge = capacity

/obj/machinery/power/smes/buildable/outpost_substation/max_charge_max_input/apply_mapped_settings()
	// Set charge
	charge = capacity
	// Set input to max
	inputting(TRUE)
	input_level = input_level_max

/obj/machinery/power/smes/batteryrack/mapped/input_and_output_on/apply_mapped_settings()
	inputting(TRUE)
	outputting(TRUE)
	mode = 3
