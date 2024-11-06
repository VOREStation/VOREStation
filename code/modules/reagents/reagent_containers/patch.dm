
/*
 * Patches. A subtype of pills, in order to inherit the possible future produceability within chem-masters, and dissolving.
 */

/obj/item/reagent_containers/pill/patch
	name = "patch"
	desc = "A patch."
	icon = 'icons/obj/chemical.dmi'
	icon_state = null
	item_state = "pill"

	base_state = "patch"

	possible_transfer_amounts = null
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	volume = 60

	var/pierce_material = FALSE	// If true, the patch can be used through thick material.

/obj/item/reagent_containers/pill/patch/attack(mob/M as mob, mob/user as mob)
	var/mob/living/L = user

	if(M == L)
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			var/obj/item/organ/external/affecting = H.get_organ(check_zone(L.zone_sel.selecting))
			if(!affecting)
				to_chat(user, span_warning("The limb is missing!"))
				return
			if(affecting.status >= ORGAN_ROBOT)
				to_chat(user, span_notice("\The [src] won't work on a robotic limb!"))
				return

			if(!H.can_inject(user, FALSE, L.zone_sel.selecting, pierce_material))
				to_chat(user, span_notice("\The [src] can't be applied through such a thick material!"))
				return

			to_chat(H, span_notice("\The [src] is placed on your [affecting]."))
			M.drop_from_inventory(src) //icon update
			if(reagents.total_volume)
				reagents.trans_to_mob(M, reagents.total_volume, CHEM_BLOOD) //CHEM_TOUCH
			qdel(src)
			return 1

	else if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(check_zone(L.zone_sel.selecting))
		if(!affecting)
			to_chat(user, span_warning("The limb is missing!"))
			return
		if(affecting.status >= ORGAN_ROBOT)
			to_chat(user, span_notice("\The [src] won't work on a robotic limb!"))
			return

		if(!H.can_inject(user, FALSE, L.zone_sel.selecting, pierce_material))
			to_chat(user, span_notice("\The [src] can't be applied through such a thick material!"))
			return

		user.visible_message(span_warning("[user] attempts to place \the [src] onto [H]`s [affecting]."))

		user.setClickCooldown(user.get_attack_speed(src))
		if(!do_mob(user, M))
			return

		user.drop_from_inventory(src) //icon update
		user.visible_message(span_warning("[user] applies \the [src] to [H]."))

		var/contained = reagentlist()
		add_attack_logs(user,M,"Applied a patch containing [contained]")

		to_chat(H, span_notice("\The [src] is placed on your [affecting]."))
		M.drop_from_inventory(src) //icon update

		if(reagents.total_volume)
			reagents.trans_to_mob(M, reagents.total_volume, CHEM_BLOOD)	//CHEM_TOUCH
		qdel(src)

		return 1

	return 0
