/datum/embedded_program
	var/name
	var/list/memory = list()
	var/obj/machinery/embedded_controller/master

	var/id_tag

/datum/embedded_program/New(var/obj/machinery/embedded_controller/M)
	master = M
	if (istype(M, /obj/machinery/embedded_controller/radio))
		var/obj/machinery/embedded_controller/radio/R = M
		id_tag = R.id_tag

/datum/embedded_program/Destroy()
	if(master)
		master.program = null
		master = null
	return ..()

// Return TRUE if was a command for us, otherwise return FALSE (so controllers with multiple programs can try each in turn until one accepts)
/datum/embedded_program/proc/receive_user_command(command)
	return FALSE

/datum/embedded_program/proc/receive_signal(datum/signal/signal, receive_method, receive_param)
	return

/datum/embedded_program/proc/post_signal(datum/signal/signal, comm_line)
	if(master)
		master.post_signal(signal, comm_line)
	else
		qdel(signal)
