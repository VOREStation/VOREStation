//snowflake guns for xenoarch because you can't override the update_icon() proc inside the giant mess that is find creation
/obj/item/gun/projectile/artifact
	name = "artifact gun"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "gun1"
	caliber = ".357"
	max_shells = 12
	ammo_type = /obj/item/ammo_casing/artifact
	load_method = SINGLE_CASING //One. At. A. Time.
	auto_eject = 0

/obj/item/gun/projectile/artifact/get_ammo_type() //Handles the HUD overlay.
	var/obj/item/projectile/P = src.projectile_type
	return list(initial(P.hud_state), initial(P.hud_state_empty))

/obj/item/gun/projectile/artifact/unload_ammo(mob/user, allow_dump=0) //No taking the bullets out!
	if(loaded.len)
		var/obj/item/ammo_casing/C = loaded[loaded.len]
		loaded.len--
		user.visible_message("[user] removes \a casing from [src], the casing fizzling in the air before evaporating into dust.", span_notice("You remove \a casing from [src], the casing fizzling in the air before evaporating into dust"))
		C.loc = null //Into the void!
		qdel(C) //And begone!
		playsound(src, 'sound/weapons/empty.ogg', 50, 1)
		new /obj/effect/effect/sparks(src)
		user.hud_used.update_ammo_hud(user, src)
	else
		to_chat(user, span_warning("[src] is empty."))
	update_icon()
	user.hud_used.update_ammo_hud(user, src)

/obj/item/ammo_casing/artifact
	name = "artifact bullet casing"
	desc = "A MYSTERIOUS bullet casing!!! (You should not see this. If you do, blame adminbus or contact your nearest coder.)"
	drop_sound = 'sound/items/drop/ring.ogg'
	pickup_sound = 'sound/items/pickup/ring.ogg'
	projectile_type = /obj/item/projectile/bullet/cap //Just a placeholder. Doesn't actually matter what this is. All that matters is what the projecttile_type of our BB is.

/obj/item/ammo_casing/artifact/Initialize(mapload) //These should ONLY ever be in artifact weapons. If you spawn outside of artifact weapons, it'll have a riot foam dart inside of it as the bullet.
	. = ..()
	BB = null
	if(istype(loc, /obj/item/gun/projectile/artifact)) //If we are IN an artifact gun
		var/obj/item/gun/projectile/artifact/our_gun = loc
		if(ispath(our_gun.projectile_type))
			BB = new our_gun.projectile_type(src) //Then we create the bullet inside of us that is the projectile_type that the gun shoots!
		else
			BB = new /obj/item/ammo_casing/afoam_dart/riot(src) //Something went wrong. Should never happen.
	else //The bullet was adminspawned in outside of an artifact gun.
		BB = new /obj/item/ammo_casing/afoam_dart/riot(src)
	randpixel_xy()
