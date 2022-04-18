/**********************Unloading unit**************************/


/obj/machinery/mineral/unloading_machine
	name = "unloading machine"
	icon = 'icons/obj/machines/mining_machines_vr.dmi' // VOREStation Edit
	icon_state = "unloader"
	density = TRUE
	anchored = TRUE
	var/obj/machinery/mineral/input = null
	var/obj/machinery/mineral/output = null


/obj/machinery/mineral/unloading_machine/Initialize()
	. = ..()
	for(var/dir in cardinal)
		input = locate(/obj/machinery/mineral/input, get_step(src, dir))
		if(input)
			break
	for(var/dir in cardinal)
		output = locate(/obj/machinery/mineral/output, get_step(src, dir))
		if(output)
			break

/obj/machinery/mineral/unloading_machine/proc/toggle_speed(var/forced)
	if(forced)
		speed_process = forced
	else
		speed_process = !speed_process // switching gears
	if(speed_process) // high gear
		STOP_MACHINE_PROCESSING(src)
		START_PROCESSING(SSfastprocess, src)
	else // low gear
		STOP_PROCESSING(SSfastprocess, src)
		START_MACHINE_PROCESSING(src)

/obj/machinery/mineral/unloading_machine/process()
	if (src.output && src.input)
		if (locate(/obj/structure/ore_box, input.loc))
			var/obj/structure/ore_box/BOX = locate(/obj/structure/ore_box, input.loc)
			var/i = 0
			for (var/obj/item/ore/O in BOX.contents)
				BOX.contents -= O
				O.loc = output.loc
				i++
				if (i>=10)
					return
		if (locate(/obj/item, input.loc))
			var/obj/item/O
			var/i
			for (i = 0; i<10; i++)
				O = locate(/obj/item, input.loc)
				if (O)
					O.loc = src.output.loc
				else
					return
	return