/obj/item/weapon/mining_scanner
	name = "ore detector"
	desc = "A complex device used to locate ore deep underground."
	icon = 'icons/obj/device.dmi'
	icon_state = "forensic0-old" //GET A BETTER SPRITE.
	item_state = "electronic"
	origin_tech = list(TECH_MAGNET = 1, TECH_ENGINEERING = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 150)
	var/scan_time = 5 SECONDS

/obj/item/weapon/mining_scanner/attack_self(mob/user as mob)
	to_chat(user, "You begin sweeping \the [src] about, scanning for metal deposits.")
	playsound(loc, 'sound/items/goggles_charge.ogg', 50, 1, -6)

	if(!do_after(user, scan_time))
		return

	ScanTurf(user, get_turf(user))

/obj/item/weapon/mining_scanner/proc/ScanTurf(var/atom/target, var/mob/user, var/exact = FALSE)
	var/list/metals = list(
		"surface minerals" = 0,
		"precious metals" = 0,
		"nuclear fuel" = 0,
		"exotic matter" = 0,
		"anomalous matter" = 0
		)

	var/turf/Turf = get_turf(target)

	for(var/turf/simulated/T in range(2, Turf))

		if(!T.has_resources)
			continue

		for(var/metal in T.resources)
			var/ore_type

			switch(metal)
				if("silicates", "carbon", "hematite", "marble")	ore_type = "surface minerals"
				if("gold", "silver", "diamond", "lead")					ore_type = "precious metals"
				if("uranium")									ore_type = "nuclear fuel"
				if("phoron", "osmium", "hydrogen")				ore_type = "exotic matter"
				if("verdantium")				ore_type = "anomalous matter"

			if(ore_type) metals[ore_type] += T.resources[metal]

	to_chat(user, "\icon[src] <span class='notice'>The scanner beeps and displays a readout.</span>")

	for(var/ore_type in metals)
		var/result = "no sign"

		if(!exact)
			switch(metals[ore_type])
				if(1 to 25) result = "trace amounts"
				if(26 to 75) result = "significant amounts"
				if(76 to INFINITY) result = "huge quantities"

		else
			result = metals[ore_type]

		to_chat(user, "- [result] of [ore_type].")
