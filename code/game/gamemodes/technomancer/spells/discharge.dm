/datum/power/technomancer/discharge
	name = "Discharge"
	desc = "Attempts to steal energy from your target, electrocuting it and anyone holding it."
	cost = 70
	verbpath = /mob/living/carbon/human/proc/technomancer_discharge

/mob/living/carbon/human/proc/technomancer_discharge()
	place_spell_in_hand(/obj/item/weapon/spell/discharge)

/obj/item/weapon/spell/discharge
	name = "discharge"
	desc = "The economical solution for when you want to zap someone to death."
	icon_state = "generic"
	cast_methods = CAST_RANGED
	aspect = ASPECT_SHOCK
	var/datum/effect/effect/system/spark_spread/sparks

/obj/item/weapon/spell/discharge/New()
	..()
	sparks = PoolOrNew(/datum/effect/effect/system/spark_spread)
	sparks.set_up(5, 0, src)
	sparks.attach(loc)

/obj/item/weapon/spell/discharge/on_ranged_cast(atom/hit_atom, mob/user)
	var/turf/T = get_turf(hit_atom)
	if(T)
		var/mob/living/victim = null
		for(var/mob/living/L in T.contents)
			if(!L.stat)
				victim = L
				break

		if(!victim)
			return 0

		var/cells = list()
		recursive_content_check(victim, cells, recursion_limit = 3, client_check = 0, sight_check = 0, include_mobs = 1, include_objects = 1)
		var/drain_factor = isrobot(victim) ? 0.25 : 0.50 //Drain only 25% of the battery if it's a borg.
		var/total_charge_drained = 0
		for(var/obj/item/weapon/cell/cell in cells)
			var/to_drain = cell.charge * drain_factor
//			var/to_drain = (cell.maxcharge - cell.charge) * drain_factor
//			cell.drain_power(0,0,to_drain)
			cell.charge = max(cell.charge - to_drain, 0)
			total_charge_drained += to_drain
			//Updates icons, so guns look drained when this hits them.
			if(istype(loc, /obj))
				var/obj/O = loc
				O.update_icon()

		var/damage_amount = round( min( total_charge_drained / 250, 25) ) //Caps damage at 25.
		var/steal_amount = round(total_charge_drained / 50)
		victim.adjustFireLoss(damage_amount)
		user << "DEBUG: You would have drained [total_charge_drained] kW from [victim], which converts to [steal_amount].  [victim] was hurt for [damage_amount]."
