var/list/mining_overlay_cache = list()

/**********************Mineral deposits**************************/
/turf/unsimulated/mineral
	name = "impassable rock"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rock-dark"
	density = TRUE

/turf/simulated/mineral //wall piece
	name = "rock"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rock"
	oxygen = 0
	nitrogen = 0
	opacity = 1
	density = TRUE
	blocks_air = 1
	temperature = T0C
	can_dirty = FALSE

	var/floor_name = "sand"
	var/rock_side_icon_state = "rock_side"
	var/sand_icon_state = "asteroid"
	var/rock_icon_state = "rock"
	var/sand_icon_path = 'icons/turf/flooring/asteroid.dmi' // Override this on a subtype turf if you want a custom icon
	var/rock_icon_path = 'icons/turf/walls.dmi' // Override this on a subtype turf if you want a custom icon
	var/random_icon = 0

	var/ore/mineral
	var/sand_dug
	var/mined_ore = 0
	var/last_act = 0
	var/overlay_detail
	var/overlay_detail_icon_path = 'icons/turf/flooring/decals.dmi' // Override this on a subtype turf if you want a custom icon

	var/datum/geosample/geologic_data
	var/excavation_level = 0
	var/list/finds
	var/next_rock = 0
	var/archaeo_overlay = ""
	var/excav_overlay = ""
	var/obj/item/last_find
	var/datum/artifact_find/artifact_find
	var/ignore_mapgen

	var/static/list/ore_types = list(
		ORE_HEMATITE = /obj/item/ore/iron,
		ORE_URANIUM = /obj/item/ore/uranium,
		ORE_GOLD = /obj/item/ore/gold,
		ORE_SILVER = /obj/item/ore/silver,
		ORE_DIAMOND = /obj/item/ore/diamond,
		ORE_PHORON = /obj/item/ore/phoron,
		ORE_PLATINUM = /obj/item/ore/osmium,
		ORE_MHYDROGEN = /obj/item/ore/hydrogen,
		ORE_SAND = /obj/item/ore/glass,
		ORE_CARBON = /obj/item/ore/coal,
		ORE_VERDANTIUM = /obj/item/ore/verdantium,
		ORE_MARBLE = /obj/item/ore/marble,
		ORE_LEAD = /obj/item/ore/lead,
//		ORE_COPPER = /obj/item/ore/copper,
//		ORE_TIN = /obj/item/ore/tin,
//		ORE_BAUXITE = /obj/item/ore/bauxite,
//		ORE_VOPAL = /obj/item/ore/void_opal,
//		ORE_PAINITE = /obj/item/ore/painite,
//		ORE_QUARTZ = /obj/item/ore/quartz,
		ORE_RUTILE = /obj/item/ore/rutile
	)

	turf_resource_types = TURF_HAS_MINERALS

/turf/simulated/mineral/ChangeTurf(turf/N, tell_universe, force_lighting_update, preserve_outdoors)
	clear_ore_effects()
	. = ..()

// Alternative rock wall sprites.
/turf/simulated/mineral/light
	icon_state = "rock-light"
	rock_side_icon_state = "rock_side-light"
	sand_icon_state = "sand-light"
	rock_icon_state = "rock-light"
	random_icon = 1

/turf/simulated/mineral/alt
	icon_state = "rock-alt"
	rock_side_icon_state = "rock_side-alt"
	sand_icon_state = "asteroid"
	rock_icon_state = "rock-alt"

/turf/simulated/mineral/icey
	icon_state = "rock-icey"
	rock_side_icon_state = "rock_side-icey"
	sand_icon_state = "sand-icey" // to be replaced
	rock_icon_state = "rock-icey"

/turf/simulated/mineral/crystal
	icon_state = "rock-crystal"
	rock_side_icon_state = "rock_side-crystal"
	sand_icon_state = "sand-icey" // to be replaced
	rock_icon_state = "rock-crystal"

/turf/simulated/mineral/crystal_shiny
	icon_state = "rock-crystal-shiny"
	rock_side_icon_state = "rock_side-crystal"
	sand_icon_state = "sand-icey" // to be replaced
	rock_icon_state = "rock-crystal-shiny"

/turf/simulated/mineral/ignore_mapgen
	ignore_mapgen = 1

/turf/simulated/mineral/floor
	name = "sand"
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_state = "asteroid"
	density = FALSE
	opacity = 0
	blocks_air = 0
	can_build_into_floor = TRUE

/turf/simulated/mineral/floor/mud
	icon_state = "mud"
	sand_icon_state = "mud"

/turf/simulated/mineral/floor/dirt
	icon_state = "dirt"
	sand_icon_state = "dirt"

//Alternative sand floor sprite.
/turf/simulated/mineral/floor/light
	icon_state = "sand-light"
	sand_icon_state = "sand-light"

/turf/simulated/mineral/floor/icey
	icon_state = "sand-icey"
	sand_icon_state = "sand-icey" // to be replaced

/turf/simulated/mineral/floor/light_border
	icon_state = "sand-light-border"
	sand_icon_state = "sand-light-border"

/turf/simulated/mineral/floor/light_nub
	icon_state = "sand-light-nub"
	sand_icon_state = "sand-light-nub"

/turf/simulated/mineral/floor/light_corner
	icon_state = "sand-light-corner"
	sand_icon_state = "sand-light-corner"

/turf/simulated/mineral/floor/ignore_mapgen
	ignore_mapgen = 1

/turf/simulated/mineral/proc/make_floor()
	if(!density && !opacity)
		return
	density = FALSE
	opacity = 0
	blocks_air = 0
	can_build_into_floor = TRUE
	clear_ore_effects()
	update_general()

/turf/simulated/mineral/proc/make_wall()
	if(density && opacity)
		return
	density = TRUE
	opacity = 1
	blocks_air = 1
	can_build_into_floor = FALSE
	update_general()

/turf/simulated/mineral/proc/update_general()
	update_icon(1)
	recalculate_directional_opacity()
	if(ticker && ticker.current_state == GAME_STATE_PLAYING)
		reconsider_lights()
		if(SSair)
			SSair.mark_for_update(src)

/turf/simulated/mineral/proc/get_cached_border(var/cache_id, var/direction, var/icon_file, var/icon_state, var/offset = 32)
	//Cache miss
	if(!mining_overlay_cache["[cache_id]_[direction]"])
		var/image/new_cached_image = image(icon_state, dir = direction, layer = ABOVE_TURF_LAYER)
		switch(direction)
			if(NORTH)
				new_cached_image.pixel_y = offset
			if(SOUTH)
				new_cached_image.pixel_y = -offset
			if(EAST)
				new_cached_image.pixel_x = offset
			if(WEST)
				new_cached_image.pixel_x = -offset
		mining_overlay_cache["[cache_id]_[direction]"] = new_cached_image
		return new_cached_image

	//Cache hit
	return mining_overlay_cache["[cache_id]_[direction]"]

/turf/simulated/mineral/Initialize()
	. = ..()
	if(turf_resource_types & TURF_HAS_RARE_ORE)
		make_ore(1)
	else if (turf_resource_types & TURF_HAS_ORE)
		make_ore()
	if(prob(20))
		overlay_detail = "asteroid[rand(0,9)]"
	update_icon(1)
	if(density && mineral)
		. = INITIALIZE_HINT_LATELOAD
	if(random_icon)
		dir = pick(alldirs)
		. = INITIALIZE_HINT_LATELOAD

/turf/simulated/mineral/LateInitialize()
	if(density && mineral)
		MineralSpread()

/turf/simulated/mineral/update_icon(var/update_neighbors)

	cut_overlays()

	//We are a wall (why does this system work like this??)
	if(density)
		if(mineral)
			name = "[mineral.display_name] deposit"
		else
			name = "rock"

		icon = rock_icon_path
		icon_state = rock_icon_state

		//Apply overlays if we should have borders
		for(var/direction in cardinal)
			var/turf/T = get_step(src,direction)
			if(istype(T) && !T.density)
				add_overlay(get_cached_border(rock_side_icon_state,direction,icon,rock_side_icon_state))

			if(archaeo_overlay)
				add_overlay(archaeo_overlay)

			if(excav_overlay)
				add_overlay(excav_overlay)

	//We are a sand floor
	else
		name = floor_name
		icon = sand_icon_path
		icon_state = sand_icon_state

		if(sand_dug)
			add_overlay("dug_overlay")

		//Apply overlays if there's space
		for(var/direction in cardinal)
			if(istype(get_step(src, direction), /turf/space) && !istype(get_step(src, direction), /turf/space/cracked_asteroid))
				add_overlay(get_cached_border("asteroid_edge",direction,icon,"asteroid_edges", 0))

			//Or any time
			else
				var/turf/T = get_step(src, direction)
				if(istype(T) && T.density)
					add_overlay(get_cached_border(rock_side_icon_state,direction,rock_icon_path,rock_side_icon_state))

		if(overlay_detail)
			add_overlay(overlay_detail_icon_path,overlay_detail)

		if(update_neighbors)
			for(var/direction in alldirs)
				if(istype(get_step(src, direction), /turf/simulated/mineral))
					var/turf/simulated/mineral/M = get_step(src, direction)
					M.update_icon()
				if(istype(get_step(src, direction), /turf/simulated/wall/solidrock))
					var/turf/simulated/wall/solidrock/M = get_step(src, direction)
					M.update_icon()

/turf/simulated/mineral/ex_act(severity)

	switch(severity)
		if(2.0)
			if (prob(70))
				mined_ore = 1 //some of the stuff gets blown up
				GetDrilled()
		if(1.0)
			mined_ore = 2 //some of the stuff gets blown up
			GetDrilled()

	if(severity <= 2) // Now to expose the ore lying under the sand.
		spawn(1) // Otherwise most of the ore is lost to the explosion, which makes this rather moot.
			for(var/ore in resources)
				var/amount_to_give = rand(CEILING(resources[ore]/2, 1), resources[ore])  // Should result in at least one piece of ore.
				var/oretype = ore_types[ore]
				if(!oretype)
					return // this turf can't give that type
				for(var/i=1, i <= amount_to_give, i++)
					new oretype(src)
				resources[ore] = 0

/turf/simulated/mineral/bullet_act(var/obj/item/projectile/Proj) // only emitters for now
	if(Proj.excavation_amount)
		var/newDepth = excavation_level + Proj.excavation_amount // Used commonly below
		if(newDepth >= 200) // first, if the turf is completely drilled then don't bother checking for finds and just drill it
			GetDrilled(0)

		//destroy any archaeological finds
		if(finds && finds.len)
			var/datum/find/F = finds[1]
			if(newDepth > F.excavation_required) // Digging too deep with something as clumsy or random as a blaster will destroy artefacts
				finds.Remove(finds[1])
				if(prob(50))
					artifact_debris()

		excavation_level += Proj.excavation_amount
		update_archeo_overlays(Proj.excavation_amount)

/turf/simulated/mineral/Bumped(AM)

	. = ..()

	if(!density)
		return .

	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		var/obj/item/pickaxe/P = H.get_inactive_hand()
		if(istype(P))
			src.attackby(P, H)

	else if(istype(AM,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = AM
		if(istype(R.module_active,/obj/item/pickaxe))
			attackby(R.module_active,R)

	else if(istype(AM,/obj/mecha))
		var/obj/mecha/M = AM
		if(istype(M.selected,/obj/item/mecha_parts/mecha_equipment/tool/drill))
			M.selected.action(src)

/turf/simulated/mineral/proc/MineralSpread()
	if(mineral && mineral.spread)
		for(var/trydir in cardinal)
			if(prob(mineral.spread_chance))
				var/turf/simulated/mineral/target_turf = get_step(src, trydir)
				if(istype(target_turf) && target_turf.density && !target_turf.mineral)
					target_turf.mineral = mineral
					target_turf.UpdateMineral()
					target_turf.MineralSpread()


/turf/simulated/mineral/proc/UpdateMineral()
	clear_ore_effects()
	if(mineral)
		new /obj/effect/mineral(src)
	update_icon()

//Not even going to touch this pile of spaghetti
/turf/simulated/mineral/attackby(obj/item/W as obj, mob/user as mob)

	if (!user.IsAdvancedToolUser())
		to_chat(user, span_warning("You don't have the dexterity to do this!"))
		return

	if(!density)
		var/valid_tool = 0
		var/digspeed = 40

		if(istype(W, /obj/item/shovel))
			var/obj/item/shovel/S = W
			valid_tool = 1
			digspeed = S.digspeed

		if(istype(W, /obj/item/pickaxe))
			var/obj/item/pickaxe/P = W
			if(P.sand_dig)
				valid_tool = 1
				digspeed = P.digspeed

		if(valid_tool)
			if (sand_dug)
				to_chat(user, span_warning("This area has already been dug."))
				return

			var/turf/T = user.loc
			if (!(istype(T)))
				return

			to_chat(user, span_notice("You start digging."))
			playsound(user, 'sound/effects/rustle1.ogg', 50, 1)

			if(!do_after(user,digspeed)) return

			to_chat(user, span_notice("You dug a hole."))
			GetDrilled()

		else if(istype(W,/obj/item/storage/bag/ore))
			var/obj/item/storage/bag/ore/S = W
			if(S.collection_mode)
				for(var/obj/item/ore/O in contents)
					O.attackby(W,user)
					return

		else if(istype(W,/obj/item/storage/bag/fossils))
			var/obj/item/storage/bag/fossils/S = W
			if(S.collection_mode)
				for(var/obj/item/fossil/F in contents)
					F.attackby(W,user)
					return

		else if(istype(W, /obj/item/stack/tile/floor))
			var/obj/item/stack/tile/floor/S = W
			if (S.get_amount() < 1)
				return
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			ChangeTurf(/turf/simulated/floor)
			S.use(1)
			return


	else
		//This lets us get a sample of the artifact core...This is JUST used for fluff.
		if (istype(W, /obj/item/core_sampler))
			geologic_data.UpdateNearbyArtifactInfo(src)
			var/obj/item/core_sampler/C = W
			C.sample_item(src, user)
			return

		if (istype(W, /obj/item/depth_scanner))
			var/obj/item/depth_scanner/C = W
			C.scan_atom(user, src)
			return

		if (istype(W, /obj/item/measuring_tape))
			var/obj/item/measuring_tape/P = W
			user.visible_message(span_infoplain(span_bold("\The [user]") + " extends \a [P] towards \the [src]."),span_notice("You extend \the [P] towards \the [src]."))
			if(do_after(user, 15))
				to_chat(user, span_notice("\The [src] has been excavated to a depth of [excavation_level]cm."))
			return

		if(istype(W, /obj/item/xenoarch_multi_tool))
			var/obj/item/xenoarch_multi_tool/C = W
			if(C.mode) //Mode means scanning
				C.depth_scanner.scan_atom(user, src)
			else
				user.visible_message(span_infoplain(span_bold("\The [user]") + " extends \the [C] over \the [src], a flurry of red beams scanning \the [src]'s surface!"), span_notice("You extend \the [C] over \the [src], a flurry of red beams scanning \the [src]'s surface!"))
				if(do_after(user, 15))
					to_chat(user, span_notice("\The [src] has been excavated to a depth of [excavation_level]cm."))
			return

		if (istype(W, /obj/item/melee/shock_maul))
			if(!istype(user.loc, /turf))
				return

			var/obj/item/melee/shock_maul/S = W
			if(!S.wielded)
				to_chat(user, span_warning("\The [W] must be wielded in two hands to be used for mining!"))
				return

			var/newDepth = excavation_level + S.excavation_amount // Used commonly below

			//handle any archaeological finds we might uncover
			var/fail_message = ""
			if(finds && finds.len)
				var/datum/find/F = finds[1]
				if(newDepth > F.excavation_required) // Digging too deep can break the item. At least you won't summon a Balrog (probably)
					fail_message = ". <b>[pick("There is a crunching noise","[S] collides with some different rock","Part of the rock face crumbles away","Something breaks under [S]")]</b>"
					wreckfinds(S.destroy_artefacts)

			to_chat(user, span_notice("You smash through \the [src][fail_message]."))
			if(S.status != 0) //We're on. This isn't just a == 1 in case someone adds some weird functionality in the future to give it multiple states.
				user.visible_message(span_warning("\The [src] discharges with a thunderous, hair-raising crackle!"))
				playsound(src, 'sound/weapons/resonator_blast.ogg', 100, 1, -1)
			else
				user.visible_message(span_warning("\The [src] plows into the rock with a thunk, smashing it to pieces."))
				playsound(src, get_sfx("pickaxe"), 35, 1, -1) //Weak. Not on. Just as good as a normal pick.

			if(newDepth >= 200) // This means the rock is mined out fully
				if(S.destroy_artefacts)
					GetDrilled(0)
				else
					excavate_turf()
				return

			excavation_level += S.excavation_amount
			update_archeo_overlays(S.excavation_amount)
			geologic_data = new /datum/geosample(src)
			//drop some rocks
			next_rock += S.excavation_amount
			while(next_rock > 50)
				next_rock -= 50
				var/obj/item/ore/O = new(src)
				geologic_data.UpdateNearbyArtifactInfo(src)
				O.geologic_data = geologic_data

		if (istype(W, /obj/item/pickaxe))
			if(!istype(user.loc, /turf))
				return

			var/obj/item/pickaxe/P = W
			if(last_act + P.digspeed > world.time)//prevents message spam
				return
			last_act = world.time

			playsound(user, P.drill_sound, 20, 1)
			var/newDepth = excavation_level + P.excavation_amount // Used commonly below

			//handle any archaeological finds we might uncover
			var/fail_message = ""
			if(finds && finds.len)
				var/datum/find/F = finds[1]
				if(newDepth > F.excavation_required) // Digging too deep can break the item. At least you won't summon a Balrog (probably)
					fail_message = ". <b>[pick("There is a crunching noise","[W] collides with some different rock","Part of the rock face crumbles away","Something breaks under [W]")]</b>"
					wreckfinds(P.destroy_artefacts)
			to_chat(user, span_notice("You start [P.drill_verb][fail_message]."))

			if(do_after(user,P.digspeed))

				if(finds && finds.len)
					var/datum/find/F = finds[1]
					if(newDepth == F.excavation_required) // When the pick hits that edge just right, you extract your find perfectly, it's never confined in a rock
						excavate_find(1, F)
					else if(newDepth > F.excavation_required)
						excavate_find(prob(10), F) //A 1 in 10 chance to get it out perfectly seems fine if you're not being careful.

				to_chat(user, span_notice("You finish [P.drill_verb] \the [src]."))

				if(newDepth >= 200) // This means the rock is mined out fully
					if(P.destroy_artefacts)
						GetDrilled(0)
					else
						excavate_turf()
					return

				excavation_level += P.excavation_amount
				update_archeo_overlays(P.excavation_amount)
				geologic_data = new /datum/geosample(src)
				//drop some rocks
				next_rock += P.excavation_amount
				while(next_rock > 50)
					next_rock -= 50
					var/obj/item/ore/O = new(src)
					geologic_data.UpdateNearbyArtifactInfo(src)
					O.geologic_data = geologic_data
			return

	return attack_hand(user)

//THIS IS THE 'YOU HIT AN ARTIFACT AND ARE GOING TOO DEEP' PROC. This is NOT the 'you destroyed the turf' proc. For that, look at 'GetDrilled'
/turf/simulated/mineral/proc/wreckfinds(var/destroy = FALSE)
	if(!destroy) //nondestructive methods have a chance of letting you step away to not trash things
		if(prob(10))	//This is to keep  you from just running into an artifact turf over and over and over and over while also keeping a small % chance to cause a small rock to drop if you truly accidentally went too deep.
						//Technically you CAN KEEP RUNNING INTO THE TILE but like, you're wasting so much time at that point. Just buy a pick set from the mining vendor.
			excavate_find(prob(1), finds[1]) //1 in 100 chance of digging it out
	else //destructive methods will always destroy finds, no bowls menacing with spikes for you
		finds.Remove(finds[1])
		artifact_debris()

/turf/simulated/mineral/proc/update_archeo_overlays(var/excavation_amount = 0)
	var/updateIcon = 0

	//archaeo overlays
	if(!archaeo_overlay && finds && finds.len)
		var/datum/find/F = finds[1]
		if(F.excavation_required <= excavation_level + F.view_range)
			cut_overlay(archaeo_overlay)
			archaeo_overlay = "overlay_archaeo[rand(1,3)]"
			add_overlay(archaeo_overlay)

	else if(archaeo_overlay && (!finds || !finds.len))
		cut_overlay(archaeo_overlay)
		archaeo_overlay = null

	//there's got to be a better way to do this
	var/update_excav_overlay = 0
	if(excavation_level >= 150)
		if(excavation_level - excavation_amount < 150)
			update_excav_overlay = 1
	else if(excavation_level >= 100)
		if(excavation_level - excavation_amount < 100)
			update_excav_overlay = 1
	else if(excavation_level >= 50)
		if(excavation_level - excavation_amount < 50)
			update_excav_overlay = 1

	//update overlays displaying excavation level
	if( !(excav_overlay && excavation_level > 0) || update_excav_overlay )
		var/excav_quadrant = round(excavation_level / 25) + 1
		if(excav_quadrant > 5)
			excav_quadrant = 5
		cut_overlay(excav_overlay)
		excav_overlay = "overlay_excv[excav_quadrant]_[rand(1,3)]"
		add_overlay(excav_overlay)

	if(updateIcon)
		update_icon()

/turf/simulated/mineral/proc/clear_ore_effects()
	turf_resource_types &= ~(TURF_HAS_ORE | TURF_HAS_RARE_ORE)
	for(var/obj/effect/mineral/M in contents)
		qdel(M)

/turf/simulated/mineral/proc/DropMineral()
	if(!mineral)
		return
	clear_ore_effects()
	geologic_data = new /datum/geosample(src)
	var/obj/item/ore/O = new mineral.ore (src)
	if(istype(O))
		geologic_data.UpdateNearbyArtifactInfo(src)
		O.geologic_data = geologic_data
	return O

/turf/simulated/mineral/proc/excavate_turf()
	var/obj/structure/boulder/B
	if(artifact_find)
		//boulder with an artifact inside
		B = new(src)
		B.artifact_find = artifact_find

	if(B)
		GetDrilled(0)
	else
		GetDrilled(1)
	return

/turf/simulated/mineral/proc/GetDrilled(var/artifact_fail = 0)

	if(!density)
		if(!sand_dug)
			sand_dug = 1
			for(var/i=0;i<5;i++)
				new/obj/item/ore/glass(src)
			update_icon()
		return

	if (mineral && mineral.result_amount)

		//if the turf has already been excavated, some of it's ore has been removed
		for (var/i = 1 to mineral.result_amount - mined_ore)
			DropMineral()

	GLOB.rocks_drilled_roundstat++

	//destroyed artifacts have weird, unpleasant effects
	//make sure to destroy them before changing the turf though
	if(finds && finds.len && prob(10)) //You destroyed an artifact turf!
		var/pain = 0
		if(prob(50))
			pain = 1
		for(var/mob/living/M in range(src, 200))
			to_chat(M, span_danger("[pick("A high-pitched [pick("keening","wailing","whistle")]","A rumbling noise like [pick("thunder","heavy machinery")]")] somehow penetrates your mind before fading away!"))
			if(pain)
				flick("pain",M.pain)
			M.flash_eyes()
			if(prob(50))
				M.Stun(5)
			M.make_jittery(1000) //SHAKY
		if(prob(25))
			excavate_find(prob(25), finds[1])
	else if(rand(1,500) == 1)
		visible_message(span_notice("An old dusty crate was buried within!"))
		new /obj/structure/closet/crate/secure/loot(src)

	make_floor()
	update_icon(1)

/turf/simulated/mineral/proc/excavate_find(var/is_clean = 0, var/datum/find/F)
	//with skill and luck, players can cleanly extract finds
	//otherwise, they come out inside a chunk of rock
	geologic_data = new /datum/geosample(src)
	var/obj/item/X
	if(is_clean)
		X = new /obj/item/archaeological_find(src, F.find_type)
	else
		X = new /obj/item/strangerock(src, inside_item_type = F.find_type)
		geologic_data.UpdateNearbyArtifactInfo(src)
		var/obj/item/strangerock/SR = X
		SR.geologic_data = geologic_data

	//some find types delete the /obj/item/archaeological_find and replace it with something else, this handles when that happens
	//yuck
	var/display_name = "Something"
	if(!X)
		X = last_find
	if(X)
		display_name = X.name

	//This is affected by 'prob_delicate' in finds.dm. As of writing, this has been set to 0 because the suspension field is just one extra piece that makes
	//Xenoarch that much more confusing, and the intent of this PR is to make it more friendly to get into.
	//many finds are ancient and thus very delicate - luckily there is a specialised energy suspension field which protects them when they're being extracted
	if(prob(F.prob_delicate))
		var/obj/effect/suspension_field/S = locate() in src
		if(!S)
			if(X)
				visible_message(span_danger("\The [pick("[display_name] crumbles away into dust","[display_name] breaks apart")]."))
				qdel(X)

	finds.Remove(F)

/turf/simulated/mineral/proc/artifact_debris(var/severity = 0)
	//cael's patented random limited drop componentized loot system!
	//sky's patented non-mischievious overhaul!

	//Give a random amount of loot from 1 to 3 or 5, varying on severity.
	for(var/j in 1 to rand(1, 3 + max(min(severity, 1), 0) * 2))
		switch(rand(1,7))
			if(1)
				new /obj/item/stack/rods(src, rand(5,25))
			if(2)
				new /obj/item/stack/material/plasteel(src, rand(5,25))
			if(3)
				new /obj/item/stack/material/steel(src, rand(5,25))
			if(4)
				new /obj/item/stack/material/plasteel(src, rand(5,25))
			if(5)
				for(var/i=1 to rand(1,3))
					new /obj/item/material/shard(src)
			if(6)
				for(var/i=1 to rand(1,3))
					new /obj/item/material/shard/phoron(src)
			if(7)
				new /obj/item/stack/material/uranium(src, rand(5,25))

/turf/simulated/mineral/proc/make_ore(var/rare_ore)
	if(mineral || ignore_mapgen || ignore_oregen) //VOREStation Edit - Makes sense, doesn't it?
		return

	var/mineral_name
	if(rare_ore)
		mineral_name = pickweight(list(ORE_MARBLE = 5,/* ORE_QUARTZ = 15, ORE_COPPER = 10, ORE_TIN = 5, ORE_BAUXITE = 5*/, ORE_URANIUM = 15, ORE_PLATINUM = 20, ORE_HEMATITE = 15, ORE_RUTILE = 20, ORE_CARBON = 15, ORE_DIAMOND = 3, ORE_GOLD = 15, ORE_SILVER = 15, ORE_PHORON = 25, ORE_LEAD = 5,/* ORE_VOPAL = 1,*/ ORE_VERDANTIUM = 2/*, ORE_PAINITE = 1*/))

	else
		mineral_name = pickweight(list(ORE_MARBLE = 3,/* ORE_QUARTZ = 10, ORE_COPPER = 20, ORE_TIN = 15, ORE_BAUXITE = 15*/, ORE_URANIUM = 10, ORE_PLATINUM = 10, ORE_HEMATITE = 70, ORE_RUTILE = 15, ORE_CARBON = 70, ORE_DIAMOND = 2, ORE_GOLD = 10, ORE_SILVER = 10, ORE_PHORON = 20, ORE_LEAD = 3,/* ORE_VOPAL = 1,*/ ORE_VERDANTIUM = 1/*, ORE_PAINITE = 1*/))

	if(mineral_name && (mineral_name in GLOB.ore_data))
		mineral = GLOB.ore_data[mineral_name]
		UpdateMineral()
	update_icon()

// V5 turfs

/turf/simulated/mineral/icey/v5
	temperature = 202
	oxygen = 8
	nitrogen = 17
	carbon_dioxide = 75
	ignore_cavegen = TRUE

/turf/simulated/mineral/crystal/v5
	temperature = 202
	oxygen = 8
	nitrogen = 17
	carbon_dioxide = 75
	ignore_cavegen = TRUE

/turf/simulated/mineral/crystal_shiny/v5
	temperature = 202
	oxygen = 8
	nitrogen = 17
	carbon_dioxide = 75
	ignore_cavegen = TRUE
