/obj/item/gun_new/afterattack(atom/A, mob/living/user, adjacent, params)
	if(adjacent) return //A is adjacent, is the user, or is on the user's person

	// locate what they're aiming at.
	if(!user.aiming)
		user.aiming = new(user)
	if(user && user.client && user.aiming && user.aiming.active && user.aiming.aiming_at != A)
		PreFire(A,user,params)
		return

	if(user && user.a_intent == I_HELP && user.client?.prefs?.read_preference(/datum/preference/toggle/safefiring)) //regardless of what happens, refuse to shoot if help intent is on
		to_chat(user, span_warning("You refrain from firing your [src] as your intent is set to help."))
		return

	Fire(A, user, params) //Otherwise, fire normally.

//Checks whether a given mob can use the gun
//Any checks that shouldn't result in handle_click_empty() being called if they fail should go here.
//Otherwise, if you want handle_click_empty() to be called, check in consume_next_projectile() and return null there.
/obj/item/gun_new/proc/special_check(var/mob/living/user)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)

	if(!isliving(user) || !user.IsAdvancedToolUser())
		return FALSE
	if(isanimal(user))
		var/mob/living/simple_mob/S = user
		if(!S.IsHumanoidToolUser(src))
			return FALSE

	if(user.has_modifier_of_type(/datum/modifier/underwater_stealth))
		to_chat(user, span_warning("You cannot use guns whilst hiding underwater!"))
		return FALSE
	if(user.has_modifier_of_type(/datum/modifier/phased_out))
		to_chat(user, span_warning("You cannot use guns whilst incorporeal!"))
		return FALSE
	if(user.has_modifier_of_type(/datum/modifier/rednet))
		to_chat(user, span_warning("Your gun refuses to fire!"))
		return FALSE
	if(user.has_modifier_of_type(/datum/modifier/trait/thickdigits))
		to_chat(user, span_warning("Your hands can't pull the trigger!!"))
		return FALSE
	if(user.has_modifier_of_type(/datum/modifier/shield_projection/melee_focus))
		to_chat(user, span_warning("The shield projection around you prevents you from using anything but melee!!"))
		return FALSE
	if(HULK in user.mutations)
		to_chat(user, span_danger("Your fingers are much too large for the trigger guard!"))
		return FALSE

	if(dna_lock && attached_lock.stored_dna && !authorized_user(user))
		if(attached_lock.safety_level == 0)
			to_chat(user, span_danger("\The [src] buzzes in dissapointment and displays an invalid DNA symbol."))
			return FALSE
		if(!attached_lock.exploding && attached_lock.safety_level == 1)
			to_chat(user, span_danger("\The [src] hisses in dissapointment."))
			visible_message(span_game(span_say(span_name("\The [src]") + " announces, \"Self-destruct occurring in ten seconds.\"")), span_game(span_say(span_name("\The [src]") + " announces, \"Self-destruct occurring in ten seconds.\"")))
			attached_lock.exploding = 1
			addtimer(CALLBACK(src, PROC_REF(lock_explosion)), 10 SECONDS, TIMER_DELETE_ME)
			return FALSE

	// Shoot self in foot with clumsy
	if((CLUMSY in user.mutations) && prob(40))
		if(!ispath(currently_chambered))
			handle_click_empty(user)
			return FALSE
		var/datum/bulletdata/shot = create_bullet_datum(user, user, 0, FALSE, FALSE)
		fire_gun_projectile(shot, user, user, pick(BP_L_FOOT, BP_R_FOOT))
		user.visible_message(
			span_danger("\The [user] shoots [user.p_themselves()] in the foot with \the [src]!"),
			span_danger("You shoot yourself in the foot with \the [src]!")
			)
		user.drop_item()
		return FALSE
	return TRUE

/// Initial gunfire proc, checks gun cooldown and if we are currently in the middle of a burst of gunfire.
/obj/item/gun_new/proc/Fire(atom/target, mob/living/user, clickparams, pointblank=0, reflex=0)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)

	if(!target)
		return

	var/shoot_time = (burst - 1)* burst_delay
	if(user) // Rarely we need to support null user firing.
		if(target.z != user.z)
			return
		add_fingerprint(user)
		user.break_cloak()
		if(!special_check(user))
			return
		user.setClickCooldown(shoot_time) //no clicking on things while shooting
		user.setMoveCooldown(shoot_time) //no moving while shooting either

	if(world.time < next_fire_time)
		if (world.time % 3) //to prevent spam
			to_chat(user, span_warning("[src] is not ready to fire again!"))
		return
	next_fire_time = world.time + shoot_time

	handle_gunfire(target, user, clickparams, pointblank, reflex, 1, FALSE)

/// Handles actual gunfire. Repeatedly called via timers during burstfire.
/obj/item/gun_new/proc/handle_gunfire(atom/target, mob/living/user, clickparams, pointblank=0, reflex=0, var/ticker, var/recursive = FALSE)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)

	if(ticker > burst)
		return //we're done here
	if(ticker >= 250) //If you go too far above this, your game will kick you and force you to reconnect. This is already EXTREMELY leninent.
		return //In testing, I reached 937 bullets out of 1000 being fired with a delay  of 0.1 before being kicked.

	var/held_twohanded = FALSE
	if(user)
		if(!ismob(loc) && !mounted_gun) //We've been dropped and we are NOT a mounted gun.
			return
		if(user.stat) //We've been KO'd or have died. No shooting while dead.
			return
		held_twohanded = (user.can_wield_item(src) && is_held_twohanded(user))

	//actually attempt to shoot
	var/turf/targloc = get_turf(target) //cache this in case target gets deleted during shooting, e.g. if it was a securitron that got destroyed.

	//update timing
	if(recursive)
		user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
		next_fire_time = world.time + fire_delay
		if(muzzle_flash)
			if(gun_light)
				set_light(light_brightness)
			else
				set_light(0)

	// End burst shot
	if(ticker > burst)
		return

	//click, out of bullets
	if(!ispath(currently_chambered))
		handle_click_empty(user)
		return

	// So one burst only makes one message and not 3+ messages.
	if(ticker == 1)
		handle_firing_text(user, target, pointblank, reflex)

	// Take the shot
	var/datum/bulletdata/shot = create_bullet_datum(user, target, ticker, held_twohanded, pointblank)
	fire_gun_projectile(shot, user, target, user.zone_sel.selecting, clickparams)

	// We do this down here, so we don't get the message if we fire an empty gun.
	if(user)
		if(user.item_is_in_hands(src) && user.hands_are_full())
			if(one_handed_penalty >= 20)
				to_chat(user, span_warning("You struggle to keep \the [src] pointed at the correct position with just one hand!"))

		if(!zoom) //If we're not zoomed, reset our accuracy to our initial accuracy.
			accuracy = initial(accuracy) //Reset our accuracy
		last_shot = world.time
		user.hud_used.update_ammo_hud(user, src)
		user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)

		if(recoil_mode && iscarbon(user))
			var/mob/living/carbon/micro = user
			var/mysize = micro.size_multiplier
			if(recoil_mode > 0)
				if(mysize <= 0.60)
					micro.Weaken(1*recoil_mode)
					/* TODO - micro harm from energy weapons?
					if(!istype(src,/obj/item/gun_new/energy))
						micro.adjustBruteLoss((5-mysize*4)*recoil_mode)
						to_chat(micro, span_danger("You're so tiny that you drop the gun and hurt yourself from the recoil!"))
					else
						to_chat(micro, span_danger("You're so tiny that the pull of the trigger causes you to drop the gun!"))
					*/

	if(!(target && target.loc))
		target = targloc
		pointblank = 0

	if(ticker < burst)
		addtimer(CALLBACK(src, PROC_REF(handle_gunfire),target, user, clickparams, pointblank, reflex, ++ticker, TRUE), burst_delay, TIMER_DELETE_ME)
		return

	if(ticker == burst)
		next_fire_time = world.time + fire_delay
		if(muzzle_flash)
			if(gun_light)
				addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, set_light),light_brightness), burst_delay, TIMER_DELETE_ME)
			else
				addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, set_light),0), burst_delay, TIMER_DELETE_ME)

/obj/item/gun_new/proc/create_bullet_datum(user, target, ticker, held_twohanded, pointblank)
	var/datum/bulletdata/shot_dat = new currently_chambered()
	process_accuracy(shot_dat, user, target, ticker, held_twohanded)
	if(pointblank)
		process_point_blank(shot_dat, user, target)
	return shot_dat

/obj/item/gun_new/proc/process_point_blank(datum/bulletdata/current_shot, mob/user, atom/target)
	//default point blank multiplier
	var/damage_mult = 1.3

	//determine multiplier due to the target being grabbed
	if(ismob(target))
		var/mob/M = target
		if(M.grabbed_by.len)
			var/grabstate = 0
			for(var/obj/item/grab/G in M.grabbed_by)
				grabstate = max(grabstate, G.state)
			if(grabstate >= GRAB_NECK)
				damage_mult = 2.5
			else if(grabstate >= GRAB_AGGRESSIVE)
				damage_mult = 1.5

	current_shot.agony *= damage_mult
	current_shot.damage *= damage_mult

/obj/item/gun_new/proc/process_accuracy(datum/bulletdata/current_shot, mob/living/user, atom/target, var/burst, var/held_twohanded)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)

	var/acc_mod = burst_accuracy[min(burst, burst_accuracy.len)]
	var/disp_mod = dispersion[min(burst, dispersion.len)]

	if(one_handed_penalty)
		if(!held_twohanded)
			acc_mod += -CEILING(one_handed_penalty/2, 1)
			disp_mod += one_handed_penalty*0.5 //dispersion per point of two-handedness

	//Accuracy modifiers
	current_shot.accuracy = accuracy + acc_mod
	current_shot.dispersion = disp_mod
	current_shot.accuracy -= user.get_accuracy_penalty()

	//accuracy bonus from aiming
	if (aim_targets && (target in aim_targets))
		//If you aim at someone beforehead, it'll hit more often.
		//Kinda balanced by fact you need like 2 seconds to aim
		//As opposed to no-delay pew pew
		current_shot.accuracy += 30

	// Some modifiers make it harder or easier to hit things.
	for(var/datum/modifier/M in user.modifiers)
		if(!isnull(M.accuracy))
			current_shot.accuracy += M.accuracy
		if(!isnull(M.accuracy_dispersion))
			current_shot.dispersion = max(current_shot.dispersion + M.accuracy_dispersion, 0)

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.species)
			current_shot.accuracy += H.species.gun_accuracy_mod
			current_shot.dispersion = max(current_shot.dispersion + H.species.gun_accuracy_dispersion_mod, 0)
		if(H.fear > 30)
			current_shot.accuracy -= 35

//does the actual launching of the projectile
/obj/item/gun_new/proc/fire_gun_projectile(datum/bulletdata/current_shot, mob/user, atom/target, var/target_zone, var/params=null)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)

	//shooting while in shock
	var/forcespread
	if(istype(user, /mob/living/carbon))
		var/mob/living/carbon/mob = user
		if(mob.shock_stage > 120)
			forcespread = rand(50, 50)
		else if(mob.shock_stage > 70)
			forcespread = rand(-25, 25)

	fire_projectile(current_shot, target, target_zone, user, params, null, forcespread)
	play_fire_sound(user)
	handle_post_fire(user, target)
