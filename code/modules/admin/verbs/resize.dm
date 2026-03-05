ADMIN_VERB_ONLY_CONTEXT_MENU(resize, (R_ADMIN|R_FUN|R_VAREDIT), "Resize", mob/living/living_target)
	user.do_resize(living_target)

ADMIN_VERB(mob_resize, (R_ADMIN|R_FUN|R_VAREDIT), "Resize Mob", "Resizes any living mob without any restrictions on size.", ADMIN_CATEGORY_FUN_EVENT_KIT)
	var/mob/target_mob = tgui_input_list(user, "Select target to resize.", "Resize Target", GLOB.mob_list)
	if(!target_mob)
		return
	user.do_resize(target_mob)

/client/proc/do_resize(mob/living/living_target)
	var/size_multiplier = tgui_input_number(src, "Input size multiplier.", "Resize", 1, round_value=FALSE)
	if(!size_multiplier)
		return //cancelled

	size_multiplier = clamp(size_multiplier, -50, 50)   //being able to make people upside down is fun. Also 1000 is way, WAY too big. Honestly 50 is too big but at least you can see 50 and it doesn't break the rendering.
	var/can_be_big = living_target.has_large_resize_bounds()
	var/very_big = is_extreme_size(size_multiplier)

	if(very_big && can_be_big) // made an extreme size in an area that allows it, don't assume adminbuse
		to_chat(src, span_warning("[living_target] will lose this size upon moving into an area where this size is not allowed."))
	else if(very_big) // made an extreme size in an area that doesn't allow it, assume adminbuse
		to_chat(src, span_warning("[living_target] will retain this normally unallowed size outside this area."))

	living_target.resize(size_multiplier, animate = TRUE, uncapped = TRUE, ignore_prefs = TRUE)

	log_and_message_admins("has changed [key_name(living_target)]'s size multiplier to [size_multiplier].", src)
	feedback_add_details("admin_verb","RESIZE")
