/**********************Mining Equipment Locker Items**************************/

/**********************Mining Equipment Voucher**********************/

/obj/item/mining_voucher
	name = "mining voucher"
	desc = "A token to redeem a piece of equipment. Use it on a mining equipment vendor."
	icon = 'icons/obj/mining.dmi'
	icon_state = "mining_voucher"
	w_class = ITEMSIZE_TINY

/**********************Mining Point Card**********************/

/obj/item/weapon/card/mining_point_card
	name = "mining point card"
	desc = "A small card preloaded with mining points. Swipe your ID card over it to transfer the points, then discard."
	icon_state = "data"
	var/mine_points = 500
	var/survey_points = 0

/obj/item/weapon/card/mining_point_card/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/card/id))
		var/obj/item/weapon/card/id/C = I
		if(mine_points)
			C.mining_points += mine_points
			to_chat(user, "<span class='info'>You transfer [mine_points] excavation points to [C].</span>")
			mine_points = 0
		else
			to_chat(user, "<span class='info'>There's no excavation points left on [src].</span>")

		if(survey_points)
			C.survey_points += survey_points
			to_chat(user, "<span class='info'>You transfer [survey_points] survey points to [C].</span>")
			survey_points = 0
		else
			to_chat(user, "<span class='info'>There's no survey points left on [src].</span>")

	..()

/obj/item/weapon/card/mining_point_card/examine(mob/user)
	. = ..()
	. += "There's [mine_points] excavation points on the card."
	. += "There's [survey_points] survey points on the card."

/obj/item/weapon/card/mining_point_card/survey
	mine_points = 0
	survey_points = 50
