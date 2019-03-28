/obj/item/weapon/gun/energy/taser
	name = "taser gun"
	desc = "The NT Mk30 NL is a small gun used for non-lethal takedowns. Produced by NT, it's actually a licensed version of a W-T design."
	icon_state = "taser"
	item_state = null	//so the human update icon uses the icon_state instead.
	projectile_type = /obj/item/projectile/beam/stun
	charge_cost = 480

/obj/item/weapon/gun/energy/taser/mounted
	name = "mounted taser gun"
	self_recharge = 1
	use_external_power = 1

/obj/item/weapon/gun/energy/taser/mounted/cyborg
	name = "taser gun"
	charge_cost = 400
	recharge_time = 7 //Time it takes for shots to recharge (in ticks)


/obj/item/weapon/gun/energy/stunrevolver
	name = "stun revolver"
	desc = "A LAEP20 Zeus. Designed by Lawson Arms and produced under the wing of Hephaestus, several TSCs have been trying to get a hold of the blueprints for half a decade."
	icon_state = "stunrevolver"
	item_state = "stunrevolver"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	projectile_type = /obj/item/projectile/energy/electrode/strong
	charge_cost = 300


/obj/item/weapon/gun/energy/crossbow
	name = "mini energy-crossbow"
	desc = "A weapon favored by many mercenary stealth specialists."
	icon_state = "crossbow"
	w_class = ITEMSIZE_SMALL
	item_state = "crossbow"
	origin_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 2, TECH_ILLEGAL = 5)
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	slot_flags = SLOT_BELT | SLOT_HOLSTER
	silenced = 1
	projectile_type = /obj/item/projectile/energy/bolt
	charge_cost = 480
	cell_type = /obj/item/weapon/cell/device/weapon/recharge
	battery_lock = 1
	charge_meter = 0

/obj/item/weapon/gun/energy/crossbow/ninja
	name = "energy dart thrower"
	projectile_type = /obj/item/projectile/energy/dart

/obj/item/weapon/gun/energy/crossbow/largecrossbow
	name = "energy crossbow"
	desc = "A weapon favored by mercenary infiltration teams."
	w_class = ITEMSIZE_LARGE
	force = 10
	matter = list(DEFAULT_WALL_MATERIAL = 200000)
	slot_flags = SLOT_BELT
	projectile_type = /obj/item/projectile/energy/bolt/large

/obj/item/weapon/gun/energy/plasmastun
	name = "plasma pulse projector"
	desc = "The Mars Military Industries MA21 Selkie is a weapon that uses a laser pulse to ionise the local atmosphere, creating a disorienting pulse of plasma and deafening shockwave as the wave expands."
	icon_state = "plasma_stun"
	item_state = "plasma_stun"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_POWER = 3)
	fire_delay = 20
	charge_cost = 600
	projectile_type = /obj/item/projectile/energy/plasmastun