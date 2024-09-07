/mob/living/carbon/human/create_mob_hud(datum/hud/HUD)
	..()

	var/datum/hud_data/hud_data
	if(species?.hud)
		hud_data = species.hud
	else
		hud_data = new ()

	if(hud_data.icon) // Species wants a specific dmi for the HUD
		HUD.ui_style = hud_data.icon

	var/adding = list()
	var/other = list()
	var/hotkeybuttons = list()
	var/slot_info = list()

	HUD.adding = adding
	HUD.other = other
	HUD.hotkeybuttons = hotkeybuttons //These can be disabled for hotkey users
	HUD.slot_info = slot_info

	var/list/hud_elements = list()
	var/obj/screen/using
	var/obj/screen/inventory/inv_box

	// Draw the various inventory equipment slots.
	var/has_hidden_gear
	for(var/gear_slot in hud_data.gear)

		inv_box = new /obj/screen/inventory()
		inv_box.icon = HUD.ui_style
		inv_box.color = HUD.ui_color
		inv_box.alpha = HUD.ui_alpha
		inv_box.hud = HUD

		var/list/slot_data =  hud_data.gear[gear_slot]
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
		using.icon = HUD.ui_style
		using.icon_state = "other"
		using.screen_loc = ui_inventory
		using.hud_layerise()
		using.color = HUD.ui_color
		using.alpha = HUD.ui_alpha
		adding += using

	// Draw the attack intent dialogue.
	if(hud_data.has_a_intent)

		using = new /obj/screen()
		using.name = "act_intent"
		using.icon = HUD.ui_style
		using.icon_state = "intent_"+a_intent
		using.screen_loc = ui_acti
		using.color = HUD.ui_color
		using.alpha = HUD.ui_alpha
		adding += using
		HUD.action_intent = using

		hud_elements |= using

		//intent small hud objects
		var/icon/ico

		ico = new(HUD.ui_style, "black")
		ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
		ico.DrawBox(rgb(255,255,255,1),1,ico.Height()/2,ico.Width()/2,ico.Height())
		using = new /obj/screen()
		using.name = I_HELP
		using.icon = ico
		using.screen_loc = ui_acti
		using.alpha = HUD.ui_alpha
		using.layer = LAYER_HUD_ITEM //These sit on the intent box
		adding += using
		HUD.help_intent = using

		ico = new(HUD.ui_style, "black")
		ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
		ico.DrawBox(rgb(255,255,255,1),ico.Width()/2,ico.Height()/2,ico.Width(),ico.Height())
		using = new /obj/screen()
		using.name = I_DISARM
		using.icon = ico
		using.screen_loc = ui_acti
		using.alpha = HUD.ui_alpha
		using.layer = LAYER_HUD_ITEM
		adding += using
		HUD.disarm_intent = using

		ico = new(HUD.ui_style, "black")
		ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
		ico.DrawBox(rgb(255,255,255,1),ico.Width()/2,1,ico.Width(),ico.Height()/2)
		using = new /obj/screen()
		using.name = I_GRAB
		using.icon = ico
		using.screen_loc = ui_acti
		using.alpha = HUD.ui_alpha
		using.layer = LAYER_HUD_ITEM
		adding += using
		HUD.grab_intent = using

		ico = new(HUD.ui_style, "black")
		ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
		ico.DrawBox(rgb(255,255,255,1),1,1,ico.Width()/2,ico.Height()/2)
		using = new /obj/screen()
		using.name = I_HURT
		using.icon = ico
		using.screen_loc = ui_acti
		using.alpha = HUD.ui_alpha
		using.layer = LAYER_HUD_ITEM
		adding += using
		HUD.hurt_intent = using
		//end intent small hud objects

	if(hud_data.has_m_intent)
		using = new /obj/screen()
		using.name = "mov_intent"
		using.icon = HUD.ui_style
		using.icon_state = (m_intent == "run" ? "running" : "walking")
		using.screen_loc = ui_movi
		using.color = HUD.ui_color
		using.alpha = HUD.ui_alpha
		adding += using
		HUD.move_intent = using

	if(hud_data.has_drop)
		using = new /obj/screen()
		using.name = "drop"
		using.icon = HUD.ui_style
		using.icon_state = "act_drop"
		using.screen_loc = ui_drop_throw
		using.color = HUD.ui_color
		using.alpha = HUD.ui_alpha
		hotkeybuttons += using

	if(hud_data.has_hands)

		using = new /obj/screen()
		using.name = "equip"
		using.icon = HUD.ui_style
		using.icon_state = "act_equip"
		using.screen_loc = ui_equip
		using.color = HUD.ui_color
		using.alpha = HUD.ui_alpha
		adding += using

		using = new /obj/screen/useself()
		using.icon = HUD.ui_style
		using.screen_loc = ui_swaphand2
		using.color = HUD.ui_color
		using.alpha = HUD.ui_alpha
		adding |= using

		inv_box = new /obj/screen/inventory/hand()
		inv_box.hud = HUD
		inv_box.name = "r_hand"
		inv_box.icon = HUD.ui_style
		inv_box.icon_state = "r_hand_inactive"
		if(!hand)	//This being 0 or null means the right hand is in use
			inv_box.icon_state = "r_hand_active"
		inv_box.screen_loc = ui_rhand
		inv_box.slot_id = slot_r_hand
		inv_box.color = HUD.ui_color
		inv_box.alpha = HUD.ui_alpha
		HUD.r_hand_hud_object = inv_box
		adding += inv_box
		slot_info["[slot_r_hand]"] = inv_box.screen_loc

		inv_box = new /obj/screen/inventory/hand()
		inv_box.hud = HUD
		inv_box.name = "l_hand"
		inv_box.icon = HUD.ui_style
		inv_box.icon_state = "l_hand_inactive"
		if(hand)	//This being 1 means the left hand is in use
			inv_box.icon_state = "l_hand_active"
		inv_box.screen_loc = ui_lhand
		inv_box.slot_id = slot_l_hand
		inv_box.color = HUD.ui_color
		inv_box.alpha = HUD.ui_alpha
		HUD.l_hand_hud_object = inv_box
		adding += inv_box
		slot_info["[slot_l_hand]"] = inv_box.screen_loc

		using = new /obj/screen/inventory()
		using.name = "hand"
		using.icon = HUD.ui_style
		using.icon_state = "hand1"
		using.screen_loc = ui_swaphand1
		using.color = HUD.ui_color
		using.alpha = HUD.ui_alpha
		using.hud = HUD
		adding += using

		using = new /obj/screen/inventory()
		using.name = "hand"
		using.icon = HUD.ui_style
		using.icon_state = "hand2"
		using.screen_loc = ui_swaphand2
		using.color = HUD.ui_color
		using.alpha = HUD.ui_alpha
		using.hud = HUD
		adding += using

	if(hud_data.has_resist)
		using = new /obj/screen()
		using.name = "resist"
		using.icon = HUD.ui_style
		using.icon_state = "act_resist"
		using.screen_loc = ui_pull_resist
		using.color = HUD.ui_color
		using.alpha = HUD.ui_alpha
		hotkeybuttons += using

	if(hud_data.has_throw)
		throw_icon = new /obj/screen()
		throw_icon.icon = HUD.ui_style
		throw_icon.icon_state = "act_throw_off"
		throw_icon.name = "throw"
		throw_icon.screen_loc = ui_drop_throw
		throw_icon.color = HUD.ui_color
		throw_icon.alpha = HUD.ui_alpha
		hotkeybuttons += throw_icon
		hud_elements |= throw_icon

		pullin = new /obj/screen()
		pullin.icon = HUD.ui_style
		pullin.icon_state = "pull0"
		pullin.name = "pull"
		pullin.screen_loc = ui_pull_resist
		hotkeybuttons += pullin
		hud_elements |= pullin

	if(hud_data.has_internals)
		internals = new /obj/screen()
		internals.icon = HUD.ui_style
		internals.icon_state = "internal0"
		if(istype(internal, /obj/item/weapon/tank)) //Internals on already? Iight, prove it
			internals.icon_state = "internal1"
		internals.name = "internal"
		internals.screen_loc = ui_internal
		hud_elements |= internals

	if(hud_data.has_warnings)
		healths = new /obj/screen()
		healths.icon = HUD.ui_style
		healths.icon_state = "health0"
		healths.name = "health"
		healths.screen_loc = ui_health
		hud_elements |= healths

	autowhisper_display = new /obj/screen()
	autowhisper_display.icon = 'icons/mob/screen/minimalist.dmi'
	autowhisper_display.icon_state = "autowhisper"
	autowhisper_display.name = "autowhisper"
	autowhisper_display.screen_loc = ui_under_health
	hud_elements |= autowhisper_display
	adding |= autowhisper_display

	var/obj/screen/aw = new /obj/screen()
	aw.icon = 'icons/mob/screen/minimalist.dmi'
	aw.icon_state = "aw-select"
	aw.name = "autowhisper mode"
	aw.screen_loc = ui_under_health
	hud_elements |= aw
	adding |= aw

	aw = new /obj/screen()
	aw.icon = 'icons/mob/screen/minimalist.dmi'
	aw.icon_state = "lang"
	aw.name = "check known languages"
	aw.screen_loc = ui_under_health
	hud_elements |= aw
	adding |= aw

	aw = new /obj/screen()
	aw.icon = 'icons/mob/screen/minimalist.dmi'
	aw.icon_state = "pose"
	aw.name = "set pose"
	aw.screen_loc = ui_under_health
	hud_elements |= aw
	adding |= aw

	aw = new /obj/screen()
	aw.icon = 'icons/mob/screen/minimalist.dmi'
	aw.icon_state = "up"
	aw.name = "move upwards"
	aw.screen_loc = ui_under_health
	hud_elements |= aw
	adding |= aw

	aw = new /obj/screen()
	aw.icon = 'icons/mob/screen/minimalist.dmi'
	aw.icon_state = "down"
	aw.name = "move downwards"
	aw.screen_loc = ui_under_health
	hud_elements |= aw
	adding |= aw

	aw = new /obj/screen()
	aw.icon = HUD.ui_style
	aw.icon_state = "use"
	aw.name = "use held item on self"
	aw.screen_loc = ui_swaphand2
	using.color = HUD.ui_color
	using.alpha = HUD.ui_alpha
	adding |= using

	//VOREStation Addition begin
	shadekin_display = new /obj/screen/shadekin()
	shadekin_display.screen_loc = ui_shadekin_display
	shadekin_display.icon_state = "shadekin"
	hud_elements |= shadekin_display

	xenochimera_danger_display = new /obj/screen/xenochimera/danger_level()
	xenochimera_danger_display.screen_loc = ui_xenochimera_danger_display
	xenochimera_danger_display.icon_state = "danger00"
	hud_elements |= xenochimera_danger_display

	lleill_display = new /obj/screen/lleill()
	lleill_display.screen_loc = ui_lleill_display
	lleill_display.icon_state = "lleill"
	hud_elements |= lleill_display
	//VOREStation Addition end

	ling_chem_display = new /obj/screen/ling/chems()
	ling_chem_display.screen_loc = ui_ling_chemical_display
	ling_chem_display.icon_state = "ling_chems"
	hud_elements |= ling_chem_display

	wiz_instability_display = new /obj/screen/wizard/instability()
	wiz_instability_display.screen_loc = ui_wiz_instability_display
	wiz_instability_display.icon_state = "wiz_instability_none"
	hud_elements |= wiz_instability_display

	wiz_energy_display = new/obj/screen/wizard/energy()
	wiz_energy_display.screen_loc = ui_wiz_energy_display
	wiz_energy_display.icon_state = "wiz_energy"
	hud_elements |= wiz_energy_display


	pain = new /obj/screen( null )

	zone_sel = new /obj/screen/zone_sel( null )
	zone_sel.icon = HUD.ui_style
	zone_sel.color = HUD.ui_color
	zone_sel.alpha = HUD.ui_alpha
	zone_sel.cut_overlays()
	zone_sel.update_icon()
	hud_elements |= zone_sel

	//Handle the gun settings buttons
	gun_setting_icon = new /obj/screen/gun/mode(null)
	gun_setting_icon.icon = HUD.ui_style
	gun_setting_icon.color = HUD.ui_color
	gun_setting_icon.alpha = HUD.ui_alpha
	hud_elements |= gun_setting_icon

	item_use_icon = new /obj/screen/gun/item(null)
	item_use_icon.icon = HUD.ui_style
	item_use_icon.color = HUD.ui_color
	item_use_icon.alpha = HUD.ui_alpha

	gun_move_icon = new /obj/screen/gun/move(null)
	gun_move_icon.icon = HUD.ui_style
	gun_move_icon.color = HUD.ui_color
	gun_move_icon.alpha = HUD.ui_alpha

	radio_use_icon = new /obj/screen/gun/radio(null)
	radio_use_icon.icon = HUD.ui_style
	radio_use_icon.color = HUD.ui_color
	radio_use_icon.alpha = HUD.ui_alpha

	if(client)
		client.screen = list()

		client.screen += hud_elements
		client.screen += adding + hotkeybuttons
		client.screen += client.void

	HUD.inventory_shown = 0

/mob/living/carbon/human/verb/toggle_hotkey_verbs()
	set category = "OOC"
	set name = "Toggle hotkey buttons"
	set desc = "This disables or enables the user interface buttons which can be used with hotkeys."

	if(hud_used.hotkey_ui_hidden)
		client.screen += hud_used.hotkeybuttons
		hud_used.hotkey_ui_hidden = 0
	else
		client.screen -= hud_used.hotkeybuttons
		hud_used.hotkey_ui_hidden = 1

//Used for new human mobs created by cloning/goleming/etc.
/mob/living/carbon/human/proc/set_cloned_appearance()
	f_style = "Shaved"
	if(dna.species == "Human") //no more xenos losing ears/tentacles
		h_style = pick("Bedhead", "Bedhead 2", "Bedhead 3")
	all_underwear.Cut()
	regenerate_icons()

/obj/screen/ling
	invisibility = 101

/obj/screen/ling/chems
	name = "chemical storage"
	icon_state = "power_display"

/obj/screen/wizard
	invisibility = 101

/obj/screen/wizard/instability
	name = "instability"
	icon_state = "instability-1"
	invisibility = 0

/obj/screen/wizard/energy
	name = "energy"
	icon_state = "wiz_energy"

/obj/screen/useself
	name = "use held item on self"
	icon_state = "use"
	var/next = 0

/obj/screen/useself/proc/can_use(var/mob/living/carbon/human/h, var/obj/item/i)	//Basically trying to use the item this way skips the cooldown
	if(world.time >= next)														//And trying to check the cooldown doesn't work because when you click the UI it sets a cooldown
		next = h.get_attack_speed(i)											//So instead we'll just put a cooldown on the use button and apply the item's cooldown to the player
		h.setClickCooldown(next)												//Otherwise you can click the button and yourself faster than the normal cooldown. SO WE SET BOTH!!!!
		next += world.time
		i.attack(h, h)
