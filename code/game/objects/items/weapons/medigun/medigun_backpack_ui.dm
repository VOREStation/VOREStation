/obj/item/medigun_backpack/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Medigun", name)
		ui.open()

/obj/item/medigun_backpack/tgui_data(mob/user)
	var/mob/living/carbon/human/H = medigun.current_target
	var/patientname
	var/patienthealth = 0
	var/patientbruteloss = 0
	var/patientfireloss = 0
	var/patienttoxloss = 0
	var/patientoxyloss = 0
	var/patientstatus = 0
	var/list/bloodData = list()
	var/inner_bleeding = FALSE
	var/organ_damage = FALSE

	//var/minhealth = 0
	if(scapacitor?.get_rating() < 5)
		gridstatus = 3
	if(H)
		for(var/obj/item/organ/org in H.internal_organs)
			if(org.robotic >= ORGAN_ROBOT)
				continue
			if(org.status & ORGAN_BLEEDING)
				inner_bleeding = TRUE
			if(org.damage >= 1 && !istype(org, /obj/item/organ/internal/brain))
				organ_damage = TRUE
		patientname = H
		patienthealth = max(0, (H.health + abs(-H.getMaxHealth())) / (H.getMaxHealth() + abs(-H.getMaxHealth())))
		patientbruteloss = H.getBruteLoss()
		patientfireloss = H.getFireLoss()
		patienttoxloss = H.getToxLoss()
		patientoxyloss = H.getOxyLoss()
		patientstatus = H.stat
		if(H.vessel)
			bloodData["volume"] = round(H.vessel.get_reagent_amount("blood"))
			bloodData["max_volume"] = H.species.blood_volume
	var/list/data = list(
		"maintenance" = maintenance,
		"generator" = charging,
		"gridstatus" = gridstatus,
		"tankmax" = tankmax,
		"power_cell_status" = bcell ? bcell.percent() : null,
		"phoron_status" = sbin ? phoronvol/chemcap : null,
		"bruteheal_charge" = scapacitor ? brutecharge : null,
		"burnheal_charge" = scapacitor ? burncharge : null,
		"toxheal_charge" = scapacitor ? toxcharge : null,
		"bruteheal_vol" = sbin ? brutevol : null,
		"burnheal_vol" = sbin ? burnvol : null,
		"toxheal_vol" = sbin ? toxvol : null,
		"patient_name" = smodule ? patientname : null,
		"patient_health" = smodule ? patienthealth : null,
		"patient_brute" = smodule ? patientbruteloss : null,
		"patient_burn" = smodule ? patientfireloss : null,
		"patient_tox" = smodule ? patienttoxloss : null,
		"patient_oxy" = smodule ? patientoxyloss : null,
		"blood_status" = smodule ? bloodData : null,
		"patient_status" = smodule ? patientstatus : null,
		"organ_damage" = smodule ? organ_damage : null,
		"inner_bleeding" = smodule ? inner_bleeding : null,
		"examine_data" = get_examine_data()
		)
	return data

/obj/item/medigun_backpack/proc/get_examine_data()
	return list(
		"smodule" = smodule ? list("name" = smodule.name, "range" = medigun.beam_range, "rating" = smodule.get_rating()) : null,
		"smanipulator" = smanipulator ? list("name" = smanipulator.name, "rating" = smaniptier) : null,
		"slaser" = slaser ? list("name" = slaser.name, "rating" = slaser.get_rating()) : null,
		"scapacitor" = scapacitor ? list("name" = scapacitor.name, "chargecap" = chargecap, "rating" = scapacitor.get_rating()) : null,
		"sbin" = sbin ? list("name" = sbin.name, "chemcap" = chemcap, "tankmax" = tankmax, "rating" = sbin.get_rating()) : null
	)

/obj/item/medigun_backpack/tgui_act(action, params, datum/tgui/ui)
	if(..())
		return TRUE

	. = TRUE
	switch(action)
		if("gentoggle")
			ui_action_click()
			return TRUE

		if("cancel_healing")
			if(medigun?.busy)
				medigun.busy = MEDIGUN_CANCELLED
				return TRUE

		if("toggle_maintenance")
			maintenance = !maintenance
			reattach_medigun(ui.user)
			return TRUE

		if("rem_smodule")
			if(!smodule || !maintenance)
				return FALSE
			smodule.forceMove(get_turf(loc))
			to_chat(ui.user, span_notice("You remove the [smodule] from \the [src]."))
			smodule = null
			update_icon()
			return TRUE

		if("rem_mani")
			if(!smanipulator || !maintenance)
				return FALSE
			STOP_PROCESSING(SSobj, src)
			smanipulator.forceMove(get_turf(loc))
			to_chat(ui.user, span_notice("You remove the [smanipulator] from \the [src]."))
			smanipulator = null
			smaniptier = 0
			update_icon()
			return TRUE

		if("rem_laser")
			if(!slaser || !maintenance)
				return FALSE
			slaser.forceMove(get_turf(loc))
			to_chat(ui.user, span_notice("You remove the [slaser] from \the [src]."))
			slaser = null
			update_icon()
			return TRUE

		if("rem_cap")
			if(!scapacitor || !maintenance)
				return FALSE
			STOP_PROCESSING(SSobj, src)
			scapacitor.forceMove(get_turf(loc))
			to_chat(ui.user, span_notice("You remove the [scapacitor] from \the [src]."))
			scapacitor = null
			update_icon()
			return TRUE

		if("rem_bin")
			if(!sbin || !maintenance)
				return FALSE
			STOP_PROCESSING(SSobj, src)
			sbin.forceMove(get_turf(loc))
			to_chat(ui.user, span_notice("You remove the [sbin] from \the [src]."))
			sbin = null
			sbintier = 0
			update_icon()
			return TRUE

/obj/item/medigun_backpack/ShiftClick(mob/user)
	. = ..()
	if(!medigun)
		return
	tgui_interact(user)
