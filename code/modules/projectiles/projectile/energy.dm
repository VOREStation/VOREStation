/obj/item/projectile/energy
	name = "energy"
	icon_state = "spark"
	damage = 0
	damage_type = BURN
	check_armour = "energy"
	var/flash_strength = 10

//releases a burst of light on impact or after travelling a distance
/obj/item/projectile/energy/flash
	name = "chemical shell"
	icon_state = "bullet"
	damage = 5
	kill_count = 15 //if the shell hasn't hit anything after travelling this far it just explodes.
	var/flash_range = 0
	var/brightness = 7
	var/light_colour = "#ffffff"

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

	var/datum/effect/effect/system/spark_spread/sparks = PoolOrNew(/datum/effect/effect/system/spark_spread)
	sparks.set_up(2, 1, T)
	sparks.start()

	new /obj/effect/decal/cleanable/ash(src.loc) //always use src.loc so that ash doesn't end up inside windows
	new /obj/effect/effect/smoke/illumination(T, 5, brightness, brightness, light_colour)

//blinds people like the flash round, but can also be used for temporary illumination
/obj/item/projectile/energy/flash/flare
	damage = 10
	flash_range = 1
	brightness = 15
	flash_strength = 20

/obj/item/projectile/energy/flash/flare/on_impact(var/atom/A)
	light_colour = pick("#e58775", "#ffffff", "#90ff90", "#a09030")

	..() //initial flash

	//residual illumination
	new /obj/effect/effect/smoke/illumination(src.loc, rand(190,240) SECONDS, range=8, power=3, color=light_colour) //same lighting power as flare

/obj/item/projectile/energy/electrode
	name = "electrode"
	icon_state = "spark"
	taser_effect = 1
	agony = 40
	light_range = 2
	light_power = 0.5
	light_color = "#FFFFFF"
	//Damage will be handled on the MOB side, to prevent window shattering.

/obj/item/projectile/energy/electrode/strong
	agony = 55

/obj/item/projectile/energy/electrode/stunshot
	name = "stunshot"
	damage = 5
	agony = 80

/obj/item/projectile/energy/declone
	name = "declone"
	icon_state = "declone"
	nodamage = 1
	damage_type = CLONE
	irradiate = 40
	light_range = 2
	light_power = 0.5
	light_color = "#33CC00"


/obj/item/projectile/energy/dart
	name = "dart"
	icon_state = "toxin"
	damage = 5
	damage_type = TOX
	agony = 120
	check_armour = "energy"


/obj/item/projectile/energy/bolt
	name = "bolt"
	icon_state = "cbbolt"
	damage = 10
	damage_type = TOX
	agony = 40
	stutter = 10


/obj/item/projectile/energy/bolt/large
	name = "largebolt"
	damage = 20


/obj/item/projectile/energy/neurotoxin
	name = "neuro"
	icon_state = "neurotoxin"
	damage = 5
	damage_type = TOX
	weaken = 5

/obj/item/projectile/energy/phoron
	name = "phoron bolt"
	icon_state = "energy"
	damage = 20
	damage_type = TOX
	irradiate = 20
	light_range = 2
	light_power = 0.5
	light_color = "#33CC00"

/obj/item/projectile/energy/plasmastun
	name = "plasma pulse"
	icon_state = "plasma_stun"
	armor_penetration = 10
	kill_count = 4
	damage = 5
	agony = 55
	damage_type = BURN
	vacuum_traversal = 0	//Projectile disappears in empty space

/obj/item/projectile/energy/plasmastun/proc/bang(var/mob/living/carbon/M)

	to_chat(M, "<span class='danger'>You hear a loud roar.</span>")
	playsound(M.loc, 'sound/effects/bang.ogg', 50, 1)
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
	M.update_icons()

/obj/item/projectile/energy/plasmastun/on_hit(var/atom/target)
	bang(target)
	. = ..()