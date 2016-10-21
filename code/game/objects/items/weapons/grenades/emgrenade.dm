/obj/item/weapon/grenade/empgrenade
	name = "emp grenade"
	icon_state = "emp"
	item_state = "empgrenade"
	origin_tech = list(TECH_MATERIAL = 2, TECH_MAGNET = 3)
	var/emp_heavy = 4
	var/emp_light = 10

	prime()
		..()
		if(empulse(src, emp_heavy, emp_light))
			qdel(src)
		return

/obj/item/weapon/grenade/empgrenade/low_yield
	name = "low yield emp grenade"
	desc = "A weaker variant of the EMP grenade"
	icon_state = "lyemp"
	origin_tech = list(TECH_MATERIAL = 2, TECH_MAGNET = 3)
	emp_heavy = 1
	emp_light = 4