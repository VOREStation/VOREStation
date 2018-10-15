// Stronger than a regular Dark Gygax, this one has three special attacks, based on intents.
// First special attack launches three arcing rockets at the current target.
// Second special attack fires a projectile that creates a short-lived microsingularity that pulls in everything nearby. Magboots can protect from this.
// Third special attack creates a dangerous electric field that causes escalating electric damage, before emitting a tesla shock and blinding anyone looking at the mecha.
// The AI will choose one every ten seconds.
/mob/living/simple_mob/mechanical/mecha/combat/gygax/dark/advanced
	name = "advanced dark gygax"
	desc = "An experimental exosuit that utilizes advanced materials to allow for greater protection while still being lightweight and fast. \
	It also is armed with an array of next-generation weaponry."
	icon_state = "darkgygax_adv"
	wreckage = /obj/structure/loot_pile/mecha/gygax/dark/adv
	icon_scale = 1.5
	movement_shake_radius = 14

	maxHealth = 450
	deflect_chance = 25
	has_repair_droid = TRUE
	armor = list(
				"melee"		= 50,
				"bullet"	= 50,
				"laser"		= 50,
				"energy"	= 30,
				"bomb"		= 30,
				"bio"		= 100,
				"rad"		= 100
				)

	special_attack_min_range = 1
	special_attack_max_range = 7
	special_attack_cooldown = 10 SECONDS
	projectiletype = /obj/item/projectile/force_missile
	var/obj/effect/overlay/energy_ball/energy_ball = null

/mob/living/simple_mob/mechanical/mecha/combat/gygax/dark/advanced/Destroy()
	if(energy_ball)
		energy_ball.stop_orbit()
		qdel(energy_ball)
	return ..()

/mob/living/simple_mob/mechanical/mecha/combat/gygax/dark/advanced/do_special_attack(atom/A)
	. = TRUE // So we don't fire a laser as well.
	switch(a_intent)
		if(I_DISARM) // Side gun
			electric_defense(A)
		if(I_HURT) // Rockets
			launch_rockets(A)
		if(I_GRAB) // Micro-singulo
			launch_microsingularity(A)

#define ELECTRIC_ZAP_POWER 20000

// Charges a tesla shot, while emitting a dangerous electric field. The exosuit is immune to electric damage while this is ongoing.
// It also briefly blinds anyone looking directly at the mech without flash protection.
/mob/living/simple_mob/mechanical/mecha/combat/gygax/dark/advanced/proc/electric_defense(atom/target)
	set waitfor = FALSE

	// Temporary immunity to shock to avoid killing themselves with their own attack.
	var/old_shock_resist = shock_resist
	shock_resist = 1

	// Make the energy ball. This is purely visual since the tesla ball is hyper-deadly.
	energy_ball = new(loc)
	energy_ball.adjust_scale(0.5)
	energy_ball.orbit(src, 32, TRUE, 1 SECOND)

	visible_message(span("warning", "\The [src] creates \an [energy_ball] around itself!"))

	playsound(src.loc, 'sound/effects/lightning_chargeup.ogg', 100, 1, extrarange = 30)

	// Shock nearby things that aren't ourselves.
	for(var/i = 1 to 10)
		energy_ball.adjust_scale(0.5 + (i/10))
		energy_ball.set_light(i/2, i/2, "#0000FF")
		for(var/mob/living/L in range(3, src))
			if(L == src)
				continue
			if(L.stat)
				continue // Otherwise it can get pretty laggy if there's loads of corpses around.
			L.inflict_shock_damage(i * 2)
			if(L && L.has_AI()) // Some mobs delete themselves when dying.
				L.ai_holder.react_to_attack(src)
		sleep(1 SECOND)

	// Shoot a tesla bolt, and flashes people who are looking at the mecha without sufficent eye protection.
	visible_message(span("warning", "\The [energy_ball] explodes in a flash of light, sending a shock everywhere!"))
	playsound(src.loc, 'sound/effects/lightningbolt.ogg', 100, 1, extrarange = 30)
	tesla_zap(src.loc, 5, ELECTRIC_ZAP_POWER, FALSE)
	for(var/mob/living/L in viewers(src))
		if(L == src)
			continue
		var/dir_towards_us = get_dir(L, src)
		if(L.dir && L.dir & dir_towards_us)
			to_chat(L, span("danger", "The flash of light blinds you briefly."))
			L.flash_eyes(intensity = FLASH_PROTECTION_MODERATE, override_blindness_check = FALSE, affect_silicon = TRUE)

	// Get rid of our energy ball.
	energy_ball.stop_orbit()
	qdel(energy_ball)

	sleep(1 SECOND)
	// Resist resistance to old value.
	shock_resist = old_shock_resist // Not using initial() in case the value gets modified by an admin or something.

#undef ELECTRIC_ZAP_POWER

/mob/living/simple_mob/mechanical/mecha/combat/gygax/dark/advanced/proc/launch_rockets(atom/target)
	set waitfor = FALSE

	// Telegraph our next move.
	Beam(target, icon_state = "sat_beam", time = 3.5 SECONDS)
	visible_message(span("warning", "\The [src] deploys a missile rack!"))
	playsound(src, 'sound/effects/turret/move1.wav', 50, 1)
	sleep(0.5 SECONDS)

	for(var/i = 1 to 3)
		if(target) // Might get deleted in the meantime.
			var/turf/T = get_turf(target)
			if(T)
				visible_message(span("warning", "\The [src] fires a rocket into the air!"))
				playsound(src, 'sound/weapons/rpg.ogg', 70, 1)
				face_atom(T)
				var/obj/item/projectile/arc/explosive_rocket/rocket = new(loc)
				rocket.launch(T)
				sleep(1 SECOND)

	visible_message(span("warning", "\The [src] retracts the missile rack."))
	playsound(src, 'sound/effects/turret/move2.wav', 50, 1)

// Arcing rocket projectile that produces a weak explosion when it lands.
// Shouldn't punch holes in the floor, but will still hurt.
/obj/item/projectile/arc/explosive_rocket
	name = "rocket"
	icon_state = "mortar"

/obj/item/projectile/arc/explosive_rocket/on_impact(turf/T)
	new /obj/effect/explosion(T) // Weak explosions don't produce this on their own, apparently.
	explosion(T, 0, 0, 2, adminlog = FALSE)

/mob/living/simple_mob/mechanical/mecha/combat/gygax/dark/advanced/proc/launch_microsingularity(atom/target)
	var/turf/T = get_turf(target)
	visible_message(span("warning", "\The [src] fires an energetic sphere into the air!"))
	playsound(src, 'sound/weapons/Laser.ogg', 50, 1)
	face_atom(T)
	var/obj/item/projectile/arc/microsingulo/sphere = new(loc)
	sphere.launch(T)

/obj/item/projectile/arc/microsingulo
	name = "micro singularity"
	icon_state = "bluespace"

/obj/item/projectile/arc/microsingulo/on_impact(turf/T)
	new /obj/effect/temporary_effect/pulse/microsingulo(T)


/obj/effect/temporary_effect/pulse/microsingulo
	name = "micro singularity"
	desc = "It's sucking everything in!"
	icon = 'icons/obj/objects.dmi'
	icon_state = "bhole3"
	light_range = 4
	light_power = 5
	light_color = "#2ECCFA"
	pulses_remaining = 10
	pulse_delay = 0.5 SECONDS
	var/pull_radius = 3
	var/pull_strength = STAGE_THREE

/obj/effect/temporary_effect/pulse/microsingulo/on_pulse()
	for(var/atom/A in range(pull_radius, src))
		A.singularity_pull(src, pull_strength)
