/***
 * TODO Gattening: Unexist this file.
*/

// Exists to store procs that should stop existing by the end of the gattening rework



//Parent gun type. Guns are weapons that can be aimed at mobs and act over a distance
/obj/item/gun
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
	var/atom/movable/screen/auto_target/auto_target
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
	var/recoil_mode = 0			//If the gun will hurt micros if shot or not. Disabled on Virgo, used downstream.
	var/mounted_gun = 0				//If the gun is mounted within a rigsuit or elsewhere. This makes it so the gun can be shot even if it's loc != a mob

	var/charge_sections = 4
	var/shaded_charge = FALSE
	var/ammo_x_offset = 2
	var/ammo_y_offset = 0


	///Var for attack_self chain
	var/special_handling = FALSE



//Checks whether a given mob can use the gun
//Any checks that shouldn't result in handle_click_empty() being called if they fail should go here.
//Otherwise, if you want handle_click_empty() to be called, check in consume_next_projectile() and return null there.
/obj/item/gun/proc/special_check(var/mob/user)

	if(!isliving(user))
		return FALSE
	if(!user.IsAdvancedToolUser())
		return FALSE
	if(isanimal(user))
		var/mob/living/simple_mob/S = user
		if(!S.IsHumanoidToolUser(src))
			return FALSE

	var/mob/living/M = user
	if(istype(M))
		if(M.has_modifier_of_type(/datum/modifier/underwater_stealth))
			to_chat(user, span_warning("You cannot use guns whilst hiding underwater!"))
			return FALSE
		else if(M.has_modifier_of_type(/datum/modifier/phased_out))
			to_chat(user, span_warning("You cannot use guns whilst incorporeal!"))
			return FALSE
		else if(M.has_modifier_of_type(/datum/modifier/rednet))
			to_chat(user, span_warning("Your gun refuses to fire!"))
			return FALSE
		else if(M.has_modifier_of_type(/datum/modifier/trait/thickdigits))
			to_chat(user, span_warning("Your hands can't pull the trigger!!"))
			return FALSE
		else if(M.has_modifier_of_type(/datum/modifier/shield_projection/melee_focus))
			to_chat(user, span_warning("The shield projection around you prevents you from using anything but melee!!"))
			return FALSE
	if(dna_lock && attached_lock.stored_dna)
		if(!authorized_user(user))
			if(attached_lock.safety_level == 0)
				to_chat(M, span_danger("\The [src] buzzes in dissapointment and displays an invalid DNA symbol."))
				return FALSE
			if(!attached_lock.exploding)
				if(attached_lock.safety_level == 1)
					to_chat(M, span_danger("\The [src] hisses in dissapointment."))
					visible_message(span_game(span_say(span_name("\The [src]") + " announces, \"Self-destruct occurring in ten seconds.\"")), span_game(span_say(span_name("\The [src]") + " announces, \"Self-destruct occurring in ten seconds.\"")))
					attached_lock.exploding = 1
					addtimer(CALLBACK(src, PROC_REF(lock_explosion)), 10 SECONDS, TIMER_DELETE_ME)
					return FALSE
	if(HULK in M.mutations)
		to_chat(M, span_danger("Your fingers are much too large for the trigger guard!"))
		return FALSE
	if((CLUMSY in M.mutations) && prob(40)) //Clumsy handling
		var/obj/P = consume_next_projectile()
		if(P)
			if(process_projectile(P, user, user, pick(BP_L_FOOT, BP_R_FOOT)))
				handle_post_fire(user, user)
				user.visible_message(
					span_danger("\The [user] shoots [user.p_themselves()] in the foot with \the [src]!"),
					span_danger("You shoot yourself in the foot with \the [src]!")
					)
				M.drop_item()
		else
			handle_click_empty(user)
		return FALSE
	return TRUE
