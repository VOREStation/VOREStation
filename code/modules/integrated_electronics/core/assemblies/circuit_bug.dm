/obj/item/electronic_assembly/circuit_bug // A nerfed, circuitry version of the spy bug.
	name = "electronic bug"
	desc = "A tiny circuit assembly that looks perfect for hiding."
	icon = 'icons/obj/integrated_electronics/electronic_setups.dmi'
	icon_state = "setup_device_cylinder"
	layer = TURF_LAYER+0.2 // Appears under many things, but with alt+click, unlike spy bug.
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	max_components = IC_COMPONENTS_BASE
	max_complexity = 20 // Incredibly low complexity to prevent shenanigans.
	origin_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)

/obj/item/electronic_assembly/circuit_bug/examine(mob/user)
	. = ..()
	if(get_dist(user, src) == 0)
		. += "It looks like it could be hidden easily..."
