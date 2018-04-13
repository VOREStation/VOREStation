/obj/item/weapon/melee/baton/slime
	name = "slimebaton"
	desc = "A modified stun baton designed to stun slimes and other lesser xeno lifeforms for handling."
	icon_state = "slimebaton"
	item_state = "slimebaton"
	slot_flags = SLOT_BELT
	force = 9
	lightcolor = "#33CCFF"
	origin_tech = list(TECH_COMBAT = 2, TECH_BIO = 2)
	agonyforce = 10	//It's not supposed to be great at stunning human beings.
	hitcost = 48	//Less zap for less cost
	description_info = "This baton will stun a slime or other lesser lifeform for about five seconds, if hit with it while on."

/obj/item/weapon/melee/baton/slime/attack(mob/M, mob/user, hit_zone)
	// Simple Animals.
	if(istype(M, /mob/living/simple_animal/slime) && status)
		var/mob/living/simple_animal/SA = M
		if(SA.intelligence_level <= SA_ANIMAL) // So it doesn't stun hivebots or syndies.
			SA.Weaken(5)
			if(isslime(SA))
				var/mob/living/simple_animal/slime/S = SA
				S.adjust_discipline(3)

	// Prometheans.
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species && H.species.name == SPECIES_PROMETHEAN && status)
			var/agony_to_apply = 60 - agonyforce
			H.apply_damage(agony_to_apply, HALLOSS)
	..()

/obj/item/weapon/melee/baton/slime/loaded/New()
	..()
	bcell = new/obj/item/weapon/cell/device(src)
	update_icon()
	return


// Research borg's version
/obj/item/weapon/melee/baton/slime/robot
	hitcost = 200

/obj/item/weapon/melee/baton/slime/robot/attack_self(mob/user)
	//try to find our power cell
	var/mob/living/silicon/robot/R = loc
	if (istype(R))
		bcell = R.cell
	return ..()

/obj/item/weapon/melee/baton/slime/robot/attackby(obj/item/weapon/W, mob/user)
	return


// Xeno stun gun + projectile
/obj/item/weapon/gun/energy/taser/xeno
	name = "xeno taser gun"
	desc = "Straight out of NT's testing laboratories, this small gun is used to subdue non-humanoid xeno life forms. \
	While marketed towards handling slimes, it may be useful for other creatures."
	icon_state = "taserold"
	fire_sound = 'sound/weapons/taser2.ogg'
	charge_cost = 120 // Twice as many shots.
	projectile_type = /obj/item/projectile/beam/stun/xeno
	accuracy = 30 // Make it a bit easier to hit the slimes.
	description_info = "This gun will stun a slime or other lesser lifeform for about two seconds, if hit with the projectile it fires."
	description_fluff = "An easy to use weapon designed by NanoTrasen, for NanoTrasen.  This weapon is designed to subdue lesser \
	xeno lifeforms at a distance.  It is ineffective at stunning larger lifeforms such as humanoids."

/obj/item/weapon/gun/energy/taser/xeno/robot // Borg version
	self_recharge = 1
	use_external_power = 1
	recharge_time = 3

/obj/item/weapon/gun/energy/taser/xeno/sec //NT's corner-cutting option for their on-station security.
	desc = "An NT Mk30 NL retrofitted to fire beams for subduing non-humanoid xeno life forms."
	icon_state = "taserblue"
	item_state = "taser"
	projectile_type = /obj/item/projectile/beam/stun/xeno/weak
	charge_cost = 240
	accuracy = 0 //Same accuracy as a normal Sec taser.
	description_fluff = "An NT Mk30 NL retrofitted after the events that occurred aboard the NRS Prometheus."

/obj/item/weapon/gun/energy/taser/xeno/sec/robot //Cyborg variant of the security xeno-taser.
	self_recharge = 1
	use_external_power = 1
	recharge_time = 3

/obj/item/projectile/beam/stun/xeno
	icon_state = "omni"
	agony = 4
	nodamage = TRUE
	// For whatever reason the projectile qdels itself early if this is on, meaning on_hit() won't be called on prometheans.
	// Probably for the best so that it doesn't harm the slime.
	taser_effect = FALSE

	muzzle_type = /obj/effect/projectile/laser_omni/muzzle
	tracer_type = /obj/effect/projectile/laser_omni/tracer
	impact_type = /obj/effect/projectile/laser_omni/impact

/obj/item/projectile/beam/stun/xeno/weak //Weaker variant for non-research equipment, turrets, or rapid fire types.
	agony = 3

/obj/item/projectile/beam/stun/xeno/on_hit(var/atom/target, var/blocked = 0, var/def_zone = null)
	if(istype(target, /mob/living))
		var/mob/living/L = target

		// Simple Animals.
		if(istype(L, /mob/living/simple_animal/slime))
			var/mob/living/simple_animal/SA = L
			if(SA.intelligence_level <= SA_ANIMAL) // So it doesn't stun hivebots or syndies.
				SA.Weaken(round(agony/2)) // Less powerful since its ranged, and therefore safer.
				if(isslime(SA))
					var/mob/living/simple_animal/slime/S = SA
					S.adjust_discipline(round(agony/2))

		// Prometheans.
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(H.species && H.species.name == SPECIES_PROMETHEAN)
				if(agony == initial(agony))
					agony = round((14 * agony) - agony) //60-4 = 56, 56 / 4 = 14. Prior was flat 60 - agony of the beam to equate to 60.
	..()
