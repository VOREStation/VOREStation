/***
 * TODO Gattening: Unexist this file.
*/

// Exists to store procs that should stop existing by the end of the gattening rework



//Parent gun type. Guns are weapons that can be aimed at mobs and act over a distance
/obj/item/gun
	/// DEPRICATED
	var/automatic = 0
	/// DEPRICATED
	var/burst = 1
	/// DEPRICATED
	var/fire_delay = 6 	//delay after shooting before the gun can be used again
	/// DEPRICATED
	var/burst_delay = 2	//delay between shots, if firing in bursts
	/// DEPRICATED
	var/move_delay = 1
	/// DEPRICATED
	var/fire_sound = null // This is handled by projectile.dm's fire_sound var now, but you can override the projectile's fire_sound with this one if you want to.
	/// DEPRICATED
	var/fire_sound_text = "gunshot"
	/// DEPRICATED
	var/fire_anim = null
	/// DEPRICATED
	var/recoil = 0		//screen shake
	/// DEPRICATED
	var/silenced = 0
	/// DEPRICATED
	var/accuracy = 0   //Accuracy is measured in percents. +15 accuracy means that everything is effectively one tile closer for the purpose of miss chance, -15 means the opposite. launchers are not supported, at the moment.
	/// DEPRICATED
	var/scoped_accuracy = null
	/// DEPRICATED
	var/list/burst_accuracy = list(0) //allows for different accuracies for each shot in a burst. Applied on top of accuracy
	/// DEPRICATED
	var/list/dispersion = list(0)
	/// DEPRICATED
	var/mode_name = null

	/// DEPRICATED
	var/one_handed_penalty = 0 // Penalty applied if someone fires a two-handed gun with one hand.

	/// DEPRICATED
	var/shooting = 0
	/// DEPRICATED
	var/next_fire_time = 0

	/// DEPRICATED
	var/reload_time = 1		//Base reload time in seconds

	/// DEPRICATED
	var/last_shot = 0			//records the last shot fired
	/// DEPRICATED
	var/recoil_mode = 0			//If the gun will hurt micros if shot or not. Disabled on Virgo, used downstream.
	/// DEPRICATED
	var/mounted_gun = 0				//If the gun is mounted within a rigsuit or elsewhere. This makes it so the gun can be shot even if it's loc != a mob
	/// DEPRICATED

	/// DEPRICATED
	var/charge_sections = 4
	/// DEPRICATED
	var/shaded_charge = FALSE
	/// DEPRICATED
	var/ammo_x_offset = 2
	/// DEPRICATED
	var/ammo_y_offset = 0

	/// DEPRICATED
	var/projectile_type = /obj/item/projectile	//On ballistics, only used to check for the cham gun
