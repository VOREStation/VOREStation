/decl/chemical_reaction/distilling
	name = REAGENT_DEVELOPER_WARNING // Unit test ignore
//	id = null
//	result = null
//	required_reagents = list()
//	catalysts = list()
//	inhibitors = list()
//	result_amount = 0

	//how far the reaction proceeds each time it is processed. Used with either REACTION_RATE or HALF_LIFE macros.
	reaction_rate = HALF_LIFE(6)

	//if less than 1, the reaction will be inhibited if the ratio of products/reagents is too high.
	//0.5 = 50% yield -> reaction will only proceed halfway until products are removed.
//	yield = 1.0

	//If limits on reaction rate would leave less than this amount of any reagent (adjusted by the reaction ratios),
	//the reaction goes to completion. This is to prevent reactions from going on forever with tiny reagent amounts.
//	min_reaction = 2

	mix_message = "The solution churns."
	reaction_sound = 'sound/effects/slosh.ogg'

//	log_is_important = 0 // If this reaction should be considered important for logging. Important recipes message admins when mixed, non-important ones just log to file.

	var/list/temp_range = list(T0C, T20C)
	var/temp_shift = 0 // How much the temperature changes when the reaction occurs.

	var/require_xgm_gas = null
	var/rejects_xgm_gas = null
	var/maximum_xgm_pressure = null
	var/minimum_xgm_pressure = null

/decl/chemical_reaction/distilling/can_happen(var/datum/reagents/holder)
	if(!istype(holder, /datum/reagents/distilling))
		return FALSE

	// return_air() will get the current turf for most things unless overriden to use a tank or such!
	var/datum/gas_mixture/GM = holder.my_atom.return_air()
	if(require_xgm_gas || rejects_xgm_gas || minimum_xgm_pressure || maximum_xgm_pressure)
		if(!GM)
			return
		if(require_xgm_gas && GM.gas[require_xgm_gas] <= 10) // If have required gas to react
			return
		if(rejects_xgm_gas && GM.gas[rejects_xgm_gas] >= 1) // If blocked by a gas it doesn't like
			return
		if(minimum_xgm_pressure && GM.return_pressure() < minimum_xgm_pressure)
			return
		if(maximum_xgm_pressure && GM.return_pressure() > maximum_xgm_pressure)
			return

	// Special distilling conditions must be met, each object has different vars to meet it though.
	if(istype(holder.my_atom,/obj/distilling_tester))
		// Unit test needs some special handholding
		var/obj/distilling_tester/DD = holder.my_atom
		if(DD.current_temp < temp_range[1] || DD.current_temp > temp_range[2])
			return FALSE
	else if(istype(holder.my_atom,/obj/machinery/portable_atmospherics/powered/reagent_distillery))
		// Super special temperature check.
		var/obj/machinery/portable_atmospherics/powered/reagent_distillery/RD = holder.my_atom
		if(RD.current_temp < temp_range[1] || RD.current_temp > temp_range[2])
			return FALSE
	else if(istype(holder.my_atom, /obj/machinery/reagent_refinery/reactor))
		// Check gas temp for refinery
		if(!GM || GM.temperature < temp_range[1] || GM.temperature > temp_range[2])
			return FALSE

	return ..()

/*
/decl/chemical_reaction/distilling/on_reaction(var/datum/reagents/holder, var/created_volume)
	if(istype(holder.my_atom, /obj/item/reagent_containers/glass/distilling))
		var/obj/item/reagent_containers/glass/distilling/D = holder.my_atom
		var/obj/machinery/portable_atmospherics/powered/reagent_distillery/RD = D.Master
		RD.current_temp += temp_shift
	return
*/

// Subtypes //

// Biomass
/decl/chemical_reaction/distilling/biomass
	name = "Distilling Biomass"
	id = "distill_biomass"
	result = REAGENT_ID_BIOMASS
	required_reagents = list(REAGENT_ID_BLOOD = 1, REAGENT_ID_SUGAR = 1, REAGENT_ID_PHORON = 0.5)
	result_amount = 1 // 40 units per sheet, requires actually using the machine, and having blood to spare.

	temp_range = list(T20C + 80, T20C + 130)
	temp_shift = -2

// Medicinal
/decl/chemical_reaction/distilling/inaprovalaze
	name = "Distilling Inaprovalaze"
	id = "distill_inaprovalaze"
	result = REAGENT_ID_INAPROVALAZE
	required_reagents = list(REAGENT_ID_INAPROVALINE = 2, REAGENT_ID_FOAMINGAGENT = 1)
	result_amount = 2

	reaction_rate = HALF_LIFE(10)

	temp_range = list(T0C + 100, T0C + 120)

/decl/chemical_reaction/distilling/bicaridaze
	name = "Distilling Bicaridaze"
	id = "distill_bicaridaze"
	result = REAGENT_ID_BICARIDAZE
	required_reagents = list(REAGENT_ID_BICARIDINE = 2, REAGENT_ID_FOAMINGAGENT = 1)
	result_amount = 2

	reaction_rate = HALF_LIFE(10)

	temp_range = list(T0C + 110, T0C + 130)

/decl/chemical_reaction/distilling/dermalaze
	name = "Distilling Dermalaze"
	id = "distill_dermalaze"
	result = REAGENT_ID_DERMALAZE
	required_reagents = list(REAGENT_ID_DERMALINE = 2, REAGENT_ID_FOAMINGAGENT = 1)
	result_amount = 2

	reaction_rate = HALF_LIFE(10)

	temp_range = list(T0C + 115, T0C + 130)

/decl/chemical_reaction/distilling/spacomycaze
	name = "Distilling Spacomycaze"
	id = "distill_spacomycaze"
	result = REAGENT_ID_SPACOMYCAZE
	required_reagents = list(REAGENT_ID_PARACETAMOL = 1, REAGENT_ID_SPACEACILLIN = 1, REAGENT_ID_FOAMINGAGENT = 1)
	result_amount = 2

	reaction_rate = HALF_LIFE(10)

	temp_range = list(T0C + 100, T0C + 120)

/decl/chemical_reaction/distilling/tricorlidaze
	name = "Distilling Tricorlidaze"
	id = "distill_tricorlidaze"
	result = REAGENT_ID_TRICORLIDAZE
	required_reagents = list(REAGENT_ID_TRICORDRAZINE = 1, REAGENT_ID_STERILIZINE = 1, REAGENT_ID_FOAMINGAGENT = 1)
	result_amount = 2

	reaction_rate = HALF_LIFE(10)

	temp_range = list(T0C + 100, T0C + 120)

/decl/chemical_reaction/distilling/synthplas
	name = "Distilling Synthplas"
	id = "distill_synthplas"
	result = REAGENT_ID_SYNTHBLOOD_DILUTE
	required_reagents = list(REAGENT_ID_PROTEIN = 2, REAGENT_ID_ANTIBODIES = 1, REAGENT_ID_BICARIDINE = 1)
	result_amount = 3

	reaction_rate = HALF_LIFE(15)

	temp_range = list(T0C + 110, T0C + 130)

// Alcohol
/decl/chemical_reaction/distilling/beer
	name = "Distilling Beer"
	id = "distill_beer"
	result = REAGENT_ID_BEER
	required_reagents = list(REAGENT_ID_NUTRIMENT = 1, REAGENT_ID_WATER = 1, REAGENT_ID_SUGAR = 1)
	result_amount = 2

	reaction_rate = HALF_LIFE(30)

	temp_range = list(T20C, T20C + 2)

/decl/chemical_reaction/distilling/ale
	name = "Distilling Ale"
	id = "distill_ale"
	result = REAGENT_ID_ALE
	required_reagents = list(REAGENT_ID_NUTRIMENT = 1, REAGENT_ID_BEER = 1)
	inhibitors = list(REAGENT_ID_WATER = 1)
	result_amount = 2

	reaction_rate = HALF_LIFE(30)

	temp_shift = 0.5
	temp_range = list(T0C + 7, T0C + 13)

// Unique
/decl/chemical_reaction/distilling/berserkjuice
	name = "Distilling Brute Juice"
	id = "distill_brutejuice"
	result = REAGENT_ID_BERSERKMED
	required_reagents = list(REAGENT_ID_BIOMASS = 1, REAGENT_ID_HYPERZINE = 3, REAGENT_ID_SYNAPTIZINE = 2, REAGENT_ID_PHORON = 1)
	result_amount = 3

	temp_range = list(T0C + 600, T0C + 700)
	temp_shift = 4

/decl/chemical_reaction/distilling/berserkjuice/on_reaction(var/datum/reagents/holder, var/created_volume)
	..()

	if(prob(1))
		var/turf/T = get_turf(holder.my_atom)
		explosion(T, -1, rand(-1, 1), rand(1,2), rand(3,5))
	return

/decl/chemical_reaction/distilling/cryogel
	name = "Distilling Cryogellatin"
	id = "distill_cryoslurry"
	result = REAGENT_ID_CRYOSLURRY
	required_reagents = list(REAGENT_ID_FROSTOIL = 7, REAGENT_ID_ENZYME = 3, REAGENT_ID_PLASTICIDE = 3, REAGENT_ID_FOAMINGAGENT = 2)
	inhibitors = list(REAGENT_ID_WATER = 5)
	result_amount = 1

	temp_range = list(0, 15)
	temp_shift = 20

/decl/chemical_reaction/distilling/cryogel/on_reaction(var/datum/reagents/holder, var/created_volume)
	..()

	if(prob(1))
		var/turf/T = get_turf(holder.my_atom)
		var/datum/effect/effect/system/smoke_spread/frost/F = new (holder.my_atom)
		F.set_up(6, 0, T)
		F.start()
	return

/decl/chemical_reaction/distilling/lichpowder
	name = "Distilling Lichpowder"
	id = "distill_lichpowder"
	result = REAGENT_ID_LICHPOWDER
	required_reagents = list(REAGENT_ID_ZOMBIEPOWDER = 2, REAGENT_ID_LEPORAZINE = 1)
	result_amount = 2

	reaction_rate = HALF_LIFE(8)

	temp_range = list(T0C + 100, T0C + 150)

/decl/chemical_reaction/distilling/necroxadone
	name = "Distilling Necroxadone"
	id = "distill_necroxadone"
	result = REAGENT_ID_NECROXADONE
	required_reagents = list(REAGENT_ID_LICHPOWDER = 1, REAGENT_ID_CRYOXADONE = 1, REAGENT_ID_CARTHATOLINE = 1)
	result_amount = 2

	catalysts = list(REAGENT_ID_PHORON = 5)

	reaction_rate = HALF_LIFE(20)

	temp_range = list(T0C + 90, T0C + 95)

/decl/chemical_reaction/distilling/sugar
	name = "Crystalizing Sugar"
	id = "distill_sugar"
	result = REAGENT_ID_SUGAR
	required_reagents = list(REAGENT_ID_CARBON = 5)
	catalysts = list(REAGENT_ID_WATER = 1, REAGENT_ID_SUGAR = 1) // Rebuild the crystals!
	result_amount = 0.1

	temp_range = list(T0C -10, T0C -5) // crystal growth
	temp_shift = -1

	require_xgm_gas = GAS_PHORON
	rejects_xgm_gas = GAS_O2

/decl/chemical_reaction/distilling/hydrogen
	name = "Distilling Hydrogen"
	id = "distill_hydrogen"
	result = REAGENT_ID_HYDROGEN
	inhibitors = list(REAGENT_ID_CARBON = 1)
	required_reagents = list(REAGENT_ID_WATER = 1)
	result_amount = 2

	temp_range = list(T20C + 110, T20C + 290)
	temp_shift = 3 // It's burning off phoron

	require_xgm_gas = GAS_PHORON
	rejects_xgm_gas = GAS_O2

/decl/chemical_reaction/distilling/oxygen
	name = "Distilling Oxygen"
	id = "distill_oxygen"
	result = REAGENT_ID_OXYGEN
	inhibitors = list(REAGENT_ID_CARBON = 1)
	required_reagents = list(REAGENT_ID_WATER = 1)
	catalysts = list(REAGENT_ID_PHORON = 1)
	result_amount = 1

	temp_range = list(T20C + 150, T20C + 320)
	temp_shift = 3 // It's burning off phoron

	require_xgm_gas = GAS_N2
	rejects_xgm_gas = GAS_O2

/decl/chemical_reaction/distilling/mineralized_sodium
	name = "Distilling Sodium"
	id = "distill_sodium"
	result = REAGENT_ID_SODIUM
	required_reagents = list(REAGENT_ID_MINERALIZEDFLUID = 1)
	result_amount = 1

	temp_range = list(T20C + 600, T20C + 800)
	temp_shift = -1

	require_xgm_gas = GAS_PHORON
	rejects_xgm_gas = GAS_O2

/decl/chemical_reaction/distilling/mineralized_carbon
	name = "Distilling Carbon"
	id = "distill_carbon"
	result = REAGENT_ID_CARBON
	required_reagents = list(REAGENT_ID_MINERALIZEDFLUID = 1)
	result_amount = 1

	temp_range = list(T20C + 400, T20C + 800)
	temp_shift = -1

	require_xgm_gas = GAS_O2
	rejects_xgm_gas = GAS_PHORON

/decl/chemical_reaction/distilling/reduce_salt
	name = "Distilling Sodium"
	id = "distill_reduce_tablesalt"
	result = REAGENT_ID_SODIUM
	required_reagents = list(REAGENT_ID_SODIUMCHLORIDE = 1)
	result_amount = 1

	temp_range = list(T20C + 800, T20C + 1000)
	temp_shift = -1

	require_xgm_gas = GAS_PHORON
	rejects_xgm_gas = GAS_O2
