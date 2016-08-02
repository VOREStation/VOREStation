/datum/unit_test/space_suffocation
	name = "MOB: human mob suffocates in space"

	var/startOxyloss
	var/endOxyloss
	var/mob/living/carbon/human/H
	async = 1

/datum/unit_test/space_suffocation/start_test()
	var/turf/space/T = locate()

	H = new(T)
	startOxyloss = H.getOxyLoss()

	return 1

/datum/unit_test/space_suffocation/check_result()
	if(H.life_tick < 10)
		return 0

	endOxyloss = H.getOxyLoss()

	if(startOxyloss < endOxyloss)
		pass("Human mob takes oxygen damage in space. (Before: [startOxyloss]; after: [endOxyloss])")
	else
		fail("Human mob is not taking oxygen damage in space. (Before: [startOxyloss]; after: [endOxyloss])")

	qdel(H)
	return 1
