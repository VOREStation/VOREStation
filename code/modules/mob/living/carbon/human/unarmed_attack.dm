var/global/list/sparring_attack_cache = list()

//Species unarmed attacks
/datum/unarmed_attack
	var/attack_name = "fist"
	var/attack_verb = list("attack")	// Empty hand hurt intent verb.
	var/attack_noun = list("fist")
	var/damage = 0						// Extra empty hand attack damage.
	var/attack_sound = "punch"
	var/miss_sound = 'sound/weapons/punchmiss.ogg'
	var/shredding = FALSE // Calls the old attack_alien() behavior on objects/mobs when on harm intent.
	var/sharp = FALSE
	var/edge = FALSE

	var/damage_type = BRUTE
	var/is_punch = FALSE //If the attack benefits from the damage increase things being on your hands give.
	var/sparring_variant_type = /datum/unarmed_attack/light_strike

	var/eye_attack_text
	var/eye_attack_text_victim

/datum/unarmed_attack/proc/get_sparring_variant()
	if(sparring_variant_type)
		if(!sparring_attack_cache[sparring_variant_type])
			sparring_attack_cache[sparring_variant_type] = new sparring_variant_type()
		return sparring_attack_cache[sparring_variant_type]

/datum/unarmed_attack/proc/is_usable(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone)
	if(user.restrained())
		return FALSE

	// Check if they have a functioning hand.
	var/obj/item/organ/external/E = user.organs_by_name[BP_L_HAND]
	if(E && !E.is_stump())
		return TRUE

	E = user.organs_by_name[BP_R_HAND]
	if(E && !E.is_stump())
		return TRUE

	return FALSE

/datum/unarmed_attack/proc/get_unarmed_damage()
	return damage

/datum/unarmed_attack/proc/apply_effects(var/mob/living/carbon/human/user,var/mob/living/carbon/human/target,var/armour,var/attack_damage,var/zone)

	var/stun_chance = rand(0, 100)
	var/datum/gender/TT = gender_datums[target.get_visible_gender()]

	if(attack_damage >= 5 && armour < 2 && !(target == user) && stun_chance <= attack_damage * 5) // 25% standard chance
		switch(zone) // strong punches can have effects depending on where they hit
			if(BP_HEAD, O_EYES, O_MOUTH)
				// Induce blurriness
				target.visible_message(span_danger("[target] looks momentarily disoriented."), span_danger("You see stars."))
				target.apply_effect(attack_damage*2, EYE_BLUR, armour)
			if(BP_L_ARM, BP_L_HAND)
				if (target.l_hand)
					// Disarm left hand
					//Urist McAssistant dropped the macguffin with a scream just sounds odd.
					target.visible_message(span_danger("\The [target.l_hand] was knocked right out of [target]'s grasp!"))
					target.drop_l_hand()
			if(BP_R_ARM, BP_R_HAND)
				if (target.r_hand)
					// Disarm right hand
					target.visible_message(span_danger("\The [target.r_hand] was knocked right out of [target]'s grasp!"))
					target.drop_r_hand()
			if(BP_TORSO)
				if(!target.lying)
					var/turf/T = get_step(get_turf(target), get_dir(get_turf(user), get_turf(target)))
					if(!T.density)
						step(target, get_dir(get_turf(user), get_turf(target)))
						target.visible_message(span_danger("[pick("[target] was sent flying backward!", "[target] staggers back from the impact!")]"))
					else
						target.visible_message(span_danger("[target] slams into [T]!"))
					if(prob(50))
						target.set_dir(reverse_dir[target.dir])
					target.apply_effect(attack_damage * 0.4, WEAKEN, armour)
			if(BP_GROIN)
				target.visible_message(span_warning("[target] looks like [TT.he] [TT.is] in pain!"), span_warning("[(target.gender=="female") ? "Oh god that hurt!" : "Oh no, not your[pick("testicles", "crown jewels", "clockweights", "family jewels", "marbles", "bean bags", "teabags", "sweetmeats", "goolies")]!"]")) // I see no easy way to fix this for non-organic or neuter characters.
				target.apply_effects(stutter = attack_damage * 2, agony = attack_damage* 3, blocked = armour)
			if(BP_L_LEG, BP_L_FOOT, BP_R_LEG, BP_R_FOOT)
				if(!target.lying)
					target.visible_message(span_warning("[target] gives way slightly."))
					target.apply_effect(attack_damage*3, AGONY, armour)
	else if(attack_damage >= 5 && !(target == user) && (stun_chance + attack_damage * 5 >= 100) && armour < 2) // Chance to get the usual throwdown as well (25% standard chance)
		if(!target.lying)
			target.visible_message(span_danger("[target] [pick("slumps", "falls", "drops")] down to the ground!"))
		else
			target.visible_message(span_danger("[target] has been weakened!"))
		target.apply_effect(3, WEAKEN, armour)

/datum/unarmed_attack/proc/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	var/obj/item/organ/external/affecting = target.get_organ(zone)
	user.visible_message(span_warning("[user] [pick(attack_verb)] [target] in the [affecting.name]!"))
	playsound(user, attack_sound, 25, 1, -1)

/datum/unarmed_attack/proc/handle_eye_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target)
	var/obj/item/organ/internal/eyes/eyes = target.internal_organs_by_name[O_EYES]
	var/datum/gender/TU = gender_datums[user.get_visible_gender()]
	var/datum/gender/TT = gender_datums[target.get_visible_gender()]
	if(eyes)
		eyes.take_damage(rand(3,4), 1)
		user.visible_message(span_danger("[user] presses [TU.his] [eye_attack_text] into [target]'s [eyes.name]!"))
		var/eye_pain = eyes.organ_can_feel_pain()
		to_chat(target, span_danger("You experience[(eye_pain) ? "" : " immense pain as you feel" ] [eye_attack_text_victim] being pressed into your [eyes.name][(eye_pain)? "." : "!"]"))
		return
	user.visible_message(span_danger("[user] attempts to press [TU.his] [eye_attack_text] into [target]'s eyes, but [TT.he] [TT.does]n't have any!"))

/datum/unarmed_attack/proc/unarmed_override(var/mob/living/carbon/human/user,var/mob/living/carbon/human/target,var/zone)
	return FALSE //return true if the unarmed override prevents further attacks

/datum/unarmed_attack/bite
	attack_name = "bite"
	attack_verb = list("bit")
	attack_sound = 'sound/weapons/bite.ogg'
	damage = 0
	//sharp = TRUE //Enable if you want bites to make people bleed.
	//germ_increase = 10 //Amount of germs each bite will give to the person.

/datum/unarmed_attack/bite/event1

/datum/unarmed_attack/bite/is_usable(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone)
	if (user.is_muzzled() || user.buckled)
		return FALSE
	if (user == target && ((zone == BP_GROIN && (prob(98)) || (zone == BP_HEAD || zone == O_EYES || zone == O_MOUTH)))) //biting your own groin is hard. 2% hit chance.
		return FALSE
	for(var/obj/item/organ/external/head/user_head in user.organs) //We have a head!
		if(!user_head.dislocated && !(user_head.status & ORGAN_BROKEN)) //And it's not dislocated
			return TRUE
	return FALSE

/datum/unarmed_attack/punch
	attack_name = "punch"
	attack_verb = list("punched")
	attack_noun = list("fist")
	eye_attack_text = "fingers"
	eye_attack_text_victim = "digits"
	damage = 0
	is_punch = TRUE

/datum/unarmed_attack/punch/event1

/datum/unarmed_attack/punch/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	var/obj/item/organ/external/affecting = target.get_organ(zone)
	var/organ = affecting.name

	var/datum/gender/TU = gender_datums[user.get_visible_gender()]
	var/datum/gender/TT = gender_datums[target.get_visible_gender()]

	attack_damage = CLAMP(attack_damage, 1, 5) // We expect damage input of 1 to 5 for this proc. But we leave this check juuust in case.

	if(target == user)
		user.visible_message(span_danger("[user] [pick(attack_verb)] [TU.himself] in the [organ]!"))
		return FALSE

	if(!target.lying)
		switch(zone)
			if(BP_HEAD, O_MOUTH, O_EYES)
				// ----- HEAD ----- //
				switch(attack_damage)
					if(1 to 2)
						user.visible_message(span_danger("[user] slapped [target] across [TT.his] cheek!"))
					if(3 to 4)
						user.visible_message(pick(
							40; span_danger("[user] [pick(attack_verb)] [target] in the head!"),
							30; span_danger("[user] struck [target] in the head[pick("", " with a closed fist")]!"),
							30; span_danger("[user] threw a hook against [target]'s head!")
							))
					if(5)
						user.visible_message(pick(
							30; span_danger("[user] gave [target] a resounding [pick("slap", "punch")] to the face!"),
							40; span_danger("[user] smashed [TU.his] [pick(attack_noun)] into [target]'s face!"),
							30; span_danger("[user] gave a strong blow against [target]'s jaw!")
							))
			else
				// ----- BODY ----- //
				switch(attack_damage)
					if(1 to 2)	user.visible_message(span_danger("[user] threw a glancing punch at [target]'s [organ]!"))
					if(1 to 4)	user.visible_message(span_danger("[user] [pick(attack_verb)] [target] in [TT.his] [organ]!"))
					if(5)
						user.visible_message(pick(
							50; span_danger("[user] smashed [TU.his] [pick(attack_noun)] into [target]'s [organ]!"),
							50; span_danger("[user] landed a striking [pick(attack_noun)] on [target]'s [organ]!")
							))
	else
		user.visible_message(span_danger("[user] [pick("punched", "threw a punch against", "struck", "slammed [TU.his] [pick(attack_noun)] into")] [target]'s [organ]!")) //why do we have a separate set of verbs for lying targets?

/datum/unarmed_attack/kick
	attack_name = "kick"
	attack_verb = list("kicked", "kicked", "kicked", "kneed")
	attack_noun = list("kick", "kick", "kick", "knee strike")
	attack_sound = "swing_hit"
	damage = 0

/datum/unarmed_attack/kick/event1

/datum/unarmed_attack/kick/is_usable(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone)
	if(user.legcuffed || user.buckled)
		return FALSE

	if(!(zone in list(BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT, BP_GROIN)))
		return FALSE

	var/obj/item/organ/external/E = user.organs_by_name[BP_L_FOOT]
	if(E && !E.is_stump())
		return TRUE

	E = user.organs_by_name[BP_R_FOOT]
	if(E && !E.is_stump())
		return TRUE

	return FALSE

/datum/unarmed_attack/kick/get_unarmed_damage(var/mob/living/carbon/human/user)
	var/obj/item/clothing/shoes = user.shoes
	if(!istype(shoes))
		return damage
	return damage + (shoes ? shoes.force : 0)

/datum/unarmed_attack/kick/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	var/obj/item/organ/external/affecting = target.get_organ(zone)
	var/datum/gender/TT = gender_datums[target.get_visible_gender()]
	var/organ = affecting.name

	attack_damage = CLAMP(attack_damage, 1, 5)

	switch(attack_damage)
		if(1 to 2)	user.visible_message(span_danger("[user] threw [target] a glancing [pick(attack_noun)] to the [organ]!")) //it's not that they're kicking lightly, it's that the kick didn't quite connect
		if(3 to 4)	user.visible_message(span_danger("[user] [pick(attack_verb)] [target] in [TT.his] [organ]!"))
		if(5)		user.visible_message(span_danger("[user] landed a strong [pick(attack_noun)] against [target]'s [organ]!"))

/datum/unarmed_attack/stomp
	attack_name = "stomp"
	attack_verb = null
	attack_noun = list("stomp")
	attack_sound = "swing_hit"
	damage = 0

/datum/unarmed_attack/stomp/event1

/datum/unarmed_attack/stomp/is_usable(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone)

	if (user.legcuffed || user.buckled)
		return FALSE

	if(!istype(target))
		return FALSE

	if (!user.lying && (target.lying || (zone in list(BP_L_FOOT, BP_R_FOOT))))
		if(target.grabbed_by == user && target.lying)
			return FALSE
		var/obj/item/organ/external/E = user.organs_by_name[BP_L_FOOT]
		if(E && !E.is_stump())
			return TRUE

		E = user.organs_by_name[BP_R_FOOT]
		if(E && !E.is_stump())
			return TRUE

		return FALSE

/datum/unarmed_attack/stomp/get_unarmed_damage(var/mob/living/carbon/human/user)
	var/obj/item/clothing/shoes = user.shoes
	return damage + (shoes ? shoes.force : 0)

/datum/unarmed_attack/stomp/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	var/obj/item/organ/external/affecting = target.get_organ(zone)
	var/organ = affecting.name
	var/obj/item/clothing/shoes = user.shoes
	var/datum/gender/TU = gender_datums[user.get_visible_gender()]

	attack_damage = CLAMP(attack_damage, 1, 5)

	switch(attack_damage)
		if(1 to 4)	user.visible_message(span_danger("[pick("[user] stomped on", "[user] slammed [TU.his] [shoes ? copytext(shoes.name, 1, -1) : "foot"] down onto")] [target]'s [organ]!"))
		if(5)		user.visible_message(span_danger("[pick("[user] landed a powerful stomp on", "[user] stomped down hard on", "[user] slammed [TU.his] [shoes ? copytext(shoes.name, 1, -1) : "foot"] down hard onto")] [target]'s [organ]!")) //Devastated lol. No. We want to say that the stomp was powerful or forceful, not that it /wrought devastation/

/datum/unarmed_attack/light_strike
	attack_name = "light hit"
	attack_noun = list("tap","light strike")
	attack_verb = list("tapped", "lightly struck")
	damage = 3
	damage_type = HALLOSS
	is_punch = TRUE
