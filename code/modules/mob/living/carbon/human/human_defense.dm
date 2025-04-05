/*
Contains most of the procs that are called when a mob is attacked by something

bullet_act
ex_act
meteor_act
emp_act

*/

/mob/living/carbon/human/bullet_act(var/obj/item/projectile/P, var/def_zone)

	def_zone = check_zone(def_zone)
	if(!has_organ(def_zone))
		return PROJECTILE_FORCE_MISS //if they don't have the organ in question then the projectile just passes by.

	var/obj/item/organ/external/organ = get_organ()

	//Shields
	var/shield_check = check_shields(P.damage, P, null, def_zone, "the [P.name]")
	if(shield_check) // If the block roll succeeded, this is true.
		if(shield_check < 0) // The shield did something weird and the bullet needs to keep doing things (e.g. it was reflected).
			return shield_check // Likely equal to PROJECTILE_FORCE_MISS or PROJECTILE_CONTINUE.
		else // Otherwise we blocked normally and stopped all the damage.
			return 0

	if(!P.nodamage)
		organ.add_autopsy_data("[P.name]", P.damage)

	// Tell clothing we're wearing that it got hit by a bullet/laser/etc
	var/list/clothing = get_clothing_list_organ(organ)
	for(var/obj/item/clothing/C in clothing)
		C.clothing_impact(P, P.damage)

	//Shrapnel
	if(P.can_embed())
		var/armor = getarmor_organ(organ, "bullet")
		if(!prob(armor/2))		//Even if the armor doesn't stop the bullet from hurting you, it might stop it from embedding.
			var/hit_embed_chance = P.embed_chance + (P.damage - armor)	//More damage equals more chance to embed

			//Modifiers can make bullets less likely to embed! These are the normal modifiers and shouldn't be related to energy stuff, but they can be anyways!
			for(var/datum/modifier/M in modifiers)
				if(!isnull(M.incoming_damage_percent))
					if(M.energy_based)
						M.energy_source.use(M.energy_cost) //We use energy_cost here for special effects, such as embedding.
					hit_embed_chance = hit_embed_chance*M.incoming_damage_percent
				if(P.damage_type == BRUTE && (!isnull(M.incoming_brute_damage_percent)))
					if(M.energy_based)
						M.energy_source.use(M.energy_cost)
					hit_embed_chance = hit_embed_chance*M.incoming_brute_damage_percent

			if(prob(max(hit_embed_chance, 0)))
				var/obj/item/material/shard/shrapnel/SP = new()
				SP.name = (P.name != "shrapnel")? "[P.name] shrapnel" : "shrapnel"
				SP.desc = "[SP.desc] It looks like it was fired from [P.shot_from]."
				SP.loc = organ
				organ.embed(SP)

	return (..(P , def_zone))

/mob/living/carbon/human/stun_effect_act(var/stun_amount, var/agony_amount, var/def_zone)
	var/obj/item/organ/external/affected = get_organ(check_zone(def_zone))
	var/siemens_coeff = get_siemens_coefficient_organ(affected)
	if(fire_stacks < 0) // Water makes you more conductive.
		siemens_coeff *= 1.5
	stun_amount *= siemens_coeff
	agony_amount *= siemens_coeff

	switch (def_zone)
		if(BP_HEAD)
			agony_amount *= 1.50
		if(BP_L_HAND, BP_R_HAND)
			var/c_hand
			if (def_zone == BP_L_HAND)
				c_hand = l_hand
			else
				c_hand = r_hand

			if(c_hand && (stun_amount || agony_amount > 10))
				msg_admin_attack("[key_name(src)] was disarmed by a stun effect")

				drop_from_inventory(c_hand)
				if(!isbelly(loc)) //VOREStation Add
					if (affected.robotic >= ORGAN_ROBOT)
						automatic_custom_emote(VISIBLE_MESSAGE, "drops what they were holding, their [affected.name] malfunctioning!", check_stat = TRUE)
					else
						var/emote_scream = pick("screams in pain and ", "lets out a sharp cry and ", "cries out and ")
						automatic_custom_emote(VISIBLE_MESSAGE, "[affected.organ_can_feel_pain() ? "" : emote_scream] drops what they were holding in their [affected.name]!", check_stat = TRUE)

	..(stun_amount, agony_amount, def_zone)

/mob/living/carbon/human/getarmor(var/def_zone, var/type)
	var/armorval = 0
	var/total = 0

	if(def_zone)
		if(isorgan(def_zone))
			return getarmor_organ(def_zone, type)
		var/obj/item/organ/external/affecting = get_organ(def_zone)
		if(affecting)
			return getarmor_organ(affecting, type)
		//If a specific bodypart is targetted, check how that bodypart is protected and return the value.

	//If you don't specify a bodypart, it checks ALL your bodyparts for protection, and averages out the values
	for(var/organ_name in organs_by_name)
		if (organ_name in organ_rel_size)
			var/obj/item/organ/external/organ = organs_by_name[organ_name]
			if(organ)
				var/weight = organ_rel_size[organ_name]
				armorval += (getarmor_organ(organ, type) * weight)
				total += weight
	return (armorval/max(total, 1))

//Like getarmor, but the value it returns will be numerical damage reduction
/mob/living/carbon/human/getsoak(var/def_zone, var/type)
	var/soakval = 0
	var/total = 0

	if(def_zone)
		if(isorgan(def_zone))
			return getsoak_organ(def_zone, type)
		var/obj/item/organ/external/affecting = get_organ(def_zone)
		if(affecting)
			return getsoak_organ(affecting, type)
		//If a specific bodypart is targetted, check how that bodypart is protected and return the value.

	//If you don't specify a bodypart, it checks ALL your bodyparts for protection, and averages out the values
	for(var/organ_name in organs_by_name)
		if (organ_name in organ_rel_size)
			var/obj/item/organ/external/organ = organs_by_name[organ_name]
			if(organ)
				var/weight = organ_rel_size[organ_name]
				soakval += getsoak_organ(organ, type) * weight
				total += weight
	return (soakval/max(total, 1))

//this proc returns the Siemens coefficient of electrical resistivity for a particular external organ.
/mob/living/carbon/human/proc/get_siemens_coefficient_organ(var/obj/item/organ/external/def_zone)
	if (!def_zone)
		return 1.0

	var/siemens_coefficient = max(species.siemens_coefficient,0)

	var/list/clothing_items = list(head, wear_mask, wear_suit, w_uniform, gloves, shoes) // What all are we checking?
	for(var/obj/item/clothing/C in clothing_items)
		if(istype(C) && (C.body_parts_covered & def_zone.body_part)) // Is that body part being targeted covered?
			siemens_coefficient *= C.siemens_coefficient

	// Modifiers.
	for(var/datum/modifier/M as anything in modifiers)
		if(!isnull(M.siemens_coefficient))
			siemens_coefficient *= M.siemens_coefficient

	return siemens_coefficient

// Similar to above but is for the mob's overall protection, being the average of all slots.
/mob/living/carbon/human/proc/get_siemens_coefficient_average()
	var/siemens_value = 0
	var/total = 0
	for(var/organ_name in organs_by_name)
		if(organ_name in organ_rel_size)
			var/obj/item/organ/external/organ = organs_by_name[organ_name]
			if(organ)
				var/weight = organ_rel_size[organ_name]
				siemens_value += get_siemens_coefficient_organ(organ) * weight
				total += weight

	if(fire_stacks < 0) // Water makes you more conductive.
		siemens_value *= 1.5

	return (siemens_value / max(total, 1))

// Returns a number between 0 to 1, with 1 being total protection.
/mob/living/carbon/human/get_shock_protection()
	return min(1 - get_siemens_coefficient_average(), 1) // Don't go above 1, but negatives are fine.

// Returns a list of clothing that is currently covering def_zone.
/mob/living/carbon/human/proc/get_clothing_list_organ(var/obj/item/organ/external/def_zone, var/type)
	var/list/results = list()
	var/list/clothing_items = list(head, wear_mask, wear_suit, w_uniform, gloves, shoes)
	for(var/obj/item/clothing/C in clothing_items)
		if(istype(C) && (C.body_parts_covered & def_zone.body_part))
			results.Add(C)
	return results

//this proc returns the armour value for a particular external organ.
/mob/living/carbon/human/proc/getarmor_organ(var/obj/item/organ/external/def_zone, var/type)
	if(!type || !def_zone)
		return 0
	var/protection = 0
	var/list/protective_gear = def_zone.get_covering_clothing()
	for(var/obj/item/clothing/gear in protective_gear)
		protection += gear.armor[type]

	for(var/datum/modifier/M as anything in modifiers)
		var/modifier_armor = LAZYACCESS(M.armor_percent, type)
		if(modifier_armor)
			protection += modifier_armor

	return protection

/mob/living/carbon/human/proc/getsoak_organ(var/obj/item/organ/external/def_zone, var/type)
	if(!type || !def_zone)
		return 0
	var/soaked = 0
	var/list/protective_gear = def_zone.get_covering_clothing()
	for(var/obj/item/clothing/gear in protective_gear)
		soaked += gear.armorsoak[type]

	for(var/datum/modifier/M as anything in modifiers)
		var/modifier_armor = LAZYACCESS(M.armor_flat, type)
		if(modifier_armor)
			soaked += modifier_armor

	return soaked

// Checked in borer code
/mob/living/carbon/human/proc/check_head_coverage()
	var/obj/item/organ/external/H = organs_by_name[BP_HEAD]
	var/list/body_parts = H.get_covering_clothing(EYES)
	if(LAZYLEN(body_parts))
		return 1
	return 0

//Used to check if they can be fed food/drinks/pills
/mob/living/carbon/human/proc/check_mouth_coverage()
	var/obj/item/organ/external/H = organs_by_name[BP_HEAD]
	var/list/protective_gear = H.get_covering_clothing(FACE)
	for(var/obj/item/gear in protective_gear)
		if(istype(gear) && (gear.body_parts_covered & FACE) && !(gear.item_flags & FLEXIBLEMATERIAL))
			return gear
	return null

/mob/living/carbon/human/proc/check_mouth_coverage_survival()
	var/obj/item/organ/external/H = organs_by_name[BP_HEAD]
	var/list/protective_gear = H.get_covering_clothing(FACE)
	for(var/obj/item/gear in protective_gear)
		if(istype(gear) && (gear.body_parts_covered & FACE) && !(gear.item_flags & FLEXIBLEMATERIAL) && !(gear.item_flags & ALLOW_SURVIVALFOOD))
			return gear
	return null

/mob/living/carbon/human/proc/check_shields(var/damage = 0, var/atom/damage_source = null, var/mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	for(var/obj/item/shield in list(l_hand, r_hand, wear_suit))
		if(!shield) continue
		. = shield.handle_shield(src, damage, damage_source, attacker, def_zone, attack_text)
		if(.) return
	return 0

/mob/living/carbon/human/resolve_item_attack(obj/item/I, mob/living/user, var/target_zone)
	if(check_neckgrab_attack(I, user, target_zone))
		return null

	if(user == src) // Attacking yourself can't miss
		return target_zone

	var/hit_zone = get_zone_with_miss_chance(target_zone, src, user.get_accuracy_penalty())

	if(!hit_zone)
		user.do_attack_animation(src)
		playsound(src, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
		visible_message(span_danger("\The [user] misses [src] with \the [I]!"))
		return null

	if(check_shields(I.force, I, user, target_zone, "the [I.name]"))
		return

	var/obj/item/organ/external/affecting = get_organ(hit_zone)
	if (!affecting || affecting.is_stump())
		to_chat(user, span_danger("They are missing that limb!"))
		return null

	return hit_zone

/mob/living/carbon/human/hit_with_weapon(obj/item/I, mob/living/user, var/effective_force, var/hit_zone)
	var/obj/item/organ/external/affecting = get_organ(hit_zone)
	if(!affecting)
		return //should be prevented by attacked_with_item() but for sanity.

	visible_message(span_danger("[src] has been [LAZYLEN(I.attack_verb) ? pick(I.attack_verb) : "attacked"] in the [affecting.name] with [I.name] by [user]!"))

	var/soaked = get_armor_soak(hit_zone, "melee", I.armor_penetration)

	var/blocked = run_armor_check(hit_zone, "melee", I.armor_penetration, "Your armor has protected your [affecting.name].", "Your armor has softened the blow to your [affecting.name].")

	standard_weapon_hit_effects(I, user, effective_force, blocked, soaked, hit_zone)

	return blocked

/mob/living/carbon/human/standard_weapon_hit_effects(obj/item/I, mob/living/user, var/effective_force, var/blocked, var/soaked, var/hit_zone)
	var/obj/item/organ/external/affecting = get_organ(hit_zone)
	if(!affecting)
		return 0

	// Allow clothing to respond to being hit.
	// This is done up here so that clothing damage occurs even if fully blocked.
	var/list/clothing = get_clothing_list_organ(affecting)
	for(var/obj/item/clothing/C in clothing)
		C.clothing_impact(I, effective_force)

	if(soaked >= round(effective_force*0.8))
		effective_force -= round(effective_force*0.8)
	// Handle striking to cripple.
	if(user.a_intent == I_DISARM)
		effective_force *= 0.5 //reduced effective force...
		if(!..(I, user, effective_force, blocked, soaked, hit_zone))
			return 0

		//set the dislocate mult less than the effective force mult so that
		//dislocating limbs on disarm is a bit easier than breaking limbs on harm
		attack_joint(affecting, I, effective_force, 0.75, blocked, soaked) //...but can dislocate joints
	else if(!..())
		return 0

	if(effective_force > 10 || effective_force >= 5 && prob(33))
		forcesay(hit_appends)	//forcesay checks stat already

	if(prob(25 + (effective_force * 2)))
		if(!((I.damtype == BRUTE) || (I.damtype == HALLOSS)))
			return

		if(!(I.flags & NOBLOODY))
			I.add_blood(src)

		var/bloody = 0
		if(prob(33))
			bloody = 1
			var/turf/location = loc
			if(istype(location, /turf/simulated))
				location.add_blood(src)
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				if(get_dist(H, src) <= 1) //people with TK won't get smeared with blood
					H.bloody_body(src)
					H.bloody_hands(src)

		if(!stat && !(I.no_random_knockdown))
			switch(hit_zone)
				if(BP_HEAD)//Harder to score a stun but if you do it lasts a bit longer
					if(prob(effective_force))
						apply_effect(20, PARALYZE, blocked, soaked)
						visible_message(span_danger("\The [src] has been knocked unconscious!"))
					if(bloody)//Apply blood
						if(wear_mask)
							wear_mask.add_blood(src)
							update_inv_wear_mask(0)
						if(head)
							head.add_blood(src)
							update_inv_head(0)
						if(glasses && prob(33))
							glasses.add_blood(src)
							update_inv_glasses(0)
				if(BP_TORSO)//Easier to score a stun but lasts less time
					if(prob(effective_force + 10))
						apply_effect(6, WEAKEN, blocked, soaked)
						visible_message(span_danger("\The [src] has been knocked down!"))
					if(bloody)
						bloody_body(src)

	return 1

/mob/living/carbon/human/proc/attack_joint(var/obj/item/organ/external/organ, var/obj/item/W, var/effective_force, var/dislocate_mult, var/blocked, var/soaked)
	if(!organ || (organ.dislocated == 1) || (organ.dislocated == -1) || blocked >= 100) //VOREStation Edit Bugfix
		return 0

	if(W.damtype != BRUTE)
		return 0

	if(soaked >= round(effective_force*0.8))
		effective_force -= round(effective_force*0.8)

	//want the dislocation chance to be such that the limb is expected to dislocate after dealing a fraction of the damage needed to break the limb
	var/dislocate_chance = effective_force/(dislocate_mult * organ.min_broken_damage * CONFIG_GET(number/organ_health_multiplier))*100
	if(prob(dislocate_chance * (100 - blocked)/100))
		visible_message(span_danger("[src]'s [organ.joint] [pick("gives way","caves in","crumbles","collapses")]!"))
		organ.dislocate(1)
		return 1
	return 0

/mob/living/carbon/human/emag_act(var/remaining_charges, mob/user, var/emag_source)
	var/obj/item/organ/external/affecting = get_organ(user.zone_sel.selecting)
	if(!affecting || !(affecting.robotic >= ORGAN_ROBOT))
		to_chat(user, span_warning("That limb isn't robotic."))
		return -1
	if(affecting.sabotaged)
		to_chat(user, span_warning("[src]'s [affecting.name] is already sabotaged!"))
		return -1
	to_chat(user, span_notice("You sneakily slide [emag_source] into the dataport on [src]'s [affecting.name] and short out the safeties."))
	affecting.sabotaged = 1
	return 1

//this proc handles being hit by a thrown atom
/mob/living/carbon/human/hitby(atom/movable/AM as mob|obj,var/speed = THROWFORCE_SPEED_DIVISOR)
	if(src.is_incorporeal())
		return
//	if(buckled && buckled == AM)
//		return // Don't get hit by the thing we're buckled to.

	//VORESTATION EDIT START - Allows for thrown vore!
	//Throwing a prey into a pred takes priority. After that it checks to see if the person being thrown is a pred.
	// I put more comments here for ease of reading.
	if(isliving(AM))
		var/mob/living/thrown_mob = AM
		if(isanimal(thrown_mob) && !allowmobvore) //Is the thrown_mob an animal and we don't allow mobvore?
			return
		// PERSON BEING HIT: CAN BE DROP PRED, ALLOWS THROW VORE.
		// PERSON BEING THROWN: DEVOURABLE, ALLOWS THROW VORE, CAN BE DROP PREY.
		if((can_be_drop_pred && throw_vore && vore_selected) && (thrown_mob.devourable && thrown_mob.throw_vore && thrown_mob.can_be_drop_prey)) //Prey thrown into pred.
			vore_selected.nom_mob(thrown_mob) //Eat them!!!
			visible_message(span_vwarning("[thrown_mob] is thrown right into [src]'s [lowertext(vore_selected.name)]!"))
			if(thrown_mob.loc != vore_selected)
				thrown_mob.forceMove(vore_selected) //Double check. Should never happen but...Weirder things have happened!
			add_attack_logs(thrown_mob.thrower,src,"Devoured [thrown_mob.name] via throw vore.")
			return //We can stop here. We don't need to calculate damage or anything else. They're eaten.

		// PERSON BEING HIT: CAN BE DROP PREY, ALLOWS THROW VORE, AND IS DEVOURABLE.
		// PERSON BEING THROWN: CAN BE DROP PRED, ALLOWS THROW VORE.
		else if((can_be_drop_prey && throw_vore && devourable) && (thrown_mob.can_be_drop_pred && thrown_mob.throw_vore && thrown_mob.vore_selected)) //Pred thrown into prey.
			visible_message(span_vwarning("[src] suddenly slips inside of [thrown_mob]'s [lowertext(thrown_mob.vore_selected.name)] as [thrown_mob] flies into them!"))
			thrown_mob.vore_selected.nom_mob(src) //Eat them!!!
			if(src.loc != thrown_mob.vore_selected)
				src.forceMove(thrown_mob.vore_selected) //Double check. Should never happen but...Weirder things have happened!
			add_attack_logs(thrown_mob.LAssailant,src,"Was Devoured by [thrown_mob.name] via throw vore.")
			return
	//VORESTATION EDIT END - Allows for thrown vore!

	if(istype(AM,/obj/))
		var/obj/O = AM
		if(stat != DEAD && istype(O,/obj/item) && trash_catching && vore_selected) //Ported from chompstation
			var/obj/item/I = O
			if(adminbus_trash || is_type_in_list(I,edible_trash) && I.trash_eatable && !is_type_in_list(I,item_vore_blacklist))
				visible_message(span_warning("[I] is thrown directly into [src]'s [lowertext(vore_selected.name)]!"))
				I.throwing = 0
				I.forceMove(vore_selected)
				return
		if(in_throw_mode && speed <= THROWFORCE_SPEED_DIVISOR)	//empty active hand and we're in throw mode
			if(canmove && !restrained() && !src.is_incorporeal())
				if(isturf(O.loc))
					if(can_catch(O))
						put_in_active_hand(O)
						visible_message(span_warning("[src] catches [O]!"))
						throw_mode_off()
						return

		var/dtype = O.damtype
		var/throw_damage = O.throwforce*(speed/THROWFORCE_SPEED_DIVISOR)

		if(species && species.throwforce_absorb_threshold >= throw_damage)
			visible_message(span_infoplain(span_bold("\The [O]") + " simply bounces off of [src]'s body!"))
			return

		var/zone
		if (isliving(O.thrower))
			var/mob/living/L = O.thrower
			zone = check_zone(L.zone_sel.selecting)
		else
			zone = ran_zone(BP_TORSO,75)	//Hits a random part of the body, geared towards the chest

		//check if we hit
		var/miss_chance = 15
		if (O.throw_source)
			var/distance = get_dist(O.throw_source, loc)
			miss_chance = max(15*(distance-2), 0)
		zone = get_zone_with_miss_chance(zone, src, miss_chance, ranged_attack=1)

		if(zone && O.thrower != src)
			var/shield_check = check_shields(throw_damage, O, thrower, zone, "[O]")
			if(shield_check == PROJECTILE_FORCE_MISS)
				zone = null
			else if(shield_check)
				return

		if(!zone)
			visible_message(span_infoplain(span_bold("\The [O]") + " misses [src] narrowly!"))
			return

		O.throwing = 0		//it hit, so stop moving

		var/obj/item/organ/external/affecting = get_organ(zone)
		var/hit_area = affecting.name

		src.visible_message(span_filter_warning("[span_red("[src] has been hit in the [hit_area] by [O].")]"))

		if(ismob(O.thrower))
			add_attack_logs(O.thrower,src,"Hit with thrown [O.name]")

		//If the armor absorbs all of the damage, skip the rest of the calculations
		var/soaked = get_armor_soak(affecting, "melee", O.armor_penetration)
		if(soaked >= throw_damage)
			to_chat(src, span_warning("Your armor absorbs the force of [O.name]!"))
			return

		var/armor = run_armor_check(affecting, "melee", O.armor_penetration, "Your armor has protected your [hit_area].", "Your armor has softened hit to your [hit_area].") //I guess "melee" is the best fit here
		if(armor < 100)
			apply_damage(throw_damage, dtype, zone, armor, soaked, is_sharp(O), has_edge(O), O)


		//thrown weapon embedded object code.
		if(dtype == BRUTE && istype(O,/obj/item))
			var/obj/item/I = O
			if (!is_robot_module(I))
				var/sharp = is_sharp(I)
				var/damage = throw_damage
				if (soaked)
					damage -= soaked
				if (armor)
					damage /= armor+1

				//blunt objects should really not be embedding in things unless a huge amount of force is involved
				var/embed_chance = sharp? damage/I.w_class : damage/(I.w_class*3)
				var/embed_threshold = sharp? 5*I.w_class : 15*I.w_class

				//Sharp objects will always embed if they do enough damage.
				//Thrown sharp objects have some momentum already and have a small chance to embed even if the damage is below the threshold
				if((sharp && prob(damage/(10*I.w_class)*100)) || (damage > embed_threshold && prob(embed_chance)))
					affecting.embed(I)

		// Begin BS12 momentum-transfer code.
		var/mass = 1.5
		if(istype(O, /obj/item))
			var/obj/item/I = O
			mass = I.w_class/THROWNOBJ_KNOCKBACK_DIVISOR
		var/momentum = speed*mass

		if(O.throw_source && momentum >= THROWNOBJ_KNOCKBACK_SPEED && !buckled)
			var/dir = get_dir(O.throw_source, src)

			visible_message(span_filter_warning("[span_red("[src] staggers under the impact!")]"),span_filter_warning("[span_red("You stagger under the impact!")]"))
			src.throw_at(get_edge_target_turf(src,dir),1,momentum)

			if(!O || !src) return

			if(O.loc == src && O.sharp) //Projectile is embedded and suitable for pinning.
				var/turf/T = near_wall(dir,2)

				if(T)
					src.loc = T
					visible_message(span_warning("[src] is pinned to the wall by [O]!"),span_warning("You are pinned to the wall by [O]!"))
					src.anchored = TRUE
					src.pinned += O

// This does a prob check to catch the thing flying at you, with a minimum of 1%
/mob/living/carbon/human/proc/can_catch(var/obj/O)
	if(!get_active_hand())	// If active hand is empty
		var/obj/item/organ/external/temp = organs_by_name[BP_R_HAND]
		if (hand)
			temp = organs_by_name[BP_L_HAND]
		if(temp && !temp.is_usable())
			return FALSE	// The hand isn't working in the first place

	if(!O.catchable)
		return FALSE

	// Alright, our hand works? Time to try the catching.
	var/catch_chance = 90	// Default 90% catch rate

	if(O.sharp)
		catch_chance -= 50	// Catching knives is hard

	catch_chance -= get_accuracy_penalty()	// Same issues with shooting a gun, or swinging a weapon

	catch_chance = between(1, catch_chance, 100)

	if(prob(catch_chance))
		return TRUE
	return FALSE

/mob/living/carbon/human/embed(var/obj/O, var/def_zone=null)
	if(!def_zone) ..()

	var/obj/item/organ/external/affecting = get_organ(def_zone)
	if(affecting)
		affecting.embed(O)


/mob/living/carbon/human/proc/bloody_hands(var/mob/living/source, var/amount = 2)
	if (istype(gloves, /obj/item/clothing/gloves))
		var/obj/item/clothing/gloves/gl = gloves
		gl.add_blood(source)
		gl.transfer_blood = amount
		gl.bloody_hands_mob = source
	else
		add_blood(source)
		bloody_hands = amount
		bloody_hands_mob = source
	update_inv_gloves()		//updates on-mob overlays for bloody hands and/or bloody gloves

/mob/living/carbon/human/proc/bloody_body(var/mob/living/source)
	if(wear_suit)
		wear_suit.add_blood(source)
		update_inv_wear_suit(0)
	if(w_uniform)
		w_uniform.add_blood(source)
		update_inv_w_uniform(0)

/mob/living/carbon/human/proc/handle_suit_punctures(var/damtype, var/damage, var/def_zone)

	// Tox and oxy don't matter to suits.
	if(damtype != BURN && damtype != BRUTE) return

	// The rig might soak this hit, if we're wearing one.
	if(istype(get_rig(),/obj/item/rig))
		var/obj/item/rig/rig = get_rig()
		rig.take_hit(damage)

	// We may also be taking a suit breach.
	if(!wear_suit) return
	if(!istype(wear_suit,/obj/item/clothing/suit/space)) return
	var/obj/item/clothing/suit/space/SS = wear_suit
	var/penetrated_dam = max(0,(damage - SS.breach_threshold))
	if(penetrated_dam) SS.create_breaches(damtype, penetrated_dam)

/mob/living/carbon/human/reagent_permeability()
	var/perm = 0

	var/list/perm_by_part = list(
		"head" = THERMAL_PROTECTION_HEAD,
		"upper_torso" = THERMAL_PROTECTION_UPPER_TORSO,
		"lower_torso" = THERMAL_PROTECTION_LOWER_TORSO,
		"legs" = THERMAL_PROTECTION_LEG_LEFT + THERMAL_PROTECTION_LEG_RIGHT,
		"feet" = THERMAL_PROTECTION_FOOT_LEFT + THERMAL_PROTECTION_FOOT_RIGHT,
		"arms" = THERMAL_PROTECTION_ARM_LEFT + THERMAL_PROTECTION_ARM_RIGHT,
		"hands" = THERMAL_PROTECTION_HAND_LEFT + THERMAL_PROTECTION_HAND_RIGHT
		)

	for(var/obj/item/clothing/C in src.get_equipped_items())
		if(C.permeability_coefficient == 1 || !C.body_parts_covered)
			continue
		if(C.body_parts_covered & HEAD)
			perm_by_part["head"] *= C.permeability_coefficient
		if(C.body_parts_covered & UPPER_TORSO)
			perm_by_part["upper_torso"] *= C.permeability_coefficient
		if(C.body_parts_covered & LOWER_TORSO)
			perm_by_part["lower_torso"] *= C.permeability_coefficient
		if(C.body_parts_covered & LEGS)
			perm_by_part["legs"] *= C.permeability_coefficient
		if(C.body_parts_covered & FEET)
			perm_by_part["feet"] *= C.permeability_coefficient
		if(C.body_parts_covered & ARMS)
			perm_by_part["arms"] *= C.permeability_coefficient
		if(C.body_parts_covered & HANDS)
			perm_by_part["hands"] *= C.permeability_coefficient

	for(var/part in perm_by_part)
		perm += perm_by_part[part]

	return perm

// This is for preventing harm by being covered in water, which only prometheans need to deal with.
/mob/living/carbon/human/get_water_protection()
	var/protection = species.water_resistance
	if(protection == 1) // No point doing permeability checks if it won't matter.
		return protection
	// Wearing clothing with a low permeability_coefficient can protect from water.

	var/converted_protection = 1 - protection
	var/perm = reagent_permeability()
	converted_protection *= perm
	return CLAMP(1-converted_protection, 0, 1)

/mob/living/carbon/human/water_act(amount)
	adjust_fire_stacks(-amount * 5)
	for(var/atom/movable/AM in contents)
		AM.water_act(amount)
	remove_modifiers_of_type(/datum/modifier/fire)

	species.handle_water_damage(src, amount)

/mob/living/carbon/human/shank_attack(obj/item/W, obj/item/grab/G, mob/user, hit_zone)

	if(!..())
		return 0

	var/organ_chance = 50
	var/damage = shank_armor_helper(W, G, user)
	var/obj/item/organ/external/chest = get_organ(hit_zone)

	if(W.edge)
		organ_chance = 75
	user.next_move = world.time + 20
	user.visible_message(span_danger("\The [user] begins to twist \the [W] around inside [src]'s [chest]!"))
	if(!do_after(user, 20))
		return 0
	if(!(G && G.assailant == user && G.affecting == src)) //check that we still have a grab
		return 0

	user.visible_message(span_danger("\The [user] twists \the [W] around inside [src]'s [chest]!"))

	if(prob(organ_chance))
		var/obj/item/organ/internal/selected_organ = pick(chest.internal_organs)
		selected_organ.damage = max(selected_organ.damage, damage * 0.5)
		G.last_action = world.time
		flick(G.hud.icon_state, G.hud)

	return 1
