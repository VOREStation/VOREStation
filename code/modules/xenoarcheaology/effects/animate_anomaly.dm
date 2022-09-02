<<<<<<< HEAD

/datum/artifact_effect/animate_anomaly
=======
/datum/artifact_effect/common/animate_anomaly
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
	name = "animate anomaly"
	effect_type = EFFECT_PSIONIC
	effect_state = "pulsing"
	effect_color = "#00c3ff"
	var/mob/living/target

<<<<<<< HEAD
/datum/artifact_effect/animate_anomaly/ToggleActivate(var/reveal_toggle = 1)
	..()
	find_target()
=======
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura

/datum/artifact_effect/animate_anomaly/New()
	..()
	effectrange = max(3, effectrange)

<<<<<<< HEAD
/datum/artifact_effect/animate_anomaly/proc/find_target()
	var/atom/masterholder = get_master_holder()
=======
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura

/datum/artifact_effect/common/animate_anomaly/ToggleActivate(reveal_toggle = TRUE)
	..()
	find_target()


<<<<<<< HEAD
/datum/artifact_effect/animate_anomaly/DoEffectTouch(var/mob/living/user)
=======
/datum/artifact_effect/common/animate_anomaly/DoEffectTouch(mob/living/user)
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
	var/atom/holder = get_master_holder()
	var/obj/O = holder
	var/turf/T = get_step_away(O, user)
	if (target && istype(T) && istype(O.loc, /turf))
		O.Move(T)
		O.visible_message("<span class='alien'>\The [holder] lurches away from [user]</span>")

<<<<<<< HEAD
/datum/artifact_effect/animate_anomaly/DoEffectAura()
=======

/datum/artifact_effect/common/animate_anomaly/DoEffectAura()
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
	var/obj/O = get_master_holder()
	find_target()
	if (!target || !istype(O))
		return
	O.dir = get_dir(O, target)
<<<<<<< HEAD

	if(!target || !istype(O))
		return

	O.dir = get_dir(O, target)

	if(istype(O.loc, /turf))
		if(get_dist(O.loc, target.loc) > 1)
			O.Move(get_step_to(O, target))
			O.visible_message("<span class='alien'>\The [O] lurches toward [target]</span>")

/datum/artifact_effect/animate_anomaly/DoEffectPulse()
=======
	if (istype(O.loc, /turf))
		if (get_dist(O.loc, target.loc) > 1)
			O.Move(get_step_to(O, target))
			O.visible_message("<span class='alien'>\The [O] lurches toward [target]</span>")


/datum/artifact_effect/common/animate_anomaly/DoEffectPulse()
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
	DoEffectAura()


/datum/artifact_effect/common/animate_anomaly/proc/find_target()
	var/atom/masterholder = get_master_holder()
	if (!target || target.z != masterholder.z || get_dist(target, masterholder) > effectrange)
		var/mob/living/ClosestMob = null
		for (var/mob/living/L in range(effectrange, get_turf(masterholder)))
			if (!L.mind)
				continue
			if (!ClosestMob)
				ClosestMob = L
				continue
			if (!L.stat)
				if (get_dist(masterholder, L) < get_dist(masterholder, ClosestMob))
					ClosestMob = L
		target = ClosestMob
