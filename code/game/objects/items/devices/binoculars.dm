/obj/item/device/binoculars
	name = "binoculars"
	desc = "A pair of binoculars."
	icon = 'icons/obj/device_vr.dmi' //VOREStation Edit
	icon_state = "binoculars"
	force = 5.0
	w_class = ITEMSIZE_SMALL
	throwforce = 5.0
	throw_range = 15
	throw_speed = 3

	//matter = list(MAT_STEEL = 50, MAT_GLASS = 50)

/obj/item/device/binoculars/attack_self(mob/user)
	zoom()

/obj/item/device/binoculars/spyglass
	name = "spyglass"
	desc = "It's a hand-held telescope, useful for star-gazing, peeping, and recon."
	icon_state = "spyglass"
	slot_flags = SLOT_BELT

/obj/item/device/binoculars/scope
	name = "rifle scope"
	desc = "It's a rifle scope. Would be better if it were actually attached to a rifle."
	icon_state = "rifle_scope"