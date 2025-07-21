// These medical issues are designed to be simple, custom medical issues that can be created on the fly by GMs.
// Designed to be more simple than diseases, they use a separate system.
// They are not designed to replace any existing medical work, just allow GMs to make them up for events

/datum/medical_issue
	var/name = "medical issue"
	var/mob/living/carbon/human/owner		//Who is affected by this issue? Who's it attached to?
	var/advscan = 0 			//The required level of advanced scan to see this issue with health analysers, set to 5 to disable.
	var/showscanner = FALSE 	//Should this issue show up on body scanners?

	var/obj/item/organ/affectedorgan	//Which organ is this attached to?

	var/damagetype				//What sort of damage should this deal to the owner?
	var/damagestrength			//How much damage should this deal over time to the owner?
	var/maxdamage = 300			//What is the maximum amount of damage it can cause?
	var/damageorgan = FALSE		//Should this damage the organ it's attached to or the body in general?

	var/datum/reagent/cure_reagent	//Which reagent cures this issue, if any?
	var/cure_surgery			//Which surgery step can be used to cure this?
	var/unhealth = 100			//The amount of health the issue has, depleted by reagent
	var/reagent_strength = 10	//How much health the reagent will remove per processing

	var/symptom_text			//Messages relayed to the patient about their symptoms
	var/symptom_affect			//Visible effects on the patient such as vomiting or weakness

/datum/medical_issue/proc/process()
	if(!owner || !affectedorgan)
		return
	if(!istype(owner) || !istype(affectedorgan))
		return

	if(!(affectedorgan in owner.organs) || !(affectedorgan in owner.internal_organs))
		return

	if(unhealth <= 0)
		cure_issue()

	if(damagestrength)
		handle_damage()

	if(cure_reagent && reagent_strength)
		handle_curing()

	if(symptom_text)
		if(prob(5))
			to_chat(owner, span_danger("[symptom_text]"))

	if(symptom_affect)
		handle_symptoms()

/datum/medical_issue/proc/cure_issue()
	qdel(src)

/datum/medical_issue/proc/handle_damage()
	if(damagestrength)
		if(damageorgan)
			var/maxtotal = max(maxdamage,affectedorgan.damage) //We don't want it to heal damage that's above the max by this
			affectedorgan.damage = max((affectedorgan.damage + damagestrength),maxtotal)
		else
			switch(damagetype)
				if(BRUTE)
					if(maxdamage <= owner.getBruteLoss())
						owner.adjustBruteLoss(damagestrength)
				if(BURN)
					if(maxdamage <= owner.getFireLoss())
						owner.adjustFireLoss(damagestrength)
				if(OXY)
					if(maxdamage <= owner.getOxyLoss())
						owner.adjustFireLoss(damagestrength)
				if(TOX)
					if(maxdamage <= owner.getToxLoss())
						owner.adjustToxLoss(damagestrength)
				if(CLONE)
					if(maxdamage <= owner.getCloneLoss())
						owner.adjustCloneLoss(damagestrength)
				if(HALLOSS)
					if(maxdamage <= owner.getHalLoss())
						owner.adjustHalLoss(damagestrength)

/datum/medical_issue/proc/handle_curing()
	for(var/datum/reagent/R in owner.reagents.reagent_list)
		if(istype(R,cure_reagent))
			unhealth = unhealth - reagent_strength

/datum/medical_issue/proc/handle_symptoms()
	switch(symptom_affect)
		if("vomit")
			if(prob(5))
				owner.vomit
		if("temporary weakness")
			if(prob(5))
				owner.AdjustWeakened(5)
		if("permanent weakness")
			owner.weakened = min(weakened,10)
		if("temporary sleeping")
			if(prob(5))
				owner.AdjustSleeping(5)
		if("permanent sleeping")
			owner.sleeping = min(sleeping,10)
		if("jittery")
			owner.make_jittery(min(jitteriness,10))
		if("paralysed")
			owner.paralysis = min(paralysis,10)


// Proc for setting all this up for GMs

/mob/living/carbon/human/proc/custom_medical_issue(var/mob/user)
	var/issue_name = tgui_input_text(user,"What would you like to call this medical issue?","Name")
	var/list/organ_options = list()
	for(var/obj/item/organ/E in src.organs)
		organ_options |= E
	for(var/obj/item/organ/I in src.internal_organs)
		organ_options |= I
	var/issue_organ = tgui_input_list(user,"Which organ should this issue be attached to?","Affect organ",organ_options)
	if(!issue_organ)
		return

	var/damage = tgui_alert(user, "Should this apply damage?","Damage",list("Yes","No","Canel"))
	if(!damage || (damage == "Cancel"))
		return
	var/damage_organ
	var/damage_value
	var/damage_max
	var/damage_type
	if(damage == "Yes")
		damage_organ = tgui_alert(user, "Should this damage the organ or body?","Damage",list(issue_organ,"Body"))
		if(!damage_organ)
			return
		if(damage_organ == "Body")
			var/
