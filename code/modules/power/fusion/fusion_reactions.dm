GLOBAL_LIST(fusion_reactions)

/decl/fusion_reaction
	var/p_react = "" // Primary reactant.
	var/s_react = "" // Secondary reactant.
	var/minimum_energy_level = 1
	var/energy_consumption = 0
	var/energy_production = 0
	var/radiation = 0
	var/instability = 0
	var/list/products = list()
	var/minimum_reaction_temperature = 100

/decl/fusion_reaction/proc/handle_reaction_special(var/obj/effect/fusion_em_field/holder)
	return 0

/proc/get_fusion_reaction(var/p_react, var/s_react, var/m_energy)
	if(!GLOB.fusion_reactions)
		GLOB.fusion_reactions = list()
		for(var/rtype in subtypesof(/decl/fusion_reaction)
		)
			var/decl/fusion_reaction/cur_reaction = new rtype()
			if(!GLOB.fusion_reactions[cur_reaction.p_react])
				GLOB.fusion_reactions[cur_reaction.p_react] = list()
			GLOB.fusion_reactions[cur_reaction.p_react][cur_reaction.s_react] = cur_reaction
			if(!GLOB.fusion_reactions[cur_reaction.s_react])
				GLOB.fusion_reactions[cur_reaction.s_react] = list()
			GLOB.fusion_reactions[cur_reaction.s_react][cur_reaction.p_react] = cur_reaction

	if(GLOB.fusion_reactions.Find(p_react))
		var/list/secondary_reactions = GLOB.fusion_reactions[p_react]
		if(secondary_reactions.Find(s_react))
			return GLOB.fusion_reactions[p_react][s_react]

// Material fuels
//  deuterium
//  tritium
//  phoron
//  supermatter

// Virtual fuels
//  helium-3
//  lithium-6
//  boron-11

// Basic power production reactions.
/decl/fusion_reaction/deuterium_deuterium
	p_react = REAGENT_ID_DEUTERIUM
	s_react = REAGENT_ID_DEUTERIUM
	energy_consumption = 1
	energy_production = 2
// Advanced production reactions (todo)

/decl/fusion_reaction/deuterium_helium
	p_react = REAGENT_ID_DEUTERIUM
	s_react = REAGENT_ID_HELIUM3
	energy_consumption = 1
	energy_production = 5

/decl/fusion_reaction/deuterium_tritium
	p_react = REAGENT_ID_DEUTERIUM
	s_react = REAGENT_ID_SLIMEJELLY
	energy_consumption = 1
	energy_production = 1
	products = list(REAGENT_ID_HELIUM3 = 1)
	instability = 0.5

/decl/fusion_reaction/deuterium_lithium
	p_react = REAGENT_ID_DEUTERIUM
	s_react = REAGENT_ID_LITHIUM
	energy_consumption = 2
	energy_production = 0
	radiation = 3
	products = list(REAGENT_ID_SLIMEJELLY= 1)
	instability = 1

// Unideal/material production reactions
/decl/fusion_reaction/oxygen_oxygen
	p_react = REAGENT_ID_OXYGEN
	s_react = REAGENT_ID_OXYGEN
	energy_consumption = 10
	energy_production = 0
	instability = 5
	radiation = 5
	products = list(REAGENT_ID_SILICON= 1)

/decl/fusion_reaction/iron_iron
	p_react = REAGENT_ID_IRON
	s_react = REAGENT_ID_IRON
	products = list(REAGENT_ID_SILVER = 1, REAGENT_ID_GOLD = 1, REAGENT_ID_PLATINUM = 1) // Not realistic but w/e
	energy_consumption = 10
	energy_production = 0
	instability = 2
	minimum_reaction_temperature = 10000

/decl/fusion_reaction/phoron_hydrogen
	p_react = REAGENT_ID_HYDROGEN
	s_react = REAGENT_ID_PHORON
	energy_consumption = 10
	energy_production = 0
	instability = 5
	products = list("mydrogen" = 1)
	minimum_reaction_temperature = 8000

// VERY UNIDEAL REACTIONS.
/decl/fusion_reaction/phoron_supermatter
	p_react = REAGENT_ID_SUPERMATTER
	s_react = REAGENT_ID_PHORON
	energy_consumption = 0
	energy_production = 5
	radiation = 20
	instability = 20

/decl/fusion_reaction/phoron_supermatter/handle_reaction_special(var/obj/effect/fusion_em_field/holder)

	wormhole_event()

	var/turf/origin = get_turf(holder)
	holder.Rupture()
	qdel(holder)
	var/radiation_level = 200

	// Copied from the SM for proof of concept. //Not any more --Cirra //Use the whole z proc --Leshana
	SSradiation.z_radiate(locate(1, 1, holder.z), radiation_level, 1)

	for(var/mob/living/mob in GLOB.living_mob_list)
		var/turf/T = get_turf(mob)
		if(T && (holder.z == T.z))
			if(ishuman(mob))
				var/mob/living/carbon/human/H = mob
				H.hallucination += rand(100,150)

	for(var/obj/machinery/fusion_fuel_injector/I in range(world.view, origin))
		if(I.cur_assembly && I.cur_assembly.fuel_type == REAGENT_ID_SUPERMATTER)
			explosion(get_turf(I), 1, 2, 3)
			spawn(5)
				if(I && I.loc)
					qdel(I)

	sleep(5)
	explosion(origin, 1, 2, 5)

	return 1

// High end reactions.
/decl/fusion_reaction/boron_hydrogen
	p_react = REAGENT_ID_BORON11
	s_react = REAGENT_ID_HYDROGEN
	minimum_energy_level = FUSION_HEAT_CAP * 0.5
	energy_consumption = 3
	energy_production = 15
	radiation = 3
	instability = 3

/decl/fusion_reaction/hydrogen_hydrogen
	p_react = REAGENT_ID_HYDROGEN
	s_react = REAGENT_ID_HYDROGEN
	minimum_energy_level = FUSION_HEAT_CAP * 0.75
	energy_consumption = 0
	energy_production = 20
	radiation = 5
	instability = 5
