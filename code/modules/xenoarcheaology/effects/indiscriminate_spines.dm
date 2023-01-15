/datum/artifact_effect/rare/spines
	name = "spines"
	effect_color = "#8db6b2"
	effect_type = EFFECT_ORGANIC


/datum/artifact_effect/extreme/spines/New()
	. = ..()
	effect = pick(EFFECT_TOUCH, EFFECT_PULSE)


/datum/artifact_effect/extreme/spines/proc/shoot(var/list/exempt = list())
	var/atom/A = get_master_holder()
	A.visible_message("<span class='danger'>\The [get_master_holder()] fires spines wildly in all directions!</span>")
	for(var/i in range(1, round(chargelevel / 3)))
		var/atom/target = pick(oview(world.view, get_turf(get_master_holder())))

		if(target in exempt)
			continue

		var/obj/item/projectile/P = new /obj/item/projectile/bullet/thorn(get_turf(get_master_holder()))
		P.launch_projectile(target, BP_TORSO, get_master_holder())
		chargelevel -= 3


/datum/artifact_effect/extreme/spines/DoEffectTouch(mob/living/user)
	if(chargelevel < 3)
		return
	shoot(list(user))


/datum/artifact_effect/extreme/spines/DoEffectPulse()
	if(chargelevel < 3)
		return
	shoot()
