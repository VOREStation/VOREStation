/datum/asset/spritesheet_batched/vending
	name = "vending"

/datum/asset/spritesheet_batched/vending/create_spritesheets()
	populate_vending_products()
	for(var/atom/item as anything in GLOB.vending_products)
		if(!ispath(item, /atom))
			continue

		var/icon_file = initial(item.icon)
		var/icon_state = initial(item.icon_state)

		// I really don't like the fact that I have to do this, but what the hell else *can* I do to make all of these
		// random special items work?
		if(ispath(item, /obj/item/reagent_containers/food/drinks/glass2) && !ispath(item, /obj/item/reagent_containers/food/drinks/glass2/fitnessflask))
			var/obj/item/reagent_containers/food/drinks/glass2/G = item
			icon_state = initial(G.base_icon)
		if(ispath(item, /obj/item/reagent_containers/hypospray/autoinjector))
			icon_state += "0"
		if(ispath(item, /obj/item/melee/shock_maul))
			icon_state += "0"

		var/datum/universal_icon/I

		var/icon_states_list = icon_states(icon_file)
		if(icon_state in icon_states_list)
			I = uni_icon(icon_file, icon_state, SOUTH)
			var/c = initial(item.color)
			if(!isnull(c) && c != "#FFFFFF")
				I.blend_color(c, ICON_MULTIPLY)
		else
			var/icon_states_string
			for(var/an_icon_state in icon_states_list)
				if(!icon_states_string)
					icon_states_string = "[json_encode(an_icon_state)](\ref[an_icon_state])"
				else
					icon_states_string += ", [json_encode(an_icon_state)](\ref[an_icon_state])"
			stack_trace("[item] does not have a valid icon state, icon=[icon_file], icon_state=[json_encode(icon_state)](\ref[icon_state]), icon_states=[icon_states_string]")
			I = uni_icon('icons/turf/floors.dmi', "", SOUTH)

		var/imgid = replacetext(replacetext("[item]", "/obj/item/", ""), "/", "-")

		insert_icon(imgid, I)

// this is cursed but necessary or else vending product icons can be missing
// basically, if there's any vending machines that aren't already mapped in, our register() will not know
// that they exist, and therefore can't generate the entries in the spritesheet for them
// and since assets are unique and can't be reloaded later, we have to make sure that GLOB.vending_products
// is populated with every single type of vending machine
// As this is only done at runtime, we have to create all the vending machines in existence and force them
// to register their products when this asset initializes.
/datum/asset/spritesheet_batched/vending/proc/populate_vending_products()
	SSatoms.map_loader_begin()
	for(var/path in subtypesof(/obj/machinery/vending))
		var/obj/machinery/vending/x = new path(null)
		// force an inventory build; with map_loader_begin active, init isn't called
		x.build_inventory()
		qdel(x)
	SSatoms.map_loader_stop()
