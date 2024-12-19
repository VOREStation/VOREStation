// Pretty much everything here is stolen from the dna scanner FYI

/obj/machinery/bodyscanner
	var/mob/living/carbon/human/occupant
	var/locked
	name = "Body Scanner"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "body_scanner_0"
	density = TRUE
	anchored = TRUE
	unacidable = TRUE
	circuit = /obj/item/circuitboard/body_scanner
	use_power = USE_POWER_IDLE
	idle_power_usage = 60
	active_power_usage = 10000	//10 kW. It's a big all-body scanner.
	light_color = "#00FF00"
	var/obj/machinery/body_scanconsole/console
	var/printing_text = null

/obj/machinery/bodyscanner/Initialize()
	. = ..()
	default_apply_parts()

/obj/machinery/bodyscanner/Destroy()
	if(console)
		console.scanner = null
	return ..()

/obj/machinery/bodyscanner/power_change()
	..()
	if(!(stat & (BROKEN|NOPOWER)))
		set_light(2)
	else
		set_light(0)

/obj/machinery/bodyscanner/attackby(var/obj/item/G, user as mob)
	if(istype(G, /obj/item/grab))
		var/obj/item/grab/H = G
		if(panel_open)
			to_chat(user, span_notice("Close the maintenance panel first."))
			return
		if(!ismob(H.affecting))
			return
		if(!ishuman(H.affecting))
			to_chat(user, span_warning("\The [src] is not designed for that organism!"))
			return
		if(occupant)
			to_chat(user, span_notice("\The [src] is already occupied!"))
			return
		if(H.affecting.has_buckled_mobs())
			to_chat(user, span_warning("\The [H.affecting] has other entities attached to it. Remove them first."))
			return
		var/mob/M = H.affecting
		if(M.abiotic())
			to_chat(user, span_notice("Subject cannot have abiotic items on."))
			return
		M.forceMove(src)
		occupant = M
		update_icon() //icon_state = "body_scanner_1" //VOREStation Edit - Health display for consoles with light and such.
		playsound(src, 'sound/machines/medbayscanner1.ogg', 50) // Beepboop you're being scanned. <3
		add_fingerprint(user)
		qdel(G)
		SStgui.update_uis(src)
	if(!occupant)
		if(default_deconstruction_screwdriver(user, G))
			return
		if(default_deconstruction_crowbar(user, G))
			return

/obj/machinery/bodyscanner/MouseDrop_T(mob/living/carbon/human/O, mob/user as mob)
	if(!istype(O))
		return 0 //not a mob
	if(user.incapacitated())
		return 0 //user shouldn't be doing things
	if(O.anchored)
		return 0 //mob is anchored???
	if(get_dist(user, src) > 1 || get_dist(user, O) > 1)
		return 0 //doesn't use adjacent() to allow for non-cardinal (fuck my life)
	if(!ishuman(user) && !isrobot(user))
		return 0 //not a borg or human
	if(panel_open)
		to_chat(user, span_notice("Close the maintenance panel first."))
		return 0 //panel open
	if(occupant)
		to_chat(user, span_notice("\The [src] is already occupied."))
		return 0 //occupied

	if(O.buckled)
		return 0
	if(O.abiotic())
		to_chat(user, span_notice("Subject cannot have abiotic items on."))
		return 0
	if(O.has_buckled_mobs())
		to_chat(user, span_warning("\The [O] has other entities attached to it. Remove them first."))
		return

	if(O == user)
		visible_message("[user] climbs into \the [src].")
	else
		visible_message("[user] puts [O] into the body scanner.")

	O.forceMove(src)
	occupant = O
	update_icon() //icon_state = "body_scanner_1" //VOREStation Edit - Health display for consoles with light and such.
	playsound(src, 'sound/machines/medbayscanner1.ogg', 50) // Beepboop you're being scanned. <3
	add_fingerprint(user)
	SStgui.update_uis(src)

/obj/machinery/bodyscanner/relaymove(mob/user as mob)
	if(user.incapacitated())
		return 0 //maybe they should be able to get out with cuffs, but whatever
	go_out()

/obj/machinery/bodyscanner/verb/eject()
	set src in oview(1)
	set category = "Object"
	set name = "Eject Body Scanner"

	if(usr.incapacitated())
		return
	go_out()
	add_fingerprint(usr)

/obj/machinery/bodyscanner/proc/go_out()
	if ((!(occupant) || src.locked))
		return
	if (occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	occupant.forceMove(src.loc) // was occupant.loc = src.loc, but that doesn't trigger exit(), and thus recursive radio listeners forwarded messages to the occupant as if they were still inside it for the rest of the round! OP21 #5f88307 Port
	occupant = null
	update_icon() //icon_state = "body_scanner_1" //VOREStation Edit - Health display for consoles with light and such.
	SStgui.update_uis(src)
	return

/obj/machinery/bodyscanner/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/atom/movable/A as mob|obj in src)
				A.loc = src.loc
				ex_act(severity)
				//Foreach goto(35)
			//SN src = null
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
					//Foreach goto(108)
				//SN src = null
				qdel(src)
				return
		if(3.0)
			if (prob(25))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
					//Foreach goto(181)
				//SN src = null
				qdel(src)
				return
		else
	return

/obj/machinery/bodyscanner/tgui_host(mob/user)
	if(user == occupant)
		return src
	return console ? console : src

/obj/machinery/bodyscanner/tgui_interact(mob/user, datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BodyScanner", "Body Scanner")
		ui.open()

/obj/machinery/bodyscanner/tgui_data(mob/user)
	var/list/data = list()

	data["occupied"] = occupant ? TRUE : FALSE

	var/occupantData[0]
	if(occupant && ishuman(occupant))
		update_icon() //VOREStation Edit - Health display for consoles with light and such.
		var/mob/living/carbon/human/H = occupant
		occupantData["name"] = H.name
		occupantData["stat"] = H.stat
		occupantData["health"] = H.health
		occupantData["maxHealth"] = H.getMaxHealth()

		occupantData["hasVirus"] = LAZYLEN(H.viruses)

		occupantData["bruteLoss"] = H.getBruteLoss()
		occupantData["oxyLoss"] = H.getOxyLoss()
		occupantData["toxLoss"] = H.getToxLoss()
		occupantData["fireLoss"] = H.getFireLoss()

		occupantData["radLoss"] = H.radiation
		occupantData["cloneLoss"] = H.getCloneLoss()
		occupantData["brainLoss"] = H.getBrainLoss()
		occupantData["paralysis"] = H.paralysis
		occupantData["paralysisSeconds"] = round(H.paralysis / 4)
		occupantData["bodyTempC"] = H.bodytemperature-T0C
		occupantData["bodyTempF"] = (((H.bodytemperature-T0C) * 1.8) + 32)

		occupantData["hasBorer"] = H.has_brain_worms()
		occupantData["colourblind"] = null
		for(var/datum/modifier/M in H.modifiers)
			if(!isnull(M.wire_colors_replace))
				occupantData["colourblind"] = LAZYLEN(M.wire_colors_replace)
				break

		var/bloodData[0]
		if(H.vessel)
			var/blood_volume = round(H.vessel.get_reagent_amount(REAGENT_ID_BLOOD))
			var/blood_max = H.species.blood_volume
			bloodData["volume"] = blood_volume
			bloodData["percent"] = round(((blood_volume / blood_max)*100))

		occupantData["blood"] = bloodData

		var/reagentData[0]
		if(H.reagents.reagent_list.len >= 1)
			for(var/datum/reagent/R in H.reagents.reagent_list)
				reagentData[++reagentData.len] = list(
					"name" = R.name,
					"amount" = R.volume,
					"overdose" = (R.overdose && R.volume > R.overdose) ? TRUE : FALSE,
				)
		else
			reagentData = null

		occupantData["reagents"] = reagentData

		var/ingestedData[0]
		if(H.ingested.reagent_list.len >= 1)
			for(var/datum/reagent/R in H.ingested.reagent_list)
				ingestedData[++ingestedData.len] = list(
					"name" = R.name,
					"amount" = R.volume,
					"overdose" = (R.overdose && R.volume > R.overdose) ? TRUE : FALSE,
				)
		else
			ingestedData = null

		occupantData["ingested"] = ingestedData

		var/extOrganData[0]
		for(var/obj/item/organ/external/E in H.organs)
			var/organData[0]
			organData["name"] = E.name
			organData["open"] = E.open
			organData["germ_level"] = E.germ_level
			organData["bruteLoss"] = E.brute_dam
			organData["fireLoss"] = E.burn_dam
			organData["totalLoss"] = E.brute_dam + E.burn_dam
			organData["maxHealth"] = E.max_damage
			organData["bruised"] = E.min_bruised_damage
			organData["broken"] = E.min_broken_damage

			var/implantData[0]
			for(var/obj/thing in E.implants)
				var/implantSubData[0]
				var/obj/item/implant/I = thing
			//VOREStation Block Edit Start
				var/obj/item/nif/N = thing
				if(istype(I))
					implantSubData["name"] =  I.name
					implantSubData["known"] = istype(I) && I.known_implant
					implantData.Add(list(implantSubData))
				else
					implantSubData["name"] =  N.name
					implantSubData["known"] = istype(N) && N.known_implant
					implantData.Add(list(implantSubData))
			//VOREStation Block Edit End

			organData["implants"] = implantData
			organData["implants_len"] = implantData.len

			var/organStatus[0]
			if(E.status & ORGAN_DESTROYED)
				organStatus["destroyed"] = 1
			if(E.status & ORGAN_BROKEN)
				organStatus["broken"] = E.broken_description
			if(E.robotic >= ORGAN_ROBOT)
				organStatus["robotic"] = 1
			if(E.splinted)
				organStatus["splinted"] = 1
			if(E.status & ORGAN_BLEEDING)
				organStatus["bleeding"] = 1
			if(E.status & ORGAN_DEAD)
				organStatus["dead"] = 1

			organData["status"] = organStatus

			if(istype(E, /obj/item/organ/external/chest) && H.is_lung_ruptured())
				organData["lungRuptured"] = 1

			for(var/datum/wound/W in E.wounds)
				if(W.internal)
					organData["internalBleeding"] = 1
					break

			extOrganData.Add(list(organData))

		occupantData["extOrgan"] = extOrganData

		var/intOrganData[0]
		for(var/obj/item/organ/I in H.internal_organs)
			var/organData[0]
			organData["name"] = I.name
			if(I.status & ORGAN_ASSISTED)
				organData["desc"] = "Assisted"
			else if(I.robotic >= ORGAN_ROBOT)
				organData["desc"] = "Mechanical"
			else
				organData["desc"] = null
			organData["germ_level"] = I.germ_level
			organData["damage"] = I.damage
			organData["maxHealth"] = I.max_damage
			organData["bruised"] = I.min_bruised_damage
			organData["broken"] = I.min_broken_damage
			organData["robotic"] = (I.robotic >= ORGAN_ROBOT)
			organData["dead"] = (I.status & ORGAN_DEAD)

			if(istype(I, /obj/item/organ/internal/appendix))
				var/obj/item/organ/internal/appendix/A = I
				organData["inflamed"] = A.inflamed

			intOrganData.Add(list(organData))

		occupantData["intOrgan"] = intOrganData

		occupantData["blind"] = (H.sdisabilities & BLIND)
		occupantData["nearsighted"] = (H.disabilities & NEARSIGHTED)
		occupantData["husked"] = (HUSK in H.mutations) // VOREstation edit
		occupantData = attempt_vr(src, "get_occupant_data_vr", list(occupantData, H)) //VOREStation Insert
	data["occupant"] = occupantData

	return data

/obj/machinery/bodyscanner/tgui_act(action, params)
	if(..())
		return TRUE

	. = TRUE
	switch(action)
		if("ejectify")
			eject()
		if("print_p")
			var/atom/target = console ? console : src
			visible_message(span_notice("[target] rattles and prints out a sheet of paper."))
			playsound(src, 'sound/machines/printer.ogg', 50, 1)
			var/obj/item/paper/P = new /obj/item/paper(get_turf(target))
			var/name = occupant ? occupant.name : "Unknown"
			P.info = "<CENTER>" + span_bold("Body Scan - [name]") + "</CENTER><BR>"
			P.info += span_bold("Time of scan:") + " [stationtime2text()]<br><br>"
			P.info += "[generate_printing_text()]"
			P.info += "<br><br>" + span_bold("Notes:") + "<br>"
			P.name = "Body Scan - [name] ([stationtime2text()])"
		else
			return FALSE

/obj/machinery/bodyscanner/proc/generate_printing_text()
	var/dat = ""

	dat = span_blue(span_bold("Occupant Statistics:")) + "<br>" //Blah obvious
	if(istype(occupant)) //is there REALLY someone in there?
		var/t1
		switch(occupant.stat) // obvious, see what their status is
			if(0)
				t1 = "Conscious"
			if(1)
				t1 = "Unconscious"
			else
				t1 = "*dead*"
		var/health_text = "\tHealth %: [(occupant.health / occupant.getMaxHealth())*100], ([t1])"
		dat += (occupant.health > (occupant.getMaxHealth() / 2) ? span_blue(health_text) : span_red(health_text))
		dat += "<br>"

		if(LAZYLEN(occupant.viruses))
			for(var/datum/disease/D in occupant.GetViruses())
				if(D.visibility_flags & HIDDEN_SCANNER)
					continue
				else
					dat += span_red("Viral pathogen detected in blood stream.") + "<BR>"

		var/damage_string = null
		damage_string = "\t-Brute Damage %: [occupant.getBruteLoss()]"
		dat += (occupant.getBruteLoss() < 60 ? span_blue(damage_string) : span_red(damage_string)) + "<br>"
		damage_string = "\t-Respiratory Damage %: [occupant.getOxyLoss()]"
		dat += (occupant.getOxyLoss() < 60 ? span_blue(damage_string) : span_red(damage_string)) + "<br>"

		damage_string = "\t-Toxin Content %: [occupant.getToxLoss()]"
		dat += (occupant.getToxLoss() < 60 ? span_blue(damage_string) : span_red(damage_string)) + "<br>"

		damage_string = "\t-Burn Severity %: [occupant.getFireLoss()]"
		dat += (occupant.getFireLoss() < 60 ? span_blue(damage_string) : span_red(damage_string)) + "<br>"

		damage_string = "\tRadiation Level %: [occupant.radiation]"
		dat += (occupant.radiation < 10 ? span_blue(damage_string) : span_red(damage_string)) + "<br>"

		damage_string = "\tGenetic Tissue Damage %: [occupant.getCloneLoss()]"
		dat += (occupant.getCloneLoss() < 1 ? span_blue(damage_string) : span_red(damage_string)) + "<br>"

		damage_string = "\tApprox. Brain Damage %: [occupant.getBrainLoss()]"
		dat += (occupant.getBrainLoss() < 1 ? span_blue(damage_string) : span_red(damage_string)) + "<br>"

		dat += "Paralysis Summary %: [occupant.paralysis] ([round(occupant.paralysis / 4)] seconds left!)<br>"
		dat += "Body Temperature: [occupant.bodytemperature-T0C]&deg;C ([occupant.bodytemperature*1.8-459.67]&deg;F)<br>"

		dat += "<hr>"

		if(occupant.has_brain_worms())
			dat += "Large growth detected in frontal lobe, possibly cancerous. Surgical removal is recommended.<br>"

		if(occupant.vessel)
			var/blood_volume = round(occupant.vessel.get_reagent_amount(REAGENT_ID_BLOOD))
			var/blood_max = occupant.species.blood_volume
			var/blood_percent =  blood_volume / blood_max
			blood_percent *= 100

			damage_string = "\tBlood Level %: [blood_percent] ([blood_volume] units)"
			dat += (blood_volume > 448 ? span_blue(damage_string) : span_red(damage_string)) + "<br>"

		if(occupant.reagents)
			for(var/datum/reagent/R in occupant.reagents.reagent_list)
				dat += "Reagent: [R.name], Amount: [R.volume]<br>"

		if(occupant.ingested)
			for(var/datum/reagent/R in occupant.ingested.reagent_list)
				dat += "Stomach: [R.name], Amount: [R.volume]<br>"

		dat += "<hr><table border='1'>"
		dat += "<tr>"
		dat += "<th>Organ</th>"
		dat += "<th>Burn Damage</th>"
		dat += "<th>Brute Damage</th>"
		dat += "<th>Other Wounds</th>"
		dat += "</tr>"

		for(var/obj/item/organ/external/e in occupant.organs)
			dat += "<tr>"
			var/AN = ""
			var/open = ""
			var/infected = ""
			var/robot = ""
			var/imp = ""
			var/bled = ""
			var/splint = ""
			var/internal_bleeding = ""
			var/lung_ruptured = ""
			var/o_dead = ""
			for(var/datum/wound/W in e.wounds) if(W.internal)
				internal_bleeding = "<br>Internal bleeding"
				break
			if(istype(e, /obj/item/organ/external/chest) && occupant.is_lung_ruptured())
				lung_ruptured = "Lung ruptured:"
			if(e.splinted)
				splint = "Splinted:"
			if(e.status & ORGAN_BLEEDING)
				bled = "Bleeding:"
			if(e.status & ORGAN_BROKEN)
				AN = "[e.broken_description]:"
			if(e.robotic >= ORGAN_ROBOT)
				robot = "Prosthetic:"
			if(e.status & ORGAN_DEAD)
				o_dead = "Necrotic:"
			if(e.open)
				open = "Open:"
			switch (e.germ_level)
				if (INFECTION_LEVEL_ONE to INFECTION_LEVEL_ONE + 200)
					infected = "Mild Infection:"
				if (INFECTION_LEVEL_ONE + 200 to INFECTION_LEVEL_ONE + 300)
					infected = "Mild Infection+:"
				if (INFECTION_LEVEL_ONE + 300 to INFECTION_LEVEL_ONE + 400)
					infected = "Mild Infection++:"
				if (INFECTION_LEVEL_TWO to INFECTION_LEVEL_TWO + 200)
					infected = "Acute Infection:"
				if (INFECTION_LEVEL_TWO + 200 to INFECTION_LEVEL_TWO + 300)
					infected = "Acute Infection+:"
				if (INFECTION_LEVEL_TWO + 300 to INFECTION_LEVEL_THREE - 50)
					infected = "Acute Infection++:"
				if (INFECTION_LEVEL_THREE -49 to INFINITY)
					infected = "Gangrene Detected:"

			var/unknown_body = 0
			for(var/obj/item/implant/I as anything in e.implants)
				var/obj/item/nif/N = I //VOREStation Add: NIFs
				if(istype(I) && I.known_implant)
					imp += "[I] implanted:"
				else if(istype(N) && N.known_implant) //VOREStation Add: NIFs
					imp += "[N] implanted:"
				else
					unknown_body++

			if(unknown_body)
				imp += "Unknown body present:"
			if(!AN && !open && !infected && !imp)
				AN = "None:"
			if(!(e.status & ORGAN_DESTROYED))
				dat += "<td>[e.name]</td><td>[e.burn_dam]</td><td>[e.brute_dam]</td><td>[robot][bled][AN][splint][open][infected][imp][internal_bleeding][lung_ruptured][o_dead]</td>"
			else
				dat += "<td>[e.name]</td><td>-</td><td>-</td><td>Not Found</td>"
			dat += "</tr>"
		for(var/obj/item/organ/i in occupant.internal_organs)
			var/mech = ""
			var/i_dead = ""
			if(i.status & ORGAN_ASSISTED)
				mech = "Assisted:"
			if(i.robotic >= ORGAN_ROBOT)
				mech = "Mechanical:"
			if(i.status & ORGAN_DEAD)
				i_dead = "Necrotic"
			var/infection = "None"
			switch (i.germ_level)
				if (INFECTION_LEVEL_ONE to INFECTION_LEVEL_ONE + 200)
					infection = "Mild Infection"
				if (INFECTION_LEVEL_ONE + 200 to INFECTION_LEVEL_ONE + 300)
					infection = "Mild Infection+"
				if (INFECTION_LEVEL_ONE + 300 to INFECTION_LEVEL_ONE + 400)
					infection = "Mild Infection++"
				if (INFECTION_LEVEL_TWO to INFECTION_LEVEL_TWO + 200)
					infection = "Acute Infection"
				if (INFECTION_LEVEL_TWO + 200 to INFECTION_LEVEL_TWO + 300)
					infection = "Acute Infection+"
				if (INFECTION_LEVEL_TWO + 300 to INFECTION_LEVEL_THREE - 50)
					infection = "Acute Infection++"
				if (INFECTION_LEVEL_THREE -49 to INFINITY)
					infection = "Necrosis Detected"

			if(istype(i, /obj/item/organ/internal/appendix))
				var/obj/item/organ/internal/appendix/A = i
				if(A.inflamed)
					infection = "Inflammation detected!"

			dat += "<tr>"
			dat += "<td>[i.name]</td><td>N/A</td><td>[i.damage]</td><td>[infection]:[mech][i_dead]</td><td></td>"
			dat += "</tr>"
		dat += "</table>"
		if(occupant.sdisabilities & BLIND)
			dat += span_red("Cataracts detected.") + "<BR>"
		if(occupant.disabilities & NEARSIGHTED)
			dat += span_red("Retinal misalignment detected.") + "<BR>"
		if(HUSK in occupant.mutations) // VOREstation edit
			dat += span_red("Anatomical structure lost, resuscitation not possible!") + "<BR>"
	else
		dat += "\The [src] is empty."

	return dat

//Body Scan Console
/obj/machinery/body_scanconsole
	var/obj/machinery/bodyscanner/scanner
	var/delete
	var/temphtml
	name = "Body Scanner Console"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "body_scannerconsole"
	dir = 8
	density = FALSE
	anchored = TRUE
	unacidable = TRUE
	circuit = /obj/item/circuitboard/scanner_console
	var/printing = null

/obj/machinery/body_scanconsole/New()
	..()
	findscanner()

/obj/machinery/body_scanconsole/Destroy()
	if(scanner)
		scanner.console = null
	return ..()

/obj/machinery/body_scanconsole/attackby(var/obj/item/I, var/mob/user)
	if(computer_deconstruction_screwdriver(user, I))
		return
	else if(istype(I, /obj/item/multitool)) //Did you want to link it?
		var/obj/item/multitool/P = I
		if(P.connectable)
			if(istype(P.connectable, /obj/machinery/bodyscanner))
				var/obj/machinery/bodyscanner/C = P.connectable
				scanner = C
				C.console = src
				to_chat(user, span_warning(" You link the [src] to the [P.connectable]!"))
		else
			to_chat(user, span_warning(" You store the [src] in the [P]'s buffer!"))
			P.connectable = src
		return
	else
		return attack_hand(user)

/obj/machinery/body_scanconsole/power_change()
	/* VOREStation Removal
	if(stat & BROKEN)
		icon_state = "body_scannerconsole-p"
	else if(powered() && !panel_open)
		icon_state = initial(icon_state)
		stat &= ~NOPOWER
	else
		spawn(rand(0, 15))
			icon_state = "body_scannerconsole-p"
			stat |= NOPOWER
	*/
	update_icon() //icon_state = "body_scanner_1" //VOREStation Edit - Health display for consoles with light and such.

/obj/machinery/body_scanconsole/ex_act(severity)
	switch(severity)
		if(1.0)
			//SN src = null
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				//SN src = null
				qdel(src)
				return
		else
	return

/obj/machinery/body_scanconsole/proc/findscanner()
	spawn(5)
		var/obj/machinery/bodyscanner/bodyscannernew = null
		// Loop through every direction
		for(dir in list(NORTH, EAST, SOUTH, WEST)) // Loop through every direction
			bodyscannernew = locate(/obj/machinery/bodyscanner, get_step(src, dir)) // Try to find a scanner in that direction
			if(bodyscannernew)
				scanner = bodyscannernew
				bodyscannernew.console = src
				set_dir(get_dir(src, bodyscannernew))
				return
		return

/obj/machinery/body_scanconsole/attack_ai(user as mob)
	return attack_hand(user)

/obj/machinery/body_scanconsole/attack_ghost(user as mob)
	return attack_hand(user)

/obj/machinery/body_scanconsole/attack_hand(user as mob)
	if(stat & (NOPOWER|BROKEN))
		return

	if(!scanner)
		findscanner()
		if(!scanner)
			to_chat(user, span_notice("Scanner not found!"))
			return

	if(scanner.panel_open)
		to_chat(user, span_notice("Close the maintenance panel first."))
		return

	if(scanner)
		return scanner.tgui_interact(user)
