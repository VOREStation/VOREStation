/**********************Resonator**********************/

/obj/item/resonator
	name = "resonator"
	icon = 'icons/obj/mining_vr.dmi'
	icon_state = "resonator"
	item_state = "resonator"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_vr.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_vr.dmi',
		)
	origin_tech =  list(TECH_MAGNET = 3, TECH_ENGINEERING = 3)
	desc = "A handheld device that creates small fields of energy that resonate until they detonate, crushing rock. It can also be activated without a target to create a field at the user's location, to act as a delayed time trap. It's more effective in low temperature."
	w_class = ITEMSIZE_NORMAL
	force = 8
	throwforce = 10
	var/cooldown = 0
	var/fieldsactive = 0
	var/burst_time = 50
	var/fieldlimit = 3
	var/spreadmode = 0
	var/cascading  = 0

/obj/item/resonator/upgraded
	name = "upgraded resonator"
	desc = "An upgraded version of the resonator that can produce more fields at once."
	icon_state = "resonator_u"
	origin_tech =  list(TECH_MATERIAL = 4, TECH_POWER = 3, TECH_MAGNET = 3, TECH_ENGINEERING = 3)
	fieldlimit = 5

/obj/item/resonator/proc/CreateResonance(var/target, var/creator)
	var/turf/T = get_turf(target)
	if(locate(/obj/effect/resonance) in T)
		return

	if((!spreadmode && fieldsactive < fieldlimit) || (spreadmode && !cascading) )
		playsound(src,'sound/weapons/resonator_fire.ogg',50,1)
		new /obj/effect/resonance(T, WEAKREF(creator), burst_time, spreadmode, fieldlimit, get_cardinal_dir(src, T))
		fieldsactive++
		cascading = TRUE
		spawn(burst_time)
			fieldsactive--
			cascading = FALSE

/obj/item/resonator/attack_self(mob/user)
	switch(tgui_alert(user, "Change Detonation Time or toggle Cascading?","Setting", list("Toggle Cascade", "Resonance Time")))
		if("Resonance Time")
			if(burst_time == 50)
				burst_time = 30
				to_chat(user, "<span class='info'>You set the resonator's fields to detonate after 3 seconds.</span>")
			else
				burst_time = 50
				to_chat(user, "<span class='info'>You set the resonator's fields to detonate after 5 seconds.</span>")
		if("Toggle Cascade")
			spreadmode = !spreadmode
			to_chat(user, span_info("You have [(spreadmode ? "enabled" : "disabled")] the resonance cascade mode."))

/obj/item/resonator/afterattack(atom/target, mob/user, proximity_flag)
	if(proximity_flag)
		if(!check_allowed_items(target, 1))
			return
		CreateResonance(target, user)

/obj/effect/resonance
	name = "resonance field"
	desc = "A resonating field that significantly damages anything inside of it when the field eventually ruptures."
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield1"
	plane = MOB_PLANE
	layer = ABOVE_MOB_LAYER
	mouse_opacity = 0
	var/resonance_damage = 20


/obj/effect/resonance/Initialize(mapload, var/creator = null, var/timetoburst, var/spread, var/fields, var/origin_dir, var/depth = 0)
	. = ..()
	// Start small and grow to big size as we are about to burst
	transform = matrix()*0.75
	animate(src, transform = matrix()*1.5, time = timetoburst)
	//Spread if requested
	if(spread)
		fields--
		var/new_dir = turn(origin_dir, 90)
		var/new_fields = fields
		for(var/i=0, i<=2, i++) //We place cascade the resonance by 3 entries each time in a "T shape" around the original resonance
			if(fields > 0)
				switch(i)
					if(0)
						new_dir = origin_dir
					if(1)
						new_dir = turn(origin_dir, 90)
					if(2)
						new_dir = turn(origin_dir, -90)
				var/turf/T = get_step(get_turf(src), new_dir)
				new_fields = fields - 2  - (i*3) - depth
				fields--
				new /obj/effect/resonance(T, WEAKREF(creator), timetoburst, spread, new_fields, get_cardinal_dir(src, T), depth++)
	// Queue the actual bursting
	spawn(timetoburst)
		if(!QDELETED(src))
			burst(creator)

/obj/effect/resonance/proc/burst(var/creator = null)
	var/turf/T = get_turf(src)
	if(!T)
		return
	playsound(src, 'sound/weapons/resonator_blast.ogg', 50, 1)
	// Make the collapsing effect
	new /obj/effect/temp_visual/resonance_crush(T)

	// Mineral turfs get drilled!
	if(istype(T, /turf/simulated/mineral))
		var/turf/simulated/mineral/M = T
		M.GetDrilled()
		qdel(src)
		return
	// Otherwise we damage mobs!  Boost damage if low tempreature
	var/datum/gas_mixture/environment = T.return_air()
	if(environment.temperature < 250)
		name = "strong resonance field"
		resonance_damage = 50

	for(var/mob/living/L in src.loc)
		if(creator)
			add_attack_logs(creator, L, "used a resonator field on")
		to_chat(L, "<span class='danger'>\The [src] ruptured with you in it!</span>")
		L.apply_damage(resonance_damage, BRUTE)
	qdel(src)


/obj/effect/temp_visual/resonance_crush
	icon_state = "shield1"
	plane = MOB_PLANE
	layer = ABOVE_MOB_LAYER
	duration = 4

/obj/effect/temp_visual/resonance_crush/Initialize()
	. = ..()
	transform = matrix()*1.5
	animate(src, transform = matrix()*0.1, alpha = 50, time = 4)
