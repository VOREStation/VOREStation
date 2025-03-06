/// Allow admin to add or remove traits of datum
/datum/admins/proc/modify_traits(datum/D)
	if(!D)
		return

	var/add_or_remove = input("Remove/Add?", "Trait Remove/Add") as null|anything in list("Add","Remove")
	if(!add_or_remove)
		return
	var/list/available_traits = list()

	switch(add_or_remove)
		if("Add")
			for(var/key in GLOB.admin_visible_traits)
				if(istype(D,key))
					available_traits += GLOB.admin_visible_traits[key]
		if("Remove")
			if(!GLOB.admin_trait_name_map)
				GLOB.admin_trait_name_map = generate_admin_trait_name_map()
			for(var/trait in D._status_traits)
				var/name = GLOB.admin_trait_name_map[trait] || trait
				available_traits[name] = trait

	var/chosen_trait = input("Select trait to modify", "Trait") as null|anything in sortList(available_traits)
	if(!chosen_trait)
		return
	chosen_trait = available_traits[chosen_trait]

	var/source = "adminabuse"
	switch(add_or_remove)
		if("Add") //Not doing source choosing here intentionally to make this bit faster to use, you can always vv it.
			//if(GLOB.movement_type_trait_to_flag[chosen_trait]) //include the required element.
			//	D.AddElement(/datum/element/movetype_handler)
			ADD_TRAIT(D,chosen_trait,source)
		if("Remove")
			var/specific = input("All or specific source ?", "Trait Remove/Add") as null|anything in list("All","Specific")
			if(!specific)
				return
			switch(specific)
				if("All")
					source = null
				if("Specific")
					source = input("Source to be removed","Trait Remove/Add") as null|anything in sortList(GET_TRAIT_SOURCES(D, chosen_trait))
					if(!source)
						return
			REMOVE_TRAIT(D,chosen_trait,source)
