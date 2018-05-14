
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

	size_multiplier = new_size //Change size_multiplier so that other items can interact with them
	if(animate)
		var/change = new_size - size_multiplier
		var/duration = (abs(change)+0.25) SECONDS
		var/matrix/resize = matrix() // Defines the matrix to change the player's size
		resize.Scale(new_size) //Change the size of the matrix
		resize.Translate(0, 16 * (new_size - 1)) //Move the player up in the tile so their feet align with the bottom
		animate(src, transform = resize, time = duration) //Animate the player resizing

		var/aura_grow_to = change > 0 ? 2 : 0.5
		var/aura_anim_duration = 5
		var/aura_offset = change > 0 ? 0 : 10
		var/aura_color = size_multiplier > new_size ? "#FF2222" : "#2222FF"
		var/aura_loops = round((duration)/aura_anim_duration)

		animate_aura(src, color = aura_color, offset = aura_offset, anim_duration = aura_anim_duration, loops = aura_loops, grow_to = aura_grow_to)
	else
		update_transform() //Lame way

/mob/living/carbon/human/resize(var/new_size, var/animate = TRUE)
	. = ..()
	if(LAZYLEN(hud_list) && has_huds)
		var/new_y_offset = 32 * (size_multiplier - 1)
		for(var/index = 1 to hud_list.len)
			var/image/HI = grab_hud(index)
			HI.pixel_y = new_y_offset
			apply_hud(index, HI)

// Optimize mannequins - never a point to animating or doing HUDs on these.
/mob/living/carbon/human/dummy/mannequin/resize(var/new_size, var/animate = TRUE)
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
/mob/living/proc/attempt_to_scoop(var/mob/living/M)
	var/size_diff = M.get_effective_size() - get_effective_size()
	if(!holder_default && holder_type)
		holder_default = holder_type
	if(!istype(M))
		return 0
	if(isanimal(M))
		var/mob/living/simple_animal/SA = M
		if(!SA.has_hands)
			return 0
	if(M.buckled)
		to_chat(usr,"<span class='notice'>You have to unbuckle \the [M] before you pick them up.</span>")
		return 0
	if(size_diff >= 0.50)
		holder_type = /obj/item/weapon/holder/micro
		var/obj/item/weapon/holder/m_holder = get_scooped(M)
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
/mob/living/proc/handle_micro_bump_helping(var/mob/living/tmob)

	//Both small! Go ahead and go.
	if(src.get_effective_size() <= RESIZE_A_SMALLTINY && tmob.get_effective_size() <= RESIZE_A_SMALLTINY)
		return TRUE

	//Worthy of doing messages at all
	if(abs(get_effective_size() - tmob.get_effective_size()) >= 0.50)

		//Smaller person being stepped onto
		if(get_effective_size() > tmob.get_effective_size() && ishuman(src))
			var/mob/living/carbon/human/H = src
			if(H.flying)
				return TRUE //Silently pass without a message.
			if(isTaurTail(H.tail_style))
				var/datum/sprite_accessory/tail/taur/tail = H.tail_style
				to_chat(src,STEP_TEXT_OWNER(tail.msg_owner_help_run))
				to_chat(tmob,STEP_TEXT_PREY(tail.msg_prey_help_run))
			else
				to_chat(src,"You carefully step over [tmob].")
				to_chat(tmob,"[src] steps over you carefully!")

		//Smaller person stepping under larger person
		else if(tmob.get_effective_size() > get_effective_size() && ishuman(tmob))
			var/mob/living/carbon/human/H = tmob
			if(isTaurTail(H.tail_style))
				var/datum/sprite_accessory/tail/taur/tail = H.tail_style
				to_chat(src,STEP_TEXT_OWNER(tail.msg_prey_stepunder))
				to_chat(tmob,STEP_TEXT_PREY(tail.msg_owner_stepunder))
			else
				to_chat(src,"You run between [tmob]'s legs.")
				to_chat(tmob,"[src] runs between your legs.")
		return TRUE
	return FALSE

/**
 * Handle bumping into someone without mutual help intent.
 * Called from /mob/living/Bump()
 *
 * @return false if normal code should continue, 1 to prevent normal code.
 */
/mob/living/proc/handle_micro_bump_other(var/mob/living/tmob)
	ASSERT(istype(tmob))

	//If they're flying, don't do any special interactions.
	if(ishuman(src))
		var/mob/living/carbon/human/P = src
		if(P.flying)
			return

	//If the prey is flying, don't smush them.
	if(ishuman(tmob))
		var/mob/living/carbon/human/D = tmob
		if(D.flying)
			return

	//They can't be stepping on anyone
	if(!canmove || buckled)
		return

	//Test/set if human
	var/mob/living/carbon/human/H
	if(ishuman(src))
		H = src

	var/mob/living/carbon/human/Ht
	if(ishuman(tmob))
		Ht = tmob

	//Depending on intent...
	switch(a_intent)

		//src stepped on someone with disarm intent
		if(I_DISARM)
			// If bigger than them by at least 0.75, move onto them and print message.
			if((get_effective_size() - tmob.get_effective_size()) >= 0.75)
				now_pushing = 0
				forceMove(tmob.loc)

				//Running on I_DISARM
				if(m_intent == "run")
					tmob.resting = 1 //Force them down to the ground.

					//Log it for admins (as opposed to walk which logs damage)
					add_attack_logs(src,tmob,"Pinned underfoot (run, no halloss)")

					//Not a human, or not a taur, generic message only
					if(!H || !isTaurTail(H.tail_style))
						to_chat(src,"<span class='danger'>You quickly push [tmob] to the ground with your foot!</span>")
						to_chat(tmob,"<span class='danger'>[src] pushes you down to the ground with their foot!</span>")

					//Human with taur tail, special messages are sent
					else
						var/datum/sprite_accessory/tail/taur/tail = H.tail_style
						to_chat(src,STEP_TEXT_OWNER("<span class='danger'>[tail.msg_owner_disarm_run]</span>"))
						to_chat(tmob,STEP_TEXT_PREY("<span class='danger'>[tail.msg_prey_disarm_run]</span>"))

				//Walking on I_DISARM
				else
					//Perform some HALLOSS damage to the smaller.
					var/size_damage_multiplier = (src.size_multiplier - tmob.size_multiplier)
					var/damage = (rand(15,30)* size_damage_multiplier) //Since stunned is broken, let's do this. Rand 15-30 multiplied by 1 min or 1.75 max. 15 holo to 52.5 holo, depending on RNG and size differnece.
					tmob.apply_damage(damage, HALLOSS)
					tmob.resting = 1

					//Log it for admins (as opposed to run which logs no damage)
					add_attack_logs(src,tmob,"Pinned underfoot (walk, about [damage] halloss)")

					//Not a human, or not a taur, generic message only
					if(!H || !isTaurTail(H.tail_style))
						to_chat(src,"<span class='danger'>You firmly push your foot down on [tmob], painfully but harmlessly pinning them to the ground!</span>")
						to_chat(tmob,"<span class='danger'>[src] firmly pushes their foot down on you, quite painfully but harmlessly pinning you to the ground!</span>")

					//Human with taur tail, special messages are sent
					else
						var/datum/sprite_accessory/tail/taur/tail = H.tail_style
						to_chat(src,STEP_TEXT_OWNER("<span class='danger'>[tail.msg_owner_disarm_walk]</span>"))
						to_chat(tmob,STEP_TEXT_PREY("<span class='danger'>[tail.msg_prey_disarm_walk]</span>"))

				//Return true, the sizediff was enough that we handled it.
				return TRUE

			//Not enough sizediff for I_DISARM to do anything.
			else
				return FALSE

		//src stepped on someone with harm intent
		if(I_HURT)
			// If bigger than them by at least 0.75, move onto them and print message.
			if((get_effective_size() - tmob.get_effective_size()) >= 0.75)
				now_pushing = 0
				forceMove(tmob.loc)

				//Precalculate base damage
				var/size_damage_multiplier = (src.size_multiplier - tmob.size_multiplier)
				var/damage = (rand(1,3)* size_damage_multiplier) //Rand 1-3 multiplied by 1 min or 1.75 max. 1 min 5.25 max damage to each limb.
				var/calculated_damage = damage/2 //This will sting, but not kill. Does .5 to 2.625 damage, randomly, to each limb.

				//Running on I_HURT
				if(m_intent == "run")

					//Not a human, or not a taur, generic message only
					if(!H || !isTaurTail(H.tail_style))
						to_chat(src,"<span class='danger'>You carelessly step down onto [tmob], crushing them!</span>")
						to_chat(tmob,"<span class='danger'>[src] steps carelessly on your body, crushing you!</span>")

					//Human with taur tail, special messages are sent
					else
						var/datum/sprite_accessory/tail/taur/tail = H.tail_style
						to_chat(src,STEP_TEXT_OWNER("<span class='danger'>[tail.msg_owner_harm_run]</span>"))
						to_chat(tmob,STEP_TEXT_PREY("<span class='danger'>[tail.msg_prey_harm_run]</span>"))

					//If they are a human, do damage (doesn't hurt other mobs...?)
					if(Ht)
						for(var/obj/item/organ/external/I in Ht.organs)
							I.take_damage(calculated_damage, 0) // 5 damage min, 26.25 damage max, depending on size & RNG. If they're only stepped on once, the damage will (probably not...) heal over time.
						Ht.drip(0.1)
						add_attack_logs(src,tmob,"Crushed underfoot (run, about [calculated_damage] damage)")

				//Walking on I_HURT
				else
					//Multiplies the above damage by 3.5. This means a min of 1.75 damage, or a max of 9.1875. damage to each limb, depending on size and RNG.
					calculated_damage *= 3.5

					//If they are a human, do damage (doesn't hurt other mobs...?)
					if(Ht)
						for(var/obj/item/organ/I in Ht.organs)
							I.take_damage(calculated_damage, 0)
						Ht.drip(3)
						add_attack_logs(src,tmob,"Crushed underfoot (walk, about [calculated_damage] damage)")

					//Not a human, or not a taur, generic message only
					if(!H || !isTaurTail(H.tail_style))
						to_chat(src,"<span class='danger'>You methodically place your foot down upon [tmob]'s body, slowly applying pressure, crushing them against the floor below!</span>")
						to_chat(tmob,"<span class='danger'>[src] methodically places their foot upon your body, slowly applying pressure, crushing you against the floor below!</span>")

					//Human with taur tail, special messages are sent
					else
						var/datum/sprite_accessory/tail/taur/tail = H.tail_style
						to_chat(src,STEP_TEXT_OWNER("<span class='danger'>[tail.msg_owner_harm_walk]</span>"))
						to_chat(tmob,STEP_TEXT_PREY("<span class='danger'>[tail.msg_prey_harm_walk]</span>"))

				//Return true, the sizediff was enough that we handled it.
				return TRUE

			//Not enough sizediff for I_HURT to do anything.
			else
				return FALSE

		//src stepped on someone with grab intent
		if(I_GRAB)
			// If bigger than them by at least 0.50, move onto them and print message.
			if((get_effective_size() - tmob.get_effective_size()) >= 0.50)
				now_pushing = 0
				tmob.resting = 1
				forceMove(tmob.loc)

				//Not a human, or not a taur while wearing shoes = no grab
				if(!H || (!isTaurTail(H.tail_style) && H.shoes))
					to_chat(src,"<span class='danger'>You step down onto [tmob], squishing them and forcing them down to the ground!</span>")
					to_chat(tmob,"<span class='danger'>[src] steps down and squishes you with their foot, forcing you down to the ground!</span>")
					add_attack_logs(src,tmob,"Grabbed underfoot (nontaur, shoes)")

				//Human, not a taur, but not wearing shoes = yes grab
				else if(H && (!isTaurTail(H.tail_style) && !H.shoes))
					to_chat(src,"<span class='danger'>You pin [tmob] down onto the floor with your foot and curl your toes up around their body, trapping them inbetween them!</span>")
					to_chat(tmob,"<span class='danger'>[src] pins you down to the floor with their foot and curls their toes up around your body, trapping you inbetween them!</span>")
					equip_to_slot_if_possible(tmob.get_scooped(H), slot_shoes, 0, 1)
					add_attack_logs(src,tmob,"Grabbed underfoot (nontaur, no shoes)")

				//Human, taur, shoes = no grab, special message
				else if(H.shoes)
					var/datum/sprite_accessory/tail/taur/tail = H.tail_style
					to_chat(src,STEP_TEXT_OWNER("<span class='danger'>[tail.msg_owner_grab_fail]</span>"))
					to_chat(tmob,STEP_TEXT_PREY("<span class='danger'>[tail.msg_prey_grab_fail]</span>"))
					add_attack_logs(src,tmob,"Grabbed underfoot (taur, shoes)")

				//Human, taur, no shoes = yes grab, special message
				else
					var/datum/sprite_accessory/tail/taur/tail = H.tail_style
					to_chat(src,STEP_TEXT_OWNER("<span class='danger'>[tail.msg_owner_grab_success]</span>"))
					to_chat(tmob,STEP_TEXT_PREY("<span class='danger'>[tail.msg_prey_grab_success]</span>"))
					equip_to_slot_if_possible(tmob.get_scooped(H), slot_shoes, 0, 1)
					add_attack_logs(src,tmob,"Grabbed underfoot (taur, no shoes)")

				//Return true, the sizediff was enough that we handled it.
				return TRUE

			//Not enough sizediff for I_GRAB to do anything.
			else
				return FALSE

#undef STEP_TEXT_OWNER
#undef STEP_TEXT_PREY