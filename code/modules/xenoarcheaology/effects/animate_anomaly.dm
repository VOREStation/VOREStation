
/datum/artifact_effect/animate_anomaly
	name = "animate anomaly"
	effect_type = EFFECT_PSIONIC
	var/mob/living/target = null

	effect_state = "pulsing"
	effect_color = "#00c3ff"

/datum/artifact_effect/animate_anomaly/ToggleActivate(var/reveal_toggle = 1)
	..()
	find_target()

/datum/artifact_effect/animate_anomaly/New()
	..()
	effectrange = max(3, effectrange)

/datum/artifact_effect/animate_anomaly/proc/find_target()
	var/atom/masterholder = get_master_holder()

<<<<<<< HEAD
	if(!target || target.z != masterholder.z || get_dist(target, masterholder) > effectrange)
		var/mob/living/ClosestMob = null
		for(var/mob/living/L in range(effectrange, get_turf(masterholder)))
			if(!L.mind)
				continue
			if(!ClosestMob)
				ClosestMob = L
				continue
			if(!L.stat)
				if(get_dist(masterholder, L) < get_dist(masterholder, ClosestMob))
					ClosestMob = L
=======
/datum/artifact_effect/common/animate_anomaly/ToggleActivate(reveal_toggle = TRUE)
	. = ..()
	find_target()
>>>>>>> f473ed9717a... Moves blob chunk effects to artifact effects. (#8783)

		target = ClosestMob

/datum/artifact_effect/animate_anomaly/DoEffectTouch(var/mob/living/user)
	var/atom/holder = get_master_holder()
	var/obj/O = holder
	var/turf/T = get_step_away(O, user)

	if(target && istype(T) && istype(O.loc, /turf))
		O.Move(T)
		O.visible_message("<span class='alien'>\The [holder] lurches away from [user]</span>")

/datum/artifact_effect/animate_anomaly/DoEffectAura()
	var/obj/O = get_master_holder()
	find_target()

	if(!target || !istype(O))
		return

	O.dir = get_dir(O, target)

	if(!target || !istype(O))
		return

	O.dir = get_dir(O, target)

	if(istype(O.loc, /turf))
		if(get_dist(O.loc, target.loc) > 1)
			O.Move(get_step_to(O, target))
			O.visible_message("<span class='alien'>\The [O] lurches toward [target]</span>")

/datum/artifact_effect/animate_anomaly/DoEffectPulse()
	DoEffectAura()
