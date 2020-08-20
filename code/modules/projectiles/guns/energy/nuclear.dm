/obj/item/weapon/gun/energy/gun
	name = "energy gun"
	desc = "Another bestseller of Lawson Arms, the LAEP90 Perun is a versatile energy based sidearm, capable of switching between low and high capacity projectile settings. In other words: Stun or Kill."
	description_fluff = "Lawson Arms is Hephaestus Industries’ main personal-energy-weapon branding, often sold alongside MarsTech projectile weapons to security and law enforcement agencies."
	icon_state = "energystun100"
	item_state = null	//so the human update icon uses the icon_state instead.
	fire_delay = 10 // Handguns should be inferior to two-handed weapons.

	projectile_type = /obj/item/projectile/beam/stun/med
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	modifystate = "energystun"

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun/med, modifystate="energystun", charge_cost = 240),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/beam, modifystate="energykill", charge_cost = 480),
		)


/obj/item/weapon/gun/energy/gun/mounted
	name = "mounted energy gun"
	self_recharge = 1
	use_external_power = 1


/obj/item/weapon/gun/energy/gun/burst
	name = "burst laser"
	desc = "The Lawson Arms FM-2t is a versatile energy based weapon, capable of switching between stun or kill with a three round burst option for both settings."
	description_fluff = "Lawson Arms is Hephaestus Industries’ main personal-energy-weapon branding, often sold alongside MarsTech projectile weapons to security and law enforcement agencies."
	icon_state = "fm-2tstun100"	//May resprite this to be more rifley
	item_state = null	//so the human update icon uses the icon_state instead.
	charge_cost = 100
	force = 8
	w_class = ITEMSIZE_LARGE	//Probably gonna make it a rifle sooner or later
	fire_delay = 6

	projectile_type = /obj/item/projectile/beam/stun/weak
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 2, TECH_ILLEGAL = 3)
	modifystate = "fm-2tstun"

//	requires_two_hands = 1
//	one_handed_penalty = 30

	firemodes = list(
		list(mode_name="stun", burst=1, projectile_type=/obj/item/projectile/beam/stun/weak, modifystate="fm-2tstun", charge_cost = 100),
		list(mode_name="stun burst", burst=3, fire_delay=null, move_delay=4, burst_accuracy=list(0,0,0), dispersion=list(0.0, 0.2, 0.5), projectile_type=/obj/item/projectile/beam/stun/weak, modifystate="fm-2tstun"),
		list(mode_name="lethal", burst=1, projectile_type=/obj/item/projectile/beam/burstlaser, modifystate="fm-2tkill", charge_cost = 200),
		list(mode_name="lethal burst", burst=3, fire_delay=null, move_delay=4, burst_accuracy=list(0,0,0), dispersion=list(0.0, 0.2, 0.5), projectile_type=/obj/item/projectile/beam/burstlaser, modifystate="fm-2tkill"),
		)

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

//	requires_two_hands = 1
//	one_handed_penalty = 15 // It's rather bulky, so holding it in one hand is a little harder than with two, however it's not 'required'.

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, modifystate="nucgunstun", charge_cost = 240),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/beam, modifystate="nucgunkill", charge_cost = 480),
		)

//Functionally a Perun, but flavoured.
/obj/item/weapon/gun/energy/gun/compact
	name = "personal energy weapon"
	desc = "The RayZar EW20 Cygnus personal energy weapon - or PEW - is Ward-Takahasi's entry into the variable capacity energy gun market. New users are advised to 'set RayZars to stun'."
	description_fluff = "RayZar is Ward-Takahashi’s main consumer weapons brand, known for producing and licensing a wide variety of specialist energy weapons of various types and quality primarily for the civilian market."
	icon_state = "PDWstun100"

	projectile_type = /obj/item/projectile/beam/stun/med
	origin_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 3)
	modifystate = "PDWstun"

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun/med, modifystate="PDWstun", charge_cost = 240),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/beam, modifystate="PDWkill", charge_cost = 480),
		)