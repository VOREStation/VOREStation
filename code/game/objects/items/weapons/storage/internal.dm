//A storage item intended to be used by other items to provide storage functionality.
//Types that use this should consider overriding emp_act() and hear_talk(), unless they shield their contents somehow.
/obj/item/weapon/storage/internal
	preserve_item = 1
	var/atom/movable/master_atom

<<<<<<< HEAD
/obj/item/weapon/storage/internal/New(obj/item/MI)
	master_item = MI
	loc = master_item
	name = master_item.name
=======
/obj/item/storage/internal/Initialize()
	. = ..()
	master_atom = loc
	if(!istype(master_atom))
		return INITIALIZE_HINT_QDEL
	loc = master_atom
	name = master_atom.name
>>>>>>> 7aa6f14ab0c... Merge pull request #8688 from MistakeNot4892/doggo
	verbs -= /obj/item/verb/verb_pickup	//make sure this is never picked up.
	..()

<<<<<<< HEAD
/obj/item/weapon/storage/internal/Destroy()
	master_item = null
=======
/obj/item/storage/internal/Destroy()
	master_atom = null
>>>>>>> 7aa6f14ab0c... Merge pull request #8688 from MistakeNot4892/doggo
	. = ..()

/obj/item/weapon/storage/internal/attack_hand()
	return		//make sure this is never picked up

/obj/item/weapon/storage/internal/mob_can_equip(M as mob, slot, disable_warning = FALSE)
	return 0	//make sure this is never picked up

//Helper procs to cleanly implement internal storages - storage items that provide inventory slots for other items.
//These procs are completely optional, it is up to the master item to decide when it's storage get's opened by calling open()
//However they are helpful for allowing the master item to pretend it is a storage item itself.
//If you are using these you will probably want to override attackby() as well.
//See /obj/item/clothing/suit/storage for an example.

//items that use internal storage have the option of calling this to emulate default storage MouseDrop behaviour.
//returns 1 if the master item's parent's MouseDrop() should be called, 0 otherwise. It's strange, but no other way of
//doing it without the ability to call another proc's parent, really.
/obj/item/weapon/storage/internal/proc/handle_mousedrop(mob/user as mob, obj/over_object as obj)
	if (ishuman(user) || issmall(user)) //so monkeys can take off their backpacks -- Urist

		if(!isitem(master_atom))
			return 0

		if (istype(user.loc,/obj/mecha)) // stops inventory actions in a mech
			return 0

		if(over_object == user && Adjacent(user)) // this must come before the screen objects only block
			src.open(user)
			return 0

		if (!( istype(over_object, /obj/screen) ))
			return 1

		//makes sure master_atom is equipped before putting it in hand, so that we can't drag it into our hand from miles away.
		//there's got to be a better way of doing this...
		if (!(master_atom.loc == user) || (master_atom.loc && master_atom.loc.loc == user))
			return 0

		if (!( user.restrained() ) && !( user.stat ))
			switch(over_object.name)
				if("r_hand")
					user.unEquip(master_atom)
					user.put_in_r_hand(master_atom)
				if("l_hand")
					user.unEquip(master_atom)
					user.put_in_l_hand(master_atom)
			master_atom.add_fingerprint(user)
			return 0
	return 0

//items that use internal storage have the option of calling this to emulate default storage attack_hand behaviour.
//returns 1 if the master item's parent's attack_hand() should be called, 0 otherwise.
//It's strange, but no other way of doing it without the ability to call another proc's parent, really.
/obj/item/weapon/storage/internal/proc/handle_attack_hand(mob/user as mob)

	if(isitem(master_atom))
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(H.l_store == master_atom && !H.get_active_hand())	//Prevents opening if it's in a pocket.
				H.put_in_hands(master_atom)
				H.l_store = null
				return 0
			if(H.r_store == master_atom && !H.get_active_hand())
				H.put_in_hands(master_atom)
				H.r_store = null
				return 0

		if(master_atom.loc == user)
			add_fingerprint(user)
			open(user)
			return 0

	if(ismob(master_atom) && user.Adjacent(master_atom))
		add_fingerprint(user)
		open(user)
		return 0

	for(var/mob/M in range(1, master_atom.loc))
		if (M.s_active == src)
			src.close(M)
	return 1

<<<<<<< HEAD
/obj/item/weapon/storage/internal/Adjacent(var/atom/neighbor)
	return master_item.Adjacent(neighbor)
=======
/obj/item/storage/internal/Adjacent(var/atom/neighbor)
	return master_atom.Adjacent(neighbor)
>>>>>>> 7aa6f14ab0c... Merge pull request #8688 from MistakeNot4892/doggo
