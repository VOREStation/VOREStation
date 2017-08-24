// Process the predator's effects upon the contents of its belly (i.e digestion/transformation etc)
// Called from /mob/living/Life() proc.
/datum/belly/proc/process_Life()

/////////////////////////// Auto-Emotes ///////////////////////////
	if((digest_mode in emote_lists) && !emotePend)
		emotePend = 1

		spawn(emoteTime)
			var/list/EL = emote_lists[digest_mode]
			for(var/mob/living/M in internal_contents)
				M << "<span class='notice'>[pick(EL)]</span>"
			src.emotePend = 0

//////////////////////// Absorbed Handling ////////////////////////
	for(var/mob/living/M in internal_contents)
		if(M.absorbed)
			M.Weaken(5)

///////////////////////////// DM_HOLD /////////////////////////////
	if(digest_mode == DM_HOLD)
		return //Pretty boring, huh

//////////////////////////// DM_DIGEST ////////////////////////////
	if(digest_mode == DM_DIGEST || digest_mode == DM_DIGEST_NUMB || digest_mode == DM_ITEMWEAK)
		var/list/touchable_items = internal_contents - items_preserved
		var/mob/living/silicon/robot/s_owner = null

		if(prob(50)) //Was SO OFTEN. AAAA.
			var/churnsound = pick(digestion_sounds)
			for(var/mob/hearer in range(1,owner))
				hearer << sound(churnsound,volume=80)

		for (var/mob/living/M in internal_contents)
			//Pref protection!
			if (!M.digestable || M.absorbed)
				continue

			//Person just died in guts!
			if(M.stat == DEAD)
				var/digest_alert_owner = pick(digest_messages_owner)
				var/digest_alert_prey = pick(digest_messages_prey)

				//Replace placeholder vars
				digest_alert_owner = replacetext(digest_alert_owner,"%pred",owner)
				digest_alert_owner = replacetext(digest_alert_owner,"%prey",M)
				digest_alert_owner = replacetext(digest_alert_owner,"%belly",lowertext(name))

				digest_alert_prey = replacetext(digest_alert_prey,"%pred",owner)
				digest_alert_prey = replacetext(digest_alert_prey,"%prey",M)
				digest_alert_prey = replacetext(digest_alert_prey,"%belly",lowertext(name))

				//Send messages
				owner << "<span class='notice'>" + digest_alert_owner + "</span>"
				M << "<span class='notice'>" + digest_alert_prey + "</span>"

				owner.nutrition += 20 // so eating dead mobs gives you *something*.
				if(isrobot(owner))
					s_owner = owner
					s_owner.cell.charge += 750
				var/deathsound = pick(death_sounds)
				for(var/mob/hearer in range(1,owner))
					hearer << deathsound
				digestion_death(M)
				owner.update_icons()
				continue

			if(digest_mode == DM_DIGEST_NUMB && ishuman(M))
				var/mob/living/carbon/human/H = M
				if(H.bloodstr.get_reagent_amount("numbenzyme") < 5)
					H.bloodstr.add_reagent("numbenzyme",10)

			// Deal digestion damage (and feed the pred)
			if(!(M.status_flags & GODMODE))
				M.adjustBruteLoss(digest_brute)
				M.adjustFireLoss(digest_burn)

				var/offset = (1 + ((M.weight - 137) / 137)) // 130 pounds = .95 140 pounds = 1.02
				var/difference = owner.size_multiplier / M.size_multiplier
				if(isrobot(owner))
					s_owner = owner
					s_owner.cell.charge += 100
				if(offset) // If any different than default weight, multiply the % of offset.
					owner.nutrition += offset*(10/difference) // 9.5 nutrition per digestion tick if they're 130 pounds and it's same size. 10.2 per digestion tick if they're 140 and it's same size. Etc etc.
				else
					owner.nutrition += (10/difference)
			M.updateVRPanel()

		if(digest_mode == DM_ITEMWEAK)
			var/obj/item/T = pick(touchable_items)
			if(istype(T, /obj/item))
				if(istype(T, /obj/item) && _is_digestable(T) && !(T in items_preserved))
					if(T in items_preserved)// Doublecheck just in case.
						return
					if(istype(T,/obj/item/weapon/card/id))// Mess up unprotected IDs
						var/obj/item/weapon/card/id/ID = T
						ID.desc = "A partially digested card that has seen better days.  Much of it's data has been destroyed."
						ID.icon = 'icons/obj/card_vr.dmi'
						ID.icon_state = "digested"
						ID.access = list() // No access
						items_preserved += ID
						return
					for(var/obj/item/SubItem in T)
						if(istype(SubItem,/obj/item/weapon/reagent_containers/food/snacks))
							var/obj/item/weapon/reagent_containers/food/snacks/SF = SubItem
							if(istype(owner,/mob/living/carbon/human))
								var/mob/living/carbon/human/howner = owner
								SF.reagents.trans_to_holder(howner.ingested, (SF.reagents.total_volume * 0.3), 1, 0)
							internal_contents -= SF
							qdel(SF)
						if(istype(SubItem,/obj/item/weapon/storage))
							for(var/obj/item/SubSubItem in SubItem)
								if(istype(SubSubItem,/obj/item/weapon/reagent_containers/food/snacks))
									var/obj/item/weapon/reagent_containers/food/snacks/SSF = SubSubItem
									if(istype(owner,/mob/living/carbon/human))
										var/mob/living/carbon/human/howner = owner
										SSF.reagents.trans_to_holder(howner.ingested, (SSF.reagents.total_volume * 0.3), 1, 0)
									internal_contents -= SSF
									qdel(SSF)
					if(istype(T, /obj/item/weapon/reagent_containers/food/snacks)) // Weakgurgles still act on foodstuff. Hopefully your prey didn't load their bag with donk boxes.
						var/obj/item/weapon/reagent_containers/food/snacks/F = T
						if(istype(owner,/mob/living/carbon/human))
							var/mob/living/carbon/human/howner = owner
							F.reagents.trans_to_holder(howner.reagents, (F.reagents.total_volume * 0.3), 1, 0)
						if(isrobot(owner))
							s_owner = owner
							s_owner.cell.charge += 150
						internal_contents -= F
						qdel(F)
					else
						items_preserved += T
						T.contaminate() // Someone got gurgled in this crap. You wouldn't wear/use it unwashed. :v
				else
					return
			return
		else
		// Handle leftovers.
			var/obj/item/T = pick(touchable_items)
			if(istype(T, /obj/item))
				if(istype(T, /obj/item) && _is_digestable(T) && !(T in items_preserved))
					if(T in items_preserved)// Doublecheck just in case.
						return
					if(istype(T, /obj/item/device/pda))
						var/obj/item/device/pda/PDA = T
						if(PDA.id)
							PDA.id.forceMove(owner)
							internal_contents += PDA.id
							PDA.id = null
						owner.nutrition += (2)
						if(isrobot(owner))
							s_owner = owner
							s_owner.cell.charge += 100
						internal_contents -= PDA
						qdel(PDA)
					for(var/obj/item/SubItem in T)
						if(istype(SubItem,/obj/item/weapon/storage/internal))
							var/obj/item/weapon/storage/internal/SI = SubItem
							for(var/obj/item/SubSubItem in SI)
								SubSubItem.forceMove(owner)
								internal_contents += SubSubItem
							qdel(SI)
						else
							SubItem.forceMove(owner)
							internal_contents += SubItem
					if(istype(T,/obj/item/weapon/card/id))// In case the ID didn't come from gurgle drop.
						var/obj/item/weapon/card/id/ID = T
						ID.desc = "A partially digested card that has seen better days.  Much of it's data has been destroyed."
						ID.icon = 'icons/obj/card_vr.dmi'
						ID.icon_state = "digested"
						ID.access = list() // No access
						items_preserved += ID
						return
					if(istype(T, /obj/item/weapon/reagent_containers/food/snacks)) // Food gets its own treatment now. Hopefully your prey didn't load their bag with donk boxes.
						var/obj/item/weapon/reagent_containers/food/snacks/F = T
						if(istype(owner,/mob/living/carbon/human))
							var/mob/living/carbon/human/howner = owner
							F.reagents.trans_to_holder(howner.ingested, (F.reagents.total_volume * 0.3), 1, 0)
						if(isrobot(owner))
							s_owner = owner
							s_owner.cell.charge += 150
						internal_contents -= F
						qdel(F)
					else
						owner.nutrition += (1 * T.w_class)
						if(isrobot(owner))
							s_owner = owner
							s_owner.cell.charge += (50 * T.w_class)
						internal_contents -= T
						qdel(T)
				else
					return

		owner.updateVRPanel()
		return

//////////////////////////// DM_STRIPDIGEST ////////////////////////////
	if(digest_mode == DM_STRIPDIGEST) // Only gurgle the gear off your prey.
		var/list/touchable_items = internal_contents - items_preserved
		var/mob/living/silicon/robot/s_owner = null

		if(prob(50))
			var/churnsound = pick(digestion_sounds)
			for(var/mob/hearer in range(1,owner))
				hearer << sound(churnsound,volume=80)

		// Handle loose items first.
		var/obj/item/T = pick(touchable_items)
		if(istype(T, /obj/item))
			if(istype(T, /obj/item) && _is_digestable(T) && !(T in items_preserved))
				if(T in items_preserved)// Doublecheck just in case.
					return
				if(istype(T, /obj/item/device/pda))
					var/obj/item/device/pda/PDA = T
					if(PDA.id)
						PDA.id.forceMove(owner)
						internal_contents += PDA.id
						PDA.id = null
					owner.nutrition += (2)
					if(isrobot(owner))
						s_owner = owner
						s_owner.cell.charge += (100)
					internal_contents -= PDA
					qdel(PDA)

				if(istype(T,/obj/item/weapon/card/id))
					var/obj/item/weapon/card/id/ID = T
					ID.desc = "A partially digested card that has seen better days.  Much of it's data has been destroyed."
					ID.icon = 'icons/obj/card_vr.dmi'
					ID.icon_state = "digested"
					ID.access = list() // No access
					items_preserved += ID
					return
				for(var/obj/item/SubItem in T)
					if(istype(SubItem,/obj/item/weapon/storage/internal))
						var/obj/item/weapon/storage/internal/SI = SubItem
						for(var/obj/item/SubSubItem in SI)
							SubSubItem.forceMove(owner)
							internal_contents += SubSubItem
						qdel(SI)
					else
						SubItem.forceMove(owner)
						internal_contents += SubItem
				if(istype(T, /obj/item/weapon/reagent_containers/food/snacks)) // Food gets its own treatment now. Hopefully your prey didn't load their bag with donk boxes.
					var/obj/item/weapon/reagent_containers/food/snacks/F = T
					if(istype(owner,/mob/living/carbon/human))
						var/mob/living/carbon/human/howner = owner
						F.reagents.trans_to_holder(howner.ingested, (F.reagents.total_volume * 0.3), 1, 0)
					if(isrobot(owner))
						s_owner = owner
						s_owner.cell.charge += (150)
					internal_contents -= F
					qdel(F)
				else
					owner.nutrition += (1 * T.w_class)
					if(isrobot(owner))
						s_owner = owner
						s_owner.cell.charge += (50 * T.w_class)
					internal_contents -= T
					qdel(T)
				for(var/mob/living/carbon/human/M in internal_contents)
					M.updateVRPanel()

		for(var/mob/living/carbon/human/M in internal_contents)
			if(!M)
				M = owner
			//Pref protection!
			if (!M.digestable || M.absorbed)
				continue
			if(length(slots - checked_slots) < 1)
				checked_slots.Cut()
			var/validslot = pick(slots - checked_slots)
			checked_slots += validslot // Avoid wasting cycles on already checked slots.
			var/obj/item/I = M.get_equipped_item(validslot)
			if(!I)
				return
			if(istype(I,/obj/item/weapon/card/id))
				var/obj/item/weapon/card/id/ID = I
				ID.desc = "A partially digested card that has seen better days.  Much of it's data has been destroyed."
				ID.icon = 'icons/obj/card_vr.dmi'
				ID.icon_state = "digested"
				ID.access = list() // No access
				M.remove_from_mob(ID,owner)
				internal_contents += ID
				items_preserved += ID
				return
			if(!_is_digestable(I))
				M.remove_from_mob(I,owner)
				items_preserved += I
				internal_contents += I
				return
			if(I == M.get_equipped_item(slot_w_uniform))
				var/list/stash = list(slot_r_store,slot_l_store,slot_wear_id,slot_belt)
				for(var/stashslot in stash)
					var/obj/item/SL = M.get_equipped_item(stashslot)
					if(SL)
						M.remove_from_mob(SL,owner)
						internal_contents += SL
				M.remove_from_mob(I,owner)
				internal_contents += I
				return
			else
				if(!(istype(I,/obj/item/organ) || istype(I,/obj/item/weapon/storage/internal) || istype(I,/obj/screen)))
					M.remove_from_mob(I,owner)
					internal_contents += I
			M.updateVRPanel()

		owner.updateVRPanel()
		return

//////////////////////////// DM_ABSORB ////////////////////////////
	if(digest_mode == DM_ABSORB)

		for (var/mob/living/M in internal_contents)

			if(prob(10)) //Less often than gurgles. People might leave this on forever.
				var/absorbsound = pick(digestion_sounds)
				M << sound(absorbsound,volume=80)
				owner << sound(absorbsound,volume=80)

			if(M.absorbed)
				continue

			if(M.nutrition >= 100) //Drain them until there's no nutrients left. Slowly "absorb" them.
				var/oldnutrition = (M.nutrition * 0.05)
				M.nutrition = (M.nutrition * 0.95)
				owner.nutrition += oldnutrition
			else if(M.nutrition < 100) //When they're finally drained.
				absorb_living(M)

		return



//////////////////////////// DM_UNABSORB ////////////////////////////
	if(digest_mode == DM_UNABSORB)

		for (var/mob/living/M in internal_contents)
			if(M.absorbed && owner.nutrition >= 100)
				M.absorbed = 0
				M << "<span class='notice'>You suddenly feel solid again </span>"
				owner << "<span class='notice'>You feel like a part of you is missing.</span>"
				owner.nutrition -= 100
		return


//////////////////////////// DM_DRAIN ////////////////////////////
	if(digest_mode == DM_DRAIN)

		for (var/mob/living/M in internal_contents)

			if(prob(10)) //Less often than gurgles. People might leave this on forever.
				var/drainsound = pick(digestion_sounds)
				M << sound(drainsound,volume=80)
				owner << sound(drainsound,volume=80)

			if(M.nutrition >= 100) //Drain them until there's no nutrients left.
				var/oldnutrition = (M.nutrition * 0.05)
				M.nutrition = (M.nutrition * 0.95)
				owner.nutrition += oldnutrition
				return
		return

///////////////////////////// DM_HEAL /////////////////////////////
	if(digest_mode == DM_HEAL)
		if(prob(50)) //Wet heals!
			var/healsound = pick(digestion_sounds)
			for(var/mob/hearer in range(1,owner))
				hearer << sound(healsound,volume=80)

		for (var/mob/living/M in internal_contents)
			if(M.stat != DEAD)
				if(owner.nutrition > 90 && (M.health < M.maxHealth))
					M.adjustBruteLoss(-5)
					M.adjustFireLoss(-5)
					owner.nutrition -= 2
					if(M.nutrition <= 400)
						M.nutrition += 1
		return

///////////////////////////// DM_TRANSFORM_HAIR_AND_EYES /////////////////////////////
	if(digest_mode == DM_TRANSFORM_HAIR_AND_EYES && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
			if(P.stat == DEAD)
				continue

			var/mob/living/carbon/human/O = owner

			if(O.nutrition > 400 && P.nutrition < 400)
				O.nutrition -= 2
				P.nutrition += 1.5

			if(check_eyes(P) || check_hair(P))
				change_eyes(P)
				change_hair(P,1)

		return
///////////////////////////// DM_TRANSFORM_MALE /////////////////////////////
	if(digest_mode == DM_TRANSFORM_MALE && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
			if(P.stat == DEAD)
				continue

			var/mob/living/carbon/human/O = owner

			if(O.nutrition > 400 && P.nutrition < 400)
				O.nutrition -= 2
				P.nutrition += 1.5

			if(check_eyes(P))
				change_eyes(P,1)
				continue

			if(check_hair(P) || check_skin(P))
				change_hair(P)
				change_skin(P,1)
				continue

			if(check_gender(P,MALE))
				change_gender(P,MALE,1)

		return


///////////////////////////// DM_TRANSFORM_FEMALE /////////////////////////////
	if(digest_mode == DM_TRANSFORM_FEMALE && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
			if(P.stat == DEAD)
				continue

			var/mob/living/carbon/human/O = owner

			if(O.nutrition > 400 && P.nutrition < 400)
				O.nutrition -= 2
				P.nutrition += 1.5

			if(check_eyes(P))
				change_eyes(P,1)
				continue

			if(check_hair(P) || check_skin(P))
				change_hair(P)
				change_skin(P,1)
				continue

			if(check_gender(P,FEMALE))
				change_gender(P,FEMALE,1)

		return

///////////////////////////// DM_TRANSFORM_KEEP_GENDER  /////////////////////////////
	if(digest_mode == DM_TRANSFORM_KEEP_GENDER && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
			if(P.stat == DEAD)
				continue

			var/mob/living/carbon/human/O = owner

			if(O.nutrition > 400 && P.nutrition < 400)
				O.nutrition -= 2
				P.nutrition += 1.5

			if(check_eyes(P))
				change_eyes(P,1)
				continue

			if(check_hair(P) || check_skin(P))
				change_hair(P)
				change_skin(P,1)

		return

///////////////////////////// DM_TRANSFORM_CHANGE_SPECIES_AND_TAUR  /////////////////////////////
	if(digest_mode == DM_TRANSFORM_CHANGE_SPECIES_AND_TAUR && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
			if(P.stat == DEAD)
				continue

			var/mob/living/carbon/human/O = owner

			if(O.nutrition > 400 && P.nutrition < 400)
				O.nutrition -= 2
				P.nutrition += 1.5

			if(check_ears(P) || check_tail_nocolor(P) || check_wing_nocolor(P) || check_species(P))
				change_ears(P)
				change_tail_nocolor(P)
				change_wing_nocolor(P)
				change_species(P,1)

		return

///////////////////////////// DM_TRANSFORM_REPLICA /////////////////////////////
	if(digest_mode == DM_TRANSFORM_REPLICA && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
			if(P.stat == DEAD)
				continue

			var/mob/living/carbon/human/O = owner

			if(O.nutrition > 400 && P.nutrition < 400)
				O.nutrition -= 2
				P.nutrition += 1.5

			if(check_eyes(P))
				change_eyes(P,1)
				continue

			if(check_hair(P) || check_skin(P))
				change_hair(P)
				change_skin(P,1)
				continue

			if(check_ears(P) || check_tail(P) || check_wing(P) || check_species(P))
				change_ears(P)
				change_tail(P)
				change_wing(P)
				change_species(P,1)

		return

///////////////////////////// DM_TRANSFORM_CHANGE_SPECIES_AND_TAUR_EGG /////////////////////////////
	if(digest_mode == DM_TRANSFORM_CHANGE_SPECIES_AND_TAUR_EGG && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
			if(P.stat == DEAD)
				continue

			if(check_ears(P) || check_tail_nocolor(P) || check_wing_nocolor(P)|| check_species(P))
				change_ears(P)
				change_tail_nocolor(P)
				change_wing_nocolor(P)
				change_species(P,1)
				continue

			if(!P.absorbed)
				put_in_egg(P,1)

		return

///////////////////////////// DM_TRANSFORM_KEEP_GENDER_EGG  /////////////////////////////
	if(digest_mode == DM_TRANSFORM_KEEP_GENDER_EGG && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
			if(P.stat == DEAD)
				continue

			if(check_eyes(P))
				change_eyes(P,1)
				continue

			if(check_hair(P) || check_skin(P))
				change_hair(P)
				change_skin(P,1)
				continue

			if(!P.absorbed)
				put_in_egg(P,1)

		return

///////////////////////////// DM_TRANSFORM_REPLICA_EGG /////////////////////////////
	if(digest_mode == DM_TRANSFORM_REPLICA_EGG && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
			if(P.stat == DEAD)
				continue

			if(check_eyes(P))
				change_eyes(P,1)
				continue

			if(check_hair(P) || check_skin(P))
				change_hair(P)
				change_skin(P,1)
				continue

			if(check_ears(P) || check_tail(P) || check_wing(P) || check_species(P))
				change_ears(P)
				change_tail(P)
				change_wing(P)
				change_species(P,1)
				continue

			if(!P.absorbed)
				put_in_egg(P,1)

		return

///////////////////////////// DM_TRANSFORM_MALE_EGG /////////////////////////////
	if(digest_mode == DM_TRANSFORM_MALE_EGG && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
			if(P.stat == DEAD)
				continue

			if(check_eyes(P))
				change_eyes(P,1)
				continue

			if(check_hair(P) || check_skin(P))
				change_hair(P)
				change_skin(P,1)
				continue

			if(check_gender(P,MALE))
				change_gender(P,MALE,1)
				continue

			if(!P.absorbed)
				put_in_egg(P,1)

		return

///////////////////////////// DM_TRANSFORM_FEMALE_EGG /////////////////////////////
	if(digest_mode == DM_TRANSFORM_FEMALE_EGG && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
			if(P.stat == DEAD)
				continue

			if(check_eyes(P))
				change_eyes(P,1)
				continue

			if(check_hair(P) || check_skin(P))
				change_hair(P)
				change_skin(P,1)
				continue

			if(check_gender(P,MALE))
				change_gender(P,MALE,1)
				continue

			if(!P.absorbed)
				put_in_egg(P,1)

		return


///////////////////////////// DM_EGG /////////////////////////////
	if(digest_mode == DM_EGG && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
			if(P.absorbed || P.stat == DEAD)
				continue

			put_in_egg(P,1)