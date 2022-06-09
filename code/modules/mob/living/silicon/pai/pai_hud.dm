/mob/living/silicon/pai
	var/obj/screen/pai/pai_fold_display = null
	var/list/hud_elements = list()

/obj/screen/pai/pai_fold_display
	name = "fold/unfold"
	icon = 'icons/mob/pai_hud.dmi'
/*
/obj/screen/ability/pai/pai_fold_display/Click()
	log_and_message_admins("I was clicked!")
	. = ..()
	if(name == "fold up" || name == "unfold")
		if(!(hud && ispAI(usr)))
			return
		else
			var/mob/living/silicon/pai/o = usr
			if(name == "unfold")
				o.fold_out()
				name = "fold up"
			else
				o.fold_up()
				name = "unfold"
*/
/mob/living/silicon/pai/create_mob_hud(datum/hud/HUD)
	..()

	var/ui_style = 'icons/mob/screen1_animal.dmi'

	var/ui_color = "#ffffff"
	var/ui_alpha = 255

	var/list/adding = list()
	var/list/other = list()
	var/list/hotkeybuttons = list()

	HUD.adding = adding
	HUD.other = other
	HUD.hotkeybuttons = hotkeybuttons

	var/obj/screen/using

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
	healths.icon = 'icons/mob/pai_hud.dmi'
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
	pai_fold_display.name = "unfold"
	pai_fold_display.screen_loc = ui_health
	pai_fold_display.icon_state = "folded"
	hud_elements |= pai_fold_display


	if(client)
		client.screen = list()
		client.screen += hud_elements
		client.screen += adding + hotkeybuttons
		client.screen += client.void


/*
/mob/living/silicon/pai/Login()
	. = ..()
	create_mob_hud(datum/hud/HUD)


/mob/living/silicon/pai/create_mob_hud(datum/hud/HUD)
	..()

	var/ui_style = 'icons/mob/pai_hud.dmi'
	if(ui_icons)
		ui_style = 'icons/mob/pai_hud.dmi'

	var/ui_color = "#ffffff"
	var/ui_alpha = 255


	healths = new /obj/screen()
	healths.icon = 'icons/mob/pai_hud.dmi'
	healths.icon_state = "health0"
	healths.name = "health"
	healths.screen_loc = ui_health
	hud_elements |= healths

	pai_fold_display = new /obj/screen/pai/pai_fold_display()
	pai_fold_display.screen_loc = ui_health
	pai_fold_display.icon_state = "folded"
	hud_elements |= pai_fold_display

	using = new /obj/screen()
	using.name = "mov_intent"
	using.icon = ui_style
	using.icon_state = (m_intent == "run" ? "running" : "walking")
	using.screen_loc = ui_movi
	using.color = ui_color
	using.alpha = ui_alpha
	HUD.adding += using
	HUD.move_intent = using

/obj/screen/movable/ability_master/shadekin
	name = "Shadekin Abilities"
	icon = 'icons/mob/screen_spells.dmi'
	icon_state = "grey_spell_ready"
	ability_objects = list()
	showing = 0

	open_state = "master_open"
	closed_state = "master_closed"

	screen_loc = ui_spell_master

/obj/screen/movable/ability_master/shadekin/update_abilities(forced = 0, mob/user)		//Different proc to prevent indexing
	update_icon()
	if(user && user.client)
		if(!(src in user.client.screen))
			user.client.screen += src
	for(var/obj/screen/ability/ability in ability_objects)
		ability.update_icon(forced)

/obj/screen/ability/verb_based/shadekin
	icon_state = "grey_spell_base"
	background_base_state = "grey"

/obj/screen/movable/ability_master/proc/add_shadekin_ability(var/object_given, var/verb_given, var/name_given, var/ability_icon_given, var/arguments)
	if(!object_given)
		message_admins("ERROR: add_shadekin_ability() was not given an object in its arguments.")
	if(!verb_given)
		message_admins("ERROR: add_shadekin_ability() was not given a verb/proc in its arguments.")
	if(get_ability_by_proc_ref(verb_given))
		return // Duplicate
	var/obj/screen/ability/verb_based/shadekin/A = new /obj/screen/ability/verb_based/shadekin()
	A.ability_master = src
	A.object_used = object_given
	A.verb_to_call = verb_given
	A.ability_icon_state = ability_icon_given
	A.name = name_given
	if(arguments)
		A.arguments_to_use = arguments
	ability_objects.Add(A)
	if(my_mob.client)
		toggle_open(2) //forces the icons to refresh on screen
*/


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
