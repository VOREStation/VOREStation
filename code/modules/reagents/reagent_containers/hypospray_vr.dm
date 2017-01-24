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
