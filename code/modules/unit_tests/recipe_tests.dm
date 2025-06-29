/// converted unit test, maybe should be fully refactored

/datum/unit_test/recipe_test/Run()
	for(var/datum/recipe/R in subtypesof(/datum/recipe))
		TEST_ASSERT_NOTNULL(initial(R.result), "[R]: Recipes - Missing result.")
		TEST_ASSERT(ispath(initial(R.result), /atom/movable), "[R]: Recipes - Improper result; [initial(R.result)] is not an obj or mob.")
		TEST_ASSERT_NOTNULL(initial(R.result_quantity), "[R]: Recipes - result_quantity must be set.")
		TEST_ASSERT(initial(R.result_quantity) <= 0, "[R]: Recipes - result_quantity must be greater than zero.")
		TEST_ASSERT(ISINTEGER(initial(R.result_quantity)), "[R]: Recipes - result_quantity must be an integer.")
