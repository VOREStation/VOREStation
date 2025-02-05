///NOTE: LEAVE THIS FILE UNTICKED AND THE SEGMENTS OF CODE COMMENTED OUT UNLESS YOU NEED TO DO SOMETHING SPECIFIC / TRACK SOMETHING SPECIFIC.


/*
/// Testing if DNA & Species datums get destoryed or not. Use this as a basis to test for memory leaks.
/// This happens if DNA is copied from somewhere but not qdel_swap()'d. WARNING: Not every time it's copied should be qdel_swap()'d.
/// But if you are doing anything DNA copy related, turn this on and make sure it's not infintely storing a datum somewhere.
GLOBAL_VAR(total_dna_counters)
GLOBAL_VAR(total_species_counters)

/datum/dna/New()
	. = ..()
	GLOB.total_dna_counters += 1

/datum/dna/Destroy()
	. = ..()
	GLOB.total_dna_counters -= 1

/datum/species/New()
	. = ..()
	GLOB.total_species_counters += 1

/datum/species/Destroy()
	. = ..()
	GLOB.total_species_counters -= 1

/proc/delete_all_monkeys()
	for(var/mob/living/carbon/human/monkey/monkeys in world)
		qdel(monkeys)
*/
