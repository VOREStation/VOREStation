/datum/artifact_effect/cellcharge
	name = "cell charge"
	effect_type = EFFECT_ELECTRO
	effect_color = "#ffee06"
	var/last_message

/datum/artifact_effect/cellcharge/proc/charge_cells(var/amount = 25)
	var/atom/holder = get_master_holder()
	if(!holder)
		return
	var/turf/turf = get_turf(holder)
	if(!turf)
		return

	var/messaged_robots
	for(var/atom/movable/AM in range(effectrange, turf))
		if(isliving(AM))
			var/mob/living/L = AM
			var/obj/item/cell/C = L.get_cell()

			if(C)
				if(issilicon(L) && ((last_message + (1 MINUTE)) < world.time))
					messaged_robots = TRUE
					to_chat(L, span_notice("SYSTEM ALERT: Energy boost detected!"))
				C.charge = min(C.maxcharge, C.charge + amount)
			continue

		var/obj/item/cell/C = AM.get_cell()
		if(C)
			C.charge = min(C.maxcharge, C.charge + amount)

	if(messaged_robots)
		last_message = world.time

/datum/artifact_effect/cellcharge/DoEffectTouch(mob/living/user)
	if(!user)
		return
	charge_cells(100)

/datum/artifact_effect/cellcharge/DoEffectAura()
	charge_cells()

/datum/artifact_effect/cellcharge/DoEffectPulse()
	charge_cells(50)
