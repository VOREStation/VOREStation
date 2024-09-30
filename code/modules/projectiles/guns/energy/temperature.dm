/obj/item/gun/energy/temperature
	name = "temperature gun"
	icon_state = "freezegun"
	desc = "A gun that can add or remove heat from entities it hits.  In other words, it can fire 'cold', and 'hot' beams."
	charge_cost = 240
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 4, TECH_POWER = 3, TECH_MAGNET = 2)
	slot_flags = SLOT_BELT|SLOT_BACK

	projectile_type = /obj/item/projectile/temp

	firemodes = list(
		list(mode_name="endothermic beam", projectile_type = /obj/item/projectile/temp, charge_cost = 240),
		list(mode_name="exothermic beam", projectile_type = /obj/item/projectile/temp/hot, charge_cost = 240),
		)

/obj/item/gun/energy/temperature/mounted
	self_recharge = 1
	use_external_power = 1
