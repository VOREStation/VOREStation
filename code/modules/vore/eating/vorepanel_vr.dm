//
// Vore management panel for players
//

#define BELLIES_MAX 40
#define BELLIES_NAME_MIN 2
#define BELLIES_NAME_MAX 20
#define BELLIES_DESC_MAX 2048
#define FLAVOR_MAX 40

/mob/living
	var/datum/vore_look/vorePanel

/mob/living/proc/insidePanel()
	set name = "Vore Panel"
	set category = "IC"

	if(!vorePanel)
		log_debug("[src] ([type], \ref[src]) didn't have a vorePanel and tried to use the verb.")
		vorePanel = new(src)

	vorePanel.tgui_interact(src)

/mob/living/proc/updateVRPanel() //Panel popup update call from belly events.
	SStgui.update_uis(vorePanel)

//
// Callback Handler for the Inside form
//
/datum/vore_look
	var/mob/living/host // Note, we do this in case we ever want to allow people to view others vore panels
	var/unsaved_changes = FALSE
	var/show_pictures = TRUE

/datum/vore_look/New(mob/living/new_host)
	if(istype(new_host))
		host = new_host
	. = ..()

/datum/vore_look/Destroy()
	host = null
	. = ..()

/datum/vore_look/ui_assets(mob/user)
	. = ..()
	. += get_asset_datum(/datum/asset/spritesheet/vore)

/datum/vore_look/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "VorePanel", "Inside!")
		ui.open()

// This looks weird, but all tgui_host is used for is state checking
// So this allows us to use the self_state just fine.
/datum/vore_look/tgui_host(mob/user)
	return host

// Note, in order to allow others to look at others vore panels, this state would need
// to be changed to tgui_always_state, and a custom tgui_status() implemented for true "rights" management.
/datum/vore_look/tgui_state(mob/user)
	return GLOB.tgui_self_state

/datum/vore_look/var/static/list/nom_icons
/datum/vore_look/proc/cached_nom_icon(atom/target)
	LAZYINITLIST(nom_icons)

	var/key = ""
	if(isobj(target))
		key = "[target.type]"
	else if(ismob(target))
		var/mob/M = target
		key = "\ref[target][M.real_name]"
	if(nom_icons[key])
		. = nom_icons[key]
	else
		. = icon2base64(getFlatIcon(target,defdir=SOUTH,no_anim=TRUE))
		nom_icons[key] = .


/datum/vore_look/tgui_data(mob/user)
	var/list/data = list()

	if(!host)
		return data

	data["unsaved_changes"] = unsaved_changes
	data["show_pictures"] = show_pictures

	data["inside"] = list()
	var/atom/hostloc = host.loc
	if(isbelly(hostloc))
		var/obj/belly/inside_belly = hostloc
		var/mob/living/pred = inside_belly.owner

		data["inside"] = list(
			"absorbed" = host.absorbed,
			"belly_name" = inside_belly.name,
			"belly_mode" = inside_belly.digest_mode,
			"desc" = inside_belly.desc || "No description.",
			"pred" = pred,
			"ref" = "\ref[inside_belly]",
		)

		data["inside"]["contents"] = list()
		for(var/atom/movable/O in inside_belly)
			if(O == host)
				continue

			var/list/info = list(
				"name" = "[O]",
				"absorbed" = FALSE,
				"stat" = 0,
				"ref" = "\ref[O]",
				"outside" = FALSE,
			)
			if(show_pictures)
				info["icon"] = cached_nom_icon(O)
			if(isliving(O))
				var/mob/living/M = O
				info["stat"] = M.stat
				if(M.absorbed)
					info["absorbed"] = TRUE
			data["inside"]["contents"].Add(list(info))

	data["our_bellies"] = list()
	for(var/belly in host.vore_organs)
		var/obj/belly/B = belly
		data["our_bellies"].Add(list(list(
			"selected" = (B == host.vore_selected),
			"name" = B.name,
			"ref" = "\ref[B]",
			"digest_mode" = B.digest_mode,
			"contents" = LAZYLEN(B.contents),
		)))

	data["selected"] = null
	if(host.vore_selected)
		var/obj/belly/selected = host.vore_selected
		data["selected"] = list(
			"belly_name" = selected.name,
			"is_wet" = selected.is_wet,
			"wet_loop" = selected.wet_loop,
			"mode" = selected.digest_mode,
			"item_mode" = selected.item_digest_mode,
			"verb" = selected.vore_verb,
			"desc" = selected.desc,
			"fancy" = selected.fancy_vore,
			"sound" = selected.vore_sound,
			"release_sound" = selected.release_sound,
			// "messages" // TODO
			"can_taste" = selected.can_taste,
			"egg_type" = selected.egg_type,
			"nutrition_percent" = selected.nutrition_percent,
			"digest_brute" = selected.digest_brute,
			"digest_burn" = selected.digest_burn,
			"bulge_size" = selected.bulge_size,
			"shrink_grow_size" = selected.shrink_grow_size,
			"belly_fullscreen" = selected.belly_fullscreen,
			"possible_fullscreens" = icon_states('icons/mob/screen_full_vore.dmi'),
		)

		data["selected"]["addons"] = list()
		for(var/flag_name in selected.mode_flag_list)
			if(selected.mode_flags & selected.mode_flag_list[flag_name])
				data["selected"]["addons"].Add(flag_name)

		data["selected"]["egg_type"] = selected.egg_type
		data["selected"]["contaminates"] = selected.contaminates
		data["selected"]["contaminate_flavor"] = null
		data["selected"]["contaminate_color"] = null
		if(selected.contaminates)
			data["selected"]["contaminate_flavor"] = selected.contamination_flavor
			data["selected"]["contaminate_color"] = selected.contamination_color

		data["selected"]["escapable"] = selected.escapable
		data["selected"]["interacts"] = list()
		if(selected.escapable)
			data["selected"]["interacts"]["escapechance"] = selected.escapechance
			data["selected"]["interacts"]["escapetime"] = selected.escapetime
			data["selected"]["interacts"]["transferchance"] = selected.transferchance
			data["selected"]["interacts"]["transferlocation"] = selected.transferlocation
			data["selected"]["interacts"]["absorbchance"] = selected.absorbchance
			data["selected"]["interacts"]["digestchance"] = selected.digestchance

		data["selected"]["disable_hud"] = selected.disable_hud

		data["selected"]["contents"] = list()
		for(var/O in selected)
			var/list/info = list(
				"name" = "[O]",
				"absorbed" = FALSE,
				"stat" = 0,
				"ref" = "\ref[O]",
				"outside" = TRUE,
			)
			if(show_pictures)
				info["icon"] = cached_nom_icon(O)
			if(isliving(O))
				var/mob/living/M = O
				info["stat"] = M.stat
				if(M.absorbed)
					info["absorbed"] = TRUE
			data["selected"]["contents"].Add(list(info))

	data["prefs"] = list(
		"digestable" = host.digestable,
		"devourable" = host.devourable,
		"feeding" = host.feeding,
		"absorbable" = host.absorbable,
		"digest_leave_remains" = host.digest_leave_remains,
		"allowmobvore" = host.allowmobvore,
		"permit_healbelly" = host.permit_healbelly,
		"show_vore_fx" = host.show_vore_fx,
		"can_be_drop_prey" = host.can_be_drop_prey,
		"can_be_drop_pred" = host.can_be_drop_pred,
		"noisy" = host.noisy,
	)

	return data

/datum/vore_look/tgui_act(action, params)
	if(..())
		return TRUE

	switch(action)
		if("show_pictures")
			show_pictures = !show_pictures
			return TRUE
		if("int_help")
			alert("These control how your belly responds to someone using 'resist' while inside you. The percent chance to trigger each is listed below, \
					and you can change them to whatever you see fit. Setting them to 0% will disable the possibility of that interaction. \
					These only function as long as interactions are turned on in general. Keep in mind, the 'belly mode' interactions (digest/absorb) \
					will affect all prey in that belly, if one resists and triggers digestion/absorption. If multiple trigger at the same time, \
					only the first in the order of 'Escape > Transfer > Absorb > Digest' will occur.","Interactions Help")
			return TRUE

		// Host is inside someone else, and is trying to interact with something else inside that person.
		if("pick_from_inside")
			return pick_from_inside(usr, params)

		// Host is trying to interact with something in host's belly.
		if("pick_from_outside")
			return pick_from_outside(usr, params)

		if("newbelly")
			if(host.vore_organs.len >= BELLIES_MAX)
				return FALSE

			var/new_name = html_encode(input(usr,"New belly's name:","New Belly") as text|null)

			var/failure_msg
			if(length(new_name) > BELLIES_NAME_MAX || length(new_name) < BELLIES_NAME_MIN)
				failure_msg = "Entered belly name length invalid (must be longer than [BELLIES_NAME_MIN], no more than than [BELLIES_NAME_MAX])."
			// else if(whatever) //Next test here.
			else
				for(var/belly in host.vore_organs)
					var/obj/belly/B = belly
					if(lowertext(new_name) == lowertext(B.name))
						failure_msg = "No duplicate belly names, please."
						break

			if(failure_msg) //Something went wrong.
				alert(usr, failure_msg, "Error!")
				return TRUE

			var/obj/belly/NB = new(host)
			NB.name = new_name
			host.vore_selected = NB
			unsaved_changes = TRUE
			return TRUE

		if("bellypick")
			host.vore_selected = locate(params["bellypick"])
			return TRUE
		if("move_belly")
			var/dir = text2num(params["dir"])
			if(LAZYLEN(host.vore_organs) <= 1)
				to_chat(usr, "<span class='warning'>You can't sort bellies with only one belly to sort...</span>")
				return TRUE

			var/current_index = host.vore_organs.Find(host.vore_selected)
			if(current_index)
				var/new_index = clamp(current_index + dir, 1, LAZYLEN(host.vore_organs))
				host.vore_organs.Swap(current_index, new_index)
				unsaved_changes = TRUE
			return TRUE

		if("set_attribute")
			return set_attr(usr, params)

		if("saveprefs")
			if(!host.save_vore_prefs())
				alert("ERROR: Virgo-specific preferences failed to save!","Error")
			else
				to_chat(usr, "<span class='notice'>Virgo-specific preferences saved!</span>")
				unsaved_changes = FALSE
			return TRUE
		if("reloadprefs")
			var/alert = alert("Are you sure you want to reload character slot preferences? This will remove your current vore organs and eject their contents.","Confirmation","Reload","Cancel")
			if(alert != "Reload")
				return FALSE
			if(!host.apply_vore_prefs())
				alert("ERROR: Virgo-specific preferences failed to apply!","Error")
			else
				to_chat(usr,"<span class='notice'>Virgo-specific preferences applied from active slot!</span>")
				unsaved_changes = FALSE
			return TRUE
		if("setflavor")
			var/new_flavor = html_encode(input(usr,"What your character tastes like (40ch limit). This text will be printed to the pred after 'X tastes of...' so just put something like 'strawberries and cream':","Character Flavor",host.vore_taste) as text|null)
			if(!new_flavor)
				return FALSE

			new_flavor = readd_quotes(new_flavor)
			if(length(new_flavor) > FLAVOR_MAX)
				alert("Entered flavor/taste text too long. [FLAVOR_MAX] character limit.","Error!")
				return FALSE
			host.vore_taste = new_flavor
			unsaved_changes = TRUE
			return TRUE
		if("setsmell")
			var/new_smell = html_encode(input(usr,"What your character smells like (40ch limit). This text will be printed to the pred after 'X smells of...' so just put something like 'strawberries and cream':","Character Smell",host.vore_smell) as text|null)
			if(!new_smell)
				return FALSE

			new_smell = readd_quotes(new_smell)
			if(length(new_smell) > FLAVOR_MAX)
				alert("Entered perfume/smell text too long. [FLAVOR_MAX] character limit.","Error!")
				return FALSE
			host.vore_smell = new_smell
			unsaved_changes = TRUE
			return TRUE
		if("toggle_dropnom_pred")
			host.can_be_drop_pred = !host.can_be_drop_pred
			if(host.client.prefs_vr)
				host.client.prefs_vr.can_be_drop_pred = host.can_be_drop_pred
			unsaved_changes = TRUE
			return TRUE
		if("toggle_dropnom_prey")
			host.can_be_drop_prey = !host.can_be_drop_prey
			if(host.client.prefs_vr)
				host.client.prefs_vr.can_be_drop_prey = host.can_be_drop_prey
			unsaved_changes = TRUE
			return TRUE
		if("toggle_digest")
			host.digestable = !host.digestable
			if(host.client.prefs_vr)
				host.client.prefs_vr.digestable = host.digestable
			unsaved_changes = TRUE
			return TRUE
		if("toggle_devour")
			host.devourable = !host.devourable
			if(host.client.prefs_vr)
				host.client.prefs_vr.devourable = host.devourable
			unsaved_changes = TRUE
			return TRUE
		if("toggle_feed")
			host.feeding = !host.feeding
			if(host.client.prefs_vr)
				host.client.prefs_vr.feeding = host.feeding
			unsaved_changes = TRUE
			return TRUE
		if("toggle_absorbable")
			host.absorbable = !host.absorbable
			if(host.client.prefs_vr)
				host.client.prefs_vr.absorbable = host.absorbable
			unsaved_changes = TRUE
			return TRUE
		if("toggle_leaveremains")
			host.digest_leave_remains = !host.digest_leave_remains
			if(host.client.prefs_vr)
				host.client.prefs_vr.digest_leave_remains = host.digest_leave_remains
			unsaved_changes = TRUE
			return TRUE
		if("toggle_mobvore")
			host.allowmobvore = !host.allowmobvore
			if(host.client.prefs_vr)
				host.client.prefs_vr.allowmobvore = host.allowmobvore
			unsaved_changes = TRUE
			return TRUE
		if("toggle_healbelly")
			host.permit_healbelly = !host.permit_healbelly
			if(host.client.prefs_vr)
				host.client.prefs_vr.permit_healbelly = host.permit_healbelly
			unsaved_changes = TRUE
			return TRUE
		if("toggle_fx")
			host.show_vore_fx = !host.show_vore_fx
			if(host.client.prefs_vr)
				host.client.prefs_vr.show_vore_fx = host.show_vore_fx
			if(!host.show_vore_fx)
				host.clear_fullscreen("belly")
				if(!host.hud_used.hud_shown)
					host.toggle_hud_vis()
			unsaved_changes = TRUE
			return TRUE
		if("toggle_noisy")
			host.noisy = !host.noisy
			unsaved_changes = TRUE
			return TRUE

/datum/vore_look/proc/pick_from_inside(mob/user, params)
	var/atom/movable/target = locate(params["pick"])
	var/obj/belly/OB = locate(params["belly"])

	if(!(target in OB))
		return TRUE // Aren't here anymore, need to update menu

	var/intent = "Examine"
	if(isliving(target))
		intent = alert("What do you want to do to them?","Query","Examine","Help Out","Devour")

	else if(istype(target, /obj/item))
		intent = alert("What do you want to do to that?","Query","Examine","Use Hand")

	switch(intent)
		if("Examine") //Examine a mob inside another mob
			var/list/results = target.examine(host)
			if(!results || !results.len)
				results = list("You were unable to examine that. Tell a developer!")
			to_chat(user, jointext(results, "<br>"))
			return TRUE

		if("Use Hand")
			if(host.stat)
				to_chat(user, "<span class='warning'>You can't do that in your state!</span>")
				return TRUE

			host.ClickOn(target)
			return TRUE

	if(!isliving(target))
		return

	var/mob/living/M = target
	switch(intent)
		if("Help Out") //Help the inside-mob out
			if(host.stat || host.absorbed || M.absorbed)
				to_chat(user, "<span class='warning'>You can't do that in your state!</span>")
				return TRUE

			to_chat(user,"<font color='green'>You begin to push [M] to freedom!</font>")
			to_chat(M,"[host] begins to push you to freedom!")
			to_chat(M.loc,"<span class='warning'>Someone is trying to escape from inside you!</span>")
			sleep(50)
			if(prob(33))
				OB.release_specific_contents(M)
				to_chat(user,"<font color='green'>You manage to help [M] to safety!</font>")
				to_chat(M,"<font color='green'>[host] pushes you free!</font>")
				to_chat(OB.owner,"<span class='alert'>[M] forces free of the confines of your body!</span>")
			else
				to_chat(user,"<span class='alert'>[M] slips back down inside despite your efforts.</span>")
				to_chat(M,"<span class='alert'> Even with [host]'s help, you slip back inside again.</span>")
				to_chat(OB.owner,"<font color='green'>Your body efficiently shoves [M] back where they belong.</font>")
			return TRUE

		if("Devour") //Eat the inside mob
			if(host.absorbed || host.stat)
				to_chat(user,"<span class='warning'>You can't do that in your state!</span>")
				return TRUE

			if(!host.vore_selected)
				to_chat(user,"<span class='warning'>Pick a belly on yourself first!</span>")
				return TRUE

			var/obj/belly/TB = host.vore_selected
			to_chat(user,"<span class='warning'>You begin to [lowertext(TB.vore_verb)] [M] into your [lowertext(TB.name)]!</span>")
			to_chat(M,"<span class='warning'>[host] begins to [lowertext(TB.vore_verb)] you into their [lowertext(TB.name)]!</span>")
			to_chat(OB.owner,"<span class='warning'>Someone inside you is eating someone else!</span>")

			sleep(TB.nonhuman_prey_swallow_time) //Can't do after, in a stomach, weird things abound.
			if((host in OB) && (M in OB)) //Make sure they're still here.
				to_chat(user,"<span class='warning'>You manage to [lowertext(TB.vore_verb)] [M] into your [lowertext(TB.name)]!</span>")
				to_chat(M,"<span class='warning'>[host] manages to [lowertext(TB.vore_verb)] you into their [lowertext(TB.name)]!</span>")
				to_chat(OB.owner,"<span class='warning'>Someone inside you has eaten someone else!</span>")
				TB.nom_mob(M)

/datum/vore_look/proc/pick_from_outside(mob/user, params)
	var/intent

	//Handle the [All] choice. Ugh inelegant. Someone make this pretty.
	if(params["pickall"])
		intent = alert("Eject all, Move all?","Query","Eject all","Cancel","Move all")
		switch(intent)
			if("Cancel")
				return TRUE

			if("Eject all")
				if(host.stat)
					to_chat(user,"<span class='warning'>You can't do that in your state!</span>")
					return TRUE

				host.vore_selected.release_all_contents()
				return TRUE

			if("Move all")
				if(host.stat)
					to_chat(user,"<span class='warning'>You can't do that in your state!</span>")
					return TRUE

				var/obj/belly/choice = input("Move all where?","Select Belly") as null|anything in host.vore_organs
				if(!choice)
					return FALSE

				for(var/atom/movable/target in host.vore_selected)
					to_chat(target,"<span class='warning'>You're squished from [host]'s [lowertext(host.vore_selected)] to their [lowertext(choice.name)]!</span>")
					host.vore_selected.transfer_contents(target, choice, 1)
				return TRUE
		return

	var/atom/movable/target = locate(params["pick"])
	if(!(target in host.vore_selected))
		return TRUE // Not in our X anymore, update UI
	var/list/available_options = list("Examine", "Eject", "Move")
	if(ishuman(target))
		available_options += "Transform"
	intent = input(user, "What would you like to do with [target]?", "Vore Pick", "Examine") as null|anything in available_options
	switch(intent)
		if("Examine")
			var/list/results = target.examine(host)
			if(!results || !results.len)
				results = list("You were unable to examine that. Tell a developer!")
			to_chat(user, jointext(results, "<br>"))
			return TRUE

		if("Eject")
			if(host.stat)
				to_chat(user,"<span class='warning'>You can't do that in your state!</span>")
				return TRUE

			host.vore_selected.release_specific_contents(target)
			return TRUE

		if("Move")
			if(host.stat)
				to_chat(user,"<span class='warning'>You can't do that in your state!</span>")
				return TRUE

			var/obj/belly/choice = input("Move [target] where?","Select Belly") as null|anything in host.vore_organs
			if(!choice || !(target in host.vore_selected))
				return TRUE

			to_chat(target,"<span class='warning'>You're squished from [host]'s [lowertext(host.vore_selected.name)] to their [lowertext(choice.name)]!</span>")
			host.vore_selected.transfer_contents(target, choice)
			return TRUE

		if("Transform")
			if(host.stat)
				to_chat(user,"<span class='warning'>You can't do that in your state!</span>")
				return TRUE

			var/mob/living/carbon/human/H = target
			if(!istype(H))
				return

			var/datum/tgui_module/appearance_changer/vore/V = new(host, H)
			V.tgui_interact(user)
			return TRUE

/datum/vore_look/proc/set_attr(mob/user, params)
	if(!host.vore_selected)
		alert("No belly selected to modify.")
		return FALSE

	var/attr = params["attribute"]
	switch(attr)
		if("b_name")
			var/new_name = html_encode(input(usr,"Belly's new name:","New Name") as text|null)

			var/failure_msg
			if(length(new_name) > BELLIES_NAME_MAX || length(new_name) < BELLIES_NAME_MIN)
				failure_msg = "Entered belly name length invalid (must be longer than [BELLIES_NAME_MIN], no more than than [BELLIES_NAME_MAX])."
			// else if(whatever) //Next test here.
			else
				for(var/belly in host.vore_organs)
					var/obj/belly/B = belly
					if(lowertext(new_name) == lowertext(B.name))
						failure_msg = "No duplicate belly names, please."
						break

			if(failure_msg) //Something went wrong.
				alert(user,failure_msg,"Error!")
				return FALSE

			host.vore_selected.name = new_name
			. = TRUE
		if("b_wetness")
			host.vore_selected.is_wet = !host.vore_selected.is_wet
			. = TRUE
		if("b_wetloop")
			host.vore_selected.wet_loop = !host.vore_selected.wet_loop
			. = TRUE
		if("b_mode")
			var/list/menu_list = host.vore_selected.digest_modes.Copy()
			var/new_mode = input("Choose Mode (currently [host.vore_selected.digest_mode])") as null|anything in menu_list
			if(!new_mode)
				return FALSE

			host.vore_selected.digest_mode = new_mode
			. = TRUE
		if("b_addons")
			var/list/menu_list = host.vore_selected.mode_flag_list.Copy()
			var/toggle_addon = input("Toggle Addon") as null|anything in menu_list
			if(!toggle_addon)
				return FALSE
			host.vore_selected.mode_flags ^= host.vore_selected.mode_flag_list[toggle_addon]
			host.vore_selected.items_preserved.Cut() //Re-evaltuate all items in belly on
			. = TRUE
		if("b_item_mode")
			var/list/menu_list = host.vore_selected.item_digest_modes.Copy()

			var/new_mode = input("Choose Mode (currently [host.vore_selected.item_digest_mode])") as null|anything in menu_list
			if(!new_mode)
				return FALSE

			host.vore_selected.item_digest_mode = new_mode
			host.vore_selected.items_preserved.Cut() //Re-evaltuate all items in belly on belly-mode change
			. = TRUE
		if("b_contaminates")
			host.vore_selected.contaminates = !host.vore_selected.contaminates
			. = TRUE
		if("b_contamination_flavor")
			var/list/menu_list = contamination_flavors.Copy()
			var/new_flavor = input("Choose Contamination Flavor Text Type (currently [host.vore_selected.contamination_flavor])") as null|anything in menu_list
			if(!new_flavor)
				return FALSE
			host.vore_selected.contamination_flavor = new_flavor
			. = TRUE
		if("b_contamination_color")
			var/list/menu_list = contamination_colors.Copy()
			var/new_color = input("Choose Contamination Color (currently [host.vore_selected.contamination_color])") as null|anything in menu_list
			if(!new_color)
				return FALSE
			host.vore_selected.contamination_color = new_color
			host.vore_selected.items_preserved.Cut() //To re-contaminate for new color
			. = TRUE
		if("b_egg_type")
			var/list/menu_list = global_vore_egg_types.Copy()
			var/new_egg_type = input("Choose Egg Type (currently [host.vore_selected.egg_type])") as null|anything in menu_list
			if(!new_egg_type)
				return FALSE
			host.vore_selected.egg_type = new_egg_type
			. = TRUE
		if("b_desc")
			var/new_desc = html_encode(input(usr,"Belly Description ([BELLIES_DESC_MAX] char limit):","New Description",host.vore_selected.desc) as message|null)

			if(new_desc)
				new_desc = readd_quotes(new_desc)
				if(length(new_desc) > BELLIES_DESC_MAX)
					alert("Entered belly desc too long. [BELLIES_DESC_MAX] character limit.","Error")
					return FALSE
				host.vore_selected.desc = new_desc
				. = TRUE
		if("b_msgs")
			alert(user,"Setting abusive or deceptive messages will result in a ban. Consider this your warning. Max 150 characters per message, max 10 messages per topic.","Really, don't.")
			var/help = " Press enter twice to separate messages. '%pred' will be replaced with your name. '%prey' will be replaced with the prey's name. '%belly' will be replaced with your belly's name. '%count' will be replaced with the number of anything in your belly. '%countprey' will be replaced with the number of living prey in your belly."
			switch(params["msgtype"])
				if("dmp")
					var/new_message = input(user,"These are sent to prey when they expire. Write them in 2nd person ('you feel X'). Avoid using %prey in this type."+help,"Digest Message (to prey)",host.vore_selected.get_messages("dmp")) as message
					if(new_message)
						host.vore_selected.set_messages(new_message,"dmp")

				if("dmo")
					var/new_message = input(user,"These are sent to you when prey expires in you. Write them in 2nd person ('you feel X'). Avoid using %pred in this type."+help,"Digest Message (to you)",host.vore_selected.get_messages("dmo")) as message
					if(new_message)
						host.vore_selected.set_messages(new_message,"dmo")

				if("smo")
					var/new_message = input(user,"These are sent to those nearby when prey struggles. Write them in 3rd person ('X's Y bulges')."+help,"Struggle Message (outside)",host.vore_selected.get_messages("smo")) as message
					if(new_message)
						host.vore_selected.set_messages(new_message,"smo")

				if("smi")
					var/new_message = input(user,"These are sent to prey when they struggle. Write them in 2nd person ('you feel X'). Avoid using %prey in this type."+help,"Struggle Message (inside)",host.vore_selected.get_messages("smi")) as message
					if(new_message)
						host.vore_selected.set_messages(new_message,"smi")

				if("em")
					var/new_message = input(user,"These are sent to people who examine you when this belly has contents. Write them in 3rd person ('Their %belly is bulging')."+help,"Examine Message (when full)",host.vore_selected.get_messages("em")) as message
					if(new_message)
						host.vore_selected.set_messages(new_message,"em")

				if("reset")
					var/confirm = alert(user,"This will delete any custom messages. Are you sure?","Confirmation","DELETE","Cancel")
					if(confirm == "DELETE")
						host.vore_selected.digest_messages_prey = initial(host.vore_selected.digest_messages_prey)
						host.vore_selected.digest_messages_owner = initial(host.vore_selected.digest_messages_owner)
						host.vore_selected.struggle_messages_outside = initial(host.vore_selected.struggle_messages_outside)
						host.vore_selected.struggle_messages_inside = initial(host.vore_selected.struggle_messages_inside)
			. = TRUE
		if("b_verb")
			var/new_verb = html_encode(input(usr,"New verb when eating (infinitive tense, e.g. nom or swallow):","New Verb") as text|null)

			if(length(new_verb) > BELLIES_NAME_MAX || length(new_verb) < BELLIES_NAME_MIN)
				alert("Entered verb length invalid (must be longer than [BELLIES_NAME_MIN], no longer than [BELLIES_NAME_MAX]).","Error")
				return FALSE

			host.vore_selected.vore_verb = new_verb
			. = TRUE
		if("b_fancy_sound")
			host.vore_selected.fancy_vore = !host.vore_selected.fancy_vore
			host.vore_selected.vore_sound = "Gulp"
			host.vore_selected.release_sound = "Splatter"
			// defaults as to avoid potential bugs
			. = TRUE
		if("b_release")
			var/choice
			if(host.vore_selected.fancy_vore)
				choice = input(user,"Currently set to [host.vore_selected.release_sound]","Select Sound") as null|anything in fancy_release_sounds
			else
				choice = input(user,"Currently set to [host.vore_selected.release_sound]","Select Sound") as null|anything in classic_release_sounds

			if(!choice)
				return FALSE

			host.vore_selected.release_sound = choice
			. = TRUE
		if("b_releasesoundtest")
			var/sound/releasetest
			if(host.vore_selected.fancy_vore)
				releasetest = fancy_release_sounds[host.vore_selected.release_sound]
			else
				releasetest = classic_release_sounds[host.vore_selected.release_sound]

			if(releasetest)
				SEND_SOUND(user, releasetest)
			. = TRUE
		if("b_sound")
			var/choice
			if(host.vore_selected.fancy_vore)
				choice = input(user,"Currently set to [host.vore_selected.vore_sound]","Select Sound") as null|anything in fancy_vore_sounds
			else
				choice = input(user,"Currently set to [host.vore_selected.vore_sound]","Select Sound") as null|anything in classic_vore_sounds

			if(!choice)
				return FALSE

			host.vore_selected.vore_sound = choice
			. = TRUE
		if("b_soundtest")
			var/sound/voretest
			if(host.vore_selected.fancy_vore)
				voretest = fancy_vore_sounds[host.vore_selected.vore_sound]
			else
				voretest = classic_vore_sounds[host.vore_selected.vore_sound]
			if(voretest)
				SEND_SOUND(user, voretest)
			. = TRUE
		if("b_tastes")
			host.vore_selected.can_taste = !host.vore_selected.can_taste
			. = TRUE
		if("b_bulge_size")
			var/new_bulge = input(user, "Choose the required size prey must be to show up on examine, ranging from 25% to 200% Set this to 0 for no text on examine.", "Set Belly Examine Size.") as num|null
			if(new_bulge == null)
				return FALSE
			if(new_bulge == 0) //Disable.
				host.vore_selected.bulge_size = 0
				to_chat(user,"<span class='notice'>Your stomach will not be seen on examine.</span>")
			else if (!ISINRANGE(new_bulge,25,200))
				host.vore_selected.bulge_size = 0.25 //Set it to the default.
				to_chat(user,"<span class='notice'>Invalid size.</span>")
			else if(new_bulge)
				host.vore_selected.bulge_size = (new_bulge/100)
			. = TRUE
		if("b_grow_shrink")
			var/new_grow = input(user, "Choose the size that prey will be grown/shrunk to, ranging from 25% to 200%", "Set Growth Shrink Size.", host.vore_selected.shrink_grow_size) as num|null
			if (new_grow == null)
				return FALSE
			if (!ISINRANGE(new_grow,25,200))
				host.vore_selected.shrink_grow_size = 1 //Set it to the default
				to_chat(user,"<span class='notice'>Invalid size.</span>")
			else if(new_grow)
				host.vore_selected.shrink_grow_size = (new_grow*0.01)
			. = TRUE
		if("b_nutritionpercent")
			var/new_nutrition = input(user, "Choose the nutrition gain percentage you will recieve per tick from prey. Ranges from 0.01 to 100.", "Set Nutrition Gain Percentage.", host.vore_selected.nutrition_percent) as num|null
			if(new_nutrition == null)
				return FALSE
			var/new_new_nutrition = CLAMP(new_nutrition, 0.01, 100)
			host.vore_selected.nutrition_percent = new_new_nutrition
			. = TRUE
		if("b_burn_dmg")
			var/new_damage = input(user, "Choose the amount of burn damage prey will take per tick. Ranges from 0 to 6.", "Set Belly Burn Damage.", host.vore_selected.digest_burn) as num|null
			if(new_damage == null)
				return FALSE
			var/new_new_damage = CLAMP(new_damage, 0, 6)
			host.vore_selected.digest_burn = new_new_damage
			. = TRUE
		if("b_brute_dmg")
			var/new_damage = input(user, "Choose the amount of brute damage prey will take per tick. Ranges from 0 to 6", "Set Belly Brute Damage.", host.vore_selected.digest_brute) as num|null
			if(new_damage == null)
				return FALSE
			var/new_new_damage = CLAMP(new_damage, 0, 6)
			host.vore_selected.digest_brute = new_new_damage
			. = TRUE
		if("b_escapable")
			if(host.vore_selected.escapable == 0) //Possibly escapable and special interactions.
				host.vore_selected.escapable = 1
				to_chat(usr,"<span class='warning'>Prey now have special interactions with your [lowertext(host.vore_selected.name)] depending on your settings.</span>")
			else if(host.vore_selected.escapable == 1) //Never escapable.
				host.vore_selected.escapable = 0
				to_chat(usr,"<span class='warning'>Prey will not be able to have special interactions with your [lowertext(host.vore_selected.name)].</span>")
			else
				alert("Something went wrong. Your stomach will now not have special interactions. Press the button enable them again and tell a dev.","Error") //If they somehow have a varable that's not 0 or 1
				host.vore_selected.escapable = 0
			. = TRUE
		if("b_escapechance")
			var/escape_chance_input = input(user, "Set prey escape chance on resist (as %)", "Prey Escape Chance") as num|null
			if(!isnull(escape_chance_input)) //These have to be 'null' because both cancel and 0 are valid, separate options
				host.vore_selected.escapechance = sanitize_integer(escape_chance_input, 0, 100, initial(host.vore_selected.escapechance))
			. = TRUE
		if("b_escapetime")
			var/escape_time_input = input(user, "Set number of seconds for prey to escape on resist (1-60)", "Prey Escape Time") as num|null
			if(!isnull(escape_time_input))
				host.vore_selected.escapetime = sanitize_integer(escape_time_input*10, 10, 600, initial(host.vore_selected.escapetime))
			. = TRUE
		if("b_transferchance")
			var/transfer_chance_input = input(user, "Set belly transfer chance on resist (as %). You must also set the location for this to have any effect.", "Prey Escape Time") as num|null
			if(!isnull(transfer_chance_input))
				host.vore_selected.transferchance = sanitize_integer(transfer_chance_input, 0, 100, initial(host.vore_selected.transferchance))
			. = TRUE
		if("b_transferlocation")
			var/obj/belly/choice = input("Where do you want your [lowertext(host.vore_selected.name)] to lead if prey resists?","Select Belly") as null|anything in (host.vore_organs + "None - Remove" - host.vore_selected)

			if(!choice) //They cancelled, no changes
				return FALSE
			else if(choice == "None - Remove")
				host.vore_selected.transferlocation = null
			else
				host.vore_selected.transferlocation = choice.name
			. = TRUE
		if("b_absorbchance")
			var/absorb_chance_input = input(user, "Set belly absorb mode chance on resist (as %)", "Prey Absorb Chance") as num|null
			if(!isnull(absorb_chance_input))
				host.vore_selected.absorbchance = sanitize_integer(absorb_chance_input, 0, 100, initial(host.vore_selected.absorbchance))
			. = TRUE
		if("b_digestchance")
			var/digest_chance_input = input(user, "Set belly digest mode chance on resist (as %)", "Prey Digest Chance") as num|null
			if(!isnull(digest_chance_input))
				host.vore_selected.digestchance = sanitize_integer(digest_chance_input, 0, 100, initial(host.vore_selected.digestchance))
			. = TRUE
		if("b_fullscreen")
			host.vore_selected.belly_fullscreen = params["val"]
			. = TRUE
		if("b_disable_hud")
			host.vore_selected.disable_hud = !host.vore_selected.disable_hud
			. = TRUE
		if("b_del")
			var/alert = alert("Are you sure you want to delete your [lowertext(host.vore_selected.name)]?","Confirmation","Delete","Cancel")
			if(!(alert == "Delete"))
				return FALSE

			var/failure_msg = ""

			var/dest_for //Check to see if it's the destination of another vore organ.
			for(var/belly in host.vore_organs)
				var/obj/belly/B = belly
				if(B.transferlocation == host.vore_selected)
					dest_for = B.name
					failure_msg += "This is the destiantion for at least '[dest_for]' belly transfers. Remove it as the destination from any bellies before deleting it. "
					break

			if(host.vore_selected.contents.len)
				failure_msg += "You cannot delete bellies with contents! " //These end with spaces, to be nice looking. Make sure you do the same.
			if(host.vore_selected.immutable)
				failure_msg += "This belly is marked as undeletable. "
			if(host.vore_organs.len == 1)
				failure_msg += "You must have at least one belly. "

			if(failure_msg)
				alert(user,failure_msg,"Error!")
				return FALSE

			qdel(host.vore_selected)
			host.vore_selected = host.vore_organs[1]
			. = TRUE

	if(.)
		unsaved_changes = TRUE