/mob/living/carbon/human/proc/steal_skeleton()
	if(isSynthetic())
		return
	to_chat(src, span_danger("You feel your bones RATTLING."))
	Weaken(30)
	make_jittery(1000)
	addtimer(CALLBACK(src, PROC_REF(burst_skeleton)), rand(15 SECONDS, 30 SECONDS))

/mob/living/carbon/human/proc/burst_skeleton()
	to_chat(src, span_userdanger("Your skeleton frees itself from you!"))
	playsound('sound/effects/blobattack.ogg', src, 50)
	adjustHalLoss(50)
	clear_jittery()
	take_overall_damage(20, used_weapon = "own bones")
	var/datum/trait/negative/boneless/nobones = new
	nobones.apply(species, src)

	var/mob/living/simple_mob/vore/alienanimals/skeleton/fleeing/skeleton = new(get_turf(src))
	skeleton.name = name + "'s skeleton."
	skeleton.move_speed = 5
	skeleton.resize(size_multiplier)
	skeleton.say("FINALLY")
