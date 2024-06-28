/datum/data/pda/app/status_display
	name = "Status Display"
	icon = "list-alt"
	template = "pda_status_display"
	category = "Utilities"

	var/message1	// used for status_displays
	var/message2

/datum/data/pda/app/status_display/update_ui(mob/user as mob, list/data)
	data["records"] = list(
		"message1" = message1 ? message1 : "(none)",
		"message2" = message2 ? message2 : "(none)")

/datum/data/pda/app/status_display/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE
	switch(action)
		if("Status")
			switch(params["statdisp"])
				if("message")
					post_status("message", message1, message2)
				if("alert")
					post_status("alert", params["alert"])
				if("setmsg1")
					message1 = clean_input("Line 1", "Enter Message Text", message1)
				if("setmsg2")
					message2 = clean_input("Line 2", "Enter Message Text", message2)
				else
					post_status(params["statdisp"])
			return TRUE

/datum/data/pda/app/status_display/proc/post_status(var/command, var/data1, var/data2)
	var/datum/radio_frequency/frequency = radio_controller.return_frequency(1435)
	if(!frequency)
		return

	var/datum/signal/status_signal = new
	status_signal.source = src
	status_signal.transmission_method = 1
	status_signal.data["command"] = command

	switch(command)
		if("message")
			status_signal.data["msg1"] = data1
			status_signal.data["msg2"] = data2
			var/mob/user = pda.fingerprintslast
			if(istype(pda.loc, /mob/living))
				user = pda.loc
			log_admin("STATUS: [user] set status screen with [pda]. Message: [data1] [data2]")
			message_admins("STATUS: [user] set status screen with [pda]. Message: [data1] [data2]")

		if("alert")
			status_signal.data["picture_state"] = data1

	spawn(0)
		frequency.post_signal(src, status_signal)


/datum/data/pda/app/signaller
	name = "Signaler System"
	icon = "rss"
	template = "pda_signaller"
	category = "Utilities"

/datum/data/pda/app/signaller/update_ui(mob/user as mob, list/data)
	if(pda.cartridge && istype(pda.cartridge.radio, /obj/item/radio/integrated/signal))
		var/obj/item/radio/integrated/signal/R = pda.cartridge.radio
		data["frequency"] = R.frequency
		data["minFrequency"] = RADIO_LOW_FREQ
		data["maxFrequency"] = RADIO_HIGH_FREQ
		data["code"] = R.code

/datum/data/pda/app/signaller/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE
	if(pda.cartridge && istype(pda.cartridge.radio, /obj/item/radio/integrated/signal))
		var/obj/item/radio/integrated/signal/R = pda.cartridge.radio

		switch(action)
			if("signal")
				spawn(0)
					R.send_signal("ACTIVATE")
			if("freq")
				var/frequency = unformat_frequency(params["freq"])
				frequency = sanitize_frequency(frequency, RADIO_LOW_FREQ, RADIO_HIGH_FREQ)
				R.set_frequency(frequency)
				. = TRUE
			if("code")
				R.code = clamp(round(text2num(params["code"])), 1, 100)
				. = TRUE
			if("reset")
				if(params["reset"] == "freq")
					R.set_frequency(initial(R.frequency))
				else
					R.code = initial(R.code)
				. = TRUE

/datum/data/pda/app/power
	name = "Power Monitor"
	icon = "exclamation-triangle"
	template = "pda_power"
	category = "Engineering"

	var/datum/tgui_module/power_monitor/power_monitor

/datum/data/pda/app/power/New()
	power_monitor = new(src)
	. = ..()

/datum/data/pda/app/power/Destroy()
	QDEL_NULL(power_monitor)
	return ..()

/datum/data/pda/app/power/update_ui(mob/user as mob, list/data)
	data.Add(power_monitor.tgui_data(user))

/datum/data/pda/app/power/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE
	if(power_monitor.tgui_act(action, params, ui, state))
		return TRUE
	switch(action)
		if("Back")
			power_monitor.active_sensor = null
			return TRUE

/datum/data/pda/app/crew_records
	var/datum/data/record/general_records = null

/datum/data/pda/app/crew_records/update_ui(mob/user as mob, list/data)
	var/list/records[0]

	if(general_records && (general_records in data_core.general))
		data["records"] = records
		records["general"] = general_records.fields
		return records
	else
		for(var/datum/data/record/R as anything in sortRecord(data_core.general))
			if(R)
				records += list(list(Name = R.fields["name"], "ref" = "\ref[R]"))
		data["recordsList"] = records
		data["records"] = null
		return null

/datum/data/pda/app/crew_records/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE
	switch(action)
		if("Records")
			var/datum/data/record/R = locate(params["target"])
			if(R && (R in data_core.general))
				load_records(R)
			return TRUE
		if("Back")
			general_records = null
			has_back = 0
			return TRUE

/datum/data/pda/app/crew_records/proc/load_records(datum/data/record/R)
	general_records = R
	has_back = 1

/datum/data/pda/app/crew_records/medical
	name = "Medical Records"
	icon = "heartbeat"
	template = "pda_medical"
	category = "Medical"

	var/datum/data/record/medical_records = null

/datum/data/pda/app/crew_records/medical/update_ui(mob/user as mob, list/data)
	var/list/records = ..()
	if(!records)
		return

	if(medical_records && (medical_records in data_core.medical))
		records["medical"] = medical_records.fields

	return records

/datum/data/pda/app/crew_records/medical/load_records(datum/data/record/R)
	..(R)
	for(var/datum/data/record/E as anything in data_core.medical)
		if(E && (E.fields["name"] == R.fields["name"] || E.fields["id"] == R.fields["id"]))
			medical_records = E
			break

/datum/data/pda/app/crew_records/security
	name = "Security Records"
	icon = "tags"
	template = "pda_security"
	category = "Security"

	var/datum/data/record/security_records = null

/datum/data/pda/app/crew_records/security/update_ui(mob/user as mob, list/data)
	var/list/records = ..()
	if(!records)
		return

	if(security_records && (security_records in data_core.security))
		records["security"] = security_records.fields

	return records

/datum/data/pda/app/crew_records/security/load_records(datum/data/record/R)
	..(R)
	for(var/datum/data/record/E as anything in data_core.security)
		if(E && (E.fields["name"] == R.fields["name"] || E.fields["id"] == R.fields["id"]))
			security_records = E
			break

/datum/data/pda/app/supply
	name = "Supply Records"
	icon = "file-word-o"
	template = "pda_supply"
	category = "Quartermaster"

/datum/data/pda/app/supply/update_ui(mob/user as mob, list/data)
	var/supplyData[0]
	var/datum/shuttle/autodock/ferry/supply/shuttle = SSsupply.shuttle
	if (shuttle)
		supplyData["shuttle_moving"] = shuttle.has_arrive_time()
		supplyData["shuttle_eta"] = shuttle.eta_minutes()
		supplyData["shuttle_loc"] = shuttle.at_station() ? "Station" : "Dock"
	var/supplyOrderCount = 0
	var/supplyOrderData[0]
	for(var/datum/supply_order/SO as anything in SSsupply.shoppinglist)

		supplyOrderCount++
		supplyOrderData[++supplyOrderData.len] = list("Number" = SO.ordernum, "Name" = html_encode(SO.object.name), "ApprovedBy" = SO.approved_by, "Comment" = html_encode(SO.comment))

	supplyData["approved"] = supplyOrderData
	supplyData["approved_count"] = supplyOrderCount

	var/requestCount = 0
	var/requestData[0]
	for(var/datum/supply_order/SO as anything in SSsupply.order_history)
		if(SO.status != SUP_ORDER_REQUESTED)
			continue

		requestCount++
		requestData[++requestData.len] = list("Number" = SO.ordernum, "Name" = html_encode(SO.object.name), "OrderedBy" = SO.ordered_by, "Comment" = html_encode(SO.comment))

	supplyData["requests"] = requestData
	supplyData["requests_count"] = requestCount

	data["supply"] = supplyData

/datum/data/pda/app/janitor
	name = "Custodial Locator"
	icon = "trash-alt-o"
	template = "pda_janitor"
	category = "Utilities"

/datum/data/pda/app/janitor/update_ui(mob/user as mob, list/data)
	var/JaniData[0]
	var/turf/cl = get_turf(pda)

	if(cl)
		JaniData["user_loc"] = list("x" = cl.x, "y" = cl.y)
	else
		JaniData["user_loc"] = list("x" = 0, "y" = 0)

	var/MopData[0]
	for(var/obj/item/weapon/mop/M in all_mops)//GLOB.janitorial_equipment)
		var/turf/ml = get_turf(M)
		if(ml)
			if(ml.z != cl.z)
				continue
			var/direction = get_dir(pda, M)
			MopData[++MopData.len] = list ("x" = ml.x, "y" = ml.y, "dir" = uppertext(dir2text(direction)), "status" = M.reagents.total_volume ? "Wet" : "Dry")

	var/BucketData[0]
	for(var/obj/structure/mopbucket/B in all_mopbuckets)//GLOB.janitorial_equipment)
		var/turf/bl = get_turf(B)
		if(bl)
			if(bl.z != cl.z)
				continue
			var/direction = get_dir(pda,B)
			BucketData[++BucketData.len] = list ("x" = bl.x, "y" = bl.y, "dir" = uppertext(dir2text(direction)), "volume" = B.reagents.total_volume, "max_volume" = B.reagents.maximum_volume)

	var/CbotData[0]
	for(var/mob/living/bot/cleanbot/B in mob_list)
		var/turf/bl = get_turf(B)
		if(bl)
			if(bl.z != cl.z)
				continue
			var/direction = get_dir(pda,B)
			CbotData[++CbotData.len] = list("x" = bl.x, "y" = bl.y, "dir" = uppertext(dir2text(direction)), "status" = B.on ? "Online" : "Offline")

	var/CartData[0]
	for(var/obj/structure/janitorialcart/B in all_janitorial_carts)//GLOB.janitorial_equipment)
		var/turf/bl = get_turf(B)
		if(bl)
			if(bl.z != cl.z)
				continue
			var/direction = get_dir(pda,B)
			CartData[++CartData.len] = list("x" = bl.x, "y" = bl.y, "dir" = uppertext(dir2text(direction)), "volume" = B.mybucket?.reagents.total_volume || 0, "max_volume" = B.mybucket?.reagents.maximum_volume || 0)

	JaniData["mops"] = MopData.len ? MopData : null
	JaniData["buckets"] = BucketData.len ? BucketData : null
	JaniData["cleanbots"] = CbotData.len ? CbotData : null
	JaniData["carts"] = CartData.len ? CartData : null
	data["janitor"] = JaniData
