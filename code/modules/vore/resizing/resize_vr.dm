
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
	var/holder_default

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
	M.Scale(size_multiplier)
	M.Translate(0, 16*(size_multiplier-1))
	src.transform = M

/**
 * Get the effective size of a mob.
 * Currently this is based only on size_multiplier for micro/macro stuff,
 * but in the future we may also incorporate the "mob_size", so that
 * a macro mouse is still only effectively "normal" or a micro dragon is still large etc.
 */
/mob/proc/get_effective_size()
	return 100000 //Whatever it is, it's too big to pick up, or it's a ghost, or something.

/mob/living/get_effective_size()
	return src.size_multiplier

/**
 * Resizes the mob immediately to the desired mod, animating it growing/shrinking.
 * It can be used by anything that calls it.
 */
/mob/living/proc/resize(var/new_size, var/animate = TRUE)
	if(size_multiplier == new_size)
		return 1
	//ASSERT(new_size >= RESIZE_TINY && new_size <= RESIZE_HUGE) //You served your use. Now scurry off and stop spamming my chat.
	if(animate)
		var/matrix/resize = matrix() // Defines the matrix to change the player's size
		resize.Scale(new_size) //Change the size of the matrix
		resize.Translate(0, 16 * (new_size - 1)) //Move the player up in the tile so their feet align with the bottom
		animate(src, transform = resize, time = 5) //Animate the player resizing
	size_multiplier = new_size //Change size_multiplier so that other items can interact with them

/mob/living/carbon/human/resize(var/new_size, var/animate = TRUE)
	if(..()) return 1
	var/new_y_offset = 32 * (size_multiplier - 1)
	for(var/I in hud_list)
		var/image/HI = I
		HI.pixel_y = new_y_offset

// Optimize mannequins - never a point to animating or doing HUDs on these.
/mob/living/carbon/human/dummy/mannequin/resize(var/new_size)
	size_multiplier = new_size

/**
 * Verb proc for a command that lets players change their size OOCly.
 * Ace was here! Redid this a little so we'd use math for shrinking characters. This is the old code.
 */


/mob/living/proc/set_size()
	set name = "Adjust Mass"
	set category = "Abilities" //Seeing as prometheans have an IC reason to be changing mass.

	var/nagmessage = "Adjust your mass to be a size between 25 to 200% (DO NOT ABUSE)"
	var/new_size = input(nagmessage, "Pick a Size") as num|null
	if(new_size && IsInRange(new_size,25,200))
		src.resize(new_size/100)
		message_admins("[key_name(src)] used the resize command in-game to be [new_size]% size. \
			([src ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>" : "null"])")

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
/mob/living/proc/attempt_to_scoop(var/mob/living/carbon/human/H)
	var/size_diff = H.get_effective_size() - src.get_effective_size()
	if(!src.holder_default && src.holder_type)
		src.holder_default = src.holder_type
	if(!istype(H))
		return 0;
	if(H.buckled)
		usr << "<span class='notice'>You have to unbuckle \the [H] before you pick them up.</span>"
		return 0
	if(size_diff >= 0.50)
		src.holder_type = /obj/item/weapon/holder/micro
		var/obj/item/weapon/holder/m_holder = get_scooped(H)
		src.holder_type = src.holder_default
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
	if(abs(src.get_effective_size() - tmob.get_effective_size()) >= 0.50)
		now_pushing = 0
		if(src.get_effective_size() > tmob.get_effective_size())
			var/mob/living/carbon/human/H = src
			if(H.flying)
				return 1 //Silently pass without a message.
			if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/naga))
				src << "You carefully slither around [tmob]."
				tmob << "[src]'s huge tail slithers past beside you!"
			else
				src << "You carefully step over [tmob]."
				tmob << "[src] steps over you carefully!"
		if(tmob.get_effective_size() > src.get_effective_size())
			var/mob/living/carbon/human/H = tmob
			if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/naga))
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
	if(ishuman(src))
		var/mob/living/carbon/human/P = src
		if(P.flying) //If they're flying, don't do any special interactions.
			return
	if(ishuman(tmob))
		var/mob/living/carbon/human/D = tmob
		if(D.flying) //if the prey is flying, don't smush them.
			return

	if(src.a_intent == I_DISARM && src.canmove && !src.buckled)
		// If bigger than them by at least 0.75, move onto them and print message.
		if((src.get_effective_size() - tmob.get_effective_size()) >= 0.75)
			now_pushing = 0
			src.forceMove(tmob.loc)
			if(src.m_intent == "run") //Running down the hallway with disarm intent?
				tmob.resting = 1 //Force them down to the ground.
				var/mob/living/carbon/human/H = src
				if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/naga))
					src << "Your tail slides over [tmob], pushing them down to the ground!"
					tmob << "[src]'s tail slides over you, forcing you down to the ground!"
				else
					src << "You quickly push [tmob] to the ground with your foot!"
					tmob << "[src] pushes you down to the ground with their foot!"
				admin_attack_log(src, tmob, "Pinned [tmob.name] under foot.", "Was pinned under foot by [src.name].", "Pinned [tmob.name] under foot.")
				return 1
			if(src.m_intent == "walk") //Most likely intentionally stepping on them.
				var/size_damage_multiplier = (src.size_multiplier - tmob.size_multiplier)
				var/damage = (rand(15,30)* size_damage_multiplier) //Since stunned is broken, let's do this. Rand 15-30 multiplied by 1 min or 1.75 max. 15 holo to 52.5 holo, depending on RNG and size differnece.
				tmob.apply_damage(damage, HALLOSS)
				tmob.resting = 1
				var/mob/living/carbon/human/H = src
				admin_attack_log(src, tmob, "Pinned [tmob.name] under foot for [damage] HALLOSS.", "Was pinned under foot by [src.name] for [damage] HALLOSS.", "Pinned [tmob.name] under foot for [damage] HALLOSS.")
				if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/naga))
					src << "You push down on [tmob] with your tail, pinning them down under you!"
					tmob << "[src] pushes down on you with their tail, pinning you down below them!"
				else
					src << "You firmly push your foot down on [tmob], painfully but harmlessly pinning them to the ground!"
					tmob << "[src] firmly pushes their foot down on you, quite painfully but harmlessly pinning you do to the ground!"


	if(src.a_intent == I_HURT && src.canmove && !src.buckled)
		if((src.get_effective_size() - tmob.get_effective_size()) >= 0.75)
			now_pushing = 0
			src.forceMove(tmob.loc)
			var/size_damage_multiplier = (src.size_multiplier - tmob.size_multiplier)
			var/damage = (rand(1,3)* size_damage_multiplier) //Rand 1-3 multiplied by 1 min or 1.75 max. 1 min 5.25 max damage to each limb.
			var/calculated_damage = damage/2 //This will sting, but not kill. Does .5 to 2.625 damage, randomly, to each limb.

			if(src.m_intent == "run")
				var/mob/living/carbon/human/H = src
				if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/naga))
					src << "Your heavy tail carelessly slides past [tmob],  crushing them!"
					tmob << "[src] quickly goes over your body, carelessly crushing you with their heavy tail!"
					if(istype(tmob,/mob/living/carbon/human))
						var/mob/living/carbon/human/M = tmob
						M.drip(0.1)
						for(var/obj/item/organ/I in M.organs)
							tmob.take_overall_damage(calculated_damage, 0) //Due to the fact that this deals damage across random body parts, this should heal quite fast.
						admin_attack_log(src, M, "trampled [tmob.name] under foot for [damage * 10] damage.", "Was crushed under foot by [H.name] for [damage * 10] damage.", "Crushed [M.name] for [damage * 10] damage.")
				else
					src << "You carelessly step down onto [tmob], crushing them!!"
					tmob << "[src] steps carelessly on your body, crushing you!"
					if(istype(tmob,/mob/living/carbon/human))
						var/mob/living/carbon/human/M = tmob
						for(var/obj/item/organ/I in M.organs)
							tmob.take_overall_damage(calculated_damage, 0) // 5 damage min, 26.25 damage max, depending on size & RNG. If they're only stepped on once, the damage will heal over time.
						M.drip(0.1)
						admin_attack_log(src, M, "Crushed [tmob.name] under foot for [damage * 10] damage.", "Was crushed under foot by [H.name] for [damage * 10] damage.", "Crushed [M.name] for [damage * 10] damage.")
				return 1

			if(src.m_intent == "walk") //Oh my.
				damage = calculated_damage * 3.5 //Multiplies the above damage by 3.5. This means a min of 1.75 damage, or a max of 9.1875. damage to each limb, depending on size and RNG.
				var/mob/living/carbon/human/H = src
				if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/naga))
					src << "Your heavy tail slowly and methodically slides down upon [tmob], crushing against the floor below!"
					tmob << "[src]'s thick, heavy tail slowly and methodically slides down upon your body, mercilessly crushing you into the floor below."
					if(istype(tmob,/mob/living/carbon/human))
						var/mob/living/carbon/human/M = tmob
						for(var/obj/item/organ/I in M.organs)
							tmob.take_overall_damage(damage, 0) //17.5 damage min, 91.875 damage max. If they're only stepped on once, the damage will heal over time.
						M.drip(3) //The least of your problems, honestly.
						admin_attack_log(src, M, "Crushed [M.name] under foot for [damage * 10] damage.", "Was crushed under foot by [H.name] for [damage * 10] damage.", "Crushed [M.name] for [damage * 10] damage.")
				else
					src << "You methodically place your foot down upon [tmob]'s body, slowly applying pressure, crushing them against the floor below!"
					tmob << "[src] methodically places their foot upon your body, slowly applying pressure, crushing you against the floor below!"
					if(istype(tmob,/mob/living/carbon/human))
						var/mob/living/carbon/human/M = tmob
						for(var/obj/item/organ/I in M.organs)
							tmob.take_overall_damage(damage, 0)
						M.drip(3)
						admin_attack_log(src, M, "Crushed [M.name] under foot for [damage * 10] damage.", "Was crushed under foot by [H.name] for [damage * 10] damage.", "Crushed [M.name] for [damage * 10] damage.")
				return 1

	if(src.a_intent == I_GRAB && src.canmove && !src.buckled)
		if((src.get_effective_size() - tmob.get_effective_size()) >= 0.50)
			now_pushing = 0
			src.forceMove(tmob.loc)

			var/mob/living/carbon/human/H = src
			if(istype(H) && !H.shoes)
				// User is a human (capable of scooping) and not wearing shoes! Scoop into foot slot!
				equip_to_slot_if_possible(tmob.get_scooped(H), slot_shoes, 0, 1)
				if(istype(H.tail_style, /datum/sprite_accessory/tail/taur/naga))
					src << "You slither over [tmob] with your large, thick tail, smushing them against the ground before coiling up around them, trapping them within the tight confines of your tail!"
					tmob << "[src] slithers over you with their large, thick tail, smushing you against the ground before coiling up around you, trapping you within the tight confines of their tail!"
				else
					src << "You pin [tmob] down onto the floor with your foot and curl your toes up around their body, trapping them inbetween them!"
					tmob << "[src] pins you down to the floor with their foot and curls their toes up around your body, trapping you inbetween them!"
			else if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/naga))
				src << "You squish [tmob] under your large, thick tail, forcing them onto the ground!"
				tmob << "[src] pins you under their large, thick tail, forcing you onto the ground!!"
				tmob.resting = 1
			else
				src << "You step down onto [tmob], squishing them and forcing them down to the ground!"
				tmob << "[src] steps down and squishes you with their foot, forcing you down to the ground!"
				tmob.resting = 1
			return 1
