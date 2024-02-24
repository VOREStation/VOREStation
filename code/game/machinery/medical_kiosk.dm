#define BROKEN_BONES 0x1
#define INTERNAL_BLEEDING 0x2
#define EXTERNAL_BLEEDING 0x4
#define SERIOUS_EXTERNAL_DAMAGE 0x8
#define SERIOUS_INTERNAL_DAMAGE 0x10
#define RADIATION_DAMAGE 0x20
#define TOXIN_DAMAGE 0x40
#define OXY_DAMAGE 0x80

/obj/machinery/medical_kiosk
	name = "medical kiosk"
	desc = "A helpful kiosk for finding out whatever is wrong with you."
	icon = 'icons/obj/machines/medical_kiosk.dmi'
	icon_state = "kiosk_off"
	idle_power_usage = 5
	active_power_usage = 200
	circuit = /obj/item/weapon/circuitboard/medical_kiosk
	anchored = TRUE
	density = TRUE

	var/mob/living/active_user
	var/db_key
	var/datum/transcore_db/our_db

/obj/machinery/medical_kiosk/Initialize()
	. = ..()
	our_db = SStranscore.db_by_key(db_key)

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
			to_chat(user, "<span class='warning'>\The [src] seems to be nonfunctional...</span>")
		else if(active_user && active_user != user)
			to_chat(user, "<span class='warning'>Another patient has begin using this machine. Please wait for them to finish, or their session to time out.</span>")
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
	user.visible_message("<b>[user]</b> wakes [src].", "You wake [src].")
	var/choice = tgui_alert(user, "What service would you like?", "[src]", list("Health Scan", "Backup Scan", "Cancel"), timeout = 10 SECONDS)
	if(!choice || choice == "Cancel" || !Adjacent(user) || inoperable() || panel_open)
		suspend()
		return
	
	// Service begins, delay
	visible_message("<b>\The [src]</b> scans [user] thoroughly!")
	flick("kiosk_active", src)
	if(!do_after(user, 10 SECONDS, src, exclusive = TASK_ALL_EXCLUSIVE) || inoperable())
		suspend()
		return
	
	// Service completes
	switch(choice)
		if("Health Scan")
			var/health_report = tell_health_info(user)
			to_chat(user, "<span class='notice'><b>Health report results:</b></span>"+health_report)
		if("Backup Scan")
			if(!our_db)
				to_chat(user, "<span class='notice'><b>Backup scan results:</b></span><br>DATABASE ERROR!")
			else
				var/scan_report = do_backup_scan(user)
				to_chat(user, "<span class='notice'><b>Backup scan results:</b></span>"+scan_report)
	
	// Standby
	suspend()

/obj/machinery/medical_kiosk/proc/tell_health_info(mob/living/user)
	if(!istype(user))
		return "<br><span class='warning'>Unable to perform diagnosis on this type of life form.</span>"
	if(user.isSynthetic())
		return "<br><span class='warning'>Unable to perform diagnosis on synthetic life forms.</span>"
	
	var/problems = 0
	for(var/obj/item/organ/external/E in user)
		if(E.status & ORGAN_BROKEN)
			problems |= BROKEN_BONES
		if(E.status & (ORGAN_DEAD|ORGAN_DESTROYED))
			problems |= SERIOUS_EXTERNAL_DAMAGE
		if(E.status & ORGAN_BLEEDING)
			problems |= EXTERNAL_BLEEDING
		for(var/datum/wound/W in E.wounds)
			if(W.bleeding())
				if(W.internal)
					problems |= INTERNAL_BLEEDING
				else
					problems |= EXTERNAL_BLEEDING
	
	for(var/obj/item/organ/internal/I in user)
		if(I.status & (ORGAN_BROKEN|ORGAN_DEAD|ORGAN_DESTROYED))
			problems |= SERIOUS_INTERNAL_DAMAGE
		if(I.status & ORGAN_BLEEDING)
			problems |= INTERNAL_BLEEDING
	
	if(user.getToxLoss() > 0)
		problems |= TOXIN_DAMAGE
	if(user.getOxyLoss() > 0)
		problems |= OXY_DAMAGE
	if(user.radiation > 0)
		problems |= RADIATION_DAMAGE
	if(user.getFireLoss() > 40 || user.getBruteLoss() > 40)
		problems |= SERIOUS_EXTERNAL_DAMAGE
	
	if(!problems)
		if(user.getHalLoss() > 0)
			return "<br><span class='warning'>Mild concussion detected - advising bed rest until patient feels well. No other anatomical issues detected.</span>"
		else
			return "<br><span class='notice'>No anatomical issues detected.</span>"
	
	var/problem_text = ""
	if(problems & BROKEN_BONES)
		problem_text += "<br><span class='warning'>Broken bones detected - see a medical professional and move as little as possible.</span>"
	if(problems & INTERNAL_BLEEDING)
		problem_text += "<br><span class='danger'>Internal bleeding detected - seek medical attention, ASAP!</span>"
	if(problems & EXTERNAL_BLEEDING)
		problem_text += "<br><span class='warning'>External bleeding detected - advising pressure with cloth and bandaging.</span>"
	if(problems & SERIOUS_EXTERNAL_DAMAGE)
		problem_text += "<br><span class='danger'>Severe anatomical damage detected - seek medical attention.</span>"
	if(problems & SERIOUS_INTERNAL_DAMAGE)
		problem_text += "<br><span class='danger'>Severe internal damage detected - seek medical attention.</span>"
	if(problems & RADIATION_DAMAGE)
		problem_text += "<br><span class='danger'>Exposure to ionizing radiation detected - seek medical attention.</span>"
	if(problems & TOXIN_DAMAGE)
		problem_text += "<br><span class='warning'>Exposure to toxic materials detected - induce vomiting if you have consumed anything recently.</span>"
	if(problems & OXY_DAMAGE)
		problem_text += "<br><span class='warning'>Blood/air perfusion level is below acceptable norms - use concentrated oxygen if necessary.</span>"

	return problem_text

/obj/machinery/medical_kiosk/proc/do_backup_scan(mob/living/carbon/human/user)
	if(!istype(user))
		return "<br><span class='warning'>Unable to perform full scan. Please see a medical professional.</span>"
	if(!user.mind)
		return "<br><span class='warning'>Unable to perform full scan. Please see a medical professional.</span>"
	
	var/nif = user.nif
	if(nif)
		persist_nif_data(user)
	
	our_db.m_backup(user.mind,nif,one_time = TRUE)
	var/datum/transhuman/body_record/BR = new()
	BR.init_from_mob(user, TRUE, TRUE, database_key = db_key)

	return "<br><span class='notice'>Backup scan completed!</span><br><b>Note:</b> A backup implant is required for automated notifications to the appropriate department in case of incident."

#undef BROKEN_BONES
#undef INTERNAL_BLEEDING
#undef EXTERNAL_BLEEDING
#undef SERIOUS_EXTERNAL_DAMAGE
#undef SERIOUS_INTERNAL_DAMAGE
#undef RADIATION_DAMAGE
#undef TOXIN_DAMAGE
#undef OXY_DAMAGE