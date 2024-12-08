/decl/xgm_gas/oxygen
	id = GAS_O2
	name = REAGENT_OXYGEN
	specific_heat = 20	// J/(mol*K)
	molar_mass = 0.032	// kg/mol

	flags = XGM_GAS_OXIDIZER

/decl/xgm_gas/nitrogen
	id = GAS_N2
	name = REAGENT_NITROGEN
	specific_heat = 20	// J/(mol*K)
	molar_mass = 0.028	// kg/mol

/decl/xgm_gas/carbon_dioxide
	id = GAS_CO2
	name = REAGENT_CARBON_DIOXIDE
	specific_heat = 30	// J/(mol*K)
	molar_mass = 0.044	// kg/mol

/decl/xgm_gas/phoron
	id = GAS_PHORON
	name = REAGENT_ID_PHORON

	//Note that this has a significant impact on TTV yield.
	//Because it is so high, any leftover phoron soaks up a lot of heat and drops the yield pressure.
	specific_heat = 200	// J/(mol*K)

	//Hypothetical group 14 (same as carbon), period 8 element.
	//Using multiplicity rule, it's atomic number is 162
	//and following a N/Z ratio of 1.5, the molar mass of a monatomic gas is:
	molar_mass = 0.405	// kg/mol

	tile_overlay = "phoron"
	overlay_limit = 0.7
	flags = XGM_GAS_FUEL | XGM_GAS_CONTAMINANT | XGM_GAS_FUSION_FUEL //R-UST port, adding XGM_GAS_FUSION_FUEL flag.

/decl/xgm_gas/volatile_fuel
	id = GAS_VOLATILE_FUEL
	name = REAGENT_VOLATILE_FUEL
	specific_heat = 253	// J/(mol*K)	C8H18 gasoline. Isobaric, but good enough.
	molar_mass = 0.114	// kg/mol. 		same.

	flags = XGM_GAS_FUEL

/decl/xgm_gas/nitrous_oxide
	id = GAS_N2O
	name = REAGENT_NITROUS_OXIDE
	specific_heat = 40	// J/(mol*K)
	molar_mass = 0.044	// kg/mol. N2O

	tile_overlay = "nitrous_oxide"
	overlay_limit = 1
	flags = XGM_GAS_OXIDIZER
