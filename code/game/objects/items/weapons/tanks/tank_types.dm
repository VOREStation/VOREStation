/* Types of tanks!
 * Contains:
 *		Oxygen
 *		Anesthetic
 *		Air
 *		Phoron
 *		Emergency Oxygen
 */

/*
 * Oxygen
 */
/obj/item/weapon/tank/oxygen
	name = "oxygen tank"
	desc = "A tank of oxygen."
	icon_state = "oxygen"
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD

/obj/item/weapon/tank/oxygen/New()
		..()
		air_contents.adjust_gas("oxygen", (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))
		return

/obj/item/weapon/tank/oxygen/examine(mob/user)
	if(..(user, 0) && air_contents.gas["oxygen"] < 10)
		user << text("<span class='warning'>The meter on \the [src] indicates you are almost out of oxygen!</span>")
		//playsound(usr, 'sound/effects/alert.ogg', 50, 1)

/obj/item/weapon/tank/oxygen/yellow
	desc = "A tank of oxygen, this one is yellow."
	icon_state = "oxygen_f"

/obj/item/weapon/tank/oxygen/red
	desc = "A tank of oxygen, this one is red."
	icon_state = "oxygen_fr"

/*
 * Anesthetic
 */
/obj/item/weapon/tank/anesthetic
	name = "anesthetic tank"
	desc = "A tank with an N2O/O2 gas mix."
	icon_state = "anesthetic"

/obj/item/weapon/tank/anesthetic/New()
	..()

	air_contents.gas["oxygen"] = (3*ONE_ATMOSPHERE)*70/(R_IDEAL_GAS_EQUATION*T20C) * O2STANDARD
	air_contents.gas["sleeping_agent"] = (3*ONE_ATMOSPHERE)*70/(R_IDEAL_GAS_EQUATION*T20C) * N2STANDARD
	air_contents.update_values()

	return

/*
 * Air
 */
/obj/item/weapon/tank/air
	name = "air tank"
	desc = "Mixed anyone?"
	icon_state = "oxygen"

/obj/item/weapon/tank/air/examine(mob/user)
	if(..(user, 0) && air_contents.gas["oxygen"] < 1 && loc==user)
		user << "<span class='danger'>The meter on the [src.name] indicates you are almost out of air!</span>"
		user << sound('sound/effects/alert.ogg')

/obj/item/weapon/tank/air/New()
	..()

	src.air_contents.adjust_multi("oxygen", (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C) * O2STANDARD, "nitrogen", (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C) * N2STANDARD)

	return

/*
 * Phoron
 */
/obj/item/weapon/tank/phoron
	name = "phoron tank"
	desc = "Contains dangerous phoron. Do not inhale. Warning: extremely flammable."
	icon_state = "phoron"
	gauge_icon = null
	flags = CONDUCT
	slot_flags = null	//they have no straps!

/obj/item/weapon/tank/phoron/New()
	..()

	src.air_contents.adjust_gas("phoron", (3*ONE_ATMOSPHERE)*70/(R_IDEAL_GAS_EQUATION*T20C))
	return

/obj/item/weapon/tank/phoron/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()

	if (istype(W, /obj/item/weapon/flamethrower))
		var/obj/item/weapon/flamethrower/F = W
		if ((!F.status)||(F.ptank))	return
		src.master = F
		F.ptank = src
		user.remove_from_mob(src)
		src.loc = F
	return

/obj/item/weapon/tank/vox	//Can't be a child of phoron or the gas amount gets screwey.
	name = "phoron tank"
	desc = "Contains dangerous phoron. Do not inhale. Warning: extremely flammable."
	icon_state = "phoron_vox"
	item_state = "oxygen_fr"
	gauge_icon = null
	flags = CONDUCT
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD
	slot_flags = SLOT_BACK	//these ones have straps!

/obj/item/weapon/tank/vox/New()
	..()

	air_contents.adjust_gas("phoron", (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))
	return

/*
 * Emergency Oxygen
 */

/obj/item/weapon/tank/emergency
	name = "emergency tank"
	icon_state = "emergency"
	gauge_icon = "indicator_emergency"
	gauge_cap = 4
	flags = CONDUCT
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_SMALL
	force = 4
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD
	volume = 2 //Tiny. Real life equivalents only have 21 breaths of oxygen in them. They're EMERGENCY tanks anyway -errorage (dangercon 2011)

/obj/item/weapon/tank/emergency/oxygen
	name = "emergency oxygen tank"
	desc = "Used for emergencies. Contains very little oxygen, so try to conserve it until you actually need it."
	icon_state = "emergency"
	gauge_icon = "indicator_emergency"

/obj/item/weapon/tank/emergency/oxygen/New()
		..()
		src.air_contents.adjust_gas("oxygen", (3*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

		return

/obj/item/weapon/tank/emergency/oxygen/examine(mob/user)
	if(..(user, 0) && air_contents.gas["oxygen"] < 0.2 && loc==user)
		user << text("<span class='danger'>The meter on the [src.name] indicates you are almost out of air!</span>")
		user << sound('sound/effects/alert.ogg')

/obj/item/weapon/tank/emergency/oxygen/engi
	name = "extended-capacity emergency oxygen tank"
	icon_state = "emergency_engi"
	volume = 6

/obj/item/weapon/tank/emergency/oxygen/double
	name = "double emergency oxygen tank"
	icon_state = "emergency_double"
	gauge_icon = "indicator_emergency_double"
	volume = 10

/obj/item/weapon/tank/emergency/nitrogen
	name = "emergency nitrogen tank"
	desc = "An emergency air tank hastily painted red."
	icon_state = "emergency_nitro"
	gauge_icon = "indicator_emergency"

/obj/item/weapon/tank/emergency/nitrogen/New()
	..()
	src.air_contents.adjust_gas("nitrogen", (3*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/weapon/tank/emergency/nitrogen/double
	name = "double emergency nitrogen tank"
	icon_state = "emergency_double_nitrogen"
	gauge_icon = "indicator_emergency_double"
	volume = 10

/obj/item/weapon/tank/emergency/phoron
	name = "emergency phoron tank"
	desc = "An emergency air tank hastily painted red."
	icon_state = "emergency_nitro"
	gauge_icon = "indicator_emergency"

/obj/item/weapon/tank/emergency/phoron/New()
	..()
	src.air_contents.adjust_gas("phoron", (3*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/weapon/tank/emergency/phoron/double
	name = "double emergency nitrogen tank"
	icon_state = "emergency_double_nitrogen"
	gauge_icon = "indicator_emergency_double"
	volume = 10

/*
 * Nitrogen
 */
/obj/item/weapon/tank/nitrogen
	name = "nitrogen tank"
	desc = "A tank of nitrogen."
	icon_state = "oxygen_fr"
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD

/obj/item/weapon/tank/nitrogen/New()
	..()

	src.air_contents.adjust_gas("nitrogen", (3*ONE_ATMOSPHERE)*70/(R_IDEAL_GAS_EQUATION*T20C))
	return

/obj/item/weapon/tank/nitrogen/examine(mob/user)
	if(..(user, 0) && air_contents.gas["nitrogen"] < 10)
		user << text("<span class='danger'>The meter on \the [src] indicates you are almost out of nitrogen!</span>")
		//playsound(user, 'sound/effects/alert.ogg', 50, 1)