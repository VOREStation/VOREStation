var/global/list/grub_machine_overlays = list()

/mob/living/simple_animal/solargrub_larva
	name = "solargrub larva"
	desc = "A tiny wormy thing that can grow to massive sizes under the right conditions."
	icon = 'icons/mob/vore.dmi'
	icon_state = "grublarva"
	icon_living = "grublarva"
	icon_dead = "grublarva-dead"

	health = 5
	maxHealth = 5
	
	meat_amount = 2
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat/grubmeat

	faction = "grubs"

	response_help = "pats"
	response_disarm = "nudges"
	response_harm = "stomps on"

	mob_size = MOB_MINISCULE
	pass_flags = PASSTABLE
	can_pull_size = ITEMSIZE_TINY
	can_pull_mobs = MOB_PULL_NONE
	density = 0

	stop_when_pulled = 0

	var/static/list/ignored_machine_types = list(
		/obj/machinery/atmospherics/unary/vent_pump,
		/obj/machinery/atmospherics/unary/vent_scrubber,
		/obj/machinery/door/firedoor
		)

	var/obj/machinery/atmospherics/unary/vent_pump/target_vent

	var/datum/effect/effect/system/spark_spread/sparks
	var/image/machine_effect

	var/obj/machinery/abstract_grub_machine/powermachine
	var/power_drained = 0
	var/forced_out = 0

/mob/living/simple_animal/solargrub_larva/New()
	..()
	powermachine = new(src)
	sparks = new(src)
	sparks.set_up()
	sparks.attach(src)
	verbs += /mob/living/proc/ventcrawl

/mob/living/simple_animal/solargrub_larva/death()
	powermachine.draining = 0
	set_light(0)
	return ..()

/mob/living/simple_animal/solargrub_larva/Destroy()
	qdel_null(powermachine)
	qdel_null(sparks)
	qdel_null(machine_effect)
	target_vent = null
	return ..()

/mob/living/simple_animal/solargrub_larva/Life()
	. = ..()

	if(machine_effect && !istype(loc, /obj/machinery))
		qdel_null(machine_effect)

	if(!. || ai_inactive)
		return

	if(power_drained >= 7 MEGAWATTS && prob(5))
		expand_grub()
		return

	if(istype(loc, /obj/machinery))
		if(machine_effect && air_master.current_cycle%30)
			for(var/mob/M in player_list)
				M << machine_effect
		if(prob(10))
			sparks.start()
		return

	if(stance == STANCE_IDLE)
		if(forced_out)
			forced_out = Clamp(0, forced_out--, forced_out)
			return

		if(target_vent)
			if(Adjacent(target_vent))
				spawn()
					do_ventcrawl(target_vent)
					target_vent = null
			else
				target_vent = null
			stop_automated_movement = 0
			walk(src, 0)
			return

		if(prob(20))
			var/list/possible_machines = list()
			for(var/obj/machinery/M in orange(1,src))
				if(!Adjacent(M))
					continue
				if(istype(M, /obj/machinery/power/apc) || istype(M, /obj/machinery/power/smes)) //APCs and SMES units don't actually use power, but it's too thematic to ignore them
					possible_machines += M
					continue
				if(is_type_in_list(M, ignored_machine_types))
					continue
				if(!M.idle_power_usage && !M.active_power_usage) //If it can't use power at all, ignore it
					continue
				possible_machines += M
			if(possible_machines.len)
				enter_machine(pick(possible_machines))
				return

		if(prob(10))
			var/list/vents = list()
			for(var/obj/machinery/atmospherics/unary/vent_pump/vent in view(7,src))
				if(vent.welded)
					continue
				vents += vent
			if(vents.len)
				var/picked = pick(vents)
				target_vent = picked
				WanderTowards(get_turf(picked))
				return

/mob/living/simple_animal/solargrub_larva/proc/enter_machine(var/obj/machinery/M)
	if(!istype(M))
		return
	forceMove(M)
	powermachine.draining = 2
	visible_message("<span class='warning'>\The [src] finds an opening and crawls inside \the [M].</span>")
	if(!(M.type in grub_machine_overlays))
		generate_machine_effect(M)
	machine_effect = image(grub_machine_overlays[M.type], M) //Can't do this the reasonable way with an overlay,
	for(var/mob/L in player_list)				//because nearly every machine updates its icon by removing all overlays first
		L << machine_effect

/mob/living/simple_animal/solargrub_larva/proc/generate_machine_effect(var/obj/machinery/M)
	var/icon/I = new /icon(M.icon, M.icon_state)
	I.Blend(new /icon('icons/effects/blood.dmi', rgb(255,255,255)),ICON_ADD)
	I.Blend(new /icon('icons/effects/alert.dmi', "_red"),ICON_MULTIPLY)
	grub_machine_overlays[M.type] = I

/mob/living/simple_animal/solargrub_larva/proc/eject_from_machine(var/obj/machinery/M)
	if(!M)
		if(istype(loc, /obj/machinery))
			M = loc
		else
			return
	forceMove(get_turf(M))
	sparks.start()
	if(machine_effect)
		qdel_null(machine_effect)
	forced_out += rand(5,15)
	powermachine.draining = 1

/mob/living/simple_animal/solargrub_larva/proc/do_ventcrawl(var/obj/machinery/atmospherics/unary/vent_pump/vent)
	if(!vent)
		return
	var/obj/machinery/atmospherics/unary/vent_pump/end_vent = get_safe_ventcrawl_target(vent)
	if(!end_vent)
		return
	forceMove(vent)
	playsound(vent, 'sound/machines/ventcrawl.ogg', 50, 1, -3)
	vent.visible_message("\The [src] wiggles into \the [vent]!")
	var/redirect_attempts = 3
	while(redirect_attempts)
		var/travel_time = round(get_dist(get_turf(src), get_turf(end_vent)) / 2)
		sleep(travel_time)
		if(end_vent.welded)
			end_vent = get_safe_ventcrawl_target(vent)
			if(!end_vent)
				forceMove(get_turf(vent))
				return
			redirect_attempts--
			continue
		break
	playsound(end_vent, 'sound/machines/ventcrawl.ogg', 50, 1, -3)
	forceMove(get_turf(end_vent))

/mob/living/simple_animal/solargrub_larva/proc/expand_grub()
	eject_from_machine()
	visible_message("<span class='warning'>\The [src] suddenly balloons in size!</span>")
	new /mob/living/simple_animal/retaliate/solargrub(get_turf(src))
//	var/mob/living/simple_animal/retaliate/solargrub/grub = new(get_turf(src))
//	grub.power_drained = power_drained //TODO
	qdel(src)

/mob/living/simple_animal/solargrub_larva/handle_light()
	. = ..()
	if(. == 0 && !is_dead())
		set_light(1.5, 1, COLOR_YELLOW)
		return 1


/obj/machinery/abstract_grub_machine
	var/total_active_power_usage = 45 KILOWATTS
	var/list/active_power_usages = list(15 KILOWATTS, 15 KILOWATTS, 15 KILOWATTS)
	var/total_idle_power_usage = 3 KILOWATTS
	var/list/idle_power_usages = list(1 KILOWATTS, 1 KILOWATTS, 1 KILOWATTS)
	var/draining = 1
	var/mob/living/simple_animal/solargrub_larva/grub

/obj/machinery/abstract_grub_machine/New()
	..()
	shuffle_power_usages()
	grub = loc
	if(!istype(grub))
		grub = null
		qdel(src)

/obj/machinery/abstract_grub_machine/Destroy()
	grub = null
	return ..()

/obj/machinery/abstract_grub_machine/process()
	if(!draining)
		return
	var/area/A = get_area(src)
	if(!A)
		return
	var/list/power_list
	switch(draining)
		if(1)
			power_list = idle_power_usages
		if(2)
			power_list = active_power_usages
	for(var/i = 1 to power_list.len)
		if(A.powered(i))
			use_power(power_list[i], i)
			grub.power_drained += power_list[i]
	if(prob(5))
		shuffle_power_usages()

/obj/machinery/abstract_grub_machine/proc/shuffle_power_usages()
	total_active_power_usage = rand(30 KILOWATTS, 60 KILOWATTS)
	total_idle_power_usage = rand(1 KILOWATTS, 5 KILOWATTS)
	active_power_usages = split_into_3(total_active_power_usage)
	idle_power_usages = split_into_3(total_idle_power_usage)


/obj/item/device/multitool/afterattack(obj/O, mob/user, proximity)
	if(proximity)
		if(istype(O, /obj/machinery))
			var/mob/living/simple_animal/solargrub_larva/grub = locate() in O
			if(grub)
				grub.eject_from_machine(O)
				to_chat(user, "<span class='warning'>You disturb a grub nesting in \the [O]!</span>")
				return
	return ..()
