// These medical issues are designed to be simple, custom medical issues that can be created on the fly by GMs.
// Designed to be more simple than diseases, they use a separate system.
// They are not designed to replace any existing medical work, just allow GMs to make them up for events

/datum/medical_issue
	var/name = "medical issue"
	var/mob/living/carbon/human/owner		//Who is affected by this issue? Who's it attached to?
	var/advscan = 0 			//The required level of advanced scan to see this issue with health analysers, set to 4 to disable.
	var/showscanner = FALSE 	//Should this issue show up on body scanners?

	var/obj/item/organ/affectedorgan	//Which organ is this attached to?

	var/damagetype				//What sort of damage should this deal to the owner?
	var/damagestrength			//How much damage should this deal over time to the owner?
	var/maxdamage = 300			//What is the maximum amount of damage it can cause?
	var/damageorgan = FALSE		//Should this damage the organ it's attached to or the body in general?

	var/datum/reagent/cure_reagent	//Which reagent cures this issue, if any?
	var/datum/surgery_step/cure_surgery			//Which surgery step can be used to cure this?
	var/unhealth = 100			//The amount of health the issue has, depleted by reagent
	var/reagent_strength = 10	//How much health the reagent will remove per processing
	var/advscan_cure = 0		//What level of advanced scan is required to reveal the cure?

	var/symptom_text			//Messages relayed to the patient about their symptoms
	var/symptom_affect			//Visible effects on the patient such as vomiting or weakness

/datum/medical_issue/proc/handle_effects()
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
	LAZYREMOVE(affectedorgan.medical_issues,src)
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
				owner.vomit(10)
		if("temporary weakness")
			if(prob(5))
				owner.AdjustWeakened(5)
		if("permanent weakness")
			owner.weakened = min(owner.weakened,10)
		if("temporary sleeping")
			if(prob(5))
				owner.AdjustSleeping(5)
		if("permanent sleeping")
			owner.sleeping = min(owner.sleeping,10)
		if("jittery")
			owner.make_jittery(min(owner.jitteriness,10))
		if("paralysed")
			owner.paralysis = min(owner.paralysis,10)


// Proc for setting all this up for GMs

/mob/living/carbon/human/proc/custom_medical_issue(var/mob/user)
	var/issue_name = tgui_input_text(user,"What would you like to call this medical issue?","Name")
	var/list/organ_options = list()
	for(var/obj/item/organ/E in src.organs)
		organ_options |= E
	for(var/obj/item/organ/I in src.internal_organs)
		organ_options |= I
	var/obj/item/organ/issue_organ = tgui_input_list(user,"Which organ should this issue be attached to?","Affect organ",organ_options)
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
		damage_value = tgui_input_number(user,"How much damage should this apply per processing. Low values are recommended.","Damage",0.1)
		damage_max = tgui_input_number(user,"What is the maximum about of damage this issue can apply? It will not damage above this value.","Damage",300)
		if(damage_organ == "Body")
			damage_type = tgui_input_list(user, "Should this damage the organ or body?","Damage",list(BRUTE,BURN,OXY,TOX,CLONE,HALLOSS),BRUTE)
			if(!damage_type)
				return

	var/cure_q = tgui_alert(user, "Should this be cured by a reagent, surgery or organ removal only? Note that organ removal will always be an option if it's not a vital body part.","Cure",list("Reagent","Surgery","Removal","Cancel"))
	if(!cure_q || (cure_q == "Cancel"))
		return
	var/datum/reagent/cure_reagent
	var/cure_surgery
	if(cure_q == "Reagent")
		var/list/chem_list = typesof(/datum/reagent)
		cure_reagent = tgui_input_list(user, "Which reagent should be the cure?", "Cure", chem_list)
		if(!cure_reagent)
			return

	if(cure_q == "Surgery")
		cure_surgery = tgui_input_list(user, "Which surgery step should cure it?", "Cure", list(get_surgery_steps_without_basetypes()))
		if(!cure_surgery)
			return

	var/symptom_text = tgui_input_text(user,"What text should be displayed to the affected patient about their symptoms?","Symptoms")
	var/symptom_affect = tgui_input_list(user, "What observable symptom should they display?", "Symptoms", list("vomit","temporary weakness","permanent weakness","temporary sleeping","permanent sleeping","jittery","paralysed","None"))
	if(!symptom_affect)
		return

	var/scanner_show = tgui_alert(user, "Should this show on body scanners?","Diagnosis",list("Yes","No","Cancel"))
	if(!scanner_show || (scanner_show == "Cancel"))
		return

	var/scanner_strength = tgui_input_number(user,"What level of health analyser is needed to see this? 0 for standard, 1 for improved, 2 for advanced, 3 for phasic and 4 for impossible.","Diagnosis",0)
	var/advscan_cure = tgui_input_number(user, "What level of health analyser is required to display the cure? 0 for standard, 1 for improved, 2 for advanced, 3 for phasic and 4 for impossible.","Diagnosis",0)

	var/datum/medical_issue/M = new()
	LAZYADD(issue_organ.medical_issues,M)
	M.affectedorgan = issue_organ
	M.name = issue_name
	M.owner = src
	M.advscan = scanner_strength
	M.advscan_cure = advscan_cure
	M.showscanner = scanner_show

	if(damage == "Yes")
		if(damage_organ == "Body")
			M.damagetype = damage_type
			M.damageorgan = FALSE
		else
			M.damageorgan = TRUE
		M.damagestrength = damage_value
		M.maxdamage = damage_max

	if(cure_reagent)
		M.cure_reagent = cure_reagent
	if(cure_surgery)
		M.cure_surgery = cure_surgery

	if(symptom_text)
		M.symptom_text = symptom_text
	if(symptom_affect != "None")
		M.symptom_affect = symptom_affect
