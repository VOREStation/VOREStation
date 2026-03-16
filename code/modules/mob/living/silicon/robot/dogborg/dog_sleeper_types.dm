/obj/item/dogborg/sleeper/K9 //The K9 portabrig
	name = "Brig-Belly"
	desc = "A mounted portable-brig that holds criminals for processing or 'processing'."
	icon_state = "sleeperb"
	injection_chems = null //So they don't have all the same chems as the medihound!
	stabilizer = TRUE
	medsensor = FALSE

/obj/item/dogborg/sleeper/compactor //Janihound gut.
	name = "Garbage Processor"
	desc = "A mounted garbage compactor unit with fuel processor, capable of processing any kind of contaminant."
	icon_state = "compactor"
	injection_chems = null //So they don't have all the same chems as the medihound!
	compactor = TRUE
	recycles = TRUE
	max_item_count = 25
	stabilizer = FALSE
	medsensor = FALSE

/obj/item/dogborg/sleeper/compactor/analyzer //sci-borg gut.
	name = "Digestive Analyzer"
	desc = "A mounted destructive analyzer unit with fuel processor, for 'deep scientific analysis'."
	icon_state = "analyzer"
	max_item_count = 10
	startdrain = 100
	analyzer = TRUE
	recycles = FALSE

/obj/item/dogborg/sleeper/compactor/decompiler
	name = "Matter Decompiler"
	desc = "A mounted matter decompiling unit with fuel processor, for recycling anything and everyone."
	icon_state = "decompiler"
	max_item_count = 10
	decompiler = TRUE
	recycles = TRUE
/*
/obj/item/dogborg/sleeper/compactor/delivery //Unfinished and unimplemented, still testing.
	name = "Cargo Belly"
	desc = "A mounted cargo bay unit for tagged deliveries."
	icon_state = "decompiler"
	max_item_count = 20
	delivery = TRUE
	recycles = FALSE
*/

/obj/item/dogborg/sleeper/compactor/supply //Miner borg belly
	name = "Supply Storage"
	desc = "A mounted survival unit with fuel processor, helpful with both deliveries and assisting injured miners."
	icon_state = "sleeperc"
	injection_chems = list(REAGENT_ID_GLUCOSE,REAGENT_ID_INAPROVALINE,REAGENT_ID_TRICORDRAZINE)
	max_item_count = 20
	ore_storage = TRUE
	var/list/stored_ore = list(
		ORE_SAND = 0,
		ORE_HEMATITE = 0,
		ORE_CARBON = 0,
		ORE_COPPER = 0,
		ORE_TIN = 0,
		ORE_VOPAL = 0,
		ORE_PAINITE = 0,
		ORE_QUARTZ = 0,
		ORE_BAUXITE = 0,
		ORE_PHORON = 0,
		ORE_SILVER = 0,
		ORE_GOLD = 0,
		ORE_MARBLE = 0,
		ORE_URANIUM = 0,
		ORE_DIAMOND = 0,
		ORE_PLATINUM = 0,
		ORE_LEAD = 0,
		ORE_MHYDROGEN = 0,
		ORE_VERDANTIUM = 0,
		ORE_RUTILE = 0)
	medsensor = FALSE

/obj/item/dogborg/sleeper/compactor/supply/Entered(atom/movable/thing, atom/OldLoc)
	. = ..()
	if(istype(thing, /obj/item/ore))
		var/obj/item/ore/ore = thing
		stored_ore[ore.material]++
		current_capacity++
		qdel(ore)

/obj/structure/ore_box/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/dogborg/sleeper/compactor/supply))
		var/obj/item/dogborg/sleeper/compactor/supply/S = W
		for(var/ore in S.stored_ore)
			if(S.stored_ore[ore] > 0)
				var/ore_amount = S.stored_ore[ore]	// How many ores does the satchel have?
				stored_ore[ore] += ore_amount 		// Add the ore to the machine.
				S.stored_ore[ore] = 0 				// Set the value of the ore in the satchel to 0.
				S.current_capacity = 0				// Set the amount of ore in the satchel  to 0.
		to_chat(user, span_notice("You empty the satchel into the box."))
		return
	..()

/obj/item/dogborg/sleeper/compactor/brewer
	name = "Brew Belly"
	desc = "A mounted drunk tank unit with fuel processor, for putting away particularly rowdy patrons."
	icon_state = "brewer"
	injection_chems = null //So they don't have all the same chems as the medihound!
	max_item_count = 10
	recycles = FALSE
	stabilizer = TRUE
	medsensor = FALSE

/obj/item/dogborg/sleeper/compactor/generic
	name = "Internal Cache"
	desc = "An internal storage of no particularly specific purpose.."
	icon_state = "sleeperd"
	max_item_count = 10
	recycles = FALSE

/obj/item/dogborg/sleeper/compactor/brewer/inject_chem(mob/user, chem)
	if(patient && patient.reagents)
		if((chem in injection_chems) + REAGENT_ID_INAPROVALINE)
			if(hound.cell.charge < 200) //This is so borgs don't kill themselves with it.
				to_chat(hound, span_notice("You don't have enough power to synthesize fluids."))
				return
			else if(patient.reagents.get_reagent_amount(chem) + 10 >= 50) //Preventing people from accidentally killing themselves by trying to inject too many chemicals!
				to_chat(hound, span_notice("Your stomach is currently too full of fluids to secrete more fluids of this kind."))
			else if(patient.reagents.get_reagent_amount(chem) + 10 <= 50) //No overdoses for you
				patient.reagents.add_reagent(chem, inject_amount)
				drain(100) //-100 charge per injection
			var/units = round(patient.reagents.get_reagent_amount(chem))
			to_chat(hound, span_notice("Injecting [units] unit\s into occupant.")) //If they were immersed, the reagents wouldn't leave with them.

/obj/item/dogborg/sleeper/K9/ert
	name = "Emergency Storage"
	desc = "A mounted 'emergency containment cell'."
	icon_state = "sleeperert"
	injection_chems = list(REAGENT_ID_INAPROVALINE, REAGENT_ID_TRAMADOL) // short list

/obj/item/dogborg/sleeper/trauma //Trauma borg belly
	name = "Recovery Belly"
	desc = "A downgraded model of the sleeper belly, intended primarily for post-surgery recovery."
	icon_state = "sleeper"
	injection_chems = list(REAGENT_ID_INAPROVALINE, REAGENT_ID_DEXALIN, REAGENT_ID_TRICORDRAZINE, REAGENT_ID_SPACEACILLIN, REAGENT_ID_OXYCODONE)

/obj/item/dogborg/sleeper/lost
	name = "Multipurpose Belly"
	desc = "A multipurpose belly, capable of functioning as both sleeper and processor."
	icon_state = "sleeperlost"
	injection_chems = list(REAGENT_ID_TRICORDRAZINE, REAGENT_ID_BICARIDINE, REAGENT_ID_DEXALIN, REAGENT_ID_ANTITOXIN, REAGENT_ID_TRAMADOL, REAGENT_ID_SPACEACILLIN)
	compactor = TRUE
	max_item_count = 25
	stabilizer = TRUE
	medsensor = TRUE

/obj/item/dogborg/sleeper/syndie
	name = "Combat Triage Belly"
	desc = "A mounted sleeper that stabilizes patients and can inject reagents in the borg's reserves. This one is for more extreme combat scenarios."
	icon_state = "sleepersyndiemed"
	injection_chems = list(REAGENT_ID_HEALINGNANITES, REAGENT_ID_HYPERZINE, REAGENT_ID_TRAMADOL, REAGENT_ID_OXYCODONE, REAGENT_ID_SPACEACILLIN, REAGENT_ID_PERIDAXON, REAGENT_ID_OSTEODAXON, REAGENT_ID_MYELAMINE, REAGENT_ID_SYNTHBLOOD)
	digest_multiplier = 2

/obj/item/dogborg/sleeper/K9/syndie
	name = "Cell-Belly"
	desc = "A mounted portable cell that holds anyone you wish for processing or 'processing'."
	icon_state = "sleepersyndiebrig"
	digest_multiplier = 3

/obj/item/dogborg/sleeper/compactor/syndie
	name = "Advanced Matter Decompiler"
	desc = "A mounted matter decompiling unit with fuel processor, for recycling anything and everyone in your way."
	icon_state = "sleepersyndieeng"
	max_item_count = 35
	digest_multiplier = 3

/obj/item/dogborg/sleeper/command //Command borg belly
	name = "Bluespace Filing Belly"
	desc = "A mounted bluespace storage unit for carrying paperwork"
	icon_state = "sleeperd"
	injection_chems = null
	compactor = TRUE
	recycles = FALSE
	max_item_count = 25
	medsensor = FALSE

/obj/item/dogborg/sleeper/compactor/honkborg
	name = "Jiggles Von Hungertron"
	desc = "You've heard of Giggles Von Honkerton for the back, now get ready for Jiggles Von Hungertron for the front."
	icon_state = "clowngut"
	recycles = FALSE

/obj/item/dogborg/sleeper/exploration
	name = "Store-Belly"
	desc = "Equipment for a ExploreHound unit. A mounted portable-storage device that holds supplies/person."
	icon_state = "sleeperlost"
	injection_chems = list(REAGENT_ID_INAPROVALINE) // Only to stabilize during extractions
	compactor = TRUE
	max_item_count = 4
	medsensor = FALSE
	recycles = TRUE
