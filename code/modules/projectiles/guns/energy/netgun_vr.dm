/obj/item/weapon/gun/energy/netgun
	name = "energy net gun"
	desc = "Specially made-to-order by Xenonomix, the XX-1 \"Varmint Catcher\" is designed to trap even the most unruly of creatures for safe transport."
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "netgun"
	item_state = "gun" // Placeholder
	charge_meter = 0

	fire_sound = 'sound/weapons/eluger.ogg'
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_MAGNET = 3)
	projectile_type = /obj/item/projectile/beam/energy_net
	charge_cost = 800
	fire_delay = 50
