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
			inst = new real_path
			inst.amount = min(count, max_amount)
			count -= inst.get_amount()
			. += inst


/datum/persistent/storage/smartfridge/produce
	name = "fruit storage"
	max_storage = 50
	store_per_type = FALSE
	target_type = /obj/machinery/smartfridge/produce

/datum/persistent/storage/smartfridge/produce/lossy
	name = "fruit storage lossy"
	go_missing_chance = 12.5 // 10% loss between rounds

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