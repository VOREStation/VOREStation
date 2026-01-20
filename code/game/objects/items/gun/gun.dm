//Every shared function that EVERY SINGLE GUN HAS. Consider this a universal bible and you'd better know what you're doing if you're editing this.
//The core
/obj/item/gun_new
	name = "gun"
	desc = "Its a gun, it go pew."
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	matter = list(MAT_STEEL = 2000)
	w_class = ITEMSIZE_NORMAL
	throwforce = 5
	throw_speed = 4
	throw_range = 5
	force = 5
	preserve_item = 1
	attack_verb = list("struck", "hit", "bashed")
	drop_sound = 'sound/items/drop/gun.ogg'
	pickup_sound = 'sound/items/pickup/gun.ogg'

	// Icon
	icon = 'icons/obj/gun.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_guns.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_guns.dmi',
		)
	icon_state = "detective"
	item_state = "gun"
	var/wielded_item_state

	// Bullet type and currently chambered round
	var/datum/bulletdata/bullet_type = /datum/bulletdata
	var/datum/bulletdata/currently_chambered = null

	// Firemode
	var/sel_mode = 1 //index of the currently selected mode
	var/list/firemodes = list()

	// Whether or not the gun is locked to dna
	var/dna_lock = FALSE
	var/obj/item/dnalockingchip/attached_lock

	//aiming system stuff
	var/keep_aim = 1 	//1 for keep shooting until aim is lowered
						//0 for one bullet after tarrget moves and aim is lowered
	var/multi_aim = 0 //Used to determine if you can target multiple people.
	var/tmp/list/mob/living/aim_targets //List of who yer targeting.
	var/tmp/mob/living/last_moved_mob //Used to fire faster at more than one person.
	var/tmp/told_cant_shoot = 0 //So that it doesn't spam them with the fact they cannot hit them.
	var/tmp/lock_time = -100
	var/atom/movable/screen/auto_target/auto_target
	zoomdevicename = "scope"

	// Attack chain
	var/special_handling = FALSE
	var/mouthshoot = 0 //To stop people from suiciding twice... >.>

	// Effects
	var/muzzle_flash = 3

	// Flashlights
	var/can_flashlight = FALSE
	var/gun_light = FALSE
	var/light_state = "flight"
	var/light_brightness = 4
	var/flight_x_offset = 0
	var/flight_y_offset = 0


	// WIP CHECK WHEN WE CAN MOVE THESE TO DATUM
	var/accuracy = 0   //Accuracy is measured in percents. +15 accuracy means that everything is effectively one tile closer for the purpose of miss chance, -15 means the opposite. launchers are not supported, at the moment.
	var/scoped_accuracy = null

	var/recoil = 0		//screen shake
	var/automatic = 0
	var/burst = 1
	var/fire_delay = 6 	//delay after shooting before the gun can be used again
	var/burst_delay = 2	//delay between shots, if firing in bursts
	var/move_delay = 1
	var/fire_sound = null // This is handled by projectile.dm's fire_sound var now, but you can override the projectile's fire_sound with this one if you want to.
	var/fire_sound_text = "gunshot"

	var/wielded_item_state
	var/one_handed_penalty = 0 // Penalty applied if someone fires a two-handed gun with one hand.
	var/atom/movable/screen/auto_target/auto_target
	var/shooting = 0
	var/next_fire_time = 0

	var/last_shot = 0			//records the last shot fired
	var/recoil_mode = 0			//If the gun will hurt micros if shot or not. Disabled on Virgo, used downstream.
	var/mounted_gun = 0				//If the gun is mounted within a rigsuit or elsewhere. This makes it so the gun can be shot even if it's loc != a mob
	var/list/burst_accuracy = list(0) //allows for different accuracies for each shot in a burst. Applied on top of accuracy
	var/list/dispersion = list(0)
	var/silenced = 0
	var/fire_anim = null


/obj/item/gun_new/Initialize(mapload)
	. = ..()
	for(var/i in 1 to firemodes.len)
		firemodes[i] = new /datum/firemode_new(src, firemodes[i])

	if(isnull(scoped_accuracy))
		scoped_accuracy = accuracy

	if(dna_lock)
		attached_lock = new /obj/item/dnalockingchip(src)
	else
		verbs -= /obj/item/gun_new/verb/remove_dna
		verbs -= /obj/item/gun_new/verb/give_dna
		verbs -= /obj/item/gun_new/verb/allow_dna

/obj/item/gun_new/examine(mob/user)
	. = ..()
	if(firemodes.len > 1)
		var/datum/firemode_new/current_mode = firemodes[sel_mode]
		. += "The fire selector is set to [current_mode.name]."

//Two handing
/obj/item/gun_new/update_twohanding()
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

/obj/item/gun_new/update_held_icon()
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

//called after successfully firing
/obj/item/gun_new/proc/handle_post_fire(mob/user, atom/target, var/pointblank=0, var/reflex=0)
	if(fire_anim)
		flick(fire_anim, src)

	if(muzzle_flash)
		set_light(muzzle_flash)

	if(one_handed_penalty)
		if(!src.is_held_twohanded(user))
			switch(one_handed_penalty)
				if(1 to 15)
					if(prob(50)) //don't need to tell them every single time
						to_chat(user, span_warning("Your aim wavers slightly."))
				if(16 to 30)
					to_chat(user, span_warning("Your aim wavers as you fire \the [src] with just one hand."))
				if(31 to 45)
					to_chat(user, span_warning("You have trouble keeping \the [src] on target with just one hand."))
				if(46 to INFINITY)
					to_chat(user, span_warning("You struggle to keep \the [src] on target with just one hand!"))
		else if(!user.can_wield_item(src))
			switch(one_handed_penalty)
				if(1 to 15)
					if(prob(50)) //don't need to tell them every single time
						to_chat(user, span_warning("Your aim wavers slightly."))
				if(16 to 30)
					to_chat(user, span_warning("Your aim wavers as you try to hold \the [src] steady."))
				if(31 to 45)
					to_chat(user, span_warning("You have trouble holding \the [src] steady."))
				if(46 to INFINITY)
					to_chat(user, span_warning("You struggle to hold \the [src] steady!"))

	if(recoil)
		shake_camera(user, recoil+1, recoil)
	update_icon()

//called if there was no projectile to shoot
/obj/item/gun_new/proc/handle_click_empty(mob/user)
	if (user)
		user.visible_message("*click click*", span_danger("*click*"))
		user.hud_used.update_ammo_hud(user, src)
	else
		src.visible_message("*click click*")
	playsound(src, 'sound/weapons/empty.ogg', 100, 1)

// Called when the user is about to fire.
// Moved from handle_post_fire() because if using a laser, the message for when someone got shot would show up before the firing message.
/obj/item/gun_new/proc/handle_firing_text(mob/user, atom/target, pointblank = FALSE, reflex = FALSE)
	if(silenced)
		to_chat(user, span_warning("You fire \the [src][pointblank ? " point blank at \the [target]":""][reflex ? " by reflex":""]"))
		for(var/mob/living/L in oview(2,user))
			if(L.stat)
				continue
			if(L.blinded)
				to_chat(L, "You hear a [fire_sound_text]!")
				continue
			to_chat(L, 	span_danger("\The [user] fires \the [src][pointblank ? " point blank at \the [target]":""][reflex ? " by reflex":""]!"))
	else
		user.visible_message(
			span_danger("\The [user] fires \the [src][pointblank ? " point blank at \the [target]":""][reflex ? " by reflex":""]!"),
			span_warning("You fire \the [src][pointblank ? " point blank at \the [target]":""][reflex ? " by reflex":""]!"),
			"You hear a [fire_sound_text]!"
			)

	add_attack_logs(user, target, "Fired gun '[src.name]' ([reflex ? "REFLEX" : "MANUAL"])")

/obj/item/gun_new/proc/play_fire_sound(var/mob/user, var/obj/item/projectile/P)
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
/obj/item/gun_new/proc/handle_suicide(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/M = user

	mouthshoot = 1
	M.visible_message(span_red("[user] sticks their gun in their mouth, ready to pull the trigger..."))
	if(!do_after(user, 4 SECONDS, target = src))
		M.visible_message(span_blue("[user] decided life was worth living"))
		mouthshoot = 0
		return
	var/obj/item/projectile/in_chamber = consume_next_projectile()
	if (istype(in_chamber))
		user.visible_message(span_warning("[user] pulls the trigger."))
		play_fire_sound(M, in_chamber)
		if(istype(in_chamber, /obj/item/projectile/beam/lasertag))
			user.show_message(span_warning("You feel rather silly, trying to commit suicide with a toy."))
			mouthshoot = 0
			return

		in_chamber.on_hit(M)
		if(in_chamber.damage_type != HALLOSS && !in_chamber.nodamage)
			log_and_message_admins("commited suicide using \a [src]", user)
			user.apply_damage(in_chamber.damage*2.5, in_chamber.damage_type, BP_HEAD, sharp = TRUE, used_weapon = src)
			user.death()
		else if(in_chamber.damage_type == HALLOSS)
			to_chat(user, span_notice("Ow..."))
			user.apply_effect(110,AGONY,0)
		qdel(in_chamber)
		mouthshoot = 0
		return
	else
		handle_click_empty(user)
		mouthshoot = 0
		return
