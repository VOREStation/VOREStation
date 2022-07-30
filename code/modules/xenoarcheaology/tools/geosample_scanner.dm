/obj/machinery/radiocarbon_spectrometer
	name = "radiocarbon spectrometer"
	desc = "A specialised, complex scanner for gleaning information on all manner of small things."
	anchored = TRUE
	density = TRUE
	icon = 'icons/obj/virology_vr.dmi' //VOREStation Edit
	icon_state = "analyser"

	use_power = USE_POWER_IDLE
	idle_power_usage = 20
	active_power_usage = 300

	//var/obj/item/reagent_containers/glass/coolant_container
	var/scanning = 0
	var/report_num = 0
	//
	var/obj/item/scanned_item
	var/last_scan_data = "No scans on record."
	//
	var/last_process_worldtime = 0
	//
	var/scanner_progress = 0
	var/scanner_rate = 1.25			//80 seconds per scan
	var/scanner_rpm = 0
	var/scanner_rpm_dir = 1
	var/scanner_temperature = 0
	var/scanner_seal_integrity = 100
	//
	var/coolant_usage_rate = 0		//measured in u/microsec
	var/fresh_coolant = 0
	var/coolant_purity = 0
	var/datum/reagents/coolant_reagents
	var/used_coolant = 0
	var/list/coolant_reagents_purity = list()
	//
	var/maser_wavelength = 0
	var/optimal_wavelength = 0
	var/optimal_wavelength_target = 0
	var/tleft_retarget_optimal_wavelength = 0
	var/maser_efficiency = 0
	//
	var/radiation = 0				//0-100 mSv
	var/t_left_radspike = 0
	var/rad_shield = 0

/obj/machinery/radiocarbon_spectrometer/New()
	..()
	create_reagents(500)
	coolant_reagents_purity["water"] = 0.5
	coolant_reagents_purity["icecoffee"] = 0.6
	coolant_reagents_purity["icetea"] = 0.6
	coolant_reagents_purity["milkshake"] = 0.6
	coolant_reagents_purity["leporazine"] = 0.7
	coolant_reagents_purity["kelotane"] = 0.7
	coolant_reagents_purity["sterilizine"] = 0.7
	coolant_reagents_purity["dermaline"] = 0.7
	coolant_reagents_purity["hyperzine"] = 0.8
	coolant_reagents_purity["cryoxadone"] = 0.9
	coolant_reagents_purity["coolant"] = 1
	coolant_reagents_purity["adminordrazine"] = 2

/obj/machinery/radiocarbon_spectrometer/attackby(var/obj/I as obj, var/mob/user as mob)
	if(scanning)
		to_chat(user, "<span class='warning'>You can't do that while [src] is scanning!</span>")
	else
		if(istype(I, /obj/item/stack/nanopaste))
			var/choice = tgui_alert(usr, "What do you want to do with the nanopaste?","Radiometric Scanner",list("Scan nanopaste","Fix seal integrity"))
			if(choice == "Fix seal integrity")
				var/obj/item/stack/nanopaste/N = I
				var/amount_used = min(N.get_amount(), 10 - scanner_seal_integrity / 10)
				N.use(amount_used)
				scanner_seal_integrity = round(scanner_seal_integrity + amount_used * 10)
				return
		if(istype(I, /obj/item/reagent_containers/glass))
			var/obj/item/reagent_containers/glass/G = I
			if(!G.is_open_container())
				return
			var/choice = tgui_alert(usr, "What do you want to do with the container?","Radiometric Scanner",list("Add coolant","Empty coolant","Scan container"))
			if(choice == "Add coolant")
				var/amount_transferred = min(src.reagents.maximum_volume - src.reagents.total_volume, G.reagents.total_volume)
				var/trans = G.reagents.trans_to_obj(src, amount_transferred)
				to_chat(user, "<span class='info'>You empty [trans ? trans : 0]u of coolant into [src].</span>")
				update_coolant()
				return
			else if(choice == "Empty coolant")
				var/amount_transferred = min(G.reagents.maximum_volume - G.reagents.total_volume, src.reagents.total_volume)
				var/trans = src.reagents.trans_to(G, amount_transferred)
				to_chat(user, "<span class='info'>You remove [trans ? trans : 0]u of coolant from [src].</span>")
				update_coolant()
				return
		if(scanned_item)
			to_chat(user, "<span class=warning>\The [src] already has \a [scanned_item] inside!</span>")
			return
		user.drop_item()
		I.loc = src
		scanned_item = I
		to_chat(user, "<span class=notice>You put \the [I] into \the [src].</span>")

/obj/machinery/radiocarbon_spectrometer/proc/update_coolant()
	var/total_purity = 0
	fresh_coolant = 0
	coolant_purity = 0
	var/num_reagent_types = 0
	for (var/datum/reagent/current_reagent in src.reagents.reagent_list)
		if (!current_reagent)
			continue
		var/cur_purity = coolant_reagents_purity[current_reagent.id]
		if(!cur_purity)
			cur_purity = 0.1
		else if(cur_purity > 1)
			cur_purity = 1
		total_purity += cur_purity * current_reagent.volume
		fresh_coolant += current_reagent.volume
		num_reagent_types += 1
	if(total_purity && fresh_coolant)
		coolant_purity = total_purity / fresh_coolant

/obj/machinery/radiocarbon_spectrometer/attack_hand(mob/user)
	tgui_interact(user)

/obj/machinery/radiocarbon_spectrometer/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "XenoarchSpectrometer", name)
		ui.open()

/obj/machinery/radiocarbon_spectrometer/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	// this is the data which will be sent to the ui
	data["scanned_item"] = (scanned_item ? scanned_item.name : "")
	data["scanned_item_desc"] = (scanned_item ? (scanned_item.desc ? scanned_item.desc : "No information on record.") : "")
	data["last_scan_data"] = last_scan_data
	//
	data["scan_progress"] = round(scanner_progress)
	data["scanning"] = scanning
	//
	data["scanner_seal_integrity"] = round(scanner_seal_integrity)
	data["scanner_rpm"] = round(scanner_rpm)
	data["scanner_temperature"] = round(scanner_temperature)
	//
	data["coolant_usage_rate"] = coolant_usage_rate
	data["coolant_usage_max"] = 10
	data["unused_coolant_abs"] = round(fresh_coolant)
	data["unused_coolant_per"] = round(fresh_coolant / reagents.maximum_volume * 100)
	data["coolant_purity"] = coolant_purity * 100
	//
	data["optimal_wavelength"] = round(optimal_wavelength)
	data["maser_wavelength"] = round(maser_wavelength)
	data["maser_wavelength_max"] = 10000
	data["maser_efficiency"] = round(maser_efficiency * 100)
	//
	data["radiation"] = round(radiation)
	data["t_left_radspike"] = round(t_left_radspike)
	data["rad_shield_on"] = rad_shield

	return data

/obj/machinery/radiocarbon_spectrometer/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	add_fingerprint(usr)
	switch(action)
		if("scanItem")
			if(scanning)
				stop_scanning()
			else
				if(scanned_item)
					if(scanner_seal_integrity > 0)
						scanner_progress = 0
						scanning = 1
						t_left_radspike = pick(5,10,15)
						to_chat(usr, "<span class='notice'>Scan initiated.</span>")
					else
						to_chat(usr, "<span class='warning'>Could not initiate scan, seal requires replacing.</span>")
				else
					to_chat(usr, "<span class='warning'>Insert an item to scan.</span>")
			return TRUE

		if("maserWavelength")
			maser_wavelength = clamp(text2num(params["wavelength"]), 1, 10000)
			return TRUE

		if("coolantRate")
			coolant_usage_rate = clamp(text2num(params["coolant"]), 0, 10)
			return TRUE

		if("toggle_rad_shield")
			rad_shield = !rad_shield
			return TRUE

		if("ejectItem")
			if(scanned_item)
				scanned_item.forceMove(loc)
				scanned_item = null
			return TRUE

/obj/machinery/radiocarbon_spectrometer/process()
	if(scanning)
		if(!scanned_item || scanned_item.loc != src)
			scanned_item = null
			stop_scanning()
		else if(scanner_progress >= 100)
			complete_scan()
		else
			//calculate time difference
			var/deltaT = (world.time - last_process_worldtime) * 0.1

			//modify the RPM over time
			//i want 1u to last for 10 sec at 500 RPM, scaling linearly
			scanner_rpm += scanner_rpm_dir * 50 * deltaT
			if(scanner_rpm > 1000)
				scanner_rpm = 1000
				scanner_rpm_dir = -1 * pick(0.5, 2.5, 5.5)
			else if(scanner_rpm < 1)
				scanner_rpm = 1
				scanner_rpm_dir = 1 * pick(0.5, 2.5, 5.5)

			//heat up according to RPM
			//each unit of coolant
			scanner_temperature += scanner_rpm * deltaT * 0.05

			//radiation
			t_left_radspike -= deltaT
			if(t_left_radspike > 0)
				//ordinary radiation
				radiation = rand() * 15
			else
				//radspike
				if(t_left_radspike > -5)
					radiation = rand() * 15 + 85
					if(!rad_shield)
						//irradiate nearby mobs
						SSradiation.radiate(src, radiation / 25)
				else
					t_left_radspike = pick(10,15,25)

			//use some coolant to cool down
			if(coolant_usage_rate > 0)
				var/coolant_used = min(fresh_coolant, coolant_usage_rate * deltaT)
				if(coolant_used > 0)
					fresh_coolant -= coolant_used
					used_coolant += coolant_used
					scanner_temperature = max(scanner_temperature - coolant_used * coolant_purity * 20, 0)

			//modify the optimal wavelength
			tleft_retarget_optimal_wavelength -= deltaT
			if(tleft_retarget_optimal_wavelength <= 0)
				tleft_retarget_optimal_wavelength = pick(4,8,15)
				optimal_wavelength_target = rand() * 9900 + 100
			//
			if(optimal_wavelength < optimal_wavelength_target)
				optimal_wavelength = min(optimal_wavelength + 700 * deltaT, optimal_wavelength_target)
			else if(optimal_wavelength > optimal_wavelength_target)
				optimal_wavelength = max(optimal_wavelength - 700 * deltaT, optimal_wavelength_target)
			//
			maser_efficiency = 1 - max(min(10000, abs(optimal_wavelength - maser_wavelength) * 3), 1) / 10000

			//make some scan progress
			if(!rad_shield)
				scanner_progress = min(100, scanner_progress + scanner_rate * maser_efficiency * deltaT)

				//degrade the seal over time according to temperature
				//i want temperature of 50K to degrade at 1%/sec
				scanner_seal_integrity -= (max(scanner_temperature, 1) / 1000) * deltaT

			//emergency stop if seal integrity reaches 0
			if(scanner_seal_integrity <= 0 || (scanner_temperature >= 1273 && !rad_shield))
				stop_scanning()
				src.visible_message("<font color='blue'>\icon[src][bicon(src)] buzzes unhappily. It has failed mid-scan!</font>", 2)

			if(prob(5))
				src.visible_message("<font color='blue'>\icon[src][bicon(src)] [pick("whirrs","chuffs","clicks")][pick(" excitedly"," energetically"," busily")].</font>", 2)
	else
		//gradually cool down over time
		if(scanner_temperature > 0)
			scanner_temperature = max(scanner_temperature - 5 - 10 * rand(), 0)
		if(prob(0.75))
			src.visible_message("<font color='blue'>\icon[src][bicon(src)] [pick("plinks","hisses")][pick(" quietly"," softly"," sadly"," plaintively")].</font>", 2)
			playsound(src, 'sound/effects/ding.ogg', 25)
	last_process_worldtime = world.time

/obj/machinery/radiocarbon_spectrometer/proc/stop_scanning()
	scanning = 0
	scanner_rpm_dir = 1
	scanner_rpm = 0
	optimal_wavelength = 0
	maser_efficiency = 0
	maser_wavelength = 0
	coolant_usage_rate = 0
	radiation = 0
	t_left_radspike = 0
	if(used_coolant)
		src.reagents.remove_any(used_coolant)
		used_coolant = 0

/obj/machinery/radiocarbon_spectrometer/proc/complete_scan()
	src.visible_message("<font color='blue'>\icon[src][bicon(src)] makes an insistent chime.</font>", 2)

	if(scanned_item)
		//create report
		var/obj/item/paper/P = new(src)
		P.name = "[src] report #[++report_num]: [scanned_item.name]"
<<<<<<< HEAD
		P.stamped = list(/obj/item/weapon/stamp)
		P.add_overlay("paper_stamped")
=======
		P.stamped = list(/obj/item/stamp)
		P.overlays = list("paper_stamped")
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon

		//work out data
		var/data = " - Mundane object: [scanned_item.desc ? scanned_item.desc : "No information on record."]<br>"
		var/datum/geosample/G
		switch(scanned_item.type)
			if(/obj/item/ore)
				var/obj/item/ore/O = scanned_item
				if(O.geologic_data)
					G = O.geologic_data

			if(/obj/item/rocksliver)
				var/obj/item/rocksliver/O = scanned_item
				if(O.geological_data)
					G = O.geological_data

			if(/obj/item/archaeological_find)
				data = " - Mundane object (archaic xenos origins)<br>"

				var/obj/item/archaeological_find/A = scanned_item
				if(A.talking_atom)
					data = " - Exhibits properties consistent with sonic reproduction and audio capture technologies.<br>"

		var/anom_found = 0
		if(G)
			data = " - Spectometric analysis on mineral sample has determined type [finds_as_strings[responsive_carriers.Find(G.source_mineral)]]<br>"
			if(G.age_billion > 0)
				data += " - Radiometric dating shows age of [G.age_billion].[G.age_million] billion years<br>"
			else if(G.age_million > 0)
				data += " - Radiometric dating shows age of [G.age_million].[G.age_thousand] million years<br>"
			else
				data += " - Radiometric dating shows age of [G.age_thousand * 1000 + G.age] years<br>"
			data += " - Chromatographic analysis shows the following materials present:<br>"
			for(var/carrier in G.find_presence)
				if(G.find_presence[carrier])
					var/index = responsive_carriers.Find(carrier)
					if(index > 0 && index <= finds_as_strings.len)
						data += "	> [100 * G.find_presence[carrier]]% [finds_as_strings[index]]<br>"

			if(G.artifact_id && G.artifact_distance >= 0)
				anom_found = 1
				data += " - Hyperspectral imaging reveals exotic energy wavelength detected with ID: [G.artifact_id]<br>"
				data += " - Fourier transform analysis on anomalous energy absorption indicates energy source located inside emission radius of [G.artifact_distance]m<br>"

		if(!anom_found)
			data += " - No anomalous data<br>"

		P.info = "<b>[src] analysis report #[report_num]</b><br>"
		P.info += "<b>Scanned item:</b> [scanned_item.name]<br><br>" + data
		last_scan_data = P.info
		P.loc = src.loc

		scanned_item.loc = src.loc
		scanned_item = null
