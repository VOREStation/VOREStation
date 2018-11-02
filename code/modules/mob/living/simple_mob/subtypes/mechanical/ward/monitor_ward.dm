/*
	'Monitor' wards are drones that yell at their creator if they see someone besides them that they are hostile to.
	They can also force an invisible entity to uncloak if the invisible mob is hostile to the ward.
	If AI controlled, they will also warn their faction if they see a hostile entity, acting as floating cameras.
*/

/mob/living/simple_mob/mechanical/ward/monitor
	desc = "It's a little flying drone. This one seems to be watching you..."
	icon_state = "ward"
	glow_color = "#00FF00"
	see_invisible = SEE_INVISIBLE_LEVEL_TWO

	has_eye_glow = TRUE
	glow_range = 3
	glow_intensity = 3
	glow_toggle = TRUE

	player_msg = "You will automatically alert your owner (if one exists) of enemies you see nearby.<br>\
	You can also <b>see invisible entities, and will automatically uncloak</b> nearby invisible or hidden enemies."

	ai_holder_type = /datum/ai_holder/simple_mob/monitor

	var/list/seen_mobs = list()
	var/view_range = 5

// For PoIs.
/mob/living/simple_mob/mechanical/ward/monitor/syndicate
	faction = "syndicate"

/mob/living/simple_mob/mechanical/ward/monitor/crew
	faction = "neutral"

/mob/living/simple_mob/mechanical/ward/monitor/death()
	if(owner)
		to_chat(owner, span("warning", "Your [src.name] inside [get_area(src)] was destroyed!"))
	..()

/mob/living/simple_mob/mechanical/ward/monitor/handle_special()
	detect_mobs()

/mob/living/simple_mob/mechanical/ward/monitor/update_icon()
	if(seen_mobs.len)
		icon_living = "ward_spotted"
		glow_color = "#FF0000"
	else
		icon_living = "ward"
		glow_color = "#00FF00"
	handle_light() // Update the light immediately.
	..()

/mob/living/simple_mob/mechanical/ward/monitor/proc/detect_mobs()
	var/last_seen_mobs_len = seen_mobs.len
	var/list/things_in_sight = view(view_range, src)
	var/list/newly_seen_mobs = list()
	for(var/mob/living/L in things_in_sight)
		if(L == src) // Don't detect ourselves.
			continue

		if(L.stat) // Dead mobs aren't concerning.
			continue

		if(owner)
			if(L == owner) // Don't yell at our owner for seeing them.
				continue

			if(L.IIsAlly(owner)) // Don't yell if they're friendly to our owner.
				continue

		else
			if(src.IIsAlly(L))
				continue

		// Decloak them .
		if(L.is_cloaked())
			Beam(L, icon_state = "solar_beam", time = 5)
			playsound(L, 'sound/effects/EMPulse.ogg', 75, 1)
			L.break_cloak()

			to_chat(L, span("danger", "\The [src] disrupts your cloak!"))
			if(owner)
				to_chat(owner, span("notice", "Your [src.name] at [get_area(src)] uncloaked \the [L]."))

		// Warn the owner when it sees a new mob.
		if(!(L in seen_mobs))
			seen_mobs += L
			newly_seen_mobs += L
			if(owner)
				to_chat(owner, span("notice", "Your [src.name] at [get_area(src)] detected [english_list(newly_seen_mobs)]."))

	// Now get rid of old mobs that left vision.
	for(var/thing in seen_mobs)
		if(!(thing in things_in_sight))
			seen_mobs -= thing

	// Check if we need to update icon.
	if(seen_mobs.len != last_seen_mobs_len)
		update_icon()
	last_seen_mobs_len = seen_mobs.len
