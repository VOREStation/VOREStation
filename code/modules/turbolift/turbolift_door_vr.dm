// Vore specific code for /obj/machinery/door/airlock/lift

/obj/machinery/door/airlock/lift/emag_act(var/uses_left, var/mob/user)
    to_chat(user, "<span class='danger'>This door is internally controlled.</span>")
    return 0 // Prevents the cryptographic sequencer from using a charge fruitlessly
