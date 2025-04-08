/decl/chemical_reaction/instant/food
	name = REAGENT_DEVELOPER_WARNING // Unit test ignore
	wiki_flag = WIKI_FOOD

/decl/chemical_reaction/instant/food/hot_ramen
	name = REAGENT_HOTRAMEN
	id = REAGENT_ID_HOTRAMEN
	result = REAGENT_ID_HOTRAMEN
	required_reagents = list(REAGENT_ID_WATER = 1, REAGENT_ID_DRYRAMEN = 3)
	result_amount = 3

/decl/chemical_reaction/instant/food/hell_ramen
	name = REAGENT_HELLRAMEN
	id = REAGENT_ID_HELLRAMEN
	result = REAGENT_ID_HELLRAMEN
	required_reagents = list(REAGENT_ID_CAPSAICIN = 1, REAGENT_ID_HOTRAMEN = 6)
	result_amount = 6

/decl/chemical_reaction/instant/food/tofu
	name = "Tofu"
	id = REAGENT_ID_TOFU
	result = null
	required_reagents = list(REAGENT_ID_SOYMILK = 10)
	catalysts = list(REAGENT_ID_ENZYME = 5)
	result_amount = 1

/decl/chemical_reaction/instant/food/tofu/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/reagent_containers/food/snacks/tofu(location)
	return

/decl/chemical_reaction/instant/food/chocolate_bar
	name = "Chocolate Bar Soy"
	id = "chocolate_bar_soy"
	result = null
	required_reagents = list(REAGENT_ID_SOYMILK = 2, REAGENT_ID_COCO = 2, REAGENT_ID_SUGAR = 2)
	catalysts = list(REAGENT_ID_ENZYME = 5)
	result_amount = 1

/decl/chemical_reaction/instant/food/chocolate_bar/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/reagent_containers/food/snacks/chocolatebar(location)
	return

/decl/chemical_reaction/instant/food/chocolate_bar2
	name = "Chocolate Bar Milk"
	id = "chocolate_bar_milk"
	result = null
	required_reagents = list(REAGENT_ID_MILK = 2, REAGENT_ID_COCO = 2, REAGENT_ID_SUGAR = 2)
	catalysts = list(REAGENT_ID_ENZYME = 5)
	result_amount = 1

/decl/chemical_reaction/instant/food/chocolate_bar2/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/reagent_containers/food/snacks/chocolatebar(location)
	return

/decl/chemical_reaction/instant/food/cookingoilcorn
	name = "corn " + REAGENT_COOKINGOIL
	id = "cookingoilcorn"
	result = REAGENT_ID_COOKINGOIL
	required_reagents = list(REAGENT_ID_CORNOIL = 10)
	catalysts = list(REAGENT_ID_ENZYME = 5)
	result_amount = 10

/decl/chemical_reaction/instant/food/cookingoilpeanut
	name = "peanut " + REAGENT_ID_COOKINGOIL
	id = "cookingoilpeanut"
	result = REAGENT_ID_COOKINGOIL
	required_reagents = list(REAGENT_ID_PEANUTOIL = 10)
	inhibitors = list(REAGENT_ID_SUGAR = 1, REAGENT_ID_SODIUMCHLORIDE = 1)
	catalysts = list(REAGENT_ID_ENZYME = 5)
	result_amount = 10

/decl/chemical_reaction/instant/food/soysauce
	name = REAGENT_SOYSAUCE
	id = REAGENT_ID_SOYSAUCE
	result = REAGENT_ID_SOYSAUCE
	required_reagents = list(REAGENT_ID_SOYMILK = 4, REAGENT_ID_SACID = 1)
	result_amount = 5

/decl/chemical_reaction/instant/food/ketchup
	name = REAGENT_KETCHUP
	id = REAGENT_ID_KETCHUP
	result = REAGENT_ID_KETCHUP
	required_reagents = list(REAGENT_ID_TOMATOJUICE = 2, REAGENT_ID_WATER = 1, REAGENT_ID_SUGAR = 1)
	result_amount = 4

/decl/chemical_reaction/instant/food/barbecue
	name = REAGENT_BARBECUE
	id = REAGENT_ID_BARBECUE
	result = REAGENT_ID_BARBECUE
	required_reagents = list(REAGENT_ID_TOMATOJUICE = 2, REAGENT_ID_APPLEJUICE = 1, REAGENT_ID_SUGAR = 1, REAGENT_ID_SPACESPICE = 1)
	result_amount = 4

/decl/chemical_reaction/instant/food/peanutbutter
	name = REAGENT_PEANUTBUTTER
	id = REAGENT_ID_PEANUTBUTTER
	result = REAGENT_ID_PEANUTBUTTER
	required_reagents = list(REAGENT_ID_PEANUTOIL = 2, REAGENT_ID_SUGAR = 1, REAGENT_ID_SODIUMCHLORIDE = 1)
	catalysts = list(REAGENT_ID_ENZYME = 5)
	result_amount = 3

/decl/chemical_reaction/instant/food/mayonnaise
	name = REAGENT_MAYO
	id = REAGENT_ID_MAYO
	result = REAGENT_ID_MAYO
	required_reagents = list(REAGENT_ID_EGG = 9, REAGENT_ID_COOKINGOIL = 5, REAGENT_ID_LEMONJUICE = 5, REAGENT_ID_SODIUMCHLORIDE = 1)
	result_amount = 15

/decl/chemical_reaction/instant/food/cheesewheel
	name = "Cheesewheel"
	id = "cheesewheel"
	result = null
	required_reagents = list(REAGENT_ID_MILK = 40)
	catalysts = list(REAGENT_ID_ENZYME = 5)
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
	required_reagents = list(REAGENT_ID_PROTEIN = 3, REAGENT_ID_FLOUR = 5)
	catalysts = list(REAGENT_ID_ENZYME = 5)
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
	required_reagents = list(REAGENT_ID_EGG = 3, REAGENT_ID_FLOUR = 10)
	inhibitors = list(REAGENT_ID_WATER = 1, REAGENT_ID_BEER = 1, REAGENT_ID_SUGAR = 1) //To prevent it messing with batter recipes
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
	required_reagents = list(REAGENT_ID_BLOOD = 5, REAGENT_ID_CLONEXADONE = 5)
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
	id = REAGENT_ID_BATTER
	result = REAGENT_ID_BATTER
	required_reagents = list(REAGENT_ID_EGG = 3, REAGENT_ID_FLOUR = 10, REAGENT_ID_WATER = 5, REAGENT_ID_SODIUMCHLORIDE = 2)
	result_amount = 20

/decl/chemical_reaction/instant/food/coating/beerbatter
	name = "Beer Batter"
	id = REAGENT_ID_BEERBATTER
	result = REAGENT_ID_BEERBATTER
	required_reagents = list(REAGENT_ID_EGG = 3, REAGENT_ID_FLOUR = 10, REAGENT_ID_BEER = 5, REAGENT_ID_SODIUMCHLORIDE = 2)
	result_amount = 20

/decl/chemical_reaction/instant/food/browniemix
	name = REAGENT_BROWNIEMIX
	id = REAGENT_ID_BROWNIEMIX
	result = REAGENT_ID_BROWNIEMIX
	required_reagents = list(REAGENT_ID_FLOUR = 5, REAGENT_ID_COCO = 5, REAGENT_ID_SUGAR = 5)
	result_amount = 15

/decl/chemical_reaction/instant/food/cakebatter
	name = REAGENT_CAKEBATTER
	id = REAGENT_ID_CAKEBATTER
	result = REAGENT_ID_CAKEBATTER
	required_reagents = list(REAGENT_ID_FLOUR = 15, REAGENT_ID_MILK = 10, REAGENT_ID_SUGAR = 15, REAGENT_ID_EGG = 3)
	result_amount = 60

/decl/chemical_reaction/instant/food/butter
	name = "Butter"
	id = "butter"
	result = null
	required_reagents = list(REAGENT_ID_CREAM = 20, REAGENT_ID_SODIUMCHLORIDE = 1)
	result_amount = 1

/decl/chemical_reaction/instant/food/butter/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/reagent_containers/food/snacks/spreads/butter(location)
	return
