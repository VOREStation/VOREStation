/datum/absorbed_dna
	var/name
	var/datum/dna/dna
	var/speciesName
	var/list/languages
	var/identifying_gender
	var/list/flavour_texts
	var/list/genMods

/datum/absorbed_dna/New(var/newName, var/newDNA, var/newSpecies, var/newLanguages, var/newIdentifying_Gender, var/list/newFlavour, var/list/newGenMods)
	..()
	name = newName
	qdel_swap(dna, newDNA)
	speciesName = newSpecies
	languages = newLanguages
	identifying_gender = newIdentifying_Gender
	flavour_texts = newFlavour ? newFlavour.Copy() : null
	genMods = newGenMods ? newGenMods.Copy() : null

/datum/absorbed_dna/Destroy()
	. = ..()
	qdel(dna)
