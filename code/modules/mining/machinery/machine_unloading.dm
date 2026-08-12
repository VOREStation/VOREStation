/**********************Unloading unit**************************/


/obj/machinery/mineral/unloading_machine
	name = "unloading machine"
	icon_state = "unloader"
	density = TRUE
	anchored = TRUE
	circuit = /obj/item/circuitboard/mat_unloader
	sets_direction = TRUE
	var/static/list/ore_iconstates = null

/obj/machinery/mineral/unloading_machine/Initialize(mapload)
	. = ..()
	default_apply_parts()

	// Populate icons for unloaded ores, lookup is faster than the if-else monster it was before
	if(!ore_iconstates)
		ore_iconstates = list()
		for(var/obj/item/ore/ore as anything in subtypesof(/obj/item/ore))
			var/mat = ore.material
			if(!mat)
				continue
			ore_iconstates[mat] = ore.icon_state

	// Mapload uses direction hints
	if(!mapload)
		return
	find_output_direction()

/obj/machinery/mineral/unloading_machine/Destroy()
	if(speed_process) // high gear
		STOP_PROCESSING(SSfastprocess, src)
	else
		STOP_MACHINE_PROCESSING(src)
	. = ..()

/obj/machinery/mineral/unloading_machine/proc/toggle_speed(forced)
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

/obj/machinery/mineral/unloading_machine/attackby(obj/item/I, mob/user)
	if(default_deconstruction_screwdriver(user, I))
		return
	if(default_deconstruction_crowbar(user, I))
		return
	if(default_part_replacement(user, I))
		return
	. = ..()

/obj/machinery/mineral/unloading_machine/process()
	if(!output_dir)
		return

	var/turf/output = get_step(src,output_dir)
	var/turf/input = get_step(src,reverse_direction(output_dir))
	if(panel_open || !powered())
		return
	if (!output || !input)
		return

	if (locate(/obj/structure/ore_box, input))
		var/obj/structure/ore_box/BOX = locate(/obj/structure/ore_box, input)
		var/i = 0
		for (var/ore in BOX.stored_ore)
			if(BOX.stored_ore[ore] > 0)
				var/obj/item/ore_chunk/ore_chunk = new /obj/item/ore_chunk(output)
				var/ore_amount = BOX.stored_ore[ore]
				ore_chunk.stored_ore[ore] += ore_amount
				BOX.stored_ore[ore] = 0

				// Icon code here.
				if(ore in ore_iconstates)
					ore_chunk.icon_state = ore_iconstates[ore]
				else
					ore_chunk.icon_state = "boulder[rand(1,4)]"

				if (i>=3) //Let's make it staggered so it looks like a lot is happening.
					return

	if (locate(/obj/item, input))
		var/obj/item/O
		var/i
		for (i = 0; i<10; i++)
			O = locate(/obj/item, input)
			if(!O)
				return
			O.forceMove(output)
