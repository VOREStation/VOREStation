// Condensing atmo gasses into reagents
// If there is ever work done converting atmogas back and forth from reagent to gas then this should be tuned to avoid creating something from nothing!
#define CONDENSING_RATE 50
#define CONDENSING_RESULT 0.5
#define CONDENSING_HEAT 2
#define OIL_CONSUMPTION_RATE 0.01

/decl/chemical_reaction/distilling/condense_oxygen
	name = "Condensing Oxygen"
	id = "condense_oxygen"
	result = REAGENT_ID_OXYGEN
	required_reagents = list(REAGENT_ID_FROSTOIL = OIL_CONSUMPTION_RATE)
	inhibitors = list(REAGENT_ID_OXYGEN = 0.1) // Used to limit the reaction
	result_amount = CONDENSING_RESULT

	temp_range = list(54.36, 90.19) // kelvin
	temp_shift = CONDENSING_HEAT

	require_xgm_gas = GAS_O2
	rejects_xgm_gas = GAS_PHORON
	consumes_xgm_gas = CONDENSING_RATE

/decl/chemical_reaction/distilling/condense_nitrogen
	name = "Condensing Nitrogen"
	id = "condense_nitrogen"
	result = REAGENT_ID_NITROGEN
	required_reagents = list(REAGENT_ID_FROSTOIL = OIL_CONSUMPTION_RATE)
	inhibitors = list(REAGENT_ID_NITROGEN = 0.1) // Used to limit the reaction
	result_amount = CONDENSING_RESULT

	temp_range = list(63.15, 77.36) // kelvin
	temp_shift = CONDENSING_HEAT

	require_xgm_gas = GAS_N2
	rejects_xgm_gas = GAS_PHORON
	consumes_xgm_gas = CONDENSING_RATE

/decl/chemical_reaction/distilling/condense_nitrox
	name = "Condensing Nitrous Oxide"
	id = "condense_nitro"
	result = REAGENT_ID_NITROGEN // Figure out something better
	required_reagents = list(REAGENT_ID_FROSTOIL = OIL_CONSUMPTION_RATE)
	inhibitors = list(REAGENT_ID_NITROGEN = 0.1) // Used to limit the reaction
	result_amount = CONDENSING_RESULT

	temp_range = list(0, 182.3) // kelvin
	temp_shift = CONDENSING_HEAT

	require_xgm_gas = GAS_N2O
	rejects_xgm_gas = GAS_PHORON
	consumes_xgm_gas = CONDENSING_RATE

/decl/chemical_reaction/distilling/condense_carbon
	name = "Condensing Carbon Dioxide"
	id = "condense_carbon"
	result = REAGENT_ID_CARBON
	required_reagents = list(REAGENT_ID_FROSTOIL = OIL_CONSUMPTION_RATE)
	inhibitors = list(REAGENT_ID_CARBON = 0.1) // Used to limit the reaction
	result_amount = CONDENSING_RESULT

	temp_range = list(54.36, 90.19) // kelvin
	temp_shift = CONDENSING_HEAT

	require_xgm_gas = GAS_CO2
	rejects_xgm_gas = GAS_PHORON
	consumes_xgm_gas = CONDENSING_RATE

/decl/chemical_reaction/distilling/condense_phoron
	name = "Condensing Phoron"
	id = "condense_phoron"
	result = REAGENT_ID_PHORON
	required_reagents = list(REAGENT_ID_FROSTOIL = OIL_CONSUMPTION_RATE)
	inhibitors = list(REAGENT_ID_PHORON = 0.1) // Used to limit the reaction
	result_amount = CONDENSING_RESULT

	temp_range = list(14.60, 52.99) // kelvin
	temp_shift = CONDENSING_HEAT

	require_xgm_gas = GAS_PHORON
	rejects_xgm_gas = GAS_O2
	consumes_xgm_gas = CONDENSING_RATE

/decl/chemical_reaction/distilling/condense_fuel
	name = "Condensing Volatiles"
	id = "condense_fuel"
	result = REAGENT_ID_FUEL
	required_reagents = list(REAGENT_ID_FROSTOIL = OIL_CONSUMPTION_RATE)
	inhibitors = list(REAGENT_ID_FUEL = 0.1) // Used to limit the reaction
	result_amount = CONDENSING_RESULT

	temp_range = list(91.60, 120.19) // kelvin
	temp_shift = CONDENSING_HEAT

	require_xgm_gas = GAS_VOLATILE_FUEL
	rejects_xgm_gas = GAS_O2
	consumes_xgm_gas = CONDENSING_RATE

#undef CONDENSING_RATE
#undef CONDENSING_RESULT
#undef CONDENSING_HEAT
#undef OIL_CONSUMPTION_RATE
