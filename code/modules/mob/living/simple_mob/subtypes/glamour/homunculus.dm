/mob/living/simple_mob/homunculus
	name = "homunculus"
	desc = "A strange misshapen humanoid creature made purely from glamour!"

	icon_dead = "homunculus"
	icon_living = "homunculus"
	icon_state = "homunculus"
	icon = 'icons/mob/vore.dmi'

	ai_holder_type = /datum/ai_holder/simple_mob/passive

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	var/owner

/mob/living/simple_mob/homunculus/death()
	if(owner)
		var/obj/item/glamour_face/O = owner
		O.homunculus = 0
	qdel(src)

/mob/living/simple_mob/homunculus/update_icon()
	return

/mob/living/simple_mob/homunculus/update_icons()
	return

