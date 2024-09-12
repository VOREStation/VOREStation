/*
	'Monitor' wards are drones that yell at their creator if they see someone besides them that they are hostile to.
	They can also force an invisible entity to uncloak if the invisible mob is hostile to the ward.
	If AI controlled, they will also warn their faction if they see a hostile entity, acting as floating cameras.
*/

/datum/category_item/catalogue/technology/drone/ward
	name = "Drone - Monitor Ward"
	desc = "This is a small drone that appears to have been designed for a singular purpose, \
	with little autonomous capability, common among the 'ward' models. This specific ward's \
	purpose is simply to observe the environment around it, reacting when it detects entities \
	it judges to be unfriendly. It presumably relays information about what it sees back to \
	whoever owns the drone.\
	<br><br>\
	The sensors onboard the ward are much more advanced than what is typical for drones, \
	allowing it to detect entities that might otherwise go unnoticed by inferior \
	observers. If this ward sees such a thing, it fires a beam of energy at the hidden \
	entity, which exposes them."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/mechanical/ward/monitor
	desc = "It's a little flying drone. This one seems to be watching you..."
	catalogue_data = list(/datum/category_item/catalogue/technology/drone/ward)
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
	faction = FACTION_SYNDICATE

/mob/living/simple_mob/mechanical/ward/monitor/crew
	icon_state = "ward-nt"

/mob/living/simple_mob/mechanical/ward/monitor/crew/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/weapon/card/id) && !owner)
		owner = user
		return
	..()

/mob/living/simple_mob/mechanical/ward/monitor/crew/IIsAlly(mob/living/L)
	. = ..()
	if(!.)
		if(isrobot(L)) // They ignore synths.
			return TRUE
		return L.assess_perp(src, FALSE, FALSE, TRUE, FALSE) <= 3

/mob/living/simple_mob/mechanical/ward/monitor/death()
	if(owner)
		to_chat(owner, span("warning", "Your [src.name] inside [get_area(src)] was destroyed!"))
	..()

/mob/living/simple_mob/mechanical/ward/monitor/handle_special()
	detect_mobs()

/mob/living/simple_mob/mechanical/ward/monitor/update_icon()
	if(seen_mobs.len)
		icon_living = "[initial(icon_state)]_spotted"
		glow_color = "#FF0000"
	else
		icon_living = "[initial(icon_state)]"
		glow_color = "#00FF00"
	handle_light() // Update the light immediately.
	..()

/mob/living/simple_mob/mechanical/ward/monitor/proc/detect_mobs()
	var/last_seen_mobs_len = seen_mobs.len
	var/list/mobs_nearby = hearers(view_range, src)
	var/list/newly_seen_mobs = list()
	for(var/mob/living/L in mobs_nearby)
		if(L == src) // Don't detect ourselves.
			continue

		if(L.stat) // Dead mobs aren't concerning.
			continue

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

	if(newly_seen_mobs.len && owner) // Yell at our owner if someone new shows up.
		to_chat(owner, span("notice", "Your [src.name] at [get_area(src)] detected [english_list(newly_seen_mobs)]."))

	// Now get rid of old mobs that left vision.
	for(var/thing in seen_mobs)
		if(!(thing in mobs_nearby))
			seen_mobs -= thing

	// Check if we need to update icon.
	if(seen_mobs.len != last_seen_mobs_len)
		update_icon()


// Can't attack but calls for help. Used by the monitor and spotter wards.
// Special attacks are not blocked since they might be used for things besides attacking, and can be conditional.
/datum/ai_holder/simple_mob/monitor
	hostile = TRUE // Required to call for help.
	cooperative = TRUE
	stand_ground = TRUE // So it doesn't run up to the thing it sees.
	wander = FALSE
	can_flee = FALSE

/datum/ai_holder/simple_mob/monitor/melee_attack(atom/A)
	return FALSE

/datum/ai_holder/simple_mob/monitor/ranged_attack(atom/A)
	return FALSE
