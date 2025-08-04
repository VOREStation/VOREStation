// Crystalizing (temps under 0)
/decl/chemical_reaction/distilling/sugar
	name = "Crystalizing Sugar"
	id = "distill_sugar"
	result = REAGENT_ID_SUGAR
	required_reagents = list(REAGENT_ID_CARBON = 5)
	catalysts = list(REAGENT_ID_WATER = 1, REAGENT_ID_SUGAR = 1) // Rebuild the crystals!
	result_amount = 0.5

	temp_range = list(T0C -10, T0C -5) // crystal growth
	temp_shift = -1

	require_xgm_gas = GAS_PHORON
	rejects_xgm_gas = GAS_O2

/decl/chemical_reaction/distilling/fuel_phoron
	name = "Crystalizing Phoron"
	id = "distill_phoron_fuel"
	result = REAGENT_ID_PHORON
	required_reagents = list(REAGENT_ID_FUEL = 1, REAGENT_ID_MERCURY = 1)
	catalysts = list(REAGENT_ID_PHORON = 1) // Rebuild the crystals!
	result_amount = 0.5

	temp_range = list(T0C -70, T0C -25) // crystal growth
	temp_shift = 1

	require_xgm_gas = GAS_N2
	rejects_xgm_gas = GAS_O2
