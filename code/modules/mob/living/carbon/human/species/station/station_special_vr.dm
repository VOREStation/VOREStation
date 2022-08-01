///////////////File for all snowflake/special races/////////////////////////////
/////Anything that is spectacularly special should be put in here///////////////
////////////////////////////////////////////////////////////////////////////////



/datum/species/xenochimera //Scree's race.
	name = SPECIES_XENOCHIMERA
	name_plural = "Xenochimeras"
	icobase = 'icons/mob/human_races/r_xenochimera.dmi'
	deform = 'icons/mob/human_races/r_def_xenochimera.dmi'
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws/chimera, /datum/unarmed_attack/bite/sharp)
	darksight = 8		//critters with instincts to hide in the dark need to see in the dark - about as good as tajara.
	slowdown = -0.2		//scuttly, but not as scuttly as a tajara or a teshari.
	brute_mod = 0.8		//About as tanky to brute as a Unathi. They'll probably snap and go feral when hurt though.
	burn_mod =  1.15	//As vulnerable to burn as a Tajara.
	base_species = "Xenochimera"
	selects_bodytype = TRUE

	num_alternate_languages = 3
	secondary_langs = list("Sol Common")
	//color_mult = 1 //It seemed to work fine in testing, but I've been informed it's unneeded.
	tail = "tail" //Scree's tail. Can be disabled in the vore tab by choosing "hide species specific tail sprite"
	icobase_tail = 1
	inherent_verbs = list(
		/mob/living/carbon/human/proc/reconstitute_form,
		/mob/living/carbon/human/proc/sonar_ping,
		/mob/living/carbon/human/proc/tie_hair,
		/mob/living/proc/flying_toggle,
		/mob/living/proc/flying_vore_toggle,
		/mob/living/proc/start_wings_hovering)		//Xenochimera get all the special verbs since they can't select traits.

	virus_immune = 1 // They practically ARE one.
	min_age = 18
	max_age = 80

	blurb = "Some amalgamation of different species from across the universe,with extremely unstable DNA, making them unfit for regular cloners. \
	Widely known for their voracious nature and violent tendencies when stressed or left unfed for long periods of time. \
	Most, if not all chimeras possess the ability to undergo some type of regeneration process, at the cost of energy."

	wikilink = "https://wiki.vore-station.net/Xenochimera"

	catalogue_data = list(/datum/category_item/catalogue/fauna/xenochimera)

	hazard_low_pressure = -1 //Prevents them from dying normally in space. Special code handled below.
	cold_level_1 = -1     // All cold debuffs are handled below in handle_environment_special
	cold_level_2 = -1
	cold_level_3 = -1

	//primitive_form = "Farwa"

	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED | SPECIES_WHITELIST_SELECTABLE//Whitelisted as restricted is broken.
	flags = NO_SCAN | NO_INFECT // | NO_DEFIB // Dying as a chimera is, quite literally, a death sentence. Well, if it wasn't for their revive, that is. Leaving NO_DEFIB there for the future/in case reversion to old 'chimera no-defib.
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	genders = list(MALE, FEMALE, PLURAL, NEUTER)

	has_organ = list(    //Same organ list as tajarans, except for their SPECIAL BRAIN.
		O_HEART =    /obj/item/organ/internal/heart,
		O_LUNGS =    /obj/item/organ/internal/lungs,
		O_VOICE = 		/obj/item/organ/internal/voicebox,
		O_LIVER =    /obj/item/organ/internal/liver,
		O_KIDNEYS =  /obj/item/organ/internal/kidneys,
		O_BRAIN =    /obj/item/organ/internal/brain/xenochimera,
		O_EYES =     /obj/item/organ/internal/eyes,
		O_STOMACH =		/obj/item/organ/internal/stomach,
		O_INTESTINE =	/obj/item/organ/internal/intestine
		)

	flesh_color = "#AFA59E"
	base_color 	= "#333333"
	blood_color = "#14AD8B"

	reagent_tag = IS_CHIMERA

/datum/species/xenochimera/handle_environment_special(var/mob/living/carbon/human/H)
	//If they're KO'd/dead, or reviving, they're probably not thinking a lot about much of anything.
	if(!H.stat || !(H.revive_ready == REVIVING_NOW || H.revive_ready == REVIVING_DONE))
		handle_feralness(H)

	//While regenerating
	if(H.revive_ready == REVIVING_NOW || H.revive_ready == REVIVING_DONE)
		H.weakened = 5
		H.canmove = 0
		H.does_not_breathe = TRUE
		var/regen_sounds = H.regen_sounds
		if(prob(2)) // 2% chance of playing squelchy noise while reviving, which is run roughly every 2 seconds/tick while regenerating.
			playsound(H, pick(regen_sounds), 30)
			H.visible_message("<span class='danger'><p><font size=4>[H.name]'s motionless form shudders grotesquely, rippling unnaturally.</font></p></span>")

	//Cold/pressure effects when not regenerating
	else
		var/datum/gas_mixture/environment = H.loc.return_air()
		var/pressure2 = environment.return_pressure()
		var/adjusted_pressure2 = H.calculate_affecting_pressure(pressure2)

		//Very low pressure damage
		if(adjusted_pressure2 <= 20)
			H.take_overall_damage(brute=LOW_PRESSURE_DAMAGE, used_weapon = "Low Pressure")
		//they handle areas where they can't breathe better than most, but it still lowers their effective health as well as all the other bad stuff that comes with unbreathable environments
		if(H.getOxyLoss() >= 50)
			H.does_not_breathe = TRUE

		//Cold hurts and gives them pain messages, eventually weakening and paralysing, but doesn't damage or trigger feral.
		//NB: 'body_temperature' used here is the 'setpoint' species var
		var/temp_diff = body_temperature - H.bodytemperature
		if(temp_diff >= 50)
			H.shock_stage = min(H.shock_stage + (temp_diff/20), 160) // Divided by 20 is the same as previous numbers, but a full scale
			H.eye_blurry = max(5,H.eye_blurry)

/obj/item/organ/internal/brain/xenochimera
	var/laststress = 0

/datum/species/xenochimera/proc/handle_feralness(var/mob/living/carbon/human/H)
	//first, calculate how stressed the chimera is
	var/laststress = 0
	var/obj/item/organ/internal/brain/xenochimera/B = H.internal_organs_by_name[O_BRAIN]
	if(B) //if you don't have a chimera brain in a chimera body somehow, you don't get the feraless protection
		laststress = B.laststress

	//Low-ish nutrition has messages and can eventually cause feralness
	var/hunger = max(0, 150 - H.nutrition)

	//pain makes feralness a thing
	var/shock = 0.75*H.traumatic_shock

	//Caffeinated or otherwise overexcited xenochimera can become feral and have special messages
	var/jittery = max(0, H.jitteriness - 100)

	//To reduce distant object references
	var/feral = H.feral

	//Are we in danger of ferality?
	var/danger = FALSE
	var/feral_state = FALSE

	//finally, calculate the current stress total the chimera is operating under, and the cause
	var/currentstress = (hunger + shock + jittery)
	var/cause = "stress"
	if(hunger > shock && hunger > jittery)
		cause = "hunger"
	else if (shock > hunger && shock > jittery)
		cause = "shock"
	else if (jittery > shock && jittery > hunger)
		cause = "jittery"

	//check to see if they go feral if they weren't before
	if(!feral)
		// if stress is below 15, no chance of snapping. Also if they weren't feral before, they won't suddenly become feral unless they get MORE stressed
		if((currentstress > laststress) && prob(clamp(currentstress-15, 0, 100)) )
			go_feral(H, currentstress, cause)
			feral = currentstress //update the local var

		//they didn't go feral, give 'em a chance of hunger messages
		else if(H.nutrition <= 200 && prob(0.5) && !isbelly(H.loc))
			switch(H.nutrition)
				if(150 to 200)
					to_chat(H,"<span class='info'>You feel rather hungry. It might be a good idea to find some some food...</span>")
				if(100 to 150)
					to_chat(H,"<span class='warning'>You feel like you're going to snap and give in to your hunger soon... It would be for the best to find some [pick("food","prey")] to eat...</span>")
					danger = TRUE

	//now the check's done, update their brain so it remembers how stressed they were
	B.laststress = currentstress

	// Handle being feral
	if(feral)
		//We're feral
		feral_state = TRUE

		//If they're still stressed, they stay feral
		if(currentstress >= 15)
			danger = TRUE
			feral = max(feral, currentstress)

		else
			feral = max(0,--feral)

			// Being in a belly or in the darkness decreases stress further. Helps mechanically reward players for staying in darkness + RP'ing appropriately. :9
			var/turf/T = get_turf(H)
			if(feral && (isbelly(H.loc) || T.get_lumcount() <= 0.1))
				feral = max(0,--feral)

		//Set our real mob's var to our temp var
		H.feral = feral

		//Did we just finish being feral?
		if(!feral)
			feral_state = FALSE
			to_chat(H,"<span class='info'>Your thoughts start clearing, your feral urges having passed - for the time being, at least.</span>")
			log_and_message_admins("is no longer feral.", H)
			update_xenochimera_hud(H, danger, feral_state)
			return

		//If they lose enough health to hit softcrit, handle_shock() will keep resetting this. Otherwise, pissed off critters will lose shock faster than they gain it.
		H.shock_stage = max(H.shock_stage-(feral/20), 0)

		//Handle light/dark areas
		var/turf/T = get_turf(H)
		if(!T)
			update_xenochimera_hud(H, danger, feral_state)
			return //Nullspace
		var/darkish = T.get_lumcount() <= 0.1

		//Don't bother doing heavy lifting if we weren't going to give emotes anyway.
		if(!prob(1))

			//This is basically the 'lite' version of the below block.
			var/list/nearby = H.living_mobs(world.view)

			//Not in the dark, or a belly, and out in the open.
			if(!darkish && isturf(H.loc) && !isbelly(H.loc)) // Added specific check for if in belly

				//Always handle feral if nobody's around and not in the dark.
				if(!nearby.len)
					H.handle_feral()

				//Rarely handle feral if someone is around
				else if(prob(1))
					H.handle_feral()

			//And bail
			update_xenochimera_hud(H, danger, feral_state)
			return

		// In the darkness, or "hidden", or in a belly. No need for custom scene-protection checks as it's just an occational infomessage.
		if(darkish || !isturf(H.loc) || isbelly(H.loc)) // Specific check for if in belly. !isturf should do this, but JUST in case.
			// If hurt, tell 'em to heal up
			if (cause == "shock")
				to_chat(H,"<span class='info'>This place seems safe, secure, hidden, a place to lick your wounds and recover...</span>")

			//If hungry, nag them to go and find someone or something to eat.
			else if(cause == "hunger")
				to_chat(H,"<span class='info'>Secure in your hiding place, your hunger still gnaws at you. You need to catch some food...</span>")

			//If jittery, etc
			else if(cause == "jittery")
				to_chat(H,"<span class='info'>sneakysneakyyesyesyescleverhidingfindthingsyessssss</span>")

			//Otherwise, just tell them to keep hiding.
			else
				to_chat(H,"<span class='info'>...safe...</span>")

		// NOT in the darkness
		else

			//Twitch twitch
			if(!H.stat)
				H.emote("twitch")

			var/list/nearby = H.living_mobs(world.view)

			// Someone/something nearby
			if(nearby.len)
				var/M = pick(nearby)
				if(cause == "shock")
					to_chat(H,"<span class='danger'>You're hurt, in danger, exposed, and [M] looks to be a little too close for comfort...</span>")
				else
					to_chat(H,"<span class='danger'>Every movement, every flick, every sight and sound has your full attention, your hunting instincts on high alert... In fact, [M] looks extremely appetizing...</span>")

			// Nobody around
			else
				if(cause == "hunger")
					to_chat(H,"<span class='danger'>Confusing sights and sounds and smells surround you - scary and disorienting it may be, but the drive to hunt, to feed, to survive, compels you.</span>")
				else if(cause == "jittery")
					to_chat(H,"<span class='danger'>yesyesyesyesyesyesgetthethingGETTHETHINGfindfoodsfindpreypounceyesyesyes</span>")
				else
					to_chat(H,"<span class='danger'>Confusing sights and sounds and smells surround you, this place is wrong, confusing, frightening. You need to hide, go to ground...</span>")

	// HUD update time
	update_xenochimera_hud(H, danger, feral_state)

/datum/species/xenochimera/proc/go_feral(var/mob/living/carbon/human/H, var/stress, var/cause)
	// Going feral due to hunger
	if(cause == "hunger")
		to_chat(H,"<span class='danger'><big>Something in your mind flips, your instincts taking over, no longer able to fully comprehend your surroundings as survival becomes your primary concern - you must feed, survive, there is nothing else. Hunt. Eat. Hide. Repeat.</big></span>")
		log_and_message_admins("has gone feral due to hunger.", H)

	// If they're hurt, chance of snapping.
	else if(cause == "shock")
		//If the majority of their shock is due to halloss, give them a different message (3x multiplier on check as halloss is 2x - meaning t_s must be at least 3x for other damage sources to be the greater part)
		if(3*H.halloss >= H.traumatic_shock)
			to_chat(H,"<span class='danger'><big>The pain! It stings! Got to get away! Your instincts take over, urging you to flee, to hide, to go to ground, get away from here...</big></span>")
			log_and_message_admins("has gone feral due to halloss.", H)

		//Majority due to other damage sources
		else
			to_chat(H,"<span class='danger'><big>Your fight-or-flight response kicks in, your injuries too much to simply ignore - you need to flee, to hide, survive at all costs - or destroy whatever is threatening you.</big></span>")
			log_and_message_admins("has gone feral due to injury.", H)

	//No hungry or shock, but jittery
	else if(cause == "jittery")
		to_chat(H,"<span class='warning'><big>Suddenly, something flips - everything that moves is... potential prey. A plaything. This is great! Time to hunt!</big></span>")
		log_and_message_admins("has gone feral due to jitteriness.", H)

	else // catch-all just in case something weird happens
		to_chat(H,"<span class='warning'><big>The stress of your situation is too much for you, and your survival instincts kick in!</big></span>")
		log_and_message_admins("has gone feral for unknown reasons.", H)
	//finally, set their feral var
	H.feral = stress
	if(!H.stat)
		H.emote("twitch")

/datum/species/xenochimera/get_race_key()
	var/datum/species/real = GLOB.all_species[base_species]
	return real.race_key

/datum/species/xenochimera/proc/update_xenochimera_hud(var/mob/living/carbon/human/H, var/danger, var/feral)
	if(H.xenochimera_danger_display)
		H.xenochimera_danger_display.invisibility = 0
		if(danger && feral)
			H.xenochimera_danger_display.icon_state = "danger11"
		else if(danger && !feral)
			H.xenochimera_danger_display.icon_state = "danger10"
		else if(!danger && feral)
			H.xenochimera_danger_display.icon_state = "danger01"
		else
			H.xenochimera_danger_display.icon_state = "danger00"

	return

/////////////////////
/////SPIDER RACE/////
/////////////////////
/datum/species/spider //These actually look pretty damn spooky!
	name = SPECIES_VASILISSAN
	name_plural = "Vasilissans"
	icobase = 'icons/mob/human_races/r_spider.dmi'
	deform = 'icons/mob/human_races/r_def_spider.dmi'
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	darksight = 8		//Can see completely in the dark. They are spiders, after all. Not that any of this matters because people will be using custom race.
	slowdown = -0.15	//Small speedboost, as they've got a bunch of legs. Or something. I dunno.
	brute_mod = 0.8		//20% brute damage reduction
	burn_mod =  1.15	//15% burn damage increase. They're spiders. Aerosol can+lighter = dead spiders.

	num_alternate_languages = 3
	secondary_langs = list(LANGUAGE_VESPINAE)
	color_mult = 1
	tail = "tail" //Spider tail.
	icobase_tail = 1

	inherent_verbs = list(
		/mob/living/carbon/human/proc/check_silk_amount,
		/mob/living/carbon/human/proc/toggle_silk_production,
		/mob/living/carbon/human/proc/weave_structure,
		/mob/living/carbon/human/proc/weave_item,
		/mob/living/carbon/human/proc/set_silk_color,
		/mob/living/carbon/human/proc/tie_hair)

	min_age = 18
	max_age = 80

	blurb = "Vasilissans are a tall, lanky, spider like people. \
	Each having four eyes, an extra four, large legs sprouting from their back, and a chitinous plating on their body, and the ability to spit webs \
	from their mandible lined mouths.  They are a recent discovery by Nanotrasen, only being discovered roughly seven years ago.  \
	Before they were found they built great cities out of their silk, being united and subjugated in warring factions under great Star Queens  \
	Who forced the working class to build huge, towering cities to attempt to reach the stars, which they worship as gems of great spiritual and magical significance."

	wikilink = "https://wiki.vore-station.net/Vasilissans"

	catalogue_data = list(/datum/category_item/catalogue/fauna/vasilissan)

	hazard_low_pressure = 20 //Prevents them from dying normally in space. Special code handled below.
	cold_level_1 = -1    // All cold debuffs are handled below in handle_environment_special
	cold_level_2 = -1
	cold_level_3 = -1

	//primitive_form = "Monkey" //I dunno. Replace this in the future.

	flags = NO_MINOR_CUT
	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	genders = list(MALE, FEMALE, PLURAL, NEUTER)

	flesh_color = "#AFA59E" //Gray-ish. Not sure if this is really needed, but eh.
	base_color 	= "#333333" //Blackish-gray
	blood_color = "#0952EF" //Spiders have blue blood.

	is_weaver = TRUE
	silk_reserve = 500
	silk_max_reserve = 1000

/datum/species/spider/handle_environment_special(var/mob/living/carbon/human/H)
	if(H.stat == DEAD) // If they're dead they won't need anything.
		return

	if(H.bodytemperature <= 260) //If they're really cold, they go into stasis.
		var/coldshock = 0
		if(H.bodytemperature <= 260 && H.bodytemperature >= 200) //Chilly.
			coldshock = 4 //This will begin to knock them out until they run out of oxygen and suffocate or until someone finds them.
			H.eye_blurry = 5 //Blurry vision in the cold.
		if(H.bodytemperature <= 199 && H.bodytemperature >= 100) //Extremely cold. Even in somewhere like the server room it takes a while for bodytemp to drop this low.
			coldshock = 8
			H.eye_blurry = 5
		if(H.bodytemperature <= 99) //Insanely cold.
			coldshock = 16
			H.eye_blurry = 5
		H.shock_stage = min(H.shock_stage + coldshock, 160) //cold hurts and gives them pain messages, eventually weakening and paralysing, but doesn't damage.
		return

/datum/species/werebeast
	name = SPECIES_WEREBEAST
	name_plural = "Werebeasts"
	icobase = 'icons/mob/human_races/r_werebeast.dmi'
	deform = 'icons/mob/human_races/r_def_werebeast.dmi'
	icon_template = 'icons/mob/human_races/r_werebeast.dmi'
	tail = "tail"
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	total_health = 200
	brute_mod = 0.85
	burn_mod = 0.85
	metabolic_rate = 2
	item_slowdown_mod = 0.25
	hunger_factor = 0.4
	darksight = 8
	mob_size = MOB_LARGE
	num_alternate_languages = 3
	secondary_langs = list(LANGUAGE_CANILUNZT)
	name_language = LANGUAGE_CANILUNZT
	primitive_form = "Wolpin"
	color_mult = 1
	icon_height = 64

	min_age = 18
	max_age = 200

	blurb = "Big buff werewolves. These are a limited functionality event species that are not balanced for regular gameplay. Adminspawn only."

	wikilink="N/A"

	catalogue_data = list(/datum/category_item/catalogue/fauna/vulpkanin)

	spawn_flags		 = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED | SPECIES_WHITELIST_SELECTABLE
	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#AFA59E"
	base_color = "#777777"

	genders = list(MALE, FEMALE, PLURAL, NEUTER)

	heat_discomfort_strings = list(
		"Your fur prickles in the heat.",
		"You feel uncomfortably warm.",
		"Your overheated skin itches."
		)

	has_limbs = list(
		BP_TORSO =  list("path" = /obj/item/organ/external/chest),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/werebeast),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right)
		)

