/turf/simulated/wall
	name = "wall"
	desc = "A huge chunk of metal used to seperate rooms."
	icon = 'icons/turf/wall_masks.dmi'
	icon_state = "generic"
	opacity = 1
	density = TRUE
	blocks_air = 1
	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 312500 //a little over 5 cm thick , 312500 for 1 m by 2.5 m by 0.25 m plasteel wall

	var/icon/wall_masks = 'icons/turf/wall_masks.dmi'
	var/damage = 0
	var/damage_overlay = 0
	var/global/damage_overlays[16]
	var/active
	var/can_open = 0
	var/datum/material/girder_material
	var/datum/material/material
	var/datum/material/reinf_material
	var/last_state
	var/construction_stage

	// There's basically always going to be wall connections, making this lazy doesn't seem like it'd help much unless you wanted to make it bitflags instead.
	var/list/wall_connections = list("0", "0", "0", "0")

// Walls always hide the stuff below them.
/turf/simulated/wall/levelupdate()
	for(var/obj/O in src)
		O.hide(1)

/turf/simulated/wall/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	. = ..()
	icon_state = "blank"

	if(materialtype && !material)
		material = materialtype
	else if(!material)
		material = DEFAULT_WALL_MATERIAL
	material = get_material_by_name(material)

	if(girdertype && !girder_material)
		girder_material = girdertype
	else if(!girder_material)
		girder_material = DEFAULT_WALL_MATERIAL
	girder_material = get_material_by_name(girder_material)

	if(rmaterialtype && !reinf_material)
		reinf_material = rmaterialtype
	if(reinf_material)
		reinf_material = get_material_by_name(reinf_material)

	update_material()
	START_PROCESSING(SSturfs, src)

/turf/simulated/wall/Destroy()
	STOP_PROCESSING(SSturfs, src)
	return ..()

/turf/simulated/wall/examine_icon()
	return icon(icon=initial(icon), icon_state=initial(icon_state))

/turf/simulated/wall/process()
	// Calling parent will kill processing
	if(!radiate())
		return PROCESS_KILL

/turf/simulated/wall/proc/get_material()
	return material

/turf/simulated/wall/bullet_act(var/obj/item/projectile/Proj)
	if(istype(Proj,/obj/item/projectile/beam))
		burn(2500)
	else if(istype(Proj,/obj/item/projectile/ion))
		burn(500)

	var/proj_damage = Proj.get_structure_damage()

	//cap the amount of damage, so that things like emitters can't destroy walls in one hit.
	var/damage = min(proj_damage, 100)

	if(Proj.damage_type == BURN && damage > 0)
		if(thermite)
			thermitemelt()

	if(istype(Proj,/obj/item/projectile/beam))
		if(material && material.reflectivity >= 0.5) // Time to reflect lasers.
			var/new_damage = damage * material.reflectivity
			var/outgoing_damage = damage - new_damage
			damage = new_damage
			Proj.damage = outgoing_damage

			visible_message("<span class='danger'>\The [src] reflects \the [Proj]!</span>")

			// Find a turf near or on the original location to bounce to
			var/new_x = Proj.starting.x + pick(0, 0, 0, -1, 1, -2, 2)
			var/new_y = Proj.starting.y + pick(0, 0, 0, -1, 1, -2, 2)
			//var/turf/curloc = get_turf(src)
			var/turf/curloc = get_step(src, get_dir(src, Proj.starting))

			Proj.penetrating += 1 // Needed for the beam to get out of the wall.

			// redirect the projectile
			Proj.redirect(new_x, new_y, curloc, null)

	take_damage(damage)
	return

/turf/simulated/wall/hitby(AM as mob|obj, var/speed=THROWFORCE_SPEED_DIVISOR)
	..()
	if(ismob(AM))
		return

	var/tforce = AM:throwforce * (speed/THROWFORCE_SPEED_DIVISOR)
	if (tforce < 15)
		return

	take_damage(tforce)

/turf/simulated/wall/proc/clear_plants()
	for(var/obj/effect/overlay/wallrot/WR in src)
		qdel(WR)
	for(var/obj/effect/plant/plant in range(src, 1))
		if(!plant.floor) //shrooms drop to the floor
			plant.floor = 1
			plant.update_icon()
			plant.pixel_x = 0
			plant.pixel_y = 0
		plant.update_neighbors()

/turf/simulated/wall/ChangeTurf(var/turf/N, var/tell_universe, var/force_lighting_update, var/preserve_outdoors)
	clear_plants()
	..(N, tell_universe, force_lighting_update, preserve_outdoors)

//Appearance
/turf/simulated/wall/examine(mob/user)
	. = ..()

	if(!damage)
		. += "<span class='notice'>It looks fully intact.</span>"
	else
		var/dam = damage / material.integrity
		if(dam <= 0.3)
			. += "<span class='warning'>It looks slightly damaged.</span>"
		else if(dam <= 0.6)
			. += "<span class='warning'>It looks moderately damaged.</span>"
		else
			. += "<span class='danger'>It looks heavily damaged.</span>"

	if(locate(/obj/effect/overlay/wallrot) in src)
		. += "<span class='warning'>There is fungus growing on [src].</span>"

//Damage

/turf/simulated/wall/melt()

	if(!can_melt())
		return

	src.ChangeTurf(/turf/simulated/floor/plating)

	var/turf/simulated/floor/F = src
	if(!F)
		return
	F.burn_tile()
	F.icon_state = "wall_thermite"
	visible_message("<span class='danger'>\The [src] spontaneously combusts!.</span>") //!!OH SHIT!!
	return

/turf/simulated/wall/take_damage(dam)
	if(dam)
		damage = max(0, damage + dam)
		update_damage()
	return

/turf/simulated/wall/proc/update_damage()
	var/cap = material.integrity
	if(reinf_material)
		cap += reinf_material.integrity

	if(locate(/obj/effect/overlay/wallrot) in src)
		cap = cap / 10

	if(damage >= cap)
		dismantle_wall()
	else
		update_icon()

	return

/turf/simulated/wall/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)//Doesn't fucking work because walls don't interact with air :(
	burn(exposed_temperature)

/turf/simulated/wall/adjacent_fire_act(turf/simulated/floor/adj_turf, datum/gas_mixture/adj_air, adj_temp, adj_volume)
	burn(adj_temp)
	if(adj_temp > material.melting_point)
		take_damage(log(RAND_F(0.9, 1.1) * (adj_temp - material.melting_point)))

	return ..()

/turf/simulated/wall/proc/dismantle_wall(var/devastated, var/explode, var/no_product)

	playsound(src, 'sound/items/Welder.ogg', 100, 1)
	if(!no_product)
		if(reinf_material)
			reinf_material.place_dismantled_girder(src, reinf_material, girder_material)
		else
			material.place_dismantled_girder(src, null, girder_material)
		if(!devastated)
			material.place_dismantled_product(src)
			if (!reinf_material)
				material.place_dismantled_product(src)

	for(var/obj/O in src.contents) //Eject contents!
		if(istype(O,/obj/structure/sign/poster))
			var/obj/structure/sign/poster/P = O
			P.roll_and_drop(src)
		else
			O.loc = src

	clear_plants()
	material = get_material_by_name("placeholder")
	reinf_material = null
	girder_material = null
	update_connections(1)

	ChangeTurf(/turf/simulated/floor/plating)

/turf/simulated/wall/ex_act(severity)
	switch(severity)
		if(1.0)
			if(girder_material.explosion_resistance >= 25 && prob(girder_material.explosion_resistance))
				new /obj/structure/girder/displaced(src, girder_material.name)
			src.ChangeTurf(get_base_turf_by_area(src))
		if(2.0)
			if(prob(75))
				take_damage(rand(150, 250))
			else
				dismantle_wall(1,1)
		if(3.0)
			take_damage(rand(0, 250))
		else
			return

// Wall-rot effect, a nasty fungus that destroys walls.
/turf/simulated/wall/proc/rot()
	if(locate(/obj/effect/overlay/wallrot) in src)
		return FALSE

	// Wall-rot can't go onto walls that are surrounded in all four cardinal directions.
	// Because of spores, or something. It's actually to avoid the pain that is removing wallrot surrounded by
	// four r-walls.
	var/at_least_one_open_turf = FALSE
	for(var/direction in GLOB.cardinal)
		var/turf/T = get_step(src, direction)
		if(!T.check_density())
			at_least_one_open_turf = TRUE
			break

	if(!at_least_one_open_turf)
		return FALSE

	var/number_rots = rand(2,3)
	for(var/i=0, i<number_rots, i++)
		new/obj/effect/overlay/wallrot(src)
	return TRUE

/turf/simulated/wall/proc/can_melt()
	if(material.flags & MATERIAL_UNMELTABLE)
		return 0
	return 1

/turf/simulated/wall/proc/thermitemelt(mob/user as mob)
	if(!can_melt())
		return
	var/obj/effect/overlay/O = new/obj/effect/overlay( src )
	O.name = "Thermite"
	O.desc = "Looks hot."
	O.icon = 'icons/effects/fire.dmi'
	O.icon_state = "2"
	O.anchored = TRUE
	O.density = TRUE
	O.plane = ABOVE_PLANE

	if(girder_material.integrity >= 150 && !girder_material.is_brittle()) //Strong girders will remain in place when a wall is melted.
		dismantle_wall(1,1)
	else
		src.ChangeTurf(/turf/simulated/floor/plating)

	var/turf/simulated/floor/F = src
	F.burn_tile()
	F.icon_state = "dmg[rand(1,4)]"
	to_chat(user, "<span class='warning'>The thermite starts melting through the wall.</span>")

	spawn(100)
		if(O)
			qdel(O)
//	F.sd_LumReset()		//TODO: ~Carn
	return

/turf/simulated/wall/proc/radiate()
	var/total_radiation = material.radioactivity + (reinf_material ? reinf_material.radioactivity / 2 : 0) + (girder_material ? girder_material.radioactivity / 2 : 0)
	if(!total_radiation)
		return

	SSradiation.radiate(src, total_radiation)
	return total_radiation

/turf/simulated/wall/proc/burn(temperature)
	if(material.combustion_effect(src, temperature, 0.7))
		spawn(2)
			new /obj/structure/girder(src, girder_material.name)
			src.ChangeTurf(/turf/simulated/floor)
			for(var/turf/simulated/wall/W in range(3,src))
				W.burn((temperature/4))
			for(var/obj/machinery/door/airlock/phoron/D in range(3,src))
				D.ignite(temperature/4)

/turf/simulated/wall/can_engrave()
	return (material && material.hardness >= 10 && material.hardness <= 100)

/turf/simulated/wall/rcd_values(mob/living/user, obj/item/rcd/the_rcd, passed_mode)
	if(material.integrity > 1000) // Don't decon things like elevatorium.
		return FALSE
	if(reinf_material && !the_rcd.can_remove_rwalls) // Gotta do it the old fashioned way if your RCD can't.
		return FALSE

	if(passed_mode == RCD_DECONSTRUCT)
		var/delay_to_use = material.integrity / 3 // Steel has 150 integrity, so it'll take five seconds to down a regular wall.
		if(reinf_material)
			delay_to_use += reinf_material.integrity / 3
		return list(
			RCD_VALUE_MODE = RCD_DECONSTRUCT,
			RCD_VALUE_DELAY = delay_to_use,
			RCD_VALUE_COST = RCD_SHEETS_PER_MATTER_UNIT * 5
			)
	return FALSE

/turf/simulated/wall/rcd_act(mob/living/user, obj/item/rcd/the_rcd, passed_mode)
	if(passed_mode == RCD_DECONSTRUCT)
		to_chat(user, span("notice", "You deconstruct \the [src]."))
		ChangeTurf(/turf/simulated/floor/airless, preserve_outdoors = TRUE)
		return TRUE
	return FALSE

/turf/simulated/wall/AltClick(mob/user)
	if(isliving(user))
		var/mob/living/livingUser = user
		if(try_graffiti(livingUser, livingUser.get_active_hand()))
			return
	. = ..()