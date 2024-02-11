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

	hud_state = "laser"
	hud_state_empty = "battery_empty"

/obj/item/projectile/beam/practice
	name = "laser"
	icon_state = "laser"
	damage = 0
	excavation_amount = 0
	damage_type = BURN
	check_armour = "laser"
	eyeblur = 2
	hud_state = "laser"

/obj/item/projectile/beam/weaklaser
	name = "weak laser"
	icon_state = "laser"
	damage = 15
	hud_state = "laser"

/obj/item/projectile/beam/weaklaser/blue
	icon_state = "bluelaser"
	light_color = "#0066FF"
	hud_state = "laser_disabler"

	muzzle_type = /obj/effect/projectile/muzzle/laser_blue
	tracer_type = /obj/effect/projectile/tracer/laser_blue
	impact_type = /obj/effect/projectile/impact/laser_blue

/obj/item/projectile/beam/weaklaser/ion
	damage_type = ELECTROMAG
	light_color = "#00CCFF"
	muzzle_type = /obj/effect/projectile/muzzle/laser_em
	tracer_type = /obj/effect/projectile/tracer/laser_em
	impact_type = /obj/effect/projectile/impact/laser_em

/obj/item/projectile/beam/smalllaser
	damage = 25
	hud_state = "laser"

/obj/item/projectile/beam/smalllaser/ion
	damage_type = ELECTROMAG
	light_color = "#00CCFF"
	muzzle_type = /obj/effect/projectile/muzzle/laser_em
	tracer_type = /obj/effect/projectile/tracer/laser_em
	impact_type = /obj/effect/projectile/impact/laser_em

/obj/item/projectile/beam/burstlaser
	damage = 30
	armor_penetration = 10
	hud_state = "laser"

/obj/item/projectile/beam/burstlaser/ion
	damage_type = ELECTROMAG
	light_color = "#00CCFF"
	muzzle_type = /obj/effect/projectile/muzzle/laser_em
	tracer_type = /obj/effect/projectile/tracer/laser_em
	impact_type = /obj/effect/projectile/impact/laser_em

/obj/item/projectile/beam/midlaser
	damage = 40
	armor_penetration = 10
	hud_state = "laser"

/obj/item/projectile/beam/midlaser/ion
	damage_type = ELECTROMAG
	light_color = "#00CCFF"
	muzzle_type = /obj/effect/projectile/muzzle/laser_em
	tracer_type = /obj/effect/projectile/tracer/laser_em
	impact_type = /obj/effect/projectile/impact/laser_em

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
	hud_state = "laser_overcharge"

/obj/item/projectile/beam/heavylaser/fakeemitter
	name = "emitter beam"
	icon_state = "emitter"
	fire_sound = 'sound/weapons/emitter.ogg'
	light_color = "#00CC33"
	excavation_amount = 140	// 2 shots to dig a standard rock turf. Superior due to being a mounted tool beam, to make it actually viable.
	hud_state = "laser_overcharge"

	muzzle_type = /obj/effect/projectile/muzzle/emitter
	tracer_type = /obj/effect/projectile/tracer/emitter
	impact_type = /obj/effect/projectile/impact/emitter

/obj/item/projectile/beam/heavylaser/ion
	damage_type = ELECTROMAG
	light_color = "#00CCFF"
	muzzle_type = /obj/effect/projectile/muzzle/laser_em
	tracer_type = /obj/effect/projectile/tracer/laser_em
	impact_type = /obj/effect/projectile/impact/laser_em

/obj/item/projectile/beam/heavylaser/cannon
	damage = 80
	armor_penetration = 50
	light_color = "#FF0D00"
	hud_state = "laser_overcharge"

/obj/item/projectile/beam/xray
	name = "xray beam"
	icon_state = "xray"
	fire_sound = 'sound/weapons/eluger.ogg'
	damage = 25
	armor_penetration = 50
	light_color = "#00CC33"
	hud_state = "laser_sniper"

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
	hud_state = "laser_sniper"

	muzzle_type = /obj/effect/projectile/muzzle/xray
	tracer_type = /obj/effect/projectile/tracer/xray
	impact_type = /obj/effect/projectile/impact/xray

/obj/item/projectile/beam/cyan
	name = "cyan beam"
	icon_state = "cyan"
	fire_sound = 'sound/weapons/eluger.ogg'
	damage = 40
	light_color = "#00C6FF"
	hud_state = "laser_disabler"

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
	hud_state = "pulse"

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
	hud_state = "laser_overcharge"

	muzzle_type = /obj/effect/projectile/muzzle/emitter
	tracer_type = /obj/effect/projectile/tracer/emitter
	impact_type = /obj/effect/projectile/impact/emitter

/obj/item/projectile/beam/lasertag
	name = "lasertag beam"
	damage = 0
	eyeblur = 0
	excavation_amount = 0
	no_attack_log = 1
	damage_type = BURN
	check_armour = "laser"
	hud_state = "monkey"

	combustion = FALSE

/obj/item/projectile/beam/lasertag/blue
	icon_state = "bluelaser"
	light_color = "#0066FF"
	hud_state = "monkey"
	muzzle_type = /obj/effect/projectile/muzzle/laser_blue
	tracer_type = /obj/effect/projectile/tracer/laser_blue
	impact_type = /obj/effect/projectile/impact/laser_blue

/obj/item/projectile/beam/lasertag/blue/on_hit(var/atom/target, var/blocked = 0)
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		if(istype(M.wear_suit, /obj/item/clothing/suit/redtag))
			M.Weaken(5)
	return 1

/obj/item/projectile/beam/lasertag/blue/multhit
	name = "blue multi-hit lasertag beam"

/obj/item/projectile/beam/lasertag/blue/multihit/on_hit(var/atom/target, var/blocked = 0)
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		if(istype(M.wear_suit, /obj/item/clothing/suit/redtag))
			var/obj/item/clothing/suit/redtag/S = M.wear_suit
			if (S.lasertag_health <= 1)
				M.Weaken(5)
				to_chat(M,"<span class='warning'>You have been defeated!</span>")
				S.lasertag_health = initial(S.lasertag_health)
			else
				S.lasertag_health--
				to_chat(M,"<span class='warning'>Danger! You have [num2text(S.lasertag_health)] hits remaining!</span>")
	return 1

/obj/item/projectile/beam/lasertag/red
	icon_state = "laser"
	light_color = "#FF0D00"
	hud_state = "monkey"

/obj/item/projectile/beam/lasertag/red/on_hit(var/atom/target, var/blocked = 0)
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		if(istype(M.wear_suit, /obj/item/clothing/suit/bluetag))
			M.Weaken(5)
	return 1

/obj/item/projectile/beam/lasertag/red/multhit
	name = "red multi-hit lasertag beam"

/obj/item/projectile/beam/lasertag/red/multihit/on_hit(var/atom/target, var/blocked = 0)
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		if(istype(M.wear_suit, /obj/item/clothing/suit/bluetag))
			var/obj/item/clothing/suit/bluetag/S = M.wear_suit
			if(S.lasertag_health <= 1)
				M.Weaken(5)
				to_chat(M,"<span class='warning'>You have been defeated!</span>")
				S.lasertag_health = initial(S.lasertag_health)
			else
				S.lasertag_health--
				to_chat(M,"<span class='warning'>Danger! You have [num2text(S.lasertag_health)] hits remaining!</span>")
	return 1

/obj/item/projectile/beam/lasertag/omni//A laser tag bolt that stuns EVERYONE
	icon_state = "omnilaser"
	light_color = "#00C6FF"
	hud_state = "monkey"

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
	hud_state = "laser_sniper"

	muzzle_type = /obj/effect/projectile/muzzle/xray
	tracer_type = /obj/effect/projectile/tracer/xray
	impact_type = /obj/effect/projectile/impact/xray

/obj/item/projectile/beam/stun
	name = "stun beam"
	icon_state = "stun"
	fire_sound = 'sound/weapons/Taser.ogg'
	nodamage = 1
	taser_effect = 1
	agony = 35
	damage_type = HALLOSS
	light_color = "#FFFFFF"
	hitsound = 'sound/weapons/zapbang.ogg'


	combustion = FALSE

	muzzle_type = /obj/effect/projectile/muzzle/stun
	tracer_type = /obj/effect/projectile/tracer/stun
	impact_type = /obj/effect/projectile/impact/stun

	hud_state = "taser" // TGMC Ammo HUD port

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

/obj/item/projectile/beam/stun/kin21
	name = "kinh21 stun beam"
	icon_state = "omnilaser"
	light_color = "#0000FF"
	muzzle_type = /obj/effect/projectile/muzzle/laser_omni
	tracer_type = /obj/effect/projectile/tracer/laser_omni
	impact_type = /obj/effect/projectile/impact/laser_omni
	hud_state = "laser_disabler"

/obj/item/projectile/beam/stun/blue
	icon_state = "bluelaser"
	light_color = "#0066FF"
	muzzle_type = /obj/effect/projectile/muzzle/laser_blue
	tracer_type = /obj/effect/projectile/tracer/laser_blue
	impact_type = /obj/effect/projectile/impact/laser_blue
	hud_state = "laser_disabler"

/obj/item/projectile/beam/disable
    name = "disabler beam"
    icon_state = "omnilaser"
    nodamage = 1
    taser_effect = 1
    agony = 100 //One shot stuns for the time being until adjustments are fully made.
    damage_type = HALLOSS
    light_color = "#00CECE"
   	hud_state = "laser_disabler"

    muzzle_type = /obj/effect/projectile/muzzle/laser_omni
    tracer_type = /obj/effect/projectile/tracer/laser_omni
    impact_type = /obj/effect/projectile/impact/laser_omni

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
	hud_state = "taser"

/obj/item/projectile/beam/shock/weak
	damage = 5
	agony = 10

/obj/item/projectile/beam/eluger
	name = "laser beam"
	icon_state = "xray"
	light_color = "#00FF00"
	muzzle_type = /obj/effect/projectile/muzzle/xray
	tracer_type = /obj/effect/projectile/tracer/xray
	impact_type = /obj/effect/projectile/impact/xray
	hud_state = "laser"

/obj/item/projectile/beam/imperial
	name = "laser beam"
	fire_sound = 'sound/weapons/mandalorian.ogg'
	icon_state = "darkb"
	light_color = "#8837A3"
	muzzle_type = /obj/effect/projectile/muzzle/darkmatter
	tracer_type = /obj/effect/projectile/tracer/darkmatter
	impact_type = /obj/effect/projectile/impact/darkmatter
	hud_state = "plasma_rifle_blast"
//
// Projectile Beam Definitions
//
/obj/item/projectile/beam/pointdefense
	name = "point defense salvo"
	icon_state = "laser"
	damage = 15
	damage_type = ELECTROCUTE //You should be safe inside a voidsuit
	sharp = FALSE //"Wide" spectrum beam
	light_color = COLOR_GOLD
	hud_state = "monkey"
	excavation_amount = 200 // Good at shooting rocks

	muzzle_type = /obj/effect/projectile/muzzle/pointdefense
	tracer_type = /obj/effect/projectile/tracer/pointdefense
	impact_type = /obj/effect/projectile/impact/pointdefense

//
// Energy Net
//
/obj/item/projectile/beam/energy_net
	name = "energy net projection"
	icon_state = "xray"
	nodamage = 1
	agony = 5
	damage_type = HALLOSS
	light_color = "#00CC33"
	hud_state = "flame_green"
	hud_state_empty = "flame_empty"

	muzzle_type = /obj/effect/projectile/muzzle/xray
	tracer_type = /obj/effect/projectile/tracer/xray
	impact_type = /obj/effect/projectile/impact/xray

/obj/item/projectile/beam/energy_net/on_hit(var/atom/netted)
	do_net(netted)
	..()

/obj/item/projectile/beam/energy_net/proc/do_net(var/mob/M)
	var/obj/item/weapon/energy_net/net = new (get_turf(M))
	net.throw_impact(M)

//
// Healing Beam
//
/obj/item/projectile/beam/medigun
	name = "healing beam"
	icon_state = "healbeam"
	damage = 0 //stops it damaging walls
	nodamage = TRUE
	no_attack_log = TRUE
	damage_type = BURN
	check_armour = "laser"
	light_color = "#80F5FF"
	hud_state = "laser_disabler"
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
			pulse.anchored = TRUE
			spawn(20)
				qdel(pulse)
			to_chat(target, "<span class='notice'>As the beam strikes you, your injuries close up!</span>")
			M.adjustBruteLoss(-15)
			M.adjustFireLoss(-15)
			M.adjustToxLoss(-5)
			M.adjustOxyLoss(-5)
	return 1