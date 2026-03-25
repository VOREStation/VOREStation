/obj/structure/particle_accelerator/power_box
	name = "Particle Focusing EM Lens"
	desc_holder = "This uses electromagnetic waves to focus the Alpha-Particles."
	icon = 'icons/obj/machines/particle_accelerator2.dmi'
	icon_state = "power_box"
	reference = "power_box"

/obj/structure/particle_accelerator/power_box/pre_mapped
	construction_state = 3

/obj/structure/particle_accelerator/power_box/pre_mapped/Initialize(mapload)
	. = ..()
	update_icon()
