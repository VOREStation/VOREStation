/datum/artifact_effect/common/noxious
	name = "sweating"
	var/list/reagents = list()
	effect_type = EFFECT_PARTICLE
	effect_color = "#5f7a5f"
	effect_state = "puffs"


/datum/artifact_effect/common/noxious/proc/offgas()
	var/mob/living/L = locate() in oview(get_master_holder())
	if(!istype(L))
		return
	if(prob(20) && !L.stat)	// There's some active living thing nearby, produce offgas.
		var/atom/A = get_master_holder()
		A.visible_message("<span class='alien'>[bicon(get_master_holder())] \The [get_master_holder()] disgorches a cloud of noxious gas!</span>")
		var/turf/T = get_turf(get_master_holder())
		var/datum/effect_system/smoke_spread/noxious/BS = new /datum/effect_system/smoke_spread/noxious
		BS.attach(T)
		BS.set_up(3, 0, T)
		playsound(T, 'sound/effects/smoke.ogg', 50, 1, -3)
		BS.start()


/datum/artifact_effect/common/noxious/DoEffectTouch()
	offgas()


/datum/artifact_effect/common/noxious/DoEffectAura()
	offgas()


/datum/artifact_effect/common/noxious/DoEffectPulse()
	offgas()
