/**
 * The gun itself
 */
/obj/item/weapon/gun/projectile/smartgun
	name = "\improper OP-15 'S.M.A.R.T.' Rifle"
	desc = "Suppressive Manual Action Reciprocating Taser rifle. A modified version of an Armadyne heavy machine gun fitted to fire miniature shock-bolts."
	description_info = "Alt-click to toggle the rifle's ready state. The rifle can't be unloaded when ready, and requires a few seconds to get ready before firing."
	icon = 'icons/obj/guns/projectile/smartgun_item.dmi'
	icon_state = "smartgun"
	icon_override = 'icons/obj/guns/projectile/smartgun_mob.dmi'
	item_state = "smartgun"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 6, TECH_BLUESPACE = 4)
	w_class = ITEMSIZE_LARGE
	matter = list(MAT_STEEL = 6000, MAT_DIAMOND = 2000, MAT_URANIUM = 2000)
	recoil = 1
	projectile_type = /obj/item/projectile/bullet/smartgun	//Only used for chameleon guns
	slot_flags = SLOT_BACK
	accuracy = -15
	one_handed_penalty = 50

	caliber = "smartgun"
	handle_casings = EJECT_CASINGS
	load_method = MAGAZINE

	magazine_type = null	//the type of magazine that the gun comes preloaded with
	allowed_magazines = list(/obj/item/ammo_magazine/smartgun)	//determines list of which magazines will fit in the gun

	var/closed = TRUE
	var/cycling = FALSE

	var/static/mutable_appearance/mag_underlay

/obj/item/weapon/gun/projectile/smartgun/make_worn_icon(body_type, slot_name, inhands, default_icon, default_layer, icon/clip_mask)
	var/image/I = ..()
	if(I)
		I.pixel_x = -16
	return I

/obj/item/weapon/gun/projectile/smartgun/loaded
	magazine_type = /obj/item/ammo_magazine/smartgun

/obj/item/weapon/gun/projectile/smartgun/Initialize()
	. = ..()
	if(!mag_underlay)
		mag_underlay = mutable_appearance(icon, icon_state = "smartgun_mag")

/obj/item/weapon/gun/projectile/smartgun/consume_next_projectile()
	if(!closed)
		return null
	return ..()

/obj/item/weapon/gun/projectile/smartgun/load_ammo(var/obj/item/A, mob/user)
	if(closed)
		to_chat(user, "<span class='warning'>[src] can't be loaded until you un-ready it. (Alt-click)</span>")
		return
	return ..()

/obj/item/weapon/gun/projectile/smartgun/unload_ammo(mob/user, var/allow_dump=0)
	if(closed)
		to_chat(user, "<span class='warning'>[src] can't be unloaded until you un-ready it. (Alt-click)</span>")
		return
	return ..()

/obj/item/weapon/gun/projectile/smartgun/AltClick(mob/user)
	if(ishuman(user) && !user.incapacitated() && Adjacent(user))
		if(cycling)
			to_chat(user, "<span class='warning'>[src] is still cycling!</span>")
			return

		cycling = TRUE

		if(closed)
			icon_state = "[initial(icon_state)]_open"
			playsound(src, 'sound/weapons/smartgunopen.ogg', 75, 0)
			to_chat(user, "<span class='notice'>You unready [src] so that it can be reloaded.</span>")
		else
			icon_state = "[initial(icon_state)]_closed"
			playsound(src, 'sound/weapons/smartgunclose.ogg', 75, 0)
			to_chat(user, "<span class='notice'>You ready [src] so that it can be fired.</span>")
		addtimer(CALLBACK(src, PROC_REF(toggle_real_state)), 2 SECONDS, TIMER_UNIQUE)

/obj/item/weapon/gun/projectile/smartgun/proc/toggle_real_state()
	cycling = FALSE
	closed = !closed

/obj/item/weapon/gun/projectile/smartgun/update_icon()
	. = ..()
	underlays = null
	if(ammo_magazine)
		underlays += mag_underlay

/**
 * The bullet that flies through the air
 */
/obj/item/projectile/bullet/smartgun
	name = "smartgun rail"
	icon_state = "smartgunproj"
	icon = 'icons/obj/guns/projectile/smartgun_32.dmi'
	fire_sound = 'sound/weapons/Gunshot4.ogg' // hmm

	// Slight damage and big stun
	damage_type = BRUTE
	damage = 10
	agony = 70
	check_armour = "bullet"
	embed_chance = 0 // There's a separate sprite for this, but for now let's just not embed
	accuracy = -30 // 2 turfs closer for the purpose of accuracy

	muzzle_type = /obj/effect/projectile/muzzle/lightning

/obj/item/projectile/bullet/smartgun/launch_projectile(atom/target, target_zone, mob/user, params, angle_override, forced_spread)
	. = ..()
	if(ismob(target))
		Beam(get_turf(target), icon_state = "sniper_beam", time = 0.25 SECONDS, maxdistance = 15)
		set_homing_target(target)

/**
 * The item of ammo that holds the bullet
 */
/obj/item/ammo_casing/smartgun
	name = "smartgun rail"
	desc = "A smartgun rail casing."
	icon = 'icons/obj/guns/projectile/smartgun_32.dmi'
	icon_state = "smartguncase"
	randpixel = 10
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_SMALL

	leaves_residue = FALSE
	caliber = "smartgun"
	projectile_type = /obj/item/projectile/bullet/smartgun

/**
 * The magazine that holds the items of ammo
 */
/obj/item/ammo_magazine/smartgun
	name = "smartgun magazine"
	desc = "A holder for smartgun rails for the S.M.A.R.T. rifle."
	icon = 'icons/obj/guns/projectile/smartgun_32.dmi'
	icon_state = "smartgunmag"
	slot_flags = SLOT_BELT
	matter = list(MAT_STEEL = 500)
	w_class = ITEMSIZE_SMALL

	mag_type = MAGAZINE
	caliber = "smartgun"
	max_ammo = 5
	ammo_type = /obj/item/ammo_casing/smartgun
	multiple_sprites = TRUE
