/decl/chemical_reaction/instant/food/hot_ramen
	name = "Hot Ramen"
	id = "hot_ramen"
	result = "hot_ramen"
	required_reagents = list("water" = 1, "dry_ramen" = 3)
	result_amount = 3

/decl/chemical_reaction/instant/food/hell_ramen
	name = "Hell Ramen"
	id = "hell_ramen"
	result = "hell_ramen"
	required_reagents = list("capsaicin" = 1, "hot_ramen" = 6)
	result_amount = 6

/decl/chemical_reaction/instant/food/tofu
	name = "Tofu"
	id = "tofu"
	result = null
	required_reagents = list("soymilk" = 10)
	catalysts = list("enzyme" = 5)
	result_amount = 1

/decl/chemical_reaction/instant/food/tofu/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/reagent_containers/food/snacks/tofu(location)
	return

/decl/chemical_reaction/instant/food/chocolate_bar
	name = "Chocolate Bar"
	id = "chocolate_bar"
	result = null
	required_reagents = list("soymilk" = 2, "coco" = 2, "sugar" = 2)
	catalysts = list("enzyme" = 5)
	result_amount = 1

/decl/chemical_reaction/instant/food/chocolate_bar/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/reagent_containers/food/snacks/chocolatebar(location)
	return

/decl/chemical_reaction/instant/food/chocolate_bar2
	name = "Chocolate Bar"
	id = "chocolate_bar"
	result = null
	required_reagents = list("milk" = 2, "coco" = 2, "sugar" = 2)
	catalysts = list("enzyme" = 5)
	result_amount = 1

/decl/chemical_reaction/instant/food/chocolate_bar2/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/reagent_containers/food/snacks/chocolatebar(location)
	return

/decl/chemical_reaction/instant/food/cookingoilcorn
	name = "Cooking Oil"
	id = "cookingoilcorn"
	result = "cookingoil"
	required_reagents = list("cornoil" = 10)
	catalysts = list("enzyme" = 5)
	result_amount = 10

/decl/chemical_reaction/instant/food/cookingoilpeanut
	name = "Cooking Oil"
	id = "cookingoilpeanut"
	result = "cookingoil"
	required_reagents = list("peanutoil" = 10)
	inhibitors = list("sugar" = 1, "sodiumchloride" = 1)
	catalysts = list("enzyme" = 5)
	result_amount = 10

/decl/chemical_reaction/instant/food/soysauce
	name = "Soy Sauce"
	id = "soysauce"
	result = "soysauce"
	required_reagents = list("soymilk" = 4, "sacid" = 1)
	result_amount = 5

/decl/chemical_reaction/instant/food/ketchup
	name = "Ketchup"
	id = "ketchup"
	result = "ketchup"
	required_reagents = list("tomatojuice" = 2, "water" = 1, "sugar" = 1)
	result_amount = 4

/decl/chemical_reaction/instant/food/barbecue
	name = "Barbeque Sauce"
	id = "barbecue"
	result = "barbecue"
	required_reagents = list("tomatojuice" = 2, "applejuice" = 1, "sugar" = 1, "spacespice" = 1)
	result_amount = 4

/decl/chemical_reaction/instant/food/peanutbutter
	name = "Peanut Butter"
	id = "peanutbutter"
	result = "peanutbutter"
	required_reagents = list("peanutoil" = 2, "sugar" = 1, "sodiumchloride" = 1)
	catalysts = list("enzyme" = 5)
	result_amount = 3

/decl/chemical_reaction/instant/food/mayonnaise
	name = "mayonnaise"
	id = "mayo"
	result = "mayo"
	required_reagents = list("egg" = 9, "cookingoil" = 5, "lemonjuice" = 5, "sodiumchloride" = 1)
	result_amount = 15

/decl/chemical_reaction/instant/food/cheesewheel
	name = "Cheesewheel"
	id = "cheesewheel"
	result = null
	required_reagents = list("milk" = 40)
	catalysts = list("enzyme" = 5)
	result_amount = 1

/decl/chemical_reaction/instant/food/cheesewheel/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/reagent_containers/food/snacks/sliceable/cheesewheel(location)
	return

/decl/chemical_reaction/instant/food/meatball
	name = "Meatball"
	id = "meatball"
	result = null
	required_reagents = list("protein" = 3, "flour" = 5)
	catalysts = list("enzyme" = 5)
	result_amount = 3

/decl/chemical_reaction/instant/food/meatball/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/reagent_containers/food/snacks/meatball(location)
	return

/decl/chemical_reaction/instant/food/dough
	name = "Dough"
	id = "dough"
	result = null
	required_reagents = list("egg" = 3, "flour" = 10)
	inhibitors = list("water" = 1, "beer" = 1) //To prevent it messing with batter recipes
	result_amount = 1

/decl/chemical_reaction/instant/food/dough/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/reagent_containers/food/snacks/dough(location)
	return

/decl/chemical_reaction/instant/food/syntiflesh
	name = "Syntiflesh"
	id = "syntiflesh"
	result = null
	required_reagents = list("blood" = 5, "clonexadone" = 5)
	result_amount = 1

/decl/chemical_reaction/instant/food/syntiflesh/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/reagent_containers/food/snacks/meat/syntiflesh(location)
	return

/*
====================
	Aurora Food
====================
*/

/decl/chemical_reaction/instant/food/coating/batter
	name = "Batter"
	id = "batter"
	result = "batter"
	required_reagents = list("egg" = 3, "flour" = 10, "water" = 5, "sodiumchloride" = 2)
	result_amount = 20

/decl/chemical_reaction/instant/food/coating/beerbatter
	name = "Beer Batter"
	id = "beerbatter"
	result = "beerbatter"
	required_reagents = list("egg" = 3, "flour" = 10, "beer" = 5, "sodiumchloride" = 2)
	result_amount = 20

/decl/chemical_reaction/instant/food/browniemix
	name = "Brownie Mix"
	id = "browniemix"
	result = "browniemix"
	required_reagents = list("flour" = 5, "coco" = 5, "sugar" = 5)
	result_amount = 15

/decl/chemical_reaction/instant/food/butter
	name = "Butter"
	id = "butter"
	result = null
	required_reagents = list("cream" = 20, "sodiumchloride" = 1)
	result_amount = 1

/decl/chemical_reaction/instant/food/butter/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/reagent_containers/food/snacks/spreads/butter(location)
	return