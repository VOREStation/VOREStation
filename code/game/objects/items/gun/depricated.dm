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

	var/shooting = 0
	var/next_fire_time = 0

	var/reload_time = 1		//Base reload time in seconds

	//aiming system stuff
	var/keep_aim = 1 	//1 for keep shooting until aim is lowered
						//0 for one bullet after tarrget moves and aim is lowered
	var/multi_aim = 0 //Used to determine if you can target multiple people.
	var/tmp/list/mob/living/aim_targets //List of who yer targeting.
	var/tmp/mob/living/last_moved_mob //Used to fire faster at more than one person.
	var/tmp/told_cant_shoot = 0 //So that it doesn't spam them with the fact they cannot hit them.
	var/tmp/lock_time = -100


	var/last_shot = 0			//records the last shot fired
	var/recoil_mode = 0			//If the gun will hurt micros if shot or not. Disabled on Virgo, used downstream.
	var/mounted_gun = 0				//If the gun is mounted within a rigsuit or elsewhere. This makes it so the gun can be shot even if it's loc != a mob

	var/charge_sections = 4
	var/shaded_charge = FALSE
	var/ammo_x_offset = 2
	var/ammo_y_offset = 0
