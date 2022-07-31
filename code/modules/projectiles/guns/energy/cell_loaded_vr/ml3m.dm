// The Gun //
/obj/item/gun/projectile/cell_loaded/medical
	name = "cell-loaded medigun"
	desc = "The ML-3 'Medigun', or ML3M for short, is a powerful cell-based ranged healing device based on the KHI-102b NSFW. \
	It uses an internal nanite fabricator, powered and controlled by discrete cells, to deliver a variety of effects at range. Up to six combinations of \
	healing beams can be configured at once, depending on cartridge used. Ammo not included."
	catalogue_data = list(/datum/category_item/catalogue/information/organization/vey_med)

	icon_state = "ml3m"
	description_info = "This is a ranged healing device that uses interchangable nanite discharge cells in a magazine. Each cell is a different healing beam type, and up to three can be loaded in the magazine. Each battery usually provides four discharges of that beam type, and multiple from the same type may be loaded to increase the number of shots for that type."
	description_fluff = "The Vey-Med ML-3 'Medigun' allows one to customize their loadout in the field, or before deploying, to allow emergency response personnel to deliver a variety of ranged healing options."
	description_antag = ""
	origin_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 2, TECH_BIO = 5)
	allowed_magazines = list(/obj/item/ammo_magazine/cell_mag/medical)

/obj/item/gun/projectile/cell_loaded/medical/cmo
	name = "advanced cell-loaded medigun"
	desc = "This is a variation on the ML-3 'Medigun', a powerful cell-based ranged healing device based on the KHI-102b NSFW. \
	It has an extended sight for increased accuracy, and much more comfortable grip. Ammo not included."

	icon_state = "ml3m_cmo"



// The Magazine //
/obj/item/ammo_magazine/cell_mag/medical //medical
	name = "nanite magazine"
	desc = "A nanite fabrication magazine for the \'ML-3/M\'"
	catalogue_data = list(/datum/category_item/catalogue/information/organization/vey_med)
	description_info = "This magazine holds self-charging nanite fabricators to power the ML-3 'Medigun'. Up to three can be loaded at once, and each provides four shots of their respective healing type. Loading multiple of the same type will provide additional shots of that type. The batteries can be recharged in a normal recharger."
	ammo_type = /obj/item/ammo_casing/microbattery/medical
	icon_state = "ml3m_mag"
	origin_tech = list(TECH_MATERIAL = 3, TECH_BIO = 3)

/obj/item/ammo_magazine/cell_mag/medical/advanced
	name = "advanced nanite magazine"
	desc = "A nanite discharge cell for the \'ML-3/M\'. This one is a more advanced version which can hold six individual nanite discharge cells."
	max_ammo = 6
	x_offset = 3
	icon_state = "ml3m_mag_extended"
	origin_tech = list(TECH_MATERIAL = 5, TECH_BIO = 5)


// The Pack //
/obj/item/storage/secure/briefcase/ml3m_pack_med
	name = "\improper ML-3 \'Medigun\' kit"
	desc = "A storage case for a multi-purpose healing gun. Variety hour!"
	icon_state = "medbriefcase"
	w_class = ITEMSIZE_NORMAL
	max_w_class = ITEMSIZE_NORMAL
	can_hold = list(/obj/item/gun/projectile/cell_loaded/medical,/obj/item/ammo_magazine/cell_mag/medical,/obj/item/ammo_casing/microbattery/medical)

/obj/item/storage/secure/briefcase/ml3m_pack_med/Initialize()
	. = ..()
	new /obj/item/gun/projectile/cell_loaded/medical(src)
	new /obj/item/ammo_magazine/cell_mag/medical(src)
	new /obj/item/ammo_casing/microbattery/medical/brute(src)
	new /obj/item/ammo_casing/microbattery/medical/burn(src)
	new /obj/item/ammo_casing/microbattery/medical/stabilize(src)

/obj/item/storage/secure/briefcase/ml3m_pack_cmo
	name = "\improper Advanced ML-3 \'Medigun\' kit"
	desc = "A storage case for a multi-purpose healing gun. Variety hour!"
	icon_state = "medbriefcase"
	w_class = ITEMSIZE_NORMAL
	max_w_class = ITEMSIZE_NORMAL
	can_hold = list(/obj/item/gun/projectile/cell_loaded/medical,/obj/item/ammo_magazine/cell_mag/medical,/obj/item/ammo_casing/microbattery/medical)

/obj/item/storage/secure/briefcase/ml3m_pack_cmo/Initialize()
	. = ..()
	new /obj/item/gun/projectile/cell_loaded/medical/cmo(src)
	new /obj/item/ammo_magazine/cell_mag/medical(src)
	new /obj/item/ammo_casing/microbattery/medical/brute(src)
	new /obj/item/ammo_casing/microbattery/medical/burn(src)
	new /obj/item/ammo_casing/microbattery/medical/stabilize(src)
	new /obj/item/ammo_casing/microbattery/medical/toxin(src)
	new /obj/item/ammo_casing/microbattery/medical/omni(src)
