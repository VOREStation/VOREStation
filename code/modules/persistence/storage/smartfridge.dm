/datum/persistent/storage/smartfridge/get_storage_list(var/obj/machinery/smartfridge/entry)
	if(!istype(entry))
		return ..()

	. = list()
	for(var/datum/stored_item/I in entry.item_records)
		.[I.item_path] = I.get_amount()

/datum/persistent/storage/smartfridge/CreateEntryInstance(var/turf/creating, var/list/token)
	var/obj/machinery/smartfridge/S = find_specific_instance(creating)
	var/list/L = generate_items(token["items"])
	for(var/atom/A in L)
		if(S.accept_check(A))
			S.stock(A)
		else
			qdel(A) // Should clean this up here, it couldn't be stocked





/datum/persistent/storage/smartfridge/sheet_storage
	name = "sheet storage"
	max_storage = 50
	store_per_type = TRUE
	target_type = /obj/machinery/smartfridge/sheets

	var/stacks_go_missing = FALSE // Variable rate depletion of stacks inter-round

/datum/persistent/storage/smartfridge/sheet_storage/lossy
	name = "sheet storage lossy"
	max_storage = 250
	stacks_go_missing = TRUE

/datum/persistent/storage/smartfridge/sheet_storage/variable_max
	name = "variable max storage"
	max_storage = list(
		/obj/item/stack/material/steel =     150,
		/obj/item/stack/material/glass =     150,
		/obj/item/stack/material/copper =    150,
		/obj/item/stack/material/wood =      150,
		/obj/item/stack/material/plastic =   150,
		/obj/item/stack/material/phoron =    100,
		/obj/item/stack/material/plasteel =  50,
		/obj/item/stack/material/cardboard = 50,
		"default" = 10
	)

/datum/persistent/storage/smartfridge/sheet_storage/generate_items(var/list/L)
	. = list()
	for(var/obj/item/stack/material/S as anything in L)
		var/real_path = istext(S) ? text2path(S) : S
		if(!ispath(real_path, /obj/item/stack/material))
			log_debug("Warning: Sheet_storage persistent datum tried to create [S]")
			continue

		// Skip entire stack if we hit the chance
		if(prob(go_missing_chance))
			continue

		var/count = L[S]

		var/obj/item/stack/material/inst = real_path
		var/max_amount = initial(inst.max_amount)

		// Delete some stacks if we want
		if(stacks_go_missing)
			var/fuzzy = rand(55,65)*0.01 // loss of 35-45% with rounding down
			count = round(count*fuzzy)
			if(count <= 0)
				continue

		while(count > 0)
			inst = new real_path(null, min(count, max_amount))
			count -= inst.get_amount()
			. += inst


/datum/persistent/storage/smartfridge/produce
	name = "fruit storage"
	max_storage = 50
	store_per_type = TRUE
	target_type = /obj/machinery/smartfridge/produce

/datum/persistent/storage/smartfridge/produce/lossy
	name = "fruit storage lossy"
	go_missing_chance = 10 // 10% loss chance between rounds

/datum/persistent/storage/smartfridge/produce/generate_items(var/list/L)			// Mostly same as storage/generate_items() but without converting string to path
	. = list()
	for(var/fruit_type in L)
		for(var/i in 1 to L[fruit_type])
			if(prob(go_missing_chance))
				continue
			var/atom/A = create_item(fruit_type)
			if(!QDELETED(A))
				. += A

/datum/persistent/storage/smartfridge/produce/create_item(var/seedtype)
	return new /obj/item/weapon/reagent_containers/food/snacks/grown(null, seedtype) // Smartfridge will be stock()ed with it, loc is unimportant

/datum/persistent/storage/smartfridge/produce/get_storage_list(var/obj/machinery/smartfridge/produce/entry)
	if(!istype(entry))
		return ..()

	. = list()
	for(var/datum/stored_item/I in entry.item_records)
		if(prob(go_missing_chance))
			continue
		if(LAZYLEN(I.instances))
			var/obj/item/weapon/reagent_containers/food/snacks/grown/G = I.instances[1]
			if(!istype(G))
				continue
			.[G.plantname] = I.get_amount() // Store the seed type, because that's what's used to generate the fruit
