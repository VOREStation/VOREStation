/obj/mecha/combat/phazon/scree
	desc = "A very, very shiny exosuit. This thing has been polished and waxed practically to a mirror finish."
	name = "Scuttlebug"
	icon_state = "scuttlebug"
	initial_icon = "scuttlebug"
	wreckage = /obj/effect/decal/mecha_wreckage/phazon/scree
	icon = 'icons/mecha/mecha_vr.dmi'


/obj/mecha/combat/phazon/scree/Initialize()
	. = ..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/taser
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/tesla_energy_relay
	ME.attach(src)
	return

/obj/effect/decal/mecha_wreckage/phazon/scree
	name = "Scuttlebug wreckage"
	icon_state = "scuttlebug-broken"
	icon = 'icons/mecha/mecha_vr.dmi'
