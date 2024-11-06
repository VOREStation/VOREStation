/client/proc/recipe_dump()
	set name = "Generate Recipe Dump"
	set category = "Server.Admin"
	set desc = "Dumps food and drink recipe info and images for wiki or other use."

	if(!holder)
		return

	//////////////////////// DRINK
	var/list/drink_recipes = list()
	for(var/decl/chemical_reaction/instant/drinks/CR in SSchemistry.chemical_reactions)
		drink_recipes[CR.type] = list("Result" = CR.name,
        						"ResAmt" = CR.result_amount,
        						"Reagents" = CR.required_reagents,
								"Catalysts" = CR.catalysts)

	//////////////////////// FOOD
	var/list/food_recipes = subtypesof(/datum/recipe)
	//Build a useful list
	for(var/Rp in food_recipes)
		//Lists don't work with datum-stealing no-instance initial() so we have to.
		var/datum/recipe/R = new Rp()
		var/obj/res = new R.result()

		var/icon/result_icon = icon(res.icon,res.icon_state)
		result_icon.Scale(64,64)

		food_recipes[Rp] = list(
						"Result" = "[res.name]",
						"ResAmt" = "1",
						"Reagents" = R.reagents,
						"Catalysts" = list(),
						"Fruit" = R.fruit,
						"Ingredients" = R.items,
						"Coating" = R.coating,
						"Appliance" = R.appliance,
						"Image" = result_icon
						)

		qdel(res)
		qdel(R)

	//////////////////////// FOOD+ (basically condiments, tofu, cheese, soysauce, etc)
	for(var/decl/chemical_reaction/instant/food/CR in SSchemistry.chemical_reactions)
		food_recipes[CR.type] = list("Result" = CR.name,
								"ResAmt" = CR.result_amount,
								"Reagents" = CR.required_reagents,
								"Catalysts" = CR.catalysts,
								"Fruit" = list(),
								"Ingredients" = list(),
								"Image" = null)

	//////////////////////// PROCESSING
	//Items needs further processing into human-readability.
	for(var/Rp in food_recipes)
		var/working_ing_list = list()
		food_recipes[Rp]["has_coatable_items"] = FALSE
		for(var/I in food_recipes[Rp]["Ingredients"])
			var/atom/ing = new I()
			if(istype(ing, /obj/item/reagent_containers/food/snacks)) // only subtypes of this have a coating variable and are checked for it (fruit are a subtype of this, so there's a check for them too later)
				food_recipes[Rp]["has_coatable_items"] = TRUE

			//So now we add something like "Bread" = 3
			if(ing.name in working_ing_list)
				var/sofar = working_ing_list[ing.name]
				working_ing_list[ing.name] = sofar+1
			else
				working_ing_list[ing.name] = 1

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

	//////////////////////// OUTPUT
	//Food Output
	var/html = "<head>\
				<meta charset='utf-8'>\
				<meta http-equiv='X-UA-Compatible' content='IE=edge'>\
				<meta http-equiv='content-language' content='en-us' />\
				<meta name='viewport' content='width=device-width, initial-scale=1'>\
				<title>Food Recipes</title>\
				<link rel='stylesheet' href='food.css' />\
				</head>"

	html += "<html><body><h3>Food Recipes (as of [time2text(world.realtime,"MMM DD, YYYY")])</h3><br>"
	html += "<table class='recipes'>"
	html += "<tr><th>Icon</th><th>Name</th><th>Appliance</th><th>Ingredients</th></tr>"
	for(var/Rp in food_recipes)
		//Open this row
		html += "<tr>"

		//Image
		var/icon/icon_to_give = food_recipes[Rp]["Image"]
		if(icon_to_give)
			var/image_path = "recipe-[ckey(food_recipes[Rp]["Result"])].png"
			html += "<td><img src='imgrecipes/[image_path]' /></td>"
			src << browse(icon_to_give, "window=picture;file=[image_path];display=0")
		else
			html += "<td>No<br>Image</td>"

		//Name
		html += "<td><b>[food_recipes[Rp]["Result"]]</b></td>"

		//Appliance
		html += "<td><b>[food_recipes[Rp]["Appliance"]]</b></td>"

		//Ingredients
		html += "<td><ul>"
		var/count //For those commas. Not sure of a great other way to do it.
		//For each large ingredient
		var/pretty_ing = ""
		count = 0
		for(var/ing in food_recipes[Rp]["Ingredients"])
			pretty_ing += "[count == 0 ? "" : ", "][food_recipes[Rp]["Ingredients"][ing]]x [ing]"
			count++
		if(pretty_ing != "")
			html += "<li><b>Ingredients:</b> [pretty_ing]</li>"

		//Coating
		if(!food_recipes[Rp]["has_coatable_items"])
			html += "<span class = \"coating coating_not_applicable\"><li><b>Coating:</b> N/A, no coatable items</li></span>"
			// css can be used to style or hide these depending on the class.  This has two classes
			// coating and coating_not_applicable, which can each have styles applied.
		else if(food_recipes[Rp]["Coating"] == -1)
			html += "<span class = \"coating coating_any_coating\"><li><b>Coating:</b> Optionally, any coating</li></span>"
		else if(isnull(food_recipes[Rp]["Coating"]))
			html += "<span class = \"coating coating_uncoated\"><li><b>Coating:</b> Must be uncoated</li></span>"
		else
			var/coatingtype = food_recipes[Rp]["Coating"]
			var/datum/reagent/coating = new coatingtype()
			html += "<span class = \"coating coating_specific_coating\"><li><b>Coating:</b> [coating.name]</li></span>"

		//For each fruit
		var/pretty_fru = ""
		count = 0
		for(var/fru in food_recipes[Rp]["Fruit"])
			pretty_fru += "[count == 0 ? "" : ", "][food_recipes[Rp]["Fruit"][fru]]x [fru]"
			count++
		if(pretty_fru != "")
			html += "<li><b>Fruit:</b> [pretty_fru]</li>"

		//For each reagent
		var/pretty_rea = ""
		count = 0
		for(var/rea in food_recipes[Rp]["Reagents"])
			pretty_rea += "[count == 0 ? "" : ", "][food_recipes[Rp]["Reagents"][rea]]u [rea]"
			count++
		if(pretty_rea != "")
			html += "<li><b>Mix in:</b> [pretty_rea]</li>"

		//For each catalyst
		var/pretty_cat = ""
		count = 0
		for(var/cat in food_recipes[Rp]["Catalysts"])
			pretty_cat += "[count == 0 ? "" : ", "][food_recipes[Rp]["Catalysts"][cat]]u [cat]"
			count++
		if(pretty_cat != "")
			html += "<li><b>Catalysts:</b> [pretty_cat]</li>"

		//Close ingredients
		html += "</ul></td>"
		//Close this row
		html += "</tr>"

	html += "</table></body></html>"
	src << browse(html, "window=recipes;file=recipes_food.html;display=0")

	//Drink Output
	html = "<head>\
			<meta charset='utf-8'>\
			<meta http-equiv='X-UA-Compatible' content='IE=edge'>\
			<meta http-equiv='content-language' content='en-us' />\
			<meta name='viewport' content='width=device-width, initial-scale=1'>\
			<title>Drink Recipes</title>\
			<link rel='stylesheet' href='drinks.css' />\
			</head>"

	html += "<html><body><h3>Drink Recipes (as of [time2text(world.realtime,"MMM DD, YYYY")])</h3><br>"
	html += "<table class='recipes'>"
	html += "<tr><th>Name</th><th>Ingredients</th></tr>"
	for(var/Rp in drink_recipes)
		//Open this row
		html += "<tr>"

		//Name
		html += "<td><b>[drink_recipes[Rp]["Result"]]</b></td>"

		html += "<td>"
		//For each reagent
		var/pretty_rea = ""
		var/count = 0
		for(var/rea in drink_recipes[Rp]["Reagents"])
			pretty_rea += "[count == 0 ? "" : ", "][drink_recipes[Rp]["Reagents"][rea]]u [rea]"
			count++
		if(pretty_rea != "")
			html += "<li><b>Mix together:</b> [pretty_rea]</li>"

		//For each catalyst
		var/pretty_cat = ""
		count = 0
		for(var/cat in drink_recipes[Rp]["Catalysts"])
			pretty_cat += "[count == 0 ? "" : ", "][drink_recipes[Rp]["Catalysts"][cat]]u [cat]"
			count++
		if(pretty_cat != "")
			html += "<li><b>Catalysts:</b> [pretty_cat]</li>"

		html += "<li>Makes [drink_recipes[Rp]["ResAmt"]]u</li>"

		//Close reagents
		html += "</ul></td>"
		//Close this row
		html += "</tr>"

	html += "</table></body></html>"
	src << browse(html, "window=recipes;file=recipes_drinks.html;display=0")

	to_chat(src, span_notice("In your byond cache, recipe-xxx.png files and recipes_drinks.html and recipes_food.html now exist. Place recipe-xxx.png files in a subfolder named 'imgrecipes' wherever you put them. The file will take a food.css or drinks.css file if in the same path."))
