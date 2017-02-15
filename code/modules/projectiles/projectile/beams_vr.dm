/obj/item/projectile/beam/disable
    name = "disabler beam"
    icon_state = "omnilaser"
    nodamage = 1
    taser_effect = 1
    agony = 100 //One shot stuns for the time being until adjustments are fully made.
    damage_type = HALLOSS
    light_color = "#00CECE"

    muzzle_type = /obj/effect/projectile/laser_omni/muzzle
    tracer_type = /obj/effect/projectile/laser_omni/tracer
    impact_type = /obj/effect/projectile/laser_omni/impact

/obj/item/projectile/beam/stun
	agony = 35