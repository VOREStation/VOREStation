/obj/machinery/artifact_analyser
	name = "Anomaly Analyser"
	desc = "Studies the emissions of anomalous materials to discover their uses."
	icon = 'icons/obj/virology_vr.dmi' //VOREStation Edit
	icon_state = "isolator"
	anchored = TRUE
	density = TRUE
	var/scan_in_progress = 0
	var/scan_num = 0
	var/obj/scanned_obj
	var/obj/machinery/artifact_scanpad/owned_scanner = null
	var/scan_completion_time = 0
	var/scan_duration = 50
	var/obj/scanned_object
	var/report_num = 0

/obj/machinery/artifact_analyser/Initialize()
	. = ..()
	reconnect_scanner()

/obj/machinery/artifact_analyser/proc/reconnect_scanner()
	//connect to a nearby scanner pad
	owned_scanner = locate(/obj/machinery/artifact_scanpad) in get_step(src, dir)
	if(!owned_scanner)
		owned_scanner = locate(/obj/machinery/artifact_scanpad) in orange(1, src)

/obj/machinery/artifact_analyser/attack_hand(mob/user)
	add_fingerprint(user)
	if(stat & (NOPOWER|BROKEN) || get_dist(src, user) > 1)
		return
	tgui_interact(user)

/obj/machinery/artifact_analyser/tgui_interact(mob/user, datum/tgui/ui)
	if(!owned_scanner)
		reconnect_scanner()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "XenoarchArtifactAnalyzer", name)
		ui.open()

/obj/machinery/artifact_analyser/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	data["owned_scanner"] = owned_scanner
	data["scan_in_progress"] = scan_in_progress

	return data

/obj/machinery/artifact_analyser/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE
	
	add_fingerprint(usr)
	
	switch(action)
		if("scan")
			if(scan_in_progress)
				scan_in_progress = FALSE
				atom_say("Scanning halted.")
				return TRUE
			if(!owned_scanner)
				reconnect_scanner()
			if(owned_scanner)
				var/artifact_in_use = 0
				for(var/obj/O in owned_scanner.loc)
					if(O == owned_scanner)
						continue
					if(O.invisibility)
						continue
					if(istype(O, /obj/machinery/artifact))
						var/obj/machinery/artifact/A = O
						if(A.being_used)
							artifact_in_use = 1
						else
							A.anchored = TRUE
							A.being_used = 1

					if(artifact_in_use)
						atom_say("Cannot scan. Too much interference.")
					else
						scanned_object = O
						scan_in_progress = 1
						scan_completion_time = world.time + scan_duration
						atom_say("Scanning begun.")
					break
				if(!scanned_object)
					atom_say("Unable to isolate scan target.")
			return TRUE

/obj/machinery/artifact_analyser/process()
	if(scan_in_progress && world.time > scan_completion_time)
		scan_in_progress = 0
		updateDialog()

		var/results = ""
		if(!owned_scanner)
			reconnect_scanner()
		if(!owned_scanner)
			results = "Error communicating with scanner."
		else if(!scanned_object || scanned_object.loc != owned_scanner.loc)
			results = "Unable to locate scanned object. Ensure it was not moved in the process."
		else
			results = get_scan_info(scanned_object)

		atom_say("Scanning complete.")
		var/obj/item/weapon/paper/P = new(src.loc)
		P.name = "[src] report #[++report_num]"
		P.info = "<b>[src] analysis report #[report_num]</b><br>"
		P.info += "<br>"
		P.info += "[bicon(scanned_object)] [results]"
		P.stamped = list(/obj/item/weapon/stamp)
		P.add_overlay("paper_stamped")

		if(scanned_object && istype(scanned_object, /obj/machinery/artifact))
			var/obj/machinery/artifact/A = scanned_object
			A.anchored = FALSE
			A.being_used = 0
			scanned_object = null

//hardcoded responses, oh well
/obj/machinery/artifact_analyser/proc/get_scan_info(var/obj/scanned_obj)
	switch(scanned_obj.type)
		if(/obj/machinery/auto_cloner)
			return "Automated cloning pod - appears to rely on an artificial ecosystem formed by semi-organic nanomachines and the contained liquid.<br>The liquid resembles protoplasmic residue supportive of unicellular organism developmental conditions.<br>The structure is composed of a titanium alloy."
		if(/obj/machinery/power/supermatter)
			return "Superdense phoron clump - appears to have been shaped or hewn, structure is composed of matter aproximately 20 times denser than ordinary refined phoron."
		if(/obj/structure/constructshell)
			return "Tribal idol - subject resembles statues/emblems built by superstitious pre-warp civilisations to honour their gods. Material appears to be a rock/plastcrete composite."
		if(/obj/machinery/giga_drill)
			return "Automated mining drill - structure composed of titanium-carbide alloy, with tip and drill lines edged in an alloy of diamond and phoron."
		if(/obj/structure/cult/pylon)
			return "Tribal pylon - subject resembles statues/emblems built by cargo cult civilisations to honour energy systems from post-warp civilisations."
		if(/obj/machinery/replicator)
			return "Automated construction unit - subject appears to be able to synthesize various objects given a material, some with simple internal circuitry. Method unknown."
		if(/obj/structure/crystal)
			return "Crystal formation - pseudo-organic crystalline matrix, unlikely to have formed naturally. No known technology exists to synthesize this exact composition."
		if(/obj/machinery/artifact)
			var/obj/machinery/artifact/A = scanned_obj
			var/out = "Anomalous alien device - composed of an unknown alloy.<br><br>"

			if(A.my_effect)
				out += A.my_effect.getDescription()

			if(A.secondary_effect && A.secondary_effect.activated)
				out += "<br><br>Internal scans indicate ongoing secondary activity operating independently from primary systems.<br><br>"
				out += A.secondary_effect.getDescription()

			return out
		else
			return "[scanned_obj.name] - mundane application."
