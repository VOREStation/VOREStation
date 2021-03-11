/datum/tgui_module/rustcore_monitor
	name = "R-UST Core Monitoring"
	tgui_id = "RustCoreMonitor"

	var/core_tag = ""

/datum/tgui_module/rustcore_monitor/tgui_act(action, params)
	if(..())
		return TRUE

	for(var/parameter in params)
		to_world("[parameter] - [params[parameter]]")

	switch(action)
		if("toggle_active")
			var/obj/machinery/power/fusion_core/C = locate(params["core"])
			if(!istype(C))
				return FALSE
			if(!C.Startup()) //Startup() whilst the device is active will return null.
				C.Shutdown()
			return TRUE

		if("toggle_reactantdump")
			var/obj/machinery/power/fusion_core/C = locate(params["core"])
			if(!istype(C))
				return FALSE
			C.reactant_dump = !C.reactant_dump
			return TRUE

		if("set_tag")
			var/new_ident = sanitize_text(input("Enter a new ident tag.", "Core Control", core_tag) as null|text)
			if(new_ident)
				core_tag = new_ident

		if("set_fieldstr")
			var/obj/machinery/power/fusion_core/C = locate(params["core"])
			if(!istype(C))
				return FALSE

			var/new_strength = params["fieldstr"]

			C.target_field_strength = new_strength

			return TRUE

/datum/tgui_module/rustcore_monitor/tgui_data(mob/user)
	var/list/data = list()
	var/list/cores = list()

	for(var/obj/machinery/power/fusion_core/C in GLOB.fusion_cores)
		if(C.id_tag == core_tag)

			var/list/reactants = list()

			if(C.owned_field)
				for(var/reagent in C.owned_field.dormant_reactant_quantities)
					reactants.Add(list(list(
						"name" = reagent,
						"amount" = C.owned_field.dormant_reactant_quantities[reagent]
						)))

				for(var/list/reactant in reactants)
					to_world("[reactant[1]] [reactant[2]]")

			cores.Add(list(list(
				"name" = C.name,
				"has_field" = C.owned_field ? TRUE : FALSE,
				"reactant_dump" = C.reactant_dump,
				"core_operational" = C.check_core_status(),
				"field_instability" = (C.owned_field ? "[C.owned_field.percent_unstable * 100]%" : "ERROR"),
				"field_temperature" = (C.owned_field ? "[C.owned_field.plasma_temperature + 295]K" : "ERROR"),
				"field_strength" = C.field_strength,
				"target_field_strength" = C.target_field_strength,
				"x" = C.x,
				"y" = C.y,
				"z" = C.z,
				"ref" = "\ref[C]"
			)))

	data["cores"] = cores
	return data

/datum/tgui_module/rustcore_monitor/ntos
	ntos = TRUE
