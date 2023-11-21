/*
 * Shotgun Box
 */
/obj/item/gunbox/warden
	name = "warden's shotgun case"
	desc = "A secure guncase containing the warden's beloved shotgun."
	icon = 'icons/obj/storage_vr.dmi'
	icon_state = "gunboxw"

/obj/item/gunbox/warden/attack_self(mob/living/user)
	var/list/options = list()
	options["Warden's combat shotgun"] = list(/obj/item/weapon/gun/projectile/shotgun/pump/combat/warden, /obj/item/ammo_magazine/ammo_box/b12g/beanbag)
	options["Warden's compact shotgun"] = list(/obj/item/weapon/gun/projectile/shotgun/compact/warden, /obj/item/ammo_magazine/ammo_box/b12g/beanbag)
	var/choice = tgui_input_list(user,"Choose your boomstick!", "Shotgun!", options)
	if(src && choice)
		var/list/things_to_spawn = options[choice]
		for(var/new_type in things_to_spawn) // Spawn all the things, the gun and the ammo.
			var/atom/movable/AM = new new_type(get_turf(src))
			if(istype(AM, /obj/item/weapon/gun))
				to_chat(user, "You have chosen \the [AM]. Say hello to your new best friend.")
		qdel(src)

/*
 * Site Manager's Box
 */
/obj/item/gunbox/captain
	name = "Captain's sidearm box"
	desc = "A secure box containing a sidearm befitting of the site manager. Includes both lethal and non-lethal munitions, beware what's loaded!"
	icon = 'icons/obj/storage.dmi'
	icon_state = "gunbox"
/obj/item/gunbox/captain/attack_self(mob/living/user)
	var/list/options = list()
	options["M1911 (.45)"] = list(/obj/item/weapon/gun/projectile/colt/detective, /obj/item/ammo_magazine/m45/rubber, /obj/item/ammo_magazine/m45)
	options["MT Mk58 (.45)"] = list(/obj/item/weapon/gun/projectile/sec, /obj/item/ammo_magazine/m45/rubber, /obj/item/ammo_magazine/m45)
	options["LAEP80 \"Thor\" (Stun/Laser)"] = list(/obj/item/weapon/gun/energy/gun, /obj/item/weapon/cell/device/weapon, /obj/item/weapon/cell/device/weapon)
	options["MarsTech P92X (9mm)"] = list(/obj/item/weapon/gun/projectile/p92x/rubber, /obj/item/ammo_magazine/m9mm/rubber, /obj/item/ammo_magazine/m9mm)
	var/choice = tgui_input_list(user,"Would you prefer a ballistic pistol or an energy gun?", "Gun!", options)
	if(src && choice)
		var/list/things_to_spawn = options[choice]
		for(var/new_type in things_to_spawn) // Spawn all the things, the gun and the ammo.
			var/atom/movable/AM = new new_type(get_turf(src))
			if(istype(AM, /obj/item/weapon/gun))
				to_chat(user, "You have chosen \the [AM]. Say hello to your new friend.")
		qdel(src)
