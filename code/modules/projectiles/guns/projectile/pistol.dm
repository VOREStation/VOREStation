/obj/item/weapon/gun/projectile/colt
	var/unique_reskin
	name = ".45 pistol"
	desc = "A cheap Martian knock-off of a Colt M1911. Uses .45 rounds."
	magazine_type = /obj/item/ammo_magazine/m45
	allowed_magazines = list(/obj/item/ammo_magazine/m45)
	icon_state = "colt"
	caliber = ".45"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	fire_sound = 'sound/weapons/semiauto.ogg'
	load_method = MAGAZINE

/obj/item/weapon/gun/projectile/colt/detective
	desc = "A Martian recreation of an old Terran pistol. Uses .45 rounds."
	magazine_type = /obj/item/ammo_magazine/m45/rubber

/obj/item/weapon/gun/projectile/colt/detective/update_icon()
	if(ammo_magazine)
		if(unique_reskin)
			icon_state = unique_reskin
		else
			icon_state = initial(icon_state)
	else
		if(unique_reskin)
			icon_state = "[unique_reskin]-e"
		else
			icon_state = "[initial(icon_state)]-e"

/obj/item/weapon/gun/projectile/colt/detective/verb/rename_gun()
	set name = "Name Gun"
	set category = "Object"
	set desc = "Rename your gun. If you're Security."

	var/mob/M = usr
	if(!M.mind)	return 0
	var/job = M.mind.assigned_role
	if(job != "Detective" && job != "Security Officer" && job != "Warden" && job != "Head of Security")
		M << "<span class='notice'>You don't feel cool enough to name this gun, chump.</span>"
		return 0

	var/input = sanitizeSafe(input("What do you want to name the gun?", ,""), MAX_NAME_LEN)

	if(src && input && !M.stat && in_range(M,src))
		name = input
		M << "You name the gun [input]. Say hello to your new friend."
		return 1

/obj/item/weapon/gun/projectile/colt/detective/verb/reskin_gun()
	set name = "Resprite gun"
	set category = "Object"
	set desc = "Click to choose a sprite for your gun."

	var/mob/M = usr
	var/list/options = list()
	options["NT Mk. 58"] = "secguncomp"
	options["NT Mk. 58 Custom"] = "secgundark"
	options["Colt M1911"] = "colt"
	options["FiveSeven"] = "fnseven"
	options["USP"] = "usp"
	options["H&K VP"] = "VP78"
	options["P08 Luger"] = "p08"
	options["P08 Luger, Brown"] = "p08b"
	var/choice = input(M,"What do you want the gun's sprite to be?","Resprite Gun") in options
	if(src && choice && !M.stat && in_range(M,src))
		icon_state = options[choice]
		unique_reskin = options[choice]
		M << "Your gun is now sprited as [choice]. Say hello to your new friend."
		return 1

/obj/item/weapon/gun/projectile/sec
	name = ".45 pistol"
	desc = "The NT Mk58 is a cheap, ubiquitous sidearm, produced by a NanoTrasen subsidiary. Found pretty much everywhere humans are. Uses .45 rounds."
	icon_state = "secguncomp"
	magazine_type = /obj/item/ammo_magazine/m45/rubber
	caliber = ".45"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	fire_sound = 'sound/weapons/semiauto.ogg'
	load_method = MAGAZINE

/obj/item/weapon/gun/projectile/sec/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "secguncomp"
	else
		icon_state = "secguncomp-e"

/obj/item/weapon/gun/projectile/sec/flash
	name = ".45 signal pistol"
	magazine_type = /obj/item/ammo_magazine/m45/flash

/obj/item/weapon/gun/projectile/sec/wood
	desc = "The NT Mk58 is a cheap, ubiquitous sidearm, produced by a NanoTrasen subsidiary. This one has a sweet wooden grip. Uses .45 rounds."
	name = "custom .45 Pistol"
	icon_state = "secgundark"

/obj/item/weapon/gun/projectile/sec/wood/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "secgundark"
	else
		icon_state = "secgundark-e"

/obj/item/weapon/gun/projectile/silenced
	name = "silenced pistol"
	desc = "A small, quiet,  easily concealable gun. Uses .45 rounds."
	icon_state = "silenced_pistol"
	w_class = ITEMSIZE_NORMAL
	caliber = ".45"
	silenced = 1
	fire_delay = 1
	recoil = 0
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ILLEGAL = 8)
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m45
	allowed_magazines = list(/obj/item/ammo_magazine/m45)

/obj/item/weapon/gun/projectile/deagle
	name = "desert eagle"
	desc = "The perfect handgun for shooters with a need to hit targets through a wall and behind a fridge in your neighbor's house. Uses .44 rounds."
	icon_state = "deagle"
	item_state = "deagle"
	force = 14.0
	caliber = ".44"
	load_method = MAGAZINE
	fire_sound = 'sound/weapons/deagle.ogg'
	magazine_type = /obj/item/ammo_magazine/m44
	allowed_magazines = list(/obj/item/ammo_magazine/m44)

/obj/item/weapon/gun/projectile/deagle/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "[initial(icon_state)]"
	else
		icon_state = "[initial(icon_state)]-e"

/obj/item/weapon/gun/projectile/deagle/gold
	desc = "A gold plated gun folded over a million times by superior martian gunsmiths. Uses .44 rounds."
	icon_state = "deagleg"
	item_state = "deagleg"

/obj/item/weapon/gun/projectile/deagle/camo
	desc = "A Deagle brand Deagle for operators operating operationally. Uses .44 rounds."
	icon_state = "deaglecamo"
	item_state = "deagleg"

/*
/obj/item/weapon/gun/projectile/fiveseven
	name = "\improper WT-AP57"
	desc = "This tacticool pistol made by Ward-Takahashi trades stopping power for armor piercing and a high capacity. Uses 5mm rounds."
	icon_state = "fnseven"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	caliber = "5mm"
	load_method = MAGAZINE
	fire_sound = 'sound/weapons/semiauto.ogg'
	magazine_type = /obj/item/ammo_magazine/c5mm
	allowed_magazines = list(/obj/item/ammo_magazine/c5mm)

/obj/item/weapon/gun/projectile/fiveseven/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "fnseven"
	else
		icon_state = "fnseven-empty"
*/

/obj/item/weapon/gun/projectile/gyropistol // Does this even appear anywhere outside of admin abuse?
	name = "gyrojet pistol"
	desc = "Speak softly, and carry a big gun. Fires rare .75 caliber self-propelled exploding bolts--because fuck you and everything around you."
	icon_state = "gyropistol"
	max_shells = 8
	caliber = ".75"
	fire_sound = 'sound/weapons/rpg.ogg'
	origin_tech = list(TECH_COMBAT = 3)
	ammo_type = "/obj/item/ammo_casing/a75"
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m75
	allowed_magazines = list(/obj/item/ammo_magazine/m75)
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'

/obj/item/weapon/gun/projectile/gyropistol/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "gyropistolloaded"
	else
		icon_state = "gyropistol"

/obj/item/weapon/gun/projectile/pistol
	name = "holdout pistol"
	desc = "The Lumoco Arms P3 Whisper. A small, easily concealable gun. Uses 9mm rounds."
	icon_state = "pistol"
	item_state = null
	w_class = ITEMSIZE_SMALL
	caliber = "9mm"
	silenced = 0
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ILLEGAL = 2)
	fire_sound = 'sound/weapons/semiauto.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m9mm
	allowed_magazines = list(/obj/item/ammo_magazine/m9mm)

/obj/item/weapon/gun/projectile/pistol/flash
	name = "holdout signal pistol"
	magazine_type = /obj/item/ammo_magazine/m9mm/flash

/obj/item/weapon/gun/projectile/pistol/attack_hand(mob/living/user as mob)
	if(user.get_inactive_hand() == src)
		if(silenced)
			if(!user.item_is_in_hands(src))
				..()
				return
			user << "<span class='notice'>You unscrew [silenced] from [src].</span>"
			user.put_in_hands(silenced)
			silenced = 0
			w_class = ITEMSIZE_SMALL
			update_icon()
			return
	..()

/obj/item/weapon/gun/projectile/pistol/attackby(obj/item/I as obj, mob/living/user as mob)
	if(istype(I, /obj/item/weapon/silencer))
		if(!user.item_is_in_hands(src))	//if we're not in his hands
			user << "<span class='notice'>You'll need [src] in your hands to do that.</span>"
			return
		user.drop_item()
		user << "<span class='notice'>You screw [I] onto [src].</span>"
		silenced = I	//dodgy?
		w_class = ITEMSIZE_NORMAL
		I.loc = src		//put the silencer into the gun
		update_icon()
		return
	..()

/obj/item/weapon/gun/projectile/pistol/update_icon()
	..()
	if(silenced)
		icon_state = "pistol-silencer"
	else
		icon_state = "pistol"

/obj/item/weapon/silencer
	name = "silencer"
	desc = "a silencer"
	icon = 'icons/obj/gun.dmi'
	icon_state = "silencer"
	w_class = ITEMSIZE_SMALL

/obj/item/weapon/gun/projectile/pirate
	name = "zip gun"
	desc = "Little more than a barrel, handle, and firing mechanism, cheap makeshift firearms like this one are not uncommon in frontier systems."
	icon_state = "sawnshotgun"
	item_state = "sawnshotgun"
	handle_casings = CYCLE_CASINGS //player has to take the old casing out manually before reloading
	load_method = SINGLE_CASING
	max_shells = 1 //literally just a barrel

	var/global/list/ammo_types = list(
		/obj/item/ammo_casing/a357              = ".357",
		/obj/item/ammo_casing/a9mmf             = "9mm",
		/obj/item/ammo_casing/a45f              = ".45",
		/obj/item/ammo_casing/a10mm             = "10mm",
		/obj/item/ammo_casing/a12g              = "12g",
		/obj/item/ammo_casing/a12g              = "12g",
		/obj/item/ammo_casing/a12g/pellet       = "12g",
		/obj/item/ammo_casing/a12g/pellet       = "12g",
		/obj/item/ammo_casing/a12g/pellet       = "12g",
		/obj/item/ammo_casing/a12g/beanbag      = "12g",
		/obj/item/ammo_casing/a12g/stunshell    = "12g",
		/obj/item/ammo_casing/a12g/flash        = "12g",
		/obj/item/ammo_casing/a762              = "7.62mm",
		/obj/item/ammo_casing/a556              = "5.56mm"
		)

/obj/item/weapon/gun/projectile/pirate/New()
	ammo_type = pick(ammo_types)
	desc += " Uses [ammo_types[ammo_type]] rounds."

	var/obj/item/ammo_casing/ammo = ammo_type
	caliber = initial(ammo.caliber)
	..()

/obj/item/weapon/gun/projectile/derringer
	name = "derringer"
	desc = "It's not size of your gun that matters, just the size of your load. Uses .357 rounds." //OHHH MYYY~
	icon_state = "derringer"
	item_state = "concealed"
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ILLEGAL = 3)
	handle_casings = CYCLE_CASINGS //player has to take the old casing out manually before reloading
	load_method = SINGLE_CASING
	max_shells = 2
	ammo_type = /obj/item/ammo_casing/a357

/obj/item/weapon/gun/projectile/luger
	name = "\improper P08 Luger"
	desc = "Not some cheap Scheisse .45 caliber Martian knockoff! This Luger is an authentic reproduction by RauMauser. Accuracy, easy handling, and its signature appearance make it popular among historic gun collectors. Uses 9mm rounds."
	icon_state = "p08"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	caliber = "9mm"
	load_method = MAGAZINE
	fire_sound = 'sound/weapons/semiauto.ogg'
	magazine_type = /obj/item/ammo_magazine/m9mm
	allowed_magazines = list(/obj/item/ammo_magazine/m9mm)

/obj/item/weapon/gun/projectile/luger/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "[initial(icon_state)]"
	else
		icon_state = "[initial(icon_state)]-e"

/obj/item/weapon/gun/projectile/luger/brown
	icon_state = "p08b"