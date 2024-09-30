/obj/machinery/computer/diseasesplicer
	name = "disease splicer"
	icon_keyboard = "med_key"
	icon_screen = "crew"

	var/datum/disease2/effectholder/memorybank = null
	var/list/species_buffer = null
	var/analysed = 0
	var/obj/item/virusdish/dish = null
	var/burning = 0
	var/splicing = 0
	var/scanning = 0

/obj/machinery/computer/diseasesplicer/attackby(var/obj/item/I as obj, var/mob/user as mob)
	if(I.has_tool_quality(TOOL_SCREWDRIVER))
		return ..(I,user)

	if(default_unfasten_wrench(user, I, 20))
		return

	if(istype(I,/obj/item/virusdish))
		var/mob/living/carbon/c = user
		if(dish)
			to_chat(user, "\The [src] is already loaded.")
			return

		dish = I
		c.drop_item()
		I.loc = src

	if(istype(I,/obj/item/diseasedisk))
		to_chat(user, "You upload the contents of the disk onto the buffer.")
		memorybank = I:effect
		species_buffer = I:species
		analysed = I:analysed

	src.attack_hand(user)

/obj/machinery/computer/diseasesplicer/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/diseasesplicer/attack_hand(var/mob/user as mob)
	if(..())
		return TRUE
	tgui_interact(user)

/obj/machinery/computer/diseasesplicer/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DiseaseSplicer", name)
		ui.open()

/obj/machinery/computer/diseasesplicer/tgui_data(mob/user)
	var/list/data = list()
	data["dish_inserted"] = !!dish

	data["buffer"] = null
	if(memorybank)
		data["buffer"] = list("name" = (analysed ? memorybank.effect.name : "Unknown Symptom"), "stage" = memorybank.effect.stage)
	data["species_buffer"] = null
	if(species_buffer)
		data["species_buffer"] = analysed ? jointext(species_buffer, ", ") : "Unknown Species"

	data["effects"] = null
	data["info"] = null
	data["growth"] = 0
	data["affected_species"] = null
	data["busy"] = null
	if(splicing)
		data["busy"] = "Splicing..."
	else if(scanning)
		data["busy"] = "Scanning..."
	else if(burning)
		data["busy"] = "Copying data to disk..."
	else if(dish)
		data["growth"] = min(dish.growth, 100)

		if(dish.virus2)
			if(dish.virus2.affected_species)
				data["affected_species"] = dish.analysed ? dish.virus2.affected_species : list()

			if(dish.growth >= 50)
				var/list/effects[0]
				for (var/datum/disease2/effectholder/e in dish.virus2.effects)
					effects.Add(list(list("name" = (dish.analysed ? e.effect.name : "Unknown"), "stage" = (e.stage), "reference" = "\ref[e]", "badness" = e.effect.badness)))
				data["effects"] = effects
			else
				data["info"] = "Insufficient cell growth for gene splicing."
		else
			data["info"] = "No virus detected."
	else
		data["info"] = "No dish loaded."

	return data

/obj/machinery/computer/diseasesplicer/process()
	if(stat & (NOPOWER|BROKEN))
		return

	if(scanning)
		scanning -= 1
		if(!scanning)
			ping("\The [src] pings, \"Analysis complete.\"")
			SStgui.update_uis(src)
	if(splicing)
		splicing -= 1
		if(!splicing)
			ping("\The [src] pings, \"Splicing operation complete.\"")
			SStgui.update_uis(src)
	if(burning)
		burning -= 1
		if(!burning)
			var/obj/item/diseasedisk/d = new /obj/item/diseasedisk(src.loc)
			d.analysed = analysed
			if(analysed)
				if(memorybank)
					d.name = "[memorybank.effect.name] GNA disk (Stage: [memorybank.effect.stage])"
					d.effect = memorybank
				else if(species_buffer)
					d.name = "[jointext(species_buffer, ", ")] GNA disk"
					d.species = species_buffer
			else
				if(memorybank)
					d.name = "Unknown GNA disk (Stage: [memorybank.effect.stage])"
					d.effect = memorybank
				else if(species_buffer)
					d.name = "Unknown Species GNA disk"
					d.species = species_buffer

			ping("\The [src] pings, \"Backup disk saved.\"")
			SStgui.update_uis(src)

/obj/machinery/computer/diseasesplicer/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	var/mob/user = usr
	add_fingerprint(user)

	switch(action)
		if("grab")
			if(dish)
				memorybank = locate(params["grab"])
				species_buffer = null
				analysed = dish.analysed
				dish = null
				scanning = 10
			. = TRUE

		if("affected_species")
			if(dish)
				memorybank = null
				species_buffer = dish.virus2.affected_species
				analysed = dish.analysed
				dish = null
				scanning = 10
			. = TRUE

		if("eject")
			if(dish)
				dish.loc = src.loc
				dish = null
			. = TRUE

		if("splice")
			if(dish)
				var/target = text2num(params["splice"]) // target = 1 to 4 for effects, 5 for species
				if(memorybank && 0 < target && target <= 4)
					if(target < memorybank.effect.stage) return // too powerful, catching this for href exploit prevention

					var/datum/disease2/effectholder/target_holder
					var/list/illegal_types = list()
					for(var/datum/disease2/effectholder/e in dish.virus2.effects)
						if(e.stage == target)
							target_holder = e
						else
							illegal_types += e.effect.type
					if(memorybank.effect.type in illegal_types) return
					target_holder.effect = memorybank.effect

				else if(species_buffer && target == 5)
					dish.virus2.affected_species = species_buffer

				else
					return

				splicing = 10
				dish.virus2.uniqueID = rand(0,10000)
			. = TRUE

		if("disk")
			burning = 10
			. = TRUE
