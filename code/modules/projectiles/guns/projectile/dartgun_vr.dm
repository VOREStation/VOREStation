//-----------------------Tranq Gun----------------------------------
/obj/item/gun/projectile/dartgun/tranq
	name = "tranquilizer gun"
	desc = "A gas-powered dart gun designed by the National Armory of Gaia. This gun is used primarily by United Federation special forces for Tactical Espionage missions. Don't forget your bandana."
	icon_state = "tranqgun"
	item_state = null

	caliber = "dart"
	fire_sound = 'sound/weapons/empty.ogg'
	fire_sound_text = "a metallic click"
	recoil = 0
	silenced = 1
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/chemdart
	allowed_magazines = list(/obj/item/ammo_magazine/chemdart)
	auto_eject = 0

/obj/item/gun/projectile/dartgun/tranq/update_icon()
	if(!ammo_magazine)
		icon_state = "tranqgun"
		return 1

	if(!ammo_magazine.stored_ammo || ammo_magazine.stored_ammo.len)
		icon_state = "tranqgun"
	else if(ammo_magazine.stored_ammo.len > 5)
		icon_state = "tranqgun"
	else
		icon_state = "tranqgun"
	return 1

// This is to allow xenobio to activate slime cores via remote.
/obj/item/projectile/bullet/chemdart/on_hit(var/atom/target, var/blocked = 0, var/def_zone = null)
	..()
	if(blocked < 2)
		if(istype(target, /obj/item/reagent_containers/food) || istype(target, /obj/item/slime_extract))
			reagents.trans_to_obj(target, reagent_amount)