/obj/item/grenade/empgrenade
	name = "emp grenade"
	icon_state = "emp"
	item_state = "empgrenade"
	var/emp_heavy = 2
	var/emp_med = 4
	var/emp_light = 7
	var/emp_long = 10

/obj/item/grenade/empgrenade/detonate()
	..()
	if(empulse(src, emp_heavy, emp_med, emp_light, emp_long))
		qdel(src)
	return

/obj/item/grenade/empgrenade/low_yield
	name = "low yield emp grenade"
	desc = "A weaker variant of the EMP grenade"
	icon_state = "lyemp"
	emp_heavy = 1
	emp_med = 2
	emp_light = 3
	emp_long = 4
