var/obj/screen/robot_inventory
/*
/mob/living/silicon/robot/instantiate_hud(var/datum/hud/HUD, var/ui_style, var/ui_color, var/ui_alpha)
	HUD.robot_hud(ui_style, ui_color, ui_alpha, src)*/

/datum/hud/proc/robot_hud(ui_style='icons/mob/screen1_robot.dmi', var/ui_color = "#ffffff", var/ui_alpha = 255, var/mob/living/silicon/robot/target)
/*	var/datum/hud_data/hud_data
	if(!istype(target))
		hud_data = new()

	if(hud_data.icon)
		ui_style = hud_data.icon*/

	if(ui_style == 'icons/mob/screen/minimalist.dmi')
		ui_style = 'icons/mob/screen1_robot_minimalist.dmi'
	else
		ui_style = 'icons/mob/screen1_robot.dmi'

	src.adding = list()
	src.other = list()

	var/obj/screen/using

//Radio
	using = new /obj/screen()
	using.name = "radio"
	using.set_dir(SOUTHWEST)
	using.icon = ui_style
	using.color = ui_color
	using.alpha = ui_alpha
	using.icon_state = "radio"
	using.screen_loc = ui_movi
	using.layer = HUD_LAYER
	src.adding += using

//Module select

	using = new /obj/screen()
	using.name = "module1"
	using.set_dir(SOUTHWEST)
	using.icon = ui_style
	using.color = ui_color
	using.alpha = ui_alpha
	using.icon_state = "inv1"
	using.screen_loc = ui_inv1
	using.layer = HUD_LAYER
	src.adding += using
	mymob:inv1 = using

	using = new /obj/screen()
	using.name = "module2"
	using.set_dir(SOUTHWEST)
	using.icon = ui_style
	using.color = ui_color
	using.alpha = ui_alpha
	using.icon_state = "inv2"
	using.screen_loc = ui_inv2
	using.layer = HUD_LAYER
	src.adding += using
	mymob:inv2 = using

	using = new /obj/screen()
	using.name = "module3"
	using.set_dir(SOUTHWEST)
	using.icon = ui_style
	using.color = ui_color
	using.alpha = ui_alpha
	using.icon_state = "inv3"
	using.screen_loc = ui_inv3
	using.layer = HUD_LAYER
	src.adding += using
	mymob:inv3 = using

//End of module select

//Intent
	using = new /obj/screen()
	using.name = "act_intent"
	using.set_dir(SOUTHWEST)
	using.icon = ui_style
	using.alpha = ui_alpha
	using.icon_state = mymob.a_intent
	using.screen_loc = ui_acti
	using.layer = HUD_LAYER
	src.adding += using
	action_intent = using

//Cell
	mymob:cells = new /obj/screen()
	mymob:cells.icon = ui_style
	mymob:cells.icon_state = "charge-empty"
	mymob:cells.alpha = ui_alpha
	mymob:cells.name = "cell"
	mymob:cells.screen_loc = ui_toxin
	src.other += mymob:cells

//Health
	mymob.healths = new /obj/screen()
	mymob.healths.icon = ui_style
	mymob.healths.icon_state = "health0"
	mymob.healths.alpha = ui_alpha
	mymob.healths.name = "health"
	mymob.healths.screen_loc = ui_borg_health
	src.other += mymob.healths

//Installed Module
	mymob.hands = new /obj/screen()
	mymob.hands.icon = ui_style
	mymob.hands.icon_state = "nomod"
	mymob.hands.alpha = ui_alpha
	mymob.hands.name = "module"
	mymob.hands.screen_loc = ui_borg_module
	src.other += mymob.hands

//Module Panel
	using = new /obj/screen()
	using.name = "panel"
	using.icon = ui_style
	using.icon_state = "panel"
	using.alpha = ui_alpha
	using.screen_loc = ui_borg_panel
	using.layer = HUD_LAYER-0.01
	src.adding += using

//Store
	mymob.throw_icon = new /obj/screen()
	mymob.throw_icon.icon = ui_style
	mymob.throw_icon.icon_state = "store"
	mymob.throw_icon.alpha = ui_alpha
	mymob.throw_icon.color = ui_color
	mymob.throw_icon.name = "store"
	mymob.throw_icon.screen_loc = ui_borg_store
	src.other += mymob.throw_icon

//Inventory
	robot_inventory = new /obj/screen()
	robot_inventory.name = "inventory"
	robot_inventory.icon = ui_style
	robot_inventory.icon_state = "inventory"
	robot_inventory.alpha = ui_alpha
	robot_inventory.color = ui_color
	robot_inventory.screen_loc = ui_borg_inventory
	src.other += robot_inventory

//Temp
	mymob.bodytemp = new /obj/screen()
	mymob.bodytemp.icon_state = "temp0"
	mymob.bodytemp.name = "body temperature"
	mymob.bodytemp.screen_loc = ui_temp

	mymob.oxygen = new /obj/screen()
	mymob.oxygen.icon = ui_style
	mymob.oxygen.icon_state = "oxy0"
	mymob.oxygen.alpha = ui_alpha
	mymob.oxygen.name = "oxygen"
	mymob.oxygen.screen_loc = ui_oxygen
	src.other += mymob.oxygen

	mymob.fire = new /obj/screen()
	mymob.fire.icon = ui_style
	mymob.fire.icon_state = "fire0"
	mymob.fire.alpha = ui_alpha
	mymob.fire.name = "fire"
	mymob.fire.screen_loc = ui_fire
	src.other += mymob.fire

	mymob.pullin = new /obj/screen()
	mymob.pullin.icon = ui_style
	mymob.pullin.icon_state = "pull0"
	mymob.pullin.alpha = ui_alpha
	mymob.pullin.color = ui_color
	mymob.pullin.name = "pull"
	mymob.pullin.screen_loc = ui_borg_pull
	src.other += mymob.pullin

	mymob.zone_sel = new /obj/screen/zone_sel()
	mymob.zone_sel.icon = ui_style
	mymob.zone_sel.alpha = ui_alpha
	mymob.zone_sel.overlays.Cut()
	mymob.zone_sel.overlays += image('icons/mob/zone_sel.dmi', "[mymob.zone_sel.selecting]")

	//Handle the gun settings buttons
	mymob.gun_setting_icon = new /obj/screen/gun/mode(null)
	mymob.gun_setting_icon.icon = ui_style
	mymob.gun_setting_icon.alpha = ui_alpha
	mymob.item_use_icon = new /obj/screen/gun/item(null)
	mymob.item_use_icon.icon = ui_style
	mymob.item_use_icon.alpha = ui_alpha
	mymob.gun_move_icon = new /obj/screen/gun/move(null)
	mymob.gun_move_icon.icon = ui_style
	mymob.gun_move_icon.alpha = ui_alpha
	mymob.radio_use_icon = new /obj/screen/gun/radio(null)
	mymob.radio_use_icon.icon = ui_style
	mymob.radio_use_icon.alpha = ui_alpha

	mymob.client.screen = list()

	mymob.client.screen += list( mymob.throw_icon, mymob.zone_sel, mymob.oxygen, mymob.fire, mymob.hands, mymob.healths, mymob:cells, mymob.pullin, robot_inventory, mymob.gun_setting_icon)
	mymob.client.screen += src.adding + src.other
	mymob.client.screen += mymob.client.void

	return


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