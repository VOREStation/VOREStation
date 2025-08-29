// The curse of hot_water reagent lives on!
/decl/chemical_reaction/distilling/drinks
	name = REAGENT_DEVELOPER_WARNING // Unit test ignore
	temp_range = list(T0C + 100, T0C + 500) // These all imply a boiled drink anyway

/decl/chemical_reaction/distilling/drinks/coffee
	name = REAGENT_COFFEE
	id = REAGENT_ID_COFFEE
	result = REAGENT_ID_COFFEE
	required_reagents = list(REAGENT_ID_WATER = 5, REAGENT_ID_COFFEEPOWDER = 1)
	result_amount = 5

/decl/chemical_reaction/distilling/drinks/tea
	name = "Black tea"
	id = REAGENT_ID_TEA
	result = REAGENT_ID_TEA
	required_reagents = list(REAGENT_ID_WATER = 5, REAGENT_ID_TEAPOWDER = 1)
	result_amount = 5

/decl/chemical_reaction/distilling/drinks/decaftea
	name = REAGENT_TEADECAF
	id = REAGENT_ID_TEADECAF
	result = REAGENT_ID_TEADECAF
	required_reagents = list(REAGENT_ID_WATER = 5, REAGENT_ID_DECAFTEAPOWDER = 1)
	result_amount = 5

/decl/chemical_reaction/distilling/drinks/hot_coco
	name = "Hot Coco"
	id = REAGENT_ID_HOTCOCO
	result = REAGENT_ID_HOTCOCO
	required_reagents = list(REAGENT_ID_WATER = 5, REAGENT_ID_COCO = 1)
	result_amount = 5

/decl/chemical_reaction/distilling/drinks/minttea
	name = REAGENT_MINTTEA
	id = REAGENT_ID_MINTTEA
	result = REAGENT_ID_MINTTEA
	required_reagents = list(REAGENT_ID_TEA = 5, REAGENT_ID_MINT = 1)
	result_amount = 6

/decl/chemical_reaction/distilling/drinks/minttea_decaf
	name = REAGENT_MINTTEADECAF
	id = REAGENT_ID_MINTTEADECAF
	result = REAGENT_ID_MINTTEADECAF
	required_reagents = list(REAGENT_ID_TEADECAF = 5, REAGENT_ID_MINT = 1)
	result_amount = 6

/decl/chemical_reaction/distilling/drinks/lemontea
	name = REAGENT_LEMONTEA
	id = REAGENT_ID_LEMONTEA
	result = REAGENT_ID_LEMONTEA
	required_reagents = list(REAGENT_ID_TEA = 5, REAGENT_ID_LEMONJUICE = 1)
	result_amount = 6

/decl/chemical_reaction/distilling/drinks/lemontea_decaf
	name = REAGENT_LEMONTEADECAF
	id = REAGENT_ID_LEMONTEADECAF
	result = REAGENT_ID_LEMONTEADECAF
	required_reagents = list(REAGENT_ID_TEADECAF = 5, REAGENT_ID_LEMONJUICE = 1)
	result_amount = 6

/decl/chemical_reaction/distilling/drinks/limetea
	name = REAGENT_LIMETEA
	id = REAGENT_ID_LIMETEA
	result = REAGENT_ID_LIMETEA
	required_reagents = list(REAGENT_ID_TEA = 5, REAGENT_ID_LIMEJUICE = 1)
	result_amount = 6

/decl/chemical_reaction/distilling/drinks/limetea_decaf
	name = REAGENT_LIMETEADECAF
	id = REAGENT_ID_LIMETEADECAF
	result = REAGENT_ID_LIMETEADECAF
	required_reagents = list(REAGENT_ID_TEADECAF = 5, REAGENT_ID_LIMEJUICE = 1)
	result_amount = 6

/decl/chemical_reaction/distilling/drinks/orangetea
	name = REAGENT_ORANGETEA
	id = REAGENT_ID_ORANGETEA
	result = REAGENT_ID_ORANGETEA
	required_reagents = list(REAGENT_ID_TEA = 5, REAGENT_ID_ORANGEJUICE = 1)
	result_amount = 6

/decl/chemical_reaction/distilling/drinks/orangetea_decaf
	name = "Decaf Orange Tea"
	id = REAGENT_ID_ORANGETEADECAF
	result = REAGENT_ID_ORANGETEADECAF
	required_reagents = list(REAGENT_ID_TEADECAF = 5, REAGENT_ID_ORANGEJUICE = 1)
	result_amount = 6

/decl/chemical_reaction/distilling/drinks/berrytea
	name = REAGENT_BERRYTEA
	id = REAGENT_ID_BERRYTEA
	result = REAGENT_ID_BERRYTEA
	required_reagents = list(REAGENT_ID_TEA = 5, REAGENT_ID_BERRYJUICE = 1)
	result_amount = 6

/decl/chemical_reaction/distilling/drinks/berrytea_decaf
	name = REAGENT_BERRYTEADECAF
	id = REAGENT_ID_BERRYTEADECAF
	result = REAGENT_ID_BERRYTEADECAF
	required_reagents = list(REAGENT_ID_TEADECAF = 5, REAGENT_ID_BERRYJUICE = 1)
	result_amount = 6
