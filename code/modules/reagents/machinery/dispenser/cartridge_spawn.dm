ADMIN_VERB(spawn_chemdisp_cartridge, R_SPAWN, "Spawn Chemical Dispenser Cartridge", "Spawns a chemical dispenser catridge.", ADMIN_CATEGORY_FUN_EVENT_KIT)
	var/size = tgui_input_list(user, "Select the catridge size", "Select Size", list("small", "medium", "large"), "small")
	if(!size)
		return
	var/reagent = tgui_input_list(user, "Select the reagent to put into the catridge", "Select Reagent", SSchemistry.chemical_reagents)
	if(!reagent)
		return
	var/obj/item/reagent_containers/chem_disp_cartridge/new_catridge
	var/mob/user_mob = user.mob
	switch(size)
		if("small") new_catridge = new /obj/item/reagent_containers/chem_disp_cartridge/small(user_mob.loc)
		if("medium") new_catridge = new /obj/item/reagent_containers/chem_disp_cartridge/medium(user_mob.loc)
		if("large") new_catridge = new /obj/item/reagent_containers/chem_disp_cartridge(user_mob.loc)
	new_catridge.reagents.add_reagent(reagent, new_catridge.volume)
	var/datum/reagent/used_reagent = SSchemistry.chemical_reagents[reagent]
	new_catridge.setLabel(used_reagent.name)
	log_admin("[key_name(user)] spawned a [size] reagent container containing [reagent] at ([user_mob.x],[user_mob.y],[user_mob.z])")
