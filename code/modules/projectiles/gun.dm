/*
	Defines a firing mode for a gun.

	A firemode is created from a list of fire mode settings. Each setting modifies the value of the gun var with the same name.
	If the fire mode value for a setting is null, it will be replaced with the initial value of that gun's variable when the firemode is created.
	Obviously not compatible with variables that take a null value. If a setting is not present, then the corresponding var will not be modified.
*/
/datum/firemode
	var/name = "default"
	var/list/settings = list()

/datum/firemode/New(obj/item/weapon/gun/gun, list/properties = null)
	..()
	if(!properties) return

	for(var/propname in properties)
		var/propvalue = properties[propname]

		if(propname == "mode_name")
			name = propvalue
		if(isnull(propvalue))
			settings[propname] = gun.vars[propname] //better than initial() as it handles list vars like burst_accuracy
		else
			settings[propname] = propvalue

/datum/firemode/proc/apply_to(obj/item/weapon/gun/gun)
	for(var/propname in settings)
		gun.vars[propname] = settings[propname]

//Parent gun type. Guns are weapons that can be aimed at mobs and act over a distance
/obj/item/weapon/gun
	name = "gun"
	desc = "Its a gun. It's pretty terrible, though."
	icon = 'icons/obj/gun.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_guns.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_guns.dmi',
		)
	icon_state = "detective"
	item_state = "gun"
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	matter = list(MAT_STEEL = 2000)
	w_class = ITEMSIZE_NORMAL
	throwforce = 5
	throw_speed = 4
	throw_range = 5
	force = 5
	preserve_item = 1
	origin_tech = list(TECH_COMBAT = 1)
	attack_verb = list("struck", "hit", "bashed")
	zoomdevicename = "scope"
	drop_sound = 'sound/items/drop/gun.ogg'
	pickup_sound = 'sound/items/pickup/gun.ogg'

	var/automatic = 0
	var/burst = 1
	var/fire_delay = 6 	//delay after shooting before the gun can be used again
	var/burst_delay = 2	//delay between shots, if firing in bursts
	var/move_delay = 1
	var/fire_sound = null // This is handled by projectile.dm's fire_sound var now, but you can override the projectile's fire_sound with this one if you want to.
	var/fire_sound_text = "gunshot"
	var/fire_anim = null
	var/recoil = 0		//screen shake
	var/silenced = 0
	var/muzzle_flash = 3
	var/accuracy = 0   //Accuracy is measured in percents. +15 accuracy means that everything is effectively one tile closer for the purpose of miss chance, -15 means the opposite. launchers are not supported, at the moment.
	var/scoped_accuracy = null
	var/list/burst_accuracy = list(0) //allows for different accuracies for each shot in a burst. Applied on top of accuracy
	var/list/dispersion = list(0)
	var/mode_name = null
	var/projectile_type = /obj/item/projectile	//On ballistics, only used to check for the cham gun

	var/wielded_item_state
	var/one_handed_penalty = 0 // Penalty applied if someone fires a two-handed gun with one hand.
	var/obj/screen/auto_target/auto_target
	var/shooting = 0
	var/next_fire_time = 0

	var/sel_mode = 1 //index of the currently selected mode
	var/list/firemodes = list()

	var/reload_time = 1		//Base reload time in seconds

	//aiming system stuff
	var/keep_aim = 1 	//1 for keep shooting until aim is lowered
						//0 for one bullet after tarrget moves and aim is lowered
	var/multi_aim = 0 //Used to determine if you can target multiple people.
	var/tmp/list/mob/living/aim_targets //List of who yer targeting.
	var/tmp/mob/living/last_moved_mob //Used to fire faster at more than one person.
	var/tmp/told_cant_shoot = 0 //So that it doesn't spam them with the fact they cannot hit them.
	var/tmp/lock_time = -100

	var/dna_lock = 0				//whether or not the gun is locked to dna
	var/obj/item/dnalockingchip/attached_lock

	var/last_shot = 0			//records the last shot fired

//VOREStation Add - /tg/ icon system
	var/charge_sections = 4
	var/shaded_charge = FALSE
	var/ammo_x_offset = 2
	var/ammo_y_offset = 0
	var/can_flashlight = FALSE
	var/gun_light = FALSE
	var/light_state = "flight"
	var/light_brightness = 4
	var/flight_x_offset = 0
	var/flight_y_offset = 0

/obj/item/weapon/gun/CtrlClick(mob/user)
	if(can_flashlight && ishuman(user) && src.loc == usr && !user.incapacitated(INCAPACITATION_ALL))
		toggle_flashlight()
	else
		return ..()

/obj/item/weapon/gun/proc/toggle_flashlight()
	if(gun_light)
		set_light(0)
		gun_light = FALSE
	else
		set_light(light_brightness)
		gun_light = TRUE

	playsound(src, 'sound/machines/button.ogg', 25)
	update_icon()
//VOREStation Add End

/obj/item/weapon/gun/New()
	..()
	for(var/i in 1 to firemodes.len)
		firemodes[i] = new /datum/firemode(src, firemodes[i])

	if(isnull(scoped_accuracy))
		scoped_accuracy = accuracy

	if(dna_lock)
		attached_lock = new /obj/item/dnalockingchip(src)
	if(!dna_lock)
		verbs -= /obj/item/weapon/gun/verb/remove_dna
		verbs -= /obj/item/weapon/gun/verb/give_dna
		verbs -= /obj/item/weapon/gun/verb/allow_dna

/obj/item/weapon/gun/update_twohanding()
	if(one_handed_penalty)
		var/mob/living/M = loc
		if(istype(M))
			if(M.can_wield_item(src) && src.is_held_twohanded(M))
				name = "[initial(name)] (wielded)"
			else
				name = initial(name)
		else
			name = initial(name)
		update_icon() // In case item_state is set somewhere else.
	..()

/obj/item/weapon/gun/update_held_icon()
	if(wielded_item_state)
		var/mob/living/M = loc
		if(istype(M))
			if(M.can_wield_item(src) && src.is_held_twohanded(M))
				LAZYSET(item_state_slots, slot_l_hand_str, wielded_item_state)
				LAZYSET(item_state_slots, slot_r_hand_str, wielded_item_state)
			else
				LAZYSET(item_state_slots, slot_l_hand_str, initial(item_state))
				LAZYSET(item_state_slots, slot_r_hand_str, initial(item_state))
	..()


//Checks whether a given mob can use the gun
//Any checks that shouldn't result in handle_click_empty() being called if they fail should go here.
//Otherwise, if you want handle_click_empty() to be called, check in consume_next_projectile() and return null there.
/obj/item/weapon/gun/proc/special_check(var/mob/user)

	if(!istype(user, /mob/living))
		return 0
	if(!user.IsAdvancedToolUser())
		return 0
	if(isanimal(user))
		var/mob/living/simple_mob/S = user
		if(!S.IsHumanoidToolUser(src))
			return 0

	var/mob/living/M = user
	if(dna_lock && attached_lock.stored_dna)
		if(!authorized_user(user))
			if(attached_lock.safety_level == 0)
				to_chat(M, "<span class='danger'>\The [src] buzzes in dissapointment and displays an invalid DNA symbol.</span>")
				return 0
			if(!attached_lock.exploding)
				if(attached_lock.safety_level == 1)
					to_chat(M, "<span class='danger'>\The [src] hisses in dissapointment.</span>")
					visible_message("<span class='game say'><span class='name'>\The [src]</span> announces, \"Self-destruct occurring in ten seconds.\"</span>", "<span class='game say'><span class='name'>\The [src]</span> announces, \"Self-destruct occurring in ten seconds.\"</span>")
					attached_lock.exploding = 1
					spawn(100)
						explosion(src, 0, 0, 3, 4)
						sleep(1)
						qdel(src)
					return 0
	if(HULK in M.mutations)
		to_chat(M, "<span class='danger'>Your fingers are much too large for the trigger guard!</span>")
		return 0
	if((CLUMSY in M.mutations) && prob(40)) //Clumsy handling
		var/obj/P = consume_next_projectile()
		if(P)
			if(process_projectile(P, user, user, pick("l_foot", "r_foot")))
				handle_post_fire(user, user)
				var/datum/gender/TU = gender_datums[user.get_visible_gender()]
				user.visible_message(
					"<span class='danger'>\The [user] shoots [TU.himself] in the foot with \the [src]!</span>",
					"<span class='danger'>You shoot yourself in the foot with \the [src]!</span>"
					)
				M.drop_item()
		else
			handle_click_empty(user)
		return 0
	return 1

/obj/item/weapon/gun/emp_act(severity)
	for(var/obj/O in contents)
		O.emp_act(severity)

/obj/item/weapon/gun/afterattack(atom/A, mob/living/user, adjacent, params)
	if(adjacent) return //A is adjacent, is the user, or is on the user's person

	if(!user.aiming)
		user.aiming = new(user)

	if(user && user.client && user.aiming && user.aiming.active && user.aiming.aiming_at != A)
		PreFire(A,user,params) //They're using the new gun system, locate what they're aiming at.
		return

	if(user && user.a_intent == I_HELP && user.client?.prefs?.read_preference(/datum/preference/toggle/safefiring)) //regardless of what happens, refuse to shoot if help intent is on
		to_chat(user, "<span class='warning'>You refrain from firing your [src] as your intent is set to help.</span>")
		return

	else
		Fire(A, user, params) //Otherwise, fire normally.
		return

/*	//Commented out for quality control and testing
	if(automatic == 1)//Are we are going to be using automatic shooting
			//We check to make sure they can fire
		if(!special_check(user))
			return
		if(auto_target)//If they already have one then update it
			auto_target.loc = get_turf(A)
			auto_target.delay_del = 1//And reset the del so its like they got a new one and doesnt instantly vanish
			to_chat(user, "<span class='notice'>You ready \the [src]!  Click and drag the target around to shoot.</span>")
		else//Otherwise just make a new one
			auto_target = new/obj/screen/auto_target(get_turf(A), src)
			visible_message("<span class='danger'>\The [user] readies the [src]!</span>")
			playsound(src, 'sound/weapons/TargetOn.ogg', 50, 1)
			to_chat(user, "<span class='notice'>You ready \the [src]!  Click and drag the target around to shoot.</span>")
			return
	Fire(A,user,params) //Otherwise, fire normally.
*/

/obj/item/weapon/gun/attack(atom/A, mob/living/user, def_zone)
	if (A == user && user.zone_sel.selecting == O_MOUTH && !mouthshoot)
		handle_suicide(user)
	else if(user.a_intent == I_HURT) //point blank shooting
		if(user && user.client && user.aiming && user.aiming.active && user.aiming.aiming_at != A && A != user)
			PreFire(A,user) //They're using the new gun system, locate what they're aiming at.
			return
		else
			Fire(A, user, pointblank=1)
	else
		return ..() //Pistolwhippin'

/obj/item/weapon/gun/attackby(var/obj/item/A as obj, mob/user as mob)
	if(istype(A, /obj/item/dnalockingchip))
		if(dna_lock)
			to_chat(user, "<span class='notice'>\The [src] already has a [attached_lock].</span>")
			return
		to_chat(user, "<span class='notice'>You insert \the [A] into \the [src].</span>")
		user.drop_item()
		A.loc = src
		attached_lock = A
		dna_lock = 1
		verbs += /obj/item/weapon/gun/verb/remove_dna
		verbs += /obj/item/weapon/gun/verb/give_dna
		verbs += /obj/item/weapon/gun/verb/allow_dna
		return

	if(A.has_tool_quality(TOOL_SCREWDRIVER))
		if(dna_lock && attached_lock && !attached_lock.controller_lock)
			to_chat(user, "<span class='notice'>You begin removing \the [attached_lock] from \the [src].</span>")
			playsound(src, A.usesound, 50, 1)
			if(do_after(user, 25 * A.toolspeed))
				to_chat(user, "<span class='notice'>You remove \the [attached_lock] from \the [src].</span>")
				user.put_in_hands(attached_lock)
				dna_lock = 0
				attached_lock = null
				verbs -= /obj/item/weapon/gun/verb/remove_dna
				verbs -= /obj/item/weapon/gun/verb/give_dna
				verbs -= /obj/item/weapon/gun/verb/allow_dna
		else
			to_chat(user, "<span class='warning'>\The [src] is not accepting modifications at this time.</span>")
	..()

/obj/item/weapon/gun/emag_act(var/remaining_charges, var/mob/user)
	if(dna_lock && attached_lock.controller_lock)
		to_chat(user, "<span class='notice'>You short circuit the internal locking mechanisms of \the [src]!</span>")
		attached_lock.controller_dna = null
		attached_lock.controller_lock = 0
		attached_lock.stored_dna = list()
		return 1

/obj/item/weapon/gun/MouseDrop(obj/over_object as obj)
	if(!canremove)
		return

	if (ishuman(usr) || issmall(usr)) //so monkeys can take off their backpacks -- Urist

		if (istype(usr.loc,/obj/mecha)) // stops inventory actions in a mech. why?
			return

		if (!( istype(over_object, /obj/screen) ))
			return ..()

		//makes sure that the thing is equipped, so that we can't drag it into our hand from miles away.
		//there's got to be a better way of doing this.
		if (!(src.loc == usr) || (src.loc && src.loc.loc == usr))
			return

		if (( usr.restrained() ) || ( usr.stat ))
			return

		if ((src.loc == usr) && !(istype(over_object, /obj/screen)) && !usr.unEquip(src))
			return

		switch(over_object.name)
			if("r_hand")
				usr.u_equip(src)
				usr.put_in_r_hand(src)
			if("l_hand")
				usr.u_equip(src)
				usr.put_in_l_hand(src)
		src.add_fingerprint(usr)

/obj/item/weapon/gun/proc/Fire(atom/target, mob/living/user, clickparams, pointblank=0, reflex=0)
	if(!user || !target) return
	if(target.z != user.z) return

	add_fingerprint(user)

	user.break_cloak()

	if(!special_check(user))
		return

	if(world.time < next_fire_time)
		if (world.time % 3) //to prevent spam
			to_chat(user, "<span class='warning'>[src] is not ready to fire again!</span>")
		return

	var/shoot_time = (burst - 1)* burst_delay

	//These should apparently be disabled to allow for the automatic system to function without causing near-permanant paralysis. Re-enabling them while we sort that out.
	user.setClickCooldown(shoot_time) //no clicking on things while shooting
	user.setMoveCooldown(shoot_time) //no moving while shooting either

	next_fire_time = world.time + shoot_time

	var/held_twohanded = (user.can_wield_item(src) && src.is_held_twohanded(user))

	//actually attempt to shoot
	var/turf/targloc = get_turf(target) //cache this in case target gets deleted during shooting, e.g. if it was a securitron that got destroyed.

/*	// Commented out for quality control and testing.
	shooting = 1
	if(automatic == 1 && auto_target && auto_target.active)//When we are going to shoot and have an auto_target AND its active meaning we clicked on it we tell it to burstfire 1000 rounds
		burst = 1000//Yes its not EXACTLY full auto but when are we shooting more than 1000 normally and it can easily be made higher
*/
	for(var/i in 1 to burst)
		/*	// Commented out for quality control and testing.
		if(!reflex && automatic)//If we are shooting automatic then check our target, however if we are shooting reflex we dont use automatic
			//extra sanity checking.
			if(user.incapacitated())
				return
			if(user.get_active_hand() != src)
				break
			if(!auto_target) break//Stopped shooting
			else if(auto_target.loc)
				target = auto_target.loc
			//Lastly just update our dir if needed
			if(user.dir != get_dir(user, auto_target))
				user.face_atom(auto_target)
		*/
		var/obj/projectile = consume_next_projectile(user)
		if(!projectile)
			handle_click_empty(user)
			break

		if(i == 1) // So one burst only makes one message and not 3+ messages.
			handle_firing_text(user, target, pointblank, reflex)

		process_accuracy(projectile, user, target, i, held_twohanded)

		if(pointblank)
			process_point_blank(projectile, user, target)

		if(process_projectile(projectile, user, target, user.zone_sel.selecting, clickparams))
			handle_post_fire(user, target, pointblank, reflex)
			update_icon()

		if(i < burst)
			sleep(burst_delay)

		if(!(target && target.loc))
			target = targloc
			pointblank = 0

		last_shot = world.time

/*
	// Commented out for quality control and testing.
	shooting = 0
*/

	// We do this down here, so we don't get the message if we fire an empty gun.
	if(user.item_is_in_hands(src) && user.hands_are_full())
		if(one_handed_penalty >= 20)
			to_chat(user, "<span class='warning'>You struggle to keep \the [src] pointed at the correct position with just one hand!</span>")

	//update timing
	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	user.setMoveCooldown(move_delay)
	next_fire_time = world.time + fire_delay

	accuracy = initial(accuracy)	//Reset the gun's accuracy

	if(muzzle_flash)
		//VOREStation Edit - Flashlights
		if(gun_light)
			set_light(light_brightness)
		else
			set_light(0)
		//VOREStation Edit End
	user.hud_used.update_ammo_hud(user, src)

// Similar to the above proc, but does not require a user, which is ideal for things like turrets.
/obj/item/weapon/gun/proc/Fire_userless(atom/target)
	if(!target)
		return

	if(world.time < next_fire_time)
		return

	var/shoot_time = (burst - 1)* burst_delay
	next_fire_time = world.time + shoot_time

	var/turf/targloc = get_turf(target) //cache this in case target gets deleted during shooting, e.g. if it was a securitron that got destroyed.
	for(var/i in 1 to burst)
		var/obj/projectile = consume_next_projectile()
		if(!projectile)
			handle_click_empty()
			break

		if(istype(projectile, /obj/item/projectile))
			var/obj/item/projectile/P = projectile

			var/acc = burst_accuracy[min(i, burst_accuracy.len)]
			var/disp = dispersion[min(i, dispersion.len)]

			P.accuracy = accuracy + acc
			P.dispersion = disp

			P.shot_from = src.name
			P.silenced |= silenced // A silent bullet (e.g., BBs) can be fired quietly from any gun.

			P.old_style_target(target)
			P.fire()

			last_shot = world.time

			play_fire_sound()

			if(muzzle_flash)
				set_light(muzzle_flash)
			update_icon()

		//process_accuracy(projectile, user, target, acc, disp)

	//	if(pointblank)
	//		process_point_blank(projectile, user, target)

	//	if(process_projectile(projectile, null, target, user.zone_sel.selecting, clickparams))
	//		handle_post_fire(null, target, pointblank, reflex)

	//	update_icon()

		if(i < burst)
			sleep(burst_delay)

		if(!(target && target.loc))
			target = targloc
			//pointblank = 0

	var/target_for_log
	if(ismob(target))
		target_for_log = target
	else
		target_for_log = "[target.name]"

	add_attack_logs("Unmanned",target_for_log,"Fired [src.name]")

	//update timing
	next_fire_time = world.time + fire_delay

	accuracy = initial(accuracy)	//Reset the gun's accuracy

	if(muzzle_flash)
		set_light(0)

//obtains the next projectile to fire
/obj/item/weapon/gun/proc/consume_next_projectile()
	return null

//used by aiming code
/obj/item/weapon/gun/proc/can_hit(atom/target as mob, var/mob/living/user as mob)
	if(!special_check(user))
		return 2
	//just assume we can shoot through glass and stuff. No big deal, the player can just choose to not target someone
	//on the other side of a window if it makes a difference. Or if they run behind a window, too bad.
	if(target in check_trajectory(target, user))
		return 1 // Magic numbers are fun.

//called if there was no projectile to shoot
/obj/item/weapon/gun/proc/handle_click_empty(mob/user)
	if (user)
		user.visible_message("*click click*", "<span class='danger'>*click*</span>")
		user.hud_used.update_ammo_hud(user, src)
	else
		src.visible_message("*click click*")
	playsound(src, 'sound/weapons/empty.ogg', 100, 1)

// Called when the user is about to fire.
// Moved from handle_post_fire() because if using a laser, the message for when someone got shot would show up before the firing message.
/obj/item/weapon/gun/proc/handle_firing_text(mob/user, atom/target, pointblank = FALSE, reflex = FALSE)
	if(silenced)
		to_chat(user, "<span class='warning'>You fire \the [src][pointblank ? " point blank at \the [target]":""][reflex ? " by reflex":""]</span>")
		for(var/mob/living/L in oview(2,user))
			if(L.stat)
				continue
			if(L.blinded)
				to_chat(L, "You hear a [fire_sound_text]!")
				continue
			to_chat(L, 	"<span class='danger'>\The [user] fires \the [src][pointblank ? " point blank at \the [target]":""][reflex ? " by reflex":""]!</span>")
	else
		user.visible_message(
			"<span class='danger'>\The [user] fires \the [src][pointblank ? " point blank at \the [target]":""][reflex ? " by reflex":""]!</span>",
			"<span class='warning'>You fire \the [src][pointblank ? " point blank at \the [target]":""][reflex ? " by reflex":""]!</span>",
			"You hear a [fire_sound_text]!"
			)

	var/target_for_log
	if(ismob(target))
		target_for_log = target
	else
		target_for_log = "[target.name]"

	add_attack_logs(user, target_for_log, "Fired gun '[src.name]' ([reflex ? "REFLEX" : "MANUAL"])")

//called after successfully firing
/obj/item/weapon/gun/proc/handle_post_fire(mob/user, atom/target, var/pointblank=0, var/reflex=0)
	if(fire_anim)
		flick(fire_anim, src)

	if(muzzle_flash)
		set_light(muzzle_flash)

	if(one_handed_penalty)
		if(!src.is_held_twohanded(user))
			switch(one_handed_penalty)
				if(1 to 15)
					if(prob(50)) //don't need to tell them every single time
						to_chat(user, "<span class='warning'>Your aim wavers slightly.</span>")
				if(16 to 30)
					to_chat(user, "<span class='warning'>Your aim wavers as you fire \the [src] with just one hand.</span>")
				if(31 to 45)
					to_chat(user, "<span class='warning'>You have trouble keeping \the [src] on target with just one hand.</span>")
				if(46 to INFINITY)
					to_chat(user, "<span class='warning'>You struggle to keep \the [src] on target with just one hand!</span>")
		else if(!user.can_wield_item(src))
			switch(one_handed_penalty)
				if(1 to 15)
					if(prob(50)) //don't need to tell them every single time
						to_chat(user, "<span class='warning'>Your aim wavers slightly.</span>")
				if(16 to 30)
					to_chat(user, "<span class='warning'>Your aim wavers as you try to hold \the [src] steady.</span>")
				if(31 to 45)
					to_chat(user, "<span class='warning'>You have trouble holding \the [src] steady.</span>")
				if(46 to INFINITY)
					to_chat(user, "<span class='warning'>You struggle to hold \the [src] steady!</span>")

	if(recoil)
		spawn()
			shake_camera(user, recoil+1, recoil)
	update_icon()

/obj/item/weapon/gun/proc/process_point_blank(obj/projectile, mob/user, atom/target)
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
			for(var/obj/item/weapon/grab/G in M.grabbed_by)
				grabstate = max(grabstate, G.state)
			if(grabstate >= GRAB_NECK)
				damage_mult = 2.5
			else if(grabstate >= GRAB_AGGRESSIVE)
				damage_mult = 1.5
	P.damage *= damage_mult

/obj/item/weapon/gun/proc/process_accuracy(obj/projectile, mob/living/user, atom/target, var/burst, var/held_twohanded)
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
/obj/item/weapon/gun/proc/process_projectile(obj/projectile, mob/user, atom/target, var/target_zone, var/params=null)
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

/obj/item/weapon/gun/proc/play_fire_sound(var/mob/user, var/obj/item/projectile/P)
	var/shot_sound = fire_sound

	if(!shot_sound && istype(P) && P.fire_sound) // If the gun didn't have a fire_sound, but the projectile exists, and has a sound...
		shot_sound = P.fire_sound
	if(!shot_sound) // If there's still no sound...
		return

	if(silenced)
		playsound(src, shot_sound, 10, 1)
	else
		playsound(src, shot_sound, 50, 1)

//Suicide handling.
/obj/item/weapon/gun/var/mouthshoot = 0 //To stop people from suiciding twice... >.>

/obj/item/weapon/gun/proc/handle_suicide(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/M = user

	mouthshoot = 1
	M.visible_message(span_red("[user] sticks their gun in their mouth, ready to pull the trigger..."))
	if(!do_after(user, 40))
		M.visible_message(span_blue("[user] decided life was worth living"))
		mouthshoot = 0
		return
	var/obj/item/projectile/in_chamber = consume_next_projectile()
	if (istype(in_chamber))
		user.visible_message("<span class = 'warning'>[user] pulls the trigger.</span>")
		play_fire_sound(M, in_chamber)
		if(istype(in_chamber, /obj/item/projectile/beam/lasertag))
			user.show_message("<span class = 'warning'>You feel rather silly, trying to commit suicide with a toy.</span>")
			mouthshoot = 0
			return

		in_chamber.on_hit(M)
		if(in_chamber.damage_type != HALLOSS && !in_chamber.nodamage)
			log_and_message_admins("[key_name(user)] commited suicide using \a [src]")
			user.apply_damage(in_chamber.damage*2.5, in_chamber.damage_type, "head", used_weapon = "Point blank shot in the mouth with \a [in_chamber]", sharp = TRUE)
			user.death()
		else if(in_chamber.damage_type == HALLOSS)
			to_chat(user, "<span class = 'notice'>Ow...</span>")
			user.apply_effect(110,AGONY,0)
		qdel(in_chamber)
		mouthshoot = 0
		return
	else
		handle_click_empty(user)
		mouthshoot = 0
		return

/obj/item/weapon/gun/proc/toggle_scope(var/zoom_amount=2.0)
	//looking through a scope limits your periphereal vision
	//still, increase the view size by a tiny amount so that sniping isn't too restricted to NSEW
	var/zoom_offset = round(world.view * zoom_amount)
	var/view_size = round(world.view + zoom_amount)
	var/scoped_accuracy_mod = zoom_offset

	zoom(zoom_offset, view_size)
	if(zoom)
		accuracy = scoped_accuracy + scoped_accuracy_mod
		if(recoil)
			recoil = round(recoil*zoom_amount+1) //recoil is worse when looking through a scope

//make sure accuracy and recoil are reset regardless of how the item is unzoomed.
/obj/item/weapon/gun/zoom()
	..()
	if(!zoom)
		accuracy = initial(accuracy)
		recoil = initial(recoil)

/obj/item/weapon/gun/examine(mob/user)
	. = ..()
	if(firemodes.len > 1)
		var/datum/firemode/current_mode = firemodes[sel_mode]
		. += "The fire selector is set to [current_mode.name]."

/obj/item/weapon/gun/proc/switch_firemodes(mob/user)
	if(firemodes.len <= 1)
		return null

	sel_mode++
	if(sel_mode > firemodes.len)
		sel_mode = 1
	var/datum/firemode/new_mode = firemodes[sel_mode]
	new_mode.apply_to(src)
	to_chat(user, "<span class='notice'>\The [src] is now set to [new_mode.name].</span>")
	user.hud_used.update_ammo_hud(user, src) // TGMC Ammo HUD

	return new_mode

/obj/item/weapon/gun/attack_self(mob/user)
	switch_firemodes(user)

/* TGMC Ammo HUD Port Begin */
/obj/item/weapon/gun
	var/hud_enabled = TRUE

/obj/item/weapon/gun/proc/has_ammo_counter()
	return FALSE

/obj/item/weapon/gun/proc/get_ammo_type()
	return FALSE

/obj/item/weapon/gun/proc/get_ammo_count()
	return FALSE

/obj/item/weapon/gun/equipped(mob/living/user, slot) // When a gun is equipped to your hands, we'll add the HUD to the user. Pending porting over TGMC guncode where wielding is far more sensible.
	if(slot == slot_l_hand || slot == slot_r_hand)
		user.hud_used.add_ammo_hud(user, src)
	else
		user.hud_used.remove_ammo_hud(user, src)

	return ..()

/obj/item/weapon/gun/dropped(mob/living/user) // Ditto as above, we remove the HUD. Pending porting TGMC code to clean up this fucking nightmare of spaghetti.
	user.hud_used.remove_ammo_hud(user, src)

	..()
