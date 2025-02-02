//snowflake guns for xenoarch because you can't override the update_icon() proc inside the giant mess that is find creation
/obj/item/gun/energy/laser/xenoarch
	name = "Relic Rifle"
	desc = "An anomalous rifle that shoots abnormal types of beams."
	icon = 'icons/obj/xenoarchaeology.dmi'
	one_handed_penalty = FALSE
	firemodes = list() //none

/obj/item/gun/energy/laser/xenoarch/update_icon()
		return
