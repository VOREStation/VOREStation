// Note that this is contained inside an actual implant subtype.
// See code/game/objects/items/weapons/implants/implantcircuits.dm for where this gets held.

/obj/item/electronic_assembly/implant
	name = "electronic implant"
	icon_state = "setup_implant"
	desc = "It's a case, for building very tiny electronics with."
	w_class = ITEMSIZE_TINY
	max_components = IC_COMPONENTS_BASE / 2
	max_complexity = IC_COMPLEXITY_BASE / 2
	var/obj/item/implant/integrated_circuit/implant = null

<<<<<<< HEAD
/obj/item/device/electronic_assembly/implant/tgui_host()
	return implant.tgui_host()
=======
/obj/item/electronic_assembly/implant/nano_host()
	return implant

/obj/item/electronic_assembly/implant/resolve_nano_host()
	return implant
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon

/obj/item/electronic_assembly/implant/update_icon()
	..()
	implant.icon_state = icon_state