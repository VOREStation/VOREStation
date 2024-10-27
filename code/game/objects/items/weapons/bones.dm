//These bone objects are mostly for mapping and decoration. They have no actual medical use, so maybe don't try to put them in anybody.
/obj/item/bone
	name = "bone"
	desc = "A non-descript bone. It's so old and worn you can barely tell which part of the body it's from."
	icon = 'icons/obj/bones.dmi'
	icon_state = "bone"
	force = 5
	throwforce = 6
	item_state = "bone"
	w_class = ITEMSIZE_SMALL
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked", "bonked", "boned")

/obj/item/bone/skull
	name = "skull"
	desc = "A skull. Judging by the shape and size, you'd guess that it might be human."
	icon_state = "skull"
	throwforce = 7

/obj/item/bone/skull/tajaran
	desc = "A skull. Judging by the shape and size, you'd guess that it might be tajaran."
	icon_state = "tajskull"

/obj/item/bone/skull/unathi
	desc = "A skull. Judging by the shape and size, you'd guess that it might be unathi."
	icon_state = "unaskull"

/obj/item/bone/skull/unknown
	desc = "A skull. You're not sure what species it might be, though."
	icon_state = "xenoskull"

/obj/item/bone/arm
	name = "arm bone"
	desc = "Wielding this, you're armed and dangerous, no bones about it."
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked", "bonked", "boned", "slapped", "punched")
	icon_state = "arm"

/obj/item/bone/leg
	name = "leg bone"
	desc = "Don't worry about getting into an argument with the owner of this. They don't have a leg to stand on."
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked", "bonked", "boned", "kicked")
	icon_state = "leg"

/obj/item/bone/ribs
	name = "ribcage"
	desc = "If you had some mallets, you could probably use this as a makeshift xylophone."
	icon_state = "ribs"

/obj/item/bone/horn	//Teppi horn!!!!
	name = "horn"
	desc = "A hard conical structure made of bone or some other similar organic material. Traditionally seen affixed to helmets, hollowed out and filled with tasty drinks, or occasionally, attatched to the heads of animals."
	icon = 'icons/obj/bones_vr.dmi'
	icon_state = "horn"