/************************************************************************
 * Mapper information:
 * Intended for POI spawns, surrounded by mineral turf walls that DO NOT CAVEGEN
 * These turfs must be surrounded by atmos of the exact same type, or be isolated
 * by walls. They may be placed next to eachother freely. They do not use the planet's
 * atmos. They start as compressed pockets of gas for miners to uncover.
 *
 * If these are given a /sif or other planet override they should be safe to use anywhere.
 * As these cracks do not produce gas on their own. They just have the atmos at init, and
 * produce gas when mined with a deep drill rig.
 *
 * Be careful when mapping them to avoid active edges.
************************************************************************/

/turf/simulated/floor/gas_crack
	icon = 'icons/turf/flooring/asteroid.dmi'
	desc = "Rough sand with a huge crack. It seems to be nothing in particular."
	description_info = "Fluid pumps can be used to frack for reagents in nearby ores, and a mining drill can also bore through trapped gas deposits beneath it."
	name = "cracked sand"
	icon_state = "asteroid_cracked"
	initial_flooring = /decl/flooring/rock
	var/list/gas_type = null
	oxygen = 0
	nitrogen = 0

/turf/simulated/floor/gas_crack/pump_reagents(var/datum/reagents/R, var/volume)
	// pick random turfs in range, then use their deep ores to get some extra reagents
	var/i = 0
	while(i++ < 4) // Do this a few times
		var/turf/simulated/mineral/M = pick(orange(5,src))
		if(!istype(M) || !M.resources)
			return
		for(var/metal in GLOB.deepore_fracking_reagents)
			if(!(metal in M.resources))
				continue
			var/list/ore_list = GLOB.deepore_fracking_reagents[metal]
			if(!ore_list || !ore_list.len)
				continue
			if(prob(60))
				var/reagent_id = pick(ore_list)
				if(reagent_id)
					R.add_reagent(reagent_id, round(volume, 0.1))


/turf/simulated/floor/gas_crack/oxygen
	gas_type = list(GAS_O2)
	oxygen = 500

/turf/simulated/floor/gas_crack/oxygen/pump_reagents(var/datum/reagents/R, var/volume)
	. = ..()
	R.add_reagent(REAGENT_ID_OXYGEN, round(volume / 2, 0.1))

/turf/simulated/floor/gas_crack/oxygen/examine(mob/user)
	. = ..()
	. += "A strong breeze blows through it."


/turf/simulated/floor/gas_crack/nitrogen
	gas_type = list(GAS_N2)
	nitrogen = 500

/turf/simulated/floor/gas_crack/nitrogen/pump_reagents(var/datum/reagents/R, var/volume)
	. = ..()
	R.add_reagent(REAGENT_ID_NITROGEN, round(volume / 2, 0.1))

/turf/simulated/floor/gas_crack/nitrogen/examine(mob/user)
	. = ..()
	. += "A stale breeze blows through it."

/turf/simulated/floor/gas_crack/carbon
	gas_type = list(GAS_CO2)
	carbon_dioxide = 500

/turf/simulated/floor/gas_crack/carbon/pump_reagents(var/datum/reagents/R, var/volume)
	. = ..()
	R.add_reagent(REAGENT_ID_CARBON, round(volume / 2, 0.1))

/turf/simulated/floor/gas_crack/carbon/examine(mob/user)
	. = ..()
	. += "A warm breeze blows through it."

/turf/simulated/floor/gas_crack/nitro
	gas_type = list(GAS_N2O)
	nitrogen = 250
	carbon_dioxide = 250

/turf/simulated/floor/gas_crack/nitro/pump_reagents(var/datum/reagents/R, var/volume)
	. = ..()
	R.add_reagent(REAGENT_ID_OXYGEN, round(volume / 3, 0.1))
	R.add_reagent(REAGENT_ID_NITROGEN, round(volume / 3, 0.1))

/turf/simulated/floor/gas_crack/nitro/examine(mob/user)
	. = ..()
	. += "A strange smell wafts from beneath it."

/turf/simulated/floor/gas_crack/phoron
	gas_type = list(GAS_PHORON)
	phoron = 500

/turf/simulated/floor/gas_crack/phoron/pump_reagents(var/datum/reagents/R, var/volume)
	. = ..()
	R.add_reagent(REAGENT_ID_PHORON, round(volume / 3, 0.1))

/turf/simulated/floor/gas_crack/phoron/examine(mob/user)
	. = ..()
	. += "A terrible smell wafts from beneath it."

/turf/simulated/floor/gas_crack/air
	gas_type = list(GAS_O2,GAS_N2)
	oxygen = 250
	nitrogen = 250

/turf/simulated/floor/gas_crack/air/pump_reagents(var/datum/reagents/R, var/volume)
	. = ..()
	R.add_reagent(REAGENT_ID_OXYGEN, round(volume / 2, 0.1))
	R.add_reagent(REAGENT_ID_NITROGEN, round(volume / 2, 0.1))

/turf/simulated/floor/gas_crack/air/examine(mob/user)
	. = ..()
	. += "A fresh breeze blows through it."

/turf/simulated/floor/gas_crack/methane
	gas_type = list(GAS_CH4)
	methane = 250

/turf/simulated/floor/gas_crack/methane/pump_reagents(var/datum/reagents/R, var/volume)
	. = ..()
	R.add_reagent(REAGENT_ID_SULFUR, round(volume / 2, 0.1))
	R.add_reagent(REAGENT_ID_PHOSPHORUS, round(volume / 2, 0.1))

/turf/simulated/floor/gas_crack/methane/examine(mob/user)
	. = ..()
	. += "A terrible smell wafts from beneath it."


/turf/simulated/floor/gas_crack/terrible
	gas_type = list(GAS_CO2,GAS_PHORON,GAS_N2O)
	methane = 250
	phoron = 250

/turf/simulated/floor/gas_crack/terrible/pump_reagents(var/datum/reagents/R, var/volume)
	. = ..()
	R.add_reagent(REAGENT_ID_NITROGEN, round(volume / 2, 0.1))
	R.add_reagent(REAGENT_ID_SULFUR, round(volume / 2, 0.1))
	R.add_reagent(REAGENT_ID_PHOSPHORUS, round(volume / 2, 0.1))
	R.add_reagent(REAGENT_ID_PHORON, round(volume / 3, 0.1))

/turf/simulated/floor/gas_crack/terrible/examine(mob/user)
	. = ..()
	. += "A dangerous smell wafts from beneath it."




// a highly randomized version of the gascrack. Do not use the base type, use the planet atmo overrides.
/turf/simulated/floor/gas_crack/random
	var/random_reagents = list()
	gas_type = list()

/turf/simulated/floor/gas_crack/random/Initialize(mapload, floortype)
	. = ..()
	// Set mined gas type
	if(prob(15))
		gas_type.Add(GAS_CO2)
	if(prob(15))
		gas_type.Add(GAS_PHORON)
	if(prob(15))
		gas_type.Add(GAS_N2O)
	if(prob(15))
		gas_type.Add(GAS_O2)
	if(prob(15))
		gas_type.Add(GAS_N2)
	if(prob(15))
		gas_type.Add(GAS_CH4)
	if(!gas_type.len)
		gas_type.Add(pick(list(GAS_CO2,GAS_PHORON,GAS_N2O,GAS_O2,GAS_N2,GAS_CH4)))
	// Set fracking reagent
	add_random_reagent()
	if(prob(60))
		add_random_reagent()
	if(prob(30))
		add_random_reagent()
	if(prob(10))
		add_random_reagent()
	if(prob(1))
		add_random_reagent()
	if(prob(1))
		add_random_reagent()

/turf/simulated/floor/gas_crack/random/proc/add_random_reagent()
	random_reagents += pick(list(REAGENT_ID_NITROGEN,
								REAGENT_ID_SULFUR,
								REAGENT_ID_PHOSPHORUS,
								REAGENT_ID_PHORON,
								REAGENT_ID_COPPER,
								REAGENT_ID_GOLD,
								REAGENT_ID_IRON,
								REAGENT_ID_NITROGEN,
								REAGENT_ID_HYDROGEN,
								REAGENT_ID_CARBON,
								REAGENT_ID_MERCURY,
								REAGENT_ID_LITHIUM,
								REAGENT_ID_POTASSIUM,
								REAGENT_ID_SILICON,
								REAGENT_ID_SODIUMCHLORIDE,
								REAGENT_ID_RADIUM,
								REAGENT_ID_CALCIUM,
								REAGENT_ID_CALCIUMCARBONATE,
								REAGENT_ID_URANIUM,
								REAGENT_ID_AMMONIA,
								REAGENT_ID_FLUORINE,
								REAGENT_ID_CHLORINE))

/turf/simulated/floor/gas_crack/random/pump_reagents(var/datum/reagents/R, var/volume)
	. = ..()
	R.add_reagent(pick(random_reagents), round(volume / 3, 0.1))
	R.add_reagent(pick(random_reagents), round(volume / 3, 0.1))
	R.add_reagent(pick(random_reagents), round(volume / 3, 0.1))

/turf/simulated/floor/gas_crack/random/examine(mob/user)
	. = ..()
	. += "An odd smell wafts from beneath it."
