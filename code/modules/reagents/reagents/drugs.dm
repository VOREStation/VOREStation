/*
/// Recreational and psychiatric drugs go here! Please keep them separated in the file.
/// Due to concerns and safety for our repo, illegal real-world drug names should generally be avoided.
*/

/datum/reagent/drugs
	name = "generic drugs"
	id = "drugs"
	description = "Some generic drugs."
	taste_description = "a bad investment"
	taste_mult = 1.2 /// The overwhelming flavor of a good(?) time!
	color = "#f2f2f2"
	var/high_messages = TRUE
	var/list/high_message_list = list("You feel great! For now...", "You feel a wave of happiness!")
	var/list/sober_message_list = list("You feel like garbage...", "Your head aches.")
	data = 0

	var/prob_proc = FALSE /// ANY probabilities in specific drugs should check for this to be TRUE + the desired probability AND set this back to false.

	reagent_state = LIQUID
	metabolism = REM * 0.5
	ingest_met = REM * 1.5 /// Be very careful with this, ingestion is weird and will spam high/sober messages horribly!
	mrate_static = TRUE
	overdose = REAGENTS_OVERDOSE

/datum/reagent/drugs/affect_blood(mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return

	if(high_messages == TRUE)
		if(world.time > data + 90 SECONDS && volume > 0.5) /// Spam prevention.
			data = world.time
			var/msg = pick(high_message_list)
			to_chat(M, "<span class='warning'>[msg]</span>")
		else if(volume <= 0.2 && data != -1)
			data = -1
			var/msg = pick(sober_message_list)
			to_chat(M, "<span class='warning'>[msg]</span>")
	if(prob(5) && prob_proc == FALSE) /// Enables procs to activate, remains true until THAT PROC sets it to false again.
		prob_proc = TRUE

/datum/reagent/drugs/bliss /// Replaces Space Drugs.
	name = "Bliss"
	id = "bliss"
	description = "Known for providing a euphoric high, this psychoactive drug is often used recreationally."
	taste_description = "unpleasant bitterness"
	taste_mult = 0.4
	high_message_list = list("You don't quite know what up or down is anymore...",
	"Colors just seem much more amazing.",
	"You feel incredibly confident. No one can stop you.",
	"You clench your jaw involuntarily.",
	"You feel... unsteady.",
	"You really feel like talking about your feelings!")
	sober_message_list = list("Everything feels a little more grounded.",
	"Colors seem... flatter.",
	"Everything feels a little dull, now.")

/datum/reagent/drugs/bliss/affect_blood(mob/living/carbon/M, var/alien, var/removed)
	..()
	var/drug_strength = 15
	if(alien == IS_SKRELL)
		drug_strength = drug_strength * 0.8
	if(alien == IS_SLIME)
		drug_strength = drug_strength * 1.2

	M.druggy = max(M.druggy, drug_strength)
	if(prob_proc == TRUE && prob(10) && isturf(M.loc) && !istype(M.loc, /turf/space) && M.canmove && !M.restrained())
		step(M, pick(cardinal))
		prob_proc = FALSE
	if(prob_proc == TRUE && prob(7))
		M.emote(pick("twitch", "drool", "moan", "giggle"))
		prob_proc = FALSE

/datum/reagent/drugs/bliss/overdose(var/mob/living/M as mob)
	if(prob_proc == TRUE && prob(20))
		M.hallucination = max(M.hallucination, 5)
		prob_proc = FALSE
	M.adjustBrainLoss(0.25*REM)
	M.adjustToxLoss(0.25*REM)
	..()

/datum/reagent/drugs/ambrosia_extract
	name = "Ambrosia extract"
	id = "ambrosia_extract"
	description = "The extract from the plant family ambrosia, responsible for the more \"recreational\" effects."
	taste_description = "a strong-tasting plant"
	color = "#358f49"
	high_message_list = list("You feel so much more relaxed.",
	"You can't quite focus on anything.",
	"Colors around you seem much more intense.",
	"You could snack on something right now...",
	"You feel lightheaded and giggly.",
	"Everything seems so hilarious.",
	"You really could go for some takeout right now.",
	"You momentarily forget where you are.",
	"You have a mild urge to look over your shoulder.")
	sober_message_list = list("You feel the urge to just sit there and do nothing.",
	"Reality seems like a real pain in the ass to deal with right now.",
	"Things feel really colourless to you all of a sudden.",
	"You feel the urge to lie down and nap.")

/datum/reagent/drugs/ambrosia_extract/affect_blood(mob/living/carbon/M, var/alien, var/removed)
	..()
	var/drug_strength = 3
	if(alien == IS_SKRELL)
		drug_strength = drug_strength * 0.8
	if(alien == IS_SLIME)
		drug_strength = drug_strength * 1.2

	M.adjustToxLoss(-2)
	M.druggy = max(M.druggy, drug_strength)
	M.heal_organ_damage(6)
	M.adjustOxyLoss(-3)
	M.AdjustStunned(-1)
	if(prob(5) && prob_proc == TRUE)
		M.emote("giggle")
		prob_proc = FALSE
	if(prob(10) && prob_proc == TRUE)
		M.adjust_nutrition(-10)
		prob_proc = FALSE

/datum/reagent/drugs/psilocybin
	name = "Psilocybin"
	id = "psilocybin"
	description = "A strong psycotropic derived from certain species of mushroom."
	taste_description = "mushroom"
	color = "#E700E7"
	high_message_list = list("The world distorts around you...!",
	"The walls look like they're moving...",
	"Nothing really makes sense right now.",
	"It feels like you've melded with the world around you...")
	sober_message_list = list("Everything feels... flat.", "You feel almost TOO grounded in your surroundings.")

/datum/reagent/drugs/psilocybin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()

	var/threshold = 1 * M.species.chem_strength_tox
	if(alien == IS_SKRELL)
		threshold = 1.2

	if(alien == IS_SLIME)
		threshold = 0.8

	M.druggy = max(M.druggy, 30)

	var/drug_strength = 20
	var/effective_dose = dose
	if(issmall(M)) effective_dose *= 2
	if(effective_dose < 1 * threshold)
		M.apply_effect(3, STUTTER)
		M.make_dizzy(5)
		if(prob(3) && prob_proc == TRUE)
			M.emote(pick("twitch", "giggle"))
			prob_proc = FALSE
	else if(effective_dose < 2 * threshold)
		M.apply_effect(3, STUTTER)
		M.make_jittery(5)
		M.make_dizzy(5)
		M.druggy = max(M.druggy, 35)
		M.hallucination = max(M.hallucination, drug_strength * threshold)
		if(prob(5) && prob_proc == TRUE)
			M.emote(pick("twitch", "giggle"))
			prob_proc = FALSE
	else
		M.apply_effect(3, STUTTER)
		M.make_jittery(10)
		M.make_dizzy(10)
		M.druggy = max(M.druggy, 40)
		M.hallucination = max(M.hallucination, drug_strength * threshold)
		if(prob(10) && prob_proc == TRUE)
			M.emote(pick("twitch", "giggle"))
			prob_proc = FALSE

/datum/reagent/drugs/talum_quem
	name = "Talum-quem"
	id = "talum_quem"
	description = " A very carefully tailored hallucinogen, for use of the Talum-Katish."
	taste_description = "bubblegum"
	taste_mult = 1.6
	color = "#db2ed8"
	high_message_list = list("The world distorts around you...!",
	"The walls look like they're moving...",
	"Nothing really makes sense right now.",
	"It feels like you've melded with the world around you...")
	sober_message_list = list("Everything feels... flat.", "You feel almost TOO grounded in your surroundings.")

/datum/reagent/drugs/talum_quem/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()

	var/drug_strength = 29 * M.species.chem_strength_tox
	if(alien == IS_SKRELL)
		drug_strength = drug_strength * 0.8
	else
		M.adjustToxLoss(10 * removed) //Given incorporations of other toxins with similiar damage, this seems right.

	M.druggy = max(M.druggy, drug_strength)
	if(prob(10) && prob_proc == TRUE && isturf(M.loc) && !istype(M.loc, /turf/space) && M.canmove && !M.restrained())
		step(M, pick(cardinal))
		prob_proc = FALSE
	if(prob(7) && prob_proc == TRUE)
		M.emote(pick("twitch", "drool", "moan", "giggle"))
		prob_proc = FALSE

/datum/reagent/drugs/nicotine
	name = "Nicotine"
	id = "nicotine"
	description = "A highly addictive stimulant extracted from the tobacco plant."
	taste_description = "sour staleness"
	color = "#181818"
	high_messages = FALSE

/*///////////////////////////////////////////////////////////////////////////
///						PSYCHIATRIC DRUGS								/////
///																		/////
/// Psychiatric drugs use similar mechanics and will go under "drugs".  /////
*////////////////////////////////////////////////////////////////////////////
/datum/reagent/drugs/methylphenidate
	name = "Methylphenidate"
	id = "methylphenidate"
	description = "Improves the ability to concentrate."
	taste_description = "mild grape" ///Referencing real life oral solutions for these meds.
	color = "#BF80BF"
	high_message_list = list("You feel focused.", "Your attention is undivided.")
	sober_message_list = list("It becomes harder to focus...", "You feel distractible.")

/datum/reagent/drugs/citalopram
	name = "Citalopram"
	id = "citalopram"
	description = "Stabilizes the mind a little."
	taste_description = "mild peppermint"
	color = "#FF80FF"
	high_message_list = list("Everything feels a bit more steady.", "Your mind feels stable.")
	sober_message_list = list("You feel a little tired.", "You feel a little more listless...")

/datum/reagent/drugs/paroxetine
	name = "Paroxetine"
	id = "paroxetine"
	description = "Stabilizes the mind greatly, but has a chance of adverse effects."
	taste_description = "mild oranges"
	color = "#FF80BF"
	high_message_list = list("Everything feels good, stable.", "You feel grounded.")
	sober_message_list = list("The stability is gone...", "Everything is much less stable.")

/datum/reagent/drugs/paroxetine/affect_blood(mob/living/carbon/M, var/alien, var/removed)
	..()
	if(prob(5) && prob_proc == TRUE)
		to_chat(M, "<span class='warning'>Everything feels out of control...</span>")
		M.hallucination += 200
		prob_proc = FALSE

/datum/reagent/drugs/qerr_quem
	name = "Qerr-quem"
	id = "qerr_quem"
	description = "A potent sedative and anti-anxiety medication, made for the Qerr-Katish."
	taste_description = "mint"
	color = "#e6efe3"
	high_message_list = list("You feel sluggish...", "You feel calm and collected.")
	sober_message_list = list("You feel so much more antsy...", "Your concentration wavers.")
