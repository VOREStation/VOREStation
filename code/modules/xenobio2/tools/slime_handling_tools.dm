/*	What this file contains:

	* A specialized stun prod, for handling fiesty slimes

	* A specialized stun gun, for handling many fiesty slimes

	* A stun projectile for handling xenomorphs.

*/
/obj/item/weapon/melee/baton/slime
	name = "slimebaton"
	desc = "A modified stun baton designed to stun slimes for handling."
	icon_state = "slimebaton"
	item_state = "slimebaton"
	slot_flags = SLOT_BELT
	force = 9
	lightcolor = "#33CCFF"
	origin_tech = list(TECH_COMBAT = 2, TECH_BIO = 4)
	agonyforce = 10	//It's not supposed to be great at stunning human beings.
	var/stasisforce = 60	//How much stasis it does to slimes, and 1/3rd to non-slimes.
	hitcost = 48	//Less zap for less cost

/obj/item/weapon/melee/baton/slime/attack(mob/M, mob/user)
	if(istype(M, /mob/living/simple_animal/xeno))
		var/mob/living/simple_animal/xeno/X = M
		if(istype(M, /mob/living/simple_animal/xeno/slime))
			X.stasis += stasisforce
		else
			X.stasis += (stasisforce / 6)
	..()

/obj/item/weapon/melee/baton/slime/loaded/New()
	..()
	bcell = new/obj/item/weapon/cell/device(src)
	update_icon()
	return


// Xeno stun gun + projectile
/obj/item/weapon/gun/energy/taser/xeno
	name = "xeno taser gun"
	desc = "Straight out of NT's testing laboratories, this small gun is used to subdue non-humanoid xeno life forms. While marketed towards handling slimes, it may be useful for other creatures."
	icon_state = "taserold"
	fire_sound = 'sound/weapons/taser2.ogg'
	projectile_type = /obj/item/projectile/beam/stun/xeno

/obj/item/projectile/beam/stun/xeno
	icon_state = "omni"
	agony = 4
	var/stasisforce = 40

	muzzle_type = /obj/effect/projectile/laser_omni/muzzle
	tracer_type = /obj/effect/projectile/laser_omni/tracer
	impact_type = /obj/effect/projectile/laser_omni/impact
/*
/obj/item/projectile/beam/stun/xeno/on_hit(var/atom/target, var/blocked = 0)
	if(istype(target, /mob/living/simple_animal/xeno))
		world << "is xeno"
		var/mob/living/simple_animal/xeno/X = target
		world << "[target.name]"
		if(istype(X, /mob/living/simple_animal/xeno/slime))
			world << "is slime"
			X.stasis += stasisforce
		else
			world << "is not slime"
			X.stasis += (stasisforce / 8)
	else
		world << "is not xeno"
		..()
*/