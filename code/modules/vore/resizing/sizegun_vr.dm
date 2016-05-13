//
// Size Gun
//

/obj/item/weapon/gun/energy/sizegun
	name = "shrink ray"
	desc = "A highly advanced ray gun with two settings: Shrink and Grow. Warning: Do not insert into mouth."
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "sizegun-shrink100" // Someone can probably do better. -Ace
	item_state = null	//so the human update icon uses the icon_state instead
	fire_sound = 'sound/weapons/wave.ogg'
	charge_cost = 100
	projectile_type = /obj/item/projectile/beam/shrinklaser
	origin_tech = "redspace=1;bluespace=4"
	modifystate = "sizegun-shrink"
	self_recharge = 1
	firemodes = list(
		list(mode_name		= "grow",
			projectile_type	= /obj/item/projectile/beam/growlaser,
			modifystate		= "sizegun-grow",
			fire_sound		= 'sound/weapons/pulse3.ogg'
		),
		list(mode_name		= "shrink",
			projectile_type	= /obj/item/projectile/beam/shrinklaser,
			modifystate		= "sizegun-shrink",
			fire_sound		= 'sound/weapons/wave.ogg'
		))

//
// Beams for size gun
//

/obj/item/projectile/beam/shrinklaser
	name = "shrink beam"
	icon_state = "xray"
	nodamage = 1
	damage = 0
	check_armour = "laser"

	muzzle_type = /obj/effect/projectile/xray/muzzle
	tracer_type = /obj/effect/projectile/xray/tracer
	impact_type = /obj/effect/projectile/xray/impact

/obj/item/projectile/beam/shrinklaser/on_hit(var/atom/target, var/blocked = 0)
	if(istype(target, /mob/living))
		var/mob/living/M = target
		switch(M.size_multiplier)
			if(RESIZE_HUGE to INFINITY)
				M.resize(RESIZE_BIG)
			if(RESIZE_BIG to RESIZE_HUGE)
				M.resize(RESIZE_NORMAL)
			if(RESIZE_NORMAL to RESIZE_BIG)
				M.resize(RESIZE_SMALL)
			if((0 - INFINITY) to RESIZE_NORMAL)
				M.resize(RESIZE_TINY)
		M.update_icons()
	return 1

/obj/item/projectile/beam/growlaser
	name = "growth beam"
	icon_state = "bluelaser"
	nodamage = 1
	damage = 0
	check_armour = "laser"

	muzzle_type = /obj/effect/projectile/laser_blue/muzzle
	tracer_type = /obj/effect/projectile/laser_blue/tracer
	impact_type = /obj/effect/projectile/laser_blue/impact

/obj/item/projectile/beam/growlaser/on_hit(var/atom/target, var/blocked = 0)
	if(istype(target, /mob/living))
		var/mob/living/M = target
		switch(M.size_multiplier)
			if(RESIZE_BIG to RESIZE_HUGE)
				M.resize(RESIZE_HUGE)
			if(RESIZE_NORMAL to RESIZE_BIG)
				M.resize(RESIZE_BIG)
			if(RESIZE_SMALL to RESIZE_NORMAL)
				M.resize(RESIZE_NORMAL)
			if((0 - INFINITY) to RESIZE_TINY)
				M.resize(RESIZE_SMALL)
		M.update_icons()
	return 1
