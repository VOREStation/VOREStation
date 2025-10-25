// Robot decal and animation control
/datum/tgui_module/robot_ui_decals
	name = "Robot Decal & Animation Control"
	tgui_id = "RobotDecals"

/datum/tgui_module/robot_ui_decals/tgui_state(mob/user)
	return GLOB.tgui_self_state

/datum/tgui_module/robot_ui_decals/tgui_static_data()
	var/list/data = ..()

	var/mob/living/silicon/robot/R = host

	if(!R.sprite_datum)
		return data

	data["all_decals"] = R.sprite_datum.sprite_decals
	data["all_animations"] = R.sprite_datum.sprite_animations

	return data

/datum/tgui_module/robot_ui_decals/tgui_data()
	var/list/data = ..()

	var/mob/living/silicon/robot/R = host
	data["active_decals"] = R.robotdecal_on

	data["theme"] = R.get_ui_theme()

	return data

/datum/tgui_module/robot_ui_decals/tgui_act(action, params)
	. = ..()
	if(.)
		return

	var/mob/living/silicon/robot/R = host
	if(!R.sprite_datum)
		return FALSE

	switch(action)
		if("toggle_decal")
			if(!LAZYLEN(R.sprite_datum.sprite_decals))
				return FALSE
			var/decal_to_toggle = lowertext(params["value"])
			if(!(decal_to_toggle in R.sprite_datum.sprite_decals))
				return FALSE
			if(R.robotdecal_on.Find(decal_to_toggle))
				R.robotdecal_on -= decal_to_toggle
			else
				R.robotdecal_on += decal_to_toggle
			R.update_icon()
			. = TRUE
		if("flick_animation")
			if(!LAZYLEN(R.sprite_datum.sprite_animations))
				return FALSE
			var/animation_to_flick = lowertext(params["value"])
			if(!(animation_to_flick in R.sprite_datum.sprite_animations))
				return FALSE
			R.cut_overlays()
			R.ImmediateOverlayUpdate()
			flick("[R.sprite_datum.sprite_icon_state]-[animation_to_flick]", R)
			R.update_icon()
			. = TRUE
