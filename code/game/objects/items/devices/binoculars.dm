<<<<<<< HEAD
/obj/item/device/binoculars
	name = "binoculars"
	desc = "A pair of binoculars."
	icon = 'icons/obj/device_vr.dmi' //VOREStation Edit
=======

//Binoculars
/obj/item/binoculars

	name = "binoculars"
	desc = "A pair of binoculars."
	zoomdevicename = "eyepieces"
	icon = 'icons/obj/device.dmi'
	pickup_sound = 'sound/items/pickup/device.ogg'
	drop_sound = 'sound/items/drop/device.ogg'
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	icon_state = "binoculars"
	force = 5.0
	w_class = ITEMSIZE_SMALL
	throwforce = 5.0
	throw_range = 15
	throw_speed = 3

<<<<<<< HEAD
	//matter = list(MAT_STEEL = 50, MAT_GLASS = 50)

/obj/item/device/binoculars/attack_self(mob/user)
	zoom()

/obj/item/device/binoculars/spyglass
=======
/obj/item/binoculars/attack_self(mob/user)
	zoom()

//Spyglass
/obj/item/binoculars/spyglass
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	name = "spyglass"
	desc = "It's a hand-held telescope, useful for star-gazing, peeping, and recon."
	icon_state = "spyglass"
	slot_flags = SLOT_BELT

/obj/item/device/binoculars/scope
	name = "rifle scope"
	desc = "It's a rifle scope. Would be better if it were actually attached to a rifle."
	icon_state = "rifle_scope"