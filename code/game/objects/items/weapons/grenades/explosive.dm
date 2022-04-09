
/obj/item/weapon/grenade/explosive
	name = "fragmentation grenade"
	desc = "A fragmentation grenade, optimized for harming personnel without causing massive structural damage."
	icon_state = "frggrenade"
	item_state = "grenade"

	var/fragment_types = list(/obj/item/projectile/bullet/pellet/fragment, /obj/item/projectile/bullet/pellet/fragment, /obj/item/projectile/bullet/pellet/fragment, /obj/item/projectile/bullet/pellet/fragment/strong)
	var/num_fragments = 63  //total number of fragments produced by the grenade
	var/explosion_size = 2   //size of the center explosion

	//The radius of the circle used to launch projectiles. Lower values mean less projectiles are used but if set too low gaps may appear in the spread pattern
	var/spread_range = 7
	loadable = null
	hud_state = "grenade_frag" // TGMC Ammo HUD Port

/obj/item/weapon/grenade/explosive/detonate()
	..()

	var/turf/O = get_turf(src)
	if(!O) return

	if(explosion_size)
		on_explosion(O)
	src.fragmentate(O, num_fragments, spread_range, fragment_types)
	qdel(src)

/obj/item/weapon/grenade/explosive/proc/on_explosion(var/turf/O)
	if(explosion_size)
		explosion(O, -1, -1, explosion_size, round(explosion_size/2), 0)

// Waaaaay more pellets
/obj/item/weapon/grenade/explosive/frag
	name = "fragmentation grenade"
	desc = "A military fragmentation grenade, designed to explode in a deadly shower of fragments."
	icon_state = "frag"
	loadable = null

	fragment_types = list(/obj/item/projectile/bullet/pellet/fragment)
	num_fragments = 200  //total number of fragments produced by the grenade



/obj/proc/fragmentate(var/turf/T=get_turf(src), var/fragment_number = 30, var/spreading_range = 5, var/list/fragtypes=list(/obj/item/projectile/bullet/pellet/fragment/))
	set waitfor = 0
	var/list/target_turfs = getcircle(T, spreading_range)
	var/fragments_per_projectile = round(fragment_number/target_turfs.len)

	for(var/turf/O in target_turfs)
		sleep(0)
		var/fragment_type = pickweight(fragtypes)
		var/obj/item/projectile/bullet/pellet/fragment/P = new fragment_type(T)
		P.pellets = fragments_per_projectile
		P.shot_from = name

		P.old_style_target(O)
		P.fire()

		//Make sure to hit any mobs in the source turf
		for(var/mob/living/M in T)
			//lying on a frag grenade while the grenade is on the ground causes you to absorb most of the shrapnel.
			//you will most likely be dead, but others nearby will be spared the fragments that hit you instead.
			if(M.lying && isturf(src.loc))
				P.attack_mob(M, 0, 5)
			else if(!M.lying && src.loc != get_turf(src)) //if it's not on the turf, it must be in the mob!
				P.attack_mob(M, 0, 25) //you're holding a grenade, dude!
			else
				P.attack_mob(M, 0, 100) //otherwise, allow a decent amount of fragments to pass

/obj/item/weapon/grenade/explosive/mini
	name = "mini fragmentation grenade"
	desc = "A miniaturized fragmentation grenade, this one poses relatively little threat on its own."
	icon_state = "minifrag"
	fragment_types = list(/obj/item/projectile/bullet/pellet/fragment/weak, /obj/item/projectile/bullet/pellet/fragment/weak, /obj/item/projectile/bullet/pellet/fragment, /obj/item/projectile/bullet/pellet/fragment/strong)
	num_fragments = 20
	spread_range = 3
	explosion_size = 1
