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
			for (var/ore in BOX.stored_ore)
				if(BOX.stored_ore[ore] > 0)
					var/obj/item/ore_chunk/ore_chunk = new /obj/item/ore_chunk(src.output.loc)
					var/ore_amount = BOX.stored_ore[ore]
					ore_chunk.stored_ore[ore] += ore_amount
					BOX.stored_ore[ore] = 0

					//Icon code here. Going from most to least common.
					if(ore == "sand")
						ore_chunk.icon_state = "ore_glass"
					else if(ore == "carbon")
						ore_chunk.icon_state = "ore_coal"
					else if(ore == "hematite")
						ore_chunk.icon_state = "ore_iron"
					else if(ore == "phoron")
						ore_chunk.icon_state = "ore_phoron"
					else if(ore == "silver")
						ore_chunk.icon_state = "ore_silver"
					else if(ore == "gold")
						ore_chunk.icon_state = "ore_gold"
					else if(ore == "uranium")
						ore_chunk.icon_state = "ore_uranium"
					else if(ore == "diamond")
						ore_chunk.icon_state = "ore_diamond"
					else if(ore == "platinum")
						ore_chunk.icon_state = "ore_platinum"
					else if(ore == "marble")
						ore_chunk.icon_state = "ore_marble"
					else if(ore == "lead")
						ore_chunk.icon_state = "ore_lead"
					else if(ore == "rutile")
						ore_chunk.icon_state = "ore_rutile"
					else if(ore == "quartz")
						ore_chunk.icon_state = "ore_quartz"
					else if(ore == "mhydrogen")
						ore_chunk.icon_state = "ore_hydrogen"
					else if(ore == "verdantium")
						ore_chunk.icon_state = "ore_verdantium"
					else if(ore == "raw copper")
						ore_chunk.icon_state = "ore_copper"
					else if(ore == "raw tin")
						ore_chunk.icon_state = "ore_tin"
					else if(ore == "void opal")
						ore_chunk.icon_state = "ore_void_opal"
					else if(ore == "raw bauxite")
						ore_chunk.icon_state = "ore_bauxite"
					else if(ore == "painite")
						ore_chunk.icon_state = "ore_painite"
					else
						ore_chunk.icon_state = "boulder[rand(1,4)]"


					if (i>=3) //Let's make it staggered so it looks like a lot is happening.
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