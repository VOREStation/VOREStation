/*
Simple Size Implant.
*/
/obj/item/endoware/size
	name = "Local Scale Regulator"
	desc = "A small (or large) implant usually installed at the base of the spine. It makes use of Quasi-Particles to enable the user to adust their relative scale on demand, in a moderately safe fashion."
	icon_state = "sizespine"

	is_activatable = TRUE
	image_text =  "SIZE"

/obj/item/endoware/size_voice/Initialize(mapload)
	. = ..()
	networkNode = new /datum/commandline_network_node/endoware/size()
	networkNode.assigned_to = src
	networkNode.Initialize() //TODO, move this to SS

/obj/item/endoware/size/activate()
	. = ..()
	if(!host)
		return

	var/size_select = tgui_input_number(host, "Put the desired size (25-200%), (1-600%) in dormitory areas.", "Set Size", 100, RESIZE_MAXIMUM_DORMS * 100, RESIZE_MINIMUM_DORMS * 100)
	if(!size_select)
		return //cancelled
	size_select = clamp((size_select / 100), RESIZE_MINIMUM_DORMS, RESIZE_MAXIMUM_DORMS)
	if(size_select < RESIZE_MINIMUM || size_select > RESIZE_MAXIMUM)
		to_chat(usr, span_notice("Note: Resizing limited to 25-200% automatically while outside dormatory areas.")) //hint that we clamp it in resize

	host.resize(size_select, uncapped = host.has_large_resize_bounds(), ignore_prefs = TRUE) //you're either jacked into or setting it yourself. Nobody's doing this on accident
