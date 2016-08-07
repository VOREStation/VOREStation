/datum/technomancer/spell/force_missile
	name = "Force Missile"
	desc = "This fires a missile at your target.  It's cheap to use, however the projectile itself moves and impacts in such a way \
	that armor designed to protect from blunt force will mitigate this function as well."
	cost = 100
	obj_path = /obj/item/weapon/spell/projectile/force_missile

/obj/item/weapon/spell/projectile/force_missile
	name = "force missile"
	icon_state = "force_missile"
	desc = "Make it rain!"
	cast_methods = CAST_RANGED
	aspect = ASPECT_FORCE
	spell_projectile = /obj/item/projectile/force_missile
	energy_cost_per_shot = 400
	instability_per_shot = 2
	cooldown = 10

/obj/item/projectile/force_missile
	name = "force missile"
	icon_state = "force_missile"
	damage = 20
	damage_type = BRUTE
	check_armour = "melee"