/obj/item/weapon/grenade/empgrenade
	name = "emp grenade"
	icon_state = "emp"
	item_state = "empgrenade"
	origin_tech = list(TECH_MATERIAL = 2, TECH_MAGNET = 3)
	var/emp_heavy = 2
	var/emp_med = 4
	var/emp_light = 7
	var/emp_long = 10

/obj/item/weapon/grenade/empgrenade/detonate()
	..()
	if(empulse(src, emp_heavy, emp_med, emp_light, emp_long))
		qdel(src)
	return

/obj/item/weapon/grenade/empgrenade/low_yield
	name = "low yield emp grenade"
	desc = "A weaker variant of the EMP grenade"
	icon_state = "lyemp"
	origin_tech = list(TECH_MATERIAL = 2, TECH_MAGNET = 3)
	emp_heavy = 1
	emp_med = 2
	emp_light = 3
	emp_long = 4