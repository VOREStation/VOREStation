/obj/item/projectile/energy
	name = "energy"
	icon_state = "spark"
	damage = 0
	damage_type = BURN
	check_armour = "energy"

	impact_effect_type = /obj/effect/temp_visual/impact_effect
	hitsound_wall = 'sound/weapons/effects/searwall.ogg'
	hitsound = 'sound/weapons/zapbang.ogg'
	hud_state = "plasma"
	hud_state_empty = "battery_empty"

	var/flash_strength = 10

//releases a burst of light on impact or after travelling a distance
/obj/item/projectile/energy/flash
	name = "chemical shell"
	icon_state = "bullet"
	fire_sound = 'sound/weapons/gunshot_pathetic.ogg'
	hitsound_wall = null
	damage = 5
	range = 15 //if the shell hasn't hit anything after travelling this far it just explodes.
	var/flash_range = 0
	var/brightness = 7
	var/light_colour = "#ffffff"
	hud_state = "grenade_dummy"

/obj/item/projectile/energy/flash/on_impact(var/atom/A)
	var/turf/T = flash_range? src.loc : get_turf(A)
	if(!istype(T)) return

	//blind adjacent people
	for (var/mob/living/carbon/M in viewers(T, flash_range))
		if(M.eyecheck() < 1)
			M.flash_eyes()
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				flash_strength *= H.species.flash_mod

				if(flash_strength > 0)
					H.Confuse(flash_strength + 5)
					H.Blind(flash_strength)
					H.eye_blurry = max(H.eye_blurry, flash_strength + 5)
					H.adjustHalLoss(22 * (flash_strength / 5)) // Five flashes to stun.  Bit weaker than melee flashes due to being ranged.

	//snap pop
	playsound(src, 'sound/effects/snap.ogg', 50, 1)
	src.visible_message("<span class='warning'>\The [src] explodes in a bright flash!</span>")

	var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
	sparks.set_up(2, 1, T)
	sparks.start()

	new /obj/effect/decal/cleanable/ash(src.loc) //always use src.loc so that ash doesn't end up inside windows
	new /obj/effect/effect/smoke/illumination(T, 5, brightness, brightness, light_colour)

//blinds people like the flash round, but can also be used for temporary illumination
/obj/item/projectile/energy/flash/flare
	fire_sound = 'sound/weapons/grenade_launcher.ogg'
	damage = 10
	flash_range = 1
	brightness = 15
	flash_strength = 20
	hud_state = "grenade_dummy"

/obj/item/projectile/energy/flash/flare/on_impact(var/atom/A)
	light_colour = pick("#e58775", "#ffffff", "#90ff90", "#a09030")

	..() //initial flash

	//residual illumination
	new /obj/effect/effect/smoke/illumination(src.loc, rand(190,240) SECONDS, range=8, power=3, color=light_colour) //same lighting power as flare

/obj/item/projectile/energy/electrode
	name = "electrode"
	icon_state = "spark"
	fire_sound = 'sound/weapons/Gunshot2.ogg'
	taser_effect = 1
	agony = 40
	light_range = 2
	light_power = 0.5
	light_color = "#FFFFFF"
	hud_state = "taser"
	//Damage will be handled on the MOB side, to prevent window shattering.

/obj/item/projectile/energy/electrode/strong
	agony = 55
	hud_state = "taser"

/obj/item/projectile/energy/electrode/stunshot
	name = "stunshot"
	damage = 5
	agony = 80
	hud_state = "taser"

/obj/item/projectile/energy/electrode/stunshot/strong
	name = "stunshot"
	icon_state = "bullet"
	damage = 10
	taser_effect = 1
	agony = 100
	hud_state = "taser"

/obj/item/projectile/energy/declone
	name = "declone"
	icon_state = "declone"
	fire_sound = 'sound/weapons/pulse3.ogg'
	nodamage = 1
	damage_type = CLONE
	irradiate = 40
	light_range = 2
	light_power = 0.5
	light_color = "#33CC00"
	impact_effect_type = /obj/effect/temp_visual/impact_effect/monochrome_laser

	combustion = FALSE
	hud_state = "plasma_pistol"

/obj/item/projectile/energy/excavate
	name = "kinetic blast"
	icon_state = "kinetic_blast"
	fire_sound = 'sound/weapons/pulse3.ogg'
	damage_type = BRUTE
	damage = 30
	armor_penetration = 60
	excavation_amount = 200
	check_armour = "melee"

	vacuum_traversal = 0
	combustion = FALSE
	hud_state = "plasma_blast"

/obj/item/projectile/energy/excavate/weak
	damage = 15
	excavation_amount = 100

/obj/item/projectile/energy/dart
	name = "dart"
	icon_state = "toxin"
	damage = 5
	damage_type = TOX
	agony = 120
	check_armour = "energy"
	hud_state = "pistol_tranq"

	combustion = FALSE

/obj/item/projectile/energy/bolt
	name = "bolt"
	icon_state = "cbbolt"
	damage = 10
	damage_type = TOX
	agony = 40
	stutter = 10
	hud_state = "electrothermal"

/obj/item/projectile/energy/bolt/large
	name = "largebolt"
	damage = 20
	hud_state = "electrothermal"

/obj/item/projectile/energy/bow
	name = "engergy bolt"
	icon_state = "cbbolt"
	damage = 20
	hud_state = "electrothermal"

/obj/item/projectile/energy/bow/heavy
	damage = 30
	icon_state = "cbbolt"
	hud_state = "electrothermal"

/obj/item/projectile/energy/bow/stun
	name = "stun bolt"
	agony = 30
	hud_state = "electrothermal"

/obj/item/projectile/energy/acid //Slightly up-gunned (Read: The thing does agony and checks bio resist) variant of the simple alien mob's projectile, for queens and sentinels.
	name = "acidic spit"
	icon_state = "neurotoxin"
	damage = 30
	damage_type = BURN
	agony = 10
	check_armour = "bio"
	armor_penetration = 25	// It's acid
	hitsound_wall = 'sound/weapons/effects/alien_spit_wall.ogg'
	hitsound = 'sound/weapons/effects/alien_spit_wall.ogg'
	hud_state = "electrothermal"

	combustion = FALSE

/obj/item/projectile/energy/neurotoxin
	name = "neurotoxic spit"
	icon_state = "neurotoxin"
	damage = 0
	damage_type = BIOACID
	agony = 80
	check_armour = "bio"
	armor_penetration = 25	// It's acid-based
	hitsound_wall = 'sound/weapons/effects/alien_spit_wall.ogg'
	hitsound = 'sound/weapons/effects/alien_spit_wall.ogg'
	hud_state = "electrothermal"

	combustion = FALSE

/obj/item/projectile/energy/neurotoxin/toxic //New alien mob projectile to match the player-variant's projectiles.
	name = "neurotoxic spit"
	icon_state = "neurotoxin"
	damage = 20
	damage_type = BIOACID
	agony = 20
	hud_state = "electrothermal"
	check_armour = "bio"
	armor_penetration = 25	// It's acid-based

/obj/item/projectile/energy/phoron
	name = "phoron bolt"
	icon_state = "energy"
	fire_sound = 'sound/effects/stealthoff.ogg'
	damage = 20
	damage_type = TOX
	irradiate = 20
	light_range = 2
	light_power = 0.5
	light_color = "#33CC00"
	impact_effect_type = /obj/effect/temp_visual/impact_effect/monochrome_laser
	hud_state = "plasma_rifle"

	combustion = FALSE

/obj/item/projectile/energy/plasmastun
	name = "plasma pulse"
	icon_state = "plasma_stun"
	fire_sound = 'sound/weapons/blaster.ogg'
	armor_penetration = 10
	range = 4
	damage = 5
	agony = 55
	damage_type = BURN
	vacuum_traversal = 0	//Projectile disappears in empty space
	hud_state = "plasma_rifle_blast"

/obj/item/projectile/energy/plasmastun/proc/bang(var/mob/living/carbon/M)

	to_chat(M, "<span class='danger'>You hear a loud roar.</span>")
	playsound(src, 'sound/effects/bang.ogg', 50, 1)
	var/ear_safety = 0
	ear_safety = M.get_ear_protection()
	if(ear_safety == 1)
		M.Confuse(150)
	else if (ear_safety > 1)
		M.Confuse(30)
	else if (!ear_safety)
		M.Stun(10)
		M.Weaken(2)
		M.ear_damage += rand(1, 10)
		M.ear_deaf = max(M.ear_deaf,15)
	if (M.ear_damage >= 15)
		to_chat(M, "<span class='danger'>Your ears start to ring badly!</span>")
		if (prob(M.ear_damage - 5))
			to_chat(M, "<span class='danger'>You can't hear anything!</span>")
			M.sdisabilities |= DEAF
	else
		if (M.ear_damage >= 5)
			to_chat(M, "<span class='danger'>Your ears start to ring!</span>")
	M.update_icons() //Just to apply matrix transform for laying asap

/obj/item/projectile/energy/plasmastun/on_hit(var/atom/target)
	bang(target)
	. = ..()

/obj/item/projectile/energy/blue_pellet
	name = "suppressive pellet"
	icon_state = "blue_pellet"
	fire_sound = 'sound/weapons/Laser4.ogg'
	damage = 5
	armor_penetration = 75
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	damage_type = BURN
	check_armour = "energy"
	light_color = "#00AAFF"

	embed_chance = 0
	muzzle_type = /obj/effect/projectile/muzzle/pulse
	impact_effect_type = /obj/effect/temp_visual/impact_effect/monochrome_laser
	hud_state = "plasma_sphere"

/obj/item/projectile/energy/phase
	name = "phase wave"
	icon_state = "phase"
	range = 6
	damage = 5
	SA_bonus_damage = 45	// 50 total on animals
	SA_vulnerability = SA_ANIMAL
	hud_state = "laser_heat"

/obj/item/projectile/energy/phase/light
	range = 4
	SA_bonus_damage = 35	// 40 total on animals
	hud_state = "laser_heat"

/obj/item/projectile/energy/phase/heavy
	range = 8
	SA_bonus_damage = 55	// 60 total on animals
	hud_state = "laser_heat"

/obj/item/projectile/energy/phase/heavy/cannon
	range = 10
	damage = 15
	SA_bonus_damage = 60	// 75 total on animals
	hud_state = "laser_heat"

/obj/item/projectile/energy/electrode/strong
	agony = 70
	hud_state = "taser"

/obj/item/projectile/energy
	flash_strength = 10
	hud_state = "taser"

/obj/item/projectile/energy/flash
	flash_range = 1
	hud_state = "grenade_dummy"

/obj/item/projectile/energy/flash/strong
	name = "chemical shell"
	icon_state = "bullet"
	damage = 10
	range = 15 //if the shell hasn't hit anything after travelling this far it just explodes.
	flash_strength = 15
	brightness = 15
	hud_state = "grenade_dummy"

/obj/item/projectile/energy/flash/flare
	flash_range = 2
	hud_state = "grenade_dummy"
