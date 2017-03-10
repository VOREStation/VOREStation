//A vial-loaded hypospray. Cartridge-based!
/obj/item/weapon/reagent_containers/hypospray/vr
	name = "hypospray mkII"
	desc = "A new development from DeForest Medical, this new hypospray takes 30-unit vials as the drug supply for easy swapping."
	var/obj/item/weapon/reagent_containers/glass/beaker/vial/loaded_vial //Wow, what a name.
	volume = 0

/obj/item/weapon/reagent_containers/hypospray/vr/New()
	..()
	loaded_vial = new /obj/item/weapon/reagent_containers/glass/beaker/vial/vr(src) //Comes with an empty vial
	volume = loaded_vial.volume
	reagents.maximum_volume = loaded_vial.reagents.maximum_volume

/obj/item/weapon/reagent_containers/hypospray/vr/attack_hand(mob/user as mob)
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

/obj/item/weapon/reagent_containers/hypospray/vr/attackby(obj/item/weapon/W, mob/user as mob)
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

/obj/item/weapon/reagent_containers/hypospray/autoinjector/beltminer
	name = "Emergency trauma injector"
	desc = "A rapid injector for emergency treatment of injuries. The warning label advises that it is not a substitute for proper medical treatment."
	icon_state = "autoinjector"
	item_state = "autoinjector"
	amount_per_transfer_from_this = 10
	volume = 10

/obj/item/weapon/reagent_containers/hypospray/autoinjector/beltminer/New()
	..()
	reagents.add_reagent("bicaridine", 5)
	reagents.add_reagent("tricordrazine", 3)
	reagents.add_reagent("tramadol", 2)
	update_icon()
	return

/obj/item/weapon/storage/box/traumainjectors
	name = "box of emergency trauma injectors"
	desc = "Contains emergency trauma autoinjectors."
	icon_state = "syringe"

/obj/item/weapon/storage/box/traumainjectors/New()
	..()
	for (var/i = 1 to 7)
		new /obj/item/weapon/reagent_containers/hypospray/autoinjector/beltminer(src)
