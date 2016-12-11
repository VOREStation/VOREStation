//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

//All devices that link into the R&D console fall into thise type for easy identification and some shared procs.

/obj/machinery/r_n_d
	name = "R&D Device"
	icon = 'icons/obj/machines/research.dmi'
	density = 1
	anchored = 1
	use_power = 1
	var/busy = 0
	var/obj/machinery/computer/rdconsole/linked_console

	var/list/materials = list()

/obj/machinery/r_n_d/attack_hand(mob/user as mob)
	return

/obj/machinery/r_n_d/proc/getMaterialType(var/name)
	switch(name)
		if(DEFAULT_WALL_MATERIAL)
			return /obj/item/stack/material/steel
		if("glass")
			return /obj/item/stack/material/glass
		if("gold")
			return /obj/item/stack/material/gold
		if("silver")
			return /obj/item/stack/material/silver
		if("phoron")
			return /obj/item/stack/material/phoron
		if("uranium")
			return /obj/item/stack/material/uranium
		if("diamond")
			return /obj/item/stack/material/diamond
	return null

/obj/machinery/r_n_d/proc/getMaterialName(var/type)
	switch(type)
		//50-stacks weren't working despite being a subtype of the others, let's just force it in
		if(/obj/item/stack/material/steel, /obj/item/stack/material/steel/fifty)
			return DEFAULT_WALL_MATERIAL
		if(/obj/item/stack/material/glass, /obj/item/stack/material/glass/fifty)
			return "glass"
		if(/obj/item/stack/material/gold, /obj/item/stack/material/gold/fifty)
			return "gold"
		if(/obj/item/stack/material/silver, /obj/item/stack/material/silver/fifty)
			return "silver"
		if(/obj/item/stack/material/phoron, /obj/item/stack/material/phoron/fifty)
			return "phoron"
		if(/obj/item/stack/material/uranium, /obj/item/stack/material/uranium/fifty)
			return "uranium"
		if(/obj/item/stack/material/diamond, /obj/item/stack/material/diamond/fifty)
			return "diamond"

/obj/machinery/r_n_d/proc/eject(var/material, var/amount)
	if(!(material in materials))
		return
	var/obj/item/stack/material/sheetType = getMaterialType(material)
	var/perUnit = initial(sheetType.perunit)
	var/eject = round(materials[material] / perUnit)
	eject = amount == -1 ? eject : min(eject, amount)
	if(eject < 1)
		return
	var/obj/item/stack/material/S = new sheetType(loc)
	S.amount = eject
	materials[material] -= eject * perUnit