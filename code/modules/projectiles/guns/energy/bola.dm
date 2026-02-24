/obj/item/gun/energy/bolagun
	name = "bola blaster"
	desc = "Specially made-to-order by Xenonomix, the  \"Bola-Blaster\" launches an energy net that consolodates around the target's legs to hinder their movement!."
	icon_state = "netgun"
	item_state = "gun" // Placeholder

	fire_sound = 'sound/weapons/eluger.ogg'
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_MAGNET = 3)
	projectile_type = /obj/item/projectile/bola/energy
	charge_cost = 400 //Low energy cost.
	fire_delay = 10 //Rapid fire!

/obj/item/gun/energy/bolagun/update_icon()
	if(power_supply == null)
		if(modifystate)
			icon_state = "[modifystate]_open"
		else
			icon_state = "[initial(icon_state)]_open"
		return
	else if(charge_meter)
		var/ratio = power_supply.charge / power_supply.maxcharge

		//make sure that rounding down will not give us the empty state even if we have charge for a shot left.
		if(power_supply.charge < charge_cost)
			ratio = 0
		else
			ratio = max(round(ratio, 0.25) * 100, 25)

		if(modifystate)
			icon_state = "[modifystate][ratio]"
		else
			icon_state = "[initial(icon_state)][ratio]"

	else if(power_supply)
		if(modifystate)
			icon_state = "[modifystate]"
		else
			icon_state = "[initial(icon_state)]"
