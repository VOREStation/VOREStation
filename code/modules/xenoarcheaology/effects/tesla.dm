/datum/artifact_effect/extreme/tesla
	name = "tesla"
	effect_color = "#f5f231"
	effect_type = EFFECT_ELECTRO
	effect_state = "sparks"


/datum/artifact_effect/extreme/tesla/New()
	. = ..()
	effect = pick(EFFECT_TOUCH, EFFECT_PULSE)


/datum/artifact_effect/extreme/tesla/proc/arc(var/list/exempt = list())
	var/atom/A = get_master_holder()
	A.visible_message("<span class='danger'>\The [get_master_holder()] discharges energy wildly in all directions!</span>")
	for(var/mob/living/L in oview(world.view, get_turf(get_master_holder())))
		if(chargelevel < 3)
			break

		if(L in exempt)
			continue

		var/obj/item/projectile/P = new /obj/item/projectile/beam/shock(get_turf(get_master_holder()))
		P.launch_projectile(L, BP_TORSO, get_master_holder())
		chargelevel -= 3


/datum/artifact_effect/extreme/tesla/DoEffectTouch(mob/living/user)
	if(chargelevel < 3)
		return
	arc(list(user))


/datum/artifact_effect/extreme/tesla/DoEffectPulse()
	if(chargelevel < 3)
		return
	arc()
