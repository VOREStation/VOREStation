//helper that ensures the reaction rate holds after iterating
//Ex. REACTION_RATE(0.3) means that 30% of the reagents will react each chemistry tick (~2 seconds by default).
#define REACTION_RATE(rate) (1.0 - (1.0-rate)**(1.0/PROCESS_REACTION_ITER))

//helper to define reaction rate in terms of half-life
//Ex.
//HALF_LIFE(0) -> Reaction completes immediately (default chems)
//HALF_LIFE(1) -> Half of the reagents react immediately, the rest over the following ticks.
//HALF_LIFE(2) -> Half of the reagents are consumed after 2 chemistry ticks.
//HALF_LIFE(3) -> Half of the reagents are consumed after 3 chemistry ticks.
#define HALF_LIFE(ticks) (ticks? 1.0 - (0.5)**(1.0/(ticks*PROCESS_REACTION_ITER)) : 1.0)

/datum/chemical_reaction
	var/name = null
	var/id = null
	var/result = null
	var/list/required_reagents = list()
	var/list/catalysts = list()
	var/list/inhibitors = list()
	var/result_amount = 0

	//how far the reaction proceeds each time it is processed. Used with either REACTION_RATE or HALF_LIFE macros.
	var/reaction_rate = HALF_LIFE(0)

	//if less than 1, the reaction will be inhibited if the ratio of products/reagents is too high.
	//0.5 = 50% yield -> reaction will only proceed halfway until products are removed.
	var/yield = 1.0

	//If limits on reaction rate would leave less than this amount of any reagent (adjusted by the reaction ratios),
	//the reaction goes to completion. This is to prevent reactions from going on forever with tiny reagent amounts.
	var/min_reaction = 2

	var/mix_message = "The solution begins to bubble."
	var/reaction_sound = 'sound/effects/bubbles.ogg'

	var/log_is_important = 0 // If this reaction should be considered important for logging. Important recipes message admins when mixed, non-important ones just log to file.

/datum/chemical_reaction/proc/can_happen(var/datum/reagents/holder)
	//check that all the required reagents are present
	if(!holder.has_all_reagents(required_reagents))
		return 0

	//check that all the required catalysts are present in the required amount
	if(!holder.has_all_reagents(catalysts))
		return 0

	//check that none of the inhibitors are present in the required amount
	if(holder.has_any_reagent(inhibitors))
		return 0

	return 1

/datum/chemical_reaction/proc/calc_reaction_progress(var/datum/reagents/holder, var/reaction_limit)
	var/progress = reaction_limit * reaction_rate //simple exponential progression

	//calculate yield
	if(1-yield > 0.001) //if yield ratio is big enough just assume it goes to completion
		/*
			Determine the max amount of product by applying the yield condition:
			(max_product/result_amount) / reaction_limit == yield/(1-yield)

			We make use of the fact that:
			reaction_limit = (holder.get_reagent_amount(reactant) / required_reagents[reactant]) of the limiting reagent.
		*/
		var/yield_ratio = yield/(1-yield)
		var/max_product = yield_ratio * reaction_limit * result_amount //rearrange to obtain max_product
		var/yield_limit = max(0, max_product - holder.get_reagent_amount(result))/result_amount

		progress = min(progress, yield_limit) //apply yield limit

	//apply min reaction progress - wasn't sure if this should go before or after applying yield
	//I guess people can just have their miniscule reactions go to completion regardless of yield.
	for(var/reactant in required_reagents)
		var/remainder = holder.get_reagent_amount(reactant) - progress*required_reagents[reactant]
		if(remainder <= min_reaction*required_reagents[reactant])
			progress = reaction_limit
			break

	return progress

/datum/chemical_reaction/process(var/datum/reagents/holder)
	//determine how far the reaction can proceed
	var/list/reaction_limits = list()
	for(var/reactant in required_reagents)
		reaction_limits += holder.get_reagent_amount(reactant) / required_reagents[reactant]

	//determine how far the reaction proceeds
	var/reaction_limit = min(reaction_limits)
	var/progress_limit = calc_reaction_progress(holder, reaction_limit)

	var/reaction_progress = min(reaction_limit, progress_limit) //no matter what, the reaction progress cannot exceed the stoichiometric limit.

	//need to obtain the new reagent's data before anything is altered
	var/data = send_data(holder, reaction_progress)

	//remove the reactants
	for(var/reactant in required_reagents)
		var/amt_used = required_reagents[reactant] * reaction_progress
		holder.remove_reagent(reactant, amt_used, safety = 1)

	//add the product
	var/amt_produced = result_amount * reaction_progress
	if(result)
		holder.add_reagent(result, amt_produced, data, safety = 1)

	on_reaction(holder, amt_produced)

	return reaction_progress

//called when a reaction processes
/datum/chemical_reaction/proc/on_reaction(var/datum/reagents/holder, var/created_volume)
	return

//called after processing reactions, if they occurred
/datum/chemical_reaction/proc/post_reaction(var/datum/reagents/holder)
	var/atom/container = holder.my_atom
	if(mix_message && container && !ismob(container))
		var/turf/T = get_turf(container)
		var/list/seen = viewers(4, T)
		for(var/mob/M in seen)
			M.show_message("<span class='notice'>[bicon(container)] [mix_message]</span>", 1)
		playsound(T, reaction_sound, 80, 1)

//obtains any special data that will be provided to the reaction products
//this is called just before reactants are removed.
/datum/chemical_reaction/proc/send_data(var/datum/reagents/holder, var/reaction_limit)
	return null

/* Common reactions */

/datum/chemical_reaction/inaprovaline
	name = "Inaprovaline"
	id = "inaprovaline"
	result = "inaprovaline"
	required_reagents = list("oxygen" = 1, "carbon" = 1, "sugar" = 1)
	result_amount = 3

/datum/chemical_reaction/dylovene
	name = "Dylovene"
	id = "anti_toxin"
	result = "anti_toxin"
	required_reagents = list("silicon" = 1, "potassium" = 1, "nitrogen" = 1)
	result_amount = 3

/datum/chemical_reaction/carthatoline
	name = "Carthatoline"
	id = "carthatoline"
	result = "carthatoline"
	required_reagents = list("anti_toxin" = 1, "carbon" = 2, "phoron" = 0.1)
	catalysts = list("phoron" = 1)
	result_amount = 2

/datum/chemical_reaction/paracetamol
	name = "Paracetamol"
	id = "paracetamol"
	result = "paracetamol"
	required_reagents = list("inaprovaline" = 1, "nitrogen" = 1, "water" = 1)
	result_amount = 2

/datum/chemical_reaction/tramadol
	name = "Tramadol"
	id = "tramadol"
	result = "tramadol"
	required_reagents = list("paracetamol" = 1, "ethanol" = 1, "oxygen" = 1)
	result_amount = 3

/datum/chemical_reaction/oxycodone
	name = "Oxycodone"
	id = "oxycodone"
	result = "oxycodone"
	required_reagents = list("ethanol" = 1, "tramadol" = 1)
	catalysts = list("phoron" = 5)
	result_amount = 1

/datum/chemical_reaction/sterilizine
	name = "Sterilizine"
	id = "sterilizine"
	result = "sterilizine"
	required_reagents = list("ethanol" = 1, "anti_toxin" = 1, "chlorine" = 1)
	result_amount = 3

/datum/chemical_reaction/silicate
	name = "Silicate"
	id = "silicate"
	result = "silicate"
	required_reagents = list("aluminum" = 1, "silicon" = 1, "oxygen" = 1)
	result_amount = 3

/datum/chemical_reaction/mutagen
	name = "Unstable mutagen"
	id = "mutagen"
	result = "mutagen"
	required_reagents = list("radium" = 1, "phosphorus" = 1, "chlorine" = 1)
	result_amount = 3

/datum/chemical_reaction/water
	name = "Water"
	id = "water"
	result = "water"
	required_reagents = list("oxygen" = 1, "hydrogen" = 2)
	result_amount = 1

/datum/chemical_reaction/thermite
	name = "Thermite"
	id = "thermite"
	result = "thermite"
	required_reagents = list("aluminum" = 1, "iron" = 1, "oxygen" = 1)
	result_amount = 3

/datum/chemical_reaction/space_drugs
	name = "Space Drugs"
	id = "space_drugs"
	result = "space_drugs"
	required_reagents = list("mercury" = 1, "sugar" = 1, "lithium" = 1)
	result_amount = 3

/datum/chemical_reaction/lube
	name = "Space Lube"
	id = "lube"
	result = "lube"
	required_reagents = list("water" = 1, "silicon" = 1, "oxygen" = 1)
	result_amount = 4

/datum/chemical_reaction/pacid
	name = "Polytrinic acid"
	id = "pacid"
	result = "pacid"
	required_reagents = list("sacid" = 1, "chlorine" = 1, "potassium" = 1)
	result_amount = 3

/datum/chemical_reaction/synaptizine
	name = "Synaptizine"
	id = "synaptizine"
	result = "synaptizine"
	required_reagents = list("sugar" = 1, "lithium" = 1, "water" = 1)
	result_amount = 3

/datum/chemical_reaction/hyronalin
	name = "Hyronalin"
	id = "hyronalin"
	result = "hyronalin"
	required_reagents = list("radium" = 1, "anti_toxin" = 1)
	result_amount = 2

/datum/chemical_reaction/arithrazine
	name = "Arithrazine"
	id = "arithrazine"
	result = "arithrazine"
	required_reagents = list("hyronalin" = 1, "hydrogen" = 1)
	result_amount = 2

/datum/chemical_reaction/impedrezene
	name = "Impedrezene"
	id = "impedrezene"
	result = "impedrezene"
	required_reagents = list("mercury" = 1, "oxygen" = 1, "sugar" = 1)
	result_amount = 2

/datum/chemical_reaction/kelotane
	name = "Kelotane"
	id = "kelotane"
	result = "kelotane"
	required_reagents = list("silicon" = 1, "carbon" = 1)
	result_amount = 2
	log_is_important = 1

/datum/chemical_reaction/peridaxon
	name = "Peridaxon"
	id = "peridaxon"
	result = "peridaxon"
	required_reagents = list("bicaridine" = 2, "clonexadone" = 2)
	catalysts = list("phoron" = 5)
	result_amount = 2

/datum/chemical_reaction/osteodaxon
	name = "Osteodaxon"
	id = "osteodaxon"
	result = "osteodaxon"
	required_reagents = list("bicaridine" = 2, "phoron" = 0.1, "carpotoxin" = 1)
	catalysts = list("phoron" = 5)
	inhibitors = list("clonexadone" = 1) // Messes with cryox
	result_amount = 2

/datum/chemical_reaction/respirodaxon
	name = "Respirodaxon"
	id = "respirodaxon"
	result = "respirodaxon"
	required_reagents = list("dexalinp" = 2, "biomass" = 2, "phoron" = 1)
	catalysts = list("phoron" = 5)
	inhibitors = list("dexalin" = 1)
	result_amount = 2

/datum/chemical_reaction/gastirodaxon
	name = "Gastirodaxon"
	id = "gastirodaxon"
	result = "gastirodaxon"
	required_reagents = list("carthatoline" = 1, "biomass" = 2, "tungsten" = 2)
	catalysts = list("phoron" = 5)
	inhibitors = list("lithium" = 1)
	result_amount = 3

/datum/chemical_reaction/hepanephrodaxon
	name = "Hepanephrodaxon"
	id = "hepanephrodaxon"
	result = "hepanephrodaxon"
	required_reagents = list("carthatoline" = 2, "biomass" = 2, "lithium" = 1)
	catalysts = list("phoron" = 5)
	inhibitors = list("tungsten" = 1)
	result_amount = 2

/datum/chemical_reaction/cordradaxon
	name = "Cordradaxon"
	id = "cordradaxon"
	result = "cordradaxon"
	required_reagents = list("potassium_chlorophoride" = 1, "biomass" = 2, "bicaridine" = 2)
	catalysts = list("phoron" = 5)
	inhibitors = list("clonexadone" = 1)
	result_amount = 2

/datum/chemical_reaction/virus_food
	name = "Virus Food"
	id = "virusfood"
	result = "virusfood"
	required_reagents = list("water" = 1, "milk" = 1)
	result_amount = 5

/datum/chemical_reaction/leporazine
	name = "Leporazine"
	id = "leporazine"
	result = "leporazine"
	required_reagents = list("silicon" = 1, "copper" = 1)
	catalysts = list("phoron" = 5)
	result_amount = 2

/datum/chemical_reaction/cryptobiolin
	name = "Cryptobiolin"
	id = "cryptobiolin"
	result = "cryptobiolin"
	required_reagents = list("potassium" = 1, "oxygen" = 1, "sugar" = 1)
	result_amount = 3

/datum/chemical_reaction/tricordrazine
	name = "Tricordrazine"
	id = "tricordrazine"
	result = "tricordrazine"
	required_reagents = list("inaprovaline" = 1, "anti_toxin" = 1)
	result_amount = 2

/datum/chemical_reaction/alkysine
	name = "Alkysine"
	id = "alkysine"
	result = "alkysine"
	required_reagents = list("chlorine" = 1, "nitrogen" = 1, "anti_toxin" = 1)
	result_amount = 2

/datum/chemical_reaction/dexalin
	name = "Dexalin"
	id = "dexalin"
	result = "dexalin"
	required_reagents = list("oxygen" = 2, "phoron" = 0.1)
	catalysts = list("phoron" = 1)
	inhibitors = list("water" = 1) // Messes with cryox
	result_amount = 1

/datum/chemical_reaction/dermaline
	name = "Dermaline"
	id = "dermaline"
	result = "dermaline"
	required_reagents = list("oxygen" = 1, "phosphorus" = 1, "kelotane" = 1)
	result_amount = 3

/datum/chemical_reaction/dexalinp
	name = "Dexalin Plus"
	id = "dexalinp"
	result = "dexalinp"
	required_reagents = list("dexalin" = 1, "carbon" = 1, "iron" = 1)
	result_amount = 3

/datum/chemical_reaction/bicaridine
	name = "Bicaridine"
	id = "bicaridine"
	result = "bicaridine"
	required_reagents = list("inaprovaline" = 1, "carbon" = 1)
	inhibitors = list("sugar" = 1) // Messes up with inaprovaline
	result_amount = 2

/datum/chemical_reaction/myelamine
	name = "Myelamine"
	id = "myelamine"
	result = "myelamine"
	required_reagents = list("bicaridine" = 1, "iron" = 2, "spidertoxin" = 1)
	result_amount = 2

/datum/chemical_reaction/hyperzine
	name = "Hyperzine"
	id = "hyperzine"
	result = "hyperzine"
	required_reagents = list("sugar" = 1, "phosphorus" = 1, "sulfur" = 1)
	result_amount = 3

/datum/chemical_reaction/stimm
	name = "Stimm"
	id = "stimm"
	result = "stimm"
	required_reagents = list("left4zed" = 1, "fuel" = 1)
	catalysts = list("fuel" = 5)
	result_amount = 2

/datum/chemical_reaction/ryetalyn
	name = "Ryetalyn"
	id = "ryetalyn"
	result = "ryetalyn"
	required_reagents = list("arithrazine" = 1, "carbon" = 1)
	result_amount = 2

/datum/chemical_reaction/cryoxadone
	name = "Cryoxadone"
	id = "cryoxadone"
	result = "cryoxadone"
	required_reagents = list("dexalin" = 1, "water" = 1, "oxygen" = 1)
	result_amount = 3

/datum/chemical_reaction/clonexadone
	name = "Clonexadone"
	id = "clonexadone"
	result = "clonexadone"
	required_reagents = list("cryoxadone" = 1, "sodium" = 1, "phoron" = 0.1)
	catalysts = list("phoron" = 5)
	result_amount = 2

/datum/chemical_reaction/mortiferin
	name = "Mortiferin"
	id = "mortiferin"
	result = "mortiferin"
	required_reagents = list("cryptobiolin" = 1, "clonexadone" = 1, "corophizine" = 1)
	result_amount = 2
	catalysts = list("phoron" = 5)

/datum/chemical_reaction/spaceacillin
	name = "Spaceacillin"
	id = "spaceacillin"
	result = "spaceacillin"
	required_reagents = list("cryptobiolin" = 1, "inaprovaline" = 1)
	result_amount = 2

/datum/chemical_reaction/corophizine
	name = "Corophizine"
	id = "corophizine"
	result = "corophizine"
	required_reagents = list("spaceacillin" = 1, "carbon" = 1, "phoron" = 0.1)
	catalysts = list("phoron" = 5)
	result_amount = 2

/datum/chemical_reaction/immunosuprizine
	name = "Immunosuprizine"
	id = "immunosuprizine"
	result = "immunosuprizine"
	required_reagents = list("corophizine" = 1, "tungsten" = 1, "sacid" = 1)
	catalysts = list("phoron" = 5)
	result_amount = 2

/datum/chemical_reaction/imidazoline
	name = "imidazoline"
	id = "imidazoline"
	result = "imidazoline"
	required_reagents = list("carbon" = 1, "hydrogen" = 1, "anti_toxin" = 1)
	result_amount = 2

/datum/chemical_reaction/ethylredoxrazine
	name = "Ethylredoxrazine"
	id = "ethylredoxrazine"
	result = "ethylredoxrazine"
	required_reagents = list("oxygen" = 1, "anti_toxin" = 1, "carbon" = 1)
	result_amount = 3

/datum/chemical_reaction/calciumcarbonate
	name = "Calcium Carbonate"
	id = "calciumcarbonate"
	result = "calciumcarbonate"
	required_reagents = list("oxygen" = 3, "calcium" = 1, "carbon" = 1)
	result_amount = 2

/datum/chemical_reaction/soporific
	name = "Soporific"
	id = "stoxin"
	result = "stoxin"
	required_reagents = list("chloralhydrate" = 1, "sugar" = 4)
	inhibitors = list("phosphorus") // Messes with the smoke
	result_amount = 5

/datum/chemical_reaction/chloralhydrate
	name = "Chloral Hydrate"
	id = "chloralhydrate"
	result = "chloralhydrate"
	required_reagents = list("ethanol" = 1, "chlorine" = 3, "water" = 1)
	result_amount = 1

/datum/chemical_reaction/potassium_chloride
	name = "Potassium Chloride"
	id = "potassium_chloride"
	result = "potassium_chloride"
	required_reagents = list("sodiumchloride" = 1, "potassium" = 1)
	result_amount = 2

/datum/chemical_reaction/potassium_chlorophoride
	name = "Potassium Chlorophoride"
	id = "potassium_chlorophoride"
	result = "potassium_chlorophoride"
	required_reagents = list("potassium_chloride" = 1, "phoron" = 1, "chloralhydrate" = 1)
	result_amount = 4

/datum/chemical_reaction/zombiepowder
	name = "Zombie Powder"
	id = "zombiepowder"
	result = "zombiepowder"
	required_reagents = list("carpotoxin" = 5, "stoxin" = 5, "copper" = 5)
	result_amount = 2

/datum/chemical_reaction/carpotoxin
	name = "Carpotoxin"
	id = "carpotoxin"
	result = "carpotoxin"
	required_reagents = list("spidertoxin" = 2, "biomass" = 1, "sifsap" = 2)
	catalysts = list("sifsap" = 10)
	inhibitors = list("radium" = 1)
	result_amount = 2

/datum/chemical_reaction/mindbreaker
	name = "Mindbreaker Toxin"
	id = "mindbreaker"
	result = "mindbreaker"
	required_reagents = list("silicon" = 1, "hydrogen" = 1, "anti_toxin" = 1)
	result_amount = 3

/datum/chemical_reaction/lipozine
	name = "Lipozine"
	id = "Lipozine"
	result = "lipozine"
	required_reagents = list("sodiumchloride" = 1, "ethanol" = 1, "radium" = 1)
	result_amount = 3

/datum/chemical_reaction/surfactant
	name = "Foam surfactant"
	id = "foam surfactant"
	result = "fluorosurfactant"
	required_reagents = list("fluorine" = 2, "carbon" = 2, "sacid" = 1)
	result_amount = 5

/datum/chemical_reaction/ammonia
	name = "Ammonia"
	id = "ammonia"
	result = "ammonia"
	required_reagents = list("hydrogen" = 3, "nitrogen" = 1)
	inhibitors = list("phoron" = 1) // Messes with lexorin
	result_amount = 3

/datum/chemical_reaction/diethylamine
	name = "Diethylamine"
	id = "diethylamine"
	result = "diethylamine"
	required_reagents = list ("ammonia" = 1, "ethanol" = 1)
	result_amount = 2

/datum/chemical_reaction/left4zed
	name = "Left4Zed"
	id = "left4zed"
	result = "left4zed"
	required_reagents = list ("diethylamine" = 2, "mutagen" = 1)
	result_amount = 3

/datum/chemical_reaction/robustharvest
	name = "RobustHarvest"
	id = "robustharvest"
	result = "robustharvest"
	required_reagents = list ("ammonia" = 1, "calcium" = 1, "neurotoxic_protein" = 1)
	result_amount = 3

/datum/chemical_reaction/space_cleaner
	name = "Space cleaner"
	id = "cleaner"
	result = "cleaner"
	required_reagents = list("ammonia" = 1, "water" = 1)
	result_amount = 2

/datum/chemical_reaction/plantbgone
	name = "Plant-B-Gone"
	id = "plantbgone"
	result = "plantbgone"
	required_reagents = list("toxin" = 1, "water" = 4)
	result_amount = 5

/datum/chemical_reaction/foaming_agent
	name = "Foaming Agent"
	id = "foaming_agent"
	result = "foaming_agent"
	required_reagents = list("lithium" = 1, "hydrogen" = 1)
	result_amount = 1

/datum/chemical_reaction/glycerol
	name = "Glycerol"
	id = "glycerol"
	result = "glycerol"
	required_reagents = list("cornoil" = 3, "sacid" = 1)
	result_amount = 1

/datum/chemical_reaction/sodiumchloride
	name = "Sodium Chloride"
	id = "sodiumchloride"
	result = "sodiumchloride"
	required_reagents = list("sodium" = 1, "chlorine" = 1)
	result_amount = 2

/datum/chemical_reaction/condensedcapsaicin
	name = "Condensed Capsaicin"
	id = "condensedcapsaicin"
	result = "condensedcapsaicin"
	required_reagents = list("capsaicin" = 2)
	catalysts = list("phoron" = 5)
	result_amount = 1

/datum/chemical_reaction/coolant
	name = "Coolant"
	id = "coolant"
	result = "coolant"
	required_reagents = list("tungsten" = 1, "oxygen" = 1, "water" = 1)
	result_amount = 3
	log_is_important = 1

/datum/chemical_reaction/rezadone
	name = "Rezadone"
	id = "rezadone"
	result = "rezadone"
	required_reagents = list("carpotoxin" = 1, "cryptobiolin" = 1, "copper" = 1)
	result_amount = 3

/datum/chemical_reaction/lexorin
	name = "Lexorin"
	id = "lexorin"
	result = "lexorin"
	required_reagents = list("phoron" = 1, "hydrogen" = 1, "nitrogen" = 1)
	result_amount = 3

/datum/chemical_reaction/methylphenidate
	name = "Methylphenidate"
	id = "methylphenidate"
	result = "methylphenidate"
	required_reagents = list("mindbreaker" = 1, "hydrogen" = 1)
	result_amount = 3

/datum/chemical_reaction/citalopram
	name = "Citalopram"
	id = "citalopram"
	result = "citalopram"
	required_reagents = list("mindbreaker" = 1, "carbon" = 1)
	result_amount = 3

/datum/chemical_reaction/paroxetine
	name = "Paroxetine"
	id = "paroxetine"
	result = "paroxetine"
	required_reagents = list("mindbreaker" = 1, "oxygen" = 1, "inaprovaline" = 1)
	result_amount = 3

/datum/chemical_reaction/neurotoxin
	name = "Neurotoxin"
	id = "neurotoxin"
	result = "neurotoxin"
	required_reagents = list("gargleblaster" = 1, "stoxin" = 1)
	result_amount = 2

/datum/chemical_reaction/luminol
	name = "Luminol"
	id = "luminol"
	result = "luminol"
	required_reagents = list("hydrogen" = 2, "carbon" = 2, "ammonia" = 2)
	result_amount = 6

/* Solidification */

/datum/chemical_reaction/solidification
	name = "Solid Iron"
	id = "solidiron"
	result = null
	required_reagents = list("frostoil" = 5, "iron" = REAGENTS_PER_SHEET)
	result_amount = 1
	var/sheet_to_give = /obj/item/stack/material/iron

/datum/chemical_reaction/solidification/on_reaction(var/datum/reagents/holder, var/created_volume)
	new sheet_to_give(get_turf(holder.my_atom), created_volume)
	return


/datum/chemical_reaction/solidification/phoron
	name = "Solid Phoron"
	id = "solidphoron"
	required_reagents = list("frostoil" = 5, "phoron" = REAGENTS_PER_SHEET)
	sheet_to_give = /obj/item/stack/material/phoron


/datum/chemical_reaction/solidification/silver
	name = "Solid Silver"
	id = "solidsilver"
	required_reagents = list("frostoil" = 5, "silver" = REAGENTS_PER_SHEET)
	sheet_to_give = /obj/item/stack/material/silver


/datum/chemical_reaction/solidification/gold
	name = "Solid Gold"
	id = "solidgold"
	required_reagents = list("frostoil" = 5, "gold" = REAGENTS_PER_SHEET)
	sheet_to_give = /obj/item/stack/material/gold


/datum/chemical_reaction/solidification/platinum
	name = "Solid Platinum"
	id = "solidplatinum"
	required_reagents = list("frostoil" = 5, "platinum" = REAGENTS_PER_SHEET)
	sheet_to_give = /obj/item/stack/material/platinum


/datum/chemical_reaction/solidification/uranium
	name = "Solid Uranium"
	id = "soliduranium"
	required_reagents = list("frostoil" = 5, "uranium" = REAGENTS_PER_SHEET)
	sheet_to_give = /obj/item/stack/material/uranium


/datum/chemical_reaction/solidification/hydrogen
	name = "Solid Hydrogen"
	id = "solidhydrogen"
	required_reagents = list("frostoil" = 100, "hydrogen" = REAGENTS_PER_SHEET)
	sheet_to_give = /obj/item/stack/material/mhydrogen


// These are from Xenobio.
/datum/chemical_reaction/solidification/steel
	name = "Solid Steel"
	id = "solidsteel"
	required_reagents = list("frostoil" = 5, "steel" = REAGENTS_PER_SHEET)
	sheet_to_give = /obj/item/stack/material/steel


/datum/chemical_reaction/solidification/plasteel
	name = "Solid Plasteel"
	id = "solidplasteel"
	required_reagents = list("frostoil" = 10, "plasteel" = REAGENTS_PER_SHEET)
	sheet_to_give = /obj/item/stack/material/plasteel


/datum/chemical_reaction/plastication
	name = "Plastic"
	id = "solidplastic"
	result = null
	required_reagents = list("pacid" = 1, "plasticide" = 2)
	result_amount = 1

/datum/chemical_reaction/plastication/on_reaction(var/datum/reagents/holder, var/created_volume)
	new /obj/item/stack/material/plastic(get_turf(holder.my_atom), created_volume)
	return

/* Grenade reactions */

/datum/chemical_reaction/explosion_potassium
	name = "Explosion"
	id = "explosion_potassium"
	result = null
	required_reagents = list("water" = 1, "potassium" = 1)
	result_amount = 2
	mix_message = null

/datum/chemical_reaction/explosion_potassium/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/datum/effect/effect/system/reagents_explosion/e = new()
	e.set_up(round (created_volume/10, 1), holder.my_atom, 0, 0)
	if(isliving(holder.my_atom))
		e.amount *= 0.5
		var/mob/living/L = holder.my_atom
		if(L.stat != DEAD)
			e.amount *= 0.5
	//VOREStation Add Start
	else
		holder.clear_reagents() //No more powergaming by creating a tiny amount of this
	//VORESTation Add End
	e.start()
	//holder.clear_reagents() //VOREStation Removal
	return

/datum/chemical_reaction/flash_powder
	name = "Flash powder"
	id = "flash_powder"
	result = null
	required_reagents = list("aluminum" = 1, "potassium" = 1, "sulfur" = 1 )
	result_amount = null

/datum/chemical_reaction/flash_powder/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(2, 1, location)
	s.start()
	for(var/mob/living/carbon/M in viewers(world.view, location))
		switch(get_dist(M, location))
			if(0 to 3)
				if(hasvar(M, "glasses"))
					if(istype(M:glasses, /obj/item/clothing/glasses/sunglasses))
						continue

				M.flash_eyes()
				M.Weaken(15)

			if(4 to 5)
				if(hasvar(M, "glasses"))
					if(istype(M:glasses, /obj/item/clothing/glasses/sunglasses))
						continue

				M.flash_eyes()
				M.Stun(5)

/datum/chemical_reaction/emp_pulse
	name = "EMP Pulse"
	id = "emp_pulse"
	result = null
	required_reagents = list("uranium" = 1, "iron" = 1) // Yes, laugh, it's the best recipe I could think of that makes a little bit of sense
	result_amount = 2

/datum/chemical_reaction/emp_pulse/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	// 100 created volume = 4 heavy range & 7 light range. A few tiles smaller than traitor EMP grandes.
	// 200 created volume = 8 heavy range & 14 light range. 4 tiles larger than traitor EMP grenades.
	empulse(location, round(created_volume / 24), round(created_volume / 20), round(created_volume / 18), round(created_volume / 14), 1)
	//VOREStation Edit Start
	if(!isliving(holder.my_atom)) //No more powergaming by creating a tiny amount of this
		holder.clear_reagents()
	//VOREStation Edit End
	return

/datum/chemical_reaction/nitroglycerin
	name = "Nitroglycerin"
	id = "nitroglycerin"
	result = "nitroglycerin"
	required_reagents = list("glycerol" = 1, "pacid" = 1, "sacid" = 1)
	result_amount = 2
	log_is_important = 1

/datum/chemical_reaction/nitroglycerin/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/datum/effect/effect/system/reagents_explosion/e = new()
	e.set_up(round (created_volume/2, 1), holder.my_atom, 0, 0)
	if(isliving(holder.my_atom))
		e.amount *= 0.5
		var/mob/living/L = holder.my_atom
		if(L.stat!=DEAD)
			e.amount *= 0.5
	//VOREStation Add Start
	else
		holder.clear_reagents() //No more powergaming by creating a tiny amount of this
	//VOREStation Add End
	e.start()

	//holder.clear_reagents() //VOREStation Removal
	return

/datum/chemical_reaction/napalm
	name = "Napalm"
	id = "napalm"
	result = null
	required_reagents = list("aluminum" = 1, "phoron" = 1, "sacid" = 1 )
	result_amount = 1

/datum/chemical_reaction/napalm/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/turf/location = get_turf(holder.my_atom.loc)
	for(var/turf/simulated/floor/target_tile in range(0,location))
		target_tile.assume_gas("volatile_fuel", created_volume, 400+T0C)
		spawn (0) target_tile.hotspot_expose(700, 400)
	holder.del_reagent("napalm")
	return

/datum/chemical_reaction/chemsmoke
	name = "Chemsmoke"
	id = "chemsmoke"
	result = null
	required_reagents = list("potassium" = 1, "sugar" = 1, "phosphorus" = 1)
	result_amount = 0.4

/datum/chemical_reaction/chemsmoke/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	var/datum/effect/effect/system/smoke_spread/chem/S = new /datum/effect/effect/system/smoke_spread/chem
	S.attach(location)
	S.set_up(holder, created_volume, 0, location)
	playsound(location, 'sound/effects/smoke.ogg', 50, 1, -3)
	spawn(0)
		S.start()
	//VOREStation Edit Start
	if(!isliving(holder.my_atom)) //No more powergaming by creating a tiny amount of this
		holder.clear_reagents()
	//VOREStation Edit End
	return

/datum/chemical_reaction/foam
	name = "Foam"
	id = "foam"
	result = null
	required_reagents = list("fluorosurfactant" = 1, "water" = 1)
	result_amount = 2
	mix_message = "The solution violently bubbles!"

/datum/chemical_reaction/foam/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)

	for(var/mob/M in viewers(5, location))
		to_chat(M, "<span class='warning'>The solution spews out foam!</span>")

	var/datum/effect/effect/system/foam_spread/s = new()
	s.set_up(created_volume, location, holder, 0)
	s.start()
	//VOREStation Edit Start
	if(!isliving(holder.my_atom)) //No more powergaming by creating a tiny amount of this
		holder.clear_reagents()
	//VOREStation Edit End
	return

/datum/chemical_reaction/metalfoam
	name = "Metal Foam"
	id = "metalfoam"
	result = null
	required_reagents = list("aluminum" = 3, "foaming_agent" = 1, "pacid" = 1)
	result_amount = 5

/datum/chemical_reaction/metalfoam/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)

	for(var/mob/M in viewers(5, location))
		to_chat(M, "<span class='warning'>The solution spews out a metalic foam!</span>")

	var/datum/effect/effect/system/foam_spread/s = new()
	s.set_up(created_volume, location, holder, 1)
	s.start()
	return

/datum/chemical_reaction/ironfoam
	name = "Iron Foam"
	id = "ironlfoam"
	result = null
	required_reagents = list("iron" = 3, "foaming_agent" = 1, "pacid" = 1)
	result_amount = 5

/datum/chemical_reaction/ironfoam/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)

	for(var/mob/M in viewers(5, location))
		to_chat(M, "<span class='warning'>The solution spews out a metalic foam!</span>")

	var/datum/effect/effect/system/foam_spread/s = new()
	s.set_up(created_volume, location, holder, 2)
	s.start()
	return

/* Paint */

/datum/chemical_reaction/red_paint
	name = "Red paint"
	id = "red_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "marker_ink_red" = 1)
	result_amount = 5

/datum/chemical_reaction/red_paint/send_data()
	return "#FE191A"

/datum/chemical_reaction/orange_paint
	name = "Orange paint"
	id = "orange_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "marker_ink_orange" = 1)
	result_amount = 5

/datum/chemical_reaction/orange_paint/send_data()
	return "#FFBE4F"

/datum/chemical_reaction/yellow_paint
	name = "Yellow paint"
	id = "yellow_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "marker_ink_yellow" = 1)
	result_amount = 5

/datum/chemical_reaction/yellow_paint/send_data()
	return "#FDFE7D"

/datum/chemical_reaction/green_paint
	name = "Green paint"
	id = "green_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "marker_ink_green" = 1)
	result_amount = 5

/datum/chemical_reaction/green_paint/send_data()
	return "#18A31A"

/datum/chemical_reaction/blue_paint
	name = "Blue paint"
	id = "blue_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "marker_ink_blue" = 1)
	result_amount = 5

/datum/chemical_reaction/blue_paint/send_data()
	return "#247CFF"

/datum/chemical_reaction/purple_paint
	name = "Purple paint"
	id = "purple_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "marker_ink_purple" = 1)
	result_amount = 5

/datum/chemical_reaction/purple_paint/send_data()
	return "#CC0099"

/datum/chemical_reaction/grey_paint //mime
	name = "Grey paint"
	id = "grey_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "marker_ink_grey" = 1)
	result_amount = 5

/datum/chemical_reaction/grey_paint/send_data()
	return "#808080"

/datum/chemical_reaction/brown_paint
	name = "Brown paint"
	id = "brown_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "marker_ink_brown" = 1)
	result_amount = 5

/datum/chemical_reaction/brown_paint/send_data()
	return "#846F35"

/datum/chemical_reaction/blood_paint
	name = "Blood paint"
	id = "blood_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "blood" = 2)
	result_amount = 5

/datum/chemical_reaction/blood_paint/send_data(var/datum/reagents/T)
	var/t = T.get_data("blood")
	if(t && t["blood_colour"])
		return t["blood_colour"]
	return "#FE191A" // Probably red

/datum/chemical_reaction/milk_paint
	name = "Milk paint"
	id = "milk_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "milk" = 5)
	result_amount = 5

/datum/chemical_reaction/milk_paint/send_data()
	return "#F0F8FF"

/datum/chemical_reaction/orange_juice_paint
	name = "Orange juice paint"
	id = "orange_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "orangejuice" = 5)
	result_amount = 5

/datum/chemical_reaction/orange_juice_paint/send_data()
	return "#E78108"

/datum/chemical_reaction/tomato_juice_paint
	name = "Tomato juice paint"
	id = "tomato_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "tomatojuice" = 5)
	result_amount = 5

/datum/chemical_reaction/tomato_juice_paint/send_data()
	return "#731008"

/datum/chemical_reaction/lime_juice_paint
	name = "Lime juice paint"
	id = "lime_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "limejuice" = 5)
	result_amount = 5

/datum/chemical_reaction/lime_juice_paint/send_data()
	return "#365E30"

/datum/chemical_reaction/carrot_juice_paint
	name = "Carrot juice paint"
	id = "carrot_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "carrotjuice" = 5)
	result_amount = 5

/datum/chemical_reaction/carrot_juice_paint/send_data()
	return "#973800"

/datum/chemical_reaction/berry_juice_paint
	name = "Berry juice paint"
	id = "berry_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "berryjuice" = 5)
	result_amount = 5

/datum/chemical_reaction/berry_juice_paint/send_data()
	return "#990066"

/datum/chemical_reaction/grape_juice_paint
	name = "Grape juice paint"
	id = "grape_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "grapejuice" = 5)
	result_amount = 5

/datum/chemical_reaction/grape_juice_paint/send_data()
	return "#863333"

/datum/chemical_reaction/poisonberry_juice_paint
	name = "Poison berry juice paint"
	id = "poisonberry_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "poisonberryjuice" = 5)
	result_amount = 5

/datum/chemical_reaction/poisonberry_juice_paint/send_data()
	return "#863353"

/datum/chemical_reaction/watermelon_juice_paint
	name = "Watermelon juice paint"
	id = "watermelon_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "watermelonjuice" = 5)
	result_amount = 5

/datum/chemical_reaction/watermelon_juice_paint/send_data()
	return "#B83333"

/datum/chemical_reaction/lemon_juice_paint
	name = "Lemon juice paint"
	id = "lemon_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "lemonjuice" = 5)
	result_amount = 5

/datum/chemical_reaction/lemon_juice_paint/send_data()
	return "#AFAF00"

/datum/chemical_reaction/banana_juice_paint
	name = "Banana juice paint"
	id = "banana_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "banana" = 5)
	result_amount = 5

/datum/chemical_reaction/banana_juice_paint/send_data()
	return "#C3AF00"

/datum/chemical_reaction/potato_juice_paint
	name = "Potato juice paint"
	id = "potato_juice_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "potatojuice" = 5)
	result_amount = 5

/datum/chemical_reaction/potato_juice_paint/send_data()
	return "#302000"

/datum/chemical_reaction/carbon_paint
	name = "Carbon paint"
	id = "carbon_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "carbon" = 1)
	result_amount = 5

/datum/chemical_reaction/carbon_paint/send_data()
	return "#333333"

/datum/chemical_reaction/aluminum_paint
	name = "Aluminum paint"
	id = "aluminum_paint"
	result = "paint"
	required_reagents = list("plasticide" = 1, "water" = 3, "aluminum" = 1)
	result_amount = 5

/datum/chemical_reaction/aluminum_paint/send_data()
	return "#F0F8FF"

/* Food */

/datum/chemical_reaction/food/tofu
	name = "Tofu"
	id = "tofu"
	result = null
	required_reagents = list("soymilk" = 10)
	catalysts = list("enzyme" = 5)
	result_amount = 1

/datum/chemical_reaction/food/tofu/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/weapon/reagent_containers/food/snacks/tofu(location)
	return

/datum/chemical_reaction/food/chocolate_bar
	name = "Chocolate Bar"
	id = "chocolate_bar"
	result = null
	required_reagents = list("soymilk" = 2, "coco" = 2, "sugar" = 2)
	result_amount = 1

/datum/chemical_reaction/food/chocolate_bar/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/weapon/reagent_containers/food/snacks/chocolatebar(location)
	return

/datum/chemical_reaction/food/chocolate_bar2
	name = "Chocolate Bar"
	id = "chocolate_bar"
	result = null
	required_reagents = list("milk" = 2, "coco" = 2, "sugar" = 2)
	result_amount = 1

/datum/chemical_reaction/food/chocolate_bar2/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/weapon/reagent_containers/food/snacks/chocolatebar(location)
	return

/datum/chemical_reaction/drinks/coffee
	name = "Coffee"
	id = "coffee"
	result = "coffee"
	required_reagents = list("water" = 5, "coffeepowder" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/tea
	name = "Black tea"
	id = "tea"
	result = "tea"
	required_reagents = list("water" = 5, "teapowder" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/hot_coco
	name = "Hot Coco"
	id = "hot_coco"
	result = "hot_coco"
	required_reagents = list("water" = 5, "coco" = 1)
	result_amount = 5

/datum/chemical_reaction/food/soysauce
	name = "Soy Sauce"
	id = "soysauce"
	result = "soysauce"
	required_reagents = list("soymilk" = 4, "sacid" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/grapejuice
	name = "Grape Juice"
	id = "grapejuice"
	result = "grapejuice"
	required_reagents = list("water" = 3, "instantgrape" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/orangejuice
	name = "Orange Juice"
	id = "orangejuice"
	result = "orangejuice"
	required_reagents = list("water" = 3, "instantorange" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/watermelonjuice
	name = "Watermelon Juice"
	id = "watermelonjuice"
	result = "watermelonjuice"
	required_reagents = list("water" = 3, "instantwatermelon" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/applejuice
	name = "Apple Juice"
	id = "applejuice"
	result = "applejuice"
	required_reagents = list("water" = 3, "instantapple" = 1)
	result_amount = 3

/datum/chemical_reaction/food/ketchup
	name = "Ketchup"
	id = "ketchup"
	result = "ketchup"
	required_reagents = list("tomatojuice" = 2, "water" = 1, "sugar" = 1)
	result_amount = 4

/datum/chemical_reaction/food/barbecue
	name = "Barbeque Sauce"
	id = "barbecue"
	result = "barbecue"
	required_reagents = list("tomatojuice" = 2, "applejuice" = 1, "sugar" = 1, "spacespice" = 1)
	result_amount = 4

/datum/chemical_reaction/food/peanutbutter
	name = "Peanut Butter"
	id = "peanutbutter"
	result = "peanutbutter"
	required_reagents = list("peanutoil" = 2, "sugar" = 1, "sodiumchloride" = 1)
	catalysts = list("enzyme" = 5)
	result_amount = 3

/datum/chemical_reaction/food/mayonnaise
	name = "mayonnaise"
	id = "mayo"
	result = "mayo"
	required_reagents = list("egg" = 9, "cornoil" = 5, "lemonjuice" = 5, "sodiumchloride" = 1)
	result_amount = 15

/datum/chemical_reaction/food/cheesewheel
	name = "Cheesewheel"
	id = "cheesewheel"
	result = null
	required_reagents = list("milk" = 40)
	catalysts = list("enzyme" = 5)
	result_amount = 1

/datum/chemical_reaction/food/cheesewheel/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/weapon/reagent_containers/food/snacks/sliceable/cheesewheel(location)
	return

/datum/chemical_reaction/food/meatball
	name = "Meatball"
	id = "meatball"
	result = null
	required_reagents = list("protein" = 3, "flour" = 5)
	result_amount = 3

/datum/chemical_reaction/food/meatball/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/weapon/reagent_containers/food/snacks/meatball(location)
	return

/datum/chemical_reaction/food/dough
	name = "Dough"
	id = "dough"
	result = null
	required_reagents = list("egg" = 3, "flour" = 10)
	inhibitors = list("water" = 1, "beer" = 1) //To prevent it messing with batter recipes
	result_amount = 1

/datum/chemical_reaction/food/dough/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/weapon/reagent_containers/food/snacks/dough(location)
	return

/datum/chemical_reaction/food/syntiflesh
	name = "Syntiflesh"
	id = "syntiflesh"
	result = null
	required_reagents = list("blood" = 5, "clonexadone" = 5)
	result_amount = 1

/datum/chemical_reaction/food/syntiflesh/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/weapon/reagent_containers/food/snacks/meat/syntiflesh(location)
	return

/datum/chemical_reaction/hot_ramen
	name = "Hot Ramen"
	id = "hot_ramen"
	result = "hot_ramen"
	required_reagents = list("water" = 1, "dry_ramen" = 3)
	result_amount = 3

/datum/chemical_reaction/hell_ramen
	name = "Hell Ramen"
	id = "hell_ramen"
	result = "hell_ramen"
	required_reagents = list("capsaicin" = 1, "hot_ramen" = 6)
	result_amount = 6

/* Alcohol */

/datum/chemical_reaction/drinks/goldschlager
	name = "Goldschlager"
	id = "goldschlager"
	result = "goldschlager"
	required_reagents = list("vodka" = 10, "gold" = 1)
	result_amount = 10

/datum/chemical_reaction/drinks/patron
	name = "Patron"
	id = "patron"
	result = "patron"
	required_reagents = list("tequilla" = 10, "silver" = 1)
	result_amount = 10

/datum/chemical_reaction/drinks/bilk
	name = "Bilk"
	id = "bilk"
	result = "bilk"
	required_reagents = list("milk" = 1, "beer" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/icetea
	name = "Iced Tea"
	id = "icetea"
	result = "icetea"
	required_reagents = list("ice" = 1, "tea" = 2)
	result_amount = 3

/datum/chemical_reaction/drinks/icecoffee
	name = "Iced Coffee"
	id = "icecoffee"
	result = "icecoffee"
	required_reagents = list("ice" = 1, "coffee" = 2)
	result_amount = 3

/datum/chemical_reaction/drinks/nuka_cola
	name = "Nuclear Cola"
	id = "nuka_cola"
	result = "nuka_cola"
	required_reagents = list("uranium" = 1, "cola" = 5)
	result_amount = 5

/datum/chemical_reaction/drinks/moonshine
	name = "Moonshine"
	id = "moonshine"
	result = "moonshine"
	required_reagents = list("nutriment" = 10)
	catalysts = list("enzyme" = 5)
	result_amount = 10

/datum/chemical_reaction/drinks/grenadine
	name = "Grenadine Syrup"
	id = "grenadine"
	result = "grenadine"
	required_reagents = list("berryjuice" = 10)
	catalysts = list("enzyme" = 5)
	result_amount = 10

/datum/chemical_reaction/drinks/wine
	name = "Wine"
	id = "wine"
	result = "wine"
	required_reagents = list("grapejuice" = 10)
	catalysts = list("enzyme" = 5)
	result_amount = 10

/datum/chemical_reaction/drinks/pwine
	name = "Poison Wine"
	id = "pwine"
	result = "pwine"
	required_reagents = list("poisonberryjuice" = 10)
	catalysts = list("enzyme" = 5)
	result_amount = 10

/datum/chemical_reaction/drinks/melonliquor
	name = "Melon Liquor"
	id = "melonliquor"
	result = "melonliquor"
	required_reagents = list("watermelonjuice" = 10)
	catalysts = list("enzyme" = 5)
	result_amount = 10

/datum/chemical_reaction/drinks/bluecuracao
	name = "Blue Curacao"
	id = "bluecuracao"
	result = "bluecuracao"
	required_reagents = list("orangejuice" = 10)
	catalysts = list("enzyme" = 5)
	result_amount = 10

/datum/chemical_reaction/drinks/spacebeer
	name = "Space Beer"
	id = "spacebeer"
	result = "beer"
	required_reagents = list("cornoil" = 10)
	catalysts = list("enzyme" = 5)
	result_amount = 10

/datum/chemical_reaction/drinks/vodka
	name = "Vodka"
	id = "vodka"
	result = "vodka"
	required_reagents = list("potatojuice" = 10)
	catalysts = list("enzyme" = 5)
	result_amount = 10

/datum/chemical_reaction/drinks/cider
	name = "Cider"
	id = "cider"
	result = "cider"
	required_reagents = list("applejuice" = 10)
	catalysts = list("enzyme" = 5)
	result_amount = 10


/datum/chemical_reaction/drinks/sake
	name = "Sake"
	id = "sake"
	result = "sake"
	required_reagents = list("rice" = 10)
	catalysts = list("enzyme" = 5)
	result_amount = 10

/datum/chemical_reaction/drinks/kahlua
	name = "Kahlua"
	id = "kahlua"
	result = "kahlua"
	required_reagents = list("coffee" = 5, "sugar" = 5)
	catalysts = list("enzyme" = 5)
	result_amount = 5

/datum/chemical_reaction/drinks/gin_tonic
	name = "Gin and Tonic"
	id = "gintonic"
	result = "gintonic"
	required_reagents = list("gin" = 2, "tonic" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/cuba_libre
	name = "Cuba Libre"
	id = "cubalibre"
	result = "cubalibre"
	required_reagents = list("rum" = 2, "cola" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/martini
	name = "Classic Martini"
	id = "martini"
	result = "martini"
	required_reagents = list("gin" = 2, "vermouth" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/vodkamartini
	name = "Vodka Martini"
	id = "vodkamartini"
	result = "vodkamartini"
	required_reagents = list("vodka" = 2, "vermouth" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/white_russian
	name = "White Russian"
	id = "whiterussian"
	result = "whiterussian"
	required_reagents = list("blackrussian" = 2, "cream" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/whiskey_cola
	name = "Whiskey Cola"
	id = "whiskeycola"
	result = "whiskeycola"
	required_reagents = list("whiskey" = 2, "cola" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/screwdriver
	name = "Screwdriver"
	id = "screwdrivercocktail"
	result = "screwdrivercocktail"
	required_reagents = list("vodka" = 2, "orangejuice" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/bloody_mary
	name = "Bloody Mary"
	id = "bloodymary"
	result = "bloodymary"
	required_reagents = list("vodka" = 2, "tomatojuice" = 3, "limejuice" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/gargle_blaster
	name = "Pan-Galactic Gargle Blaster"
	id = "gargleblaster"
	result = "gargleblaster"
	required_reagents = list("vodka" = 2, "gin" = 1, "whiskey" = 1, "cognac" = 1, "limejuice" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/brave_bull
	name = "Brave Bull"
	id = "bravebull"
	result = "bravebull"
	required_reagents = list("tequilla" = 2, "kahlua" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/tequilla_sunrise
	name = "Tequilla Sunrise"
	id = "tequillasunrise"
	result = "tequillasunrise"
	required_reagents = list("tequilla" = 2, "orangejuice" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/phoron_special
	name = "Toxins Special"
	id = "phoronspecial"
	result = "phoronspecial"
	required_reagents = list("rum" = 2, "vermouth" = 2, "phoron" = 2)
	result_amount = 6

/datum/chemical_reaction/drinks/beepsky_smash
	name = "Beepksy Smash"
	id = "beepksysmash"
	result = "beepskysmash"
	required_reagents = list("limejuice" = 1, "whiskey" = 1, "iron" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/doctor_delight
	name = "The Doctor's Delight"
	id = "doctordelight"
	result = "doctorsdelight"
	required_reagents = list("limejuice" = 1, "tomatojuice" = 1, "orangejuice" = 1, "cream" = 2, "tricordrazine" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/irish_cream
	name = "Irish Cream"
	id = "irishcream"
	result = "irishcream"
	required_reagents = list("whiskey" = 2, "cream" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/manly_dorf
	name = "The Manly Dorf"
	id = "manlydorf"
	result = "manlydorf"
	required_reagents = list ("beer" = 1, "ale" = 2)
	result_amount = 3

/datum/chemical_reaction/drinks/hooch
	name = "Hooch"
	id = "hooch"
	result = "hooch"
	required_reagents = list ("sugar" = 1, "ethanol" = 2, "fuel" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/irish_coffee
	name = "Irish Coffee"
	id = "irishcoffee"
	result = "irishcoffee"
	required_reagents = list("irishcream" = 1, "coffee" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/b52
	name = "B-52"
	id = "b52"
	result = "b52"
	required_reagents = list("irishcream" = 1, "kahlua" = 1, "cognac" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/atomicbomb
	name = "Atomic Bomb"
	id = "atomicbomb"
	result = "atomicbomb"
	required_reagents = list("b52" = 10, "uranium" = 1)
	result_amount = 10

/datum/chemical_reaction/drinks/margarita
	name = "Margarita"
	id = "margarita"
	result = "margarita"
	required_reagents = list("tequilla" = 2, "limejuice" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/longislandicedtea
	name = "Long Island Iced Tea"
	id = "longislandicedtea"
	result = "longislandicedtea"
	required_reagents = list("vodka" = 1, "gin" = 1, "tequilla" = 1, "cubalibre" = 3)
	result_amount = 6

/datum/chemical_reaction/drinks/icedtea
	name = "Long Island Iced Tea"
	id = "longislandicedtea"
	result = "longislandicedtea"
	required_reagents = list("vodka" = 1, "gin" = 1, "tequilla" = 1, "cubalibre" = 3)
	result_amount = 6

/datum/chemical_reaction/drinks/threemileisland
	name = "Three Mile Island Iced Tea"
	id = "threemileisland"
	result = "threemileisland"
	required_reagents = list("longislandicedtea" = 10, "uranium" = 1)
	result_amount = 10

/datum/chemical_reaction/drinks/whiskeysoda
	name = "Whiskey Soda"
	id = "whiskeysoda"
	result = "whiskeysoda"
	required_reagents = list("whiskey" = 2, "sodawater" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/black_russian
	name = "Black Russian"
	id = "blackrussian"
	result = "blackrussian"
	required_reagents = list("vodka" = 2, "kahlua" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/manhattan
	name = "Manhattan"
	id = "manhattan"
	result = "manhattan"
	required_reagents = list("whiskey" = 2, "vermouth" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/manhattan_proj
	name = "Manhattan Project"
	id = "manhattan_proj"
	result = "manhattan_proj"
	required_reagents = list("manhattan" = 10, "uranium" = 1)
	result_amount = 10

/datum/chemical_reaction/drinks/vodka_tonic
	name = "Vodka and Tonic"
	id = "vodkatonic"
	result = "vodkatonic"
	required_reagents = list("vodka" = 2, "tonic" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/gin_fizz
	name = "Gin Fizz"
	id = "ginfizz"
	result = "ginfizz"
	required_reagents = list("gin" = 1, "sodawater" = 1, "limejuice" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/bahama_mama
	name = "Bahama mama"
	id = "bahama_mama"
	result = "bahama_mama"
	required_reagents = list("rum" = 2, "orangejuice" = 2, "limejuice" = 1, "ice" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/singulo
	name = "Singulo"
	id = "singulo"
	result = "singulo"
	required_reagents = list("vodka" = 5, "radium" = 1, "wine" = 5)
	result_amount = 10

/datum/chemical_reaction/drinks/alliescocktail
	name = "Allies Cocktail"
	id = "alliescocktail"
	result = "alliescocktail"
	required_reagents = list("martini" = 1, "vodka" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/demonsblood
	name = "Demons Blood"
	id = "demonsblood"
	result = "demonsblood"
	required_reagents = list("rum" = 3, "spacemountainwind" = 1, "blood" = 1, "dr_gibb" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/booger
	name = "Booger"
	id = "booger"
	result = "booger"
	required_reagents = list("cream" = 2, "banana" = 1, "rum" = 1, "watermelonjuice" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/antifreeze
	name = "Anti-freeze"
	id = "antifreeze"
	result = "antifreeze"
	required_reagents = list("vodka" = 1, "cream" = 1, "ice" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/barefoot
	name = "Barefoot"
	id = "barefoot"
	result = "barefoot"
	required_reagents = list("berryjuice" = 1, "cream" = 1, "vermouth" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/grapesoda
	name = "Grape Soda"
	id = "grapesoda"
	result = "grapesoda"
	required_reagents = list("grapejuice" = 2, "cola" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/sbiten
	name = "Sbiten"
	id = "sbiten"
	result = "sbiten"
	required_reagents = list("vodka" = 10, "capsaicin" = 1)
	result_amount = 10

/datum/chemical_reaction/drinks/red_mead
	name = "Red Mead"
	id = "red_mead"
	result = "red_mead"
	required_reagents = list("blood" = 1, "mead" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/mead
	name = "Mead"
	id = "mead"
	result = "mead"
	required_reagents = list("sugar" = 1, "water" = 1)
	catalysts = list("enzyme" = 5)
	result_amount = 2

/datum/chemical_reaction/drinks/iced_beer
	name = "Iced Beer"
	id = "iced_beer"
	result = "iced_beer"
	required_reagents = list("beer" = 10, "frostoil" = 1)
	result_amount = 10

/datum/chemical_reaction/drinks/iced_beer2
	name = "Iced Beer"
	id = "iced_beer"
	result = "iced_beer"
	required_reagents = list("beer" = 5, "ice" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/grog
	name = "Grog"
	id = "grog"
	result = "grog"
	required_reagents = list("rum" = 1, "water" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/soy_latte
	name = "Soy Latte"
	id = "soy_latte"
	result = "soy_latte"
	required_reagents = list("coffee" = 1, "soymilk" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/cafe_latte
	name = "Cafe Latte"
	id = "cafe_latte"
	result = "cafe_latte"
	required_reagents = list("coffee" = 1, "milk" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/acidspit
	name = "Acid Spit"
	id = "acidspit"
	result = "acidspit"
	required_reagents = list("sacid" = 1, "wine" = 5)
	result_amount = 6

/datum/chemical_reaction/drinks/amasec
	name = "Amasec"
	id = "amasec"
	result = "amasec"
	required_reagents = list("iron" = 1, "wine" = 5, "vodka" = 5)
	result_amount = 10

/datum/chemical_reaction/drinks/changelingsting
	name = "Changeling Sting"
	id = "changelingsting"
	result = "changelingsting"
	required_reagents = list("screwdrivercocktail" = 1, "limejuice" = 1, "lemonjuice" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/aloe
	name = "Aloe"
	id = "aloe"
	result = "aloe"
	required_reagents = list("cream" = 1, "whiskey" = 1, "watermelonjuice" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/andalusia
	name = "Andalusia"
	id = "andalusia"
	result = "andalusia"
	required_reagents = list("rum" = 1, "whiskey" = 1, "lemonjuice" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/snowwhite
	name = "Snow White"
	id = "snowwhite"
	result = "snowwhite"
	required_reagents = list("pineapplejuice" = 1, "rum" = 1, "lemon_lime" = 1, "egg" = 1, "kahlua" = 1, "sugar" = 1) //VoreStation Edit
	result_amount = 2

/datum/chemical_reaction/drinks/irishcarbomb
	name = "Irish Car Bomb"
	id = "irishcarbomb"
	result = "irishcarbomb"
	required_reagents = list("ale" = 1, "irishcream" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/syndicatebomb
	name = "Syndicate Bomb"
	id = "syndicatebomb"
	result = "syndicatebomb"
	required_reagents = list("beer" = 1, "whiskeycola" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/erikasurprise
	name = "Erika Surprise"
	id = "erikasurprise"
	result = "erikasurprise"
	required_reagents = list("ale" = 2, "limejuice" = 1, "whiskey" = 1, "banana" = 1, "ice" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/devilskiss
	name = "Devils Kiss"
	id = "devilskiss"
	result = "devilskiss"
	required_reagents = list("blood" = 1, "kahlua" = 1, "rum" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/hippiesdelight
	name = "Hippies Delight"
	id = "hippiesdelight"
	result = "hippiesdelight"
	required_reagents = list("psilocybin" = 1, "gargleblaster" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/bananahonk
	name = "Banana Honk"
	id = "bananahonk"
	result = "bananahonk"
	required_reagents = list("banana" = 1, "cream" = 1, "sugar" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/silencer
	name = "Silencer"
	id = "silencer"
	result = "silencer"
	required_reagents = list("nothing" = 1, "cream" = 1, "sugar" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/driestmartini
	name = "Driest Martini"
	id = "driestmartini"
	result = "driestmartini"
	required_reagents = list("nothing" = 1, "gin" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/lemonade
	name = "Lemonade"
	id = "lemonade"
	result = "lemonade"
	required_reagents = list("lemonjuice" = 1, "sugar" = 1, "water" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/melonade
	name = "Melonade"
	id = "melonade"
	result = "melonade"
	required_reagents = list("watermelonjuice" = 1, "sugar" = 1, "sodawater" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/appleade
	name = "Appleade"
	id = "appleade"
	result = "appleade"
	required_reagents = list("applejuice" = 1, "sugar" = 1, "sodawater" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/pineappleade
	name = "Pineappleade"
	id = "pineappleade"
	result = "pineappleade"
	required_reagents = list("pineapplejuice" = 2, "limejuice" = 1, "sodawater" = 2, "honey" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/driverspunch
	name = "Driver`s Punch"
	id = "driverspunch"
	result = "driverspunch"
	required_reagents = list("appleade" = 2, "orangejuice" = 1, "mint" = 1, "sodawater" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/mintapplesparkle
	name = "Mint Apple Sparkle"
	id = "mintapplesparkle"
	result = "mintapplesparkle"
	required_reagents = list("appleade" = 2, "mint" = 1)
	inhibitors = list("sodawater" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/berrycordial
	name = "Berry Cordial"
	id = "berrycordial"
	result = "berrycordial"
	required_reagents = list("berryjuice" = 4, "sugar" = 1, "lemonjuice" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/tropicalfizz
	name = "Tropical Fizz"
	id = "tropicalfizz"
	result = "tropicalfizz"
	required_reagents = list("sodawater" = 6, "berryjuice" = 1, "mint" = 1, "limejuice" = 1, "lemonjuice" = 1, "pineapplejuice" = 1)
	inhibitors = list("sugar" = 1)
	result_amount = 8

/datum/chemical_reaction/drinks/melonspritzer
	name = "Melon Spritzer"
	id = "melonspritzer"
	result = "melonspritzer"
	required_reagents = list("watermelonjuice" = 2, "wine" = 2, "applejuice" = 1, "limejuice" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/fauxfizz
	name = "Faux Fizz"
	id = "fauxfizz"
	result = "fauxfizz"
	required_reagents = list("sodawater" = 2, "berryjuice" = 1, "applejuice" = 1, "limejuice" = 1, "honey" = 1)
	inhibitors = list("sugar" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/firepunch
	name = "Fire Punch"
	id = "firepunch"
	result = "firepunch"
	required_reagents = list("sugar" = 1, "rum" = 2)
	result_amount = 3

/datum/chemical_reaction/drinks/kiraspecial
	name = "Kira Special"
	id = "kiraspecial"
	result = "kiraspecial"
	required_reagents = list("orangejuice" = 1, "limejuice" = 1, "sodawater" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/brownstar
	name = "Brown Star"
	id = "brownstar"
	result = "brownstar"
	required_reagents = list("orangejuice" = 2, "cola" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/milkshake
	name = "Milkshake"
	id = "milkshake"
	result = "milkshake"
	required_reagents = list("cream" = 1, "ice" = 2, "milk" = 2)
	result_amount = 5

/datum/chemical_reaction/drinks/peanutmilkshake
	name = "Peanutbutter Milkshake"
	id = "peanutmilkshake"
	result = "peanutmilkshake"
	required_reagents = list("cream" = 1, "ice" = 1, "peanutbutter" = 2, "milk" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/rewriter
	name = "Rewriter"
	id = "rewriter"
	result = "rewriter"
	required_reagents = list("spacemountainwind" = 1, "coffee" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/suidream
	name = "Sui Dream"
	id = "suidream"
	result = "suidream"
	required_reagents = list("space_up" = 1, "bluecuracao" = 1, "melonliquor" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/shirleytemple
	name = "Shirley Temple"
	id = "shirley_temple"
	result = "shirley_temple"
	required_reagents = list("gingerale" = 4, "grenadine" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/royrogers
	name = "Roy Rogers"
	id = "roy_rogers"
	result = "roy_rogers"
	required_reagents = list("shirley_temple" = 5, "lemon_lime" = 2)
	result_amount = 7

/datum/chemical_reaction/drinks/collinsmix
	name = "Collins Mix"
	id = "collins_mix"
	result = "collins_mix"
	required_reagents = list("lemon_lime" = 3, "sodawater" = 1)
	result_amount = 4

/datum/chemical_reaction/drinks/arnoldpalmer
	name = "Arnold Palmer"
	id = "arnold_palmer"
	result = "arnold_palmer"
	required_reagents = list("icetea" = 1, "lemonade" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/minttea
	name = "Mint Tea"
	id = "minttea"
	result = "minttea"
	required_reagents = list("tea" = 5, "mint" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/lemontea
	name = "Lemon Tea"
	id = "lemontea"
	result = "lemontea"
	required_reagents = list("tea" = 5, "lemonjuice" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/limetea
	name = "Lime Tea"
	id = "limetea"
	result = "limetea"
	required_reagents = list("tea" = 5, "limejuice" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/orangetea
	name = "Orange Tea"
	id = "orangetea"
	result = "orangetea"
	required_reagents = list("tea" = 5, "orangejuice" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/berrytea
	name = "Berry Tea"
	id = "berrytea"
	result = "berrytea"
	required_reagents = list("tea" = 5, "berryjuice" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/sakebomb
	name = "Sake Bomb"
	id = "sakebomb"
	result = "sakebomb"
	required_reagents = list("beer" = 2, "sake" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/tamagozake
	name = "Tamagozake"
	id = "tamagozake"
	result = "tamagozake"
	required_reagents = list("sake" = 10, "sugar" = 5, "egg" = 3)
	result_amount = 15

/datum/chemical_reaction/drinks/ginzamary
	name = "Ginza Mary"
	id = "ginzamary"
	result = "ginzamary"
	required_reagents = list("sake" = 2, "vodka" = 2, "tomatojuice" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/tokyorose
	name = "Tokyo Rose"
	id = "tokyorose"
	result = "tokyorose"
	required_reagents = list("sake" = 1, "berryjuice" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/saketini
	name = "Saketini"
	id = "saketini"
	result = "saketini"
	required_reagents = list("sake" = 1, "gin" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/elysiumfacepunch
	name = "Elysium Facepunch"
	id = "elysiumfacepunch"
	result = "elysiumfacepunch"
	required_reagents = list("kahlua" = 1, "lemonjuice" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/erebusmoonrise
	name = "Erebus Moonrise"
	id = "erebusmoonrise"
	result = "erebusmoonrise"
	required_reagents = list("whiskey" = 1, "vodka" = 1, "tequilla" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/balloon
	name = "Balloon"
	id = "balloon"
	result = "balloon"
	required_reagents = list("cream" = 1, "bluecuracao" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/natunabrandy
	name = "Natuna Brandy"
	id = "natunabrandy"
	result = "natunabrandy"
	required_reagents = list("beer" = 1, "sodawater" = 2)
	result_amount = 3

/datum/chemical_reaction/drinks/euphoria
	name = "Euphoria"
	id = "euphoria"
	result = "euphoria"
	required_reagents = list("specialwhiskey" = 1, "cognac" = 2)
	result_amount = 3

/datum/chemical_reaction/drinks/xanaducannon
	name = "Xanadu Cannon"
	id = "xanaducannon"
	result = "xanaducannon"
	required_reagents = list("ale" = 1, "dr_gibb" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/debugger
	name = "Debugger"
	id = "debugger"
	result = "debugger"
	required_reagents = list("fuel" = 1, "sugar" = 2, "cornoil" = 2)
	result_amount = 5

/datum/chemical_reaction/drinks/spacersbrew
	name = "Spacer's Brew"
	id = "spacersbrew"
	result = "spacersbrew"
	required_reagents = list("brownstar" = 4, "ethanol" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/binmanbliss
	name = "Binman Bliss"
	id = "binmanbliss"
	result = "binmanbliss"
	required_reagents = list("sake" = 1, "tequilla" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/chrysanthemum
	name = "Chrysanthemum"
	id = "chrysanthemum"
	result = "chrysanthemum"
	required_reagents = list("sake" = 1, "melonliquor" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/deathbell
	name = "Deathbell"
	id = "deathbell"
	result = "deathbell"
	required_reagents = list("antifreeze" = 1, "gargleblaster" = 1, "syndicatebomb" =1)
	result_amount = 3

/datum/chemical_reaction/bitters
	name = "Bitters"
	id = "bitters"
	result = "bitters"
	required_reagents = list("mint" = 5)
	catalysts = list("enzyme" = 5)
	result_amount = 5

/datum/chemical_reaction/drinks/soemmerfire
	name = "Soemmer Fire"
	id = "soemmerfire"
	result = "soemmerfire"
	required_reagents = list("manhattan" = 2, "condensedcapsaicin" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/winebrandy
    name = "Wine brandy"
    id = "winebrandy"
    result = "winebrandy"
    required_reagents = list("wine" = 10)
    catalysts = list("enzyme" = 10) //10u enzyme so it requires more than is usually added. Stops overlap with wine recipe
    result_amount = 5

/datum/chemical_reaction/drinks/lovepotion
	name = "Love Potion"
	id = "lovepotion"
	result = "lovepotion"
	required_reagents = list("cream" = 1, "berryjuice" = 1, "sugar" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/morningafter
	name = "Morning After"
	id = "morningafter"
	result = "morningafter"
	required_reagents = list("sbiten" = 1, "coffee" = 5)
	result_amount = 6

/datum/chemical_reaction/drinks/vesper
	name = "Vesper"
	id = "vesper"
	result = "vesper"
	required_reagents = list("gin" = 3, "vodka" = 1, "wine" = 1)
	result_amount = 4

/datum/chemical_reaction/drinks/rotgut
	name = "Rotgut Fever Dream"
	id = "rotgut"
	result = "rotgut"
	required_reagents = list("vodka" = 3, "rum" = 1, "whiskey" = 1, "cola" = 3)
	result_amount = 8

/datum/chemical_reaction/drinks/entdraught
	name = "Ent's Draught"
	id = "entdraught"
	result = "entdraught"
	required_reagents = list("tonic" = 1, "holywater" = 1, "honey" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/voxdelight
	name = "Vox's Delight"
	id = "voxdelight"
	result = "voxdelight"
	required_reagents = list("phoron" = 3, "fuel" = 1, "water" = 1)
	result_amount = 4

/datum/chemical_reaction/drinks/screamingviking
	name = "Screaming Viking"
	id = "screamingviking"
	result = "screamingviking"
	required_reagents = list("martini" = 2, "vodkatonic" = 2, "limejuice" = 1, "rum" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/vilelemon
	name = "Vile Lemon"
	id = "vilelemon"
	result = "vilelemon"
	required_reagents = list("lemonade" = 5, "spacemountainwind" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/dreamcream
	name = "Dream Cream"
	id = "dreamcream"
	result = "dreamcream"
	required_reagents = list("milk" = 2, "cream" = 1, "honey" = 1)
	result_amount = 4

/datum/chemical_reaction/drinks/robustin
	name = "Robustin"
	id = "robustin"
	result = "robustin"
	required_reagents = list("antifreeze" = 1, "phoron" = 1, "fuel" = 1, "vodka" = 1)
	result_amount = 4

/datum/chemical_reaction/drinks/virginsip
	name = "Virgin Sip"
	id = "virginsip"
	result = "virginsip"
	required_reagents = list("driestmartini" = 1, "water" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/chocoshake
	name = "Chocolate Milkshake"
	id = "chocoshake"
	result = "chocoshake"
	required_reagents = list("milkshake" = 1, "coco" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/berryshake
	name = "Berry Milkshake"
	id = "berryshake"
	result = "berryshake"
	required_reagents = list("milkshake" = 1, "berryjuice" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/coffeeshake
	name = "Coffee Milkshake"
	id = "coffeeshake"
	result = "coffeeshake"
	required_reagents = list("milkshake" = 1, "coffee" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/jellyshot
	name = "Jelly Shot"
	id = "jellyshot"
	result = "jellyshot"
	required_reagents = list("cherryjelly" = 4, "vodka" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/slimeshot
	name = "Named Bullet"
	id = "slimeshot"
	result = "slimeshot"
	required_reagents = list("slimejelly" = 4, "vodka" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/negroni
	name = "Negroni"
	id = "negroni"
	result = "negroni"
	required_reagents = list("gin" = 1, "bitters" = 1, "vermouth" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/cloverclub
	name = "Clover Club"
	id = "cloverclub"
	result = "cloverclub"
	required_reagents = list("berryjuice" = 1, "lemonjuice" = 1, "gin" = 3)
	result_amount = 5

/datum/chemical_reaction/drinks/oldfashioned
	name = "Old Fashioned"
	id = "oldfashioned"
	result = "oldfashioned"
	required_reagents = list("whiskey" = 3, "bitters" = 1, "sugar" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/whiskeysour
	name = "Whiskey Sour"
	id = "whiskeysour"
	result = "whiskeysour"
	required_reagents = list("whiskey" = 2, "lemonjuice" = 1, "sugar" = 1)
	result_amount = 4

/datum/chemical_reaction/drinks/daiquiri
	name = "Daiquiri"
	id = "daiquiri"
	result = "daiquiri"
	required_reagents = list("rum" = 3, "limejuice" = 2, "sugar" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/mintjulep
	name = "Mint Julep"
	id = "mintjulep"
	result = "mintjulep"
	required_reagents = list("whiskey" = 2, "water" = 1, "mint" = 1)
	result_amount = 4

/datum/chemical_reaction/drinks/paloma
	name = "Paloma"
	id = "paloma"
	result = "paloma"
	required_reagents = list("orangejuice" = 1, "sodawater" = 1, "tequilla" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/mojito
	name = "Mojito"
	id = "mojito"
	result = "mojito"
	required_reagents = list("rum" = 3, "limejuice" = 1, "mint" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/virginmojito
	name = "Mojito"
	id = "virginmojito"
	result = "virginmojito"
	required_reagents = list("sodawater" = 3, "limejuice" = 1, "mint" = 1, "sugar" = 1)
	result_amount = 5

/datum/chemical_reaction/drinks/piscosour
	name = "Pisco Sour"
	id = "piscosour"
	result = "piscosour"
	required_reagents = list("winebrandy" = 1, "lemonjuice" = 1, "sugar" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/coldfront
	name = "Cold Front"
	id = "coldfront"
	result = "coldfront"
	required_reagents = list("icecoffee" = 1, "whiskey" = 1, "mint" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/godsake
	name = "Gods Sake"
	id = "godsake"
	result = "godsake"
	required_reagents = list("sake" = 2, "holywater" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/godka //Why you would put this in your body, I don't know.
	name = "Godka"
	id = "godka"
	result = "godka"
	required_reagents = list("vodka" = 1, "holywater" = 1, "ethanol" = 1, "carthatoline" = 1)
	catalysts = list("enzyme" = 5, "holywater" = 5)
	result_amount = 1

/datum/chemical_reaction/drinks/holywine
	name = "Angel Ichor"
	id = "holywine"
	result = "holywine"
	required_reagents = list("grapejuice" = 5, "gold" = 5)
	catalysts = list("holywater" = 5)
	result_amount = 10

/datum/chemical_reaction/drinks/holy_mary
	name = "Holy Mary"
	id = "holymary"
	result = "holymary"
	required_reagents = list("vodka" = 2, "holywine" = 3, "limejuice" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/angelskiss
	name = "Angels Kiss"
	id = "angelskiss"
	result = "angelskiss"
	required_reagents = list("holywine" = 1, "kahlua" = 1, "rum" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/angelswrath
	name = "Angels Wrath"
	id = "angelswrath"
	result = "angelswrath"
	required_reagents = list("rum" = 3, "spacemountainwind" = 1, "holywine" = 1, "dr_gibb" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/ichor_mead
	name = "Ichor Mead"
	id = "ichor_mead"
	result = "ichor_mead"
	required_reagents = list("holywine" = 1, "mead" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/oilslick
	name = "Oil Slick"
	id = "oilslick"
	result = "oilslick"
	required_reagents = list("cornoil" = 2, "honey" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/slimeslam
	name = "Slick Slime Slammer"
	id = "slimeslammer"
	result = "slimeslammer"
	required_reagents = list("cornoil" = 2, "peanutbutter" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/virginsexonthebeach
	name = "Virgin Sex On The Beach"
	id = "virginsexonthebeach"
	result = "virginsexonthebeach"
	required_reagents = list("orangejuice" = 3, "grenadine" = 2)
	result_amount = 5

/datum/chemical_reaction/drinks/sexonthebeach
	name = "Sex On The Beach"
	id = "sexonthebeach"
	result = "sexonthebeach"
	required_reagents = list("virginsexonthebeach" = 5, "vodka" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/eggnog
	name = "Eggnog"
	id = "eggnog"
	result = "eggnog"
	required_reagents = list("milk" = 5, "cream" = 5, "sugar" = 5, "egg" = 3)
	result_amount = 15

/datum/chemical_reaction/drinks/nuclearwaste_radium
	name = "Nuclear Waste"
	id = "nuclearwasterad"
	result = "nuclearwaste"
	required_reagents = list("oilslick" = 1, "radium" = 1, "limejuice" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/nuclearwaste_uranium
	name = "Nuclear Waste"
	id = "nuclearwasteuran"
	result = "nuclearwaste"
	required_reagents = list("oilslick" = 2, "uranium" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/sodaoil
	name = "Soda Oil"
	id = "sodaoil"
	result = "sodaoil"
	required_reagents = list("cornoil" = 4, "sodawater" = 1, "carbon" = 1, "tricordrazine" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/fusionnaire
	name = "Fusionnaire"
	id = "fusionnaire"
	result = "fusionnaire"
	required_reagents = list("lemonjuice" = 3, "vodka" = 2, "schnapps_pep" = 1, "schnapps_lem" = 1, "rum" = 1, "ice" = 1)
	result_amount = 9

//R-UST Port
/datum/chemical_reaction/hyrdophoron
	name = "Hydrophoron"
	id = "hydrophoron"
	result = "hydrophoron"
	required_reagents = list("hydrogen" = 1, "phoron" = 1)
	inhibitors = list("nitrogen" = 1) //So it doesn't mess with lexorin
	result_amount = 2

/datum/chemical_reaction/deuterium
	name = "Deuterium"
	id = "deuterium"
	result = null
	required_reagents = list("hydrophoron" = 5, "water" = 10)
	result_amount = 15

/datum/chemical_reaction/deuterium/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/turf/T = get_turf(holder.my_atom)
	if(istype(T)) new /obj/item/stack/material/deuterium(T, created_volume)
	return

//Skrellian crap.
/datum/chemical_reaction/talum_quem
	name = "Talum-quem"
	id = "talum_quem"
	result = "talum_quem"
	required_reagents = list("space_drugs" = 2, "sugar" = 1, "amatoxin" = 1)
	result_amount = 4

/datum/chemical_reaction/qerr_quem
	name = "Qerr-quem"
	id = "qerr_quem"
	result = "qerr_quem"
	required_reagents = list("nicotine" = 1, "carbon" = 1, "sugar" = 2)
	result_amount = 4

/datum/chemical_reaction/malish_qualem
	name = "Malish-Qualem"
	id = "malish-qualem"
	result = "malish-qualem"
	required_reagents = list("immunosuprizine" = 1, "qerr_quem" = 1, "inaprovaline" = 1)
	catalysts = list("phoron" = 5)
	result_amount = 2

// Biomass, for cloning and bioprinters
/datum/chemical_reaction/biomass
	name = "Biomass"
	id = "biomass"
	result = "biomass"
	required_reagents = list("protein" = 1, "sugar" = 1, "phoron" = 1)
	result_amount = 1	// Roughly 20u per phoron sheet

// Neutralization.

/datum/chemical_reaction/neutralize_neurotoxic_protein
	name = "Neutralize Toxic Proteins"
	id = "neurotoxic_protein_neutral"
	result = "protein"
	required_reagents = list("anti_toxin" = 1, "neurotoxic_protein" = 2)
	result_amount = 2

/datum/chemical_reaction/neutralize_carpotoxin
	name = "Neutralize Carpotoxin"
	id = "carpotoxin_neutral"
	result = "protein"
	required_reagents = list("radium" = 1, "carpotoxin" = 1, "sifsap" = 1)
	catalysts = list("sifsap" = 10)
	result_amount = 2

/datum/chemical_reaction/neutralize_spidertoxin
	name = "Neutralize Spidertoxin"
	id = "spidertoxin_neutral"
	result = "protein"
	required_reagents = list("radium" = 1, "spidertoxin" = 1, "sifsap" = 1)
	catalysts = list("sifsap" = 10)
	result_amount = 2

/*
====================
	Aurora Food
====================
*/

/datum/chemical_reaction/coating/batter
	name = "Batter"
	id = "batter"
	result = "batter"
	required_reagents = list("egg" = 3, "flour" = 10, "water" = 5, "sodiumchloride" = 2)
	result_amount = 20

/datum/chemical_reaction/coating/beerbatter
	name = "Beer Batter"
	id = "beerbatter"
	result = "beerbatter"
	required_reagents = list("egg" = 3, "flour" = 10, "beer" = 5, "sodiumchloride" = 2)
	result_amount = 20

/datum/chemical_reaction/browniemix
	name = "Brownie Mix"
	id = "browniemix"
	result = "browniemix"
	required_reagents = list("flour" = 5, "coco" = 5, "sugar" = 5)
	result_amount = 15

/datum/chemical_reaction/butter
	name = "Butter"
	id = "butter"
	result = null
	required_reagents = list("cream" = 20, "sodiumchloride" = 1)
	result_amount = 1

/datum/chemical_reaction/butter/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/weapon/reagent_containers/food/snacks/spreads/butter(location)
	return

/datum/chemical_reaction/browniemix
	name = "Brownie Mix"
	id = "browniemix"
	result = "browniemix"
	required_reagents = list("flour" = 5, "coco" = 5, "sugar" = 5)
	result_amount = 15
