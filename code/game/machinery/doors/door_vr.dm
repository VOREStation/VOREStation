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
				visible_message("<span class='danger'>\The [src.name] disintegrates!</span>")
				new /obj/effect/decal/cleanable/ash(src.loc) // Turn it to ashes!
				qdel(src)
		take_damage(burndamage)

	return ..()

// Returns true only if one of the actions unique to reinforcing is done, otherwise false and continuing normal attackby
/obj/machinery/door/proc/attackby_vr(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/stack/material) && I.get_material_name() == "plasteel")
		if(heat_proof)
			to_chat(user, "<span class='warning'>\The [src] is already reinforced.</span>")
			return TRUE
		if((stat & BROKEN) || (health < maxhealth))
			to_chat(user, "<span class='notice'>It looks like \the [src] broken. Repair it before reinforcing it.</span>")
			return TRUE
		if(!density)
			to_chat(user, "<span class='warning'>\The [src] must be closed before you can reinforce it.</span>")
			return TRUE

		var/amount_needed = 2

		var/obj/item/stack/stack = I
		var/amount_given = amount_needed - reinforcing
		var/mats_given = stack.get_amount()
		if(reinforcing && amount_given <= 0)
			to_chat(user, "<span class='warning'>You must weld or remove \the plasteel from \the [src] before you can add anything else.</span>")
		else
			if(mats_given >= amount_given)
				if(stack.use(amount_given))
					reinforcing += amount_given
			else
				if(stack.use(mats_given))
					reinforcing += mats_given
					amount_given = mats_given
		if(amount_given)
			to_chat(user, "<span class='notice'>You fit [amount_given] [stack.singular_name]\s on \the [src].</span>")

		return TRUE

	if(reinforcing && istype(I, /obj/item/weapon/weldingtool))
		if(!density)
			to_chat(user, "<span class='warning'>\The [src] must be closed before you can reinforce it.</span>")
			return TRUE

		if(reinforcing < 2)
			to_chat(user, "<span class='warning'>You will need more plasteel to reinforce \the [src].</span>")
			return TRUE

		var/obj/item/weapon/weldingtool/welder = I
		if(welder.remove_fuel(0,user))
			to_chat(user, "<span class='notice'>You start weld \the plasteel into place.</span>")
			playsound(src, welder.usesound, 50, 1)
			if(do_after(user, 10 * welder.toolspeed) && welder && welder.isOn())
				to_chat(user, "<span class='notice'>You finish reinforcing \the [src].</span>")
				heat_proof = 1
				update_icon()
				reinforcing = 0
		return TRUE

	if(reinforcing && I.is_crowbar())
		var/obj/item/stack/material/plasteel/reinforcing_sheet = new /obj/item/stack/material/plasteel(src.loc)
		reinforcing_sheet.amount = reinforcing
		reinforcing = 0
		to_chat(user, "<span class='notice'>You remove \the [reinforcing_sheet].</span>")
		playsound(src, I.usesound, 100, 1)
		return TRUE

	return FALSE

/obj/machinery/door/blast/regular/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	return // blast doors are immune to fire completely.

/obj/machinery/door/blast/regular/
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