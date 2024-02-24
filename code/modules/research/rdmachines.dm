//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

//All devices that link into the R&D console fall into thise type for easy identification and some shared procs.

/obj/machinery/r_n_d
	name = "R&D Device"
	icon = 'icons/obj/machines/research.dmi'
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	var/busy = 0
	var/obj/machinery/computer/rdconsole/linked_console

	var/list/materials = list()		// Materials this machine can accept.
	var/list/hidden_materials = list()	// Materials this machine will not display, unless it contains them. Must be in the materials list as well.

/obj/machinery/r_n_d/attack_hand(mob/user as mob)
	return

/obj/machinery/r_n_d/proc/getMaterialType(var/name)
	var/datum/material/M = get_material_by_name(name)
	if(M && M.stack_type)
		return M.stack_type
	return null

/obj/machinery/r_n_d/proc/getMaterialName(var/type)
	if(istype(type, /obj/item/stack/material))
		var/obj/item/stack/material/M = type
		return M.material.name
	return null

/obj/machinery/r_n_d/proc/eject(var/material, var/amount)
	if(!(material in materials))
		return
	var/obj/item/stack/material/sheetType = getMaterialType(material)
	var/perUnit = initial(sheetType.perunit)
	var/eject = round(materials[material] / perUnit)
	eject = amount == -1 ? eject : min(eject, amount)
	if(eject < 1)
		return
	new sheetType(loc, eject)
	materials[material] -= eject * perUnit
