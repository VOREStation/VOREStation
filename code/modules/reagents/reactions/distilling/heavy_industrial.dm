// Heavy chemicals
/decl/chemical_reaction/distilling/titanium_refine
	name = REAGENT_TITANIUM
	id = "distill_titanium"
	result = REAGENT_ID_TITANIUM
	required_reagents = list(REAGENT_ID_TITANIUMDIOX = 1, REAGENT_ID_CHLORINE = 4, REAGENT_ID_SODIUM = 1)
	result_amount = 1

	temp_range = list(T20C + 900, T20C + 1100)
	temp_shift = -1

	require_xgm_gas = GAS_N2
	rejects_xgm_gas = GAS_O2

/decl/chemical_reaction/distilling/concentrate_radium
	name = REAGENT_CONCENTRATEDRADIUM
	id = "distill_conrad"
	result = REAGENT_ID_CONCENTRATEDRADIUM
	required_reagents = list(REAGENT_ID_RADIUM = 5, REAGENT_ID_LEAD = 1)
	catalysts = list(REAGENT_ID_URANIUM = 1)
	result_amount = 1

	temp_range = list(T20C + 1500, T20C + 2000)
	temp_shift = -1

	require_xgm_gas = GAS_PHORON
	rejects_xgm_gas = GAS_N2

/decl/chemical_reaction/distilling/cyanide
	name = REAGENT_CYANIDE
	id = "distill_cyanide"
	result = REAGENT_ID_CYANIDE
	required_reagents = list(REAGENT_ID_CARBON = 1, REAGENT_ID_NITROGEN = 1, REAGENT_ID_WATER = 2)
	result_amount = 1

	temp_range = list(T0C + 150, T0C + 170)
	temp_shift = 0

	require_xgm_gas = GAS_N2
	rejects_xgm_gas = GAS_O2

/decl/chemical_reaction/distilling/sacid
	name = REAGENT_SACID
	id = "distill_sacid"
	result = REAGENT_ID_SACID
	required_reagents = list(REAGENT_ID_HYDROGEN = 2, REAGENT_ID_SULFUR = 1)
	result_amount = 1

	temp_range = list(T0C + 200, T0C + 300)
	temp_shift = 5

	require_xgm_gas = GAS_O2
	rejects_xgm_gas = GAS_N2

/decl/chemical_reaction/distilling/toxin
	name = REAGENT_TOXIN
	id = "distill_rawtoxin"
	result = REAGENT_ID_TOXIN
	required_reagents = list(REAGENT_ID_SACID = 2, REAGENT_ID_CYANIDE = 1)
	result_amount = 1

	temp_range = list(T0C + 120, T0C + 580)
	temp_shift = 2

	require_xgm_gas = GAS_PHORON
	rejects_xgm_gas = GAS_N2


// Marker ink for paint production
/decl/chemical_reaction/distilling/marker_ink_black
	name = REAGENT_MARKERINKBLACK
	id = "distill_marker_black"
	result = REAGENT_ID_MARKERINKBLACK
	required_reagents = list(REAGENT_ID_LUBE = 1, REAGENT_ID_ETHANOL = 1, REAGENT_ID_CARBON = 1)
	result_amount = 1

	temp_range = list(T20C + 90, T20C + 160)
	temp_shift = -1

	require_xgm_gas = GAS_O2
	rejects_xgm_gas = GAS_PHORON

/decl/chemical_reaction/distilling/marker_ink_red
	name = REAGENT_MARKERINKRED
	id = "distill_marker_red"
	result = REAGENT_ID_MARKERINKRED
	required_reagents = list(REAGENT_ID_LUBE = 1, REAGENT_ID_ETHANOL = 1, REAGENT_ID_IRON = 1)
	result_amount = 1

	temp_range = list(T20C + 90, T20C + 160)
	temp_shift = -1

	require_xgm_gas = GAS_O2
	rejects_xgm_gas = GAS_PHORON

/decl/chemical_reaction/distilling/marker_ink_yellow
	name = REAGENT_MARKERINKYELLOW
	id = "distill_marker_yellow"
	result = REAGENT_ID_MARKERINKYELLOW
	required_reagents = list(REAGENT_ID_LUBE = 1, REAGENT_ID_ETHANOL = 1, REAGENT_ID_SULFUR = 1)
	result_amount = 1

	temp_range = list(T20C + 90, T20C + 160)
	temp_shift = -1

	require_xgm_gas = GAS_O2
	rejects_xgm_gas = GAS_PHORON

/decl/chemical_reaction/distilling/marker_ink_green
	name = REAGENT_MARKERINKGREEN
	id = "distill_marker_green"
	result = REAGENT_ID_MARKERINKGREEN
	required_reagents = list(REAGENT_ID_LUBE = 1, REAGENT_ID_ETHANOL = 1, REAGENT_ID_COPPER = 1)
	result_amount = 1

	temp_range = list(T20C + 90, T20C + 160)
	temp_shift = -1

	require_xgm_gas = GAS_O2
	rejects_xgm_gas = GAS_PHORON

/decl/chemical_reaction/distilling/marker_ink_blue
	name = REAGENT_MARKERINKBLUE
	id = "distill_marker_blue"
	result = REAGENT_ID_MARKERINKBLUE
	required_reagents = list(REAGENT_ID_LUBE = 1, REAGENT_ID_ETHANOL = 1, REAGENT_ID_PRUSSIANBLUE = 1)
	result_amount = 1

	temp_range = list(T20C + 90, T20C + 160)
	temp_shift = -1

	require_xgm_gas = GAS_O2
	rejects_xgm_gas = GAS_PHORON

/decl/chemical_reaction/distilling/marker_ink_grey
	name = REAGENT_MARKERINKGREY
	id = "distill_marker_grey"
	result = REAGENT_ID_MARKERINKGREY
	required_reagents = list(REAGENT_ID_LUBE = 1, REAGENT_ID_ETHANOL = 1, REAGENT_ID_TIN = 1)
	result_amount = 1

	temp_range = list(T20C + 90, T20C + 160)
	temp_shift = -1

	require_xgm_gas = GAS_O2
	rejects_xgm_gas = GAS_PHORON


// Secondary distillation for markers
/decl/chemical_reaction/distilling/marker_ink_orange
	name = REAGENT_MARKERINKORANGE
	id = "distill_marker_orange"
	result = REAGENT_ID_MARKERINKORANGE
	required_reagents = list(REAGENT_ID_MARKERINKRED = 1, REAGENT_ID_MARKERINKYELLOW = 1)
	result_amount = 1

	temp_range = list(T20C + 90, T20C + 160)
	temp_shift = -1

	require_xgm_gas = GAS_O2
	rejects_xgm_gas = GAS_PHORON

/decl/chemical_reaction/distilling/marker_ink_purple
	name = REAGENT_MARKERINKPURPLE
	id = "distill_marker_purple"
	result = REAGENT_ID_MARKERINKPURPLE
	required_reagents = list(REAGENT_ID_MARKERINKRED = 1, REAGENT_ID_MARKERINKBLUE = 1)
	result_amount = 1

	temp_range = list(T20C + 90, T20C + 160)
	temp_shift = -1

	require_xgm_gas = GAS_O2
	rejects_xgm_gas = GAS_PHORON

/decl/chemical_reaction/distilling/marker_ink_brown
	name = REAGENT_MARKERINKBROWN
	id = "distill_marker_brown"
	result = REAGENT_ID_MARKERINKBROWN
	required_reagents = list(REAGENT_ID_MARKERINKRED = 1, REAGENT_ID_MARKERINKGREY = 1)
	result_amount = 1

	temp_range = list(T20C + 90, T20C + 160)
	temp_shift = -1

	require_xgm_gas = GAS_O2
	rejects_xgm_gas = GAS_PHORON
