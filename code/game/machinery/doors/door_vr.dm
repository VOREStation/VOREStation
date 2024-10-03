/turf/simulated/floor/proc/adjacent_fire_act_vr(turf/simulated/floor/adj_turf, datum/gas_mixture/adj_air, adj_temp, adj_volume)
	for(var/obj/machinery/door/D in src) //makes doors next to fire affected by fire
		D.fire_act(adj_air, adj_temp, adj_volume)

/obj/machinery/door
	var/reinforcing = 0	//vorestation addition
	var/tintable = 0
	var/icon_tinted
	var/id_tint

/obj/machinery/door/firedoor
	heat_proof = 1

/obj/machinery/door/airlock/vault
	heat_proof = 1

/obj/machinery/door/airlock/hatch
	heat_proof = 1

/obj/machinery/door/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
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

// Returns true only if one of the actions unique to reinforcing is done, otherwise false and continuing normal attackby
/obj/machinery/door/proc/attackby_vr(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/stack/material) && I.get_material_name() == "plasteel")
		if(heat_proof)
			to_chat(user, span_warning("\The [src] is already reinforced."))
			return TRUE
		if((stat & BROKEN) || (health < maxhealth))
			to_chat(user, span_notice("It looks like \the [src] broken. Repair it before reinforcing it."))
			return TRUE
		if(!density)
			to_chat(user, span_warning("\The [src] must be closed before you can reinforce it."))
			return TRUE

		var/amount_needed = 2

		var/obj/item/stack/stack = I
		var/amount_given = amount_needed - reinforcing
		var/mats_given = stack.get_amount()
		var/singular_name = stack.singular_name
		if(reinforcing && amount_given <= 0)
			to_chat(user, span_warning("You must weld or remove \the plasteel from \the [src] before you can add anything else."))
		else
			if(mats_given >= amount_given)
				if(stack.use(amount_given))
					reinforcing += amount_given
			else
				if(stack.use(mats_given))
					reinforcing += mats_given
					amount_given = mats_given
		if(amount_given)
			to_chat(user, span_notice("You fit [amount_given] [singular_name]\s on \the [src]."))

		return TRUE

	if(reinforcing && I.has_tool_quality(TOOL_WELDER))
		if(!density)
			to_chat(user, span_warning("\The [src] must be closed before you can reinforce it."))
			return TRUE

		if(reinforcing < 2)
			to_chat(user, span_warning("You will need more plasteel to reinforce \the [src]."))
			return TRUE

		var/obj/item/weldingtool/welder = I.get_welder()
		if(welder.remove_fuel(0,user))
			to_chat(user, span_notice("You start weld \the plasteel into place."))
			playsound(src, welder.usesound, 50, 1)
			if(do_after(user, 10 * welder.toolspeed) && welder && welder.isOn())
				to_chat(user, span_notice("You finish reinforcing \the [src]."))
				heat_proof = 1
				update_icon()
				reinforcing = 0
		return TRUE

	if(reinforcing && I.has_tool_quality(TOOL_CROWBAR))
		var/obj/item/stack/material/plasteel/reinforcing_sheet = new /obj/item/stack/material/plasteel(src.loc, reinforcing)
		reinforcing = 0
		to_chat(user, span_notice("You remove \the [reinforcing_sheet]."))
		playsound(src, I.usesound, 100, 1)
		return TRUE

	return FALSE

/obj/machinery/door/blast/regular/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	return // blast doors are immune to fire completely.

/obj/machinery/door/blast/regular
	heat_proof = 1 //just so repairing them doesn't try to fireproof something that never takes fire damage

/obj/machinery/door/blast/angled/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	return // blast doors are immune to fire completely.

/obj/machinery/door/blast/angled
	heat_proof = 1 //just so repairing them doesn't try to fireproof something that never takes fire damage

/obj/machinery/door/blast/puzzle/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	return // blast doors are immune to fire completely.

/obj/machinery/door/blast/puzzle
	heat_proof = 1 //just so repairing them doesn't try to fireproof something that never takes fire damage

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
			spawn(0)
				D.toggle()
				return
