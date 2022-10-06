// Reorganized and somewhat cleaned up.
// AI code has been made into a datum, inside the AI module folder.


/mob/living/simple_mob
	name = "animal"
	desc = ""
	icon = 'icons/mob/animal.dmi'
	health = 20
	maxHealth = 20

	// Generally we don't want simple_mobs to get displaced when bumped into due to it trivializing combat with windup attacks.
	// Some subtypes allow displacement, like passive animals.
	mob_bump_flag = HEAVY
	mob_swap_flags = ~HEAVY
	mob_push_flags = ~HEAVY

	has_huds = TRUE // We do show AI status huds for buildmode players

	var/tt_desc = null //Tooltip description

	//Settings for played mobs
	var/show_stat_health = 1		// Does the percentage health show in the stat panel for the mob
	var/has_hands = 0				// Set to 1 to enable the use of hands and the hands hud
	var/humanoid_hands = 0			// Can a player in this mob use things like guns or AI cards?
	var/hand_form = "hands"			// Used in IsHumanoidToolUser. 'Your X are not fit-'.
	var/list/hud_gears				// Slots to show on the hud (typically none)
	var/ui_icons					// Icon file path to use for the HUD, otherwise generic icons are used
	var/r_hand_sprite				// If they have hands,
	var/l_hand_sprite				// they could use some icons.
	var/player_msg					// Message to print to players about 'how' to play this mob on login.

	//Mob icon/appearance settings
	var/icon_living = ""			// The iconstate if we're alive, required
	var/icon_dead = ""				// The iconstate if we're dead, required
	var/icon_gib = "generic_gib"	// The iconstate for being gibbed, optional. Defaults to a generic gib animation.
	var/icon_rest = null			// The iconstate for resting, optional
	var/image/modifier_overlay = null // Holds overlays from modifiers.
	var/image/eye_layer = null		// Holds the eye overlay.
	var/has_eye_glow = FALSE		// If true, adds an overlay over the lighting plane for [icon_state]-eyes.
	var/custom_eye_color = null
	attack_icon = 'icons/effects/effects.dmi' //Just the default, played like the weapon attack anim
	attack_icon_state = "slash" //Just the default

	//Mob talking settings
	universal_speak = 0				// Can all mobs in the entire universe understand this one?
	var/has_langs = list(LANGUAGE_GALCOM)// Text name of their language if they speak something other than galcom. They speak the first one.

	//Movement things.
	var/movement_cooldown = 5			// Lower is faster.
	var/movement_sound = null			// If set, will play this sound when it moves on its own will.
	var/turn_sound = null				// If set, plays the sound when the mob's dir changes in most cases.
	var/movement_shake_radius = 0		// If set, moving will shake the camera of all living mobs within this radius slightly.
	var/aquatic_movement = 0			// If set, the mob will move through fluids with no hinderance.

	//Mob interaction
	var/response_help   = "tries to help"	// If clicked on help intent
	var/response_disarm = "tries to disarm" // If clicked on disarm intent
	var/response_harm   = "tries to hurt"	// If clicked on harm intent
	var/list/friends = list()		// Mobs on this list wont get attacked regardless of faction status.
	var/harm_intent_damage = 3		// How much an unarmed harm click does to this mob.
	var/list/loot_list = list()		// The list of lootable objects to drop, with "/path = prob%" structure
	var/obj/item/weapon/card/id/myid// An ID card if they have one to give them access to stuff.
	var/organ_names = /decl/mob_organ_names //'False' bodyparts that can be shown as hit by projectiles in place of the default humanoid bodyplan.

	//Mob environment settings
	var/minbodytemp = 250			// Minimum "okay" temperature in kelvin
	var/maxbodytemp = 350			// Maximum of above
	var/heat_damage_per_tick = 3	// Amount of damage applied if animal's body temperature is higher than maxbodytemp
	var/cold_damage_per_tick = 2	// Same as heat_damage_per_tick, only if the bodytemperature it's lower than minbodytemp

	var/min_oxy = 5					// Oxygen in moles, minimum, 0 is 'no minimum'
	var/max_oxy = 0					// Oxygen in moles, maximum, 0 is 'no maximum'
	var/min_tox = 0					// Phoron min
	var/max_tox = 1					// Phoron max
	var/min_co2 = 0					// CO2 min
	var/max_co2 = 5					// CO2 max
	var/min_n2 = 0					// N2 min
	var/max_n2 = 0					// N2 max
	var/unsuitable_atoms_damage = 2	// This damage is taken when atmos doesn't fit all the requirements above

	//Hostility settings
	var/taser_kill = 1				// Is the mob weak to tasers

	//Attack ranged settings
	var/projectiletype				// The projectiles I shoot
	var/projectilesound				// The sound I make when I do it
	var/projectile_accuracy = 0		// Accuracy modifier to add onto the bullet when its fired.
	var/projectile_dispersion = 0	// How many degrees to vary when I do it.
	var/casingtype					// What to make the hugely laggy casings pile out of

	// Reloading settings, part of ranged code
	var/needs_reload = FALSE							// If TRUE, mob needs to reload occasionally
	var/reload_max = 1									// How many shots the mob gets before it has to reload, will not be used if needs_reload is FALSE
	var/reload_count = 0								// A counter to keep track of how many shots the mob has fired so far. Reloads when it hits reload_max.
	var/reload_time = 4 SECONDS							// How long it takes for a mob to reload. This is to buy a player a bit of time to run or fight.
	var/reload_sound = 'sound/weapons/flipblade.ogg'	// What sound gets played when the mob successfully reloads. Defaults to the same sound as reloading guns. Can be null.

	//Mob melee settings
	var/melee_damage_lower = 2		// Lower bound of randomized melee damage
	var/melee_damage_upper = 6		// Upper bound of randomized melee damage
	var/list/attacktext = list("attacked") // "You are [attacktext] by the mob!"
	var/list/friendly = list("nuzzles") // "The mob [friendly] the person."
	var/attack_sound = null				// Sound to play when I attack
	var/melee_miss_chance = 0			// percent chance to miss a melee attack.
	var/attack_armor_type = "melee"		// What armor does this check?
	var/attack_armor_pen = 0			// How much armor pen this attack has.
	var/attack_sharp = FALSE			// Is the attack sharp?
	var/attack_edge = FALSE				// Does the attack have an edge?

	var/melee_attack_delay = 2			// If set, the mob will do a windup animation and can miss if the target moves out of the way.
	var/ranged_attack_delay = null
	var/special_attack_delay = null

	//Special attacks
//	var/special_attack_prob = 0				// The chance to ATTEMPT a special_attack_target(). If it fails, it will do a regular attack instead.
											// This is commented out to ease the AI attack logic by being (a bit more) determanistic.
											// You should instead limit special attacks using the below vars instead.
	var/special_attack_min_range = null		// The minimum distance required for an attempt to be made.
	var/special_attack_max_range = null		// The maximum for an attempt.
	var/special_attack_charges = null		// If set, special attacks will work off of a charge system, and won't be usable if all charges are expended. Good for grenades.
	var/special_attack_cooldown = null		// If set, special attacks will have a cooldown between uses.
	var/last_special_attack = null			// world.time when a special attack occured last, for cooldown calculations.

	//Damage resistances
	var/grab_resist = 0				// Chance for a grab attempt to fail. Note that this is not a true resist and is just a prob() of failure.
	var/resistance = 0				// Damage reduction for all types
	var/list/armor = list(			// Values for normal getarmor() checks
				"melee" = 0,
				"bullet" = 0,
				"laser" = 0,
				"energy" = 0,
				"bomb" = 0,
				"bio" = 100,
				"rad" = 100
				)
	var/list/armor_soak = list(		// Values for getsoak() checks.
				"melee" = 0,
				"bullet" = 0,
				"laser" = 0,
				"energy" = 0,
				"bomb" = 0,
				"bio" = 0,
				"rad" = 0
				)
	// Protection against heat/cold/electric/water effects.
	// 0 is no protection, 1 is total protection. Negative numbers increase vulnerability.
	var/heat_resist = 0.0
	var/cold_resist = 0.0
	var/shock_resist = 0.0
	var/water_resist = 1.0
	var/poison_resist = 0.0
	var/thick_armor = FALSE // Stops injections and "injections".
	var/purge = 0					// Cult stuff.
	var/supernatural = FALSE		// Ditto.

	// contained in a cage
	var/in_stasis = 0

	// don't process me if there's nobody around to see it
	low_priority = TRUE
	// Used for if the mob can drop limbs. Overrides species dmi.
	var/limb_icon
	// Used for if the mob can drop limbs. Overrides the icon cache key, so it doesn't keep remaking the icon needlessly.
	var/limb_icon_key
	var/understands_common = TRUE 		//VOREStation Edit - Makes it so that simplemobs can understand galcomm without being able to speak it.
	var/heal_countdown = 5				//VOREStation Edit - A cooldown ticker for passive healing
	var/obj/item/weapon/card/id/mobcard = null //VOREStation Edit
	var/list/mobcard_access = list() //VOREStation Edit
	var/mobcard_provided = FALSE //VOREStation Edit

/mob/living/simple_mob/Initialize()
	verbs -= /mob/verb/observe
	health = maxHealth

	if(mobcard_provided) //VOREStation Edit
		mobcard = new /obj/item/weapon/card/id(src)
		mobcard.access = mobcard_access.Copy()

	for(var/L in has_langs)
		languages |= GLOB.all_languages[L]
	if(languages.len)
		default_language = languages[1]

	if(has_eye_glow)
		add_eyes()

	if(organ_names)
		organ_names = GET_DECL(organ_names)

	return ..()

/mob/living/simple_mob/Destroy()
	default_language = null
	if(myid)
		qdel(myid)
		myid = null

	friends.Cut()
	languages.Cut()

	if(has_eye_glow)
		remove_eyes()
	return ..()

/mob/living/simple_mob/death()
	update_icon()
	..()

//Client attached
/mob/living/simple_mob/Login()
	. = ..()
	to_chat(src,"<b>You are \the [src].</b> [player_msg]")

/mob/living/simple_mob/SelfMove(turf/n, direct, movetime)
	var/turf/old_turf = get_turf(src)
	var/old_dir = dir
	. = ..()
	if(. && movement_shake_radius)
		for(var/mob/living/L in range(movement_shake_radius, src))
			shake_camera(L, 1, 1)
	if(turn_sound && dir != old_dir)
		playsound(src, turn_sound, 50, 1)
	else if(movement_sound && old_turf != get_turf(src)) // Playing both sounds at the same time generally sounds bad.
		playsound(src, movement_sound, 50, 1)
/*
/mob/living/simple_mob/set_dir(new_dir)
	if(dir != new_dir)
		playsound(src, turn_sound, 50, 1)
	return ..()
*/
/mob/living/simple_mob/movement_delay()
	. = movement_cooldown

	if(force_max_speed)
		return -3

	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.haste) && M.haste == TRUE)
			return -3
		if(!isnull(M.slowdown))
			. += M.slowdown

	// Turf related slowdown
	var/turf/T = get_turf(src)
	if(T && T.movement_cost && (!hovering || !flying)) // Flying mobs ignore turf-based slowdown. Aquatic mobs ignore water slowdown, and can gain bonus speed in it.
		if(istype(T,/turf/simulated/floor/water) && aquatic_movement)
			. -= aquatic_movement - 1
		else
			. += T.movement_cost
		if(flying)
			adjust_nutrition(-0.5)

	if(purge)//Purged creatures will move more slowly. The more time before their purge stops, the slower they'll move.
		if(. <= 0)
			. = 1
		. *= purge

	if(m_intent == "walk")
		. *= 1.5

	 . += config.animal_delay

	 . += ..()


/mob/living/simple_mob/Stat()
	..()
	if(statpanel("Status") && show_stat_health)
		stat(null, "Health: [round((health / getMaxHealth()) * 100)]%")

/mob/living/simple_mob/lay_down()
	..()
	if(resting && icon_rest)
		icon_state = icon_rest
	else
		icon_state = icon_living
	update_icon()


/mob/living/simple_mob/say_quote(var/message, var/datum/language/speaking = null)
	if(speak_emote.len)
		. = pick(speak_emote)
	else if(speaking)
		. = ..()

/mob/living/simple_mob/get_speech_ending(verb, var/ending)
	return verb

/mob/living/simple_mob/is_sentient()
	return mob_class & MOB_CLASS_HUMANOID|MOB_CLASS_ANIMAL|MOB_CLASS_SLIME // Update this if needed.

/mob/living/simple_mob/get_nametag_desc(mob/user)
	return "<i>[tt_desc]</i>"

/mob/living/simple_mob/make_hud_overlays()
	hud_list[STATUS_HUD]  = gen_hud_image(buildmode_hud, src, "ai_0", plane = PLANE_BUILDMODE)
	hud_list[LIFE_HUD]	  = gen_hud_image(buildmode_hud, src, "ais_1", plane = PLANE_BUILDMODE)
	add_overlay(hud_list)

//VOREStation Add Start		Makes it so that simplemobs can understand galcomm without being able to speak it.
/mob/living/simple_mob/say_understands(var/mob/other, var/datum/language/speaking = null)
	if(understands_common && speaking?.name == LANGUAGE_GALCOM)
		return TRUE
	return ..()
//Vorestation Add End

/decl/mob_organ_names
	var/list/hit_zones = list("body") //When in doubt, it's probably got a body.

//VOREStation Add Start 	For allowing mobs with ID's door access
/mob/living/simple_mob/Bump(var/atom/A)
	if(mobcard && istype(A, /obj/machinery/door))
		var/obj/machinery/door/D = A
		if(client && !istype(D, /obj/machinery/door/firedoor) && !istype(D, /obj/machinery/door/blast) && !istype(D, /obj/machinery/door/airlock/lift) && D.check_access(mobcard))
			D.open()
	else
		..()
//Vorestation Add End
