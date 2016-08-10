///////////////File for all snowflake/special races/////////////////////////////
/////Anything that is spectacularly special should be put in here///////////////
////////////////////////////////////////////////////////////////////////////////



/datum/species/xenochimera //Scree's race.
	name = "Xenochimera"
	name_plural = "Xenochimeras"
	icobase = 'icons/mob/human_races/r_xenochimera.dmi'
	deform = 'icons/mob/human_races/r_def_xenochimera.dmi'
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/punch, /datum/unarmed_attack/bite)
	num_alternate_languages = 2
	secondary_langs = list("Sol Common")
	//color_mult = 1 //It seemed to work fine in testing, but I've been informed it's unneeded.
	tail = "tail" //Scree's tail. Can be disabled in the vore tab by choosing "hide species specific tail sprite"
	icobase_tail = 1
	inherent_verbs = list(/mob/living/carbon/human/proc/begin_reconstitute_form)

	min_age = 17
	max_age = 80

	blurb = "Some amalgamation of different species from across the universe,with extremely unstable DNA, making them unfit for regular cloners. \
	Widely known for their voracious nature and violent tendencies when left unfed for long periods of time. \
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
	if(H.absorbed == 1) //If they get nomphed and absorbed.
		return

	if(H.nutrition > 50 && H.feral == 1) //If they went feral then ate something.
		H.feral = 0
		H << "<span class='primary'>You feel as if you're no longer feral, the feeling of intense hunger having now passed. You're sated. For the time being, at least.</span>"
		H.hallucination = 0 //Remove all their hallucinations.

	else if(H.nutrition < 300 && H.nutrition > 200)
		if(prob(0.5)) //A bit of an issue, not too bad.
			H << "<span class='info'>You feel extremely hungry. It might be a good idea to find some some food...</span>"

	else if(H.nutrition <= 200 && H.nutrition > 100)
		if(prob(0.5)) //Getting closer, should probably eat some food about now...
			H << "<span class='warning'>You feel like you're going to starve and give into your hunger soon... It might would be for the best to find some [pick("food","prey")] to eat...</span>"

	else if(H.nutrition <= 100 && H.nutrition > 50)
		if(prob(1)) //Getting real close here! Eat something!
			H << "<span class='danger'> You feel a sharp jabbing pain in your abdomen. You feel as if you're beginning to become feral, with food being the only thing on your mind. </span>"

	else if(H.nutrition <= 50 && H.feral == 0) //Should've eaten sooner!
		H << "<span class='danger'><big>You suddenly feel a sharp stabbing pain in your stomach. You feel as if you've became completely feral, food the only thing on your mind.</big></span>"
		if(H.stat == CONSCIOUS)
			H.emote("twitch")
		H.feral = 1 //Begin hallucinating

	for(var/mob/living/M in viewers(H))
		if(M != H && H.nutrition <= 50)
			if(prob(0.5))//1 in 200 chance to tell them that person looks like food. This is so irregular so it doesn't pop up 24/7 during ERP.
				H << "<span class='danger'> You feel a stabbing pain in your gut, causing you to twitch in pain.. It would be extremely wise to find some type of food... In fact, [M] looks extremely appetizing...</span>"
				if(H.stat == CONSCIOUS)
					H.emote("twitch")
			if(H.feral == 1) //This should always be the case under 500 nutrition, but just in case.
				H.hallucination -= 25 //Start to stop hallucinating once you see someone.

		else if(M == H && H.nutrition <= 50) //Hungry and nobody is in view.
			if(prob(1)) //Constantly nag them to go and find someone or something to eat.
				H << "<span class='danger'> You feel a sharp jab in your stomach from hunger, causing you to twitch in pain. You need to find something to eat immediately.</span>"
				if(H.stat == CONSCIOUS)
					H.emote("twitch")
			if(H.feral == 1)
				if(H.hallucination < 200) //200 hallucination cap. Let's not be too evil.
					H.hallucination += 5 //Start hallucinating while alone and hungry.

//////////////////////////////////////////////////////////////////////////////////////////
///////////WIP CODE TO MAKE XENOCHIMERAS NOT DIE IN SPACE WHILE REGENNING BELOW///////////
//////////////////////////////////////////////////////////////////////////////////////////

	var/datum/gas_mixture/environment = H.loc.return_air()
	var/pressure2 = environment.return_pressure()
	var/adjusted_pressure2 = H.calculate_affecting_pressure(pressure2)

	if(adjusted_pressure2 <= 20 && H.in_stasis == 1) //If they're in a enviroment with no pressure and are in stasis (See: regenerating), don't kill them.
		//This is just to prevent them from taking damage if they're in stasis.

	else if(adjusted_pressure2 <= 20) //If they're in an enviroment with no pressure and are NOT in stasis, damage them.
		H.take_overall_damage(brute=LOW_PRESSURE_DAMAGE, used_weapon = "Low Pressure")

	if(H.bodytemperature <= 260 && H.in_stasis == 1) //If they're in stasis, don't give them them the negative cold effects
		//This is just here to prevent them from getting cold effects

	else if(H.bodytemperature <= 260) //If they're not in stasis and are cold. Don't really have to add in an exception to cryo cells, as the effects aren't anything /too/ horrible.
		if(H.bodytemperature <= 260 && H.bodytemperature >= 200) //Chilly
			if(H.halloss < 100) //100 halloss cap. Harsh punishment for staying in space, and it'll take them a while to fully thaw out when they get retrieved.
				H.halloss = H.halloss + 1 //This will begin to knock them out over twenty seconds until they run out of oxygen and suffocate or until someone finds them.
			H.eye_blurry = 5 //Blurry vision in the cold.
		if(H.bodytemperature <= 199 && H.bodytemperature >= 100) //Extremely cold.
			if(H.halloss < 100)
				H.halloss = H.halloss + 2
			H.eye_blurry = 5
		if(H.bodytemperature <= 99) //Insanely cold.
			if(H.halloss < 100)
				H.halloss = H.halloss + 5
			H.eye_blurry = 5
		return