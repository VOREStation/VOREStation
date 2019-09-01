/obj/item/projectile/beam/disable
    name = "disabler beam"
    icon_state = "omnilaser"
    nodamage = 1
    taser_effect = 1
    agony = 100 //One shot stuns for the time being until adjustments are fully made.
    damage_type = HALLOSS
    light_color = "#00CECE"

    muzzle_type = /obj/effect/projectile/muzzle/laser_omni
    tracer_type = /obj/effect/projectile/tracer/laser_omni
    impact_type = /obj/effect/projectile/impact/laser_omni

/obj/item/projectile/beam/stun
	agony = 35

/obj/item/projectile/beam/energy_net
	name = "energy net projection"
	icon_state = "xray"
	nodamage = 1
	agony = 5
	damage_type = HALLOSS
	light_color = "#00CC33"

	muzzle_type = /obj/effect/projectile/muzzle/xray
	tracer_type = /obj/effect/projectile/tracer/xray
	impact_type = /obj/effect/projectile/impact/xray

/obj/item/projectile/beam/energy_net/on_hit(var/atom/netted)
	do_net(netted)
	..()

/obj/item/projectile/beam/energy_net/proc/do_net(var/mob/M)
	var/obj/item/weapon/energy_net/net = new (get_turf(M))
	net.throw_impact(M)

/obj/item/projectile/beam/stun/blue
	icon_state = "bluelaser"
	light_color = "#0066FF"

	muzzle_type = /obj/effect/projectile/muzzle/laser_blue
	tracer_type = /obj/effect/projectile/tracer/laser_blue
	impact_type = /obj/effect/projectile/impact/laser_blue

/obj/item/projectile/beam/medigun
	name = "healing beam"
	icon_state = "healbeam"
	damage = 0 //stops it damaging walls
	nodamage = TRUE
	no_attack_log = TRUE
	damage_type = BURN
	check_armour = "laser"
	light_color = "#80F5FF"

	combustion = FALSE

	muzzle_type = /obj/effect/projectile/muzzle/medigun
	tracer_type = /obj/effect/projectile/tracer/medigun
	impact_type = /obj/effect/projectile/impact/medigun

/obj/item/projectile/beam/medigun/on_hit(var/atom/target, var/blocked = 0)
	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/M = target
		if(M.health < M.maxHealth)
			var/obj/effect/overlay/pulse = new /obj/effect/overlay(get_turf(M))
			pulse.icon = 'icons/effects/effects.dmi'
			pulse.icon_state = "heal"
			pulse.name = "heal"
			pulse.anchored = 1
			spawn(20)
				qdel(pulse)
			to_chat(target, "<span class='notice'>As the beam strikes you, your injuries close up!</span>")
			M.adjustBruteLoss(-15)
			M.adjustFireLoss(-15)
			M.adjustToxLoss(-5)
			M.adjustOxyLoss(-5)
	return 1