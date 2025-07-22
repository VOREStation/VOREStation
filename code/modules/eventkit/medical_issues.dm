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

	var/cure_reagent			//Which reagent cures this issue, if any?
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

	if(!(affectedorgan in owner.organs) && !(affectedorgan in owner.internal_organs))
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
					if(maxdamage >= owner.getBruteLoss())
						owner.adjustBruteLoss(damagestrength)
				if(BURN)
					if(maxdamage >= owner.getFireLoss())
						owner.adjustFireLoss(damagestrength)
				if(OXY)
					if(maxdamage >= owner.getOxyLoss())
						owner.adjustFireLoss(damagestrength)
				if(TOX)
					if(maxdamage >= owner.getToxLoss())
						owner.adjustToxLoss(damagestrength)
				if(CLONE)
					if(maxdamage >= owner.getCloneLoss())
						owner.adjustCloneLoss(damagestrength)
				if(HALLOSS)
					if(maxdamage >= owner.getHalLoss())
						owner.adjustHalLoss(damagestrength)

/datum/medical_issue/proc/handle_curing()
	for(var/datum/reagent/R in owner.reagents.reagent_list)
		if(R.name == cure_reagent)
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

	var/list/external_organ_surgeries = list("bone reinforcement","remove growths","redirect blood vessels","extract object","flesh graft")
	var/list/internal_organ_surgeries = list("remove growths","redirect blood vessels","close holes","ultrasound","reoxygenate tissue")

	var/issue_name = tgui_input_text(user,"What would you like to call this medical issue?","Name")
	var/list/organ_options = list()
	for(var/obj/item/organ/E in src.organs)
		organ_options |= E
	for(var/obj/item/organ/I in src.internal_organs)
		organ_options |= I
	var/obj/item/organ/issue_organ = tgui_input_list(user,"Which organ should this issue be attached to?","Affect organ",organ_options)
	if(!issue_organ)
		return

	var/damage = tgui_alert(user, "Should this apply damage?","Damage",list("Yes","No","Cancel"))
	if(!damage || (damage == "Cancel"))
		return
	var/damage_organ
	var/damage_value_pre
	var/damage_value
	var/damage_max
	var/damage_type
	if(damage == "Yes")
		damage_organ = tgui_alert(user, "Should this damage the organ or body?","Damage",list("Organ","Body"))
		if(!damage_organ)
			return
		damage_value_pre = tgui_input_number(user,"How much damage should this apply per processing. Low values are recommended, automatically divided by 10.","Damage",1)
		damage_value = damage_value_pre / 10
		damage_max = tgui_input_number(user,"What is the maximum about of damage this issue can apply? It will not damage above this value.","Damage",300)
		if(damage_organ == "Body")
			damage_type = tgui_input_list(user, "Should this damage the organ or body?","Damage",list(BRUTE,BURN,OXY,TOX,CLONE,HALLOSS),BRUTE)
			if(!damage_type)
				return

	var/cure_q = tgui_alert(user, "Should this be cured by a reagent, surgery or organ removal only? Note that organ removal will always be an option if it's not a vital body part.","Cure",list("Reagent","Surgery","Removal","Cancel"))
	if(!cure_q || (cure_q == "Cancel"))
		return
	var/datum/reagent/cure_reagent
	var/cure_reagent_ID
	var/cure_surgery
	if(cure_q == "Reagent")
		var/list/chem_list = typesof(/datum/reagent)
		cure_reagent = tgui_input_list(user, "Which reagent should be the cure?", "Cure", chem_list)
		if(!cure_reagent)
			return
		cure_reagent_ID = cure_reagent.name

	if(cure_q == "Surgery")
		if(istype(issue_organ,/obj/item/organ/internal))
			cure_surgery = tgui_input_list(user, "Which surgery step should cure it?", "Cure", internal_organ_surgeries)
		else
			cure_surgery = tgui_input_list(user, "Which surgery step should cure it?", "Cure", external_organ_surgeries)
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
		M.cure_reagent = cure_reagent_ID
	if(cure_surgery)
		M.cure_surgery = cure_surgery

	if(symptom_text)
		M.symptom_text = symptom_text
	if(symptom_affect != "None")
		M.symptom_affect = symptom_affect

	to_chat(user,"[issue_name] applied to [issue_organ] inside of [src]!")
	if(damage == "Yes")
		to_chat(user,"[issue_name] will damage the [damage_organ] with a strength of [damage_value], up to a maximum of [damage_max].")
	if(cure_reagent)
		to_chat(user,"[issue_name] can be cured with [cure_reagent_ID].")
	else if(cure_surgery)
		to_chat(user,"[issue_name] can be cured via the [cure_surgery] surgery.")
	else
		to_chat(user,"[issue_name] can only be cured by amputation or removal of \the [issue_organ]!")

/mob/living/carbon/human/proc/clear_medical_issue(var/mob/user)
	var/list/all_issues = list()
	for(var/obj/item/organ/O in contents)
		for(var/datum/medical_issue/MI in O.medical_issues)
			all_issues |= MI
	if(!all_issues.len)
		to_chat(user,"No custom medical issues found in [src]!")
		return
	var/broad = tgui_alert(user, "Would you like to clear all custom medical issues or a specific one?","Damage",list("All","One","Cancel"))
	if(!broad || (broad == "Cancel"))
		return

	if(broad == "All")
		for(var/datum/medical_issue/MI in all_issues)
			MI.cure_issue()
			to_chat(user,"[MI.name] removed from [MI.affectedorgan] in [src].")

	if(broad == "One")
		var/datum/medical_issue/one_issue = tgui_input_list(user, "Which issue would you like to remove?", "Symptoms", all_issues)
		if(!one_issue)
			return
		one_issue.cure_issue()
		to_chat(user,"[one_issue.name] removed from [one_issue.affectedorgan] in [src].")


///////////////////////////////////////////////////////////////
//////////////External Organ Surgeries/////////////////////////
///////////////////////////////////////////////////////////////

/datum/surgery_step/medical_issue

/datum/surgery_step/medical_issue/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_danger("[user]'s hand slips, damaging the bone in [target]'s [affected.name] with \the [tool]!") , \
		span_danger("Your hand slips, damaging the bone in [target]'s [affected.name] with \the [tool]!"))
	user.balloon_alert_visible("slips, damaging the bone.", "your hand slips, damaging the bone")
	affected.createwound(BRUISE, 5)

//Bone-gel
/datum/surgery_step/medical_issue/strengthen_bone
	surgery_name = "Reinforce Bone"
	allowed_tools = list(
		/obj/item/surgical/bonegel = 100
	)

	allowed_procs = list(IS_SCREWDRIVER = 75)

	can_infect = 1
	blood_level = 1

	min_duration = 50
	max_duration = 60

/datum/surgery_step/medical_issue/strengthen_bone/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(coverage_check(user, target, affected, tool))
		return 0
	for(var/datum/medical_issue/MI in affected.medical_issues)
		if(MI.cure_surgery == "bone reinforcement")
			return affected && (affected.robotic < ORGAN_ROBOT) && affected.open >= 2
	return 0

/datum/surgery_step/medical_issue/strengthen_bone/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_notice("[user] is beginning to reinforce the bone in [target]'s [affected.name] in place with \the [tool].") , \
		span_notice("You are beginning to reinforce the bone in [target]'s [affected.name] in place with \the [tool]."))
	user.balloon_alert_visible("begins to reinforce the bone.", "reinforcing the bone.")
	target.custom_pain("The pain in your [affected.name] is going to make you pass out!", 50)
	..()

/datum/surgery_step/medical_issue/strengthen_bone/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	for(var/datum/medical_issue/MI in affected.medical_issues)
		if(MI.cure_surgery == "bone reinforcement")
			user.visible_message(span_notice("[user] reinforces the bone in [target]'s [affected.name] with \the [tool]."), \
			span_notice("You reinforce the bone in [target]'s [affected.name] with \the [tool]."))
			user.balloon_alert_visible("reinforces the bone.", "bone reinforced.")
			MI.cure_issue()

//scalpel
/datum/surgery_step/medical_issue/remove_growth
	surgery_name = "Remove Growth"
	allowed_tools = list(
		/obj/item/surgical/scalpel = 100
	)

	can_infect = 1
	blood_level = 1

	min_duration = 50
	max_duration = 60

/datum/surgery_step/medical_issue/remove_growth/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(coverage_check(user, target, affected, tool))
		return 0
	for(var/datum/medical_issue/MI in affected.medical_issues)
		if(MI.cure_surgery == "remove growths")
			return affected && (affected.robotic < ORGAN_ROBOT) && affected.open >= 2
	return 0

/datum/surgery_step/medical_issue/remove_growth/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_notice("[user] is beginning to remove growths in [target]'s [affected.name] with \the [tool].") , \
		span_notice("You are beginning to remove growths in [target]'s [affected.name] with \the [tool]."))
	user.balloon_alert_visible("begins to remove growths.", "removing growths.")
	target.custom_pain("The pain in your [affected.name] is going to make you pass out!", 50)
	..()

/datum/surgery_step/medical_issue/remove_growth/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	for(var/datum/medical_issue/MI in affected.medical_issues)
		if(MI.cure_surgery == "remove growths")
			user.visible_message(span_notice("[user] removes the growths in [target]'s [affected.name] with \the [tool]."), \
			span_notice("You removes the growths in [target]'s [affected.name] with \the [tool]."))
			user.balloon_alert_visible("removes the growth.", "removed growth.")
			MI.cure_issue()

//fixovein
/datum/surgery_step/medical_issue/redirect_vessels
	surgery_name = "Redirect Blood Vessels"
	allowed_tools = list(
		/obj/item/surgical/FixOVein = 100
	)

	can_infect = 1
	blood_level = 1

	min_duration = 50
	max_duration = 60

/datum/surgery_step/medical_issue/redirect_vessels/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(coverage_check(user, target, affected, tool))
		return 0
	for(var/datum/medical_issue/MI in affected.medical_issues)
		if(MI.cure_surgery == "redirect blood vessels")
			return affected && (affected.robotic < ORGAN_ROBOT) && affected.open >= 2
	return 0

/datum/surgery_step/medical_issue/redirect_vessels/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_notice("[user] is beginning to redirect blood vessels in [target]'s [affected.name] with \the [tool].") , \
		span_notice("You are beginning to redirect blood vessels in [target]'s [affected.name] with \the [tool]."))
	user.balloon_alert_visible("begins to redirect blood vessels.", "redirecting blood vessels.")
	target.custom_pain("The pain in your [affected.name] is going to make you pass out!", 50)
	..()

/datum/surgery_step/medical_issue/redirect_vessels/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	for(var/datum/medical_issue/MI in affected.medical_issues)
		if(MI.cure_surgery == "redirect blood vessels")
			user.visible_message(span_notice("[user] redirected blood vessels in [target]'s [affected.name] with \the [tool]."), \
			span_notice("You redirected blood vessels in [target]'s [affected.name] with \the [tool]."))
			user.balloon_alert_visible("redirected blood vessels.", "redirected blood vessels.")
			MI.cure_issue()

//hemostat
/datum/surgery_step/medical_issue/extract_object
	surgery_name = "Extract Object"
	allowed_tools = list(
		/obj/item/surgical/hemostat = 100
	)

	can_infect = 1
	blood_level = 1

	min_duration = 50
	max_duration = 60

/datum/surgery_step/medical_issue/extract_object/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(coverage_check(user, target, affected, tool))
		return 0
	for(var/datum/medical_issue/MI in affected.medical_issues)
		if(MI.cure_surgery == "extract object")
			return affected && (affected.robotic < ORGAN_ROBOT) && affected.open >= 2
	return 0

/datum/surgery_step/medical_issue/extract_object/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_notice("[user] is beginning to remove objects in [target]'s [affected.name] with \the [tool].") , \
		span_notice("You are beginning to remove objects in [target]'s [affected.name] with \the [tool]."))
	user.balloon_alert_visible("begins to remove objects.", "removing objects.")
	target.custom_pain("The pain in your [affected.name] is going to make you pass out!", 50)
	..()

/datum/surgery_step/medical_issue/extract_object/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	for(var/datum/medical_issue/MI in affected.medical_issues)
		if(MI.cure_surgery == "extract object")
			user.visible_message(span_notice("[user] removes the objects in [target]'s [affected.name] with \the [tool]."), \
			span_notice("You removes the objects in [target]'s [affected.name] with \the [tool]."))
			user.balloon_alert_visible("removes the objects.", "removed objects.")
			MI.cure_issue()

//brute kit
/datum/surgery_step/medical_issue/flesh_graft
	surgery_name = "Graft Flesh"
	allowed_tools = list(
		/obj/item/stack/medical/advanced/bruise_pack = 100
	)

	can_infect = 1
	blood_level = 1

	min_duration = 50
	max_duration = 60

/datum/surgery_step/medical_issue/flesh_graft/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(coverage_check(user, target, affected, tool))
		return 0
	for(var/datum/medical_issue/MI in affected.medical_issues)
		if(MI.cure_surgery == "flesh graft")
			return affected && (affected.robotic < ORGAN_ROBOT) && affected.open >= 2
	return 0

/datum/surgery_step/medical_issue/flesh_graft/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_notice("[user] is beginning to graft flesh in [target]'s [affected.name] with \the [tool].") , \
		span_notice("You are beginning to graft flesh in [target]'s [affected.name] with \the [tool]."))
	user.balloon_alert_visible("begins to graft flesh.", "grafting flesh.")
	target.custom_pain("The pain in your [affected.name] is going to make you pass out!", 50)
	..()

/datum/surgery_step/medical_issue/flesh_graft/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	for(var/datum/medical_issue/MI in affected.medical_issues)
		if(MI.cure_surgery == "flesh graft")
			user.visible_message(span_notice("[user] grafts the flesh in [target]'s [affected.name] with \the [tool]."), \
			span_notice("You grafts the flesh in [target]'s [affected.name] with \the [tool]."))
			user.balloon_alert_visible("grafted flesh.", "grafted flesh.")
			MI.cure_issue()

///////////////////Internal Organs

//scalpel
/datum/surgery_step/medical_issue/remove_growth_internal
	surgery_name = "Remove Growth on Organ"
	allowed_tools = list(
		/obj/item/surgical/scalpel = 100
	)

	can_infect = 1
	blood_level = 1

	min_duration = 50
	max_duration = 60

/datum/surgery_step/medical_issue/remove_growth_internal/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(coverage_check(user, target, affected, tool))
		return 0
	for(var/obj/item/organ/internal/I in affected.internal_organs)
		for(var/datum/medical_issue/MI in I.medical_issues)
			if(MI.cure_surgery == "remove growths")
				return affected && (affected.robotic < ORGAN_ROBOT) && affected.open >= 2
	return 0

/datum/surgery_step/medical_issue/remove_growth_internal/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_notice("[user] is beginning to remove growths in [target]'s [affected.name] with \the [tool].") , \
		span_notice("You are beginning to remove growths in [target]'s [affected.name] with \the [tool]."))
	user.balloon_alert_visible("begins to remove growths.", "removing growths.")
	target.custom_pain("The pain in your [affected.name] is going to make you pass out!", 50)
	..()

/datum/surgery_step/medical_issue/remove_growth_internal/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	for(var/obj/item/organ/internal/I in affected.internal_organs)
		for(var/datum/medical_issue/MI in I.medical_issues)
			if(MI.cure_surgery == "remove growths")
				user.visible_message(span_notice("[user] removes the growths in [target]'s [affected.name] with \the [tool]."), \
				span_notice("You removes the growths in [target]'s [affected.name] with \the [tool]."))
				user.balloon_alert_visible("removes the growth.", "removed growth.")
				MI.cure_issue()

//fixovein
/datum/surgery_step/medical_issue/redirect_vessels_internal
	surgery_name = "Redirect Blood Vessels"
	allowed_tools = list(
		/obj/item/surgical/FixOVein = 100
	)

	can_infect = 1
	blood_level = 1

	min_duration = 50
	max_duration = 60

/datum/surgery_step/medical_issue/redirect_vessels_internal/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(coverage_check(user, target, affected, tool))
		return 0
	for(var/obj/item/organ/internal/I in affected.internal_organs)
		for(var/datum/medical_issue/MI in I.medical_issues)
			if(MI.cure_surgery == "redirect blood vessels")
				return affected && (affected.robotic < ORGAN_ROBOT) && affected.open >= 2
	return 0

/datum/surgery_step/medical_issue/redirect_vessels_internal/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_notice("[user] is beginning to redirect blood vessels in [target]'s [affected.name] with \the [tool].") , \
		span_notice("You are beginning to redirect blood vessels in [target]'s [affected.name] with \the [tool]."))
	user.balloon_alert_visible("begins to redirect blood vessels.", "redirecting blood vessels.")
	target.custom_pain("The pain in your [affected.name] is going to make you pass out!", 50)
	..()

/datum/surgery_step/medical_issue/redirect_vessels_internal/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	for(var/obj/item/organ/internal/I in affected.internal_organs)
		for(var/datum/medical_issue/MI in I.medical_issues)
			if(MI.cure_surgery == "redirect blood vessels")
				user.visible_message(span_notice("[user] redirected blood vessels in [target]'s [affected.name] with \the [tool]."), \
				span_notice("You redirected blood vessels in [target]'s [affected.name] with \the [tool]."))
				user.balloon_alert_visible("redirected blood vessels.", "redirected blood vessels.")
				MI.cure_issue()

//cautery
/datum/surgery_step/medical_issue/close_holes
	surgery_name = "Close Holes"
	allowed_tools = list(
		/obj/item/surgical/cautery = 100
	)

	can_infect = 1
	blood_level = 1

	min_duration = 50
	max_duration = 60

/datum/surgery_step/medical_issue/close_holes/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(coverage_check(user, target, affected, tool))
		return 0
	for(var/obj/item/organ/internal/I in affected.internal_organs)
		for(var/datum/medical_issue/MI in I.medical_issues)
			if(MI.cure_surgery == "close holes")
				return affected && (affected.robotic < ORGAN_ROBOT) && affected.open >= 2
	return 0

/datum/surgery_step/medical_issue/close_holes/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_notice("[user] is beginning to close holes in [target]'s [affected.name] with \the [tool].") , \
		span_notice("You are beginning to close holes in [target]'s [affected.name] with \the [tool]."))
	user.balloon_alert_visible("begins to close holes.", "closing holes.")
	target.custom_pain("The pain in your [affected.name] is going to make you pass out!", 50)
	..()

/datum/surgery_step/medical_issue/close_holes/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	for(var/obj/item/organ/internal/I in affected.internal_organs)
		for(var/datum/medical_issue/MI in I.medical_issues)
			if(MI.cure_surgery == "close holes")
				user.visible_message(span_notice("[user] closed holes in [target]'s [affected.name] with \the [tool]."), \
				span_notice("You closed holes in [target]'s [affected.name] with \the [tool]."))
				user.balloon_alert_visible("closed holes.", "closed holes.")
				MI.cure_issue()

//cautery
/datum/surgery_step/medical_issue/ultrasound
	surgery_name = "Ultrasound"
	allowed_tools = list(
		/obj/item/autopsy_scanner = 100
	)

	can_infect = 1
	blood_level = 1

	min_duration = 50
	max_duration = 60

/datum/surgery_step/medical_issue/ultrasound/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(coverage_check(user, target, affected, tool))
		return 0
	for(var/obj/item/organ/internal/I in affected.internal_organs)
		for(var/datum/medical_issue/MI in I.medical_issues)
			if(MI.cure_surgery == "ultrasound")
				return affected && (affected.robotic < ORGAN_ROBOT) && affected.open >= 2
	return 0

/datum/surgery_step/medical_issue/ultrasound/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_notice("[user] is beginning to break up material using ultrasound in [target]'s [affected.name] with \the [tool].") , \
		span_notice("You are beginning to break up material using ultrasound in [target]'s [affected.name] with \the [tool]."))
	user.balloon_alert_visible("begins to break up material using ultrasound.", "breaking up material using ultrasound.")
	target.custom_pain("The pain in your [affected.name] is going to make you pass out!", 50)
	..()

/datum/surgery_step/medical_issue/ultrasound/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	for(var/obj/item/organ/internal/I in affected.internal_organs)
		for(var/datum/medical_issue/MI in I.medical_issues)
			if(MI.cure_surgery == "ultrasound")
				user.visible_message(span_notice("[user] broke up material with ultrasound in [target]'s [affected.name] with \the [tool]."), \
				span_notice("You broke up material with ultrasound in [target]'s [affected.name] with \the [tool]."))
				user.balloon_alert_visible("broke up material with ultrasound.", "broke up material with ultrasound.")
				MI.cure_issue()

//cautery
/datum/surgery_step/medical_issue/reoxygenate_tissue
	surgery_name = "Reoxygenate Tissue"
	allowed_tools = list(
		/obj/item/surgical/bioregen = 100
	)

	can_infect = 1
	blood_level = 1

	min_duration = 50
	max_duration = 60

/datum/surgery_step/medical_issue/reoxygenate_tissue/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(coverage_check(user, target, affected, tool))
		return 0
	for(var/obj/item/organ/internal/I in affected.internal_organs)
		for(var/datum/medical_issue/MI in I.medical_issues)
			if(MI.cure_surgery == "reoxygenate tissue")
				return affected && (affected.robotic < ORGAN_ROBOT) && affected.open >= 2
	return 0

/datum/surgery_step/medical_issue/reoxygenate_tissue/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_notice("[user] is beginning to reoxygenate tissue in [target]'s [affected.name] with \the [tool].") , \
		span_notice("You are beginning to reoxygenate tissue in [target]'s [affected.name] with \the [tool]."))
	user.balloon_alert_visible("begins to reoxygenate tissue.", "reoxygenating tissue.")
	target.custom_pain("The pain in your [affected.name] is going to make you pass out!", 50)
	..()

/datum/surgery_step/medical_issue/reoxygenate_tissue/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	for(var/obj/item/organ/internal/I in affected.internal_organs)
		for(var/datum/medical_issue/MI in I.medical_issues)
			if(MI.cure_surgery == "reoxygenate tissue")
				user.visible_message(span_notice("[user] reoxygenated tissue in [target]'s [affected.name] with \the [tool]."), \
				span_notice("You reoxygenated tissue in [target]'s [affected.name] with \the [tool]."))
				user.balloon_alert_visible("reoxygenated tissue.", "reoxygenated tissue.")
				MI.cure_issue()
