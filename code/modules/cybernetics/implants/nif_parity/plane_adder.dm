/obj/item/endoware/plane_overlay
	name = "Integrated Corneal Display"
	allowed_in = list(O_EYES)
	var/list/planes_to_add = list()
	is_activatable = TRUE
	var/is_active = TRUE

/obj/item/endoware/plane_overlay/activate(external)
	is_active = !is_active
	if(is_active && host)
		to_chat(host,span_notice("ON"))
	if(!is_active && host)
		to_chat(host,span_notice("OFF"))
	host.update_endoware_vision()
	. = ..()

/obj/item/endoware/plane_overlay/get_vision_planes()
	if(is_active)
		return planes_to_add
	return

//no, I'm not adding thermals. that's a horrible idea.
//if you do add it,
