/obj/item/projectile/bullet
	name = "bullet"
	icon_state = "bullet"
	fire_sound = 'sound/weapons/Gunshot4.ogg'
	damage = 60
	damage_type = BRUTE
	nodamage = 0
	check_armour = "bullet"
	embed_chance = 20	//Modified in the actual embed process, but this should keep embed chance about the same
	sharp = TRUE
	hitsound_wall = "ricochet"
	impact_effect_type = /obj/effect/temp_visual/impact_effect
	excavation_amount  = 20
	var/mob_passthrough_check = 0

	muzzle_type = /obj/effect/projectile/muzzle/bullet

/obj/item/projectile/bullet/on_hit(var/atom/target, var/blocked = 0)
	if (..(target, blocked))
		var/mob/living/L = target
		shake_camera(L, 3, 2)

/obj/item/projectile/bullet/attack_mob(var/mob/living/target_mob, var/distance, var/miss_modifier)
	if(penetrating > 0 && damage > 20 && prob(damage))
		mob_passthrough_check = 1
	else
		mob_passthrough_check = 0
	return ..()

/obj/item/projectile/bullet/can_embed()
	//prevent embedding if the projectile is passing through the mob
	if(mob_passthrough_check)
		return 0
	return ..()

/obj/item/projectile/bullet/check_penetrate(var/atom/A)
	if(!A || !A.density) return 1 //if whatever it was got destroyed when we hit it, then I guess we can just keep going

	if(istype(A, /obj/mecha))
		return 1 //mecha have their own penetration handling

	if(ismob(A))
		if(!mob_passthrough_check)
			return 0
		if(iscarbon(A))
			damage *= 0.7 //squishy mobs absorb KE
		return 1

	var/chance = damage
	if(istype(A, /turf/simulated/wall))
		var/turf/simulated/wall/W = A
		chance = round(damage/W.material.integrity*180)
	else if(istype(A, /obj/machinery/door))
		var/obj/machinery/door/D = A
		chance = round(damage/D.maxhealth*180)
		if(D.glass) chance *= 2
	else if(istype(A, /obj/structure/girder))
		chance = 100

	if(prob(chance))
		if(A.opacity)
			//display a message so that people on the other side aren't so confused
			A.visible_message("<span class='warning'>\The [src] pierces through \the [A]!</span>")
		return 1

	return 0

/* short-casing projectiles, like the kind used in pistols or SMGs */

/obj/item/projectile/bullet/pistol // 9mm pistols and most SMGs. Sacrifice power for capacity.
	fire_sound = 'sound/weapons/gunshot2.ogg'
	damage = 20

/obj/item/projectile/bullet/pistol/ap
	damage = 15
	armor_penetration = 30

/obj/item/projectile/bullet/pistol/hp
	damage = 25
	armor_penetration = -50

/obj/item/projectile/bullet/pistol/medium // .45 (and maybe .40 if it ever gets added) caliber security pistols. Balance between capacity and power.
	fire_sound = 'sound/weapons/gunshot3.ogg' // Snappier sound.
	damage = 25

/obj/item/projectile/bullet/pistol/medium/ap
	damage = 20
	armor_penetration = 15

/obj/item/projectile/bullet/pistol/medium/hp
	damage = 30
	armor_penetration = -50

/obj/item/projectile/bullet/pistol/strong // .357 and .44 caliber stuff. High power pistols like the Mateba or Desert Eagle. Sacrifice capacity for power.
	fire_sound = 'sound/weapons/gunshot4.ogg'
	damage = 60

/obj/item/projectile/bullet/pistol/rubber/strong // "Rubber" bullets for high power pistols.
	fire_sound = 'sound/weapons/gunshot3.ogg' // Rubber shots have less powder, but these still have more punch than normal rubber shot.
	damage = 10
	agony = 60
	embed_chance = 0
	sharp = FALSE
	check_armour = "melee"

/obj/item/projectile/bullet/pistol/rubber // "Rubber" bullets for all other pistols.
	name = "rubber bullet"
	damage = 5
	agony = 40
	embed_chance = 0
	sharp = FALSE
	check_armour = "melee"
	fire_sound ='sound/weapons/Gunshot_pathetic.ogg' // Rubber shots have less powder in the casing.

/* shotgun projectiles */

/obj/item/projectile/bullet/shotgun
	name = "slug"
	fire_sound = 'sound/weapons/Gunshot_shotgun.ogg'
	damage = 50
	armor_penetration = 20

/obj/item/projectile/bullet/shotgun/beanbag		//because beanbags are not bullets
	name = "beanbag"
	damage = 20
	agony = 60
	embed_chance = 0
	sharp = FALSE
	check_armour = "melee"

//Should do about 80 damage at 1 tile distance (adjacent), and 50 damage at 3 tiles distance.
//Overall less damage than slugs in exchange for more damage at very close range and more embedding
/obj/item/projectile/bullet/pellet/shotgun
	name = "shrapnel"
	fire_sound = 'sound/weapons/Gunshot_shotgun.ogg'
	damage = 13
	pellets = 6
	range_step = 1
	spread_step = 10

/obj/item/projectile/bullet/pellet/shotgun/flak
	damage = 2 //The main weapon using these fires four at a time, usually with different destinations. Usually.
	range_step = 2
	spread_step = 30
	armor_penetration = 10

//EMP shotgun 'slug', it's basically a beanbag that pops a tiny emp when it hits. //Not currently used
/obj/item/projectile/bullet/shotgun/ion
	name = "ion slug"
	fire_sound = 'sound/weapons/Laser.ogg' // Really? We got nothing better than this?
	damage = 15
	embed_chance = 0
	sharp = FALSE
	check_armour = "melee"

	combustion = FALSE

/obj/item/projectile/bullet/shotgun/ion/on_hit(var/atom/target, var/blocked = 0)
	..()
	empulse(target, 0, 0, 0, 0)	//Only affects what it hits
	return 1


/* "Rifle" rounds */

/obj/item/projectile/bullet/rifle
	fire_sound = 'sound/weapons/Gunshot_generic_rifle.ogg'
	armor_penetration = 15
	penetrating = 1

/obj/item/projectile/bullet/rifle/a762
	fire_sound = 'sound/weapons/Gunshot_heavy.ogg'
	damage = 35

/obj/item/projectile/bullet/rifle/a762/sniper // Hitscan specifically for sniper ammo; to be implimented at a later date, probably for the SVD. -Ace
	fire_sound = 'sound/weapons/Gunshot_sniper.ogg'
	hitscan = 1 //so the ammo isn't useless as a sniper weapon

/obj/item/projectile/bullet/rifle/a762/ap
	damage = 30
	armor_penetration = 50 // At 30 or more armor, this will do more damage than standard rounds.

/obj/item/projectile/bullet/rifle/a762/hp
	damage = 40
	armor_penetration = -50
	penetrating = 0

/obj/item/projectile/bullet/rifle/a762/hunter // Optimized for killing simple animals and not people, because Balance(tm)
	damage = 20
	SA_bonus_damage = 50 // 70 total on animals.
	SA_vulnerability = SA_ANIMAL

/obj/item/projectile/bullet/rifle/a545
	fire_sound = 'sound/weapons/Gunshot_light.ogg'
	damage = 25

/obj/item/projectile/bullet/rifle/a545/ap
	damage = 20
	armor_penetration = 50 // At 40 or more armor, this will do more damage than standard rounds.

/obj/item/projectile/bullet/rifle/a545/hp
	damage = 35
	armor_penetration = -50
	penetrating = 0

/obj/item/projectile/bullet/rifle/a545/hunter
	damage = 15
	SA_bonus_damage = 35 // 50 total on animals.
	SA_vulnerability = SA_ANIMAL

/obj/item/projectile/bullet/rifle/a145 // 14.5�114mm is bigger than a .50 BMG round.
	fire_sound = 'sound/weapons/Gunshot_cannon.ogg' // This is literally an anti-tank rifle caliber. It better sound like a fucking cannon.
	damage = 80
	stun = 3
	weaken = 3
	penetrating = 5
	armor_penetration = 80
	hitscan = 1 //so the PTR isn't useless as a sniper weapon

	icon_state = "bullet_alt"
	tracer_type = /obj/effect/projectile/tracer/cannon

/obj/item/projectile/bullet/rifle/a145/highvel
	damage = 50
	stun = 1
	weaken = 0
	penetrating = 15
	armor_penetration = 90

/obj/item/projectile/bullet/rifle/a44rifle
	fire_sound = 'sound/weapons/gunshot4.ogg'
	damage = 50

/* Miscellaneous */

/obj/item/projectile/bullet/suffocationbullet//How does this even work?
	name = "co bullet"
	damage = 20
	damage_type = OXY

/obj/item/projectile/bullet/cyanideround
	name = "poison bullet"
	damage = 40
	damage_type = TOX

/obj/item/projectile/bullet/burstbullet
	name = "exploding bullet"
	fire_sound = 'sound/effects/Explosion1.ogg'
	damage = 20
	embed_chance = 0
	edge = TRUE

/obj/item/projectile/bullet/burstbullet/on_hit(var/atom/target, var/blocked = 0)
	if(isturf(target))
		explosion(target, -1, 0, 2)
	..()

/* Incendiary */

/obj/item/projectile/bullet/incendiary
	name = "incendiary bullet"
	icon_state = "bullet_alt"
	damage = 15
	damage_type = BURN
	incendiary = 0.5
	flammability = 2

/obj/item/projectile/bullet/incendiary/flamethrower
	name = "ball of fire"
	desc = "Don't stand in the fire."
	icon_state = "fireball"
	damage = 10
	embed_chance = 0
	incendiary = 2
	flammability = 4
	agony = 30
	range = 4
	vacuum_traversal = 0

/obj/item/projectile/bullet/incendiary/flamethrower/large
	damage = 5
	incendiary = 3
	flammability = 2
	range = 6

/obj/item/projectile/bullet/incendiary/flamethrower/tiny
	damage = 2
	incendiary = 0
	flammability = 2
	modifier_type_to_apply = /datum/modifier/fire/stack_managed/weak
	modifier_duration = 20 SECONDS
	range = 6
	agony = 0

/* Practice rounds and blanks */

/obj/item/projectile/bullet/practice
	damage = 5

/obj/item/projectile/bullet/pistol/cap // Just the primer, such as a cap gun.
	name = "cap"
	damage_type = HALLOSS
	fire_sound = 'sound/effects/snap.ogg'
	damage = 0
	nodamage = 1
	embed_chance = 0
	sharp = FALSE

	combustion = FALSE

/obj/item/projectile/bullet/pistol/cap/process()
	loc = null
	qdel(src)

/obj/item/projectile/bullet/blank
	name = "blank"
	damage_type = HALLOSS
	fire_sound = 'sound/weapons/Gunshot_generic_rifle.ogg' // Blanks still make loud noises.
	damage = 0
	nodamage = 1
	embed_chance = 0
	sharp = FALSE

/* BB Rounds */
/obj/item/projectile/bullet/bb // Generic single BB
	name = "BB"
	damage = 0
	agony = 0
	embed_chance = 0
	sharp = FALSE
	silenced = TRUE

/obj/item/projectile/bullet/pellet/shotgun/bb // Shotgun
	name = "BB"
	damage = 0
	agony = 0
	embed_chance = 0
	sharp = FALSE
	pellets = 6
	range_step = 1
	spread_step = 10
	silenced = TRUE

/* toy projectiles */
/obj/item/projectile/bullet/cap
	name = "cap"
	desc = "SNAP!"
	damage = 0 // It's a damn toy.
	embed_chance = 0
	nodamage = TRUE
	sharp = FALSE
	damage_type = HALLOSS
	impact_effect_type = null
	fire_sound = 'sound/effects/snap.ogg'
	combustion = FALSE

/obj/item/projectile/bullet/cap/process()
	loc = null
	qdel(src)

/obj/item/projectile/bullet/foam_dart
	name = "foam dart"
	desc = "I hope you're wearing eye protection."
	damage = 0 // It's a damn toy.
	embed_chance = 0
	nodamage = TRUE
	sharp = FALSE
	damage_type = HALLOSS
	impact_effect_type = null
	fire_sound = 'sound/items/syringeproj.ogg'
	combustion = FALSE
	icon = 'icons/obj/gun_toy.dmi'
	icon_state = "foamdart_proj"
	range = 15

/obj/item/projectile/bullet/foam_dart/on_impact(var/atom/A)
	. = ..()
	var/turf/T = get_turf(loc)
	if(istype(T))
		new /obj/item/ammo_casing/afoam_dart(get_turf(loc))

/obj/item/projectile/bullet/foam_dart/on_range(var/atom/A)
	. = ..()
	var/turf/T = get_turf(loc)
	if(istype(T))
		new /obj/item/ammo_casing/afoam_dart(get_turf(loc))

/obj/item/projectile/bullet/foam_dart/riot
	name = "riot foam dart"
	desc = "Whose smart idea was it to use toys as crowd control? Ages 18 and up."
	agony = 50
	icon_state = "foamdart_riot_proj"