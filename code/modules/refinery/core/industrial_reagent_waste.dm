/obj/machinery/reagent_refinery/waste_processor
	name = "Industrial Chemical Waste Processor"
	desc = "A large chemical processing chamber. Chemicals inside are energized into plasma and collected as raw energy! Unfortunately the process is only 17% efficient, a net loss of power."
	icon = 'modular_outpost/icons/obj/machines/refinery_machines.dmi'
	icon_state = "waste"
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 0
	active_power_usage = 200
	circuit = /obj/item/circuitboard/industrial_reagent_waste_processor
	default_max_vol = CARGOTANKER_VOLUME

/obj/machinery/reagent_refinery/waste_processor/Initialize(mapload)
	. = ..()
	default_apply_parts()
	// Can't be set on these
	src.verbs -= /obj/machinery/reagent_refinery/verb/set_APTFT

/obj/machinery/reagent_refinery/waste_processor/process()
	if(!anchored)
		return

	power_change()
	if(stat & (NOPOWER|BROKEN))
		return

	if (reagents.total_volume <= 0)
		return

	if (prob((reagents.total_volume / reagents.maximum_volume) * 100))
		flick("waste_burn",src)
		use_power_oneoff(active_power_usage)
		reagents.clear_reagents()

/obj/machinery/reagent_refinery/waste_processor/update_icon()
	cut_overlays()
	if(anchored)
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
					if(check_dir == GLOB.reverse_dir[direction])
						var/image/intake = image(icon, icon_state = "waste_intakes", dir = direction)
						add_overlay(intake)
						continue
				if(other.dir == GLOB.reverse_dir[direction])
					var/image/intake = image(icon, icon_state = "waste_intakes", dir = direction)
					add_overlay(intake)

/obj/machinery/reagent_refinery/waste_processor/verb/rotate_clockwise()
	set name = "Rotate Waste Processor Clockwise"
	set category = "Object"
	set src in view(1)

	if (usr.stat || usr.restrained() || anchored)
		return

	src.set_dir(turn(src.dir, 270))
	update_icon()

/obj/machinery/reagent_refinery/waste_processor/verb/rotate_counterclockwise()
	set name = "Rotate Waste Processor Counterclockwise"
	set category = "Object"
	set src in view(1)

	if (usr.stat || usr.restrained() || anchored)
		return

	src.set_dir(turn(src.dir, 90))
	update_icon()

/obj/machinery/reagent_refinery/waste_processor/handle_transfer(var/atom/origin_machine, var/datum/reagents/RT, var/source_forward_dir, var/filter_id = "")
	// Waste tanks accept from all sides
	. = ..(origin_machine, RT, source_forward_dir, filter_id)

/obj/machinery/reagent_refinery/waste_processor/examine(mob/user, infix, suffix)
	. = ..()
	. += "The meter shows [reagents.total_volume]u / [reagents.maximum_volume]u. It is pumping chemicals at a rate of [amount_per_transfer_from_this]u."

/obj/machinery/reagent_refinery/waste_processor/MouseDrop_T(var/atom/movable/C, mob/user as mob)
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
		istype(C,/obj/item/reagent_containers/food/drinks/shaker))
		// Drain it!
		C.reagents.trans_to_holder( src.reagents, src.reagents.maximum_volume)
		visible_message("\The [user] dumps \the [C] into \the [src].")
		update_icon()
		return
	. = ..()
