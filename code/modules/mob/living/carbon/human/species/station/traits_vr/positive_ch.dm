/datum/trait/absorbent
	name = "Absorbent"
	desc = "You are able to clean messes just by walking over them, and gain nutrition from doing so!"
	cost = 2
	special_env = TRUE
	excludes = list(/datum/trait/slipperydirt)

/datum/trait/absorbent/handle_environment_special(var/mob/living/carbon/human/H)
	var/turf/T = get_turf(H)
	if(istype(T))
		if(!(H.shoes || (H.wear_suit && (H.wear_suit.body_parts_covered & FEET))))
			for(var/obj/O in T)
				if(O.clean_blood())
					H.adjust_nutrition(rand(5, 15))
			if (istype(T, /turf/simulated))
				var/turf/simulated/S = T
				if(T.clean_blood())
					H.adjust_nutrition(rand(10, 20))
				if(S.dirt > 50)
					S.dirt = 0
					H.adjust_nutrition(rand(10, 20))
		if(H.clean_blood(1))
			H.adjust_nutrition(rand(5, 15))
		if(H.r_hand)
			if(H.r_hand.clean_blood())
				H.adjust_nutrition(rand(5, 15))
		if(H.l_hand)
			if(H.l_hand.clean_blood())
				H.adjust_nutrition(rand(5, 15))
		if(H.head)
			if(H.head.clean_blood())
				H.update_inv_head(0)
				H.adjust_nutrition(rand(5, 15))
		if(H.wear_suit)
			if(H.wear_suit.clean_blood())
				H.update_inv_wear_suit(0)
				H.adjust_nutrition(rand(5, 15))
		if(H.w_uniform)
			if(H.w_uniform.clean_blood())
				H.update_inv_w_uniform(0)
				H.adjust_nutrition(rand(5, 15))
