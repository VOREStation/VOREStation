/obj/item/projectile/bullet/chemdart
	name = "dart"
	icon_state = "dart"
	damage = 5
	var/reagent_amount = 15
	range = 15 //shorter range

	muzzle_type = null

/obj/item/projectile/bullet/chemdart/New()
	reagents = new/datum/reagents(reagent_amount)
	reagents.my_atom = src

/obj/item/projectile/bullet/chemdart/on_hit(var/atom/target, var/blocked = 0, var/def_zone = null)
	if(blocked < 2 && isliving(target))
		var/mob/living/L = target
		if(L.can_inject(target_zone=def_zone))
			reagents.trans_to_mob(L, reagent_amount, CHEM_BLOOD)

/obj/item/ammo_casing/chemdart
	name = "chemical dart"
	desc = "A casing containing a small hardened, hollow dart."
	icon_state = "dartcasing"
	caliber = "dart"
	projectile_type = /obj/item/projectile/bullet/chemdart

/obj/item/ammo_casing/chemdart/expend()
	..()
	//qdel(src)		//Wasn't able to find the exact issue with the qdel-ing. Possibly because it was still being processed by the gun when this is called.

/obj/item/ammo_magazine/chemdart
	name = "dart cartridge"
	desc = "A rack of hollow darts."
	icon_state = "darts"
	item_state = "rcdammo"
	origin_tech = list(TECH_MATERIAL = 2)
	mag_type = MAGAZINE
	caliber = "dart"
	ammo_type = /obj/item/ammo_casing/chemdart
	max_ammo = 5
	multiple_sprites = 1

/obj/item/gun/projectile/dartgun
	name = "dart gun"
	desc = "Zeng-Hu Pharmaceutical's entry into the arms market, the Z-H P Artemis is a gas-powered dart gun capable of delivering chemical cocktails swiftly across short distances."
	description_info = "The dart gun is capable of storing three beakers. In order to use the dart gun, you must first use it in-hand to open its mixing UI. The dart-gun will only draw from beakers with mixing enabled. If multiple are enabled, the gun will draw from them in equal amounts."
	description_antag = "The dart gun is silenced, but cannot pierce thick clothing such as armor or space-suits, and thus is better for use against soft targets, or commonly exposed areas of the body."
	icon_state = "dartgun-empty"
	item_state = null
	var/base_state = "dartgun"
	origin_tech = list(TECH_COMBAT = 7, TECH_MATERIAL = 6, TECH_BIO = 5, TECH_MAGNET = 2, TECH_ILLEGAL = 3)

	caliber = "dart"
	fire_sound = 'sound/weapons/empty.ogg'
	fire_sound_text = "a metallic click"
	recoil = 0
	silenced = 1
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/chemdart
	allowed_magazines = list(/obj/item/ammo_magazine/chemdart)
	var/default_magazine_casing_count = 5
	var/track_magazine = 1
	auto_eject = 0

	var/list/beakers = list() //All containers inside the gun.
	var/list/mixing = list() //Containers being used for mixing.
	var/max_beakers = 3
	var/dart_reagent_amount = 15
	var/container_type = /obj/item/reagent_containers/glass/beaker
	var/list/starting_chems = null

<<<<<<< HEAD
/obj/item/weapon/gun/projectile/dartgun/New()
	..()
=======
/obj/item/gun/projectile/dartgun/Initialize()
	. = ..()
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	if(starting_chems)
		for(var/chem in starting_chems)
			var/obj/B = new container_type(src)
			B.reagents.add_reagent(chem, 60)
			beakers += B
	update_icon()

/obj/item/gun/projectile/dartgun/update_icon()
	if(!ammo_magazine)
		icon_state = "[base_state]-empty"
		return 1
	if(track_magazine)
		if(!ammo_magazine.stored_ammo || ammo_magazine.stored_ammo.len == 0)
			icon_state = "[base_state]-0"
		else if(ammo_magazine.stored_ammo.len > default_magazine_casing_count)
			icon_state = "[base_state]-[default_magazine_casing_count]"
		else
			icon_state = "[base_state]-[ammo_magazine.stored_ammo.len]"
		return 1
	else
		icon_state = "[base_state]"

/obj/item/gun/projectile/dartgun/consume_next_projectile()
	. = ..()
	var/obj/item/projectile/bullet/chemdart/dart = .
	if(istype(dart))
		fill_dart(dart)

/obj/item/gun/projectile/dartgun/examine(mob/user)
	. = ..()
	if(beakers.len)
		. += "<span class='notice'>[src] contains:</span>"
		for(var/obj/item/reagent_containers/glass/beaker/B in beakers)
			if(B.reagents && B.reagents.reagent_list.len)
				for(var/datum/reagent/R in B.reagents.reagent_list)
					. += "<span class='notice'>[R.volume] units of [R.name]</span>"

/obj/item/gun/projectile/dartgun/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/reagent_containers/glass))
		if(!istype(I, container_type))
			to_chat(user, "<font color='blue'>[I] doesn't seem to fit into [src].</font>")
			return
		if(beakers.len >= max_beakers)
			to_chat(user, "<font color='blue'>[src] already has [max_beakers] beakers in it - another one isn't going to fit!</font>")
			return
		var/obj/item/reagent_containers/glass/beaker/B = I
		user.drop_item()
		B.loc = src
		beakers += B
		to_chat(user, "<font color='blue'>You slot [B] into [src].</font>")
		src.updateUsrDialog()
		return 1
	..()

//fills the given dart with reagents
/obj/item/gun/projectile/dartgun/proc/fill_dart(var/obj/item/projectile/bullet/chemdart/dart)
	if(mixing.len)
		var/mix_amount = dart.reagent_amount/mixing.len
		for(var/obj/item/reagent_containers/glass/beaker/B in mixing)
			B.reagents.trans_to_obj(dart, mix_amount)

/obj/item/gun/projectile/dartgun/attack_self(mob/user)
	user.set_machine(src)
	var/dat = "<b>[src] mixing control:</b><br><br>"

	if (beakers.len)
		var/i = 1
		for(var/obj/item/reagent_containers/glass/beaker/B in beakers)
			dat += "Beaker [i] contains: "
			if(B.reagents && B.reagents.reagent_list.len)
				for(var/datum/reagent/R in B.reagents.reagent_list)
					dat += "<br>    [R.volume] units of [R.name], "
				if (check_beaker_mixing(B))
					dat += text("<A href='?src=\ref[src];stop_mix=[i]'><font color='green'>Mixing</font></A> ")
				else
					dat += text("<A href='?src=\ref[src];mix=[i]'><font color='red'>Not mixing</font></A> ")
			else
				dat += "nothing."
			dat += " \[<A href='?src=\ref[src];eject=[i]'>Eject</A>\]<br>"
			i++
	else
		dat += "There are no beakers inserted!<br><br>"

	if(ammo_magazine)
		if(ammo_magazine.stored_ammo && ammo_magazine.stored_ammo.len)
			dat += "The dart cartridge has [ammo_magazine.stored_ammo.len] shots remaining."
		else
			dat += "<font color='red'>The dart cartridge is empty!</font>"
		dat += " \[<A href='?src=\ref[src];eject_cart=1'>Eject</A>\]"

	user << browse(dat, "window=dartgun")
	onclose(user, "dartgun", src)

/obj/item/gun/projectile/dartgun/proc/check_beaker_mixing(var/obj/item/B)
	if(!mixing || !beakers)
		return 0
	for(var/obj/item/M in mixing)
		if(M == B)
			return 1
	return 0

/obj/item/gun/projectile/dartgun/Topic(href, href_list)
	if(..()) return 1
	src.add_fingerprint(usr)
	if(href_list["stop_mix"])
		var/index = text2num(href_list["stop_mix"])
		if(index <= beakers.len)
			for(var/obj/item/M in mixing)
				if(M == beakers[index])
					mixing -= M
					break
	else if (href_list["mix"])
		var/index = text2num(href_list["mix"])
		if(index <= beakers.len)
			mixing += beakers[index]
	else if (href_list["eject"])
		var/index = text2num(href_list["eject"])
		if(index <= beakers.len)
			if(beakers[index])
				var/obj/item/reagent_containers/glass/beaker/B = beakers[index]
				to_chat(usr, "You remove [B] from [src].")
				mixing -= B
				beakers -= B
				B.loc = get_turf(src)
	else if (href_list["eject_cart"])
		unload_ammo(usr)
	src.updateUsrDialog()
	return

///Variants of the Dartgun and Chemdarts.///

/obj/item/gun/projectile/dartgun/research
	name = "prototype dart gun"
	desc = "Zeng-Hu Pharmaceutical's entry into the arms market, the Z-H P Artemis is a gas-powered dart gun capable of delivering chemical cocktails swiftly across short distances. This one seems to be an early model with an NT stamp."
	description_info = "The dart gun is capable of storing two beakers. In order to use the dart gun, you must first use it in-hand to open its mixing UI. The dart-gun will only draw from beakers with mixing enabled. If multiple are enabled, the gun will draw from them in equal amounts."
	icon_state = "dartgun_sci-empty"
	base_state = "dartgun_sci"
	magazine_type = /obj/item/ammo_magazine/chemdart/small
	allowed_magazines = list(/obj/item/ammo_magazine/chemdart)
	default_magazine_casing_count = 3
	max_beakers = 2
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 4, TECH_BIO = 4, TECH_MAGNET = 2, TECH_ILLEGAL = 1)

/obj/item/ammo_casing/chemdart/small
	name = "short chemical dart"
	desc = "A casing containing a small hardened, hollow dart."
	icon_state = "dartcasing"
	caliber = "dart"
	projectile_type = /obj/item/projectile/bullet/chemdart/small

/obj/item/ammo_magazine/chemdart/small
	name = "small dart cartridge"
	desc = "A rack of hollow darts."
	icon_state = "darts_small"
	item_state = "rcdammo"
	origin_tech = list(TECH_MATERIAL = 2)
	mag_type = MAGAZINE
	caliber = "dart"
	ammo_type = /obj/item/ammo_casing/chemdart/small
	max_ammo = 3
	multiple_sprites = 1

/obj/item/projectile/bullet/chemdart/small
	reagent_amount = 10
