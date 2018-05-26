
/obj/item/poi
	icon = 'icons/obj/objects.dmi'
	desc = "This is definitely something cool."

/obj/item/poi/pascalb
	icon_state = "pascalb"
	name = "misshapen manhole cover"
	desc = "The top of this twisted chunk of metal is faintly stamped with a five pointed star. 'Property of US Army, Pascal B - 1957'."

/obj/item/poi/pascalb/New()
	processing_objects += src
	return ..()

/obj/item/poi/pascalb/process()
	radiation_repository.radiate(src, 5)

/obj/item/poi/pascalb/Destroy()
	processing_objects -= src
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
	processing_objects += src
	return ..()

/obj/item/poi/brokenoldreactor/process()
	radiation_repository.radiate(src, 25)

/obj/item/poi/brokenoldreactor/Destroy()
	processing_objects -= src
	return ..()


//Crashed Cargo Shuttle PoI

/obj/structure/largecrate/animal/crashedshuttle
	name = "SCP"
/obj/structure/largecrate/animal/crashedshuttle/initialize()
	starts_with = pick(/mob/living/simple_animal/hostile/statue, /obj/item/cursed_marble)
	name = pick("Spicy Crust Pizzeria", "Soap and Care Products", "Sally's Computer Parts", "Steve's Chocolate Pastries", "Smith & Christian's Plastics","Standard Containers & Packaging Co.", "Sanitary Chemical Purgation (LTD)")
	name += " delivery crate"
	return ..()
