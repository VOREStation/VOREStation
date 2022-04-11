/***************************************
* Highly Visible and Dangerous Weapons *
***************************************/
/datum/uplink_item/item/visible_weapons
	category = /datum/uplink_category/visible_weapons

/datum/uplink_item/item/visible_weapons/tactknife
	name = "Tactical Knife"
	item_cost = 10
	path = /obj/item/weapon/material/knife/tacknife

/datum/uplink_item/item/visible_weapons/combatknife
	name = "Combat Knife"
	item_cost = 20
	path = /obj/item/weapon/material/knife/tacknife/combatknife

/datum/uplink_item/item/visible_weapons/energy_sword
	name = "Energy Sword, Colorable"
	item_cost = 40
	path = /obj/item/weapon/melee/energy/sword

/datum/uplink_item/item/visible_weapons/energy_sword_pirate
	name = "Energy Cutlass, Colorable"
	item_cost = 40
	path = /obj/item/weapon/melee/energy/sword/pirate

/datum/uplink_item/item/visible_weapons/energy_spear
	name = "Energy Spear, Colorable"
	item_cost = 50
	path = /obj/item/weapon/melee/energy/spear

/datum/uplink_item/item/visible_weapons/claymore
	name = "Claymore"
	item_cost = 40
	path = /obj/item/weapon/material/sword

/datum/uplink_item/item/visible_weapons/chainsaw
	name = "Chainsaw"
	item_cost = 40
	path = /obj/item/weapon/chainsaw

/datum/uplink_item/item/visible_weapons/katana
	name = "Katana"
	item_cost = 40
	path = /obj/item/weapon/material/sword/katana

/datum/uplink_item/item/visible_weapons/dartgun
	name = "Dart Gun"
	item_cost = 30
	path = /obj/item/weapon/gun/projectile/dartgun

/datum/uplink_item/item/visible_weapons/crossbow
	name = "Energy Crossbow"
	item_cost = 40
	path = /obj/item/weapon/gun/energy/crossbow

/datum/uplink_item/item/visible_weapons/silenced_45
	name = "Silenced .45"
	item_cost = 40
	path = /obj/item/weapon/gun/projectile/silenced

/datum/uplink_item/item/visible_weapons/riggedlaser
	name = "Exosuit Rigged Laser"
	item_cost = 30
	path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/riggedlaser

/datum/uplink_item/item/visible_weapons/revolver
	name = "Revolver"
	item_cost = 70
	path = /obj/item/weapon/gun/projectile/revolver

/datum/uplink_item/item/visible_weapons/mateba
	name = "Mateba"
	item_cost = 70
	path = /obj/item/weapon/gun/projectile/revolver/mateba

/datum/uplink_item/item/visible_weapons/judge
	name = "Judge"
	item_cost = 70
	path = /obj/item/weapon/gun/projectile/revolver/judge

/datum/uplink_item/item/visible_weapons/pistol_standard_capacity
	name = "9mm Pistol"
	item_cost = 40
	path = /obj/item/weapon/gun/projectile/p92x

/datum/uplink_item/item/visible_weapons/pistol_large_capacity
	name = "9mm Pistol (with large capacity magazine)"
	item_cost = 70
	path = /obj/item/weapon/gun/projectile/p92x/large

/datum/uplink_item/item/visible_weapons/lemat
	name = "Mako Revolver"
	item_cost = 60
	path = /obj/item/weapon/gun/projectile/revolver/lemat

/datum/uplink_item/item/visible_weapons/Derringer
	name = ".357 Derringer Pistol"
	item_cost = 40
	path = /obj/item/weapon/gun/projectile/derringer

/datum/uplink_item/item/visible_weapons/heavysnipermerc
	name = "Anti-Materiel Rifle (14.5mm)"
	item_cost = DEFAULT_TELECRYSTAL_AMOUNT
	path = /obj/item/weapon/gun/projectile/heavysniper
	antag_roles = list("mercenary", "ert") //VOREStation Edit

/datum/uplink_item/item/visible_weapons/heavysnipertraitor
	name = "Anti-Materiel Rifle (14.5mm)"
	desc = "A convenient collapsible rifle for covert assassination. Comes with 4 shots and its own secure carrying case."
	item_cost = DEFAULT_TELECRYSTAL_AMOUNT
	path = /obj/item/weapon/storage/secure/briefcase/rifle
	antag_roles = list("traitor", "autotraitor", "infiltrator")

/datum/uplink_item/item/visible_weapons/fuelrodcannon
	name = "Fuel-Rod Cannon"
	desc = "An incredibly bulky weapon whose devastating firepower is only matched by its severe need for expensive, and rare, ammunition. This device will likely require extra preparation to use, you are warned."
	item_cost = DEFAULT_TELECRYSTAL_AMOUNT
	path = /obj/item/weapon/storage/secure/briefcase/fuelrod

/datum/uplink_item/item/visible_weapons/tommygun
	name = "Tommy Gun (.45)" // We're keeping this because it's CLASSY. -Spades
	item_cost = 60
	path = /obj/item/weapon/gun/projectile/automatic/tommygun

//These are for traitors (or other antags, perhaps) to have the option of purchasing some merc gear.
/datum/uplink_item/item/visible_weapons/submachinegun
	name = "Submachine Gun (10mm)"
	item_cost = 60
	path = /obj/item/weapon/gun/projectile/automatic/c20r

/datum/uplink_item/item/visible_weapons/assaultrifle
	name = "Assault Rifle (5.45mm)"
	item_cost = 75
	path = /obj/item/weapon/gun/projectile/automatic/sts35

/datum/uplink_item/item/visible_weapons/combatshotgun
	name = "Combat Shotgun"
	item_cost = 75
	path = /obj/item/weapon/gun/projectile/shotgun/pump/combat

/datum/uplink_item/item/visible_weapons/leveraction
	name = "Lever Action Rifle"
	item_cost = 50
	path = /obj/item/weapon/gun/projectile/shotgun/pump/rifle/lever

/datum/uplink_item/item/visible_weapons/egun
	name = "Compact Energy Gun"
	item_cost = 30
	path = /obj/item/weapon/gun/energy/gun/compact

/datum/uplink_item/item/visible_weapons/lasercannon
	name = "Laser Cannon"
	item_cost = 60
	path = /obj/item/weapon/gun/energy/lasercannon

/datum/uplink_item/item/visible_weapons/lasercarbine
	name = "Laser Carbine"
	item_cost = 75
	path = /obj/item/weapon/gun/energy/laser

/datum/uplink_item/item/visible_weapons/ionrifle
	name = "Ion Rifle"
	item_cost = 40
	path = /obj/item/weapon/gun/energy/ionrifle

/datum/uplink_item/item/visible_weapons/ionpistol
	name = "Ion Pistol"
	item_cost = 25
	path = /obj/item/weapon/gun/energy/ionrifle/pistol

/datum/uplink_item/item/visible_weapons/xray
	name = "Xray Gun"
	item_cost = 60
	path = /obj/item/weapon/gun/energy/xray

/datum/uplink_item/item/visible_weapons/flamethrower
	name = "Heavy Flamethrower"
	desc = "A large flamethrower that runs on pressurized, gaseous phoron and electric charge."
	item_cost = 60
	path = /obj/item/weapon/storage/secure/briefcase/flamer

/datum/uplink_item/item/visible_weapons/concussion_grenades
	name = "Concussion Grenades (8)"
	desc = "A box of eight concussion grenades."
	item_cost = 30
	path = /obj/item/weapon/storage/box/syndie_kit/concussion_grenade
