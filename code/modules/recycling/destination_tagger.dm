/obj/item/destTagger
	name = "destination tagger"
	desc = "Used to set the destination of properly wrapped packages."
	icon = 'icons/obj/device.dmi'
	icon_state = "dest_tagger"
	var/currTag = 0

	w_class = ITEMSIZE_SMALL
	item_state = "electronic"
	slot_flags = SLOT_BELT
	pickup_sound = 'sound/items/pickup/device.ogg'
	drop_sound = 'sound/items/drop/device.ogg'

/obj/item/destTagger/tgui_state(mob/user)
	return GLOB.tgui_inventory_state

/obj/item/destTagger/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DestinationTagger", name)
		ui.open()

/obj/item/destTagger/tgui_static_data(mob/user)
	. = ..()
	.["level_names"] = using_map.zlevels

/obj/item/destTagger/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = list(
		"taggerLocs" = GLOB.tagger_locations
	)
	return data

/obj/item/destTagger/tgui_data(mob/user, datum/tgui/ui)
	var/list/data = ..()

	data["currTag"] = currTag

	return data

/obj/item/destTagger/attack_self(mob/user)
	. = ..(user)
	if(.)
		return TRUE
	tgui_interact(user)

/obj/item/destTagger/tgui_act(action, params, datum/tgui/ui)
	if(..())
		return TRUE
	add_fingerprint(ui.user)
	switch(action)
		if("set_tag")
			var/new_tag = params["tag"]
			if(!(new_tag in GLOB.tagger_locations))
				return FALSE
			currTag = new_tag
			return TRUE
		if("new_tag")
			var/dest_tag = sanitizeName(params["tag"], allow_numbers = TRUE)
			if(!istext(dest_tag) || length(dest_tag) < 3)
				return FALSE
			if(dest_tag in GLOB.tagger_locations)
				return FALSE
			GLOB.tagger_locations[dest_tag] = null
			currTag = dest_tag
			return TRUE
