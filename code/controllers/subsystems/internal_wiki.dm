/*
	This is a self assembled wiki for chemical reagents, food recipies,
	and other information that should be assembled from game files.
*/

SUBSYSTEM_DEF(internal_wiki)
	name = "Wiki"
	wait = 1
	init_order = INIT_ORDER_WIKI
	flags = SS_NO_FIRE

	VAR_PRIVATE/list/pages = list()

	VAR_PRIVATE/list/ores = list()
	VAR_PRIVATE/list/materials = list()
	VAR_PRIVATE/list/smashers = list()

	VAR_PRIVATE/list/appliance_list = list("Simple","Microwave","Fryer","Oven","Grill","Candy Maker","Cereal Maker")
	VAR_PRIVATE/list/foodreact = list()
	VAR_PRIVATE/list/drinkreact = list()
	VAR_PRIVATE/list/chemreact = list()
	VAR_PRIVATE/list/botseeds = list()

	VAR_PRIVATE/list/foodrecipe = list()
	VAR_PRIVATE/list/drinkrecipe = list()

	VAR_PRIVATE/list/catalogs = list()

	VAR_PRIVATE/list/searchcache_ore = list()
	VAR_PRIVATE/list/searchcache_material = list()
	VAR_PRIVATE/list/searchcache_smasher = list()
	VAR_PRIVATE/list/searchcache_foodrecipe = list()
	VAR_PRIVATE/list/searchcache_drinkrecipe = list()
	VAR_PRIVATE/list/searchcache_chemreact = list()
	VAR_PRIVATE/list/searchcache_catalogs = list()
	VAR_PRIVATE/list/searchcache_botseeds = list()

/datum/controller/subsystem/internal_wiki/stat_entry(msg)
	msg = "P: [pages.len] | O: [ores.len] | M: [materials.len] | S: [smashers.len] | F: [foodrecipe.len]  | D: [drinkrecipe.len]  | C: [chemreact.len]  | B: [botseeds.len] "
	return ..()

/datum/controller/subsystem/internal_wiki/Initialize()
	init_mining_data()
	init_kitchen_data()
	init_lore_data()
	return SS_INIT_SUCCESS


/datum/controller/subsystem/internal_wiki/proc/get_page_food(var/search)
	return foodrecipe[search]
/datum/controller/subsystem/internal_wiki/proc/get_page_drink(var/search)
	return drinkrecipe[search]
/datum/controller/subsystem/internal_wiki/proc/get_page_chem(var/search)
	return chemreact[search]
/datum/controller/subsystem/internal_wiki/proc/get_page_seed(var/search)
	return botseeds[search]
/datum/controller/subsystem/internal_wiki/proc/get_page_catalog(var/search)
	return catalogs[search]
/datum/controller/subsystem/internal_wiki/proc/get_page_material(var/search)
	return materials[search]
/datum/controller/subsystem/internal_wiki/proc/get_page_particle(var/search)
	return smashers[search]
/datum/controller/subsystem/internal_wiki/proc/get_page_ore(var/search)
	return ores[search]

/datum/controller/subsystem/internal_wiki/proc/get_appliances()
	return appliance_list
/datum/controller/subsystem/internal_wiki/proc/get_searchcache_food(var/appliance)
	return searchcache_foodrecipe[appliance]
/datum/controller/subsystem/internal_wiki/proc/get_searchcache_drink()
	return searchcache_drinkrecipe
/datum/controller/subsystem/internal_wiki/proc/get_searchcache_chem()
	return searchcache_chemreact
/datum/controller/subsystem/internal_wiki/proc/get_searchcache_seed()
	return searchcache_botseeds
/datum/controller/subsystem/internal_wiki/proc/get_searchcache_catalog()
	return searchcache_catalogs
/datum/controller/subsystem/internal_wiki/proc/get_searchcache_material()
	return searchcache_material
/datum/controller/subsystem/internal_wiki/proc/get_searchcache_particle()
	return searchcache_smasher
/datum/controller/subsystem/internal_wiki/proc/get_searchcache_ore()
	return searchcache_ore

/datum/controller/subsystem/internal_wiki/proc/init_mining_data()
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)

	// assemble ore wiki
	for(var/N in GLOB.ore_data)
		var/ore/OR = GLOB.ore_data[N]
		var/datum/internal_wiki/page/P = new()
		P.ore_assemble(OR)
		ores["[OR.display_name]"] = P
		searchcache_ore.Add("[OR.display_name]")
		pages.Add(P)

	// assemble material wiki
	for(var/mat in name_to_material)
		var/datum/material/M = name_to_material[mat]
		var/datum/internal_wiki/page/P = new()
		var/id = "[M.display_name]"
		P.material_assemble(M)
		materials[id] = P
		searchcache_material.Add(id)
		pages.Add(P)

	// assemble particle smasher wiki
	var/list/smasher_recip = list()
	for(var/D in subtypesof(/datum/particle_smasher_recipe))
		smasher_recip += new D
	for(var/datum/particle_smasher_recipe/R in smasher_recip)
		var/datum/internal_wiki/page/P = new()
		var/res_path = new R.result;
		var/res_name = initial(res_path:name)
		if(res_name)
			var/id = "[res_name]"
			P.smasher_assemble(R,res_name)
			smashers[id] = P
			searchcache_smasher.Add(id)
			pages.Add(P)

	// assemble chemical reactions wiki
	for(var/reagent in SSchemistry.chemical_reagents)
		if(allow_reagent(reagent))
			var/datum/internal_wiki/page/P = new()
			var/datum/reagent/R = SSchemistry.chemical_reagents[reagent]
			var/id = "[R.name]"
			if(R.is_food)
				P.food_assemble(R)
				foodreact[id] = P
			else if(R.is_drink)
				P.drink_assemble(R)
				drinkreact[id] = P
			else
				P.chemical_assemble(R)
				searchcache_chemreact.Add(id)
				chemreact[id] = P
			pages.Add(P)

/datum/controller/subsystem/internal_wiki/proc/init_kitchen_data()
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)

	// seeds and plants
	for(var/SN in SSplants.seeds)
		var/datum/seed/S = SSplants.seeds[SN]
		if(S && S.roundstart && !S.mysterious)
			var/datum/internal_wiki/page/P = new()
			P.seed_assemble(S)
			searchcache_botseeds.Add("[S.display_name]")
			botseeds["[S.display_name]"] = P
			pages.Add(P)

	// this is basically a clone of code\modules\food\recipe_dump.dm
	// drinks
	var/list/drink_recipes = list()
	for(var/decl/chemical_reaction/instant/drinks/CR in SSchemistry.chemical_reactions)
		if(isnull(CR.result))
			continue // Probably explodes instead
		var/datum/reagent/Rd = SSchemistry.chemical_reagents[CR.result]
		if(!isnull(Rd))
			drink_recipes[CR.type] = list("Result" = "[CR.name]",
									"Desc" = "[Rd.description]",
									"Flavor" = "[Rd.taste_description]",
									"ResAmt" = CR.result_amount,
									"Reagents" = CR.required_reagents ? CR.required_reagents.Copy() : list(),
									"Catalysts" = CR.catalysts ? CR.catalysts.Copy() : list())
		else
			log_runtime(EXCEPTION("Invalid reagent result id: [CR.result] in instant drink reaction id: [CR.id]"))
	// Build the kitchen recipe lists
	var/list/food_recipes = subtypesof(/datum/recipe)
	for(var/Rp in food_recipes)
		//Lists don't work with datum-stealing no-instance initial() so we have to.
		var/datum/recipe/R = new Rp()
		if(!isnull(R.result))
			var/res = R.result
			food_recipes[Rp] = list(
						"Result" = "[initial(res:name)]",
						"Desc" = "[initial(res:desc)]",
						"Flavor" = "",
						"ResAmt" = "1",
						"Reagents" = R.reagents ? R.reagents.Copy() : list(),
						"Catalysts" = list(),
						"Fruit" = R.fruit ? R.fruit.Copy() : list(),
						"Ingredients" = R.items ? R.items.Copy() : list(),
						"Coating" = R.coating,
						"Appliance" = R.appliance,
						"Allergens" = 0,
						"Price" = initial(res:price_tag)
						)
		qdel(R)
	// basically condiments, tofu, cheese, soysauce, etc
	for(var/decl/chemical_reaction/instant/food/CR in SSchemistry.chemical_reactions)
		food_recipes[CR.type] = list("Result" = CR.name,
								"ResAmt" = CR.result_amount,
								"Reagents" = CR.required_reagents ? CR.required_reagents.Copy() : list(),
								"Catalysts" = CR.catalysts ? CR.catalysts.Copy() : list(),
								"Fruit" = list(),
								"Ingredients" = list(),
								"Allergens" = 0)
	//Items needs further processing into human-readability.
	for(var/Rp in food_recipes)
		var/working_ing_list = list()
		food_recipes[Rp]["has_coatable_items"] = FALSE
		for(var/I in food_recipes[Rp]["Ingredients"])
			if(I == /obj/item/holder/mouse) // Time for the list of snowflakes
				if("mouse" in working_ing_list)
					var/sofar = working_ing_list["mouse"]
					working_ing_list["mouse"] = sofar+1
				else
					working_ing_list["mouse"] = 1
			else if(I == /obj/item/holder/diona) // YOU TOO
				if("diona" in working_ing_list)
					var/sofar = working_ing_list["diona"]
					working_ing_list["diona"] = sofar+1
				else
					working_ing_list["diona"] = 1
			else if(I == /obj/item/holder) // And you especially, needed for "splat" microwave recipe
				if("micro" in working_ing_list)
					var/sofar = working_ing_list["micro"]
					working_ing_list["micro"] = sofar+1
				else
					working_ing_list["micro"] = 1
			else
				if(I in typesof(/obj/item/reagent_containers/food/snacks)) // only subtypes of this have a coating variable and are checked for it (fruit are a subtype of this, so there's a check for them too later)
					food_recipes[Rp]["has_coatable_items"] = TRUE

				//So now we add something like "Bread" = 3
				var/id = initial(I:name)
				if(id in working_ing_list)
					var/sofar = working_ing_list[id]
					working_ing_list[id] = sofar+1
				else
					working_ing_list[id] = 1

		if(LAZYLEN(food_recipes[Rp]["Fruit"]))
			food_recipes[Rp]["has_coatable_items"] = TRUE
		food_recipes[Rp]["Ingredients"] = working_ing_list

	//Reagents can be resolved to nicer names as well
	for(var/Rp in food_recipes)
		for(var/rid in food_recipes[Rp]["Reagents"])
			var/datum/reagent/Rd = SSchemistry.chemical_reagents[rid]
			if(!Rd) // Leaving this here in the event that if rd is ever invalid or there's a recipe issue, it'll be skipped and recipe dumps can still be ran.
				log_runtime(EXCEPTION("Food \"[Rp]\" had an invalid RID: \"[rid]\"! Check your reagents list for a missing or mistyped reagent!"))
				continue // This allows the dump to still continue, and it will skip the invalid recipes.
			var/R_name = Rd.name
			var/amt = food_recipes[Rp]["Reagents"][rid]
			food_recipes[Rp]["Reagents"] -= rid
			food_recipes[Rp]["Reagents"][R_name] = amt
			food_recipes[Rp]["Allergens"] |= Rd.allergen_type
		for(var/rid in food_recipes[Rp]["Catalysts"])
			var/datum/reagent/Rd = SSchemistry.chemical_reagents[rid]
			if(!Rd) // Leaving this here in the event that if rd is ever invalid or there's a recipe issue, it'll be skipped and recipe dumps can still be ran.
				log_runtime(EXCEPTION("Food \"[Rp]\" had an invalid RID: \"[rid]\"! Check your reagents list for a missing or mistyped reagent!"))
				continue // This allows the dump to still continue, and it will skip the invalid recipes.
			var/R_name = Rd.name
			var/amt = food_recipes[Rp]["Catalysts"][rid]
			food_recipes[Rp]["Catalysts"] -= rid
			food_recipes[Rp]["Catalysts"][R_name] = amt
	for(var/Rp in drink_recipes)
		for(var/rid in drink_recipes[Rp]["Reagents"])
			var/datum/reagent/Rd = SSchemistry.chemical_reagents[rid]
			if(!Rd) // Leaving this here in the event that if rd is ever invalid or there's a recipe issue, it'll be skipped and recipe dumps can still be ran.
				log_runtime(EXCEPTION("Food \"[Rp]\" had an invalid RID: \"[rid]\"! Check your reagents list for a missing or mistyped reagent!"))
				continue // This allows the dump to still continue, and it will skip the invalid recipes.
			var/R_name = Rd.name
			var/amt = drink_recipes[Rp]["Reagents"][rid]
			drink_recipes[Rp]["Reagents"] -= rid
			drink_recipes[Rp]["Reagents"][R_name] = amt
			drink_recipes[Rp]["Allergens"] |= Rd.allergen_type
		for(var/rid in drink_recipes[Rp]["Catalysts"])
			var/datum/reagent/Rd = SSchemistry.chemical_reagents[rid]
			if(!Rd) // Leaving this here in the event that if rd is ever invalid or there's a recipe issue, it'll be skipped and recipe dumps can still be ran.
				log_runtime(EXCEPTION("Food \"[Rp]\" had an invalid RID: \"[rid]\"! Check your reagents list for a missing or mistyped reagent!"))
				continue // This allows the dump to still continue, and it will skip the invalid recipes.
			var/R_name = Rd.name
			var/amt = drink_recipes[Rp]["Catalysts"][rid]
			drink_recipes[Rp]["Catalysts"] -= rid
			drink_recipes[Rp]["Catalysts"][R_name] = amt

	//We can also change the appliance to its proper name.
	for(var/Rp in food_recipes)
		switch(food_recipes[Rp]["Appliance"])
			if(1)
				food_recipes[Rp]["Appliance"] = "Microwave"
			if(2)
				food_recipes[Rp]["Appliance"] = "Fryer"
			if(4)
				food_recipes[Rp]["Appliance"] = "Oven"
			if(8)
				food_recipes[Rp]["Appliance"] = "Grill"
			if(16)
				food_recipes[Rp]["Appliance"] = "Candy Maker"
			if(32)
				food_recipes[Rp]["Appliance"] = "Cereal Maker"

	//////////////////////// SORTING
	var/list/foods_to_paths = list()
	var/list/drinks_to_paths = list()
	for(var/Rp in food_recipes) // "Appliance" will sort the list by APPLIANCES first. Items without an appliance will append to the top of the list. The old method was "Result", which sorts the list by the name of the result.
		foods_to_paths["[food_recipes[Rp]["Appliance"]] [Rp]"] = Rp //Append recipe datum path to keep uniqueness
	for(var/Rp in drink_recipes)
		drinks_to_paths["[drink_recipes[Rp]["Result"]] [Rp]"] = Rp
	foods_to_paths = sortAssoc(foods_to_paths)
	drinks_to_paths = sortAssoc(drinks_to_paths)

	var/list/foods_newly_sorted = list()
	var/list/drinks_newly_sorted = list()
	for(var/Rr in foods_to_paths)
		var/Rp = foods_to_paths[Rr]
		foods_newly_sorted[Rp] = food_recipes[Rp]
	for(var/Rr in drinks_to_paths)
		var/Rp = drinks_to_paths[Rr]
		drinks_newly_sorted[Rp] = drink_recipes[Rp]
	food_recipes = foods_newly_sorted
	drink_recipes = drinks_newly_sorted

	// assemble output page
	for(var/Rp in food_recipes)
		if(food_recipes[Rp] && !isnull(food_recipes[Rp]["Result"]))
			var/datum/internal_wiki/page/P = new()
			P.recipe_assemble(food_recipes[Rp])
			foodrecipe["[P.title]"] = P
			// organize into sublists
			var/app = food_recipes[Rp]["Appliance"]
			if(!app || app == "")
				app = "Simple"
			if(!searchcache_foodrecipe[app])
				searchcache_foodrecipe[app] = list()
			var/list/FL = searchcache_foodrecipe[app]
			FL.Add("[P.title]")
			pages.Add(P)
	for(var/Rp in drink_recipes)
		if(drink_recipes[Rp] && !isnull(drink_recipes[Rp]["Result"]))
			var/datum/internal_wiki/page/P = new()
			P.recipe_assemble(drink_recipes[Rp])
			drinkrecipe["[P.title]"] = P
			searchcache_drinkrecipe.Add("[P.title]")
			pages.Add(P)

/datum/controller/subsystem/internal_wiki/proc/init_lore_data()
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)

	// assemble low reward catalog entries
	for(var/datum/category_group/G in GLOB.catalogue_data.categories)
		for(var/datum/category_item/catalogue/item in G.items)
			if(istype(item,/datum/category_item/catalogue/anomalous))
				continue // lets always consider these spoilers
			if(istype(item,/datum/category_item/catalogue/fauna/catslug/custom))
				continue // too many silly entries
			if(item.value > CATALOGUER_REWARD_TRIVIAL)
				continue
			var/datum/internal_wiki/page/catalog/P = new()
			P.title = item.name
			P.catalog_record = item
			catalogs["[item.name]"] = P
			searchcache_catalogs.Add("[item.name]")
			pages.Add(P)

/datum/controller/subsystem/internal_wiki/proc/allow_reagent(var/reagent_id)
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)

	// This is used to filter out some of the base reagent types, such as admin only reagents
	if(!reagent_id || reagent_id == "" || reagent_id == DEVELOPER_WARNING_NAME || reagent_id == REAGENT_ID_ADMINORDRAZINE)
		return FALSE
	return TRUE


////////////////////////////////////////////////////////////////////////////////////////////////
// PAGES AND THEIR CONSTRUCTION
////////////////////////////////////////////////////////////////////////////////////////////////
/datum/internal_wiki/page
	var/title = ""
	var/body = ""

/datum/internal_wiki/page/proc/get_data()
	return body

/datum/internal_wiki/page/proc/ore_assemble(var/ore/O)
	title = O.display_name
	if(O.smelts_to)
		var/datum/material/S = get_material_by_name(O.smelts_to)
		body += "<b>Smelting: [S.display_name]</b><br>"
	if(O.compresses_to)
		var/datum/material/C = get_material_by_name(O.compresses_to)
		body += "<b>Compressing: [C.display_name]</b><br>"
	if(O.alloy)
		body += "<br>"
		body += "<b>Alloy Component of: </b><br>"
		// Assemble what alloys this ore can make
		for(var/datum/alloy/A in GLOB.alloy_data)
			for(var/req in A.requires)
				if(O.name == req )
					var/datum/material/M = get_material_by_name(A.metaltag)
					body += "<b>-[M.display_name]</b><br>"
					break
	else
		body += "<br>"
		body += "<b>No known Alloys</b><br>"

	if(O.reagent)
		body += "<br>"
		var/datum/reagent/REG = SSchemistry.chemical_reagents[O.reagent]
		if(REG)
			body += "<b>Fluid Pump Results:</b><br>"
			body += "<b>-[REG.name]</b><br>"
		else
			log_runtime(EXCEPTION("Invalid reagent id: [O.reagent] in pump results for ore [title]"))

	if(global.ore_reagents[O.ore])
		body += "<br>"
		body += "<b>Ore Grind Results: </b><br>"
		var/list/output = global.ore_reagents[O.ore]
		var/list/collect = list()
		var/total_parts = 0
		for(var/Rid in output)
			var/datum/reagent/CBR = SSchemistry.chemical_reagents[Rid]
			if(CBR)
				if(!collect[CBR.name])
					collect[CBR.name] = 0
				collect[CBR.name] += 1
				total_parts += 1
			else
				log_runtime(EXCEPTION("Invalid reagent id: [Rid] in grind results for ore [title]"))
		var/per_part = REAGENTS_PER_SHEET / total_parts
		for(var/N in collect)
			body += "<b>-[N]: [collect[N] * per_part]u</b><br>"

/datum/internal_wiki/page/proc/material_assemble(var/datum/material/M)
	title = M.display_name
	body  = "<b>Integrity: [M.integrity]</b><br>"
	body += "<b>Hardness: [M.hardness]</b><br>"
	body += "<b>Weight: [M.weight]</b><br>"
	var/stack_size = 50
	body += "<b>Supply Points: [M.supply_conversion_value] per sheet, [M.supply_conversion_value * stack_size] per stack of [stack_size]</b><br>"
	var/value = M.supply_conversion_value * SSsupply.points_per_money
	value = FLOOR(value * 100,1) / 100 // Truncate decimals
	if(value > 0)
		body += "<b>Market Price: [value] [value > 1 ? "thalers" : "thaler"] per sheet  |  [(value*stack_size)] [(value*stack_size) > 1 ? "thalers" : "thaler"] per stack of [stack_size]</b><br>"
	body += "<br>"
	body += "<b>Transparent: [M.opacity >= 0.5 ? "No" : "Yes"]</b><br>"
	body += "<b>Conductive: [M.conductive ? "Yes" : "No"]</b><br>"
	body += "<b>Stability: [M.protectiveness]</b><br>"
	body += "<b>Blast Res.: [M.explosion_resistance]</b><br>"
	body += "<b>Radioactivity: [M.radioactivity]</b><br>"
	body += "<b>Reflectivity: [M.reflectivity * 100]%</b><br>"
	body += "<br>"
	if(M.melting_point != null)
		body += "<b>Melting Point: [M.melting_point]K ([M.melting_point - T0C]C)</b><br>"
	else
		body += "<b>Melting Point: --- </b><br>"
	if(M.ignition_point != null)
		body += "<b>Ignition Point: [M.ignition_point]K ([M.ignition_point - T0C]C)</b><br>"
	else
		body += "<b>Ignition Point: --- </b><br>"
	if(global.sheet_reagents[M.stack_type])
		body += "<br>"
		var/list/output = global.sheet_reagents[M.stack_type]
		if(output && output.len > 0)
			body += "<b>Sheet Grind Results: </b><br>"
			var/list/collect = list()
			var/total_parts = 0
			for(var/Rid in output)
				var/datum/reagent/CBR = SSchemistry.chemical_reagents[Rid]
				if(CBR)
					if(!collect[CBR.name])
						collect[CBR.name] = 0
					collect[CBR.name] += 1
					total_parts += 1
				else
					log_runtime(EXCEPTION("Invalid reagent id: [Rid] in grind results for sheet [title]"))
			if(total_parts > 0)
				var/per_part = REAGENTS_PER_SHEET / total_parts
				for(var/N in collect)
					body += "<b>-[N]: [collect[N] * per_part]u</b><br>"
	M.get_recipes() // generate if not already
	if(M.recipes != null && M.recipes.len > 0)
		body += "<br>"
		body += "<b>Recipies: </b><br>"
		for(var/datum/stack_recipe/R in M.recipes)
			body += "<b>-[R.title]</b><br>"

/datum/internal_wiki/page/proc/seed_assemble(var/datum/seed/S)
	title = S.display_name
	body  =  "<b>Requires Feeding: [S.get_trait(TRAIT_REQUIRES_NUTRIENTS) ? "YES" : "NO"]</b><br>"
	body  += "<b>Requires Watering: [S.get_trait(TRAIT_REQUIRES_WATER) ? "YES" : "NO"]</b><br>"
	body  += "<b>Requires Light: [S.get_trait(TRAIT_IDEAL_LIGHT)] lumen[S.get_trait(TRAIT_IDEAL_LIGHT) == 1 ? "" : "s"]</b><br>"
	if(S.get_trait(TRAIT_YIELD) > 0)
		body  += "<b>Yield: [S.get_trait(TRAIT_YIELD)]</b><br>"
	body  += "<br>"

	var/traits = FALSE
	body  += "<b>Traits:</b><br>"
	if(S.has_item_product)
		body  += "<b>-Grown Byproducts</b><br>"
		traits = TRUE
	if(S.chems && !isnull(S.chems["woodpulp"]))
		body  += "<b>-Wooden Growths</b><br>"
		traits = TRUE
	if(S.get_trait(TRAIT_FLESH_COLOUR))
		body  += "<b>-Choppable</b><br>"
		traits = TRUE
	if(S.kitchen_tag == "pumpkin")
		body  += "<b>-Carvable</b><br>"
		traits = TRUE
	if(S.kitchen_tag == "potato")
		body  += "<b>-Sliceable</b><br>"
		traits = TRUE
	if(S.get_trait(TRAIT_JUICY))
		body  += "<b>-Juicy</b><br>"
		traits = TRUE
	if(S.get_trait(TRAIT_IMMUTABLE))
		body  += "<b>-Stable Genome</b><br>"
		traits = TRUE
	if(S.get_trait(TRAIT_PRODUCES_POWER))
		body  += "<b>-Voltaic</b><br>"
		traits = TRUE
	if(S.get_trait(TRAIT_BIOLUM))
		body  += "<b>-Bioluminescence</b><br>"
		traits = TRUE
	if(S.get_trait(TRAIT_STINGS))
		body  += "<b>-Stings</b><br>"
		traits = TRUE
	if(S.get_trait(TRAIT_SPORING))
		body  += "<b>-Produces Spores</b><br>"
		traits = TRUE
	if(S.get_trait(TRAIT_CARNIVOROUS))
		body  += "<b>-Carnivorous</b><br>"
		traits = TRUE
	if(S.get_trait(TRAIT_PARASITE))
		body  += "<b>-Parasitic</b><br>"
		traits = TRUE
	if(S.get_trait(TRAIT_SPREAD))
		body  += "<b>-Spreading</b><br>"
		traits = TRUE
	if(S.get_trait(TRAIT_EXPLOSIVE))
		body  += "<b>-Explosive</b><br>"
		traits = TRUE
	if(!traits)
		body  += "<b>-None</b><br>"
	body  += "<br>"

	if(S.has_mob_product)
		body += "<b>DANGER - MAY BE MOBILE</b><br>"
	body  += "<br>"

	if(S.chems && S.chems.len > 0)
		body  += "<b>Chemical Breakdown: </b><br>"
		for(var/CB in S.chems)
			var/datum/reagent/CBR = SSchemistry.chemical_reagents[CB]
			if(CBR)
				body  += "<b>-[CBR.name]</b><br>"
			else
				log_runtime(EXCEPTION("Invalid reagent id: [CB] in chemical breakdown for seed [title]"))
		body  += "<br>"
	if(S.consume_gasses && S.consume_gasses.len > 0)
		body  += "<b>Gasses Consumed: </b><br>"
		for(var/CG in S.consume_gasses)
			var/amount = "[gas_data.name[CG]]"
			if (S.consume_gasses[CG] < 5)
				amount = "[gas_data.name[CG]] (trace amounts)"
			body  += "<b>-[amount]</b><br>"
		body  += "<br>"
	if(S.exude_gasses && S.exude_gasses.len > 0)
		body  += "<b>Gasses Produced: </b><br>"
		for(var/EG in S.exude_gasses)
			var/amount = "[gas_data.name[EG]]"
			if (S.exude_gasses[EG] < 5)
				amount = "[gas_data.name[EG]] (trace amounts)"
			body  += "<b>-[amount]</b><br>"
		body  += "<br>"
	if(S.mutants && S.mutants.len > 0)
		body  += "<b>Mutant Strains: </b><br>"
		for(var/MS in S.mutants)
			var/datum/seed/mut = SSplants.seeds[MS]
			if(mut)
				body  += "<b>-[mut.display_name]</b><br>"

/datum/internal_wiki/page/proc/smasher_assemble(var/datum/particle_smasher_recipe/M, var/resultname)
	var/req_mat = M.required_material
	title = resultname
	if(req_mat != null)
		body += "<b>Target Sheet: [initial(req_mat:name)]</b><br>"
	if(M.items != null && M.items.len > 0)
		if( M.items.len == 1)
			var/Ir = M.items[1]
			body += "<b>Target Item: [initial(Ir:name)]</b><br>"
		else
			body += "<b>Target Item: </b><br>"
			for(var/Ir in M.items)
				body += "<b>-[initial(Ir:name)]</b><br>"
	body += "<b>Threshold Energy: [M.required_energy_min] - [M.required_energy_max]</b><br>"
	body += "<b>Threshold Temp: [M.required_atmos_temp_min]k - [M.required_atmos_temp_max]k | ([M.required_atmos_temp_min - T0C]C - [M.required_atmos_temp_max - T0C]C)</b><br>"
	if(M.reagents != null && M.reagents.len > 0)
		body += "<br>"
		body += "<b>Inducers: </b><br>"
		for(var/R in M.reagents)
			var/amnt = M.reagents[R]
			var/datum/reagent/Rd = SSchemistry.chemical_reagents[R]
			if(Rd)
				body += "<b>-[Rd.name] [amnt]u</b><br>"
			else
				log_runtime(EXCEPTION("Invalid reagent id: [Rd] in inducer for atom smasher [title]"))
	body += "<br>"
	body += "<b>Results: [resultname]</b><br>"
	body += "<b>Probability: [M.probability]%</b><br>"

/datum/internal_wiki/page/proc/chemical_assemble(var/datum/reagent/R)
	title = R.name
	body  = "<b>Description: </b>[R.description]<br>"
	/* Downstream features
	if(R.id in addictives)
		body  += "<b>DANGER, [(R.id in fast_addictives) ? "highly " : ""]addictive.</b><br>"
	var/tank_size = CARGOTANKER_VOLUME
	if(R.industrial_use)
		body  += "<b>Industrial Use: </b>[R.industrial_use]<br>"
	body += "<b>Supply Points: [R.supply_conversion_value] per unit, [R.supply_conversion_value * tank_size] per [tank_size] tank</b><br>"
	var/value = R.supply_conversion_value * REAGENTS_PER_SHEET * SSsupply.points_per_money
	value = FLOOR(value * 100,1) / 100 // Truncate decimals
	if(value > 0)
		body += "<b>Market Price: [value] [value > 1 ? "thalers" : "thaler"] per [REAGENTS_PER_SHEET] units  |  [(value*tank_size)] [(value*tank_size) > 1 ? "thalers" : "thaler"] per [tank_size] unit tank</b><br>"
	if(global.reagent_sheets[R.id])
		var/mat_id = global.reagent_sheets[R.id]
		switch(mat_id)
			if("FLAG_SMOKE")
				body += "<b>Sintering Results: COMBUSTION</b><br>"
			if("FLAG_EXPLODE")
				body += "<b>Sintering Results: DETONATION</b><br>"
			if("FLAG_SPIDERS")
				body += "<b>Sintering Results: DO NOT EVER</b><br>"
			else
				var/datum/material/C = get_material_by_name(global.reagent_sheets[R.id])
				if(C)
					body += "<b>Sintering Results: [C.display_name] [C.sheet_plural_name]</b><br>"
				else
					log_runtime(EXCEPTION("Invalid sintering result id: [global.reagent_sheets[R.id]] in reagent [title]"))
	*/
	if(R.overdose > 0)
		body += "<b>Overdose: </b>[R.overdose]U<br>"
	body += "<b>Flavor: </b>[R.taste_description]<br>"
	body += "<br>"
	body += allergen_assemble(R.allergen_type)
	body += "<br>"
	var/list/reaction_list = SSchemistry.chemical_reactions_by_product[R.id]
	if(reaction_list != null && reaction_list.len > 0)
		var/segment = 1

		var/list/display_reactions = list()
		for(var/decl/chemical_reaction/CR in reaction_list)
			display_reactions.Add(CR)
		for(var/decl/chemical_reaction/CR in display_reactions)
			if(display_reactions.len == 1)
				body += "<b>Potential Chemical breakdown: </b><br>"
			else
				body += "<b>Potential Chemical breakdown [segment]: </b><br>"
			segment += 1

			for(var/RQ in CR.required_reagents)
				var/decl/chemical_reaction/r_RQ = SSchemistry.chemical_reagents[RQ]
				if(!r_RQ)
					log_runtime(EXCEPTION("Invalid reagent id: [RQ] in chemical instant component for [title]"))
					continue
				body += " <b>-Component: </b>[r_RQ.name]<br>"
			for(var/IH in CR.inhibitors)
				var/decl/chemical_reaction/r_IH = SSchemistry.chemical_reagents[IH]
				if(!r_IH)
					log_runtime(EXCEPTION("Invalid reagent id: [IH] in chemical instant inhibitor for [title]"))
					continue
				body += " <b>-Inhibitor: </b>[r_IH.name]<br>"
			for(var/CL in CR.catalysts)
				var/decl/chemical_reaction/r_CL = SSchemistry.chemical_reagents[CL]
				if(!r_CL)
					log_runtime(EXCEPTION("Invalid reagent id: [CL] in chemical instant catalyst for [title]"))
					continue
				body += " <b>-Catalyst: </b>[r_CL.name]<br>"
	else
		body += "<b>Potential Chemical breakdown: </b><br>UNKNOWN OR BASE-REAGENT<br>"

	var/list/distilled_list = SSchemistry.distilled_reactions_by_product[R.id]
	if(distilled_list != null && distilled_list.len > 0)
		body += "<br>"
		var/segment = 1

		var/list/display_reactions = list()
		for(var/decl/chemical_reaction/distilling/CR in distilled_list)
			display_reactions.Add(CR)

		for(var/decl/chemical_reaction/distilling/CR in display_reactions)
			if(display_reactions.len == 1)
				body += "<b>Potential Chemical Distillation: </b><br>"
			else
				body += "<b>Potential Chemical Distillation [segment]: </b><br>"
			segment += 1

			body += " <b>-Temperature: </b> [CR.temp_range[1]]K - [CR.temp_range[2]]K | ([CR.temp_range[1] - T0C]C - [CR.temp_range[2] - T0C]C)<br>"
			/* Downstream features
			body += " <b>-Pressure: </b> [isnull(CR.minimum_xgm_pressure) ? 0 : CR.minimum_xgm_pressure]kpa to [isnull(CR.maximum_xgm_pressure) ? "~" : CR.maximum_xgm_pressure]kpa<br>"
			if(CR.require_xgm_gas)
				body += " <b>-Requires Gas: </b> [CR.require_xgm_gas]<br>"
			if(CR.rejects_xgm_gas)
				body += " <b>-Rejects Gas: </b> [CR.rejects_xgm_gas]<br>"
			*/

			for(var/RQ in CR.required_reagents)
				var/decl/chemical_reaction/r_RQ = SSchemistry.chemical_reagents[RQ]
				if(!r_RQ)
					log_runtime(EXCEPTION("Invalid reagent id: [RQ] in chemical distilation component for [title]"))
					continue
				body += " <b>-Component: </b>[r_RQ.name]<br>"
			for(var/IH in CR.inhibitors)
				var/decl/chemical_reaction/r_IH = SSchemistry.chemical_reagents[IH]
				if(!r_IH)
					log_runtime(EXCEPTION("Invalid reagent id: [IH] in chemical distilation inhibitor for [title]"))
					continue
				body += " <b>-Inhibitor: </b>[r_IH.name]<br>"
			for(var/CL in CR.catalysts)
				var/decl/chemical_reaction/r_CL = SSchemistry.chemical_reagents[CL]
				if(!r_CL)
					log_runtime(EXCEPTION("Invalid reagent id: [CL] in chemical distilation catalyst for [title]"))
					continue
				body += " <b>-Catalyst: </b>[r_CL.name]<br>"

/datum/internal_wiki/page/proc/food_assemble(var/datum/reagent/R)
	title = R.name
	body  = "<b>Description: </b>[R.description]<br>"
	body += "<br>"
	body += allergen_assemble(R.allergen_type)
	body += "<br>"
	var/list/reaction_list = SSchemistry.chemical_reactions_by_product[R.id]
	if(reaction_list != null && reaction_list.len > 0)
		var/segment = 1
		var/list/display_reactions = list()
		for(var/decl/chemical_reaction/CR in reaction_list)
			display_reactions.Add(CR)
		for(var/decl/chemical_reaction/CR in display_reactions)
			if(display_reactions.len == 1)
				body += "<b>Recipe: </b><br>"
			else
				body += "<b>Recipe </b>[segment]: <br>"
			segment += 1

			for(var/RQ in CR.required_reagents)
				var/datum/reagent/RQ_A = SSchemistry.chemical_reagents[RQ]
				if(!RQ_A)
					log_runtime(EXCEPTION("Invalid reagent id: [RQ] in food instant component for [title]"))
					continue
				body += " <b>-Component: </b>[RQ_A.name]<br>"
			for(var/IH in CR.inhibitors)
				var/datum/reagent/IH_A = SSchemistry.chemical_reagents[IH]
				if(!IH_A)
					log_runtime(EXCEPTION("Invalid reagent id: [IH] in food instant inhibitor for [title]"))
					continue
				body += " <b>-Inhibitor: </b>[IH_A.name]<br>"
			for(var/CL in CR.catalysts)
				var/datum/reagent/CL_A = SSchemistry.chemical_reagents[CL]
				if(!CL_A)
					log_runtime(EXCEPTION("Invalid reagent id: [CL] in food instant catalyst for [title]"))
					continue
				body += " <b>-Catalyst: </b>[CL_A.name]<br>"
	else
		body += "<b>Recipe: </b>UNKNOWN<br>"

/datum/internal_wiki/page/proc/drink_assemble(var/datum/reagent/R)
	title = R.name
	body  = "<b>Description: </b>[R.description]<br>"
	body += "<b>Flavor: </b>[R.taste_description]<br>"
	body += "<br>"
	body += allergen_assemble(R.allergen_type)
	body += "<br>"
	var/list/reaction_list = SSchemistry.chemical_reactions_by_product[R.id]
	if(reaction_list != null && reaction_list.len > 0)
		var/segment = 1
		var/list/display_reactions = list()
		for(var/decl/chemical_reaction/CR in reaction_list)
			display_reactions.Add(CR)
		for(var/decl/chemical_reaction/CR in display_reactions)
			if(display_reactions.len == 1)
				body += "Mix: <br>"
			else
				body += "Mix [segment]: <br>"
			segment += 1

			for(var/RQ in CR.required_reagents)
				var/datum/reagent/RQ_A = SSchemistry.chemical_reagents[RQ]
				if(!RQ_A)
					log_runtime(EXCEPTION("Invalid reagent id: [RQ] in drink instant component for [title]"))
					continue
				body += " <b>-Component: </b>[RQ_A.name]<br>"
			for(var/IH in CR.inhibitors)
				var/datum/reagent/IH_A = SSchemistry.chemical_reagents[IH]
				if(!IH_A)
					log_runtime(EXCEPTION("Invalid reagent id: [IH] in drink instant inhibitor for [title]"))
					continue
				body += " <b>-Inhibitor: </b>[IH_A.name]<br>"
			for(var/CL in CR.catalysts)
				var/datum/reagent/CL_A = SSchemistry.chemical_reagents[CL]
				if(!CL_A)
					log_runtime(EXCEPTION("Invalid reagent id: [CL] in drink instant catalyst for [title]"))
					continue
				body += " <b>-Catalyst: </b>[CL_A.name]<br>"
	else
		body += "<b>Mix: </b>UNKNOWN<br>"

/datum/internal_wiki/page/proc/allergen_assemble(var/allergens)
	PRIVATE_PROC(TRUE)
	var/AG = ""
	if(allergens > 0)
		AG += "<b>Allergens: </b><br>"
		if(allergens & ALLERGEN_MEAT)
			AG += "-Meat protein<br>"
		if(allergens & ALLERGEN_FISH)
			AG += "-Fish protein<br>"
		if(allergens & ALLERGEN_FRUIT)
			AG += "-Fruit<br>"
		if(allergens & ALLERGEN_VEGETABLE)
			AG += "-Vegetable<br>"
		if(allergens & ALLERGEN_GRAINS)
			AG += "-Grain<br>"
		if(allergens & ALLERGEN_BEANS)
			AG += "-Bean<br>"
		if(allergens & ALLERGEN_SEEDS)
			AG += "-Nut<br>"
		if(allergens & ALLERGEN_DAIRY)
			AG += "-Dairy<br>"
		if(allergens & ALLERGEN_FUNGI)
			AG += "-Fungi<br>"
		if(allergens & ALLERGEN_COFFEE)
			AG += "-Caffeine<br>"
		if(allergens & ALLERGEN_SUGARS)
			AG += "-Sugar<br>"
		if(allergens & ALLERGEN_EGGS)
			AG += "-Egg<br>"
		if(allergens & ALLERGEN_STIMULANT)
			AG += "-Stimulant<br>"
		/* Downstream features
		if(allergens & ALLERGEN_POLLEN)
			AG += "-Pollen<br>"
		if(allergens & ALLERGEN_SALT)
			AG += "-Salt<br>"
		*/
		AG += "<br>"
	return AG

/datum/internal_wiki/page/proc/recipe_assemble(var/list/recipe)
	title = recipe["Result"]
	if(recipe["Desc"])
		body  += "<b>Description: </b>[recipe["Desc"]]<br>"
	if(length(recipe["Flavor"]) > 0)
		body += "<b>Flavor: </b>[recipe["Flavor"]]<br>"
	if(recipe["Price"] > 0)
		var/value = recipe["Price"]
		body += "<b>Supply Points: </b>[value]<br>"
		// convert to cash
		value *= SSsupply.points_per_money
		value = FLOOR(value * 100,1) / 100 // Truncate decimals
		body += "<b>Market Price: [value] [value > 1 ? "thalers" : "thaler"]</b><br>"
	body += allergen_assemble(recipe["Allergens"])
	body += "<br>"
	if(recipe["Appliance"])
		body += "<b>Appliance: </b>[recipe["Appliance"]]<br><br>"

	var/count //For those commas. Not sure of a great other way to do it.
	//For each large ingredient
	var/pretty_ing = ""
	count = 0
	for(var/ing in recipe["Ingredients"])
		pretty_ing += "[count == 0 ? "" : ", "][recipe["Ingredients"][ing]]x [ing]"
		count++
	if(pretty_ing != "")
		body +=  "<b>Ingredients: </b>[pretty_ing]<br>"

	//Coating
	if(!recipe["has_coatable_items"])
		body += "<b>Coating: </b>N/A, no coatable items<br>"
	else if(recipe["Coating"] == -1)
		body += "<b>Coating: </b>Optionally, any coating<br>"
	else if(isnull(recipe["Coating"]))
		body += "<b>Coating: </b> Must be uncoated<br>"
	else
		var/coatingtype = recipe["Coating"]
		body += "<b>Coating: </b> [initial(coatingtype:name)]<br>"

	//For each fruit... why are they named this when it can be vegis too?
	var/pretty_fru = ""
	count = 0
	for(var/fru in recipe["Fruit"])
		pretty_fru += "[count == 0 ? "" : ", "][recipe["Fruit"][fru]]x [fru]"
		count++
	if(pretty_fru != "")
		body += "<b>Components: </b> [pretty_fru]<br>"

	//For each reagent
	var/pretty_rea = ""
	count = 0
	for(var/rea in recipe["Reagents"])
		pretty_rea += "[count == 0 ? "" : ", "][recipe["Reagents"][rea]]u [rea]"
		count++
	if(pretty_rea != "")
		body += "<b>Mix in: </b> [pretty_rea]<br>"

	//For each catalyst
	var/pretty_cat = ""
	count = 0
	for(var/cat in recipe["Catalysts"])
		pretty_cat += "[count == 0 ? "" : ", "][recipe["Catalysts"][cat]]u [cat]"
		count++
	if(pretty_cat != "")
		body += "<b>Catalysts: </b> [pretty_cat]<br>"

/datum/internal_wiki/page/catalog
	var/datum/category_item/catalogue/catalog_record = null

/datum/internal_wiki/page/catalog/get_data()
	return catalog_record.desc
