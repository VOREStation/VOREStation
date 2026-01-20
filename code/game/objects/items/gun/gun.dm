//Every shared function that EVERY SINGLE GUN HAS. Consider this a universal bible and you'd better know what you're doing if you're editing this.
//The core
/obj/item/gun
	name = "gun"
	desc = "Its a gun, it go pew."
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
	attack_verb = list("struck", "hit", "bashed")
	zoomdevicename = "scope"
	drop_sound = 'sound/items/drop/gun.ogg'
	pickup_sound = 'sound/items/pickup/gun.ogg'

	//Primary Vars
	var/datum/bulletdata/chamberedtype = /datum/bulletdata

	//Flashlights
	var/can_flashlight = FALSE
	var/gun_light = FALSE
	var/light_state = "flight"
	var/light_brightness = 4
	var/flight_x_offset = 0
	var/flight_y_offset = 0

	var/mouthshoot = 0 //To stop people from suiciding twice... >.>

/obj/item/gun/Initialize(mapload)
	. = ..()
	for(var/i in 1 to firemodes.len)
		firemodes[i] = new /datum/firemode(src, firemodes[i])

	if(isnull(scoped_accuracy))
		scoped_accuracy = accuracy

	if(dna_lock)
		attached_lock = new /obj/item/dnalockingchip(src)
	if(!dna_lock)
		verbs -= /obj/item/gun/verb/remove_dna
		verbs -= /obj/item/gun/verb/give_dna
		verbs -= /obj/item/gun/verb/allow_dna

/obj/item/gun/examine(mob/user)
	. = ..()
	if(firemodes.len > 1)
		var/datum/firemode/current_mode = firemodes[sel_mode]
		. += "The fire selector is set to [current_mode.name]."

//Two handing
/obj/item/gun/update_twohanding()
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

/obj/item/gun/update_held_icon()
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

//used by aiming code
/obj/item/gun/proc/can_hit(atom/target as mob, var/mob/living/user as mob)
	if(!special_check(user))
		return 2
	//just assume we can shoot through glass and stuff. No big deal, the player can just choose to not target someone
	//on the other side of a window if it makes a difference. Or if they run behind a window, too bad.
	if(target in check_trajectory(target, user))
		return 1 // Magic numbers are fun.

//called after successfully firing
/obj/item/gun/proc/handle_post_fire(mob/user, atom/target, var/pointblank=0, var/reflex=0)
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
/obj/item/gun/proc/handle_click_empty(mob/user)
	if (user)
		user.visible_message("*click click*", span_danger("*click*"))
		user.hud_used.update_ammo_hud(user, src)
	else
		src.visible_message("*click click*")
	playsound(src, 'sound/weapons/empty.ogg', 100, 1)

// Called when the user is about to fire.
// Moved from handle_post_fire() because if using a laser, the message for when someone got shot would show up before the firing message.
/obj/item/gun/proc/handle_firing_text(mob/user, atom/target, pointblank = FALSE, reflex = FALSE)
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

/obj/item/gun/proc/play_fire_sound(var/mob/user, var/obj/item/projectile/P)
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
/obj/item/gun/proc/handle_suicide(mob/living/user)
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

/obj/item/gun/proc/lock_explosion()
	explosion(src, 0, 0, 3, 4)
	QDEL_IN(src, 1)
