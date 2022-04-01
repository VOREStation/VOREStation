/datum/power/changeling/resonant_shriek
	name = "Resonant Shriek"
	desc = "Our lungs and vocal cords shift, allowing us to briefly emit a noise that deafens and confuses the weak-minded."
	helptext = "Lights are blown, organics are disoriented, and synthetics act as if they were flashed."
	enhancedtext = "Range is doubled."
	ability_icon_state = "ling_resonant_shriek"
	genomecost = 2
	power_category = CHANGELING_POWER_SHRIEKS
	verbpath = /mob/proc/changeling_resonant_shriek

/datum/power/changeling/dissonant_shriek
	name = "Dissonant Shriek"
	desc = "We shift our vocal cords to release a high-frequency sound that overloads nearby electronics."
	helptext = "Creates a moderate sized EMP."
	enhancedtext = "Range is doubled."
	ability_icon_state = "ling_dissonant_shriek"
	genomecost = 2
	power_category = CHANGELING_POWER_SHRIEKS
	verbpath = /mob/proc/changeling_dissonant_shriek

//A flashy ability, good for crowd control and sewing chaos.
/mob/proc/changeling_resonant_shriek()
	set category = "Changeling"
	set name = "Resonant Shriek (20)"
	set desc = "Emits a high-frequency sound that confuses and deafens organics, blows out nearby lights, and overloads synthetics' sensors."

	var/datum/changeling/changeling = changeling_power(20,0,100,CONSCIOUS)
	if(!changeling)	return 0

	if(is_muzzled())
		to_chat(src, "<span class='danger'>Mmmf mrrfff!</span>")
		return 0

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(H.silent)
			to_chat(src, "<span class='danger'>You can't speak!</span>")
			return 0

	if(world.time < (changeling.last_shriek + 10 SECONDS) )
		to_chat(src, "<span class='warning'>We are still recovering from our last shriek...</span>")
		return 0

	if(!isturf(loc))
		to_chat(src, "<span class='warning'>Shrieking here would be a bad idea.</span>")
		return 0

	src.break_cloak()	//No more invisible shrieking

	changeling.chem_charges -= 20
	var/range = 4
	if(src.mind.changeling.recursive_enhancement)
		range = range * 2
		to_chat(src, "<span class='notice'>We are extra loud.</span>")

	visible_message("<span class='notice'>[src] appears to shout.</span>")
	var/list/affected = list()
	for(var/mob/living/M in range(range, src))
		if(iscarbon(M))
			if(!M.mind || !M.mind.changeling)
				if(M.get_ear_protection() >= 2)
					continue
				to_chat(M, "<span class='danger'>You hear an extremely loud screeching sound!  It \
				[pick("confuses","confounds","perturbs","befuddles","dazes","unsettles","disorients")] you.</span>")
				M.adjustEarDamage(0,30)
				M.Confuse(20)
				M << sound('sound/effects/screech.ogg')
				affected += M
			else
				if(M != src)
					to_chat(M, "<span class='notice'>You hear a familiar screech from nearby.  It has no effect on you.</span>")
				M << sound('sound/effects/screech.ogg')

		if(issilicon(M))
			M << sound('sound/weapons/flash.ogg')
			to_chat(M, "<span class='notice'>Auditory input overloaded.  Reinitializing...</span>")
			M.Weaken(rand(5,10))
			affected += M

	for(var/obj/machinery/light/L in range(range, src))
		L.on = 1
		L.broken()

	changeling.last_shriek = world.time

	add_attack_logs(src,affected,"Used resonant shriek")
	feedback_add_details("changeling_powers","RS")
	return 1

//EMP version
/mob/proc/changeling_dissonant_shriek()
	set category = "Changeling"
	set name = "Dissonant Shriek (20)"
	set desc = "We shift our vocal cords to release a high-frequency sound that overloads nearby electronics."

	var/datum/changeling/changeling = changeling_power(20,0,100,CONSCIOUS)
	if(!changeling)	return 0

	if(is_muzzled())
		to_chat(src, "<span class='danger'>Mmmf mrrfff!</span>")
		return 0

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(H.silent)
			to_chat(src, "<span class='danger'>You can't speak!</span>")
			return 0

	if(world.time < (changeling.last_shriek + 10 SECONDS) )
		to_chat(src, "<span class='warning'>We are still recovering from our last shriek...</span>")
		return 0

	if(!isturf(loc))
		to_chat(src, "<span class='warning'>Shrieking here would be a bad idea.</span>")
		return 0

	src.break_cloak()	//No more invisible shrieking

	changeling.chem_charges -= 20

	var/range_heavy = 1
	var/range_med = 2
	var/range_light = 4
	var/range_long = 6
	if(src.mind.changeling.recursive_enhancement)
		range_heavy = range_heavy * 2
		range_med = range_med * 2
		range_light = range_light * 2
		range_long = range_long * 2
		to_chat(src, "<span class='notice'>We are extra loud.</span>")
		src.mind.changeling.recursive_enhancement = 0

	visible_message("<span class='notice'>[src] appears to shout.</span>")

	add_attack_logs(src,null,"Use dissonant shriek")

	for(var/obj/machinery/light/L in range(5, src))
		L.on = 1
		L.broken()
	empulse(get_turf(src), range_heavy, range_light, 1)

	changeling.last_shriek = world.time

	return 1
