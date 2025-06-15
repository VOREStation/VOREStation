// liquid belly procs
/datum/vore_look/proc/liq_set_attr(mob/user, params)
	if(!host.vore_selected)
		tgui_alert(user, "No belly selected to modify.")
		return FALSE

	var/attr = params["attribute"]
	switch(attr)
		if("b_show_liq")
			if(!host.vore_selected.show_liquids)
				host.vore_selected.show_liquids = 1
				to_chat(user,span_warning("Your [lowertext(host.vore_selected.name)] now has liquid options."))
			else
				host.vore_selected.show_liquids = 0
				to_chat(user,span_warning("Your [lowertext(host.vore_selected.name)] no longer has liquid options."))
			. = TRUE
		if("b_liq_reagent_gen")
			if(!host.vore_selected.reagentbellymode) //liquid container adjustments and interactions.
				host.vore_selected.reagentbellymode = 1
				to_chat(user,span_warning("Your [lowertext(host.vore_selected.name)] now has interactions which can produce liquids."))
			else //Doesnt produce liquids
				host.vore_selected.reagentbellymode = 0
				to_chat(user,span_warning("Your [lowertext(host.vore_selected.name)] wont produce liquids, liquids already in your [lowertext(host.vore_selected.name)] must be emptied out or removed with purge."))
			. = TRUE
		if("b_liq_reagent_type")
			var/new_reagent = params["val"]
			if(!(new_reagent in host.vore_selected.reagent_choices))
				return FALSE

			host.vore_selected.reagent_chosen = new_reagent
			host.vore_selected.ReagentSwitch() // For changing variables when a new reagent is chosen
			. = TRUE
		if("b_liq_reagent_name")
			var/new_name = params["val"]

			if(length(new_name) > BELLIES_NAME_MAX || length(new_name) < BELLIES_NAME_MIN)
				tgui_alert(user, "Entered name length invalid (must be longer than [BELLIES_NAME_MIN], no longer than [BELLIES_NAME_MAX]).","Error")
				return FALSE

			host.vore_selected.reagent_name = new_name
			. = TRUE
		if("b_liq_reagent_transfer_verb")
			var/new_verb = params["val"]

			if(length(new_verb) > BELLIES_NAME_MAX || length(new_verb) < BELLIES_NAME_MIN)
				tgui_alert(user, "Entered verb length invalid (must be longer than [BELLIES_NAME_MIN], no longer than [BELLIES_NAME_MAX]).","Error")
				return FALSE

			host.vore_selected.reagent_transfer_verb = new_verb
			. = TRUE
		if("b_liq_reagent_nutri_rate")
			host.vore_selected.gen_time_display = params["val"]
			switch(host.vore_selected.gen_time_display)
				if("10 minutes")
					host.vore_selected.gen_time = 0
				if("30 minutes")
					host.vore_selected.gen_time = 2
				if("1 hour")
					host.vore_selected.gen_time = 5
				if("3 hours")
					host.vore_selected.gen_time = 17
				if("6 hours")
					host.vore_selected.gen_time = 35
				if("12 hours")
					host.vore_selected.gen_time = 71
				if("24 hours")
					host.vore_selected.gen_time = 143
			. = TRUE
		if("b_liq_reagent_capacity")
			var/new_custom_vol = text2num(params["val"])
			if(!isnum(new_custom_vol))
				return FALSE
			host.vore_selected.custom_max_volume = CLAMP(new_custom_vol, 10, 300)
			. = TRUE
		if("b_liq_sloshing")
			if(!host.vore_selected.vorefootsteps_sounds)
				host.vore_selected.vorefootsteps_sounds = 1
				to_chat(user,span_warning("Your [lowertext(host.vore_selected.name)] can now make sounds when you walk around depending on how full you are."))
			else
				host.vore_selected.vorefootsteps_sounds = 0
				to_chat(user,span_warning("Your [lowertext(host.vore_selected.name)] wont make any liquid sounds no matter how full it is."))
			. = TRUE
		if("b_liq_reagent_addons")
			var/reagent_toggle_addon = params["val"]
			if(!reagent_toggle_addon)
				return FALSE
			host.vore_selected.reagent_mode_flags ^= host.vore_selected.reagent_mode_flag_list[reagent_toggle_addon]
			. = TRUE
		if("b_liquid_overlay")
			if(!host.vore_selected.liquid_overlay)
				host.vore_selected.liquid_overlay = 1
				to_chat(user,span_warning("Your [lowertext(host.vore_selected.name)] now has liquid overlay enabled."))
			else
				host.vore_selected.liquid_overlay = 0
				to_chat(user,span_warning("Your [lowertext(host.vore_selected.name)] no longer has liquid overlay enabled."))
			. = TRUE
		if("b_max_liquid_level")
			var/new_max_liquid_level = params["val"]
			if(!isnum(new_max_liquid_level))
				return FALSE
			host.vore_selected.max_liquid_level = CLAMP(new_max_liquid_level, 0, 100)
			host.vore_selected.update_internal_overlay()
			. = TRUE
		if("b_custom_reagentcolor")
			var/newcolor = tgui_color_picker(user, "Choose custom color for liquid overlay. Cancel for normal reagent color.", "", host.vore_selected.custom_reagentcolor)
			if(newcolor)
				host.vore_selected.custom_reagentcolor = newcolor
			else
				host.vore_selected.custom_reagentcolor = null
			host.vore_selected.update_internal_overlay()
			. = TRUE
		if("b_custom_reagentalpha")
			var/newalpha = text2num(params["val"])
			if(!isnum(newalpha))
				return FALSE
			if(newalpha)
				host.vore_selected.custom_reagentalpha = CLAMP(newalpha, 0, 255)
			else
				host.vore_selected.custom_reagentalpha = null
			host.vore_selected.update_internal_overlay()
			. = TRUE
		if("b_reagent_touches")
			if(!host.vore_selected.reagent_touches)
				host.vore_selected.reagent_touches = 1
				to_chat(user,span_warning("Your [lowertext(host.vore_selected.name)] will now apply reagents to creatures when digesting."))
			else
				host.vore_selected.reagent_touches = 0
				to_chat(user,span_warning("Your [lowertext(host.vore_selected.name)] will no longer apply reagents to creatures when digesting."))
			. = TRUE
		if("b_mush_overlay")
			if(!host.vore_selected.mush_overlay)
				host.vore_selected.mush_overlay = 1
				to_chat(user,span_warning("Your [lowertext(host.vore_selected.name)] now has fullness overlay enabled."))
			else
				host.vore_selected.mush_overlay = 0
				to_chat(user,span_warning("Your [lowertext(host.vore_selected.name)] no longer has fullness overlay enabled."))
			host.vore_selected.update_internal_overlay()
			. = TRUE
		if("b_mush_color")
			var/newcolor = tgui_color_picker(user, "Choose custom color for mush overlay.", "", host.vore_selected.mush_color)
			if(newcolor)
				host.vore_selected.mush_color = newcolor
				host.vore_selected.update_internal_overlay()
			. = TRUE
		if("b_mush_alpha")
			var/newalpha = text2num(params["val"])
			if(!isnum(newalpha))
				return FALSE
			host.vore_selected.mush_alpha = CLAMP(newalpha, 0, 255)
			host.vore_selected.update_internal_overlay()
			. = TRUE
		if("b_max_mush")
			var/new_max_mush = text2num(params["val"])
			if(!isnum(new_max_mush))
				return FALSE
			host.vore_selected.max_mush = CLAMP(new_max_mush, 0, 6000)
			host.vore_selected.update_internal_overlay()
			. = TRUE
		if("b_min_mush")
			var/new_min_mush = text2num(params["val"])
			if(!isnum(new_min_mush))
				return FALSE
			host.vore_selected.min_mush = CLAMP(new_min_mush, 0, 100)
			host.vore_selected.update_internal_overlay()
			. = TRUE
		if("b_item_mush_val")
			var/new_item_mush_val = text2num(params["val"])
			if(!isnum(new_item_mush_val))
				return FALSE
			host.vore_selected.item_mush_val = CLAMP(new_item_mush_val, 0, 1000)
			host.vore_selected.update_internal_overlay()
			. = TRUE
		if("b_metabolism_overlay")
			if(!host.vore_selected.metabolism_overlay)
				host.vore_selected.metabolism_overlay = 1
				to_chat(user,span_warning("Your [lowertext(host.vore_selected.name)] now has ingested metabolism overlay enabled."))
			else
				host.vore_selected.metabolism_overlay = 0
				to_chat(user,span_warning("Your [lowertext(host.vore_selected.name)] no longer has ingested metabolism overlay enabled."))
			host.vore_selected.update_internal_overlay()
			. = TRUE
		if("b_metabolism_mush_ratio")
			var/new_metabolism_mush_ratio = text2num(params["val"])
			if(!isnum(new_metabolism_mush_ratio))
				return FALSE
			host.vore_selected.metabolism_mush_ratio = CLAMP(new_metabolism_mush_ratio, 0, 500)
			host.vore_selected.update_internal_overlay()
			. = TRUE
		if("b_max_ingested")
			var/new_max_ingested = text2num(params["val"])
			if(!isnum(new_max_ingested))
				return FALSE
			host.vore_selected.max_ingested = CLAMP(new_max_ingested, 0, 6000)
			host.vore_selected.update_internal_overlay()
			. = TRUE
		if("b_custom_ingested_color")
			var/newcolor = tgui_color_picker(user, "Choose custom color for ingested metabolism overlay. Cancel for reagent-based dynamic blend.", "", host.vore_selected.custom_ingested_color)
			if(newcolor)
				host.vore_selected.custom_ingested_color = newcolor
			else
				host.vore_selected.custom_ingested_color = null
			host.vore_selected.update_internal_overlay()
			. = TRUE
		if("b_custom_ingested_alpha")
			var/newalpha = text2num(params["val"])
			if(!isnum(newalpha))
				return FALSE
			host.vore_selected.custom_ingested_alpha = newalpha
			host.vore_selected.update_internal_overlay()
			. = TRUE
		if("b_liq_purge")
			host.vore_selected.reagents.clear_reagents()
			. = TRUE
	if(.)
		unsaved_changes = TRUE
