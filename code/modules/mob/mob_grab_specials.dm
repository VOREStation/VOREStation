/obj/item/grab/proc/inspect_organ(mob/living/carbon/human/H, mob/user, var/target_zone)

	var/obj/item/organ/external/E = H.get_organ(target_zone)

	if(!E || E.is_stump())
		to_chat(user, span_notice("[H] is missing that bodypart."))
		return

	user.visible_message(span_notice("[user] starts inspecting [affecting]'s [E.name] carefully."))
	if(!do_after(user, 1 SECOND, H))
		to_chat(user, span_notice("You must stand still to inspect [E] for wounds."))
	else if(LAZYLEN(E.wounds))
		to_chat(user, span_warning("You find [E.get_wounds_desc()]"))
	else
		to_chat(user, span_notice("You find no visible wounds."))

	to_chat(user, span_notice("Checking bones now..."))
	if(!do_after(user, 2 SECONDS, H))
		to_chat(user, span_notice("You must stand still to feel [E] for fractures."))
	if(E.nonsolid && E.cannot_break) //boneless!
		to_chat(user, span_warning("You are unable to feel any bones in the [E.name]!"))
	else if(E.status & ORGAN_BROKEN)
		to_chat(user, span_warning("The [E.encased ? E.encased : "bone in the [E.name]"] moves slightly when you poke it!"))
		H.custom_pain("Your [E.name] hurts where it's poked.", 40)
	else
		to_chat(user, span_notice("The [E.encased ? E.encased : "bones in the [E.name]"] seem to be fine."))

	to_chat(user, span_notice("Checking skin now..."))
	if(!do_after(user, 1 SECOND, H))
		to_chat(user, span_notice("You must stand still to check [H]'s skin for abnormalities."))
	else
		var/bad = 0
		if(H.getToxLoss() >= 40)
			to_chat(user, span_warning("[H] has an unhealthy skin discoloration."))
			bad = 1
		if(H.getOxyLoss() >= 20)
			to_chat(user, span_warning("[H]'s skin is unusaly pale."))
			bad = 1
		if(E.status & ORGAN_DEAD)
			to_chat(user, span_warning("[E] is decaying!"))
			bad = 1
		if(E.status & ORGAN_DEAD) //this is also infection level 3
			to_chat(user, span_bolddanger("[H]'s [E.name] is gangreous and completely dead!"))
			bad = 1
		else if(E.germ_level > INFECTION_LEVEL_ONE)
			if(E.germ_level > INFECTION_LEVEL_TWO)
				to_chat(user, span_danger("[H]'s [E.name] shows signs of a severe infection!"))
				bad = 1
			else
				to_chat(user, span_warning("[H] shows signs of infection in the [E.name]."))
				bad = 1
		if(LAZYLEN(E.wounds))
			for(var/datum/wound/W in E.wounds)
				if(W.internal)
					to_chat(user, span_danger("You find a large, swelling hematoma in the skin")) //INTERNAL BLEEDING, BE VERY AFRAID.
					break
		if(!bad)
			to_chat(user, span_notice("[H]'s skin is normal."))

	var/body_part = parse_zone(target_zone)
	if(body_part == BP_GROIN || body_part == BP_TORSO || body_part == BP_HEAD)
		to_chat(user, span_notice("Checking for internal injury now..."))
		if(!do_after(user, 5 SECONDS, H))
			to_chat(user, span_notice("You must stand still to check [H]'s [E.name] for internal injury."))
		else

			///If we have a bad organ down here. Very non-specific. Doctor should ask how badly it hurt.
			var/bad_organs = 0
			///If we have appendicitis or not.
			var/appendicitis = FALSE
			switch(body_part)

				if(BP_GROIN)
					var/obj/item/organ/internal/intestine/intestine = H.internal_organs_by_name[O_INTESTINE]
					var/obj/item/organ/internal/stomach/stomach = H.internal_organs_by_name[O_STOMACH]
					var/obj/item/organ/internal/kidneys/kidneys = H.internal_organs_by_name[O_KIDNEYS]
					var/obj/item/organ/internal/liver/liver = H.internal_organs_by_name[O_LIVER]
					var/obj/item/organ/internal/spleen/spleen = H.internal_organs_by_name[O_SPLEEN]
					var/obj/item/organ/internal/appendix/appendix = H.internal_organs_by_name[O_APPENDIX]
					if(intestine && intestine.is_bruised())
						bad_organs++
					if(stomach && stomach.is_bruised())
						bad_organs++
					if(kidneys && kidneys.is_bruised())
						bad_organs++
					if(liver && liver.is_bruised())
						bad_organs++
					if(spleen && spleen.is_bruised())
						bad_organs++
					if(appendix && (appendix.is_bruised() || appendix.inflamed))
						bad_organs++
						appendicitis = TRUE

				if(BP_TORSO)
					var/obj/item/organ/internal/lungs/lungs = H.internal_organs_by_name[O_LUNGS]
					var/obj/item/organ/internal/heart/heart = H.internal_organs_by_name[O_HEART]
					if(lungs && lungs.is_bruised())
						bad_organs++
					if(heart && heart.is_bruised())
						bad_organs++

				if(BP_HEAD)
					var/obj/item/organ/internal/voicebox/voicebox = H.internal_organs_by_name[O_VOICE]
					if(voicebox && voicebox.is_bruised())
						bad_organs++

			if(bad_organs)
				to_chat(user, span_warning("[H]'s [E.name] appears to be tender when you press on it, indicating an internal injury."))
				H.custom_pain("Your [E.name] hurts where it's poked.", bad_organs*20)

			if(appendicitis)
				var/pain_check = (H.stat && (H.can_feel_pain() || H.synth_cosmetic_pain) && H.chem_effects[CE_PAINKILLER] < 60)
				if(pain_check) //They can feel pain.
					to_chat(user, span_danger("[H] jolts when you let go of their [E.name], indicating appendicitis!"))
					H.custom_pain("You feel pure agony as [src] pushes down on your [E.name]!", 200)

/obj/item/grab/proc/jointlock(mob/living/carbon/human/target, mob/attacker, var/target_zone)
	if(state < GRAB_AGGRESSIVE)
		to_chat(attacker, span_warning("You require a better grab to do this."))
		return

	var/obj/item/organ/external/organ = target.get_organ(check_zone(target_zone))
	if(!organ || organ.dislocated == -1)
		return

	attacker.visible_message(span_danger("[attacker] [pick("bent", "twisted")] [target]'s [organ.name] into a jointlock!"))

	if(target.species.flags & NO_PAIN)
		return

	var/armor = target.run_armor_check(target, "melee")
	if(armor < 60)
		to_chat(target, span_danger("You feel extreme pain!"))

		var/max_halloss = round(target.getMaxHealth() * 0.8) //up to 80% of passing out
		affecting.adjustHalLoss(CLAMP(max_halloss - affecting.halloss, 0, 30))

/obj/item/grab/proc/attack_eye(mob/living/carbon/human/target, mob/living/carbon/human/attacker)
	if(!istype(attacker))
		return

	var/datum/unarmed_attack/attack = attacker.get_unarmed_attack(target, O_EYES)

	if(!attack)
		return
	if(state < GRAB_NECK)
		to_chat(attacker, span_warning("You require a better grab to do this."))
		return
	for(var/obj/item/protection in list(target.head, target.wear_mask, target.glasses))
		if(protection && (protection.body_parts_covered & EYES))
			to_chat(attacker, span_danger("You're going to need to remove the eye covering first."))
			return
	if(!target.has_eyes())
		to_chat(attacker, span_danger("You cannot locate any eyes on [target]!"))
		return

	add_attack_logs(attacker,target,"Eye gouge using grab")

	attack.handle_eye_attack(attacker, target)

/obj/item/grab/proc/headbutt(mob/living/carbon/human/target, mob/living/carbon/human/attacker)
	if(!istype(attacker))
		return
	if(target.lying)
		return
	attacker.visible_message(span_danger("[attacker] thrusts [attacker.p_their()] head into [target]'s skull!"))

	var/damage = 20
	var/obj/item/clothing/hat = attacker.head
	if(istype(hat))
		damage += hat.force * 3

	var/armor = target.run_armor_check(BP_HEAD, "melee")
	target.apply_damage(damage, BRUTE, BP_HEAD, armor)
	attacker.apply_damage(10, BRUTE, BP_HEAD, attacker.run_armor_check(BP_HEAD))

	if(!armor && target.headcheck(BP_HEAD) && prob(damage))
		target.apply_effect(20, PARALYZE)
		target.visible_message(span_danger("[target] [target.species.get_knockout_message(target)]"))

	playsound(attacker, "swing_hit", 25, 1, -1)
	add_attack_logs(attacker,target,"Headbutted using grab")

	attacker.drop_from_inventory(src)
	src.loc = null
	qdel(src)
	return

/obj/item/grab/proc/dislocate(mob/living/carbon/human/target, mob/living/attacker, var/target_zone)
	if(state < GRAB_NECK)
		to_chat(attacker, span_warning("You require a better grab to do this."))
		return
	if(target.grab_joint(attacker, target_zone))
		playsound(src, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		return

/obj/item/grab/proc/pin_down(mob/target, mob/attacker)
	if(state < GRAB_AGGRESSIVE)
		to_chat(attacker, span_warning("You require a better grab to do this."))
		return
	if(force_down)
		to_chat(attacker, span_warning("You are already pinning [target] to the ground."))
		return
	if(size_difference(affecting, assailant) > 0)
		to_chat(attacker, span_warning("You are too small to do that!"))
		return

	attacker.visible_message(span_danger("[attacker] starts forcing [target] to the ground!"))
	if(do_after(attacker, 2 SECONDS, target) && target)
		last_action = world.time
		attacker.visible_message(span_danger("[attacker] forces [target] to the ground!"))
		apply_pinning(target, attacker)

/obj/item/grab/proc/apply_pinning(mob/target, mob/attacker)
	force_down = 1
	target.Weaken(3)
	target.lying = 1
	step_to(attacker, target)
	attacker.set_dir(EAST) //face the victim
	target.set_dir(SOUTH) //face up
