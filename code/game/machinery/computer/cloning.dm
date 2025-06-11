#define MENU_MAIN 1
#define MENU_RECORDS 2

/obj/machinery/computer/cloning
	name = "cloning console"
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "med_key"
	icon_screen = "dna"
	circuit = /obj/item/circuitboard/cloning
	req_access = list(access_heads) //Only used for record deletion right now.
	var/obj/machinery/dna_scannernew/scanner = null //Linked scanner. For scanning.
	var/list/pods = null //Linked cloning pods.
	var/list/temp = null
	var/list/scantemp = null
	var/menu = MENU_MAIN //Which menu screen to display
	var/list/records = null
	var/datum/transhuman/body_record/active_BR = null
	var/obj/item/disk/body_record/diskette = null // Traitgenes - Storing the entire body record
	var/loading = 0 // Nice loading text
	var/autoprocess = 0
	var/obj/machinery/clonepod/selected_pod
	// 0: Standard body scan
	// 1: The "Best" scan available
	var/scan_mode = 1

	light_color = "#315ab4"

/obj/machinery/computer/cloning/Initialize(mapload)
	. = ..()
	pods = list()
	records = list()
	set_scan_temp("Scanner ready.", "good")
	updatemodules()

/obj/machinery/computer/cloning/Destroy()
	releasecloner()
	for(var/datum/transhuman/body_record/BR in records)
		qdel(BR)
	return ..()

/obj/machinery/computer/cloning/process()
	if(!scanner || !pods.len || !autoprocess || stat & NOPOWER)
		return

	if(scanner.get_occupant() && can_autoprocess())
		scan_mob(scanner.get_occupant())

	if(!LAZYLEN(records))
		return

	for(var/obj/machinery/clonepod/pod in pods)
		if(!(pod.get_occupant() || pod.mess) && (pod.efficiency > 5))
			for(var/datum/transhuman/body_record/BR in records)
				if(!(pod.get_occupant() || pod.mess))
					if(pod.growclone(BR))
						records.Remove(BR)

/obj/machinery/computer/cloning/proc/updatemodules()
	scanner = findscanner()
	releasecloner()
	findcloner()
	if(!selected_pod && pods.len)
		selected_pod = pods[1]

/obj/machinery/computer/cloning/proc/findscanner()
	var/obj/machinery/dna_scannernew/scannerf = null

	//Try to find scanner on adjacent tiles first
	for(var/scan_dir in list(NORTH,EAST,SOUTH,WEST))
		scannerf = locate(/obj/machinery/dna_scannernew, get_step(src, scan_dir))
		if(scannerf)
			return scannerf

	//Then look for a free one in the area
	if(!scannerf)
		for(var/obj/machinery/dna_scannernew/S in get_area(src))
			return S

	return 0

/obj/machinery/computer/cloning/proc/releasecloner()
	for(var/obj/machinery/clonepod/P in pods)
		P.connected = null
		P.name = initial(P.name)
	pods.Cut()

/obj/machinery/computer/cloning/proc/findcloner()
	var/num = 1
	for(var/obj/machinery/clonepod/P in get_area(src))
		if(!P.connected)
			pods += P
			P.connected = src
			P.name = "[initial(P.name)] #[num++]"

/obj/machinery/computer/cloning/attackby(obj/item/W as obj, mob/user as mob, params)
	if(istype(W, /obj/item/disk/body_record/)) //Traitgenes Storing the entire body record
		if(!diskette)
			user.drop_item()
			W.forceMove(src)
			diskette = W
			to_chat(user, "You insert [W].")
			SStgui.update_uis(src)
			return
	else if(istype(W, /obj/item/multitool))
		var/obj/item/multitool/M = W
		var/obj/machinery/clonepod/P = M.connecting
		if(P && !(P in pods))
			pods += P
			P.connected = src
			P.name = "[initial(P.name)] #[pods.len]"
			to_chat(user, span_notice("You connect [P] to [src]."))
	else
		return ..()

/obj/machinery/computer/cloning/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/cloning/attack_hand(mob/user as mob)
	user.set_machine(src)
	add_fingerprint(user)

	if(stat & (BROKEN|NOPOWER))
		return

	updatemodules()
	tgui_interact(user)

/obj/machinery/computer/cloning/resleeving/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/simple/cloning)
	)

/obj/machinery/computer/cloning/tgui_interact(mob/user, datum/tgui/ui = null)
	if(stat & (NOPOWER|BROKEN))
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CloningConsole", "Cloning Console")
		ui.open()

/obj/machinery/computer/cloning/tgui_data(mob/user)
	var/data[0]
	data["menu"] = menu
	data["scanner"] = sanitize("[scanner]")

	var/canpodautoprocess = 0
	if(pods.len)
		data["numberofpods"] = pods.len

		var/list/tempods[0]
		for(var/obj/machinery/clonepod/pod in pods)
			if(pod.efficiency > 5)
				canpodautoprocess = 1

			var/mob/living/occupant = pod.get_occupant()
			var/status = "idle"
			if(pod.mess)
				status = "mess"
			else if(occupant && !(pod.stat & NOPOWER))
				status = "cloning"
			tempods.Add(list(list(
				"pod" = "\ref[pod]",
				"name" = sanitize(capitalize(pod.name)),
				"biomass" = pod.get_biomass(),
				"status" = status,
				"progress" = (occupant && occupant.stat != DEAD) ? pod.get_completion() : 0
			)))
			data["pods"] = tempods

	data["loading"] = loading
	data["autoprocess"] = autoprocess
	data["can_brainscan"] = can_brainscan() // You'll need tier 4s for this
	data["scan_mode"] = scan_mode

	if(scanner && pods.len && ((scanner.scan_level > 2) || canpodautoprocess))
		data["autoallowed"] = 1
	else
		data["autoallowed"] = 0
	if(scanner)
		data["occupant"] = scanner.get_occupant()
		data["locked"] = scanner.locked
	data["temp"] = temp
	data["scantemp"] = scantemp
	data["disk"] = diskette
	data["selected_pod"] = "\ref[selected_pod]"
	var/list/temprecords[0]
	for(var/datum/transhuman/body_record/BR in records)
		var tempRealName = BR.mydna.dna.real_name
		temprecords.Add(list(list("record" = "\ref[BR]", "realname" = sanitize(tempRealName))))
	data["records"] = temprecords

	if(selected_pod && (selected_pod in pods) && selected_pod.get_biomass() >= CLONE_BIOMASS)
		data["podready"] = 1
	else
		data["podready"] = 0

	data["modal"] = tgui_modal_data(src)

	return data

/obj/machinery/computer/cloning/tgui_act(action, params, datum/tgui/ui)
	if(..())
		return TRUE

	. = TRUE
	switch(tgui_modal_act(src, action, params))
		if(TGUI_MODAL_ANSWER)
			if(params["id"] == "del_rec" && active_BR)
				var/obj/item/card/id/C = ui.user.get_active_hand()
				if(!istype(C) && !istype(C, /obj/item/pda))
					set_temp("ID not in hand.", "danger")
					return
				if(check_access(C))
					records.Remove(active_BR)
					qdel(active_BR) // Already deletes dna in destroy()
					set_temp("Record deleted.", "success")
					menu = MENU_RECORDS
				else
					set_temp("Access denied.", "danger")
			return

	var/mob/living/carbon/human/scanner_occupant = scanner.get_occupant()

	switch(action)
		if("scan")
			if(!scanner || !scanner_occupant || loading)
				return
			set_scan_temp("Scanner ready.", "good")
			loading = TRUE

			spawn(20)
				if(can_brainscan() && scan_mode)
					scan_mob(scanner_occupant, scan_brain = TRUE)
				else
					scan_mob(scanner_occupant)
				loading = FALSE
				SStgui.update_uis(src)
		if("autoprocess")
			autoprocess = text2num(params["on"]) > 0
		if("lock")
			if(isnull(scanner) || !scanner_occupant) //No locking an open scanner.
				return
			scanner.locked = !scanner.locked
		if("view_rec")
			var/ref = params["ref"]
			if(!length(ref))
				return
			active_BR = locate(ref)
			if(istype(active_BR))
				if(isnull(active_BR.ckey))
					qdel(active_BR)
					set_temp("Error: Record corrupt.", "danger")
				else
					var/obj/item/implant/health/H = null
					if(active_BR.mydna.implant)
						H = locate(active_BR.mydna.implant)
					var/list/payload = list(
						activerecord = "\ref[active_BR]",
						health = (H && istype(H)) ? H.sensehealth() : "",
						realname = sanitize(active_BR.mydna.dna.real_name),
						unidentity = active_BR.mydna.dna.uni_identity,
						strucenzymes = active_BR.mydna.dna.struc_enzymes,
					)
					tgui_modal_message(src, action, "", null, payload)
			else
				active_BR = null
				set_temp("Error: Record missing.", "danger")
		if("del_rec")
			if(!active_BR)
				return
			tgui_modal_boolean(src, action, "Please confirm that you want to delete the record by holding your ID and pressing Delete:", yes_text = "Delete", no_text = "Cancel")
		if("disk") // Disk management.
			if(!length(params["option"]))
				return
			switch(params["option"])
				if("load")
					if(isnull(diskette) || isnull(diskette.stored)) // Traitgenes Storing the entire body record
						set_temp("Error: The disk's data could not be read.", "danger")
						return
					else if(isnull(active_BR))
						set_temp("Error: No active record was found.", "danger")
						menu = MENU_MAIN
						return

					active_BR = new(diskette.stored) // Traitgenes Storing the entire body record
					set_temp("Successfully loaded from disk.", "success")
				if("save")
					if(isnull(diskette) || isnull(active_BR)) // Traitgenes Removed readonly
						set_temp("Error: The data could not be saved.", "danger")
						return

					diskette.stored = new(active_BR) // Traitgenes Storing the entire body record
					diskette.name = "data disk - '[active_BR.mydna.dna.real_name]'"
					set_temp("Successfully saved to disk.", "success")
				if("eject")
					if(!isnull(diskette))
						diskette.forceMove(get_turf(src))
						diskette = null
		if("refresh")
			SStgui.update_uis(src)
		if("selectpod")
			var/ref = params["ref"]
			if(!length(ref))
				return
			var/obj/machinery/clonepod/selected = locate(ref)
			if(istype(selected) && (selected in pods))
				selected_pod = selected
		if("clone")
			var/ref = params["ref"]
			if(!length(ref))
				return
			var/datum/transhuman/body_record/C = locate(ref)
			//Look for that player! They better be dead!
			if(istype(C))
				tgui_modal_clear(src)
				//Can't clone without someone to clone.  Or a pod.  Or if the pod is busy. Or full of gibs.
				if(!length(pods))
					set_temp("Error: No cloning pod detected.", "danger")
				else
					var/obj/machinery/clonepod/pod = selected_pod
					var/cloneresult
					if(!selected_pod)
						set_temp("Error: No cloning pod selected.", "danger")
					else if(pod.get_occupant())
						set_temp("Error: The cloning pod is currently occupied.", "danger")
					else if(pod.get_biomass() < CLONE_BIOMASS)
						set_temp("Error: Not enough biomass.", "danger")
					else if(pod.mess)
						set_temp("Error: The cloning pod is malfunctioning.", "danger")
					else if(!CONFIG_GET(flag/revival_cloning))
						set_temp("Error: Unable to initiate cloning cycle.", "danger")
					else
						cloneresult = pod.growclone(C)
						if(cloneresult)
							set_temp("Initiating cloning cycle...", "success")
							playsound(src, 'sound/machines/medbayscanner1.ogg', 100, 1)
							records.Remove(C)
							qdel(C)
							menu = MENU_MAIN
						else
							set_temp("Error: Initialisation failure.", "danger")
			else
				set_temp("Error: Data corruption.", "danger")
		if("menu")
			menu = clamp(text2num(params["num"]), MENU_MAIN, MENU_RECORDS)
		if("toggle_mode")
			if(loading)
				return
			if(can_brainscan())
				scan_mode = !scan_mode
			else
				scan_mode = FALSE
		if("eject")
			if(ui.user.incapacitated() || !scanner || loading)
				return
			scanner.eject_occupant(ui.user)
			scanner.add_fingerprint(ui.user)
		if("cleartemp")
			temp = null
		else
			return FALSE

	add_fingerprint(ui.user)

/obj/machinery/computer/cloning/proc/scan_mob(mob/living/carbon/human/subject as mob, var/scan_brain = 0)
	if(stat & NOPOWER)
		return
	if(scanner.stat & (NOPOWER|BROKEN))
		return
	if(scan_brain && !can_brainscan())
		return
	if(isnull(subject) || (!(ishuman(subject))) || (!subject.dna))
		if(isalien(subject))
			set_scan_temp("Genaprawns are not scannable.", "bad")
			SStgui.update_uis(src)
			return
		// can add more conditions for specific non-human messages here
		else
			set_scan_temp("Subject species is not scannable.", "bad")
			SStgui.update_uis(src)
			return
	if(!subject.has_brain())
		if(ishuman(subject))
			var/mob/living/carbon/human/H = subject
			if(H.should_have_organ(O_BRAIN))
				set_scan_temp("No brain detected in subject.", "bad")
		else
			set_scan_temp("No brain detected in subject.", "bad")
		SStgui.update_uis(src)
		return
	if(subject.suiciding)
		set_scan_temp("Subject has committed suicide and is not scannable.", "bad")
		SStgui.update_uis(src)
		return
	if((!subject.ckey) || (!subject.client))
		set_scan_temp("Subject's brain is not responding. Further attempts after a short delay may succeed.", "bad")
		SStgui.update_uis(src)
		return
	if((NOCLONE in subject.mutations))
		set_scan_temp("Subject has incompatible genetic mutations.", "bad")
		SStgui.update_uis(src)
		return
	if(!isnull(find_record(subject.ckey)))
		set_scan_temp("Subject already in database.")
		SStgui.update_uis(src)
		return

	for(var/obj/machinery/clonepod/pod in pods)
		var/mob/living/occupant = pod.get_occupant()
		if(occupant && occupant.mind == subject.mind)
			set_scan_temp("Subject already getting cloned.")
			SStgui.update_uis(src)
			return

	subject.dna.check_integrity()
	var/datum/transhuman/body_record/BR = new(subject)

	//Add an implant if needed
	var/obj/item/implant/health/imp = locate(/obj/item/implant/health, subject)
	if (isnull(imp))
		imp = new /obj/item/implant/health(subject)
		imp.implanted = subject
		BR.mydna.implant = "\ref[imp]"
	//Update it if needed
	else
		BR.mydna.implant = "\ref[imp]"

	if (!isnull(subject.mind)) //Save that mind so traitors can continue traitoring after cloning.
		BR.mydna.mind = "\ref[subject.mind]"

	records += BR
	set_scan_temp("Subject successfully scanned.", "good")
	SStgui.update_uis(src)

//Find a specific record by key.
/obj/machinery/computer/cloning/proc/find_record(var/find_key)
	var/selected_record = null
	for(var/datum/transhuman/body_record/BR in records)
		if(BR.mydna.ckey == find_key)
			selected_record = BR
			break
	return selected_record

/obj/machinery/computer/cloning/proc/can_autoprocess()
	return (scanner && scanner.scan_level > 2)

/obj/machinery/computer/cloning/proc/can_brainscan()
	return (scanner && scanner.scan_level > 3)

/**
 * Sets a temporary message to display to the user
 *
 * Arguments:
 * * text - Text to display, null/empty to clear the message from the UI
 * * style - The style of the message: (color name), info, success, warning, danger
 */
/obj/machinery/computer/cloning/proc/set_temp(text = "", style = "info", update_now = FALSE)
	temp = list(text = text, style = style)
	if(update_now)
		SStgui.update_uis(src)

/**
 * Sets a temporary scan message to display to the user
 *
 * Arguments:
 * * text - Text to display, null/empty to clear the message from the UI
 * * color - The color of the message: (color name)
 */
/obj/machinery/computer/cloning/proc/set_scan_temp(text = "", color = "", update_now = FALSE)
	scantemp = list(text = text, color = color)
	if(update_now)
		SStgui.update_uis(src)

#undef MENU_MAIN
#undef MENU_RECORDS
