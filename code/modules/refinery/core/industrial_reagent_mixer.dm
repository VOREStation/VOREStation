/obj/machinery/reagent_refinery/mixer
	name = "Industrial Chemical Mixer"
	desc = "A large mixing machine. Each input is only fed into the mixer once during each rotation."
	icon_state = "mixer"
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 0
	active_power_usage = 50
	circuit = /obj/item/circuitboard/industrial_reagent_mixer
	default_max_vol = 240 // Two large beakers of volume
	var/mixer_angle = 0
	var/mixer_rotation_rate = 45
	var/got_input = FALSE

/obj/machinery/reagent_refinery/mixer/Initialize(mapload)
	mixer_angle = dir2angle(dir)
	. = ..()
	default_apply_parts()
	// Can't be set on these
	src.verbs -= /obj/machinery/reagent_refinery/verb/set_APTFT

/obj/machinery/reagent_refinery/mixer/process()
	if(!anchored)
		return

	power_change()
	if(stat & (NOPOWER|BROKEN))
		return

	if(mixer_angle == dir2angle(dir))
		// Drain it!
		refinery_transfer()
		if(reagents.total_volume <= 0)
			mixer_angle += mixer_rotation_rate
			mixer_angle = (360 + mixer_angle) % 360
			update_icon()
		got_input = FALSE
	else
		// Check if we were filled...
		if(mixer_angle % 90 != 0) // Not cardinal, keep going
			got_input = TRUE
		else if(!(locate(/obj/machinery/reagent_refinery) in get_step(src,angle2dir(mixer_angle)))) // If nothing, keep rotating
			got_input = TRUE

		if(got_input)
			mixer_angle += mixer_rotation_rate
			mixer_angle = (360 + mixer_angle) % 360
			update_icon()
			got_input = FALSE

/obj/machinery/reagent_refinery/mixer/update_icon()
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
		var/image/filling = image(icon, loc, "mixer_r_[percent]",dir = dir)
		filling.color = reagents.get_color()
		add_overlay(filling)
	// Get main dir pipe
	var/image/pipe = image(icon, icon_state = "mixer_cons", dir = dir)
	add_overlay(pipe)
	if(anchored)
		if(!(stat & (NOPOWER|BROKEN)))
			var/image/dot = image(icon, icon_state = "mixer_dot_[ got_input ? "on" : "off" ]")
			add_overlay(dot)
		for(var/direction in GLOB.cardinal)
			var/turf/T = get_step(get_turf(src),direction)
			var/obj/machinery/other = locate(/obj/machinery/reagent_refinery) in T
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
						var/image/intake = image(icon, icon_state = "mixer_intakes", dir = direction)
						add_overlay(intake)
						continue
				if(other.dir == GLOB.reverse_dir[direction] && dir != direction)
					var/image/intake = image(icon, icon_state = "mixer_intakes", dir = direction)
					add_overlay(intake)
	// Get mixer overlay
	var/image/arm = image(icon, icon_state = "mixer_arm", dir = angle2dir(mixer_angle))
	add_overlay(arm)

/obj/machinery/reagent_refinery/mixer/attack_hand(mob/user)
	set_rotation()

/obj/machinery/reagent_refinery/mixer/verb/set_rotation()
	PRIVATE_PROC(TRUE)
	set name = "Set Mixer Rotation"
	set category = "Object"
	set src in view(1)

	if (usr.stat || usr.restrained())
		return

	if(mixer_rotation_rate > 0)
		mixer_rotation_rate = -45
		to_chat(usr,span_notice("You set \the [src] to rotate counter clockwise."))
	else
		mixer_rotation_rate = 45
		to_chat(usr,span_notice("You set \the [src] to rotate clockwise."))


/obj/machinery/reagent_refinery/mixer/examine(mob/user, infix, suffix)
	. = ..()
	. += "The meter shows [reagents.total_volume]u / [reagents.maximum_volume]u. It is pumping chemicals at a rate of [amount_per_transfer_from_this]u."
	tutorial(REFINERY_TUTORIAL_SINGLEOUTPUT, .)

/obj/machinery/reagent_refinery/mixer/handle_transfer(var/atom/origin_machine, var/datum/reagents/RT, var/source_forward_dir, var/transfer_rate, var/filter_id = "")
	// no back/forth, filters don't use just their forward, they send the side too!
	if(mixer_angle % 90 != 0) // Only handle proper directions
		return 0
	if(got_input) // Only ONCE per direction
		return 0
	if(dir == GLOB.reverse_dir[source_forward_dir])
		return 0
	if(get_turf(origin_machine) != get_step(src,angle2dir(mixer_angle))) // Check if the mixer arm is pointing at the machine too!
		return 0

	. = ..(origin_machine, RT, source_forward_dir, transfer_rate, filter_id)

	// If we transfered anything, then inform process() of it!
	if(.)
		got_input = TRUE
		update_icon()
