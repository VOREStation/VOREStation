/obj/machinery/power/port_gen/pacman/super/potato
	name = "nuclear reactor"
	desc = "PTTO-3, an industrial all-in-one nuclear power plant by Neo-Chernobyl GmbH. It uses uranium as a fuel source. Rated for 200 kW max safe output."
	icon = 'icons/obj/power.dmi'
	icon_state = "potato"
	time_per_sheet = 1152 //same power output, but a 50 sheet stack will last 4 hours at max safe power
	power_gen = 50000 //watts
	anchored = TRUE

// Circuits for the RTGs below
/obj/item/weapon/circuitboard/machine/rtg
	name = T_BOARD("radioisotope TEG")
	build_path = /obj/machinery/power/rtg
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_DATA = 3, TECH_POWER = 3, TECH_PHORON = 3, TECH_ENGINEERING = 3)
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/weapon/stock_parts/capacitor = 1,
		/obj/item/stack/material/uranium = 10) // We have no Pu-238, and this is the closest thing to it.

/obj/item/weapon/circuitboard/machine/rtg/advanced
	name = T_BOARD("advanced radioisotope TEG")
	build_path = /obj/machinery/power/rtg/advanced
	origin_tech = list(TECH_DATA = 5, TECH_POWER = 5, TECH_PHORON = 5, TECH_ENGINEERING = 5)
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/weapon/stock_parts/capacitor = 1,
		/obj/item/weapon/stock_parts/micro_laser = 1,
		/obj/item/stack/material/uranium = 10,
		/obj/item/stack/material/phoron = 5)

/obj/item/weapon/circuitboard/machine/abductor/core
	name = T_BOARD("void generator")
	build_path = /obj/machinery/power/rtg/abductor
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_DATA = 8, TECH_POWER = 8, TECH_PHORON = 8, TECH_ENGINEERING = 8)
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/weapon/stock_parts/capacitor/hyper = 1)

/obj/item/weapon/circuitboard/machine/abductor/core/hybrid
	name = T_BOARD("void generator (hybrid)")
	build_path = /obj/machinery/power/rtg/abductor/hybrid
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_DATA = 8, TECH_POWER = 8, TECH_PHORON = 8, TECH_ENGINEERING = 8)
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/weapon/stock_parts/capacitor/hyper = 1,
		/obj/item/weapon/stock_parts/micro_laser/hyper = 1)

// Radioisotope Thermoelectric Generator (RTG)
// Simple power generator that would replace "magic SMES" on various derelicts.
/obj/machinery/power/rtg
	name = "radioisotope thermoelectric generator"
	desc = "A simple nuclear power generator, used in small outposts to reliably provide power for decades."
	icon = 'icons/obj/power_vr.dmi'
	icon_state = "rtg"
	density = TRUE
	use_power = USE_POWER_OFF
	circuit = /obj/item/weapon/circuitboard/machine/rtg

	// You can buckle someone to RTG, then open its panel. Fun stuff.
	can_buckle = TRUE
	buckle_lying = FALSE

	var/power_gen = 1000 // Enough to power a single APC. 4000 output with T4 capacitor.
	var/irradiate = TRUE // RTGs irradiate surroundings, but only when panel is open.

/obj/machinery/power/rtg/Initialize()
	. = ..()
	if(ispath(circuit))
		circuit = new circuit(src)
	default_apply_parts()
	connect_to_network()

/obj/machinery/power/rtg/process()
	..()
	add_avail(power_gen)
	if(panel_open && irradiate)
		SSradiation.radiate(src, 60)

/obj/machinery/power/rtg/RefreshParts()
	var/part_level = 0
	for(var/obj/item/weapon/stock_parts/SP in component_parts)
		part_level += SP.rating

	power_gen = initial(power_gen) * part_level

/obj/machinery/power/rtg/examine(mob/user)
	. = ..()
	if(Adjacent(user, src) || isobserver(user))
		. += "<span class='notice'>The status display reads: Power generation now at <b>[power_gen*0.001]</b>kW.</span>"

/obj/machinery/power/rtg/attackby(obj/item/I, mob/user, params)
	if(default_deconstruction_screwdriver(user, I))
		return
	else if(default_deconstruction_crowbar(user, I))
		return
	return ..()

/obj/machinery/power/rtg/update_icon()
	if(panel_open)
		icon_state = "[initial(icon_state)]-open"
	else
		icon_state = initial(icon_state)

/obj/machinery/power/rtg/advanced
	desc = "An advanced RTG capable of moderating isotope decay, increasing power output but reducing lifetime. It uses plasma-fueled radiation collectors to increase output even further."
	power_gen = 1250 // 2500 on T1, 10000 on T4.
	circuit = /obj/item/weapon/circuitboard/machine/rtg/advanced

/obj/machinery/power/rtg/fake_gen
	name = "area power generator"
	desc = "Some power generation equipment that might be powering the current area."
	icon_state = "rtg_gen"
	power_gen = 6000
	circuit = /obj/item/weapon/circuitboard/machine/rtg
	can_buckle = FALSE

/obj/machinery/power/rtg/fake_gen/RefreshParts()
	return
/obj/machinery/power/rtg/fake_gen/attackby(obj/item/I, mob/user, params)
	return
/obj/machinery/power/rtg/fake_gen/update_icon()
	return

// Void Core, power source for Abductor ships and bases.
// Provides a lot of power, but tends to explode when mistreated.
/obj/machinery/power/rtg/abductor
	name = "Void Core"
	icon_state = "core-nocell"
	desc = "An alien power source that produces energy seemingly out of nowhere."
	circuit = /obj/item/weapon/circuitboard/machine/abductor/core
	power_gen = 10000
	irradiate = FALSE // Green energy!
	can_buckle = FALSE
	pixel_y = 7
	var/going_kaboom = FALSE // Is it about to explode?
	var/obj/item/weapon/cell/void/cell

	var/icon_base = "core"
	var/state_change = TRUE

/obj/machinery/power/rtg/abductor/RefreshParts()
	..()
	if(!cell)
		power_gen = 0

/obj/machinery/power/rtg/abductor/proc/asplod()
	if(going_kaboom)
		return
	going_kaboom = TRUE
	visible_message("<span class='danger'>\The [src] lets out an shower of sparks as it starts to lose stability!</span>",\
		"<span class='italics'>You hear a loud electrical crack!</span>")
	playsound(src, 'sound/effects/lightningshock.ogg', 100, 1, extrarange = 5)
	tesla_zap(src, 5, power_gen * 0.05)
	addtimer(CALLBACK(GLOBAL_PROC, .proc/explosion, get_turf(src), 2, 3, 4, 8), 100) // Not a normal explosion.

/obj/machinery/power/rtg/abductor/bullet_act(obj/item/projectile/Proj)
	. = ..()
	if(!going_kaboom && istype(Proj) && !Proj.nodamage && ((Proj.damage_type == BURN) || (Proj.damage_type == BRUTE)))
		log_and_message_admins("[ADMIN_LOOKUPFLW(Proj.firer)] triggered an Abductor Core explosion at [x],[y],[z] via projectile.")
		asplod()

/obj/machinery/power/rtg/abductor/attack_hand(var/mob/living/user)
	if(!istype(user) || (. = ..()))
		return

	if(cell)
		cell.forceMove(get_turf(src))
		user.put_in_active_hand(cell)
		cell = null
		state_change = TRUE
		RefreshParts()
		update_icon()
		playsound(src, 'sound/effects/metal_close.ogg', 50, 1)
		return TRUE

/obj/machinery/power/rtg/abductor/attackby(obj/item/I, mob/user, params)
	state_change = TRUE //Can't tell if parent did something
	if(istype(I, /obj/item/weapon/cell/void) && !cell)
		user.remove_from_mob(I)
		I.forceMove(src)
		cell = I
		RefreshParts()
		update_icon()
		playsound(src, 'sound/effects/metal_close.ogg', 50, 1)
		return
	return ..()

/obj/machinery/power/rtg/abductor/update_icon()
	if(!state_change)
		return //Stupid cells constantly update our icon so trying to be efficient
	
	if(cell)
		if(panel_open)
			icon_state = "[icon_base]-open"
		else
			icon_state = "[icon_base]"
	else
		icon_state = "[icon_base]-nocell"

	state_change = FALSE

/obj/machinery/power/rtg/abductor/blob_act(obj/structure/blob/B)
	asplod()

/obj/machinery/power/rtg/abductor/ex_act()
	if(going_kaboom)
		qdel(src)
	else
		asplod()

/obj/machinery/power/rtg/abductor/fire_act(exposed_temperature, exposed_volume)
	asplod()

/obj/machinery/power/rtg/abductor/tesla_act()
	..() //extend the zap
	asplod()

// Comes with an installed cell
/obj/machinery/power/rtg/abductor/built
	icon_state = "core"

/obj/machinery/power/rtg/abductor/built/Initialize()
	. = ..()
	cell = new(src)
	RefreshParts()

// Bloo version
/obj/machinery/power/rtg/abductor/hybrid
	icon_state = "coreb-nocell"
	icon_base = "coreb"
	circuit = /obj/item/weapon/circuitboard/machine/abductor/core/hybrid

/obj/machinery/power/rtg/abductor/hybrid/built
	icon_state = "coreb"

/obj/machinery/power/rtg/abductor/hybrid/built/Initialize()
	. = ..()
	cell = new /obj/item/weapon/cell/void/hybrid(src)
	RefreshParts()


// Kugelblitz generator, confined black hole like a singulo but smoller and higher tech
// Presumably whoever made these has better tech than most
/obj/machinery/power/rtg/kugelblitz
	name = "kugelblitz generator"
	desc = "A power source harnessing a small black hole."
	icon = 'icons/obj/props/decor64x64.dmi'
	icon_state = "bigdice"
	bound_width = 64
	bound_height = 64
	power_gen = 30000
	irradiate = FALSE // Green energy!
	can_buckle = FALSE

/obj/machinery/power/rtg/kugelblitz/proc/asplod()
	visible_message("<span class='danger'>\The [src] lets out an shower of sparks as it starts to lose stability!</span>",\
		"<span class='italics'>You hear a loud electrical crack!</span>")
	playsound(src, 'sound/effects/lightningshock.ogg', 100, 1, extrarange = 5)
	var/turf/T = get_turf(src)
	qdel(src)
	new /obj/singularity(T)

/obj/machinery/power/rtg/kugelblitz/blob_act(obj/structure/blob/B)
	asplod()

/obj/machinery/power/rtg/kugelblitz/ex_act()
	asplod()

/obj/machinery/power/rtg/kugelblitz/fire_act(exposed_temperature, exposed_volume)
	asplod()

/obj/machinery/power/rtg/kugelblitz/tesla_act()
	..() //extend the zap
	asplod()

/obj/machinery/power/rtg/kugelblitz/bullet_act(obj/item/projectile/Proj)
	. = ..()
	if(istype(Proj) && !Proj.nodamage && ((Proj.damage_type == BURN) || (Proj.damage_type == BRUTE)) && Proj.damage >= 20)
		log_and_message_admins("[ADMIN_LOOKUPFLW(Proj.firer)] triggered a kugelblitz core explosion at [x],[y],[z] via projectile.")
		asplod()

/obj/machinery/power/rtg/d_type_reg
	name = "d-type rotary electric generator"
	desc = "It looks kind of like a large hamster wheel."
	icon = 'icons/obj/power_vrx96.dmi'
	icon_state = "reg"
	circuit = /obj/item/weapon/circuitboard/machine/reg
	irradiate = FALSE
	power_gen = 0	//It's big but it gets adjusted based on what you put into it!!!
	var/default_power_gen = 1000000
	var/part_mult = 0
	pixel_x = -32
	plane = ABOVE_MOB_PLANE
	layer = ABOVE_MOB_LAYER
	buckle_dir = EAST
	interact_offline = TRUE
	density = FALSE

/obj/machinery/power/rtg/d_type_reg/Initialize()
	. = ..()
	pixel_x = -32
	
/obj/machinery/power/rtg/d_type_reg/Destroy()
	. = ..()

/obj/machinery/power/rtg/d_type_reg/user_buckle_mob(mob/living/M, mob/user, var/forced = FALSE, var/silent = TRUE)
	. = ..()
	M.pixel_y = 8
	M.visible_message("<span class='notice'>\The [M], hops up onto \the [src] and begins running!</span>")

/obj/machinery/power/rtg/d_type_reg/unbuckle_mob(mob/living/buckled_mob, force = FALSE)
	. = ..()
	buckled_mob.pixel_y = initial(buckled_mob.pixel_y)

/obj/machinery/power/rtg/d_type_reg/RefreshParts()
	var/n = 0
	for(var/obj/item/weapon/stock_parts/SP in component_parts)
		n += SP.rating
	part_mult = n	

/obj/machinery/power/rtg/d_type_reg/attackby(obj/item/I, mob/user, params)
	if(default_deconstruction_screwdriver(user, I))
		return
	else if(default_deconstruction_crowbar(user, I))
		return
	return ..()

/obj/machinery/power/rtg/d_type_reg/update_icon()
	if(panel_open)
		icon_state = "reg-o"
	else if(buckled_mobs && buckled_mobs.len > 0)
		icon_state = "reg-a"
	else
		icon_state = "reg"

/obj/machinery/power/rtg/d_type_reg/process()
	..()
	if(buckled_mobs && buckled_mobs.len > 0)
		for(var/mob/living/L in buckled_mobs)
			runner_process(L)
	else
		power_gen = 0
	update_icon()

/obj/machinery/power/rtg/d_type_reg/proc/runner_process(var/mob/living/runner)
	if(runner.stat != CONSCIOUS)
		unbuckle_mob(runner)
		runner.visible_message("<span class='warning'>\The [runner], topples off of \the [src]!</span>")
		return
	var/cool_rotations
	if(ishuman(runner))
		var/mob/living/carbon/human/R = runner
		cool_rotations = R.movement_delay()
	else if (isanimal(runner))
		var/mob/living/simple_mob/R = runner
		cool_rotations = R.movement_delay()
	if(cool_rotations <= 0)
		cool_rotations = 0.5
	cool_rotations = default_power_gen / cool_rotations
	switch(runner.nutrition)
		if(1000 to INFINITY)	//VERY WELL FED, ZOOM!!!!
			cool_rotations *= (runner.nutrition * 0.001)
		if(500 to 1000)	//Well fed!
			cool_rotations = cool_rotations
		if(400 to 500)
			cool_rotations *= 0.9
		if(300 to 400)
			cool_rotations *= 0.75
		if(200 to 300)
			cool_rotations *= 0.5
		if(100 to 200)
			cool_rotations *= 0.25
		else	//TOO HUNGY IT TIME TO STOP!!!
			unbuckle_mob(runner)
			runner.visible_message("<span class='notice'>\The [runner], panting and exhausted hops off of \the [src]!</span>")
	if(part_mult > 1)
		cool_rotations += (cool_rotations * (part_mult - 1)) / 4
	power_gen = cool_rotations
	runner.nutrition --

/obj/machinery/power/rtg/d_type_reg/emp_act(severity)
	return

/obj/item/weapon/circuitboard/machine/reg
	name = T_BOARD("REG")
	build_path = /obj/machinery/power/rtg/d_type_reg
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_DATA = 2, TECH_POWER = 4, TECH_ENGINEERING = 4)
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/weapon/stock_parts/capacitor = 1)