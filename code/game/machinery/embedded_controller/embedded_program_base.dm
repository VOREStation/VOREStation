
/datum/computer/file/embedded_program
	var/list/memory = list()
	var/obj/machinery/embedded_controller/master

	var/id_tag

/datum/computer/file/embedded_program/New(var/obj/machinery/embedded_controller/M)
	master = M
	if (istype(M, /obj/machinery/embedded_controller/radio))
		var/obj/machinery/embedded_controller/radio/R = M
		id_tag = R.id_tag

/datum/computer/file/embedded_program/proc/receive_user_command(command)
	return

/datum/computer/file/embedded_program/proc/receive_signal(datum/signal/signal, receive_method, receive_param)
	return

<<<<<<< HEAD
/datum/computer/file/embedded_program/proc/process()
	return

=======
>>>>>>> 9ff8103... Merge pull request #5636 from kevinz000/pixel_projectiles
/datum/computer/file/embedded_program/proc/post_signal(datum/signal/signal, comm_line)
	if(master)
		master.post_signal(signal, comm_line)
	else
		qdel(signal)
