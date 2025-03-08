#define BROKEN_BONES 0x1
#define INTERNAL_BLEEDING 0x2
#define EXTERNAL_BLEEDING 0x4
#define SERIOUS_EXTERNAL_DAMAGE 0x8
#define SERIOUS_INTERNAL_DAMAGE 0x10
#define ACUTE_RADIATION_DOSE 0x20
#define CHRONIC_RADIATION_DOSE 0x40
#define TOXIN_DAMAGE 0x80
#define OXY_DAMAGE 0x100
#define HUSKED_BODY 0x200
#define INFECTION 0x400
#define VIRUS 0x800
#define INTERNAL_DAMAGE 0x1000
#define CLONE_DAMAGE 0x2000
#define ORGAN_DISLOCATED 0x4000
#define ALCOHOL_POISONING 0x8000
#define BLOODLOSS 0x10000

/obj/machinery/medical_kiosk
	name = "medical kiosk"
	desc = "A helpful kiosk for finding out whatever is wrong with you."
	icon = 'icons/obj/machines/medical_kiosk.dmi'
	icon_state = "kiosk_off"
	idle_power_usage = 5
	bubble_icon = "medical"
	active_power_usage = 200
	circuit = /obj/item/circuitboard/medical_kiosk
	anchored = TRUE
	density = TRUE

	var/mob/living/active_user
	var/db_key
	var/datum/transcore_db/our_db

	//These are the variables that control 'When we were
	var/last_dispensed
	var/dispense_cooldown = 1 MINUTE //If abused, this can be decreased. The machine gives chems and supplies that are easily and readily available, barring tramadol. If someone intentionally breaks their arm to rob the machines of their tramadol to fuel their addiction, that's a gameplay feature.

	/// This determines if the kiosk can dispense or not. Edit the below line to FALSE if you don't want them to do such.
	var/can_dispense = TRUE

/obj/machinery/medical_kiosk/Initialize()
	. = ..()
	our_db = SStranscore.db_by_key(db_key)

/obj/machinery/medical_kiosk/Destroy()
	our_db = null //Remove the reference we have to our DB.
	active_user = null
	. = ..()


/obj/machinery/medical_kiosk/update_icon()
	. = ..()
	if(panel_open)
		icon_state = "kiosk_open" // panel
	else if((stat & (NOPOWER|BROKEN)) || !active_user)
		icon_state = "kiosk_off" // asleep or no power
	else
		icon_state = "kiosk" // waiting for user or to finish processing

/obj/machinery/medical_kiosk/attack_hand(mob/living/user)
	. = ..()
	if(istype(user) && Adjacent(user))
		if(inoperable() || panel_open)
			to_chat(user, span_warning("\The [src] seems to be nonfunctional..."))
		else if(active_user && active_user != user)
			to_chat(user, span_warning("Another patient has begin using this machine. Please wait for them to finish, or their session to time out."))
		else
			start_using(user)

/obj/machinery/medical_kiosk/attackby(obj/item/O, mob/user)
	. = ..()
	if(default_unfasten_wrench(user, O, 40))
		return
	if(default_deconstruction_screwdriver(user, O))
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return

/obj/machinery/medical_kiosk/proc/wake_lock(mob/living/user)
	active_user = user
	update_icon()
	update_use_power(USE_POWER_ACTIVE)

/obj/machinery/medical_kiosk/proc/suspend()
	active_user = null
	update_icon()
	update_use_power(USE_POWER_IDLE)

/obj/machinery/medical_kiosk/proc/start_using(mob/living/user)
	// Out of standby
	wake_lock(user)

	// User requests service
	user.visible_message(span_bold("[user]") + " wakes [src].", "You wake [src].")
	var/choice = tgui_alert(user, "What service would you like?", "[src]", list("Health Scan", "Backup Scan", "Cancel"), timeout = 10 SECONDS)
	if(!choice || choice == "Cancel" || !Adjacent(user) || inoperable() || panel_open)
		suspend()
		return

	// Service begins, delay
	visible_message(span_bold("\The [src]") + " scans [user] thoroughly!")
	flick("kiosk_active", src)
	if(!do_after(user, 5 SECONDS, src, exclusive = TASK_ALL_EXCLUSIVE) || inoperable())
		suspend()
		return

	// Service completes
	switch(choice)
		if("Health Scan")
			var/health_report = medical_scan(user)
			to_chat(user, span_boldnotice("Health report results:")+health_report)
		if("Backup Scan")
			if(!our_db)
				to_chat(user, span_notice(span_bold("Backup scan results:")) + "<br>DATABASE ERROR!")
			else
				var/scan_report = do_backup_scan(user)
				to_chat(user, span_notice(span_bold("Backup scan results:"))+scan_report)

	// Standby
	suspend()

/obj/machinery/medical_kiosk/proc/medical_scan(mob/living/user)
	if(!istype(user))
		return "<br>" + span_warning("Unable to perform diagnosis on this type of life form.")
	if(user.isSynthetic())
		return "<br>" + span_warning("Unable to perform diagnosis on synthetic life forms.")

	var/problems = 0
	for(var/obj/item/organ/external/E in user)
		if(E.status & ORGAN_BROKEN)
			problems |= BROKEN_BONES
		if(E.status & (ORGAN_DEAD|ORGAN_DESTROYED))
			problems |= SERIOUS_EXTERNAL_DAMAGE
		if(E.status & ORGAN_BLEEDING)
			problems |= EXTERNAL_BLEEDING
		if(E.dislocated == 1)
			problems |= ORGAN_DISLOCATED
		for(var/datum/wound/W in E.wounds)
			if(W.internal) //Internal wounds don't get pinged as 'bleeding' when bleeding() is checked.
				problems |= INTERNAL_BLEEDING
			else if(W.bleeding())
				problems |= EXTERNAL_BLEEDING
		if(E.germ_level >= INFECTION_LEVEL_ONE) //Do NOT check for the germ_level on the mob, it'll be innacurate.
			problems |= INFECTION

	for(var/obj/item/organ/internal/I in user)
		if(I.status & (ORGAN_BROKEN|ORGAN_DEAD|ORGAN_DESTROYED))
			problems |= SERIOUS_INTERNAL_DAMAGE
		if(I.status & ORGAN_BLEEDING)
			problems |= INTERNAL_BLEEDING
		if(I.germ_level >= INFECTION_LEVEL_ONE) //Do NOT check for the germ_level on the mob, it'll be innacurate.
			problems |= INFECTION
		if(I.damage)
			problems |= INTERNAL_DAMAGE

	if(HUSK in user.mutations)
		problems |= HUSKED_BODY

	if(user.getToxLoss() > 0)
		problems |= TOXIN_DAMAGE
	if(user.getOxyLoss() > 0)
		problems |= OXY_DAMAGE
	if(user.radiation > 0)
		problems |= ACUTE_RADIATION_DOSE
	if(user.accumulated_rads > 0)
		problems |= CHRONIC_RADIATION_DOSE
	if(user.getFireLoss() > 40 || user.getBruteLoss() > 40)
		problems |= SERIOUS_EXTERNAL_DAMAGE
	if(user.getCloneLoss())
		problems |= CLONE_DAMAGE

	var/is_drunk = FALSE //Just so we don't have to do another ishuman() check down there in !problems
	if(ishuman(user))
		var/mob/living/carbon/human/our_user = user
		if(our_user.has_virus())
			problems |= VIRUS
		if(our_user.chem_effects[CE_ALCOHOL_TOXIC])
			problems |= ALCOHOL_POISONING
		if(our_user.chem_effects[CE_ALCOHOL])
			is_drunk = TRUE
		if(our_user.vessel.total_volume < our_user.vessel.maximum_volume) //Bloodloss
			problems |= BLOODLOSS

	if(!problems) //Minor stuff that we really don't care much about, but can be annoying! So let's tell people how to fix it. But only if they don't  have a health crisis going on!
		var/minor_problems = ""
		if(user.hallucination)
			minor_problems += "<br>" + span_warning("Brain activity suggesting severe mental inhibitions detected - medical assistance recommended.")
		if(user.drowsyness || user.dizziness || user.sleeping)
			minor_problems += "<br>" + span_warning("Mild mental inhibitions detected - drinking coffee can improve symptoms and stimulate nervous system.")
		if(is_drunk)
			minor_problems += "<br>" + span_warning("Ethanol intoxication detected - suggest close observation to alleviate risk of injury.")
		if(user.getHalLoss() > 0)
			minor_problems += "<br>" + span_warning("Mild concussion detected - advising bed rest until feeling better. No other anatomical issues detected.")
		else
			minor_problems += "<br>" + span_notice("No anatomical issues detected.")
			return minor_problems

	var/problem_text = ""

	//Dispensing vars! This ensures you don't get FLOODED with too many things and accidentally OD becuase the machine gave it to you!
	var/able_to_dispense = TRUE

	/// This determines if the kiosk has already selected one of the chems to dispense. This prevents ODs. Swap these to TRUE if you want to disable kiosks from giving out speicfic chems.
	var/paracetamol_given = FALSE
	var/tramadol_given = FALSE
	var/inaprovaline_given = FALSE
	var/medication_dispensed = FALSE




	if(!can_dispense || (world.time < last_dispensed + dispense_cooldown))
		able_to_dispense = FALSE

	//Let's do this list from 'most severe' to 'least severe'

	if(problems & INTERNAL_BLEEDING) //Will kill you quick and you NEED medical treatment.
		problem_text += "<br>" + span_bolddanger("SEVERITY: 'LETHAL' - Internal bleeding detected - seek medical attention immediately!")
		if(able_to_dispense)
			medication_dispensed = TRUE
			new /obj/item/reagent_containers/pill/small_blood_restoration(src.loc)
	//If you aren't able to use iron...Well, sorry!

	if(problems & INFECTION) //Will kill you quick and you NEED medical treatment.
		problem_text += "<br>" + span_bolddanger("SEVERITY: 'LETHAL' - Infection detected - see a medical professional immediately!")
	//Nothin. Get to medical! Technically COULD give spaceacillin, but this is only meant to help you get TO medical, not REPLACE medical.

	if(problems & EXTERNAL_BLEEDING)
		problem_text += "<br>" + span_warning("SEVERITY: 'SEVERE' - External bleeding detected - advising pressure with cloth and bandaging or direct pressure until medical staff can assist.")
		if(able_to_dispense)
			medication_dispensed = TRUE
			var/obj/item/stack/medical/bruise_pack/BP = new /obj/item/stack/medical/bruise_pack(src.loc)
			BP.amount = 1
			BP.max_amount = 1

	if(problems & SERIOUS_EXTERNAL_DAMAGE)
		problem_text += "<br>" + span_danger("SEVERITY: 'SEVERE' - Severe external damage detected - seek medical attention immediately!")
		if(able_to_dispense)
			medication_dispensed = TRUE
			var/obj/item/stack/medical/bruise_pack/BP = new /obj/item/stack/medical/bruise_pack(src.loc)
			BP.amount = 1
			BP.max_amount = 1
			var/obj/item/stack/medical/ointment/ointment = new /obj/item/stack/medical/ointment(src.loc)
			ointment.amount = 1
			ointment.max_amount = 1
			if(!paracetamol_given)
				new /obj/item/reagent_containers/pill/small_paracetamol(src.loc)
				paracetamol_given = TRUE

	if(problems & ALCOHOL_POISONING)
		problem_text += "<br>" + span_danger("SEVERITY: 'SEVERE' - Severe alcohol poisoning detected - seek medical attention immediately!")
	//We could be nice and give a pill of ethylredoxrazine, but remember, this is meant to stabilize until they get medical attention, not fix them!
	//And given that alcohol poisoning will ALWAYS cause liver damage, it means the internal damage below this will /always/ proc. So we put it above it!

	if(problems & SERIOUS_INTERNAL_DAMAGE)
		problem_text += "<br>" + span_danger("SEVERITY: 'SEVERE' - Severe internal damage detected - seek medical attention immediately!")
		if(able_to_dispense && !paracetamol_given)
			medication_dispensed = TRUE
			new /obj/item/reagent_containers/pill/small_paracetamol(src.loc)
	else if(problems & INTERNAL_DAMAGE) //This isn't TOO major. All internal damage (as long as it's not severe, which would trigger 'SERIOUS_INTERNAL_DAMAGE') is survivable and not lethal, but is annoying. (ex: Lung damage causing you to constantly cough up blood)
		problem_text += "<br>" + span_warning("SEVERITY: 'MODERATE' - Internal damage detected - seek out medical attention at soonest convinence, or urgently if severe symptoms are occurring.")

	if(problems & BROKEN_BONES)
		problem_text += "<br>" + span_warning("SEVERITY: 'MODERATE' - Broken bones detected - see a medical professional and move as little as possible.")
		if(able_to_dispense && !tramadol_given)
			medication_dispensed = TRUE
			new /obj/item/reagent_containers/pill/small_tramadol(src.loc)
			tramadol_given = TRUE

	if(problems & BLOODLOSS)
		problem_text += "<br>" + span_warning("SEVERITY: 'MODERATE' - Indeterminate amount of blood loss detected. If symptoms are severe, please seek medical attention.")
		if(able_to_dispense)
			medication_dispensed = TRUE
			new /obj/item/reagent_containers/pill/small_blood_restoration(src.loc)

	if(problems & VIRUS)
		problem_text += "<br>" + span_boldwarning("SEVERITY: 'VARIES' - Viral illness detected - seek out medical attention and quarantine from others!")
	//Nothin. Get to medical! Technically COULD give spaceacillin, but this is only meant to help you get TO medical, not REPLACE medical.

	if(problems & ACUTE_RADIATION_DOSE)
		problem_text += "<br>" + span_boldwarning("SEVERITY: 'VARIES' - Acute exposure to ionizing radiation detected - seek medical attention.")
		if(able_to_dispense)
			medication_dispensed = TRUE
			new /obj/item/reagent_containers/pill/small_prussian_blue(src.loc)
	else if(problems & CHRONIC_RADIATION_DOSE) //We don't care about telling them about chronic rads if they have acute rads!
		problem_text += "<br>" + span_warning("SEVERITY: 'LOW' - Chronic Exposure to ionizing radiation detected - medical attention is advised.")
	//Nothing. It's acute. Sorry!

	if(problems & CLONE_DAMAGE)
		problem_text += "<br>" + span_warning("SEVERITY: 'LOW' - Exposure to genetic damage detected - medical treatment recommended.")
	//Nothing!
	if(problems & TOXIN_DAMAGE)
		problem_text += "<br>" + span_warning("SEVERITY: 'LOW' - Exposure to toxic materials detected - if severe, seek medical attention. If mild, drinking tea is suggested.") //Let people know about the secret 'drink tea to decrease toxins' technique.
		if(able_to_dispense)
			medication_dispensed = TRUE
			new /obj/item/reagent_containers/pill/small_dylovene(src.loc)
	if(problems & OXY_DAMAGE) //Honestly this will never happen. And if it is, you are probably going to get KO'd before this finishes.
		problem_text += "<br>" + span_warning("SEVERITY: 'LOW' - Blood/air perfusion level is below acceptable norms - use concentrated oxygen if necessary.")
		if(able_to_dispense & !inaprovaline_given)
			medication_dispensed = TRUE
			new /obj/item/reagent_containers/pill/small_inaprovaline(src.loc)
			inaprovaline_given = TRUE
	if(problems & HUSKED_BODY)
		problem_text += "<br>" + span_danger("SEVERITY: 'Minor' - Anatomical structure lost, resuscitation not possible!") //Only borers will ever see this.
	//thoughts and prayers
	if(problems & ORGAN_DISLOCATED)
		problem_text += "<br>" + span_warning("SEVERITY: 'Minor' - Limb dislocation detected. Relocating limb recommended.")
		if(able_to_dispense && !paracetamol_given)
			medication_dispensed = TRUE
			new /obj/item/reagent_containers/pill/small_paracetamol(src.loc)

	if(medication_dispensed) //We found something and can dispense meds!
		last_dispensed = world.time
		problem_text += "<br>" + span_cyan("Condition has been analyzed and supplies have been dispensed. Please take any dispensed items to help stabilize your condition until medical personnel can see you!")

	return problem_text

/obj/machinery/medical_kiosk/proc/do_backup_scan(mob/living/carbon/human/user)
	if(!istype(user))
		return "<br>" + span_warning("Unable to perform full scan. Please see a medical professional.")
	if(!user.mind)
		return "<br>" + span_warning("Unable to perform full scan. Please see a medical professional.")

	var/nif = user.nif
	if(nif)
		persist_nif_data(user)

	our_db.m_backup(user.mind,nif,one_time = TRUE)
	var/datum/transhuman/body_record/BR = new()
	BR.init_from_mob(user, TRUE, TRUE, database_key = db_key)

	return "<br>" + span_notice("Backup scan completed!") + "<br>" + span_bold("Note:") + " A backup implant is required for automated notifications to the appropriate department in case of incident."

#undef BROKEN_BONES
#undef INTERNAL_BLEEDING
#undef EXTERNAL_BLEEDING
#undef SERIOUS_EXTERNAL_DAMAGE
#undef SERIOUS_INTERNAL_DAMAGE
#undef ACUTE_RADIATION_DOSE
#undef CHRONIC_RADIATION_DOSE
#undef TOXIN_DAMAGE
#undef OXY_DAMAGE
#undef HUSKED_BODY
#undef INFECTION
#undef VIRUS
#undef INTERNAL_DAMAGE
#undef CLONE_DAMAGE
#undef ORGAN_DISLOCATED
#undef ALCOHOL_POISONING
#undef BLOODLOSS
