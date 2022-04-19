/obj/item/device/measuring_tape
	name = "measuring tape"
	desc = "A coiled metallic tape used to check dimensions and lengths."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "measuring"
	origin_tech = list(TECH_MATERIAL = 1)
	matter = list(MAT_STEEL = 100)
	w_class = ITEMSIZE_SMALL

/obj/item/weapon/storage/bag/fossils
	name = "Fossil Satchel"
	desc = "Transports delicate fossils in suspension so they don't break during transit."
	icon = 'icons/obj/mining.dmi'
	icon_state = "satchel"
	slot_flags = SLOT_BELT | SLOT_POCKET
	w_class = ITEMSIZE_NORMAL
	storage_slots = 50
	max_storage_space = ITEMSIZE_COST_NORMAL * 50
	max_w_class = ITEMSIZE_NORMAL
	can_hold = list(/obj/item/weapon/fossil)

/obj/item/weapon/storage/box/samplebags
	name = "sample bag box"
	desc = "A box claiming to contain sample bags."

/obj/item/weapon/storage/box/samplebags/New()
	..()
	for(var/i = 1 to 7)
		var/obj/item/weapon/evidencebag/S = new(src)
		S.name = "sample bag"
		S.desc = "a bag for holding research samples."

/obj/item/device/ano_scanner
	name = "Alden-Saraspova counter"
	desc = "Aids in triangulation of exotic particles."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "flashgun"
	item_state = "lampgreen"
	origin_tech = list(TECH_BLUESPACE = 3, TECH_MAGNET = 3)
	matter = list(MAT_STEEL = 10000,MAT_GLASS = 5000)
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_BELT

	var/last_scan_time = 0
	var/scan_delay = 25

/obj/item/device/ano_scanner/attack_self(var/mob/living/user)
	interact(user)

/obj/item/device/ano_scanner/interact(var/mob/living/user)
	if(world.time - last_scan_time >= scan_delay)
		last_scan_time = world.time

		var/nearestTargetDist = -1
		var/nearestTargetId

		var/nearestSimpleTargetDist = -1
		var/turf/cur_turf = get_turf(src)

		if(SSxenoarch) //Sanity check due to runtimes ~Z
			for(var/turf/simulated/mineral/T as anything in SSxenoarch.artifact_spawning_turfs)
				if(T.density && T.artifact_find)
					if(T.z == cur_turf.z)
						var/cur_dist = get_dist(cur_turf, T) * 2
						if(nearestTargetDist < 0 || cur_dist < nearestTargetDist)
							nearestTargetDist = cur_dist + rand() * 2 - 1
							nearestTargetId = T.artifact_find.artifact_id
				else
					SSxenoarch.artifact_spawning_turfs.Remove(T)

			for(var/turf/simulated/mineral/T as anything in SSxenoarch.digsite_spawning_turfs)
				if(T.density && T.finds && T.finds.len)
					if(T.z == cur_turf.z)
						var/cur_dist = get_dist(cur_turf, T) * 2
						if(nearestSimpleTargetDist < 0 || cur_dist < nearestSimpleTargetDist)
							nearestSimpleTargetDist = cur_dist + rand() * 2 - 1
				else
					SSxenoarch.digsite_spawning_turfs.Remove(T)

		if(nearestTargetDist >= 0)
			to_chat(user, "Exotic energy detected on wavelength '[nearestTargetId]' in a radius of [nearestTargetDist]m[nearestSimpleTargetDist > 0 ? "; small anomaly detected in a radius of [nearestSimpleTargetDist]m" : ""]")
		else if(nearestSimpleTargetDist >= 0)
			to_chat(user, "Small anomaly detected in a radius of [nearestSimpleTargetDist]m.")
		else
			to_chat(user, "Background radiation levels detected.")
	else
		to_chat(user, "Scanning array is recharging.")

/obj/item/device/depth_scanner
	name = "depth analysis scanner"
	desc = "Used to check spatial depth and density of rock outcroppings."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "depth_scanner"
	item_state = "analyzer"
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2, TECH_BLUESPACE = 2)
	matter = list(MAT_STEEL = 1000,MAT_GLASS = 1000)
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_BELT
	var/list/positive_locations = list()
	var/datum/depth_scan/current

/datum/depth_scan
	var/time = ""
	var/coords = ""
	var/depth = ""
	var/clearance = 0
	var/record_index = 1
	var/dissonance_spread = 1
	var/material = "unknown"

/obj/item/device/depth_scanner/proc/scan_atom(var/mob/user, var/atom/A)
	user.visible_message("<b>\The [user]</b> scans \the [A], the air around them humming gently.")

	if(istype(A, /turf/simulated/mineral))
		var/turf/simulated/mineral/M = A
		if((M.finds && M.finds.len) || M.artifact_find)

			//create a new scanlog entry
			var/datum/depth_scan/D = new()
			D.coords = "[M.x]:[M.y]:[M.z]"
			D.time = stationtime2text()
			D.record_index = positive_locations.len + 1
			D.material = M.mineral ? M.mineral.display_name : "Rock"

			//find the first artifact and store it
			if(M.finds.len)
				var/datum/find/F = M.finds[1]
				D.depth = "[F.excavation_required - F.clearance_range] - [F.excavation_required]"
				D.clearance = F.clearance_range
				D.material = get_responsive_reagent(F.find_type)

			positive_locations.Add(D)

			to_chat(user, "<span class='notice'>[bicon(src)] [src] pings.</span>")

	else if(istype(A, /obj/structure/boulder))
		var/obj/structure/boulder/B = A
		if(B.artifact_find)
			//create a new scanlog entry
			var/datum/depth_scan/D = new()
			D.coords = "[B.x]:[B.y]:[B.z]"
			D.time = stationtime2text()
			D.record_index = positive_locations.len + 1

			//these values are arbitrary
			D.depth = rand(150, 200)
			D.clearance = rand(10, 50)
			D.dissonance_spread = rand(750, 2500) / 100

			positive_locations.Add(D)

			to_chat(user, "<span class='notice'>[bicon(src)] [src] pings [pick("madly","wildly","excitedly","crazily")]!</span>")

/obj/item/device/depth_scanner/attack_self(var/mob/living/user)
	tgui_interact(user)

/obj/item/device/depth_scanner/tgui_state(mob/user)
	return GLOB.tgui_deep_inventory_state

/obj/item/device/depth_scanner/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "XenoarchDepthScanner", name)
		ui.open()

/obj/item/device/depth_scanner/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	data["current"] = list()
	if(current)
		data["current"] = list(
			"time" = current.time,
			"coords" = current.coords,
			"depth" = current.depth,
			"clearance" = current.clearance,
			"dissonance_spread" = current.dissonance_spread,
			"index" = current.record_index,
		)
		data["current"]["material"] = "Unknown"
		var/index = responsive_carriers.Find(current.material)
		if(index > 0 && index <= LAZYLEN(finds_as_strings))
			data["current"]["material"] = finds_as_strings[index]

	var/list/plocs = list()
	data["positive_locations"] = plocs
	for(var/i in 1 to LAZYLEN(positive_locations))
		var/datum/depth_scan/D = positive_locations[i]
		plocs.Add(list(list(
			"index" = i,
			"time" = D.time,
			"coords" = D.coords,
		)))

	return data

/obj/item/device/depth_scanner/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("select")
			var/index = text2num(params["select"])
			if(index && index <= LAZYLEN(positive_locations))
				current = positive_locations[index]
			return TRUE
		if("clear")
			var/index = text2num(params["clear"])
			if(index)
				if(index <= LAZYLEN(positive_locations))
					var/datum/depth_scan/D = positive_locations[index]
					positive_locations.Remove(D)
					qdel(D)
					current = null
			else
				QDEL_LIST_NULL(positive_locations)
				positive_locations = list()
				QDEL_NULL(current)
			return TRUE

/obj/item/device/beacon_locator
	name = "locater device"
	desc = "Used to scan and locate signals on a particular frequency."
	icon = 'icons/obj/device.dmi'
	icon_state = "pinoff"	//pinonfar, pinonmedium, pinonclose, pinondirect, pinonnull
	item_state = "electronic"
	origin_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 2, TECH_BLUESPACE = 3)
	matter = list(MAT_STEEL = 1000,MAT_GLASS = 500)
	var/frequency = PUB_FREQ
	var/scan_ticks = 0
	var/obj/item/device/radio/target_radio

/obj/item/device/beacon_locator/New()
	..()
	START_PROCESSING(SSobj, src)

/obj/item/device/beacon_locator/Destroy()
	STOP_PROCESSING(SSobj, src)
	..()

/obj/item/device/beacon_locator/process()
	if(target_radio)
		set_dir(get_dir(src,target_radio))
		switch(get_dist(src,target_radio))
			if(0 to 3)
				icon_state = "pinondirect"
			if(4 to 10)
				icon_state = "pinonclose"
			if(11 to 30)
				icon_state = "pinonmedium"
			if(31 to INFINITY)
				icon_state = "pinonfar"
	else
		if(scan_ticks)
			icon_state = "pinonnull"
			scan_ticks++
			if(prob(scan_ticks * 10))
				spawn(0)
					set background = 1
					if(datum_flags & DF_ISPROCESSING)
						//scan radios in the world to try and find one
						var/cur_dist = 999
						for(var/obj/item/device/radio/beacon/R in all_beacons)
							if(R.z == src.z && R.frequency == src.frequency)
								var/check_dist = get_dist(src,R)
								if(check_dist < cur_dist)
									cur_dist = check_dist
									target_radio = R

						scan_ticks = 0
						var/turf/T = get_turf(src)
						if(target_radio)
							T.visible_message("[bicon(src)] [src] [pick("chirps","chirrups","cheeps")] happily.")
						else
							T.visible_message("[bicon(src)] [src] [pick("chirps","chirrups","cheeps")] sadly.")
		else
			icon_state = "pinoff"

/obj/item/device/beacon_locator/attack_self(mob/user)
	return tgui_interact(user)

/obj/item/device/beacon_locator/tgui_state(mob/user)
	return GLOB.tgui_inventory_state

/obj/item/device/beacon_locator/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BeaconLocator", name)
		ui.open()

/obj/item/device/beacon_locator/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	data["scan_ticks"] = scan_ticks
	data["degrees"] = null
	if(target_radio)
		data["degrees"] = round(Get_Angle(get_turf(src), get_turf(target_radio)))

	data["rawfreq"] = frequency
	data["minFrequency"] = RADIO_LOW_FREQ
	data["maxFrequency"] = RADIO_HIGH_FREQ

	return data

/obj/item/device/beacon_locator/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("reset_tracking")
			scan_ticks = 1
			target_radio = null
			return TRUE
		if("setFrequency")
			var/new_frequency = (text2num(params["freq"]))
			new_frequency = sanitize_frequency(new_frequency, RADIO_LOW_FREQ, RADIO_HIGH_FREQ)
			frequency = new_frequency
			return TRUE

/obj/item/device/xenoarch_multi_tool
	name = "xenoarcheology multitool"
	desc = "Has the features of the Alden-Saraspova counter, a measuring tape, and a depth analysis scanner all in one!"
	icon_state = "ano_scanner2"
	item_state = "lampgreen"
	icon = 'icons/obj/xenoarchaeology.dmi'
	origin_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 3, TECH_BLUESPACE = 2)
	matter = list(MAT_STEEL = 10000,MAT_GLASS = 5000)
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_BELT
	var/mode = 1 //Start off scanning. 1 = scanning, 0 = measuring
	var/obj/item/device/ano_scanner/anomaly_scanner = null
	var/obj/item/device/depth_scanner/depth_scanner = null

/obj/item/device/xenoarch_multi_tool/New()
	anomaly_scanner = new/obj/item/device/ano_scanner(src)
	depth_scanner = new/obj/item/device/depth_scanner(src)

/obj/item/device/xenoarch_multi_tool/attack_self(var/mob/living/user)
	depth_scanner.tgui_interact(user)

/obj/item/device/xenoarch_multi_tool/verb/swap_settings(var/mob/living/user)
	set name = "Swap Functionality"
	set desc = "Swap between the scanning and measuring functionality.."
	mode = !mode
	if(mode)
		to_chat(user, "The device will now scan for artifacts.")
	else
		to_chat(user, "The device will now measure depth dug.")

/obj/item/device/xenoarch_multi_tool/verb/scan_for_anomalies(var/mob/living/user)
	set name = "Scan for Anomalies"
	set desc = "Scan for artifacts and anomalies within your vicinity."
	anomaly_scanner.interact(user)

