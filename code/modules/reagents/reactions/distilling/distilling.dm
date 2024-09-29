/decl/chemical_reaction/distilling
//	name = null
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

/decl/chemical_reaction/distilling/can_happen(var/datum/reagents/holder)
	if(!istype(holder, /datum/reagents/distilling) || !istype(holder.my_atom, /obj/machinery/portable_atmospherics/powered/reagent_distillery))
		return FALSE

	// Super special temperature check.
	var/obj/machinery/portable_atmospherics/powered/reagent_distillery/RD = holder.my_atom
	if(RD.current_temp < temp_range[1] || RD.current_temp > temp_range[2])
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
	result = "biomass"
	required_reagents = list("blood" = 1, "sugar" = 1, "phoron" = 0.5)
	result_amount = 1 // 40 units per sheet, requires actually using the machine, and having blood to spare.

	temp_range = list(T20C + 80, T20C + 130)
	temp_shift = -2

// Medicinal
/decl/chemical_reaction/distilling/inaprovalaze
	name = "Distilling Inaprovalaze"
	id = "distill_inaprovalaze"
	result = "inaprovalaze"
	required_reagents = list("inaprovaline" = 2, "foaming_agent" = 1)
	result_amount = 2

	reaction_rate = HALF_LIFE(10)

	temp_range = list(T0C + 100, T0C + 120)

/decl/chemical_reaction/distilling/bicaridaze
	name = "Distilling Bicaridaze"
	id = "distill_bicaridaze"
	result = "bicaridaze"
	required_reagents = list("bicaridine" = 2, "foaming_agent" = 1)
	result_amount = 2

	reaction_rate = HALF_LIFE(10)

	temp_range = list(T0C + 110, T0C + 130)

/decl/chemical_reaction/distilling/dermalaze
	name = "Distilling Dermalaze"
	id = "distill_dermalaze"
	result = "dermalaze"
	required_reagents = list("dermaline" = 2, "foaming_agent" = 1)
	result_amount = 2

	reaction_rate = HALF_LIFE(10)

	temp_range = list(T0C + 115, T0C + 130)

/decl/chemical_reaction/distilling/spacomycaze
	name = "Distilling Spacomycaze"
	id = "distill_spacomycaze"
	result = "spacomycaze"
	required_reagents = list("paracetamol" = 1, "spaceacillin" = 1, "foaming_agent" = 1)
	result_amount = 2

	reaction_rate = HALF_LIFE(10)

	temp_range = list(T0C + 100, T0C + 120)

/decl/chemical_reaction/distilling/tricorlidaze
	name = "Distilling Tricorlidaze"
	id = "distill_tricorlidaze"
	result = "tricorlidaze"
	required_reagents = list("tricordrazine" = 1, "sterilizine" = 1, "foaming_agent" = 1)
	result_amount = 2

	reaction_rate = HALF_LIFE(10)

	temp_range = list(T0C + 100, T0C + 120)

/decl/chemical_reaction/distilling/synthplas
	name = "Distilling Synthplas"
	id = "distill_synthplas"
	result = "synthblood_dilute"
	required_reagents = list("protein" = 2, "antibodies" = 1, "bicaridine" = 1)
	result_amount = 3

	reaction_rate = HALF_LIFE(15)

	temp_range = list(T0C + 110, T0C + 130)

// Alcohol
/decl/chemical_reaction/distilling/beer
	name = "Distilling Beer"
	id = "distill_beer"
	result = "beer"
	required_reagents = list("nutriment" = 1, "water" = 1, "sugar" = 1)
	result_amount = 2

	reaction_rate = HALF_LIFE(30)

	temp_range = list(T20C, T20C + 2)

/decl/chemical_reaction/distilling/ale
	name = "Distilling Ale"
	id = "distill_ale"
	result = "ale"
	required_reagents = list("nutriment" = 1, "beer" = 1)
	inhibitors = list("water" = 1)
	result_amount = 2

	reaction_rate = HALF_LIFE(30)

	temp_shift = 0.5
	temp_range = list(T0C + 7, T0C + 13)

// Unique
/decl/chemical_reaction/distilling/berserkjuice
	name = "Distilling Brute Juice"
	id = "distill_brutejuice"
	result = "berserkmed"
	required_reagents = list("biomass" = 1, "hyperzine" = 3, "synaptizine" = 2, "phoron" = 1)
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
	result = "cryoslurry"
	required_reagents = list("frostoil" = 7, "enzyme" = 3, "plasticide" = 3, "foaming_agent" = 2)
	inhibitors = list("water" = 5)
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
	result = "lichpowder"
	required_reagents = list("zombiepowder" = 2, "leporazine" = 1)
	result_amount = 2

	reaction_rate = HALF_LIFE(8)

	temp_range = list(T0C + 100, T0C + 150)

/decl/chemical_reaction/distilling/necroxadone
	name = "Distilling Necroxadone"
	id = "distill_necroxadone"
	result = "necroxadone"
	required_reagents = list("lichpowder" = 1, "cryoxadone" = 1, "carthatoline" = 1)
	result_amount = 2

	catalysts = list("phoron" = 5)

	reaction_rate = HALF_LIFE(20)

	temp_range = list(T0C + 90, T0C + 95)
