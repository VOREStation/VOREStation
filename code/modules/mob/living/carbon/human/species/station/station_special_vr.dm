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


	//primitive_form = "Farwa"

	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED //Whitelisted as restricted is broken.
	flags = NO_SCAN //Dying as a chimera is, quite literally, a death sentence. Well, if it wasn't for their revive, that is.
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#AFA59E"
	base_color 	= "#333333"
	blood_color = "#14AD8B"

/datum/species/chimera/handle_environment_special(var/mob/living/carbon/human/H)
	if(H.stat) // If they're dead or unconcious they won't think about being all feral.
		return
	if(H.absorbed == 1) //If they get nomphed and absorbed.
		return

	if(H.nutrition > 50 && H.species.has_fine_manipulation == 0) //If they went feral then ate something.
		H.species.has_fine_manipulation = 1
		H << "<span class='primary'>You feel as if you're no longer feral, the feeling of intense hunger having now passed. You're sated. For the time being, at least.</span>"
		return

	else if(H.nutrition >= 300)
		return

	else if(H.nutrition < 300 && H.nutrition > 200)
		if(prob(0.5)) //A bit of an issue, not too bad.
			H << "<span class='info'>You feel extremely hungry. It might be a good idea to find some some food...</span>"
			return

	else if(H.nutrition <= 200 && H.nutrition > 100)
		if(prob(0.5)) //Getting closer, should probably eat some food about now...
			H << "<span class='warning'>You feel like you're going to starve and give into your hunger soon... It might would be for the best to find some [pick("food","prey")] to eat...</span>"
			return

	else if(H.nutrition <= 100 && H.nutrition > 50)
		if(prob(1)) //Getting real close here! Eat something!
			H << "<span class='danger'> You feel a sharp jabbing pain in your abdomen. You feel as if you're beginning to become feral, with food being the only thing on your mind. </span>"
			return

	else if(H.nutrition <= 50 && H.species.has_fine_manipulation == 1) //Should've eaten sooner!
		H << "<span class='danger'><big>You suddenly feel a sharp stabbing pain in your stomach. You feel as if you've became completely feral, food the only thing on your mind.</big></span>"
		if(H.stat == CONSCIOUS)
			H.emote("twitch")
		H.species.has_fine_manipulation = 0 //Unable  to use objects.

	for(var/mob/living/M in viewers(H))
		if(M != H)
			if(prob(0.5))//1 in 200 chance to tell them that person looks like food. This is so irregular so it doesn't pop up 24/7 during ERP.
				H << "<span class='danger'> You feel a stabbing pain in your gut, causing you to twitch in pain.. It would be extremely wise to find some type of food... In fact, [M] looks extremely appetizing...</span>"
				if(H.stat == CONSCIOUS)
					H.emote("twitch")
				return

		else if(M == H && H.nutrition <= 50) //Hungry and nobody is in view.
			if(prob(1)) //Constantly nag them to go and find someone or something to eat.
				H << "<span class='danger'> You feel a sharp jab in your stomach from hunger, causing you to twitch in pain. You need to find something to eat immediately.</span>"
				if(H.stat == CONSCIOUS)
					H.emote("twitch")
				return
			return
