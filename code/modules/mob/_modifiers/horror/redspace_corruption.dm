///The PERMANENT debuff that redspace warp leaves you with.
/datum/modifier/redspace_corruption
	name = "redspace corruption"
	desc = "Your body has been permanently twisted."

	on_created_text = null
	on_expired_text = null

	stacks = MODIFIER_STACK_EXTEND

	///Time since we last revived
	var/time_since_revival = 0

	///Cooldown on how often we can revive.
	var/revival_cooldown = 60 SECONDS

	///When did we last do a 'heal tick' ?
	var/heal_tick = 0

	///How often do we do a 'heal tick' ?
	var/heal_tick_cooldown = 5 SECONDS

	///What chance is there per tick that we unsheath an armblade and face someone?
	var/blade_chance = 1

	///What is the chance that we inject a paralyze a nearby crewmember that is standing too close to us?
	var/injection_chance = 0.5

	///If we have our flesh armor deployed or not.
	var/armor_deployed = FALSE

	///At what time did we deploy our armor?
	var/armor_deployed_time = 0

	///How long can we upkeep our armor?
	var/armor_duration = 1 MINUTE

	///What is our hivemind name?
	var/speech_name = "The Unseen Horror"


	var/mob/living/carbon/human/unfortunate_soul //The human target of our modifier.

/datum/modifier/redspace_corruption/can_apply(mob/living/L, suppress_output = TRUE)
	if(ishuman(L) && !L.isSynthetic())
		if(L.mind?.assigned_role == JOB_CHAPLAIN)
			return FALSE
		return TRUE
	return FALSE

/datum/modifier/redspace_corruption/on_applied()
	unfortunate_soul = holder
	ADD_TRAIT(unfortunate_soul, TRAIT_REDSPACE_CORRUPTED, UNHOLY_TRAIT)
	ADD_TRAIT(unfortunate_soul, UNIQUE_MINDSTRUCTURE, UNHOLY_TRAIT)
	speech_name = pick("Lost Soul", "Rescued One", "The Embraced", "The Chosen", "The Unseen Horror", "Obedient Servant", "Willing Follower")

	//SHUNT ALL THE IMPORTANT ORGANS TO THE CHEST!
	var/obj/item/organ/internal/brain/brain = unfortunate_soul.internal_organs_by_name[O_BRAIN]
	var/obj/item/organ/internal/eyes/eyes = unfortunate_soul.internal_organs_by_name[O_EYES]
	var/obj/item/organ/external/chest/torso = unfortunate_soul.get_organ(BP_TORSO)
	if(unfortunate_soul.should_have_organ(O_BRAIN))
		brain.parent_organ = BP_TORSO //Move the brain to the torso.
		torso.internal_organs |= brain
	if(unfortunate_soul.should_have_organ(O_EYES))
		eyes.parent_organ = BP_TORSO //Move the eyes to the torso.
		torso.internal_organs |= eyes
	for(var/obj/item/organ/external/head/ex_organ in unfortunate_soul.organs)
		ex_organ.cannot_break = TRUE
		ex_organ.dislocated = -1
		ex_organ.nonsolid = TRUE
		ex_organ.spread_dam = TRUE
		ex_organ.max_damage = 5 //VERY fragile, now.
		ex_organ.vital = FALSE
		ex_organ.encased = FALSE
		ex_organ.cannot_gib = FALSE
		if(brain)
			ex_organ.internal_organs -= brain //Remove the brain from the head.
		if(eyes)
			ex_organ.internal_organs -= eyes

/datum/modifier/redspace_corruption/on_expire()
	REMOVE_TRAIT(unfortunate_soul, TRAIT_REDSPACE_CORRUPTED, UNHOLY_TRAIT)
	REMOVE_TRAIT(unfortunate_soul, UNIQUE_MINDSTRUCTURE, UNHOLY_TRAIT)
	unfortunate_soul = null

/datum/modifier/redspace_corruption/tick()
	//Handles resurrection and healing if dead.
	var/bellied = FALSE
	if(isbelly(unfortunate_soul.loc))
		bellied = TRUE
		var/mob/living/carbon/human/predator = unfortunate_soul.loc.loc
		if(istype(predator) && !predator.HasDisease(/datum/disease/fleshy_spread))
			var/datum/disease/fleshy_spread/flesh_disease = new /datum/disease/fleshy_spread()
			predator.ForceContractDisease(flesh_disease, BP_TORSO)

	if(unfortunate_soul.stat == DEAD)
		handle_death()
		return

	if(!armor_deployed && (unfortunate_soul.stunned || unfortunate_soul.weakened || unfortunate_soul.paralysis || unfortunate_soul.health < unfortunate_soul.getMaxHealth() * 0.75))
		if(assume_battle_stance())
			unfortunate_soul.adjustHalLoss(-200) //WAKE UP SAMURI
			unfortunate_soul.reagents.add_reagent(REAGENT_ID_ADRENALINE, 5)
			unfortunate_soul.reagents.add_reagent(REAGENT_ID_EPINEPHRINE, 5)
			unfortunate_soul.reagents.add_reagent(REAGENT_ID_NUMBENZYME, 1)
			to_chat(unfortunate_soul, span_large(span_bolddanger("Your body surges with adrenaline, and every cell ignites with a primal fight or flight. Your instincts are screaming through every fiber of your body: Escape the danger. Kill the threats. Protect your body. SURVIVE.")))
			return

	else if(unfortunate_soul.stat == UNCONSCIOUS)
		return

	if(bellied)
		return

	if(armor_deployed && ((armor_deployed_time + armor_duration) < world.time)) //Time ran out.

		//Are we still in panic mode?
		if(unfortunate_soul.stunned || unfortunate_soul.weakened || unfortunate_soul.paralysis || (unfortunate_soul.health < unfortunate_soul.maxHealth * 0.75))
			return
		else
			exit_battle_stance()
		return
	//Stuff that happens when we're ALIVE.
	if(prob(blade_chance))
		//If we have an open hand and we have people near us, unsheath an armblade and face them.
		//This plays a BIG SCARY MESSAGE in chat and will make people panic.
		if(!unfortunate_soul.hands_are_full())
			if(attempt_armblade())
				return
	if(prob(injection_chance))
		var/list_of_humans = list()
		for(var/mob/living/carbon/human/target in oview(1, unfortunate_soul.loc))
			if(target.has_modifier_of_type(/datum/modifier/redspace_corruption)) //No cyclic injections!
				continue
			if(is_changeling(target))
				continue
			if(target.HasDisease(/datum/disease/fleshy_spread))
				continue
			list_of_humans += target

		if(LAZYLEN(list_of_humans))
			var/mob/living/carbon/human/prey = pick(list_of_humans)
			if(!prey)
				return
			to_chat(prey, span_bolddanger("You feel a tiny prick."))
			prey.reagents.add_reagent(REAGENT_ID_ZOMBIEPOWDER, 3)
			if(!prey.HasDisease(/datum/disease/fleshy_spread))
				var/datum/disease/fleshy_spread/flesh_disease = new /datum/disease/fleshy_spread()
				prey.ForceContractDisease(flesh_disease)
			to_chat(unfortunate_soul, span_warning("[prey] walks too close to you, your body instinctually stinging them"))
			return
	return

/datum/modifier/redspace_corruption/proc/handle_death()

	//Cooldown?

	if(armor_deployed)
		exit_battle_stance()

	if(heal_tick + heal_tick_cooldown > world.time)
		return

	var/obj/item/organ/internal/brain/brain = unfortunate_soul.internal_organs_by_name[O_BRAIN]
	if(unfortunate_soul.should_have_organ(O_BRAIN))
		if(!brain) //Removed the brain? Can't do anything.
			return

	var/obj/item/organ/internal/heart/heart = unfortunate_soul.internal_organs_by_name[O_HEART]
	if(!heart)
		return


	var/blood_volume = unfortunate_soul.vessel.get_reagent_amount(REAGENT_ID_BLOOD)
	var/lethal_blood = FALSE
	if(unfortunate_soul.reagents.get_reagent_amount(REAGENT_ID_MYELAMINE) < 5)
		unfortunate_soul.reagents.add_reagent(REAGENT_ID_MYELAMINE, 5) //Helps stabilize them.
	if(!heart || heart.is_broken())
		blood_volume *= 0.3
	else if(heart.is_bruised())
		blood_volume *= 0.7
	else if(heart.damage > 1)
		blood_volume *= 0.8
	if(blood_volume < unfortunate_soul.species.blood_volume*unfortunate_soul.species.blood_level_fatal)
		unfortunate_soul.reagents.add_reagent(REAGENT_ID_SYNTHBLOOD, 25) //Will get processed below.
		lethal_blood = TRUE

	//Circulate chems.
	for(var/i in 1 to 5)
		unfortunate_soul.handle_chemicals_in_body()
	unfortunate_soul.handle_organs()

	//Slowly come back from the dead.
	unfortunate_soul.heal_overall_damage(2, 2)
	unfortunate_soul.adjustToxLoss(-5)
	unfortunate_soul.adjustOxyLoss(-5)
	unfortunate_soul.adjustBrainLoss(-0.5)

	//Handle our organs. We might not heal entirely before we come back, but that's fine. If we die again, we come back again.
	for(var/obj/item/organ/I in unfortunate_soul.internal_organs)
		I.process()
		I.germ_level = max(0, I.germ_level - 25)
		I.damage = max(0, I.damage - 2.5)
		if(I.status & ORGAN_DEAD && (I.damage < I.is_broken()) && (I.germ_level < INFECTION_LEVEL_ONE)) //If we have any dead organs, try to revive them.
			I.status = 0

	for(var/obj/item/organ/external/limb in unfortunate_soul.bad_external_organs)
		limb.germ_level = max(0, limb.germ_level - 25)
		if(limb.status & ORGAN_DEAD && (limb.damage < limb.is_broken()) && (limb.germ_level < INFECTION_LEVEL_ONE)) //If we have any dead organs, try to revive them.
			limb.status = 0

	heal_tick = world.time

	//Big checks to see if there's a reason we CAN'T revive.
	if(time_since_revival + revival_cooldown > world.time) //On cooldown.
		return
	if(lethal_blood) //Blood volume is low enough we'd immediately die upon revival.
		return
	if(unfortunate_soul.health <= -(unfortunate_soul.getMaxHealth() * 0.33)) //Too injured to revive. We want to be a bit JUST before hardcrit.
		return
	if(unfortunate_soul.check_vital_organs()) //Missing a vital organ.
		return
	if(unfortunate_soul.teleop) //Aghosted or the sort.
		return
	if(!unfortunate_soul.mind) //Mind is gone.
		return


	//This won't get EVERYTHING, but if we end up reviving just to die shortly afterwards to heal up further, that's fine.

	//Time to revive! This FORCIBLY grabs their mind and puts it back in.
	revive()
	return

/datum/modifier/redspace_corruption/proc/revive()
	//Force us back into the body.
	unfortunate_soul.grab_ghost(TRUE)

	//Defib stuff here.
	GLOB.dead_mob_list.Remove(unfortunate_soul)
	if((unfortunate_soul in GLOB.living_mob_list) || (unfortunate_soul in GLOB.dead_mob_list))
		WARNING("Mob [unfortunate_soul] was revived but already in the living or dead list still!")
	GLOB.living_mob_list += unfortunate_soul
	unfortunate_soul.timeofdeath = 0
	unfortunate_soul.set_stat(UNCONSCIOUS) //Life() can bring them back to consciousness if it needs to.
	unfortunate_soul.failed_last_breath = 0 //So mobs that died of oxyloss don't revive and have perpetual out of breath.
	unfortunate_soul.reload_fullscreen()

	//Awaken!
	unfortunate_soul.emote("gasp")
	unfortunate_soul.Weaken(rand(10,25))
	unfortunate_soul.updatehealth()
	time_since_revival = world.time

//Returns TRUE If we succeeded. FALSE if we failed.
/datum/modifier/redspace_corruption/proc/attempt_armblade()
	var/list_of_humans = list()
	for(var/mob/living/carbon/human/target in oview(4, unfortunate_soul.loc))
		if(target.has_modifier_of_type(/datum/modifier/redspace_corruption)) //Flesh knows flesh.
			continue
		if(is_changeling(target))
			continue
		list_of_humans += target
	if(LAZYLEN(list_of_humans))
		var/mob/person_to_stare_at_with_our_special_eyes = pick(list_of_humans)
		if(!person_to_stare_at_with_our_special_eyes)
			return FALSE
		deploy_armblade()
		unfortunate_soul.face_atom(person_to_stare_at_with_our_special_eyes)
		if(get_dist(unfortunate_soul, person_to_stare_at_with_our_special_eyes.loc) > 1)
			step_towards(unfortunate_soul, person_to_stare_at_with_our_special_eyes)
		if(get_dist(unfortunate_soul, person_to_stare_at_with_our_special_eyes.loc) > 1)
			step_towards(unfortunate_soul, person_to_stare_at_with_our_special_eyes)
		return TRUE
	return FALSE

/datum/modifier/redspace_corruption/proc/deploy_armblade()
	var/obj/item/melee/changeling/arm_blade/blade = new /obj/item/melee/changeling/arm_blade(unfortunate_soul)
	var/datum/disease/fleshy_spread/flesh_disease = new /datum/disease/fleshy_spread
	blade.AddComponent(/datum/component/infective, \
	flesh_disease, \
	weak = FALSE)
	if(!unfortunate_soul.put_in_hands(blade))
		qdel(blade) //failed, sad.

//shamelessly stolen from changeling/armor.dm
/datum/modifier/redspace_corruption/proc/equip_flesh_armor(armor_type, helmet_type, boot_type, glove_type)
	if(!armor_type)
		armor_type = /obj/item/clothing/suit/space/changeling/armored
	if(!helmet_type)
		helmet_type = /obj/item/clothing/head/helmet/space/changeling/armored
	if(!boot_type)
		boot_type = /obj/item/clothing/shoes/magboots/changeling/armored
	if(!glove_type)
		glove_type = /obj/item/clothing/gloves/combat/changeling

	var/mob/living/carbon/human/M = unfortunate_soul

	//First, check if we're already wearing the armor, and if so, take it off.
	if(istype(M.wear_suit, armor_type) || istype(M.head, helmet_type) || istype(M.shoes, boot_type) || istype(M.gloves, glove_type))
		M.visible_message(span_warning("[M] casts off their [M.wear_suit.name]!"),
		span_warning("We cast off our [M.wear_suit.name]"),
		span_warningplain("You hear the organic matter ripping and tearing!"))
		if(istype(M.wear_suit, armor_type))
			qdel(M.wear_suit)
		if(istype(M.head, helmet_type))
			qdel(M.head)
		if(istype(M.shoes, boot_type))
			qdel(M.shoes)
		if(istype(M.gloves, glove_type))
			qdel(M.gloves)
		M.update_inv_wear_suit()
		M.update_inv_head()
		M.update_hair()
		M.update_inv_shoes()
		M.update_inv_gloves()
		return TRUE

	var/obj/item/clothing/suit/A = new armor_type(M)
	if(M.wear_suit)
		M.unEquip(M.wear_suit, TRUE)
	M.equip_to_slot_or_del(A, slot_wear_suit)

	var/obj/item/clothing/suit/H = new helmet_type(M)
	if(M.head)
		M.unEquip(M.head, TRUE)
	M.equip_to_slot_or_del(H, slot_head)

	var/obj/item/clothing/shoes/B = new boot_type(M)
	if(M.shoes)
		M.unEquip(M.shoes, TRUE)
	M.equip_to_slot_or_del(B, slot_shoes)

	var/obj/item/clothing/gloves/G = new glove_type(M)
	if(M.gloves)
		M.unEquip(M.gloves, TRUE)
	M.equip_to_slot_or_del(G, slot_gloves)

	playsound(M, 'sound/effects/blobattack.ogg', 30, 1)
	M.update_inv_wear_suit()
	M.update_inv_head()
	M.update_hair()
	M.update_inv_shoes()
	M.update_inv_gloves()
	return TRUE

///Equips armor and melee weapon. If we succeed, returns TRUE. FALSE if we fail.
/datum/modifier/redspace_corruption/proc/assume_battle_stance()
	if(equip_flesh_armor())
		to_chat(unfortunate_soul, span_warning("Your flesh shifts and hardens into a protective armor!"))
		armor_deployed = TRUE
		armor_deployed_time = world.time
		unfortunate_soul.drop_l_hand()
		unfortunate_soul.drop_r_hand()
		deploy_armblade()
		deploy_armblade()
		return TRUE
	return FALSE

/datum/modifier/redspace_corruption/proc/exit_battle_stance()
	if(armor_deployed)
		equip_flesh_armor()
		armor_deployed = FALSE
		unfortunate_soul.drop_l_hand()
		unfortunate_soul.drop_r_hand()
