/obj/machinery/firework_launcher
	name = "firework launcher"
	desc = "A machine for launching fireworks of varying practicality."
	icon = 'icons/obj/machines/firework_launcher.dmi'
	icon_state = "launcher01"
	density = TRUE
	anchored = TRUE

	circuit = /obj/item/weapon/circuitboard/firework_launcher
	var/obj/item/weapon/firework_star/loaded_star
	var/last_launch
	var/launch_cooldown = 5 MINUTES

/obj/machinery/firework_launcher/Initialize()
	. = ..()

	default_apply_parts()
	last_launch = world.time						// Prevents cheesing cooldown by deconstructing and reconstructing
	update_icon()

/obj/machinery/firework_launcher/RefreshParts()
	launch_cooldown = 5 MINUTES
	var/rating = 0
	for(var/obj/item/weapon/stock_parts/micro_laser/laser in component_parts)
		rating += laser.rating - 1
	launch_cooldown = max(0, (launch_cooldown - ((rating*30) SECONDS)))			// For every part tier above 1 on the two lasers, reduce cooldown by 30 seconds. 1 minute cooldown on the tier 5 parts, 3 minutes on tier 3.

	. = ..()

/obj/machinery/firework_launcher/update_icon()
	icon_state = "launcher[loaded_star ? "1" : "0"][anchored ? "1" : "0"][panel_open ? "_open" : ""]"

/obj/machinery/firework_launcher/attackby(var/obj/item/O, var/mob/user)
	if(default_deconstruction_screwdriver(user, O))
		update_icon()
		return

	if(default_deconstruction_crowbar(user, O))
		return

	if(default_part_replacement(user, O))
		return

	if(default_unfasten_wrench(user, O, 20))
		update_icon()
		return

	if(istype(O, /obj/item/weapon/firework_star))
		loaded_star = O
		user.drop_item()
		O.forceMove(src)
		to_chat(user, "<span class='notice'>You insert the firework star into the launcher.</span>")
		add_fingerprint(user)
		update_icon()
		return

	return ..()

/obj/machinery/firework_launcher/verb/eject()
	set category = "Object"
	set name = "Eject Firework Star"
	set src in oview(1)

	var/mob/living/user = usr
	if(!user || user.stat != 0)
		return
	if(!loaded_star)
		to_chat(user, "<span class='notice'>There is no firework star loaded in the launcher.</span>")
		return
	else
		loaded_star.forceMove(get_turf(src))
		loaded_star = null
		add_fingerprint(user)
		update_icon()

/obj/machinery/firework_launcher/attack_hand(mob/user)				// Maybe this proc could be better as entirely its own proc, called from attack_hand, but also I don't really see the point
	if(panel_open)
		to_chat(user, "<span class='warning'>Close the panel first!</span>")
		return

	if(!loaded_star)
		to_chat(user, "<span class='notice'>There is no firework star loaded in the launcher.</span>")
		return

	if((world.time - last_launch) <= launch_cooldown)
		to_chat(user, "<span class='notice'>The launcher is still re-priming for launch.</span>")
		return

	if(!anchored)
		to_chat(user, "<span class='warning'>Launcher must be firmly secured to the ground before firework can be launched!</span>")
		return

	var/datum/planet/P = get_planet()
	if(!P || !(P.weather_holder))				// There are potential cases of being outside but not on planet. And checking whether planet has weather at all is more sanity thing than anything.
		to_chat(user, "<span class='warning'>Launcher beeps as its safeties seem to prevent launch in the current location.</span>")
		return

	var/datum/weather_holder/WH = P.weather_holder
	if(WH.firework_override && istype(loaded_star, /obj/item/weapon/firework_star/weather))			// Enable weather-based events to not be ruined
		to_chat(user, "<span class='warning'>Launcher beeps as it seems some interference is preventing launch of this type of firework.</span>")
		return

	to_chat(user, "<span class='notice'>You launch the firework!</span>")
	playsound(get_turf(src), 'sound/weapons/rpg.ogg', 75, 1)
	loaded_star.trigger_firework(WH)
	qdel(loaded_star)
	loaded_star = null
	last_launch = world.time
	add_fingerprint(user)
	update_icon()
	flick("launcher_launch", src)

/obj/machinery/firework_launcher/proc/get_planet()
	var/turf/T = get_turf(src)
	if(!T)
		return

	if(!T.is_outdoors())
		return

	var/datum/planet/P = SSplanets.z_to_planet[T.z]
	if(!P)
		return
	return P