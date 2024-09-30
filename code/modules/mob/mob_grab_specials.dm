/obj/item/grab/proc/inspect_organ(mob/living/carbon/human/H, mob/user, var/target_zone)

	var/obj/item/organ/external/E = H.get_organ(target_zone)

	if(!E || E.is_stump())
		to_chat(user, "<span class='notice'>[H] is missing that bodypart.</span>")
		return

	user.visible_message("<span class='notice'>[user] starts inspecting [affecting]'s [E.name] carefully.</span>")
	if(!do_mob(user,H, 10))
		to_chat(user, "<span class='notice'>You must stand still to inspect [E] for wounds.</span>")
	else if(E.wounds.len)
		to_chat(user, "<span class='warning'>You find [E.get_wounds_desc()]</span>")
	else
		to_chat(user, "<span class='notice'>You find no visible wounds.</span>")

	to_chat(user, "<span class='notice'>Checking bones now...</span>")
	if(!do_mob(user, H, 20))
		to_chat(user, "<span class='notice'>You must stand still to feel [E] for fractures.</span>")
	else if(E.status & ORGAN_BROKEN)
		to_chat(user, "<span class='warning'>The [E.encased ? E.encased : "bone in the [E.name]"] moves slightly when you poke it!</span>")
		H.custom_pain("Your [E.name] hurts where it's poked.", 40)
	else
		to_chat(user, "<span class='notice'>The [E.encased ? E.encased : "bones in the [E.name]"] seem to be fine.</span>")

	to_chat(user, "<span class='notice'>Checking skin now...</span>")
	if(!do_mob(user, H, 10))
		to_chat(user, "<span class='notice'>You must stand still to check [H]'s skin for abnormalities.</span>")
	else
		var/bad = 0
		if(H.getToxLoss() >= 40)
			to_chat(user, "<span class='warning'>[H] has an unhealthy skin discoloration.</span>")
			bad = 1
		if(H.getOxyLoss() >= 20)
			to_chat(user, "<span class='warning'>[H]'s skin is unusaly pale.</span>")
			bad = 1
		if(E.status & ORGAN_DEAD)
			to_chat(user, "<span class='warning'>[E] is decaying!</span>")
			bad = 1
		if(!bad)
			to_chat(user, "<span class='notice'>[H]'s skin is normal.</span>")

/obj/item/grab/proc/jointlock(mob/living/carbon/human/target, mob/attacker, var/target_zone)
	if(state < GRAB_AGGRESSIVE)
		to_chat(attacker, "<span class='warning'>You require a better grab to do this.</span>")
		return

	var/obj/item/organ/external/organ = target.get_organ(check_zone(target_zone))
	if(!organ || organ.dislocated == -1)
		return

	attacker.visible_message("<span class='danger'>[attacker] [pick("bent", "twisted")] [target]'s [organ.name] into a jointlock!</span>")

	if(target.species.flags & NO_PAIN)
		return

	var/armor = target.run_armor_check(target, "melee")
	var/soaked = target.get_armor_soak(target, "melee")
	if(armor + soaked < 60)
		to_chat(target, "<span class='danger'>You feel extreme pain!</span>")

		var/max_halloss = round(target.species.total_health * 0.8) //up to 80% of passing out
		affecting.adjustHalLoss(CLAMP(max_halloss - affecting.halloss, 0, 30))

/obj/item/grab/proc/attack_eye(mob/living/carbon/human/target, mob/living/carbon/human/attacker)
	if(!istype(attacker))
		return

	var/datum/unarmed_attack/attack = attacker.get_unarmed_attack(target, O_EYES)

	if(!attack)
		return
	if(state < GRAB_NECK)
		to_chat(attacker, "<span class='warning'>You require a better grab to do this.</span>")
		return
	for(var/obj/item/protection in list(target.head, target.wear_mask, target.glasses))
		if(protection && (protection.body_parts_covered & EYES))
			to_chat(attacker, "<span class='danger'>You're going to need to remove the eye covering first.</span>")
			return
	if(!target.has_eyes())
		to_chat(attacker, "<span class='danger'>You cannot locate any eyes on [target]!</span>")
		return

	add_attack_logs(attacker,target,"Eye gouge using grab")

	attack.handle_eye_attack(attacker, target)

/obj/item/grab/proc/headbutt(mob/living/carbon/human/target, mob/living/carbon/human/attacker)
	if(!istype(attacker))
		return
	if(target.lying)
		return
	var/datum/gender/T = gender_datums[attacker.get_visible_gender()]
	attacker.visible_message("<span class='danger'>[attacker] thrusts [T.his] head into [target]'s skull!</span>")

	var/damage = 20
	var/obj/item/clothing/hat = attacker.head
	if(istype(hat))
		damage += hat.force * 3

	var/armor = target.run_armor_check(BP_HEAD, "melee")
	var/soaked = target.get_armor_soak(BP_HEAD, "melee")
	target.apply_damage(damage, BRUTE, BP_HEAD, armor, soaked)
	attacker.apply_damage(10, BRUTE, BP_HEAD, attacker.run_armor_check(BP_HEAD), attacker.get_armor_soak(BP_HEAD), "melee")

	if(!armor && target.headcheck(BP_HEAD) && prob(damage))
		target.apply_effect(20, PARALYZE)
		target.visible_message("<span class='danger'>[target] [target.species.get_knockout_message(target)]</span>")

	playsound(attacker, "swing_hit", 25, 1, -1)
	add_attack_logs(attacker,target,"Headbutted using grab")

	attacker.drop_from_inventory(src)
	src.loc = null
	qdel(src)
	return

/obj/item/grab/proc/dislocate(mob/living/carbon/human/target, mob/living/attacker, var/target_zone)
	if(state < GRAB_NECK)
		to_chat(attacker, "<span class='warning'>You require a better grab to do this.</span>")
		return
	if(target.grab_joint(attacker, target_zone))
		playsound(src, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		return

/obj/item/grab/proc/pin_down(mob/target, mob/attacker)
	if(state < GRAB_AGGRESSIVE)
		to_chat(attacker, "<span class='warning'>You require a better grab to do this.</span>")
		return
	if(force_down)
		to_chat(attacker, "<span class='warning'>You are already pinning [target] to the ground.</span>")
		return
	if(size_difference(affecting, assailant) > 0)
		to_chat(attacker, "<span class='warning'>You are too small to do that!</span>")
		return

	attacker.visible_message("<span class='danger'>[attacker] starts forcing [target] to the ground!</span>")
	if(do_after(attacker, 20) && target)
		last_action = world.time
		attacker.visible_message("<span class='danger'>[attacker] forces [target] to the ground!</span>")
		apply_pinning(target, attacker)

/obj/item/grab/proc/apply_pinning(mob/target, mob/attacker)
	force_down = 1
	target.Weaken(3)
	target.lying = 1
	step_to(attacker, target)
	attacker.set_dir(EAST) //face the victim
	target.set_dir(SOUTH) //face up

/obj/item/grab/proc/devour(mob/target, mob/user)
	var/can_eat
	if((FAT in user.mutations) && ismini(target))
		can_eat = 1
	else
		var/mob/living/carbon/human/H = user
		if(istype(H) && H.species.gluttonous)
			if(H.species.gluttonous == 2)
				can_eat = 2
			else if((H.mob_size > target.mob_size) && !ishuman(target) && ismini(target))
				can_eat = 1

	if(can_eat)
		var/mob/living/carbon/attacker = user
		user.visible_message("<span class='vdanger'>[user] is attempting to devour [target]!</span>")
		if(can_eat == 2)
			if(!do_mob(user, target)||!do_after(user, 30)) return
		else
			if(!do_mob(user, target)||!do_after(user, 70)) return
		user.visible_message("<span class='vdanger'>[user] devours [target]!</span>")
		target.loc = user
		attacker.stomach_contents.Add(target)
		qdel(src)
