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
	VAR_PRIVATE/list/catalog_list = list()
	VAR_PRIVATE/list/drinkreact = list()
	VAR_PRIVATE/list/chemreact = list()
	VAR_PRIVATE/list/botseeds = list()

	VAR_PRIVATE/list/foodrecipe = list()

	VAR_PRIVATE/list/catalogs = list()

	VAR_PRIVATE/list/searchcache_ore = list()
	VAR_PRIVATE/list/searchcache_material = list()
	VAR_PRIVATE/list/searchcache_smasher = list()
	VAR_PRIVATE/list/searchcache_foodrecipe = list()
	VAR_PRIVATE/list/searchcache_drinkreact = list()
	VAR_PRIVATE/list/searchcache_chemreact = list()
	VAR_PRIVATE/list/searchcache_catalogs = list()
	VAR_PRIVATE/list/searchcache_botseeds = list()

	VAR_PRIVATE/list/spoiler_entries = list()

	VAR_PRIVATE/max_donation = 100000
	VAR_PRIVATE/min_donation = 50000
	VAR_PRIVATE/donation_goal = 0
	VAR_PRIVATE/cur_donation = 0
	VAR_PRIVATE/list/dono_list = list()
	VAR_PRIVATE/highest_cached_donator = null

/datum/controller/subsystem/internal_wiki/stat_entry(msg)
	msg = "P: [pages.len] | O: [ores.len] | M: [materials.len] | S: [smashers.len] | F: [foodrecipe.len]  | D: [drinkreact.len]  | C: [chemreact.len]  | B: [botseeds.len] "
	return ..()

/datum/controller/subsystem/internal_wiki/Initialize()
	init_ore_data()
	init_material_data()
	init_particle_smasher_data()
	init_reagent_data()
	init_seed_data()
	init_kitchen_data()
	init_lore_data()
	// Donation gag
	donation_goal = rand(min_donation,max_donation)
	donation_goal = round(donation_goal,1)
	cur_donation = rand(0,donation_goal * 0.95)
	cur_donation = round(cur_donation,1)
	return SS_INIT_SUCCESS


///////////////////////////////////////////////////////////////////////////////////
// Donation system, for the joke of course
///////////////////////////////////////////////////////////////////////////////////
/datum/controller/subsystem/internal_wiki/proc/pay_with_card( var/obj/item/card/id/I, var/mob/M, var/obj/device, var/paying_amount)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!purchase_with_id_card(I, M, "Bingle.Co.LLC.UK.M.XM.WMP.AVI.COM", device.name, "Donation", paying_amount))
		return FALSE
	// Keep tabs on donations
	var/datum/money_account/customer_account = get_account(I.associated_account_number)
	if(isnull(dono_list[customer_account.owner_name]))
		dono_list[customer_account.owner_name] = 0
	dono_list[customer_account.owner_name] += paying_amount
	donation_add(paying_amount)
	return TRUE

/datum/controller/subsystem/internal_wiki/proc/donation_add(var/paying_amount)
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	var/old_dono = cur_donation
	cur_donation += paying_amount
	if(old_dono < donation_goal)
		// If donation goal was not yet met upon donation, recalculate leader on donate
		highest_cached_donator = update_highest_donator(TRUE)
		if(cur_donation >= donation_goal) // Reached goal!
			message_admins("Bingle donation goal reached! Winner was [get_highest_donor_name()] with [get_highest_donor_value()]") // TODO - Removed me for something actually interesting

/datum/controller/subsystem/internal_wiki/proc/update_highest_donator(var/no_cache = FALSE)
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	if(no_cache)
		highest_cached_donator = null
	if(highest_cached_donator)
		return highest_cached_donator
	// Search through the donated names for a winner
	var/highest = "noone!"
	var/val = 0
	for(var/donor in dono_list)
		if(dono_list[donor] > val)
			val = dono_list[donor]
			highest = donor
	return highest


///////////////////////////////////////////////////////////////////////////////////
// Accessors for safely talking with the subsystem
///////////////////////////////////////////////////////////////////////////////////
// get a page from a search
/datum/controller/subsystem/internal_wiki/proc/get_page_food(var/search)
	RETURN_TYPE(/datum/internal_wiki/page/food)
	SHOULD_NOT_OVERRIDE(TRUE)
	return foodrecipe[search]
/datum/controller/subsystem/internal_wiki/proc/get_page_drink(var/search)
	RETURN_TYPE(/datum/internal_wiki/page/drink)
	SHOULD_NOT_OVERRIDE(TRUE)
	return drinkreact[search]
/datum/controller/subsystem/internal_wiki/proc/get_page_chem(var/search)
	RETURN_TYPE(/datum/internal_wiki/page/chemical)
	SHOULD_NOT_OVERRIDE(TRUE)
	return chemreact[search]
/datum/controller/subsystem/internal_wiki/proc/get_page_seed(var/search)
	RETURN_TYPE(/datum/internal_wiki/page/seed)
	SHOULD_NOT_OVERRIDE(TRUE)
	return botseeds[search]
/datum/controller/subsystem/internal_wiki/proc/get_page_catalog(var/search)
	RETURN_TYPE(/datum/internal_wiki/page/catalog)
	SHOULD_NOT_OVERRIDE(TRUE)
	return catalogs[search]
/datum/controller/subsystem/internal_wiki/proc/get_page_material(var/search)
	RETURN_TYPE(/datum/internal_wiki/page/material)
	SHOULD_NOT_OVERRIDE(TRUE)
	return materials[search]
/datum/controller/subsystem/internal_wiki/proc/get_page_particle(var/search)
	RETURN_TYPE(/datum/internal_wiki/page/smasher)
	SHOULD_NOT_OVERRIDE(TRUE)
	return smashers[search]
/datum/controller/subsystem/internal_wiki/proc/get_page_ore(var/search)
	RETURN_TYPE(/datum/internal_wiki/page/ore)
	SHOULD_NOT_OVERRIDE(TRUE)
	return ores[search]
// Search lists
/datum/controller/subsystem/internal_wiki/proc/get_appliances()
	RETURN_TYPE(/list)
	SHOULD_NOT_OVERRIDE(TRUE)
	return appliance_list
/datum/controller/subsystem/internal_wiki/proc/get_searchcache_food(var/appliance)
	RETURN_TYPE(/list)
	SHOULD_NOT_OVERRIDE(TRUE)
	return searchcache_foodrecipe[appliance] || list()
/datum/controller/subsystem/internal_wiki/proc/get_searchcache_drink()
	RETURN_TYPE(/list)
	SHOULD_NOT_OVERRIDE(TRUE)
	return searchcache_drinkreact
/datum/controller/subsystem/internal_wiki/proc/get_searchcache_chem()
	RETURN_TYPE(/list)
	SHOULD_NOT_OVERRIDE(TRUE)
	return searchcache_chemreact
/datum/controller/subsystem/internal_wiki/proc/get_searchcache_seed()
	RETURN_TYPE(/list)
	SHOULD_NOT_OVERRIDE(TRUE)
	return searchcache_botseeds
/datum/controller/subsystem/internal_wiki/proc/get_catalogs()
	RETURN_TYPE(/list)
	SHOULD_NOT_OVERRIDE(TRUE)
	return catalog_list
/datum/controller/subsystem/internal_wiki/proc/get_searchcache_catalog(var/section)
	RETURN_TYPE(/list)
	SHOULD_NOT_OVERRIDE(TRUE)
	var/list/known_entries = list()
	var/list/section_data = searchcache_catalogs[section] || list()
	for(var/PG in section_data)
		var/datum/internal_wiki/page/catalog/P = catalogs["[PG]"]
		var/datum/category_item/catalogue/C = P.catalog_record
		if(C.visible || C.value <= CATALOGUER_REWARD_TRIVIAL)
			known_entries.Add(PG)
	return known_entries
/datum/controller/subsystem/internal_wiki/proc/get_searchcache_material()
	RETURN_TYPE(/list)
	SHOULD_NOT_OVERRIDE(TRUE)
	return searchcache_material
/datum/controller/subsystem/internal_wiki/proc/get_searchcache_particle()
	RETURN_TYPE(/list)
	SHOULD_NOT_OVERRIDE(TRUE)
	return searchcache_smasher
/datum/controller/subsystem/internal_wiki/proc/get_searchcache_ore()
	RETURN_TYPE(/list)
	SHOULD_NOT_OVERRIDE(TRUE)
	return searchcache_ore
// Donating
/datum/controller/subsystem/internal_wiki/proc/get_donor_value(var/key)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!dono_list.len || isnull(dono_list[key]))
		return 0
	return dono_list[key]
/datum/controller/subsystem/internal_wiki/proc/get_donation_current()
	SHOULD_NOT_OVERRIDE(TRUE)
	return cur_donation
/datum/controller/subsystem/internal_wiki/proc/get_donation_goal()
	SHOULD_NOT_OVERRIDE(TRUE)
	return donation_goal
/datum/controller/subsystem/internal_wiki/proc/get_highest_donor_name()
	SHOULD_NOT_OVERRIDE(TRUE)
	highest_cached_donator = update_highest_donator(FALSE)
	return highest_cached_donator
/datum/controller/subsystem/internal_wiki/proc/get_highest_donor_value()
	SHOULD_NOT_OVERRIDE(TRUE)
	highest_cached_donator = update_highest_donator(FALSE)
	return get_donor_value(highest_cached_donator)
// Helpers for formatting wiki data for tgui pages
/datum/controller/subsystem/internal_wiki/proc/assemble_reaction_data(var/list/data, var/datum/reagent/R)
	var/list/reaction_list = SSchemistry.chemical_reactions_by_product[R.id]
	var/list/distilled_list = SSchemistry.distilled_reactions_by_product[R.id]

	data["instant_reactions"] = null
	if(reaction_list != null && reaction_list.len > 0)
		var/list/display_reactions = list()
		for(var/decl/chemical_reaction/CR in reaction_list)
			if(CR.wiki_flag & WIKI_SPOILER)
				continue
			display_reactions.Add(CR)

		var/reactions = list()
		for(var/decl/chemical_reaction/CR in display_reactions)
			var/list/assemble_reaction = list()
			var/list/reqs = list()
			for(var/RQ in CR.required_reagents)
				var/decl/chemical_reaction/r_RQ = SSchemistry.chemical_reagents[RQ]
				if(!r_RQ)
					log_runtime(EXCEPTION("Invalid reagent id: [RQ]"))
					continue
				reqs.Add("[r_RQ.name]")
			assemble_reaction["required"] = reqs
			var/list/inhib = list()
			for(var/IH in CR.inhibitors)
				var/decl/chemical_reaction/r_IH = SSchemistry.chemical_reagents[IH]
				if(!r_IH)
					log_runtime(EXCEPTION("Invalid reagent id: [IH]"))
					continue
				inhib.Add("[r_IH.name]")
			assemble_reaction["inhibitor"] = inhib
			var/list/catal = list()
			for(var/CL in CR.catalysts)
				var/decl/chemical_reaction/r_CL = SSchemistry.chemical_reagents[CL]
				if(!r_CL)
					log_runtime(EXCEPTION("Invalid reagent id: [CL]"))
					continue
				catal.Add("[r_CL.name]")
			assemble_reaction["catalysts"] = catal
			assemble_reaction["is_slime"] = null
			if(istype(CR,/decl/chemical_reaction/instant/slime))
				var/decl/chemical_reaction/instant/slime/CRS = CR
				var/obj/item/slime_extract/slime_path = CRS.required
				assemble_reaction["is_slime"] = initial(slime_path.name)
			reactions += list(assemble_reaction)
		if(display_reactions.len)
			data["instant_reactions"] = reactions

	data["distilled_reactions"] = null
	if(distilled_list != null && distilled_list.len > 0)
		var/list/display_reactions = list()
		for(var/decl/chemical_reaction/distilling/CR in distilled_list)
			if(CR.wiki_flag & WIKI_SPOILER)
				continue
			display_reactions.Add(CR)

		var/reactions = list()
		for(var/decl/chemical_reaction/distilling/CR in display_reactions)
			var/list/assemble_reaction = list()
			assemble_reaction["temp_min"] = CR.temp_range[1]
			assemble_reaction["temp_max"] = CR.temp_range[2]
			/* Downstream features
			assemble_reaction["xgm_min"] = CR.minimum_xgm_pressure
			assemble_reaction["xgm_max"] = CR.maximum_xgm_pressure
			assemble_reaction["require_xgm_gas"] = CR.require_xgm_gas
			assemble_reaction["rejects_xgm_gas"] = CR.rejects_xgm_gas
			*/
			var/list/reqs = list()
			for(var/RQ in CR.required_reagents)
				var/decl/chemical_reaction/r_RQ = SSchemistry.chemical_reagents[RQ]
				if(!r_RQ)
					log_runtime(EXCEPTION("Invalid reagent id: [RQ]"))
					continue
				reqs.Add("[r_RQ.name]")
			assemble_reaction["required"] = reqs
			var/list/inhib = list()
			for(var/IH in CR.inhibitors)
				var/decl/chemical_reaction/r_IH = SSchemistry.chemical_reagents[IH]
				if(!r_IH)
					log_runtime(EXCEPTION("Invalid reagent id: [IH]"))
					continue
				inhib.Add("[r_IH.name]")
			assemble_reaction["inhibitor"] = inhib
			var/list/catal = list()
			for(var/CL in CR.catalysts)
				var/decl/chemical_reaction/r_CL = SSchemistry.chemical_reagents[CL]
				if(!r_CL)
					log_runtime(EXCEPTION("Invalid reagent id: [CL]"))
					continue
				catal.Add("[r_CL.name]")
			assemble_reaction["catalysts"] = catal
			assemble_reaction["is_slime"] = null
			reactions += list(assemble_reaction)
		if(display_reactions.len)
			data["distilled_reactions"] = reactions

	var/grind_list = list()
	var/list/display_reactions = list()
	for(var/ore_type in ore_reagents)
		var/obj/item/ore/O = ore_type
		if(R.id in ore_reagents[ore_type])
			display_reactions.Add(initial(O.name))
	grind_list["ore"] = null
	if(display_reactions.len > 0)
		grind_list["ore"] = display_reactions

	display_reactions = list()
	for(var/sheet_type in sheet_reagents)
		var/obj/item/stack/material/M = sheet_type
		if(R.id in sheet_reagents[sheet_type])
			display_reactions.Add(initial(M.name))
	grind_list["material"] = null
	if(display_reactions.len > 0)
		grind_list["material"] = display_reactions

	display_reactions = list()
	for(var/SN in SSplants.seeds)
		var/datum/seed/S = SSplants.seeds[SN]
		if(S && S.roundstart && !S.mysterious)
			if(S.wiki_flag & WIKI_SPOILER)
				continue
			if(!S.chems || !S.chems.len)
				continue
			if(!(R.id in S.chems))
				continue
			display_reactions.Add(S.display_name)
	grind_list["plant"] = null
	if(display_reactions.len > 0)
		grind_list["plant"] = display_reactions

	data["grinding"] = grind_list

	display_reactions = list()
	for(var/O in GLOB.ore_data)
		var/ore/OR = GLOB.ore_data[O]
		if(OR.reagent == R.id)
			display_reactions.Add(OR.name)
	data["fluid"] = null
	if(display_reactions.len > 0)
		data["fluid"] = display_reactions

	display_reactions = list()
	var/list/instant_by_reagent = SSchemistry.instant_reactions_by_reagent["[R.id]"]
	if(instant_by_reagent && instant_by_reagent.len)
		for(var/i = 1, i <= instant_by_reagent.len, i++)
			var/decl/chemical_reaction/OR = instant_by_reagent[i]
			if(istype(OR,/decl/chemical_reaction/instant/slime)) // very bloated and meant to be a mystery
				continue
			display_reactions.Add(OR.name)
	var/list/distilled_by_reagent = SSchemistry.distilled_reactions_by_reagent["[R.id]"]
	if(distilled_by_reagent && distilled_by_reagent.len)
		for(var/i = 1, i <= distilled_by_reagent.len, i++)
			var/decl/chemical_reaction/OR = distilled_by_reagent[i]
			display_reactions.Add(OR.name)
	data["produces"] = null
	if(display_reactions.len > 0)
		data["produces"] = display_reactions

/datum/controller/subsystem/internal_wiki/proc/assemble_allergens(var/allergens)
	if(allergens > 0)
		var/list/allergies = list()
		if(allergens & ALLERGEN_MEAT)
			allergies.Add("Meat protein")
		if(allergens & ALLERGEN_FISH)
			allergies.Add("Fish protein")
		if(allergens & ALLERGEN_FRUIT)
			allergies.Add("Fruit")
		if(allergens & ALLERGEN_VEGETABLE)
			allergies.Add("Vegetable")
		if(allergens & ALLERGEN_GRAINS)
			allergies.Add("Grain")
		if(allergens & ALLERGEN_BEANS)
			allergies.Add("Bean")
		if(allergens & ALLERGEN_SEEDS)
			allergies.Add("Nut")
		if(allergens & ALLERGEN_DAIRY)
			allergies.Add("Dairy")
		if(allergens & ALLERGEN_FUNGI)
			allergies.Add("Fungi")
		if(allergens & ALLERGEN_COFFEE)
			allergies.Add("Caffeine")
		if(allergens & ALLERGEN_SUGARS)
			allergies.Add("Sugar")
		if(allergens & ALLERGEN_EGGS)
			allergies.Add("Egg")
		if(allergens & ALLERGEN_STIMULANT)
			allergies.Add("Stimulant")
		if(allergens & ALLERGEN_CHOCOLATE)
			allergies.Add("Chocolate")
		/* Downstream features
		if(allergens & ALLERGEN_POLLEN)
			allergies.Add("Pollen")
		if(allergens & ALLERGEN_SALT)
			allergies.Add("Salt")
		*/
		return allergies
	return null

/datum/controller/subsystem/internal_wiki/proc/add_icon(var/list/data, var/ic, var/is, var/col)
	var/load_data = list()
	load_data["icon"] = ic // dmi path
	load_data["state"] = is // string
	load_data["color"] = col // html color
	data["icon_data"] = load_data


///////////////////////////////////////////////////////////////////////////////////
// Initilizing data and creating wiki pages
///////////////////////////////////////////////////////////////////////////////////
/datum/controller/subsystem/internal_wiki/proc/init_ore_data()
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	// assemble ore wiki
	for(var/N in GLOB.ore_data)
		var/ore/OR = GLOB.ore_data[N]
		if(OR.wiki_flag & WIKI_SPOILER)
			spoiler_entries.Add(OR.type)
			continue
		var/datum/internal_wiki/page/ore/P = new()
		P.assemble(OR)
		ores["[OR.display_name]"] = P
		searchcache_ore.Add("[OR.display_name]")
		pages.Add(P)

/datum/controller/subsystem/internal_wiki/proc/init_material_data()
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	// assemble material wiki
	for(var/mat in name_to_material)
		var/datum/material/M = name_to_material[mat]
		if(M.wiki_flag & WIKI_SPOILER)
			spoiler_entries.Add(M.type)
			continue
		var/datum/internal_wiki/page/material/P = new()
		var/id = "[M.display_name] [M.sheet_singular_name]"
		P.assemble(M)
		materials[id] = P
		searchcache_material.Add(id)
		pages.Add(P)

/datum/controller/subsystem/internal_wiki/proc/init_particle_smasher_data()
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	// assemble particle smasher wiki
	for(var/datum/particle_smasher_recipe/D  as anything in subtypesof(/datum/particle_smasher_recipe))
		if(initial(D.wiki_flag) & WIKI_SPOILER)
			spoiler_entries.Add(D)
			continue
		var/datum/particle_smasher_recipe/R = new D()
		var/datum/internal_wiki/page/smasher/P = new()
		var/id = "[initial(D.display_name)]"
		P.assemble(R)
		smashers[id] = P
		searchcache_smasher.Add(id)
		pages.Add(P)
		qdel(R)

/datum/controller/subsystem/internal_wiki/proc/init_reagent_data()
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	// assemble chemical reactions wiki
	for(var/reagent in SSchemistry.chemical_reagents)
		var/datum/internal_wiki/page/P = null
		var/datum/reagent/R = SSchemistry.chemical_reagents[reagent]
		if(!allow_reagent(R.id))
			continue
		if((R.wiki_flag & WIKI_FOOD)) // Processed later
			continue
		if(R.wiki_flag & WIKI_SPOILER)
			spoiler_entries.Add(R.type)
			continue
		var/id = "[R.name]"
		if((R.wiki_flag & WIKI_DRINK) && R.id != REAGENT_ID_ETHANOL) // This is no good way to use inheretance for ethanol... We exclude it here so it shows up in chems
			P = new /datum/internal_wiki/page/drink()
			P.assemble(R)
			searchcache_drinkreact.Add(id)
			drinkreact[id] = P
		else
			P = new /datum/internal_wiki/page/chemical()
			P.assemble(R)
			searchcache_chemreact.Add(id)
			chemreact[id] = P
		pages.Add(P)

/datum/controller/subsystem/internal_wiki/proc/init_seed_data()
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	// seeds and plants
	for(var/SN in SSplants.seeds)
		var/datum/seed/S = SSplants.seeds[SN]
		if(S && S.roundstart && !S.mysterious)
			if(S.wiki_flag & WIKI_SPOILER)
				spoiler_entries.Add(S.type)
				continue
			var/datum/internal_wiki/page/seed/P = new()
			P.assemble(S)
			searchcache_botseeds.Add("[S.display_name]")
			botseeds["[S.display_name]"] = P
			pages.Add(P)

/datum/controller/subsystem/internal_wiki/proc/init_kitchen_data()
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	// Build the kitchen recipe lists
	var/list/food_recipes = subtypesof(/datum/recipe)
	for(var/datum/recipe/Rp as anything in food_recipes)
		//Lists don't work with datum-stealing no-instance initial() so we have to.
		var/datum/recipe/R = new Rp()
		if(!isnull(R.result))
			var/obj/item/res = R.result
			food_recipes[Rp] = list(
						"Result" = "[initial(res.name)]",
						"ResultPath" = res,
						"Desc" = "[initial(res.desc)]",
						"ResAmt" = "1",
						"Reagents" = R.reagents ? R.reagents.Copy() : list(),
						"Catalysts" = list(),
						"Fruit" = R.fruit ? R.fruit.Copy() : list(),
						"Ingredients" = R.items ? R.items.Copy() : list(),
						"Coating" = R.coating,
						"Appliance" = R.appliance,
						"Allergens" = 0,
						"Price" = initial(res.price_tag),
						"Flags" = R.wiki_flag
						)
		qdel(R)
	// basically condiments, tofu, cheese, soysauce, etc
	for(var/decl/chemical_reaction/instant/CR in SSchemistry.chemical_reactions)
		if(!allow_reagent(CR.result))
			continue
		if(CR.wiki_flag & WIKI_SPOILER)
			continue
		if(!(CR.wiki_flag & WIKI_FOOD))
			continue
		food_recipes[CR.type] = list("Result" = CR.name,
								"ResultPath" = null,
								"ResAmt" = CR.result_amount,
								"Reagents" = CR.required_reagents ? CR.required_reagents.Copy() : list(),
								"Catalysts" = CR.catalysts ? CR.catalysts.Copy() : list(),
								"Fruit" = list(),
								"Ingredients" = list(),
								"Appliance" = 0,
								"Allergens" = 0,
								"Flags" = CR.wiki_flag
								)
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

	//We can also change the appliance to its proper name.
	for(var/Rp in food_recipes)
		switch(food_recipes[Rp]["Appliance"])
			if(0)
				food_recipes[Rp]["Appliance"] = "Simple"
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
	for(var/Rp in food_recipes) // "Appliance" will sort the list by APPLIANCES first. Items without an appliance will append to the top of the list. The old method was "Result", which sorts the list by the name of the result.
		foods_to_paths["[food_recipes[Rp]["Appliance"]] [Rp]"] = Rp //Append recipe datum path to keep uniqueness
	foods_to_paths = sortAssoc(foods_to_paths)
	var/list/foods_newly_sorted = list()
	for(var/Rr in foods_to_paths)
		var/Rp = foods_to_paths[Rr]
		foods_newly_sorted[Rp] = food_recipes[Rp]
	food_recipes = foods_newly_sorted

	// assemble output pages
	for(var/Rp in food_recipes)
		if(food_recipes[Rp] && !isnull(food_recipes[Rp]["Result"]))
			if(food_recipes[Rp]["Flags"] & WIKI_SPOILER)
				spoiler_entries.Add(Rp)
				continue
			var/datum/internal_wiki/page/recipe/P = new()
			P.assemble(food_recipes[Rp])
			foodrecipe["[P.title]"] = P
			// organize into sublists
			var/app = food_recipes[Rp]["Appliance"]
			if(!searchcache_foodrecipe[app])
				searchcache_foodrecipe[app] = list()
			var/list/FL = searchcache_foodrecipe[app]
			FL.Add("[P.title]")
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
			var/datum/internal_wiki/page/catalog/P = new()
			P.title = item.name
			P.catalog_record = item
			P.assemble()
			catalogs["[item.name]"] = P
			if(!searchcache_catalogs[G.name])
				searchcache_catalogs[G.name] = list()
			var/list/SC = searchcache_catalogs[G.name]
			SC.Add(P.title)
			pages.Add(P)
		catalog_list.Add(G.name)

/datum/controller/subsystem/internal_wiki/proc/allow_reagent(var/reagent_id)
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)

	// This is used to filter out some of the base reagent types, such as admin only reagents
	if(!reagent_id || reagent_id == "" || reagent_id == REAGENT_ID_DEVELOPER_WARNING || reagent_id == REAGENT_ID_DRINK || reagent_id == REAGENT_DRUGS || reagent_id == REAGENT_ID_ADMINORDRAZINE)
		return FALSE
	return TRUE


////////////////////////////////////////////////////////////////////////////////////////////////
// PAGES AND THEIR CONSTRUCTION
////////////////////////////////////////////////////////////////////////////////////////////////
/datum/internal_wiki/page
	var/title = ""
	var/list/data = list()

/datum/internal_wiki/page/proc/assemble()
	return

/datum/internal_wiki/page/proc/get_data()
	RETURN_TYPE(/list)
	return data

/datum/internal_wiki/page/proc/get_print()
	return


// ORES
////////////////////////////////////////////
/datum/internal_wiki/page/ore/assemble(var/ore/O)
	title = O.display_name
	data["title"] = title
	var/obj/item/ore/ore_path = O.ore
	SSinternal_wiki.add_icon(data, initial(ore_path.icon), initial(ore_path.icon_state), "#ffffff")
	// Get internal data
	data["smelting"] = null
	if(O.smelts_to)
		var/datum/material/S = get_material_by_name(O.smelts_to)
		data["smelting"] = S.display_name

	data["compressing"] = null
	if(O.compresses_to)
		var/datum/material/C = get_material_by_name(O.compresses_to)
		data["compressing"] = C.display_name

	data["alloys"] = null
	if(O.alloy)
		var/list/alloy_list = list()
		for(var/datum/alloy/A in GLOB.alloy_data)
			for(var/req in A.requires)
				if(O.name == req )
					var/datum/material/M = get_material_by_name(A.metaltag)
					alloy_list.Add(M.display_name)
					break
		data["alloys"] = alloy_list

	data["pump_reagent"] = null
	if(O.reagent)
		var/datum/reagent/REG = SSchemistry.chemical_reagents[O.reagent]
		data["pump_reagent"] = REG.name

	data["grind_reagents"] = null
	if(global.ore_reagents[O.ore])
		var/list/output = global.ore_reagents[O.ore]
		var/list/collect = list()
		var/total_parts = 0
		for(var/Rid in output)
			var/datum/reagent/CBR = SSchemistry.chemical_reagents[Rid]
			if(!collect[CBR.name])
				collect[CBR.name] = 0
			collect[CBR.name] += 1
			total_parts += 1

		var/per_part = REAGENTS_PER_SHEET / total_parts
		var/list/grind_list = list()
		for(var/N in collect)
			grind_list[N] = "[collect[N] * per_part]"
		data["grind_reagents"] = grind_list

/datum/internal_wiki/page/ore/get_print()
	var/body = ""
	if(data["smelting"])
		body += "<b>Smelting: [data["smelting"]]</b><br>"
	if(data["compressing"])
		body += "<b>Compressing: [data["compressing"]]</b><br>"
	if(data["alloys"])
		body += "<br>"
		body += "<b>Alloy Component of: </b><br>"
		var/list/alloy_list = data["alloys"]
		for(var/A in alloy_list)
			body += "<b>-[A]</b><br>"
	else
		body += "<br>"
		body += "<b>No known Alloys</b><br>"
	if(data["pump_reagent"])
		body += "<br>"
		body += "<b>Fluid Pump Results:</b><br>"
		body += "<b>-[data["pump_reagent"]]</b><br>"
	if(data["grind_reagents"])
		body += "<br>"
		body += "<b>Ore Grind Results: </b><br>"
		var/list/grind_list = data["grind_reagents"]
		for(var/A in grind_list)
			body += "<b>-[A]: [grind_list[A]]u</b><br>"
	return body

// MATERIALS
////////////////////////////////////////////
/datum/internal_wiki/page/material/assemble(var/datum/material/M)
	title = M.display_name + " "  + M.sheet_singular_name
	data["title"] = title
	var/obj/item/stack/stack_path = M.stack_type
	SSinternal_wiki.add_icon(data, initial(stack_path.icon), initial(stack_path.icon_state), initial(M.icon_colour))
	// Get internal data
	data["integrity"] = M.integrity
	data["hardness"] = M.hardness
	data["weight"] = M.weight
	data["stack_size"] = initial(stack_path.max_amount) ? initial(stack_path.max_amount) : 0
	var/supply_value = M.supply_conversion_value ? M.supply_conversion_value : 0
	data["supply_points"] = supply_value
	var/value = supply_value * SSsupply.points_per_money
	value = FLOOR(value * 100, 1) / 100 // Truncate decimals
	data["market_price"] = value

	data["opacity"] = M.opacity
	data["conductive"] = M.conductive
	data["protectiveness"] = M.protectiveness
	data["explosion_resistance"] = M.explosion_resistance
	data["radioactivity"] = M.radioactivity
	data["reflectivity"] = M.reflectivity
	data["melting_point"] = M.melting_point
	data["ignition_point"] = M.ignition_point

	data["grind_reagents"] = null
	if(global.sheet_reagents[M.stack_type])
		var/list/output = global.sheet_reagents[M.stack_type]
		if(output && output.len > 0)
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
				var/list/grind_list = list()
				for(var/N in collect)
					grind_list[N] = "[collect[N] * per_part]"
				data["grind_reagents"] = grind_list

	data["recipies"] = null
	M.get_recipes() // generate if not already
	if(M.recipes != null && M.recipes.len > 0)
		var/list/recipie_list = list()
		for(var/datum/stack_recipe/R in M.recipes)
			recipie_list.Add(R.title)
		data["recipies"] = recipie_list

/datum/internal_wiki/page/material/get_print()
	var/body = ""
	body += "<b>Integrity: [data["integrity"]]</b><br>"
	body += "<b>Hardness: [data["hardness"]]</b><br>"
	body += "<b>Weight: [data["weight"]]</b><br>"
	var/points = data["supply_points"]
	var/stack_size = data["stack_size"]
	body += "<b>Supply Points: [points] per sheet, [points * stack_size] per stack of [stack_size]</b><br>"
	var/value = data["market_price"]
	body += "<b>Market Price: [value] [value > 1 ? "thalers" : "thaler"] per sheet  |  [(value*stack_size)] [(value*stack_size) > 1 ? "thalers" : "thaler"] per stack of [stack_size]</b><br>"
	body += "<br>"
	body += "<b>Transparent: [data["opacity"] >= 0.5 ? "No" : "Yes"]</b><br>"
	body += "<b>Conductive: [data["conductive"] ? "Yes" : "No"]</b><br>"
	body += "<b>Stability: [data["protectiveness"]]</b><br>"
	body += "<b>Blast Res.: [data["explosion_resistance"]]</b><br>"
	body += "<b>Radioactivity: [data["radioactivity"]]</b><br>"
	body += "<b>Reflectivity: [data["reflectivity"] * 100]%</b><br>"
	body += "<br>"
	if(data["melting_point"] > 0)
		body += "<b>Melting Point: [data["melting_point"]]K ([data["melting_point"] - T0C]C)</b><br>"
	else
		body += "<b>Melting Point: --- </b><br>"

	if(data["ignition_point"] > 0)
		body += "<b>Ignition Point: [data["ignition_point"]]K ([data["ignition_point"] - T0C]C)</b><br>"
	else
		body += "<b>Ignition Point: --- </b><br>"
	if(data["grind_reagents"])
		body += "<br>"
		var/list/grind_list = data["grind_reagents"]
		if(grind_list && grind_list.len > 0)
			body += "<b>Sheet Grind Results: </b><br>"
			for(var/N in grind_list)
				body += "<b>-[N]: [grind_list[N]]u</b><br>"
	if(data["recipies"])
		body += "<br>"
		var/list/recipie_list = data["recipies"]
		body += "<b>Recipies: </b><br>"
		for(var/R in recipie_list)
			body += "<b>-[R]</b><br>"
	return body

// SEEDS
////////////////////////////////////////////
/datum/internal_wiki/page/seed/assemble(var/datum/seed/S)
	title = S.display_name
	data["title"] = title
	SSinternal_wiki.add_icon(data, 'icons/obj/hydroponics_growing.dmi', "[S.get_trait(TRAIT_PLANT_ICON)]-[S.growth_stages]", S.get_trait(TRAIT_PLANT_COLOUR))
	// Get internal data
	data["feeding"] = S.get_trait(TRAIT_REQUIRES_NUTRIENTS)
	data["watering"] = S.get_trait(TRAIT_REQUIRES_WATER)
	data["lighting"] = S.get_trait(TRAIT_IDEAL_LIGHT)
	data["crop_yield"] = S.get_trait(TRAIT_YIELD)

	var/list/traits = list()
	if(S.has_item_product)
		traits.Add("Grown Byproducts")
	if(S.chems && !isnull(S.chems["woodpulp"]))
		traits.Add("Wooden Growths")
	if(S.get_trait(TRAIT_FLESH_COLOUR))
		traits.Add("Choppable")
	if(S.kitchen_tag == "pumpkin")
		traits.Add("Carvable")
	if(S.kitchen_tag == "potato")
		traits.Add("Sliceable")
	if(S.get_trait(TRAIT_JUICY))
		traits.Add("Juicy")
	if(S.get_trait(TRAIT_IMMUTABLE))
		traits.Add("Stable Genome")
	if(S.get_trait(TRAIT_PRODUCES_POWER))
		traits.Add("Voltaic")
	if(S.get_trait(TRAIT_BIOLUM))
		traits.Add("Bioluminescence")
	if(S.get_trait(TRAIT_STINGS))
		traits.Add("Stings")
	if(S.get_trait(TRAIT_SPORING))
		traits.Add("Produces Spores")
	if(S.get_trait(TRAIT_CARNIVOROUS))
		traits.Add("Carnivorous")
	if(S.get_trait(TRAIT_PARASITE))
		traits.Add("Parasitic")
	if(S.get_trait(TRAIT_SPREAD))
		traits.Add("Spreading")
	if(S.get_trait(TRAIT_EXPLOSIVE))
		traits.Add("Explosive")
	if(!traits.len)
		traits.Add("None")
	data["traits"] = traits
	data["mob_product"] = S.has_mob_product

	data["chem_breakdown"] = null
	if(S.chems && S.chems.len > 0)
		var/list/chems = list()
		for(var/CB in S.chems)
			var/datum/reagent/CBR = SSchemistry.chemical_reagents[CB]
			if(CBR)
				chems.Add(CBR.name)
			else
				log_runtime(EXCEPTION("Invalid reagent id: [CB] in chemical breakdown for seed [title]"))
		data["chem_breakdown"] = chems

	data["gas_consumed"] = null
	if(S.consume_gasses && S.consume_gasses.len > 0)
		var/list/consumed = list()
		for(var/CG in S.consume_gasses)
			consumed["[gas_data.name[CG]]"] = S.consume_gasses[CG]
		data["gas_consumed"] = consumed

	data["gas_exuded"] = null
	if(S.exude_gasses && S.exude_gasses.len > 0)
		var/list/exude = list()
		for(var/EG in S.exude_gasses)
			exude["[gas_data.name[EG]]"] = S.exude_gasses[EG]
		data["gas_exuded"] = exude

	data["mutations"] = null
	if(S.mutants && S.mutants.len > 0)
		var/list/mutations = list()
		for(var/MS in S.mutants)
			var/datum/seed/mut = SSplants.seeds[MS]
			if(mut)
				mutations.Add(mut.display_name)
		data["mutations"] = mutations

/datum/internal_wiki/page/seed/get_print()
	var/body = ""
	body  += "<b>Requires Feeding: [data["feeding"] ? "YES" : "NO"]</b><br>"
	body  += "<b>Requires Watering: [data["watering"] ? "YES" : "NO"]</b><br>"
	body  += "<b>Requires Light: [data["lighting"]] lumen[data["lighting"] == 1 ? "" : "s"]</b><br>"
	if(data["crop_yield"] > 0)
		body  += "<b>Yield: [data["crop_yield"]]</b><br>"
	body  += "<br>"
	body  += "<b>Traits:</b><br>"
	var/list/traits = data["traits"]
	for(var/A in traits)
		body  += "<b>-[A]</b><br>"
	body  += "<br>"
	if(data["mob_product"])
		body += "<b>DANGER - MAY BE MOBILE</b><br>"
	body  += "<br>"
	var/list/chem_list = data["chem_breakdown"]
	if(chem_list && chem_list.len > 0)
		body  += "<b>Chemical Breakdown: </b><br>"
		for(var/CB in chem_list)
			body  += "<b>-[CB]</b><br>"
		body  += "<br>"
	var/list/consumed_list = data["gas_consumed"]
	if(consumed_list && consumed_list.len > 0)
		body  += "<b>Gasses Consumed: </b><br>"
		for(var/CG in consumed_list)
			var/amount = "[consumed_list[CG]]"
			if (consumed_list[CG] < 5)
				amount = "[CG] (trace amounts)"
			body  += "<b>-[amount]</b><br>"
		body  += "<br>"
	var/list/exuded_list = data["gas_exuded"]
	if(exuded_list && exuded_list.len > 0)
		body  += "<b>Gasses Produced: </b><br>"
		for(var/EG in exuded_list)
			var/amount = "[exuded_list[EG]]"
			if (exuded_list[EG] < 5)
				amount = "[EG] (trace amounts)"
			body  += "<b>-[amount]</b><br>"
		body  += "<br>"
	var/list/mutations = data["mutations"]
	if(mutations && mutations.len > 0)
		body += "<b>Mutant Strains: </b><br>"
		for(var/MS in mutations)
			body  += "<b>-[MS]</b><br>"
	return body

// PARTICLE SMASHER
////////////////////////////////////////////
/datum/internal_wiki/page/smasher/assemble(var/datum/particle_smasher_recipe/M)
	title = M.display_name
	data["title"] = title
	var/obj/item/stack/material/result_path = M.result
	var/datum/material/result_mat = get_material_by_name(initial(result_path.default_type))
	SSinternal_wiki.add_icon(data, initial(result_path.icon), initial(result_path.icon_state), initial(result_mat.icon_colour))
	// Get internal data
	var/obj/item/stack/req_mat = M.required_material
	data["req_mat"] = null
	if(req_mat != null)
		data["req_mat"] = initial(req_mat.name)

	data["target_items"] = null
	if(M.items && M.items.len > 0)
		var/list/targs = list()
		for(var/obj/Ir as anything in M.items)
			targs.Add(initial(Ir.name))
		data["target_items"] = targs

	data["required_energy_min"] = M.required_energy_min
	data["required_energy_max"] = M.required_energy_max
	data["required_atmos_temp_min"] = M.required_atmos_temp_min
	data["required_atmos_temp_max"] = M.required_atmos_temp_max

	data["inducers"] = null
	if(M.reagents != null && M.reagents.len > 0)
		var/list/inducers = list()
		for(var/R in M.reagents)
			var/amnt = M.reagents[R]
			var/datum/reagent/Rd = SSchemistry.chemical_reagents[R]
			if(Rd)
				inducers["[Rd.name]"] = amnt
			else
				log_runtime(EXCEPTION("Invalid reagent id: [Rd] in inducer for atom smasher [title]"))
		data["inducers"] = inducers
	data["result"] = initial(result_path.name)
	data["probability"] = M.probability

/datum/internal_wiki/page/smasher/get_print()
	var/body = ""
	if(data["req_mat"] != null)
		body += "<b>Target Sheet: [data["req_mat"]]</b><br>"
	var/list/targ_items = data["target_items"]
	if(targ_items && targ_items.len > 0)
		for(var/Ir in targ_items)
			body += "<b>-[Ir]</b><br>"
	body += "<b>Threshold Energy: [data["required_energy_min"]] - [data["required_energy_max"]]</b><br>"
	body += "<b>Threshold Temp: [data["required_atmos_temp_min"]]k - [data["required_atmos_temp_max"]]k | ([data["required_atmos_temp_min"] - T0C]C - [data["required_atmos_temp_max"] - T0C]C)</b><br>"
	var/list/inducers = data["inducers"]
	if(inducers && inducers.len > 0)
		body += "<br>"
		body += "<b>Inducers: </b><br>"
		for(var/R in inducers)
			body += "<b>-[R] [inducers[R]]u</b><br>"
	body += "<br>"
	body += "<b>Results: [data["result"]]</b><br>"
	body += "<b>Probability: [data["probability"]]%</b><br>"
	return body


// CHEMICALS
////////////////////////////////////////////
/datum/internal_wiki/page/chemical/assemble(var/datum/reagent/R)
	title = R.name
	data["title"] = title
	var/obj/item/reagent_containers/glass/beaker/large/beaker_path = /obj/item/reagent_containers/glass/beaker/large
	SSinternal_wiki.add_icon(data, initial(beaker_path.icon), initial(beaker_path.icon_state), R.color)
	// Get internal data
	data["description"] = R.description
	/* Downstream features
	data["addictive"] = 0
	if(R.id in addictives)
		data["addictive"] = (R.id in fast_addictives) ? 2 : 1
	data["industrial_use"] = R.industrial_use
	data["supply_points"] = R.supply_conversion_value ? R.supply_conversion_value : 0
	var/value = R.supply_conversion_value * REAGENTS_PER_SHEET * SSsupply.points_per_money
	value = FLOOR(value * 100,1) / 100 // Truncate decimals
	data["market_price"] = value
	data["sintering"] = global.reagent_sheets[R.id]
	*/
	data["overdose"] = R.overdose
	data["flavor"] = R.taste_description
	data["allergen"] = SSinternal_wiki.assemble_allergens(R.allergen_type)
	SSinternal_wiki.assemble_reaction_data(data, R)

/datum/internal_wiki/page/chemical/get_print()
	var/body = ""
	body += "<b>Description: </b>[data["description"]]<br>"
	/* Downstream features
	if(data["addictive"])
		body += "<b>DANGER, [data["addictive"] > 1 ? "highly " : ""]addictive.</b><br>"
	if(data["industrial_use"])
		body  += "<b>Industrial Use: </b>[data["industrial_use"]]<br>"
	var/tank_size = CARGOTANKER_VOLUME
	body += "<b>Supply Points: [data["supply_points"]] per unit, [data["supply_points"] * tank_size] per [tank_size] tank</b><br>"
	var/value = data["market_price"]
	if(value > 0)
		body += "<b>Market Price: [value] [value > 1 ? "thalers" : "thaler"] per [REAGENTS_PER_SHEET] units  |  [(value*tank_size)] [(value*tank_size) > 1 ? "thalers" : "thaler"] per [tank_size] unit tank</b><br>"
	if(data["sintering"])
		var/mat_id = data["sintering"]
		switch(mat_id)
			if("FLAG_SMOKE")
				body += "<b>Sintering Results: COMBUSTION</b><br>"
			if("FLAG_EXPLODE")
				body += "<b>Sintering Results: DETONATION</b><br>"
			if("FLAG_SPIDERS")
				body += "<b>Sintering Results: DO NOT EVER</b><br>"
			else
				var/datum/material/C = get_material_by_name(data["sintering"])
				body += "<b>Sintering Results: [C.display_name] [C.sheet_plural_name]</b><br>"
	*/
	if(data["overdose"] > 0)
		body += "<b>Overdose: </b>[data["overdose"]]u<br>"
	body += "<b>Flavor: </b>[data["flavor"]]<br>"
	body += "<br>"
	body += print_allergens(data["allergen"])
	body += "<br>"
	body += print_reaction_data(data)
	return body

// FOOD REAGENTS
////////////////////////////////////////////
/datum/internal_wiki/page/food/assemble(var/datum/reagent/R)
	title = R.name
	data["title"] = title
	var/obj/item/reagent_containers/glass/beaker/large/beaker_path = /obj/item/reagent_containers/glass/beaker/large
	SSinternal_wiki.add_icon(data, initial(beaker_path.icon), initial(beaker_path.icon_state), R.color)
	// Get internal data
	data["description"] = R.description
	data["flavor"] = R.taste_description
	data["allergen"] = SSinternal_wiki.assemble_allergens(R.allergen_type)
	SSinternal_wiki.assemble_reaction_data(data, R)

/datum/internal_wiki/page/food/get_print()
	var/body = ""
	body += "<b>Description: </b>[data["description"]]<br>"
	body += "<br>"
	body += print_allergens(data["allergen"])
	body += "<br>"
	body += print_reaction_data(data)

// DRINK REAGENTS
////////////////////////////////////////////
/datum/internal_wiki/page/drink/assemble(var/datum/reagent/R)
	title = R.name
	data["title"] = title
	// Use beaker by default, otherwise try metamorphic glass for icon
	var/ico = 'icons/obj/drinks.dmi'
	if(R.glass_icon_file)
		ico = R.glass_icon_file
	var/sta = "glass_empty"
	if(R.glass_icon_state)
		sta = R.glass_icon_state
	SSinternal_wiki.add_icon(data, ico, sta, R.color)
	// Get internal data
	data["description"] = R.description
	data["flavor"] = R.taste_description
	data["allergen"] = SSinternal_wiki.assemble_allergens(R.allergen_type)
	SSinternal_wiki.assemble_reaction_data(data, R)

/datum/internal_wiki/page/drink/get_print()
	var/body = ""
	body += "<b>Description: </b>[data["description"]]<br>"
	body += "<b>Flavor: </b>[data["flavor"]]<br>"
	body += "<br>"
	body += print_allergens(data["allergen"])
	body += "<br>"
	body += print_reaction_data(data)
	return body

// FOOD RECIPIE
////////////////////////////////////////////
/datum/internal_wiki/page/recipe/assemble(var/list/recipe)
	title = recipe["Result"]
	data["title"] = title
	var/obj/item/path = recipe["ResultPath"]
	if(path)
		SSinternal_wiki.add_icon(data, initial(path.icon), initial(path.icon_state), "#ffffff")
	else
		var/obj/item/reagent_containers/glass/beaker/large/beaker_path = /obj/item/reagent_containers/glass/beaker/large
		SSinternal_wiki.add_icon(data, initial(beaker_path.icon), initial(beaker_path.icon_state), "#ffffff")
	// Get internal data
	data["description"] = recipe["Desc"]
	data["allergen"] = SSinternal_wiki.assemble_allergens(recipe["Allergens"])
	var/list/recipe_data = list()
	var/value = recipe["Price"] ? recipe["Price"] : 0
	recipe_data["supply_points"] = value
	value *= SSsupply.points_per_money // convert to cash
	value = FLOOR(value * 100,1) / 100 // Truncate decimals
	recipe_data["market_price"] = value
	recipe_data["appliance"] = recipe["Appliance"]
	recipe_data["has_coating"] = recipe["has_coatable_items"]
	recipe_data["coating"] = recipe["Coating"]
	if(!isnull(recipe_data["coating"]) && recipe_data["coating"] != -1) // Null is no coatings, -1 is any coating, otherwise specifies the name of coating
		var/datum/reagent/nutriment/coating/coatingtype = recipe["Coating"]
		recipe_data["coating"] = initial(coatingtype.name)
	var/list/ingred = list()
	for(var/ing in recipe["Ingredients"])
		ingred["[ing]"] = recipe["Ingredients"][ing]
	recipe_data["ingredients"] = ingred.len ? ingred : null
	var/list/fruits = list()
	for(var/fru in recipe["Fruit"])
		fruits["[fru]"] = recipe["Fruit"][fru]
	recipe_data["fruits"] = fruits.len ? fruits : null
	var/list/reagents = list()
	for(var/rea in recipe["Reagents"])
		reagents["[rea]"] = recipe["Reagents"][rea]
	recipe_data["reagents"] = reagents.len ? reagents : null
	var/list/catalysts = list()
	for(var/cat in recipe["Catalysts"])
		catalysts["[cat]"] = recipe["Catalysts"][cat]
	recipe_data["catalysts"] = catalysts.len ? catalysts : null
	data["recipe"] = recipe_data

/datum/internal_wiki/page/recipe/get_print()
	var/body = ""
	if(data["description"])
		body += "<b>Description: </b>[data["description"]]<br>"
	if(data["recipe"]["supply_points"] > 0)
		var/value = data["recipe"]["supply_points"]
		body += "<b>Supply Points: </b>[value]<br>"
	if(data["recipe"]["market_price"] > 0)
		var/value = data["recipe"]["market_price"]
		body += "<b>Market Price: [value] [value > 1 ? "thalers" : "thaler"]</b><br>"
	body += print_allergens(data["allergen"])
	body += "<br>"
	if(data["recipe"]["appliance"])
		body += "<b>Appliance: </b>[data["recipe"]["appliance"]]<br><br>"
	// ingredients
	var/list/ingreds = data["recipe"]["ingredients"]
	if(ingreds && ingreds.len)
		var/count = 0
		var/pretty_ing = ""
		for(var/ing in ingreds)
			pretty_ing += "[count == 0 ? "" : ", "][ing]x [ingreds[ing]]"
			count++
		if(pretty_ing != "")
			body +=  "<b>Ingredients: </b>[pretty_ing]<br>"
	// Coatings
	if(!data["recipe"]["has_coating"])
		body += "<b>Coating: </b>N/A, no coatable items<br>"
	else if(isnull(data["recipe"]["coating"]))
		body += "<b>Coating: </b> Must be uncoated<br>"
	else if(data["recipe"]["coating"] == -1)
		body += "<b>Coating: </b>Optionally, any coating<br>"
	else
		body += "<b>Coating: </b> [data["recipe"]["coating"]]<br>"
	// Fruits/Veggis
	var/list/fruits = data["recipe"]["fruits"]
	if(fruits && fruits.len) // Can't use lazylen, assoc list
		var/count = 0
		var/pretty_fru = ""
		for(var/fru in fruits)
			pretty_fru += "[count == 0 ? "" : ", "][fru]x [fruits[fru]]"
			count++
		if(pretty_fru != "")
			body += "<b>Components: </b> [pretty_fru]<br>"
	//For each reagent
	var/list/reags = data["recipe"]["reagents"]
	if(reags && reags.len) // Can't use lazylen, assoc list
		var/count = 0
		var/pretty_rea = ""
		for(var/reg in reags)
			pretty_rea += "[count == 0 ? "" : ", "][reg] [reags[reg]]u"
			count++
		if(pretty_rea != "")
			body += "<b>Mix in: </b> [pretty_rea]<br>"
	//For each catalyst
	var/list/catalis = data["recipe"]["catalysts"]
	if(catalis && catalis.len) // Can't use lazylen, assoc list
		var/count = 0
		var/pretty_cat = ""
		for(var/cat in catalis)
			pretty_cat += "[count == 0 ? "" : ", "][cat] [catalis[cat]]u"
			count++
		if(pretty_cat != "")
			body += "<b>Catalysts: </b> [pretty_cat]<br>"
	return body

// CATALOG
////////////////////////////////////////////
/datum/internal_wiki/page/catalog
	var/datum/category_item/catalogue/catalog_record = null

/datum/internal_wiki/page/catalog/assemble()
	data["name"] = catalog_record.name
	data["desc"] = catalog_record.desc

// MISC HELPERS
////////////////////////////////////////////
/datum/internal_wiki/page/proc/print_allergens(var/list/allergens)
	PROTECTED_PROC(TRUE)
	var/AG = ""
	if(allergens && allergens.len > 0)
		AG += "<b>Allergens: </b><br>"
		for(var/ALGY in allergens)
			AG += "-[ALGY]<br>"
		AG += "<br>"
	return AG

/datum/internal_wiki/page/proc/print_reaction_data(var/list/data)
	var/body = ""
	var/list/instant = data["instant_reactions"]
	if(instant && instant.len > 0)
		var/segment = 1
		for(var/list/react in instant)
			if(instant.len == 1)
				body += "<b>Potential Chemical breakdown: </b><br>"
			else
				body += "<b>Potential Chemical breakdown [segment]: </b><br>"
				segment++
			if(react["is_slime"])
				for(var/RQ in react["required"])
					body += " <b>-[react["is_slime"]] Injection: </b>[RQ]<br>"
			else
				for(var/RQ in react["required"])
					body += " <b>-Component: </b>[RQ]<br>"
			for(var/IH in react["inhibitor"])
				body += " <b>-Inhibitor: </b>[IH]<br>"
			for(var/CL in react["catalysts"])
				body += " <b>-Catalyst: </b>[CL]<br>"
	else
		body += "<b>Potential Chemical breakdown: </b><br>UNKNOWN OR BASE-REAGENT<br>"

	var/list/distilled = data["distilled_reactions"]
	if(distilled && distilled.len > 0)
		var/segment = 1
		for(var/list/react in distilled)
			if(distilled.len == 1)
				body += "<b>Potential Chemical breakdown: </b><br>"
			else
				body += "<b>Potential Chemical breakdown [segment]: </b><br>"
				segment++
			/* Downstream features
			body += " <b>-Temperature: </b> [react["xgm_min"]]K - [react["xgm_max"]]K | ([react["xgm_min"] - T0C]C - [react["xgm_max"] - T0C]C)<br>"
			if(react["require_xgm_gas"])
				body += " <b>-Requires Gas: </b> [react["require_xgm_gas"])]<br>"
			if(react["rejects_xgm_gas"])
				body += " <b>-Rejects Gas: </b> [react["rejects_xgm_gas"]]<br>"
			*/
			for(var/RQ in react["required"])
				body += " <b>-Component: </b>[RQ]<br>"
			for(var/IH in react["inhibitor"])
				body += " <b>-Inhibitor: </b>[IH]<br>"
			for(var/CL in react["catalysts"])
				body += " <b>-Catalyst: </b>[CL]<br>"

	var/list/grind_ore = data["grinding"]["ore"]
	if(grind_ore && grind_ore.len)
		body += "<br>"
		body += "<b>Ore processing results: </b><br>"
		for(var/PL in grind_ore)
			body += " <b>-Grind: </b>[PL]<br>"

	var/list/grind_mats = data["grinding"]["material"]
	if(grind_mats && grind_mats.len)
		body += "<br>"
		body += "<b>Material processing results: </b><br>"
		for(var/PL in grind_mats)
			body += " <b>-Grind: </b>[PL]<br>"

	var/list/grind_plants = data["grinding"]["plant"]
	if(grind_plants && grind_plants.len)
		body += "<br>"
		body += "<b>Organic processing results: </b><br>"
		for(var/PL in grind_plants)
			body += " <b>-Grind: </b>[PL]<br>"

	var/list/fluid_pumping = data["fluid"]
	if(fluid_pumping && fluid_pumping.len)
		body += "<br>"
		body += "<b>Fluid pump results: </b><br>"
		for(var/PL in fluid_pumping)
			body += " <b>-Erosion: </b>[PL]<br>"

	body += "<br>"
	var/list/produces = data["produces"]
	if(produces && produces.len)
		body += "<b>Is a component of: </b><br>"
		for(var/PL in produces)
			body += "-[PL]<br>"
	return body
