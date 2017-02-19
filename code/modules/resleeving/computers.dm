/obj/machinery/computer/transhuman/resleeving
	name = "resleeving control console"
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "med_key"
	icon_screen = "dna"
	light_color = "#315ab4"
	circuit = /obj/item/weapon/circuitboard/cloning
	req_access = list(access_heads) //Only used for record deletion right now.
	var/list/pods = list() //Linked grower pods.
	var/list/sleevers = list() //Linked resleeving booths.
	var/temp = ""
	var/menu = 1 //Which menu screen to display
	var/datum/transhuman/body_record/active_br = null
	var/datum/transhuman/mind_record/active_mr = null
	var/datum/transhuman/infocore/TC //Easy debugging access
	var/organic_capable = 1
	var/synthetic_capable = 0

/obj/machinery/computer/transhuman/resleeving/initialize()
	..()
	updatemodules()
	TC = transcore

/obj/machinery/computer/transhuman/resleeving/Destroy()
	releasepods()
	..()

/obj/machinery/computer/transhuman/resleeving/proc/updatemodules()
	releasepods()
	findpods()

/obj/machinery/computer/transhuman/resleeving/proc/releasepods()
	for(var/obj/machinery/clonepod/transhuman/P in pods)
		P.connected = null
		P.name = initial(P.name)
	pods.Cut()
	for(var/obj/machinery/transhuman/resleever/P in sleevers)
		P.connected = null
		P.name = initial(P.name)
	sleevers.Cut()

/obj/machinery/computer/transhuman/resleeving/proc/findpods()
	var/num = 1
	var/area/A = get_area(src)
	for(var/obj/machinery/clonepod/transhuman/P in A.get_contents())
		if(!P.connected)
			pods += P
			P.connected = src
			P.name = "[initial(P.name)] #[num++]"
	for(var/obj/machinery/transhuman/resleever/P in A.get_contents())
		if(!P.connected)
			sleevers += P
			P.connected = src
			P.name = "[initial(P.name)] #[num++]"

/obj/machinery/computer/transhuman/resleeving/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/device/multitool))
		var/obj/item/device/multitool/M = W
		var/obj/machinery/clonepod/transhuman/P = M.connecting
		if(P && !(P in pods))
			pods += P
			P.connected = src
			P.name = "[initial(P.name)] #[pods.len]"
			user << "<span class='notice'>You connect [P] to [src].</span>"
	else
		..()
	return

/obj/machinery/computer/transhuman/resleeving/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/transhuman/resleeving/attack_hand(mob/user as mob)
	user.set_machine(src)
	add_fingerprint(user)

	if(stat & (BROKEN|NOPOWER))
		return

	updatemodules()

	ui_interact(user)

/obj/machinery/computer/transhuman/resleeving/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)

	var/data[0]

	var/bodyrecords_list_ui[0]
	for(var/N in TC.body_scans)
		var/datum/transhuman/body_record/BR = TC.body_scans[N]
		bodyrecords_list_ui[++bodyrecords_list_ui.len] = list("name" = N, "recref" = "\ref[BR]")

	var/mindrecords_list_ui[0]
	for(var/N in TC.backed_up)
		var/datum/transhuman/mind_record/MR = TC.backed_up[N]
		mindrecords_list_ui[++mindrecords_list_ui.len] = list("name" = N, "recref" = "\ref[MR]")

	var/pods_list_ui[0]
	for(var/obj/machinery/clonepod/transhuman/pod in pods)
		pods_list_ui[++pods_list_ui.len] = list("pod" = pod, "biomass" = pod.biomass)

	var/sleevers_list_ui[0]
	for(var/obj/machinery/transhuman/resleever/resleever in sleevers)
		sleevers_list_ui[++sleevers_list_ui.len] = list("sleever" = resleever, "occupant" = resleever.occupant ? resleever.occupant.real_name : "None")

	if(pods)
		data["pods"] = pods_list_ui
	else
		data["pods"] = null

	if(sleevers)
		data["sleevers"] = sleevers_list_ui
	else
		data["pods"] = null

	if(bodyrecords_list_ui.len)
		data["bodyrecords"] = bodyrecords_list_ui
	else
		data["bodyrecords"] = null

	if(mindrecords_list_ui.len)
		data["mindrecords"] = mindrecords_list_ui
	else
		data["mindrecords"] = null


	if(active_br)
		var/can_grow_active = 1
		if(!synthetic_capable && active_br.synthetic) //Disqualified due to being synthetic in an organic pod.
			can_grow_active = 0
		else if(!organic_capable && !active_br.synthetic) //Disqualified for the opposite.
			can_grow_active = 0
		else if(!synthetic_capable && !organic_capable) //What have you done??
			can_grow_active = 0
		else if(!pods.len)
			can_grow_active = 0

		data["activeBodyRecord"] = list("real_name" = active_br.mydna.name, \
									"speciesname" = active_br.speciesname, \
									"gender" = active_br.bodygender, \
									"synthetic" = active_br.synthetic ? "Yes" : "No", \
									"cando" = can_grow_active)
	else
		data["activeRecord"] = null

	if(active_mr)
		var/can_sleeve_current = 1
		if(!sleevers.len)
			can_sleeve_current = 0
		data["activeMindRecord"] = list("charname" = active_mr.charname, \
										"obviously_dead" = active_mr.obviously_dead ? "Past-due" : "Current", \
										"cando" = can_sleeve_current)
	else
		data["activeMindRecord"] = null


	data["menu"] = menu
	data["podsLen"] = pods.len
	data["sleeversLen"] = sleevers.len
	data["temp"] = temp

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "sleever.tmpl", src.name, 400, 450)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(5)

/obj/machinery/computer/transhuman/resleeving/Topic(href, href_list)
	if(..())
		return 1

	else if (href_list["view_brec"])
		active_br = locate(href_list["view_brec"])
		if(active_br && istype(active_br.mydna))
			menu = 4
		else
			active_br = null
			temp = "ERROR: Record missing."

	else if (href_list["view_mrec"])
		active_mr = locate(href_list["view_mrec"])
		if(active_mr && istype(active_mr))
			menu = 5
		else
			active_mr = null
			temp = "ERROR: Record missing."

	else if (href_list["refresh"])
		updateUsrDialog()

	else if (href_list["grow"])
		if(istype(active_br))
			if(!pods.len)
				temp = "Error: No growpods detected."
			else
				var/obj/machinery/clonepod/transhuman/pod = pods[1]
				if (pods.len > 1)
					pod = input(usr,"Select a growing pod to use", "Pod selection") as anything in pods
				if(pod.occupant)
					temp = "Error: Growpod is currently occupied."
				else if(pod.biomass < CLONE_BIOMASS)
					temp = "Error: Not enough biomass."
				else if(pod.mess)
					temp = "Error: Growpod malfunction."
				else if(!config.revival_cloning)
					temp = "Error: Unable to initiate growing cycle."
				else if(pod.growclone(active_br.mydna))
					temp = "Initiating growing cycle..."
					menu = 1
				else
					temp = "Initiating growing cycle...<br>Error: Post-initialisation failed. Growing cycle aborted."
		else
			temp = "Error: Data corruption."

	else if (href_list["sleeve"])
		if(istype(active_mr))
			if(!sleevers.len)
				temp = "Error: No sleevers detected."
			else
				var/obj/machinery/transhuman/resleever/sleever = sleevers[1]
				if (sleevers.len > 1)
					sleever = input(usr,"Select a resleeving pod to use", "Resleever selection") as anything in sleevers

				//No body to sleeve into.
				if(!sleever.occupant)
					temp = "Error: Resleeving pod is not occupied."

				//Body to sleeve into, but mind is in another living body.
				else if(active_mr.mind.current && active_mr.mind.current.stat != DEAD) //Mind is in a body already that's alive
					var/answer = alert(active_mr.mind.current,"Someone is attempting to restore a CURRENT backup of your mind into another body. Do you want to move to that body? You should suffer no memory loss.","Resleeving","Yes","No")

					//They declined to be moved.
					if(answer == "No")
						temp = "Initiating resleeving...<br>Error: Post-initialisation failed. Resleeving cycle aborted."
						menu = 1

					//They approved being moved.
					else
						sleever.putmind(active_mr)
						temp = "Initiating current backup & resleeving..."
						menu = 1

				//They were dead, or otherwise available.
				else
					sleever.putmind(active_mr)
					temp = "Initiating resleeving..."
					menu = 1

		//IDK but it broke somehow.
		else
			temp = "Error: Data corruption."

	else if (href_list["menu"])
		menu = href_list["menu"]
		temp = ""

	nanomanager.update_uis(src)
	add_fingerprint(usr)
