/*
 * M1911
 */
/obj/item/weapon/gun/projectile/colt
	var/unique_reskin
	name = ".45 pistol"
	desc = "A typical modern handgun produced for law enforcement. Uses .45 rounds."
	magazine_type = /obj/item/ammo_magazine/m45
	allowed_magazines = list(/obj/item/ammo_magazine/m45)
	projectile_type = /obj/item/projectile/bullet/pistol/medium
	icon_state = "colt"
	caliber = ".45"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	load_method = MAGAZINE

/obj/item/weapon/gun/projectile/colt/update_icon()
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

/*
 * Detective M1911
 */
/obj/item/weapon/gun/projectile/colt/detective
	desc = "A standard law enforcement issue pistol. Uses .45 rounds."
	magazine_type = /obj/item/ammo_magazine/m45/rubber

/obj/item/weapon/gun/projectile/colt/detective/verb/rename_gun()
	set name = "Name Gun"
	set category = "Object"
	set desc = "Rename your gun. If you're Security."

	var/mob/M = usr
	if(!M.mind)	return 0
	var/job = M.mind.assigned_role
	if(job != "Detective" && job != "Security Officer" && job != "Warden" && job != "Head of Security")
		to_chat(M, "<span class='notice'>You don't feel cool enough to name this gun, chump.</span>")
		return 0

	var/input = sanitizeSafe(input(usr, "What do you want to name the gun?", ,""), MAX_NAME_LEN)

	if(src && input && !M.stat && in_range(M,src))
		name = input
		to_chat(M, "You name the gun [input]. Say hello to your new friend.")
		return 1

/obj/item/weapon/gun/projectile/colt/detective/verb/reskin_gun()
	set name = "Resprite gun"
	set category = "Object"
	set desc = "Click to choose a sprite for your gun."

	var/mob/M = usr
	var/list/options = list()
	options["MarsTech P11 Spur (Bubba'd)"] = "mod_colt"
	options["MarsTech P11 Spur (Blued)"] = "blued_colt"
	options["MarsTech P11 Spur (Gold)"] = "gold_colt"
	options["MarsTech P11 Spur (Stainless)"] = "stainless_colt"
	options["MarsTech P11 Spur (Dark)"] = "dark_colt"
	options["MarsTech P11 Spur (Green)"] = "green_colt"
	options["MarsTech P11 Spur (Blue)"] = "blue_colt"
	var/choice = tgui_input_list(M,"Choose your sprite!","Resprite Gun", options)
	if(src && choice && !M.stat && in_range(M,src))
		icon_state = options[choice]
		unique_reskin = options[choice]
		to_chat(M, "Your gun is now sprited as [choice]. Say hello to your new friend.")
		return 1

/*//apart of reskins that have two sprites, touching may result in frustration and breaks
/obj/item/weapon/gun/projectile/colt/detective/attack_hand(var/mob/living/user)
	if(!unique_reskin && loc == user)
		reskin_gun(user)
		return
	..()
*/

/*
 * Security Sidearm
 */
/obj/item/weapon/gun/projectile/sec
	name = ".45 pistol"
	desc = "The MT Mk58 is a cheap, ubiquitous sidearm, produced by MarsTech. Found pretty much everywhere humans are. Uses .45 rounds."
	description_fluff = "The leading civilian-sector high-quality small arms brand of Hephaestus Industries, \
	MarsTech has been the provider of choice for law enforcement and security forces for over 300 years."
	icon_state = "secgun"
	magazine_type = /obj/item/ammo_magazine/m45/rubber
	allowed_magazines = list(/obj/item/ammo_magazine/m45)
	projectile_type = /obj/item/projectile/bullet/pistol/medium
	caliber = ".45"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	load_method = MAGAZINE

/obj/item/weapon/gun/projectile/sec/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "secgun"
	else
		icon_state = "secgun-e"

/obj/item/weapon/gun/projectile/sec/flash
	name = ".45 signal pistol"
	magazine_type = /obj/item/ammo_magazine/m45/flash

/obj/item/weapon/gun/projectile/sec/wood
	desc = "The MT Mk58 is a cheap, ubiquitous sidearm, produced by MarsTech. This one has a sweet wooden grip. Uses .45 rounds."
	name = "custom .45 Pistol"
	icon_state = "secgunb"

/obj/item/weapon/gun/projectile/sec/wood/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "secgunb"
	else
		icon_state = "secgunb-e"

/*
 * Silenced Pistol
 */
/obj/item/weapon/gun/projectile/silenced
	name = "silenced pistol"
	desc = "A small, quiet, easily concealable gun with a built-in silencer. Uses .45 rounds."
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
	projectile_type = /obj/item/projectile/bullet/pistol/medium

/obj/item/weapon/gun/projectile/silenced/empty
	magazine_type = null

/*
 * Deagle
 */
/obj/item/weapon/gun/projectile/deagle
	name = "hand cannon"
	desc = "The PCA-55 Rarkajar perfect handgun for shooters with a need to hit targets through a wall and behind a fridge in your neighbor's house. Uses .44 rounds."
	description_fluff = "Pearlshield Consolidated Armories are far from the most cutting edge firearm manufacturer, but the Tajaran’s long tradition of war is rivaled only by humanity, \
	and the introduction of human technology to the Tajaran arms market has resulted in something of a revolution in finding new ways to kill each other at long distances with bullets. \
	Usually made with mass-production in mind, PCA weapons combine an eye for design with a great desire to make people dead."
	icon_state = "deagle"
	item_state = "deagle"
	force = 14.0
	caliber = ".44"
	fire_sound = 'sound/weapons/Gunshot_deagle.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m44
	allowed_magazines = list(/obj/item/ammo_magazine/m44)

/obj/item/weapon/gun/projectile/deagle/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "[initial(icon_state)]"
	else
		icon_state = "[initial(icon_state)]-e"

/obj/item/weapon/gun/projectile/deagle/gold
	desc = "A gold plated gun folded over a million times by superior Tajaran gunsmiths. Uses .44 rounds."
	icon_state = "deagleg"
	item_state = "deagleg"

/obj/item/weapon/gun/projectile/deagle/camo
	desc = "An off-brand non-Deagle for operators not operating operationally. Uses .44 rounds."
	icon_state = "deaglecamo"
	item_state = "deagleg"

/*
 * Gyro Pistol (Admin Abuse in gun form)
 */
/obj/item/weapon/gun/projectile/gyropistol // Does this even appear anywhere outside of admin abuse?
	name = "gyrojet pistol"
	desc = "Speak softly, and carry a big gun. Fires rare .75 caliber self-propelled exploding bolts--because fuck you and everything around you."
	icon_state = "gyropistol"
	max_shells = 8
	caliber = ".75"
	fire_sound = 'sound/weapons/railgun.ogg'
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

/*
 * Compact Pistol
 */
/obj/item/weapon/gun/projectile/pistol
	name = "compact pistol"
	desc = "The Lumoco Arms P3 Whisper. A compact, easily concealable gun, though it's only compatible with compact magazines. Uses 9mm rounds."
	icon_state = "pistol"
	item_state = null
	w_class = ITEMSIZE_SMALL
	caliber = "9mm"
	silenced = 0
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ILLEGAL = 2)
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m9mm/compact
	allowed_magazines = list(/obj/item/ammo_magazine/m9mm/compact)
	projectile_type = /obj/item/projectile/bullet/pistol

/obj/item/weapon/gun/projectile/pistol/flash
	name = "compact signal pistol"
	magazine_type = /obj/item/ammo_magazine/m9mm/compact/flash

/obj/item/weapon/gun/projectile/pistol/attack_hand(mob/living/user as mob)
	if(user.get_inactive_hand() == src)
		if(silenced)
			if(!user.item_is_in_hands(src))
				..()
				return
			to_chat(user, "<span class='notice'>You unscrew [silenced] from [src].</span>")
			user.put_in_hands(silenced)
			silenced = 0
			w_class = ITEMSIZE_SMALL
			update_icon()
			return
	..()

/obj/item/weapon/gun/projectile/pistol/attackby(obj/item/I as obj, mob/living/user as mob)
	if(istype(I, /obj/item/weapon/silencer))
		if(!user.item_is_in_hands(src))	//if we're not in his hands
			to_chat(user, "<span class='notice'>You'll need [src] in your hands to do that.</span>")
			return
		user.drop_item()
		to_chat(user, "<span class='notice'>You screw [I] onto [src].</span>")
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

/*
 * Silencer
 */
/obj/item/weapon/silencer
	name = "silencer"
	desc = "a silencer"
	icon = 'icons/obj/gun.dmi'
	icon_state = "silencer"
	w_class = ITEMSIZE_SMALL

/*
 * Zip Gun (yar har)
 */
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
		/obj/item/ammo_casing/a9mm		        = "9mm",
		/obj/item/ammo_casing/a45				= ".45",
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
		/obj/item/ammo_casing/a545              = "5.45mm"
		)

/obj/item/weapon/gun/projectile/pirate/Initialize()
	ammo_type = pick(ammo_types)
	desc += " Uses [ammo_types[ammo_type]] rounds."

	var/obj/item/ammo_casing/ammo = ammo_type
	caliber = initial(ammo.caliber)
	. = ..()

/*
 * Derringer
 */
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
	projectile_type = /obj/item/projectile/bullet/pistol/strong

/*
 * Luger
 */
/obj/item/weapon/gun/projectile/luger
	name = "\improper Jindal T15 Chooha"
	desc = "Almost seventy percent guaranteed not to be a cheap rimworld knockoff! Accuracy, easy handling, and its distinctive appearance make it popular among gun collectors. Uses 9mm rounds."
	description_fluff = "While Jindal’s rugged, affordable weapons intended for the colonial sector are a major export of Tau Ceti, \
	the Jindal Arms company is perhaps best known for its liberal sale of production licenses to just about any fledgling rimworld venture who asks, and has cash to spare. \
	While Jindal’s 'authentic' Binma-built weapons are renowned for their reliability, the same cannot be said for the hundreds of low-grade (But technically legal) \
	copies circulating the squalid habitats and smoke-filled junk ships of the frontier."
	icon_state = "p08"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	caliber = "9mm"
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m9mm/compact
	allowed_magazines = list(/obj/item/ammo_magazine/m9mm/compact)
	projectile_type = /obj/item/projectile/bullet/pistol

/obj/item/weapon/gun/projectile/luger/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "[initial(icon_state)]"
	else
		icon_state = "[initial(icon_state)]-e"

/obj/item/weapon/gun/projectile/luger/brown
	name = "\improper Jindal KP-45W"
	description_fluff = "While wholly owned by Hephaestus Industries, the Jindal Arms brand does not appear prominently in most company catalogues \
	(Perhaps owing to its less than prestigious image), instead being sold almost exclusively through retailers and advertising platforms targeting the 'independent roughneck' demographic."
	icon_state = "p08b"

/*
 * P92X (9mm Pistol)
 */
/obj/item/weapon/gun/projectile/p92x
	name = "9mm pistol"
	desc = "A widespread MarsTech sidearm called the P92X which is used by military, police, and security forces across the galaxy. Uses 9mm rounds."
	icon_state = "p92x"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	caliber = "9mm"
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m9mm
	allowed_magazines = list(/obj/item/ammo_magazine/m9mm) // Can accept illegal large capacity magazines, or compact magazines.

/obj/item/weapon/gun/projectile/p92x/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "[initial(icon_state)]"
	else
		icon_state = "[initial(icon_state)]-e"

/obj/item/weapon/gun/projectile/p92x/rubber
	magazine_type = /obj/item/ammo_magazine/m9mm/rubber

/obj/item/weapon/gun/projectile/p92x/brown
	icon_state = "p92xb"

/obj/item/weapon/gun/projectile/p92x/large
	magazine_type = /obj/item/ammo_magazine/m9mm/large // Spawns with illegal magazines.