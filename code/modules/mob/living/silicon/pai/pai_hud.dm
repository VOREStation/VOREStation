/mob/living/silicon/pai
	var/obj/screen/pai/pai_fold_display = null

/obj/screen/pai
	icon = 'icons/mob/pai_hud.dmi'
	var/base_state

/obj/screen/pai/Click_vr(location, control, params)
	if(!usr)	return 1
	if(!ispAI(usr))		return 1
	var/mob/living/silicon/pai/p = usr
	switch(name)
		if("fold/unfold")
			if(p.loc == p.card)
				p.fold_out()
			else
				p.fold_up()
		if("choose chassis")
			p.choose_chassis()

		if("software interface")
			p.paiInterface()

		if("radio configuration")
			p.radio.tgui_interact(p)

		if("pda")
			p.pda.cmd_pda_open_ui()

		if("communicator")
			p.communicator.activate()

		if("known languages")
			p.check_languages()

		if("software toggle")
			p.refresh_software_status()
			if(p.hud_used.inventory_shown)
				p.hud_used.inventory_shown = 0
				p.client.screen -= p.hud_used.other
			else
				p.hud_used.inventory_shown = 1
				p.client.screen += p.hud_used.other

		if("directives")
			p.directives()

		if("crew manifest")
			p.crew_manifest()

		if("universal translator")
			p.translator()

		if("medical records")
			p.med_records()

		if("security records")
			p.sec_records()

		if("remote signaler")
			p.remote_signal()

		if("atmosphere sensor")
			p.atmos_sensor()

		if("door jack")
			p.door_jack()

		if("ar hud")
			p.ar_hud()

/obj/screen/pai/pai_fold_display
	name = "fold/unfold"
	icon = 'icons/mob/pai_hud.dmi'

/datum/hud
	var/list/hud_elements = list()

/mob/living/silicon/pai/create_mob_hud(datum/hud/HUD)
	..()

	var/ui_style = 'icons/mob/pai_hud.dmi'

	var/ui_color = "#ffffff"
	var/ui_alpha = 255

	var/list/adding = list()
	var/list/other = list()
	var/list/hotkeybuttons = list()
	var/list/hud_elements = list()

	HUD.adding = adding
	HUD.other = other
	HUD.hotkeybuttons = hotkeybuttons
	HUD.hud_elements = hud_elements

	var/obj/screen/pai/using

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

	//Pull button
	pullin = new /obj/screen()
	pullin.icon = ui_style
	pullin.icon_state = "pull0"
	pullin.name = "pull"
	pullin.screen_loc = ui_movi
	HUD.hotkeybuttons += pullin
	HUD.hud_elements |= pullin

	//Health status
	healths = new /obj/screen()
	healths.icon = ui_style
	healths.icon_state = "health0"
	healths.name = "health"
	healths.screen_loc = ui_health
	HUD.hud_elements |= healths

	pain = new /obj/screen( null )

	zone_sel = new /obj/screen/zone_sel( null )
	zone_sel.icon = ui_style
	zone_sel.color = ui_color
	zone_sel.alpha = ui_alpha
	zone_sel.cut_overlays()
	zone_sel.update_icon()
	HUD.hud_elements |= zone_sel

	pai_fold_display = new /obj/screen/pai/pai_fold_display()
	pai_fold_display.screen_loc = ui_health
	pai_fold_display.icon_state = "folded"
	HUD.hud_elements |= pai_fold_display

	//Choose chassis button
	using = new /obj/screen/pai()
	using.name = "choose chassis"
	using.icon_state = "choose_chassis"
	using.screen_loc = ui_movi
	using.color = ui_color
	using.alpha = ui_alpha
	hud_elements |= using

	//Software interface button
	using = new /obj/screen/pai()
	using.name = "software interface"
	using.icon_state = "software_interface"
	using.screen_loc = ui_acti
	using.color = ui_color
	using.alpha = ui_alpha
	hud_elements |= using

	//Radio configuration button
	using = new /obj/screen/pai()
	using.name = "radio configuration"
	using.icon_state = "radio_configuration"
	using.screen_loc = ui_acti
	using.color = ui_color
	using.alpha = ui_alpha
	hud_elements |= using

	//PDA button
	using = new /obj/screen/pai()
	using.name = "pda"
	using.icon_state = "pda"
	using.screen_loc = ui_pai_comms
	using.color = ui_color
	using.alpha = ui_alpha
	hud_elements |= using

	//Communicator button
	using = new /obj/screen/pai()
	using.name = "communicator"
	using.icon_state = "communicator"
	using.screen_loc = ui_pai_comms
	using.color = ui_color
	using.alpha = ui_alpha
	hud_elements |= using

	//Language button
	using = new /obj/screen/pai()
	using.name = "known languages"
	using.icon_state = "language"
	using.screen_loc = ui_acti
	using.color = ui_color
	using.alpha = ui_alpha
	hud_elements |= using

	using = new /obj/screen/pai()
	using.name = "software toggle"
	using.icon_state = "software"
	using.screen_loc = ui_inventory
	using.color = ui_color
	using.alpha = ui_alpha
	hud_elements |= using

	using = new /obj/screen/pai()
	using.name = "directives"
	using.icon_state = "directives"
	using.screen_loc = "WEST:6,SOUTH:18"
	using.color = ui_color
	using.alpha = ui_alpha
	other |= using

	using = new /obj/screen/pai()
	using.name = "crew manifest"
	using.icon_state = "manifest"
	using.screen_loc = "WEST:6,SOUTH+1:2"
	using.color = ui_color
	using.alpha = ui_alpha
	other |= using

	using = new /obj/screen/pai()
	using.name = "medical records"
	using.base_state = "med_records"
	using.screen_loc = "WEST:6,SOUTH+1:18"
	using.color = ui_color
	using.alpha = ui_alpha
	other |= using

	using = new /obj/screen/pai()
	using.name = "security records"
	using.base_state = "sec_records"
	using.screen_loc = "WEST:6,SOUTH+2:2"
	using.color = ui_color
	using.alpha = ui_alpha
	other |= using

	using = new /obj/screen/pai()
	using.name = "atmosphere sensor"
	using.base_state = "atmos_sensor"
	using.screen_loc = "WEST:6,SOUTH+2:18"
	using.color = ui_color
	using.alpha = ui_alpha
	other |= using

	using = new /obj/screen/pai()
	using.name = "remote signaler"
	using.base_state = "signaller"
	using.screen_loc = "WEST:6,SOUTH+3:2"
	using.color = ui_color
	using.alpha = ui_alpha
	other |= using

	using = new /obj/screen/pai()
	using.name = "universal translator"
	using.base_state = "translator"
	using.screen_loc = "WEST:6,SOUTH+3:18"
	using.color = ui_color
	using.alpha = ui_alpha
	other |= using

	using = new /obj/screen/pai()
	using.name = "door jack"
	using.base_state = "door_jack"
	using.screen_loc = "WEST:6,SOUTH+4:2"
	using.color = ui_color
	using.alpha = ui_alpha
	other |= using

	using = new /obj/screen/pai()
	using.name = "ar hud"
	using.base_state = "ar_hud"
	using.screen_loc = "WEST:6,SOUTH+4:18"
	using.color = ui_color
	using.alpha = ui_alpha
	other |= using

	if(client)
		client.screen = list()
		client.screen += hud_elements
		client.screen += adding + hotkeybuttons
		client.screen += client.void

	HUD.inventory_shown = 0


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
	if(!client)
		return FALSE

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
		if(hud_used.hud_elements)
			client.screen -= hud_used.hud_elements

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
		if(hud_used.hud_elements)
			client.screen |= hud_used.hud_elements

		hud_used?.action_intent.screen_loc = ui_acti //Restore intent selection to the original position
		client.screen += zone_sel				//This one is a special snowflake

	hud_used.hidden_inventory_update()
	hud_used.persistant_inventory_update()
	update_action_buttons()
	hud_used.reorganize_alerts()
	return TRUE
