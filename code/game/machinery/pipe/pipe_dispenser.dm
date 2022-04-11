/obj/machinery/pipedispenser
	name = "Pipe Dispenser"
	desc = "A large machine that can rapidly dispense pipes."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "pipe_d"
	density = TRUE
	anchored = TRUE
	unacidable = TRUE
	var/unwrenched = 0
	var/wait = 0
	var/p_layer = PIPING_LAYER_REGULAR
	var/static/list/pipe_layers = list(
		"Regular" = PIPING_LAYER_REGULAR,
		"Supply" = PIPING_LAYER_SUPPLY,
		"Scrubber" = PIPING_LAYER_SCRUBBER,
		"Fuel" = PIPING_LAYER_FUEL,
		"Aux" = PIPING_LAYER_AUX
	)
	var/disposals = FALSE

// TODO - Its about time to make this NanoUI don't we think?
/obj/machinery/pipedispenser/attack_hand(var/mob/user as mob)
	if((. = ..()))
		return
	tgui_interact(user)

/obj/machinery/pipedispenser/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/pipes),
	)

/obj/machinery/pipedispenser/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PipeDispenser", name)
		ui.open()

/obj/machinery/pipedispenser/tgui_data(mob/user)
	var/list/data = list(
		"disposals" = disposals,
		"p_layer" = p_layer,
		"pipe_layers" = pipe_layers,
	)

	var/list/recipes
	if(disposals)
		recipes = GLOB.disposal_pipe_recipes
	else
		recipes = GLOB.atmos_pipe_recipes

	for(var/c in recipes)
		var/list/cat = recipes[c]
		var/list/r = list()
		for(var/i in 1 to cat.len)
			var/datum/pipe_recipe/info = cat[i]
			r += list(list("pipe_name" = info.name, "ref" = "\ref[info]"))
			// Stationary pipe dispensers don't allow you to pre-select pipe directions.
			// This makes it impossble to spawn bent versions of bendable pipes.
			// We add a "Bent" pipe type with a special param to work around it.
			if(info.dirtype == PIPE_BENDABLE)
				r += list(list(
					"pipe_name" = ("Bent " + info.name),
					"ref" = "\ref[info]",
					"bent" = TRUE
				))
		data["categories"] += list(list("cat_name" = c, "recipes" = r))

	return data

/obj/machinery/pipedispenser/tgui_act(action, params)
	if(..())
		return TRUE
	if(unwrenched || !usr.canmove || usr.stat || usr.restrained() || !in_range(loc, usr))
		return TRUE

	. = TRUE
	switch(action)
		if("p_layer")
			p_layer = text2num(params["p_layer"])
		if("dispense_pipe")
			if(!wait)				
				var/datum/pipe_recipe/recipe = locate(params["ref"])
				if(!istype(recipe))
					return
				
				var/target_dir = NORTH
				if(params["bent"])
					target_dir = NORTHEAST

				var/obj/created_object = null
				if(istype(recipe, /datum/pipe_recipe/pipe))
					var/datum/pipe_recipe/pipe/R = recipe
					created_object = new R.construction_type(loc, recipe.pipe_type, target_dir)
					var/obj/item/pipe/P = created_object
					P.setPipingLayer(p_layer)
				else if(istype(recipe, /datum/pipe_recipe/disposal))
					var/datum/pipe_recipe/disposal/D = recipe
					var/obj/structure/disposalconstruct/C = new(loc, D.pipe_type, target_dir, 0, D.subtype ? D.subtype : 0)
					C.update()
					created_object = C
				else if(istype(recipe, /datum/pipe_recipe/meter))
					created_object = new recipe.pipe_type(loc)
				else
					log_runtime(EXCEPTION("Warning: [usr] attempted to spawn pipe recipe type by params [json_encode(params)] ([recipe] [recipe?.type]), but it was not allowed by this machine ([src] [type])"))
					return

				created_object.add_fingerprint(usr)
				wait = TRUE
				VARSET_IN(src, wait, FALSE, 15)


/obj/machinery/pipedispenser/attackby(var/obj/item/W as obj, var/mob/user as mob)
	src.add_fingerprint(usr)
	if (istype(W, /obj/item/pipe) || istype(W, /obj/item/pipe_meter))
		to_chat(usr, "<span class='notice'>You put [W] back in [src].</span>")
		user.drop_item()
		qdel(W)
		return
	else if(W.is_wrench())
		if (unwrenched==0)
			playsound(src, W.usesound, 50, 1)
			to_chat(user, "<span class='notice'>You begin to unfasten \the [src] from the floor...</span>")
			if (do_after(user, 40 * W.toolspeed))
				user.visible_message( \
					"<span class='notice'>[user] unfastens \the [src].</span>", \
					"<span class='notice'>You have unfastened \the [src]. Now it can be pulled somewhere else.</span>", \
					"You hear ratchet.")
				src.anchored = FALSE
				src.stat |= MAINT
				src.unwrenched = 1
				if (usr.machine==src)
					usr << browse(null, "window=pipedispenser")
		else /*if (unwrenched==1)*/
			playsound(src, W.usesound, 50, 1)
			to_chat(user, "<span class='notice'>You begin to fasten \the [src] to the floor...</span>")
			if (do_after(user, 20 * W.toolspeed))
				user.visible_message( \
					"<span class='notice'>[user] fastens \the [src].</span>", \
					"<span class='notice'>You have fastened \the [src]. Now it can dispense pipes.</span>", \
					"You hear ratchet.")
				src.anchored = TRUE
				src.stat &= ~MAINT
				src.unwrenched = 0
				power_change()
	else
		return ..()

/obj/machinery/pipedispenser/disposal
	name = "Disposal Pipe Dispenser"
	desc = "A large machine that can rapidly dispense pipes. This one seems to dispsense disposal pipes."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "pipe_d"
	density = TRUE
	anchored = TRUE
	disposals = TRUE

//Allow you to drag-drop disposal pipes into it
/obj/machinery/pipedispenser/disposal/MouseDrop_T(var/obj/structure/disposalconstruct/pipe as obj, mob/usr as mob)
	if(!usr.canmove || usr.stat || usr.restrained())
		return

	if (!istype(pipe) || get_dist(usr, src) > 1 || get_dist(src,pipe) > 1 )
		return

	if (pipe.anchored)
		return

	to_chat(usr, "<span class='notice'>You shove [pipe] back in [src].</span>")
	qdel(pipe)

// adding a pipe dispensers that spawn unhooked from the ground
/obj/machinery/pipedispenser/orderable
	anchored = FALSE
	unwrenched = 1

/obj/machinery/pipedispenser/disposal/orderable
	anchored = FALSE
	unwrenched = 1
