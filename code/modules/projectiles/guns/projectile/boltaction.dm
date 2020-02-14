// For all intents and purposes, these work exactly the same as pump shotguns. It's unnecessary to make their own procs for them.

/obj/item/weapon/gun/projectile/shotgun/pump/rifle
	name = "bolt action rifle"
	desc = "A reproduction of an almost ancient weapon design from the early 20th century. It's still popular among hunters and collectors due to its reliability. Uses 7.62mm rounds."
	item_state = "boltaction"
	icon_state = "boltaction"
	fire_sound = 'sound/weapons/Gunshot_generic_rifle.ogg'
	max_shells = 5
	caliber = "7.62mm"
	origin_tech = list(TECH_COMBAT = 1)// Old as shit rifle doesn't have very good tech.
	ammo_type = /obj/item/ammo_casing/a762
	load_method = SINGLE_CASING|SPEEDLOADER
	action_sound = 'sound/weapons/riflebolt.ogg'

/obj/item/weapon/gun/projectile/shotgun/pump/rifle/practice // For target practice
	desc = "A bolt-action rifle with a lightweight synthetic wood stock, designed for competitive shooting. Comes shipped with practice rounds pre-loaded into the gun. Popular among professional marksmen. Uses 7.62mm rounds."
	ammo_type = /obj/item/ammo_casing/a762/practice

/obj/item/weapon/gun/projectile/shotgun/pump/rifle/ceremonial
	name = "ceremonial bolt-action rifle"
	desc = "A bolt-action rifle with a heavy, high-quality wood stock that has a beautiful finish. Clearly not intended to be used in combat. Uses 7.62mm rounds."
	icon_state = "boltaction_c"
	item_state = "boltaction_c"
	ammo_type = /obj/item/ammo_casing/a762/blank

// Stole hacky terrible code from doublebarrel shotgun. -Spades
/obj/item/weapon/gun/projectile/shotgun/pump/rifle/ceremonial/attackby(var/obj/item/A as obj, mob/user as mob)
	if(istype(A, /obj/item/weapon/surgical/circular_saw) || istype(A, /obj/item/weapon/melee/energy) || istype(A, /obj/item/weapon/pickaxe/plasmacutter) && w_class != ITEMSIZE_NORMAL)
		to_chat(user, "<span class='notice'>You begin to shorten the barrel and stock of \the [src].</span>")
		if(loaded.len)
			afterattack(user, user)
			playsound(user, fire_sound, 50, 1)
			user.visible_message("<span class='danger'>[src] goes off!</span>", "<span class='danger'>The rifle goes off in your face!</span>")
			return
		if(do_after(user, 30))
			icon_state = "sawnrifle"
			w_class = ITEMSIZE_NORMAL
			recoil = 2 // Owch
			accuracy = -15 // You know damn well why.
			item_state = "gun"
			slot_flags &= ~SLOT_BACK	//you can't sling it on your back
			slot_flags |= (SLOT_BELT|SLOT_HOLSTER) //but you can wear it on your belt (poorly concealed under a trenchcoat, ideally) - or in a holster, why not.
			name = "sawn-off rifle"
			desc = "The firepower of a rifle, now the size of a pistol, with an effective combat range of about three feet. Uses 7.62mm rounds."
			to_chat(user, "<span class='warning'>You shorten the barrel and stock of \the [src]!</span>")
	else
		..()

//Lever actions are the same thing, but bigger.
/obj/item/weapon/gun/projectile/shotgun/pump/rifle/lever
	name = "lever-action rifle"
	desc = "A reproduction of an almost ancient weapon design from the 19th century. This one uses a lever-action to move new rounds into the chamber. Uses 7.62mm rounds."
	item_state = "leveraction"
	icon_state = "leveraction"
	max_shells = 5
	caliber = "7.62mm"
	load_method = SINGLE_CASING

/obj/item/weapon/gun/projectile/shotgun/pump/rifle/lever/vintage
	name = "vintage repeater"
	desc = "An iconic manually operated lever action rifle, offering adequate stopping power due to it's still powerful cartridge while at the same time having a rather respectable firing rate due to it's mechanism. It is very probable this is a replica instead of a museum piece, but rifles of this pattern still see usage as colonist guns in some far off regions. Uses 7.62mm rounds."
	item_state = "levercarabine" // That isn't how carbine is spelled ya knob! :U
	icon_state = "levercarabine"
	animated_pump = 1
