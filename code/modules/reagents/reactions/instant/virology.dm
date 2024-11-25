/decl/chemical_reaction/instant/virus_food_mutagen
	name = "mutagenic agar"
	id = "mutagenvirusfood"
	result = "mutagenvirusfood"
	required_reagents = list("mutagen" = 1, "virusfood" = 1)
	result_amount = 1

/decl/chemical_reaction/instant/virus_food_adranol
	name = "virus rations"
	id = "adranolvirusfood"
	result = "adranolvirusfood"
	required_reagents = list("adranol" = 1, "virusfood" = 1)
	result_amount = 1

/decl/chemical_reaction/instant/virus_food_phoron
	name = "phoronic virus food"
	id = "phoronvirusfood"
	result = "phoronvirusfood"
	required_reagents = list("phoron" = 1, "virusfood" = 1)
	result_amount = 1

/decl/chemical_reaction/instant/virus_food_phoron_adranol
	name = "weakened phoronic virus food"
	id = "weakphoronvirusfood"
	result = "weakphoronvirusfood"
	required_reagents = list("adranol" = 1, "phoronvirusfood" = 1)
	result_amount = 2

/decl/chemical_reaction/instant/virus_food_mutagen_sugar
	name = "sucrose agar"
	id = "sugarvirusfood"
	result = "sugarvirusfood"
	required_reagents = list("sugar" = 1, "mutagenvirusfood" = 1)
	result_amount = 2

/decl/chemical_reaction/instant/virus_food_mutagen_inaprovaline
	name = "sucrose agar"
	id = "inaprovalinevirusfood"
	result = "sugarvirusfood"
	required_reagents = list("inaprovaline" = 1, "mutagenvirusfood" = 1)
	result_amount = 2

/decl/chemical_reaction/instant/virus_food_size
	name = "sizeoxadone virus food"
	id = "sizeoxadonevirusfood"
	result = "sizevirusfood"
	required_reagents = list("sizeoxadone" = 1, "phoronvirusfood" = 1)
	result_amount = 2

/decl/chemical_reaction/instant/mix_virus
	name = "Mix Virus"
	id = "mixvirus"
	required_reagents = list("virusfood" = 1)
	catalysts = list("blood" = 1)
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
	required_reagents = list("phoron" = 1)
	level_min = 4
	level_max = 6

/decl/chemical_reaction/instant/mix_virus/mix_virus_4
	name = "Mix Virus 4"
	id = "mixvirus4"
	required_reagents = list("uranium" = 1)
	level_min = 5
	level_max = 6

/decl/chemical_reaction/instant/mix_virus/mix_virus_5
	name = "Mix Virus 5"
	id = "mixvirus5"
	required_reagents = list("mutagenvirusfood" = 1)
	level_min = 3
	level_max = 3

/decl/chemical_reaction/instant/mix_virus/mix_virus_6
	name = "Mix Virus 6"
	id = "mixvirus6"
	required_reagents = list("sugarvirusfood" = 1)
	level_min = 4
	level_max = 4

/decl/chemical_reaction/instant/mix_virus/mix_virus_7
	name = "Mix Virus 7"
	id = "mixvirus7"
	required_reagents = list("weakphoronvirusfood" = 1)
	level_min = 5
	level_max = 5

/decl/chemical_reaction/instant/mix_virus/mix_virus_8
	name = "Mix Virus 8"
	id = "mixvirus8"
	required_reagents = list("phoronvirusfood" = 1)
	level_min = 6
	level_max = 6

/decl/chemical_reaction/instant/mix_virus/mix_virus_9
	name = "Mix Virus 9"
	id = "mixvirus9"
	required_reagents = list("adranolvirusfood" = 1)
	level_min = 1
	level_max = 1

/decl/chemical_reaction/instant/mix_virus/picky/size
	name = "Mix Virus Size"
	id = "mixvirussize"
	required_reagents = list("sizevirusfood" = 1)
	symptoms = list(
		/datum/symptom/macrophage,
		/datum/symptom/size,
		/datum/symptom/size/grow
	)

/decl/chemical_reaction/instant/mix_virus/rem_virus
	name = "Devolve Virus"
	id = "remvirus"
	required_reagents = list("adranol" = 1)
	catalysts = list("blood" = 1)

/decl/chemical_reaction/instant/mix_virus/rem_virus/on_reaction(var/datum/reagents/holder)
	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in holder.reagent_list
	if(B && B.data)
		var/datum/disease/advance/D = locate(/datum/disease/advance) in B.data["viruses"]
		if(D)
			D.Devolve()

/decl/chemical_reaction/instant/antibodies
	name = "Antibodies"
	id = "antibodiesmix"
	result = "antibodies"
	required_reagents = list("vaccine")
	catalysts = list("inaprovaline" = 0.1)
	result_amount = 0.5
