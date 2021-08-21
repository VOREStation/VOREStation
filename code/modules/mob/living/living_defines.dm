/mob/living
	see_invisible = SEE_INVISIBLE_LIVING

	//Health and life related vars
	var/maxHealth = 100 //Maximum health that should be possible.  Avoid adjusting this if you can, and instead use modifiers datums.
	var/health = 100 	//A mob's health

	var/mob_class = null	// A mob's "class", e.g. human, mechanical, animal, etc. Used for certain projectile effects. See __defines/mob.dm for available classes.

	var/hud_updateflag = 0

	//Damage related vars, NOTE: THESE SHOULD ONLY BE MODIFIED BY PROCS
	var/bruteloss = 0.0	//Brutal damage caused by brute force (punching, being clubbed by a toolbox ect... this also accounts for pressure damage)
	var/oxyloss = 0.0	//Oxygen depravation damage (no air in lungs)
	var/toxloss = 0.0	//Toxic damage caused by being poisoned or radiated
	var/fireloss = 0.0	//Burn damage caused by being way too hot, too cold or burnt.
	var/cloneloss = 0	//Damage caused by being cloned or ejected from the cloner early. slimes also deal cloneloss damage to victims
	var/brainloss = 0	//'Retardation' damage caused by someone hitting you in the head with a bible or being infected with brainrot.
	var/halloss = 0		//Hallucination damage. 'Fake' damage obtained through hallucinating or the holodeck. Sleeping should cause it to wear off.

	var/nutrition = 400
	var/max_nutrition = MAX_NUTRITION

	var/hallucination = 0 //Directly affects how long a mob will hallucinate for
	var/list/atom/hallucinations = list() //A list of hallucinated people that try to attack the mob. See /obj/effect/fake_attacker in hallucinations.dm

	var/last_special = 0 //Used by the resist verb, likely used to prevent players from bypassing next_move by logging in/out.
	var/base_attack_cooldown = DEFAULT_ATTACK_COOLDOWN

	var/t_phoron = null
	var/t_oxygen = null
	var/t_sl_gas = null
	var/t_n2 = null

	var/now_pushing = null
	var/mob_bump_flag = 0
	var/mob_swap_flags = 0
	var/mob_push_flags = 0
	var/mob_always_swap = 0

	var/mob/living/cameraFollow = null
	var/list/datum/action/actions = list()

	var/tod = null // Time of death
	var/update_slimes = 1
	var/silent = null 		// Can't talk. Value goes down every life proc.
	var/on_fire = 0 //The "Are we on fire?" var
	var/fire_stacks

	var/failed_last_breath = 0 //This is used to determine if the mob failed a breath. If they did fail a brath, they will attempt to breathe each tick, otherwise just once per 4 ticks.
	var/lastpuke = 0

	var/evasion = 0 // Makes attacks harder to land. Negative numbers increase hit chance.
	var/force_max_speed = 0 // If 1, the mob runs extremely fast and cannot be slowed.

	var/image/dsoverlay = null //Overlay used for darksight eye adjustments

	var/glow_toggle = 0					// If they're glowing!
	var/glow_range = 2
	var/glow_intensity = null
	var/glow_color = "#FFFFFF"			// The color they're glowing!

	var/see_invisible_default = SEE_INVISIBLE_LIVING

	var/nest				//Not specific, because a Nest may be the prop nest, or blob factory in this case.

	var/list/hud_list		//Holder for health hud, status hud, wanted hud, etc (not like inventory slots)
	var/has_huds = FALSE	//Whether or not we should bother initializing the above list

	var/makes_dirt = TRUE	//FALSE if the mob shouldn't be making dirt on the ground when it walks

	var/looking_elsewhere = FALSE //If the mob's view has been relocated to somewhere else, like via a camera or with binocs

	var/image/selected_image = null // Used for buildmode AI control stuff.

	var/allow_self_surgery = FALSE	// Used to determine if the mob can perform surgery on itself.


	var/tail_alt = 0
	var/flying = 0				// Allows flight
	var/inventory_panel_type = /datum/inventory_panel
	var/datum/inventory_panel/inventory_panel
	var/last_resist_time = 0 // world.time of the most recent resist that wasn't on cooldown. 
