/var/const/meteor_wave_delay = 625 //minimum wait between waves in tenths of seconds
//set to at least 100 unless you want evarr ruining every round

//Meteors probability of spawning during a given wave

//for space dust event
/var/list/meteors_dust = list(/obj/effect/meteor/dust)

//for normal meteor event
/var/list/meteors_normal = list(
	/obj/effect/meteor/dust=3,
	/obj/effect/meteor/medium=5,
	/obj/effect/meteor/medium/spalling = 3,
	/obj/effect/meteor/big=3,
	/obj/effect/meteor/flaming=1,
	/obj/effect/meteor/irradiated=3
	)

//for threatening meteor event
/var/list/meteors_threatening = list(
	/obj/effect/meteor/medium=3,
	/obj/effect/meteor/medium/spalling = 2,
	/obj/effect/meteor/big=10,
	/obj/effect/meteor/flaming=3,
	/obj/effect/meteor/irradiated=3,
	/obj/effect/meteor/emp=3)

//for catastrophic meteor event
/var/list/meteors_catastrophic = list(
	/obj/effect/meteor/medium=2,
	/obj/effect/meteor/medium/spalling = 3,
	/obj/effect/meteor/big=75,
	/obj/effect/meteor/flaming=10,
	/obj/effect/meteor/irradiated=8,
	/obj/effect/meteor/irradiated/super=2,
	/obj/effect/meteor/emp=10)



///////////////////////////////
//Meteor spawning global procs
///////////////////////////////

/proc/spawn_meteors(var/number = 10, var/list/meteortypes, var/startSide, var/zlevel)
	log_debug("Spawning [number] meteors on the [dir2text(startSide)] of [zlevel].")
	for(var/i = 0; i < number; i++)
		spawn_meteor(meteortypes, startSide, zlevel)

/proc/spawn_meteor(var/list/meteortypes, var/startSide, var/startLevel)
	if(isnull(startSide))
		startSide = pick(cardinal)
	if(isnull(startLevel))
		startLevel = pick(using_map.station_levels - using_map.underground_levels)

	var/turf/pickedstart = spaceDebrisStartLoc(startSide, startLevel)
	var/turf/pickedgoal = spaceDebrisFinishLoc(startSide, startLevel)

	var/Me = pickweight(meteortypes)
	var/obj/effect/meteor/M = new Me(pickedstart)
<<<<<<< HEAD
	M.dest = pickedgoal
	spawn(0)
		walk_towards(M, M.dest, 3) //VOREStation Edit - Slower Meteors
=======

	if(M.planetary && !pickedgoal.outdoors)
		var/list/Targ = check_trajectory(pickedgoal, pickedstart, PASSTABLE)
		if(LAZYLEN(Targ))
			var/turf/TargetTurf = get_step(get_turf(Targ[1]), get_dir(pickedgoal, pickedstart))
			if(get_dist(pickedstart, Targ[1]) < get_dist(pickedstart, pickedgoal))
				pickedgoal = TargetTurf

	M.launch_to_turf(pickedgoal, 1)

>>>>>>> 4780b1efe52... Planetary Meteors (#8422)
	return

/proc/spaceDebrisStartLoc(var/startSide, var/Z, var/planetary)
	var/starty
	var/startx
	switch(startSide)
		if(NORTH)
			starty = world.maxy-(TRANSITIONEDGE+1)
			startx = rand((TRANSITIONEDGE+1), world.maxx-(TRANSITIONEDGE+1))
		if(EAST)
			starty = rand((TRANSITIONEDGE+1),world.maxy-(TRANSITIONEDGE+1))
			startx = world.maxx-(TRANSITIONEDGE+1)
		if(SOUTH)
			starty = (TRANSITIONEDGE+1)
			startx = rand((TRANSITIONEDGE+1), world.maxx-(TRANSITIONEDGE+1))
		if(WEST)
			starty = rand((TRANSITIONEDGE+1), world.maxy-(TRANSITIONEDGE+1))
			startx = (TRANSITIONEDGE+1)
	var/turf/T = locate(startx, starty, Z)
	return T

/proc/spaceDebrisFinishLoc(var/startSide, var/Z, var/planetary)
	var/endy
	var/endx
	switch(startSide)
		if(NORTH)
			endy = TRANSITIONEDGE
			endx = rand(TRANSITIONEDGE, world.maxx-TRANSITIONEDGE)
		if(EAST)
			endy = rand(TRANSITIONEDGE, world.maxy-TRANSITIONEDGE)
			endx = TRANSITIONEDGE
		if(SOUTH)
			endy = world.maxy-TRANSITIONEDGE
			endx = rand(TRANSITIONEDGE, world.maxx-TRANSITIONEDGE)
		if(WEST)
			endy = rand(TRANSITIONEDGE,world.maxy-TRANSITIONEDGE)
			endx = world.maxx-TRANSITIONEDGE
	var/turf/T = locate(endx, endy, Z)
	return T

// Override for special behavior when getting hit by meteors, and only meteors.  Return one if the meteor hasn't been 'stopped'.
/atom/proc/handle_meteor_impact(var/obj/effect/meteor/meteor)
	return TRUE

///////////////////////
//The meteor effect
//////////////////////

/obj/effect/meteor
	name = "the concept of meteor"
	desc = "You should probably run instead of gawking at this."
	icon = 'icons/obj/meteor.dmi'
	icon_state = "small"
	density = TRUE
	anchored = TRUE
	var/hits = 4
	var/hitpwr = 2 //Level of ex_act to be called on hit.
	var/atom/dest
	var/atom/start
	var/startheight = 0
	pass_flags = PASSTABLE
	var/heavy = FALSE
	var/z_original

	// Planetary meteors slope in, and impact only their target turf. They can be hard to see before impact, but have a shadow.
	var/planetary
	var/curheight = 0	// How "high" we are
	// They also have shadows.
	var/obj/effect/projectile_shadow/shadow

	var/list/chunk_tech = list(TECH_MATERIAL = 5)

	var/meteordrop = /obj/item/weapon/ore/iron
	var/dropamt = 2

	// How much damage it does to walls, using take_damage().
	// Normal walls will die to 150 or more, where as reinforced walls need 800 to penetrate.  Durasteel walls need 1200 damage to go through.
	// Multiply this and the hits var to get a rough idea of how penetrating a meteor is.
	var/wall_power = 100

/obj/effect/meteor/Initialize()
	. = ..()
	z_original = z
	var/turf/T = get_turf(src)
	if(T.outdoors)
		planetary = TRUE
	GLOB.meteor_list += src

/obj/effect/meteor/Move()
	if(z != z_original || loc == dest)
		qdel(src)
		return

	. = ..() //process movement...

/obj/effect/meteor/Moved(atom/old_loc, direction, forced = FALSE)
	. = ..()

	handle_unique_movement(old_loc, direction)

	// Planetary roids only hit the turf they target, since they're, you know, in the air.
	if(!planetary)
		var/turf/T = get_turf(loc)
		ram_turf(T)

		if(prob(10) && !istype(T, /turf/space)) //randomly takes a 'hit' from ramming
			get_hit()
	else if(shadow)	// We are planetary, and have a shadow. So make it keep up.
		shadow.forceMove(get_turf(src))

/obj/effect/meteor/Destroy()
	if(shadow)
		QDEL_NULL(shadow)
	walk(src,FALSE) //this cancels the walk_towards() proc
	GLOB.meteor_list -= src
	return ..()

/obj/effect/meteor/New()
	..()
	SpinAnimation()

/obj/effect/meteor/Bump(atom/A)
	if(attempt_vr(src,"Bump_vr",list(A))) return //VOREStation Edit - allows meteors to be deflected by baseball bats
	if(A)
		if(A.handle_meteor_impact(src)) // Used for special behaviour when getting hit specifically by a meteor, like a shield.

			if(planetary)
				if(curheight > 1)
					forceMove(get_turf(A))
			else
				ram_turf(get_turf(A))
				get_hit()
		else
			die(FALSE)

/obj/effect/meteor/CanPass(atom/movable/mover, turf/target)
	return istype(mover, /obj/effect/meteor) ? TRUE : ..()

/obj/effect/meteor/proc/launch_to_turf(var/target, var/delay = 0)
	dest = get_turf(target)
	start = get_turf(src)
	var/turf/Current = get_turf(src)
	var/turf/Target = get_turf(target)
	if(Current.outdoors)
		startheight = rand(5,15)

	if(planetary && !Target.outdoors)
		startheight = rand(5, 20)	// Random "height" of falling meteors. Angle of attack, changes visibility.

	move_toward(Target, delay, TRUE)	// Begin the movement loop.

/obj/effect/meteor/proc/move_toward(var/target, var/delay = 0, var/allow_recursion = FALSE)
	if(!target)
		return

	var/turf/StartTurf = get_turf(src)
	var/turf/EndTurf = get_step(StartTurf, get_dir(StartTurf, target))

	if(planetary)
		if(!shadow)
			shadow = new(get_turf(src))
			shadow.pixel_y = -20

		if(loc == dest)
			die(TRUE)
			return

		var/dist_percent = calc_distance_percent()
		if(!isnull(dist_percent))
			curheight = startheight * dist_percent
			src.pixel_y = (curheight * 32)

	if(EndTurf)	// Have we somehow reached the edge of a map without a teleport boundary?
		Move(EndTurf, delay)
		if(get_turf(src) == StartTurf)	// If it doesn't move, IE, is blocked by something, take a hit.
			get_hit()
		
		if(allow_recursion)
			if(!QDELETED(src))
				addtimer(CALLBACK(src, .proc/move_toward, target, delay, allow_recursion), delay)

	else if(!QDELETED(src))	// Then delete ourselves if we haven't been deleted already.
		qdel(src)
		return

/obj/effect/meteor/proc/calc_distance_percent()
	var/current_dest_distance
	var/max_dest_distance

	if(!start)
		start = get_turf(src)

	if(!dest)
		return 0

	current_dest_distance = get_dist(get_turf(src), dest)
	max_dest_distance = get_dist(start, dest)
	return current_dest_distance / max_dest_distance

/obj/effect/meteor/proc/ram_turf(var/turf/T)
	//first bust whatever is in the turf
	for(var/atom/A in T)
		if(A == src) // Don't hit ourselves.
			continue
		if(isturf(A)) // Don't hit floors. We'll deal with walls later.
			continue
		A.ex_act(hitpwr)

	//then, ram the turf if it still exists
	if(T)
		if(istype(T, /turf/simulated/wall))
			var/turf/simulated/wall/W = T
			W.take_damage(wall_power) // Stronger walls can halt asteroids.

<<<<<<< HEAD
/obj/effect/meteor/proc/get_shield_damage()
	return max(((max(hits, 2)) * (heavy + 1) * rand(6, 12)) / hitpwr , 0)

=======
>>>>>>> 4780b1efe52... Planetary Meteors (#8422)
//process getting 'hit' by colliding with a dense object
//or randomly when ramming turfs
/obj/effect/meteor/proc/get_hit()
	hits--
	if(hits <= 0)
		die(TRUE)


// Meteor effects on traversal.
/obj/effect/meteor/proc/handle_unique_movement(var/turf/oldloc, var/direction)
	return

/obj/effect/meteor/proc/die(var/explode = TRUE)
	make_debris()
	meteor_effect(explode)
	if(!QDELETED(src))
		qdel(src)

/obj/effect/meteor/ex_act()
	return

/obj/effect/meteor/attackby(obj/item/weapon/W as obj, mob/user as mob, params)
	if(istype(W, /obj/item/weapon/pickaxe))
		qdel(src)
		return
	..()

/obj/effect/meteor/bullet_act(var/obj/item/projectile/Proj)
	if(Proj.excavation_amount)
		get_hit()

	if(!QDELETED(src))
		wall_power -= Proj.excavation_amount + Proj.damage + (Proj.hitscan * 25)	// Instant-impact projectiles are inherently better at dealing with meteors.

		if(wall_power <= 0)
			die(FALSE) // If you kill the meteor, then it dies.
			return
	return

/obj/effect/meteor/proc/make_debris()
	if(prob(5 * dropamt))
		var/obj/item/meteor_chunk/MC = new(get_turf(src))
		MC.copy_meteor(src)
		MC.throw_at(dest, 5, 10)
	for(var/throws = dropamt, throws > 0, throws--)
		var/obj/item/O = new meteordrop(get_turf(src))
		O.throw_at(dest, 5, 10)

/obj/effect/meteor/proc/shake_players()
	for(var/mob/M in player_list)
		var/turf/T = get_turf(M)
		if(!T || T.z != src.z)
			continue
		var/dist = get_dist(M.loc, src.loc)
		shake_camera(M, dist > 20 ? 3 : 5, dist > 20 ? 1 : 3)

/obj/effect/meteor/proc/meteor_effect(var/explode)
	if(heavy)
		shake_players()


///////////////////////
//Meteor types
///////////////////////

// Dust breaks windows and hurts normal walls, generally more of an annoyance than a danger unless two happen to hit the same spot.
/obj/effect/meteor/dust
	name = "space dust"
	icon_state = "dust"
	pass_flags = PASSTABLE | PASSGRILLE
	hits = 1
	hitpwr = 3
	meteordrop = /obj/item/weapon/ore/glass
	wall_power = 50

	chunk_tech = list(TECH_MATERIAL = 3)

// Medium-sized meteors aren't very special and can be stopped easily by r-walls.
/obj/effect/meteor/medium
	name = "meteor"
	dropamt = 3
	wall_power = 200

	chunk_tech = list(TECH_MATERIAL = 5)

/obj/effect/meteor/medium/meteor_effect(var/explode)
	..()
	if(explode)
		explosion(src.loc, 0, 1, 2, 3, 0)

/obj/effect/meteor/medium/spalling
	name = "spalling meteor"
	wall_power = 150

	chunk_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 3)

/obj/effect/meteor/medium/spalling/handle_unique_movement(var/turf/oldloc, var/direction)
	var/turf/T = get_turf(src)
	if(prob(20))
		for(var/I = 1 to rand(2,5))
			var/obj/item/projectile/bullet/pellet/fragment/meteor/frag = new(T)
			var/turf/Targ = pick(orange(7,src))
			frag.launch_projectile_from_turf(Targ, BP_TORSO)

// Large-sized meteors generally pack the most punch, but are more concentrated towards the epicenter.
/obj/effect/meteor/big
	name = "large meteor"
	icon_state = "large"
	hits = 8
	heavy = 1
	dropamt = 4
	wall_power = 400

	chunk_tech = list(TECH_MATERIAL = 6)

/obj/effect/meteor/big/meteor_effect(var/explode)
	..()
	if(explode)
		explosion(src.loc, 1, 2, 3, 4, 0)

// Huge-sized meteors pack -the biggest- punch, leaving a clump of rock behind.
/obj/effect/meteor/huge
	name = "massive meteor"
	icon_state = "large"
	hits = 10
	hitpwr = 0
	heavy = 1
	dropamt = 0
	wall_power = 800

	var/spawned_terrain = FALSE

	chunk_tech = list(TECH_MATERIAL = 7)

/obj/effect/meteor/huge/Initialize()
	. = ..()
	adjust_scale(2)

/obj/effect/meteor/huge/meteor_effect(var/explode)
	..()
	if(!spawned_terrain)
		spawned_terrain = TRUE
		var/dest_x = x - 2
		var/dest_y = y - 2
		var/dest_z = z
		spawn(0)	// Needs to be asynchronous due to how spawning the maps functions.
			new /datum/random_map/meteor(null, dest_x, dest_y, dest_z)

// 'Flaming' meteors do less overall damage but are spread out more due to a larger but weaker explosion at the end.
/obj/effect/meteor/flaming
	name = "flaming meteor"
	icon_state = "flaming"
	hits = 5
	heavy = 1
	meteordrop = /obj/item/weapon/ore/phoron
	wall_power = 100

	chunk_tech = list(TECH_MATERIAL = 6, TECH_PHORON = 4)

/obj/effect/meteor/flaming/meteor_effect(var/explode)
	..()
	if(explode)
		explosion(src.loc, 1, 2, 3, 4, 0, 0, 5)

// Irradiated meteors do less physical damage but project a ten-tile ranged pulse of radiation upon exploding.
/obj/effect/meteor/irradiated
	name = "glowing meteor"
	icon_state = "glowing"
	heavy = 1
	meteordrop = /obj/item/weapon/ore/uranium
	wall_power = 75

	chunk_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 5)

/obj/effect/meteor/irradiated/meteor_effect(var/explode)
	..()
	if(explode)
		explosion(src.loc, 0, 0, 4, 3, 0)
	new /obj/effect/decal/cleanable/greenglow(get_turf(src))
	SSradiation.radiate(src, 50)

// A -supermatter- irradiated meteor.
/obj/effect/meteor/irradiated/super
	name = "supermatteor"
	desc = "Act of god, or ejected core gone wrong, something terrible is going to happen."
	icon_state = "glowing_blue"

	chunk_tech = list(TECH_MATERIAL = 7, TECH_ENGINEERING = 6)

	meteordrop = /obj/item/stack/material/supermatter
	wall_power = 200

// This meteor fries toasters.
/obj/effect/meteor/emp
	name = "conducting meteor"
	icon_state = "glowing_blue"
	desc = "Hide your floppies!"
	meteordrop = /obj/item/weapon/ore/osmium
	dropamt = 3
	wall_power = 80

	chunk_tech = list(TECH_MATERIAL = 6, TECH_POWER = 5)

/obj/effect/meteor/emp/meteor_effect(var/explode)
	..()
	// Best case scenario: Comparable to a low-yield EMP grenade.
	// Worst case scenario: Comparable to a standard yield EMP grenade.
	empulse(src, rand(1, 3), rand(2, 4), rand(3, 7), rand(5, 10))

/obj/effect/meteor/emp/get_shield_damage()
	return ..() * rand(2,4)

//Station buster Tunguska
/obj/effect/meteor/tunguska
	name = "tunguska meteor"
	icon_state = "flaming"
	desc = "Your life briefly passes before your eyes the moment you lay them on this monstruosity"
	hits = 30
	hitpwr = 1
	heavy = 1
	meteordrop = /obj/item/weapon/ore/phoron
	wall_power = 150

	chunk_tech = list(TECH_MATERIAL = 10, TECH_PHORON = 8)

/obj/effect/meteor/tunguska/meteor_effect(var/explode)
	..()
	if(explode)
		explosion(src.loc, 3, 6, 9, 20, 0)

/obj/effect/meteor/tunguska/Bump()
	..()
	if(prob(20))
		explosion(src.loc,2,4,6,8)

// Meat. It's a- it's- it has- It's a meatyor.

/obj/effect/meteor/meaty
	name = "meatyor"
	desc = "A horrific amalgam of compacted flesh. Your skin crawls looking at this."
	icon_state = "meat"

	wall_power = 70
	hits = 3
	hitpwr = 1

	meteordrop = /obj/item/weapon/reagent_containers/food/snacks/meat
	dropamt = 4

// Blob! By default, it spawns a blob weaker than the lethargic by grow-rate, but slightly hardier defense-wise. Like a barnacle, from space!
/obj/effect/meteor/blobby
	name = "blobteor"
	desc = "A pulsing amalgam of gel. It writhes."
	icon_state = "blob"

	wall_power = 120
	hits = 5
	hitpwr = 1

	meteordrop = /obj/structure/blob/core/barnacle
	dropamt = 1

/*
 * Meteor core chunks.
 */

/obj/item/meteor_chunk	// It's not just a pebble.. it's a rock! From space!
	name = "meteoric iron"
	desc = "A meteor chunk. Cool."
	icon = 'icons/obj/meteor.dmi'
	icon_state = "small"
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 5)

/obj/item/meteor_chunk/proc/copy_meteor(var/obj/effect/meteor/Parent)
	if(!Parent)
		return FALSE

	name = "[Parent.name]ite chunk"	// The single case this doesn't presently work for meteors would be incredibly funny, "space dustite", and so I leave it.
	desc = "A recovered piece of a [Parent.name]."
	icon_state = Parent.icon_state

	adjust_scale(0.7)
	return TRUE

/obj/item/meteor_chunk/ex_act()	// Meteor tuff
	return
