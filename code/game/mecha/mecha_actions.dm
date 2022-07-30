//AEIOU
//
//THIS FILE CONTAINS THE CODE TO ADD THE HUD BUTTONS AND THE MECH ACTIONS THEMSELVES.
//
//
// I better get some free food for this..



//
/// Adding the buttons things to the player. The interactive, top left things, at least at time of writing.
/// If you want it to be only for a special mech, you have to go and make an override like in the durand mech.
//

/obj/mecha/proc/GrantActions(mob/living/user, human_occupant = 0)
	if(human_occupant)
		eject_action.Grant(user, src)
	internals_action.Grant(user, src)
	cycle_action.Grant(user, src)
	lights_action.Grant(user, src)
	stats_action.Grant(user, src)
	strafing_action.Grant(user, src)//The defaults.

	if(defence_mode_possible)
		defence_action.Grant(user, src)
	if(overload_possible)
		overload_action.Grant(user, src)
	if(smoke_possible)
		smoke_action.Grant(user, src)
	if(zoom_possible)
		zoom_action.Grant(user, src)
	if(thrusters_possible)
		thrusters_action.Grant(user, src)
	if(phasing_possible)
		phasing_action.Grant(user, src)
	if(switch_dmg_type_possible)
		switch_damtype_action.Grant(user, src)
	if(cloak_possible)
		cloak_action.Grant(user, src)

/obj/mecha/proc/RemoveActions(mob/living/user, human_occupant = 0)
	if(human_occupant)
		eject_action.Remove(user, src)
	internals_action.Remove(user, src)
	cycle_action.Remove(user, src)
	lights_action.Remove(user, src)
	stats_action.Remove(user, src)
	strafing_action.Remove(user, src)

	defence_action.Remove(user, src)
	smoke_action.Remove(user, src)
	zoom_action.Remove(user, src)
	thrusters_action.Remove(user, src)
	phasing_action.Remove(user, src)
	switch_damtype_action.Remove(user, src)
	overload_action.Remove(user, src)
	cloak_action.Remove(user, src)


//
////BUTTONS STUFF
//

/datum/action/innate/mecha
	check_flags = AB_CHECK_RESTRAINED | AB_CHECK_STUNNED | AB_CHECK_ALIVE
	button_icon = 'icons/effects/actions_mecha.dmi'
	var/obj/mecha/chassis

/datum/action/innate/mecha/Grant(mob/living/L, obj/mecha/M)
	if(M)
		chassis = M
	..()


/datum/action/innate/mecha/mech_toggle_lights
	name = "Toggle Lights"
	button_icon_state = "mech_lights_off"

/datum/action/innate/mecha/mech_toggle_lights/Activate()
	button_icon_state = "mech_lights_[chassis.lights ? "off" : "on"]"
	button.UpdateIcon()
	chassis.lights()



/datum/action/innate/mecha/mech_toggle_internals
	name = "Toggle Internal Airtank Usage"
	button_icon_state = "mech_internals_off"

/datum/action/innate/mecha/mech_toggle_internals/Activate()
	button_icon_state = "mech_internals_[chassis.use_internal_tank ? "off" : "on"]"
	button.UpdateIcon()
	chassis.internal_tank()



/datum/action/innate/mecha/mech_view_stats
	name = "View stats"
	button_icon_state = "mech_view_stats"

/datum/action/innate/mecha/mech_view_stats/Activate()
	chassis.view_stats()



/datum/action/innate/mecha/mech_eject
	name = "Eject From Mech"
	button_icon_state = "mech_eject"

/datum/action/innate/mecha/mech_eject/Activate()
	chassis.go_out()



/datum/action/innate/mecha/strafe
	name = "Toggle Mech Strafing"
	button_icon_state = "mech_strafe_off"

/datum/action/innate/mecha/strafe/Activate()
	button_icon_state = "mech_strafe_[chassis.strafing ? "off" : "on"]"
	button.UpdateIcon()
	chassis.strafing()



/datum/action/innate/mecha/mech_defence_mode
	name = "Toggle Mech defence mode"
	button_icon_state = "mech_defense_mode_off"

/datum/action/innate/mecha/mech_defence_mode/Activate()
	button_icon_state = "mech_defense_mode_[chassis.defence_mode ? "off" : "on"]"
	button.UpdateIcon()
	chassis.defence_mode()



/datum/action/innate/mecha/mech_overload_mode
	name = "Toggle Mech Leg Overload"
	button_icon_state = "mech_overload_off"

/datum/action/innate/mecha/mech_overload_mode/Activate()
	button_icon_state = "mech_overload_[chassis.overload ? "off" : "on"]"
	button.UpdateIcon()
	chassis.overload()



/datum/action/innate/mecha/mech_smoke
	name = "Toggle Mech Smoke"
	button_icon_state = "mech_smoke_off"

/datum/action/innate/mecha/mech_smoke/Activate()
	//button_icon_state = "mech_smoke_[chassis.smoke ? "off" : "on"]"
	//button.UpdateIcon()	//Dual colors notneeded ATM
	chassis.smoke()



/datum/action/innate/mecha/mech_zoom
	name = "Toggle Mech Zoom"
	button_icon_state = "mech_zoom_off"

/datum/action/innate/mecha/mech_zoom/Activate()
	button_icon_state = "mech_zoom_[chassis.zoom ? "off" : "on"]"
	button.UpdateIcon()
	chassis.zoom()



/datum/action/innate/mecha/mech_toggle_thrusters
	name = "Toggle Mech thrusters"
	button_icon_state = "mech_thrusters_off"

/datum/action/innate/mecha/mech_toggle_thrusters/Activate()
	button_icon_state = "mech_thrusters_[chassis.thrusters ? "off" : "on"]"
	button.UpdateIcon()
	chassis.thrusters()



/datum/action/innate/mecha/mech_cycle_equip	//I'll be honest, i don't understand this part, buuuuuut it works!
	name = "Cycle Equipment"
	button_icon_state = "mech_cycle_equip_off"

/datum/action/innate/mecha/mech_cycle_equip/Activate()

	var/list/available_equipment = list()
	available_equipment = chassis.equipment

	if(chassis.weapons_only_cycle)
		available_equipment = chassis.weapon_equipment

	if(available_equipment.len == 0)
		chassis.occupant_message("No equipment available.")
		return
	if(!chassis.selected)
		chassis.selected = available_equipment[1]
		chassis.occupant_message("You select [chassis.selected]")
		send_byjax(chassis.occupant,"exosuit.browser","eq_list",chassis.get_equipment_list())
		button_icon_state = "mech_cycle_equip_on"
		button.UpdateIcon()
		return
	var/number = 0
	for(var/A in available_equipment)
		number++
		if(A == chassis.selected)
			if(available_equipment.len == number)
				chassis.selected = null
				chassis.occupant_message("You switch to no equipment")
				button_icon_state = "mech_cycle_equip_off"
			else
				chassis.selected = available_equipment[number+1]
				chassis.occupant_message("You switch to [chassis.selected]")
				button_icon_state = "mech_cycle_equip_on"
			send_byjax(chassis.occupant,"exosuit.browser","eq_list",chassis.get_equipment_list())
			button.UpdateIcon()
			return



/datum/action/innate/mecha/mech_switch_damtype
	name = "Reconfigure arm microtool arrays"
	button_icon_state = "mech_damtype_brute"


/datum/action/innate/mecha/mech_switch_damtype/Activate()


	button_icon_state = "mech_damtype_[chassis.damtype]"
	playsound(src, 'sound/mecha/mechmove01.ogg', 50, 1)
	button.UpdateIcon()
	chassis.query_damtype()



/datum/action/innate/mecha/mech_toggle_phasing
	name = "Toggle Mech phasing"
	button_icon_state = "mech_phasing_off"

/datum/action/innate/mecha/mech_toggle_phasing/Activate()
	button_icon_state = "mech_phasing_[chassis.phasing ? "off" : "on"]"
	button.UpdateIcon()
	chassis.phasing()



/datum/action/innate/mecha/mech_toggle_cloaking
	name = "Toggle Mech phasing"
	button_icon_state = "mech_phasing_off"

/datum/action/innate/mecha/mech_toggle_cloaking/Activate()
	button_icon_state = "mech_phasing_[chassis.cloaked ? "off" : "on"]"
	button.UpdateIcon()
	chassis.toggle_cloaking()



/////
/////
/////		ACTUAL MECANICS FOR THE ACTIONS
/////		OVERLOAD, DEFENCE, SMOKE
/////
/////


/obj/mecha/verb/toggle_defence_mode()
	set category = "Exosuit Interface"
	set name = "Toggle defence mode"
	set src = usr.loc
	set popup_menu = 0
	defence_mode()

/obj/mecha/proc/defence_mode()
	if(usr!=src.occupant)
		return
	playsound(src, 'sound/mecha/duranddefencemode.ogg', 50, 1)
	defence_mode = !defence_mode
	if(defence_mode)
		deflect_chance = defence_deflect
		src.occupant_message("<font color='blue'>You enable [src] defence mode.</font>")
	else
		deflect_chance = initial(deflect_chance)
		src.occupant_message("<font color='red'>You disable [src] defence mode.</font>")
	src.log_message("Toggled defence mode.")
	return



/obj/mecha/verb/toggle_overload()
	set category = "Exosuit Interface"
	set name = "Toggle leg actuators overload"
	set src = usr.loc
	set popup_menu = 0
	overload()

/obj/mecha/proc/overload()
	if(usr.stat == 1)//No manipulating things while unconcious.
		return
	if(usr!=src.occupant)
		return
	if(health < initial(health) - initial(health)/3)//Same formula as in movement, just beforehand.
		src.occupant_message("<font color='red'>Leg actuators damage critical, unable to engage overload.</font>")
		overload = 0	//Just to be sure
		return
	if(overload)
		overload = 0
		step_energy_drain = initial(step_energy_drain)
		src.occupant_message("<font color='blue'>You disable leg actuators overload.</font>")
	else
		overload = 1
		step_energy_drain = step_energy_drain*overload_coeff
		src.occupant_message("<font color='red'>You enable leg actuators overload.</font>")
	src.log_message("Toggled leg actuators overload.")
	playsound(src, 'sound/mecha/mechanical_toggle.ogg', 50, 1)
	return


/obj/mecha/verb/toggle_smoke()
	set category = "Exosuit Interface"
	set name = "Activate Smoke"
	set src = usr.loc
	set popup_menu = 0
	smoke()

/obj/mecha/proc/smoke()
	if(usr!=src.occupant)
		return

	if(smoke_reserve < 1)
		src.occupant_message("<font color='red'>You don't have any smoke left in stock!</font>")
		return

	if(smoke_ready)
		smoke_reserve--	//Remove ammo
		src.occupant_message("<font color='red'>Smoke fired. [smoke_reserve] usages left.</font>")

		var/datum/effect_system/smoke_spread/smoke = new /datum/effect_system/smoke_spread()
		smoke.attach(src)
		smoke.set_up(10, 0, usr.loc)
		smoke.start()
		playsound(src, 'sound/effects/smoke.ogg', 50, 1, -3)

		smoke_ready = 0
		spawn(smoke_cooldown)
			smoke_ready = 1
	return



/obj/mecha/verb/toggle_zoom()
	set category = "Exosuit Interface"
	set name = "Zoom"
	set src = usr.loc
	set popup_menu = 0
	zoom()

/obj/mecha/proc/zoom()//This could use improvements but maybe later.
	if(usr!=src.occupant)
		return
	if(src.occupant.client)
		src.zoom = !src.zoom
		src.log_message("Toggled zoom mode.")
		src.occupant_message("<font color='[src.zoom?"blue":"red"]'>Zoom mode [zoom?"en":"dis"]abled.</font>")
		if(zoom)
			src.occupant.set_viewsize(12)
			src.occupant << sound('sound/mecha/imag_enh.ogg',volume=50)
		else
			src.occupant.set_viewsize() // Reset to default
	return



/obj/mecha/verb/toggle_thrusters()
	set category = "Exosuit Interface"
	set name = "Toggle thrusters"
	set src = usr.loc
	set popup_menu = 0
	thrusters()

/obj/mecha/proc/thrusters()
	if(usr!=src.occupant)
		return
	if(src.occupant)
		if(get_charge() > 0)
			thrusters = !thrusters
			src.log_message("Toggled thrusters.")
			src.occupant_message("<font color='[src.thrusters?"blue":"red"]'>Thrusters [thrusters?"en":"dis"]abled.</font>")
	return



/obj/mecha/verb/switch_damtype()
	set category = "Exosuit Interface"
	set name = "Change melee damage type"
	set src = usr.loc
	set popup_menu = 0
	query_damtype()

/obj/mecha/proc/query_damtype()
	if(usr!=src.occupant)
		return
	var/new_damtype = tgui_alert(src.occupant,"Melee Damage Type","Damage Type",list("Brute","Fire","Toxic"))
	switch(new_damtype)
		if("Brute")
			damtype = "brute"
			src.occupant_message("Your exosuit's hands form into fists.")
		if("Fire")
			damtype = "fire"
			src.occupant_message("A torch tip extends from your exosuit's hand, glowing red.")
		if("Toxic")
			damtype = "tox"
			src.occupant_message("A bone-chillingly thick plasteel needle protracts from the exosuit's palm.")
	src.occupant_message("Melee damage type switched to [new_damtype]")
	return



/obj/mecha/verb/toggle_phasing()
	set category = "Exosuit Interface"
	set name = "Toggle phasing"
	set src = usr.loc
	set popup_menu = 0
	phasing()

/obj/mecha/proc/phasing()
	if(usr!=src.occupant)
		return
	phasing = !phasing
	send_byjax(src.occupant,"exosuit.browser","phasing_command","[phasing?"Dis":"En"]able phasing")
	src.occupant_message("<font color=\"[phasing?"#00f\">En":"#f00\">Dis"]abled phasing.</font>")
	return


/obj/mecha/verb/toggle_cloak()
	set category = "Exosuit Interface"
	set name = "Toggle cloaking"
	set src = usr.loc
	set popup_menu = 0
	toggle_cloaking()

/obj/mecha/proc/toggle_cloaking()
	if(usr!=src.occupant)
		return

	if(cloaked)
		uncloak()
	else
		cloak()

	src.occupant_message("<font color=\"[cloaked?"#00f\">En":"#f00\">Dis"]abled cloaking.</font>")
	return

/obj/mecha/verb/toggle_weapons_only_cycle()
	set category = "Exosuit Interface"
	set name = "Toggle weapons only cycling"
	set src = usr.loc
	set popup_menu = 0
	set_weapons_only_cycle()

/obj/mecha/proc/set_weapons_only_cycle()
	if(usr!=src.occupant)
		return
	weapons_only_cycle = !weapons_only_cycle
	src.occupant_message("<font color=\"[weapons_only_cycle?"#00f\">En":"#f00\">Dis"]abled weapons only cycling.</font>")
	return
