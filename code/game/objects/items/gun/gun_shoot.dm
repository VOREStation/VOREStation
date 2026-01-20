
/obj/item/gun/afterattack(atom/A, mob/living/user, adjacent, params)
	if(adjacent) return //A is adjacent, is the user, or is on the user's person

	if(!user.aiming)
		user.aiming = new(user)

	if(user && user.client && user.aiming && user.aiming.active && user.aiming.aiming_at != A)
		PreFire(A,user,params) //They're using the new gun system, locate what they're aiming at.
		return

	if(user && user.a_intent == I_HELP && user.client?.prefs?.read_preference(/datum/preference/toggle/safefiring)) //regardless of what happens, refuse to shoot if help intent is on
		to_chat(user, span_warning("You refrain from firing your [src] as your intent is set to help."))
		return

	else
		Fire(A, user, params) //Otherwise, fire normally.
		return

/obj/item/gun/proc/Fire(atom/target, mob/living/user, clickparams, pointblank=0, reflex=0)
	if(!user || !target)
		return
	if(target.z != user.z)
		return

	add_fingerprint(user)

	user.break_cloak()

	if(!special_check(user))
		return

	if(world.time < next_fire_time)
		if (world.time % 3) //to prevent spam
			to_chat(user, span_warning("[src] is not ready to fire again!"))
		return

	var/shoot_time = (burst - 1)* burst_delay

	//These should apparently be disabled to allow for the automatic system to function without causing near-permanant paralysis. Re-enabling them while we sort that out.
	user.setClickCooldown(shoot_time) //no clicking on things while shooting
	user.setMoveCooldown(shoot_time) //no moving while shooting either

	next_fire_time = world.time + shoot_time
	handle_gunfire(target, user, clickparams, pointblank, reflex, 1, FALSE)

//obtains the next projectile to fire
/obj/item/gun/proc/consume_next_projectile()
	return null

/obj/item/gun/proc/handle_gunfire(atom/target, mob/living/user, clickparams, pointblank=0, reflex=0, var/ticker, var/recursive = FALSE)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(ticker > burst)
		return //we're done here
	if(!ismob(loc) && !mounted_gun) //We've been dropped and we are NOT a mounted gun.
		return
	if(user.stat) //We've been KO'd or have died. No shooting while dead.
		return
	if(ticker >= 250) //If you go too far above this, your game will kick you and force you to reconnect. This is already EXTREMELY leninent.
		return //In testing, I reached 937 bullets out of 1000 being fired with a delay  of 0.1 before being kicked.
	var/held_twohanded = (user.can_wield_item(src) && is_held_twohanded(user))

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

	if(ticker <= burst)
		var/obj/projectile = consume_next_projectile(user)
		if(!projectile) //click, out of bullets
			handle_click_empty(user)
			return

		else
			if(ticker == 1) // So one burst only makes one message and not 3+ messages.
				handle_firing_text(user, target, pointblank, reflex)

			process_accuracy(projectile, user, target, ticker, held_twohanded)

			if(pointblank)
				process_point_blank(projectile, user, target)

			if(process_projectile(projectile, user, target, user.zone_sel.selecting, clickparams))
				handle_post_fire(user, target, pointblank, reflex)
				update_icon()

			// We do this down here, so we don't get the message if we fire an empty gun.
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
						if(!istype(src,/obj/item/gun/energy))
							micro.adjustBruteLoss((5-mysize*4)*recoil_mode)
							to_chat(micro, span_danger("You're so tiny that you drop the gun and hurt yourself from the recoil!"))
						else
							to_chat(micro, span_danger("You're so tiny that the pull of the trigger causes you to drop the gun!"))

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

// Similar to the above proc, but does not require a user, which is ideal for things like turrets.
/obj/item/gun/proc/Fire_userless(atom/target)
	if(!target)
		return

	if(world.time < next_fire_time)
		return

	var/shoot_time = (burst - 1)* burst_delay
	next_fire_time = world.time + shoot_time
	handle_userless_gunfire(target, 1, FALSE)

// This is horrible. I tried to keep the old way it had because if I try to use the fancy procs above like handle_post_fire, it expects a user.
// Which this doesn't have. It's ugly but whatever. This is used in literally one place (sawn off shotguns) and should honestly just be axed.
/obj/item/gun/proc/handle_userless_gunfire(atom/target, var/ticker, var/recursive = FALSE)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(ticker > burst)
		return //we're done here

	//actually attempt to shoot
	var/turf/targloc = get_turf(target) //cache this in case target gets deleted during shooting, e.g. if it was a securitron that got destroyed.

	//update timing
	if(recursive)
		next_fire_time = world.time + fire_delay
		if(muzzle_flash)
			set_light(0)

	if(ticker <= burst)
		var/obj/item/projectile/P = consume_next_projectile()
		if(!P) //click, out of bullets
			handle_click_empty()
			return

		else
			var/acc = burst_accuracy[min(ticker, burst_accuracy.len)]
			var/disp = dispersion[min(ticker, dispersion.len)]

			P.accuracy = accuracy + acc
			P.dispersion = disp

			P.shot_from = src.name
			P.silenced |= silenced // A silent bullet (e.g., BBs) can be fired quietly from any gun.

			P.old_style_target(target)
			P.fire()

			accuracy = initial(accuracy)
			last_shot = world.time

			play_fire_sound()

			if(muzzle_flash)
				set_light(muzzle_flash)
			update_icon()

			if(!(target && target.loc))
				target = targloc

			if(ticker < burst)
				addtimer(CALLBACK(src, PROC_REF(handle_gunfire),target, ++ticker, TRUE), burst_delay, TIMER_DELETE_ME)

	add_attack_logs(src,target,"Fired [src.name] (Unmanned)")

/obj/item/gun/proc/process_point_blank(obj/projectile, mob/user, atom/target)
	var/obj/item/projectile/P = projectile
	if(!istype(P))
		return //default behaviour only applies to true projectiles

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
	P.agony *= damage_mult
	P.damage *= damage_mult

/obj/item/gun/proc/process_accuracy(obj/projectile, mob/living/user, atom/target, var/burst, var/held_twohanded)
	var/obj/item/projectile/P = projectile
	if(!istype(P))
		return //default behaviour only applies to true projectiles

	var/acc_mod = burst_accuracy[min(burst, burst_accuracy.len)]
	var/disp_mod = dispersion[min(burst, dispersion.len)]

	if(one_handed_penalty)
		if(!held_twohanded)
			acc_mod += -CEILING(one_handed_penalty/2, 1)
			disp_mod += one_handed_penalty*0.5 //dispersion per point of two-handedness

	//Accuracy modifiers
	P.accuracy = accuracy + acc_mod
	P.dispersion = disp_mod

	P.accuracy -= user.get_accuracy_penalty()

	//accuracy bonus from aiming
	if (aim_targets && (target in aim_targets))
		//If you aim at someone beforehead, it'll hit more often.
		//Kinda balanced by fact you need like 2 seconds to aim
		//As opposed to no-delay pew pew
		P.accuracy += 30

	// Some modifiers make it harder or easier to hit things.
	for(var/datum/modifier/M in user.modifiers)
		if(!isnull(M.accuracy))
			P.accuracy += M.accuracy
		if(!isnull(M.accuracy_dispersion))
			P.dispersion = max(P.dispersion + M.accuracy_dispersion, 0)

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.species)
			P.accuracy += H.species.gun_accuracy_mod
			P.dispersion = max(P.dispersion + H.species.gun_accuracy_dispersion_mod, 0)
		if(H.fear > 30)
			P.accuracy -= 35

//does the actual launching of the projectile
/obj/item/gun/proc/process_projectile(obj/projectile, mob/user, atom/target, var/target_zone, var/params=null)
	var/obj/item/projectile/P = projectile
	if(!istype(P))
		return FALSE //default behaviour only applies to true projectiles

	//shooting while in shock
	var/forcespread
	if(istype(user, /mob/living/carbon))
		var/mob/living/carbon/mob = user
		if(mob.shock_stage > 120)
			forcespread = rand(50, 50)
		else if(mob.shock_stage > 70)
			forcespread = rand(-25, 25)
	var/launched = !P.launch_from_gun(target, target_zone, user, params, null, forcespread, src)

	if(launched)
		play_fire_sound(user, P)

	return launched
