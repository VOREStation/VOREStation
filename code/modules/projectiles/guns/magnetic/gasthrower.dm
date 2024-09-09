/obj/item/gun/magnetic/gasthrower
	name = "phoronthrower"
	desc = "A modernized flamethrower utilizing pressurized phoron gas as both a propellant and combustion medium."
	description_fluff = "A weapon designed to effectively combat the threat posed by Almachi soldiers without the danger of other forms of flamethrower."
	icon_state = "gasthrower"
	item_state = "bore"
	wielded_item_state = "bore-wielded"
	icon = 'icons/obj/railgun.dmi'
	one_handed_penalty = 20
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 4, TECH_ILLEGAL = 2, TECH_PHORON = 4)
	w_class = ITEMSIZE_LARGE
	slowdown = 1

	burst = 3
	burst_delay = 1

	fire_sound = 'sound/weapons/towelwipe.ogg'

	removable_components = TRUE
	gun_unreliable = 0

	load_type = /obj/item/tank
	projectile_type = /obj/item/projectile/scatter/flamethrower

	power_cost = 250

/obj/item/gun/magnetic/gasthrower/check_ammo()
	if(!loaded || !istype(loaded, load_type))
		return 0

	var/obj/item/tank/Tank = loaded

	Tank.air_contents.update_values()	// Safety

	var/turf/T = get_turf(src)

	var/phoron_amt = Tank.air_contents.gas["phoron"]
	var/co2_amt = Tank.air_contents.gas["carbon_dioxide"]
	var/oxy_amt = Tank.air_contents.gas["oxygen"]
	var/n2o_amt = Tank.air_contents.gas["nitrous_oxide"]

	if(isnull(co2_amt))
		co2_amt = 0

	if(isnull(oxy_amt))
		oxy_amt = 0

	if(isnull(n2o_amt))
		n2o_amt = 0

	var/phoron_mix_proper = TRUE
	if(!phoron_amt || phoron_amt < max(0.25, 3 + co2_amt - oxy_amt - (n2o_amt / 2)))
		phoron_mix_proper = FALSE

	if(Tank.air_contents.return_pressure() >= T.air.return_pressure() && phoron_mix_proper)
		return 1

	return 0

/obj/item/gun/magnetic/gasthrower/use_ammo()
	var/obj/item/tank/Tank = loaded

	var/moles_to_pull = 0.25

	Tank.air_contents.remove(moles_to_pull)

/obj/item/gun/magnetic/gasthrower/show_ammo(var/mob/user)
	. = ..()

	if(loaded)
		var/obj/item/tank/T = loaded
		. += "<span class='notice'>\The [T]'s pressure meter shows: [T.air_contents.return_pressure()] kpa.</span>"

		switch(check_ammo())
			if(TRUE)
				. += "<span class='notice'>\The [src]'s display registers a proper fuel mixture.</span>"
			if(FALSE)
				. += "<span class='warning'>\The [src]'s display registers an improper fuel mixture.</span>"
