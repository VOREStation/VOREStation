/obj/item/weapon/gun/projectile/automatic/fluff/crestrose
	name = "Crescent Rose"
	desc = "Can you match my resolve? If so then you will succeed. I believe that the human spirit is indomitable. Keep Moving Forward. Uses 7.62mm rounds."
	icon = 'icons/vore/custom_guns_vr.dmi'
	icon_state = "crestrose_fold"

	icon_override = 'icons/vore/custom_guns_vr.dmi'
	item_state = "laser" //placeholder

	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_COMBAT = 7, TECH_MATERIAL = 4)
	slot_flags = null
	fire_sound = 'sound/weapons/Gunshot_light.ogg'
	load_method = MAGAZINE
	force = 3
	recoil = 2
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	hitsound = null
	caliber = "s762"
	magazine_type = /obj/item/ammo_magazine/m762
	allowed_magazines = list(/obj/item/ammo_magazine/m762)

	firemodes = list(
	list(mode_name="fold", icon_state="crestrose_fold",item_state = "laser",force=3),
	list(mode_name="scythe", icon_state="crestrose",item_state = "crestrose",force=15),
	)

/obj/item/weapon/gun/projectile/automatic/fluff/crestrose/switch_firemodes(mob/user)
	if(..())
		update_icon()
		update_held_icon()


/obj/item/weapon/gun/projectile/automatic/fluff/crestrose/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(default_parry_check(user, attacker, damage_source) && prob(50))
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
		playsound(user.loc, 'sound/weapons/punchmiss.ogg', 50, 1)
		return 1
	return 0