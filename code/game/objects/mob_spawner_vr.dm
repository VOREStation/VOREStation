/obj/structure/mob_spawner
	name = "mob spawner"
	desc = "This shouldn't be seen, yell at a dev."
	icon = 'icons/effects/effects.dmi'
	icon_state = "rift"
	anchored = 1

	var/last_spawn = 0
	var/spawn_delay = 10 MINUTES

	var/list/spawn_types = list(
	/mob/living/simple_animal/corgi = 100,
	/mob/living/simple_animal/cat = 25
	)

	var/total_spawns = -1 //Total mob spawns, over all time, -1 for no limit
	var/simultaneous_spawns = 3 //Max spawned mobs active at one time
	var/mob_faction

	var/destructible = 0
	var/health = 50

	var/list/spawned_mobs = list()

/obj/structure/mob_spawner/initialize()
	..()
	processing_objects.Add(src)
	last_spawn = world.time + rand(0,spawn_delay)

/obj/structure/mob_spawner/Destroy()
	processing_objects.Remove(src)
	for(var/mob/living/L in spawned_mobs)
		L.source_spawner = null
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
	L.source_spawner = src
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
	visible_message("<span class='warning'>\The [src] has been [I.attack_verb.len ? "[pick(I.attack_verb)]":"attacked"] with \the [I] by [user].</span>")
	take_damage(I.force)

/obj/structure/mob_spawner/bullet_act(var/obj/item/projectile/Proj)
	..()
	if(destructible)
		take_damage(Proj.get_structure_damage())

/obj/structure/mob_spawner/proc/take_damage(var/damage)
	health -= damage
	if(health <= 0)
		visible_message("<span class='warning'>\The [src] breaks apart!</span>")
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