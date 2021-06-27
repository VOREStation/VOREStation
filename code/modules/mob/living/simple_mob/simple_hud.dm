/mob/living/simple_mob/create_mob_hud(datum/hud/HUD)
	..()

	var/ui_style = 'icons/mob/screen1_animal.dmi'
	if(ui_icons)
		ui_style = ui_icons

	var/ui_color = "#ffffff"
	var/ui_alpha = 255

	var/list/adding = list()
	var/list/other = list()
	var/list/hotkeybuttons = list()
	var/list/slot_info = list()

	HUD.adding = adding
	HUD.other = other
	HUD.hotkeybuttons = hotkeybuttons

	var/list/hud_elements = list()
	var/obj/screen/using
	var/obj/screen/inventory/inv_box

	var/has_hidden_gear
	if(LAZYLEN(hud_gears))
		for(var/gear_slot in hud_gears)
			inv_box = new /obj/screen/inventory()
			inv_box.icon = ui_style
			inv_box.color = ui_color
			inv_box.alpha = ui_alpha

			var/list/slot_data =  hud_gears[gear_slot]
			inv_box.name =        gear_slot
			inv_box.screen_loc =  slot_data["loc"]
			inv_box.slot_id =     slot_data["slot"]
			inv_box.icon_state =  slot_data["state"]
			slot_info["[inv_box.slot_id]"] = inv_box.screen_loc

			if(slot_data["dir"])
				inv_box.set_dir(slot_data["dir"])

			if(slot_data["toggle"])
				other += inv_box
				has_hidden_gear = 1
			else
				adding += inv_box

	if(has_hidden_gear)
		using = new /obj/screen()
		using.name = "toggle"
		using.icon = ui_style
		using.icon_state = "other"
		using.screen_loc = ui_inventory
		using.hud_layerise()
		using.color = ui_color
		using.alpha = ui_alpha
		adding += using

	//Intent Backdrop
	using = new /obj/screen()
	using.name = "act_intent"
	using.icon = ui_style
	using.icon_state = "intent_"+a_intent
	using.screen_loc = ui_acti
	using.color = ui_color
	using.alpha = ui_alpha
	HUD.adding += using
	HUD.action_intent = using

	hud_elements |= using

	//Small intent quarters
	var/icon/ico

	ico = new(ui_style, "black")
	ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
	ico.DrawBox(rgb(255,255,255,1),1,ico.Height()/2,ico.Width()/2,ico.Height())
	using = new /obj/screen()
	using.name = I_HELP
	using.icon = ico
	using.screen_loc = ui_acti
	using.alpha = ui_alpha
	using.layer = LAYER_HUD_ITEM //These sit on the intent box
	HUD.adding += using
	HUD.help_intent = using

	ico = new(ui_style, "black")
	ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
	ico.DrawBox(rgb(255,255,255,1),ico.Width()/2,ico.Height()/2,ico.Width(),ico.Height())
	using = new /obj/screen()
	using.name = I_DISARM
	using.icon = ico
	using.screen_loc = ui_acti
	using.alpha = ui_alpha
	using.layer = LAYER_HUD_ITEM
	HUD.adding += using
	HUD.disarm_intent = using

	ico = new(ui_style, "black")
	ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
	ico.DrawBox(rgb(255,255,255,1),ico.Width()/2,1,ico.Width(),ico.Height()/2)
	using = new /obj/screen()
	using.name = I_GRAB
	using.icon = ico
	using.screen_loc = ui_acti
	using.alpha = ui_alpha
	using.layer = LAYER_HUD_ITEM
	HUD.adding += using
	HUD.grab_intent = using

	ico = new(ui_style, "black")
	ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
	ico.DrawBox(rgb(255,255,255,1),1,1,ico.Width()/2,ico.Height()/2)
	using = new /obj/screen()
	using.name = I_HURT
	using.icon = ico
	using.screen_loc = ui_acti
	using.alpha = ui_alpha
	using.layer = LAYER_HUD_ITEM
	HUD.adding += using
	HUD.hurt_intent = using

	//Move intent (walk/run)
	using = new /obj/screen()
	using.name = "mov_intent"
	using.icon = ui_style
	using.icon_state = (m_intent == "run" ? "running" : "walking")
	using.screen_loc = ui_movi
	using.color = ui_color
	using.alpha = ui_alpha
	HUD.adding += using
	HUD.move_intent = using

	//Resist button
	using = new /obj/screen()
	using.name = "resist"
	using.icon = ui_style
	using.icon_state = "act_resist"
	using.screen_loc = ui_pull_resist
	using.color = ui_color
	using.alpha = ui_alpha
	HUD.hotkeybuttons += using

	//Pull button
	pullin = new /obj/screen()
	pullin.icon = ui_style
	pullin.icon_state = "pull0"
	pullin.name = "pull"
	pullin.screen_loc = ui_pull_resist
	HUD.hotkeybuttons += pullin
	hud_elements |= pullin

	//Health status
	healths = new /obj/screen()
	healths.icon = ui_style
	healths.icon_state = "health0"
	healths.name = "health"
	healths.screen_loc = ui_health
	hud_elements |= healths



	pain = new /obj/screen( null )

	zone_sel = new /obj/screen/zone_sel( null )
	zone_sel.icon = ui_style
	zone_sel.color = ui_color
	zone_sel.alpha = ui_alpha
	zone_sel.cut_overlays()
	zone_sel.update_icon()
	hud_elements |= zone_sel

	//Hand things
	if(has_hands)
		//Drop button
		using = new /obj/screen()
		using.name = "drop"
		using.icon = ui_style
		using.icon_state = "act_drop"
		using.screen_loc = ui_drop_throw
		using.color = ui_color
		using.alpha = ui_alpha
		HUD.hotkeybuttons += using

		//Equip detail
		using = new /obj/screen()
		using.name = "equip"
		using.icon = ui_style
		using.icon_state = "act_equip"
		using.screen_loc = ui_equip
		using.color = ui_color
		using.alpha = ui_alpha
		HUD.adding += using

		//Hand slots themselves
		inv_box = new /obj/screen/inventory/hand()
		inv_box.hud = src
		inv_box.name = "r_hand"
		inv_box.icon = ui_style
		inv_box.icon_state = "r_hand_inactive"
		if(!hand)	//This being 0 or null means the right hand is in use
			inv_box.icon_state = "r_hand_active"
		inv_box.screen_loc = ui_rhand
		inv_box.slot_id = slot_r_hand
		inv_box.color = ui_color
		inv_box.alpha = ui_alpha
		HUD.r_hand_hud_object = inv_box
		HUD.adding += inv_box
		slot_info["[slot_r_hand]"] = inv_box.screen_loc

		inv_box = new /obj/screen/inventory/hand()
		inv_box.hud = src
		inv_box.name = "l_hand"
		inv_box.icon = ui_style
		inv_box.icon_state = "l_hand_inactive"
		if(hand)	//This being 1 means the left hand is in use
			inv_box.icon_state = "l_hand_active"
		inv_box.screen_loc = ui_lhand
		inv_box.slot_id = slot_l_hand
		inv_box.color = ui_color
		inv_box.alpha = ui_alpha
		HUD.l_hand_hud_object = inv_box
		HUD.adding += inv_box
		slot_info["[slot_l_hand]"] = inv_box.screen_loc

		//Swaphand titlebar
		using = new /obj/screen/inventory()
		using.name = "hand"
		using.icon = ui_style
		using.icon_state = "hand1"
		using.screen_loc = ui_swaphand1
		using.color = ui_color
		using.alpha = ui_alpha
		HUD.adding += using

		using = new /obj/screen/inventory()
		using.name = "hand"
		using.icon = ui_style
		using.icon_state = "hand2"
		using.screen_loc = ui_swaphand2
		using.color = ui_color
		using.alpha = ui_alpha
		HUD.adding += using

		//Throw button
		throw_icon = new /obj/screen()
		throw_icon.icon = ui_style
		throw_icon.icon_state = "act_throw_off"
		throw_icon.name = "throw"
		throw_icon.screen_loc = ui_drop_throw
		throw_icon.color = ui_color
		throw_icon.alpha = ui_alpha
		HUD.hotkeybuttons += throw_icon
		hud_elements |= throw_icon

	extra_huds(HUD, HUD.ui_style, hud_elements)

	if(client)
		client.screen = list()
		client.screen += hud_elements
		client.screen += adding + hotkeybuttons
		client.screen += client.void
