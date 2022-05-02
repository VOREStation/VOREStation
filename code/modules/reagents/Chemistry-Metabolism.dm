/datum/reagents/metabolism
	var/metabolism_class //CHEM_TOUCH, CHEM_INGEST, or CHEM_BLOOD
	var/metabolism_speed = 1	// Multiplicative, 1 is full speed, 0.5 is half, etc.
	var/mob/living/human/parent

/datum/reagents/metabolism/New(var/max = 100, mob/living/human/parent_mob, var/met_class = null)
	..(max, parent_mob)

	if(met_class)
		metabolism_class = met_class
	if(istype(parent_mob))
		parent = parent_mob

/datum/reagents/metabolism/proc/metabolize()

	var/metabolism_type = 0 //non-human mobs
	if(ishuman(parent))
		var/mob/living/human/H = parent
		metabolism_type = H.species.reagent_tag

	for(var/datum/reagent/current in reagent_list)
		current.on_mob_life(parent, metabolism_type, src)
	update_total()

// "Specialized" metabolism datums
/datum/reagents/metabolism/bloodstream
	metabolism_class = CHEM_BLOOD

/datum/reagents/metabolism/ingested
	metabolism_class = CHEM_INGEST
	metabolism_speed = 0.5

/datum/reagents/metabolism/touch
	metabolism_class = CHEM_TOUCH