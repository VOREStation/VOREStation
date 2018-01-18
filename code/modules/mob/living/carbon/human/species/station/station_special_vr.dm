///////////////File for all snowflake/special races/////////////////////////////
/////Anything that is spectacularly special should be put in here///////////////
////////////////////////////////////////////////////////////////////////////////



/datum/species/xenochimera //Scree's race.
	name = "Xenochimera"
	name_plural = "Xenochimeras"
	icobase = 'icons/mob/human_races/r_xenochimera.dmi'
	deform = 'icons/mob/human_races/r_def_xenochimera.dmi'
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	darksight = 8		//critters with instincts to hide in the dark need to see in the dark - about as good as tajara.
	slowdown = -0.2		//scuttly, but not as scuttly as a tajara or a teshari.
	brute_mod = 0.8		//About as tanky to brute as a Unathi. They'll probably snap and go feral when hurt though.
	burn_mod =  1.15	//As vulnerable to burn as a Tajara.
	var/base_species = "Xenochimera"

	num_alternate_languages = 2
	secondary_langs = list("Sol Common")
	//color_mult = 1 //It seemed to work fine in testing, but I've been informed it's unneeded.
	tail = "tail" //Scree's tail. Can be disabled in the vore tab by choosing "hide species specific tail sprite"
	icobase_tail = 1
	inherent_verbs = list(
		/mob/living/carbon/human/proc/begin_reconstitute_form,
		/mob/living/carbon/human/proc/sonar_ping,
		/mob/living/carbon/human/proc/purge_impurities,
		/mob/living/carbon/human/proc/succubus_drain,
		/mob/living/carbon/human/proc/succubus_drain_finalize,
		/mob/living/carbon/human/proc/succubus_drain_lethal,
		/mob/living/carbon/human/proc/bloodsuck,
		/mob/living/carbon/human/proc/shred_limb,
		/mob/living/proc/flying_toggle,
		/mob/living/proc/start_wings_hovering) //Xenochimera get all the special verbs since they can't select traits.

	min_age = 18
	max_age = 80

	blurb = "Some amalgamation of different species from across the universe,with extremely unstable DNA, making them unfit for regular cloners. \
	Widely known for their voracious nature and violent tendencies when stressed or left unfed for long periods of time. \
	Most, if not all chimeras possess the ability to undergo some type of regeneration process, at the cost of energy."

	hazard_low_pressure = -1 //Prevents them from dying normally in space. Special code handled below.
	cold_level_1 = -5000     // All cold debuffs are handled below in handle_environment_special
	cold_level_2 = -5000
	cold_level_3 = -5000

	//primitive_form = "Farwa"

	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED //Whitelisted as restricted is broken.
	flags = NO_SCAN //Dying as a chimera is, quite literally, a death sentence. Well, if it wasn't for their revive, that is.
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#AFA59E"
	base_color 	= "#333333"
	blood_color = "#14AD8B"


/datum/species/xenochimera/handle_environment_special(var/mob/living/carbon/human/H)
	if(H.stat == 2) // If they're dead they won't think about being all feral and won't need all the code below.
		return

//handle feral triggers

	if(H.nutrition <= 200||H.traumatic_shock > min(60, H.nutrition/10)) // Stress factors are in play
		// If they're hungry, give nag messages.
		if (!istype(H.loc, /mob)) // if they're in a mob, skip the hunger stuff so it doesn't mess with drain/absorption modes.
			if(H.nutrition < 200 && H.nutrition > 150)
				if(prob(0.5)) //A bit of an issue, not too bad.
					H << "<span class='info'>You feel rather hungry. It might be a good idea to find some some food...</span>"

			else if(H.nutrition <= 150 && H.nutrition > 100)
				if(prob(0.5)) //Getting closer, should probably eat some food about now...
					H << "<span class='warning'>You feel like you're going to snap and give in to your hunger soon... It would be for the best to find some [pick("food","prey")] to eat...</span>"

			else if(H.nutrition <= 100) //Should've eaten sooner!
				if(H.feral == 0)
					H << "<span class='danger'><big>Something in your mind flips, your instincts taking over, no longer able to fully comprehend your surroundings as survival becomes your primary concern - you must feed, survive, there is nothing else. Hunt. Eat. Hide. Repeat.</big></span>"
					log_and_message_admins("has gone feral due to hunger.", H)
					H.feral += 5 //just put them over the threshold by a decent amount for the first chunk.
					if(H.stat == CONSCIOUS)
						H.emote("twitch")
				if(H.feral + H.nutrition < 150) //Feralness increases while this hungry, capped at 50-150 depending on hunger.
					H.feral += 1

		// If they're hurt, chance of snapping. Not if they're straight-up KO'd though.
		if (H.stat == CONSCIOUS && H.traumatic_shock >=min(60, H.nutrition/10)) //at 360 nutrition, this is 30 brute/burn, or 18 halloss. Capped at 50 brute/30 halloss - if they take THAT much, no amount of satiation will help them. Also they're fat.
			if (2.5*H.halloss >= H.traumatic_shock) //If the majority of their shock is due to halloss, greater chance of snapping.
				if(prob(min(10,(0.2 * H.traumatic_shock))))
					if(H.feral == 0)
						H << "<span class='danger'><big>The pain! It stings! Got to get away! Your instincts take over, urging you to flee, to hide, to go to ground, get away from here...</big></span>"
						log_and_message_admins("has gone feral due to halloss.", H)
					H.feral = max(H.feral, H.halloss) //if already more feral than their halloss justifies, don't increase it.
					H.emote("twitch")
			else if(prob(min(10,(0.1 * H.traumatic_shock))))
				H.emote("twitch")
				if(H.feral == 0)
					H << "<span class='danger'><big>Your fight-or-flight response kicks in, your injuries too much to simply ignore - you need to flee, to hide, survive at all costs - or destroy whatever is threatening you.</big></span>"
					H.feral = 2*H.traumatic_shock //Make 'em snap.
					log_and_message_admins("has gone feral due to injury.", H)
				else
					H.feral = max(H.feral, H.traumatic_shock * 2) //keep feralness up to match the current injury state.

	else if (H.jitteriness >= 100) //No stress factors, but there's coffee. Keeps them mildly feral while they're all jittery.
		if(H.feral == 0)
			H << "<span class='warning'><big>Suddenly, something flips - everything that moves is... potential prey. A plaything. This is great! Time to hunt!</big></span>"
			log_and_message_admins("has gone feral due to jitteriness.", H)
			if(H.stat == CONSCIOUS)
				H.emote("twitch")
		H.feral = max(H.feral, H.jitteriness-100) //they'll be twitchy and pouncy while they're under the influence, and feralness won't wear off until they're calm.

	else
		if (H.feral > 0) //still feral, but all stress factors are gone. Calm them down.
			H.feral -= 1
			if (H.feral <=0) //check if they're unferalled
				H.feral = 0
				H << "<span class='info'>Your thoughts start clearing, your feral urges having passed - for the time being, at least.</span>"
				log_and_message_admins("is no longer feral.", H)

// handle what happens while feral

	if(H.feral > 0) //do the following if feral, otherwise no effects.
		var/light_amount = H.getlightlevel() //how much light there is in the place

		H.shock_stage = max(H.shock_stage-(H.feral/20), 0) //if they lose enough health to hit softcrit, handle_shock() will keep resetting this. Otherwise, pissed off critters will lose shock faster than they gain it.

		if(light_amount <= 0.5) // in the darkness. No need for custom scene-protection checks as it's just an occational infomessage.
			if(prob(2)) //periodic nagmessages just to remind 'em they're still feral
				if (H.traumatic_shock >=min(60, H.nutrition/10)) // if hurt, tell 'em to heal up
					H << "<span class='info'> This place seems safe, secure, hidden, a place to lick your wounds and recover...</span>"
				else if(H.nutrition <= 100) //If hungry, nag them to go and find someone or something to eat.
					H << "<span class='info'> Secure in your hiding place, your hunger still gnaws at you. You need to catch some food...</span>"
				else if(H.jitteriness >= 100)
					H << "<span class='info'> sneakysneakyyesyesyescleverhidingfindthingsyessssss</span>"
				else //otherwise, just tell them to keep hiding.
					H << "<span class='info'> ...safe...</span>"
		else // must be in a lit area
			var/list/nearby = oviewers(H)
			if (nearby.len) // someone's nearby
				if(prob(1)) // 1 in 100 chance of doing something so as not to interrupt scenes
					var/mob/M = pick(nearby)
					if (H.traumatic_shock >=min(60, H.nutrition/10)) //tell 'em to be wary of a random person
						H << "<span class='danger'> You're hurt, in danger, exposed, and [M] looks to be a little too close for comfort...</span>"
					else if(H.nutrition <= 250 || H.jitteriness > 0) //tell them a random person in view looks like food. It CAN happen when you're not hungry enough to be feral, especially if coffee is involved.
						H << "<span class='danger'> Every movement, every flick, every sight and sound has your full attention, your hunting instincts on high alert... In fact, [M] looks extremely appetizing...</span>"
					if(H.stat == CONSCIOUS)
						H.emote("twitch")
					if(!H.handling_hal)
						H.handle_feral()
			else // nobody around
				if(!H.handling_hal)
					H.handle_feral()
				if(prob(2)) //periodic nagmessages
					if(H.nutrition <= 100) //If hungry, nag them to go and find someone or something to eat.
						H << "<span class='danger'> Confusing sights and sounds and smells surround you - scary and disorienting it may be, but the drive to hunt, to feed, to survive, compels you.</span>"
						if(H.stat == CONSCIOUS)
							H.emote("twitch")
					else if(H.jitteriness >= 100)
						H << "<span class='danger'> yesyesyesyesyesyesgetthethingGETTHETHINGfindfoodsfindpreypounceyesyesyes</span>"
						if(H.stat == CONSCIOUS)
							H.emote("twitch")
					else //otherwise, just tell them to hide.
						H << "<span class='danger'> Confusing sights and sounds and smells surround you, this place is wrong, confusing, frightening. You need to hide, go to ground...</span>"
						if(H.stat == CONSCIOUS)
							H.emote("twitch")


//////////////////////////////////////////////////////////////////////////////////////////
///////////WIP CODE TO MAKE XENOCHIMERAS NOT DIE IN SPACE WHILE REGENNING BELOW/////////// //I put WIP, but what I really meant to put was "Finished"
//////////////////////////////////////////////////////////////////////////////////////////

	var/datum/gas_mixture/environment = H.loc.return_air()
	var/pressure2 = environment.return_pressure()
	var/adjusted_pressure2 = H.calculate_affecting_pressure(pressure2)

	if(adjusted_pressure2 <= 20 && H.does_not_breathe) //If they're in a enviroment with no pressure and are not breathing (See: regenerating), don't kill them.
		//This is just to prevent them from taking damage if they're in stasis.

	else if(adjusted_pressure2 <= 20) //If they're in an enviroment with no pressure and are NOT in stasis, damage them.
		H.take_overall_damage(brute=LOW_PRESSURE_DAMAGE, used_weapon = "Low Pressure")

	if(H.bodytemperature <= 260 && H.does_not_breathe) //If they're regenerating, don't give them them the negative cold effects
		//This is just here to prevent them from getting cold effects

	else if(H.bodytemperature <= 260) //If they're not in stasis and are cold. Don't really have to add in an exception to cryo cells, as the effects aren't anything /too/ horrible.
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
		H.shock_stage = min(H.shock_stage + coldshock, 160) //cold hurts and gives them pain messages, eventually weakening and paralysing, but doesn't damage or trigger feral.
		return

/datum/species/xenochimera/proc/produceCopy(var/datum/species/to_copy,var/list/traits,var/mob/living/carbon/human/H)
	ASSERT(to_copy)
	ASSERT(istype(H))

	if(ispath(to_copy))
		to_copy = "[initial(to_copy.name)]"
	if(istext(to_copy))
		to_copy = all_species[to_copy]

	var/datum/species/xenochimera/new_copy = new()

	//Initials so it works with a simple path passed, or an instance
	new_copy.base_species = to_copy.name
	new_copy.icobase = to_copy.icobase
	new_copy.deform = to_copy.deform
	new_copy.tail = to_copy.tail
	new_copy.tail_animation = to_copy.tail_animation
	new_copy.icobase_tail = to_copy.icobase_tail
	new_copy.color_mult = to_copy.color_mult
	new_copy.primitive_form = to_copy.primitive_form
	new_copy.appearance_flags = to_copy.appearance_flags
	new_copy.flesh_color = to_copy.flesh_color
	new_copy.base_color = to_copy.base_color
	new_copy.blood_mask = to_copy.blood_mask
	new_copy.damage_mask = to_copy.damage_mask
	new_copy.damage_overlays = to_copy.damage_overlays

	//Set up a mob
	H.species = new_copy
	H.icon_state = lowertext(new_copy.get_bodytype())

	if(new_copy.holder_type)
		H.holder_type = new_copy.holder_type

	if(H.dna)
		H.dna.ready_dna(H)

	return new_copy

/datum/species/xenochimera/get_bodytype()
	return base_species

/datum/species/xenochimera/get_race_key()
	var/datum/species/real = all_species[base_species]
	return real.race_key


/////////////////////
/////SPIDER RACE/////
/////////////////////
/datum/species/spider //These actually look pretty damn spooky!
	name = "Vasilissan"
	name_plural = "Vasilissans"
	icobase = 'icons/mob/human_races/r_spider.dmi'
	deform = 'icons/mob/human_races/r_def_spider.dmi'
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	darksight = 8		//Can see completely in the dark. They are spiders, after all. Not that any of this matters because people will be using custom race.
	slowdown = -0.15	//Small speedboost, as they've got a bunch of legs. Or something. I dunno.
	brute_mod = 0.8		//20% brute damage reduction
	burn_mod =  1.15	//15% burn damage increase. They're spiders. Aerosol can+lighter = dead spiders.

	num_alternate_languages = 2
	secondary_langs = list("Sol Common")
	color_mult = 1
	tail = "tail" //Spider tail.
	icobase_tail = 1

	inherent_verbs = list(
		/mob/proc/weaveWebBindings)

	min_age = 18
	max_age = 80

	blurb = "Vasilissans are a tall, lanky, spider like people. \
	Each having four eyes, an extra four, large legs sprouting from their back, and a chitinous plating on their body, and the ability to spit webs \
	from their mandible lined mouths.  They are a recent discovery by Nanotrasen, only being discovered roughly seven years ago.  \
	Before they were found they built great cities out of their silk, being united and subjugated in warring factions under great Star Queens  \
	Who forced the working class to build huge, towering cities to attempt to reach the stars, which they worship as gems of great spiritual and magical significance."

	hazard_low_pressure = -1 //Prevents them from dying normally in space. Special code handled below.
	cold_level_1 = -5000     // All cold debuffs are handled below in handle_environment_special
	cold_level_2 = -5000
	cold_level_3 = -5000

	//primitive_form = "Monkey" //I dunno. Replace this in the future.

	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR | NO_MINOR_CUT

	flesh_color = "#AFA59E" //Gray-ish. Not sure if this is really needed, but eh.
	base_color 	= "#333333" //Blackish-gray
	blood_color = "#0952EF" //Spiders have blue blood.

/datum/species/spider/handle_environment_special(var/mob/living/carbon/human/H)
	if(H.stat == 2) // If they're dead they won't need anything.
		return

	var/datum/gas_mixture/environment = H.loc.return_air()
	var/pressure2 = environment.return_pressure()
	var/adjusted_pressure2 = H.calculate_affecting_pressure(pressure2)

	if(adjusted_pressure2 <= 20) //If they're in an enviroment with no pressure and are NOT in stasis, like a stasis bodybag, damage them.
		H.take_overall_damage(brute=LOW_PRESSURE_DAMAGE, used_weapon = "Low Pressure")

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
