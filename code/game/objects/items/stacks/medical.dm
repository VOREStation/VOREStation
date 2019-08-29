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

/obj/item/stack/medical/attack(mob/living/carbon/M as mob, mob/user as mob)
	if (!istype(M))
		user << "<span class='warning'>\The [src] cannot be applied to [M]!</span>"
		return 1

	if ( ! (istype(user, /mob/living/carbon/human) || \
			istype(user, /mob/living/silicon)) )
		user << "<span class='warning'>You don't have the dexterity to do this!</span>"
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(!affecting)
			user << "<span class='warning'>No body part there to work on!</span>"
			return 1

		if(affecting.organ_tag == BP_HEAD)
			if(H.head && istype(H.head,/obj/item/clothing/head/helmet/space))
				user << "<span class='warning'>You can't apply [src] through [H.head]!</span>"
				return 1
		else
			if(H.wear_suit && istype(H.wear_suit,/obj/item/clothing/suit/space))
				user << "<span class='warning'>You can't apply [src] through [H.wear_suit]!</span>"
				return 1

		if(affecting.robotic == ORGAN_ROBOT)
			user << "<span class='warning'>This isn't useful at all on a robotic limb.</span>"
			return 1

		if(affecting.robotic >= ORGAN_LIFELIKE)
			user << "<span class='warning'>You apply the [src], but it seems to have no effect...</span>"
			use(1)
			return 1

		H.UpdateDamageIcon()

	else

		M.heal_organ_damage((src.heal_brute/2), (src.heal_burn/2))
		user.visible_message( \
			"<span class='notice'>[M] has been applied with [src] by [user].</span>", \
			"<span class='notice'>You apply \the [src] to [M].</span>" \
		)
		use(1)

	M.updatehealth()
/obj/item/stack/medical/bruise_pack
	name = "roll of gauze"
	singular_name = "gauze length"
	desc = "Some sterile gauze to wrap around bloody stumps."
	icon_state = "brutepack"
	origin_tech = list(TECH_BIO = 1)
	no_variants = FALSE
	apply_sounds = list('sound/effects/rip1.ogg','sound/effects/rip2.ogg')

/obj/item/stack/medical/bruise_pack/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(affecting.open)
			to_chat(user, "<span class='notice'>The [affecting.name] is cut open, you'll need more than a bandage!</span>")
			return

		if(affecting.is_bandaged())
			to_chat(user, "<span class='warning'>The wounds on [M]'s [affecting.name] have already been bandaged.</span>")
			return 1
		else
			user.visible_message("<span class='notice'>\The [user] starts treating [M]'s [affecting.name].</span>", \
					             "<span class='notice'>You start treating [M]'s [affecting.name].</span>" )
			var/used = 0
			for (var/datum/wound/W in affecting.wounds)
				if (W.internal)
					continue
				if(W.bandaged)
					continue
				if(used == amount)
					break
				if(!do_mob(user, M, W.damage/5))
					to_chat(user, "<span class='notice'>You must stand still to bandage wounds.</span>")
					break

				if(affecting.is_bandaged()) // We do a second check after the delay, in case it was bandaged after the first check.
					to_chat(user, "<span class='warning'>The wounds on [M]'s [affecting.name] have already been bandaged.</span>")
					return 1

				if (W.current_stage <= W.max_bleeding_stage)
					user.visible_message("<span class='notice'>\The [user] bandages \a [W.desc] on [M]'s [affecting.name].</span>", \
					                              "<span class='notice'>You bandage \a [W.desc] on [M]'s [affecting.name].</span>" )
					//H.add_side_effect("Itch")
				else if (W.damage_type == BRUISE)
					user.visible_message("<span class='notice'>\The [user] places a bruise patch over \a [W.desc] on [M]'s [affecting.name].</span>", \
					                              "<span class='notice'>You place a bruise patch over \a [W.desc] on [M]'s [affecting.name].</span>" )
				else
					user.visible_message("<span class='notice'>\The [user] places a bandaid over \a [W.desc] on [M]'s [affecting.name].</span>", \
					                              "<span class='notice'>You place a bandaid over \a [W.desc] on [M]'s [affecting.name].</span>" )
				W.bandage()
				// W.disinfect() // VOREStation - Tech1 should not disinfect
				playsound(src, pick(apply_sounds), 25)
				used++
			affecting.update_damages()
			if(used == amount)
				if(affecting.is_bandaged())
					to_chat(user, "<span class='warning'>\The [src] is used up.</span>")
				else
					to_chat(user, "<span class='warning'>\The [src] is used up, but there are more wounds to treat on \the [affecting.name].</span>")
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

/obj/item/stack/medical/ointment/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(affecting.open)
			to_chat(user, "<span class='notice'>The [affecting.name] is cut open, you'll need more than a bandage!</span>")
			return

		if(affecting.is_salved())
			to_chat(user, "<span class='warning'>The wounds on [M]'s [affecting.name] have already been salved.</span>")
			return 1
		else
			user.visible_message("<span class='notice'>\The [user] starts salving wounds on [M]'s [affecting.name].</span>", \
					             "<span class='notice'>You start salving the wounds on [M]'s [affecting.name].</span>" )
			if(!do_mob(user, M, 10))
				to_chat(user, "<span class='notice'>You must stand still to salve wounds.</span>")
				return 1
			if(affecting.is_salved()) // We do a second check after the delay, in case it was bandaged after the first check.
				to_chat(user, "<span class='warning'>The wounds on [M]'s [affecting.name] have already been salved.</span>")
				return 1
			user.visible_message("<span class='notice'>[user] salved wounds on [M]'s [affecting.name].</span>", \
			                         "<span class='notice'>You salved wounds on [M]'s [affecting.name].</span>" )
			use(1)
			affecting.salve()
			playsound(src, pick(apply_sounds), 25)

/obj/item/stack/medical/advanced/bruise_pack
	name = "advanced trauma kit"
	singular_name = "advanced trauma kit"
	desc = "An advanced trauma kit for severe injuries."
	icon_state = "traumakit"
	heal_brute = 7 //VOREStation Edit
	origin_tech = list(TECH_BIO = 1)
	apply_sounds = list('sound/effects/rip1.ogg','sound/effects/rip2.ogg','sound/effects/tape.ogg')

/obj/item/stack/medical/advanced/bruise_pack/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(affecting.open)
			to_chat(user, "<span class='notice'>The [affecting.name] is cut open, you'll need more than a bandage!</span>")
			return

		if(affecting.is_bandaged() && affecting.is_disinfected())
			to_chat(user, "<span class='warning'>The wounds on [M]'s [affecting.name] have already been treated.</span>")
			return 1
		else
			user.visible_message("<span class='notice'>\The [user] starts treating [M]'s [affecting.name].</span>", \
					             "<span class='notice'>You start treating [M]'s [affecting.name].</span>" )
			var/used = 0
			for (var/datum/wound/W in affecting.wounds)
				if (W.internal)
					continue
				if (W.bandaged && W.disinfected)
					continue
				//if(used == amount) //VOREStation Edit
				//	break //VOREStation Edit
				if(!do_mob(user, M, W.damage/5))
					to_chat(user, "<span class='notice'>You must stand still to bandage wounds.</span>")
					break
				if(affecting.is_bandaged() && affecting.is_disinfected()) // We do a second check after the delay, in case it was bandaged after the first check.
					to_chat(user, "<span class='warning'>The wounds on [M]'s [affecting.name] have already been bandaged.</span>")
					return 1
				if (W.current_stage <= W.max_bleeding_stage)
					user.visible_message("<span class='notice'>\The [user] cleans \a [W.desc] on [M]'s [affecting.name] and seals the edges with bioglue.</span>", \
					                     "<span class='notice'>You clean and seal \a [W.desc] on [M]'s [affecting.name].</span>" )
				else if (W.damage_type == BRUISE)
					user.visible_message("<span class='notice'>\The [user] places a medical patch over \a [W.desc] on [M]'s [affecting.name].</span>", \
					                              "<span class='notice'>You place a medical patch over \a [W.desc] on [M]'s [affecting.name].</span>" )
				else
					user.visible_message("<span class='notice'>\The [user] smears some bioglue over \a [W.desc] on [M]'s [affecting.name].</span>", \
					                              "<span class='notice'>You smear some bioglue over \a [W.desc] on [M]'s [affecting.name].</span>" )
				W.bandage()
				W.disinfect()
				W.heal_damage(heal_brute)
				playsound(src, pick(apply_sounds), 25)
				used = 1 //VOREStation Edit
				update_icon() // VOREStation Edit - Support for stack icons
			affecting.update_damages()
			if(used == amount)
				if(affecting.is_bandaged())
					to_chat(user, "<span class='warning'>\The [src] is used up.</span>")
				else
					to_chat(user, "<span class='warning'>\The [src] is used up, but there are more wounds to treat on \the [affecting.name].</span>")
			use(used)

/obj/item/stack/medical/advanced/ointment
	name = "advanced burn kit"
	singular_name = "advanced burn kit"
	desc = "An advanced treatment kit for severe burns."
	icon_state = "burnkit"
	heal_burn = 7 //VOREStation Edit
	origin_tech = list(TECH_BIO = 1)
	apply_sounds = list('sound/effects/ointment.ogg')

/obj/item/stack/medical/advanced/ointment/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(affecting.open)
			to_chat(user, "<span class='notice'>The [affecting.name] is cut open, you'll need more than a bandage!</span>")

		if(affecting.is_salved())
			to_chat(user, "<span class='warning'>The wounds on [M]'s [affecting.name] have already been salved.</span>")
			return 1
		else
			user.visible_message("<span class='notice'>\The [user] starts salving wounds on [M]'s [affecting.name].</span>", \
					             "<span class='notice'>You start salving the wounds on [M]'s [affecting.name].</span>" )
			if(!do_mob(user, M, 10))
				to_chat(user, "<span class='notice'>You must stand still to salve wounds.</span>")
				return 1
			if(affecting.is_salved()) // We do a second check after the delay, in case it was bandaged after the first check.
				to_chat(user, "<span class='warning'>The wounds on [M]'s [affecting.name] have already been salved.</span>")
				return 1
			user.visible_message( 	"<span class='notice'>[user] covers wounds on [M]'s [affecting.name] with regenerative membrane.</span>", \
									"<span class='notice'>You cover wounds on [M]'s [affecting.name] with regenerative membrane.</span>" )
			affecting.heal_damage(0,heal_burn)
			use(1)
			affecting.salve()
			playsound(src, pick(apply_sounds), 25)
			update_icon() // VOREStation Edit - Support for stack icons

/obj/item/stack/medical/splint
	name = "medical splints"
	singular_name = "medical splint"
	desc = "Modular splints capable of supporting and immobilizing bones in all areas of the body."
	icon_state = "splint"
	amount = 5
	max_amount = 5

	var/list/splintable_organs = list(BP_HEAD, BP_L_HAND, BP_R_HAND, BP_L_ARM, BP_R_ARM, BP_L_FOOT, BP_R_FOOT, BP_L_LEG, BP_R_LEG, BP_GROIN, BP_TORSO)	//List of organs you can splint, natch.

/obj/item/stack/medical/splint/attack(mob/living/carbon/M as mob, mob/living/user as mob)
	if(..())
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)
		var/limb = affecting.name
		if(!(affecting.organ_tag in splintable_organs))
			to_chat(user, "<span class='danger'>You can't use \the [src] to apply a splint there!</span>")
			return
		if(affecting.splinted)
			to_chat(user, "<span class='danger'>[M]'s [limb] is already splinted!</span>")
			return
		if (M != user)
			user.visible_message("<span class='danger'>[user] starts to apply \the [src] to [M]'s [limb].</span>", "<span class='danger'>You start to apply \the [src] to [M]'s [limb].</span>", "<span class='danger'>You hear something being wrapped.</span>")
		else
			if(( !user.hand && (affecting.organ_tag in list(BP_R_ARM, BP_R_HAND)) || \
				user.hand && (affecting.organ_tag in list(BP_L_ARM, BP_L_HAND)) ))
				to_chat(user, "<span class='danger'>You can't apply a splint to the arm you're using!</span>")
				return
			user.visible_message("<span class='danger'>[user] starts to apply \the [src] to their [limb].</span>", "<span class='danger'>You start to apply \the [src] to your [limb].</span>", "<span class='danger'>You hear something being wrapped.</span>")
		if(do_after(user, 50, M))
			if(affecting.splinted)
				to_chat(user, "<span class='danger'>[M]'s [limb] is already splinted!</span>")
				return
			if(M == user && prob(75))
				user.visible_message("<span class='danger'>\The [user] fumbles [src].</span>", "<span class='danger'>You fumble [src].</span>", "<span class='danger'>You hear something being wrapped.</span>")
				return
			if(ishuman(user))
				var/obj/item/stack/medical/splint/S = split(1)
				if(S)
					if(affecting.apply_splint(S))
						S.forceMove(affecting)
						if (M != user)
							user.visible_message("<span class='danger'>\The [user] finishes applying [src] to [M]'s [limb].</span>", "<span class='danger'>You finish applying \the [src] to [M]'s [limb].</span>", "<span class='danger'>You hear something being wrapped.</span>")
						else
							user.visible_message("<span class='danger'>\The [user] successfully applies [src] to their [limb].</span>", "<span class='danger'>You successfully apply \the [src] to your [limb].</span>", "<span class='danger'>You hear something being wrapped.</span>")
						return
					S.dropInto(src.loc) //didn't get applied, so just drop it
			if(isrobot(user))
				var/obj/item/stack/medical/splint/B = src
				if(B)
					if(affecting.apply_splint(B))
						B.forceMove(affecting)
						user.visible_message("<span class='danger'>\The [user] finishes applying [src] to [M]'s [limb].</span>", "<span class='danger'>You finish applying \the [src] to [M]'s [limb].</span>", "<span class='danger'>You hear something being wrapped.</span>")
						B.use(1)
						return
			user.visible_message("<span class='danger'>\The [user] fails to apply [src].</span>", "<span class='danger'>You fail to apply [src].</span>", "<span class='danger'>You hear something being wrapped.</span>")
		return


/obj/item/stack/medical/splint/ghetto
	name = "makeshift splints"
	singular_name = "makeshift splint"
	desc = "For holding your limbs in place with duct tape and scrap metal."
	icon_state = "tape-splint"
	amount = 1
	splintable_organs = list(BP_L_ARM, BP_R_ARM, BP_L_LEG, BP_R_LEG)
