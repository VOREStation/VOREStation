<<<<<<< HEAD

/datum/artifact_effect/poltergeist
=======
/datum/artifact_effect/rare/poltergeist
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
	name = "poltergeist"
	effect_type = EFFECT_ENERGY
	effect_state = "shield2"
	effect_color = "#a824c9"

<<<<<<< HEAD
/datum/artifact_effect/poltergeist/proc/throw_at_mob(var/mob/living/target, var/damage = 20)
	var/list/valid_targets = list()

	for(var/obj/O in oview(world.view, target))
		if(!O.anchored && isturf(O.loc))
			valid_targets |= O

	if(valid_targets.len)
		var/obj/obj_to_throw = pick(valid_targets)
		obj_to_throw.visible_message("<span class='alien'>\The [obj_to_throw] levitates, before hurtling toward [target]!</span>")
		obj_to_throw.throw_at(target, world.view, min(40, damage * GetAnomalySusceptibility(target)))

/datum/artifact_effect/poltergeist/DoEffectTouch(var/mob/user)
	throw_at_mob(user, rand(10, 30))

/datum/artifact_effect/poltergeist/DoEffectAura()
=======

/datum/artifact_effect/rare/poltergeist/DoEffectTouch(mob/living/user)
	throw_at_mob(user, rand(10, 30))


/datum/artifact_effect/rare/poltergeist/DoEffectAura()
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
	var/atom/holder = get_master_holder()
	var/mob/living/target = null
	for (var/mob/living/L in oview(get_turf(holder), effectrange))
		if (L.stat || !L.mind)
			continue
		if (target && get_dist(get_turf(holder), L) > get_dist(get_turf(holder), target))
			continue
		target = L
	if (target)
		throw_at_mob(target, rand(15, 30))

<<<<<<< HEAD
/datum/artifact_effect/poltergeist/DoEffectPulse()
=======

/datum/artifact_effect/rare/poltergeist/DoEffectPulse()
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
	var/atom/holder = get_master_holder()
	var/mob/living/target = null
	for (var/mob/living/L in oview(get_turf(holder), effectrange))
		if (L.stat || !L.mind)
			continue
		if (target && get_dist(get_turf(holder), L) > get_dist(get_turf(holder), target))
			continue
		target = L
	if (target)
		throw_at_mob(target, chargelevelmax)


/datum/artifact_effect/rare/poltergeist/proc/throw_at_mob(mob/living/target, damage = 20)
	var/list/valid_targets = list()
	for (var/obj/O in oview(world.view, target))
		if (!O.anchored && isturf(O.loc))
			valid_targets |= O
	if (valid_targets.len)
		var/obj/obj_to_throw = pick(valid_targets)
		obj_to_throw.visible_message("<span class='alien'>\The [obj_to_throw] levitates, before hurtling toward [target]!</span>")
		obj_to_throw.throw_at(target, world.view, min(40, damage * GetAnomalySusceptibility(target)))
