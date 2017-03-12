/turf/simulated/floor/proc/adjacent_fire_act_vr(turf/simulated/floor/adj_turf, datum/gas_mixture/adj_air, adj_temp, adj_volume)
	for(var/obj/machinery/door/D in src) //makes doors next to fire affected by fire
		D.fire_act(adj_air, adj_temp, adj_volume)

/obj/machinery/door
	var/obj/item/stack/material/plasteel/reinforcing //vorestation addition

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

/obj/machinery/door/proc/attackby_vr(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/stack/material) && I.get_material_name() == "plasteel") // Add heat shielding if it isn't already.
		if(!heat_proof)
			var/obj/item/stack/stack = I
			var/transfer
			var/amount_needed = 2
			if(stat & BROKEN)
				user << "<span class='notice'>It looks like \the [src] is pretty busted.</span>"
			if (reinforcing)
				transfer = stack.transfer_to(reinforcing, amount_needed - reinforcing.amount)
				if (!transfer)
					user << "<span class='warning'>You must weld or remove \the [reinforcing] from \the [src] before you can add anything else.</span>"
					return 1
			else
				reinforcing = stack.split(amount_needed)
				if (reinforcing)
					reinforcing.loc = src
					transfer = reinforcing.amount

			if (transfer)
				user << "<span class='notice'>You fit [transfer] [stack.singular_name]\s to \the [src].</span>"
				return 1

	if(istype(I, /obj/item/stack/material) && I.get_material_name() == src.get_material_name())
		if(stat & BROKEN)
			if(health >= maxhealth && destroy_hits >= 10)
				user << "<span class='notice'>The [src] is about as shored up as it's going to get.</span>"
				return 1
			if(!density)
				user << "<span class='warning'>\The [src] must be closed before you can repair it.</span>"
				return 1

			//figure out how much metal we need
			var/amount_needed = (maxhealth - health) / DOOR_REPAIR_AMOUNT
			if (destroy_hits < 10)
				amount_needed += (20*(10 - destroy_hits) / DOOR_REPAIR_AMOUNT)
			amount_needed = (round(amount_needed) == amount_needed)? amount_needed : round(amount_needed) + 1 //Why does BYOND not have a ceiling proc?

			var/obj/item/stack/stack = I
			var/transfer
			if (repairing)
				transfer = stack.transfer_to(repairing, amount_needed - repairing.amount)
				if (!transfer)
					user << "<span class='warning'>You must weld or remove \the [repairing] from \the [src] before you can add anything else.</span>"
			else
				repairing = stack.split(amount_needed)
				if (repairing)
					repairing.loc = src
					transfer = repairing.amount

			if (transfer)
				user << "<span class='notice'>\The [src] is completely broken inside, but you manage to fit [transfer] [stack.singular_name]\s to shore it up.</span>"

			return 1

		return 0


	if(reinforcing && istype(I, /obj/item/weapon/weldingtool))
		var/amount_needed = 2
		if(!density)
			user << "<span class='warning'>\The [src] must be closed before you can repair it.</span>"
			return 1
		if (reinforcing.amount < amount_needed)
			user << "<span class='notice'>You need [amount_needed] [reinforcing.singular_name]\s to reinforce \the [src].</span>"
			return 1
		var/obj/item/weapon/weldingtool/welder = I
		if(welder.remove_fuel(0,user))
			user << "<span class='notice'>You start to weld \the [reinforcing] into place.</span>"
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			if(do_after(user, 5 * reinforcing.amount) && welder && welder.isOn())
				user << "<span class='notice'>You finish reinforcing \the [src].</span>"
				heat_proof = 1
				update_icon()
				qdel(reinforcing)
				reinforcing = null
		return 1

	if(repairing && istype(I, /obj/item/weapon/weldingtool) && (stat & BROKEN))
		if(!density)
			user << "<span class='warning'>\The [src] must be closed before you can shore it up.</span>"
			return 1

		var/obj/item/weapon/weldingtool/welder = I
		if(welder.remove_fuel(0,user))
			user << "<span class='notice'>You start to weld \the [repairing] into place.</span>"
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			if(do_after(user, 5 * repairing.amount) && welder && welder.isOn())
				user << "<span class='notice'>You finish shoring up \the [src]. It'll hold for at least a little while.</span>"
				var/damagerepaired = repairing.amount*DOOR_REPAIR_AMOUNT
				if (destroy_hits < 10)
					var/severedamage = 10 - destroy_hits
					destroy_hits = between(destroy_hits, destroy_hits + (damagerepaired)/20, 10)
					damagerepaired -= 20 * severedamage
				health = between(health, health + damagerepaired, maxhealth)
				update_icon()
				qdel(repairing)
				repairing = null
		return 1

	if(reinforcing && istype(I, /obj/item/weapon/crowbar))
		user << "<span class='notice'>You remove \the [reinforcing].</span>"
		playsound(src.loc, 'sound/items/Crowbar.ogg', 100, 1)
		reinforcing.loc = user.loc
		reinforcing = null
		return 1
	return 0

/obj/machinery/door/blast/regular/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	return // blast doors are immune to fire completely.

/obj/machinery/door/blast/regular/
	heat_proof = 1 //just so repairing them doesn't try to fireproof something that never takes fire damage


