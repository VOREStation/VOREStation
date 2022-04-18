/*
 * Sidearm Lethal
 */
/obj/item/gunbox
	name = "sidearm box"
	desc = "A secure box containing a lethal sidearm."
	icon = 'icons/obj/storage.dmi'
	icon_state = "gunbox"
	w_class = ITEMSIZE_HUGE
/obj/item/gunbox/attack_self(mob/living/user)
	var/list/options = list()
<<<<<<< HEAD
	options["M1911 (.45)"] = list(/obj/item/weapon/gun/projectile/colt/detective, /obj/item/ammo_magazine/m45/rubber, /obj/item/ammo_magazine/m45/rubber)
	options["MT Mk58 (.45)"] = list(/obj/item/weapon/gun/projectile/sec, /obj/item/ammo_magazine/m45/rubber, /obj/item/ammo_magazine/m45/rubber)
	options["MarsTech R1 (.45)"] = list(/obj/item/weapon/gun/projectile/revolver/detective45, /obj/item/ammo_magazine/s45/rubber, /obj/item/ammo_magazine/s45/rubber)
	options["MarsTech P92X (9mm)"] = list(/obj/item/weapon/gun/projectile/p92x/rubber, /obj/item/ammo_magazine/m9mm/rubber, /obj/item/ammo_magazine/m9mm/rubber)
	var/choice = tgui_input_list(user,"Would you prefer a pistol or a revolver?", "Gun!", options)
	if(src && choice)
		var/list/things_to_spawn = options[choice]
		for(var/new_type in things_to_spawn) // Spawn all the things, the gun and the ammo.
			var/atom/movable/AM = new new_type(get_turf(src))
			if(istype(AM, /obj/item/weapon/gun))
				to_chat(user, "You have chosen \the [AM]. Say hello to your new friend.")
		qdel(src)

/*
 * Sidearm Stun
 */
/obj/item/gunbox/stun
	name = "non-lethal sidearm box"
	desc = "A secure box containing a non-lethal sidearm."
/obj/item/gunbox/stun/attack_self(mob/living/user)
	var/list/options = list()
	options["Stun Revolver"] = list(/obj/item/weapon/gun/energy/stunrevolver/detective, /obj/item/weapon/cell/device/weapon, /obj/item/weapon/cell/device/weapon)
	options["Taser"] = list(/obj/item/weapon/gun/energy/taser, /obj/item/weapon/cell/device/weapon, /obj/item/weapon/cell/device/weapon)
	var/choice = tgui_input_list(user,"Please, select an option.", "Stun Gun!", options)
	if(src && choice)
		var/list/things_to_spawn = options[choice]
		for(var/new_type in things_to_spawn) // Spawn all the things, the gun and the ammo.
			var/atom/movable/AM = new new_type(get_turf(src))
			if(istype(AM, /obj/item/weapon/gun))
				to_chat(user, "You have chosen \the [AM]. Say hello to your new friend.")
		qdel(src)

/*
 * CentCom Pistol
 */
/obj/item/gunbox/centcom
	name = "centcom sidearm box"
	desc = "A secure box containing a lethal sidearm used by Central Command."
	w_class = ITEMSIZE_HUGE
/obj/item/gunbox/centcom/attack_self(mob/living/user)
	var/list/options = list()
	options["Écureuil (10mm)"] = list(/obj/item/weapon/gun/projectile/ecureuil, /obj/item/ammo_magazine/m10mm/pistol, /obj/item/ammo_magazine/m10mm/pistol)
	options["Écureuil Olive (10mm)"] = list(/obj/item/weapon/gun/projectile/ecureuil/tac, /obj/item/ammo_magazine/m10mm/pistol, /obj/item/ammo_magazine/m10mm/pistol)
	options["Écureuil Tan (10mm)"] = list(/obj/item/weapon/gun/projectile/ecureuil/tac2, /obj/item/ammo_magazine/m10mm/pistol, /obj/item/ammo_magazine/m10mm/pistol)
	var/choice = tgui_input_list(user,"Please, select an option.", "Gun!", options)
=======
	options[".45 Pistol"] = list(/obj/item/gun/projectile/colt/detective, /obj/item/ammo_magazine/m45/rubber, /obj/item/ammo_magazine/m45/rubber)
	options[".45 Revolver"] = list(/obj/item/gun/projectile/revolver/detective45, /obj/item/ammo_magazine/s45/rubber, /obj/item/ammo_magazine/s45/rubber)
	var/choice = input(user,"Would you prefer a pistol or a revolver?") as null|anything in options
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	if(src && choice)
		var/list/things_to_spawn = options[choice]
		for(var/new_type in things_to_spawn) // Spawn all the things, the gun and the ammo.
			var/atom/movable/AM = new new_type(get_turf(src))
			if(istype(AM, /obj/item/gun))
				to_chat(user, "You have chosen \the [AM]. Say hello to your new friend.")
		qdel(src)