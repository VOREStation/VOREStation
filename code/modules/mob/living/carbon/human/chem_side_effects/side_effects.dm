// HEADACHE
// ========
/datum/decl/medical_effect/headache
	name = "Headache"
	triggers = list(REAGENT_ID_CRYOXADONE = 10, REAGENT_ID_BICARIDINE = 15, REAGENT_ID_TRICORDRAZINE = 15)
	cures = list(REAGENT_ID_ALKYSINE, REAGENT_ID_TRAMADOL, REAGENT_ID_PARACETAMOL, REAGENT_ID_OXYCODONE)
	cure_message = "Your head stops throbbing..."

/datum/decl/medical_effect/headache/on_life(mob/living/carbon/human/H, strength)
	switch(strength)
		if(1 to 10)
			H.custom_pain("You feel a light pain in your head.",0)
		if(11 to 30)
			H.custom_pain("You feel a throbbing pain in your head!",1)
		if(31 to INFINITY)
			H.custom_pain("You feel an excrutiating pain in your head!",1)

// BAD STOMACH
// ===========
/datum/decl/medical_effect/bad_stomach
	name = "Bad Stomach"
	triggers = list(REAGENT_ID_KELOTANE = 30, REAGENT_ID_DERMALINE = 15)
	cures = list(REAGENT_ID_ANTITOXIN)
	cure_message = "Your stomach feels a little better now..."

/datum/decl/medical_effect/bad_stomach/on_life(mob/living/carbon/human/H, strength)
	switch(strength)
		if(1 to 10)
			H.custom_pain("You feel a bit light around the stomach.",0)
		if(11 to 30)
			H.custom_pain("Your stomach hurts.",0)
		if(31 to INFINITY)
			H.custom_pain("You feel sick.",1)

// CRAMPS
// ======
/datum/decl/medical_effect/cramps
	name = "Cramps"
	triggers = list(REAGENT_ID_ANTITOXIN = 30, REAGENT_ID_TRAMADOL = 15)
	cures = list(REAGENT_ID_INAPROVALINE)
	cure_message = "The cramps let up..."

/datum/decl/medical_effect/cramps/on_life(mob/living/carbon/human/H, strength)
	switch(strength)
		if(1 to 10)
			H.custom_pain("The muscles in your body hurt a little.",0)
		if(11 to 30)
			H.custom_pain("The muscles in your body cramp up painfully.",0)
		if(31 to INFINITY)
			H.automatic_custom_emote(VISIBLE_MESSAGE, "flinches as all the muscles in their body cramp up.", check_stat = TRUE)
			H.custom_pain("There's pain all over your body.",1)

// ITCH
// ====
/datum/decl/medical_effect/itch
	name = "Itch"
	triggers = list(REAGENT_ID_BLISS = 10)
	cures = list(REAGENT_ID_INAPROVALINE)
	cure_message = "The itching stops..."

/datum/decl/medical_effect/itch/on_life(mob/living/carbon/human/H, strength)
	switch(strength)
		if(1 to 10)
			H.custom_pain("You feel a slight itch.",0)
		if(11 to 30)
			H.custom_pain("You want to scratch your itch badly.",0)
		if(31 to INFINITY)
			H.automatic_custom_emote(VISIBLE_MESSAGE, "shivers slightly.", check_stat = TRUE)
			H.custom_pain("This itch makes it really hard to concentrate.",1)
