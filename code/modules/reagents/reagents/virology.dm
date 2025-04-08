/datum/reagent/vaccine
	name = REAGENT_VACCINE
	id = REAGENT_ID_VACCINE
	description = "Liquid vaccine against some type of virus."
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
	name = REAGENT_MUTAGENVIRUSFOOD
	id = REAGENT_ID_MUTAGENVIRUSFOOD
	description = "Mutates viruses when mixed in blood. This one seems rather alright."
	color = "#A3C00F"

/datum/reagent/mutagen/mutagenvirusfood/sugar
	name = REAGENT_SUGARVIRUSFOOD
	id = REAGENT_ID_SUGARVIRUSFOOD
	color = "#41B0C0"
	taste_mult = 1.5

/datum/reagent/medicine
	name = REAGENT_DEVELOPER_WARNING // Unit test ignore

/datum/reagent/medicine/adranol/adranolvirusfood
	name = REAGENT_ADRANOLVIRUSFOOD
	id = REAGENT_ID_ADRANOLVIRUSFOOD
	description = "Mutates viruses when mixed in blood. This one seems rather weak."
	color = "#D18AA5"

/datum/reagent/toxin/phoron/phoronvirusfood
	name = REAGENT_PHORONVIRUSFOOD
	id = REAGENT_ID_PHORONVIRUSFOOD
	description = "Mutates viruses when mixed in blood. This one seems to be the strongest."
	color = "#A69DA9"

/datum/reagent/toxin/phoron/phoronvirusfood/weak
	name = REAGENT_WEAKPHORONVIRUSFOOD
	id = REAGENT_ID_WEAKPHORONVIRUSFOOD
	description = "Mutates viruses when mixed in blood. This one seems to have been weakened, but still strong."
	color = "#CEC3C6"

/datum/reagent/toxin/phoron/phoronvirusfood/sizevirusfood
	name = REAGENT_SIZEVIRUSFOOD
	id = REAGENT_ID_SIZEVIRUSFOOD
	description = "Mutates virus when mixed in blood. This is a strange size mix..."
	color = "#88AFDD"
