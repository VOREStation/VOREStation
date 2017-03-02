/obj/item/clothing/gloves/weddingring
	name = "golden wedding ring"
	desc = "For showing your devotion to another person. It has a golden glimmer to it."
	icon = 'icons/obj/clothing/gloves_vr.dmi'
	icon_state = "wedring_g"
	item_state = "wedring_g"
	var/partnername = ""

/obj/item/clothing/gloves/weddingring/attack_self(mob/user)
	partnername = copytext(sanitize(input(user, "Would you like to change the holoengraving on the ring?", "Name your betrothed", "Bae") as null|text),1,MAX_NAME_LEN)
	name = "[initial(name)] - [partnername]"

/obj/item/clothing/gloves/weddingring/silver
	name = "silver wedding ring"
	icon_state = "wedring_s"
	item_state = "wedring_s"

/obj/item/clothing/gloves/color
	desc = "A pair of gloves, they don't look special in any way."
	item_state_slots = list(slot_r_hand_str = "white", slot_l_hand_str = "white")
	icon_state = "latex"
