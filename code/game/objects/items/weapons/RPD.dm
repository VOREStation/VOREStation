#define ATMOS_CATEGORY 0
#define DISPOSALS_CATEGORY 1
#define TRANSIT_CATEGORY 2

#define BUILD_MODE (1<<0)
#define WRENCH_MODE (1<<1)
#define DESTROY_MODE (1<<2)
#define PAINT_MODE (1<<3)

/obj/item/pipe_dispenser
	name = "Rapid Piping Device (RPD)"
	desc = "A device used to rapidly pipe things."
	icon = 'icons/obj/tools.dmi'
	icon_state = "rpd"
	item_state = "rpd"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand.dmi',
	)
	item_flags = NOBLUDGEON
	force = 10
	throwforce = 10
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_NORMAL
	matter = list(MAT_STEEL = 50000, MAT_GLASS = 25000)
	var/datum/effect_system/spark_spread/spark_system
	var/p_dir = NORTH 			// Next pipe will be built with this dir
	var/p_flipped = FALSE		// If the next pipe should be built flipped
	var/paint_color = "grey"	// Pipe color index for next pipe painted/built.
	var/category = ATMOS_CATEGORY
	var/piping_layer = PIPING_LAYER_DEFAULT
	var/obj/item/tool/wrench/tool
	var/datum/pipe_recipe/recipe	// pipe recipie selected for display/construction
	var/static/datum/pipe_recipe/first_atmos
	var/static/datum/pipe_recipe/first_disposal
	var/mode = BUILD_MODE | DESTROY_MODE | WRENCH_MODE
	var/static/list/pipe_layers = list(
		"Regular" = PIPING_LAYER_REGULAR,
		"Supply" = PIPING_LAYER_SUPPLY,
		"Scrubber" = PIPING_LAYER_SCRUBBER,
		"Fuel" = PIPING_LAYER_FUEL,
		"Aux" = PIPING_LAYER_AUX
	)

/obj/item/pipe_dispenser/Initialize()
	. = ..()
	src.spark_system = new /datum/effect_system/spark_spread
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)
	tool = new /obj/item/tool/wrench/cyborg(src) // RPDs have wrenches inside of them, so that they can wrench down spawned pipes without being used as superior wrenches themselves.

/obj/item/pipe_dispenser/proc/SetupPipes()
	if(!first_atmos)
		first_atmos = GLOB.atmos_pipe_recipes[GLOB.atmos_pipe_recipes[1]][1]
		recipe = first_atmos
	if(!first_disposal)
		first_disposal = GLOB.disposal_pipe_recipes[GLOB.disposal_pipe_recipes[1]][1]

/obj/item/pipe_dispenser/Destroy()
	qdel_null(spark_system)
	qdel_null(tool)
	return ..()

/obj/item/pipe_dispenser/attack_self(mob/user)
	tgui_interact(user)

/obj/item/pipe_dispenser/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/pipes),
	)

/obj/item/pipe_dispenser/tgui_state(mob/user)
	return GLOB.tgui_inventory_state

/obj/item/pipe_dispenser/tgui_interact(mob/user, datum/tgui/ui)
	SetupPipes()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RapidPipeDispenser", name)
		ui.open()

/obj/item/pipe_dispenser/tgui_data(mob/user)
	var/list/data = list(
		"category" = category,
		"piping_layer" = piping_layer,
		"pipe_layers" = pipe_layers,
		"preview_rows" = recipe.get_preview(p_dir),
		"categories" = list(),
		"selected_color" = paint_color,
		"paint_colors" = pipe_colors,
		"mode" = mode
	)

	var/list/recipes
	switch(category)
		if(ATMOS_CATEGORY)
			recipes = GLOB.atmos_pipe_recipes
		if(DISPOSALS_CATEGORY)
			recipes = GLOB.disposal_pipe_recipes
		// if(TRANSIT_CATEGORY)
		// 	recipes = transit_tube_recipes
	for(var/c in recipes)
		var/list/cat = recipes[c]
		var/list/r = list()
		for(var/i in 1 to cat.len)
			var/datum/pipe_recipe/info = cat[i]
			r += list(list("pipe_name" = info.name, "pipe_index" = i, "selected" = (info == recipe)))
		data["categories"] += list(list("cat_name" = c, "recipes" = r))

	return data

/obj/item/pipe_dispenser/tgui_act(action, params)
	SetupPipes()
	if(..())
		return TRUE
	if(!usr.canmove || usr.stat || usr.restrained() || !in_range(loc, usr))
		return TRUE
	var/playeffect = TRUE
	switch(action)
		if("color")
			paint_color = params["paint_color"]
		if("category")
			category = text2num(params["category"])
			switch(category)
				if(DISPOSALS_CATEGORY)
					recipe = first_disposal
				if(ATMOS_CATEGORY)
					recipe = first_atmos
				// if(TRANSIT_CATEGORY)
				// 	recipe = first_transit
			p_dir = NORTH
			playeffect = FALSE
		if("piping_layer")
			piping_layer = text2num(params["piping_layer"])
			playeffect = FALSE
		// if("ducting_layer")
		// 	ducting_layer = text2num(params["ducting_layer"])
		// 	playeffect = FALSE
		if("pipe_type")
			var/static/list/recipes
			if(!recipes)
				recipes = GLOB.disposal_pipe_recipes + GLOB.atmos_pipe_recipes
			recipe = recipes[params["category"]][text2num(params["pipe_type"])]
			p_dir = NORTH
		if("setdir")
			p_dir = text2dir(params["dir"])
			p_flipped = text2num(params["flipped"])
			playeffect = FALSE
		if("mode")
			var/n = text2num(params["mode"])
			if(mode & n)
				mode &= ~n
			else
				mode |= n
	if(playeffect)
		spark_system.start()
		playsound(get_turf(src), 'sound/effects/pop.ogg', 50, FALSE)
	return TRUE

/obj/item/pipe_dispenser/afterattack(atom/A, mob/user as mob, proximity)
	if(!user.IsAdvancedToolUser() || istype(A, /turf/space/transit) || !proximity)
		return ..()

	//So that changing the menu settings doesn't affect the pipes already being built.
	var/queued_piping_layer = piping_layer
	var/queued_p_dir = p_dir
	var/queued_p_flipped = p_flipped

	//make sure what we're clicking is valid for the current mode
	var/static/list/make_pipe_whitelist // This should probably be changed to be in line with polaris standards. Oh well.
	if(!make_pipe_whitelist)
		make_pipe_whitelist = typecacheof(list(/obj/structure/lattice, /obj/structure/girder, /obj/item/pipe))
	var/can_make_pipe = (isturf(A) || is_type_in_typecache(A, make_pipe_whitelist))

	var/can_destroy_pipe = istype(A, /obj/item/pipe) || istype(A, /obj/item/pipe_meter) || istype(A, /obj/structure/disposalconstruct)

	. = TRUE
	if((mode & DESTROY_MODE) && can_destroy_pipe)
		to_chat(user, "<span class='notice'>You start destroying a pipe...</span>")
		playsound(src, 'sound/machines/click.ogg', 50, 1)
		if(do_after(user, 2, target = A))
			activate()
			animate_deletion(A)
		return

	if((mode & PAINT_MODE)) //Paint pipes
		if(istype(A, /obj/machinery/atmospherics/pipe))
			var/obj/machinery/atmospherics/pipe/P = A
			playsound(src, 'sound/machines/click.ogg', 50, 1)
			P.change_color(pipe_colors[paint_color])
			user.visible_message("<span class='notice'>[user] paints \the [P] [paint_color].</span>", "<span class='notice'>You paint \the [P] [paint_color].</span>")
			return

	if(mode & BUILD_MODE) //Making pipes
		switch(category)
			if(ATMOS_CATEGORY)
				if(!can_make_pipe)
					return ..()
				playsound(src, 'sound/machines/click.ogg', 50, 1)
				if(istype(recipe, /datum/pipe_recipe/meter))
					to_chat(user, "<span class='notice'>You start building a meter...</span>")
					if(do_after(user, 2, target = A))
						activate()
						var/obj/item/pipe_meter/PM = new /obj/item/pipe_meter(get_turf(A))
						PM.setAttachLayer(queued_piping_layer)
						if(mode & WRENCH_MODE)
							do_wrench(PM, user)
				else if(istype(recipe, /datum/pipe_recipe/pipe))
					var/datum/pipe_recipe/pipe/R = recipe
					to_chat(user, "<span class='notice'>You start building a pipe...</span>")
					if(do_after(user, 2, target = A))
						activate()
						var/obj/machinery/atmospherics/path = R.pipe_type
						var/pipe_item_type = initial(path.construction_type) || /obj/item/pipe
						var/obj/item/pipe/P = new pipe_item_type(get_turf(A), path, queued_p_dir)

						P.update()
						P.add_fingerprint(usr)
						if(R.paintable)
							P.color = pipe_colors[paint_color]
						P.setPipingLayer(queued_piping_layer)
						if(queued_p_flipped)
							P.do_a_flip()
						if(mode & WRENCH_MODE)
							do_wrench(P, user)
						else
							build_effect(P)

			if(DISPOSALS_CATEGORY) //Making disposals pipes
				var/datum/pipe_recipe/disposal/R = recipe
				if(!istype(R) || !can_make_pipe)
					return ..()
				A = get_turf(A)
				if(istype(A, /turf/unsimulated))
					to_chat(user, "<span class='warning'>[src]'s error light flickers; there's something in the way!</span>")
					return
				to_chat(user, "<span class='notice'>You start building a disposals pipe...</span>")
				playsound(src, 'sound/machines/click.ogg', 50, 1)
				if(do_after(user, 4, target = A))
					var/obj/structure/disposalconstruct/C = new(A, R.pipe_type, queued_p_dir, queued_p_flipped, R.subtype)

					if(!C.can_place())
						to_chat(user, "<span class='warning'>There's not enough room to build that here!</span>")
						qdel(C)
						return

					activate()

					C.add_fingerprint(usr)
					C.update_icon()
					if(mode & WRENCH_MODE)
						do_wrench(C, user)
					else
						build_effect(C)

			else
				return ..()

/obj/item/pipe_dispenser/proc/build_effect(var/obj/P, var/time = 1.5)
	set waitfor = FALSE
	P.filters += filter(type = "angular_blur", size = 30)
	animate(P.filters[P.filters.len], size = 0, time = time)
	var/outline = filter(type = "outline", size = 1, color = "#22AAFF")
	P.filters += outline
	sleep(time)
	P.filters -= outline
	P.filters -= filter(type = "angular_blur", size = 0)

/obj/item/pipe_dispenser/proc/animate_deletion(var/obj/P, var/time = 1.5)
	set waitfor = FALSE
	P.filters += filter(type = "angular_blur", size = 0)
	animate(P.filters[P.filters.len], size = 30, time = time)
	sleep(time)
	if(!QDELETED(P))
		P.filters -= filter(type = "angular_blur", size = 30)
		qdel(P)

/obj/item/pipe_dispenser/proc/activate()
	playsound(src, 'sound/items/deconstruct.ogg', 50, 1)

/obj/item/pipe_dispenser/proc/do_wrench(var/atom/target, mob/user)
	var/resolved = target.attackby(tool,user)
	if(!resolved && tool && target)
		tool.afterattack(target,user,1)

#undef ATMOS_CATEGORY
#undef DISPOSALS_CATEGORY
#undef TRANSIT_CATEGORY

#undef BUILD_MODE
#undef WRENCH_MODE
#undef DESTROY_MODE
#undef PAINT_MODE
