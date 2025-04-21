/obj/machinery/computer/pandemic
	name = "PanD.E.M.I.C 2200"
	desc = "Used to work with viruses."
	circuit = /obj/item/circuitboard/pandemic
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/pandemic.dmi'
	icon_state = "pandemic0"
	idle_power_usage = 20
	use_power = TRUE

	var/temp_html = ""
	var/printing = FALSE
	var/wait = FALSE
	var/obj/item/reagent_containers/beaker = null

// PanDEMIC Vial
/obj/item/reagent_containers/glass/beaker/vial/vaccine
	possible_transfer_amounts = (list(5, 10, 15))
	volume = 15

/obj/machinery/computer/pandemic/Initialize(mapload)
	. = ..()
	update_icon()

/obj/machinery/computer/pandemic/set_broken()
	stat |= BROKEN
	update_icon()

/obj/machinery/computer/pandemic/update_icon()
	if(stat & BROKEN)
		icon_state = (beaker ? "pandemic1_b" : "pandemic0_b")
		return
	icon_state = "pandemic[(beaker)?"1":"0"][!(stat & NOPOWER) ? "" : "_nopower"]"

/obj/machinery/computer/pandemic/tgui_act(action, params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return
	if(inoperable())
		return

	switch(action)
		if("create_culture_bottle")
			if(wait)
				return FALSE
			create_culture_bottle(params["index"])
			return TRUE
		if("create_vaccine_bottle")
			if(wait)
				atom_say("The replicator is not ready yet.")
				return FALSE
			create_vaccine_bottle(params["index"])
			return TRUE
		if("eject_beaker")
			eject_beaker()
			update_tgui_static_data(ui.user)
			return TRUE
		if("destroy_eject_beaker")
			beaker.reagents.clear_reagents()
			eject_beaker()
			update_tgui_static_data(ui.user)
			return TRUE
		if("empty_beaker")
			beaker.reagents.clear_reagents()
			return TRUE
		if("rename_disease")
			rename_disease(params["index"], params["name"])
			return TRUE
		if("print_release_form")
			var/strain_index = text2num(params["index"])
			if(isnull(strain_index))
				atom_say("Unable to respond to command.")
				return FALSE
			var/type = get_virus_id_by_index(strain_index)
			if(!type)
				atom_say("Unable to find requested strain.")
				return FALSE
			var/datum/disease/advance/A = GLOB.archive_diseases[type]
			if(!A)
				atom_say("Unable to find requested strain.")
				return FALSE
		else
			return FALSE

/obj/machinery/computer/pandemic/tgui_state(mob/user)
	return GLOB.tgui_default_state

/obj/machinery/computer/pandemic/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Pandemic", name)
		ui.open()

/obj/machinery/computer/pandemic/tgui_data(mob/user)
	var/list/data = list()
	data["is_ready"] = !wait
	if(!beaker)
		data["has_beaker"] = FALSE
		data["has_blood"] = FALSE
		return data
	data["has_beaker"] = TRUE
	data["beaker"] = list(
		"volume" = round(beaker.reagents?.total_volume, 0.01) || 0,
		"capacity" = beaker.volume
	)
	var/datum/reagent/blood/blood = locate() in beaker.reagents.reagent_list
	if(!blood)
		data["has_blood"] = FALSE
		return data

	data["has_blood"] = TRUE
	data["blood"] = list()
	data["blood"]["dna"] = blood.data["blood_DNA"] || "none"
	data["blood"]["type"] = blood.data["blood_type"] || "none"
	data["viruses"] = get_viruses_data(blood)
	data["resistances"] = get_resistance_data(blood)

	return data

/obj/machinery/computer/pandemic/proc/eject_beaker()
	set name = "Eject Beaker"
	set category = "Object"
	set src in oview(1)

	if(usr.stat != 0)
		return

	beaker.forceMove(loc)
	beaker = null
	icon_state = "pandemic0"

/obj/machinery/computer/pandemic/proc/print_form(datum/disease/advance/D, mob/living/user)
	D = GLOB.archive_diseases[D.GetDiseaseID()]
	if(!istype(D))
		visible_message(span_warning("ERROR: Unable to print form."))
		playsound(loc, 'sound/machines/buzz-sigh.ogg', 50, 1)
		return
	if(!(printing) && D)
		var/reason = tgui_input_text(user,"Enter a reason for the release", "Write", multiline = TRUE)
		if(!reason)
			return
		reason += "<span class=\"paper_field\"></span>"
		var/english_symptoms = list()
		for(var/I in D.symptoms)
			var/datum/symptom/S = I
			english_symptoms += S.name
		var/symptoms = english_list(english_symptoms)

		var/signature
		if(tgui_alert(user, "Would you like to add your signature?", "Signature", list("Yes","No")) == "Yes")
			signature = "<font face=\"Times New Roman\">" + span_italics("[user ? user.real_name : "Anonymous"]") + "</font>"
		else
			signature = "<span class=\"paper_field\"></span>"

		printing = TRUE
		var/obj/item/paper/P = new /obj/item/paper(loc)
		visible_message(span_notice("[src] rattles and prints out a sheet of paper."))
		playsound(loc, 'sound/machines/printer.ogg', 50, 1)

		P.info = span_underline(span_huge(span_bold("<center> Releasing Virus </center>")))
		P.info += "<HR>"
		P.info += span_underline("Name of the Virus:") + " [D.name] <BR>"
		P.info += span_underline("Symptoms:") + " [symptoms]<BR>"
		P.info += span_underline("Spreads by:") + " [D.spread_text]<BR>"
		P.info += span_underline("Cured by:") + " [D.cure_text]<BR>"
		P.info += "<BR>"
		P.info += span_underline("Reason for releasing:") + " [reason]"
		P.info += "<HR>"
		P.info += "The Virologist is responsible for any biohazards caused by the virus released.<BR>"
		P.info += span_underline("Virologist's sign:") + " [signature]<BR>"
		P.info += "If approved, stamp below with the Chief Medical Officer's stamp, and/or the Captain's stamp if required:"
		P.updateinfolinks()
		P.name = "Releasing Virus - [D.name]"
		printing = FALSE

/obj/machinery/computer/pandemic/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/computer/pandemic/attack_hand(mob/user)
	if(..())
		return
	tgui_interact(user)

/obj/machinery/computer/pandemic/attack_ghost(mob/user)
	tgui_interact(user)

/obj/machinery/computer/pandemic/attackby(obj/item/I, mob/user, params)
	if(default_unfasten_wrench(user, I, 4 SECONDS))
		return
	if(I.has_tool_quality(TOOL_SCREWDRIVER))
		eject_beaker()
		return
	if(istype(I, /obj/item/reagent_containers/glass) && I.is_open_container() || istype(I, /obj/item/reagent_containers/syringe))
		if(stat & (NOPOWER|BROKEN))
			return
		if(beaker)
			to_chat(user, span_warning("A [beaker] is already loaded into the machine!"))
			return

		user.drop_item()
		beaker = I
		beaker.loc = src
		to_chat(user, span_notice("You add \the [I] to the machine."))
		update_tgui_static_data(user)
		icon_state = "pandemic1"
	else
		return ..()

/obj/machinery/computer/pandemic/proc/get_viruses_data(datum/reagent/blood/blood)
	. = list()
	var/list/viruses = blood.get_diseases()
	var/index = 1

	for(var/datum/disease/disease as anything in viruses)
		if(CHECK_BITFIELD(disease.visibility_flags, HIDDEN_PANDEMIC))
			continue

		var/list/traits = list()
		traits["name"] = disease.name
		if(istype(disease, /datum/disease/advance))
			var/datum/disease/advance/adv_disease = disease
			traits["can_rename"] = (adv_disease.name == "Unknown")
			traits["name"] = disease.name
			traits["is_adv"] = TRUE
			traits["symptoms"] = list()
			for(var/datum/symptom/symptom as() in adv_disease.symptoms)
				traits["symptoms"] += list(symptom.get_symptom_data())
			traits["resistance"] = adv_disease.resistance
			traits["stealth"] = adv_disease.stealth
			traits["stage_speed"] = adv_disease.stage_rate
			traits["transmission"] = adv_disease.transmission
			traits["symptom_severity"] = adv_disease.severity

		traits["index"] = index++
		traits["agent"] = disease.agent
		traits["description"] = disease.desc || "none"
		traits["spread"] = disease.spread_text || "none"
		traits["cure"] = disease.cure_text || "none"
		traits["danger"] = disease.danger || "none"

		. += list(traits)

/obj/machinery/computer/pandemic/proc/get_resistance_data(datum/reagent/blood/blood)
	var/list/data = list()
	if(!islist(blood.data["resistances"]))
		return data
	var/list/resistances = blood.data["resistances"]
	for(var/id in resistances)
		var/list/resistance = list()
		var/datum/disease/disease = GLOB.archive_diseases[id]
		if(disease)
			resistance["id"] = id
			resistance["name"] = disease.name
		data += list(resistance)
	return data

/obj/machinery/computer/pandemic/proc/get_by_index(thing, index)
	if(!beaker || !beaker.reagents)
		return FALSE
	var/datum/reagent/blood/blood = locate() in beaker.reagents.reagent_list
	if(blood?.data[thing])
		return blood.data[thing][index]
	return FALSE

/obj/machinery/computer/pandemic/proc/get_virus_id_by_index(index)
	var/datum/disease/disease = get_by_index("viruses", index)
	if(!disease)
		return FALSE
	return disease.GetDiseaseID()

/obj/machinery/computer/pandemic/proc/create_vaccine_bottle(index)
	use_power(active_power_usage)
	var/id = index
	var/datum/disease/disease = GLOB.archive_diseases[id]
	var/obj/item/reagent_containers/glass/beaker/vial/bottle = new(drop_location())
	bottle.name = "[disease.name] vaccine"
	bottle.reagents.add_reagent(REAGENT_ID_VACCINE, 15, list(get_by_index("resistances", id)))
	beaker.reagents.remove_reagent(REAGENT_ID_BLOOD, 5)
	wait = TRUE
	addtimer(CALLBACK(src, PROC_REF(reset_replicator_cooldown)), 20 SECONDS)
	return TRUE

/obj/machinery/computer/pandemic/proc/create_culture_bottle(index)
	var/id = get_virus_id_by_index(text2num(index))
	var/datum/disease/advance/adv_disease = GLOB.archive_diseases[id]
	var/old_name = adv_disease.name

	if(!istype(adv_disease))
		to_chat(usr, span_warning("ERROR: Cannot replicate virus strain."))
		return FALSE

	if(!beaker.reagents.has_reagent(REAGENT_ID_BLOOD, 10))
		to_chat(usr, span_warning("ERROR: Not enough blood in the sample."))
		return FALSE

	use_power(active_power_usage)
	adv_disease = adv_disease.Copy()
	adv_disease.name = old_name
	var/list/cures = get_beaker_cures(id)
	if(cures.len)
		adv_disease.cures = cures[1]
		adv_disease.cure_text = cures[2]
	var/list/data = list("viruses" = list(adv_disease))

	var/obj/item/reagent_containers/glass/beaker/vial/bottle = new(drop_location())
	bottle.name = "[adv_disease.name] culture vial"
	bottle.desc = "A small vial containing [adv_disease.agent] culture in synthblood."
	bottle.reagents.add_reagent(REAGENT_ID_BLOOD, 10, data)
	beaker.reagents.remove_reagent(REAGENT_ID_BLOOD, 10)
	wait = TRUE
	addtimer(CALLBACK(src, PROC_REF(reset_replicator_cooldown)), 5 SECONDS)
	return TRUE

/obj/machinery/computer/pandemic/proc/get_beaker_cures(disease_id)
	var/list/cures = list()
	if(!beaker)
		return cures

	var/datum/reagent/blood/blood = beaker.reagents.get_reagent(REAGENT_ID_BLOOD)
	if(!blood)
		return cures

	var/list/viruses = blood.get_diseases()
	if(!length(viruses))
		return cures

	for(var/datum/disease/advance/disease in viruses)
		if(disease.GetDiseaseID() == disease_id)
			cures.Add(disease.cures)
			cures.Add(disease.cure_text)
			break

	return cures

/obj/machinery/computer/pandemic/proc/rename_disease(index, name)
	var/id = get_virus_id_by_index(text2num(index))
	var/datum/disease/advance/adv_disease = GLOB.archive_diseases[id]

	if(adv_disease)
		if(!name)
			return FALSE
		adv_disease.AssignName(name)
		return TRUE
	return FALSE

/obj/machinery/computer/pandemic/proc/reset_replicator_cooldown()
	wait = FALSE
	SStgui.update_uis(src)
	playsound(src, 'sound/machines/ping.ogg', 30, TRUE)
	return TRUE
