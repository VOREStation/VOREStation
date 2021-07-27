
//Binoculars
/obj/item/device/binoculars

	name = "binoculars"
	desc = "A pair of binoculars."
<<<<<<< HEAD
	icon = 'icons/obj/device_vr.dmi' //VOREStation Edit
=======
	zoomdevicename = "eyepieces"
>>>>>>> aaddb5fa719... Binoculars and Spyglass (#8176)
	icon_state = "binoculars"
	force = 5.0
	throwforce = 5.0
	throw_range = 15
	throw_speed = 3

<<<<<<< HEAD
	//matter = list(MAT_STEEL = 50,MAT_GLASS = 50)


=======
>>>>>>> aaddb5fa719... Binoculars and Spyglass (#8176)
/obj/item/device/binoculars/attack_self(mob/user)
	zoom()

//Spyglass
/obj/item/device/binoculars/spyglass
	name = "spyglass"
	desc = "A classic spyglass. Useful for star-gazing, peeping, and recon."
	icon_state = "spyglass"
	slot_flags = SLOT_BELT