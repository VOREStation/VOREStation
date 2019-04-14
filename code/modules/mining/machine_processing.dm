/**********************Mineral processing unit console**************************/
#define PROCESS_NONE		0
#define PROCESS_SMELT		1
#define PROCESS_COMPRESS	2
#define PROCESS_ALLOY		3

/obj/machinery/mineral/processing_unit_console
	name = "production machine console"
	icon = 'icons/obj/machines/mining_machines_vr.dmi' // VOREStation Edit
	icon_state = "console"
	density = TRUE
	anchored = TRUE

	var/obj/item/weapon/card/id/inserted_id	// Inserted ID card, for points

	var/obj/machinery/mineral/processing_unit/machine = null
	var/show_all_ores = FALSE

/obj/machinery/mineral/processing_unit_console/Initialize()
	. = ..()
	src.machine = locate(/obj/machinery/mineral/processing_unit) in range(5, src)
	if (machine)
		machine.console = src
	else
		log_debug("Ore processing machine console at [src.x], [src.y], [src.z] could not find its machine!")
		qdel(src)

/obj/machinery/mineral/processing_unit_console/Destroy()
	if(inserted_id)
		inserted_id.forceMove(loc) //Prevents deconstructing from deleting whatever ID was inside it.
	. = ..()

/obj/machinery/mineral/processing_unit_console/attack_hand(mob/user)
	if(..())
		return
	interact(user)

/obj/machinery/mineral/processing_unit_console/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/weapon/card/id))
		if(!powered())
			return
		if(!inserted_id && user.unEquip(I))
			I.forceMove(src)
			inserted_id = I
			interact(user)
		return
	..()

/obj/machinery/mineral/processing_unit_console/interact(mob/user)
	if(..())
		return

	if(!allowed(user))
		to_chat(user, "<span class='warning'>Access denied.</span>")
		return

	user.set_machine(src)

	var/dat = "<h1>Ore processor console</h1>"

	dat += "Current unclaimed points: [machine.points]<br>"
	if(istype(inserted_id))
		dat += "You have [inserted_id.mining_points] mining points collected. <A href='?src=\ref[src];choice=eject'>Eject ID.</A><br>"
		dat += "<A href='?src=\ref[src];choice=claim'>Claim points.</A><br>"
	else
		dat += "No ID inserted.  <A href='?src=\ref[src];choice=insert'>Insert ID.</A><br>"

	dat += "<hr><table>"

	for(var/ore in machine.ores_processing)

		if(!machine.ores_stored[ore] && !show_all_ores) continue
		var/ore/O = ore_data[ore]
		if(!O) continue
		dat += "<tr><td width = 40><b>[capitalize(O.display_name)]</b></td><td width = 30>[machine.ores_stored[ore]]</td><td width = 100>"
		if(machine.ores_processing[ore])
			switch(machine.ores_processing[ore])
				if(PROCESS_NONE)
					dat += "<font color='red'>not processing</font>"
				if(PROCESS_SMELT)
					dat += "<font color='orange'>smelting</font>"
				if(PROCESS_COMPRESS)
					dat += "<font color='blue'>compressing</font>"
				if(PROCESS_ALLOY)
					dat += "<font color='gray'>alloying</font>"
		else
			dat += "<font color='red'>not processing</font>"
		dat += ".</td><td width = 30><a href='?src=\ref[src];toggle_smelting=[ore]'>\[change\]</a></td></tr>"

	dat += "</table><hr>"
	dat += "Currently displaying [show_all_ores ? "all ore types" : "only available ore types"]. <A href='?src=\ref[src];toggle_ores=1'>\[[show_all_ores ? "show less" : "show more"]\]</a></br>"
	dat += "The ore processor is currently <A href='?src=\ref[src];toggle_power=1'>[(machine.active ? "<font color='green'>processing</font>" : "<font color='red'>disabled</font>")]</a>."
	user << browse(dat, "window=processor_console;size=400x500")
	onclose(user, "processor_console")
	return

/obj/machinery/mineral/processing_unit_console/Topic(href, href_list)
	if(..())
		return 1
	usr.set_machine(src)
	src.add_fingerprint(usr)

	if(href_list["toggle_smelting"])

		var/choice = input("What setting do you wish to use for processing [href_list["toggle_smelting"]]?") as null|anything in list("Smelting","Compressing","Alloying","Nothing")
		if(!choice) return

		switch(choice)
			if("Nothing") choice = PROCESS_NONE
			if("Smelting") choice = PROCESS_SMELT
			if("Compressing") choice = PROCESS_COMPRESS
			if("Alloying") choice = PROCESS_ALLOY

		machine.ores_processing[href_list["toggle_smelting"]] = choice

	if(href_list["toggle_power"])

		machine.active = !machine.active

	if(href_list["toggle_ores"])

		show_all_ores = !show_all_ores

	if(href_list["choice"])
		if(istype(inserted_id))
			if(href_list["choice"] == "eject")
				usr.put_in_hands(inserted_id)
				inserted_id = null
			if(href_list["choice"] == "claim")
				if(access_mining_station in inserted_id.access)
					inserted_id.mining_points += machine.points
					machine.points = 0
				else
					to_chat(usr, "<span class='warning'>Required access not found.</span>")
		else if(href_list["choice"] == "insert")
			var/obj/item/weapon/card/id/I = usr.get_active_hand()
			if(istype(I))
				usr.drop_item()
				I.forceMove(src)
				inserted_id = I
			else
				to_chat(usr, "<span class='warning'>No valid ID.</span>")

	src.updateUsrDialog()
	return

/**********************Mineral processing unit**************************/


/obj/machinery/mineral/processing_unit
	name = "material processor" //This isn't actually a goddamn furnace, we're in space and it's processing platinum and flammable phoron...
	icon = 'icons/obj/machines/mining_machines_vr.dmi' // VOREStation Edit
	icon_state = "furnace"
	density = TRUE
	anchored = TRUE
	light_range = 3
	var/obj/machinery/mineral/input = null
	var/obj/machinery/mineral/output = null
	var/obj/machinery/mineral/console = null
	var/sheets_per_tick = 10
	var/list/ores_processing[0]
	var/list/ores_stored[0]
	var/static/list/alloy_data
	var/active = FALSE

	var/points = 0
	var/static/list/ore_values = list(
		"sand" = 1,
		"hematite" = 1,
		"carbon" = 1,
		"phoron" = 15,
		"silver" = 16,
		"gold" = 18,
		"marble" = 20,
		"uranium" = 30,
		"diamond" = 50,
		"platinum" = 40,
		"lead" = 40,
		"mhydrogen" = 40,
		"verdantium" = 60)

/obj/machinery/mineral/processing_unit/New()
	..()
	// initialize static alloy_data list
	if(!alloy_data)
		alloy_data = list()
		for(var/alloytype in typesof(/datum/alloy)-/datum/alloy)
			alloy_data += new alloytype()

	// TODO - Initializing this here is insane. Put it in global lists init or something. ~Leshana
	if(!ore_data || !ore_data.len)
		for(var/oretype in typesof(/ore)-/ore)
			var/ore/OD = new oretype()
			ore_data[OD.name] = OD
			ores_processing[OD.name] = 0
			ores_stored[OD.name] = 0

/obj/machinery/mineral/processing_unit/Initialize()
	. = ..()
	// TODO - Eschew input/output machinery and just use dirs ~Leshana
	//Locate our output and input machinery.
	for (var/dir in cardinal)
		src.input = locate(/obj/machinery/mineral/input, get_step(src, dir))
		if(src.input) break
	for (var/dir in cardinal)
		src.output = locate(/obj/machinery/mineral/output, get_step(src, dir))
		if(src.output) break
	return

/obj/machinery/mineral/processing_unit/process()

	if (!src.output || !src.input)
		return

	if(panel_open || !powered())
		return

	var/list/tick_alloys = list()

	//Grab some more ore to process this tick.
	for(var/i = 0,i<sheets_per_tick,i++)
		var/obj/item/weapon/ore/O = locate() in input.loc
		if(!O) break
		if(!isnull(ores_stored[O.material]))
			ores_stored[O.material]++
			points += ore_values[O.material] // Give Points!
		qdel(O)

	if(!active)
		return

	//Process our stored ores and spit out sheets.
	var/sheets = 0
	for(var/metal in ores_stored)

		if(sheets >= sheets_per_tick) break

		if(ores_stored[metal] > 0 && ores_processing[metal] != 0)

			var/ore/O = ore_data[metal]

			if(!O) continue

			if(ores_processing[metal] == PROCESS_ALLOY && O.alloy) //Alloying.

				for(var/datum/alloy/A in alloy_data)

					if(A.metaltag in tick_alloys)
						continue

					tick_alloys += A.metaltag
					var/enough_metal

					if(!isnull(A.requires[metal]) && ores_stored[metal] >= A.requires[metal]) //We have enough of our first metal, we're off to a good start.

						enough_metal = 1

						for(var/needs_metal in A.requires)
							//Check if we're alloying the needed metal and have it stored.
							if(ores_processing[needs_metal] != PROCESS_ALLOY || ores_stored[needs_metal] < A.requires[needs_metal])
								enough_metal = 0
								break

					if(!enough_metal)
						continue
					else
						var/total
						for(var/needs_metal in A.requires)
							ores_stored[needs_metal] -= A.requires[needs_metal]
							total += A.requires[needs_metal]
							total = max(1,round(total*A.product_mod)) //Always get at least one sheet.
							sheets += total-1

						for(var/i=0,i<total,i++)
							new A.product(output.loc)

			else if(ores_processing[metal] == PROCESS_COMPRESS && O.compresses_to) //Compressing.

				var/can_make = CLAMP(ores_stored[metal],0,sheets_per_tick-sheets)
				if(can_make%2>0) can_make--

				var/material/M = get_material_by_name(O.compresses_to)

				if(!istype(M) || !can_make || ores_stored[metal] < 1)
					continue

				for(var/i=0,i<can_make,i+=2)
					ores_stored[metal]-=2
					sheets+=2
					new M.stack_type(output.loc)

			else if(ores_processing[metal] == PROCESS_SMELT && O.smelts_to) //Smelting.

				var/can_make = CLAMP(ores_stored[metal],0,sheets_per_tick-sheets)

				var/material/M = get_material_by_name(O.smelts_to)
				if(!istype(M) || !can_make || ores_stored[metal] < 1)
					continue

				for(var/i=0,i<can_make,i++)
					ores_stored[metal]--
					sheets++
					new M.stack_type(output.loc)
			else
				ores_stored[metal]--
				sheets++
				new /obj/item/weapon/ore/slag(output.loc)
		else
			continue

	console.updateUsrDialog()

#undef PROCESS_NONE
#undef PROCESS_SMELT
#undef PROCESS_COMPRESS
#undef PROCESS_ALLOY
