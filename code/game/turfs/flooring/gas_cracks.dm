/turf/simulated/floor/gas_crack
	icon = 'icons/turf/flooring/asteroid.dmi'
	desc = "Rough sand with a huge crack. It seems to be nothing in particular."
	description_info = "Fluid pumps can be used to frack for reagents in nearby ores, and a mining drill can also bore through trapped gas deposits beneath it."
	name = "cracked sand"
	icon_state = "asteroid_cracked"
	initial_flooring = /decl/flooring/rock
	var/gas_type = null

	// Fracking results for fluid pump
	var/static/list/ore_types = list(
		ORE_HEMATITE = list(REAGENT_ID_SILICATE,REAGENT_ID_IRON,REAGENT_ID_CARBON),
		ORE_URANIUM = list(REAGENT_ID_RADIUM,REAGENT_ID_RADIUM,REAGENT_ID_CALCIUM,REAGENT_ID_PHOSPHORUS), // Doesn't produce uranium due to low use in reagents, and emp reaction
		// ORE_COPPER = list(REAGENT_ID_GOLD,REAGENT_ID_COPPER,REAGENT_ID_LEAD), // Commonly
		ORE_GOLD = list(REAGENT_ID_GOLD,REAGENT_ID_COPPER,REAGENT_ID_LEAD), // Found
		// ORE_TIN = list(REAGENT_ID_GOLD,REAGENT_ID_COPPER,REAGENT_ID_LEAD), // Together
		ORE_SILVER = list(REAGENT_ID_SILVER,REAGENT_ID_LEAD,REAGENT_ID_COPPER), // lead loves this one too
		ORE_DIAMOND = list(REAGENT_ID_TITANIUMDIOX,REAGENT_ID_PHOSPHORUS,REAGENT_ID_SULFUR,REAGENT_ID_CARBON), // Ignius process
		ORE_PHORON = list(REAGENT_ID_PHORON,REAGENT_ID_RADIUM,REAGENT_ID_PHOSPHORUS,REAGENT_ID_SULFUR), // Ignius heavymetals?
		ORE_PLATINUM = list(REAGENT_ID_PLATINUM,REAGENT_ID_COPPER), // Don't have much to group it with
		ORE_MHYDROGEN = list(REAGENT_ID_SILICATE,REAGENT_ID_HYDROGEN),
		ORE_SAND = list(REAGENT_ID_SILICATE,REAGENT_ID_SILICON,REAGENT_ID_LITHIUM,REAGENT_ID_PHOSPHORUS,REAGENT_ID_CALCIUM,REAGENT_ID_SODIUMCHLORIDE,REAGENT_ID_CARBON), // Catch all sedimentry
		ORE_CARBON = list(REAGENT_ID_SILICATE,REAGENT_ID_CARBON,REAGENT_ID_SODIUMCHLORIDE), // Salty coal
		// ORE_BAUXITE = list(REAGENT_ID_TITANIUMDIOX,REAGENT_ID_ALUMINIUM,REAGENT_ID_SODIUMCHLORIDE), // ore's general components and neighbours
		ORE_RUTILE = list(REAGENT_ID_TITANIUMDIOX,REAGENT_ID_SILICATE,REAGENT_ID_SILICON,REAGENT_ID_SODIUMCHLORIDE) // ore's general components and neighbours
		)

/turf/simulated/floor/gas_crack/pump_reagents(var/datum/reagents/R, var/volume)
	// pick random turfs in range, then use their deep ores to get some extra reagents
	var/i = 0
	while(i++ < 4) // Do this a few times
		var/turf/simulated/mineral/M = pick(orange(5,src))
		if(!M)
			return
		for(var/metal in ore_types)
			if(!M.resources[metal])
				return
			var/list/ore_list = ore_types[metal]
			if(!ore_list || !ore_list.len)
				return
			if(prob(60))
				var/reagent_id = pick(ore_list)
				R.add_reagent(reagent_id, round(volume, 0.1))


/turf/simulated/floor/gas_crack/oxygen
	desc = "Rough sand with a huge crack. A strong breeze blows through it."
	gas_type = list(GAS_O2)

/turf/simulated/floor/gas_crack/oxygen/pump_reagents(var/datum/reagents/R, var/volume)
	. = ..()
	R.add_reagent(REAGENT_ID_OXYGEN, round(volume / 2, 0.1))


/turf/simulated/floor/gas_crack/nitrogen
	desc = "Rough sand with a huge crack. A stale breeze blows through it."
	gas_type = list(GAS_N2)

/turf/simulated/floor/gas_crack/nitrogen/pump_reagents(var/datum/reagents/R, var/volume)
	. = ..()
	R.add_reagent(REAGENT_ID_NITROGEN, round(volume / 2, 0.1))


/turf/simulated/floor/gas_crack/carbon
	desc = "Rough sand with a huge crack. A warm breeze blows through it."
	gas_type = list(GAS_CO2)

/turf/simulated/floor/gas_crack/carbon/pump_reagents(var/datum/reagents/R, var/volume)
	. = ..()
	R.add_reagent(REAGENT_ID_CARBON, round(volume / 2, 0.1))


/turf/simulated/floor/gas_crack/nitro
	desc = "Rough sand with a huge crack. A strange smell wafts from beneath it."
	gas_type = list(GAS_N2O)

/turf/simulated/floor/gas_crack/nitro/pump_reagents(var/datum/reagents/R, var/volume)
	. = ..()
	R.add_reagent(REAGENT_ID_OXYGEN, round(volume / 3, 0.1))
	R.add_reagent(REAGENT_ID_NITROGEN, round(volume / 3, 0.1))


/turf/simulated/floor/gas_crack/phoron
	desc = "Rough sand with a huge crack. A terrible smell wafts from beneath it."
	gas_type = list(GAS_PHORON)

/turf/simulated/floor/gas_crack/phoron/pump_reagents(var/datum/reagents/R, var/volume)
	. = ..()
	R.add_reagent(REAGENT_ID_PHORON, round(volume / 3, 0.1))


/turf/simulated/floor/gas_crack/air
	desc = "Rough sand with a huge crack. A fresh breeze blows through it."
	gas_type = list(GAS_O2,GAS_N2)

/turf/simulated/floor/gas_crack/air/pump_reagents(var/datum/reagents/R, var/volume)
	. = ..()
	R.add_reagent(REAGENT_ID_OXYGEN, round(volume / 2, 0.1))
	R.add_reagent(REAGENT_ID_NITROGEN, round(volume / 2, 0.1))


/turf/simulated/floor/gas_crack/terrible
	desc = "Rough sand with a huge crack. A dangerous smell wafts from beneath it."
	gas_type = list(GAS_CO2,GAS_PHORON,GAS_N2O)

/turf/simulated/floor/gas_crack/terrible/pump_reagents(var/datum/reagents/R, var/volume)
	. = ..()
	R.add_reagent(REAGENT_ID_NITROGEN, round(volume / 2, 0.1))
	R.add_reagent(REAGENT_ID_SULFUR, round(volume / 2, 0.1))
	R.add_reagent(REAGENT_ID_PHOSPHORUS, round(volume / 2, 0.1))
	R.add_reagent(REAGENT_ID_PHORON, round(volume / 3, 0.1))
