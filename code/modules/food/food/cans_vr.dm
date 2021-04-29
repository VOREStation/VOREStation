//////////////////////Bepis Drinks (04/29/2021)//////////////////////

/obj/item/weapon/reagent_containers/food/drinks/cans/bepis
	name = "\improper Bepis"
	desc = "It has a smell of 'off-brand' whenever you open it..."
	description_fluff = "Puts the 'B' in Best Soda! Bepis is the number one competitor to \
	Space Cola and has vendors scattered across the frontier. While the drink is not as \
	popular as Space Cola, many people across known space enjoy the sweet beverage."
	icon = 'icons/obj/drinks_vr.dmi'
	icon_state = "bepis"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/weapon/reagent_containers/food/drinks/cans/bepis/Initialize()
	. = ..()
	reagents.add_reagent("bepis", 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/astrodew
	name = "\improper Astro Dew Spring Water"
	desc = "A can of refreshing 'spring' water! Or so the can claims."
	icon = 'icons/obj/drinks_vr.dmi'
	icon_state = "watercan"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/weapon/reagent_containers/food/drinks/cans/astrodew/Initialize()
	. = ..()
	reagents.add_reagent("water", 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/icecoffee
	name = "\improper Café Del Consumir"
	desc = "A can of deliciously sweet iced coffee that originates from Earth."
	description_fluff = "Café Del Consumir originates from a small coffee brewery in México \
	that still opperates to this day. Café Del Consumir prides itself on being true to form \
	and retaining its original recipe. They've been producing and selling thier product across \
	the galaxy for decades without fail. NanoTrasen has attempted to by out the small company for \
	years now, howerver all attempts they've made have failed."
	icon = 'icons/obj/drinks_vr.dmi'
	icon_state = "coffeecan"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/weapon/reagent_containers/food/drinks/cans/icecoffee/Initialize()
	. = ..()
	reagents.add_reagent("icecoffee", 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/buzz
	name = "\improper Buzz Fuzz"
	desc = "Uses real honey, making it a sweet tooth's dream drink."
	icon = 'icons/obj/drinks_vr.dmi'
	icon_state = "buzzfuzz"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/weapon/reagent_containers/food/drinks/cans/buzz/Initialize()
	. = ..()
	reagents.add_reagent("buzz_fuzz", 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/shambler
	name = "\improper Shambler's Juice"
	desc = "~Shake me up some of that Shambler's Juice!~"
	icon = 'icons/obj/drinks_vr.dmi'
	icon_state = "shambler"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/weapon/reagent_containers/food/drinks/cans/shambler/Initialize()
	. = ..()
	reagents.add_reagent("shamblers", 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/cranberry
	name = "\improper Sprited Cranberry"
	desc = "A delicious blend of fresh cranberry juice and various spices, the perfect drink."
	icon = 'icons/obj/drinks_vr.dmi'
	icon_state = "cranberry"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/weapon/reagent_containers/food/drinks/cans/cranberry/Initialize()
	. = ..()
	reagents.add_reagent("sprited_cranberry", 30)