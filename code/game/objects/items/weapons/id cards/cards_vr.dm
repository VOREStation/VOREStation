/obj/item/card/emag/examine(mob/user)
	. = ..()
	. += "[uses] uses remaining."

/obj/item/card/emag/used
	uses = 1

/obj/item/card/emag/used/Initialize()
	. = ..()
	uses = rand(1, 5)
