/obj/item/weapon/tank/emergency/phoron_double
	name = "double emergency phoron tank"
	desc = "An emergency air tank hastily painted red."
	icon = 'icons/obj/tank_vr.dmi'
	icon_state = "emergency_double_nitrogen"
	gauge_icon = "indicator_emergency_double"
	volume = 10

/obj/item/weapon/tank/emergency/phoron_double/New()
	..()
	air_contents.adjust_gas("phoron", (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))
