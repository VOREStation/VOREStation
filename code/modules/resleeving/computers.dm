#define MENU_MAIN 1
#define MENU_BODY 2
#define MENU_MIND 3

/obj/machinery/computer/transhuman/resleeving
	name = "resleeving control console"
	catalogue_data = list(/datum/category_item/catalogue/information/organization/khi,
						/datum/category_item/catalogue/technology/resleeving)
	icon_keyboard = "med_key"
	icon_screen = "dna"
	light_color = "#315ab4"
	circuit = /obj/item/circuitboard/resleeving_control
	req_access = list(access_heads) //Only used for record deletion right now.
	var/list/pods = null //Linked grower pods.
	var/list/spods = null
	var/list/sleevers = null //Linked resleeving booths.
	var/list/temp = null
	var/menu = MENU_MAIN //Which menu screen to display
	var/datum/transhuman/body_record/active_br = null
	var/datum/transhuman/mind_record/active_mr = null
	var/organic_capable = 1
	var/synthetic_capable = 1
	var/obj/item/disk/transcore/disk
	var/obj/machinery/clonepod/transhuman/selected_pod
	var/obj/machinery/transhuman/synthprinter/selected_printer
	var/obj/machinery/transhuman/resleever/selected_sleever

	// Resleeving database this machine interacts with. Blank for default database
	// Needs a matching /datum/transcore_db with key defined in code
	var/db_key
	var/datum/transcore_db/our_db // These persist all round and are never destroyed, just keep a hard ref

/obj/machinery/computer/transhuman/resleeving/Initialize()
	. = ..()
	pods = list()
	spods = list()
	sleevers = list()
	our_db = SStranscore.db_by_key(db_key)
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
	if(istype(W, /obj/item/multitool))
		var/obj/item/multitool/M = W
		var/obj/machinery/clonepod/transhuman/P = M.connecting
		if(istype(P) && !(P in pods))
			pods += P
			P.connected = src
			P.name = "[initial(P.name)] #[pods.len]"
			to_chat(user, "<span class='notice'>You connect [P] to [src].</span>")
	else if(istype(W, /obj/item/disk/transcore) && !our_db.core_dumped)
		user.unEquip(W)
		disk = W
		disk.forceMove(src)
		to_chat(user, "<span class='notice'>You insert \the [W] into \the [src].</span>")
	if(istype(W, /obj/item/disk/body_record))
		var/obj/item/disk/body_record/brDisk = W
		if(!brDisk.stored)
			to_chat(user, "<span class='warning'>\The [W] does not contain a stored body record.</span>")
			return
		user.unEquip(W)
		W.forceMove(get_turf(src)) // Drop on top of us
		active_br = new /datum/transhuman/body_record(brDisk.stored) // Loads a COPY!
		to_chat(user, "<span class='notice'>\The [src] loads the body record from \the [W] before ejecting it.</span>")
		attack_hand(user)
		view_b_rec("view_b_rec", list("ref" = "\ref[active_br]"))
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
	tgui_interact(user)

/obj/machinery/computer/transhuman/resleeving/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/simple/cloning),
		get_asset_datum(/datum/asset/simple/cloning/resleeving),
	)

/obj/machinery/computer/transhuman/resleeving/tgui_interact(mob/user, datum/tgui/ui = null)
	if(stat & (NOPOWER|BROKEN))
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ResleevingConsole", "Resleeving Console")
		ui.open()

/obj/machinery/computer/transhuman/resleeving/tgui_data(mob/user)
	var/data[0]
	data["menu"] = menu

	var/list/temppods[0]
	for(var/obj/machinery/clonepod/transhuman/pod in pods)
		var/status = "idle"
		if(pod.mess)
			status = "mess"
		else if(pod.occupant && !(pod.stat & NOPOWER))
			status = "cloning"
		temppods.Add(list(list(
			"pod" = "\ref[pod]",
			"name" = sanitize(capitalize(pod.name)),
			"biomass" = pod.get_biomass(),
			"status" = status,
			"progress" = (pod.occupant && pod.occupant.stat != DEAD) ? pod.get_completion() : 0
		)))
	data["pods"] = temppods.Copy()
	temppods.Cut()

	for(var/obj/machinery/transhuman/synthprinter/spod in spods)
		temppods.Add(list(list(
			"spod" = "\ref[spod]",
			"name" = sanitize(capitalize(spod.name)),
			"busy" = spod.busy,
			"steel" = spod.stored_material[MAT_STEEL],
			"glass" = spod.stored_material[MAT_GLASS]
		)))
	data["spods"] = temppods.Copy()
	temppods.Cut()

	for(var/obj/machinery/transhuman/resleever/resleever in sleevers)
		temppods.Add(list(list(
			"sleever" = "\ref[resleever]",
			"name" = sanitize(capitalize(resleever.name)),
			"occupied" = !!resleever.occupant,
			"occupant" = resleever.occupant ? resleever.occupant.real_name : "None"
		)))
	data["sleevers"] = temppods.Copy()
	temppods.Cut()

	data["coredumped"] = our_db.core_dumped
	data["emergency"] = disk
	data["temp"] = temp
	data["selected_pod"] = "\ref[selected_pod]"
	data["selected_printer"] = "\ref[selected_printer]"
	data["selected_sleever"] = "\ref[selected_sleever]"

	var/bodyrecords_list_ui[0]
	for(var/N in our_db.body_scans)
		var/datum/transhuman/body_record/BR = our_db.body_scans[N]
		bodyrecords_list_ui[++bodyrecords_list_ui.len] = list("name" = N, "recref" = "\ref[BR]")
	data["bodyrecords"] = bodyrecords_list_ui

	var/mindrecords_list_ui[0]
	for(var/N in our_db.backed_up)
		var/datum/transhuman/mind_record/MR = our_db.backed_up[N]
		mindrecords_list_ui[++mindrecords_list_ui.len] = list("name" = N, "recref" = "\ref[MR]")
	data["mindrecords"] = mindrecords_list_ui

	data["modal"] = tgui_modal_data(src)
	return data

/obj/machinery/computer/transhuman/resleeving/tgui_act(action, params)
	if(..())
		return TRUE

	. = TRUE
	switch(tgui_modal_act(src, action, params))
		if(TGUI_MODAL_ANSWER)
			// if(params["id"] == "del_rec" && active_record)
			// 	var/obj/item/card/id/C = usr.get_active_hand()
			// 	if(!istype(C) && !istype(C, /obj/item/pda))
			// 		set_temp("ID not in hand.", "danger")
			// 		return
			// 	if(check_access(C))
			// 		records.Remove(active_record)
			// 		qdel(active_record)
			// 		set_temp("Record deleted.", "success")
			// 		menu = MENU_RECORDS
			// 	else
			// 		set_temp("Access denied.", "danger")
			return

	switch(action)
		if("view_b_rec")
			view_b_rec(action, params)
		if("view_m_rec")
			var/ref = params["ref"]
			if(!length(ref))
				return
			active_mr = locate(ref)
			if(istype(active_mr))
				if(isnull(active_mr.ckey))
					qdel(active_mr)
					set_temp("Error: Record corrupt.", "danger")
				else
					var/can_sleeve_active = 1
					if(!LAZYLEN(sleevers))
						can_sleeve_active = 0
						set_temp("Error: Cannot sleeve due to no sleevers.", "danger")
					if(!selected_sleever)
						can_sleeve_active = 0
						set_temp("Error: Cannot sleeve due to no selected sleever.", "danger")
					if(selected_sleever && !selected_sleever.occupant)
						can_sleeve_active = 0
						set_temp("Error: Cannot sleeve due to lack of sleever occupant.", "danger")
					var/list/payload = list(
						activerecord = "\ref[active_mr]",
						realname = sanitize(active_mr.mindname),
						obviously_dead = active_mr.dead_state == MR_DEAD ? "Past-due" : "Current",
						oocnotes = active_mr.mind_oocnotes ? active_mr.mind_oocnotes : "None.",
						can_sleeve_active = can_sleeve_active,
					)
					tgui_modal_message(src, action, "", null, payload)
			else
				active_mr = null
				set_temp("Error: Record missing.", "danger")
		if("coredump")
			if(disk)
				our_db.core_dump(disk)
				sleep(5)
				visible_message("<span class='warning'>\The [src] spits out \the [disk].</span>")
				disk.forceMove(get_turf(src))
				disk = null
		if("ejectdisk")
			disk.forceMove(get_turf(src))
			disk = null

		if("create")
			if(istype(active_br))
				//Tried to grow a synth but no synth pods.
				if(active_br.synthetic && !spods.len)
					set_temp("Error: No SynthFabs detected.", "danger")
				//Tried to grow an organic but no growpods.
				else if(!active_br.synthetic && !pods.len)
					set_temp("Error: No growpods detected.", "danger")
				//We have the machines. We can rebuild them. Probably.
				else
					//We're cloning a synth.
					if(active_br.synthetic)
						var/obj/machinery/transhuman/synthprinter/spod = selected_printer
						if(!istype(spod))
							set_temp("Error: No SynthFab selected.", "danger")
							return

						//Already doing someone.
						if(spod.busy)
							set_temp("Error: SynthFab is currently busy.", "danger")
							return

						//Not enough steel or glass
						else if(spod.stored_material[MAT_STEEL] < spod.body_cost)
							set_temp("Error: Not enough [MAT_STEEL] in SynthFab.", "danger")
							return
						else if(spod.stored_material["glass"] < spod.body_cost)
							set_temp("Error: Not enough glass in SynthFab.", "danger")
							return

						//Gross pod (broke mid-cloning or something).
						else if(spod.broken)
							set_temp("Error: SynthFab malfunction.", "danger")
							return

						//Do the cloning!
						else if(spod.print(active_br))
							set_temp("Initiating printing cycle...", "success")
							menu = 1
						else
							set_temp("Initiating printing cycle... Error: Post-initialisation failed. Printing cycle aborted.", "danger")
							return

					//We're cloning an organic.
					else
						var/obj/machinery/clonepod/transhuman/pod = selected_pod
						if(!istype(pod))
							set_temp("Error: No clonepod selected.", "danger")
							tgui_modal_clear(src)
							return

						//Already doing someone.
						if(pod.occupant)
							set_temp("Error: Growpod is currently occupied.", "danger")
							tgui_modal_clear(src)
							return

						//Not enough materials.
						else if(pod.get_biomass() < CLONE_BIOMASS)
							set_temp("Error: Not enough biomass.", "danger")
							tgui_modal_clear(src)
							return

						//Gross pod (broke mid-cloning or something).
						else if(pod.mess)
							set_temp("Error: Growpod malfunction.", "danger")
							tgui_modal_clear(src)
							return

						//Disabled in config.
						else if(!config.revival_cloning)
							set_temp("Error: Unable to initiate growing cycle.", "danger")
							tgui_modal_clear(src)
							return

						//Do the cloning!
						else if(pod.growclone(active_br))
							set_temp("Initiating growing cycle...", "success")
							tgui_modal_clear(src)
						else
							set_temp("Initiating growing cycle... Error: Post-initialisation failed. Growing cycle aborted.", "danger")
							tgui_modal_clear(src)
							return

			//The body record is broken somehow.
			else
				set_temp("Error: Data corruption.", "danger")
				tgui_modal_clear(src)
				return

		if("sleeve")
			if(istype(active_mr))
				if(!sleevers.len)
					set_temp("Error: No sleevers detected.", "danger")
				else
					var/mode = text2num(params["mode"])
					var/override
					var/obj/machinery/transhuman/resleever/sleever = selected_sleever
					if(!istype(sleever))
						set_temp("Error: No resleeving pod selected.", "danger")
						tgui_modal_clear(src)
						return

					switch(mode)
						if(1) //Body resleeving
							//No body to sleeve into.
							if(!sleever.occupant)
								set_temp("Error: Resleeving pod is not occupied.", "danger")
								tgui_modal_clear(src)
								return

							//OOC body lock thing.
							if(sleever.occupant.resleeve_lock && active_mr.ckey != sleever.occupant.resleeve_lock)
								set_temp("Error: Mind incompatible with body.", "danger")
								tgui_modal_clear(src)
								return

							var/list/subtargets = list()
							for(var/mob/living/carbon/human/H in sleever.occupant)
								if(H.resleeve_lock && active_mr.ckey != H.resleeve_lock)
									continue
								subtargets += H
							if(subtargets.len)
								var/oc_sanity = sleever.occupant
								override = tgui_input_list(usr,"Multiple bodies detected. Select target for resleeving of [active_mr.mindname] manually. Sleeving of primary body is unsafe with sub-contents, and is not listed.", "Resleeving Target", subtargets)
								if(!override || oc_sanity != sleever.occupant || !(override in sleever.occupant))
									set_temp("Error: Target selection aborted.", "danger")
									tgui_modal_clear(src)
									return

						if(2) //Card resleeving
							if(sleever.sleevecards <= 0)
								set_temp("Error: No available cards in resleever.", "danger")
								tgui_modal_clear(src)
								return

					//Body to sleeve into, but mind is in another living body.
					if(active_mr.mind_ref.current && active_mr.mind_ref.current.stat < DEAD) //Mind is in a body already that's alive
						var/answer = tgui_alert(active_mr.mind_ref.current,"Someone is attempting to restore a backup of your mind. Do you want to abandon this body, and move there? You MAY suffer memory loss! (Same rules as CMD apply)","Resleeving",list("No","Yes"))

						//They declined to be moved.
						if(answer != "Yes")
							set_temp("Initiating resleeving... Error: Post-initialisation failed. Resleeving cycle aborted.", "danger")
							tgui_modal_clear(src)
							return TRUE

					//They were dead, or otherwise available.
					sleever.putmind(active_mr,mode,override,db_key = db_key)
					set_temp("Initiating resleeving...")
					tgui_modal_clear(src)

		if("refresh")
			SStgui.update_uis(src)
		if("selectpod")
			var/ref = params["ref"]
			if(!length(ref))
				return
			var/obj/machinery/clonepod/selected = locate(ref)
			if(istype(selected) && (selected in pods))
				selected_pod = selected
		if("selectprinter")
			var/ref = params["ref"]
			if(!length(ref))
				return
			var/obj/machinery/transhuman/synthprinter/selected = locate(ref)
			if(istype(selected) && (selected in spods))
				selected_printer = selected
		if("selectsleever")
			var/ref = params["ref"]
			if(!length(ref))
				return
			var/obj/machinery/transhuman/resleever/selected = locate(ref)
			if(istype(selected) && (selected in sleevers))
				selected_sleever = selected
		if("menu")
			menu = clamp(text2num(params["num"]), MENU_MAIN, MENU_MIND)
		if("cleartemp")
			temp = null
		else
			return FALSE

// In here because only relevant to computer
/obj/item/cmo_disk_holder
	name = "cmo emergency packet"
	desc = "A small paper packet with printing on one side. \"Tear open in case of Code Delta or Emergency Evacuation ONLY. Use in any other case is UNLAWFUL.\""
	catalogue_data = list(/datum/category_item/catalogue/technology/resleeving)
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "cmoemergency"
	item_state = "card-id"

/obj/item/cmo_disk_holder/attack_self(var/mob/attacker)
	playsound(src, 'sound/items/poster_ripped.ogg', 50)
	to_chat(attacker, "<span class='warning'>You tear open \the [name].</span>")
	attacker.unEquip(src)
	var/obj/item/disk/transcore/newdisk = new(get_turf(src))
	attacker.put_in_any_hand_if_possible(newdisk)
	qdel(src)

/obj/item/disk/transcore
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
	var/list/datum/transhuman/mind_record/stored = list()

/**
  * Sets a temporary message to display to the user
  *
  * Arguments:
  * * text - Text to display, null/empty to clear the message from the UI
  * * style - The style of the message: (color name), info, success, warning, danger
  */
/obj/machinery/computer/transhuman/resleeving/proc/set_temp(text = "", style = "info", update_now = FALSE)
	temp = list(text = text, style = style)
	if(update_now)
		SStgui.update_uis(src)

/obj/machinery/computer/transhuman/resleeving/proc/view_b_rec(action, params)
	var/ref = params["ref"]
	if(!length(ref))
		return
	active_br = locate(ref)
	if(istype(active_br))
		var/can_grow_active = 1
		if(!synthetic_capable && active_br.synthetic) //Disqualified due to being synthetic in an organic only.
			can_grow_active = 0
			set_temp("Error: Cannot grow [active_br.mydna.name] due to lack of synthfabs.", "danger")
		else if(!organic_capable && !active_br.synthetic) //Disqualified for the opposite.
			can_grow_active = 0
			set_temp("Error: Cannot grow [active_br.mydna.name] due to lack of cloners.", "danger")
		else if(!synthetic_capable && !organic_capable) //What have you done??
			can_grow_active = 0
			set_temp("Error: Cannot grow [active_br.mydna.name] due to lack of synthfabs and cloners.", "danger")
		else if(active_br.toocomplex)
			can_grow_active = 0
			set_temp("Error: Cannot grow [active_br.mydna.name] due to species complexity.", "danger")
		var/list/payload = list(
			activerecord = "\ref[active_br]",
			realname = sanitize(active_br.mydna.name),
			species = active_br.speciesname ? active_br.speciesname : active_br.mydna.dna.species,
			sex = active_br.bodygender,
			mind_compat = active_br.locked ? "Low" : "High",
			synthetic = active_br.synthetic,
			oocnotes = active_br.body_oocnotes ? active_br.body_oocnotes : "None",
			can_grow_active = can_grow_active,
		)
		tgui_modal_message(src, action, "", null, payload)
	else
		active_br = null
		set_temp("Error: Record missing.", "danger")

#undef MENU_MAIN
#undef MENU_BODY
#undef MENU_MIND
