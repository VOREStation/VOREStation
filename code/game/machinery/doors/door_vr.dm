/obj/machinery/door/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	for(var/obj/machinery/door/blast/B in loc.contents)
		if(B.density)
			return

	var/maxtemperature = 1800 //same as a normal steel wall
	var/destroytime = 20 //effectively gives an airlock 200HP between breaking and completely disintegrating
	if(heat_proof)
		maxtemperature = 6000 //same as a plasteel rwall
		destroytime = 50 //fireproof airlocks need to take 500 damage after breaking before they're destroyed

	if(exposed_temperature > maxtemperature)
		var/burndamage = log(RAND_F(0.9, 1.1) * (exposed_temperature - maxtemperature))
		if (burndamage && health <= 0) //once they break, start taking damage to destroy_hits
			destroy_hits -= (burndamage / destroytime)
			if (destroy_hits <= 0)
				visible_message(span_danger("\The [src.name] disintegrates!"))
				new /obj/effect/decal/cleanable/ash(src.loc) // Turn it to ashes!
				qdel(src)
		take_damage(burndamage)

	return ..()

/obj/machinery/door/proc/toggle()
	if(glass)
		icon = icon_tinted
		glass = 0
		if(!operating && density)
			set_opacity(1)
	else
		icon = initial(icon)
		glass = 1
		if(!operating)
			set_opacity(0)

/obj/machinery/button/windowtint/doortint
	name = "door tint control"
	desc = "A remote control switch for polarized glass doors."

/obj/machinery/button/windowtint/doortint/toggle_tint()
	use_power(5)
	active = !active
	update_icon()

	for(var/obj/machinery/door/D in range(src,range))
		if(D.icon_tinted && (D.id_tint == src.id || !D.id_tint))
			D.toggle()
