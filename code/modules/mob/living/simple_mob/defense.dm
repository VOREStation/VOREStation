// Hit by a projectile.
/mob/living/simple_mob/bullet_act(var/obj/item/projectile/P)
	//Projectiles with bonus SA damage
	if(!P.nodamage)
	//	if(!P.SA_vulnerability || P.SA_vulnerability == intelligence_level)
		if(P.SA_vulnerability & mob_class)
			P.damage += P.SA_bonus_damage

	. = ..()


// When someone clicks us with an empty hand
/mob/living/simple_mob/attack_hand(mob/living/L)
	..()

	switch(L.a_intent)
		if(I_HELP)
			if(health > 0)
				L.visible_message("<span class='notice'>\The [L] [response_help] \the [src].</span>")

		if(I_DISARM)
			L.visible_message("<span class='notice'>\The [L] [response_disarm] \the [src].</span>")
			L.do_attack_animation(src)
			//TODO: Push the mob away or something

		if(I_GRAB)
			if (L == src)
				return
			if (!(status_flags & CANPUSH))
				return
			if(!incapacitated(INCAPACITATION_ALL) && prob(grab_resist))
				L.visible_message("<span class='warning'>\The [L] tries to grab \the [src] but fails!</span>")
				return

			var/obj/item/weapon/grab/G = new /obj/item/weapon/grab(L, src)

			L.put_in_active_hand(G)

			G.synch()
			G.affecting = src
			LAssailant = L

			L.visible_message("<span class='warning'>\The [L] has grabbed [src] passively!</span>")
			L.do_attack_animation(src)

		if(I_HURT)
			var/armor = run_armor_check(def_zone = null, attack_flag = "melee")
			if(istype(L,/mob/living/carbon/human)) //VOREStation EDIT START Is it a human?
				var/mob/living/carbon/human/attacker = L //We are a human!
				var/datum/unarmed_attack/attack = attacker.get_unarmed_attack(src, BP_TORSO) //What attack are we using? Also, just default to attacking the chest.
				var/rand_damage = rand(1, 5) //Like normal human attacks, let's randomize the damage...
				var/real_damage = rand_damage //Let's go ahead and start calculating our damage.
				var/hit_dam_type = attack.damage_type //Let's get the type of damage. Brute? Burn? Defined by the unarmed_attack.
				real_damage += attack.get_unarmed_damage(attacker) //Add the damage that their special attack has. Some have 0. Some have 15.
				if(real_damage <= damage_threshold)
					L.visible_message("<span class='warning'>\The [L] uselessly hits \the [src]!</span>")
					L.do_attack_animation(src)
					return
				apply_damage(damage = real_damage, damagetype = hit_dam_type, def_zone = null, blocked = armor, blocked = resistance, used_weapon = null, sharp = FALSE, edge = FALSE)
				L.visible_message("<span class='warning'>\The [L] [pick(attack.attack_verb)] \the [src]!</span>")
				L.do_attack_animation(src)
				return //VOREStation EDIT END
			apply_damage(damage = harm_intent_damage, damagetype = BRUTE, def_zone = null, blocked = armor, blocked = resistance, used_weapon = null, sharp = FALSE, edge = FALSE) //VOREStation EDIT Somebody set this to burn instead of brute.
			L.visible_message("<span class='warning'>\The [L] [response_harm] \the [src]!</span>")
			L.do_attack_animation(src)

<<<<<<< HEAD
	return


// When somoene clicks us with an item in hand
/mob/living/simple_mob/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/stack/medical))
		if(stat != DEAD)
			// This could be done better.
			var/obj/item/stack/medical/MED = O
			if(health < getMaxHealth())
				if(MED.use(1))
					adjustBruteLoss(-MED.heal_brute)
					visible_message("<b>\The [user]</b> applies the [MED] on [src].")
		else
			var/datum/gender/T = gender_datums[src.get_visible_gender()]
			to_chat(user, "<span class='notice'>\The [src] is dead, medical items won't bring [T.him] back to life.</span>") // the gender lookup is somewhat overkill, but it functions identically to the obsolete gender macros and future-proofs this code
	if(can_butcher(user, O))	//if the animal can be butchered, do so and return. It's likely to be gibbed.
=======
// When somoene clicks us with an item in hand.
/mob/living/simple_mob/attackby(var/obj/item/O, var/mob/user)

	// Attempt to apply healing items, nanopaste, etc.
	if(attempt_healing(user, O))
		return TRUE

	//if the animal can be butchered, do so and return. It's likely to be gibbed.
	if(can_butcher(user, O))
>>>>>>> 781fe82a78a... Merge pull request #8841 from MistakeNot4892/aminals
		harvest(user, O)
		return

	if(user.a_intent == I_HELP && harvest_tool && istype(O, harvest_tool) && stat != DEAD)
		if(world.time > (harvest_recent + harvest_cooldown))
			livestock_harvest(O, user)
			return
		else
			to_chat(user, "<span class='notice'>\The [src] can't be [harvest_verb] so soon.</span>")
			return

	if(can_tame(O, user))
		to_chat(user, "<span class='notice'>You offer \the [src] \the [O].</span>")
		if(tame_prob(O, user))
			to_chat(user, "<span class='notice'>\The [src] appears to accept \the [O], seemingly calmed.</span>")
			do_tame(O,user)
		else
			fail_tame(O, user)
		return

	return ..()


// Handles the actual harming by a melee weapon.
/mob/living/simple_mob/hit_with_weapon(obj/item/O, mob/living/user, var/effective_force, var/hit_zone)
	effective_force = O.force

	//Animals can't be stunned(?)
	if(O.damtype == HALLOSS)
		effective_force = 0
	if(supernatural && istype(O,/obj/item/weapon/nullrod))
		effective_force *= 2
		purge = 3
	if(O.force <= resistance)
		to_chat(user,"<span class='danger'>This weapon is ineffective, it does no damage.</span>")
		return 2 //???

	. = ..()


// Exploding.
/mob/living/simple_mob/ex_act(severity)
	if(!blinded)
		flash_eyes()

	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.explosion_modifier))
			severity = CLAMP(severity + M.explosion_modifier, 1, 4)

	severity = round(severity)

	if(severity > 3)
		return

	var/armor = run_armor_check(def_zone = null, attack_flag = "bomb")
	var/bombdam = 500
	switch (severity)
		if (1.0)
			bombdam = 500
		if (2.0)
			bombdam = 60
		if (3.0)
			bombdam = 30

	apply_damage(damage = bombdam, damagetype = BRUTE, def_zone = null, blocked = armor, blocked = resistance, used_weapon = null, sharp = FALSE, edge = FALSE)

	if(bombdam > maxHealth)
		gib()

// Cold stuff.
/mob/living/simple_mob/get_cold_protection()
	. = cold_resist
	. = 1 - . // Invert from 1 = immunity to 0 = immunity.

	// Doing it this way makes multiplicative stacking not get out of hand, so two modifiers that give 0.5 protection will be combined to 0.75 in the end.
	for(var/datum/modifier/M as anything in modifiers)
		if(!isnull(M.cold_protection))
			. *= 1 - M.cold_protection

	// Code that calls this expects 1 = immunity so we need to invert again.
	. = 1 - .
	. = min(., 1.0)


// Fire stuff. Not really exciting at the moment.
/mob/living/simple_mob/handle_fire()
	return
/mob/living/simple_mob/update_fire()
	return
/mob/living/simple_mob/IgniteMob()
	return
/mob/living/simple_mob/ExtinguishMob()
	return

/mob/living/simple_mob/get_heat_protection()
	. = heat_resist
	. = 1 - . // Invert from 1 = immunity to 0 = immunity.

	// Doing it this way makes multiplicative stacking not get out of hand, so two modifiers that give 0.5 protection will be combined to 0.75 in the end.
	for(var/datum/modifier/M as anything in modifiers)
		if(!isnull(M.heat_protection))
			. *= 1 - M.heat_protection

	// Code that calls this expects 1 = immunity so we need to invert again.
	. = 1 - .
	. = min(., 1.0)

// Electricity
/mob/living/simple_mob/electrocute_act(var/shock_damage, var/obj/source, var/siemens_coeff = 1.0, var/def_zone = null)
	shock_damage *= siemens_coeff
	if(shock_damage < 1)
		return 0

	apply_damage(damage = shock_damage, damagetype = BURN, def_zone = null, blocked = null, blocked = resistance, used_weapon = null, sharp = FALSE, edge = FALSE)
	playsound(src, "sparks", 50, 1, -1)

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(5, 1, loc)
	s.start()

/mob/living/simple_mob/get_shock_protection()
	. = shock_resist
	. = 1 - . // Invert from 1 = immunity to 0 = immunity.

	// Doing it this way makes multiplicative stacking not get out of hand, so two modifiers that give 0.5 protection will be combined to 0.75 in the end.
	for(var/datum/modifier/M as anything in modifiers)
		if(!isnull(M.siemens_coefficient))
			. *= M.siemens_coefficient

	// Code that calls this expects 1 = immunity so we need to invert again.
	. = 1 - .
	. = min(., 1.0)

// Shot with taser/stunvolver
/mob/living/simple_mob/stun_effect_act(var/stun_amount, var/agony_amount, var/def_zone, var/used_weapon=null)
	if(taser_kill)
		var/stunDam = 0
		var/agonyDam = 0
		var/armor = run_armor_check(def_zone = null, attack_flag = "energy")

		if(stun_amount)
			stunDam += stun_amount * 0.5
			apply_damage(damage = stunDam, damagetype = BURN, def_zone = null, blocked = armor, blocked = resistance, used_weapon = used_weapon, sharp = FALSE, edge = FALSE)

		if(agony_amount)
			agonyDam += agony_amount * 0.5
			apply_damage(damage = agonyDam, damagetype = BURN, def_zone = null, blocked = armor, blocked = resistance, used_weapon = used_weapon, sharp = FALSE, edge = FALSE)


// Electromagnetism
/mob/living/simple_mob/emp_act(severity)
	..() // To emp_act() its contents.
	if(!isSynthetic())
		return
	switch(severity)
		if(1)
		//	adjustFireLoss(rand(15, 25))
			adjustFireLoss(min(60, getMaxHealth()*0.5)) // Weak mobs will always take two direct EMP hits to kill. Stronger ones might take more.
		if(2)
			adjustFireLoss(min(30, getMaxHealth()*0.25))
		//	adjustFireLoss(rand(10, 18))
		if(3)
			adjustFireLoss(min(15, getMaxHealth()*0.125))
		//	adjustFireLoss(rand(5, 12))
		if(4)
			adjustFireLoss(min(7, getMaxHealth()*0.0625))
		//	adjustFireLoss(rand(1, 6))

// Water
/mob/living/simple_mob/get_water_protection()
	return water_resist

// "Poison" (aka what reagents would do if we wanted to deal with those).
/mob/living/simple_mob/get_poison_protection()
	return poison_resist

// Armor
/mob/living/simple_mob/getarmor(def_zone, attack_flag)
	var/armorval = armor[attack_flag]
	if(isnull(armorval))
		armorval = 0

	for(var/datum/modifier/M as anything in modifiers)
		var/modifier_armor = LAZYACCESS(M.armor_percent, attack_flag)
		if(modifier_armor)
			armorval += modifier_armor

	return armorval

/mob/living/simple_mob/getsoak(def_zone, attack_flag)
	var/armorval = armor_soak[attack_flag]
	if(isnull(armorval))
		armorval = 0

	for(var/datum/modifier/M as anything in modifiers)
		var/modifier_armor = LAZYACCESS(M.armor_flat, attack_flag)
		if(modifier_armor)
			armorval += modifier_armor

	return armorval

// Lightning
/mob/living/simple_mob/lightning_act()
	..()
	// If a non-player simple_mob was struck, inflict huge damage.
	// If the damage is fatal, it is turned to ash.
	if(!client)
		inflict_shock_damage(200) // Mobs that are very beefy or resistant to shock may survive getting struck.
		updatehealth()
		if(health <= 0)
			visible_message(span("critical", "\The [src] disintegrates into ash!"))
			ash()
			return // No point deafening something that wont exist.

// Lava
/mob/living/simple_mob/lava_act()
	..()
	// Similar to lightning, the mob is turned to ash if the lava tick was fatal and it isn't a player.
	// Unlike lightning, we don't add an additional damage spike (since lava already hurts a lot).
	if(!client)
		updatehealth()
		if(health <= 0)
			visible_message(span("critical", "\The [src] flashes into ash as the lava consumes them!"))
			ash()

// Injections.
/mob/living/simple_mob/can_inject(mob/user, error_msg, target_zone, ignore_thickness)
	if(ignore_thickness)
		return TRUE
	return !thick_armor

