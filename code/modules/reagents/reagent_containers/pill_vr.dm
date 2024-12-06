/obj/item/reagent_containers/pill/nutriment
	name = "Nutriment (30u)"
	desc = "Used to feed people on the field. Contains 30 units of Nutriment."
	icon_state = "pill10"

/obj/item/reagent_containers/pill/nutriment/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_NUTRIMENT, 30)

/obj/item/reagent_containers/pill/protein
	name = "Protein (30u)"
	desc = "Used to feed carnivores on the field. Contains 30 units of Protein."
	icon_state = "pill24"

/obj/item/reagent_containers/pill/protein/Initialize()
	. = ..()
	reagents.add_reagent("protein", 30)

/obj/item/reagent_containers/pill/rezadone
	name = "Rezadone (5u)"
	desc = "A powder with almost magical properties, this substance can effectively treat genetic damage in humanoids, though excessive consumption has side effects."
	icon_state = "pill2"

/obj/item/reagent_containers/pill/rezadone/Initialize()
	. = ..()
	reagents.add_reagent("rezadone", 5)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/peridaxon
	name = "Peridaxon (10u)"
	desc = "Used to encourage recovery of internal organs and nervous systems. Medicate cautiously."
	icon_state = "pill10"

/obj/item/reagent_containers/pill/peridaxon/Initialize()
	. = ..()
	reagents.add_reagent("peridaxon", 10)

/obj/item/reagent_containers/pill/carthatoline
	name = "Carthatoline (15u)"
	desc = "Carthatoline is strong evacuant used to treat severe poisoning."
	icon_state = "pill4"

/obj/item/reagent_containers/pill/carthatoline/Initialize()
	. = ..()
	reagents.add_reagent("carthatoline", 15)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/alkysine
	name = "Alkysine (10u)"
	desc = "Alkysine is a drug used to lessen the damage to neurological tissue after a catastrophic injury. Can heal brain tissue."
	icon_state = "pill3"

/obj/item/reagent_containers/pill/alkysine/Initialize()
	. = ..()
	reagents.add_reagent("alkysine", 10)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/imidazoline
	name = "Imidazoline (15u)"
	desc = "Heals eye damage."
	icon_state = "pill3"

/obj/item/reagent_containers/pill/imidazoline/Initialize()
	. = ..()
	reagents.add_reagent("imidazoline", 15)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/osteodaxon
	name = "Osteodaxon (25u)"
	desc = "An experimental drug used to heal bone fractures."
	icon_state = "pill2"

/obj/item/reagent_containers/pill/osteodaxon/Initialize()
	. = ..()
	reagents.add_reagent("osteodaxon", 15)
	reagents.add_reagent("inaprovaline", 10)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/myelamine
	name = "Myelamine (25u)"
	desc = "Used to rapidly clot internal hemorrhages by increasing the effectiveness of platelets."
	icon_state = "pill1"

/obj/item/reagent_containers/pill/myelamine/Initialize()
	. = ..()
	reagents.add_reagent("myelamine", 15)
	reagents.add_reagent("inaprovaline", 10)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/hyronalin
	name = "Hyronalin (15u)"
	desc = "Hyronalin is a medicinal drug used to counter the effect of radiation poisoning."
	icon_state = "pill4"

/obj/item/reagent_containers/pill/hyronalin/Initialize()
	. = ..()
	reagents.add_reagent("hyronalin", 15)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/arithrazine
	name = "Arithrazine (5u)"
	desc = "Arithrazine is an unstable medication used for the most extreme cases of radiation poisoning."
	icon_state = "pill2"

/obj/item/reagent_containers/pill/arithrazine/Initialize()
	. = ..()
	reagents.add_reagent("arithrazine", 5)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/corophizine
	name = "Corophizine (5u)"
	desc = "A wide-spectrum antibiotic drug. Powerful and uncomfortable in equal doses."
	icon_state = "pill2"

/obj/item/reagent_containers/pill/corophizine/Initialize()
	. = ..()
	reagents.add_reagent("corophizine", 5)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/vermicetol
	name = "Vermicetol (15u)"
	desc = "An extremely potent drug to treat physical injuries."
	icon_state = "pill1"

/obj/item/reagent_containers/pill/vermicetol/Initialize()
	. = ..()
	reagents.add_reagent("vermicetol", 15)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/healing_nanites
	name = "Healing nanites (30u)"
	desc = "Miniature medical robots that swiftly restore bodily damage."
	icon_state = "pill1"

/obj/item/reagent_containers/pill/healing_nanites/Initialize()
	. = ..()
	reagents.add_reagent("healing_nanites", 30)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/sleevingcure
	name = "Kitsuhanan Cure (1u)"
	desc = "A rare cure provided by KHI that helps counteract negative side effects of using imperfect resleeving machinery."
	icon_state = "pill3"

/obj/item/reagent_containers/pill/sleevingcure/Initialize()
	. = ..()
	reagents.add_reagent("sleevingcure", 1)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/airlock
	name = "\'Airlock\' Pill"
	desc = "Neutralizes toxins and provides a mild analgesic effect."
	icon_state = "pill2"

/obj/item/reagent_containers/pill/airlock/New()
	..()
	reagents.add_reagent("anti_toxin", 15)
	reagents.add_reagent("paracetamol", 5)
