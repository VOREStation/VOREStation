/obj/item/weapon/gun/energy/netgun
	name = "energy net gun"
	desc = "A Kitsuhana-designed, usually dubbed 'Hunter' or 'non-lethal capture device' stunner and energy net launcher, \
			for when you want criminals to stop acting like they're on a 20th century British comedy sketch show."
	catalogue_data = list(/datum/category_item/catalogue/information/organization/khi)
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "hunter"
	item_state = "gun" // Placeholder
	mode_name = "stun"

	fire_sound = 'sound/weapons/eluger.ogg'
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_MAGNET = 3)
	projectile_type = /obj/item/projectile/beam/stun/blue
	charge_cost = 240
	fire_delay = 5

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun/blue, fire_sound='sound/weapons/Taser.ogg', charge_cost=240, fire_delay=5),
		list(mode_name="capture", projectile_type=/obj/item/projectile/beam/energy_net, fire_sound = 'sound/weapons/eluger.ogg', charge_cost=1200, fire_delay=50)
	)

/obj/item/weapon/gun/energy/netgun/update_icon()
	overlays.Cut()

	if(power_supply)
		var/ratio = power_supply.charge / power_supply.maxcharge

		if(power_supply.charge < charge_cost)
			ratio = 0
		else
			ratio = max(round(ratio, 0.25) * 100, 25)

		overlays += "[initial(icon_state)]_cell"
		overlays += "[initial(icon_state)]_[ratio]"
		overlays += "[initial(icon_state)]_[mode_name]"
