/datum/experiment/scanning/random/janitor_trash
	name = "Station Hygiene Inspection"
	description = "To learn how to clean, we must first learn what it is to have filth. We need you to scan some filth around the station."
	possible_types = list(/obj/effect/decal/cleanable/blood)
	total_requirement = 3

/datum/experiment/scanning/random/janitor_trash/serialize_progress_stage(atom/target, list/seen_instances)
	var/scanned_total = seen_instances.len
	return EXPERIMENT_PROG_INT("Scan samples of blood or oil", scanned_total, required_atoms[target])

/datum/experiment/scanning/random/mecha_equipped_scan
	name = "Exosuit Materials: Load Strain Test"
	description = "Exosuit equipment places unique strain upon the structure of the vehicle. Scan exosuits you have assembled from your exosuit fabricator and fully equipped to accelerate our structural stress simulations."
	possible_types = list(/obj/mecha)
	total_requirement = 1

/datum/experiment/scanning/points/easy_cytology
	name = "Basic Cytology Scanning Experiment"
	description = "A scientist needs vermin to test on!"
	required_points = 1
	required_atoms = list(
		/mob/living/simple_mob/animal/passive/mouse = 1,
		/mob/living/simple_mob/vore/otie/red/chubby/cocoa = 1,
		/mob/living/simple_mob/vore/aggressive/rat/pet = 1,
	)

/datum/experiment/scanning/points/slime_scanning
	name = "Slime Scanning Experiment"
	description = "Xenobiologists love their squishy friends. Scan one, or their core!"
	required_points = 1
	required_atoms = list(
		/mob/living/simple_mob/slime = 1,
		/obj/item/slime_extract = 1,
	)
