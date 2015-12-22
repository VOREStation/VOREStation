var/list/mining_overlay_cache = list()

/**********************Mineral deposits**************************/
/turf/unsimulated/mineral
	name = "impassable rock"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rock-dark"

/turf/simulated/mineral //wall piece
	name = "rock"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rock"
	oxygen = 0
	nitrogen = 0
	opacity = 1
	density = 1
	blocks_air = 1
	temperature = T0C

	var/ore/mineral
	var/sand_dug
	var/mined_ore = 0
	var/last_act = 0
	var/emitter_blasts_taken = 0 // EMITTER MINING! Muhehe.
	var/overlay_detail

	var/datum/geosample/geologic_data
	var/excavation_level = 0
	var/list/finds
	var/next_rock = 0
	var/archaeo_overlay = ""
	var/excav_overlay = ""
	var/obj/item/weapon/last_find
	var/datum/artifact_find/artifact_find
	var/ignore_mapgen

	has_resources = 1

/turf/simulated/mineral/ignore_mapgen
	ignore_mapgen = 1

/turf/simulated/mineral/floor
	name = "sand"
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_state = "asteroid"
	density = 0
	opacity = 0
	blocks_air = 0

/turf/simulated/mineral/floor/ignore_mapgen
	ignore_mapgen = 1

/turf/simulated/mineral/proc/make_floor()
	if(!density && !opacity)
		return
	density = 0
	opacity = 0
	blocks_air = 0
	update_general()

/turf/simulated/mineral/proc/make_wall()
	if(density && opacity)
		return
	density = 1
	opacity = 1
	blocks_air = 1
	update_general()

/turf/simulated/mineral/proc/update_general()
	update_icon(1)
	if(ticker && ticker.current_state == GAME_STATE_PLAYING)
		reconsider_lights()
		if(air_master)
			air_master.mark_for_update(src)

/turf/simulated/mineral/Entered(atom/movable/M as mob|obj)
	. = ..()
	if(istype(M,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = M
		if(R.module)
			for(var/obj/item/weapon/storage/bag/ore/O in list(R.module_state_1, R.module_state_2, R.module_state_3))
				attackby(O, R)
				return

/turf/simulated/mineral/initialize()
	if(prob(20))
		overlay_detail = "asteroid[rand(0,9)]"
	if(density)
		spawn(0)
			MineralSpread()
	update_icon(1)

/turf/simulated/mineral/update_icon(var/update_neighbors)

	overlays.Cut()

	if(density)
		if(mineral)
			name = "[mineral.display_name] deposit"
		else
			name = "rock"

		icon = 'icons/turf/walls.dmi'
		icon_state = "rock"

		for(var/direction in cardinal)
			var/turf/T = get_step(src,direction)
			if(istype(T) && !T.density)
				var/place_dir = turn(direction, 180)
				if(!mining_overlay_cache["rock_side_[place_dir]"])
					mining_overlay_cache["rock_side_[place_dir]"] = image('icons/turf/walls.dmi', "rock_side", dir = place_dir)
				T.overlays += mining_overlay_cache["rock_side_[place_dir]"]
	else

		name = "sand"
		icon = 'icons/turf/flooring/asteroid.dmi'
		icon_state = "asteroid"

		if(sand_dug)
			if(!mining_overlay_cache["dug_overlay"])
				mining_overlay_cache["dug_overlay"] = image('icons/turf/flooring/asteroid.dmi', "dug_overlay")
			overlays += mining_overlay_cache["dug_overlay"]

		for(var/direction in cardinal)
			if(istype(get_step(src, direction), /turf/space))
				if(!mining_overlay_cache["asteroid_edge_[direction]"])
					mining_overlay_cache["asteroid_edge_[direction]"] = image('icons/turf/flooring/asteroid.dmi', "asteroid_edges", dir = direction)
				overlays += mining_overlay_cache["asteroid_edge_[direction]"]
			else
				var/turf/simulated/mineral/M = get_step(src, direction)
				if(istype(M) && M.density)
					if(!mining_overlay_cache["rock_side_[direction]"])
						mining_overlay_cache["rock_side_[direction]"] = image('icons/turf/walls.dmi', "rock_side", dir = direction)
					overlays += mining_overlay_cache["rock_side_[direction]"]

		if(overlay_detail)

			if(!mining_overlay_cache["decal_[overlay_detail]"])
				mining_overlay_cache["decal_[overlay_detail]"] = image(icon = 'icons/turf/flooring/decals.dmi', icon_state = overlay_detail)
			overlays += mining_overlay_cache["decal_[overlay_detail]"]

		if(update_neighbors)
			for(var/direction in alldirs)
				if(istype(get_step(src, direction), /turf/simulated/mineral))
					var/turf/simulated/mineral/M = get_step(src, direction)
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

/turf/simulated/mineral/bullet_act(var/obj/item/projectile/Proj)

	// Emitter blasts
	if(istype(Proj, /obj/item/projectile/beam/emitter))
		emitter_blasts_taken++
		if(emitter_blasts_taken > 2) // 3 blasts per tile
			mined_ore = 1
			GetDrilled()

/turf/simulated/mineral/Bumped(AM)

	. = ..()

	if(!density)
		return .

	if(istype(AM,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = AM
		if((istype(H.l_hand,/obj/item/weapon/pickaxe)) && (!H.hand))
			attackby(H.l_hand,H)
		else if((istype(H.r_hand,/obj/item/weapon/pickaxe)) && H.hand)
			attackby(H.r_hand,H)

	else if(istype(AM,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = AM
		if(istype(R.module_active,/obj/item/weapon/pickaxe))
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
		new /obj/effect/mineral(src, mineral)
	update_icon()

//Not even going to touch this pile of spaghetti
/turf/simulated/mineral/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if (!(istype(usr, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")
		usr << "<span class='warning'>You don't have the dexterity to do this!</span>"
		return

	if(!density)

		var/list/usable_tools = list(
			/obj/item/weapon/shovel,
			/obj/item/weapon/pickaxe/diamonddrill,
			/obj/item/weapon/pickaxe/drill,
			/obj/item/weapon/pickaxe/borgdrill
			)

		var/valid_tool
		for(var/valid_type in usable_tools)
			if(istype(W,valid_type))
				valid_tool = 1
				break

		if(valid_tool)
			if (sand_dug)
				user << "<span class='warning'>This area has already been dug.</span>"
				return

			var/turf/T = user.loc
			if (!(istype(T)))
				return

			user << "<span class='notice'>You start digging.</span>"
			playsound(user.loc, 'sound/effects/rustle1.ogg', 50, 1)

			if(!do_after(user,40)) return

			user << "<span class='notice'>You dug a hole.</span>"
			GetDrilled()

		else if(istype(W,/obj/item/weapon/storage/bag/ore))
			var/obj/item/weapon/storage/bag/ore/S = W
			if(S.collection_mode)
				for(var/obj/item/weapon/ore/O in contents)
					O.attackby(W,user)
					return

		else if(istype(W,/obj/item/weapon/storage/bag/fossils))
			var/obj/item/weapon/storage/bag/fossils/S = W
			if(S.collection_mode)
				for(var/obj/item/weapon/fossil/F in contents)
					F.attackby(W,user)
					return

		else if(istype(W, /obj/item/stack/rods))
			var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
			if(L)
				return
			var/obj/item/stack/rods/R = W
			if (R.use(1))
				user << "<span class='notice'>Constructing support lattice ...</span>"
				playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
				new /obj/structure/lattice(get_turf(src))

		else if(istype(W, /obj/item/stack/tile/floor))
			var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
			if(L)
				var/obj/item/stack/tile/floor/S = W
				if (S.get_amount() < 1)
					return
				qdel(L)
				playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
				ChangeTurf(/turf/simulated/floor)
				S.use(1)
				return
			else
				user << "<span class='warning'>The plating is going to need some support.</span>"
				return


	else
		if (istype(W, /obj/item/device/core_sampler))
			geologic_data.UpdateNearbyArtifactInfo(src)
			var/obj/item/device/core_sampler/C = W
			C.sample_item(src, user)
			return

		if (istype(W, /obj/item/device/depth_scanner))
			var/obj/item/device/depth_scanner/C = W
			C.scan_atom(user, src)
			return

		if (istype(W, /obj/item/device/measuring_tape))
			var/obj/item/device/measuring_tape/P = W
			user.visible_message("<span class='notice'>\The [user] extends \a [P] towards \the [src].</span>","<span class='notice'>You extend \the [P] towards \the [src].</span>")
			if(do_after(user,25))
				user << "<span class='notice'>\icon[P] [src] has been excavated to a depth of [2*excavation_level]cm.</span>"
			return

		if (istype(W, /obj/item/weapon/pickaxe))
			var/turf/T = user.loc
			if (!( istype(T, /turf) ))
				return

			var/obj/item/weapon/pickaxe/P = W
			if(last_act + P.digspeed > world.time)//prevents message spam
				return
			last_act = world.time

			playsound(user, P.drill_sound, 20, 1)

			//handle any archaeological finds we might uncover
			var/fail_message
			if(finds && finds.len)
				var/datum/find/F = finds[1]
				if(excavation_level + P.excavation_amount > F.excavation_required)
					//Chance to destroy / extract any finds here
					fail_message = ". <b>[pick("There is a crunching noise","[W] collides with some different rock","Part of the rock face crumbles away","Something breaks under [W]")]</b>"

			user << "<span class='notice'>You start [P.drill_verb][fail_message ? fail_message : ""].</span>"

			if(fail_message && prob(90))
				if(prob(25))
					excavate_find(5, finds[1])
				else if(prob(50))
					finds.Remove(finds[1])
					if(prob(50))
						artifact_debris()

			if(do_after(user,P.digspeed))
				user << "<span class='notice'>You finish [P.drill_verb] \the [src].</span>"

				if(finds && finds.len)
					var/datum/find/F = finds[1]
					if(round(excavation_level + P.excavation_amount) == F.excavation_required)
						//Chance to extract any items here perfectly, otherwise just pull them out along with the rock surrounding them
						if(excavation_level + P.excavation_amount > F.excavation_required)
							//if you can get slightly over, perfect extraction
							excavate_find(100, F)
						else
							excavate_find(80, F)

					else if(excavation_level + P.excavation_amount > F.excavation_required - F.clearance_range)
						//just pull the surrounding rock out
						excavate_find(0, F)

				if( excavation_level + P.excavation_amount >= 100 )
					//if players have been excavating this turf, leave some rocky debris behind
					var/obj/structure/boulder/B
					if(artifact_find)
						if( excavation_level > 0 || prob(15) )
							//boulder with an artifact inside
							B = new(src)
							if(artifact_find)
								B.artifact_find = artifact_find
						else
							artifact_debris(1)
					else if(prob(15))
						//empty boulder
						B = new(src)

					if(B)
						GetDrilled(0)
					else
						GetDrilled(1)
					return

				excavation_level += P.excavation_amount

				//archaeo overlays
				if(!archaeo_overlay && finds && finds.len)
					var/datum/find/F = finds[1]
					if(F.excavation_required <= excavation_level + F.view_range)
						archaeo_overlay = "overlay_archaeo[rand(1,3)]"
						overlays += archaeo_overlay

				//there's got to be a better way to do this
				var/update_excav_overlay = 0
				if(excavation_level >= 75)
					if(excavation_level - P.excavation_amount < 75)
						update_excav_overlay = 1
				else if(excavation_level >= 50)
					if(excavation_level - P.excavation_amount < 50)
						update_excav_overlay = 1
				else if(excavation_level >= 25)
					if(excavation_level - P.excavation_amount < 25)
						update_excav_overlay = 1

				//update overlays displaying excavation level
				if( !(excav_overlay && excavation_level > 0) || update_excav_overlay )
					var/excav_quadrant = round(excavation_level / 25) + 1
					excav_overlay = "overlay_excv[excav_quadrant]_[rand(1,3)]"
					overlays += excav_overlay

				//drop some rocks
				next_rock += P.excavation_amount * 10
				while(next_rock > 100)
					next_rock -= 100
					var/obj/item/weapon/ore/O = new(src)
					geologic_data.UpdateNearbyArtifactInfo(src)
					O.geologic_data = geologic_data
			return

	return attack_hand(user)

/turf/simulated/mineral/proc/clear_ore_effects()
	for(var/obj/effect/mineral/M in contents)
		qdel(M)

/turf/simulated/mineral/proc/DropMineral()
	if(!mineral)
		return
	clear_ore_effects()
	var/obj/item/weapon/ore/O = new mineral.ore (src)
	if(istype(O))
		geologic_data.UpdateNearbyArtifactInfo(src)
		O.geologic_data = geologic_data
	return O

/turf/simulated/mineral/proc/GetDrilled(var/artifact_fail = 0)

	if(!density)
		if(!sand_dug)
			sand_dug = 1
			for(var/i=0;i<(rand(3)+2);i++)
				new/obj/item/weapon/ore/glass(src)
			update_icon()
		return

	if (mineral && mineral.result_amount)

		//if the turf has already been excavated, some of it's ore has been removed
		for (var/i = 1 to mineral.result_amount - mined_ore)
			DropMineral()

	//destroyed artifacts have weird, unpleasant effects
	//make sure to destroy them before changing the turf though
	if(artifact_find && artifact_fail)
		var/pain = 0
		if(prob(50))
			pain = 1
		for(var/mob/living/M in range(src, 200))
			M << "<span class='danger'>[pick("A high-pitched [pick("keening","wailing","whistle")]","A rumbling noise like [pick("thunder","heavy machinery")]")] somehow penetrates your mind before fading away!</span>"
			if(pain)
				flick("pain",M.pain)
				if(prob(50))
					M.adjustBruteLoss(5)
			else
				flick("flash",M.flash)
				if(prob(50))
					M.Stun(5)
			M.apply_effect(25, IRRADIATE)

	make_floor()
	update_icon(1)

/turf/simulated/mineral/proc/excavate_find(var/prob_clean = 0, var/datum/find/F)
	//with skill and luck, players can cleanly extract finds
	//otherwise, they come out inside a chunk of rock
	var/obj/item/weapon/X
	if(prob_clean)
		X = new /obj/item/weapon/archaeological_find(src, new_item_type = F.find_type)
	else
		X = new /obj/item/weapon/ore/strangerock(src, inside_item_type = F.find_type)
		geologic_data.UpdateNearbyArtifactInfo(src)
		X:geologic_data = geologic_data

	//some find types delete the /obj/item/weapon/archaeological_find and replace it with something else, this handles when that happens
	//yuck
	var/display_name = "Something"
	if(!X)
		X = last_find
	if(X)
		display_name = X.name

	//many finds are ancient and thus very delicate - luckily there is a specialised energy suspension field which protects them when they're being extracted
	if(prob(F.prob_delicate))
		var/obj/effect/suspension_field/S = locate() in src
		if(!S || S.field_type != get_responsive_reagent(F.find_type))
			if(X)
				visible_message("<span class='danger'>\The [pick("[display_name] crumbles away into dust","[display_name] breaks apart")].</span>")
				qdel(X)

	finds.Remove(F)

/turf/simulated/mineral/proc/artifact_debris(var/severity = 0)
	//cael's patented random limited drop componentized loot system!
	//sky's patented not-fucking-retarded overhaul!

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
					new /obj/item/weapon/material/shard(src)
			if(6)
				for(var/i=1 to rand(1,3))
					new /obj/item/weapon/material/shard/phoron(src)
			if(7)
				new /obj/item/stack/material/uranium(src, rand(5,25))

/turf/simulated/mineral/proc/make_ore(var/rare_ore)
	if(mineral)
		return

	var/mineral_name
	if(rare_ore)
		mineral_name = pickweight(list("uranium" = 10, "platinum" = 10, "iron" = 20, "coal" = 20, "diamond" = 2, "gold" = 10, "silver" = 10, "phoron" = 20))

	else
		mineral_name = pickweight(list("uranium" = 5, "platinum" = 5, "iron" = 35, "coal" = 35, "diamond" = 1, "gold" = 5, "silver" = 5, "phoron" = 10))

	if(mineral_name && (mineral_name in ore_data))
		mineral = ore_data[mineral_name]
		UpdateMineral()
	update_icon()
