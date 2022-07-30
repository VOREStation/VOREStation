// Stronger than a regular Dark Gygax, this one has three special attacks, based on intents.
// First special attack launches three arcing rockets at the current target.
// Second special attack fires a projectile that creates a short-lived microsingularity that pulls in everything nearby. Magboots can protect from this.
// Third special attack creates a dangerous electric field that causes escalating electric damage, before emitting a tesla shock and blinding anyone looking at the mecha.
// The AI will choose one every ten seconds.

/datum/category_item/catalogue/technology/adv_dark_gygax
	name = "Exosuit - Advanced Dark Gygax"
	desc = "This exosuit is an experimental prototype, descended from the Dark Gygax. It retains the \
	speed that is characteristic of the other models, yet outclasses all of them in durability, \
	to the point of having a comparable amount of protection to models that placed a higher emphesis \
	on armor, like the Durand and even the Marauder. It is also much larger in scale, and significantly \
	heavier than most other exosuits developed by humans, which often causes shockwaves to be felt \
	whenever it moves. This has been observed to have a demoralizing effect on hostile forces.\
	<br><br>\
	<b>Weapons & Power System</b><br>\
	Attached to the exosuit's chassis are several newly invented mounted weapons, each unique in purpose and capability. \
	These weapons are integral to the chassis as opposed to the modular equipment that more traditional exosuits utilize. \
	It is unknown if that is due to simply being an early prototype, or if discarding the modular design is benefitial \
	to the design of the model.\
	<br><br>\
	All the weapons utilize energy, as opposed to consumable projectiles. This appears to have been a conscious decision to \
	allow for more staying power, by only being limited by availablity of electricity. \
	In order to supply the needed energy for combat, the ADG contains a miniturized fusion reactor, which is also \
	considered experimental due to its size. The reactor is powerful enough to power the actuators, electronics, \
	and the primary weapon. The supplementary weapons, however, cannot be continiously fired and instead draw from \
	a electrical buffer that is constantly replenished by the reactor.\
	<br><br>\
	<b>Homing Energy Bolts</b><br>\
	The primary weapon is a projector that fires somewhat slow moving blue bolts of energy. The ADG is able to \
	passively redirect the trajectory of the blue bolts towards the initial target, essentially acting as a \
	homing projectile. The blue bolt itself is otherwise not very powerful compared to conventional photonic \
	weaponry or ballistic shells, however the power required to fire the main gun is significantly less \
	than the other available weapons, and so the ADG uses it as the main weapon.\
	<br><br>\
	<b>Self-Supplying Missile Launcher</b><br>\
	The first supplementary weapon would appear to not be an energy weapon, as it is a missile launcher. \
	What is not obvious is that the missiles are fabricated inside the exosuit, with the physical \
	materials also being created from energy, similar to the newer models of Rapid Construction Devices. \
	Therefore, the ADG does not need to concern itself with running out of missiles. The missiles themselves \
	are optimized towards harming hard targets, such as other exosuits, but are also still dangerous to soft \
	targets like infantry.\
	<br><br>\
	<b>Electric Defense</b><br>\
	The second supplementary weapon is not a conventional gun. Instead, the ADG weaponizes its electrical \
	systems by redirecting power output from its fusion reactor to its exterior shell, becoming a walking \
	tesla coil. This generates a strong electric field that harms anything unprotected nearby. \
	The electric field grows in power, until reaching a critical point, after which a blinding flash \
	of light and arcs of lightning fly out from the exosuit towards its surroundings.\
	<br><br>\
	<b>Microsingularity Projector</b><br>\
	Finally, the third supplementary weapon utilizes gravitation as a weapon, by firing a blue energetic orb \
	that, upon hitting the ground, collapses and causes a 'microsingularity' to emerge briefly, pulling in \
	anything unsecured, such as personnel or weapons. The microsingularity lacks the means to gain any energy, meaning it \
	will dissipate in a few seconds, and so it is <u>probably</u> safe to use on a planetary body.\
	<br><br>\
	<b>Flaws</b><br>\
	It would appear the ADG is poised to take the place of other exosuits like the Marauder, however several \
	massive flaws exist to make that unlikely. Firstly, this exosuit is almost an order of magnitude more \
	costly to produce than comparable alternatives, even accounting for being a prototype. \
	Secondly, a number of weapons integrated into the ADG are dangerous both to enemies and \
	allies, limiting the ability for a massed assault using ADGs. \
	Finally, the nature of several weapons used could invoke technological fear, or otherwise \
	be considered a war crime to utilize, primarily the electrical field and microsingularity \
	projector.\
	<br><br>\
	All of these flaws appear to doom the ADG to becoming another technological marvel that was \
	overly ambitious and unconstrained to the demands of reality. They will likely be really rare, \
	and terrifying."
	value = CATALOGUER_REWARD_SUPERHARD


/mob/living/simple_mob/mechanical/mecha/combat/gygax/dark/advanced
	name = "advanced dark gygax"
	desc = "An experimental exosuit that utilizes advanced materials to allow for greater protection while still being lightweight and fast. \
	It also is armed with an array of next-generation weaponry."
	catalogue_data = list(/datum/category_item/catalogue/technology/adv_dark_gygax)
	icon_state = "darkgygax_adv"
	wreckage = /obj/structure/loot_pile/mecha/gygax/dark/adv
	icon_scale_x = 1.5
	icon_scale_y = 1.5
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
	projectiletype = /obj/item/projectile/energy/homing_bolt // We're now a bullet hell game.
	projectilesound = 'sound/weapons/wave.ogg'
	ai_holder_type = /datum/ai_holder/simple_mob/intentional/adv_dark_gygax
	var/obj/effect/overlay/energy_ball/energy_ball = null

/mob/living/simple_mob/mechanical/mecha/combat/gygax/dark/advanced/Destroy()
	if(energy_ball)
		energy_ball.stop_orbit()
		qdel(energy_ball)
	return ..()

/mob/living/simple_mob/mechanical/mecha/combat/gygax/dark/advanced/do_special_attack(atom/A)
	. = TRUE // So we don't fire a bolt as well.
	switch(a_intent)
		if(I_DISARM) // Side gun
			electric_defense(A)
		if(I_HURT) // Rockets
			launch_rockets(A)
		if(I_GRAB) // Micro-singulo
			launch_microsingularity(A)

/obj/item/projectile/energy/homing_bolt
	name = "homing bolt"
	icon_state = "force_missile"
	damage = 20
	damage_type = BURN
	check_armour = "laser"

/obj/item/projectile/energy/homing_bolt/launch_projectile(atom/target, target_zone, mob/user, params, angle_override, forced_spread = 0)
	..()
	if(target)
		set_homing_target(target)

/obj/item/projectile/energy/homing_bolt/fire(angle, atom/direct_target)
	..()
	set_pixel_speed(0.5)

#define ELECTRIC_ZAP_POWER 15000 //VOREStation Edit

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

	playsound(src, 'sound/effects/lightning_chargeup.ogg', 100, 1, extrarange = 30)

	// Shock nearby things that aren't ourselves.
	for(var/i = 1 to 10)
		energy_ball.adjust_scale(0.5 + (i/10))
		energy_ball.set_light(i/2, i/2, "#0000FF")
		for(var/thing in range(3, src))
			// This is stupid because mechs are stupid and not mobs.
			if(isliving(thing))
				var/mob/living/L = thing

				if(L == src)
					continue
				if(L.stat)
					continue // Otherwise it can get pretty laggy if there's loads of corpses around.
				L.inflict_shock_damage(i * 2)
				if(L && L.has_AI()) // Some mobs delete themselves when dying.
					L.ai_holder.react_to_attack(src)

			else if(istype(thing, /obj/mecha))
				var/obj/mecha/M = thing
				M.take_damage(i * 2, "energy") // Mechs don't have a concept for siemens so energy armor check is the best alternative.

		sleep(1 SECOND)

	// Shoot a tesla bolt, and flashes people who are looking at the mecha without sufficent eye protection.
	visible_message(span("warning", "\The [energy_ball] explodes in a flash of light, sending a shock everywhere!"))
	playsound(src, 'sound/effects/lightningbolt.ogg', 100, 1, extrarange = 30)
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
	Beam(target, icon_state = "sat_beam", time = 3.5 SECONDS, maxdistance = INFINITY)
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
				rocket.old_style_target(T, src)
				rocket.fire()
				sleep(1 SECOND)

	visible_message(span("warning", "\The [src] retracts the missile rack."))
	playsound(src, 'sound/effects/turret/move2.wav', 50, 1)

// Arcing rocket projectile that produces a weak explosion when it lands.
// Shouldn't punch holes in the floor, but will still hurt.
/obj/item/projectile/arc/explosive_rocket
	name = "rocket"
	icon_state = "mortar"

/obj/item/projectile/arc/explosive_rocket/on_impact(turf/T)
	new /obj/effect/vfx/explosion(T) // Weak explosions don't produce this on their own, apparently.
	explosion(T, 0, 0, 2, adminlog = FALSE)

/mob/living/simple_mob/mechanical/mecha/combat/gygax/dark/advanced/proc/launch_microsingularity(atom/target)
	var/turf/T = get_turf(target)
	visible_message(span("warning", "\The [src] fires an energetic sphere into the air!"))
	playsound(src, 'sound/weapons/Laser.ogg', 50, 1)
	face_atom(T)
	var/obj/item/projectile/arc/microsingulo/sphere = new(loc)
	sphere.old_style_target(T, src)
	sphere.fire()

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


// The Advanced Dark Gygax's AI.
// The mob has three special attacks, based on the current intent.
// This AI choose the appropiate intent for the situation, and tries to ensure it doesn't kill itself by firing missiles at its feet.
/datum/ai_holder/simple_mob/intentional/adv_dark_gygax
	conserve_ammo = TRUE					// Might help avoid 'I shoot the wall forever' cheese.
	var/closest_desired_distance = 1		// Otherwise run up to them to be able to potentially shock or punch them.

	var/electric_defense_radius = 3			// How big to assume electric defense's area is.
	var/microsingulo_radius = 3				// Same but for microsingulo pull.
	var/rocket_explosive_radius = 2			// Explosion radius for the rockets.

	var/electric_defense_threshold = 2		// How many non-targeted people are needed in close proximity before electric defense is viable.
	var/microsingulo_threshold = 2			// Similar to above, but uses an area around the target.

// Used to control the mob's positioning based on which special attack it has done.
// Note that the intent will not change again until the next special attack is about to happen.
/datum/ai_holder/simple_mob/intentional/adv_dark_gygax/on_engagement(atom/A)
	// Make the AI backpeddle if using an AoE special attack.
	var/list/risky_intents = list(I_GRAB, I_HURT) // Mini-singulo and missiles.
	if(holder.a_intent in risky_intents)
		var/closest_distance = 1
		switch(holder.a_intent) // Plus one just in case.
			if(I_HURT)
				closest_distance = rocket_explosive_radius + 1
			if(I_GRAB)
				closest_distance = microsingulo_radius + 1

		if(get_dist(holder, A) <= closest_distance)
			holder.IMove(get_step_away(holder, A, closest_distance))

	// Otherwise get up close and personal.
	else if(get_dist(holder, A) > closest_desired_distance)
		holder.IMove(get_step_towards(holder, A))

// Changes the mob's intent, which controls which special attack is used.
// I_DISARM causes Electric Defense, I_GRAB causes Micro-Singularity, and I_HURT causes Missile Barrage.
/datum/ai_holder/simple_mob/intentional/adv_dark_gygax/pre_special_attack(atom/A)
	if(isliving(A))
		var/mob/living/target = A

		// If we're surrounded, Electric Defense will quickly fix that.
		var/tally = 0
		var/list/potential_targets = list_targets() // Returns list of mobs and certain objects like mechs and turrets.
		for(var/atom/movable/AM in potential_targets)
			if(get_dist(holder, AM) > electric_defense_radius)
				continue
			if(!can_attack(AM))
				continue
			tally++

		// Should we shock them?
		if(tally >= electric_defense_threshold || get_dist(target, holder) <= electric_defense_radius)
			holder.a_intent = I_DISARM
			return

		// Otherwise they're a fair distance away and we're not getting mobbed up close.
		// See if we should use missiles or microsingulo.
		tally = 0 // Let's recycle the var.
		for(var/atom/movable/AM in potential_targets)
			if(get_dist(target, AM) > microsingulo_radius) // Deliberately tests distance between target and nearby targets and not the holder.
				continue
			if(!can_attack(AM))
				continue
			if(AM.anchored) // Microsingulo doesn't do anything to anchored things.
				tally--
			else
				tally++

		// Lots of people means minisingulo would be more useful.
		if(tally >= microsingulo_threshold)
			holder.a_intent = I_GRAB
		else // Otherwise use rockets.
			holder.a_intent = I_HURT

	else
		if(get_dist(holder, A) >= rocket_explosive_radius + 1)
			holder.a_intent = I_HURT // Fire rockets if it's an obj/turf.
		else
			holder.a_intent = I_DISARM // Electricity might not work but it's safe up close.
