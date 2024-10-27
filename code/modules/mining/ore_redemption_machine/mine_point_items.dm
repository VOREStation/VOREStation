/**********************Mining Equipment Locker Items**************************/

/**********************Mining Equipment Voucher**********************/

/obj/item/mining_voucher
	name = "mining voucher"
	desc = "A token to redeem a piece of equipment. Use it on a mining equipment vendor."
	icon = 'icons/obj/mining.dmi'
	icon_state = "mining_voucher"
	w_class = ITEMSIZE_TINY

/**********************Mining Point Card**********************/

/obj/item/card/mining_point_card
	name = "mining point card"
	desc = "A small card preloaded with mining points. Swipe your ID card over it to transfer the points, then discard."
	icon_state = "data"
	var/mine_points = 500
	var/survey_points = 0

/obj/item/card/mining_point_card/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/card/id))
		var/obj/item/card/id/C = I
		if(mine_points)
			C.mining_points += mine_points
			to_chat(user, span_info("You transfer [mine_points] excavation points to [C]."))
			mine_points = 0
		else
			to_chat(user, span_info("There's no excavation points left on [src]."))

		if(survey_points)
			C.survey_points += survey_points
			to_chat(user, span_info("You transfer [survey_points] survey points to [C]."))
			survey_points = 0
		else
			to_chat(user, span_info("There's no survey points left on [src]."))

	..()

/obj/item/card/mining_point_card/examine(mob/user)
	. = ..()
	. += "There's [mine_points] excavation points on the card."
	. += "There's [survey_points] survey points on the card."

/obj/item/card/mining_point_card/survey
	mine_points = 0
	survey_points = 50
