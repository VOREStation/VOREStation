/mob/living/bot/cleanbot
	name = "Cleanbot"
	desc = "A little cleaning robot, it looks so excited!"
	icon_state = "cleanbot0"
	req_one_access = list(access_robotics, access_janitor)
	botcard_access = list(access_janitor)
	pass_flags = PASSTABLE

	locked = 0 // Start unlocked so roboticist can set them to patrol.
	wait_if_pulled = 1
	min_target_dist = 0

	var/vocal = 1
	var/cleaning = 0
	var/wet_floors = 0
	var/spray_blood = 0
	var/blood = 1
	var/list/target_types = list()

/mob/living/bot/cleanbot/New()
	..()
	get_targets()

/mob/living/bot/cleanbot/Destroy()
	if(target)
		cleanbot_reserved_turfs -= target
	return ..()

/mob/living/bot/cleanbot/handleIdle()
	if(!wet_floors && !spray_blood && vocal && prob(2))
		custom_emote(2, "makes an excited booping sound!")
		playsound(src, 'sound/machines/synth_yes.ogg', 50, 0)

	if(wet_floors && prob(5)) // Make a mess
		if(istype(loc, /turf/simulated))
			var/turf/simulated/T = loc
			T.wet_floor()

	if(spray_blood && prob(5)) // Make a big mess
		visible_message("Something flies out of [src]. It seems to be acting oddly.")
		var/obj/effect/decal/cleanable/blood/gibs/gib = new /obj/effect/decal/cleanable/blood/gibs(loc)
		// TODO - I have a feeling weakrefs will not work in ignore_list, verify this ~Leshana
		var/weakref/g = weakref(gib)
		ignore_list += g
		spawn(600)
			ignore_list -= g

/mob/living/bot/cleanbot/handlePanic()	// Speed modification based on alert level.
	. = 0
	switch(get_security_level())
		if("green")
			. = 0

		if("yellow")
			. = 1

		if("violet")
			. = 1

		if("orange")
			. = 1

		if("blue")
			. = 2

		if("red")
			. = 2

		if("delta")
			. = 2

	return .

/mob/living/bot/cleanbot/lookForTargets()
	for(var/i = 0, i <= world.view, i++)
		for(var/obj/effect/decal/cleanable/D in view(i, src))
			if (i > 0 && get_dist(src, D) < i)
				continue // already checked this one
			else if(confirmTarget(D))
				target = D
				cleanbot_reserved_turfs += D
				return

/mob/living/bot/resetTarget()
	cleanbot_reserved_turfs -= target
	..()

/mob/living/bot/cleanbot/confirmTarget(var/obj/effect/decal/cleanable/D)
	if(!..())
		return FALSE
	if(D.loc in cleanbot_reserved_turfs)
		return FALSE
	for(var/T in target_types)
		if(istype(D, T))
			return TRUE
	return FALSE


/mob/living/bot/cleanbot/handleAdjacentTarget()
	if(get_turf(target) == src.loc)
		UnarmedAttack(target)

/mob/living/bot/cleanbot/UnarmedAttack(var/obj/effect/decal/cleanable/D, var/proximity)
	if(!..())
		return

	if(!istype(D))
		return

	if(D.loc != loc)
		return

	busy = 1
	if(prob(20))
		custom_emote(2, "begins to clean up \the [D]")
	update_icons()
	var/cleantime = istype(D, /obj/effect/decal/cleanable/dirt) ? 10 : 50
	if(do_after(src, cleantime))
		if(istype(loc, /turf/simulated))
			var/turf/simulated/f = loc
			f.dirt = 0
		if(!D)
			return
		qdel(D)
		if(D == target)
			cleanbot_reserved_turfs -= target
			target = null
	busy = 0
	update_icons()

/mob/living/bot/cleanbot/explode()
	on = 0
	visible_message("<span class='danger'>[src] blows apart!</span>")
	var/turf/Tsec = get_turf(src)

	new /obj/item/weapon/reagent_containers/glass/bucket(Tsec)
	new /obj/item/device/assembly/prox_sensor(Tsec)
	if(prob(50))
		new /obj/item/robot_parts/l_arm(Tsec)

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	qdel(src)
	return

/mob/living/bot/cleanbot/update_icons()
	if(busy)
		icon_state = "cleanbot-c"
	else
		icon_state = "cleanbot[on]"

/mob/living/bot/cleanbot/attack_hand(var/mob/user)
	tgui_interact(user)

/mob/living/bot/cleanbot/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Cleanbot", name)
		ui.open()

/mob/living/bot/cleanbot/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()
	data["on"] = on
	data["open"] = open
	data["locked"] = locked
	
	data["blood"] = blood
	data["patrol"] = will_patrol
	data["vocal"] = vocal

	data["wet_floors"] = wet_floors
	data["spray_blood"] = spray_blood
	data["version"] = "v2.0"
	return data

/mob/living/bot/cleanbot/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE
	usr.set_machine(src)
	add_fingerprint(usr)
	switch(action)
		if("start")
			if(on)
				turn_off()
			else
				turn_on()
			. = TRUE
		if("blood")
			blood = !blood
			get_targets()
			. = TRUE
		if("patrol")
			will_patrol = !will_patrol
			patrol_path = null
			. = TRUE
		if("vocal")
			vocal = !vocal
			. = TRUE
		if("wet_floors")
			wet_floors = !wet_floors
			to_chat(usr, "<span class='notice'>You twiddle the screw.</span>")
			. = TRUE
		if("spray_blood")
			spray_blood = !spray_blood
			to_chat(usr, "<span class='notice'>You press the weird button.</span>")
			. = TRUE

/mob/living/bot/cleanbot/emag_act(var/remaining_uses, var/mob/user)
	. = ..()
	if(!wet_floors || !spray_blood)
		if(user)
			to_chat(user, "<span class='notice'>The [src] buzzes and beeps.</span>")
			playsound(src, 'sound/machines/buzzbeep.ogg', 50, 0)
		spray_blood = 1
		wet_floors = 1
		return 1

/mob/living/bot/cleanbot/proc/get_targets()
	target_types = list()

	target_types += /obj/effect/decal/cleanable/blood/oil
	target_types += /obj/effect/decal/cleanable/vomit
	target_types += /obj/effect/decal/cleanable/crayon
	target_types += /obj/effect/decal/cleanable/liquid_fuel
	target_types += /obj/effect/decal/cleanable/mucus
	target_types += /obj/effect/decal/cleanable/dirt
	target_types += /obj/effect/decal/cleanable/filth

	if(blood)
		target_types += /obj/effect/decal/cleanable/blood

/* Assembly */

/obj/item/weapon/bucket_sensor
	desc = "It's a bucket. With a sensor attached."
	name = "proxy bucket"
	icon = 'icons/obj/aibots.dmi'
	icon_state = "bucket_proxy"
	force = 3.0
	throwforce = 10.0
	throw_speed = 2
	throw_range = 5
	w_class = ITEMSIZE_NORMAL
	var/created_name = "Cleanbot"

/obj/item/weapon/bucket_sensor/attackby(var/obj/item/W, var/mob/user)
	..()
	if(istype(W, /obj/item/robot_parts/l_arm) || istype(W, /obj/item/robot_parts/r_arm) || (istype(W, /obj/item/organ/external/arm) && ((W.name == "robotic left arm") || (W.name == "robotic right arm"))))
		user.drop_item()
		qdel(W)
		var/turf/T = get_turf(loc)
		var/mob/living/bot/cleanbot/A = new /mob/living/bot/cleanbot(T)
		A.name = created_name
		to_chat(user, "<span class='notice'>You add the robot arm to the bucket and sensor assembly. Beep boop!</span>")
		user.drop_from_inventory(src)
		qdel(src)

	else if(istype(W, /obj/item/weapon/pen))
		var/t = sanitizeSafe(input(user, "Enter new robot name", name, created_name), MAX_NAME_LEN)
		if(!t)
			return
		if(!in_range(src, usr) && src.loc != usr)
			return
		created_name = t
