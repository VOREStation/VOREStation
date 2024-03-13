//DNA machine
/obj/machinery/dnaforensics
	name = "DNA analyzer"
	desc = "A high tech machine that is designed to read DNA samples properly."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "dnaopen"
	anchored = TRUE
	density = TRUE
	circuit = /obj/item/weapon/circuitboard/dna_analyzer

	var/obj/item/weapon/forensics/swab/bloodsamp = null
	var/scanning = 0
	var/scanner_progress = 0
	var/scanner_rate = 5
	var/last_process_worldtime = 0
	var/report_num = 0

/obj/machinery/dnaforensics/Initialize()
	. = ..()
	default_apply_parts()

/obj/machinery/dnaforensics/attackby(obj/item/W, mob/user)
	if(bloodsamp)
		to_chat(user, "<span class='warning'>There is a sample in the machine.</span>")
		return

	if(scanning)
		to_chat(user, "<span class='warning'>[src] is busy scanning right now.</span>")
		return

	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return

	var/obj/item/weapon/forensics/swab/swab = W
	if(istype(swab) && swab.is_used())
		user.unEquip(W)
		bloodsamp = swab
		swab.forceMove(src)
		to_chat(user, "<span class='notice'>You insert [W] into [src].</span>")
		update_icon()
	else
		to_chat(user, "<span class='warning'>\The [src] only accepts used swabs.</span>")
		return

/obj/machinery/dnaforensics/tgui_interact(mob/user, datum/tgui/ui)
	if(stat & (NOPOWER))
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DNAForensics", "QuikScan DNA Analyzer") // 540, 326
		ui.open()

/obj/machinery/dnaforensics/tgui_data(mob/user)
	var/list/data = ..()
	data["scan_progress"] = round(scanner_progress)
	data["scanning"] = scanning
	data["bloodsamp"] = (bloodsamp ? bloodsamp.name : "")
	data["bloodsamp_desc"] = (bloodsamp ? (bloodsamp.desc ? bloodsamp.desc : "No information on record.") : "")
	return data

/obj/machinery/dnaforensics/tgui_act(action, list/params)
	if(..())
		return TRUE

	if(stat & (NOPOWER))
		return FALSE // don't update UIs attached to this object

	. = TRUE
	switch(action)
		if("scanItem")
			if(scanning)
				scanning = FALSE
				update_icon()
			else
				if(bloodsamp)
					scanner_progress = 0
					scanning = TRUE
					to_chat(usr, "<span class='notice'>Scan initiated.</span>")
					update_icon()
				else
					to_chat(usr, "<span class='warning'>Insert an item to scan.</span>")
			. = TRUE

		if("ejectItem")
			if(bloodsamp)
				bloodsamp.forceMove(loc)
				bloodsamp = null
				scanning = FALSE
				update_icon()

/obj/machinery/dnaforensics/process()
	if(scanning)
		if(!bloodsamp || bloodsamp.loc != src)
			bloodsamp = null
			scanning = 0
		else if(scanner_progress >= 100)
			complete_scan()
			return
		else
			//calculate time difference
			var/deltaT = (world.time - last_process_worldtime) * 0.1
			scanner_progress = min(100, scanner_progress + scanner_rate * deltaT)
	last_process_worldtime = world.time

/obj/machinery/dnaforensics/proc/complete_scan()
	visible_message("<span class='notice'>[icon2html(src,viewers(src))] makes an insistent chime.</span>", 2)
	update_icon()
	if(bloodsamp)
		var/obj/item/weapon/paper/P = new(src)
		P.name = "[src] report #[++report_num]: [bloodsamp.name]"
		P.stamped = list(/obj/item/weapon/stamp)
		P.cut_overlays()
		P.add_overlay("paper_stamped")
		//dna data itself
		var/data = "No scan information available."
		if(bloodsamp.dna != null)
			data = "Spectometric analysis on provided sample has determined the presence of [bloodsamp.dna.len] strings of DNA.<br><br>"
			for(var/blood in bloodsamp.dna)
				data += "<font color='blue'>Blood type: [bloodsamp.dna[blood]]<br>\nDNA: [blood]<br><br></font>"
		else
			data += "No DNA found.<br>"
		P.info = "<b>[src] analysis report #[report_num]</b><br>"
		P.info += "<b>Scanned item:</b><br>[bloodsamp.name]<br>[bloodsamp.desc]<br><br>" + data
		P.forceMove(loc)
		P.update_icon()
		scanning = FALSE
		update_icon()
	return

/obj/machinery/dnaforensics/attack_ai(mob/user)
	tgui_interact(user)

/obj/machinery/dnaforensics/attack_hand(mob/user)
	tgui_interact(user)

/obj/machinery/dnaforensics/update_icon()
	..()
	if(!(stat & NOPOWER) && scanning)
		icon_state = "dnaworking"
	else if(bloodsamp)
		icon_state = "dnaclosed"
	else
		icon_state = "dnaopen"
