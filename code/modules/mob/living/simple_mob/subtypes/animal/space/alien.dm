/mob/living/simple_mob/animal/space/alien
	name = "alien hunter"
	desc = "Hiss!"
	icon = 'icons/mob/alien.dmi'
	icon_state = "alienh_running"
	icon_living = "alienh_running"
	icon_dead = "alien_l"
	icon_gib = "syndicate_gib"
	icon_rest = "alienh_sleep"

	faction = "xeno"

	mob_class = MOB_CLASS_ABERRATION

	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"

	maxHealth = 100
	health = 100
	see_in_dark = 7

	harm_intent_damage = 5
	melee_damage_lower = 25
<<<<<<< HEAD
	melee_damage_upper = 25
	attack_armor_pen = 15	//It's a freaking alien.
=======
	melee_damage_upper = 35
	attack_armor_pen = 15
>>>>>>> 0e647789c7a... Merge pull request #8521 from Sypsoti/skathari_improvements
	attack_sharp = TRUE
	attack_edge = TRUE

	attacktext = list("slashed")
	attack_sound = 'sound/weapons/bladeslice.ogg'
	ai_holder_type = /datum/ai_holder/simple_mob/xeno_alien /// Found in xeno_alien_ai.dm 
	special_attack_min_range = 1
	special_attack_max_range = 7
	var/teleport_distance = 1 /// How far away to be when we teleport. 
	special_attack_cooldown = 7 SECONDS

	var/obj/effect/overlay/skathari_telegrab/displacement_warning = null

/mob/living/simple_mob/animal/space/alien/do_special_attack(atom/A)
	switch(a_intent)
		if(I_DISARM)
			xeno_teleport(A)
		if(I_GRAB)
			xeno_telegrab()
	return TRUE /// Prevents shooting when using, mostly noticable for player-controlled. 

/mob/living/simple_mob/animal/space/alien/proc/xeno_teleport(atom/target)
	/// Copied MOSTLY from bluespace slime's do_special_attack
	if(!target)
		to_chat(src, span("warning", "There's nothing to teleport to."))
		return FALSE
	
	var/list/nearby_things = range(teleport_distance, target)
	var/list/valid_turfs = list()

	// Check tile density and distance.
	for(var/turf/potential_turf in nearby_things)
		var/valid_turf = TRUE
		if(potential_turf.density)
			continue
		for(var/atom/movable/AM in potential_turf)
			if(AM.density)
				valid_turf = FALSE
		if(get_dist(potential_turf, target) != teleport_distance) /// We want to maintain an acceptable distance.
			valid_turf = FALSE
		if(!can_see(src, potential_turf, 7)) /// We don't want to teleport out of sight!
			valid_turf = FALSE
		if(valid_turf)
			valid_turfs.Add(potential_turf)

	var/turf/T = get_turf(src)
	var/turf/target_turf = pick(valid_turfs)

	if(!target_turf)
		to_chat(src, span("warning", "There wasn't an unoccupied spot to teleport to."))
		return FALSE

	var/datum/effect_system/spark_spread/s1 = new /datum/effect_system/spark_spread
	s1.set_up(5, 1, T)
	var/datum/effect_system/spark_spread/s2 = new /datum/effect_system/spark_spread
	s2.set_up(5, 1, target_turf)


	T.visible_message(span("notice", "\The [src] vanishes!"))
	s1.start()

	forceMove(target_turf)
	playsound(target_turf, 'sound/effects/phasein.ogg', 50, 1)
	to_chat(src, span("notice", "You teleport to \the [target_turf]."))

	target_turf.visible_message(span("warning", "\The [src] appears!"))
	s2.start()

	if(Adjacent(target))
		attack_target(target)

/mob/living/simple_mob/animal/space/alien/proc/xeno_telegrab() /// Fair bit of copy from adv. gygax's electrical defense
	set waitfor = FALSE
	/// Create list of potential teleport spots. 
	var/list/nearby_things = range(7, src)
	var/list/valid_turfs = list()

	for(var/turf/potential_turf in nearby_things)
		var/valid_turf = TRUE
		if(potential_turf.density)
			continue
		for(var/atom/movable/AM in potential_turf)
			if(AM.density)
				valid_turf = FALSE
		if(get_dist(potential_turf, src) <= 5) /// Get them a decent distance away!
			valid_turf = FALSE
		if(valid_turf)
			valid_turfs.Add(potential_turf)

	if(valid_turfs.len < 1)
		return /// Nowhere to teleport them to!

	displacement_warning = new(loc)
	for(var/i = 1 to 3)
		var/turf/T = get_turf(src)
		if(get_turf(displacement_warning) != T)
			displacement_warning.forceMove(T)
		displacement_warning.set_light(i/2, i/2, "#2a84b9")
		for(var/thing in range(3, src))
			if(isliving(thing) || istype(thing, /obj/mecha))
				var/mob/living/L = thing
				if(L == src)
					continue
				if(L.stat)
					continue
				var/turf/target_turf = pick(valid_turfs)
				var/datum/effect_system/spark_spread/sparks = new /datum/effect_system/spark_spread
				sparks.set_up(5, 1, target_turf)
				L.forceMove(target_turf)
				to_chat(L, span("warning", "You were displaced to \the [target_turf]!"))
				playsound(target_turf, 'sound/effects/phasein.ogg', 50, 1)
				target_turf.visible_message(span("warning", "\The [src] appears suddenly!"))
				sparks.start()
				if(L && L.has_AI()) // Some mobs delete themselves when dying.
					L.ai_holder.react_to_attack(src)
		sleep(1 SECOND)
	
	visible_message(span("warning", "\The [displacement_warning] pulses, displacing those nearby!"))
	playsound(src, 'sound/effects/cascade.ogg', 100, 1, extrarange = 30)
	
	qdel(displacement_warning)

	sleep(1 SECOND)

<<<<<<< HEAD
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/xenomeat
	meat_amount = 5
=======

/mob/living/simple_mob/animal/space/alien/death()
	var/turf/center = get_turf(src)
	if (isturf(center))
		playsound(center, 'sound/effects/mob_effects/skathari_teleport.ogg', 75, TRUE)
		for (var/mob/living/carbon/victim in oviewers(5, center))
			victim.flash_eyes(3)
		visible_message(
			SPAN_WARNING("\The [src] disappears with a screech and a flash of light!"),
			SPAN_WARNING("You hear a thin, high screech, ended by a sudden echoing snap!")
		)
		new /obj/effect/decal/cleanable/blood/skathari (center)
		new /obj/effect/temp_visual/bluespace_tear (center)
	if(displacement_warning)
		qdel(displacement_warning)
	qdel(src)
	..()

>>>>>>> 0e647789c7a... Merge pull request #8521 from Sypsoti/skathari_improvements

/mob/living/simple_mob/animal/space/alien/drone
	name = "alien drone"
	icon_state = "aliend_running"
	icon_living = "aliend_running"
	icon_dead = "aliend_l"
	icon_rest = "aliend_sleep"
<<<<<<< HEAD
	health = 60
	melee_damage_lower = 15
	melee_damage_upper = 15
=======
	maxHealth = 80
	health = 80
	melee_damage_lower = 15
	melee_damage_upper = 20
	projectiletype = /obj/item/projectile/energy/skathari
	ai_holder_type = /datum/ai_holder/simple_mob/xeno_alien/ranged
	teleport_distance = 5 /// Puts us right in the middle of our acceptable range. 
>>>>>>> 0e647789c7a... Merge pull request #8521 from Sypsoti/skathari_improvements

/mob/living/simple_mob/animal/space/alien/sentinel
	name = "alien sentinel"
	icon_state = "aliens_running"
	icon_living = "aliens_running"
	icon_dead = "aliens_l"
	icon_rest = "aliens_sleep"
	health = 120
	melee_damage_lower = 15
	melee_damage_upper = 15
	projectiletype = /obj/item/projectile/energy/neurotoxin/toxic
	projectilesound = 'sound/weapons/pierce.ogg'

/mob/living/simple_mob/animal/space/alien/sentinel/praetorian
	name = "alien praetorian"
	icon = 'icons/mob/64x64.dmi'
	icon_state = "prat_s"
	icon_living = "prat_s"
	icon_dead = "prat_dead"
	icon_rest = "prat_sleep"
	maxHealth = 200
	health = 200

	pixel_x = -16
	old_x = -16
	icon_expected_width = 64
	icon_expected_height = 64
	meat_amount = 8

/mob/living/simple_mob/animal/space/alien/queen
	name = "alien queen"
	icon_state = "alienq_running"
	icon_living = "alienq_running"
	icon_dead = "alienq_l"
	icon_rest = "alienq_sleep"
	health = 250
	maxHealth = 250
	melee_damage_lower = 15
	melee_damage_upper = 15
	projectiletype = /obj/item/projectile/energy/neurotoxin/toxic
	projectilesound = 'sound/weapons/pierce.ogg'


	movement_cooldown = 10

/mob/living/simple_mob/animal/space/alien/queen/empress
	name = "alien empress"
	icon = 'icons/mob/64x64.dmi'
	icon_state = "queen_s"
	icon_living = "queen_s"
	icon_dead = "queen_dead"
	icon_rest = "queen_sleep"
	maxHealth = 400
	health = 400
	meat_amount = 15

	pixel_x = -16
	old_x = -16
	icon_expected_width = 64
	icon_expected_height = 64

/mob/living/simple_mob/animal/space/alien/queen/empress/mother
	name = "alien mother"
	icon = 'icons/mob/96x96.dmi'
	icon_state = "empress_s"
	icon_living = "empress_s"
	icon_dead = "empress_dead"
	icon_rest = "empress_rest"
	maxHealth = 600
	health = 600
	meat_amount = 40
	melee_damage_lower = 15
	melee_damage_upper = 25
<<<<<<< HEAD

=======
	movement_cooldown = 8
	projectiletype = /obj/item/projectile/energy/skathari
	ai_holder_type = /datum/ai_holder/simple_mob/xeno_alien/empress
>>>>>>> 0e647789c7a... Merge pull request #8521 from Sypsoti/skathari_improvements
	pixel_x = -32
	pixel_y = -16
	old_x = -32
	default_pixel_x = -32
	default_pixel_y = -16 /// Help center it a bit more. 
	icon_expected_width = 96
	icon_expected_height = 96

<<<<<<< HEAD
/mob/living/simple_mob/animal/space/alien/death()
	..()
	visible_message("[src] lets out a waning guttural screech, green blood bubbling from its maw...")
	playsound(src, 'sound/voice/hiss6.ogg', 100, 1)
=======
	teleport_distance = 3 /// Will encourage mix of ranged and melee attacks.  

/decl/mob_organ_names/skathari
	hit_zones = list("carapace", "abdomen", "left forelegs", "right forelegs", "left hind legs", "right hind legs", "head")
>>>>>>> 0e647789c7a... Merge pull request #8521 from Sypsoti/skathari_improvements
