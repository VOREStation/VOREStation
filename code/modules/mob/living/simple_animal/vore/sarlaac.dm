



/mob/living/simple_animal/retaliate/sarlaac
	name = "Sarlacc"	//Need a new name so no suing.
	desc = "Some sort of massive maw sticking out of the ground. Seems safe." //Placeholder plz suggest better.
	//tt_desc = "Semaeostomeae virginus" //No idea what name it should have
	icon = 'icons/mob/vore64x64.dmi'//Placeholder.
	icon_dead = "deathclaw-dead"
	icon_living = "deathclaw"
	icon_state = "deathclaw"


	health = 800 //Sturdy

	melee_damage_lower = 40 // Break legs and eat
	melee_damage_upper = 25
	attacktext = list("thrashed")
	friendly = "caressed"

	response_help   = "brushes"	// If clicked on help intent
	response_disarm = "pushes" // If clicked on disarm intent
	response_harm   = "punches"	// If clicked on harm intent

	wander = 0 //No move
	returns_home = 1
	follow_dist = 0

	minbodytemp = 0 //Can be outside
	maxbodytemp = 350

	min_oxy = 0
	max_oxy = 5 // Does not like oxygen very much.
	min_tox = 1 // Needs phoron to survive.
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0

	armor = list(			// Values for normal getarmor() checks
				"melee" = 40,		//Insides are underground
				"bullet" = 0,
				"laser" = 0,
				"energy" = 0,
				"bomb" = -100,			//This kill the insides
				"bio" = -100,
				"rad" = -100)
	taser_kill = 0	//No
	run_at_them = 0

// Activate Noms!
/mob/living/simple_animal/retaliate/sarlaac 
	vore_active = 1
	vore_capacity = 3
	vore_bump_chance = 100 //How did you not see this coming
	vore_bump_emote = "wraps its tentacles around"
	vore_default_mode = DM_DRAIN
	vore_icons = SA_ICON_LIVING


	vore_digest_chance = 0			// Chance to switch to digest mode if resisted
	vore_absorb_chance = 0			// BECOME A PART OF ME.
	vore_pounce_chance = 66			// Just don't come close you idiots!
	vore_standing_too = 1
	vore_ignores_undigestable = 1


// Make sure you don't call ..() on this one, otherwise you duplicate work.
/mob/living/simple_animal/init_vore()

	var/obj/belly/B1 = new /obj/belly(src)
	vore_selected = B1
	B1.immutable = 1
	B1.name = "internal chamber"
	B1.desc = "Your surroundings are tight, constantly shiftting, and slimy. Makes sense, considering you're inside \the [name]."
	B1.digest_mode = DM_HOLD
	B1.mode_flags = vore_default_flags
	B1.escapable = vore_escape_chance > 0
	B1.escapechance = 30
	B1.digestchance = 0
	B1.transferchance = 70
	B1.transferlocation = "deeper chamber"
	B1.absorbchance = 0

	B1.human_prey_swallow_time = swallowTime
	B1.nonhuman_prey_swallow_time = swallowTime
	B1.vore_verb = "swallow"
	B1.emote_lists[DM_HOLD] = list( //Please change them they suck.
		"The insides knead at you for a moment.",
		"The guts glorp wetly around you as some air shifts.",
		"The predator takes a deep breath and sighs, shifting you somewhat.",
		"The stomach squeezes you tight for a moment, then relaxes.",
		"The predator's breathing and thumping heartbeat pulses around you.",
		"The warm walls kneads against you.",
		"The liquids churn around you, though there doesn't seem to be much effect.",
		"The sound of bodily movements drown out everything for a moment.",
		"The predator's movements force you into a different position.")
	B1.emote_lists[DM_DIGEST] = list(
		"The burning acids eat away at your form.",
		"The muscular stomach flesh grinds harshly against you.",
		"The caustic air stings your chest when you try to breathe.",
		"The slimy guts squeeze inward to help the digestive juices soften you up.",
		"The onslaught against your body doesn't seem to be letting up; you're food now.",
		"The predator's body ripples and crushes against you as digestive enzymes pull you apart.",
		"The juices pooling beneath you sizzle against your sore skin.",
		"The churning walls slowly pulverize you into meaty nutrients.",
		"The stomach glorps and gurgles as it tries to work you into slop.")

	var/obj/belly/B2 = new /obj/belly(src)
	B2.immutable = 1
	B2.name = "deeper chamber"
	B2.desc = "Your surroundings are tight, constantly shiftting, and slimy. Makes sense, considering you're inside \the [name]."
	B2.digest_mode = DM_DRAIN
	B2.mode_flags = vore_default_flags
	B2.escapable = vore_escape_chance > 0
	B2.escapechance = 0
	B2.digestchance = 5
	B2.transferchance = 15	//Escape to upper level
	B2.transferlocation = "internal chamber"
	B2.absorbchance = 50

	B2.human_prey_swallow_time = 10
	B2.nonhuman_prey_swallow_time = 10
	B2.vore_verb = "swallow"
	B2.emote_lists[DM_DRAIN] = list( // We need more that aren't repetitive. I suck at endo. -Ace
		"The insides knead at you for a moment.",
		"The guts glorp wetly around you as some air shifts.",
		"The predator takes a deep breath and sighs, shifting you somewhat.",
		"The stomach squeezes you tight for a moment, then relaxes.",
		"The predator's breathing and thumping heartbeat pulses around you.",
		"The warm walls kneads against you.",
		"The liquids churn around you, though there doesn't seem to be much effect.",
		"The sound of bodily movements drown out everything for a moment.",
		"You're practically smothered in the oppressive heat of the creature's stomach!",//Stolen
		"The predator's movements force you into a different position.")
	B2.emote_lists[DM_DIGEST] = list(
		"The burning acids eat away at your form.",
		"The muscular stomach flesh grinds harshly against you.",
		"The caustic air stings your chest when you try to breathe.",
		"The slimy guts squeeze inward to help the digestive juices soften you up.",
		"The onslaught against your body doesn't seem to be letting up; you're food now.",
		"The predator's body ripples and crushes against you as digestive enzymes pull you apart.",
		"The juices pooling beneath you sizzle against your sore skin.",
		"The churning walls slowly pulverize you into meaty nutrients.",
		"The stomach glorps and gurgles as it tries to work you into slop.")
