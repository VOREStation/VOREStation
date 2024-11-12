/datum/reagent/vaccine
	name = "Vaccine"
	id = "vaccine"
	color = "#C81040"
	taste_description = "antibodies"

/datum/reagent/vaccine/affect_blood(mob/living/carbon/M, alien, removed)
	if(islist(data))
		for(var/thing in M.GetViruses())
			var/datum/disease/D = thing
			if(D.GetDiseaseID() in data)
				D.cure()
		M.resistances |= data

/datum/reagent/vaccines/mix_data(newdata, newamount)
	if(islist(newdata))
		var/list/newdatalist = newdata
		data |= newdatalist.Copy()

/datum/reagent/mutagen/mutagenvirusfood
	name = "Mutagenic agar"
	id = "mutagenvirusfood"
	description = "Mutates viruses when mixed in blood. This one seems rather alright."
	color = "#A3C00F"

/datum/reagent/mutagen/mutagenvirusfood/sugar
	name = "Sucrose agar"
	id = "sugarvirusfood"
	color = "#41B0C0"
	taste_mult = 1.5

/datum/reagent/medicine/adranol/adranolvirusfood
	name = "Virus rations"
	id = "adranolvirusfood"
	description = "Mutates viruses when mixed in blood. This one seems rather weak."
	color = "#D18AA5"

/datum/reagent/toxin/phoron/phoronvirusfood
	name = "Phoronic virus food"
	id = "phoronvirusfood"
	description = "Mutates viruses when mixed in blood. This one seems to be the strongest."
	color = "#A69DA9"

/datum/reagent/toxin/phoron/phoronvirusfood/weak
	name = "Weakened phoronic virus food. This one seems to have been weakened, but still strong."
	id = "weakphoronvirusfood"
	color = "#CEC3C6"
