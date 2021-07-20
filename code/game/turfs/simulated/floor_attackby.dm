/turf/simulated/floor/attackby(var/obj/item/C, var/mob/user)

	if(!C || !user)
		return 0

	if(isliving(user) && istype(C, /obj/item/weapon))
		var/mob/living/L = user
		if(L.a_intent != I_HELP)
			attack_tile(C, L) // Be on help intent if you want to decon something.
			return

	if(!(C.is_screwdriver() && flooring && (flooring.flags & TURF_REMOVE_SCREWDRIVER)) && try_graffiti(user, C))
		return

	// Multi-z roof building
	if(istype(C, /obj/item/stack/tile/roofing))
		var/expended_tile = FALSE // To track the case. If a ceiling is built in a multiz zlevel, it also necessarily roofs it against weather
		var/turf/T = GetAbove(src)
		var/obj/item/stack/tile/roofing/R = C

		// Patch holes in the ceiling
		if(T)
			if(istype(T, /turf/simulated/open) || istype(T, /turf/space))
			 	// Must be build adjacent to an existing floor/wall, no floating floors
				var/list/cardinalTurfs = list() // Up a Z level
				for(var/dir in cardinal)
					var/turf/B = get_step(T, dir)
					if(B)
						cardinalTurfs += B

				var/turf/simulated/A = locate(/turf/simulated/floor) in cardinalTurfs
				if(!A)
					A = locate(/turf/simulated/wall) in cardinalTurfs
				if(!A)
					to_chat(user, "<span class='warning'>There's nothing to attach the ceiling to!</span>")
					return

				if(R.use(1)) // Cost of roofing tiles is 1:1 with cost to place lattice and plating
					T.ReplaceWithLattice()
					T.ChangeTurf(/turf/simulated/floor, preserve_outdoors = TRUE)
					playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
					user.visible_message("<span class='notice'>[user] patches a hole in the ceiling.</span>", "<span class='notice'>You patch a hole in the ceiling.</span>")
					expended_tile = TRUE
			else
				to_chat(user, "<span class='warning'>There aren't any holes in the ceiling to patch here.</span>")
				return

		// Create a ceiling to shield from the weather
		if(src.outdoors)
			for(var/dir in cardinal)
				var/turf/A = get_step(src, dir)
				if(A && !A.outdoors)
					if(expended_tile || R.use(1))
						make_indoors()
						playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
						user.visible_message("<span class='notice'>[user] roofs a tile, shielding it from the elements.</span>", "<span class='notice'>You roof this tile, shielding it from the elements.</span>")
					break
		return

	// Floor has flooring set
	if(!is_plating())
		if(istype(C, /obj/item/weapon))
			try_deconstruct_tile(C, user)
			return
		else if(istype(C, /obj/item/stack/cable_coil))
			to_chat(user, "<span class='warning'>You must remove the [flooring.descriptor] first.</span>")
			return
		else if(istype(C, /obj/item/stack/tile))
			try_replace_tile(C, user)
			return
	
	// Floor is plating (or no flooring)
	else
		// Placing wires on plating
		if(istype(C, /obj/item/stack/cable_coil))
			if(broken || burnt)
				to_chat(user, "<span class='warning'>This section is too damaged to support anything. Use a welder to fix the damage.</span>")
				return
			var/obj/item/stack/cable_coil/coil = C
			coil.turf_place(src, user)
			return
		// Placing flooring on plating
		else if(istype(C, /obj/item/stack))
			if(broken || burnt)
				to_chat(user, "<span class='warning'>This section is too damaged to support anything. Use a welder to fix the damage.</span>")
				return
			var/obj/item/stack/S = C
			var/decl/flooring/use_flooring
			for(var/flooring_type in flooring_types)
				var/decl/flooring/F = flooring_types[flooring_type]
				if(!F.build_type)
					continue
				if((S.type == F.build_type) || (S.build_type == F.build_type))
					use_flooring = F
					break
			if(!use_flooring)
				return
			// Do we have enough?
			if(use_flooring.build_cost && S.amount < use_flooring.build_cost)
				to_chat(user, "<span class='warning'>You require at least [use_flooring.build_cost] [S.name] to complete the [use_flooring.descriptor].</span>")
				return
			// Stay still and focus...
			if(use_flooring.build_time && !do_after(user, use_flooring.build_time))
				return
			if(!is_plating() || !S || !user || !use_flooring)
				return
			if(S.use(use_flooring.build_cost))
				set_flooring(use_flooring)
				playsound(src, 'sound/items/Deconstruct.ogg', 80, 1)
				return
		// Plating repairs and removal
		else if(istype(C, /obj/item/weapon/weldingtool))
			var/obj/item/weapon/weldingtool/welder = C
			if(welder.isOn())
				// Needs repairs
				if(broken || burnt)
					if(welder.remove_fuel(0,user))
						to_chat(user, "<span class='notice'>You fix some dents on the broken plating.</span>")
						playsound(src, welder.usesound, 80, 1)
						icon_state = "plating"
						burnt = null
						broken = null
					else
						to_chat(user, "<span class='warning'>You need more welding fuel to complete this task.</span>")
				// Deconstructing plating
				else
					var/base_type = get_base_turf_by_area(src)
					if(type == base_type || !base_type)
						to_chat(user, "<span class='warning'>There's nothing under [src] to expose by cutting.</span>")
						return
					if(!can_remove_plating(user))
						return
					
					user.visible_message("<span class='warning'>[user] begins cutting through [src].</span>", "<span class='warning'>You begin cutting through [src].</span>")
					// This is slow because it's a potentially hostile action to just cut through places into space in the middle of the bar and such
					// Presumably also the structural floor is thick?
					if(do_after(user, 10 SECONDS, src, TRUE, exclusive = TASK_ALL_EXCLUSIVE))
						if(!can_remove_plating(user))
							return // Someone slapped down some flooring or cables or something
						do_remove_plating(C, user, base_type)

/turf/simulated/floor/proc/try_deconstruct_tile(obj/item/weapon/W as obj, mob/user as mob)
	if(W.is_crowbar())
		if(broken || burnt)
			to_chat(user, "<span class='notice'>You remove the broken [flooring.descriptor].</span>")
			make_plating()
		else if(flooring.flags & TURF_IS_FRAGILE)
			to_chat(user, "<span class='danger'>You forcefully pry off the [flooring.descriptor], destroying them in the process.</span>")
			make_plating()
		else if(flooring.flags & TURF_REMOVE_CROWBAR)
			to_chat(user, "<span class='notice'>You lever off the [flooring.descriptor].</span>")
			make_plating(1)
		else
			return 0
		playsound(src, W.usesound, 80, 1)
		return 1
	else if(W.is_screwdriver() && (flooring.flags & TURF_REMOVE_SCREWDRIVER))
		if(broken || burnt)
			return 0
		to_chat(user, "<span class='notice'>You unscrew and remove the [flooring.descriptor].</span>")
		make_plating(1)
		playsound(src, W.usesound, 80, 1)
		return 1
	else if(W.is_wrench() && (flooring.flags & TURF_REMOVE_WRENCH))
		to_chat(user, "<span class='notice'>You unwrench and remove the [flooring.descriptor].</span>")
		make_plating(1)
		playsound(src, W.usesound, 80, 1)
		return 1
	else if(istype(W, /obj/item/weapon/shovel) && (flooring.flags & TURF_REMOVE_SHOVEL))
		to_chat(user, "<span class='notice'>You shovel off the [flooring.descriptor].</span>")
		make_plating(1)
		playsound(src, 'sound/items/Deconstruct.ogg', 80, 1)
		return 1
	return 0

/turf/simulated/floor/proc/try_replace_tile(obj/item/stack/tile/T as obj, mob/user as mob)
	if(T.type == flooring.build_type)
		return
	var/obj/item/weapon/W = user.is_holding_item_of_type(/obj/item/weapon)
	if(!istype(W))
		return
	if(!try_deconstruct_tile(W, user))
		return
	if(flooring)
		return
	attackby(T, user)

/turf/simulated/floor/proc/can_remove_plating(mob/user)
	if(!is_plating())
		to_chat(user, "<span class='warning'>\The [src] can't be cut through!</span>")
		return FALSE
	if(locate(/obj/structure) in contents)
		to_chat(user, "<span class='warning'>\The [src] has structures that must be removed before cutting!</span>")
		return FALSE
	return TRUE

/turf/simulated/floor/proc/do_remove_plating(obj/item/weapon/W, mob/user, base_type)
	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if(!WT.remove_fuel(5,user))
			to_chat(user, "<span class='warning'>You don't have enough fuel in [WT] finish cutting through [src].</span>")
			return
		playsound(src, WT.usesound, 80, 1)

	// Keep in mind, turfs can never actually be deleted in byond, after this line
	// our turf is just 'magically changed' to the new type and src refers to that
	ChangeTurf(base_type, preserve_outdoors = TRUE)

	var/static/list/floors_that_need_lattice = list(
		/turf/space,
		/turf/simulated/open
	)
	if(is_type_in_list(src, floors_that_need_lattice))
		new /obj/structure/lattice(src)
