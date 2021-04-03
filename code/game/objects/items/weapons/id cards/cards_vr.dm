/obj/item/weapon/card/emag/examine(mob/user)
	. = ..()
	. += "[uses] uses remaining."

/obj/item/weapon/card/emag/used
	uses = 1

/obj/item/weapon/card/emag/used/Initialize()
	. = ..()
	uses = rand(1, 5)
