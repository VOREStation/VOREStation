
//these aren't defines so they can stay in this file
var/const/RESIZE_HUGE = 2
var/const/RESIZE_BIG = 1.5
var/const/RESIZE_NORMAL = 1
var/const/RESIZE_SMALL = 0.5
var/const/RESIZE_TINY = 0.25

//average
var/const/RESIZE_A_HUGEBIG = (RESIZE_HUGE + RESIZE_BIG) / 2
var/const/RESIZE_A_BIGNORMAL = (RESIZE_BIG + RESIZE_NORMAL) / 2
var/const/RESIZE_A_NORMALSMALL = (RESIZE_NORMAL + RESIZE_SMALL) / 2
var/const/RESIZE_A_SMALLTINY = (RESIZE_SMALL + RESIZE_TINY) / 2

// Adding needed defines to /mob/living
// Note: Polaris had this on /mob/living/carbon/human We need it higher up for animals and stuff.
/mob/living
	var/size_multiplier = 1 //multiplier for the mob's icon size

// Define holder_type on types we want to be scoop-able
/mob/living/carbon/human
	holder_type = /obj/item/weapon/holder/micro

/**
 * Scale up the size of a mob's icon by the size_multiplier.
 * NOTE: mob/living/carbon/human/update_icons() has a more complicated system and
 * 	is already applying this transform.   BUT, it does not call ..()
 *	as long as that is true, we should be fine.  If that changes we need to
 *	re-evaluate.
 */
/mob/living/update_icons()
	ASSERT(!ishuman(src))
	var/matrix/M = matrix()
	M.Scale(size_multiplier)
	M.Translate(0, 16*(size_multiplier-1))
	src.transform = M

/**
 * Get the effective size of a mob.
 * Currently this is based only on size_multiplier for micro/macro stuff,
 * but in the future we may also incorporate the "mob_size", so that
 * a macro mouse is still only effectively "normal" or a micro dragon is still large etc.
 */
/mob/living/proc/get_effective_size()
	return src.size_multiplier

/**
 * Resizes the mob immediately to the desired mod, animating it growing/shrinking.
 * It can be used by anything that calls it.
 */
/mob/living/proc/resize(var/new_size)
	var/matrix/resize = matrix() // Defines the matrix to change the player's size
	resize.Scale(new_size) //Change the size of the matrix

	if(new_size >= RESIZE_NORMAL)
		resize.Translate(0, -1 * (1 - new_size) * 16) //Move the player up in the tile so their feet align with the bottom

	animate(src, transform = resize, time = 5) //Animate the player resizing
	size_multiplier = new_size //Change size_multiplier so that other items can interact with them

/**
 * Verb proc for a command that lets players change their size OOCly.
 * Ace was here! Redid this a little so we'd use math for shrinking characters. This is the old code.
 */
/mob/living/proc/set_size()
	set name = "Set Character Size"
	set category = "Vore"
	var/nagmessage = "DO NOT ABUSE THESE COMMANDS. They are not here for you to play with. \
			We were originally going to remove them but kept them for popular demand. \
			Do not abuse their existence outside of ERP scenes where they apply, \
			or reverting OOCly unwanted changes like someone lolshooting the crew with a shrink ray. -Ace"

	var/size_name = input(nagmessage, "Pick a Size") in player_sizes_list
	if (size_name && player_sizes_list[size_name])
		src.resize(player_sizes_list[size_name])
		message_admins("[key_name(src)] used the resize command in-game to be [size_name]. \
			([src ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>" : "null"])")

/** Add the set_size() proc to usable verbs. */
/hook/living_new/proc/resize_setup(mob/living/M)
	M.verbs += /mob/living/proc/set_size
	return 1

/**
 * Attempt to scoop up this mob up into M's hands, if the size difference is large enough.
 * @return false if normal code should continue, 1 to prevent normal code.
 */
/mob/living/proc/attempt_to_scoop(var/mob/living/carbon/human/M)
	if(!istype(M))
		return 0;
	if(M.get_effective_size() - src.get_effective_size() >= 0.75)
		var/obj/item/weapon/holder/m_holder = get_scooped(M)
		if (m_holder)
			return 1
		else
			return 0; // Unable to scoop, let other code run

/**
 * Handle bumping into someone with helping intent.
 * Called from /mob/living/Bump() in the 'brohugs all around' section.
 * @return false if normal code should continue, 1 to prevent normal code.
 * // TODO - can the now_pushing = 0 be moved up? What does it do anyway?
 */
/mob/living/proc/handle_micro_bump_helping(var/mob/living/tmob)
	if(src.get_effective_size() <= RESIZE_A_SMALLTINY && tmob.get_effective_size() <= RESIZE_A_SMALLTINY)
		// Both small! Go ahead and
		now_pushing = 0
		return 1
	if(abs(src.get_effective_size() - tmob.get_effective_size()) >= 0.75)
		now_pushing = 0
		if(src.get_effective_size() > tmob.get_effective_size())
			var/mob/living/carbon/human/M = src
			if(istype(M) && istype(M.tail_style, /datum/sprite_accessory/tail/taur/naga))
				src << "You carefully slither around [tmob]."
				tmob << "[src]'s huge tail slithers past beside you!"
			else
				src << "You carefully step over [tmob]."
				tmob << "[src] steps over you carefully!"
		if(tmob.get_effective_size() > src.get_effective_size())
			var/mob/living/carbon/human/M = tmob
			if(istype(M) && istype(M.tail_style, /datum/sprite_accessory/tail/taur/naga))
				src << "You jump over [tmob]'s thick tail."
				tmob << "[src] bounds over your tail."
			else
				src << "You run between [tmob]'s legs."
				tmob << "[src] runs between your legs."
		return 1

/**
 * Handle bumping into someone without mutual help intent.
 * Called from /mob/living/Bump()
 * NW was here, adding even more options for stomping!
 *
 * @return false if normal code should continue, 1 to prevent normal code.
 */
/mob/living/proc/handle_micro_bump_other(var/mob/living/tmob)
	ASSERT(istype(tmob)) // Baby don't hurt me

	if(src.a_intent == I_DISARM && src.canmove && !src.buckled)
		// If bigger than them by at least 0.75, move onto them and print message.
		if((src.get_effective_size() - tmob.get_effective_size()) >= 0.75)
			now_pushing = 0
			src.forceMove(tmob.loc)
			tmob.Stun(4)

			var/mob/living/carbon/human/M = src
			if(istype(M) && istype(M.tail_style, /datum/sprite_accessory/tail/taur/naga))
				src << "You carefully squish [tmob] under your tail!"
				tmob << "[src] pins you under their tail!"
			else
				src << "You pin [tmob] beneath your foot!"
				tmob << "[src] pins you beneath their foot!"
			return 1

	if(src.a_intent == I_HURT && src.canmove && !src.buckled)
		if((src.get_effective_size() - tmob.get_effective_size()) >= 0.75)
			now_pushing = 0
			src.forceMove(tmob.loc)
			tmob.apply_damage(10, HALLOSS)

			var/mob/living/carbon/human/M = src
			if(istype(M) && istype(M.tail_style, /datum/sprite_accessory/tail/taur/naga))
				src << "You steamroller over [tmob] with your heavy tail!"
				tmob << "[src] ploughs you down mercilessly with their heavy tail!"
			else
				src << "You bring your foot down heavily upon [tmob]!"
				tmob << "[src] steps carelessly on your body!"
			return 1

	if(src.a_intent == I_GRAB && src.canmove && !src.buckled)
		if((src.get_effective_size() - tmob.get_effective_size()) >= 0.75)
			now_pushing = 0
			src.forceMove(tmob.loc)

			var/mob/living/carbon/human/M = src
			if(istype(M) && !M.shoes)
				// User is a human (capable of scooping) and not wearing shoes! Scoop into foot slot!
				equip_to_slot_if_possible(tmob.get_scooped(M), slot_shoes, 0, 1)
				if(istype(M.tail_style, /datum/sprite_accessory/tail/taur/naga))
					src << "You wrap up [tmob] with your powerful tail!"
					tmob << "[src] binds you with their powerful tail!"
				else
					src << "You clench your toes around [tmob]'s body!"
					tmob << "[src] grabs your body with their toes!"
			else if(istype(M) && istype(M.tail_style, /datum/sprite_accessory/tail/taur/naga))
				src << "You carefully squish [tmob] under your tail!"
				tmob << "[src] pins you under their tail!"
			else
				src << "You pin [tmob] beneath your foot!"
				tmob << "[src] pins you beneath their foot!"
			return 1
