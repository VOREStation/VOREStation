
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
		/mob/living/simple_mob/animal/passive/mothroach = 1,
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

// Basic Experiments to unlock the rig nodes.
/datum/experiment/scanning/points/basic_engi_rig
	name = "Basic Engineering Suit Scans"
	description = "We would like to access the structural wear and tear of existing void suits worn by engineers. Please scan some of the existing suits you may have lying around that an engineer might use."
	required_points = 2
	required_atoms = list(
		/obj/item/clothing/suit/space/void/engineering = 1,
		/obj/item/clothing/suit/space/void/engineering/hazmat = 1,
		/obj/item/clothing/suit/space/void/atmos = 1,
		/obj/item/clothing/suit/space/void/engineering/construction = 1,
	)

/datum/experiment/scanning/points/basic_sec_rig
	name = "Basic Security Suit Scans"
	description = "Some of our engineers had made a mistake of relying on the survivor's bias. And had armored the suits more in areas where officers have survived. We need additional data to correct this mistake."
	required_points = 2
	required_atoms = list(
		/obj/item/clothing/suit/space/void/security = 1,
		/obj/item/clothing/suit/space/void/security/riot = 1,
		/obj/item/clothing/suit/space/void/exploration =1,
	)

/datum/experiment/scanning/points/basic_med_rig
	name = "Basic Medical Suit Scans"
	description = "The synthprene fibers sterile properties have become a topic of extreme interest. With this scan data we can further enhance our first responders with proper RIGs fitting for the job."
	required_points = 2
	required_atoms = list(
		/obj/item/clothing/suit/space/void/medical = 1,
		/obj/item/clothing/suit/space/void/medical/emt = 1,
		/obj/item/clothing/suit/space/void/medical/bio = 1,
	)

/datum/experiment/scanning/points/basic_min_rig
	name = "Basic Mining Suit Scans"
	description = "We need scans of mining suits to check their durability in long usage of industrial environments. Go bug one of the miners for a quick scan. For rock and stone!"
	required_points = 2
	required_atoms = list(
		/obj/item/clothing/suit/space/void/mining = 1,
		/obj/item/clothing/suit/space/void/mining/alt = 1,
	)

/datum/experiment/scanning/points/basic_sci_rig
	name = "Basic Research Suit Scans"
	description = "We have recieve a notice that there are anomalous particles on the researcher's gear. Please scan and confirm for us. And while you're at it, give them a good wash for safety."
	required_points = 4
	required_atoms = list(
		/obj/item/clothing/suit/bio_suit/anomaly = 1,
		/obj/item/clothing/suit/space/anomaly = 1,
		/obj/item/clothing/suit/space/anomaly/heat = 1,
		/obj/item/clothing/suit/bomb_suit = 1,
		/obj/item/clothing/suit/bio_suit = 1,
	)
