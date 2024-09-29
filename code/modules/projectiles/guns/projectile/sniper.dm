////////////// PTR-7 Anti-Materiel Rifle //////////////

/obj/item/gun/projectile/heavysniper
	name = "anti-materiel rifle"
	desc = "A portable anti-armour rifle fitted with a scope, the HI PTR-7 Rifle was originally designed to used against armoured exosuits. It is capable of punching through windows and non-reinforced walls with ease. Fires armor piercing 14.5mm shells."
	description_fluff = "The leading arms producer in the SCG, Hephaestus typically only uses its 'top level' branding for its military-grade equipment used by professional armed forces across human space."
	icon_state = "heavysniper"
	wielded_item_state = "heavysniper-wielded"
	w_class = ITEMSIZE_HUGE // So it can't fit in a backpack.
	force = 10
	slot_flags = SLOT_BACK
	action_button_name = "Use Scope"
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 2, TECH_ILLEGAL = 8)
	caliber = "14.5mm"
	recoil = 5 //extra kickback
	handle_casings = HOLD_CASINGS
	load_method = SINGLE_CASING
	max_shells = 1
	ammo_type = /obj/item/ammo_casing/a145
	projectile_type = /obj/item/projectile/bullet/rifle/a145
	accuracy = -75
	scoped_accuracy = 75
	ignore_visor_zoom_restriction = TRUE	// Ignore the restriction on vision modifiers when using this gun's scope.
	one_handed_penalty = 90
	var/bolt_open = 0

/obj/item/gun/projectile/heavysniper/update_icon()
	if(bolt_open)
		icon_state = "heavysniper-open"
	else
		icon_state = "heavysniper"

/obj/item/gun/projectile/heavysniper/attack_self(mob/user as mob)
	playsound(src, 'sound/weapons/flipblade.ogg', 50, 1)
	bolt_open = !bolt_open
	if(bolt_open)
		if(chambered)
			to_chat(user, "<span class='notice'>You work the bolt open, ejecting [chambered]!</span>")
			chambered.loc = get_turf(src)
			loaded -= chambered
			chambered = null
		else
			to_chat(user, "<span class='notice'>You work the bolt open.</span>")
	else
		to_chat(user, "<span class='notice'>You work the bolt closed.</span>")
		bolt_open = 0
	add_fingerprint(user)
	update_icon()

/obj/item/gun/projectile/heavysniper/special_check(mob/user)
	if(bolt_open)
		to_chat(user, "<span class='warning'>You can't fire [src] while the bolt is open!</span>")
		return 0
	return ..()

/obj/item/gun/projectile/heavysniper/load_ammo(var/obj/item/A, mob/user)
	if(!bolt_open)
		return
	..()

/obj/item/gun/projectile/heavysniper/unload_ammo(mob/user, var/allow_dump=1)
	if(!bolt_open)
		return
	..()

/obj/item/gun/projectile/heavysniper/ui_action_click()
	scope()

/obj/item/gun/projectile/heavysniper/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(2.0)

////////////// Dragunov Sniper Rifle //////////////

/obj/item/gun/projectile/SVD
	name = "sniper rifle"
	desc = "The PCA S19 Jalgarr, also known by its translated name the 'Dragon', is mass produced with an Optical Sniper Sight so simple that even a Tajaran can use it. Too bad for you that the inscriptions are written in Siik. Uses 7.62mm rounds."
	icon_state = "SVD"
	item_state = "SVD"
	wielded_item_state = "heavysniper-wielded" //Placeholder
	w_class = ITEMSIZE_HUGE // So it can't fit in a backpack.
	force = 10
	slot_flags = SLOT_BACK // Needs a sprite.
	action_button_name = "Use Scope"
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 2, TECH_ILLEGAL = 8)
	caliber = "7.62mm"
	load_method = MAGAZINE
	accuracy = -45 //shooting at the hip
	scoped_accuracy = 0
	one_handed_penalty = 60 // The weapon itself is heavy, and the long barrel makes it hard to hold steady with just one hand.
	fire_sound = 'sound/weapons/Gunshot_SVD.ogg' // Has a very unique sound.
	magazine_type = /obj/item/ammo_magazine/m762svd
	allowed_magazines = list(/obj/item/ammo_magazine/m762svd)

/obj/item/gun/projectile/SVD/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "SVD"
	else
		icon_state = "SVD-empty"

/obj/item/gun/projectile/SVD/ui_action_click()
	scope()

/obj/item/gun/projectile/SVD/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(2.0)