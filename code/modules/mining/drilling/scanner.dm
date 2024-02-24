/obj/item/weapon/mining_scanner
	name = "deep scan device"
	desc = "A complex device used to locate ore deep underground."
	icon = 'icons/obj/device.dmi'
	icon_state = "deep_scan_device"
	item_state = "electronic"
	origin_tech = list(TECH_MAGNET = 1, TECH_ENGINEERING = 1)
	matter = list(MAT_STEEL = 150)
	var/scan_time = 2 SECONDS
	var/range = 2
	var/exact = FALSE

/obj/item/weapon/mining_scanner/attack_self(mob/user as mob)
	to_chat(user, "<span class='notice'>You begin sweeping \the [src] about, scanning for metal deposits.</span>")
	playsound(src, 'sound/items/goggles_charge.ogg', 50, 1, -6)

	if(!do_after(user, scan_time))
		return

	ScanTurf(get_turf(user), user)

/obj/item/weapon/mining_scanner/proc/ScanTurf(var/atom/target, var/mob/user)
	var/list/metals = list(
		"surface minerals" = 0,
		"industrial metals" = 0,
		"precious metals" = 0,
		"precious gems" = 0,
		"nuclear fuel" = 0,
		"exotic matter" = 0,
		"anomalous matter" = 0
		)

	var/turf/Turf = get_turf(target)

	for(var/turf/simulated/T in range(range, Turf))

		if(!T.has_resources)
			continue

		for(var/metal in T.resources)
			var/ore_type

			switch(metal)
				if("sand", "carbon", "marble", /*"quartz"*/)	ore_type = "surface minerals"
				if("hematite", /*"tin", "copper", "bauxite",*/ "lead")	ore_type = "industrial metals"
				if("gold", "silver", "rutile")					ore_type = "precious metals"
				if("diamond", /*"painite"*/)	ore_type = "precious gems"
				if("uranium")									ore_type = "nuclear fuel"
				if("phoron", "platinum", "mhydrogen")				ore_type = "exotic matter"
				if("verdantium", /*"void opal"*/)				ore_type = "anomalous matter"

			if(ore_type) metals[ore_type] += T.resources[metal]

	var/message = "\icon[src][bicon(src)] <span class='notice'>The scanner beeps and displays a readout.</span>"

	for(var/ore_type in metals)
		var/result = "no sign"

		if(!exact)
			switch(metals[ore_type])
				if(1 to 25) result = "trace amounts"
				if(26 to 75) result = "significant amounts"
				if(76 to INFINITY) result = "huge quantities"

		else
			result = metals[ore_type]

		message += "<br><span class='notice'>- [result] of [ore_type].</span>"

	to_chat(user, message)

/obj/item/weapon/mining_scanner/advanced
	name = "advanced ore detector"
	desc = "An advanced device used to locate ore deep underground."
	description_info = "This scanner has variable range, you can use the Set Scanner Range verb, or alt+click the device. Drills dig in 5x5."
	origin_tech = list(TECH_MAGNET = 4, TECH_ENGINEERING = 4)
	matter = list(MAT_STEEL = 150)
	scan_time = 0.5 SECONDS
	exact = TRUE

/obj/item/weapon/mining_scanner/advanced/AltClick(mob/user)
	change_size()

/obj/item/weapon/mining_scanner/advanced/verb/change_size()
	set name = "Set Scanner Range"
	set category = "Object"
	var/custom_range = tgui_input_list(usr, "Scanner Range","Pick a range to scan. ", list(0,1,2,3,4,5,6,7))
	if(custom_range)
		range = custom_range
		to_chat(usr, "<span class='notice'>Scanner will now look up to [range] tile(s) away.</span>")