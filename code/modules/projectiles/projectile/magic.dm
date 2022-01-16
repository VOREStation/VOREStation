
/obj/item/projectile/energy/fireball
	name = "fireball"
	icon_state = "fireball2"
	damage = 15
	damage_type = BURN
	check_armour = "bomb"
	armor_penetration = 25	// It's a great ball of fire.

	combustion = TRUE

/obj/item/projectile/energy/fireball/on_hit(var/atom/target, var/blocked = 0)
	new /obj/effect/vfx/explosion(get_turf(target))
	explosion(target, -1, 0, 2)
	..()

/obj/item/projectile/energy/fireball/on_impact(var/atom/target)
	new /obj/effect/vfx/explosion(get_turf(target))
	explosion(target, -1, 0, 2)
	..()
