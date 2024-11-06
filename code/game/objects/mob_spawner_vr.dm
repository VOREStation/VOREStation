/obj/structure/mob_spawner
	name = "mob spawner"
	desc = "This shouldn't be seen, yell at a dev."
	icon = 'icons/effects/effects.dmi'
	icon_state = "rift"
	anchored = TRUE

	var/last_spawn = 0
	var/spawn_delay = 10 MINUTES

	var/list/spawn_types = list(
	/mob/living/simple_mob/animal/passive/dog/corgi = 100,
	/mob/living/simple_mob/animal/passive/cat = 25
	)

	var/total_spawns = -1 //Total mob spawns, over all time, -1 for no limit
	var/simultaneous_spawns = 3 //Max spawned mobs active at one time
	var/mob_faction

	var/destructible = 0
	var/health = 50

	var/list/spawned_mobs = list()

/obj/structure/mob_spawner/New()
	..()
	START_PROCESSING(SSobj, src)
	last_spawn = world.time + rand(0,spawn_delay)

/obj/structure/mob_spawner/Destroy()
	STOP_PROCESSING(SSobj, src)
	for(var/mob/living/L in spawned_mobs)
		L.nest = null
	spawned_mobs.Cut()
	return ..()

/obj/structure/mob_spawner/process()
	if(!can_spawn())
		return
	var/chosen_mob = choose_spawn()
	if(chosen_mob)
		do_spawn(chosen_mob)

/obj/structure/mob_spawner/proc/can_spawn()
	if(!total_spawns)
		return 0
	if(spawned_mobs.len >= simultaneous_spawns)
		return 0
	if(world.time < last_spawn + spawn_delay)
		return 0
	return 1

/obj/structure/mob_spawner/proc/choose_spawn()
	return pickweight(spawn_types)

/obj/structure/mob_spawner/proc/do_spawn(var/mob_path)
	if(!ispath(mob_path))
		return 0
	var/mob/living/L = new mob_path(get_turf(src))
	L.nest = src
	spawned_mobs.Add(L)
	last_spawn = world.time
	if(total_spawns > 0)
		total_spawns--
	if(mob_faction)
		L.faction = mob_faction
	return L

/obj/structure/mob_spawner/proc/get_death_report(var/mob/living/L)
	if(L in spawned_mobs)
		spawned_mobs.Remove(L)

/obj/structure/mob_spawner/attackby(var/obj/item/I, var/mob/living/user)
	if(!I.force || I.flags & NOBLUDGEON || !destructible)
		return

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(src)
	visible_message(span_warning("\The [src] has been [LAZYLEN(I.attack_verb) ? "[pick(I.attack_verb)]":"attacked"] with \the [I] by [user]."))
	take_damage(I.force)

/obj/structure/mob_spawner/bullet_act(var/obj/item/projectile/Proj)
	..()
	if(destructible)
		take_damage(Proj.get_structure_damage())

/obj/structure/mob_spawner/take_damage(var/damage)
	health -= damage
	if(health <= 0)
		visible_message(span_warning("\The [src] breaks apart!"))
		qdel(src)

/obj/structure/mob_spawner/clear_zlevel/can_spawn()
	if(!..())
		return 0
	var/turf/T = get_turf(src)
	if(!T)
		return 0
	for(var/mob/living/L in player_list)
		var/turf/L_T
		if(L.stat == DEAD)
			continue
		L_T = get_turf(L)
		if(T.z == L_T.z)
			return 0
	return 1


/*
This code is based on the mob spawner and the proximity sensor, the idea is to lazy load mobs to avoid having the server use mobs when they arent needed.
It also makes it so a ghost wont know where all the goodies/mobs are.
*/

/obj/structure/mob_spawner/scanner
	name ="Lazy Mob Spawner"
	var/range = 10 //range in tiles from the spawner to detect moving stuff

/obj/structure/mob_spawner/scanner/process()
	if(!can_spawn())
		return
	if(world.time > last_spawn + spawn_delay)
		var/turf/mainloc = get_turf(src)
		for(var/mob/living/A in range(range,mainloc))
			if ((A.faction != mob_faction) && (A.move_speed < 12))
				var/chosen_mob = choose_spawn()
				if(chosen_mob)
					do_spawn(chosen_mob)

//////////////
// Spawners //
/////////////
/obj/structure/mob_spawner/scanner/corgi
	name = "Corgi Lazy Spawner"
	desc = "This is a proof of concept, not sure why you would use this one"
	spawn_delay = 3 MINUTES
	mob_faction = "Corgi"
	spawn_types = list(
	/mob/living/simple_mob/animal/passive/dog/corgi = 75,
	/mob/living/simple_mob/animal/passive/dog/corgi/puppy = 50
	)

	simultaneous_spawns = 5
	range = 7
	destructible = 1
	health = 200
	total_spawns = 100

/obj/structure/mob_spawner/scanner/wild_animals
	name = "Wilderness Lazy Spawner"
	spawn_delay = 10 MINUTES
	range = 10
	simultaneous_spawns = 1
	mob_faction = "wild animal"
	total_spawns = -1
	destructible = 0
	anchored = TRUE
	invisibility = 101
	spawn_types = list(
	/mob/living/simple_mob/animal/passive/gaslamp = 20,
//	/mob/living/simple_mob/vore/otie/feral = 10,
	/mob/living/simple_mob/vore/aggressive/dino/virgo3b = 5,
	/mob/living/simple_mob/vore/aggressive/dragon/virgo3b = 1
	)

/obj/structure/mob_spawner/scanner/xenos
	name = "Xenomorph Egg"
	spawn_delay = 10 MINUTES
	range = 10
	simultaneous_spawns = 1
	mob_faction = "xeno"
	total_spawns = -1
	destructible = 1
	health = 50
	anchored = TRUE
	icon = 'icons/mob/actions.dmi'
	icon_state = "alien_egg"
	spawn_types = list(
	/mob/living/simple_mob/animal/space/alien/drone = 20,
	/mob/living/simple_mob/animal/space/alien = 10,
	/mob/living/simple_mob/animal/space/alien/sentinel = 5,
	/mob/living/simple_mob/animal/space/alien/queen = 1
	)

/obj/structure/mob_spawner/scanner/xenos/royal
	name = "Royal Xenomorph Egg"
	spawn_delay = 10 MINUTES
	range = 10
	simultaneous_spawns = 1
	mob_faction = "xeno"
	total_spawns = 1
	destructible = 1
	health = 50
	anchored = TRUE
	icon = 'icons/mob/actions.dmi'
	icon_state = "alien_egg"
	spawn_types = list(
	/mob/living/simple_mob/animal/space/alien/queen = 5,
	)
