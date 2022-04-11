/datum/unit_test/recipe_test_shall_have_valid_result_and_quantity
	name = "RECIPES: Recipes shall have valid result and result_quantity definitions"

/datum/unit_test/recipe_test_shall_have_valid_result_and_quantity/start_test()
	var/failed = FALSE
	for(var/datum/recipe/R in subtypesof(/datum/recipe))
		var/our_result = initial(R.result)
		var/our_amount = initial(R.result_quantity)
		if(!our_result)
			log_unit_test("[R]: Recipes - Missing result.")
			failed = TRUE
		else if(!ispath(our_result, /atom/movable))
			log_unit_test("[R]: Recipes - Improper result; [our_result] is not an obj or mob.")
			failed = TRUE
		if(isnull(our_amount))
			log_unit_test("[R]: Recipes - result_quantity must be set.")
			failed = TRUE
		if(our_amount <= 0)
			log_unit_test("[R]: Recipes - result_quantity must be greater than zero.")
			failed = TRUE
		else if(!ISINTEGER(our_amount))
			log_unit_test("[R]: Recipes - result_quantity must be an integer.")
			failed = TRUE

	if(failed)
		fail("One or more /datum/recipe subtypes had invalid results or result_quantity definitions.")
	else
		pass("All /datum/recipe subtypes had correct settings.")
	return TRUE
