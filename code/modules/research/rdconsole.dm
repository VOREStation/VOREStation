/*
Research and Development (R&D) Console

This is the main work horse of the R&D system. It contains the menus/controls for the Destructive Analyzer, Protolathe, and Circuit
imprinter. It also contains the /datum/research holder with all the known/possible technology paths and device designs.

Basic use: When it first is created, it will attempt to link up to related devices within 3 squares. It'll only link up if they
aren't already linked to another console. Any consoles it cannot link up with (either because all of a certain type are already
linked or there aren't any in range), you'll just not have access to that menu. In the settings menu, there are menu options that
allow a player to attempt to re-sync with nearby consoles. You can also force it to disconnect from a specific console.

The imprinting and construction menus do NOT require toxins access to access but all the other menus do. However, if you leave it
on a menu, nothing is to stop the person from using the options on that menu (although they won't be able to change to a different
one). You can also lock the console on the settings menu if you're feeling paranoid and you don't want anyone messing with it who
doesn't have toxins access.

When a R&D console is destroyed or even partially disassembled, you lose all research data on it. However, there are two ways around
this dire fate:
- The easiest way is to go to the settings menu and select "Sync Database with Network." That causes it to upload (but not download)
it's data to every other device in the game. Each console has a "disconnect from network" option that'll will cause data base sync
operations to skip that console. This is useful if you want to make a "public" R&D console or, for example, give the engineers
a circuit imprinter with certain designs on it and don't want it accidentally updating. The downside of this method is that you have
to have physical access to the other console to send data back. Note: An R&D console is on CentCom so if a random griffan happens to
cause a ton of data to be lost, an admin can go send it back.
- The second method is with Technology Disks and Design Disks. Each of these disks can hold a single technology or design datum in
it's entirety. You can then take the disk to any R&D console and upload it's data to it. This method is a lot more secure (since it
won't update every console in existence) but it's more of a hassle to do. Also, the disks can be stolen.
*/

/obj/machinery/computer/rdconsole
	name = "R&D control console"
	desc = "Science, in a computer! Experiment results not guaranteed."
	icon_keyboard = "rd_key"
	icon_screen = "rdcomp"
	light_color = "#a97faa"
	circuit = /obj/item/circuitboard/rdconsole
	var/datum/research/files							//Stores all the collected research data.
	var/obj/item/disk/tech_disk/t_disk = null	//Stores the technology disk.
	var/obj/item/disk/design_disk/d_disk = null	//Stores the design disk.

	var/obj/machinery/r_n_d/destructive_analyzer/linked_destroy = null	//Linked Destructive Analyzer
	var/obj/machinery/r_n_d/protolathe/linked_lathe = null				//Linked Protolathe
	var/obj/machinery/r_n_d/circuit_imprinter/linked_imprinter = null	//Linked Circuit Imprinter

	var/id = 0			//ID of the computer (for server restrictions).
	var/sync = 1		//If sync = 0, it doesn't show up on Server Control Console

	req_access = list(access_research)	//Data and setting manipulation requires scientist access.

	var/protofilter //String to filter protolathe designs by
	var/circuitfilter //String to filter circuit designs by

/obj/machinery/computer/rdconsole/proc/CallMaterialName(var/ID)
	var/return_name = ID
	switch(return_name)
		if("metal")
			return_name = "Metal"
		if("glass")
			return_name = "Glass"
		if("gold")
			return_name = "Gold"
		if("silver")
			return_name = "Silver"
		if("phoron")
			return_name = "Solid Phoron"
		if("uranium")
			return_name = "Uranium"
		if("diamond")
			return_name = "Diamond"
	return return_name

/obj/machinery/computer/rdconsole/proc/CallReagentName(var/ID)
	var/return_name = ID
	for(var/datum/reagent/R in SSchemistry.chemical_reagents)
		if(R.id == ID)
			return_name = R.name
			break
	return return_name

/obj/machinery/computer/rdconsole/proc/SyncRDevices() //Makes sure it is properly sync'ed up with the devices attached to it (if any).
	for(var/obj/machinery/r_n_d/D in range(3, src))
		if(D.linked_console != null || D.panel_open)
			continue
		if(istype(D, /obj/machinery/r_n_d/destructive_analyzer))
			if(linked_destroy == null)
				linked_destroy = D
				D.linked_console = src
		else if(istype(D, /obj/machinery/r_n_d/protolathe))
			if(linked_lathe == null)
				linked_lathe = D
				D.linked_console = src
		else if(istype(D, /obj/machinery/r_n_d/circuit_imprinter))
			if(linked_imprinter == null)
				linked_imprinter = D
				D.linked_console = src
	return

/obj/machinery/computer/rdconsole/proc/griefProtection() //Have it automatically push research to the CentCom server so wild griffins can't fuck up R&D's work
	for(var/obj/machinery/r_n_d/server/centcom/C in machines)
		for(var/datum/tech/T in files.known_tech)
			C.files.AddTech2Known(T)
		for(var/datum/design/D in files.known_designs)
			C.files.AddDesign2Known(D)
		C.files.RefreshResearch()

/obj/machinery/computer/rdconsole/New()
	..()
	files = new /datum/research(src) //Setup the research data holder.
	if(!id)
		for(var/obj/machinery/r_n_d/server/centcom/S in machines)
			S.update_connections()
			break

/obj/machinery/computer/rdconsole/Initialize()
	SyncRDevices()
	. = ..()

/obj/machinery/computer/rdconsole/attackby(var/obj/item/D as obj, var/mob/user as mob)
	//Loading a disk into it.
	if(istype(D, /obj/item/disk))
		if(t_disk || d_disk)
			to_chat(user, "A disk is already loaded into the machine.")
			return

		if(istype(D, /obj/item/disk/tech_disk))
			t_disk = D
		else if (istype(D, /obj/item/disk/design_disk))
			d_disk = D
		else
			to_chat(user, "<span class='notice'>Machine cannot accept disks in that format.</span>")
			return
		user.drop_item()
		D.loc = src
		to_chat(user, "<span class='notice'>You add \the [D] to the machine.</span>")
	else
		//The construction/deconstruction of the console code.
		..()

	SStgui.update_uis(src)
	return

/obj/machinery/computer/rdconsole/emp_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		playsound(src, 'sound/effects/sparks4.ogg', 75, 1)
		emagged = 1
		to_chat(user, "<span class='notice'>You you disable the security protocols.</span>")
		return 1

<<<<<<< HEAD
=======
/obj/machinery/computer/rdconsole/Topic(href, href_list)
	if(..())
		return 1

	add_fingerprint(usr)

	usr.set_machine(src)
	if((screen < 1 || (screen == 1.6 && href_list["menu"] != "1.0")) && (!allowed(usr) && !emagged)) //Stops people from HREF exploiting out of the lock screen, but allow it if they have the access.
		to_chat(usr, "Unauthorized Access")
		return

	if(href_list["menu"]) //Switches menu screens. Converts a sent text string into a number. Saves a LOT of code.
		var/temp_screen = text2num(href_list["menu"])
		if(temp_screen <= 1.1 || (3 <= temp_screen && 4.9 >= temp_screen) || allowed(usr) || emagged) //Unless you are making something, you need access.
			screen = temp_screen
		else
			to_chat(usr, "Unauthorized Access.")

	else if(href_list["updt_tech"]) //Update the research holder with information from the technology disk.
		screen = 0.0
		spawn(5 SECONDS)
			screen = 1.2
			files.AddTech2Known(t_disk.stored)
			updateUsrDialog()
			griefProtection() //Update CentCom too

	else if(href_list["clear_tech"]) //Erase data on the technology disk.
		t_disk.stored = null

	else if(href_list["eject_tech"]) //Eject the technology disk.
		t_disk.loc = loc
		t_disk = null
		screen = 1.0

	else if(href_list["copy_tech"]) //Copys some technology data from the research holder to the disk.
		for(var/datum/tech/T in files.known_tech)
			if(href_list["copy_tech_ID"] == T.id)
				t_disk.stored = T
				break
		screen = 1.2

	else if(href_list["updt_design"]) //Updates the research holder with design data from the design disk.
		screen = 0.0
		spawn(5 SECONDS)
			screen = 1.4
			files.AddDesign2Known(d_disk.blueprint)
			updateUsrDialog()
			griefProtection() //Update CentCom too

	else if(href_list["clear_design"]) //Erases data on the design disk.
		d_disk.blueprint = null

	else if(href_list["eject_design"]) //Eject the design disk.
		d_disk.loc = loc
		d_disk = null
		screen = 1.0

	else if(href_list["copy_design"]) //Copy design data from the research holder to the design disk.
		for(var/datum/design/D in files.known_designs)
			if(href_list["copy_design_ID"] == D.id)
				d_disk.blueprint = D
				break
		screen = 1.4

	else if(href_list["eject_item"]) //Eject the item inside the destructive analyzer.
		if(linked_destroy)
			if(linked_destroy.busy)
				to_chat(usr, "<span class='notice'>The destructive analyzer is busy at the moment.</span>")

			else if(linked_destroy.loaded_item)
				linked_destroy.loaded_item.loc = linked_destroy.loc
				linked_destroy.loaded_item = null
				linked_destroy.icon_state = "d_analyzer"
				screen = 2.1

	else if(href_list["deconstruct"]) //Deconstruct the item in the destructive analyzer and update the research holder.
		if(linked_destroy)
			if(linked_destroy.busy)
				to_chat(usr, "<span class='notice'>The destructive analyzer is busy at the moment.</span>")
			else
				if(alert("Proceeding will destroy loaded item. Continue?", "Destructive analyzer confirmation", "Yes", "No") == "No" || !linked_destroy)
					return
				linked_destroy.busy = 1
				screen = 0.1
				updateUsrDialog()
				flick("d_analyzer_process", linked_destroy)
				spawn(2.4 SECONDS)
					if(linked_destroy)
						linked_destroy.busy = 0
						if(!linked_destroy.loaded_item)
							to_chat(usr, "<span class='notice'>The destructive analyzer appears to be empty.</span>")
							screen = 1.0
							return

						for(var/T in linked_destroy.loaded_item.origin_tech)
							files.UpdateTech(T, linked_destroy.loaded_item.origin_tech[T])
						if(linked_lathe && linked_destroy.loaded_item.matter) // Also sends salvaged materials to a linked protolathe, if any.
							for(var/t in linked_destroy.loaded_item.matter)
								if(t in linked_lathe.materials)
									linked_lathe.materials[t] += min(linked_lathe.max_material_storage - linked_lathe.TotalMaterials(), linked_destroy.loaded_item.matter[t] * linked_destroy.decon_mod)

						linked_destroy.loaded_item = null
						for(var/obj/I in linked_destroy.contents)
							for(var/mob/M in I.contents)
								playsound(linked_destroy, 'sound/machines/destructive_analyzer.ogg', 50, 1)
								M.death()
							if(istype(I,/obj/item/stack/material))//Only deconsturcts one sheet at a time instead of the entire stack
								var/obj/item/stack/material/S = I
								if(S.get_amount() > 1)
									playsound(linked_destroy, 'sound/machines/destructive_analyzer.ogg', 50, 1)
									S.use(1)
									linked_destroy.loaded_item = S
								else
									playsound(linked_destroy, 'sound/machines/destructive_analyzer.ogg', 50, 1)
									qdel(S)
									linked_destroy.icon_state = "d_analyzer"
							else
								if(I != linked_destroy.circuit && !(I in linked_destroy.component_parts))
									playsound(linked_destroy, 'sound/machines/destructive_analyzer.ogg', 50, 1)
									qdel(I)
									linked_destroy.icon_state = "d_analyzer"

						use_power(linked_destroy.active_power_usage)
						screen = 1.0
						updateUsrDialog()

	else if(href_list["lock"]) //Lock the console from use by anyone without tox access.
		if(allowed(usr))
			screen = text2num(href_list["lock"])
		else
			to_chat(usr, "Unauthorized Access.")

	else if(href_list["sync"]) //Sync the research holder with all the R&D consoles in the game that aren't sync protected.
		screen = 0.0
		if(!sync)
			to_chat(usr, "<span class='notice'>You must connect to the network first.</span>")
		else
			griefProtection() //Putting this here because I dont trust the sync process
			spawn(3 SECONDS)
				if(src)
					for(var/obj/machinery/r_n_d/server/S in machines)
						var/server_processed = 0
						if((id in S.id_with_upload) || istype(S, /obj/machinery/r_n_d/server/centcom))
							for(var/datum/tech/T in files.known_tech)
								S.files.AddTech2Known(T)
							for(var/datum/design/D in files.known_designs)
								S.files.AddDesign2Known(D)
							S.files.RefreshResearch()
							server_processed = 1
						if((id in S.id_with_download) && !istype(S, /obj/machinery/r_n_d/server/centcom))
							for(var/datum/tech/T in S.files.known_tech)
								files.AddTech2Known(T)
							for(var/datum/design/D in S.files.known_designs)
								files.AddDesign2Known(D)
							files.RefreshResearch()
							server_processed = 1
						if(!istype(S, /obj/machinery/r_n_d/server/centcom) && server_processed)
							S.produce_heat()
					screen = 1.6
					updateUsrDialog()

	else if(href_list["togglesync"]) //Prevents the console from being synced by other consoles. Can still send data.
		sync = !sync

	else if(href_list["build"]) //Causes the Protolathe to build something.
		if(linked_lathe)
			var/datum/design/being_built = null
			for(var/datum/design/D in files.known_designs)
				if(D.id == href_list["build"])
					being_built = D
					break
			if(being_built)
				linked_lathe.addToQueue(being_built)

	else if(href_list["buildfive"]) //Causes the Protolathe to build 5 of something.
		if(linked_lathe)
			var/datum/design/being_built = null
			for(var/datum/design/D in files.known_designs)
				if(D.id == href_list["buildfive"])
					being_built = D
					break
			if(being_built)
				for(var/i = 1 to 5)
					linked_lathe.addToQueue(being_built)

		screen = 3.1

	else if(href_list["protofilter"])
		var/filterstring = input(usr, "Input a filter string, or blank to not filter:", "Design Filter", protofilter) as null|text
		if(!Adjacent(usr))
			return
		if(isnull(filterstring)) //Clicked Cancel
			return
		if(filterstring == "") //Cleared value
			protofilter = null
		protofilter = sanitize(filterstring, 25)

	else if(href_list["circuitfilter"])
		var/filterstring = input(usr, "Input a filter string, or blank to not filter:", "Design Filter", circuitfilter) as null|text
		if(!Adjacent(usr))
			return
		if(isnull(filterstring)) //Clicked Cancel
			return
		if(filterstring == "") //Cleared value
			circuitfilter = null
		circuitfilter = sanitize(filterstring, 25)

	else if(href_list["imprint"]) //Causes the Circuit Imprinter to build something.
		if(linked_imprinter)
			var/datum/design/being_built = null
			for(var/datum/design/D in files.known_designs)
				if(D.id == href_list["imprint"])
					being_built = D
					break
			if(being_built)
				linked_imprinter.addToQueue(being_built)
		screen = 4.1

	else if(href_list["disposeI"] && linked_imprinter)  //Causes the circuit imprinter to dispose of a single reagent (all of it)
		linked_imprinter.reagents.del_reagent(href_list["dispose"])

	else if(href_list["disposeallI"] && linked_imprinter) //Causes the circuit imprinter to dispose of all it's reagents.
		linked_imprinter.reagents.clear_reagents()

	else if(href_list["removeI"] && linked_lathe)
		linked_imprinter.removeFromQueue(text2num(href_list["removeI"]))

	else if(href_list["disposeP"] && linked_lathe)  //Causes the protolathe to dispose of a single reagent (all of it)
		linked_lathe.reagents.del_reagent(href_list["dispose"])

	else if(href_list["disposeallP"] && linked_lathe) //Causes the protolathe to dispose of all it's reagents.
		linked_lathe.reagents.clear_reagents()

	else if(href_list["removeP"] && linked_lathe)
		linked_lathe.removeFromQueue(text2num(href_list["removeP"]))

	else if(href_list["lathe_ejectsheet"] && linked_lathe) //Causes the protolathe to eject a sheet of material
		linked_lathe.eject(href_list["lathe_ejectsheet"], text2num(href_list["amount"]))

	else if(href_list["imprinter_ejectsheet"] && linked_imprinter) //Causes the protolathe to eject a sheet of material
		linked_imprinter.eject(href_list["imprinter_ejectsheet"], text2num(href_list["amount"]))

	else if(href_list["find_device"]) //The R&D console looks for devices nearby to link up with.
		screen = 0.0
		spawn(10)
			SyncRDevices()
			screen = 1.7
			updateUsrDialog()

	else if(href_list["disconnect"]) //The R&D console disconnects with a specific device.
		switch(href_list["disconnect"])
			if("destroy")
				linked_destroy.linked_console = null
				linked_destroy = null
			if("lathe")
				linked_lathe.linked_console = null
				linked_lathe = null
			if("imprinter")
				linked_imprinter.linked_console = null
				linked_imprinter = null

	else if(href_list["reset"]) //Reset the R&D console's database.
		griefProtection()
		var/choice = alert("R&D Console Database Reset", "Are you sure you want to reset the R&D console's database? Data lost cannot be recovered.", "Continue", "Cancel")
		if(choice == "Continue")
			screen = 0.0
			qdel(files)
			files = new /datum/research(src)
			spawn(20)
				screen = 1.6
				updateUsrDialog()

	else if (href_list["print"]) //Print research information
		screen = 0.5
		spawn(20)
			var/obj/item/paper/PR = new/obj/item/paper
			PR.name = "list of researched technologies"
			PR.info = "<center><b>[station_name()] Science Laboratories</b>"
			PR.info += "<h2>[ (text2num(href_list["print"]) == 2) ? "Detailed" : null] Research Progress Report</h2>"
			PR.info += "<i>report prepared at [stationtime2text()] station time</i></center><br>"
			if(text2num(href_list["print"]) == 2)
				PR.info += GetResearchListInfo()
			else
				PR.info += GetResearchLevelsInfo()
			PR.info_links = PR.info
			PR.icon_state = "paper_words"
			PR.loc = src.loc
			spawn(10)
				screen = ((text2num(href_list["print"]) == 2) ? 5.0 : 1.1)
				updateUsrDialog()

	updateUsrDialog()
	return

>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
/obj/machinery/computer/rdconsole/proc/GetResearchLevelsInfo()
	var/list/dat = list()
	dat += "<UL>"
	for(var/datum/tech/T in files.known_tech)
		if(T.level < 1)
			continue
		dat += "<LI>"
		dat += "[T.name]"
		dat += "<UL>"
		dat +=  "<LI>Level: [T.level]"
		dat +=  "<LI>Summary: [T.desc]"
		dat += "</UL>"
	return dat.Join()

/obj/machinery/computer/rdconsole/proc/GetResearchListInfo()
	var/list/dat = list()
	dat += "<UL>"
	for(var/datum/design/D in files.known_designs)
		if(D.build_path)
			dat += "<LI><B>[D.name]</B>: [D.desc]"
	dat += "</UL>"
	return dat.Join()

/obj/machinery/computer/rdconsole/attack_hand(mob/user as mob)
	if(stat & (BROKEN|NOPOWER))
		return

	tgui_interact(user) // TODO: remove the other UI

/obj/machinery/computer/rdconsole/robotics
	name = "Robotics R&D Console"
	id = 2
	req_access = list(access_robotics)

/obj/machinery/computer/rdconsole/core
	name = "Core R&D Console"
	id = 1
