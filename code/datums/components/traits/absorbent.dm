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
			for(var/obj/O in T)
				if(O.wash(CLEAN_WASH))
					H.adjust_nutrition(rand(5, 15))
			if (istype(T, /turf/simulated))
				var/turf/simulated/S = T
				if(T.wash(CLEAN_WASH))
					H.adjust_nutrition(rand(10, 20))
				if(S.dirt > 50)
					S.dirt = 0
					H.adjust_nutrition(rand(10, 20))
		if(H.wash(CLEAN_WASH))
			H.adjust_nutrition(rand(5, 15))
		if(H.r_hand)
			if(H.r_hand.wash(CLEAN_WASH))
				H.adjust_nutrition(rand(5, 15))
		if(H.l_hand)
			if(H.l_hand.wash(CLEAN_WASH))
				H.adjust_nutrition(rand(5, 15))
		if(H.head)
			if(H.head.wash(CLEAN_WASH))
				H.update_inv_head(0)
				H.adjust_nutrition(rand(5, 15))
		if(H.wear_suit)
			if(H.wear_suit.wash(CLEAN_WASH))
				H.update_inv_wear_suit(0)
				H.adjust_nutrition(rand(5, 15))
		if(H.w_uniform)
			if(H.w_uniform.wash(CLEAN_WASH))
				H.update_inv_w_uniform(0)
				H.adjust_nutrition(rand(5, 15))
