// Adding needed defines to /mob/living
// Note: Polaris had this on /mob/living/carbon/human We need it higher up for animals and stuff.
/mob/living
	var/holder_default
	var/step_mechanics_pref = TRUE		// Allow participation in macro-micro step mechanics
	var/pickup_pref = TRUE				// Allow participation in macro-micro pickup mechanics
	var/pickup_active = TRUE			// Toggle whether your help intent picks up micros or pets them

// Define holder_type on types we want to be scoop-able
/mob/living/carbon/human
	holder_type = /obj/item/weapon/holder/micro

// The reverse lookup of player_sizes_list, number to name.
/proc/player_size_name(var/size_multiplier)
	// (This assumes list is sorted big->small)
	for(var/N in player_sizes_list)
		. = N // So we return the smallest if we get to the end
		if(size_multiplier >= player_sizes_list[N])
			return N

/**
 * Scale up the size of a mob's icon by the size_multiplier.
 * NOTE: mob/living/carbon/human/update_icons() has a more complicated system and
 * 	is already applying this transform.   BUT, it does not call ..()
 *	as long as that is true, we should be fine.  If that changes we need to
 *	re-evaluate.
 */
/mob/living/update_icons()
	. = ..()
	ASSERT(!ishuman(src))
	var/matrix/M = matrix()
	M.Scale(size_multiplier * icon_scale_x, size_multiplier * icon_scale_y)
	M.Translate(0, (vis_height/2)*(size_multiplier-1))
	transform = M

/**
 * Get the effective size of a mob.
 * Currently this is based only on size_multiplier for micro/macro stuff,
 * but in the future we may also incorporate the "mob_size", so that
 * a macro mouse is still only effectively "normal" or a micro dragon is still large etc.
 */
/mob/proc/get_effective_size(var/micro = FALSE)
	return 100000 //Whatever it is, it's too big to pick up, or it's a ghost, or something.

/mob/living/get_effective_size(var/micro = FALSE)
	return size_multiplier

/mob/living/carbon/human/get_effective_size(var/micro = FALSE)		// Set micro to TRUE for interactions where you're small, to FALSE for ones where you're large.
	var/effective_size = size_multiplier
	if(micro)
		effective_size += species.micro_size_mod
	else
		effective_size += species.macro_size_mod
	return effective_size

/atom/movable/proc/size_range_check(size_select)		//both objects and mobs needs to have that
	var/area/A = get_area(src) //Get the atom's area to check for size limit.
	if((A?.limit_mob_size && (size_select > 200 || size_select < 25)) || (size_select > 600 || size_select <1))
		return FALSE
	return TRUE

/atom/movable/proc/has_large_resize_bounds()
	var/area/A = get_area(src) //Get the atom's area to check for size limit.
	return !A.limit_mob_size

/proc/is_extreme_size(size)
	return (size < RESIZE_MINIMUM || size > RESIZE_MAXIMUM)


/**
 * Resizes the mob immediately to the desired mod, animating it growing/shrinking.
 * It can be used by anything that calls it.
 */


/mob/living/proc/resize(var/new_size, var/animate = TRUE, var/uncapped = FALSE, var/ignore_prefs = FALSE, var/aura_animation = TRUE)
	if(!uncapped)
		new_size = clamp(new_size, RESIZE_MINIMUM, RESIZE_MAXIMUM)
		var/datum/component/resize_guard/guard = GetComponent(/datum/component/resize_guard)
		if(guard)
			qdel(guard)
	else if(has_large_resize_bounds())
		if(is_extreme_size(new_size))
			AddComponent(/datum/component/resize_guard)
		else
			var/datum/component/resize_guard/guard = GetComponent(/datum/component/resize_guard)
			if(guard)
				qdel(guard)

	if(size_multiplier == new_size)
		return 1

	size_multiplier = new_size //Change size_multiplier so that other items can interact with them

	if(animate)
		var/change = new_size - size_multiplier
		var/duration = (abs(change)+0.25) SECONDS
		var/matrix/resize = matrix() // Defines the matrix to change the player's size
		var/special_x = 1
		var/special_y = 1
		if(ishuman(src))
			var/mob/living/carbon/human/H = src
			var/datum/species/S = H.species
			special_x = S.icon_scale_x
			special_y = S.icon_scale_y
		resize.Scale(new_size * icon_scale_x * special_x, new_size * icon_scale_y * special_y) //Change the size of the matrix
		resize.Translate(0, (vis_height/2) * (new_size - 1)) //Move the player up in the tile so their feet align with the bottom
		animate(src, transform = resize, time = duration) //Animate the player resizing

		if(aura_animation)
			var/aura_grow_to = change > 0 ? 2 : 0.5
			var/aura_anim_duration = 5
			var/aura_offset = change > 0 ? 0 : 10
			var/aura_color = size_multiplier > new_size ? "#FF2222" : "#2222FF"
			var/aura_loops = round((duration)/aura_anim_duration)

			animate_aura(src, color = aura_color, offset = aura_offset, anim_duration = aura_anim_duration, loops = aura_loops, grow_to = aura_grow_to)
	else
		update_transform() //Lame way

/mob/living/carbon/human/resize(var/new_size, var/animate = TRUE, var/uncapped = FALSE, var/ignore_prefs = FALSE, var/aura_animation = TRUE)
	if(!resizable && !ignore_prefs)
		return 1
	. = ..()
	if(LAZYLEN(hud_list) && has_huds)
		var/new_y_offset = vis_height * (size_multiplier - 1)
		for(var/index = 1 to hud_list.len)
			var/image/HI = grab_hud(index)
			HI.pixel_y = new_y_offset
			apply_hud(index, HI)

// Optimize mannequins - never a point to animating or doing HUDs on these.
/mob/living/carbon/human/dummy/mannequin/resize(var/new_size, var/animate = TRUE, var/uncapped = FALSE, var/ignore_prefs = FALSE, var/aura_animation = TRUE)
	size_multiplier = new_size

/**
 * Verb proc for a command that lets players change their size OOCly.
 * Ace was here! Redid this a little so we'd use math for shrinking characters. This is the old code.
 */

/mob/living/proc/set_size()
	set name = "Adjust Mass"
	set category = "Abilities" //Seeing as prometheans have an IC reason to be changing mass.

	if(!resizable)
		to_chat(src, "<span class='warning'>You are immune to resizing!</span>")
		return

	var/nagmessage = "Adjust your mass to be a size between 25 to 200% (or 1% to 600% in dormitories). (DO NOT ABUSE)"
	var/default = size_multiplier * 100
	var/new_size = tgui_input_number(usr, nagmessage, "Pick a Size", default, 600, 1)
	if(size_range_check(new_size))
		resize(new_size/100, uncapped = has_large_resize_bounds(), ignore_prefs = TRUE)
		// I'm not entirely convinced that `src ? ADMIN_JMP(src) : "null"` here does anything
		// but just in case it does, I'm leaving the null-src checking
		log_admin("[key_name(src)] used the resize command in-game to be [new_size]% size. [src ? ADMIN_JMP(src) : "null"]")

/*
//Add the set_size() proc to usable verbs. By commenting this out, we can leave the proc and hand it to species that need it.
/hook/living_new/proc/resize_setup(mob/living/H)
	H.verbs += /mob/living/proc/set_size
	return 1
*/

/**
 * Attempt to scoop up this mob up into H's hands, if the size difference is large enough.
 * @return false if normal code should continue, 1 to prevent normal code.
 */
/mob/living/proc/attempt_to_scoop(mob/living/M, mob/living/G) //second one is for the Grabber, only exists for animals to self-grab
	if(!(pickup_pref && M.pickup_pref && M.pickup_active))
		return 0
	if(!(M.a_intent == I_HELP))
		return 0
	var/size_diff = M.get_effective_size(FALSE) - get_effective_size(TRUE)
	if(!holder_default && holder_type)
		holder_default = holder_type
	if(!istype(M))
		return 0
	if(isanimal(M))
		var/mob/living/simple_mob/SA = M
		if(!SA.has_hands)
			return 0
	if(size_diff >= 0.50 || mob_size < MOB_SMALL || size_diff >= get_effective_size())
		if(buckled)
			to_chat(usr,"<span class='notice'>You have to unbuckle \the [src] before you pick them up.</span>")
			return 0
		holder_type = /obj/item/weapon/holder/micro
		var/obj/item/weapon/holder/m_holder = get_scooped(M, G)
		holder_type = holder_default
		if (m_holder)
			return 1
		else
			return 0; // Unable to scoop, let other code run

#define STEP_TEXT_OWNER(x) "[replacetext(x,"%prey",tmob)]"
#define STEP_TEXT_PREY(x) "[replacetext(x,"%owner",src)]"
/**
 * Handle bumping into someone with helping intent.
 * Called from /mob/living/Bump() in the 'brohugs all around' section.
 * @return false if normal code should continue, true to prevent normal code.
 */
/mob/living/proc/handle_micro_bump_helping(mob/living/tmob)
	//Riding and being moved to us or something similar
	if(tmob in buckled_mobs)
		return TRUE

	//Both small! Go ahead and go.
	if(get_effective_size(TRUE) <= RESIZE_A_SMALLTINY && tmob.get_effective_size(TRUE) <= RESIZE_A_SMALLTINY)		// For help intent interaction just assume both are 'smol'
		return TRUE

	//Worthy of doing messages at all
	if(abs(get_effective_size(TRUE) - tmob.get_effective_size(TRUE)) >= 0.50)
		var/src_message = null
		var/tmob_message = null

		//Smaller person being stepped onto
		if(get_effective_size(TRUE) > tmob.get_effective_size(TRUE) && ishuman(src))
			src_message = "You carefully step over [tmob]."
			tmob_message = "[src] steps over you carefully!"
			var/mob/living/carbon/human/H = src
			if(H.flying)
				return TRUE //Silently pass without a message.
			if(istaurtail(H.tail_style))
				var/datum/sprite_accessory/tail/taur/tail = H.tail_style
				src_message = tail.msg_owner_help_run
				tmob_message = tail.msg_prey_help_run

		//Smaller person stepping under larger person
		else if(get_effective_size(TRUE) < tmob.get_effective_size(TRUE) && ishuman(tmob))
			src_message = "You run between [tmob]'s legs."
			tmob_message = "[src] runs between your legs."
			var/mob/living/carbon/human/H = tmob
			if(istaurtail(H.tail_style))
				var/datum/sprite_accessory/tail/taur/tail = H.tail_style
				src_message = tail.msg_prey_stepunder
				tmob_message = tail.msg_owner_stepunder

		if(src_message)
			to_chat(src, STEP_TEXT_OWNER(src_message))
		if(tmob_message)
			to_chat(tmob, STEP_TEXT_PREY(tmob_message))
		return TRUE
	return FALSE

/mob/living/proc/can_pass_into(turf/n, var/prey = null)
	for (var/atom/movable/M in n)
		if (prey == M)
			continue
		if (istype(M, /mob/living))
			var/mob/living/L = M
			if (!(M.CanPass(src, n) || get_effective_size(FALSE) - L.get_effective_size(TRUE) >= 0.75))
				return FALSE
			continue
		if (!M.CanPass(src, n))
			return FALSE
	return TRUE

/**
 * Handle bumping into someone without mutual help intent.
 * Called from /mob/living/Bump()
 *
 * @return false if normal code should continue, 1 to prevent normal code.
 */
/mob/living/proc/handle_micro_bump_other(mob/living/tmob)
	ASSERT(istype(tmob))
	//If we're flying, don't do any special interactions.
	if(flying)
		return
	//If the prey is flying, don't smush them.
	if(tmob.flying)
		return
	//We can't be stepping on anyone
	if(!canmove || buckled)
		return

	//Riding and being moved to us or something similar
	if(tmob in buckled_mobs)
		return TRUE

	//Test/set if human
	var/mob/living/carbon/human/pred = src
	if(!istype(pred))
		//If we're not human, can't do the steppy
		return FALSE

	var/mob/living/carbon/human/prey = tmob
	if(!istype(prey) || !(isturf(prey.loc) && can_pass_into(prey.loc, prey)))
		//If they're not human, steppy shouldn't happen
		return FALSE

	// We need to be above a certain size ratio in order to do anything to the prey.
	// For DISARM and HURT intent, this is >=0.75, for GRAB it is >=0.5
	var/size_ratio = get_effective_size(FALSE) - tmob.get_effective_size(TRUE)
	if(a_intent == I_GRAB && size_ratio < 0.5)
		return FALSE
	if((a_intent == I_DISARM || a_intent == I_HURT) && size_ratio < 0.75)
		return FALSE
	if(a_intent == I_HELP) // Theoretically not possible, but just in case.
		return FALSE

	if(tmob.a_intent != I_HELP && prob(35))
		to_chat(pred, "<span class='danger'>[prey] dodges out from under your foot!</span>")
		to_chat(prey, "<span class='danger'>You narrowly avoid [pred]'s foot!</span>")
		return FALSE

	now_pushing = 0
	forceMove(tmob.loc)
	if(a_intent == I_GRAB || a_intent == I_DISARM)
		if(tmob.a_intent == I_HELP)
			tmob.resting = 1
		else
			tmob.Weaken(1)

	var/size_damage_multiplier = size_multiplier - tmob.size_multiplier
	// This technically means that I_GRAB will set this value to the same as I_HARM, but
	// I_GRAB won't ever trigger the damage-giving code, so it doesn't matter.
	// I_HARM: Rand 1-3 multiplied by 1 min or 1.75 max. 1 min 5.25 max damage to each limb.
	// I_DISARM: Perform some HALLOSS damage to the smaller.
	//           Since stunned is broken, let's do this. Rand 15-30 multiplied by 1 min or 1.75 max. 15 holo to 52.5 holo, depending on RNG and size differnece.
	var/damage = (a_intent == I_DISARM) ? (rand(15, 30) * size_damage_multiplier) : (rand(1, 3) * size_damage_multiplier)
	// I_HARM only
	var/calculated_damage = damage / 2 //This will sting, but not kill. Does .5 to 2.625 damage, randomly, to each limb.

	var/message_pred = null
	var/message_prey = null
	var/datum/sprite_accessory/tail/taur/tail = null
	if(istaurtail(pred.tail_style))
		tail = pred.tail_style

	if(a_intent == I_GRAB)
		// You can only grab prey if you have no shoes on. And both of you are cool with it.
		if(pred.shoes || !(pred.pickup_pref && prey.pickup_pref))
			message_pred = "You step down onto [prey], squishing them and forcing them down to the ground!"
			message_prey = "[pred] steps down and squishes you with their foot, forcing you down to the ground!"
			if(tail)
				message_pred = STEP_TEXT_OWNER(tail.msg_owner_grab_fail)
				message_prey = STEP_TEXT_PREY(tail.msg_prey_grab_fail)
			add_attack_logs(pred, prey,"Grabbed underfoot ([tail ? "taur" : "nontaur"], shoes)")
		else
			message_pred = "You pin [prey] down onto the floor with your foot and curl your toes up around their body, trapping them inbetween them!"
			message_prey = "[pred] pins you down to the floor with their foot and curls their toes up around your body, trapping you inbetween them!"
			if(tail)
				message_pred = STEP_TEXT_OWNER(tail.msg_owner_grab_success)
				message_prey = STEP_TEXT_PREY(tail.msg_prey_grab_success)
			equip_to_slot_if_possible(prey.get_scooped(pred), slot_shoes, 0, 1)
			add_attack_logs(pred, prey, "Grabbed underfoot ([tail ? "taur" : "nontaur"], no shoes)")

	if(m_intent == "run")
		switch(a_intent)
			if(I_DISARM)
				message_pred = "You quickly push [prey] to the ground with your foot!"
				message_prey = "[pred] pushes you down to the ground with their foot!"
				if(tail)
					message_pred = STEP_TEXT_OWNER(tail.msg_owner_disarm_run)
					message_prey = STEP_TEXT_PREY(tail.msg_prey_disarm_run)
				add_attack_logs(pred, prey, "Pinned underfoot (run, no halloss)")
			if(I_HURT)
				message_pred = "You carelessly step down onto [prey], crushing them!"
				message_prey = "[pred] steps carelessly on your body, crushing you!"
				if(tail)
					message_pred = STEP_TEXT_OWNER(tail.msg_owner_harm_run)
					message_prey = STEP_TEXT_PREY(tail.msg_prey_harm_run)

				for(var/obj/item/organ/external/I in prey.organs)
					I.take_damage(calculated_damage, 0) // 5 damage min, 26.25 damage max, depending on size & RNG. If they're only stepped on once, the damage will (probably not...) heal over time.
				prey.drip(0.1)
				add_attack_logs(pred, prey, "Crushed underfoot (run, about [calculated_damage] damage)")
	else
		switch(a_intent)
			if(I_DISARM)
				message_pred = "You firmly push your foot down on [prey], painfully but harmlessly pinning them to the ground!"
				message_prey = "[pred] firmly pushes their foot down on you, quite painfully but harmlessly pinning you to the ground!"
				if(tail)
					message_pred = STEP_TEXT_OWNER(tail.msg_owner_disarm_walk)
					message_prey = STEP_TEXT_PREY(tail.msg_prey_disarm_walk)
				add_attack_logs(pred, prey, "Pinned underfoot (walk, about [damage] halloss)")
				tmob.Weaken(2) //Removed halloss because it was being abused
			if(I_HURT)
				message_pred = "You methodically place your foot down upon [prey]'s body, slowly applying pressure, crushing them against the floor below!"
				message_prey = "[pred] methodically places their foot upon your body, slowly applying pressure, crushing you against the floor below!"
				if(tail)
					message_pred = STEP_TEXT_OWNER(tail.msg_owner_harm_walk)
					message_prey = STEP_TEXT_PREY(tail.msg_prey_harm_walk)
				// Multiplies the above damage by 3.5. This means a min of 1.75 damage, or a max of 9.1875. damage to each limb, depending on size and RNG.
				calculated_damage *= 3.5
				for(var/obj/item/organ/I in prey.organs)
					I.take_damage(calculated_damage, 0)
				prey.drip(3)
				add_attack_logs(pred, prey, "Crushed underfoot (walk, about [calculated_damage] damage)")

	to_chat(pred, "<span class='danger'>[message_pred]</span>")
	to_chat(prey, "<span class='danger'>[message_prey]</span>")
	return TRUE

/mob/living/verb/toggle_pickups()
	set name = "Toggle Micro Pick-up"
	set desc = "Toggles whether your help-intent action attempts to pick up the micro or pet/hug/help them. Does not disable participation in pick-up mechanics entirely, refer to Vore Panel preferences for that."
	set category = "IC"

	pickup_active = !pickup_active
	to_chat(src, "You will [pickup_active ? "now" : "no longer"] attempt to pick up mobs when clicking them with help intent.")

#undef STEP_TEXT_OWNER
#undef STEP_TEXT_PREY
