/obj/effect/decal/cleanable/liquid_fuel
	//Liquid fuel is used for things that used to rely on volatile fuels or phoron being contained to a couple tiles.
	icon = 'icons/effects/effects.dmi'
	icon_state = "fuel"
	plane = DIRTY_PLANE
	layer = DIRTY_LAYER
	anchored = TRUE
	var/amount = 1
	generic_filth = TRUE
	persistent = FALSE

/obj/effect/decal/cleanable/liquid_fuel/New(turf/newLoc,amt=1,nologs=1)
	if(!nologs)
		message_admins("Liquid fuel has spilled in [newLoc.loc.name] ([newLoc.x],[newLoc.y],[newLoc.z]) (<A HREF='?_src_=holder;[HrefToken()];adminplayerobservecoodjump=1;X=[newLoc.x];Y=[newLoc.y];Z=[newLoc.z]'>JMP</a>)")
		log_game("Liquid fuel has spilled in [newLoc.loc.name] ([newLoc.x],[newLoc.y],[newLoc.z])")
	src.amount = amt

	var/has_spread = 0
	//Be absorbed by any other liquid fuel in the tile.
	for(var/obj/effect/decal/cleanable/liquid_fuel/other in newLoc)
		if(other != src)
			other.amount += src.amount
			other.Spread()
			has_spread = 1
			break

	. = ..()
	if(!has_spread)
		Spread()
	else
		qdel(src)

/obj/effect/decal/cleanable/liquid_fuel/proc/Spread(exclude=list())
	//Allows liquid fuels to sometimes flow into other tiles.
	if(amount < 15) return //lets suppose welder fuel is fairly thick and sticky. For something like water, 5 or less would be more appropriate.
	var/turf/simulated/S = loc
	if(!istype(S)) return
	for(var/d in cardinal)
		var/turf/simulated/target = get_step(src,d)
		var/turf/simulated/origin = get_turf(src)
		if(origin.CanPass(src, target) && target.CanPass(src, origin))
			var/obj/effect/decal/cleanable/liquid_fuel/other_fuel = locate() in target
			if(other_fuel)
				other_fuel.amount += amount*0.25
				if(!(other_fuel in exclude))
					exclude += src
					other_fuel.Spread(exclude)
			else
				new/obj/effect/decal/cleanable/liquid_fuel(target, amount*0.25,1)
			amount *= 0.75

/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel
	icon_state = "mustard"
	anchored = FALSE

/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel/New(newLoc, amt = 1, d = 0)
	set_dir(d) //Setting this direction means you won't get torched by your own flamethrower.
	if(istype(newLoc, /turf/simulated))
		var/turf/simulated/T = newLoc
		T.hotspot_expose((T20C*2) + 380,500) //Ignite the fuel.
	. = ..()

/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel/Spread()
	//The spread for flamethrower fuel is much more precise, to create a wide fire pattern.
	if(amount <= 0.1)
		if(amount < 0.025) //Hopefully stops fuel spreading into unburnable puddles.
			qdel(src)
		return
	var/turf/simulated/S = loc
	if(!istype(S)) return

	for(var/d in list(turn(dir,90),turn(dir,-90), dir))
		var/turf/simulated/O = get_step(S,d)
		if(locate(/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel) in O)
			continue
		if(O.CanPass(src, S) && S.CanPass(src, O))
			var/new_pool_amount = amount * 0.25
			if(new_pool_amount > 0.1)
				var/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel/F = new(O, new_pool_amount, d)
				if(F.amount < 0.025) //Safety.
					qdel(F)
					return
			O.hotspot_expose((T20C*2) + 380,500) //Light flamethrower fuel on fire immediately.

	amount *= 0.25
