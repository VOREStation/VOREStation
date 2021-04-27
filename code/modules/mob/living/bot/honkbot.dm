//TODO: make this not bad
/mob/living/bot/honkbot
	name = "\improper honkbot"
	health = 20
	maxHealth = 20
	icon = 'icons/obj/aibots_vr.dmi'
	icon_state = "honkbot"
	layer = MOB_LAYER-0.1
	var/wet_floors = 0
	var/last_newpatient_speak = 0

/mob/living/bot/honkbot/handleIdle()
	if(prob(10))
		custom_emote(2, "honks.")
		playsound(src, 'sound/items/bikehorn.ogg', 50, 0)
		if(istype(loc, /turf/simulated))
			if(wet_floors)
				if(istype(loc, /turf/simulated))
					var/turf/simulated/T = loc
					T.wet_floor()

/mob/living/bot/honkbot/Crossed(atom/movable/AM as mob|obj)
	if(AM.is_incorporeal())
		return
	if(istype(AM, /mob/living))
		var/mob/living/M = AM
		M.slip("the [src.name]",4)
		playsound(src, 'sound/items/bikehorn.ogg', 50, 0)

/mob/living/bot/honkbot/handleIdle()
	if(prob(2))
		custom_emote(2, "honks!")
		playsound(src, 'sound/machines/synth_yes.ogg', 50, 0)

/mob/living/bot/honkbot/explode()
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
	//playsound(src, 'sound/items/bikehorn.ogg', 50, 0) //todo: find party horn sound
	qdel(src)
	return

/mob/living/bot/honkbot/lookForTargets()
	for(var/mob/living/carbon/human/H in view(7, src)) // Time to find a patient!
		if(confirmTarget(H))
			target = H
			if(last_newpatient_speak + 30 SECONDS < world.time)
				var/message_options = list(
					"Hey, [H.name]. Why can't I see the ceiling?",
					"I may have dropped out of Harvard, but they say laughter is the best medicine!",
					"Psst, [H.name]. I know who you are. Hail Honkmother."
					)
				var/message = pick(message_options)
				say(message)
				playsound(src, 'sound/items/bikehorn.ogg', 50, 0)
			last_newpatient_speak = world.time
		break

/mob/living/bot/honkbot/attack_hand(var/mob/user)
	tgui_interact(user)

/mob/living/bot/honkbot/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Cleanbot", name)
		ui.open()

/mob/living/bot/honkbot/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()
	data["on"] = on
	data["open"] = open
	data["locked"] = locked

	data["patrol"] = will_patrol

	data["wet_floors"] = wet_floors
	data["version"] = "v2.0"
	return data

/mob/living/bot/honkbot/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
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
		if("patrol")
			will_patrol = !will_patrol
			patrol_path = null
			. = TRUE
		if("wet_floors")
			wet_floors = !wet_floors
			to_chat(usr, "<span class='notice'>You twiddle the screw.</span>")
			. = TRUE

/mob/living/bot/honkbot/emag_act(var/remaining_uses, var/mob/user)
	. = ..()
	if(!wet_floors)
		if(user)
			to_chat(user, "<span class='notice'>The [src] buzzes and beeps.</span>")
			playsound(src, 'sound/machines/buzzbeep.ogg', 50, 0)
		wet_floors = 1
		return 1