/// Modified to work with the Artifact Harvester
/datum/artifact_effect/animate_anomaly
	name = "Animation"
	effect_type = EFFECT_ANIMATE
	var/mob/living/target = null

	effect_state = "pulsing"
	effect_color = "#00c3ff"

/datum/artifact_effect/animate_anomaly/ToggleActivate(var/reveal_toggle = 1)
	..()
	find_target()

/datum/artifact_effect/animate_anomaly/New()
	..()
	effectrange = max(3, effectrange)

/datum/artifact_effect/animate_anomaly/proc/find_target(var/obj/item/anodevice/utilizer)
	var/atom/masterholder = get_master_holder()
	if(utilizer) //We are in an artifact utilizer! Just run from whoever touched us last!
		masterholder = utilizer
		target = utilizer.last_user_touched
		return

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

		target = ClosestMob

/datum/artifact_effect/animate_anomaly/DoEffectTouch(var/mob/living/user)
	var/atom/holder = get_master_holder()
	var/obj/O = holder
	var/turf/T = get_step_away(O, user)
	if(!user) //Sanity.
		return
	/// This controls the NORMAL functionality!
	if(target && istype(T) && isturf(O.loc))
		O.Move(T)
		O.visible_message(span_alien("\The [holder] lurches away from [user]"))

	/// This does the 'we are in an artifact utilizer' functionality
	if(istype(holder, /obj/item/anobattery))
		var/obj/item/anodevice/utilizer = O.loc
		user = utilizer.last_user_touched
		T = get_step_away(utilizer, user)
		if(istype(utilizer.loc, /turf))
			utilizer.Move(T)
			utilizer.visible_message(span_alien("\The [holder] lurches away from [user]"))
		else if(istype(utilizer.loc, /mob)) //It's in your hands and running away!
			user.drop_from_inventory(utilizer, user.loc)
			utilizer.visible_message(span_alien("\The [holder] squirms out of [user]'s hand!"))
			T = get_step_away(utilizer, user)
			utilizer.Move(T)

/datum/artifact_effect/animate_anomaly/DoEffectAura()
	var/atom/holder = get_master_holder()
	var/obj/O = holder
	var/mob/user
	if(istype(holder, /obj/item/anobattery))
		var/obj/item/anodevice/utilizer = O.loc
		O = O.loc //Yes, this seems weird, but it's needed for below.
		user = utilizer.last_user_touched
		if(istype(utilizer.loc, /mob)) //It's in your hands and running away!
			user = utilizer.loc
			user.drop_from_inventory(utilizer, user.loc)
			utilizer.visible_message(span_alien("\The [utilizer] squirms out of [user]'s hand!"))
		find_target(utilizer)
	else
		find_target()

	if(!target || !istype(O))
		return

	O.dir = get_dir(O, target)

	if(!target || !istype(O))
		return

	O.dir = get_dir(O, target)

	if(isturf(O.loc))
		if(get_dist(O.loc, target.loc) > 1)
			O.Move(get_step_to(O, target))
			O.visible_message(span_alien("\The [O] lurches toward [target]"))



/datum/artifact_effect/animate_anomaly/DoEffectPulse()
	DoEffectAura()
