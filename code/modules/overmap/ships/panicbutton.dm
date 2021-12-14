/obj/structure/panic_button
	name = "distress beacon trigger"
	desc = "WARNING: Will deploy ship's distress beacon and request help. Misuse may result in fines and jail time."
	description_info = "Using this device (smashing the glas on harm intent, and then pressing the button) will send a message to people on other z-levels requesting their aid. It may take them a while to come get you, as they'll need to prepare. You should only use this if you really need it."
	icon = 'icons/obj/objects_vr.dmi'
	icon_state = "panicbutton"
	anchored = TRUE

	var/glass = TRUE
	var/launched = FALSE

/obj/structure/panic_button/small
	icon_state = "smallpanicbutton"

// In case we're annihilated by a meteor
/obj/structure/panic_button/Destroy()
	if(!launched)
		launch()
	return ..()

/obj/structure/panic_button/update_icon()
	if(launched)
		icon_state = "[initial(icon_state)]_launched"
	else if(!glass)
		icon_state = "[initial(icon_state)]_open"
	else
		icon_state = "[initial(icon_state)]"

/obj/structure/panic_button/attack_hand(mob/living/user)
	if(!istype(user))
		return ..()

	if(user.incapacitated())
		return

	// Already launched
	if(launched)
		to_chat(user, "<span class='warning'>The button is already depressed; the beacon has been launched already.</span>")
	// Glass present
	else if(glass)
		if(user.a_intent == I_HURT)
			user.custom_emote(VISIBLE_MESSAGE, "smashes the glass on [src]!")
			glass = FALSE
			playsound(src, 'sound/effects/hit_on_shattered_glass.ogg')
			update_icon()
		else
			user.custom_emote(VISIBLE_MESSAGE, "pats [src] in a friendly manner.")
			to_chat(user, "<span class='warning'>If you're trying to break the glass, you'll have to hit it harder than that...</span>")
	// Must be !glass and !launched
	else
		user.custom_emote(VISIBLE_MESSAGE, "pushes the button on [src]!")
		launch(user)
		playsound(src, get_sfx("button"))
		update_icon()

/obj/structure/panic_button/proc/launch(mob/living/user)
	if(launched)
		return
	launched = TRUE
	var/obj/effect/overmap/visitable/S = get_overmap_sector(z)
	if(!S)
		error("Distress button hit on z[z] but that's not an overmap sector...")
		return
	S.distress(user)
	//Kind of pricey, but this is a one-time thing that can't be reused, so I'm not too worried.
	var/list/hear_z = GetConnectedZlevels(z) // multiz 'physical' connections only, not crazy overmap connections

	var/mapsize = (world.maxx+world.maxy)*0.5
	var/turf/us = get_turf(src)

	for(var/hz in hear_z)
		for(var/mob/M as anything in GLOB.players_by_zlevel[hz])
			var/sound/SND = sound('sound/misc/emergency_beacon_launched.ogg') // Inside the loop because playsound_local modifies it for each person, so, need separate instances
			var/turf/them = get_turf(M)
			var/volume = max(0.20, 1-(get_dist(us,them) / mapsize*0.8))*100
			M.playsound_local(get_turf(M), SND, vol = volume)
