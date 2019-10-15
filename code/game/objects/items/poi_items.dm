
/obj/item/poi
	icon = 'icons/obj/objects.dmi'
	desc = "This is definitely something cool."

/obj/item/poi/pascalb
	icon_state = "pascalb"
	name = "misshapen manhole cover"
	desc = "The top of this twisted chunk of metal is faintly stamped with a five pointed star. 'Property of US Army, Pascal B - 1957'."

/obj/item/poi/pascalb/New()
	START_PROCESSING(SSobj, src)
	return ..()

/obj/item/poi/pascalb/process()
	SSradiation.radiate(src, 5)

/obj/item/poi/pascalb/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/closet/crate/oldreactor
	name = "fission reactor rack"
	desc = "Used in older models of nuclear reactors, essentially a cooling rack for high volumes of radioactive material."
	icon = 'icons/obj/objects.dmi'
	icon_state = "poireactor"
	icon_opened = "poireactor_open"
	icon_closed = "poireactor"
	climbable = 0

	starts_with = list(
		/obj/item/weapon/fuel_assembly/deuterium = 6)

/obj/item/poi/brokenoldreactor
	icon_state = "poireactor_broken"
	name = "ruptured fission reactor rack"
	desc = "This broken hunk of machinery looks extremely dangerous."

/obj/item/poi/brokenoldreactor/New()
	START_PROCESSING(SSobj, src)
	return ..()

/obj/item/poi/brokenoldreactor/process()
	SSradiation.radiate(src, 25)

/obj/item/poi/brokenoldreactor/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

