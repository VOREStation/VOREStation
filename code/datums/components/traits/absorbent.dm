//Honestly this could be an element, but I don't want to aggressively refactor traits in an upport and cleanup PR.
/datum/component/absorbent

/datum/component/absorbent/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/absorbent/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(process_component))

/datum/component/absorbent/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_MOVABLE_MOVED))

/datum/component/absorbent/proc/process_component()
	SIGNAL_HANDLER
	var/mob/living/carbon/human/H = parent
	var/turf/T = get_turf(H)
	if(istype(T))
		if(!(H.shoes || (H.wear_suit && (H.wear_suit.body_parts_covered & FEET))))
			//We do this first as it gives nutrition for each item on the turf.
			for(var/obj/O in T)
				if(O.wash(CLEAN_WASH))
					H.adjust_nutrition(rand(5, 15))

			//Secondly, we check if the turf is a sim turf. If it's dirty, we get nutrition.
			//The T.wash() below will clean it and set the dirt to 0.
			if(istype(T, /turf/simulated))
				var/turf/simulated/turf_to_clean = T
				if(turf_to_clean.dirt >= 50)
					H.adjust_nutrition(rand(10, 20))
			//Third, we clean the turf itself.
			if(T.wash(CLEAN_WASH))
				H.adjust_nutrition(rand(10, 20))

	//Lastly, we clean ourself and all the items on us.
	if(H.wash(CLEAN_WASH))
		H.adjust_nutrition(rand(5, 15))
