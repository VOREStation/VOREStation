/client/proc/resize(var/mob/living/L in mob_list)
	set name = "Resize"
	set desc = "Resizes any living mob without any restrictions on size."
	set category = "Fun.Event Kit"
	if(!check_rights(R_ADMIN|R_FUN|R_VAREDIT))
		return

	var/size_multiplier = tgui_input_number(usr, "Input size multiplier.", "Resize", 1, round_value=FALSE)
	if(!size_multiplier)
		return //cancelled

	size_multiplier = clamp(size_multiplier, -50, 50)   //VOREStation Edit - being able to make people upside down is fun. Also 1000 is way, WAY too big. Honestly 50 is too big but at least you can see 50 and it doesn't break the rendering.
	var/can_be_big = L.has_large_resize_bounds()
	var/very_big = is_extreme_size(size_multiplier)

	if(very_big && can_be_big) // made an extreme size in an area that allows it, don't assume adminbuse
		to_chat(src,span_warning("[L] will lose this size upon moving into an area where this size is not allowed."))
	else if(very_big) // made an extreme size in an area that doesn't allow it, assume adminbuse
		to_chat(src,span_warning("[L] will retain this normally unallowed size outside this area."))

	L.resize(size_multiplier, animate = TRUE, uncapped = TRUE, ignore_prefs = TRUE)

	log_and_message_admins("has changed [key_name(L)]'s size multiplier to [size_multiplier].")
	feedback_add_details("admin_verb","RESIZE")
