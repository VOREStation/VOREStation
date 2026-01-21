/*********************************************************************************************
 * The Gattening: Core principles.
 *
 * Guncode has always been a mess on this branch of ss13. With many major reworks and different
 * schools of thought on how guns should be done from arcade to hyper realistic. The goal of
 * this rework is to minimize duplicated code, vars, and remove copypasted code where bullets
 * need to do unique behaviors such as flamethrowers.
 *
 * The tool used to achieve this goal is the bulletdata datum.
 *
 * Projectiles, bullet casing items, and even guns themselves lack most unique logic. Guns exist
 * to check what bullet item is inside them, and that bullet item says what bulletdata datum
 * should be used when firing. This is done to minimize vars on items. In most cases the bullet
 * item itself shouldn't exist. Such as inside a magazine, where the bullet item is destroyed when
 * placed into the magazine, and simply becomes the typepath to the bulletdata datum, and is added
 * to a list of bulletdata datums in that magazine. This also applies to ammo boxes, and the currently
 * chambered round of the gun.
 *
 * When a gun shoots a bullet, it will get the bulletdata datum of the bullet currently in its chamber.
 * This is when the bulletdatum is actually be instantiated. All other times, only the PATH to the datum
 * is stored. This minimizes memory footprint. The projectile effect fired from the gun stores the
 * instantiated datum. The gun modifies the datum however it wants based on the gun's special snowflake
 * design, such as increasing damage. Though most gun modifiers should be BASE vars to the gun item.
 *
 * When the fired bullet hits a target, it will pass the projectile, and atom hit, into a proc on the
 * bulletdata datum. This proc will allow unique behavior on bullet impact, bullet end-of-range, etc.
 *
 * Guns restrict their ammo types based on using subtypes of a datum. For example a gun that uses 10mm
 * will restrict its bullets by setting its bullet datum path to /datum/bulletdata/10mm, all subtypes
 * of 10mm including the base type can fit in that gun. This allows multiple ammos to work automatically
 * on every gun capable of shooting that bullet subtype without manually having to list them on the gun
 * itself. Which is an issue present on older gun reworks.
 *
 **********************************************************************************************/

/datum/bulletdata
	var/casing_name = "bullet"
	var/casing_desc = "a singular bullet, ready to go pew."

	var/damage = 10
	var/damage_type = BRUTE //BRUTE, BURN, TOX, OXY, CLONE, HALLOSS, ELECTROCUTE, BIOACID, SEARING are the only things that should be in here
	var/mob_bonus_damage = 0 // Some bullets inflict extra damage on simple animals.
	var/accuracy = 0
	var/dispersion = 0.0
	var/range = 50

	// TODO - Confirmed keeping vars

	/// Played when something hits a wall, or anything else that isn't a mob.
	var/hitsound_wall = null

	///If the rounds dephase or not
	var/dephasing = FALSE
	///If the rounds hit phased entities or not.
	var/hits_phased = FALSE





	// TODO - Go through code and determine which of these should continue to exist
	var/incendiary = 0 //1 for ignite on hit, 2 for trail of fire. 3 for intense fire. - Mech
	var/flammability = 0 //Amount of fire stacks to add for the above.
	var/combustion = TRUE	//Does this set off flammable objects on fire/hit?
	var/stun = 0
	var/weaken = 0
	var/paralyze = 0
	var/irradiate = 0
	var/stutter = 0
	var/eyeblur = 0
	var/drowsy = 0
	var/agony = 0

	var/modifier_type_to_apply = null // If set, will apply a modifier to mobs that are hit by this projectile.
	var/modifier_duration = null // How long the above modifier should last for. Leave null to be permanent.
	var/excavation_amount = 0 // How much, if anything, it drills from a mineral turf.


	var/homing = FALSE
	var/homing_turn_speed = 10		//Angle per tick.
	var/homing_inaccuracy_min = 0		//in pixels for these. offsets are set once when setting target.
	var/homing_inaccuracy_max = 0

	var/fire_sound = 'sound/weapons/gunshot_old.ogg' // Can be overriden in gun.dm's fire_sound var. It can also be null but I don't know why you'd ever want to do that. -Ace

	var/vacuum_traversal = TRUE //Determines if the projectile can exist in vacuum, if false, the projectile will be deleted if it enters vacuum.

	var/hud_state = "unknown" // What HUD state we use when we have ammunition.
	var/hud_state_empty = "unknown" // The empty state. DON'T USE _FLASH IN THE NAME OF THE EMPTY STATE STRING, THAT IS ADDED BY THE CODE.

	var/nodamage = 0 //Determines if the projectile will skip any damage inflictions
	var/taser_effect = 0 //If set then the projectile will apply it's agony damage using stun_effect_act() to mobs it hits, and other damage will be ignored
	var/check_armour = "bullet" //Defines what armor to use when it hits things.  Must be set to bullet, laser, energy,or bomb	//Cael - bio and rad are also valid
	var/penetrating = 0 //If greater than zero, the projectile will pass through dense objects as specified by on_penetrate()

	// Sub-munitions. Basically, multi-projectile shotgun, rather than pellets.
	var/list/submunitions = list() // Assoc list of the paths of any submunitions, and how many they are. [projectilepath] = [projectilecount].
	var/use_submunitions = FALSE
	var/only_submunitions = FALSE // Will the projectile delete itself after firing the submunitions?
	var/submunition_spread_max = 30 // Divided by 10 to get the percentile dispersion.
	var/submunition_spread_min = 5 // Above.
	var/force_max_submunition_spread = FALSE // Do we just force the maximum?
	var/spread_submunition_damage = FALSE // Do we assign damage to our sub projectiles based on our main projectile damage?

	var/hitscan_light_intensity = 1.5
	var/hitscan_light_range = 0.75
	var/hitscan_light_color_override
	var/muzzle_flash_intensity = 3
	var/muzzle_flash_range = 1.5
	var/muzzle_flash_color_override
	var/impact_light_intensity = 3
	var/impact_light_range = 2
	var/impact_light_color_override

	var/hitscan = FALSE		//Whether this is hitscan. If it is, speed is basically ignored.
	var/tracer_type
	var/muzzle_type
	var/impact_type

	var/spread = 0			//amount (in degrees) of projectile spread

	var/silenced = FALSE

	var/ricochets_max = 2
	var/ricochet_chance = 30
	var/can_miss = TRUE
	var/bump_targets = TRUE //Should we bump and/or attack objects we hit? Used only for 'raytraces' e.g. subtype /test

	// When a non-hitscan projectile hits something, a visual effect can be spawned.
	// This is distinct from the hitscan's "impact_type" var.
	var/impact_effect_type = null
	var/nondirectional_sprite = FALSE //Set TRUE to prevent projectiles from having their sprites rotated based on firing angle

/// Fired when a projectile hits an atom.
/datum/bulletdata/proc/on_hit(obj/item/projectile_new/shot, atom/hit_atom)
	// TODO - Bullet hit an atom

/// Fired when a projectile reaches its maximum range
/datum/bulletdata/proc/on_range(obj/item/projectile_new/shot)
	// So it does a little 'burst' effect, but not actually do anything (unless overrided).
	shot.impact_sounds(shot.loc)
	shot.impact_visuals(shot.loc)

/// Takes a /datum/bulletdata path and creates a projectile based on it's data. Returns the instantiated projectile
/proc/generate_projectile(obj/firer, bulletdata_path)
	RETURN_TYPE(/obj/item/projectile_new)

	// Create projectile
	var/obj/item/projectile_new/fired_shot = new(firer)
	fired_shot.shot_data = new bulletdata_path()
	// Apply datum to projectile

	return fired_shot
