/obj/machinery/vr_sleeper
	name = "virtual reality sleeper"
	desc = "A fancy bed with built-in sensory I/O ports and connectors to interface users' minds with their bodies in virtual reality."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "syndipod_0"
<<<<<<< HEAD:code/game/machinery/vr_console.dm
=======

	var/base_state = "syndipod_"

>>>>>>> 83fc6b5... Adds Alien Reality pods, aka AR pods, for use in events or PoIs. (#5798):code/game/machinery/virtual_reality/vr_console.dm
	density = 1
	anchored = 1
	circuit = /obj/item/weapon/circuitboard/vr_sleeper
	var/mob/living/carbon/human/occupant = null
	var/mob/living/carbon/human/avatar = null
	var/datum/mind/vr_mind = null
<<<<<<< HEAD:code/game/machinery/vr_console.dm
=======
	var/datum/effect/effect/system/smoke_spread/bad/smoke

	var/eject_dead = TRUE

	var/mirror_first_occupant = TRUE	// Do we force the newly produced body to look like the occupant?
>>>>>>> 83fc6b5... Adds Alien Reality pods, aka AR pods, for use in events or PoIs. (#5798):code/game/machinery/virtual_reality/vr_console.dm

	use_power = 1
	idle_power_usage = 15
	active_power_usage = 200
	light_color = "#FF0000"

/obj/machinery/vr_sleeper/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/stock_parts/scanning_module(src)
	component_parts += new /obj/item/stack/material/glass/reinforced(src, 2)

	RefreshParts()

<<<<<<< HEAD:code/game/machinery/vr_console.dm
/obj/machinery/vr_sleeper/initialize()
	. = ..()
	update_icon()

/obj/machinery/vr_sleeper/process()
	if(stat & (NOPOWER|BROKEN))
		return

/obj/machinery/vr_sleeper/update_icon()
	icon_state = "syndipod_[occupant ? "1" : "0"]"
=======
/obj/machinery/vr_sleeper/Initialize()
	. = ..()
	smoke = new
	update_icon()

/obj/machinery/vr_sleeper/Destroy()
	. = ..()
	go_out()

/obj/machinery/vr_sleeper/process()
	if(stat & (NOPOWER|BROKEN))
		if(occupant)
			go_out()
			visible_message("<span class='notice'>\The [src] emits a low droning sound, before the pod door clicks open.</span>")
		return
	else if(eject_dead && occupant && occupant.stat == DEAD) // If someone dies somehow while inside, spit them out.
		visible_message("<span class='warning'>\The [src] sounds an alarm, swinging its hatch open.</span>")
		go_out()

/obj/machinery/vr_sleeper/update_icon()
	icon_state = "[base_state][occupant ? "1" : "0"]"
>>>>>>> 83fc6b5... Adds Alien Reality pods, aka AR pods, for use in events or PoIs. (#5798):code/game/machinery/virtual_reality/vr_console.dm

/obj/machinery/vr_sleeper/Topic(href, href_list)
	if(..())
		return 1

	if(usr == occupant)
		to_chat(usr, "<span class='warning'>You can't reach the controls from the inside.</span>")
		return

	add_fingerprint(usr)

	if(href_list["eject"])
		go_out()

	return 1

/obj/machinery/vr_sleeper/attackby(var/obj/item/I, var/mob/user)
	add_fingerprint(user)
<<<<<<< HEAD:code/game/machinery/vr_console.dm
=======

	if(occupant && (istype(I, /obj/item/device/healthanalyzer) || istype(I, /obj/item/device/robotanalyzer)))
		I.attack(occupant, user)
		return

>>>>>>> 83fc6b5... Adds Alien Reality pods, aka AR pods, for use in events or PoIs. (#5798):code/game/machinery/virtual_reality/vr_console.dm
	if(default_deconstruction_screwdriver(user, I))
		return
	else if(default_deconstruction_crowbar(user, I))
		if(occupant && avatar)
			avatar.exit_vr()
			avatar = null
			go_out()
		return


/obj/machinery/vr_sleeper/MouseDrop_T(var/mob/target, var/mob/user)
	if(user.stat || user.lying || !Adjacent(user) || !target.Adjacent(user)|| !isliving(target))
		return
	go_in(target, user)



/obj/machinery/sleeper/relaymove(var/mob/user)
	..()
	if(usr.incapacitated())
		return
	go_out()



/obj/machinery/vr_sleeper/emp_act(var/severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return

	if(occupant)
		// This will eject the user from VR
<<<<<<< HEAD:code/game/machinery/vr_console.dm
		// ### Fry the brain?
=======
		// ### Fry the brain? Yes. Maybe.
		if(prob(15 / ( severity / 4 )) && occupant.species.has_organ[O_BRAIN] && occupant.internal_organs_by_name[O_BRAIN])
			var/obj/item/organ/O = occupant.internal_organs_by_name[O_BRAIN]
			O.take_damage(severity * 2)
			visible_message("<span class='danger'>\The [src]'s internal lighting flashes rapidly, before the hatch swings open with a cloud of smoke.</span>")
			smoke.set_up(n = severity, 0, src)
			smoke.start("#202020")
>>>>>>> 83fc6b5... Adds Alien Reality pods, aka AR pods, for use in events or PoIs. (#5798):code/game/machinery/virtual_reality/vr_console.dm
		go_out()

	..(severity)

/obj/machinery/vr_sleeper/verb/eject()
<<<<<<< HEAD:code/game/machinery/vr_console.dm
	set src in oview(1)
=======
	set src in view(1)
>>>>>>> 83fc6b5... Adds Alien Reality pods, aka AR pods, for use in events or PoIs. (#5798):code/game/machinery/virtual_reality/vr_console.dm
	set category = "Object"
	set name = "Eject VR Capsule"

	if(usr.incapacitated())
		return

<<<<<<< HEAD:code/game/machinery/vr_console.dm
	if(usr != occupant && avatar && alert(avatar, "Someone wants to remove you from virtual reality. Do you want to leave?", "Leave VR?", "Yes", "No") == "No")
		return

	// The player in VR is fine with leaving, kick them out and reset avatar
	avatar.exit_vr()
	avatar = null
	go_out()
=======
	var/forced = FALSE

	if(stat & (BROKEN|NOPOWER) || occupant && occupant.stat == DEAD)
		forced = TRUE

	go_out(forced)
>>>>>>> 83fc6b5... Adds Alien Reality pods, aka AR pods, for use in events or PoIs. (#5798):code/game/machinery/virtual_reality/vr_console.dm
	add_fingerprint(usr)

/obj/machinery/vr_sleeper/verb/climb_in()
	set src in oview(1)
	set category = "Object"
	set name = "Enter VR Capsule"

	if(usr.incapacitated())
		return
	go_in(usr, usr)
	add_fingerprint(usr)

/obj/machinery/vr_sleeper/relaymove(mob/user as mob)
	if(user.incapacitated())
		return 0 //maybe they should be able to get out with cuffs, but whatever
	go_out()

/obj/machinery/vr_sleeper/proc/go_in(var/mob/M, var/mob/user)
	if(!M)
		return
	if(stat & (BROKEN|NOPOWER))
		return
	if(!ishuman(M))
<<<<<<< HEAD:code/game/machinery/vr_console.dm
		user << "<span class='warning'>\The [src] rejects [M] with a sharp beep.</span>"
	if(occupant)
		user << "<span class='warning'>\The [src] is already occupied.</span>"
=======
		to_chat(user, "<span class='warning'>\The [src] rejects [M] with a sharp beep.</span>")
	if(occupant)
		to_chat(user, "<span class='warning'>\The [src] is already occupied.</span>")
>>>>>>> 83fc6b5... Adds Alien Reality pods, aka AR pods, for use in events or PoIs. (#5798):code/game/machinery/virtual_reality/vr_console.dm
		return

	if(M == user)
		visible_message("\The [user] starts climbing into \the [src].")
	else
		visible_message("\The [user] starts putting [M] into \the [src].")

	if(do_after(user, 20))
		if(occupant)
			to_chat(user, "<span class='warning'>\The [src] is already occupied.</span>")
			return
		M.stop_pulling()
		if(M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src
		M.loc = src
		update_use_power(2)
		occupant = M

		update_icon()

		enter_vr()
	return

<<<<<<< HEAD:code/game/machinery/vr_console.dm
/obj/machinery/vr_sleeper/proc/go_out()
	if(!occupant)
		return

=======
/obj/machinery/vr_sleeper/proc/go_out(var/forced = TRUE)
	if(!occupant)
		return

	if(!forced && avatar && alert(avatar, "Someone wants to remove you from virtual reality. Do you want to leave?", "Leave VR?", "Yes", "No") == "No")
		return

	avatar.exit_vr()
	avatar = null

>>>>>>> 83fc6b5... Adds Alien Reality pods, aka AR pods, for use in events or PoIs. (#5798):code/game/machinery/virtual_reality/vr_console.dm
	if(occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	occupant.loc = src.loc
	occupant = null
	for(var/atom/movable/A in src) // In case an object was dropped inside or something
		if(A == circuit)
			continue
		if(A in component_parts)
			continue
		A.loc = src.loc
	update_use_power(1)
	update_icon()

/obj/machinery/vr_sleeper/proc/enter_vr()

	// No mob to transfer a mind from
	if(!occupant)
		return

	// No mind to transfer
	if(!occupant.mind)
		return

	// Mob doesn't have an active consciousness to send/receive from
<<<<<<< HEAD:code/game/machinery/vr_console.dm
	if(occupant.stat != CONSCIOUS)
=======
	if(occupant.stat == DEAD)
>>>>>>> 83fc6b5... Adds Alien Reality pods, aka AR pods, for use in events or PoIs. (#5798):code/game/machinery/virtual_reality/vr_console.dm
		return

	avatar = occupant.vr_link
	// If they've already enterred VR, and are reconnecting, prompt if they want a new body
<<<<<<< HEAD:code/game/machinery/vr_console.dm
	if(avatar && alert(occupant, "You already have a Virtual Reality avatar. Would you like to use it?", "New avatar", "Yes", "No") == "No")
=======
	if(avatar && alert(occupant, "You already have a [avatar.stat == DEAD ? "" : "deceased "]Virtual Reality avatar. Would you like to use it?", "New avatar", "Yes", "No") == "No")
>>>>>>> 83fc6b5... Adds Alien Reality pods, aka AR pods, for use in events or PoIs. (#5798):code/game/machinery/virtual_reality/vr_console.dm
		// Delink the mob
		occupant.vr_link = null
		avatar = null

	if(!avatar)
		// Get the desired spawn location to put the body
		var/S = null
		var/list/vr_landmarks = list()
		for(var/obj/effect/landmark/virtual_reality/sloc in landmarks_list)
			vr_landmarks += sloc.name

		S = input(occupant, "Please select a location to spawn your avatar at:", "Spawn location") as null|anything in vr_landmarks
		if(!S)
			return 0

		for(var/obj/effect/landmark/virtual_reality/i in landmarks_list)
			if(i.name == S)
				S = i
				break

		avatar = new(S, "Virtual Reality Avatar")
		// If the user has a non-default (Human) bodyshape, make it match theirs.
<<<<<<< HEAD:code/game/machinery/vr_console.dm
		if(occupant.species.name != "Promethean" && occupant.species.name != "Human")
=======
		if(occupant.species.name != "Promethean" && occupant.species.name != "Human" && mirror_first_occupant)
>>>>>>> 83fc6b5... Adds Alien Reality pods, aka AR pods, for use in events or PoIs. (#5798):code/game/machinery/virtual_reality/vr_console.dm
			avatar.shapeshifter_change_shape(occupant.species.name)
		avatar.forceMove(get_turf(S))			// Put the mob on the landmark, instead of inside it
		avatar.Sleeping(1)

		occupant.enter_vr(avatar)

		// Prompt for username after they've enterred the body.
		var/newname = sanitize(input(avatar, "You are entering virtual reality. Your username is currently [src.name]. Would you like to change it to something else?", "Name change") as null|text, MAX_NAME_LEN)
		if (newname)
			avatar.real_name = newname

	else
		occupant.enter_vr(avatar)

