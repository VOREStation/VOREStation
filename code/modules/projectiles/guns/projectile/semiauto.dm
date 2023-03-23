/*
 * M1 Garand
 */
/obj/item/weapon/gun/projectile/garand
	name = "semi-automatic rifle"
	desc = "A vintage styled frontier rifle by Hedberg-Hammarstrom. The distinctive 'ping' is considered \
	traditional, though its origins are much debated. Uses 7.62mm rounds."
	description_fluff = "Sif’s largest home-grown firearms manufacturer, the Hedberg-Hammarstrom company offers a \
	range of high-quality, high-cost hunting rifles and shotguns designed with the Sivian wilderness - and its \
	wildlife - in mind. The company operates just one production plant in Kalmar, but their weapons have found \
	popularity on garden worlds as far afield as the Tajaran homeworld due to their excellent build quality, \
	precision, and stopping power."
	icon_state = "garand"
	item_state = "rifle"
	w_class = ITEMSIZE_LARGE
	caliber = "7.62mm"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	slot_flags = SLOT_BACK
	//fire_sound = 'sound/weapons/rifleshot.ogg'
	load_method = MAGAZINE // ToDo: Make it so MAGAZINE, SPEEDLOADER and SINGLE_CASING can all be used on the same gun.
	magazine_type = /obj/item/ammo_magazine/m762enbloc
	allowed_magazines = list(/obj/item/ammo_magazine/m762enbloc)
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/garand_ping.ogg'

/obj/item/weapon/gun/projectile/garand/update_icon()
	if(ammo_magazine)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-e"

/*
 * Revolver Rifle
 *		Bastard child of a revolver and a semi-auto rifle.
 */
/obj/item/weapon/gun/projectile/revolvingrifle
	name = "revolving rifle"
	desc = "The Gungnir is a novel, antique idea brought into the modern era by Hedberg-Hammarstrom. \
	The semi-automatic revolving mechanism offers no real advantage, but some colonists swear by it. \
	Uses .44 magnum revolver rounds."
	description_fluff = "Sif’s largest home-grown firearms manufacturer, the Hedberg-Hammarstrom company offers a \
	range of high-quality, high-cost hunting rifles and shotguns designed with the Sivian wilderness - and its \
	wildlife - in mind. The company operates just one production plant in Kalmar, but their weapons have found \
	popularity on garden worlds as far afield as the Tajaran homeworld due to their excellent build quality, \
	precision, and stopping power."
	icon_state = "revolvingrifle"
	item_state = "rifle"
	w_class = ITEMSIZE_LARGE
	caliber = ".44"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	slot_flags = SLOT_BACK
	handle_casings = CYCLE_CASINGS
	load_method = SINGLE_CASING|SPEEDLOADER
	max_shells = 6
	ammo_type = /obj/item/ammo_casing/a44/rifle

/*
 * Vintage Revolver Rifle
 */
/obj/item/weapon/gun/projectile/revolvingrifle/vintage
	name = "vintage revolving rifle"
	desc = "The Willhem is the Gungir's older cousin by Hedberg-Hammarstrom, the perfect collector piece. \
	The semi-automatic revolving mechanism offers no real advantage, but some colonists swear by it. \
	Uses .44 magnum revolver rounds."
	icon_state = "vintagerevolvingrifle"

