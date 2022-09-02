/datum/artifact_effect/radiate
	name = "radiation"
	effect_color = "#007006"
	var/radiation_amount


/datum/artifact_effect/radiate/New()
	..()
	radiation_amount = rand(1, 10)
	effect_type = pick(EFFECT_PARTICLE, EFFECT_ORGANIC)

<<<<<<< HEAD
/datum/artifact_effect/radiate/DoEffectTouch(var/mob/living/user)
	if(user)
=======

/datum/artifact_effect/rare/radiate/DoEffectTouch(mob/living/user)
	if (user)
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
		user.apply_effect(radiation_amount * 5,IRRADIATE,0)
		user.updatehealth()


/datum/artifact_effect/radiate/DoEffectAura()
	var/atom/holder = get_master_holder()
	if (holder)
		SSradiation.flat_radiate(holder, radiation_amount, src.effectrange)


/datum/artifact_effect/radiate/DoEffectPulse()
	var/atom/holder = get_master_holder()
<<<<<<< HEAD
	if(holder)
		SSradiation.radiate(holder, ((radiation_amount * 3) * (sqrt(src.effectrange)))) //Need to get feedback on this //VOREStation Edit - Was too crazy-strong.
		return 1
=======
	if (holder)
		SSradiation.radiate(holder, ((radiation_amount * 25) * (sqrt(src.effectrange)))) //Need to get feedback on this
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
