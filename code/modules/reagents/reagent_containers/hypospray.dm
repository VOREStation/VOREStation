////////////////////////////////////////////////////////////////////////////////
/// HYPOSPRAY
////////////////////////////////////////////////////////////////////////////////

/obj/item/weapon/reagent_containers/hypospray
	name = "hypospray"
	desc = "The DeForest Medical Corporation hypospray is a sterile, air-needle autoinjector for rapid administration of drugs to patients."
	icon = 'icons/obj/syringe.dmi'
	item_state = "hypo"
	icon_state = "hypo"
	amount_per_transfer_from_this = 5
	unacidable = 1
	volume = 30
	possible_transfer_amounts = null
	flags = OPENCONTAINER
	slot_flags = SLOT_BELT
	preserve_item = 1
	var/reusable = 1
	var/used = 0
	var/filled = 0
	var/list/filled_reagents = list()

/obj/item/weapon/reagent_containers/hypospray/New()
	..()
	if(filled)
		if(filled_reagents)
			for(var/r in filled_reagents)
				reagents.add_reagent(r, filled_reagents[r])
	update_icon()
	return

/obj/item/weapon/reagent_containers/hypospray/attack(mob/living/M as mob, mob/user as mob)
	if(!reagents.total_volume)
		user << "<span class='warning'>[src] is empty.</span>"
		return
	if (!istype(M))
		return

	var/mob/living/carbon/human/H = M
	if(istype(H))
		var/obj/item/organ/external/affected = H.get_organ(user.zone_sel.selecting)
		if(!affected)
			user << "<span class='danger'>\The [H] is missing that limb!</span>"
			return
		else if(affected.robotic >= ORGAN_ROBOT)
			user << "<span class='danger'>You cannot inject a robotic limb.</span>"
			return

	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	user << "<span class='notice'>You inject [M] with [src].</span>"
	M << "<span class='notice'>You feel a tiny prick!</span>"

	if(M.reagents)
		var/contained = reagentlist()
		var/trans = reagents.trans_to_mob(M, amount_per_transfer_from_this, CHEM_BLOOD)
		admin_inject_log(user, M, src, contained, trans)
		user << "<span class='notice'>[trans] units injected. [reagents.total_volume] units remaining in \the [src].</span>"

	if(!reusable && !used)
		used = !used

	return
//A vial-loaded hypospray. Cartridge-based!
/obj/item/weapon/reagent_containers/hypospray/vial
	name = "hypospray mkII"
	desc = "A new development from DeForest Medical, this new hypospray takes 30-unit vials as the drug supply for easy swapping."
	var/obj/item/weapon/reagent_containers/glass/beaker/vial/loaded_vial //Wow, what a name.
	volume = 0

/obj/item/weapon/reagent_containers/hypospray/vial/New()
	..()
	loaded_vial = new /obj/item/weapon/reagent_containers/glass/beaker/vial(src) //Comes with an empty vial
	volume = loaded_vial.volume
	reagents.maximum_volume = loaded_vial.reagents.maximum_volume

/obj/item/weapon/reagent_containers/hypospray/vial/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src)
		if(loaded_vial)
			reagents.trans_to_holder(loaded_vial.reagents,volume)
			reagents.maximum_volume = 0
			loaded_vial.update_icon()
			user.put_in_hands(loaded_vial)
			loaded_vial = null
			user << "<span class='notice'>You remove the vial from the [src].</span>"
			update_icon()
			playsound(src.loc, 'sound/weapons/flipblade.ogg', 50, 1)
			return
		..()
	else
		return ..()

/obj/item/weapon/reagent_containers/hypospray/vial/attackby(obj/item/weapon/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/reagent_containers/glass/beaker/vial))
		if(!loaded_vial)
			user.visible_message("<span class='notice'>[user] begins loading [W] into \the [src].</span>","<span class='notice'>You start loading [W] into \the [src].</span>")
			if(!do_after(user,30) || loaded_vial || !(W in user))
				return 0
			if(W.is_open_container())
				W.flags ^= OPENCONTAINER
				W.update_icon()
			user.drop_item()
			W.loc = src
			loaded_vial = W
			reagents.maximum_volume = loaded_vial.reagents.maximum_volume
			loaded_vial.reagents.trans_to_holder(reagents,volume)
			user.visible_message("<span class='notice'>[user] has loaded [W] into \the [src].</span>","<span class='notice'>You have loaded [W] into \the [src].</span>")
			update_icon()
			playsound(src.loc, 'sound/weapons/empty.ogg', 50, 1)
		else
			user << "<span class='notice'>\The [src] already has a vial.</span>"
	else
		..()
		
/obj/item/weapon/reagent_containers/hypospray/autoinjector
	name = "autoinjector"
	desc = "A rapid and safe way to administer small amounts of drugs by untrained or trained personnel."
	icon_state = "autoinjector"
	item_state = "autoinjector"
	amount_per_transfer_from_this = 5
	volume = 5
	reusable = 0
	filled = 1
	filled_reagents = list("inaprovaline" = 5)
	preserve_item = 0

/obj/item/weapon/reagent_containers/hypospray/autoinjector/on_reagent_change()
	..()
	update_icon()

/obj/item/weapon/reagent_containers/hypospray/autoinjector/empty
	filled = 0
	filled_reagents = list()

/obj/item/weapon/reagent_containers/hypospray/autoinjector/used
	used = 1
	filled_reagents = list()

/obj/item/weapon/reagent_containers/hypospray/autoinjector/attack(mob/M as mob, mob/user as mob)
	..()
	if(used) //Prevents autoinjectors to be refilled.
		flags &= ~OPENCONTAINER
	update_icon()
	return

/obj/item/weapon/reagent_containers/hypospray/autoinjector/update_icon()
	if(!used && reagents.reagent_list.len)
		icon_state = "[initial(icon_state)]1"
	else if(used)
		icon_state = "[initial(icon_state)]0"
	else
		icon_state = "[initial(icon_state)]2"

/obj/item/weapon/reagent_containers/hypospray/autoinjector/examine(mob/user)
	..(user)
	if(reagents && reagents.reagent_list.len)
		user << "<span class='notice'>It is currently loaded.</span>"
	else if(used)
		user << "<span class='notice'>It is spent.</span>"
	else
		user << "<span class='notice'>It is currently unloaded.</span>"

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/clotting
	name = "clotting agent"
	desc = "A refined version of the standard autoinjector, allowing greater capacity. This variant excels at treating bleeding wounds and internal bleeding."
	filled_reagents = list("inaprovaline" = 5, "myelamine" = 10)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/bonemed
	name = "bone repair injector"
	desc = "A refined version of the standard autoinjector, allowing greater capacity. This one excels at treating damage to bones."
	filled_reagents = list("inaprovaline" = 5, "osteodaxon" = 10)
