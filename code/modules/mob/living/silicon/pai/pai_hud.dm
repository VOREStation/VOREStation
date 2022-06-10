/mob/living/silicon/pai
	var/obj/screen/pai/pai_fold_display = null
	var/list/hud_elements = list()

/obj/screen/pai/pai_fold_display
	name = "fold/unfold"
	icon = 'icons/mob/pai_hud.dmi'

/mob/living/silicon/pai/create_mob_hud(datum/hud/HUD)
	..()

	var/ui_style = 'icons/mob/pai_hud.dmi'

	var/ui_color = "#ffffff"
	var/ui_alpha = 255

	var/list/adding = list()
	var/list/other = list()
	var/list/hotkeybuttons = list()

	HUD.adding = adding
	HUD.other = other
	HUD.hotkeybuttons = hotkeybuttons

	var/obj/screen/using

	//Small intent quarters

	using = new /obj/screen()
	using.name = I_HELP
	using.icon = ui_style
	using.icon_state = "intent_help-s"
	using.screen_loc = ui_acti
	using.alpha = ui_alpha
	using.layer = LAYER_HUD_ITEM //These sit on the intent box
	HUD.adding += using
	HUD.help_intent = using

	using = new /obj/screen()
	using.name = I_DISARM
	using.icon = ui_style
	using.icon_state = "intent_disarm-n"
	using.screen_loc = ui_acti
	using.alpha = ui_alpha
	using.layer = LAYER_HUD_ITEM
	HUD.adding += using
	HUD.disarm_intent = using

	using = new /obj/screen()
	using.name = I_GRAB
	using.icon = ui_style
	using.icon_state = "intent_grab-n"
	using.screen_loc = ui_acti
	using.alpha = ui_alpha
	using.layer = LAYER_HUD_ITEM
	HUD.adding += using
	HUD.grab_intent = using

	using = new /obj/screen()
	using.name = I_HURT
	using.icon = ui_style
	using.icon_state = "intent_harm-n"
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
	using.screen_loc = ui_movi
	using.color = ui_color
	using.alpha = ui_alpha
	HUD.hotkeybuttons += using

	//Choose chassis button
	using = new /obj/screen()
	using.name = "choose chassis"
	using.icon = ui_style
	using.icon_state = "choose_chassis"
	using.screen_loc = ui_movi
	using.color = ui_color
	using.alpha = ui_alpha
	hud_elements |= using

	//Software interface button
	using = new /obj/screen()
	using.name = "software interface"
	using.icon = ui_style
	using.icon_state = "software_interface"
	using.screen_loc = ui_acti
	using.color = ui_color
	using.alpha = ui_alpha
	hud_elements |= using

	//Radio configuration button
	using = new /obj/screen()
	using.name = "radio configuration"
	using.icon = ui_style
	using.icon_state = "radio_configuration"
	using.screen_loc = ui_acti
	using.color = ui_color
	using.alpha = ui_alpha
	hud_elements |= using

	//Pull button
	pullin = new /obj/screen()
	pullin.icon = ui_style
	pullin.icon_state = "pull0"
	pullin.name = "pull"
	pullin.screen_loc = ui_movi
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

	pai_fold_display = new /obj/screen/pai/pai_fold_display()
	pai_fold_display.screen_loc = ui_health
	pai_fold_display.icon_state = "folded"
	hud_elements |= pai_fold_display


	if(client)
		client.screen = list()
		client.screen += hud_elements
		client.screen += adding + hotkeybuttons
		client.screen += client.void

/mob/living/silicon/pai/handle_regular_hud_updates()
	. = ..()
	if(healths)
		if(stat != DEAD)
			var/heal_per = (health / getMaxHealth()) * 100
			switch(heal_per)
				if(100 to INFINITY)
					healths.icon_state = "health0"
				if(80 to 100)
					healths.icon_state = "health1"
				if(60 to 80)
					healths.icon_state = "health2"
				if(40 to 60)
					healths.icon_state = "health3"
				if(20 to 40)
					healths.icon_state = "health4"
				if(0 to 20)
					healths.icon_state = "health5"
				else
					healths.icon_state = "health6"
		else
			healths.icon_state = "health7"

	if(pai_fold_display)
		if(loc == card)
			pai_fold_display.icon_state = "folded"
		else
			pai_fold_display.icon_state = "unfolded"

/mob/living/silicon/pai/toggle_hud_vis(full)
	
	hud_used.hud_shown = 1
	

	if(hud_used.hud_shown)
		hud_used.hud_shown = 0
		if(hud_used.adding)
			client.screen -= hud_used.adding
		if(hud_used.other)
			client.screen -= hud_used.other
		if(hud_used.hotkeybuttons)
			client.screen -= hud_used.hotkeybuttons
		if(hud_used.other_important)
			client.screen -= hud_used.other_important
		if(hud_elements)
			client.screen -= hud_elements

	else
		hud_used.hud_shown = 1
		if(hud_used.adding)
			client.screen += hud_used.adding
		if(hud_used.other && hud_used.inventory_shown)
			client.screen += hud_used.other
		if(hud_used.other_important)
			client.screen += hud_used.other_important
		if(hud_used.hotkeybuttons && !hud_used.hotkey_ui_hidden)
			client.screen += hud_used.hotkeybuttons
		if(healths)
			client.screen |= healths
		if(internals)
			client.screen |= internals
		if(gun_setting_icon)
			client.screen |= gun_setting_icon
		if(hud_elements)
			client.screen |= hud_elements

		hud_used?.action_intent.screen_loc = ui_acti //Restore intent selection to the original position
		client.screen += zone_sel				//This one is a special snowflake

	hud_used.hidden_inventory_update()
	hud_used.persistant_inventory_update()
	update_action_buttons()
	hud_used.reorganize_alerts()
	return TRUE
