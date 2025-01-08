/mob/living/simple_mob/vore/horse
	name = "small horse"
	desc = "Don't look it in the mouth."
	tt_desc = "Equus ferus caballus"

	icon_state = "horse"
	icon_living = "horse"
	icon_dead = "horse-dead"
	icon = 'icons/mob/vore.dmi'

	faction = FACTION_HORSE
	maxHealth = 60
	health = 60

	movement_cooldown = -2 //horses are fast mkay.
	see_in_dark = 6

	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"

	melee_damage_lower = 1
	melee_damage_upper = 5
	attacktext = list("kicked")

	meat_amount = 6
	meat_type = /obj/item/reagent_containers/food/snacks/meat

	max_buckled_mobs = 1 //Yeehaw
	can_buckle = TRUE
	buckle_movable = TRUE
	buckle_lying = FALSE
	mount_offset_x = 0

	say_list_type = /datum/say_list/horse
	ai_holder_type = /datum/ai_holder/simple_mob/retaliate

	allow_mind_transfer = TRUE

/mob/living/simple_mob/vore/horse/big
	name = "horse"
	icon_state = "horse"
	icon_living = "horse"
	icon_dead = "horse-dead"
	icon = 'icons/mob/vore64x64.dmi'

	maxHealth = 120
	health = 120

	melee_damage_lower = 5
	melee_damage_upper = 15
	attacktext = list("kicked")

	meat_amount = 10

	old_x = -16
	old_y = 0
	default_pixel_x = -16
	pixel_x = -16
	pixel_y = 0
	mount_offset_y = 22

// Activate Noms!
/mob/living/simple_mob/vore/horse
	vore_active = 1
	vore_icons = SA_ICON_LIVING

/mob/living/simple_mob/vore/horse/big
	vore_capacity = 2

/mob/living/simple_mob/vore/horse/Login()
	. = ..()
	if(!riding_datum)
		riding_datum = new /datum/riding/simple_mob(src)
	add_verb(src, /mob/living/simple_mob/proc/animal_mount)
	add_verb(src, /mob/living/proc/toggle_rider_reins)
	movement_cooldown = -2

/mob/living/simple_mob/vore/horse/MouseDrop_T(mob/living/M, mob/living/user)
	return

/mob/living/simple_mob/vore/horse/init_vore()
	if(!voremob_loaded)
		return
	. = ..()
	var/obj/belly/B = vore_selected
	B.name = "stomach"
	B.desc = "With a final few gulps, the horse finishes swallowing you down into its hot, dark gut... and with a slosh, your weight makes the equine's belly hang down slightly like some sort of organic hammock. The thick, humid air is tinged with the smell of half-digested grass, and the surrounding flesh wastes no time in clenching and massaging down over its newfound fodder."

	B.emote_lists[DM_HOLD] = list(
		"The horse's idle trotting helps its stomach gently churn around you, slimily squelching against your figure.",
		"The equine predator takes a moment to intentionally clench its gut around you, encapsulating you in a strange, fleshy hug.",
		"Some hot, viscous slime oozes down over your form, helping slicken you up during your stay.",
		"During a moment of relative silence, you can hear the beast's soft, relaxed breathing as it casually goes about its day.",
		"The thick, humid atmosphere within the horse's hanging belly works in tandem with its steady, metronome-like heartbeat to soothe you.",
		"Your surroundings sway from side to side as the horse trots about, as if it is showing off its newest catch.")

	B.emote_lists[DM_DIGEST] = list(
		"The horse huffs in annoyance before clenching those wrinkled walls tight against your form, grinding away at you!",
		"As the beast trots about, you're forced to slip and slide around amidst a pool of thick digestive goop!",
		"You can barely hear the horse let out a pleased nicker as its stomach eagerly gurgles around its newfound meal!",
		"As the thinning air begins to make you feel dizzy, menacing bworps and grumbles fill that dark, constantly shifting organ!",
		"The constant, rhythmic kneading and massaging starts to take its toll along with the muggy heat, making you feel weaker and weaker!",
		"The horse happily trots around while digesting its meal, almost like it is trying to show off the hanging gut you've given it.")

/datum/say_list/horse
	speak = list("NEHEHEHEHEH","Neh?")
	emote_hear = list("snorts","whinnies")
	emote_see = list("shakes its head", "stamps a hoof", "looks around")

//Kelpie resprite of the big horse

/mob/living/simple_mob/vore/horse/kelpie
	name = "kelpie"
	icon_state = "kelpie"
	icon_living = "kelpie"
	icon_dead = "kelpie-dead"
	icon = 'icons/mob/vore64x64.dmi'
	desc = "A darkly furred horse-like creature with piercing light green eyes. It's mane is a dark green and has an almost seaweed like texture."
	tt_desc = "Equus cailpeach"

	vore_capacity = 2
	maxHealth = 250
	health = 250
	meat_amount = 10

	old_x = -16
	old_y = 0
	default_pixel_x = -16
	pixel_x = -16
	pixel_y = 0
	mount_offset_y = 22
	say_list_type = /datum/say_list/horse/kelpie
	ai_holder_type = /datum/ai_holder/simple_mob/vore/kelpie

	vore_bump_chance = 75
	vore_pounce_chance = 75
	vore_pounce_maxhealth = 200
	vore_bump_emote	= "chomps down on"

/mob/living/simple_mob/vore/horse/kelpie/init_vore()
	if(!voremob_loaded)
		return
	. = ..()
	var/obj/belly/B = vore_selected
	B.name = "stomach"
	B.desc = "With a final few gulps, the kelpie finishes swallowing you down into its hot, humid gut... and with a slosh, your weight makes the equine's belly hang down slightly like some sort of organic hammock. The thick, damp air is tinged with the smell of seaweed, and the surrounding flesh wastes no time in clenching and massaging down over its newfound fodder."
	B.digest_brute = 3
	B.digest_burn = 3
	B.digestchance = 40
	B.absorbchance = 1
	B.escapechance = 7
	B.escape_stun = 5

	B.emote_lists[DM_HOLD] = list(
		"The kelpie's idle trotting helps its stomach gently churn around you, slimily squelching against your figure.",
		"The equine predator takes a moment to intentionally clench its gut around you, encapsulating you in a strange, fleshy hug.",
		"Some hot, viscous slime oozes down over your form, helping slicken you up during your stay.",
		"During a moment of relative silence, you can hear the beast's soft, relaxed breathing as it casually goes about its day.",
		"The thick, humid atmosphere within the kelpie's hanging belly works in tandem with its steady, metronome-like heartbeat to soothe you.",
		"Your surroundings sway from side to side as the kelpie trots about, as if it is showing off its newest catch.")

	B.emote_lists[DM_DIGEST] = list(
		"The kelpie huffs in annoyance before clenching those wrinkled walls tight against your form, grinding away at you!",
		"As the beast trots about, you're forced to slip and slide around amidst a pool of thick digestive goop!",
		"You can barely hear the horse let out a pleased nicker as its stomach eagerly gurgles around its newfound meal!",
		"As the thinning air begins to make you feel dizzy, menacing bworps and grumbles fill that dark, constantly shifting organ!",
		"The constant, rhythmic kneading and massaging starts to take its toll along with the muggy heat, making you feel weaker and weaker!",
		"The kelpie happily trots around while digesting its meal, almost like it is trying to show off the hanging gut you've given it.")

/datum/say_list/horse/kelpie
	speak = list("...","?")
	emote_hear = list("whispers something","lets out a high pitched, distorted neigh")
	emote_see = list("beckons you near", "watches", "swishes it's grass-like tail")

/datum/ai_holder/simple_mob/vore/kelpie

/datum/ai_holder/simple_mob/vore/kelpie/handle_wander_movement()
	if(!holder)
		return
	ai_log("handle_wander_movement() : Entered.", AI_LOG_TRACE)
	if(isturf(holder.loc) && can_act())
		wander_delay--
		var/turf/simulated/floor/water/deep/ocean/diving/sink = holder.loc
		var/turf/simulated/floor/water/underwater/surface = holder.loc
		var/mob/living/simple_mob/H = holder
		if(istype(sink) && H.vore_fullness)
			holder.zMove(DOWN)
			wander_delay = base_wander_delay
		else if(istype(surface) && !H.vore_fullness)
			holder.zMove(UP)
			wander_delay = base_wander_delay
		else if(wander_delay <= 0)
			if(!wander_when_pulled && (holder.pulledby || holder.grabbed_by.len))
				ai_log("handle_wander_movement() : Being pulled and cannot wander. Exiting.", AI_LOG_DEBUG)
				return

			var/moving_to = 0 // Apparently this is required or it always picks 4, according to the previous developer for simplemob AI.
			moving_to = pick(cardinal)
			holder.set_dir(moving_to)
			holder.IMove(get_step(holder,moving_to))
			wander_delay = base_wander_delay
	ai_log("handle_wander_movement() : Exited.", AI_LOG_TRACE)
