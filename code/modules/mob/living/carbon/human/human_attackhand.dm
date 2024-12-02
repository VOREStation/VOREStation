/mob/living/carbon/human
	var/datum/unarmed_attack/default_attack

/mob/living/carbon/human/proc/get_unarmed_attack(var/mob/living/carbon/human/target, var/hit_zone)
	// VOREStation Edit - Begin
	if(nif && nif.flag_check(NIF_C_HARDCLAWS,NIF_FLAGS_COMBAT)){return unarmed_hardclaws}
	if(src.default_attack && src.default_attack.is_usable(src, target, hit_zone))
		if(pulling_punches)
			var/datum/unarmed_attack/soft_type = src.default_attack.get_sparring_variant()
			if(soft_type)
				return soft_type
		return src.default_attack
	// VOREStation Edit - End
	if(src.gloves)
		var/obj/item/clothing/gloves/G = src.gloves
		if(istype(G) && G.special_attack && G.special_attack.is_usable(src, target, hit_zone))
			if(pulling_punches)
				var/datum/unarmed_attack/soft_type = G.special_attack.get_sparring_variant()
				if(soft_type)
					return soft_type
			return G.special_attack
	if(src.default_attack && src.default_attack.is_usable(src, target, hit_zone))
		if(pulling_punches)
			var/datum/unarmed_attack/soft_type = src.default_attack.get_sparring_variant()
			if(soft_type)
				return soft_type
		return src.default_attack
	for(var/datum/unarmed_attack/u_attack in species.unarmed_attacks)
		if(u_attack.is_usable(src, target, hit_zone))
			if(pulling_punches)
				var/datum/unarmed_attack/soft_variant = u_attack.get_sparring_variant()
				if(soft_variant)
					return soft_variant
			return u_attack
	return null

/mob/living/carbon/human/attack_hand(mob/living/M as mob)
	var/datum/gender/TT = gender_datums[M.get_visible_gender()]
	var/mob/living/carbon/human/H = M
	if(istype(H))
		var/obj/item/organ/external/temp = H.organs_by_name["r_hand"]
		if(H.hand)
			temp = H.organs_by_name["l_hand"]
		if(!temp || !temp.is_usable())
			to_chat(H, span_warning("You can't use your hand."))
			return

		for(var/thing in GetViruses())
			var/datum/disease/D = thing
			if(D.IsSpreadByTouch())
				H.ContractDisease(D)

		for(var/thing in H.GetViruses())
			var/datum/disease/D = thing
			if(D.IsSpreadByTouch())
				ContractDisease(D)

	if(H.lying)
		return
	M.break_cloak()

	..()

	// Should this all be in Touch()?
	if(istype(H))
		if(H.get_accuracy_penalty() && H != src)	//Should only trigger if they're not aiming well
			var/hit_zone = get_zone_with_miss_chance(H.zone_sel.selecting, src, H.get_accuracy_penalty())
			if(!hit_zone)
				H.do_attack_animation(src)
				playsound(src, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
				visible_message(span_filter_combat("[span_red(span_bold("[H] reaches for [src], but misses!"))]"))
				return FALSE

		if(H != src && check_shields(0, null, H, H.zone_sel.selecting, H.name))
			H.do_attack_animation(src)
			return FALSE

	if(istype(M,/mob/living/carbon))
		for(var/datum/disease/D in M.GetViruses())
			if(D.spread_flags & CONTACT_HANDS)
				ContractDisease(D)

	switch(M.a_intent)
		if(I_HELP)

			// VOREStation Edit - Begin
			if (istype(H) && attempt_to_scoop(H))
				return 0;
			// VOREStation Edit - End
			if(istype(H) && health < CONFIG_GET(number/health_threshold_crit))
				if(!H.check_has_mouth())
					to_chat(H, span_danger("You don't have a mouth, you cannot perform CPR!"))
					return
				if(!check_has_mouth())
					to_chat(H, span_danger("They don't have a mouth, you cannot perform CPR!"))
					return
				if((H.head && (H.head.body_parts_covered & FACE)) || (H.wear_mask && (H.wear_mask.body_parts_covered & FACE)))
					to_chat(H, span_notice("Remove your mask!"))
					return 0
				if((head && (head.body_parts_covered & FACE)) || (wear_mask && (wear_mask.body_parts_covered & FACE)))
					to_chat(H, span_notice("Remove [src]'s mask!"))
					return 0

				if (!cpr_time)
					return 0

				cpr_time = 0
				spawn(30)
					cpr_time = 1

				H.visible_message(span_danger("\The [H] is trying to perform CPR on \the [src]!"))

				if(!do_after(H, 30))
					return

				H.visible_message(span_danger("\The [H] performs CPR on \the [src]!"))
				to_chat(H, span_warning("Repeat at least every 7 seconds."))

				if(istype(H) && health > CONFIG_GET(number/health_threshold_dead))
					adjustOxyLoss(-(min(getOxyLoss(), 5)))
					updatehealth()
					to_chat(src, span_notice("You feel a breath of fresh air enter your lungs. It feels good."))

			else if(!(M == src && apply_pressure(M, M.zone_sel.selecting)))
				help_shake_act(M)
			return TRUE

		if(I_GRAB)
			if(M == src || anchored)
				return 0
			for(var/obj/item/grab/G in src.grabbed_by)
				if(G.assailant == M)
					to_chat(M, span_notice("You already grabbed [src]."))
					return
			if(w_uniform)
				w_uniform.add_fingerprint(M)

			var/obj/item/grab/G = new /obj/item/grab(M, src)
			if(buckled)
				to_chat(M, span_notice("You cannot grab [src], [TT.he] is buckled in!"))
				return
			if(!G)	//the grab will delete itself in New if affecting is anchored
				return
			M.put_in_active_hand(G)
			G.synch()
			LAssailant = M

			H.do_attack_animation(src)
			playsound(src, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			//VORESTATION EDIT
			visible_message(span_warning("[M] has grabbed [src] [(M.zone_sel.selecting == BP_L_HAND || M.zone_sel.selecting == BP_R_HAND)? "by [(gender==FEMALE)? "her" : ((gender==MALE)? "his": "their")] hands": "passively"]!"))
			//VORESTATION END END
			return TRUE

		if(I_HURT)

			if(M.zone_sel.selecting == "mouth" && wear_mask && istype(wear_mask, /obj/item/grenade))
				var/obj/item/grenade/G = wear_mask
				if(!G.active)
					visible_message(span_danger("\The [M] pulls the pin from \the [src]'s [G.name]!"))
					G.activate(M)
					update_inv_wear_mask()
				else
					to_chat(M, span_warning("\The [G] is already primed! Run!"))
				return

			if(!istype(H))
				attack_generic(H,rand(1,3),"punched")
				return

			var/rand_damage = rand(1, 5)
			var/block = 0
			var/accurate = 0
			var/hit_zone = H.zone_sel.selecting
			var/obj/item/organ/external/affecting = get_organ(hit_zone)

			if(!affecting || affecting.is_stump())
				to_chat(M, span_danger("They are missing that limb!"))
				return TRUE

			switch(src.a_intent)
				if(I_HELP)
					// We didn't see this coming, so we get the full blow
					rand_damage = 5
					accurate = 1
				if(I_HURT, I_GRAB)
					// We're in a fighting stance, there's a chance we block
					if(src.canmove && src!=H && prob(20))
						block = 1

			if (M.grabbed_by.len)
				// Someone got a good grip on them, they won't be able to do much damage
				rand_damage = max(1, rand_damage - 2)

			if(src.grabbed_by.len || src.buckled || !src.canmove || src==H)
				accurate = 1 // certain circumstances make it impossible for us to evade punches
				rand_damage = 5

			// Process evasion and blocking
			var/miss_type = 0
			var/attack_message
			if(!accurate)
				/* ~Hubblenaut
					This place is kind of convoluted and will need some explaining.
					ran_zone() will pick out of 11 zones, thus the chance for hitting
					our target where we want to hit them is circa 9.1%.

					Now since we want to statistically hit our target organ a bit more
					often than other organs, we add a base chance of 20% for hitting it.

					This leaves us with the following chances:

					If aiming for chest:
						27.3% chance you hit your target organ
						70.5% chance you hit a random other organ
						 2.2% chance you miss

					If aiming for something else:
						23.2% chance you hit your target organ
						56.8% chance you hit a random other organ
						15.0% chance you miss

					Note: We don't use get_zone_with_miss_chance() here since the chances
						  were made for projectiles.
					TODO: proc for melee combat miss chances depending on organ?
				*/

				if(!hit_zone)
					attack_message = "[H] attempted to strike [src], but missed!"
					miss_type = 1

				if(prob(80))
					hit_zone = ran_zone(hit_zone, 70) //70% chance to hit what you're aiming at seems fair?
				if(prob(15) && hit_zone != BP_TORSO) // Missed!
					if(!src.lying)
						attack_message = "[H] attempted to strike [src], but missed!"
					else
						attack_message = "[H] attempted to strike [src], but [TT.he] rolled out of the way!"
						src.set_dir(pick(cardinal))
					miss_type = 1

			if(!miss_type && block)
				attack_message = "[H] went for [src]'s [affecting.name] but was blocked!"
				miss_type = 2

			// See what attack they use
			var/datum/unarmed_attack/attack = H.get_unarmed_attack(src, hit_zone)
			if(!attack)
				return FALSE

			if(attack.unarmed_override(H, src, hit_zone))
				return FALSE

			H.do_attack_animation(src)
			if(!attack_message)
				attack.show_attack(H, src, hit_zone, rand_damage)
			else
				H.visible_message(span_danger("[attack_message]"))

			playsound(src, ((miss_type) ? (miss_type == 1 ? attack.miss_sound : 'sound/weapons/thudswoosh.ogg') : attack.attack_sound), 25, 1, -1)

			add_attack_logs(H,src,"Melee attacked with fists (miss/block)")

			if(miss_type)
				return FALSE

			var/real_damage = rand_damage
			var/hit_dam_type = attack.damage_type
			real_damage += attack.get_unarmed_damage(H)
			if(H.gloves)
				if(istype(H.gloves, /obj/item/clothing/gloves))
					var/obj/item/clothing/gloves/G = H.gloves
					real_damage += G.punch_force
					hit_dam_type = G.punch_damtype
				else if(istype(H.gloves, /obj/item/clothing/accessory))
					var/obj/item/clothing/accessory/G = H.gloves
					real_damage += G.punch_force
					hit_dam_type = G.punch_damtype
				if(H.pulling_punches && !attack.sharp && !attack.edge)	//SO IT IS DECREED: PULLING PUNCHES WILL PREVENT THE ACTUAL DAMAGE FROM RINGS AND KNUCKLES, BUT NOT THE ADDED PAIN, BUT YOU CAN'T "PULL" A KNIFE
					hit_dam_type = AGONY
			real_damage *= damage_multiplier
			rand_damage *= damage_multiplier
			if(HULK in H.mutations)
				real_damage *= 2 // Hulks do twice the damage
				rand_damage *= 2
			real_damage = max(1, real_damage)

			var/armour = run_armor_check(hit_zone, "melee")
			var/soaked = get_armor_soak(hit_zone, "melee")
			// Apply additional unarmed effects.
			attack.apply_effects(H, src, armour, rand_damage, hit_zone)

			// Finally, apply damage to target
			apply_damage(real_damage, hit_dam_type, hit_zone, armour, soaked, sharp=attack.sharp, edge=attack.edge)

		if(I_DISARM)
			add_attack_logs(H,src,"Disarmed")

			M.do_attack_animation(src)

			if(w_uniform)
				w_uniform.add_fingerprint(M)
			var/obj/item/organ/external/affecting = get_organ(ran_zone(M.zone_sel.selecting))

			var/list/holding = list(get_active_hand() = 40, get_inactive_hand = 20)

			//See if they have any guns that might go off
			for(var/obj/item/gun/W in holding)
				if(W && prob(holding[W]))
					var/list/turfs = list()
					for(var/turf/T in view())
						turfs += T
					if(turfs.len)
						var/turf/target = pick(turfs)
						visible_message(span_danger("[src]'s [W] goes off during the struggle!"))
						return W.afterattack(target,src)

			if(last_push_time + 30 > world.time)
				visible_message(span_warning("[M] has weakly pushed [src]!"))
				return

			var/randn = rand(1, 100)
			last_push_time = world.time
			// We ARE wearing shoes OR
			// We as a species CAN be slipped when barefoot
			// And also 1 in 4 because rngesus
			if((shoes || !(species.flags & NO_SLIP)) && randn <= 25)
				var/armor_check = run_armor_check(affecting, "melee")
				apply_effect(3, WEAKEN, armor_check)
				playsound(src, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
				if(armor_check < 60)
					visible_message(span_danger("[M] has pushed [src]!"))
				else
					visible_message(span_warning("[M] attempted to push [src]!"))
				return

			if(randn <= 60)
				//See about breaking grips or pulls
				if(break_all_grabs(M))
					playsound(src, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
					return

				//Actually disarm them
				for(var/obj/item/I in holding)
					if(I)
						drop_from_inventory(I)
						visible_message(span_danger("[M] has disarmed [src]!"))
						playsound(src, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
						return

			playsound(src, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
			visible_message(span_filter_combat("[span_red(span_bold("[M] attempted to disarm [src]!"))]"))
	return

/mob/living/carbon/human/proc/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, inrange, params)
	return

/mob/living/carbon/human/attack_generic(var/mob/user, var/damage, var/attack_message, var/armor_type = "melee", var/armor_pen = 0, var/a_sharp = 0, var/a_edge = 0)

	if(!damage)
		return

	add_attack_logs(user,src,"Melee attacked with fists (miss/block)",admin_notify = FALSE) //No admin notice since this is usually fighting simple animals
	src.visible_message(span_danger("[user] has [attack_message] [src]!"))
	user.do_attack_animation(src)

	var/dam_zone = pick(organs_by_name)
	var/obj/item/organ/external/affecting = get_organ(ran_zone(dam_zone))
	var/armor_block = run_armor_check(affecting, armor_type, armor_pen)
	var/armor_soak = get_armor_soak(affecting, armor_type, armor_pen)
	apply_damage(damage, BRUTE, affecting, armor_block, armor_soak, sharp = a_sharp, edge = a_edge)
	updatehealth()
	return TRUE

//Used to attack a joint through grabbing
/mob/living/carbon/human/proc/grab_joint(var/mob/living/user, var/def_zone)
	var/has_grab = 0
	for(var/obj/item/grab/G in list(user.l_hand, user.r_hand))
		if(G.affecting == src && G.state == GRAB_NECK)
			has_grab = 1
			break

	if(!has_grab)
		return FALSE

	if(!def_zone) def_zone = user.zone_sel.selecting
	var/target_zone = check_zone(def_zone)
	if(!target_zone)
		return FALSE
	var/obj/item/organ/external/organ = get_organ(check_zone(target_zone))
	if(!organ || organ.dislocated > 0 || organ.dislocated == -1) //don't use is_dislocated() here, that checks parent
		return FALSE

	user.visible_message(span_warning("[user] begins to dislocate [src]'s [organ.joint]!"))
	if(do_after(user, 100))
		organ.dislocate(1)
		src.visible_message(span_danger("[src]'s [organ.joint] [pick("gives way","caves in","crumbles","collapses")]!"))
		return TRUE
	return FALSE

//Breaks all grips and pulls that the mob currently has.
/mob/living/carbon/human/proc/break_all_grabs(mob/living/carbon/user)
	var/success = FALSE
	if(pulling)
		visible_message(span_danger("[user] has broken [src]'s grip on [pulling]!"))
		success = TRUE
		stop_pulling()

	if(istype(l_hand, /obj/item/grab))
		var/obj/item/grab/lgrab = l_hand
		if(lgrab.affecting)
			visible_message(span_danger("[user] has broken [src]'s grip on [lgrab.affecting]!"))
			success = TRUE
		spawn(1)
			qdel(lgrab)
	if(istype(r_hand, /obj/item/grab))
		var/obj/item/grab/rgrab = r_hand
		if(rgrab.affecting)
			visible_message(span_danger("[user] has broken [src]'s grip on [rgrab.affecting]!"))
			success = TRUE
		spawn(1)
			qdel(rgrab)
	return success

/*
	We want to ensure that a mob may only apply pressure to one organ of one mob at any given time. Currently this is done mostly implicitly through
	the behaviour of do_after() and the fact that applying pressure to someone else requires a grab:
	If you are applying pressure to yourself and attempt to grab someone else, you'll change what you are holding in your active hand which will stop do_mob()
	If you are applying pressure to another and attempt to apply pressure to yourself, you'll have to switch to an empty hand which will also stop do_mob()
	Changing targeted zones should also stop do_mob(), preventing you from applying pressure to more than one body part at once.
*/
/mob/living/carbon/human/proc/apply_pressure(mob/living/user, var/target_zone)
	var/obj/item/organ/external/organ = get_organ(target_zone)
	if(!organ || !(organ.status & ORGAN_BLEEDING) || (organ.robotic >= ORGAN_ROBOT))
		return FALSE

	if(organ.applied_pressure)
		var/message = span_warning("Someone is already applying pressure to [user == src ? "your [organ.name]" : "[src]'s [organ.name]"].")
		to_chat(user,message)
		return FALSE

	var/datum/gender/TU = gender_datums[user.get_visible_gender()]

	if(user == src)
		user.visible_message(span_filter_notice("\The [user] starts applying pressure to [TU.his] [organ.name]!"), span_filter_notice("You start applying pressure to your [organ.name]!"))
	else
		user.visible_message(span_filter_notice("\The [user] starts applying pressure to [src]'s [organ.name]!"), span_filter_notice("You start applying pressure to [src]'s [organ.name]!"))
	spawn(0)
		organ.applied_pressure = user

		//apply pressure as long as they stay still and keep grabbing
		do_mob(user, src, INFINITY, target_zone, progress = 0)

		organ.applied_pressure = null

		if(user == src)
			user.visible_message(span_filter_notice("\The [user] stops applying pressure to [TU.his] [organ.name]!"), span_filter_notice("You stop applying pressure to your [organ]!"))
		else
			user.visible_message(span_filter_notice("\The [user] stops applying pressure to [src]'s [organ.name]!"), span_filter_notice("You stop applying pressure to [src]'s [organ.name]!"))

	return TRUE

/mob/living/carbon/human/verb/check_attacks()
	set name = "Check Attacks"
	set category = "IC.Game"
	set src = usr

	var/dat = span_bold(span_giant("Known Attacks")) + "<br/><br/>"

	if(default_attack)
		dat += "Current default attack: [default_attack.attack_name] - <a href='byond://?src=\ref[src];default_attk=reset_attk'>reset</a><br/><br/>"

	for(var/datum/unarmed_attack/u_attack in species.unarmed_attacks)
		if(u_attack == default_attack)
			dat += span_bold("Primarily [u_attack.attack_name]") + " - default - <a href='byond://?src=\ref[src];default_attk=reset_attk'>reset</a><br/><br/><br/>"
		else
			dat += span_bold("Primarily [u_attack.attack_name]") + " - <a href='byond://?src=\ref[src];default_attk=\ref[u_attack]'>set default</a><br/><br/><br/>"

	src << browse(dat, "window=checkattack")

/mob/living/carbon/human/Topic(href, href_list)
	if(href_list["default_attk"])
		if(href_list["default_attk"] == "reset_attk")
			set_default_attack(null)
		else
			var/datum/unarmed_attack/u_attack = locate(href_list["default_attk"])
			if(u_attack && (u_attack in species.unarmed_attacks))
				set_default_attack(u_attack)
		check_attacks()
		return 1
	else
		return ..()

/mob/living/carbon/human/proc/set_default_attack(var/datum/unarmed_attack/u_attack)
	default_attack = u_attack
