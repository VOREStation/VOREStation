/obj/machinery/computer/transhuman/resleeving
	name = "resleeving control console"
	catalogue_data = list(/datum/category_item/catalogue/information/organization/khi,
						/datum/category_item/catalogue/technology/resleeving)
	icon_keyboard = "med_key"
	icon_screen = "dna"
	light_color = "#315ab4"
	circuit = /obj/item/weapon/circuitboard/resleeving_control
	req_access = list(access_heads) //Only used for record deletion right now.
	var/list/pods = list() //Linked grower pods.
	var/list/spods = list()
	var/list/sleevers = list() //Linked resleeving booths.
	var/temp = ""
	var/menu = 1 //Which menu screen to display
	var/datum/transhuman/body_record/active_br = null
	var/datum/transhuman/mind_record/active_mr = null
	var/organic_capable = 1
	var/synthetic_capable = 1
	var/obj/item/weapon/disk/transcore/disk

/obj/machinery/computer/transhuman/resleeving/Initialize()
	. = ..()
	updatemodules()

/obj/machinery/computer/transhuman/resleeving/Destroy()
	releasepods()
	return ..()

/obj/machinery/computer/transhuman/resleeving/proc/updatemodules()
	releasepods()
	findpods()

/obj/machinery/computer/transhuman/resleeving/proc/releasepods()
	for(var/obj/machinery/clonepod/transhuman/P in pods)
		P.connected = null
		P.name = initial(P.name)
	pods.Cut()
	for(var/obj/machinery/transhuman/synthprinter/P in spods)
		P.connected = null
		P.name = initial(P.name)
	spods.Cut()
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
	for(var/obj/machinery/transhuman/synthprinter/P in A.get_contents())
		if(!P.connected)
			spods += P
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
		if(istype(P) && !(P in pods))
			pods += P
			P.connected = src
			P.name = "[initial(P.name)] #[pods.len]"
			to_chat(user, "<span class='notice'>You connect [P] to [src].</span>")
	else if(istype(W, /obj/item/weapon/disk/transcore) && SStranscore && !SStranscore.core_dumped)
		user.unEquip(W)
		disk = W
		disk.forceMove(src)
		to_chat(user, "<span class='notice'>You insert \the [W] into \the [src].</span>")
	if(istype(W, /obj/item/weapon/disk/body_record))
		var/obj/item/weapon/disk/body_record/brDisk = W
		if(!brDisk.stored)
			to_chat(user, "<span class='warning'>\The [W] does not contain a stored body record.</span>")
			return
		user.unEquip(W)
		W.forceMove(get_turf(src)) // Drop on top of us
		active_br = new /datum/transhuman/body_record(brDisk.stored) // Loads a COPY!
		menu = 4
		to_chat(user, "<span class='notice'>\The [src] loads the body record from \the [W] before ejecting it.</span>")
		attack_hand(user)
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
	for(var/N in SStranscore.body_scans)
		var/datum/transhuman/body_record/BR = SStranscore.body_scans[N]
		bodyrecords_list_ui[++bodyrecords_list_ui.len] = list("name" = N, "recref" = "\ref[BR]")

	var/mindrecords_list_ui[0]
	for(var/N in SStranscore.backed_up)
		var/datum/transhuman/mind_record/MR = SStranscore.backed_up[N]
		mindrecords_list_ui[++mindrecords_list_ui.len] = list("name" = N, "recref" = "\ref[MR]")

	var/pods_list_ui[0]
	for(var/obj/machinery/clonepod/transhuman/pod in pods)
		pods_list_ui[++pods_list_ui.len] = list("pod" = pod, "biomass" = pod.get_biomass())

	var/spods_list_ui[0]
	for(var/obj/machinery/transhuman/synthprinter/spod in spods)
		spods_list_ui[++spods_list_ui.len] = list("spod" = spod, "steel" = spod.stored_material[DEFAULT_WALL_MATERIAL], "glass" = spod.stored_material["glass"])

	var/sleevers_list_ui[0]
	for(var/obj/machinery/transhuman/resleever/resleever in sleevers)
		sleevers_list_ui[++sleevers_list_ui.len] = list("sleever" = resleever, "occupant" = resleever.occupant ? resleever.occupant.real_name : "None")

	if(pods)
		data["pods"] = pods_list_ui
	else
		data["pods"] = null

	if(spods)
		data["spods"] = spods_list_ui
	else
		data["spods"] = null

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
		if(!synthetic_capable && active_br.synthetic) //Disqualified due to being synthetic in an organic only.
			can_grow_active = 0
		else if(!organic_capable && !active_br.synthetic) //Disqualified for the opposite.
			can_grow_active = 0
		else if(!synthetic_capable && !organic_capable) //What have you done??
			can_grow_active = 0
		else if(active_br.toocomplex)
			can_grow_active = 0

		data["activeBodyRecord"] = list("real_name" = active_br.mydna.name, \
									"speciesname" = active_br.speciesname ? active_br.speciesname : active_br.mydna.dna.species, \
									"gender" = active_br.bodygender, \
									"synthetic" = active_br.synthetic ? "Yes" : "No", \
									"locked" = active_br.locked ? "Low" : "High", \
									"cando" = can_grow_active,
									"booc" = active_br.body_oocnotes)
	else
		data["activeRecord"] = null

	if(active_mr)
		var/can_sleeve_current = 1
		if(!sleevers.len)
			can_sleeve_current = 0
		data["activeMindRecord"] = list("charname" = active_mr.mindname, \
										"obviously_dead" = active_mr.dead_state == MR_DEAD ? "Past-due" : "Current", \
										"cando" = can_sleeve_current,
										"mooc" = active_mr.mind_oocnotes)
	else
		data["activeMindRecord"] = null


	data["menu"] = menu
	data["podsLen"] = pods.len
	data["spodsLen"] = spods.len
	data["sleeversLen"] = sleevers.len
	data["temp"] = temp
	data["coredumped"] = SStranscore.core_dumped
	data["emergency"] = disk ? 1 : 0

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "sleever.tmpl", "Resleeving Control Console", 400, 450)
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

	else if (href_list["boocnotes"])
		menu = 6

	else if (href_list["moocnotes"])
		menu = 7

	else if (href_list["refresh"])
		updateUsrDialog()

	else if (href_list["coredump"])
		if(disk)
			SStranscore.core_dump(disk)
			sleep(5)
			visible_message("<span class='warning'>\The [src] spits out \the [disk].</span>")
			disk.forceMove(get_turf(src))
			disk = null

	else if (href_list["ejectdisk"])
		disk.forceMove(get_turf(src))
		disk = null

	else if (href_list["create"])
		if(istype(active_br))
			//Tried to grow a synth but no synth pods.
			if(active_br.synthetic && !spods.len)
				temp = "Error: No SynthFabs detected."
			//Tried to grow an organic but no growpods.
			else if(!active_br.synthetic && !pods.len)
				temp = "Error: No growpods detected."
			//We have the machines. We can rebuild them. Probably.
			else
				//We're cloning a synth.
				if(active_br.synthetic)
					var/obj/machinery/transhuman/synthprinter/spod = spods[1]
					if (spods.len > 1)
						spod = input(usr,"Select a SynthFab to use", "Printer selection") as anything in spods

					//Already doing someone.
					if(spod.busy)
						temp = "Error: SynthFab is currently busy."

					//Not enough steel or glass
					else if(spod.stored_material[DEFAULT_WALL_MATERIAL] < spod.body_cost)
						temp = "Error: Not enough [DEFAULT_WALL_MATERIAL] in SynthFab."
					else if(spod.stored_material["glass"] < spod.body_cost)
						temp = "Error: Not enough glass in SynthFab."

					//Gross pod (broke mid-cloning or something).
					else if(spod.broken)
						temp = "Error: SynthFab malfunction."

					//Do the cloning!
					else if(spod.print(active_br))
						temp = "Initiating printing cycle..."
						menu = 1
					else
						temp = "Initiating printing cycle...<br>Error: Post-initialisation failed. Printing cycle aborted."

				//We're cloning an organic.
				else
					var/obj/machinery/clonepod/transhuman/pod = pods[1]
					if (pods.len > 1)
						pod = input(usr,"Select a growing pod to use", "Pod selection") as anything in pods

					//Already doing someone.
					if(pod.occupant)
						temp = "Error: Growpod is currently occupied."

					//Not enough materials.
					else if(pod.get_biomass() < CLONE_BIOMASS)
						temp = "Error: Not enough biomass."

					//Gross pod (broke mid-cloning or something).
					else if(pod.mess)
						temp = "Error: Growpod malfunction."

					//Disabled in config.
					else if(!config.revival_cloning)
						temp = "Error: Unable to initiate growing cycle."

					//Do the cloning!
					else if(pod.growclone(active_br))
						temp = "Initiating growing cycle..."
						menu = 1
					else
						temp = "Initiating growing cycle...<br>Error: Post-initialisation failed. Growing cycle aborted."

		//The body record is broken somehow.
		else
			temp = "Error: Data corruption."

	else if (href_list["sleeve"])
		if(istype(active_mr))
			if(!sleevers.len)
				temp = "Error: No sleevers detected."
			else
				var/mode = text2num(href_list["sleeve"])
				var/override
				var/obj/machinery/transhuman/resleever/sleever = sleevers[1]
				if (sleevers.len > 1)
					sleever = input(usr,"Select a resleeving pod to use", "Resleever selection") as anything in sleevers

				switch(mode)
					if(1) //Body resleeving
						//No body to sleeve into.
						if(!sleever.occupant)
							temp = "Error: Resleeving pod is not occupied."

						//OOC body lock thing.
						if(sleever.occupant.resleeve_lock && active_mr.ckey != sleever.occupant.resleeve_lock)
							temp = "Error: Mind incompatible with body."

						var/list/subtargets = list()
						for(var/mob/living/carbon/human/H in sleever.occupant)
							if(H.resleeve_lock && active_mr.ckey != H.resleeve_lock)
								continue
							subtargets += H
						if(subtargets.len)
							var/oc_sanity = sleever.occupant
							override = input(usr,"Multiple bodies detected. Select target for resleeving of [active_mr.mindname] manually. Sleeving of primary body is unsafe with sub-contents, and is not listed.", "Resleeving Target") as null|anything in subtargets
							if(!override || oc_sanity != sleever.occupant || !(override in sleever.occupant))
								temp = "Error: Target selection aborted."

					if(2) //Card resleeving
						if(sleever.sleevecards <= 0)
							temp = "Error: No available cards in resleever."

				//Body to sleeve into, but mind is in another living body.
				if(active_mr.mind_ref.current && active_mr.mind_ref.current.stat < DEAD) //Mind is in a body already that's alive
					var/answer = alert(active_mr.mind_ref.current,"Someone is attempting to restore a backup of your mind. Do you want to abandon this body, and move there? You MAY suffer memory loss! (Same rules as CMD apply)","Resleeving","Yes","No")

					//They declined to be moved.
					if(answer == "No")
						temp = "Initiating resleeving...<br>Error: Post-initialisation failed. Resleeving cycle aborted."
						menu = 1

				//They were dead, or otherwise available.
				if(!temp)
					sleever.putmind(active_mr,mode,override)
					temp = "Initiating resleeving..."
					menu = 1

		//IDK but it broke somehow.
		else
			temp = "Error: Data corruption."

	else if (href_list["menu"])
		menu = href_list["menu"]
		temp = ""

	SSnanoui.update_uis(src)
	add_fingerprint(usr)

// In here because only relevant to computer
/obj/item/weapon/cmo_disk_holder
	name = "cmo emergency packet"
	desc = "A small paper packet with printing on one side. \"Tear open in case of Code Delta or Emergency Evacuation ONLY. Use in any other case is UNLAWFUL.\""
	catalogue_data = list(/datum/category_item/catalogue/technology/resleeving)
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "cmoemergency"
	item_state = "card-id"

/obj/item/weapon/cmo_disk_holder/attack_self(var/mob/attacker)
	playsound(src, 'sound/items/poster_ripped.ogg', 50)
	to_chat(attacker, "<span class='warning'>You tear open \the [name].</span>")
	attacker.unEquip(src)
	var/obj/item/weapon/disk/transcore/newdisk = new(get_turf(src))
	attacker.put_in_any_hand_if_possible(newdisk)
	qdel(src)

/obj/item/weapon/disk/transcore
	name = "TransCore Dump Disk"
	desc = "It has a small label. \n\
	\"1.INSERT DISK INTO RESLEEVING CONSOLE\n\
	2. BEGIN CORE DUMP PROCEDURE\n\
	3. ENSURE DISK SAFETY WHEN EJECTED\""
	catalogue_data = list(/datum/category_item/catalogue/technology/resleeving)
	icon = 'icons/obj/cloning.dmi'
	icon_state = "harddisk"
	item_state = "card-id"
	w_class = ITEMSIZE_SMALL
	var/datum/transhuman/mind_record/list/stored = list()
