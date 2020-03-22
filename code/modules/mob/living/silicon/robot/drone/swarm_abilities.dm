
/spell/aoe_turf/conjure/swarmer
	name = "Self Replication"
	desc = "This ability constructs a standard swarmer shell that may activate at some point."

	school = "conjuration"
	charge_max = 5 MINUTES
	spell_flags = 0
	invocation = "none"
	invocation_type = SpI_NONE
	range = 0

	summon_type = list(/obj/structure/ghost_pod/ghost_activated/swarm_drone/event)

	hud_state = "swarm_replicate"

/spell/aoe_turf/conjure/swarmer/conjure_animation(var/atom/movable/overlay/animation, var/turf/target)
	animation.icon_state = "deflect_static"
	flick("shield2",animation)
	spawn(1 SECOND)
		qdel(animation)

/spell/aoe_turf/conjure/forcewall/swarm
	name = "Null-Field"
	desc = "Create a bubble of null-point energy."
	summon_type = list(/obj/effect/forcefield/swarm)
	duration = 30 SECONDS
	charge_max = 60 SECONDS

	school = "conjuration"
	invocation = "none"
	invocation_type = SpI_NONE
	range = 0

	hud_state = "wiz_shield"

/obj/effect/forcefield/swarm
	desc = "A pocket of strange energy."
	name = "Null-Field"
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield-old"
	invisibility = 0

/spell/aoe_turf/conjure/zeropointwell
	name = "Zero-Point Well"
	desc = "This ability constructs a standard zero-point energy well, capable of charging nearby swarmers."

	school = "conjuration"
	charge_max = 120 SECONDS
	spell_flags = 0
	invocation = "none"
	invocation_type = SpI_NONE
	range = 0

	summon_type = list(/obj/structure/cult/pylon/swarm/zp_well)

	hud_state = "swarm_zeropoint"

/spell/aoe_turf/conjure/zeropointbarricade
	name = "Zero-Point Barricade"
	desc = "This ability constructs a standard zero-point energy wall, used to create a secure passageway for allies, and a bastion for defense."

	school = "conjuration"
	charge_max = 120 SECONDS
	spell_flags = 0
	invocation = "none"
	invocation_type = SpI_NONE
	range = 0

	summon_type = list(/obj/structure/cult/pylon/swarm/defender)

	hud_state = "swarm_barricade"

/spell/aoe_turf/blink/swarm
	name = "Warp"
	desc = "Your null-point drive jaunts you to a new location."

	school = "abjuration"
	charge_max = 5 MINUTES
	spell_flags = Z2NOCAST | IGNOREDENSE
	invocation = "none"
	invocation_type = SpI_NONE
	range = 10
	inner_radius = 5
	hud_state = "swarm_warp"

/spell/aoe_turf/conjure/swarmer/gunner
	name = "Generate Gunner"
	desc = "This spell constructs a gunner swarmer shell that may activate at some point."

	school = "conjuration"
	charge_type = Sp_CHARGES
	charge_max = 1
	spell_flags = 0
	invocation = "none"
	invocation_type = SpI_NONE
	range = 0

	summon_type = list(/obj/structure/ghost_pod/ghost_activated/swarm_drone/event/gunner)

	hud_state = "swarm_replicate"

/spell/aoe_turf/conjure/swarmer/melee
	name = "Generate Impaler"
	desc = "This spell constructs an impaler swarmer shell that may activate at some point."

	school = "conjuration"
	charge_type = Sp_CHARGES
	charge_max = 1
	spell_flags = 0
	invocation = "none"
	invocation_type = SpI_NONE
	range = 0

	summon_type = list(/obj/structure/ghost_pod/ghost_activated/swarm_drone/event/melee)

	hud_state = "swarm_replicate"
