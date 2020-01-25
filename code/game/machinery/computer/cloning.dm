/obj/machinery/computer/cloning
	name = "cloning control console"
	desc = "Used to start cloning cycles, as well as manage clone records."
	icon_keyboard = "med_key"
	icon_screen = "dna"
	light_color = "#315ab4"
	circuit = /obj/item/weapon/circuitboard/cloning
	req_access = list(access_heads) //Only used for record deletion right now.
	var/obj/machinery/dna_scannernew/scanner = null //Linked scanner. For scanning.
	var/list/pods = list() //Linked cloning pods.
	var/temp = ""
	var/scantemp = "Scanner unoccupied"
	var/menu = 1 //Which menu screen to display
	var/list/records = list()
	var/datum/dna2/record/active_record = null
	var/obj/item/weapon/disk/data/diskette = null //Mostly so the geneticist can steal everything.
	var/loading = 0 // Nice loading text


/obj/machinery/computer/cloning/Initialize()
	. = ..()
	updatemodules()

/obj/machinery/computer/cloning/Destroy()
	releasecloner()
	..()

/obj/machinery/computer/cloning/proc/updatemodules()
	scanner = findscanner()
	releasecloner()
	findcloner()

/obj/machinery/computer/cloning/proc/findscanner()
	var/obj/machinery/dna_scannernew/scannerf = null

	//Try to find scanner on adjacent tiles first
	for(dir in list(NORTH,EAST,SOUTH,WEST))
		scannerf = locate(/obj/machinery/dna_scannernew, get_step(src, dir))
		if (scannerf)
			return scannerf

	//Then look for a free one in the area
	if(!scannerf)
		var/area/A = get_area(src)
		for(var/obj/machinery/dna_scannernew/S in A.get_contents())
			return S

	return

/obj/machinery/computer/cloning/proc/releasecloner()
	for(var/obj/machinery/clonepod/P in pods)
		P.connected = null
		P.name = initial(P.name)
	pods.Cut()

/obj/machinery/computer/cloning/proc/findcloner()
	var/num = 1
	var/area/A = get_area(src)
	for(var/obj/machinery/clonepod/P in A.get_contents())
		if(!P.connected)
			pods += P
			P.connected = src
			P.name = "[initial(P.name)] #[num++]"

/obj/machinery/computer/cloning/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/disk/data)) //INSERT SOME DISKETTES
		if (!diskette)
			user.drop_item()
			W.loc = src
			diskette = W
			to_chat(user, "You insert [W].")
			updateUsrDialog()
			return
	else if(istype(W, /obj/item/device/multitool))
		var/obj/item/device/multitool/M = W
		var/obj/machinery/clonepod/P = M.connecting
		if(P && !(P in pods))
			pods += P
			P.connected = src
			P.name = "[initial(P.name)] #[pods.len]"
			to_chat(user, "<span class='notice'>You connect [P] to [src].</span>")

	else if (menu == 4 && (istype(W, /obj/item/weapon/card/id) || istype(W, /obj/item/device/pda)))
		if(check_access(W))
			records.Remove(active_record)
			qdel(active_record)
			temp = "Record deleted."
			menu = 2
		else
			temp = "Access Denied."
	else
		..()
	return

/obj/machinery/computer/cloning/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/cloning/attack_hand(mob/user as mob)
	user.set_machine(src)
	add_fingerprint(user)

	if(stat & (BROKEN|NOPOWER))
		return

	updatemodules()

	ui_interact(user)

/obj/machinery/computer/cloning/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)

	var/data[0]

	var/records_list_ui[0]
	for(var/datum/dna2/record/R in records)
		records_list_ui[++records_list_ui.len] = list("ckey" = R.ckey, "name" = R.dna.real_name)

	var/pods_list_ui[0]
	for(var/obj/machinery/clonepod/pod in pods)
		pods_list_ui[++pods_list_ui.len] = list("pod" = pod, "biomass" = pod.get_biomass())

	if(pods)
		data["pods"] = pods_list_ui
	else
		data["pods"] = null

	if(records)
		data["records"] = records_list_ui
	else
		data["records"] = null

	if(active_record)
		data["activeRecord"] = list("ckey" = active_record.ckey, "real_name" = active_record.dna.real_name, \
									"ui" = active_record.dna.uni_identity, "se" = active_record.dna.struc_enzymes)
	else
		data["activeRecord"] = null

	data["menu"] = menu
	data["connected"] = scanner
	data["podsLen"] = pods.len
	data["loading"] = loading
	if(!scanner.occupant)
		scantemp = ""
	data["scantemp"] = scantemp
	data["occupant"] = scanner.occupant
	data["locked"] = scanner.locked
	data["diskette"] = diskette
	data["temp"] = temp

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "cloning.tmpl", src.name, 400, 450)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(5)

/obj/machinery/computer/cloning/Topic(href, href_list)
	if(..())
		return 1

	if(loading)
		return

	if ((href_list["scan"]) && (!isnull(scanner)))
		scantemp = ""

		loading = 1

		spawn(20)
			scan_mob(scanner.occupant)

			loading = 0

		//No locking an open scanner.
	else if ((href_list["lock"]) && (!isnull(scanner)))
		if ((!scanner.locked) && (scanner.occupant))
			scanner.locked = 1
		else
			scanner.locked = 0

	else if ((href_list["eject"]) && (!isnull(scanner)))
		if ((!scanner.locked) && (scanner.occupant))
			scanner.eject_occupant()

	else if (href_list["view_rec"])
		active_record = find_record(href_list["view_rec"])
		if(istype(active_record,/datum/dna2/record))
			if ((isnull(active_record.ckey)))
				qdel(active_record)
				temp = "ERROR: Record Corrupt"
			else
				menu = 3
		else
			active_record = null
			temp = "Record missing."

	else if (href_list["del_rec"])
		if ((!active_record) || (menu < 3))
			return
		if (menu == 3) //If we are viewing a record, confirm deletion
			temp = "Delete record?"
			menu = 4

	else if (href_list["disk"]) //Load or eject.
		switch(href_list["disk"])
			if("load")
				if ((isnull(diskette)) || isnull(diskette.buf))
					temp = "Load error."
					return
				if (isnull(active_record))
					temp = "Record error."
					menu = 1
					return

				active_record = diskette.buf

				temp = "Load successful."
			if("eject")
				if (!isnull(diskette))
					diskette.loc = loc
					diskette = null

	else if (href_list["save_disk"]) //Save to disk!
		if ((isnull(diskette)) || (diskette.read_only) || (isnull(active_record)))
			temp = "Save error."

		// DNA2 makes things a little simpler.
		diskette.buf = active_record
		diskette.buf.types = 0
		switch(href_list["save_disk"]) //Save as Ui/Ui+Ue/Se
			if("ui")
				diskette.buf.types = DNA2_BUF_UI
			if("ue")
				diskette.buf.types = DNA2_BUF_UI | DNA2_BUF_UE
			if("se")
				diskette.buf.types = DNA2_BUF_SE
		diskette.name = "data disk - '[active_record.dna.real_name]'"
		temp = "Save \[[href_list["save_disk"]]\] successful."

	else if (href_list["refresh"])
		updateUsrDialog()

	else if (href_list["clone"])
		var/datum/dna2/record/C = find_record(href_list["clone"])
		//Look for that player! They better be dead!
		if(istype(C))
			//Can't clone without someone to clone.  Or a pod.  Or if the pod is busy. Or full of gibs.
			if(!LAZYLEN(pods))
				temp = "Error: No clone pods detected."
			else
				var/obj/machinery/clonepod/pod = pods[1]
				if (pods.len > 1)
					pod = input(usr,"Select a cloning pod to use", "Pod selection") as anything in pods
				if(pod.occupant)
					temp = "Error: Clonepod is currently occupied."
				else if(pod.get_biomass() < CLONE_BIOMASS)
					temp = "Error: Not enough biomass."
				else if(pod.mess)
					temp = "Error: Clonepod malfunction."
				else if(!config.revival_cloning)
					temp = "Error: Unable to initiate cloning cycle."
				else if(pod.growclone(C))
					temp = "Initiating cloning cycle..."
					records.Remove(C)
					qdel(C)
					menu = 1
				else

					var/mob/selected = find_dead_player("[C.ckey]")
					selected << 'sound/machines/chime.ogg'	//probably not the best sound but I think it's reasonable
					var/answer = alert(selected,"Do you want to return to life?","Cloning","Yes","No")
					if(answer != "No" && pod.growclone(C))
						temp = "Initiating cloning cycle..."
						records.Remove(C)
						qdel(C)
						menu = 1
					else
						temp = "Initiating cloning cycle...<br>Error: Post-initialisation failed. Cloning cycle aborted."

		else
			temp = "Error: Data corruption."

	else if (href_list["menu"])
		menu = href_list["menu"]
		temp = ""
		scantemp = ""

	SSnanoui.update_uis(src)
	add_fingerprint(usr)

/obj/machinery/computer/cloning/proc/scan_mob(mob/living/carbon/human/subject as mob)
	var/brain_skip = 0
	if (istype(subject, /mob/living/carbon/brain)) //Brain scans.
		brain_skip = 1
	if ((isnull(subject)) || (!(ishuman(subject)) && !brain_skip) || (!subject.dna))
		scantemp = "Error: Unable to locate valid genetic data."
		return
	if (!subject.has_brain() && !brain_skip)
		if(istype(subject, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = subject
			if(H.should_have_organ("brain"))
				scantemp = "Error: No signs of intelligence detected."
		else
			scantemp = "Error: No signs of intelligence detected."
		return

	if(subject.isSynthetic())
		scantemp = "Error: Majority of subject is non-organic."
		return
	if (subject.suiciding)
		scantemp = "Error: Subject's brain is not responding to scanning stimuli."
		return
	if ((!subject.ckey) || (!subject.client))
		scantemp = "Error: Mental interface failure."
		return
	if (NOCLONE in subject.mutations)
		scantemp = "Error: Mental interface failure."
		return
	if (subject.species && subject.species.flags & NO_SCAN && !brain_skip)
		scantemp = "Error: Mental interface failure."
		return
	for(var/modifier_type in subject.modifiers)	//Can't be cloned, even if they had a previous scan
		if(istype(modifier_type, /datum/modifier/no_clone))
			scantemp = "Error: Mental interface failure."
			return
	if (!isnull(find_record(subject.ckey)))
		scantemp = "Subject already in database."
		return

	subject.dna.check_integrity()

	var/datum/dna2/record/R = new /datum/dna2/record()
	R.dna = subject.dna
	R.ckey = subject.ckey
	R.id = copytext(md5(subject.real_name), 2, 6)
	R.name = R.dna.real_name
	R.types = DNA2_BUF_UI|DNA2_BUF_UE|DNA2_BUF_SE
	R.languages = subject.languages
	R.gender = subject.gender
	R.body_descriptors = subject.descriptors
	if(!brain_skip) //Brains don't have flavor text.
		R.flavor = subject.flavor_texts.Copy()
	else
		R.flavor = list()
	for(var/datum/modifier/mod in subject.modifiers)
		if(mod.flags & MODIFIER_GENETIC)
			R.genetic_modifiers.Add(mod.type)

	//Add an implant if needed
	var/obj/item/weapon/implant/health/imp = locate(/obj/item/weapon/implant/health, subject)
	if (isnull(imp))
		imp = new /obj/item/weapon/implant/health(subject)
		imp.implanted = subject
		R.implant = "\ref[imp]"
	//Update it if needed
	else
		R.implant = "\ref[imp]"

	if (!isnull(subject.mind)) //Save that mind so traitors can continue traitoring after cloning.
		R.mind = "\ref[subject.mind]"

	records += R
	scantemp = "Subject successfully scanned."

//Find a specific record by key.
/obj/machinery/computer/cloning/proc/find_record(var/find_key)
	var/selected_record = null
	for(var/datum/dna2/record/R in records)
		if (R.ckey == find_key)
			selected_record = R
			break
	return selected_record
