
/datum/artifact_effect/animate_anomaly
	name = "animate anomaly"
	effect_type = EFFECT_PSIONIC
	var/mob/living/target = null

/datum/artifact_effect/animate_anomaly/ToggleActivate(var/reveal_toggle = 1)
	..()
	find_target()

/datum/artifact_effect/animate_anomaly/New()
	..()
	effectrange = max(3, effectrange)

/datum/artifact_effect/animate_anomaly/proc/find_target()
<<<<<<< HEAD
	if(!target || target.z != holder.z || get_dist(target, holder) > effectrange)
		var/mob/living/ClosestMob = null
		for(var/mob/living/L in range(effectrange, holder))
=======
	var/atom/masterholder = get_master_holder()

	if(!target || target.z != masterholder.z || get_dist(target, masterholder) > effectrange)
		var/mob/living/ClosestMob = null
		for(var/mob/living/L in range(effectrange, get_turf(masterholder)))
>>>>>>> a186da160f9... Merge pull request #8339 from Mechoid/AnomBattery
			if(!L.mind)
				continue
			if(!ClosestMob)
				ClosestMob = L
				continue
			if(!L.stat)
<<<<<<< HEAD
				if(get_dist(holder, L) < get_dist(holder, ClosestMob))
=======
				if(get_dist(masterholder, L) < get_dist(masterholder, ClosestMob))
>>>>>>> a186da160f9... Merge pull request #8339 from Mechoid/AnomBattery
					ClosestMob = L

		target = ClosestMob

/datum/artifact_effect/animate_anomaly/DoEffectTouch(var/mob/living/user)
<<<<<<< HEAD
=======
	var/atom/holder = get_master_holder()
>>>>>>> a186da160f9... Merge pull request #8339 from Mechoid/AnomBattery
	var/obj/O = holder
	var/turf/T = get_step_away(O, user)

	if(target && istype(T) && istype(O.loc, /turf))
		O.Move(T)
		O.visible_message("<span class='alien'>\The [holder] lurches away from [user]</span>")

/datum/artifact_effect/animate_anomaly/DoEffectAura()
<<<<<<< HEAD
	var/obj/O = holder
	if(!target || target.z != O.z || get_dist(target, O) > effectrange)
		target = null
		find_target()
	var/turf/T = get_step_to(O, target)
=======
	var/obj/O = get_master_holder()
	find_target()

	if(!target || !istype(O))
		return

	O.dir = get_dir(O, target)
>>>>>>> a186da160f9... Merge pull request #8339 from Mechoid/AnomBattery

	if(target && istype(T) && istype(O.loc, /turf))
		if(get_dist(O, T) > 1)
			O.Move(T)
			O.visible_message("<span class='alien'>\The [holder] lurches toward [target]</span>")

/datum/artifact_effect/animate_anomaly/DoEffectPulse()
	var/obj/O = holder
	if(!target || target.z != O.z || get_dist(target, O) > effectrange)
		target = null
		find_target()
	var/turf/T = get_step_to(O, target)

	if(target && istype(T) && istype(O.loc, /turf))
		if(get_dist(O, T) > 1)
			O.Move(T)
			O.visible_message("<span class='alien'>\The [holder] lurches toward [target]</span>")
