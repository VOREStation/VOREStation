<<<<<<< HEAD
/*
 * Bolt-Action Rifle
 */
/obj/item/weapon/gun/projectile/shotgun/pump/rifle
=======
// For all intents and purposes, these work exactly the same as pump shotguns. It's unnecessary to make their own procs for them.

////////Base Rifle////////
/obj/item/gun/projectile/shotgun/pump/rifle
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	name = "bolt-action rifle"
	desc = "The Weissen Company Type-19 is a modern interpretation of an almost ancient weapon design. \
	The model is popular among hunters and collectors due to its reliability. Uses 7.62mm rounds."
	description_fluff = "The frontier’s largest home-grown firearms manufacturer, \
	the Weissen Arms Company are the leading manufacturer of - not only quality - \
	but affordable rifles for the average frontiersman looking to protect his \
	claim. The company operates just one production plant in the Mytis system, \
	but their weapons have found popularity on garden worlds as far afield as \
	the Tajaran homeworld due to their excellent build quality, precision, and \
	stopping power. Thier bolt-action rifles and brushguns are a staple amongst \
	the rural communities that dot this infinite frontier."
	icon_state = "boltaction"
	item_state = "boltaction"
	fire_sound = 'sound/weapons/Gunshot_generic_rifle.ogg'
	max_shells = 5
	caliber = "7.62mm"
	origin_tech = list(TECH_COMBAT = 1)// Old as shit rifle doesn't have very good tech.
	ammo_type = /obj/item/ammo_casing/a762
	load_method = SINGLE_CASING|SPEEDLOADER
	action_sound = 'sound/weapons/riflebolt.ogg'
	pump_animation = "boltaction-cycling"

<<<<<<< HEAD
/*
 * Practice Rifle
 */
/obj/item/weapon/gun/projectile/shotgun/pump/rifle/practice // For target practice
=======
////////Practice Rifle////////
/obj/item/gun/projectile/shotgun/pump/rifle/practice // For target practice
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	name = "practice bolt-action rifle"
	icon_state = "boltaction_practice"
	desc = "A bolt-action rifle with a lightweight synthetic wood stock, designed for competitive shooting. \
	Comes shipped with practice rounds pre-loaded into the gun. Popular among professional marksmen. Uses 7.62mm rounds."
	ammo_type = /obj/item/ammo_casing/a762/practice
	pump_animation = "boltaction_practice-cycling"
	max_shells = 4

/*
 * Moist Nugget
 */
/obj/item/weapon/gun/projectile/shotgun/pump/rifle/moistnugget
	name = "mosin-nagant"
	icon_state = "moistnugget"
	item_state = "rifle"
	desc = "Developed from 1882 to 1891, it was used by the armed forces of the Russian Empire, the Soviet \
	Union and various other nations. It is one of the most mass-produced military bolt-action rifles in history. Uses 7.62mm rounds."
	description_fluff = "Hailing from the Human homeworld, the M1891, otherwise known as the Mosin-Nagant is one of the most \
	prevalant and cheapest rifles of its time. This modern remake of the classic design was used by early colonists of the \
	Commonwealth to stake claims. It was favored because of how cheap and easy the weapon was to manufacture as well as its \
	ease of use making it a better choice for those that didn't have proper firearms training."
	ammo_type = /obj/item/ammo_casing/a762
	pump_animation = "moistnugget-cycling"

<<<<<<< HEAD
/*
 * Ceremonial Rifle
 */
/obj/item/weapon/gun/projectile/shotgun/pump/rifle/ceremonial
=======
////////Ceremonial Rifle////////
/obj/item/gun/projectile/shotgun/pump/rifle/ceremonial
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	name = "ceremonial bolt-action rifle"
	desc = "A bolt-action rifle with a heavy, high-quality wood stock that has a beautiful finish. \
	Clearly not intended to be used in combat. Uses 7.62mm rounds."
	item_state = "ceremonial_rifle"
	icon_state = "ceremonial_rifle"
	ammo_type = /obj/item/ammo_casing/a762/blank
	pump_animation = "ceremonial_rifle-cycling"
	max_shells = 5

	var/sawn_off = FALSE

<<<<<<< HEAD
/obj/item/weapon/gun/projectile/shotgun/pump/rifle/ceremonial/attackby(var/obj/item/A as obj, mob/user as mob)
	if(sawn_off)
		to_chat(user, "<span class='warning'>The [src] is already shortened!</span>")
		return
	if(istype(A, /obj/item/weapon/surgical/circular_saw) || istype(A, /obj/item/weapon/melee/energy) || istype(A, /obj/item/weapon/pickaxe/plasmacutter) && w_class != ITEMSIZE_NORMAL)
=======
/obj/item/gun/projectile/shotgun/pump/rifle/ceremonial/attackby(var/obj/item/A as obj, mob/user as mob)
	if(istype(A, /obj/item/surgical/circular_saw) || istype(A, /obj/item/melee/energy) || istype(A, /obj/item/pickaxe/plasmacutter) && w_class != ITEMSIZE_NORMAL)
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
		to_chat(user, "<span class='notice'>You begin to shorten the barrel and stock of \the [src].</span>")
		if(loaded.len)
			afterattack(user, user)
			playsound(src, fire_sound, 50, 1)
			user.visible_message("<span class='danger'>[src] goes off!</span>", "<span class='danger'>The rifle goes off in your face!</span>")
			return
		if(do_after(user, 30))
			if(sawn_off)
				return
			icon_state = "sawn_rifle"
			w_class = ITEMSIZE_NORMAL
			recoil = 2 // Owch
			accuracy = -15 // You know damn well why.
			item_state = "gun"
			slot_flags &= ~SLOT_BACK // You can't sling it on your back
			slot_flags |= (SLOT_BELT|SLOT_HOLSTER) // But you can wear it on your belt (poorly concealed under a trenchcoat, ideally) - or in a holster, why not.
			name = "sawn-off rifle"
			desc = "The firepower of a rifle, now the size of a pistol, with an effective combat range of about three feet. Uses 7.62mm rounds."
			pump_animation = "sawn_rifle-cycling"
			to_chat(user, "<span class='warning'>You shorten the barrel and stock of \the [src]!</span>")
			sawn_off = TRUE
	else
		..()

/*
 * Surplus Rifle
 */
/obj/item/weapon/gun/projectile/shotgun/pump/surplus
	name = "surplus rifle"
	desc = "An ancient weapon from an era long past, crude in design, but still just as effective \
	as any modern interpretation. Uses 7.62mm rounds."
	icon_state = "surplus"
	item_state = "rifle"
	fire_sound = 'sound/weapons/Gunshot_generic_rifle.ogg'
	max_shells = 4
	slot_flags = null
	caliber = "7.62mm"
	origin_tech = list(TECH_COMBAT = 1) // Old(er) as shit rifle doesn't have very good tech.
	ammo_type = /obj/item/ammo_casing/a762
	load_method = SINGLE_CASING|SPEEDLOADER
	action_sound = 'sound/weapons/riflebolt.ogg'
	pump_animation = "surplus-cycling"

<<<<<<< HEAD
/*
 * Scoped Rifle
 */
/obj/item/weapon/gun/projectile/shotgun/pump/rifle/scoped
	name = "scoped bolt-action rifle"
	desc = "The Weissen Company Type-19 is a modern interpretation of an almost ancient weapon design. \
	The model is popular among hunters and collectors due to its reliability. Uses 7.62mm rounds."
	description_fluff = "The frontier’s largest home-grown firearms manufacturer, \
	the Weissen Arms Company are the leading manufacturer of - not only quality - \
	but affordable rifles for the average frontiersman looking to protect his \
	claim. The company operates just one production plant in the Mytis system, \
	but their weapons have found popularity on garden worlds as far afield as \
	the Tajaran homeworld due to their excellent build quality, precision, and \
	stopping power. Thier bolt-action rifles and brushguns are a staple amongst \
	the rural communities that dot this infinite frontier."
	icon_state = "scoped-boltaction"
	item_state = "boltaction_scoped"
	fire_sound = 'sound/weapons/Gunshot_generic_rifle.ogg'
=======
////////Standard Lever Action Rifle////////
/obj/item/gun/projectile/shotgun/pump/rifle/lever
	name = "lever-action rifle"
	desc = "The Hedberg-Hammarstrom Edda is the latest version of an almost ancient weapon design from the 19th century, popular with some due to its simplistic design. This one uses a lever-action to move new rounds into the chamber. Uses 7.62mm rounds."
	description_fluff = "Sif’s largest home-grown firearms manufacturer, the Hedberg-Hammarstrom company offers a range of high-quality, high-cost hunting rifles and shotguns designed with the Sivian wilderness - and its wildlife - in mind. \
	The company operates just one production plant in Kalmar, but their weapons have found popularity on garden worlds as far afield as the Tajaran homeworld due to their excellent build quality, precision, and stopping power."
	item_state = "leveraction"
	icon_state = "leveraction"
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	max_shells = 5
	caliber = "7.62mm"
	origin_tech = list(TECH_COMBAT = 2)// Old as shit rifle doesn't have very good tech, but it does have a scope.
	ammo_type = /obj/item/ammo_casing/a762
	load_method = SINGLE_CASING|SPEEDLOADER
	action_sound = 'sound/weapons/riflebolt.ogg'
	pump_animation = "scoped-boltaction-cycling"

/obj/item/weapon/gun/projectile/shotgun/pump/rifle/ui_action_click()
	scope()

<<<<<<< HEAD
/obj/item/weapon/gun/projectile/shotgun/pump/rifle/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1
=======
////////Vintage Lever Action Rifle////////
/obj/item/gun/projectile/shotgun/pump/rifle/lever/vintage
	name = "vintage repeater"
	desc = "An iconic manually operated lever action rifle, offering adequate stopping power due to it's still powerful cartridge while at the same time having a rather respectable firing rate due to it's mechanism. It is very probable this is a replica instead of a museum piece, but rifles of this pattern still see usage as colonist guns in some far off regions. Uses 7.62mm rounds."
	item_state = "levercarbine"
	icon_state = "levercarbine"
	pump_animation = "levercarbine-cycling"
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
