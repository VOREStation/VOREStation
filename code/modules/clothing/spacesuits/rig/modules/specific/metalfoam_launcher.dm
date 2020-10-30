
/obj/item/rig_module/grenade_launcher/metalfoam
	name = "mounted metalfoam grenade launcher"
	desc = "A shoulder-mounted foam-bomb dispenser."
	selectable = 1
	icon_state = "grenadelauncher"

	interface_name = "integrated metalfoam grenade launcher"
	interface_desc = "Discharges loaded grenades against the wearer's location."

	fire_force = 15

	charges = list(
		list("metalfoam",   "metalfoam",   /obj/item/weapon/grenade/chem_grenade/metalfoam,  5)
		)
