/obj/item/reagent_containers/pill/nutriment
	name = REAGENT_NUTRIMENT + " (30u)"
	desc = "Used to feed people on the field. Contains 30 units of " + REAGENT_NUTRIMENT + "."
	icon_state = "pill10"

/obj/item/reagent_containers/pill/nutriment/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_NUTRIMENT, 30)

/obj/item/reagent_containers/pill/protein
	name = REAGENT_PROTEIN + " (30u)"
	desc = "Used to feed carnivores on the field. Contains 30 units of " + REAGENT_PROTEIN + "."
	icon_state = "pill24"

/obj/item/reagent_containers/pill/protein/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_PROTEIN, 30)

/obj/item/reagent_containers/pill/rezadone
	name = REAGENT_REZADONE + " (5u)"
	desc = "A powder with almost magical properties, this substance can effectively treat genetic damage in humanoids, though excessive consumption has side effects."
	icon_state = "pill2"

/obj/item/reagent_containers/pill/rezadone/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_REZADONE, 5)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/peridaxon
	name = REAGENT_PERIDAXON + " (10u)"
	desc = "Used to encourage recovery of internal organs and nervous systems. Medicate cautiously."
	icon_state = "pill10"

/obj/item/reagent_containers/pill/peridaxon/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_PERIDAXON, 10)

/obj/item/reagent_containers/pill/carthatoline
	name = REAGENT_CARTHATOLINE + " (15u)"
	desc = REAGENT_CARTHATOLINE + " is strong evacuant used to treat severe poisoning."
	icon_state = "pill4"

/obj/item/reagent_containers/pill/carthatoline/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_CARTHATOLINE, 15)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/alkysine
	name = REAGENT_ALKYSINE + " (10u)"
	desc = REAGENT_ALKYSINE + " is a drug used to lessen the damage to neurological tissue after a catastrophic injury. Can heal brain tissue."
	icon_state = "pill3"

/obj/item/reagent_containers/pill/alkysine/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_ALKYSINE, 10)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/imidazoline
	name = REAGENT_IMIDAZOLINE + " (15u)"
	desc = "Heals eye damage."
	icon_state = "pill3"

/obj/item/reagent_containers/pill/imidazoline/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_IMIDAZOLINE, 15)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/osteodaxon
	name = REAGENT_OSTEODAXON + " (25u)"
	desc = "An experimental drug used to heal bone fractures."
	icon_state = "pill2"

/obj/item/reagent_containers/pill/osteodaxon/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_OSTEODAXON, 15)
	reagents.add_reagent(REAGENT_ID_INAPROVALINE, 10)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/myelamine
	name = REAGENT_MYELAMINE + " (25u)"
	desc = "Used to rapidly clot internal hemorrhages by increasing the effectiveness of platelets."
	icon_state = "pill1"

/obj/item/reagent_containers/pill/myelamine/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_MYELAMINE, 15)
	reagents.add_reagent(REAGENT_ID_INAPROVALINE, 10)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/hyronalin
	name = REAGENT_HYRONALIN + " (15u)"
	desc = REAGENT_HYRONALIN + " is a medicinal drug used to counter the effect of radiation poisoning."
	icon_state = "pill4"

/obj/item/reagent_containers/pill/hyronalin/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_HYRONALIN, 15)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/arithrazine
	name = REAGENT_ARITHRAZINE + " (5u)"
	desc = REAGENT_ARITHRAZINE + " is an unstable medication used for the most extreme cases of radiation poisoning."
	icon_state = "pill2"

/obj/item/reagent_containers/pill/arithrazine/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_ARITHRAZINE, 5)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/corophizine
	name = REAGENT_COROPHIZINE + " (5u)"
	desc = "A wide-spectrum antibiotic drug. Powerful and uncomfortable in equal doses."
	icon_state = "pill2"

/obj/item/reagent_containers/pill/corophizine/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_COROPHIZINE, 5)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/vermicetol
	name = REAGENT_VERMICETOL + " (15u)"
	desc = "An extremely potent drug to treat physical injuries."
	icon_state = "pill1"

/obj/item/reagent_containers/pill/vermicetol/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_VERMICETOL, 15)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/healing_nanites
	name = REAGENT_HEALINGNANITES + " (30u)"
	desc = "Miniature medical robots that swiftly restore bodily damage."
	icon_state = "pill1"

/obj/item/reagent_containers/pill/healing_nanites/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_HEALINGNANITES, 30)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/sleevingcure
	name = REAGENT_SLEEVINGCURE + " (1u)"
	desc = "A rare cure provided by Vey-Med that helps counteract negative side effects of using imperfect resleeving machinery."
	icon_state = "pill3"

/obj/item/reagent_containers/pill/sleevingcure/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_SLEEVINGCURE, 1)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/airlock
	name = "\'Airlock\' Pill"
	desc = "Neutralizes toxins and provides a mild analgesic effect."
	icon_state = "pill2"

/obj/item/reagent_containers/pill/airlock/New()
	..()
	reagents.add_reagent(REAGENT_ID_ANTITOXIN, 15)
	reagents.add_reagent(REAGENT_ID_PARACETAMOL, 5)
