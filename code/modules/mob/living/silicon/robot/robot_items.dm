//A portable analyzer, for research borgs.  This is better then giving them a gripper which can hold anything and letting them use the normal analyzer.
/obj/item/portable_destructive_analyzer
	name = "Portable Destructive Analyzer"
	icon = 'icons/obj/items.dmi'
	icon_state = "portable_analyzer"
	desc = "Similar to the stationary version, this rather unwieldy device allows you to break down objects in the name of science."

	var/min_reliability = 90 //Can't upgrade, call it laziness or a drawback

	var/datum/research/techonly/files 	//The device uses the same datum structure as the R&D computer/server.
										//This analyzer can only store tech levels, however.

	var/obj/item/loaded_item	//What is currently inside the analyzer.

/obj/item/portable_destructive_analyzer/New()
	..()
	files = new /datum/research/techonly(src) //Setup the research data holder.

/obj/item/portable_destructive_analyzer/attack_self(user as mob)
	var/response = tgui_alert(user, 	"Analyzing the item inside will *DESTROY* the item for good.\n\
							Syncing to the research server will send the data that is stored inside to research.\n\
							Ejecting will place the loaded item onto the floor.",
							"What would you like to do?", list("Analyze", "Sync", "Eject"))
	if(response == "Analyze")
		if(loaded_item)
			var/confirm = tgui_alert(user, "This will destroy the item inside forever. Are you sure?","Confirm Analyze",list("Yes","No"))
			if(confirm == "Yes" && !QDELETED(loaded_item)) //This is pretty copypasta-y
				to_chat(user, "<span class='filter_notice'>You activate the analyzer's microlaser, analyzing \the [loaded_item] and breaking it down.</span>")
				flick("portable_analyzer_scan", src)
				playsound(src, 'sound/items/Welder2.ogg', 50, 1)
				var/research_levels = list()
				for(var/T in loaded_item.origin_tech)
					files.UpdateTech(T, loaded_item.origin_tech[T])
					research_levels += "\The [loaded_item] had level [loaded_item.origin_tech[T]] in [CallTechName(T)]."
				if (length(research_levels))
					to_chat(user, "<span class='filter_notice'>[jointext(research_levels,"<br>")]</span>")
				loaded_item = null
				for(var/obj/I in contents)
					for(var/mob/M in I.contents)
						M.death()
					if(istype(I,/obj/item/stack/material))//Only deconstructs one sheet at a time instead of the entire stack
						var/obj/item/stack/material/S = I
						if(S.get_amount() > 1)
							S.use(1)
							loaded_item = S
						else
							qdel(S)
							desc = initial(desc)
							icon_state = initial(icon_state)
					else
						qdel(I)
						desc = initial(desc)
						icon_state = initial(icon_state)
			else
				return
		else
			to_chat(user, "<span class='filter_notice'>The [src] is empty.  Put something inside it first.</span>")
	if(response == "Sync")
		var/success = 0
		for(var/obj/machinery/r_n_d/server/S in machines)
			for(var/datum/tech/T in files.known_tech) //Uploading
				S.files.AddTech2Known(T)
			for(var/datum/tech/T in S.files.known_tech) //Downloading
				files.AddTech2Known(T)
			success = 1
			files.RefreshResearch()
		if(success)
			to_chat(user, "<span class='filter_notice'>You connect to the research server, push your data upstream to it, then pull the resulting merged data from the master branch.</span>")
			playsound(src, 'sound/machines/twobeep.ogg', 50, 1)
		else
			to_chat(user, "<span class='filter_notice'>Reserch server ping response timed out.  Unable to connect.  Please contact the system administrator.</span>")
			playsound(src, 'sound/machines/buzz-two.ogg', 50, 1)
	if(response == "Eject")
		if(loaded_item)
			loaded_item.loc = get_turf(src)
			desc = initial(desc)
			icon_state = initial(icon_state)
			loaded_item = null
		else
			to_chat(user, "<span class='filter_notice'>The [src] is already empty.</span>")


/obj/item/portable_destructive_analyzer/afterattack(var/atom/target, var/mob/living/user, proximity)
	if(!target)
		return
	if(!proximity)
		return
	if(!isturf(target.loc)) // Don't load up stuff if it's inside a container or mob!
		return
	if(istype(target,/obj/item))
		if(loaded_item)
			to_chat(user, "<span class='filter_notice'>Your [src] already has something inside.  Analyze or eject it first.</span>")
			return
		var/obj/item/I = target
		I.loc = src
		loaded_item = I
		for(var/mob/M in viewers())
			M.show_message("<span class='notice'>[user] adds the [I] to the [src].</span>", 1)
		desc = initial(desc) + "<br>It is holding \the [loaded_item]."
		flick("portable_analyzer_load", src)
		icon_state = "portable_analyzer_full"

/obj/item/portable_scanner
	name = "Portable Resonant Analyzer"
	icon = 'icons/obj/items.dmi'
	icon_state = "portable_scanner"
	desc = "An advanced scanning device used for analyzing objects without completely annihilating them for science. Unfortunately, it has no connection to any database like its angrier cousin."

/obj/item/portable_scanner/afterattack(var/atom/target, var/mob/living/user, proximity)
	if(!target)
		return
	if(!proximity)
		return
	if(istype(target,/obj/item))
		var/obj/item/I = target
		if(do_after(src, 5 SECONDS * I.w_class))
			for(var/mob/M in viewers())
				M.show_message(text("<span class='notice'>[user] sweeps \the [src] over \the [I].</span>"), 1)
			flick("[initial(icon_state)]-scan", src)
			if(I.origin_tech && I.origin_tech.len)
				for(var/T in I.origin_tech)
					to_chat(user, "<span class='notice'>\The [I] had level [I.origin_tech[T]] in [CallTechName(T)].</span>")
			else
				to_chat(user, "<span class='notice'>\The [I] cannot be scanned by \the [src].</span>")

//This is used to unlock other borg covers.
/obj/item/card/robot //This is not a child of id cards, as to avoid dumb typechecks on computers.
	name = "access code transmission device"
	icon_state = "id-robot"
	desc = "A circuit grafted onto the bottom of an ID card.  It is used to transmit access codes into other robot chassis, \
	allowing you to lock and unlock other robots' panels."

	var/dummy_card = null
	var/dummy_card_type = /obj/item/card/id/science/roboticist/dummy_cyborg

/obj/item/card/robot/Initialize()
	. = ..()
	dummy_card = new dummy_card_type(src)

/obj/item/card/robot/Destroy()
	qdel(dummy_card)
	dummy_card = null
	..()

/obj/item/card/robot/GetID()
	return dummy_card

/obj/item/card/robot/syndi
	dummy_card_type = /obj/item/card/id/syndicate/dummy_cyborg

/obj/item/card/id/science/roboticist/dummy_cyborg
	access = list(access_robotics)

/obj/item/card/id/syndicate/dummy_cyborg/Initialize()
	. = ..()
	access |= access_robotics

//A harvest item for serviceborgs.
/obj/item/robot_harvester
	name = "auto harvester"
	desc = "A hand-held harvest tool that resembles a sickle.  It uses energy to cut plant matter very efficently."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "autoharvester"

/obj/item/robot_harvester/afterattack(var/atom/target, var/mob/living/user, proximity)
	if(!target)
		return
	if(!proximity)
		return
	if(istype(target,/obj/machinery/portable_atmospherics/hydroponics))
		var/obj/machinery/portable_atmospherics/hydroponics/T = target
		if(T.harvest) //Try to harvest, assuming it's alive.
			T.harvest(user)
		else if(T.dead) //It's probably dead otherwise.
			T.remove_dead(user)
	else
		to_chat(user, "<span class='filter_notice'>Harvesting \a [target] is not the purpose of this tool. [src] is for plants being grown.</span>")

// A special tray for the service droid. Allow droid to pick up and drop items as if they were using the tray normally
// Click on table to unload, click on item to load. Otherwise works identically to a tray.
// Unlike the base item "tray", robotrays ONLY pick up food, drinks and condiments.

/obj/item/tray/robotray
	name = "RoboTray"
	desc = "An autoloading tray specialized for carrying refreshments."

/obj/item/tray/robotray/afterattack(atom/target, mob/user as mob, proximity)
	if(!proximity)
		return
	if ( !target )
		return
	// pick up items, mostly copied from base tray pickup proc
	// see code\game\objects\items\weapons\kitchen.dm line 241
	if ( istype(target,/obj/item))
		if ( !isturf(target.loc) ) // Don't load up stuff if it's inside a container or mob!
			return
		var turf/pickup = target.loc

		var addedSomething = 0

		for(var/obj/item/reagent_containers/food/I in pickup)


			if( I != src && !I.anchored && !istype(I, /obj/item/clothing/under) && !istype(I, /obj/item/clothing/suit) && !istype(I, /obj/item/projectile) )
				var/add = 0
				if(I.w_class == ITEMSIZE_TINY)
					add = 1
				else if(I.w_class == ITEMSIZE_SMALL)
					add = 3
				else
					add = 5
				if(calc_carry() + add >= max_carry)
					break

				I.loc = src
				carrying.Add(I)
				add_overlay(image("icon" = I.icon, "icon_state" = I.icon_state, "layer" = 30 + I.layer))
				addedSomething = 1
		if ( addedSomething )
			user.visible_message("<span class='notice'>[user] loads some items onto their service tray.</span>")

		return

	// Unloads the tray, copied from base item's proc dropped() and altered
	// see code\game\objects\items\weapons\kitchen.dm line 263

	if ( isturf(target) || istype(target,/obj/structure/table) )
		var foundtable = istype(target,/obj/structure/table/)
		if ( !foundtable ) //it must be a turf!
			for(var/obj/structure/table/T in target)
				foundtable = 1
				break

		var turf/dropspot
		if ( !foundtable ) // don't unload things onto walls or other silly places.
			dropspot = user.loc
		else if ( isturf(target) ) // they clicked on a turf with a table in it
			dropspot = target
		else					// they clicked on a table
			dropspot = target.loc


		overlays = null

		var droppedSomething = 0

		for(var/obj/item/I in carrying)
			I.loc = dropspot
			carrying.Remove(I)
			droppedSomething = 1
			if(!foundtable && isturf(dropspot))
				// if no table, presume that the person just shittily dropped the tray on the ground and made a mess everywhere!
				spawn()
					for(var/i = 1, i <= rand(1,2), i++)
						if(I)
							step(I, pick(NORTH,SOUTH,EAST,WEST))
							sleep(rand(2,4))
		if ( droppedSomething )
			if ( foundtable )
				user.visible_message("<span class='notice'>[user] unloads their service tray.</span>")
			else
				user.visible_message("<span class='notice'>[user] drops all the items on their tray.</span>")

	return ..()




// A special pen for service droids. Can be toggled to switch between normal writting mode, and paper rename mode
// Allows service droids to rename paper items.

/obj/item/pen/robopen
	desc = "A black ink printing attachment with a paper naming mode."
	name = "Printing Pen"
	var/mode = 1

/obj/item/pen/robopen/attack_self(mob/user as mob)

	var/choice = tgui_alert(usr, "Would you like to change colour or mode?", "Change What?", list("Colour","Mode","Cancel"))
	if(!choice || choice == "Cancel")
		return

	playsound(src, 'sound/effects/pop.ogg', 50, 0)

	switch(choice)

		if("Colour")
			var/newcolour = tgui_input_list(usr, "Which colour would you like to use?", "Color Choice", list("black","blue","red","green","yellow"))
			if(newcolour) colour = newcolour

		if("Mode")
			if (mode == 1)
				mode = 2
			else
				mode = 1
			to_chat(user, "<span class='filter_notice'>Changed printing mode to '[mode == 2 ? "Rename Paper" : "Write Paper"]'</span>")

	return

// Copied over from paper's rename verb
// see code\modules\paperwork\paper.dm line 62

/obj/item/pen/robopen/proc/RenamePaper(mob/user, obj/item/paper/paper)
	if ( !user || !paper )
		return
	var/n_name = sanitizeSafe(tgui_input_text(user, "What would you like to label the paper?", "Paper Labelling", null, 32), 32)
	if ( !user || !paper )
		return

	//n_name = copytext(n_name, 1, 32)
	if(( get_dist(user,paper) <= 1  && user.stat == 0))
		paper.name = "paper[(n_name ? text("- '[n_name]'") : null)]"
		paper.last_modified_ckey = user.ckey
	add_fingerprint(user)
	return

//TODO: Add prewritten forms to dispense when you work out a good way to store the strings.
/obj/item/form_printer
	name = "paperwork printer"
	//name = "paper dispenser"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "doc_printer_mod_pre"
	item_icons = list(
			slot_l_hand_str = 'icons/mob/items/lefthand_material.dmi',
			slot_r_hand_str = 'icons/mob/items/righthand_material.dmi',
			)
	item_state = "sheet-metal"

/obj/item/form_printer/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	return

/obj/item/form_printer/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, flag, params)

	if(!target || !flag)
		return

	if(istype(target,/obj/structure/table))
		deploy_paper(get_turf(target))

/obj/item/form_printer/attack_self(mob/user as mob)
	deploy_paper()

/obj/item/form_printer/proc/deploy_paper()
	var/choice = tgui_alert(usr, "Would you like dispense and empty page or print a form?", "Dispense", list("Paper","Form"))
	if(!choice || choice == "Cancel")
		return
	switch(choice)
		if("Paper")
			flick("doc_printer_mod_ejecting", src)
			spawn(22)
				var/turf/T = get_turf(src)
				T.visible_message("<span class='notice'>\The [src.loc] dispenses a sheet of crisp white paper.</span>")
				new /obj/item/paper(T)
		if ("Form")
			var/list/content = print_form()
			if(!content)
				to_chat(usr, "<span class='warning'>No form for this category found in central network. Central is advising employees to upload new forms whenever possible.</span>")
				return
			flick("doc_printer_mod_printing", src)
			spawn(22)
				var/turf/T = get_turf(src)
				T.visible_message("<span class='notice'>\The [src.loc] dispenses an official form to fill.</span>")
				new /obj/item/paper(T, content[1], content[2])

/obj/item/form_printer/proc/print_form()
	var/list/paper_forms = list("Empty", "Command", "Security", "Supply", "Science", "Medical", "Engineering", "Service", "Exploration", "Event", "Other", "Mercenary")
	var/list/command_paper_forms = list("COM-0002: Dismissal Order", "COM-0003: Job Change Request", "COM-0004: ID Replacement Request", "COM-0005: Access Change Order", "COM-0006: Formal Complaint", "COM-0009: Visitor Permit", "COM-0012: Personnel Request Form", "COM-0013: Employee of the Month Nomination Form")
	var/list/security_paper_forms = list("SEC-1001: Shift-Start Checklist", "SEC-1002: Patrol Assignment Sheet", "SEC-1003: Incident Report", "SEC-1004: Arrest Report", "SEC-1005: Arrest Warrant", "SEC-1006: Search Warrant", "SEC-1007: Forensics Investigation Report", "SEC-1008: Interrogation Report", "SEC-1009: Witness Statement", "SEC-1010: Armory Inventory", "SEC-1011: Armory Equipment Request", "SEC-1012: Armory Equipment Deployment", "SEC-1013: Weapon Permit", "SEC-1014: Injunction", "SEC-1015: Deputization Waiver")
	var/list/supply_paper_forms = list("SUP-2001: Delivery of Goods", "SUP-2002: Delivery of Resources", "SUP-2003: Material Stock")
	var/list/science_paper_forms = list("SCI-3003: Cyborg / Robot Inspection", "SCI-3004: Cyborg / Robot Upgrades", "SCI-3009: Xenoflora Genetics Report")
	var/list/medical_paper_forms = list("MED-4001: Death Certificate", "MED-4002: Prescription", "MED-4003: Against Medical Advice", "MED-4004: Cyborgification Contract", "MED-4005: Mental Health Patient Intake", "MED-4006: NIF Surgery", "MED-4007: Psychiatric Evaluation")
	var/list/engineering_paper_forms = list("ENG-5001: Building Permit")
	var/list/service_paper_forms = list("SER-6005: Certificate of Marriage")
	var/list/exploration_paper_forms = list()
	var/list/event_paper_forms = list()
	var/list/other_paper_forms = list("OTHR-9001: Emergency Transmission", "OTHR-9032: Ownership Transfer")
	var/list/mercenary_paper_forms = list("MERC-?071: Mercenary Request")

	var/list/split = list()
	var/papertype = tgui_input_list(usr, "What kind of form do you want to print?", "Department", paper_forms)
	if(!papertype || papertype == "Cancel")
		return
	switch(papertype)
		if ("Empty")
			split = list("", "Empty form")
		if("Command")
			var/command_paper = tgui_input_list(usr, "What kind of command form do you want to print?", "Form", command_paper_forms)
			if(!command_paper || command_paper == "Cancel")
				return
			split = splittext(command_paper, ": ")
		if("Security")
			var/security_paper = tgui_input_list(usr, "What kind of security form do you want to print?", "Form", security_paper_forms)
			if(!security_paper || security_paper == "Cancel")
				return
			split = splittext(security_paper, ": ")
		if("Supply")
			var/supply_paper = tgui_input_list(usr, "What kind of supply form do you want to print?", "Form", supply_paper_forms)
			if(!supply_paper || supply_paper == "Cancel")
				return
			split = splittext(supply_paper, ": ")
		if("Science")
			var/science_paper = tgui_input_list(usr, "What kind of science form do you want to print?", "Form", science_paper_forms)
			if(!science_paper || science_paper == "Cancel")
				return
			split = splittext(science_paper, ": ")
		if("Medical")
			var/medical_paper = tgui_input_list(usr, "What kind of medical form do you want to print?", "Form", medical_paper_forms)
			if(!medical_paper || medical_paper == "Cancel")
				return
			split = splittext(medical_paper, ": ")
		if("Engineering")
			var/engineering_paper = tgui_input_list(usr, "What kind of engineering form do you want to print?", "Form", engineering_paper_forms)
			if(!engineering_paper || engineering_paper == "Cancel")
				return
			split = splittext(engineering_paper, ": ")
		if("Service")
			var/service_paper = tgui_input_list(usr, "What kind of service form do you want to print?", "Form", service_paper_forms)
			if(!service_paper || service_paper == "Cancel")
				return
			split = splittext(service_paper, ": ")
		if("Exploration")
			var/exploration_paper = tgui_input_list(usr, "What kind of exploration form do you want to print?", "Form", exploration_paper_forms)
			if(!exploration_paper || exploration_paper == "Cancel")
				return
			split = splittext(exploration_paper, ": ")
		if("Event")
			var/event_paper = tgui_input_list(usr, "What kind of event form do you want to print?", "Form", event_paper_forms)
			if(!event_paper || event_paper == "Cancel")
				return
			split = splittext(event_paper, ": ")
		if("Other")
			var/other_paper = tgui_input_list(usr, "What kind of other form do you want to print?", "Form", other_paper_forms)
			if(!other_paper || other_paper == "Cancel")
				return
			split = splittext(other_paper, ": ")
		if("Mercenary")
			var/mercenary_paper = tgui_input_list(usr, "What kind of mercenary form do you want to print?", "Form", mercenary_paper_forms)
			if(!mercenary_paper || mercenary_paper == "Cancel")
				return
			split = splittext(mercenary_paper, ": ")
		else
			return
	return list(select_form(split[1], split[2]), split[1] + ": " + split[2])

/obj/item/form_printer/proc/select_form(paperid, name)
	var/content = ""
	var/revision = ""
	switch(paperid)
		//Command forms, COM-0
		if("COM-0002")
			content = @{"[grid][row][cell][b]Employee:[/b] [cell][field][br][row][cell][b]Position:[/b] [cell][field][/grid][br][hr][br][b]Reason:[/b] [field][br][br][hr][grid][row][cell][list][b]Signature of relevant Head of Staff:[/b][/list][cell][list][list][list][list][list][b]Head of Personnel signature:[/b][/list][/list][/list][/list][/list][cell][br][row][cell][list] - [large][field][/large][/list][cell][list][list][list][list][list]- [large][field][/large][/list][/list][/list][/list][/list][cell][/grid]"}
			revision = "Revision: 1.3"
		if("COM-0003")
			content = @{"[grid][row][cell][b]Employee:[/b] [cell][field][br][row][cell][b]Current Position:[/b] [cell][field][br][row][cell][b]Requested Position:[/b] [cell][field][/grid][br][hr][br][b]Reason:[/b] [field][br][br][hr][grid][row][cell][list][b]Employee signature[/b][/list][cell][cell][br][row][cell][list]- [field][/list][cell][cell][br][row][cell][cell][cell][br][row][cell][list][b]Transferring department head signature:[/b][cell][list][list][list][list][list][b]Receiving department head signature:[/b][/list][/list][/list][/list][/list][cell][br][row][cell][list] - [large][field][/large][cell][list][list][list][list][list]- [large][field][/large][/list][/list][/list][/list][/list][cell][br][row][cell][cell][cell][br][row][cell][list][b]Head of Personnel signature[/b][/list][cell][cell][br][row][cell][list]- [large][field][/large][/list][cell][cell][/grid][hr][br][list][small][*]All department heads must agree to the transfer before transfer can take place.[br][*]If the transferred has been transferred for an invalid or illegal reason, this form is immediately void and unlawful.[br][*]In the event a relevant head of staff retracts his or her approval for this transfer, this form is immediately void and unlawful.[/small][/list]"}
			revision = "Revision: 1.3"
		if("COM-0004")
			content = @{"[grid][row][cell][b]Employee:[/b] [cell][field][br][row][cell][b]Position:[/b] [cell][field][br][row][cell][cell][br][row][cell][b]Reason:[/b] [cell][/grid][br][table][row][cell]Lost[cell][field][br][row][cell]Damaged[cell][field][/table][br][hr][grid][row][cell][list][b]Employee signature[/b][/list][cell][cell][br][row][cell][list]- [field][/list][cell][cell][br][row][cell][cell][cell][br][row][cell][list][b]Signature of relevant Head of Staff:[/b][/list][cell][list][list][list][list][list][b]Head of Personnel signature:[/b][/list][/list][/list][/list][/list][cell][br][row][cell][list] - [large][field][/large][/list][cell][list][list][list][list][list]- [large][field][/large][/list][/list][/list][/list][/list][cell][/grid][hr][br][list][small][*]ID card requests fall under the fair use policy COM-0099.[br][*]NanoTrasen withholds the right to deny and and all applications for a replacement ID, dependent on policy COM-0099.[br][*]Excessive ID loss or damage as agreed on COM-0099 is to be compensated for out of personal income and account as specified under COM-0098.[/small][/list]"}
			revision = "Revision: 1.8"
		if("COM-0005")
			content = @{"[grid][row][cell][b]Employee:[/b] [cell][field][br][row][cell][b]Position:[/b] [cell][field][br][row][cell][cell][br][row][cell][b]Access:[/b] [cell][field][/grid][br][hr][br][b]Reason:[/b] [field][br][br][hr][grid][row][cell][list][b]Employee signature[/b][/list][cell][cell][br][row][cell][list]- [field][/list][cell][cell][br][row][cell][cell][cell][br][row][cell][list][b]Signature of relevant Head of Staff:[/b][/list][cell][list][list][list][list][list][b]Head of Personnel signature:[/b][/list][/list][/list][/list][/list][cell][br][row][cell][list] - [large][field][/large][/list][cell][list][list][list][list][list]- [large][field][/large][/list][/list][/list][/list][/list][cell][/grid]"}
			revision = "Revision: 1.7"
		if("COM-0006")
			content = @{"[grid][row][cell][b]Employee:[/b] [cell][field][br][row][cell][b]Position:[/b] [cell][field][br][row][cell][b]Department Head:[/b] [cell][field][/grid][br][hr][br][b]Reason:[/b] [field][br][br][hr][grid][row][cell][list][b]Employee signature:[/b][/list][cell][list][list][list][list][list][b]Site Manager signature:[/b][/list][/list][/list][/list][/list][cell][br][row][cell][list] - [field][/list][cell][list][list][list][list][list]- [large][field][/large][/list][/list][/list][/list][/list][cell][/grid]"}
			revision = "Revision: 1.3"
		if("COM-0009")
			content = @{"[grid][row][cell][b]Visitor name:[/b] [cell][field][br][row][cell][cell][br][row][cell][b]Escort:[/b] [cell][/grid][br][table][row][cell]Required[cell][field][br][row][cell]Not Required[cell][field][/table][br][hr][br][b]Assigned Crewmember as Escort:[/b] [field][br][br][small]Leave blank if none[/small][br][hr][grid][row][cell][list][b]Authorizing Personnel:[/b][/list][cell][cell][list][list][list][list][list][b]Crewmember signature:[/b][/list][/list][/list][/list][/list][cell][br][row][cell][list] - [large][field][/large][/list][cell][list][list][list][list][cell][list][list][list][list][list]- [large][field][/large][/list][/list][/list][/list][/list][cell][/grid]"}
			revision = "Revision: 1.5"
		if("COM-0012")
			content = @{"[grid][row][cell][b]Sender:[/b] [cell][field][br][row][cell][b]Position:[/b] [cell][field][/grid][br][hr][br][b]Personnel Needed:[/b][br][table][br][row][cell]Exploration[cell][field][br][row][cell]Cargo[cell][field][br][row][cell]Medical[cell][field][br][row][cell]Service[cell][field][br][row][cell]Security[cell][field][br][row][cell]Science[cell][field][br][row][cell]Engineering[cell][field][br][row][cell]Command[cell][field][br][/table][br][small]Leave blank if none[/small][br][h3]Reason:[/h3] [field][br][br][hr][grid][row][cell][list][b]Signed:[/b][/list][cell][br][row][cell][list] - [large][field][/large][/list][cell][/grid]"}
			revision = "Revision: 1.2"
		if("COM-0013")
			content = @{"[center][i]Recognizing outstanding contributions and achievements[/i][/center][hr][b]Nominator Information[/b][table][row][cell]Full Name:[cell][field][row][cell]Department:[cell][field][row][cell]Contact Email:[cell][field][/table][hr][b]Nominee Details[/b][table][row][cell]Nominee's Full Name:[cell][field][row][cell]Nominee's Department:[cell][field][row][cell]Date of Nomination:[cell][field][/table][hr][b]Nomination Justification[/b][br][i]Please provide a detailed explanation of why the nominee deserves the Employee of the Month award. Highlight specific achievements, contributions to team goals, or any exemplary behavior.[/i][br][br][field][hr][b]Supporting Documents[/b][br][i]Include any relevant documents, such as performance reports or commendations, that support your nomination.[/i][br][br][field][hr][b]Endorsements[/b][br][i]List any additional endorsements from colleagues or supervisors. Include their names and brief statements of support.[/i][br][br][field][hr][b]Approval[/b][table][row][cell]Nominator's Signature:[cell][field][row][cell]Department Head Signature:[cell][field][row][cell]HOP Review Signature:[cell][field][/table]"}
			revision = "Revision: 1.1"
		//Security forms, SEC-1
		if("SEC-1001")
			content = @{"The following is a checklist of actions generally considered useful or essential to perform at the start of a work shift, or as soon as possible otherwise. Please sign to the right of each item when completed. If necessary, you may put notes regarding the work item after your signature.[br][hr][center][table][br][row][cell]All secure doors inspected and maintained if necessary[cell][field][br][row][cell]All cells cleaned[cell][field][br][row][cell]Brig cleaned and repaired if necessary[cell][field][br][row][cell]Armory inventory completed (see SEC-1010)[cell][field][br][row][cell]Security records checked for important information[cell][field][br][row][cell](optional) Patrol assignments given (see SEC-1002)[cell][field][br][row][cell]Cadets/Junior Officers assigned supervising officer if necessary[cell][field][br][/table][/center][br][hr][grid][row][cell][list][b]Officer on duty signature:[/b][/list][cell][br][row][cell][list] - [large][field][/large][/list][cell][/grid]"}
			revision = "Revision: 1.1"
		if("SEC-1002")
			content = @{"[hr][center][small][i]This sheet is designed for the [station]. You may wish to modify it if you are working on a different facility.[/i][/small][br][table][br][row][cell][b]Location[/b][cell][b]Personnel[/b][cell][b]Job[/b][br][row][cell]Arrivals Checkpoint[cell][field][cell][field][br][row][cell]Security Reception[cell][field][cell][field][br][row][cell]Foot Patrol: Deck 1 to Deck 2[cell][field][cell][field][br][row][cell]Foot Patrol: Deck 2[cell][field][cell][field][br][row][cell]Foot Patrol: Deck 2 to Deck 3[cell][field][cell][field][br][row][cell]Vault Checkpoint[cell][field][cell][field][br][row][cell]Auxiliary Checkpoint [field][cell][field][cell][field][br][row][cell][field][cell][field][cell][field][br][/table][/center][br][hr][grid][row][cell][list][b]Signature of Head of Security:[/b][/list][cell][br][row][cell][list] - [large][field][/large][/list][cell][/grid]"}
			revision = "Revision: 1.4"
		if("SEC-1003")
			content = @{"[b]Location of Incident:[/b] [field][br][br][b]Persons Involved:[/b][br][small][i](V - Victim, S - Suspect, W - Witness, M - Missing, A - Arrested, RP - Reporting Person, RO - Responding Officer, D - Deceased)[/i][/small][br][list][*] [field][br][/list][br][hr][br][b]Details of Incident:[/b][br][br][field][br][br][b]Evidence of Incident:[/b][br][br][field][br][br][hr][grid][row][cell][list][b]Signature of Reporting Officer:[/b][/list][cell][cell][list][list][list][list][b]Signature of Reporting Officer's Supervisor [small](if available)[/small]:[/b][/list][/list][/list][/list][cell][br][row][cell][list] - [large][field][/large][/list][cell][cell][list][list][list][list]- [large][field][/large][/list][/list][/list][/list][cell][/grid]"}
			revision = "Revision: 1.1"
		if("SEC-1004")
			content = @{"[grid][row][cell][b]Location of Incident:[/b][cell][field][br][row][cell][cell][br][row][cell][b]Suspect's Name:[/b][cell][field][br][row][cell][cell][br][row][cell][b]Suspect's Title:[/b][cell][field][br][row][cell][cell][br][row][cell][b]Charges Filed:[/b][cell][field][br][row][cell][cell][br][row][cell][b]Sentence Given:[/b][cell][field][/grid][br][hr][br][b]Persons Involved:[/b][br][small][i](V - Victim, S - Suspect, W - Witness, M - Missing, A - Arrested, RP - Reporting Person, RO - Responding Officer, D - Deceased)[/i][/small][br][list][*] [field][br][/list][br][hr][br][b]Details of Incident:[/b][br][br][field][br][br][b]Evidence of Incident:[/b][br][br][field][br][br][hr][grid][row][cell][list][b]Signature of Arresting Officer:[/b][/list][cell][cell][list][list][list][list][b]Signature of Arresting Officer's Supervisor [small](if available)[/small]:[/b][/list][/list][/list][/list][cell][br][row][cell][list] - [large][field][/large][/list][cell][cell][list][list][list][list]- [large][field][/large][/list][/list][/list][/list][cell][/grid]"}
			revision = "Revision: 1.0"
		if("SEC-1005")
			content = @{"[hr][br]To all members of the [field] facility's security department:[br][br]A command to arrive at the security department to answer for their accused charges of [[b][field][/b]] having been given to [[b][field][/b]], and said person having failed to do so,[br][br]YOU ARE HEREBY COMMANDED to arrest said person and bring said person directly to the security department to answer for their disobedience to the aforementioned command, and also the aforementioned charges, as issued by [[b][field][/b]].[br][br][hr][br]This arrest warrant has been issued by [[b][field][/b]] [small][i](name)[/i][/small], [[b][field][/b]] [small][i](rank)[/small][/i]. This arrest warrant is not valid without the aforementioned issuer's signature and only if they have the authority to issue this arrest warrant and are doing so with due respect to the laws and policies governing this facility.[br][br][hr][grid][row][cell][list][b]Issuer's Signature:[/b][/list][cell][cell][list][list][list][list][b]Arresting Officer's Signature:[/b][/list][/list][/list][/list][cell][br][row][cell][list] - [large][field][/large][/list][cell][cell][list][list][list][list]- [large][field][/large][/list][/list][/list][/list][cell][/grid]"}
			revision = "Revision: 1.3"
		if("SEC-1006")
			content = @{"[hr][br]I, [[b][field][/b]], do on oath and with my authority as a member of this facility's security department, affirm that I have substantial probable cause to search:[br][br][b]LOCATION, PROPERTY, AND/OR PERSONS TO BE SEARCHED:[/b][br][br]1. [field][br][br][b]ITEMS TO BE SEIZED:[/b][br][br]For the following property, to wit:[br]1. [field][br][br][b]OFFICER'S QUALIFICATIONS[/b][br][br]I have been a member of NanoTrasen's security division for [field] years and am currently assigned to the [field] facility. [field][br][br][b]PROBABLE CAUSE[/b][br][br][i][small]Write the reason why you have probable cause to execute this search warrant.[/small][/i][br][field][br][br][hr][br]This search warrant has been reviewed for legal sufficiency by [[b][field][/b]] [small][i](name)[/i][/small], [[b][field][/b]] [small][i](rank)[/i][/small]. This search warrant is not valid without the aforementioned reviewer's signature and only if they have the authority to approve this search warrant and are doing so with due respect to the laws and policies governing this facility.[br][br][hr][grid][row][cell][list][b]Reviewer's Signature:[/b][/list][cell][cell][list][list][list][list][b]Executing Officer's Signature:[/b][/list][/list][/list][/list][cell][br][row][cell][list] - [large][field][/large][/list][cell][cell][list][list][list][list]- [large][field][/large][/list][/list][/list][/list][cell][/grid]"}
			revision = "Revision: 1.5"
		if("SEC-1007")
			content = @{"[grid][row][cell][b]Case Number:[/b][cell][field][/grid][br][hr][h3]Involved Personnel[/h3][small][i](V - Victim, S - Suspect, W - Witness, M - Missing, A - Arrested, RP - Reporting Person, RO - Responding Officer, D - Deceased, O - Other)[/i][/small][br][table][br][row][cell]- [b]Personnel[/b][cell]- [b]Code[/b][cell]- [b]Summary[/b][br][row][cell]- [field][cell]- [field][cell]- [field][br][row][cell]- [field][cell]- [field][cell]- [field][br][row][cell]- [field][cell]- [field][cell]- [field][br][row][cell]- [field][cell]- [field][cell]- [field][br][row][cell]- [field][cell]- [field][cell]- [field][br][/table][br][br][hr][h3]Physical Property[/h3][small][i](D - Damaged, E - Evidence, L - Lost, R - Recovered, S - Stolen, O - Other)[/i][/small][br][table][br][row][cell]- [b]Item[/b][cell]- [b]Code[/b][cell]- [b]Summary[/b][br][row][cell]- [field][cell]- [field][cell]- [field][br][row][cell]- [field][cell]- [field][cell]- [field][br][row][cell]- [field][cell]- [field][cell]- [field][br][row][cell]- [field][cell]- [field][cell]- [field][br][row][cell]- [field][cell]- [field][cell]- [field][br][/table][br][br][hr][h3]Evidence[/h3][small][i](S - Statement, P - Photo, D - Document, IP - Item/Property, F - Fibers, FP - Fingerprints, B - Blood, O - Other)[/i][/small][br][table][br][row][cell]- [b]Evidence[/b][cell]- [b]Code[/b][cell]- [b]Summary[/b][br][row][cell]- [field][cell]- [field][cell]- [field][br][row][cell]- [field][cell]- [field][cell]- [field][br][row][cell]- [field][cell]- [field][cell]- [field][br][row][cell]- [field][cell]- [field][cell]- [field][br][row][cell]- [field][cell]- [field][cell]- [field][br][/table][br][br][hr][h3]Narrative[/h3][field][br][br][hr][grid][row][cell][list][b]Signature of Reporting Detective:[/b][/list][cell][br][row][cell][list] - [large][field][/large][/list][cell][/grid]"}
			revision = "Revision: 1.1"
		if("SEC-1008")
			content = @{"[grid][row][cell][b]Interviewee's Name:[/b][cell][field][br][row][cell][b]Interviewee's Title:[/b][cell][field][br][row][cell][cell][br][row][cell][b]Interrogating Officer's Name:[/b][cell][field][br][row][cell][b]Interrogating Officer's Rank:[/b][cell][field][br][row][cell][cell][br][row][cell][b]Other Personnel Present:[/b][cell][field][br][row][cell][b]Case Number:[/b][cell][field][/grid][br][hr][h3]Interview Notes:[/h3][field][br][br][hr][small][i]A transcript of the interrogation should be attached to this report as soon as it is available.[/i][/small][br][br][grid][row][cell][list][b]Interrogating Officer's Signature:[/b][/list][cell][br][row][cell][list] - [large][field][/large][/list][cell][/grid]"}
			revision = "Revision: 1.0"
		if("SEC-1009")
			content = @{"[grid][row][cell][b]Witness' Name:[/b][cell][field][br][row][cell][b]Witness' Title:[/b][cell][field][br][row][cell][cell][br][row][cell][b]Attending Officer's Name:[/b][cell][field][br][row][cell][b]Attending Officer's Title:[/b][cell][field][/grid][hr][br][b]Witness' Statement:[/b][br][br][field][br][br][small][i]I, the undersigned, affirm that the above statement is my personal account of the relevant events and is correct and true to the best of my knowledge. Knowingly providing false information could result in charges.[/i][/small][br][grid][row][cell][list][b]Witness' Signature:[/b][/list][cell][br][row][cell][list] - [large][field][/large][/list][cell][/grid][hr][br][small][b][u]FOR SECURITY USE ONLY[/b][/u][/small][br][br][grid][row][cell][b]Case Number:[/b][cell][field][br][row][cell][cell][br][row][cell][b]Additional Remarks:[/b][cell][field][/grid][br][grid][row][cell][list][b]Attending Officer's Signature:[/b][/list][cell][br][row][cell][list] - [large][field][/large][/list][cell][/grid][br]"}
			revision = "Revision: 1.4"
		if("SEC-1010")
			content = @{"[grid][row][cell][b]Time of Inspection:[/b][cell][field][br][row][cell][cell][br][row][cell][b]Inspecting Officer:[/b][cell][field][/grid][br][hr][center][h3]Regular Armory[/h3][/center][list][*][field][br][/list][br]Miscellaneous equipment: [field][br][br][hr][center][h3]Tactical Armory[/h3][/center][list][*][field][br][/list][br]Miscellaneous equipment: [field][br][br][hr][grid][row][cell][list][b]Signature of Inspecting Officer:[/b][/list][cell][cell][list][list][list][list][b]Signature of Warden [small](if different)[/small]:[/b][/list][/list][/list][/list][cell][br][row][cell][list] - [large][field][/large][/list][cell][cell][list][list][list][list]- [large][field][/large][/list][/list][/list][/list][cell][/grid]"}
			revision = "Revision: 1.1"
		if("SEC-1011")
			content = @{"[grid][row][cell][b]Name of Requesting Personne:[/b][cell][field][br][row][cell][cell][br][row][cell][b]Title of Requesting Personnel:[/b][cell][field][/grid][br][hr][br][b]Equipment Requested:[/b][br][br][field][br][br][grid][row][cell][b]Reason:[/b][cell][field][/grid][br][grid][row][cell][list][b]Signature of Requesting Personnel:[/b][/list][cell][br][row][cell][list] - [large][field][/large][/list][cell][/grid][hr][br][grid][row][cell][b]Tequest Status [small](approved/denied)[/small]:[/b][cell][field][br][row][cell][cell][br][row][cell][b]Reason [small](if denied)[/small]:[/b][cell][field][/grid][br][grid][row][cell][list][b]Signature of Warden [small](or stand-in signatory)[/small]:[/b][/list][cell][br][row][cell][list] - [large][field][/large][/list][cell][/grid]"}
			revision = "Revision: 1.1"
		if("SEC-1012")
			content = @{"[grid][row][cell][b]Name of Receiving Personnel:[/b][cell][field][br][row][cell][cell][br][row][cell][b]Title of Receiving Personnel:[/b][cell][field][/grid][br][hr][br][b]Equipment Issued:[/b][br][br][field][br][br][hr][br][grid][row][cell][b]Name of Issuing Personnel:[/b][cell][field][br][row][cell][cell][br][row][cell][b]Title of Issuing Personnel:[/b][cell][field][br][row][cell][cell][br][row][cell][b]Reason:[/b][cell][field][/grid][br][hr][grid][row][cell][list][b]Signature of Receiving Personnel:[/b][/list][cell][cell][list][list][list][list][b]Signature of Issuing Personnel:[/b][/list][/list][/list][/list][cell][br][row][cell][list] - [large][field][/large][/list][cell][cell][list][list][list][list]- [large][field][/large][/list][/list][/list][/list][cell][/grid][hr][br][small][b][u]TO BE FILLED OUT UPON RETURN OF EQUIPMENT[/u][/b][/small][br][br][b]Missing and/or Damaged Items:[/b][br][br][field][br][br][grid][row][cell][list][b]Signature of Warden [small](or stand-in signatory)[/small]:[/b][/list][cell][br][row][cell][list] - [large][field][/large][/list][cell][/grid]"}
			revision = "Revision: 1.3"
		if("SEC-1013")
			content = @{"[grid][row][cell][b]Personnel's Name:[/b][cell][field][br][row][cell][cell][br][row][cell][b]Weapon:[/b][cell][field][br][row][cell][cell][br][row][cell][b]Reason:[/b][cell][field][br][row][cell][cell][br][row][cell][b]Duration [small](max. end of shift)[/small]:[/b][cell][field][/grid][br][hr][br][b]Terms of Permit:[/b][br][br][field][br][br][hr][small][i]I have read and understand Standard Operating Procedure as pertaining to weapon permits and the above terms in which I am allowed to carry this weapon permit. I understand that the below signatories, or any security officer with probable cause, may revoke my weapon permit at any time, and I will be expected to immediately surrender my weapon and this permit to the security department upon revocation or expiration of this permit. I understand that if I am involved in any violent crime, even if the crime is not related to my weapon permit, or if I violate the terms of this weapon permit for any reason, this permit may immediately be revoked at the discretion of security personnel.[/i][/small][br][br][grid][row][cell][list][b]Personnel's Signature:[/b][/list][cell][cell][list][list][list][list][b]Permit Issuer's Signature [small](Title: [field])[/small]:[/b][/list][/list][/list][/list][cell][br][row][cell][list] - [large][field][/large][/list][cell][cell][list][list][list][list]- [large][field][/large][/list][/list][/list][/list][cell][/grid]"}
			revision = "Revision: 1.1"
		if("SEC-1014")
			content = @{"[grid][row][cell][b]Receiving Personnel:[/b][cell][field][/grid][br][hr][h3]Terms of Injunction[/h3][field][br][br][hr][small][i]I have read and understand the above terms of this injunction. I understand that this injunction legally forbids me from performing the above actions under any circumstances and that violating this injunction can result in my immediate arrest. If I wish to appeal this injunction, I may contact an Internal Affairs Agent to appeal my case. I understand that this injunction is valid only until the end of the shift in which it was issued unless I am notified otherwise by a Central Command Officer. My below signature constitutes acknowledgment and agreeance with all of these above statements, though it is not required to enforce this injunction.[/small][/i][br][br][grid][row][cell][list][b]Signature of Receiving Personnel:[/b][/list][cell][cell][list][list][list][list][b]Signature of Head of Security [small](or stand-in signatory):[/b][/list][/list][/list][/list][cell][br][row][cell][list] - [large][field][/large][/list][cell][cell][list][list][list][list]- [large][field][/large][/list][/list][/list][/list][cell][/grid]"}
			revision = "Revision: 1.1"
		if("SEC-1015")
			content = @{"[hr][br]I, [small][u][field][/u][/small], agree to become deputized to the Security department onboard the [station] and agree to be held to the responsibilities and expectations thereof.[br][br]I understand that this means I am granted some powers of a security officer, but that I am not a security officer and do not hold any authority over any member of the security department.[br][br]I understand that this deputization may be revoked at any time by the head of staff that authorized it or by any security officer with probable cause.[br][br]I understand that I am not above the law and agree to abide by all laws and regulations for as long as I am deputized.[br][br]I understand that I will be placed under direct supervision by the Security department and must follow valid orders given to me by a superior.[br][br][grid][row][cell][list][b]Personnel's Signature:[/b][/list][cell][cell][list][list][list][list][b]Autorizing Staff Signature [small](Title: [field])[/small]:[/b][/list][/list][/list][/list][cell][br][row][cell][list] - [large][field][/large][/list][cell][cell][list][list][list][list]- [large][field][/large][/list][/list][/list][/list][cell][/grid]"}
			revision = "Revision: 3.2"
		//Supply forms, SUP-2
		if("SUP-2001")
			content = @{"[grid][row][cell][b]Order Number(s):[/b] [cell][field][br][row][cell][b]Shipment Destination:[/b] [cell][field][br][row][cell][b]Shipment Method:[/b] [cell][field][/grid][br][hr][br][center][b]Goods in this delivery:[/b][/center][br][list][br][*][field][br][*][field][br][*][field][br][*][field][br][*][field][br][/list][br][hr][grid][row][cell][list][b]Supply personnel signature:[/b][/list][cell][cell][list][list][list][list][b]Receiver signature:[/b][/list][/list][/list][/list][cell][br][row][cell][list] - [large][field][/large][/list][cell][cell][list][list][list][list]- [large][field][/large][/list][/list][/list][/list][cell][/grid]"}
			revision = "Revision: 1.0"
		if("SUP-2002")
			content = @{"[grid][row][cell][b]Shipment Number(s):[/b] [cell][field][br][row][cell][b]Shipment Destination:[/b] [cell][field][br][row][cell][b]Shipment Method:[/b] [cell][field] [/grid][br][hr][br][center][b]Material in this shipment:[/b][/center][br][list][grid][row][cell][*]Iron:[cell][field][br][row][cell][*]Steel:[cell][field][br][row][cell][*]Plasteel:[cell][field][br][row][cell][*]Durasteel[cell][field][br][row][cell][*]Glass:[cell][field][br][row][cell][*]Sandstone:[cell][field][br][row][cell][*]Uranium:[cell][field][br][row][cell][*]Phoron Crystals:[cell][field][br][row][cell][*]Gold Bars:[cell][field][br][row][cell][*]Silver Ingots:[cell][field][br][row][cell][*]Diamonds:[cell][field][br][row][cell][*]Plastic:[cell][field][br][row][cell][*]Graphite:[cell][field][br][row][cell][*]Platinum:[cell][field][br][row][cell][*]Osmium:[cell][field][br][row][cell][*]Tritium:[cell][field][br][row][cell][*]Mhydrogen:[cell][field][br][row][cell][*]Verdantium:[cell][field][br][row][cell][*]Marble:[cell][field][br][row][cell][*]Lead:[cell][field][br][row][cell][*]Titanium:[cell][field][/grid][br][/list][br][small]Leave blank or write 0 if none[/small][br][hr][grid][row][cell][list][b]Supply personnel signature:[/b][/list][cell][cell][list][list][list][list][b]Receiver signature:[/b][/list][/list][/list][/list][cell][br][row][cell][list] - [large][field][/large][/list][cell][cell][list][list][list][list]- [large][field][/large][/list][/list][/list][/list][cell][/grid]"}
			revision = "Revision: 1.4"
		if("SUP-2003")
			content = @{"[hr][br][center][b]Material in stock:[/b][/center][br][list][grid][row][cell][*]Iron:[cell][field][br][row][cell][*]Steel:[cell][field][br][row][cell][*]Plasteel:[cell][field][br][row][cell][*]Durasteel[cell][field][br][row][cell][*]Glass:[cell][field][br][row][cell][*]Sandstone:[cell][field][br][row][cell][*]Uranium:[cell][field][br][row][cell][*]Phoron Crystals:[cell][field][br][row][cell][*]Gold Bars:[cell][field][br][row][cell][*]Silver Ingots:[cell][field][br][row][cell][*]Diamonds:[cell][field][br][row][cell][*]Plastic:[cell][field][br][row][cell][*]Graphite:[cell][field][br][row][cell][*]Platinum:[cell][field][br][row][cell][*]Osmium:[cell][field][br][row][cell][*]Tritium:[cell][field][br][row][cell][*]Mhydrogen:[cell][field][br][row][cell][*]Verdantium:[cell][field][br][row][cell][*]Marble:[cell][field][br][row][cell][*]Lead:[cell][field][br][row][cell][*]Titanium:[cell][field][/grid][br][/list][br][small]Leave blank or write 0 if none[/small][br][hr][grid][row][cell][list][b]Supply personnel signature:[/b][/list][cell][br][row][cell][list] - [large][field][/large][/list][cell][/grid]"}
			revision = "Revision: 1.1"
		//Science forms, SCI-3
		if("SCI-3003")
			content = @{"[grid][row][cell][row][cell][b]Roboticist:[/b] [cell][field][br][row][cell][b]Assistant:[/b] [cell][field][/grid][br][small]Leave blank if none[/small][hr][br][grid][row][cell][row][cell][b]Cyborg / Robot:[/b] [cell][field][br][row][cell][b]Module:[/b] [cell][field][/grid][br][hr][br]The following form documents the full inspection of [[field]] as performed by [u][field][/u] in the Robotics Labratory aboard the [station] on [u][date][/u].[br][br][table][row][cell][b]General [/b][cell][center]Status[/center][cell]Comment[br][row][cell][b]- Laws [/b][cell][center][field][/center][cell][field][br][row][cell]-[cell][center]-[/center][cell]-[br][row][cell][b]Component external [/b][cell][center]-[/center][cell]-[br][row][cell][b]- Robot Endoskeleton [/b][cell][center][field][/center][cell][field][br][row][cell][b]- Left Arm [/b][cell][center][field][/center][cell][field][br][row][cell][b]- Right Arm [/b][cell][center][field][/center][cell][field][br][row][cell][b]- Left Leg [/b][cell][center][field][/center][cell][field][br][row][cell][b]- Right Leg [/b][cell][center][field][/center][cell][field][br][row][cell][b]- Torso [/b][cell][center][field][/center][cell][field][br][row][cell][b]- Head  [/b][cell][center][field][/center][cell][field][br][row][cell]-[cell][center]-[/center][cell]-[br][row][cell][b]Component internal [/b][cell][center]-[/center][cell]-[br][row][cell][b]- Wiring [/b][cell][center][field][/center][cell][field][br][row][cell][b]- Actuator [/b][cell][center][field][/center][cell][field][br][row][cell][b]- Radio [/b][cell][center][field][/center][cell][field][br][row][cell][b]- Power Cell [/b][cell][center][field][/center][cell][field][br][row][cell][b]- Self-Diagnosis Unit [/b][cell][center][field][/center][cell][field][br][row][cell][b]- Camera [/b][cell][center][field][/center][cell][field][br][row][cell][b]- Binary Communication Device [/b][cell][center][field][/center][cell][field][br][row][cell][b]- Armour Plating [/b][cell][center][field][/center][cell][field][/table][br][hr][grid][row][cell][list][b]Scientist signature:[/b][/list][cell][br][row][cell][list] - [large][field][/large][/list][cell][/grid]"}
			revision = "Revision: 1.1"
		if("SCI-3004")
			content = @{"[grid][row][cell][row][cell][b]Roboticist:[/b] [cell][field][br][row][cell][b]Assistant:[/b] [cell][field][/grid][br][small]Leave blank if none[/small][hr][br][grid][row][cell][row][cell][b]Cyborg / Robot:[/b] [cell][field][br][row][cell][b]Module:[/b] [cell][field][/grid][br][hr][br]The following form documents the installed upgrades into [[field]] as performed by [u][field][/u] in the Robotics Labratory aboard the [station] on [u][date][/u].[br][br][table][row][cell][b]Lawset[/b][cell][center]Status[/center][cell]Comment[br][row][cell][b]- [field][/b][cell][center][field][/center][cell][field][br][row][cell]-[cell][center]-[/center][cell]-[br][row][cell][b]General [/b][cell][center]-[/center][cell]-[br][row][cell][b]- Rename Module [/b][cell][center][field][/center][cell][field][br][row][cell][b]- Reset Module [/b][cell][center][field][/center][cell][field][br][row][cell][b]- Emergency Resttart Module [/b][cell][center][field][/center][cell][field][br][row][cell][b]- VTEC Module [/b][cell][center][field][/center][cell][field][br][row][cell][b]- Advanced Health Analyzer Module [/b][cell][center][field][/center][cell][field][br][row][cell][b]- Robohound Capacity Expansion Module [/b][cell][center][field][/center][cell][field][br][row][cell][b]- Robohound Capability Expansion Module [/b][cell][center][field][/center][cell][field][br][row][cell][b]- Size Alteration Module [/b][cell][center][field][/center][cell][field][br][row][cell][b]- Size Gun Module [/b][cell][center][field][/center][cell][field][br][row][cell][b]- Scrambled Equipment Module [/b][cell][center][field][/center][cell][field][br][row][cell][b]- Language Module [/b][cell][center][field][/center][cell][field][br][row][cell]-[cell][center]-[/center][cell]-[br][row][cell][b]Security [/b][cell][center]-[/center][cell]-[br][row][cell][b]- Rapid Taser Cooling Module [/b][cell][center][field][/center][cell][field][br][row][cell]-[cell][center]-[/center][cell]-[br][row][cell][b]Mining [/b][cell][center]-[/center][cell]-[br][row][cell][b]- Proto-Kinetic Accelerator [/b][cell][center][field][/center][cell][field][br][row][cell][b]- Diamond Drill [/b][cell][center][field][/center][cell][field][br][row][cell]-[cell][center]-[/center][cell]-[br][row][cell][b]Science [/b][cell][center]-[/center][cell]-[br][row][cell][b]- Advanced Rapid Part Exchange Device [/b][cell][center][field][/center][cell][field][/table][br][hr][grid][row][cell][list][b]Scientist signature:[/b][/list][cell][list][list][list][list][list][b]Research Director signature [small](In case of Law Change)[/small]:[/b][/list][/list][/list][/list][/list][cell][br][row][cell][list] - [large][field][/large][/list][cell][list][list][list][list][list]- [large][field][/large][/list][/list][/list][/list][/list][cell][br][row][cell][cell][cell][br][row][cell][list][/list][cell][list][list][list][list][list][b]Second Command signature [small](In case of Law Change)[/small]:[/b][/list][/list][/list][/list][/list][cell][br][row][cell][list][/list][cell][list][list][list][list][list]- [large][field][/large][/list][/list][/list][/list][/list][cell][/grid]"}
			revision = "Revision: 1.4"
		if("SCI-3009")
			content = @{"[grid][row][cell][row][cell][b]Scientist:[/b] [cell][field][br][row][cell][b]Assistant:[/b] [cell][field] [/grid][br][small]Leave blank if none[/small][br][hr][br]The following table contains the Genetic Identifier and purpose of the Xenofloral genes as identified by [u][field][/u] in the Xenobotanical Labratory aboard the [station] on [u][date][/u].[br][br][table][cell][b]Genetic Identifier[/b][cell]Genetic Sequence[row][br][cell][b]-[field] [/b][cell][small][b]Hardiness:[/b] Endurance. Tolerance to toxins, pests, and/or weeds[/small][br][row][cell]-[b][field] [/b][cell][small][b]Vigour:[/b] How long the plant takes to mature and produce fruit. How much fruit it produces. Whether it can spread out of its tray(vine).[/small][br][row][cell]-[b][field] [/b][cell][small][b]Biochemistry:[/b] Which reagents the fruit contains; which gases the plant generates.[/small][br][row][cell][b]-[field] [/b][cell][small][b]Fruit:[/b] Whether the fruit is juicy and will splatter when thrown; whether the plant has stinging spines and will inject its reagents into anyone coming in contact with it.[/small][br][row][cell]-[b][field] [/b][cell][small][b]Diet:[/b] Whether the plant consumes gases in its environment; whether the plant is carnivorous (eats pests) or eats tray weeds; how much water and fertilizer it consumes.[/small][br][row][cell]-[b][field] [/b][cell][small][b]Metabolism:[/b] Whether the plant requires water or fertilizer. Whether it alters the ambient temperature.[/small][br][row][cell]-[b][field] [/b][cell][small][b]Environment:[/b] Plant's preferred temperature and light levels, and how much tolerance it has for changes in light level.[/small][row][cell]-[b][field] [/b][cell][small][b]Atmosphere:[/b] The plant's tolerance for changes in temperature and pressure away from its preferred levels.[/small][br][row][cell]-[b][field] [/b][cell][small][b]Output:[/b] Whether the plant produces electrical power or bioluminescent light.[/small][br][row][cell]-[b][field] [/b][cell][small][b]Appearance:[/b] The "shape" of the plant. Also affects whether it can be harvested only once or multiple times.[/small][br][row][cell]-[b][field] [/b][cell][small][b]Pigment:[/b] The color of the plant and its fruit; the color of any bioluminescence.[/small][br][row][cell][b]-[field] [/b][cell][small][b]Special:[/b] The ability to teleport the thrower or target when thrown.[/small][/table][br][hr][grid][row][cell][list][b]Scientist signature:[/b][/list][cell][br][row][cell][list] - [large][field][/large][/list][cell][/grid]"}
			revision = "Revision: 0.9"
		//Medical forms, MED-4
		if("MED-4001")
			content = @{"[hr][br][grid][row][cell][b]Deceased Patient's Name:[/b][cell][field][br][row][cell][cell][br][row][cell][b]Date of Birth:[/b][cell][field][br][row][cell][cell][br][row][cell][b]Attending Physician:[/b][cell][field][/grid][br][hr][br][grid][row][cell][b]Date of Death:[/b][cell][field][br][row][cell][b]Time of Death:[/b][cell][field][br][row][cell][b]Cause of Death:[/b][cell][field][br][row][cell][cell][br][row][cell][b]DNR/DNC Request Present:[/b][cell][field][br][row][cell][cell][br][row][cell][b]Further Autopsy Notes:[/b][cell][field][/grid][br][hr][br][i][small]I, the undersigned, with my authority as a licensed medical practitioner, declare the aforementioned patient to have irreversibly died at the aforementioned date and time in the aforementioned manner. I affirm that all information in this death certificate is true and correct to the best of my knowledge.[/i][/small][br][br][hr][grid][row][cell][list][b]Signature of Attending Physician:[/b][/list][cell][br][row][cell][list] - [large][field][/large][/list][cell][/grid]"}
			revision = "Revision: 1.2"
		if("MED-4002")
			content = @{"[grid][row][cell][b]Patient Name:[/b][cell][field][br][row][cell][cell][br][row][cell][b]Prescribing Doctor:[/b][cell][field][/grid][br][hr][br][grid][row][cell][b]Name of Prescription Medicine:[/b][cell][field][br][row][cell][b]Dosage Type & Amount:[/b][cell][field][br][row][cell][cell][br][row][cell][b]Prescription Start Date:[/b][cell][field][br][row][cell][b]Prescription End Date:[/b][cell][field][/grid][br][hr][h3]INSTRUCTIONS:[/h3][field][br][br][grid][row][cell][b]Potential Side Effects:[/b][cell][field][br][row][cell][b]Additional Notes:[/b][cell][field][/grid][br][hr][br]Only take this medication as prescribed, according to the above instructions. Do not stop taking this medication without consulting your doctor. If you miss a dose, take it as soon as you remember unless it is close to the time of your next dose. [b]Do not take multiple doses to make up for a missed dose.[/b] If you have any questions about this medication, ask your doctor.[br][br]Keep a copy of this form with your medication so you may easily reference it.[br][hr][grid][row][cell][list][b]Signature of Patient:[/b][/list][cell][cell][list][list][list][list][b]Signature of Attending Physician:[/b][/list][/list][/list][/list][cell][br][row][cell][list] - [large][field][/large][/list][cell][cell][list][list][list][list]- [large][field][/large][/list][/list][/list][/list][cell][/grid]"}
			revision = "Revision: 1.1"
		if("MED-4003")
			content = @{"[grid][row][cell][b]Patient Name:[/b][cell][field][br][row][cell][cell][br][row][cell][b]Practitioner:[/b][cell][field][/grid][br][hr][br][center]Patient has decisional capacity to refuse further medical evaluation or treatment. Sign to confirm.[/center][br][hr][br]This certified that I, [[field]], voluntarily refuse further medical evaluation and treatment at [field]. I understand that further evaluation and treatment has been recommended and I am leaving [b]against medical advice.[/b] The medical staff have explained the risks of leaving which may include the worsening of my condition, harm to a bodily function or part, [b]or even death.[/b][br][br][hr][br][b]Benefits of receiving[/b] further evaluation and treatment include, but are not limited to:[br][br][field][br][br][b]Risks of refusing[/b] further evaluation and treatment include, but are not limited to:[br][br][field][br][br][b]Alternatives[/b] to receiving further evaluation and treatment here include, but are not limited to:[br][br][field][br][br][br][grid][row][cell][list][b]Practitioner Signature:[/b][/list][cell][cell][br][row][cell][list] - [large][field][/large][/list][cell][/grid][br][hr][br][b]I understand that I may return at any time and consent to further evaluation and treatment.[/b][br][br][grid][row][cell][list][b]Signature of Patient:[/b][/list][cell][cell][br][row][cell][list] - [large][field][/large][/list][cell][/grid]"}
			revision = "Revision: 1.1"
		if("MED-4004")
			content = @{"[hr][br][grid][row][cell][b]Patient Name:[/b][cell][field][br][row][cell][cell][br][row][cell][b]Current Occupation:[/b][cell][field][br][row][cell][cell][br][row][cell][b]Preferred Cyborg name:[/b][cell][field][/grid][br][hr][br]By signing this contract you will be filed for voluntary cybogification.[br][br] Lobotomy will be performed on your person and your brain will be transported, implanted and synchronized to a functional cyborg shell. You also agree to abide by NT Cyborg law and that the research department, NT, or any of its affilites are not responsible for the loss of, or damage to any of the following:[br][list][small][*]Health[br][*]Life[br][*]Posessions[br][*]Investments[br][*]Relationships[br][*]Sense of fullfillment[br][*]Fun[/small][/list][br][small]The research team withholds the privilege to, [i]at any time[/i], end the cyborg contract in question, thereby destroying the shell in the process, and consider returning the brain to a biological body.[/small][br][hr][grid][row][cell][list][b]Patient signature[/b][/list][cell][cell][br][row][cell][list]- [field][/list][cell][cell][br][row][cell][cell][cell][br][row][cell][list][b]Performing surgeon signature:[/b][cell][list][list][list][list][list][b]Performing roboticist signature:[/b][/list][/list][/list][/list][/list][cell][br][row][cell][list] - [large][field][/large][cell][list][list][list][list][list]- [large][field][/large][/list][/list][/list][/list][/list][cell][br][row][cell][cell][cell][br][row][cell][list][b]Head of department Signature[/b][/list][cell][cell][br][row][cell][list]- [large][field][/large][/list][cell][cell][/grid][br][small][center]-Reminder to notify subject's head of staff and security-[/small]"}
			revision = "Revision: 1.2"
		if("MED-4005")
			content = @{"[hr][br][grid][row][cell][b]Deceased Patient's Name:[/b][cell][field][br][row][cell][cell][br][row][cell][b]Date of Birth:[/b][cell][field][br][row][cell][cell][br][row][cell][b]Attending Physician:[/b][cell][field][/grid][br][hr][small][i]The following questions should be filled out by the patient without supervision or direction.[/small][/i][br][br][b]List of current physical and mental ailments [small](as described by you or another healthcare professional)[/small]:[/b][br][br][field][br][br][b]List of current and prior prescription medicine usage:[/b][br][br][field][br][br][b]Why do you want to see a mental health professional?[/b][br][br][field][br][br][b]Anything else I should know about you?[/b][br][br][field][br][br][b]Are you happy to recieve hypnotherapy and/or experimental vore therapy? Please ask your therapist if unsure.[/b][br][br][field][br][br][hr][br][[b][field][/b]] is expected to be your assigned mental healthcare professional. Please note that due to the decentralization of NanoTrasen's healthcare facilities, you may visit a different professional from time to time. Please take care to keep a summary of past visits with you to help you get the best care you need.[br][br][hr][grid][row][cell][list][b]Signature of Patient:[/b][/list][cell][cell][list][list][list][list][b]Doctor Signature:[/b][/list][/list][/list][/list][cell][br][row][cell][list] - [large][field][/large][/list][cell][cell][list][list][list][list]- [large][field][/large][/list][/list][/list][/list][cell][/grid]"}
			revision = "Revision: 2.1"
		if("MED-4006")
			content = @{"[grid][row][cell][b]Patient Name:[/b][cell][field][br][row][cell][cell][br][row][cell][b]Practitioner:[/b][cell][field][/grid][br][hr][br]I, [[field]] (hereafter referred to as 'the patient'), hereby grant permission for the installation of a Nanite Implant Framework (hereafter referred to as a NIF), a non-essential and invasive implantation surgical procedure. I have been informed of and recognize the risks of this procedure, and the risks of possessing an implanted NIF, outlined below.[br][hr][br]Due to the complexity of this procedure, life-threatening risks are present. A skilled surgeon will be called upon to operate the procedure. They are expected to uphold Standard Operating Procedure and all surgical procedural guidelines.[br][br]There are possible risks associated with the installation of certain NIFsoft programs as well, such as malfunction or malware.[br][br]Upon installation, there will be a half-hour calibration period while the NIF connects to neurons in the brain, during which the patient will experience the following symptoms.[br][list][br][*]Loss of sight for approximately the first five minutes of calibration.[br][*]Grainy vision after restoration of ocular functions.[br][*]Strange and unusual sensations and tingling.[br][*]Extreme full-body pain.[br][*]Headaches.[br][*]Weakness.[br][*]Intermittent fainting and loss of consciousness.[/list][br][br]The patient may be discharged after the 30-minute recovery period has passed. The patient will be notified by their NIF when the process is complete.[br][br]As the patient, you are entitled to priority medical care in the event of a surgery-related emergency, up to and including resleeving if necessary. You are also entitled to an available, surgically-trained physician of your choice for the implantation in the event you do not like the one assigned to your care.[br][hr][br]Please put a cross (X) on one of these anesthetic-like options:[br][[field]] - I want to be sedated with anesthetic gas. (Recommended for a majority of species.)[br][[field]] - I want to be sedated with medication.[br][[field]] - I want my mind to be downloaded onto a SleeveMate 3700.[br][[field]] - I do [u]not[/u] want any of the above. [b](Not recommended for most species. The surgeon may refuse to operate without anesthetic.)[/b][br][hr][small]By signing this form I agree that I have read and assessed the risks associated with owning a NIF and NIF implantation surgery and give my consent for operation of this procedure.[/small][br][grid][row][cell][list][b]Signature of Patient:[/b][/list][cell][cell][list][list][list][list][b]Practitioner Signature:[/b][/list][/list][/list][/list][cell][br][row][cell][list] - [large][field][/large][/list][cell][cell][list][list][list][list]- [large][field][/large][/list][/list][/list][/list][cell][/grid]"}
			revision = "Revision: 2.2"
		if("MED-4007")
			content = @{"[grid][row][cell][b]Patient Name:[/b][cell][field][br][row][cell][cell][br][row][cell][b]Patient Occupation:[/b][cell][field][br][row][cell][cell][br][row][cell][b]Psychiatrist:[/b][cell][field][/grid][br][hr][br][b][u]Concerns:[/u][/b][br][br][field][br][br][b][u]Evaluation:[/u][/b][br][br][field][br][br][b][u]Conclusion:[/u][/b][br][br][field][br][br][hr][b][u]Comments:[/u][/b][br][br][field][br][br][hr][grid][row][cell][list][b]Psychiatrist Signature:[/b][/list][cell][br][row][cell][list] - [large][field][/large][/list][cell][/grid]"}
			revision = "Revision: 1.3"
		//Engineering forms, ENG-5
		if("ENG-5001")
			content = @{"[grid][row][cell][b]Location:[/b] [cell][field][br][row][cell][b]Purpose:[/b] [cell][field][/grid][br][hr][br]I, [[u][field][/u]] certify that I have reviewed and approved of provided blueprints. I have verified that design will be structurally sound and fall within building guidelines. I and any others participating in its construction will ensure that the blueprint will be followed.[br][br][br][b]Blueprint:[/b] [field][br][br][hr][grid][row][cell][list][b]Constructing Engineer signature:[/b][/list][cell][list][list][list][list][list][b]Chief Engineer signature:[/b][/list][/list][/list][/list][/list][cell][br][row][cell][list] - [field][/list][cell][list][list][list][list][list]- [large][field][/large][/list][/list][/list][/list][/list][cell][/grid]"}
			revision = "Revision 1.1"
		//Service forms, SER-6
		if("SER-6005")
			content = @{"[hr][br][center]This is to certify that[br][br][u]_[field]_[/u] and [u]_[field]_[/u][br][br]were united in marriage at [u]_[field]_[/u] on date [u]_[field]_[/u][br][br][hr][grid][row][cell][list][b]Bride:[/b][/list][cell][cell][list][list][list][list][b]Groom:[/b][/list][/list][/list][/list][cell][row][cell][list] - [large][field][/large][/list][cell][cell][list][list][list][list]- [large][field][/large][/list][/list][/list][/list][cell][/grid][hr][br][b]Chaplain:[/b] [large][field][/large]"}
			revision = "Revision 1.4"
		//Explorer forms, EXP-7
		//Event forms, EVNT-8
		//Other forms, OTHR-9
		if("OTHR-9001")
			content = @{"[grid][row][cell][b]Sender:[/b] [cell][field][br][row][cell][b]Position:[/b] [cell][field][/grid][br][hr][br][b]Message:[/b] [field][br][br][hr][grid][row][cell][list][b]Signed:[/b][/list][cell][br][row][cell][list] - [large][field][/large][/list][cell][/grid]"}
			revision = "Revision: 1.0"
		if("OTHR-9032")
			content = @{"[b]Requested Owner:[/b] [field][br][br][hr][br][b]Hereby, I [[/b][field][b]] agree to transfer my full ownsership, including all my rights to [[/b][field][b]].[br]This contract is binding immediately after both parties have signed and valid until [[/b][field][b]].[/b][br][br]Additional Agreements: [field][br][br][hr][grid][row][cell][list][b]Property Signature:[/b][/list][cell][list][list][list][list][list][b]Owner Signature:[/b][/list][cell][br][row][cell][list]- [field][/list][cell][list][list][list][list][list]- [field][/list][cell][/grid][hr][br]The contract can only be cancelled if both parties agree.[br]At no time, a single party can revert or void this contract.[br]All changes to this form after the contract was stamped are invalidated.[br][br]"}
			revision = "Revision: 1.0"
		//Mercenary forms, MERC-?
		if("MERC-?071")
			content = @{"[b]Requested Mercenary:[/b] [field][br][br][hr][br][grid][row][cell][b]Target:[/b] [cell][field][br][row][cell][b]Reason:[/b] [cell][field][/grid][br][grid][row][cell][list][b]Vore Type:[/b][/list][cell][list][field][/list][cell][list][list][list][b]Offered Bounty:[/b][/list][/list][/list][cell][list][field][/list][cell][br][row][cell][list][b]Extra Modules:[/b][/list][cell][list][field][/list][cell][list][list][list][b]Added Module Costs:[/b][/list][/list][/list][cell][list][field][/list][cell][br][row][cell][list][b]Special Requests:[/b][/list][cell][list][field][/list][cell][list][list][list][b]Added Request Fees:[/b][/list][/list][/list][cell][list][field][/list][cell][br][row][cell][cell][cell][cell][cell][br][row][cell][cell][cell][list][list][list][b]Total Bounty:[/b][/list][cell][list][field][/list][cell][/grid][br][hr][br]All payments are to be made in full before contract fulfilment.[br]Please be aware that signed contracts can [u]not[/u] be cancelled.[br][br][hr][grid][row][cell][list][b]Commissioner signature:[/b][/list][cell][list][list][list][list][list][b]Contractor signature:[/b][/list][/list][/list][/list][/list][cell][br][row][cell][list][large] - [field][/large][/list][cell][large][list][list][list][list][list]- [field][/large][cell][/list][/list][/list][/list][/list][cell][/grid]"}
			revision = "Revision: ?.?"
		else
			paperid = @{"[field]"}
			name = @{"[field]"}
			content = @{"[field]"}
			revision = @{"[field]"}
	return create_form(paperid, name, content, revision)

/obj/item/form_printer/proc/create_form(paperid, name, content, revision)
	var/header = "\[center]\[br]\[small]" + paperid + "\[/small]\[br]\[h1]\[u]" + name + "\[/u]\[/h1]\[br]\[logo]\[br]\[br]\[station]\[br]\[/center]\[br]\[hr]\[br]\[b]Station Time:\[/b] \[date], \[time]\[br]\[br]"
	var/footer = "\[hr]\[br]\[center]\[small]Stamp here.\[/small]\[/center]\[br]\[small]" + revision + "\[/small]"
	return header + content + footer

//Personal shielding for the combat module.
/obj/item/borg/combat/shield
	name = "personal shielding"
	desc = "A powerful experimental module that turns aside or absorbs incoming attacks at the cost of charge."
	icon = 'icons/obj/decals.dmi'
	icon_state = "shock"
	var/shield_level = 0.5			//Percentage of damage absorbed by the shield.
	var/active = 1					//If the shield is on
	var/flash_count = 0				//Counter for how many times the shield has been flashed
	var/overload_threshold = 3		//Number of flashes it takes to overload the shield
	var/shield_refresh = 15 SECONDS	//Time it takes for the shield to reboot after destabilizing
	var/overload_time = 0			//Stores the time of overload
	var/last_flash = 0				//Stores the time of last flash

/obj/item/borg/combat/shield/New()
	START_PROCESSING(SSobj, src)
	..()

/obj/item/borg/combat/shield/Destroy()
	STOP_PROCESSING(SSobj, src)
	..()

/obj/item/borg/combat/shield/attack_self(var/mob/living/user)
	set_shield_level()

/obj/item/borg/combat/shield/process()
	if(active)
		if(flash_count && (last_flash + shield_refresh < world.time))
			flash_count = 0
			last_flash = 0
	else if(overload_time + shield_refresh < world.time)
		active = 1
		flash_count = 0
		overload_time = 0

		var/mob/living/user = src.loc
		user.visible_message("<span class='danger'>[user]'s shield reactivates!</span>", "<span class='danger'>Your shield reactivates!</span>")
		user.update_icon()

/obj/item/borg/combat/shield/proc/adjust_flash_count(var/mob/living/user, amount)
	if(active)			//Can't destabilize a shield that's not on
		flash_count += amount

		if(amount > 0)
			last_flash = world.time
			if(flash_count >= overload_threshold)
				overload(user)

/obj/item/borg/combat/shield/proc/overload(var/mob/living/user)
	active = 0
	user.visible_message("<span class='danger'>[user]'s shield destabilizes!</span>", "<span class='danger'>Your shield destabilizes!</span>")
	user.update_icon()
	overload_time = world.time

/obj/item/borg/combat/shield/verb/set_shield_level()
	set name = "Set shield level"
	set category = "Object"
	set src in range(0)

	var/N = tgui_input_list(usr, "How much damage should the shield absorb?", "Shield Level", list("5","10","25","50","75","100"))
	if (N)
		shield_level = text2num(N)/100

/obj/item/borg/combat/mobility
	name = "mobility module"
	desc = "By retracting limbs and tucking in its head, a combat android can roll at high speeds."
	icon = 'icons/obj/decals.dmi'
	icon_state = "shock"

/obj/item/inflatable_dispenser
	name = "inflatables dispenser"
	desc = "Hand-held device which allows rapid deployment and removal of inflatables."
	icon = 'icons/obj/storage.dmi'
	icon_state = "inf_deployer"
	w_class = ITEMSIZE_LARGE

	var/stored_walls = 5
	var/stored_doors = 2
	var/max_walls = 5
	var/max_doors = 2
	var/mode = 0 // 0 - Walls   1 - Doors

/obj/item/inflatable_dispenser/robot
	w_class = ITEMSIZE_HUGE
	stored_walls = 10
	stored_doors = 5
	max_walls = 10
	max_doors = 5

/obj/item/inflatable_dispenser/examine(var/mob/user)
	. = ..()
	. += "It has [stored_walls] wall segment\s and [stored_doors] door segment\s stored."
	. += "It is set to deploy [mode ? "doors" : "walls"]"

/obj/item/inflatable_dispenser/attack_self()
	mode = !mode
	to_chat(usr, "<span class='filter_notice'>You set \the [src] to deploy [mode ? "doors" : "walls"].</span>")

/obj/item/inflatable_dispenser/afterattack(var/atom/A, var/mob/user)
	..(A, user)
	if(!user)
		return
	if(!user.Adjacent(A))
		to_chat(user, "<span class='filter_notice'>You can't reach!</span>")
		return
	if(istype(A, /turf))
		try_deploy_inflatable(A, user)
	if(istype(A, /obj/item/inflatable) || istype(A, /obj/structure/inflatable))
		pick_up(A, user)

/obj/item/inflatable_dispenser/proc/try_deploy_inflatable(var/turf/T, var/mob/living/user)
	if(mode) // Door deployment
		if(!stored_doors)
			to_chat(user, "<span class='filter_notice'>\The [src] is out of doors!</span>")
			return

		if(T && istype(T))
			new /obj/structure/inflatable/door(T)
			stored_doors--

	else // Wall deployment
		if(!stored_walls)
			to_chat(user, "<span class='filter_notice'>\The [src] is out of walls!</span>")
			return

		if(T && istype(T))
			new /obj/structure/inflatable(T)
			stored_walls--

	playsound(T, 'sound/items/zip.ogg', 75, 1)
	to_chat(user, "<span class='filter_notice'>You deploy the inflatable [mode ? "door" : "wall"]!</span>")

/obj/item/inflatable_dispenser/proc/pick_up(var/obj/A, var/mob/living/user)
	if(istype(A, /obj/structure/inflatable))
		if(!istype(A, /obj/structure/inflatable/door))
			if(stored_walls >= max_walls)
				to_chat(user, "<span class='filter_notice'>\The [src] is full.</span>")
				return
			stored_walls++
			qdel(A)
		else
			if(stored_doors >= max_doors)
				to_chat(user, "<span class='filter_notice'>\The [src] is full.</span>")
				return
			stored_doors++
			qdel(A)
		playsound(src, 'sound/machines/hiss.ogg', 75, 1)
		visible_message("<span class='filter_notice'>\The [user] deflates \the [A] with \the [src]!</span>")
		return
	if(istype(A, /obj/item/inflatable))
		if(!istype(A, /obj/item/inflatable/door))
			if(stored_walls >= max_walls)
				to_chat(user, "<span class='filter_notice'>\The [src] is full.</span>")
				return
			stored_walls++
			qdel(A)
		else
			if(stored_doors >= max_doors)
				to_chat(usr, "<span class='filter_notice'>\The [src] is full!</span>")
				return
			stored_doors++
			qdel(A)
		visible_message("<span class='filter_notice'>\The [user] picks up \the [A] with \the [src]!</span>")
		return

	to_chat(user, "<span class='filter_notice'>You fail to pick up \the [A] with \the [src].</span>")
	return
