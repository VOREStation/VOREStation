var/obj/screen/robot_inventory

/mob/living/silicon/robot/create_mob_hud(datum/hud/HUD, apply_to_client = TRUE)
	..()

	// Don't care about your prefs! Our icon is more important
	if(HUD.ui_style == 'icons/mob/screen/minimalist.dmi')
		HUD.ui_style = 'icons/mob/screen1_robot_minimalist.dmi'
	else
		HUD.ui_style = 'icons/mob/screen1_robot.dmi'

	var/list/adding = list()
	var/list/other = list()
	
	HUD.adding = adding
	HUD.other = other

	var/obj/screen/using

//Radio
	using = new /obj/screen()
	using.name = "radio"
	using.set_dir(SOUTHWEST)
	using.icon = HUD.ui_style
	using.color = HUD.ui_color
	using.alpha = HUD.ui_alpha
	using.icon_state = "radio"
	using.screen_loc = ui_movi
	using.layer = HUD_LAYER
	adding += using

//Module select

	using = new /obj/screen()
	using.name = "module1"
	using.set_dir(SOUTHWEST)
	using.icon = HUD.ui_style
	using.color = HUD.ui_color
	using.alpha = HUD.ui_alpha
	using.icon_state = "inv1"
	using.screen_loc = ui_inv1
	using.layer = HUD_LAYER
	adding += using
	inv1 = using

	using = new /obj/screen()
	using.name = "module2"
	using.set_dir(SOUTHWEST)
	using.icon = HUD.ui_style
	using.color = HUD.ui_color
	using.alpha = HUD.ui_alpha
	using.icon_state = "inv2"
	using.screen_loc = ui_inv2
	using.layer = HUD_LAYER
	adding += using
	inv2 = using

	using = new /obj/screen()
	using.name = "module3"
	using.set_dir(SOUTHWEST)
	using.icon = HUD.ui_style
	using.color = HUD.ui_color
	using.alpha = HUD.ui_alpha
	using.icon_state = "inv3"
	using.screen_loc = ui_inv3
	using.layer = HUD_LAYER
	adding += using
	inv3 = using

//End of module select

//Intent
	using = new /obj/screen()
	using.name = "act_intent"
	using.set_dir(SOUTHWEST)
	using.icon = HUD.ui_style
	using.alpha = HUD.ui_alpha
	using.icon_state = a_intent
	using.screen_loc = ui_acti
	using.layer = HUD_LAYER
	adding += using
	HUD.action_intent = using

//Health
	healths = new /obj/screen()
	healths.icon = HUD.ui_style
	healths.icon_state = "health0"
	healths.alpha = HUD.ui_alpha
	healths.name = "health"
	healths.screen_loc = ui_borg_health
	other += healths

//Installed Module
	hands = new /obj/screen()
	hands.icon = HUD.ui_style
	hands.icon_state = "nomod"
	hands.alpha = HUD.ui_alpha
	hands.name = "module"
	hands.screen_loc = ui_borg_module
	other += hands

//Module Panel
	using = new /obj/screen()
	using.name = "panel"
	using.icon = HUD.ui_style
	using.icon_state = "panel"
	using.alpha = HUD.ui_alpha
	using.screen_loc = ui_borg_panel
	using.layer = HUD_LAYER-0.01
	adding += using

//Store
	throw_icon = new /obj/screen()
	throw_icon.icon = HUD.ui_style
	throw_icon.icon_state = "store"
	throw_icon.alpha = HUD.ui_alpha
	throw_icon.color = HUD.ui_color
	throw_icon.name = "store"
	throw_icon.screen_loc = ui_borg_store
	other += throw_icon

//Inventory
	robot_inventory = new /obj/screen()
	robot_inventory.name = "inventory"
	robot_inventory.icon = HUD.ui_style
	robot_inventory.icon_state = "inventory"
	robot_inventory.alpha = HUD.ui_alpha
	robot_inventory.color = HUD.ui_color
	robot_inventory.screen_loc = ui_borg_inventory
	other += robot_inventory

	pullin = new /obj/screen()
	pullin.icon = HUD.ui_style
	pullin.icon_state = "pull0"
	pullin.alpha = HUD.ui_alpha
	pullin.color = HUD.ui_color
	pullin.name = "pull"
	pullin.screen_loc = ui_borg_pull
	other += pullin

	zone_sel = new /obj/screen/zone_sel()
	zone_sel.icon = HUD.ui_style
	zone_sel.alpha = HUD.ui_alpha
	zone_sel.overlays.Cut()
	zone_sel.overlays += image('icons/mob/zone_sel.dmi', "[zone_sel.selecting]")

	//Handle the gun settings buttons
	gun_setting_icon = new /obj/screen/gun/mode(null)
	gun_setting_icon.icon = HUD.ui_style
	gun_setting_icon.alpha = HUD.ui_alpha
	item_use_icon = new /obj/screen/gun/item(null)
	item_use_icon.icon = HUD.ui_style
	item_use_icon.alpha = HUD.ui_alpha
	gun_move_icon = new /obj/screen/gun/move(null)
	gun_move_icon.icon = HUD.ui_style
	gun_move_icon.alpha = HUD.ui_alpha
	radio_use_icon = new /obj/screen/gun/radio(null)
	radio_use_icon.icon = HUD.ui_style
	radio_use_icon.alpha = HUD.ui_alpha

	if(client && apply_to_client)
		client.screen = list()
		client.screen += list( throw_icon, zone_sel, hands, healths, pullin, robot_inventory, gun_setting_icon)
		client.screen += HUD.adding + HUD.other
		client.screen += client.void


/datum/hud/proc/toggle_show_robot_modules()
	if(!isrobot(mymob))
		return

	var/mob/living/silicon/robot/r = mymob

	r.shown_robot_modules = !r.shown_robot_modules
	update_robot_modules_display()


/datum/hud/proc/update_robot_modules_display()
	if(!isrobot(mymob))
		return

	var/mob/living/silicon/robot/r = mymob

	if(r.shown_robot_modules)
		//Modules display is shown
		//r.client.screen += robot_inventory	//"store" icon

		if(!r.module)
			to_chat(usr, "<span class='danger'>No module selected</span>")
			return

		if(!r.module.modules)
			to_chat(usr, "<span class='danger'>Selected module has no modules to select</span>")
			return

		if(!r.robot_modules_background)
			return

		var/display_rows = -round(-(r.module.modules.len) / 8)
		r.robot_modules_background.screen_loc = "CENTER-4:16,SOUTH+1:7 to CENTER+3:16,SOUTH+[display_rows]:7"
		r.client.screen += r.robot_modules_background

		var/x = -4	//Start at CENTER-4,SOUTH+1
		var/y = 1

		//Unfortunately adding the emag module to the list of modules has to be here. This is because a borg can
		//be emagged before they actually select a module. - or some situation can cause them to get a new module
		// - or some situation might cause them to get de-emagged or something.
		if(r.emagged || r.emag_items)
			if(!(r.module.emag in r.module.modules))
				r.module.modules.Add(r.module.emag)
		else
			if(r.module.emag in r.module.modules)
				r.module.modules.Remove(r.module.emag)

		for(var/atom/movable/A in r.module.modules)
			if( (A != r.module_state_1) && (A != r.module_state_2) && (A != r.module_state_3) )
				//Module is not currently active
				r.client.screen += A
				if(x < 0)
					A.screen_loc = "CENTER[x]:16,SOUTH+[y]:7"
				else
					A.screen_loc = "CENTER+[x]:16,SOUTH+[y]:7"
				A.hud_layerise()

				x++
				if(x == 4)
					x = -4
					y++

	else
		//Modules display is hidden
		//r.client.screen -= robot_inventory	//"store" icon
		for(var/atom/A in r.module.modules)
			if( (A != r.module_state_1) && (A != r.module_state_2) && (A != r.module_state_3) )
				//Module is not currently active
				r.client.screen -= A
		r.shown_robot_modules = 0
		r.client.screen -= r.robot_modules_background

/mob/living/silicon/robot/update_hud()
	if(modtype)
		hands.icon_state = lowertext(modtype)
	..()