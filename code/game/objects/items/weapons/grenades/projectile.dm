/obj/item/grenade/shooter
	name = "projectile grenade"	// I have no idea what else to call this, but the base type should never be used
	icon_state = "frggrenade"
	item_state = "grenade"

	var/list/projectile_types = list(/obj/item/projectile/bullet/pistol/rubber)	// What sorts of projectiles might we make?

	//The radius of the circle used to launch projectiles. Lower values mean less projectiles are used but if set too low gaps may appear in the spread pattern
	var/spread_range = 7

	loadable = FALSE

/obj/item/grenade/shooter/detonate()
	..()

	var/turf/O = get_turf(src)
	if(!O)
		return

	src.launch_many_projectiles(O, spread_range, projectile_types)

	qdel(src)



/obj/item/grenade/shooter/rubber
	name = "rubber pellet grenade"
	desc = "An anti-riot grenade that fires a cloud of rubber projectiles upon detonation."
	projectile_types = list(/obj/item/projectile/bullet/pistol/rubber)

// Exists mostly so I don't have to copy+paste the sprite vars to a billion things
/obj/item/grenade/shooter/energy
	icon_state = "flashbang"
	item_state = "flashbang"
	spread_range = 3	// Because dear god

/obj/item/grenade/shooter/energy/laser
	name = "laser grenade"
	desc = "A horrifically dangerous rave in a can."
	projectile_types = list(/obj/item/projectile/beam/midlaser)

/obj/item/grenade/shooter/energy/flash
	name = "flash grenade"
	desc = "A grenade that creates a large number of flashes upon detonation."
	projectile_types = list(/obj/item/projectile/energy/flash)

/obj/item/grenade/shooter/energy/tesla
	name = "tesla grenade"
	projectile_types = list(/obj/item/projectile/beam/chain_lightning/lesser)


// This is just fragmentate, but less specific. Don't know how to make either of them less awful, at the moment
/obj/proc/launch_many_projectiles(var/turf/T=get_turf(src), var/spreading_range = 5, var/list/projectiletypes=list(/obj/item/projectile/bullet/pistol/rubber))
	set waitfor = 0
	var/list/target_turfs = getcircle(T, spreading_range)

	for(var/turf/O in target_turfs)
		sleep(0)
		var/shot_type = pick(projectiletypes)

		var/obj/item/projectile/P = new shot_type(T)
		P.shot_from = src.name

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
