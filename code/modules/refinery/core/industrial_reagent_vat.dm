var/global/list/vats_to_rain_into = list() // Faster than checks, and handles all weather datums...

/obj/machinery/reagent_refinery/vat
	name = "Industrial Chemical Vat"
	desc = "A large mixing vat for huge quantities of chemicals. Don't fall in!"
	icon = 'modular_outpost/icons/obj/machines/refinery_machines.dmi'
	icon_state = "vat"
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 0
	active_power_usage = 50
	circuit = /obj/item/circuitboard/industrial_reagent_vat
	// Chemical bath funtimes!
	can_buckle = TRUE
	buckle_lying = TRUE
	default_max_vol = REAGENT_VAT_VOLUME

/obj/machinery/reagent_refinery/vat/Initialize(mapload)
	. = ..()
	default_apply_parts()
	vats_to_rain_into.Add(src)
	// Can't be set on these
	src.verbs -= /obj/machinery/reagent_refinery/verb/set_APTFT

/obj/machinery/reagent_refinery/vat/Destroy()
	. = ..()
	vats_to_rain_into.Remove(src)

/obj/machinery/reagent_refinery/vat/process()
	if(buckled_mobs && buckled_mobs.len && reagents.total_volume > 0)
		for(var/mob/living/L in buckled_mobs)
			reagents.trans_to(L, 1) // Soak in the juices

	if(!anchored)
		return

	power_change()
	if(stat & (NOPOWER|BROKEN))
		return

	if (amount_per_transfer_from_this <= 0 || reagents.total_volume <= 0)
		return

	// dump reagents to next refinery machine
	var/obj/machinery/reagent_refinery/target = locate(/obj/machinery/reagent_refinery) in get_step(loc,dir)
	if(target)
		transfer_tank( reagents, target, dir)

/obj/machinery/reagent_refinery/vat/update_icon()
	cut_overlays()
	// GOOBY!
	if(reagents && reagents.total_volume >= 5)
		var/percent = (reagents.total_volume / reagents.maximum_volume) * 100
		switch(percent)
			if(5 to 20)			percent = 2
			if(20 to 40) 		percent = 4
			if(40 to 60)		percent = 6
			if(60 to 80)		percent = 8
			if(80 to INFINITY)	percent = 10
		var/image/filling = image(icon, loc, "vat_r_[percent]",dir = dir)
		filling.color = reagents.get_color()
		add_overlay(filling)
	// Get main dir pipe
	var/image/pipe = image(icon, icon_state = "vat_cons", dir = dir)
	add_overlay(pipe)
	if(anchored)
		if(!(stat & (NOPOWER|BROKEN)))
			var/image/dot = image(icon, icon_state = "vat_dot_[ amount_per_transfer_from_this > 0 ? "on" : "off" ]")
			add_overlay(dot)
		for(var/direction in GLOB.cardinal)
			var/turf/T = get_step(get_turf(src),direction)
			var/obj/machinery/other = locate(/obj/machinery/reagent_refinery) in T
			if(!other) // snowflake grinders...
				other = locate(/obj/machinery/reagentgrinder/industrial) in T
			if(other && other.anchored)
				// Waste processors do not connect to anything as outgoing
				if(istype(other,/obj/machinery/reagent_refinery/waste_processor))
					continue
				// weird handling for side connections... Otherwise, anything pointing into use gets connected back!
				if(istype(other,/obj/machinery/reagent_refinery/filter))
					var/obj/machinery/reagent_refinery/filter/filt = other
					var/check_dir = 0
					if(filt.get_filter_side() == 1)
						check_dir = turn(filt.dir, 270)
					else
						check_dir = turn(filt.dir, 90)
					if(check_dir == GLOB.reverse_dir[direction] && dir != direction)
						var/image/intake = image(icon, icon_state = "vat_intakes", dir = direction)
						add_overlay(intake)
						continue
				if(other.dir == GLOB.reverse_dir[direction] && dir != direction)
					var/image/intake = image(icon, icon_state = "vat_intakes", dir = direction)
					add_overlay(intake)

/obj/machinery/reagent_refinery/vat/verb/rotate_clockwise()
	set name = "Rotate Vat Clockwise"
	set category = "Object"
	set src in view(1)

	if (usr.stat || usr.restrained() || anchored)
		return

	src.set_dir(turn(src.dir, 270))
	update_icon()

/obj/machinery/reagent_refinery/vat/verb/rotate_counterclockwise()
	set name = "Rotate Vat Counterclockwise"
	set category = "Object"
	set src in view(1)

	if (usr.stat || usr.restrained() || anchored)
		return

	src.set_dir(turn(src.dir, 90))
	update_icon()

/obj/machinery/reagent_refinery/vat/examine(mob/user, infix, suffix)
	. = ..()
	. += "The meter shows [reagents.total_volume]u / [reagents.maximum_volume]u. It is pumping chemicals at a rate of [amount_per_transfer_from_this]u."

/obj/machinery/reagent_refinery/vat/handle_transfer(var/atom/origin_machine, var/datum/reagents/RT, var/source_forward_dir, var/filter_id = "")
	// no back/forth, filters don't use just their forward, they send the side too!
	if(dir == GLOB.reverse_dir[source_forward_dir])
		return 0
	. = ..(origin_machine, RT, source_forward_dir, filter_id)

/obj/machinery/reagent_refinery/vat/MouseDrop_T(var/atom/movable/C, mob/user as mob)
	if(user.buckled || user.stat || user.restrained() || !Adjacent(user) || !user.Adjacent(C) || !istype(C) || (user == C && !user.canmove))
		return
	if(istype(C,/obj/vehicle/train/trolly_tank))
		// Drain it!
		C.reagents.trans_to_holder( src.reagents, src.reagents.maximum_volume)
		visible_message("\The [user] drains \the [C] into \the [src].")
		update_icon()
		return
	if(istype(C,/obj/item/reagent_containers/glass) || \
		istype(C,/obj/item/reagent_containers/food/drinks/glass2) || \
		istype(C,/obj/item/reagent_containers/food/drinks/shaker) || \
		istype(C,/obj/item/reagent_containers/chem_canister))
		// Drain it!
		C.reagents.trans_to_holder( src.reagents, src.reagents.maximum_volume)
		visible_message("\The [user] dumps \the [C] into \the [src].")
		update_icon()
		return
	. = ..()
