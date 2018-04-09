/obj/item/clothing/gloves/ring/wedding
	name = "golden wedding ring"
	desc = "For showing your devotion to another person. It has a golden glimmer to it."
	icon = 'icons/obj/clothing/gloves_vr.dmi'
	icon_state = "wedring_g"
	item_state = "wedring_g"
	var/partnername = ""

/obj/item/clothing/gloves/ring/wedding/attack_self(mob/user)
	partnername = copytext(sanitize(input(user, "Would you like to change the holoengraving on the ring?", "Name your spouse", "Bae") as null|text),1,MAX_NAME_LEN)
	name = "[initial(name)] - [partnername]"

/obj/item/clothing/gloves/ring/wedding/silver
	name = "silver wedding ring"
	desc = "For showing your devotion to another person. It has a silver glimmer to it."
	icon_state = "wedring_s"
	item_state = "wedring_s"
