// Foam
// Similar to smoke, but spreads out more
// metal foams leave behind a foamed metal wall

/obj/effect/effect/foam
	name = "foam"
	icon_state = "foam"
	opacity = 0
	anchored = TRUE
	density = FALSE
	layer = OBJ_LAYER + 0.9
	mouse_opacity = 0
	animate_movement = 0
	var/amount = 3
	var/expand = 1
	var/metal = 0
	var/dries = 1 //VOREStation Add
	var/slips = 0 //VOREStation Add

/obj/effect/effect/foam/Initialize(mapload, var/ismetal = 0)
	. = ..()
	//icon_state = "[ismetal? "m" : ""]foam" //VOREStation Removal
	metal = ismetal
	playsound(src, 'sound/effects/bubbles2.ogg', 80, 1, -3)
	if(dries) //VOREStation Add
		addtimer(CALLBACK(src, PROC_REF(post_spread)), 3 + metal * 3)
		addtimer(CALLBACK(src, PROC_REF(pre_harden)), 12 SECONDS)
		addtimer(CALLBACK(src, PROC_REF(harden)), 15 SECONDS)

/obj/effect/effect/foam/proc/post_spread()
	process()
	checkReagents()

/obj/effect/effect/foam/proc/pre_harden()
	return //VOREStation Edit

/obj/effect/effect/foam/proc/harden()
	if(metal)
		var/obj/structure/foamedmetal/M = new(src.loc)
		M.metal = metal
		M.update_icon()
	flick("[icon_state]-disolve", src)
	QDEL_IN(src, 5)

/obj/effect/effect/foam/proc/checkReagents() // transfer any reagents to the floor
	if(!metal && reagents)
		var/turf/T = get_turf(src)
		reagents.touch_turf(T)
		for(var/obj/O in T)
			reagents.touch_obj(O)

/obj/effect/effect/foam/process()
	if(--amount < 0)
		return

	for(var/direction in GLOB.cardinal)
		var/turf/T = get_step(src, direction)
		if(!T)
			continue

		if(!T.Enter(src))
			continue

		var/obj/effect/effect/foam/F = locate() in T
		if(F)
			continue

		F = new(T, metal)
		F.amount = amount
		if(!metal)
			F.create_reagents(10)
			if(reagents)
				for(var/datum/reagent/R in reagents.reagent_list)
					F.reagents.add_reagent(R.id, 1, safety = 1) //added safety check since reagents in the foam have already had a chance to react

/obj/effect/effect/foam/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume) // foam disolves when heated, except metal foams
	if(!metal && prob(max(0, exposed_temperature - 475)))
		flick("[icon_state]-disolve", src)

		spawn(5)
			qdel(src)

/obj/effect/effect/foam/Crossed(var/atom/movable/AM)
	if(AM.is_incorporeal())
		return
	if(metal)
		return
	if(slips && isliving(AM)) //VOREStation Add
		var/mob/living/M = AM
		M.slip("the foam", 6)

/datum/effect/effect/system/foam_spread
	var/amount = 5				// the size of the foam spread.
	var/list/carried_reagents	// the IDs of reagents present when the foam was mixed
	var/metal = 0				// 0 = foam, 1 = metalfoam, 2 = ironfoam

/datum/effect/effect/system/foam_spread/set_up(amt=5, loca, var/datum/reagents/carry = null, var/metalfoam = 0)
	amount = round(sqrt(amt / 3), 1)
	if(istype(loca, /turf/))
		location = loca
	else
		location = get_turf(loca)

	carried_reagents = list()
	metal = metalfoam

	// bit of a hack here. Foam carries along any reagent also present in the glass it is mixed with (defaults to water if none is present). Rather than actually transfer the reagents, this makes a list of the reagent ids and spawns 1 unit of that reagent when the foam disolves.

	if(carry && !metal)
		for(var/datum/reagent/R in carry.reagent_list)
			carried_reagents += R.id

/datum/effect/effect/system/foam_spread/start()
	spawn(0)
		var/obj/effect/effect/foam/F = locate() in location
		if(F)
			F.amount += amount
			return

		F = new /obj/effect/effect/foam(location, metal)
		F.amount = amount

		if(!metal) // don't carry other chemicals if a metal foam
			F.create_reagents(10)

			if(carried_reagents)
				for(var/id in carried_reagents)
					F.reagents.add_reagent(id, 1, safety = 1) //makes a safety call because all reagents should have already reacted anyway
			else
				F.reagents.add_reagent(REAGENT_ID_WATER, 1, safety = 1)

// wall formed by metal foams, dense and opaque, but easy to break

/obj/structure/foamedmetal
	icon = 'icons/effects/effects.dmi'
	icon_state = "metalfoam"
	density = TRUE
	opacity = 1 // changed in New()
	anchored = TRUE
	name = "foamed metal"
	desc = "A lightweight foamed metal wall."
	can_atmos_pass = ATMOS_PASS_NO
	var/metal = 1 // 1 = aluminum, 2 = iron

/obj/structure/foamedmetal/Initialize(mapload)
	. = ..()
	update_nearby_tiles(1)

/obj/structure/foamedmetal/Destroy()
	density = FALSE
	update_nearby_tiles(1)
	return ..()

/obj/structure/foamedmetal/update_icon()
	if(metal == 1)
		icon_state = "metalfoam"
	else
		icon_state = "ironfoam"

/obj/structure/foamedmetal/ex_act(severity)
	qdel(src)

/obj/structure/foamedmetal/bullet_act(var/obj/item/projectile/P)
	if(istype(P, /obj/item/projectile/test))
		return
	else if(metal == 1 || prob(50))
		qdel(src)

/obj/structure/foamedmetal/attack_hand(var/mob/user)
	if ((HULK in user.mutations) || (prob(75 - metal * 25)))
		user.visible_message(span_warning("[user] smashes through the foamed metal."), span_notice("You smash through the metal foam wall."))
		qdel(src)
	else
		to_chat(user, span_notice("You hit the metal foam but bounce off it."))
	return

/obj/structure/foamedmetal/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/grab))
		var/obj/item/grab/G = I
		G.affecting.loc = src.loc
		visible_message(span_warning("[G.assailant] smashes [G.affecting] through the foamed metal wall."))
		qdel(I)
		qdel(src)
		return

	if(prob(I.force * 20 - metal * 25))
		user.visible_message(span_warning("[user] smashes through the foamed metal."), span_notice("You smash through the foamed metal with \the [I]."))
		qdel(src)
	else
		to_chat(user, span_notice("You hit the metal foam to no effect."))
