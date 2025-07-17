/obj/machinery/reagent_refinery/furnace
	name = "Industrial Chemical Furnace"
	desc = "Extracts specific chemicals, compressing and heating them until they solidify."
	icon_state = "furnace_l"
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 5
	active_power_usage = 500
	circuit = /obj/item/circuitboard/industrial_reagent_furnace
	VAR_PROTECTED/filter_side = -1 // L
	VAR_PRIVATE/filter_reagent_id = ""

	default_max_vol = 60
	VAR_PRIVATE/obj/item/reagent_containers/beaker = null // Safer than retooling all of reagent code to support a second reagent var inside this one object

/obj/machinery/reagent_refinery/furnace/alt
	filter_side = 1 // R
	icon_state = "furnace_r"

/obj/machinery/reagent_refinery/furnace/Initialize(mapload)
	. = ..()
	default_apply_parts()
	beaker = new /obj/item/reagent_containers/glass/beaker/bluespace(src) // Get it all out as fast as possible
	// Can't be set on these
	src.verbs -= /obj/machinery/reagent_refinery/verb/set_APTFT
	// Update neighbours and self for state
	update_neighbours()
	update_icon()
	AddElement(/datum/element/climbable)

/obj/machinery/reagent_refinery/furnace/Destroy()
	. = ..()
	qdel_null(beaker)

/obj/machinery/reagent_refinery/furnace/process()
	if(!anchored)
		return

	power_change()
	if(stat & (NOPOWER|BROKEN))
		return

	// extract and filter side products
	if(filter_reagent_id == "")
		return // MUST BE SET
	if(amount_per_transfer_from_this <= 0)
		return
	if(filter_reagent_id != "-1") // disabled check, and "all" check
		var/check_dir = 0
		if(filter_side == 1)
			check_dir = turn(src.dir, 270)
		else
			check_dir = turn(src.dir, 90)
		var/turf/spawn_t = get_step(get_turf(src),check_dir)

		// Suck out the reagent we're looking for into temporary holding
		if(reagents.total_volume > 0)
			for(var/datum/reagent/R in reagents.reagent_list)
				if(R && R.id == filter_reagent_id)
					reagents.trans_id_to(beaker, R.id, R.volume)

		// while loop is sane here because the beaker should always be cleaned when changing filter type,
		// and it should never end up mixed with more than 1 type of reagent
		// For sanity, and if admemes break something, I will do a clearing anyway....
		if(beaker.reagents.reagent_list.len > 1)
			beaker.reagents.clear_reagents() // Highlander rules
		var/played_sound = FALSE
		while(beaker.reagents.total_volume >= REAGENTS_PER_SHEET) // at least enough reagents to bother checking
			var/datum/reagent/R = beaker.reagents.reagent_list[1]
			var/mat_id = global.reagent_sheets[R.id]
			beaker.reagents.remove_reagent(R.id,REAGENTS_PER_SHEET)
			switch(mat_id)
				if(REFINERY_SINTERING_SMOKE)
					// Smoke em out sometimes
					if(prob(30))
						if(!played_sound)
							playsound(src, 'sound/items/electronic_assembly_emptying.ogg', 50, 1)
							playsound(src, 'sound/effects/smoke.ogg', 20, 1)
							played_sound = TRUE
						visible_message(span_notice("\The [src] vomits a gout of smoke!"))
						var/datum/effect/effect/system/smoke_spread/bad/smoke = new /datum/effect/effect/system/smoke_spread/bad
						smoke.attach(src)
						smoke.set_up(10, 0, get_turf(src), 300)
						smoke.start()
				if(REFINERY_SINTERING_EXPLODE)
					// Detonate
					if(!played_sound)
						visible_message(span_danger("\The [src] catches fire and violently explodes!"))
						played_sound = TRUE
					explosion(loc, 0, 1, 2, 4)
					visible_message("\The [src.name] detonates!")
				if(REFINERY_SINTERING_SPIDERS)
					// Spawns some spiders
					if(!played_sound)
						playsound(src, 'sound/items/fulext_deploy.wav', 40, 1)
						played_sound = TRUE
					var/i = rand(1,3)
					while(i-- > 0)
						new /obj/effect/spider/spiderling/non_growing(spawn_t)
					if(prob(20))
						i = rand(1,2)
						while(i-- > 0)
							new /obj/effect/spider/spiderling/varied(spawn_t)
				else
					var/datum/material/printing = get_material_by_name(mat_id)
					if(printing)
						// Place a sheet
						if(!played_sound)
							playsound(src, 'sound/items/electronic_assembly_emptying.ogg', 50, 1)
							played_sound = TRUE
						var/obj/item/stack/material/S = printing.place_sheet(src, 1) // One at a time
						S.forceMove(spawn_t) // autostack
						if(!istype(S))
							warning("[src] tried to eject material '[printing]', which didn't generate a proper stack when asked!")
	// dump reagents to next refinery machine if all of the target reagent has been filtered out
	var/obj/machinery/reagent_refinery/target = locate(/obj/machinery/reagent_refinery) in get_step(get_turf(src),dir)
	if(target && reagents.total_volume > 0)
		transfer_tank( reagents, target, dir)

/obj/machinery/reagent_refinery/furnace/update_icon()
	cut_overlays()
	icon_state = "furnace_[filter_side == 1 ? "r" : "l"]"

	if(reagents && reagents.total_volume > 0)
		var/image/filling = image(icon, loc, "[icon_state]_r",dir = dir)
		filling.color = reagents.get_color()
		add_overlay(filling)
	else if(beaker && beaker.reagents && beaker.reagents.total_volume > 0)
		var/image/filling = image(icon, loc, "[icon_state]_r",dir = dir)
		filling.color = beaker.reagents.get_color()
		add_overlay(filling)

/obj/machinery/reagent_refinery/furnace/attack_hand(mob/user)
	set_filter()

/obj/machinery/reagent_refinery/furnace/verb/set_filter()
	PRIVATE_PROC(TRUE)
	set name = "Set Sintering Chemical"
	set category = "Object"
	set src in view(1)

	if (usr.stat || usr.restrained())
		return

	// Get a list of reagents currently inside!
	var/list/tgui_list = list("Disabled" = "","Bypass" = "-1")
	for(var/datum/reagent/R in reagents.reagent_list)
		if(R)
			var/mat_id = global.reagent_sheets[R.id]
			if(!mat_id) // No reaction
				continue
			var/id_string = "[R.name] - ???"
			switch(mat_id)
				if(REFINERY_SINTERING_SMOKE)
					id_string = "[R.name] - DANGER"
				if(REFINERY_SINTERING_EXPLODE)
					id_string = "[R.name] - DANGER"
				if(REFINERY_SINTERING_SPIDERS)
					id_string = "[R.name] - DANGER"
				else
					var/datum/material/C = get_material_by_name(mat_id)
					if(C)
						id_string = "[R.name] - [C.display_name] [C.sheet_plural_name]"
			tgui_list[id_string] = R.id

	var/filter = "disabled"
	if(filter_reagent_id == "-1")
		filter = "sintering out nothing"
	else if(filter_reagent_id != "")
		var/datum/reagent/R = SSchemistry.chemical_reagents[filter_reagent_id]
		filter = "sintering [R.name]"
	var/select = tgui_input_list(usr, "Select chemical to sinter. It is currently [filter].", "Chemical Select", tgui_list)

	if (usr.stat || usr.restrained())
		return

	// Select if possible
	if(select && select != "")
		filter_reagent_id = tgui_list[select]
		beaker.reagents.clear_reagents()
		update_icon()

/obj/machinery/reagent_refinery/furnace/verb/flip_furnace()
	set name = "Flip Furnace Direction"
	set category = "Object"
	set src in view(1)

	if (usr.stat || usr.restrained() || anchored)
		return

	filter_side *= -1
	update_icon()

/obj/machinery/reagent_refinery/furnace/handle_transfer(var/atom/origin_machine, var/datum/reagents/RT, var/source_forward_dir, var/filter_id = "")
	// pumps, furnaces and filters can only be FED in a straight line
	if(source_forward_dir != dir)
		return 0
	. = ..(origin_machine, RT, source_forward_dir, filter_id)

/obj/machinery/reagent_refinery/furnace/examine(mob/user, infix, suffix)
	. = ..()
	var/filter = "disabled"
	if(filter_reagent_id == "-1")
		filter = "sintering out nothing"
	else if(filter_reagent_id != "")
		var/datum/reagent/R = SSchemistry.chemical_reagents[filter_reagent_id]
		filter = "sintering [R.name]"
	. += "The meter shows [reagents.total_volume]u / [reagents.maximum_volume]u. It is currently [filter]."
	. += "The sintering mold is [ (beaker.reagents.total_volume / REAGENTS_PER_SHEET) * 100 ]% full."
	tutorial(REFINERY_TUTORIAL_INPUT, .)
