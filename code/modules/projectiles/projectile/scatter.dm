
/*
 * Home of the purely submunition projectiles.
 */

/obj/item/projectile/scatter
	name = "scatter projectile"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "bullet"
	density = FALSE
	anchored = TRUE
	unacidable = TRUE
	pass_flags = PASSTABLE
	mouse_opacity = 0

	use_submunitions = TRUE

	damage = 8
	spread_submunition_damage = TRUE
	only_submunitions = TRUE
	range = 0	// Immediately deletes itself after firing, as its only job is to fire other projectiles.

	submunition_spread_max = 30
	submunition_spread_min = 2

	submunitions = list(
		/obj/item/projectile/bullet/pellet/shotgun/flak = 3
		)

/*
 * Energy
 */

/obj/item/projectile/scatter/laser
	damage = 40

	submunition_spread_max = 40
	submunition_spread_min = 10

	submunitions = list(
		/obj/item/projectile/beam/prismatic = 4
		)

/obj/item/projectile/beam/prismatic
	name = "prismatic beam"
	icon_state = "omnilaser"
	damage = 10
	damage_type = BURN
	check_armour = "laser"
	light_color = "#00C6FF"

	stutter = 2

	muzzle_type = /obj/effect/projectile/muzzle/laser_omni
	tracer_type = /obj/effect/projectile/tracer/laser_omni
	impact_type = /obj/effect/projectile/impact/laser_omni

/obj/item/projectile/scatter/ion
	damage = 20

	submunition_spread_max = 40
	submunition_spread_min = 10

	submunitions = list(
		/obj/item/projectile/bullet/shotgun/ion = 3
		)


/*
 * Flame
 */


/obj/item/projectile/scatter/flamethrower
	damage = 5
	submunition_spread_max = 100
	submunition_spread_min = 30
	force_max_submunition_spread = TRUE

	submunitions = list(
		/obj/item/projectile/bullet/incendiary/flamethrower/tiny = 7
		)


/*
 * Ballistic
 */

/obj/item/projectile/scatter/shotgun
	name = "Shotgun scatter projectile"
	hud_state = "shotgun_buckshot"
	spread_submunition_damage = FALSE
	submunition_spread_max = 60
	submunition_spread_min = 50
	submunitions = list(
		/obj/item/projectile/bullet/shotgun/scatterprojectile = 6
		)

/obj/item/projectile/bullet/shotgun/scatterprojectile
	name = "pellet"
	fire_sound = 'sound/weapons/Gunshot_shotgun.ogg'
	damage = 12
	armor_penetration = 0

/obj/item/projectile/scatter/flechette
	damage = 60

	submunition_spread_max = 40
	submunition_spread_min = 10

	submunitions = list(
		/obj/item/projectile/bullet/magnetic/flechette/small = 4
		)
