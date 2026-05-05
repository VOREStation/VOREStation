// Vore specific code for /obj/machinery/door/airlock/lift

/obj/machinery/door/airlock/lift/emag_act(uses_left, mob/user)
	to_chat(user, span_danger("This door is internally controlled."))
	return 0 // Prevents the cryptographic sequencer from using a charge fruitlessly
