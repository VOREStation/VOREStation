/obj/item/weapon/gun/projectile/automatic/wt550/lethal
	magazine_type = /obj/item/ammo_magazine/m9mmt

/obj/item/weapon/gun/projectile/automatic/tommygun
	icon = 'icons/obj/gun_vr.dmi'

////////////////////////////////////////////////////////////
//////////////////// Projectile Weapons ////////////////////
////////////////////////////////////////////////////////////
// For general use
/obj/item/weapon/gun/projectile/automatic/battlerifle
	name = "\improper USDF service rifle"
	desc = "You had your chance to be afraid before you joined my beloved Corps! But, to guide you back to the true path, I have brought this motivational device! Uses 9.5x40mm rounds."
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "battlerifle"
	icon_override = 'icons/obj/gun_vr.dmi'
	item_state = "battlerifle_i"
	item_icons = null
	w_class = ITEMSIZE_LARGE
	recoil = 2 // The battlerifle was known for its nasty recoil.
	max_shells = 36
	caliber = "9.5x40mm"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	magazine_type = /obj/item/ammo_magazine/m95
	allowed_magazines = list(/obj/item/ammo_magazine/m95)
	fire_sound = 'sound/weapons/battlerifle.ogg'
	load_method = MAGAZINE
	slot_flags = SLOT_BACK
	one_handed_penalty = 60 // The weapon itself is heavy

// For general use
/obj/item/weapon/gun/projectile/automatic/stg
	name = "\improper Sturmgewehr"
	desc = "An STG-560 built by RauMauser. Experience the terror of the Siegfried line, redone for the 26th century! The Kaiser would be proud. Uses unique 7.92x33mm Kurz rounds."
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "stg60"
	item_state = "arifle"
	w_class = ITEMSIZE_LARGE
	max_shells = 30
	caliber = "7.92x33mm"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2, TECH_ILLEGAL = 6)
	magazine_type = /obj/item/ammo_magazine/mtg
	allowed_magazines = list(/obj/item/ammo_magazine/mtg)
	load_method = MAGAZINE

/obj/item/weapon/gun/projectile/automatic/stg/update_icon(var/ignore_inhands)
	..()
	icon_state = (ammo_magazine)? "stg60" : "stg60-empty"
	item_state = (ammo_magazine)? "arifle" : "arifle-empty"
	if(!ignore_inhands) update_held_icon()

//////////////////// Eris Ported Guns ////////////////////
// No idea what this is for.
/obj/item/weapon/gun/projectile/automatic/sol
	name = "\improper \"Sol\" SMG"
	desc = "The FS 9x19mm \"Sol\" is a compact and reliable submachine gun. Uses 9mm rounds."
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "SMG-IS"
	item_state = "wt550"
	w_class = ITEMSIZE_LARGE
	slot_flags = SLOT_BELT
	caliber = "9mm"
	magazine_type = /obj/item/ammo_magazine/m9mm
	allowed_magazines = list(/obj/item/ammo_magazine/m9mm)
	load_method = MAGAZINE
	multi_aim = 1
	burst_delay = 2
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=4,    burst_accuracy=list(0,-15,-15),       dispersion=list(0.0, 0.6, 1.0)),
		)

/obj/item/weapon/gun/projectile/automatic/sol/proc/update_charge()
	if(!ammo_magazine)
		return
	var/ratio = ammo_magazine.stored_ammo.len / ammo_magazine.max_ammo
	if(ratio < 0.25 && ratio != 0)
		ratio = 0.25
	ratio = round(ratio, 0.25) * 100
	add_overlay("smg_[ratio]")

/obj/item/weapon/gun/projectile/automatic/sol/update_icon()
	icon_state = (ammo_magazine)? "SMG-IS" : "SMG-IS-empty"
	cut_overlays()
	update_charge()

//--------------- StG-60 ----------------
/obj/item/ammo_magazine/m792
	name = "box mag (7.92x33mm Kurz)"
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "stg_30rnd"
	caliber = "7.92x33mm"
	ammo_type = /obj/item/ammo_casing/a792
	max_ammo = 30
	mag_type = MAGAZINE

/obj/item/ammo_casing/a792
	desc = "A 7.92x33mm Kurz casing."
	icon_state = "rifle-casing"
	caliber = "7.92x33mm"
	projectile_type = /obj/item/projectile/bullet/rifle/a762

/obj/item/ammo_magazine/mtg/empty
	initial_ammo = 0

//------------- Battlerifle -------------
/obj/item/ammo_magazine/m95
	name = "box mag (9.5x40mm)"
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "battlerifle"
	caliber = "9.5x40mm"
	ammo_type = /obj/item/ammo_casing/a95
	max_ammo = 36
	mag_type = MAGAZINE
	multiple_sprites = 1

/obj/item/ammo_casing/a95
	desc = "A 9.5x40mm bullet casing."
	icon_state = "rifle-casing"
	caliber = "9.5x40mm"
	projectile_type = /obj/item/projectile/bullet/rifle/a95

/obj/item/projectile/bullet/rifle/a95
	damage = 40

/obj/item/ammo_magazine/m95/empty
	initial_ammo = 0

//---------------- PDW ------------------
/obj/item/ammo_magazine/m9mml
	name = "\improper SMG magazine (9mm)"
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "smg"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	matter = list(MAT_STEEL = 1800)
	caliber = "9mm"
	ammo_type = /obj/item/ammo_casing/a9mm
	max_ammo = 30
	multiple_sprites = 1

/obj/item/ammo_magazine/m9mml/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m9mml/ap
	name = "\improper SMG magazine (9mm armor-piercing)"
	ammo_type = /obj/item/ammo_casing/a9mm/ap