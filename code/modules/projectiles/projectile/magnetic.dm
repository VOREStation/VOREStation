// Rod for railguns. Slightly less nasty than the sniper round.
/obj/item/projectile/bullet/magnetic
	name = "rod"
	icon_state = "rod"
	fire_sound = 'sound/weapons/railgun.ogg'
	damage = 65
	stun = 1
	weaken = 1
	penetrating = 5
	armor_penetration = 70

/obj/item/projectile/bullet/magnetic/slug
	name = "slug"
	icon_state = "gauss_silenced"
	damage = 75
	armor_penetration = 90

/obj/item/projectile/bullet/magnetic/flechette
	name = "flechette"
	icon_state = "flechette"
	fire_sound = 'sound/weapons/rapidslice.ogg'
	damage = 20
	armor_penetration = 100

/obj/item/projectile/bullet/magnetic/fuelrod
	name = "fuel rod"
	icon_state = "fuel-deuterium"
	damage = 30
	stun = 1
	weaken = 0
	agony = 30
	incendiary = 1
	flammability = 0 //Deuterium and Tritium are both held in water, but the object moving so quickly will ignite the target.
	penetrating = 2
	embed_chance = 0
	armor_penetration = 40
	range = 20

	var/searing = 0 //Does this fuelrod ignore shields?
	var/detonate_travel = 0 //Will this fuelrod explode when it reaches maximum distance?
	var/detonate_mob = 0 //Will this fuelrod explode when it hits a mob?
	var/energetic_impact = 0 //Does this fuelrod cause a bright flash on impact with a mob?

/obj/item/projectile/bullet/magnetic/fuelrod/on_hit(var/atom/target, var/blocked = 0, var/def_zone = null) //Future-proofing. Special effects for impact.
	if(istype(target,/mob/living))
		var/mob/living/V = target
		if(detonate_mob)
			if(V.loc)
				explosion(V.loc, -1, -1, 2, 3)

		if(energetic_impact)
			var/eye_coverage = 0
			for(var/mob/living/carbon/M in viewers(world.view, get_turf(src)))
				eye_coverage = 0
				if(iscarbon(M))
					eye_coverage = M.eyecheck()
				if(eye_coverage < 2)
					M.flash_eyes()
					M.Stun(2)
					M.Weaken(10)

		if(searing)
			if(blocked)
				blocked = 0

	return ..(target, blocked, def_zone)

/obj/item/projectile/bullet/magnetic/fuelrod/on_impact(var/atom/A) //Future-proofing, again. In the event new fuel rods are introduced, and have special effects for when they stop flying.
	if(src.loc)
		if(detonate_travel && detonate_mob)
			visible_message("<span class='warning'>\The [src] shatters in a violent explosion!</span>")
			explosion(src.loc, 1, 1, 3, 4)
		else if(detonate_travel)
			visible_message("<span class='warning'>\The [src] explodes in a shower of embers!</span>")
			explosion(src.loc, -1, 1, 2, 3)
	..(A)

/obj/item/projectile/bullet/magnetic/fuelrod/tritium
	icon_state = "fuel-tritium"
	damage = 40
	flammability = -1
	armor_penetration = 50
	penetrating = 3

/obj/item/projectile/bullet/magnetic/fuelrod/phoron
	name = "blazing fuel rod"
	icon_state = "fuel-phoron"
	damage = 35
	incendiary = 2
	flammability = 2
	armor_penetration = 60
	penetrating = 5
	irradiate = 20
	detonate_mob = 1

/obj/item/projectile/bullet/magnetic/fuelrod/supermatter
	name = "painfully incandescent fuel rod"
	icon_state = "fuel-supermatter"
	damage = 15
	incendiary = 2
	flammability = 4
	weaken = 2
	armor_penetration = 100
	penetrating = 100 //Theoretically, this shouldn't stop flying for a while, unless someone lines it up with a wall or fires it into a mountain.
	irradiate = 120
	range = 75
	searing = 1
	detonate_travel = 1
	detonate_mob = 1
	energetic_impact = 1

/obj/item/projectile/bullet/magnetic/fuelrod/supermatter/on_hit(var/atom/target, var/blocked = 0, var/def_zone = null) //You cannot touch the supermatter without disentigrating. Assumedly, this is true for condensed rods of it flying at relativistic speeds.
	if(istype(target,/turf/simulated/wall) || istype(target,/mob/living))
		target.visible_message("<span class='danger'>The [src] burns a perfect hole through \the [target] with a blinding flash!</span>")
		playsound(target.loc, 'sound/effects/teleport.ogg', 40, 0)
	return ..(target, blocked, def_zone)

/obj/item/projectile/bullet/magnetic/fuelrod/supermatter/check_penetrate()
	return 1

/obj/item/projectile/bullet/magnetic/bore
	name = "phorogenic blast"
	icon_state = "purpleemitter"
	damage = 20
	incendiary = 1
	armor_penetration = 20
	penetrating = 0
	check_armour = "melee"
	irradiate = 20
	range = 6

/obj/item/projectile/bullet/magnetic/bore/Bump(atom/A, forced=0)
	if(istype(A, /turf/simulated/mineral))
		var/turf/simulated/mineral/MI = A
		loc = get_turf(A) // Careful.
		permutated.Add(A)
		MI.GetDrilled(TRUE)
		return 0
	else if(istype(A, /turf/simulated/wall) || istype(A, /turf/simulated/shuttle/wall))	// Cause a loud, but relatively minor explosion on the wall it hits.
		explosion(A, -1, -1, 1, 3)
		qdel(src)
		return 1
	else
		..()
