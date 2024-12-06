/decl/chemical_reaction/instant/virus_food_mutagen
	name = REAGENT_MUTAGENVIRUSFOOD
	id = REAGENT_ID_MUTAGENVIRUSFOOD
	result = REAGENT_ID_MUTAGENVIRUSFOOD
	required_reagents = list("mutagen" = 1, "virusfood" = 1)
	result_amount = 1

/decl/chemical_reaction/instant/virus_food_adranol
	name = REAGENT_ADRANOLVIRUSFOOD
	id = REAGENT_ID_ADRANOLVIRUSFOOD
	result = REAGENT_ID_ADRANOLVIRUSFOOD
	required_reagents = list(REAGENT_ID_ADRANOL = 1, "virusfood" = 1)
	result_amount = 1

/decl/chemical_reaction/instant/virus_food_phoron
	name = REAGENT_ADRANOLVIRUSFOOD
	id = REAGENT_ID_PHORONVIRUSFOOD
	result = REAGENT_ID_PHORONVIRUSFOOD
	required_reagents = list(REAGENT_ID_PHORON = 1, "virusfood" = 1)
	result_amount = 1

/decl/chemical_reaction/instant/virus_food_phoron_adranol
	name = REAGENT_WEAKPHORONVIRUSFOOD
	id = REAGENT_ID_WEAKPHORONVIRUSFOOD
	result = REAGENT_ID_WEAKPHORONVIRUSFOOD
	required_reagents = list(REAGENT_ID_ADRANOL = 1, REAGENT_ID_PHORONVIRUSFOOD = 1)
	result_amount = 2

/decl/chemical_reaction/instant/virus_food_mutagen_sugar
	name = REAGENT_SUGARVIRUSFOOD
	id = REAGENT_ID_SUGARVIRUSFOOD
	result = REAGENT_ID_SUGARVIRUSFOOD
	required_reagents = list(REAGENT_ID_SUGAR = 1, REAGENT_ID_MUTAGENVIRUSFOOD = 1)
	result_amount = 2

/decl/chemical_reaction/instant/virus_food_mutagen_inaprovaline
	name = REAGENT_SUGARVIRUSFOOD
	id = "inaprovalinevirusfood"
	result = REAGENT_ID_SUGARVIRUSFOOD
	required_reagents = list("inaprovaline" = 1, REAGENT_ID_MUTAGENVIRUSFOOD = 1)
	result_amount = 2

/decl/chemical_reaction/instant/virus_food_size
	name = REAGENT_SIZEVIRUSFOOD
	id = "sizeoxadonevirusfood"
	result = REAGENT_ID_SIZEVIRUSFOOD
	required_reagents = list("sizeoxadone" = 1, REAGENT_ID_PHORONVIRUSFOOD = 1)
	result_amount = 2

/decl/chemical_reaction/instant/mix_virus
	name = "Mix Virus"
	id = "mixvirus"
	required_reagents = list("virusfood" = 1)
	catalysts = list(REAGENT_ID_BLOOD = 1)
	var/level_min = 0
	var/level_max = 2

/decl/chemical_reaction/instant/mix_virus/picky
	var/list/datum/symptom/symptoms

/decl/chemical_reaction/instant/mix_virus/on_reaction(datum/reagents/holder)
	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in holder.reagent_list
	if(B && B.data)
		var/datum/disease/advance/D = locate(/datum/disease/advance) in B.data["viruses"]
		if(D)
			D.Evolve(level_min, level_max)

/decl/chemical_reaction/instant/mix_virus/picky/on_reaction(datum/reagents/holder)
	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in holder.reagent_list
	if(B && B.data)
		var/datum/disease/advance/D = locate(/datum/disease/advance) in B.data["viruses"]
		if(D)
			D.PickyEvolve(symptoms)

/decl/chemical_reaction/instant/mix_virus/mix_virus_2
	name = "Mix Virus 2"
	id = "mixvirus2"
	required_reagents = list("mutagen" = 1)
	level_min = 2
	level_max = 4

/decl/chemical_reaction/instant/mix_virus/mix_virus_3
	name = "Mix Virus 3"
	id = "mixvirus3"
	required_reagents = list(REAGENT_ID_PHORON = 1)
	level_min = 4
	level_max = 6

/decl/chemical_reaction/instant/mix_virus/mix_virus_4
	name = "Mix Virus 4"
	id = "mixvirus4"
	required_reagents = list(REAGENT_ID_URANIUM = 1)
	level_min = 5
	level_max = 6

/decl/chemical_reaction/instant/mix_virus/mix_virus_5
	name = "Mix Virus 5"
	id = "mixvirus5"
	required_reagents = list(REAGENT_ID_MUTAGENVIRUSFOOD = 1)
	level_min = 3
	level_max = 3

/decl/chemical_reaction/instant/mix_virus/mix_virus_6
	name = "Mix Virus 6"
	id = "mixvirus6"
	required_reagents = list(REAGENT_ID_SUGARVIRUSFOOD = 1)
	level_min = 4
	level_max = 4

/decl/chemical_reaction/instant/mix_virus/mix_virus_7
	name = "Mix Virus 7"
	id = "mixvirus7"
	required_reagents = list(REAGENT_ID_WEAKPHORONVIRUSFOOD = 1)
	level_min = 5
	level_max = 5

/decl/chemical_reaction/instant/mix_virus/mix_virus_8
	name = "Mix Virus 8"
	id = "mixvirus8"
	required_reagents = list(REAGENT_ID_PHORONVIRUSFOOD = 1)
	level_min = 6
	level_max = 6

/decl/chemical_reaction/instant/mix_virus/mix_virus_9
	name = "Mix Virus 9"
	id = "mixvirus9"
	required_reagents = list(REAGENT_ID_ADRANOLVIRUSFOOD = 1)
	level_min = 1
	level_max = 1

/decl/chemical_reaction/instant/mix_virus/picky/size
	name = "Mix Virus Size"
	id = "mixvirussize"
	required_reagents = list(REAGENT_ID_SIZEVIRUSFOOD = 1)
	symptoms = list(
		/datum/symptom/macrophage,
		/datum/symptom/size,
		/datum/symptom/size/grow,
		/datum/symptom/size/shrink
	)

/decl/chemical_reaction/instant/mix_virus/rem_virus
	name = "Devolve Virus"
	id = "remvirus"
	required_reagents = list(REAGENT_ID_ADRANOL = 1)
	catalysts = list(REAGENT_ID_BLOOD = 1)

/decl/chemical_reaction/instant/mix_virus/rem_virus/on_reaction(var/datum/reagents/holder)
	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in holder.reagent_list
	if(B && B.data)
		var/datum/disease/advance/D = locate(/datum/disease/advance) in B.data["viruses"]
		if(D)
			D.Devolve()

/decl/chemical_reaction/instant/antibodies
	name = "Antibodies"
	id = "antibodiesmix"
	result = REAGENT_ID_ANTIBODIES
	required_reagents = list(REAGENT_ID_VACCINE)
	catalysts = list("inaprovaline" = 0.1)
	result_amount = 0.5
