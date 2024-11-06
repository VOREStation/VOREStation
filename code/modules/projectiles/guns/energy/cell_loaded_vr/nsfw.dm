// The Gun //
/obj/item/gun/projectile/cell_loaded/combat
	name = "cell-loaded revolver"
	desc = "Variety is the spice of life! The KHI-102b 'Nanotech Selectable-Fire Weapon', or NSFW for short, is an unholy hybrid of an ammo-driven  \
	energy weapon that allows the user to mix and match their own fire modes. Up to four combinations of \
	energy beams can be configured at once. Ammo not included."
	catalogue_data = list(/datum/category_item/catalogue/information/organization/khi)

	description_fluff = "The Kitsuhana 'Nanotech Selectable Fire Weapon' allows one to customize their loadout in the field, or before deploying, to achieve various results in a weapon they are already familiar with wielding."
	allowed_magazines = list(/obj/item/ammo_magazine/cell_mag/combat)

/obj/item/gun/projectile/cell_loaded/combat/prototype
	name = "prototype cell-loaded revolver"
	desc = "Variety is the spice of life! A prototype based on KHI-102b 'Nanotech Selectable-Fire Weapon', or NSFW for short, is an unholy hybrid of an ammo-driven  \
	energy weapon that allows the user to mix and match their own fire modes. Up to two combinations of \
	energy beams can be configured at once. Ammo not included."

	description_info = "This gun is an energy weapon that uses interchangable microbatteries in a magazine. Each battery is a different beam type, and up to three can be loaded in the magazine. Each battery usually provides four discharges of that beam type, and multiple from the same type may be loaded to increase the number of shots for that type."
	description_antag = ""
	allowed_magazines = list(/obj/item/ammo_magazine/cell_mag/combat/prototype)

	origin_tech = list(TECH_COMBAT = 7, TECH_MATERIAL = 4, TECH_MAGNET = 3)


// The Magazine //
/obj/item/ammo_magazine/cell_mag/combat
	name = "microbattery magazine"
	desc = "A microbattery holder for the \'NSFW\'"
	icon_state = "nsfw_mag"
	max_ammo = 4
	x_offset = 4
	catalogue_data = list(/datum/category_item/catalogue/information/organization/khi)
	description_info = "This magazine holds NSFW microbatteries to power the NSFW handgun. Up to three can be loaded at once, and each provides four shots of their respective energy type. Loading multiple of the same type will provide additional shots of that type. The batteries can be recharged in a normal recharger."
	ammo_type = /obj/item/ammo_casing/microbattery/combat

/obj/item/ammo_magazine/cell_mag/combat/prototype
	name = "prototype microbattery magazine"
	icon_state = "nsfw_mag_prototype"
	max_ammo = 2
	x_offset = 6
	catalogue_data = null
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_MAGNET = 2)


// The Pack //
/obj/item/storage/secure/briefcase/nsfw_pack
	name = "\improper KHI-102b \'NSFW\' gun kit"
	desc = "A storage case for a multi-purpose handgun. Variety hour!"
	w_class = ITEMSIZE_NORMAL
	max_w_class = ITEMSIZE_NORMAL
	can_hold = list(/obj/item/gun/projectile/cell_loaded/combat,/obj/item/ammo_magazine/cell_mag/combat,/obj/item/ammo_casing/microbattery/combat)

/obj/item/storage/secure/briefcase/nsfw_pack/New()
	..()
	new /obj/item/gun/projectile/cell_loaded/combat(src)
	new /obj/item/ammo_magazine/cell_mag/combat(src)
	for(var/path in subtypesof(/obj/item/ammo_casing/microbattery/combat))
		new path(src)

/obj/item/storage/secure/briefcase/nsfw_pack_hos
	name = "\improper KHI-102b \'NSFW\' gun kit"
	desc = "A storage case for a multi-purpose handgun. Variety hour!"
	w_class = ITEMSIZE_NORMAL
	max_w_class = ITEMSIZE_NORMAL
	can_hold = list(/obj/item/gun/projectile/cell_loaded/combat,/obj/item/ammo_magazine/cell_mag/combat,/obj/item/ammo_casing/microbattery/combat)

/obj/item/storage/secure/briefcase/nsfw_pack_hos/New()
	..()
	new /obj/item/gun/projectile/cell_loaded/combat(src)
	new /obj/item/ammo_magazine/cell_mag/combat(src)
	new /obj/item/ammo_casing/microbattery/combat/lethal(src)
	new /obj/item/ammo_casing/microbattery/combat/lethal(src)
	new /obj/item/ammo_casing/microbattery/combat/stun(src)
	new /obj/item/ammo_casing/microbattery/combat/stun(src)
	new /obj/item/ammo_casing/microbattery/combat/stun(src)
	new /obj/item/ammo_casing/microbattery/combat/net(src)
	new /obj/item/ammo_casing/microbattery/combat/ion(src)
