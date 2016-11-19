/obj/item/projectile/beam/disable
    name = "disabler beam"
    icon_state = "omnilaser"
    nodamage = 1
    taser_effect = 1
    agony = 60 // Does as much damage as a heavy bullet, but in agony damage.
    damage_type = HALLOSS
    light_color = "#FFFFFF"

    muzzle_type = /obj/effect/projectile/laser_omni/muzzle
    tracer_type = /obj/effect/projectile/laser_omni/tracer
    impact_type = /obj/effect/projectile/laser_omni/impact