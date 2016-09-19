/obj/item/weapon/pen/reagent/paralysis
	origin_tech = list(TECH_MATERIAL = 2, TECH_ILLEGAL = 5)

/obj/item/weapon/pen/reagent/paralysis/New()
	..()
//	reagents.add_reagent("zombiepowder", 10)
//	reagents.add_reagent("cryptobiolin", 15)
	reagents.add_reagent("neurotoxin", 30) // A lot less griefy.