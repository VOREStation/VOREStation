/**********************Unloading unit**************************/


/obj/machinery/mineral/unloading_machine
	name = "unloading machine"
	icon_state = "unloader"
	density = TRUE
	anchored = TRUE
	circuit = /obj/item/circuitboard/mat_unloader
	sets_direction = TRUE

/obj/machinery/mineral/unloading_machine/Initialize(mapload)
	. = ..()
	default_apply_parts()

	// Mapload uses direction hints
	if(!mapload)
		return
	for(var/dir in GLOB.cardinal)
		var/output = locate(/obj/machinery/mineral/output, get_step(src, dir))
		if(output)
			set_output_dir(dir)
			break

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

				//Icon code here. Going from most to least common.
				if(ore == ORE_SAND)
					ore_chunk.icon_state = "ore_glass"
				else if(ore == ORE_CARBON)
					ore_chunk.icon_state = "ore_coal"
				else if(ore == ORE_HEMATITE)
					ore_chunk.icon_state = "ore_iron"
				else if(ore == ORE_PHORON)
					ore_chunk.icon_state = "ore_phoron"
				else if(ore == ORE_SILVER)
					ore_chunk.icon_state = "ore_silver"
				else if(ore == ORE_GOLD)
					ore_chunk.icon_state = "ore_gold"
				else if(ore == ORE_URANIUM)
					ore_chunk.icon_state = "ore_uranium"
				else if(ore == ORE_DIAMOND)
					ore_chunk.icon_state = "ore_diamond"
				else if(ore == ORE_PLATINUM)
					ore_chunk.icon_state = "ore_platinum"
				else if(ore == ORE_MARBLE)
					ore_chunk.icon_state = "ore_marble"
				else if(ore == ORE_LEAD)
					ore_chunk.icon_state = "ore_lead"
				else if(ore == ORE_RUTILE)
					ore_chunk.icon_state = "ore_rutile"
				else if(ore == ORE_QUARTZ)
					ore_chunk.icon_state = "ore_quartz"
				else if(ore == ORE_MHYDROGEN)
					ore_chunk.icon_state = "ore_hydrogen"
				else if(ore == ORE_VERDANTIUM)
					ore_chunk.icon_state = "ore_verdantium"
				else if(ore == ORE_COPPER)
					ore_chunk.icon_state = "ore_copper"
				else if(ore == ORE_TIN)
					ore_chunk.icon_state = "ore_tin"
				else if(ore == ORE_VOPAL)
					ore_chunk.icon_state = "ore_void_opal"
				else if(ore == ORE_BAUXITE)
					ore_chunk.icon_state = "ore_bauxite"
				else if(ore == ORE_PAINITE)
					ore_chunk.icon_state = "ore_painite"
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
