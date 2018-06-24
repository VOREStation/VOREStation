// Does a melee attack.
/mob/living/simple_mob/proc/attack_target(atom/A)
	set waitfor = FALSE // For attack animations. Don't want the AI processor to get held up.

	if(!A.Adjacent(src))
		return FALSE
	var/turf/their_T = get_turf(A)
	if(attack_delay)
	//	their_T.color = "#FF0000"
		melee_pre_animation(A)
		handle_attack_delay(A) // This will sleep this proc for a bit, which is why waitfor is false.

	// Cooldown testing is done at click code (for players) and interface code (for AI).
	setClickCooldown(get_attack_speed())

	. = do_attack(A, their_T)

	if(attack_delay)
		melee_post_animation(A)
	//	their_T.color = "#FFFFFF"



// This does the actual attack.
// This is a seperate proc for the purposes of attack animations.
// A is the thing getting attacked, T is the turf A is/was on when attack_target was called.
/mob/living/simple_mob/proc/do_attack(atom/A, turf/T)
//	if(!A.Adjacent(src))
	if((!(A in T)) || !T.Adjacent(src)) // Most likely we have a slow attack and they dodged it or we somehow got moved.
		add_attack_logs(src, A, "Animal-attacked (dodged)", admin_notify = FALSE)
		playsound(src, 'sound/weapons/punchmiss.ogg', 75, 1)
		return FALSE

	var/damage_to_do = rand(melee_damage_lower, melee_damage_upper)

	damage_to_do = apply_bonus_melee_damage(A, damage_to_do)

	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.outgoing_melee_damage_percent))
			damage_to_do *= M.outgoing_melee_damage_percent

	if(isliving(A)) // Check defenses.
		var/mob/living/L = A

		if(prob(melee_miss_chance))
			add_attack_logs(src, L, "Animal-attacked (miss)", admin_notify = FALSE)
			do_attack_animation(src)
			return FALSE // We missed.

		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(H.check_shields(damage = damage_to_do, damage_source = src, attacker = src, def_zone = null, attack_text = "the attack"))
				return FALSE // We were blocked.

	if(A.attack_generic(src, damage_to_do, pick(attacktext)))
		apply_melee_effects(A)
		if(attack_sound)
			playsound(src, attack_sound, 75, 1)

	return TRUE

// Override for special effects after a successful attack, like injecting poison or stunning the target.
/mob/living/simple_mob/proc/apply_melee_effects(atom/A)
	return

// Override to modify the amount of damage the mob does conditionally.
// This must return the amount of outgoing damage.
// Note that this is done before mob modifiers scale the damage.
/mob/living/simple_mob/proc/apply_bonus_melee_damage(atom/A, damage_amount)
	return damage_amount

//The actual top-level ranged attack proc
/mob/living/simple_mob/proc/shoot_target(atom/A)
	set waitfor = FALSE
	setClickCooldown(get_attack_speed())

	if(attack_delay)
		ranged_pre_animation(A)
		handle_attack_delay(A) // This will sleep this proc for a bit, which is why waitfor is false.

	if(needs_reload)
		if(reload_count >= reload_max)
			try_reload()
			return FALSE

	visible_message("<span class='danger'><b>\The [src]</b> fires at \the [A]!</span>")
	shoot(A, src.loc, src)
	if(casingtype)
		new casingtype

	if(attack_delay)
		ranged_post_animation(A)

	return TRUE


//Shoot a bullet at someone (idk why user is an argument when src would fit???)
/mob/living/simple_mob/proc/shoot(atom/A, turf/start, mob/living/user, bullet = 0)
	if(A == start)
		return

	var/obj/item/projectile/P = new projectiletype(user.loc)
	playsound(user, projectilesound, 100, 1)
	if(!P)
		return
	P.launch(A)
	if(needs_reload)
		reload_count ++

//	if(distance >= special_attack_min_range && distance <= special_attack_max_range)
//		return TRUE

/mob/living/simple_mob/proc/try_reload()
	if(do_after(src, reload_time))
		if(reload_sound)
			playsound(src.loc, reload_sound, 50, 1)
		reload_count = 0
		return TRUE
	else
		return FALSE

// Can we currently do a special attack?
/mob/living/simple_mob/proc/can_special_attack(atom/A)
	// Validity check.
	if(!istype(A))
		return FALSE

	// Ability check.
	if(isnull(special_attack_min_range) || isnull(special_attack_max_range))
		return FALSE

	// Distance check.
	var/distance = get_dist(src, A)
	if(distance < special_attack_min_range || distance > special_attack_max_range)
		return FALSE

	// Cooldown check.
	if(!isnull(special_attack_cooldown) && last_special_attack + special_attack_cooldown > world.time)
		return FALSE

	// Charge check.
	if(!isnull(special_attack_charges) && special_attack_charges <= 0)
		return FALSE

	return TRUE

// Should we do one? Used to make the AI not waste their special attacks. Only checked for AI. Players are free to screw up on their own.
/mob/living/simple_mob/proc/should_special_attack(atom/A)
	return TRUE

// Special attacks, like grenades or blinding spit or whatever.
// Don't override this, override do_special_attack() for your blinding spit/etc.
/mob/living/simple_mob/proc/special_attack_target(atom/A)
	last_special_attack = world.time
	if(do_special_attack(A))
		if(special_attack_charges)
			special_attack_charges -= 1
		return TRUE
	return FALSE

// Override this for the actual special attack.
/mob/living/simple_mob/proc/do_special_attack(atom/A)
	return FALSE

// Sleeps the proc that called it for the correct amount of time.
// Also makes sure the AI doesn't do anything stupid in the middle of the delay.
/mob/living/simple_mob/proc/handle_attack_delay(atom/A)
	set_AI_busy(TRUE)

	// Click delay modifiers also affect telegraphing time.
	// This means berserked enemies will leave less time to dodge.
	var/true_attack_delay = attack_delay
	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.attack_speed_percent))
			attack_delay *= M.attack_speed_percent

	setClickCooldown(true_attack_delay) // Insurance against a really long attack being longer than default click delay.

	sleep(true_attack_delay)

	set_AI_busy(FALSE)


// Override these four for special custom animations (like the GOLEM).
/mob/living/simple_mob/proc/melee_pre_animation(atom/A)
	do_windup_animation(A, attack_delay)

/mob/living/simple_mob/proc/melee_post_animation(atom/A)

/mob/living/simple_mob/proc/ranged_pre_animation(atom/A)
	do_windup_animation(A, attack_delay) // Semi-placeholder.

/mob/living/simple_mob/proc/ranged_post_animation(atom/A)