/obj/item/melee/baton/slime
	name = "slimebaton"
	desc = "A modified stun baton designed to stun slimes and other lesser slimy xeno lifeforms for handling."
	icon_state = "slimebaton"
	item_state = "slimebaton"
	slot_flags = SLOT_BELT
	force = 9
	lightcolor = "#33CCFF"
	origin_tech = list(TECH_COMBAT = 2, TECH_BIO = 2)
	agonyforce = 10	//It's not supposed to be great at stunning human beings.
	hitcost = 48	//Less zap for less cost
	description_info = "This baton will stun a slime or other slime-based lifeform for about five seconds, if hit with it while on."

/obj/item/melee/baton/slime/attack(mob/living/L, mob/user, hit_zone)
	if(istype(L) && status) // Is it on?
		if(L.mob_class & MOB_CLASS_SLIME) // Are they some kind of slime? (Prommies might pass this check someday).
			if(isslime(L))
				var/mob/living/simple_mob/slime/S = L
				S.slimebatoned(user, 5) // Feral and xenobio slimes will react differently to this.
			else
				L.Weaken(5)

		// Now for prommies.
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(H.species && H.species.name == SPECIES_PROMETHEAN)
				var/agony_to_apply = 60 - agonyforce
				H.apply_damage(agony_to_apply, HALLOSS)

	..()
/obj/item/melee/baton/slime/loaded/Initialize()
	bcell = new/obj/item/cell/device(src)
	update_icon()
	return ..()

// Research borg's version
/obj/item/melee/baton/slime/robot
	hitcost = 200
	use_external_power = TRUE

// Xeno stun gun + projectile
/obj/item/gun/energy/taser/xeno
	name = "xeno taser gun"
	desc = "Straight out of NT's testing laboratories, this small gun is used to subdue non-humanoid xeno life forms. \
	While marketed towards handling slimes, it may be useful for other creatures."
	icon_state = "taserblue"
	fire_sound = 'sound/weapons/taser2.ogg'
	charge_cost = 120 // Twice as many shots.
	projectile_type = /obj/item/projectile/beam/stun/xeno
	accuracy = 30 // Make it a bit easier to hit the slimes.
	description_info = "This gun will stun a slime or other lesser slimy lifeform for about two seconds if hit with the projectile it fires."
	description_fluff = "An easy to use weapon designed by NanoTrasen, for NanoTrasen. This weapon is based on the NT Mk30 NL, \
	it's core components swaped out for a new design made to subdue lesser slime-based xeno lifeforms at a distance.  It is \
	ineffective at stunning non-slimy lifeforms such as humanoids."
	recoil_mode = 0

/obj/item/gun/energy/taser/xeno/robot // Borg version
	self_recharge = 1
	use_external_power = 1
	recharge_time = 3
/*
VORESTATION REMOVAL
/obj/item/gun/energy/taser/xeno/sec //NT's corner-cutting option for their on-station security.
	desc = "An NT Mk30 NL retrofitted to fire beams for subduing non-humanoid slimy xeno life forms."
	icon_state = "taserblue"
	item_state = "taser"
	projectile_type = /obj/item/projectile/beam/stun/xeno/weak
	charge_cost = 480
	accuracy = 0 //Same accuracy as a normal Sec taser.
	description_fluff = "An NT Mk30 NL retrofitted after the events that occurred aboard the NRS Prometheus."

/obj/item/gun/energy/taser/xeno/sec/robot //Cyborg variant of the security xeno-taser.
	self_recharge = 1
	use_external_power = 1
	recharge_time = 3
*/

/obj/item/projectile/beam/stun/xeno
	icon_state = "omni"
	agony = 4
	nodamage = TRUE
	// For whatever reason the projectile qdels itself early if this is on, meaning on_hit() won't be called on prometheans.
	// Probably for the best so that it doesn't harm the slime.
	taser_effect = FALSE

	muzzle_type = /obj/effect/projectile/muzzle/laser_omni
	tracer_type = /obj/effect/projectile/tracer/laser_omni
	impact_type = /obj/effect/projectile/impact/laser_omni

/obj/item/projectile/beam/stun/xeno/weak //Weaker variant for non-research equipment, turrets, or rapid fire types.
	agony = 3

/obj/item/projectile/beam/stun/xeno/on_hit(var/atom/target, var/blocked = 0, var/def_zone = null)
	if(isliving(target))
		var/mob/living/L = target
		if(L.mob_class & MOB_CLASS_SLIME)
			if(isslime(L))
				var/mob/living/simple_mob/slime/S = L
				S.slimebatoned(firer, round(agony/2))
			else
				L.Weaken(round(agony/2))

		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(H.species && H.species.name == SPECIES_PROMETHEAN)
				if(agony == initial(agony)) // ??????
					agony = round((14 * agony) - agony) //60-4 = 56, 56 / 4 = 14. Prior was flat 60 - agony of the beam to equate to 60.

	..()
