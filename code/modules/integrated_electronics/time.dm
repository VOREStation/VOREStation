/obj/item/integrated_circuit/time
	name = "time circuit"
	desc = "Now you can build your own clock!"
	complexity = 2
	number_of_inputs = 0
	number_of_outputs = 0

/obj/item/integrated_circuit/time/clock
	name = "integrated clock"
	desc = "Tells you what the local time is, specific to your station or planet."
	number_of_inputs = 0
	number_of_outputs = 6
	number_of_activators = 1
	name_of_outputs = list(
		"time (string)",
		"minute (string)",
		"hour (string)",
		"minute (number)",
		"hour (number)",
		)