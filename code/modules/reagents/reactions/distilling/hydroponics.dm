// Hydroponics refinery fun
/decl/chemical_reaction/distilling/fertilizer
	name = REAGENT_FERTILIZER
	id = "distill_fertilizer"
	result = REAGENT_ID_FERTILIZER
	required_reagents = list(REAGENT_ID_WATER = 5, REAGENT_ID_NUTRIMENT = 1, REAGENT_ID_PHOSPHORUS = 1, REAGENT_ID_SULFUR = 1)
	result_amount = 3

	temp_range = list(T20C + 40, T20C + 60)
	temp_shift = 0

	require_xgm_gas = GAS_CO2
	rejects_xgm_gas = GAS_N2

/decl/chemical_reaction/distilling/eznutrient
	name = REAGENT_EZNUTRIENT
	id = "distill_eznutriment"
	result = REAGENT_ID_EZNUTRIENT
	required_reagents = list(REAGENT_ID_FERTILIZER = 1, REAGENT_ID_CALCIUM = 1, REAGENT_ID_CARBON = 2)
	result_amount = 1

	temp_range = list(T0C + 10, T0C + 50)
	temp_shift = 0

	require_xgm_gas = GAS_O2
	rejects_xgm_gas = GAS_PHORON

/decl/chemical_reaction/distilling/leftforzed
	name = REAGENT_LEFT4ZED
	id = "distill_leftforzed"
	result = REAGENT_ID_LEFT4ZED
	required_reagents = list(REAGENT_ID_FERTILIZER = 1, REAGENT_ID_RADIUM = 2, REAGENT_ID_CALCIUM = 2)
	result_amount = 1

	temp_range = list(T0C + 40, T0C + 80)
	temp_shift = 2

	require_xgm_gas = GAS_PHORON
	rejects_xgm_gas = GAS_N2

/decl/chemical_reaction/distilling/robustharvest
	name = REAGENT_ROBUSTHARVEST
	id = "distill_robustharvest"
	result = REAGENT_ID_ROBUSTHARVEST
	required_reagents = list(REAGENT_ID_FERTILIZER = 1, REAGENT_ID_CARBON = 2, REAGENT_ID_BICARIDINE = 1)
	result_amount = 1

	temp_range = list(T0C + 40, T0C + 80)
	temp_shift = 2

	require_xgm_gas = GAS_PHORON
	rejects_xgm_gas = GAS_N2
