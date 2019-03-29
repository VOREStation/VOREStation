/obj/structure/bonfire
	name = "bonfire"
	desc = "For grilling, broiling, charring, smoking, heating, roasting, toasting, simmering, searing, melting, and occasionally burning things."
	icon = 'icons/obj/structures.dmi'
	icon_state = "bonfire"
	density = FALSE
	anchored = TRUE
	buckle_lying = FALSE
	var/burning = FALSE
	var/next_fuel_consumption = 0 // world.time of when next item in fuel list gets eatten to sustain the fire.
	var/grill = FALSE
	var/material/material
	var/set_temperature = T0C + 30	//K
	var/heating_power = 80000

/obj/structure/bonfire/New(newloc, material_name)
	..(newloc)
	if(!material_name)
		material_name = MAT_WOOD
	material = get_material_by_name("[material_name]")
	if(!material)
		qdel(src)
		return
	color = material.icon_colour

// Blue wood.
/obj/structure/bonfire/sifwood/New(newloc, material_name)
	..(newloc, MAT_SIFWOOD)

/obj/structure/bonfire/permanent/New(newloc, material_name)
	..()
	ignite()

/obj/structure/bonfire/permanent/sifwood/New(newloc, material_name)
	..(newloc, MAT_SIFWOOD)

/obj/structure/bonfire/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/stack/rods) && !can_buckle && !grill)
		var/obj/item/stack/rods/R = W
		var/choice = input(user, "What would you like to construct?", "Bonfire") as null|anything in list("Stake","Grill")
		switch(choice)
			if("Stake")
				R.use(1)
				can_buckle = TRUE
				buckle_require_restraints = TRUE
				to_chat(user, "<span class='notice'>You add a rod to \the [src].</span>")
				var/mutable_appearance/rod_underlay = mutable_appearance('icons/obj/structures.dmi', "bonfire_rod")
				rod_underlay.pixel_y = 16
				rod_underlay.appearance_flags = RESET_COLOR|PIXEL_SCALE|TILE_BOUND
				underlays += rod_underlay
			if("Grill")
				R.use(1)
				grill = TRUE
				to_chat(user, "<span class='notice'>You add a grill to \the [src].</span>")
				update_icon()
			else
				return ..()

	else if(istype(W, /obj/item/stack/material/wood) || istype(W, /obj/item/stack/material/log) )
		add_fuel(W, user)

	else if(W.is_hot())
		ignite()
	else
		return ..()

/obj/structure/bonfire/attack_hand(mob/user)
	if(has_buckled_mobs())
		return ..()

	if(get_fuel_amount())
		remove_fuel(user)
	else
		dismantle(user)


/obj/structure/bonfire/proc/dismantle(mob/user)
	if(!burning)
		user.visible_message("[user] starts dismantling \the [src].", "You start dismantling \the [src].")
		if(do_after(user, 5 SECONDS))
			for(var/i = 1 to 5)
				material.place_dismantled_product(get_turf(src))
			user.visible_message("[user] dismantles down \the [src].", "You dismantle \the [src].")
			qdel(src)
	else
		to_chat(user, "<span class='warning'>\The [src] is still burning. Extinguish it first if you want to dismantle it.</span>")

/obj/structure/bonfire/proc/get_fuel_amount()
	var/F = 0
	for(var/A in contents)
		if(istype(A, /obj/item/stack/material/wood))
			F += 0.5
		if(istype(A, /obj/item/stack/material/log))
			F += 1.0
	return F

/obj/structure/bonfire/permanent/get_fuel_amount()
	return 10

/obj/structure/bonfire/proc/remove_fuel(mob/user)
	if(get_fuel_amount())
		var/atom/movable/AM = pop(contents)
		AM.forceMove(get_turf(src))
		to_chat(user, "<span class='notice'>You take \the [AM] out of \the [src] before it has a chance to burn away.</span>")
		update_icon()

/obj/structure/bonfire/permanent/remove_fuel(mob/user)
	dismantle(user)

/obj/structure/bonfire/proc/add_fuel(atom/movable/new_fuel, mob/user)
	if(get_fuel_amount() >= 10)
		to_chat(user, "<span class='warning'>\The [src] already has enough fuel!</span>")
		return FALSE
	if(istype(new_fuel, /obj/item/stack/material/wood) || istype(new_fuel, /obj/item/stack/material/log) )
		var/obj/item/stack/F = new_fuel
		var/obj/item/stack/S = F.split(1)
		if(S)
			S.forceMove(src)
			to_chat(user, "<span class='warning'>You add \the [new_fuel] to \the [src].</span>")
			update_icon()
			return TRUE
		return FALSE
	else
		to_chat(user, "<span class='warning'>\The [src] needs raw wood to burn, \a [new_fuel] won't work.</span>")
		return FALSE

/obj/structure/bonfire/permanent/add_fuel(mob/user)
	to_chat(user, "<span class='warning'>\The [src] has plenty of fuel and doesn't need more fuel.</span>")

/obj/structure/bonfire/proc/consume_fuel(var/obj/item/stack/consumed_fuel)
	if(!istype(consumed_fuel))
		qdel(consumed_fuel) // Don't know, don't care.
		return FALSE

	if(istype(consumed_fuel, /obj/item/stack/material/log))
		next_fuel_consumption = world.time + 2 MINUTES
		qdel(consumed_fuel)
		update_icon()
		return TRUE

	else if(istype(consumed_fuel, /obj/item/stack/material/wood)) // One log makes two planks of wood.
		next_fuel_consumption = world.time + 1 MINUTE
		qdel(consumed_fuel)
		update_icon()
		return TRUE
	return FALSE

/obj/structure/bonfire/permanent/consume_fuel()
	return TRUE

/obj/structure/bonfire/proc/check_oxygen()
	var/datum/gas_mixture/G = loc.return_air()
	if(G.gas["oxygen"] < 1)
		return FALSE
	return TRUE


/obj/structure/bonfire/proc/extinguish()
	if(burning)
		burning = FALSE
		update_icon()
		STOP_PROCESSING(SSobj, src)
		visible_message("<span class='notice'>\The [src] stops burning.</span>")

/obj/structure/bonfire/proc/ignite()
	if(!burning && get_fuel_amount())
		burning = TRUE
		update_icon()
		START_PROCESSING(SSobj, src)
		visible_message("<span class='warning'>\The [src] starts burning!</span>")

/obj/structure/bonfire/proc/burn()
	var/turf/current_location = get_turf(src)
	current_location.hotspot_expose(1000, 500)
	for(var/A in current_location)
		if(A == src)
			continue
		if(isobj(A))
			var/obj/O = A
			O.fire_act(null, 1000, 500)
		else if(isliving(A) && get_fuel_amount() > 4)
			var/mob/living/L = A
			L.adjust_fire_stacks(get_fuel_amount() / 4)
			L.IgniteMob()

/obj/structure/bonfire/update_icon()
	overlays.Cut()
	if(burning)
		var/state
		switch(get_fuel_amount())
			if(0 to 4.5)
				state = "bonfire_warm"
			if(4.6 to 10)
				state = "bonfire_hot"
		var/image/I = image(icon, state)
		I.appearance_flags = RESET_COLOR
		overlays += I

		if(has_buckled_mobs() && get_fuel_amount() >= 5)
			I = image(icon, "bonfire_intense")
			I.pixel_y = 13
			I.layer = MOB_LAYER + 0.1
			I.appearance_flags = RESET_COLOR
			overlays += I

		var/light_strength = max(get_fuel_amount() / 2, 2)
		set_light(light_strength, light_strength, "#FF9933")
	else
		set_light(0)

	if(grill)
		var/image/grille_image = image(icon, "bonfire_grill")
		grille_image.appearance_flags = RESET_COLOR
		overlays += grille_image


/obj/structure/bonfire/process()
	if(!check_oxygen())
		extinguish()
		return
	if(world.time >= next_fuel_consumption)
		if(!consume_fuel(pop(contents)))
			extinguish()
			return
	if(!grill)
		burn()

	if(burning)
		var/W = get_fuel_amount()
		if(W >= 5)
			var/datum/gas_mixture/env = loc.return_air()
			if(env && abs(env.temperature - set_temperature) > 0.1)
				var/transfer_moles = 0.25 * env.total_moles
				var/datum/gas_mixture/removed = env.remove(transfer_moles)

				if(removed)
					var/heat_transfer = removed.get_thermal_energy_change(set_temperature)
					if(heat_transfer > 0)
						heat_transfer = min(heat_transfer , heating_power)

						removed.add_thermal_energy(heat_transfer)

				env.merge(removed)

/obj/structure/bonfire/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	ignite()

/obj/structure/bonfire/water_act(amount)
	if(prob(amount * 10))
		extinguish()

/obj/structure/bonfire/post_buckle_mob(mob/living/M)
	if(M.buckled == src) // Just buckled someone
		M.pixel_y += 13
	else // Just unbuckled someone
		M.pixel_y -= 13
	update_icon()

/obj/structure/fireplace //more like a space heater than a bonfire. A cozier alternative to both.
	name = "fireplace"
	desc = "The sound of the crackling hearth reminds you of home."
	icon = 'icons/obj/structures.dmi'
	icon_state = "fireplace"
	density = TRUE
	anchored = TRUE
	var/burning = FALSE
	var/next_fuel_consumption = 0
	var/set_temperature = T0C + 20	//K
	var/heating_power = 40000

/obj/structure/fireplace/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/stack/material/wood) || istype(W, /obj/item/stack/material/log) )
		add_fuel(W, user)

	else if(W.is_hot())
		ignite()
	else
		return ..()

/obj/structure/fireplace/attack_hand(mob/user)
	if(get_fuel_amount())
		remove_fuel(user)

/obj/structure/fireplace/proc/get_fuel_amount()
	var/F = 0
	for(var/A in contents)
		if(istype(A, /obj/item/stack/material/wood))
			F += 0.5
		if(istype(A, /obj/item/stack/material/log))
			F += 1.0
	return F

/obj/structure/fireplace/proc/remove_fuel(mob/user)
	if(get_fuel_amount())
		var/atom/movable/AM = pop(contents)
		AM.forceMove(get_turf(src))
		to_chat(user, "<span class='notice'>You take \the [AM] out of \the [src] before it has a chance to burn away.</span>")
		update_icon()

/obj/structure/fireplace/proc/add_fuel(atom/movable/new_fuel, mob/user)
	if(get_fuel_amount() >= 10)
		to_chat(user, "<span class='warning'>\The [src] already has enough fuel!</span>")
		return FALSE
	if(istype(new_fuel, /obj/item/stack/material/wood) || istype(new_fuel, /obj/item/stack/material/log) )
		var/obj/item/stack/F = new_fuel
		var/obj/item/stack/S = F.split(1)
		if(S)
			S.forceMove(src)
			to_chat(user, "<span class='warning'>You add \the [new_fuel] to \the [src].</span>")
			update_icon()
			return TRUE
		return FALSE
	else
		to_chat(user, "<span class='warning'>\The [src] needs raw wood to burn, \a [new_fuel] won't work.</span>")
		return FALSE

/obj/structure/fireplace/proc/consume_fuel(var/obj/item/stack/consumed_fuel)
	if(!istype(consumed_fuel))
		qdel(consumed_fuel) // Don't know, don't care.
		return FALSE

	if(istype(consumed_fuel, /obj/item/stack/material/log))
		next_fuel_consumption = world.time + 2 MINUTES
		qdel(consumed_fuel)
		update_icon()
		return TRUE

	else if(istype(consumed_fuel, /obj/item/stack/material/wood)) // One log makes two planks of wood.
		next_fuel_consumption = world.time + 1 MINUTE
		qdel(consumed_fuel)
		update_icon()
		return TRUE
	return FALSE

/obj/structure/fireplace/proc/check_oxygen()
	var/datum/gas_mixture/G = loc.return_air()
	if(G.gas["oxygen"] < 1)
		return FALSE
	return TRUE

/obj/structure/fireplace/proc/extinguish()
	if(burning)
		burning = FALSE
		update_icon()
		STOP_PROCESSING(SSobj, src)
		visible_message("<span class='notice'>\The [src] stops burning.</span>")

/obj/structure/fireplace/proc/ignite()
	if(!burning && get_fuel_amount())
		burning = TRUE
		update_icon()
		START_PROCESSING(SSobj, src)
		visible_message("<span class='warning'>\The [src] starts burning!</span>")

/obj/structure/fireplace/proc/burn()
	var/turf/current_location = get_turf(src)
	current_location.hotspot_expose(1000, 500)
	for(var/A in current_location)
		if(A == src)
			continue
		if(isobj(A))
			var/obj/O = A
			O.fire_act(null, 1000, 500)

/obj/structure/fireplace/update_icon()
	overlays.Cut()
	if(burning)
		var/state
		switch(get_fuel_amount())
			if(0 to 3.5)
				state = "fireplace_warm"
			if(3.6 to 6.5)
				state = "fireplace_hot"
			if(6.6 to 10)
				state = "fireplace_intense" //don't need to throw a corpse inside to make it burn hotter.
		var/image/I = image(icon, state)
		I.appearance_flags = RESET_COLOR
		overlays += I

		var/light_strength = max(get_fuel_amount() / 2, 2)
		set_light(light_strength, light_strength, "#FF9933")
	else
		set_light(0)

/obj/structure/fireplace/process()
	if(!check_oxygen())
		extinguish()
		return
	if(world.time >= next_fuel_consumption)
		if(!consume_fuel(pop(contents)))
			extinguish()
			return

	if(burning)
		var/W = get_fuel_amount()
		if(W >= 5)
			var/datum/gas_mixture/env = loc.return_air()
			if(env && abs(env.temperature - set_temperature) > 0.1)
				var/transfer_moles = 0.25 * env.total_moles
				var/datum/gas_mixture/removed = env.remove(transfer_moles)

				if(removed)
					var/heat_transfer = removed.get_thermal_energy_change(set_temperature)
					if(heat_transfer > 0)
						heat_transfer = min(heat_transfer , heating_power)

						removed.add_thermal_energy(heat_transfer)

				env.merge(removed)

/obj/structure/fireplace/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	ignite()

/obj/structure/fireplace/water_act(amount)
	if(prob(amount * 10))
		extinguish()