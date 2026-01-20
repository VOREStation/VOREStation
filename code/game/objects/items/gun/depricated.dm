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





/obj/item/projectile
	/// DEPRICATED
	var/fired = FALSE	//Have we been fired yet
	/// DEPRICATED
	var/casing_name = "bullet"
	/// DEPRICATED
	var/casing_desc = "a singular bullet, ready to go pew."

	/// DEPRICATED
	var/damage = 10
	/// DEPRICATED
	var/damage_type = BRUTE //BRUTE, BURN, TOX, OXY, CLONE, HALLOSS, ELECTROCUTE, BIOACID, SEARING are the only things that should be in here
	/// DEPRICATED
	var/mob_bonus_damage = 0 // Some bullets inflict extra damage on simple animals.
	/// DEPRICATED
	var/accuracy = 0
	/// DEPRICATED
	var/dispersion = 0.0
	/// DEPRICATED
	var/range = 50

	var/incendiary = 0 //1 for ignite on hit, 2 for trail of fire. 3 for intense fire. - Mech
	/// DEPRICATED
	var/flammability = 0 //Amount of fire stacks to add for the above.
	/// DEPRICATED
	var/combustion = TRUE	//Does this set off flammable objects on fire/hit?
	/// DEPRICATED
	var/stun = 0
	/// DEPRICATED
	var/weaken = 0
	/// DEPRICATED
	var/paralyze = 0
	/// DEPRICATED
	var/irradiate = 0
	/// DEPRICATED
	var/stutter = 0
	/// DEPRICATED
	var/eyeblur = 0
	/// DEPRICATED
	var/drowsy = 0
	/// DEPRICATED
	var/agony = 0
	/// DEPRICATED
	var/reflected = 0 // This should be set to 1 if reflected by any means, to prevent infinite reflections.
	/// DEPRICATED
	var/modifier_type_to_apply = null // If set, will apply a modifier to mobs that are hit by this projectile.
	/// DEPRICATED
	var/modifier_duration = null // How long the above modifier should last for. Leave null to be permanent.
	/// DEPRICATED
	var/excavation_amount = 0 // How much, if anything, it drills from a mineral turf.

	///If the rounds dephase or not
	/// DEPRICATED
	var/dephasing = FALSE
	///If the rounds hit phased entities or not.
	/// DEPRICATED
	var/hits_phased = FALSE

	/// DEPRICATED
	var/hitsound_wall = null // Played when something hits a wall, or anything else that isn't a mob.

	/// DEPRICATED
	var/homing = FALSE
	/// DEPRICATED
	var/homing_turn_speed = 10		//Angle per tick.
	/// DEPRICATED
	var/homing_inaccuracy_min = 0		//in pixels for these. offsets are set once when setting target.
	/// DEPRICATED
	var/homing_inaccuracy_max = 0

	/// DEPRICATED
	var/fire_sound = 'sound/weapons/gunshot_old.ogg' // Can be overriden in gun.dm's fire_sound var. It can also be null but I don't know why you'd ever want to do that. -Ace

	/// DEPRICATED
	var/vacuum_traversal = TRUE //Determines if the projectile can exist in vacuum, if false, the projectile will be deleted if it enters vacuum.

	/// DEPRICATED
	var/hud_state = "unknown" // What HUD state we use when we have ammunition.
	/// DEPRICATED
	var/hud_state_empty = "unknown" // The empty state. DON'T USE _FLASH IN THE NAME OF THE EMPTY STATE STRING, THAT IS ADDED BY THE CODE.

	/// DEPRICATED
	var/nodamage = 0 //Determines if the projectile will skip any damage inflictions
	/// DEPRICATED
	var/taser_effect = 0 //If set then the projectile will apply it's agony damage using stun_effect_act() to mobs it hits, and other damage will be ignored
	/// DEPRICATED
	var/check_armour = "bullet" //Defines what armor to use when it hits things.  Must be set to bullet, laser, energy,or bomb	//Cael - bio and rad are also valid
	/// DEPRICATED
	var/penetrating = 0 //If greater than zero, the projectile will pass through dense objects as specified by on_penetrate()

	// Sub-munitions. Basically, multi-projectile shotgun, rather than pellets.
	/// DEPRICATED
	var/use_submunitions = FALSE
	/// DEPRICATED
	var/only_submunitions = FALSE // Will the projectile delete itself after firing the submunitions?
	/// DEPRICATED
	var/submunition_spread_max = 30 // Divided by 10 to get the percentile dispersion.
	/// DEPRICATED
	var/submunition_spread_min = 5 // Above.
	/// DEPRICATED
	var/force_max_submunition_spread = FALSE // Do we just force the maximum?
	/// DEPRICATED
	var/spread_submunition_damage = FALSE // Do we assign damage to our sub projectiles based on our main projectile damage?

	/// DEPRICATED
	var/hitscan_light_intensity = 1.5
	/// DEPRICATED
	var/hitscan_light_range = 0.75
	/// DEPRICATED
	var/hitscan_light_color_override
	/// DEPRICATED
	var/muzzle_flash_intensity = 3
	/// DEPRICATED
	var/muzzle_flash_range = 1.5
	/// DEPRICATED
	var/muzzle_flash_color_override
	/// DEPRICATED
	var/impact_light_intensity = 3
	/// DEPRICATED
	var/impact_light_range = 2
	/// DEPRICATED
	var/impact_light_color_override

	/// DEPRICATED
	var/hitscan = FALSE		//Whether this is hitscan. If it is, speed is basically ignored.
	/// DEPRICATED
	var/tracer_type
	/// DEPRICATED
	var/muzzle_type
	/// DEPRICATED
	var/impact_type

	/// DEPRICATED
	var/ricochets = 0
	/// DEPRICATED
	var/ricochets_max = 2
	/// DEPRICATED
	var/ricochet_chance = 30
	/// DEPRICATED
	var/can_miss = TRUE
	/// DEPRICATED
	var/bump_targets = TRUE //Should we bump and/or attack objects we hit? Used only for 'raytraces' e.g. subtype /test

	// When a non-hitscan projectile hits something, a visual effect can be spawned.
	// This is distinct from the hitscan's "impact_type" var.
	/// DEPRICATED
	var/impact_effect_type = null
