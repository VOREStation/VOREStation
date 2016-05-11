/datum/absorbed_dna
	var/name
	var/datum/dna/dna
	var/speciesName
	var/list/languages
	var/identifying_gender

/datum/absorbed_dna/New(var/newName, var/newDNA, var/newSpecies, var/newLanguages, var/newIdentifying_Gender)
	..()
	name = newName
	dna = newDNA
	speciesName = newSpecies
	languages = newLanguages
	identifying_gender = newIdentifying_Gender