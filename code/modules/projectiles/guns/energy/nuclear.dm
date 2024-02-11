/*
 * Energy Gun
 */
/obj/item/weapon/gun/energy/gun
	name = "energy gun"
	desc = "Another bestseller of Lawson Arms, the LAEP80 Thor is a versatile energy based pistol, capable of switching between low and high \
	capacity projectile settings. In other words: Stun or Kill."
	description_fluff = "Lawson Arms is Hephaestus Industries’ main personal-energy-weapon branding, often sold alongside MarsTech projectile \
	weapons to security and law enforcement agencies."
	icon_state = "egunstun"
	item_state = null //so the human update icon uses the icon_state instead.
	fire_delay = 8

	projectile_type = /obj/item/projectile/beam/stun/med
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	modifystate = "egunstun"

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun/med, modifystate="egunstun", fire_sound='sound/weapons/Taser.ogg', charge_cost = 240),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/beam, modifystate="egunkill", fire_sound='sound/weapons/Laser.ogg', charge_cost = 480),
		)

/*
 * Energy Rifle
 */
/obj/item/weapon/gun/energy/gun/rifle
	name = "energy rifle"
	desc = "Another bestseller of Lawson Arms, the LAEP100 Svarog is a versatile energy rifle, capable of switching between low and high capacity \
	projectile settings. In other words: Stun or Kill."
	icon_state = "riflestun"
	item_state = null //so the human update icon uses the icon_state instead.
	wielded_item_state = "riflestun-wielded"
	force = 8
	w_class = ITEMSIZE_LARGE
	fire_delay = 6
	one_handed_penalty = 30

	projectile_type = /obj/item/projectile/beam/stun
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 3)
	modifystate = "riflestun"

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, modifystate="riflestun", fire_sound='sound/weapons/Taser.ogg', wielded_item_state="riflestun-wielded", charge_cost = 120),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/beam, modifystate="riflekill", fire_sound='sound/weapons/Laser.ogg', wielded_item_state="riflekill-wielded", charge_cost = 240),
		)

/*
 * Energy Carbine (Burst Laser)
 */
/obj/item/weapon/gun/energy/gun/burst
	name = "energy carbine"
	desc = "The Lawson Arms FM-2t is a versatile energy based carbine made from modifying the original LAEP100 design. It is capable of switching \
	between stun or kill with a three round burst option for both settings."
	icon_state = "energystun"
	item_state = null //so the human update icon uses the icon_state instead.
	force = 8
	w_class = ITEMSIZE_LARGE
	fire_delay = 6

	projectile_type = /obj/item/projectile/beam/stun/weak
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 2, TECH_ILLEGAL = 3)
	modifystate = "energystun"

	firemodes = list(
		list(mode_name="stun", burst=1, projectile_type=/obj/item/projectile/beam/stun/weak, modifystate="energystun", charge_cost = 100),
		list(mode_name="stun burst", burst=3, fire_delay=null, move_delay=4, burst_accuracy=list(0,0,0), dispersion=list(0.0, 0.2, 0.5), projectile_type=/obj/item/projectile/beam/stun/weak, modifystate="energystun"),
		list(mode_name="lethal", burst=1, projectile_type=/obj/item/projectile/beam/burstlaser, modifystate="energykill", charge_cost = 200),
		list(mode_name="lethal burst", burst=3, fire_delay=null, move_delay=4, burst_accuracy=list(0,0,0), dispersion=list(0.0, 0.2, 0.5), projectile_type=/obj/item/projectile/beam/burstlaser, modifystate="energykill"),
		)

/*
 * Energy Thompson (RCW)
 */
/obj/item/weapon/gun/energy/gun/etommy
	name = "Energy RCW"
	desc = "The Lawson Arms experimental Rapid Capacitor Weapon is a highly reguarded and deadly peice of military hardware. Using a large drum shaped \
	capacitor bank the weapon is capable of accurate, rapid burst fire."
	description_fluff = "The Rapid Capacitor Weapon is one of a few weapons that never saw full production. IT was an experimental Shock Trooper weapon developed by \
	Lawsom Arms during the Hegemony Conflict. While only a few hundred were made it didn't take long for smaller arms dealers to break apart stolen units and revese engineer \
	the tech used in their design. While they're an uncommon sight, they're known to be used by roving bands in the Salthan Fyrds as a forms of personal protection because \
	of their ease of use and firepower."
	icon_state = "etommy"
	item_state = "fm-2tkill"
	force = 8
	w_class = ITEMSIZE_LARGE
	fire_delay = 7

	projectile_type = /obj/item/projectile/beam/burstlaser
	origin_tech = list(TECH_COMBAT = 5, TECH_MAGNET = 3, TECH_ILLEGAL = 4)

	firemodes = list(
		list(mode_name="lethal", burst=1, projectile_type=/obj/item/projectile/beam/burstlaser, charge_cost = 200),
		list(mode_name="lethal burst", burst=4, fire_delay=null, move_delay=4, burst_accuracy=list(0,0,0), dispersion=list(0.0, 0.2, 0.5), projectile_type=/obj/item/projectile/beam/burstlaser),
		)

/*
 * Energy PDW (Martin)
 */
/obj/item/weapon/gun/energy/gun/compact
	name = "personal energy weapon"
	desc = "The RayZar EW20 \"Martin\" personal energy weapon - or PEW - is Ward-Takahasi's entry into the variable capacity energy gun market. \
	New users are advised to 'set RayZars to stun'."
	description_fluff = "RayZar is Ward-Takahashi’s main consumer weapons brand, known for producing and licensing a wide variety of specialist \
	energy weapons of various types and quality primarily for the civilian market."
	icon_state = "PDWstun"
	fire_sound = 'sound/weapons/Taser.ogg'
	w_class = ITEMSIZE_SMALL
	projectile_type = /obj/item/projectile/beam/stun/med
	origin_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 3)
	modifystate = "PDWstun"

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun/med, modifystate="PDWstun", fire_sound='sound/weapons/Taser.ogg', charge_cost = 240),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/beam, modifystate="PDWkill", fire_sound='sound/weapons/Laser.ogg', charge_cost = 480),
		)

/*
 * Energy Luger
 */
/obj/item/weapon/gun/energy/gun/eluger
	name = "energy Luger"
	desc = "The finest sidearm produced by RauMauser. Although its battery cannot be removed, its ergonomic design makes it easy to shoot, allowing \
	for rapid follow-up shots. It also has the ability to toggle between stun and kill."
	icon_state = "ep08stun"
	item_state = "gun"
	fire_delay = null // Lugers are quite comfortable to shoot, thus allowing for more controlled follow-up shots. Rate of fire similar to a laser carbine.
	battery_lock = 1 // In exchange for balance, you cannot remove the battery. Also there's no sprite for that and I fucking suck at sprites. -Ace

	projectile_type = /obj/item/projectile/beam/stun/med
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2, TECH_ILLEGAL = 2)
	modifystate = "ep08stun"

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, modifystate="ep08stun", fire_sound='sound/weapons/Taser.ogg', charge_cost = 120),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/beam/eluger, modifystate="ep08kill", fire_sound='sound/weapons/Laser.ogg', charge_cost = 240),
		)

/*
 * Mounted Energy Gun
 */
/obj/item/weapon/gun/energy/gun/mounted
	name = "mounted energy gun"
	self_recharge = 1
	use_external_power = 1

/*
 * Nuclear Energy Gun
 */
/obj/item/weapon/gun/energy/gun/nuclear
	name = "advanced energy gun"
	desc = "An energy gun with an experimental miniaturized reactor, based on a Lawson Arms platform."
	icon_state = "nucgunstun"
	projectile_type = /obj/item/projectile/beam/stun
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_POWER = 3)
	slot_flags = SLOT_BELT
	force = 8 //looks heavier than a pistol
	w_class = ITEMSIZE_LARGE	//Looks bigger than a pistol, too.
	fire_delay = 6	//This one's not a handgun, it should have the same fire delay as everything else
	cell_type = /obj/item/weapon/cell/device/weapon/recharge
	battery_lock = 1
	modifystate = null

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, modifystate="nucgunstun", charge_cost = 240),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/beam, modifystate="nucgunkill", charge_cost = 480),
		)