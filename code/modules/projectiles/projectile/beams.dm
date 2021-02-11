/obj/item/projectile/beam
	name = "laser"
	icon_state = "laser"
	fire_sound = 'sound/weapons/Laser.ogg'
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	damage = 40
	damage_type = BURN
	check_armour = "laser"
	eyeblur = 4
	var/frequency = 1
	hitscan = 1
	embed_chance = 0
	invisibility = 99	//beam projectiles are invisible as they are rendered by the effect engine
	light_range = 2
	light_power = 0.5
	light_color = "#FF0D00"
	hitsound = 'sound/weapons/sear.ogg'
	hitsound_wall = 'sound/weapons/effects/searwall.ogg'

	excavation_amount = 50

	muzzle_type = /obj/effect/projectile/muzzle/laser
	tracer_type = /obj/effect/projectile/tracer/laser
	impact_type = /obj/effect/projectile/impact/laser

/obj/item/projectile/beam/practice
	name = "laser"
	icon_state = "laser"
	damage = 0
	damage_type = BURN
	check_armour = "laser"
	eyeblur = 2

/obj/item/projectile/beam/weaklaser
	name = "weak laser"
	icon_state = "laser"
	damage = 15

/obj/item/projectile/beam/smalllaser
	damage = 25

/obj/item/projectile/beam/burstlaser
	damage = 30
	armor_penetration = 10


/obj/item/projectile/beam/midlaser
	damage = 40
	armor_penetration = 10

/obj/item/projectile/beam/mininglaser
	name = "pulsating laser"
	damage = 10
	armor_penetration = 20
	fire_sound = 'sound/weapons/eluger.ogg'

	excavation_amount = 100

	muzzle_type = /obj/effect/projectile/muzzle/emitter
	tracer_type = /obj/effect/projectile/tracer/emitter
	impact_type = /obj/effect/projectile/impact/emitter

/obj/item/projectile/beam/heavylaser
	name = "heavy laser"
	icon_state = "heavylaser"
	fire_sound = 'sound/weapons/lasercannonfire.ogg'
	damage = 60
	armor_penetration = 30
	light_range = 3
	light_power = 1
	light_color = "#FF0D00"

	muzzle_type = /obj/effect/projectile/muzzle/laser_heavy
	tracer_type = /obj/effect/projectile/tracer/laser_heavy
	impact_type = /obj/effect/projectile/impact/laser_heavy

/obj/item/projectile/beam/heavylaser/fakeemitter
	name = "emitter beam"
	icon_state = "emitter"
	fire_sound = 'sound/weapons/emitter.ogg'
	light_color = "#00CC33"
	excavation_amount = 140	// 2 shots to dig a standard rock turf. Superior due to being a mounted tool beam, to make it actually viable.

	muzzle_type = /obj/effect/projectile/muzzle/emitter
	tracer_type = /obj/effect/projectile/tracer/emitter
	impact_type = /obj/effect/projectile/impact/emitter

/obj/item/projectile/beam/heavylaser/cannon
	damage = 80
	armor_penetration = 50
	light_color = "#FF0D00"

/obj/item/projectile/beam/xray
	name = "xray beam"
	icon_state = "xray"
	fire_sound = 'sound/weapons/eluger.ogg'
	damage = 25
	armor_penetration = 50
	light_color = "#00CC33"

	muzzle_type = /obj/effect/projectile/muzzle/xray
	tracer_type = /obj/effect/projectile/tracer/xray
	impact_type = /obj/effect/projectile/impact/xray

/obj/item/projectile/beam/gamma
	name = "gamma beam"
	icon_state = "xray"
	fire_sound = 'sound/weapons/eluger.ogg'
	damage = 10
	armor_penetration = 90
	irradiate = 20
	light_color = "#00CC33"

	muzzle_type = /obj/effect/projectile/muzzle/xray
	tracer_type = /obj/effect/projectile/tracer/xray
	impact_type = /obj/effect/projectile/impact/xray

/obj/item/projectile/beam/cyan
	name = "cyan beam"
	icon_state = "cyan"
	fire_sound = 'sound/weapons/eluger.ogg'
	damage = 40
	light_color = "#00C6FF"

	muzzle_type = /obj/effect/projectile/muzzle/laser_omni
	tracer_type = /obj/effect/projectile/tracer/laser_omni
	impact_type = /obj/effect/projectile/impact/laser_omni

/obj/item/projectile/beam/pulse
	name = "pulse"
	icon_state = "u_laser"
	fire_sound='sound/weapons/gauss_shoot.ogg' // Needs a more meaty sound than what pulse.ogg currently is; this will be a placeholder for now.
	damage = 100	//Badmin toy, don't care
	armor_penetration = 100
	light_color = "#0066FF"

	muzzle_type = /obj/effect/projectile/muzzle/laser_pulse
	tracer_type = /obj/effect/projectile/tracer/laser_pulse
	impact_type = /obj/effect/projectile/impact/laser_pulse

/obj/item/projectile/beam/pulse/on_hit(var/atom/target, var/blocked = 0)
	if(isturf(target))
		target.ex_act(2)
	..()

/obj/item/projectile/beam/emitter
	name = "emitter beam"
	icon_state = "emitter"
	fire_sound = 'sound/weapons/emitter.ogg'
	damage = 0 // The actual damage is computed in /code/modules/power/singularity/emitter.dm
	light_color = "#00CC33"
	excavation_amount = 70 // 3 shots to mine a turf

	muzzle_type = /obj/effect/projectile/muzzle/emitter
	tracer_type = /obj/effect/projectile/tracer/emitter
	impact_type = /obj/effect/projectile/impact/emitter

/obj/item/projectile/beam/lasertag
	name = "lasertag beam"
	damage = 0
	eyeblur = 0
	no_attack_log = 1
	damage_type = BURN
	check_armour = "laser"

	combustion = FALSE

/obj/item/projectile/beam/lasertag/blue
	icon_state = "bluelaser"
	light_color = "#0066FF"

	muzzle_type = /obj/effect/projectile/muzzle/laser_blue
	tracer_type = /obj/effect/projectile/tracer/laser_blue
	impact_type = /obj/effect/projectile/impact/laser_blue

/obj/item/projectile/beam/lasertag/blue/on_hit(var/atom/target, var/blocked = 0)
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		if(istype(M.wear_suit, /obj/item/clothing/suit/redtag))
			M.Weaken(5)
	return 1

/obj/item/projectile/beam/lasertag/red
	icon_state = "laser"
	light_color = "#FF0D00"

/obj/item/projectile/beam/lasertag/red/on_hit(var/atom/target, var/blocked = 0)
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		if(istype(M.wear_suit, /obj/item/clothing/suit/bluetag))
			M.Weaken(5)
	return 1

/obj/item/projectile/beam/lasertag/omni//A laser tag bolt that stuns EVERYONE
	icon_state = "omnilaser"
	light_color = "#00C6FF"

	muzzle_type = /obj/effect/projectile/muzzle/laser_omni
	tracer_type = /obj/effect/projectile/tracer/laser_omni
	impact_type = /obj/effect/projectile/impact/laser_omni

/obj/item/projectile/beam/lasertag/omni/on_hit(var/atom/target, var/blocked = 0)
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		if((istype(M.wear_suit, /obj/item/clothing/suit/bluetag))||(istype(M.wear_suit, /obj/item/clothing/suit/redtag)))
			M.Weaken(5)
	return 1

/obj/item/projectile/beam/sniper
	name = "sniper beam"
	icon_state = "xray"
	fire_sound = 'sound/weapons/gauss_shoot.ogg'
	damage = 50
	armor_penetration = 10
	light_color = "#00CC33"

	muzzle_type = /obj/effect/projectile/muzzle/xray
	tracer_type = /obj/effect/projectile/tracer/xray
	impact_type = /obj/effect/projectile/impact/xray

/obj/item/projectile/beam/stun
	name = "stun beam"
	icon_state = "stun"
	fire_sound = 'sound/weapons/Taser.ogg'
	nodamage = 1
	taser_effect = 1
	agony = 40
	damage_type = HALLOSS
	light_color = "#FFFFFF"
	hitsound = 'sound/weapons/zapbang.ogg'

	combustion = FALSE

	muzzle_type = /obj/effect/projectile/muzzle/stun
	tracer_type = /obj/effect/projectile/tracer/stun
	impact_type = /obj/effect/projectile/impact/stun

/obj/item/projectile/beam/stun/weak
	name = "weak stun beam"
	icon_state = "stun"
	agony = 25

/obj/item/projectile/beam/stun/med
	name = "stun beam"
	icon_state = "stun"
	agony = 30

/obj/item/projectile/beam/stun/disabler
	muzzle_type = /obj/effect/projectile/muzzle/laser_omni
	tracer_type = /obj/effect/projectile/tracer/laser_omni
	impact_type = /obj/effect/projectile/impact/laser_omni

/obj/item/projectile/beam/stun/disabler/on_hit(atom/target, blocked = 0, def_zone)
	. = ..(target, blocked, def_zone)

	if(. && istype(target, /mob/living/silicon/robot) && prob(agony))
		var/mob/living/silicon/robot/R = target
		var/drainamt = agony * (rand(5, 15) / 10)
		R.drain_power(0, 0, drainamt)
		if(istype(firer, /mob/living/silicon/robot)) // Mischevious sappers, the swarm drones are.
			var/mob/living/silicon/robot/A = firer
			if(A.cell)
				A.cell.give(drainamt * 2)

/obj/item/projectile/beam/shock
	name = "shock beam"
	icon_state = "lightning"
	damage_type = ELECTROCUTE

	muzzle_type = /obj/effect/projectile/muzzle/lightning
	tracer_type = /obj/effect/projectile/tracer/lightning
	impact_type = /obj/effect/projectile/impact/lightning

	damage = 30
	agony = 15
	eyeblur = 2
	hitsound = 'sound/weapons/zapbang.ogg'

/obj/item/projectile/beam/shock/weak
	damage = 5
	agony = 10
