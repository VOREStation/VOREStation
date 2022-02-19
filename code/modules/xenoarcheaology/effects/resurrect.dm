/datum/artifact_effect/resurrect
	name = "resurrect"
	effect_type = EFFECT_ORGANIC

	var/stored_life = 0

	effect_state = "pulsing"
	effect_color = "#ff0000"

/datum/artifact_effect/resurrect/proc/steal_life(var/mob/living/target = null)
	var/atom/holder = get_master_holder()
	if(!istype(target))
		return 0

	if(target.stat != DEAD && stored_life < 200)
		holder.Beam(target, icon_state = "drain_life", time = 1 SECOND)
		target.apply_damage(5, SEARING, BP_TORSO)
		return 5

	return 0

/datum/artifact_effect/resurrect/proc/give_life(var/mob/living/target = null)
	var/atom/holder = get_master_holder()
	if(!istype(target))
		return

	if(target.stat == DEAD && stored_life)
		holder.Beam(target, icon_state = "lichbeam", time = 1 SECOND)
		target.adjustBruteLoss(-5)
		target.adjustFireLoss(-5)
		target.adjustCloneLoss(-5)
		target.adjustOxyLoss(-5)
		target.adjustHalLoss(-5)
		target.adjustToxLoss(-5)
		stored_life = max(0, stored_life - 5)

		if(target.health > (target.maxHealth / 4))
			attempt_revive(target)
			stored_life = 0

/datum/artifact_effect/resurrect/proc/attempt_revive(var/mob/living/L = null)
	var/atom/holder = get_master_holder()
	spawn()
		if(istype(L, /mob/living/simple_mob))
			var/mob/living/simple_mob/SM = L
			SM.adjustBruteLoss(-40)
			SM.adjustFireLoss(-40)
			SM.health = SM.getMaxHealth() / 3
			SM.stat = CONSCIOUS
			dead_mob_list -= SM
			living_mob_list += SM
			SM.update_icon()
			SM.revive()
			holder.visible_message("<span class='alien'>\The [SM]'s eyes open in a flash of light!</span>")
		else if(ishuman(L))
			var/mob/living/carbon/human/H = L

			if(!H.client && H.mind)
				for(var/mob/observer/dead/ghost in player_list)
					if(ghost.mind == H.mind)
						to_chat(ghost, "<b><font color = #330033><font size = 3>An artifact is trying to \
						revive you. Return to your body if you want to be resurrected!</b> \
						(Verbs -> Ghost -> Re-enter corpse)</font></font>")
						break

			H.adjustBruteLoss(-40)
			H.adjustFireLoss(-40)

			sleep(10 SECONDS)
			if(H.client)
				L.stat = CONSCIOUS
				dead_mob_list -= H
				living_mob_list += H
				H.timeofdeath = null

				holder.visible_message("<span class='alien'>\The [H]'s eyes open in a flash of light!</span>")

/datum/artifact_effect/resurrect/DoEffectTouch(var/mob/user)
	var/atom/holder = get_master_holder()
	for(var/mob/living/L in oview(effectrange, get_turf(holder)))
		stored_life += 4 * steal_life(L)

	var/turf/T = get_turf(holder)
	for(var/mob/living/L in T)
		if(L.stat == DEAD)
			give_life(L)
			break

/datum/artifact_effect/resurrect/DoEffectAura()
	var/atom/holder = get_master_holder()
	for(var/mob/living/L in oview(effectrange, get_turf(holder)))
		stored_life += steal_life(L)

	var/turf/T = get_turf(holder)
	for(var/mob/living/L in T)
		if(L.stat == DEAD)
			give_life(L)
			break

/datum/artifact_effect/resurrect/DoEffectPulse()
	var/atom/holder = get_master_holder()
	for(var/mob/living/L in oview(effectrange, get_turf(holder)))
		stored_life += 2 * steal_life(L)

	var/turf/T = get_turf(holder)
	for(var/mob/living/L in T)
		if(L.stat == DEAD)
			give_life(L)
			break
