/*
Semi-randomized loot for PoIs involving medicine.
Note that most of these include both 'good' and 'bad' results, with the bad results often being
much more likely to show up. This is done for several purposes;

 * A large influx of valuable medicine makes medical/SAR less needed for explorers, which is something we want to avoid.
 * Blindly using autoinjectors should be risky, and to accomplish that, it needs to be more likely to get a bad effect.
 * A large amount of bad loot helps make the good loot feel better to acquire.

*/

// This one makes a purely random hypo. Not recommended for PoIs since it will produce nonsensical results for a PoI's theme.
// It's more of a thing to help pick specific hypos for the other lists.
/obj/random/unidentified_medicine
	name = "unidentified medicine"
	desc = "This will make a random hypo."
	icon = 'icons/obj/syringe.dmi'
	icon_state = "autoinjector1"

/obj/random/unidentified_medicine/item_to_spawn()
	return pick(
		/obj/item/reagent_containers/hypospray/autoinjector/bonemed/unidentified,
		/obj/item/reagent_containers/hypospray/autoinjector/clonemed/unidentified,
		/obj/item/reagent_containers/hypospray/autoinjector/biginjector/brute/unidentified,
		/obj/item/reagent_containers/hypospray/autoinjector/biginjector/burn/unidentified,
		/obj/item/reagent_containers/hypospray/autoinjector/biginjector/toxin/unidentified,
		/obj/item/reagent_containers/hypospray/autoinjector/biginjector/oxy/unidentified,
		/obj/item/reagent_containers/hypospray/autoinjector/biginjector/purity/unidentified,
		/obj/item/reagent_containers/hypospray/autoinjector/biginjector/pain/unidentified,
		/obj/item/reagent_containers/hypospray/autoinjector/biginjector/organ/unidentified,
		/obj/item/reagent_containers/hypospray/autoinjector/biginjector/clotting/unidentified,
		/obj/item/reagent_containers/hypospray/autoinjector/biginjector/combat/unidentified,
		/obj/item/reagent_containers/hypospray/autoinjector/biginjector/healing_nanites/unidentified,
		/obj/item/reagent_containers/hypospray/autoinjector/biginjector/stimm/unidentified,
		/obj/item/reagent_containers/hypospray/autoinjector/biginjector/bliss/unidentified,
		/obj/item/reagent_containers/hypospray/autoinjector/biginjector/expired/unidentified,
		/obj/item/reagent_containers/hypospray/autoinjector/biginjector/serotrotium/unidentified,
		/obj/item/reagent_containers/hypospray/autoinjector/biginjector/cryptobiolin/unidentified,
		/obj/item/reagent_containers/hypospray/autoinjector/biginjector/mindbreaker/unidentified,
		/obj/item/reagent_containers/hypospray/autoinjector/biginjector/psilocybin/unidentified,
		/obj/item/reagent_containers/hypospray/autoinjector/biginjector/soporific/unidentified,
		/obj/item/reagent_containers/hypospray/autoinjector/biginjector/cyanide/unidentified,
		/obj/item/reagent_containers/hypospray/autoinjector/biginjector/impedrezene/unidentified,
		/obj/item/reagent_containers/hypospray/autoinjector/biginjector/mutagen/unidentified,
		/obj/item/reagent_containers/hypospray/autoinjector/biginjector/defective_nanites/unidentified,
		/obj/item/reagent_containers/hypospray/autoinjector/biginjector/contaminated/unidentified)

// Produces things you might find in an old medicine cabinet in a PoI.
// Old cabinets are typical of ruins and abandoned buildings in the plains, meaning they're usually easier to reach, and as such, inferior loot.
/obj/random/unidentified_medicine/old_medicine/item_to_spawn()
	// 30 Good, 70 Bad. 30% to get something good.
	// Poor odds, but these are fairly easy to reach as they're in abandoned areas.
	return pick(
		prob(5);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/brute/unidentified,
		prob(5);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/burn/unidentified,
		prob(5);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/toxin/unidentified,
		prob(5);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/oxy/unidentified,
		prob(5);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/purity/unidentified,
		prob(5);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/pain/unidentified,
		prob(65);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/expired/unidentified,
		prob(5);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/contaminated/unidentified)

// Medicine belonging to a place still being occupied (or was recently), meaning the goods might still be fresh, and better.
/obj/random/unidentified_medicine/fresh_medicine/item_to_spawn()
	// More likely to get something good, and a chance to get rare medicines.
	// 80 Good, 25 Bad. 76% chance of getting something good.
	// Good odds, but the contents aren't super great unless someone gets lucky.
	return pick(
		prob(5);/obj/item/reagent_containers/hypospray/autoinjector/bonemed/unidentified,
		prob(5);/obj/item/reagent_containers/hypospray/autoinjector/clonemed/unidentified,
		prob(10);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/brute/unidentified,
		prob(10);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/burn/unidentified,
		prob(10);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/toxin/unidentified,
		prob(10);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/oxy/unidentified,
		prob(10);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/purity/unidentified,
		prob(10);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/pain/unidentified,
		prob(5);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/organ/unidentified,
		prob(5);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/clotting/unidentified,
		prob(25);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/expired/unidentified)

// For military PoIs like BSD. High odds of good loot since those PoIs are really hard.
/obj/random/unidentified_medicine/combat_medicine/item_to_spawn()
	// More likely to get something good, and a chance to get rare medicines.
	// 75 Good, 30 Bad, roughly 71.4% chance to get something good.
	// Very high but very hard to reach and still has a chance of ending poorly if injecting blind.
	return pick(
		prob(5);/obj/item/reagent_containers/hypospray/autoinjector/bonemed/unidentified,
		prob(5);/obj/item/reagent_containers/hypospray/autoinjector/clonemed/unidentified,
		prob(5);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/brute/unidentified,
		prob(5);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/burn/unidentified,
		prob(5);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/pain/unidentified,
		prob(10);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/organ/unidentified,
		prob(10);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/clotting/unidentified,
		prob(30);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/combat/unidentified,
		prob(10);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/soporific/unidentified,
		prob(30);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/cyanide/unidentified)

// Hyposprays found inside various illicit places.
/obj/random/unidentified_medicine/drug_den/item_to_spawn()
	// Combat stims are common, but so are nasty drugs.
	// 70 Good, 160 Bad, roughly 30% to get something good.
	// Poor odds, but there are a lot of these scattered in the drug dens and illegal chem labs.
	return pick(
		prob(5);/obj/item/reagent_containers/hypospray/autoinjector/bonemed/unidentified,
		prob(5);/obj/item/reagent_containers/hypospray/autoinjector/clonemed/unidentified,
		prob(10);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/pain/unidentified,
		prob(5);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/organ/unidentified,
		prob(5);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/clotting/unidentified,
		prob(40);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/combat/unidentified,
		prob(20);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/stimm/unidentified,
		prob(20);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/bliss/unidentified,
		prob(20);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/serotrotium/unidentified,
		prob(20);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/cryptobiolin/unidentified,
		prob(20);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/mindbreaker/unidentified,
		prob(20);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/psilocybin/unidentified,
		prob(20);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/soporific/unidentified,
		prob(10);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/impedrezene/unidentified,
		prob(5);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/cyanide/unidentified,
		prob(5);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/contaminated/unidentified)

// Medicine made FOR SCIENCE.
/obj/random/unidentified_medicine/scientific/item_to_spawn()
	// Potential for amazing loot, also potential for very nasty consequences if injecting blind.
	// 45 Good, 45 Bad, 50% chance to get something good.
	// Do you feel lucky?
	return pick(
		prob(5);/obj/item/reagent_containers/hypospray/autoinjector/bonemed/unidentified,
		prob(5);/obj/item/reagent_containers/hypospray/autoinjector/clonemed/unidentified,
		prob(10);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/organ/unidentified,
		prob(10);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/clotting/unidentified,
		prob(10);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/combat/unidentified,
		prob(5);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/healing_nanites/unidentified,
		prob(20);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/contaminated/unidentified,
		prob(10);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/cyanide/unidentified,
		prob(10);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/mutagen/unidentified,
		prob(5);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/defective_nanites/unidentified)

// Nanomachines, son. Found in very advanced places such as the Crashed UFO.
/obj/random/unidentified_medicine/nanites/item_to_spawn()
	// You better identify this if you value your life.
	// 30 Good, 70 Bad. 30% of getting a good outcome.
	return pick(
		prob(30);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/healing_nanites/unidentified,
		prob(70);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/defective_nanites/unidentified)

// Found in virus-related areas like the Quarantined Shuttle.
/obj/random/unidentified_medicine/viral/item_to_spawn()
	// Another one where's its important to identify the hypo.
	// 30 Good, 70 Bad. 30% of getting a good outcome.
	return pick(
		prob(30);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/purity/unidentified,
		prob(40);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/expired/unidentified,
		prob(10);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/mutagen/unidentified,
		prob(20);/obj/item/reagent_containers/hypospray/autoinjector/biginjector/contaminated/unidentified)
