/datum/artifact_effect/radiate
	name = "radiation"
	var/radiation_amount

/datum/artifact_effect/radiate/New()
	..()
	radiation_amount = rand(1, 10)
	effect_type = pick(EFFECT_PARTICLE, EFFECT_ORGANIC)

/datum/artifact_effect/radiate/DoEffectTouch(var/mob/living/user)
	if(user)
		user.apply_effect(radiation_amount * 5,IRRADIATE,0)
		user.updatehealth()
		return 1

/datum/artifact_effect/radiate/DoEffectAura()
	if(holder)
		SSradiation.flat_radiate(holder, radiation_amount, src.effectrange)
		return 1

/datum/artifact_effect/radiate/DoEffectPulse()
	if(holder)
		SSradiation.radiate(holder, ((radiation_amount * 3) * (sqrt(src.effectrange)))) //Need to get feedback on this //VOREStation Edit - Was too crazy-strong.
		return 1
