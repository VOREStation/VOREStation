/obj/mecha/combat/phazon/scree
	desc = "A very, very shiny exosuit. This thing has been polished and waxed practically to a mirror finish."
	name = "Scuttlebug"

/obj/mecha/combat/phazon/scree/New()
	..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/taser
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/tesla_energy_relay
	ME.attach(src)
	return

