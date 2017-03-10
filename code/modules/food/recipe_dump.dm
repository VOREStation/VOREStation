/client/proc/recipe_dump()
	set name = "Generate Recipe Dump"
	set category = "Server"
	set desc = "Dumps food recipe info and images for wiki or other use."

	if(!holder)
		return

	var/list/recipe_paths = typesof(/datum/recipe) - /datum/recipe
	//Build a useful list
	for(var/Rp in recipe_paths)
		//Lists don't work with datum-stealing no-instance initial() so we have to.
		var/datum/recipe/R = new Rp()
		var/obj/res = new R.result()

		var/icon/result_icon = icon(res.icon,res.icon_state)
		result_icon.Scale(64,64)

		recipe_paths[Rp] = list(
						"Result" = "[res.name]",
						"Reagents" = R.reagents,
						"Fruit" = R.fruit,
						"Ingredients" = R.items,
						"Image" = result_icon
						)

		qdel(res)
		qdel(R)

		//Items needs further processing into human-readability. Another use of initial.
		var/working_ing_list = list()
		for(var/I in recipe_paths[Rp]["Ingredients"])
			var/atom/ing = new I()

			//So now we add something like "Bread" = 3
			if(ing.name in working_ing_list)
				working_ing_list[ing.name] = working_ing_list[ing.name]++
			else
				working_ing_list[ing.name] = 1

		recipe_paths[Rp]["Ingredients"] = working_ing_list

		//Reagents can be resolved to nicer names as well
		for(var/rid in recipe_paths[Rp]["Reagents"])
			var/datum/reagent/Rd = chemical_reagents_list[rid]
			var/R_name = Rd.name
			recipe_paths[Rp]["Reagents"][R_name] += recipe_paths[Rp]["Reagents"][rid]
			recipe_paths[Rp]["Reagents"] -= rid

	//Sort list by transforming into resultname+unique = path, then back in the right order
	//Can't just be sorted by resultname since they are not unique and lists indexed by that will
	//end up overwriting the several ways to make something with a single one
	var/list/names_to_paths = list()
	for(var/Rp in recipe_paths)
		names_to_paths["[recipe_paths[Rp]["Result"]] [Rp]"] = Rp //Append recipe datum path to keep uniqueness

	names_to_paths = sortAssoc(names_to_paths)

	var/list/newly_sorted = list()
	for(var/Rr in names_to_paths)
		var/Rp = names_to_paths[Rr]
		newly_sorted[Rp] = recipe_paths[Rp]

	recipe_paths = newly_sorted

	//Produce Output
	var/html = "<head>\
				<meta charset='utf-8'>\
				<meta http-equiv='X-UA-Compatible' content='IE=edge'>\
				<meta http-equiv='content-language' content='en-us' />\
				<meta name='viewport' content='width=device-width, initial-scale=1'>\
				<title>Food Recipes</title>\
				<link rel='stylesheet' href='recipes.css' />\
				</head>"

	html += "<html><body><h3>Recipes (as of [time2text(world.realtime,"MMM DD, YYYY")])</h3><br>"
	html += "<table class='recipes'>"
	html += "<tr><th>Icon</th><th>Name</th><th>Ingredients</th></tr>"
	for(var/Rp in recipe_paths)
		//Open this row
		html += "<tr>"

		//Image
		var/image_path = "recipe-[ckey(recipe_paths[Rp]["Result"])].png"
		var/icon/icon_to_give = recipe_paths[Rp]["Image"]
		html += "<td><img src='imgrecipes/[image_path]' /></td>"
		src << browse(icon_to_give, "window=picture;file=[image_path];display=0")

		//Name
		html += "<td><b>[recipe_paths[Rp]["Result"]]</b></td>"

		//Ingredients
		html += "<td><ul>"
		var/count //For those commas. Not sure of a great other way to do it.
		//For each large ingredient
		var/pretty_ing = ""
		count = 0
		for(var/ing in recipe_paths[Rp]["Ingredients"])
			pretty_ing += "[count == 0 ? "" : ", "][recipe_paths[Rp]["Ingredients"][ing]]x [ing]"
			count++
		if(pretty_ing != "")
			html += "<li><b>Ingredients:</b> [pretty_ing]</li>"

		//For each fruit
		var/pretty_fru = ""
		count = 0
		for(var/fru in recipe_paths[Rp]["Fruit"])
			pretty_fru += "[count == 0 ? "" : ", "][recipe_paths[Rp]["Fruit"][fru]]x [fru]"
			count++
		if(pretty_fru != "")
			html += "<li><b>Fruit:</b> [pretty_fru]</li>"

		//For each reagent
		var/pretty_rea = ""
		count = 0
		for(var/rea in recipe_paths[Rp]["Reagents"])
			pretty_rea += "[count == 0 ? "" : ", "][recipe_paths[Rp]["Reagents"][rea]]u [rea]"
			count++
		if(pretty_rea != "")
			html += "<li><b>Mix in:</b> [pretty_rea]</li>"

		//Close ingredients
		html += "</ul></td>"
		//Close this row
		html += "</tr>"

	html += "</table></body></html>"
	src << browse(html, "window=recipes;file=recipes.html;display=0")
	src << "<span class='notice'>In your byond cache, recipe-xxx.png files and recipes.html now exist. Place recipe-xxx.png files in a subfolder named 'imgrecipes' wherever you put them. The file will take a recipes.css file if in the same path.</span>"
