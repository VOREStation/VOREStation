/obj/item/stack/medical
	name = "medical pack"
	singular_name = "medical pack"
	icon = 'icons/obj/stacks.dmi'
	amount = 10
	max_amount = 10
	w_class = ITEMSIZE_SMALL
	throw_speed = 4
	throw_range = 20
	var/heal_brute = 0
	var/heal_burn = 0
	var/apply_sounds
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'

	var/upgrade_to	// The type path this stack can be upgraded to.

/obj/item/stack/medical/attack(mob/living/carbon/M as mob, mob/user as mob)
	if (!istype(M))
		balloon_alert(user, "\the [src] cannot be applied to [M]!")
		return 1

	if (!user.IsAdvancedToolUser())
		balloon_alert(user, "you don't have the dexterity to do this!")
		return 1

	var/available = get_amount()
	if(!available)
		balloon_alert(user, "not enough [uses_charge ? "charge" : "items"] left to use that!")
		return 1

	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(!affecting)
			balloon_alert(user, "no body part there to work on!")
			return 1

		if(affecting.organ_tag == BP_HEAD)
			if(H.head && istype(H.head,/obj/item/clothing/head/helmet/space))
				balloon_alert(user, "you can't apply [src] through [H.head]!")
				return 1
		else
			if(H.wear_suit && istype(H.wear_suit,/obj/item/clothing/suit/space))
				balloon_alert(user, "you can't apply [src] through [H.wear_suit]!")
				return 1

		if(affecting.robotic == ORGAN_ROBOT)
			balloon_alert(user, "this isn't useful at all on a robotic limb.")
			return 1

		if(affecting.robotic >= ORGAN_LIFELIKE)
			balloon_alert(user, "you apply the [src], but it seems to have no effect...")
			use(1)
			return 1

		H.UpdateDamageIcon()

	else

		M.heal_organ_damage((src.heal_brute/2), (src.heal_burn/2))
		user.balloon_alert_visible( \
			"[M] has been applied with [src] by [user].", \
			"you apply \the [src] to [M]." \
		)
		use(1)

	M.updatehealth()

/obj/item/stack/medical/proc/upgrade_stack(var/upgrade_amount)
	. = FALSE

	var/turf/T = get_turf(src)

	if(ispath(upgrade_to) && use(upgrade_amount))
		var/obj/item/stack/medical/M = new upgrade_to(T, upgrade_amount)
		return M

	return .

/obj/item/stack/medical/crude_pack
	name = "crude bandage"
	singular_name = "crude bandage length"
	desc = "Some bandages to wrap around bloody stumps."
	icon_state = "gauze"
	origin_tech = list(TECH_BIO = 1)
	no_variants = FALSE
	apply_sounds = list('sound/effects/rip1.ogg','sound/effects/rip2.ogg')

	upgrade_to = /obj/item/stack/medical/bruise_pack

/obj/item/stack/medical/crude_pack/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1

	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(affecting.open)
			balloon_alert(user, "the [affecting.name] is cut open!")
			return

		if(affecting.is_bandaged())
			balloon_alert(user, "[M]'s [affecting.name] is already bandaged.")
			return 1
		else
			var/available = get_amount()
			user.balloon_alert_visible("\the [user] starts bandaging [M]'s [affecting.name].", \
											"bandaging [M]'s [affecting.name]." )
			var/used = 0
			for (var/datum/wound/W in affecting.wounds)
				if(W.internal)
					continue
				if(W.bandaged)
					continue
				if(used == amount)
					break
				if(!do_mob(user, M, W.damage/3, exclusive = TRUE))
					balloon_alert(user, "stand still to bandage wounds.")
					break

				if(affecting.is_bandaged()) // We do a second check after the delay, in case it was bandaged after the first check.
					balloon_alert(user, "[M]'s [affecting.name] is already bandaged.")
					return 1

				if(used >= available)
					balloon_alert(user, "you run out of [src]!")
					break

				if (W.current_stage <= W.max_bleeding_stage)
					user.balloon_alert_visible("\the [user] bandages \a [W.desc] on [M]'s [affecting.name].", \
												"you bandage \a [W.desc] on [M]'s [affecting.name]." )
				else
					user.balloon_alert_visible("\the [user] places a bandage over \a [W.desc] on [M]'s [affecting.name].", \
												"you place a bandage over \a [W.desc] on [M]'s [affecting.name]." )
				W.bandage()
				playsound(src, pick(apply_sounds), 25)
				used++
			affecting.update_damages()
			if(used == amount)
				if(affecting.is_bandaged())
					balloon_alert(user, "\the [src] is used up.")
				else
					balloon_alert(user, "\the [src] is used up, but there are more wounds to treat on \the [affecting.name].")
			use(used)

/obj/item/stack/medical/bruise_pack
	name = "roll of gauze"
	singular_name = "gauze length"
	desc = "Some sterile gauze to wrap around bloody stumps."
	icon_state = "brutepack"
	origin_tech = list(TECH_BIO = 1)
	no_variants = FALSE
	apply_sounds = list('sound/effects/rip1.ogg','sound/effects/rip2.ogg')
	drop_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'

	upgrade_to = /obj/item/stack/medical/advanced/bruise_pack

/obj/item/stack/medical/bruise_pack/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1

	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(affecting.open)
			balloon_alert(user, "the [affecting.name] is cut open!")
			return

		if(affecting.is_bandaged())
			balloon_alert(user, "[M]'s [affecting.name] is already bandaged.")
			return 1
		else
			var/available = get_amount()
			user.balloon_alert_visible("\the [user] starts treating [M]'s [affecting.name].", \
										"treating [M]'s [affecting.name]." )
			var/used = 0
			for (var/datum/wound/W in affecting.wounds)
				if (W.internal)
					continue
				if(W.bandaged)
					continue
				if(used == amount)
					break
				if(!do_mob(user, M, W.damage/5, exclusive = TRUE))
					balloon_alert(user, "stand still to bandage wounds.")
					break

				if(affecting.is_bandaged()) // We do a second check after the delay, in case it was bandaged after the first check.
					balloon_alert(user, "[M]'s [affecting.name] is already bandaged.")
					return 1

				if(used >= available)
					balloon_alert(user, "you run out of [src]!")
					break

				if (W.current_stage <= W.max_bleeding_stage)
					user.balloon_alert_visible("\the [user] bandages \a [W.desc] on [M]'s [affecting.name].", \
												"bandaged \a [W.desc] on [M]'s [affecting.name]." )
					//H.add_side_effect("Itch")
				else if (W.damage_type == BRUISE)
					user.balloon_alert_visible("\the [user] places a bruise patch over \a [W.desc] on [M]'s [affecting.name].", \
												"placed bruise patch over \a [W.desc] on [M]'s [affecting.name]." )
				else
					user.balloon_alert_visible("\the [user] places a bandaid over \a [W.desc] on [M]'s [affecting.name].", \
												"placed bandaid over \a [W.desc] on [M]'s [affecting.name]." )
				W.bandage()
				// W.disinfect() // Tech1 should not disinfect
				playsound(src, pick(apply_sounds), 25)
				used++
			affecting.update_damages()
			if(used == amount)
				if(affecting.is_bandaged())
					balloon_alert(user, "\the [src] is used up.")
				else
					balloon_alert(user, "\the [src] is used up, but there are more wounds to treat on \the [affecting.name].")
			use(used)

/obj/item/stack/medical/ointment
	name = "ointment"
	desc = "Used to treat those nasty burns."
	gender = PLURAL
	singular_name = "ointment"
	icon_state = "ointment"
	heal_burn = 1
	origin_tech = list(TECH_BIO = 1)
	no_variants = FALSE
	apply_sounds = list('sound/effects/ointment.ogg')
	drop_sound = 'sound/items/drop/herb.ogg'
	pickup_sound = 'sound/items/pickup/herb.ogg'

/obj/item/stack/medical/ointment/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1

	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(affecting.open)
			balloon_alert(user, "the [affecting.name] is cut open!")
			return

		if(affecting.is_salved())
			balloon_alert(user, "the wounds on [M]'s [affecting.name] have already been salved.")
			return 1
		else
			user.balloon_alert_visible("\the [user] starts salving wounds on [M]'s [affecting.name].", \
										"salving the wounds on [M]'s [affecting.name]." )
			if(!do_mob(user, M, 10, exclusive = TRUE))
				balloon_alert(user, "stand still to salve wounds.")
				return 1
			if(affecting.is_salved()) // We do a second check after the delay, in case it was bandaged after the first check.
				balloon_alert(user, "[M]'s [affecting.name] have already been salved.")
				return 1
			user.balloon_alert_visible("[user] salved wounds on [M]'s [affecting.name].", \
										"salved wounds on [M]'s [affecting.name]." )
			use(1)
			affecting.salve()
			playsound(src, pick(apply_sounds), 25)

/obj/item/stack/medical/ointment/simple
	name = "ointment paste"
	desc = "A simple thick paste used to salve burns."
	singular_name = "old-ointment"
	icon_state = "old-ointment"

/obj/item/stack/medical/advanced/bruise_pack
	name = "advanced trauma kit"
	singular_name = "advanced trauma kit"
	desc = "An advanced trauma kit for severe injuries."
	icon_state = "traumakit"
	heal_brute = 7
	origin_tech = list(TECH_BIO = 1)
	apply_sounds = list('sound/effects/rip1.ogg','sound/effects/rip2.ogg','sound/effects/tape.ogg')

/obj/item/stack/medical/advanced/bruise_pack/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1

	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(affecting.open)
			balloon_alert(user, "the [affecting.name] is cut open!")
			return

		if(affecting.is_bandaged() && affecting.is_disinfected())
			balloon_alert(user, "[M]'s [affecting.name] have already been treated.")
			return 1
		else
			var/available = get_amount()
			user.balloon_alert_visible("\the [user] starts treating [M]'s [affecting.name].", \
										"treating [M]'s [affecting.name]." )
			var/used = 0
			for (var/datum/wound/W in affecting.wounds)
				if (W.internal)
					continue
				if (W.bandaged && W.disinfected)
					continue
				//if(used == amount)
				//	break
				if(!do_mob(user, M, W.damage/5, exclusive = TRUE))
					balloon_alert(user, "stand still to bandage wounds.")
					break
				if(affecting.is_bandaged() && affecting.is_disinfected()) // We do a second check after the delay, in case it was bandaged after the first check.
					balloon_alert(user, "[M]'s [affecting.name] is already bandaged.")
					return 1

				if(used >= available)
					balloon_alert(user, "you run out of [src]!")
					break

				if (W.current_stage <= W.max_bleeding_stage)
					user.balloon_alert_visible("\the [user] cleans \a [W.desc] on [M]'s [affecting.name] and seals the edges with bioglue.", \
												"cleaning and sealing \a [W.desc] on [M]'s [affecting.name]." )
				else if (W.damage_type == BRUISE)
					user.balloon_alert_visible("\the [user] places a medical patch over \a [W.desc] on [M]'s [affecting.name].", \
												"placed medical patch over \a [W.desc] on [M]'s [affecting.name]." )
				else
					user.balloon_alert_visible("\the [user] smears some bioglue over \a [W.desc] on [M]'s [affecting.name].", \
												"smeared bioglue over \a [W.desc] on [M]'s [affecting.name]." )
				W.bandage()
				W.disinfect()
				W.heal_damage(heal_brute)
				playsound(src, pick(apply_sounds), 25)
				used = 1
				update_icon()
			affecting.update_damages()
			if(used == amount)
				if(affecting.is_bandaged())
					balloon_alert(user, "\the [src] is used up.")
				else
					balloon_alert(user, "\the [src] is used up, but there are more wounds to treat on \the [affecting.name].")
			use(used)

/obj/item/stack/medical/advanced/ointment
	name = "advanced burn kit"
	singular_name = "advanced burn kit"
	desc = "An advanced treatment kit for severe burns."
	icon_state = "burnkit"
	heal_burn = 7
	origin_tech = list(TECH_BIO = 1)
	apply_sounds = list('sound/effects/ointment.ogg')

/obj/item/stack/medical/advanced/ointment/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1

	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(affecting.open)
			balloon_alert(user, "the [affecting.name] is cut open!")

		if(affecting.is_salved())
			balloon_alert(user, "[M]'s [affecting.name] has already been salved.")
			return 1
		else
			user.balloon_alert_visible("\the [user] starts salving wounds on [M]'s [affecting.name].", \
										"salving the wounds on [M]'s [affecting.name]." )
			if(!do_mob(user, M, 10, exclusive = TRUE))
				balloon_alert(user, "stand still to salve wounds.")
				return 1
			if(affecting.is_salved()) // We do a second check after the delay, in case it was bandaged after the first check.
				balloon_alert(user, "[M]'s [affecting.name] have already been salved.")
				return 1
			user.balloon_alert_visible("[user] covers wounds on [M]'s [affecting.name] with regenerative membrane.", \
									"covered wounds on [M]'s [affecting.name] with regenerative membrane." )
			affecting.heal_damage(0,heal_burn)
			use(1)
			affecting.salve()
			playsound(src, pick(apply_sounds), 25)
			update_icon()

/obj/item/stack/medical/splint
	name = "medical splints"
	singular_name = "medical splint"
	desc = "Modular splints capable of supporting and immobilizing bones in all areas of the body."
	icon_state = "splint"
	amount = 5
	max_amount = 5
	drop_sound = 'sound/items/drop/hat.ogg'
	pickup_sound = 'sound/items/pickup/hat.ogg'

	var/list/splintable_organs = list(BP_HEAD, BP_L_HAND, BP_R_HAND, BP_L_ARM, BP_R_ARM, BP_L_FOOT, BP_R_FOOT, BP_L_LEG, BP_R_LEG, BP_GROIN, BP_TORSO)	//List of organs you can splint, natch.

/obj/item/stack/medical/splint/attack(mob/living/carbon/M as mob, mob/living/user as mob)
	if(..())
		return 1

	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)
		var/limb = affecting.name
		if(!(affecting.organ_tag in splintable_organs))
			balloon_alert(user, "you can't use \the [src] to apply a splint there!")
			return
		if(affecting.splinted)
			balloon_alert(user, "[M]'s [limb] is already splinted!")
			return
		if (M != user)
			user.balloon_alert_visible("[user] starts to apply \the [src] to [M]'s [limb].", "applying \the [src] to [M]'s [limb].", "You hear something being wrapped.")
		else
			if(( !user.hand && (affecting.organ_tag in list(BP_R_ARM, BP_R_HAND)) || \
				user.hand && (affecting.organ_tag in list(BP_L_ARM, BP_L_HAND)) ))
				balloon_alert(user, "you can't apply a splint to the arm you're using!")
				return
			user.balloon_alert_visible("[user] starts to apply \the [src] to their [limb].", "applying \the [src] to your [limb].", "You hear something being wrapped.")
		if(do_after(user, 50, M, exclusive = TASK_USER_EXCLUSIVE))
			if(affecting.splinted)
				balloon_alert(user, "[M]'s [limb] is already splinted!")
				return
			if(M == user && prob(75))
				user.balloon_alert_visible("\the [user] fumbles [src].", "fumbling [src].", "You hear something being wrapped.")
				return
			if(ishuman(user))
				var/obj/item/stack/medical/splint/S = split(1)
				if(S)
					if(affecting.apply_splint(S))
						S.forceMove(affecting)
						if (M != user)
							user.balloon_alert_visible("\the [user] finishes applying [src] to [M]'s [limb].", "finished applying \the [src] to [M]'s [limb].", "You hear something being wrapped.")
						else
							user.balloon_alert_visible("\the [user] successfully applies [src] to their [limb].", "successfully applied \the [src] to your [limb].", "You hear something being wrapped.")
						return
					S.dropInto(src.loc) //didn't get applied, so just drop it
			if(isrobot(user))
				var/obj/item/stack/medical/splint/B = src
				if(B)
					if(affecting.apply_splint(B))
						B.forceMove(affecting)
						user.balloon_alert_visible("\the [user] finishes applying [src] to [M]'s [limb].", "finish applying \the [src] to [M]'s [limb].", "You hear something being wrapped.")
						B.use(1)
						return
			user.balloon_alert_visible("\the [user] fails to apply [src].", "failed to apply [src].", "You hear something being wrapped.")
		return


/obj/item/stack/medical/splint/ghetto
	name = "makeshift splints"
	singular_name = "makeshift splint"
	desc = "For holding your limbs in place with duct tape and scrap metal."
	icon_state = "tape-splint"
	amount = 1
	splintable_organs = list(BP_L_ARM, BP_R_ARM, BP_L_LEG, BP_R_LEG)
