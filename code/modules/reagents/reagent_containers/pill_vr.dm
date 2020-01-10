/obj/item/weapon/reagent_containers/pill/nutriment
	name = "Nutriment pill"
	desc = "Used to feed people on the field. Contains 30 units of Nutriment."
	icon_state = "pill10"

/obj/item/weapon/reagent_containers/pill/nutriment/Initialize()
	..()
	reagents.add_reagent("nutriment", 30)

/obj/item/weapon/reagent_containers/pill/protein
	name = "Meat pill"
	desc = "Used to feed carnivores on the field. Contains 30 units of Protein."
	icon_state = "pill24"

/obj/item/weapon/reagent_containers/pill/protein/Initialize()
	..()
	reagents.add_reagent("protein", 30)

/obj/item/weapon/reagent_containers/pill/rezadone
	name = "Rezadone pill"
	desc = "A powder with almost magical properties, this substance can effectively treat genetic damage in humanoids, though excessive consumption has side effects."
	icon_state = "pill2"

/obj/item/weapon/reagent_containers/pill/rezadone/Initialize()
	..()
	reagents.add_reagent("rezadone", 5)
	color = reagents.get_color()

/obj/item/weapon/reagent_containers/pill/peridaxon
	name = "Peridaxon pill"
	desc = "Used to encourage recovery of internal organs and nervous systems. Medicate cautiously."
	icon_state = "pill10"

/obj/item/weapon/reagent_containers/pill/peridaxon/Initialize()
	..()
	reagents.add_reagent("peridaxon", 10)

/obj/item/weapon/reagent_containers/pill/carthatoline
	name = "Carthatoline pill"
	desc = "Carthatoline is strong evacuant used to treat severe poisoning."
	icon_state = "pill4"

/obj/item/weapon/reagent_containers/pill/carthatoline/Initialize()
	..()
	reagents.add_reagent("carthatoline", 10)
	color = reagents.get_color()

/obj/item/weapon/reagent_containers/pill/alkysine
	name = "Alkysine pill"
	desc = "Alkysine is a drug used to lessen the damage to neurological tissue after a catastrophic injury. Can heal brain tissue."
	icon_state = "pill3"

/obj/item/weapon/reagent_containers/pill/alkysine/Initialize()
	..()
	reagents.add_reagent("alkysine", 10)
	color = reagents.get_color()

/obj/item/weapon/reagent_containers/pill/imidazoline
	name = "Imidazoline pill"
	desc = "Heals eye damage."
	icon_state = "pill3"

/obj/item/weapon/reagent_containers/pill/imidazoline/Initialize()
	..()
	reagents.add_reagent("imidazoline", 15)
	color = reagents.get_color()

/obj/item/weapon/reagent_containers/pill/osteodaxon
	name = "Osteodaxon pill"
	desc = "An experimental drug used to heal bone fractures."
	icon_state = "pill2"

/obj/item/weapon/reagent_containers/pill/osteodaxon/Initialize()
	..()
	reagents.add_reagent("osteodaxon", 10)
	color = reagents.get_color()

/obj/item/weapon/reagent_containers/pill/myelamine
	name = "Myelamine pill"
	desc = "Used to rapidly clot internal hemorrhages by increasing the effectiveness of platelets."
	icon_state = "pill1"

/obj/item/weapon/reagent_containers/pill/myelamine/Initialize()
	..()
	reagents.add_reagent("myelamine", 10)
	color = reagents.get_color()

/obj/item/weapon/reagent_containers/pill/hyronalin
	name = "Hyronalin pill"
	desc = "Hyronalin is a medicinal drug used to counter the effect of radiation poisoning."
	icon_state = "pill4"

/obj/item/weapon/reagent_containers/pill/hyronalin/Initialize()
	..()
	reagents.add_reagent("hyronalin", 15)
	color = reagents.get_color()

/obj/item/weapon/reagent_containers/pill/arithrazine
	name = "Arithrazine pill"
	desc = "Arithrazine is an unstable medication used for the most extreme cases of radiation poisoning."
	icon_state = "pill2"

/obj/item/weapon/reagent_containers/pill/arithrazine/Initialize()
	..()
	reagents.add_reagent("arithrazine", 5)
	color = reagents.get_color()

/obj/item/weapon/reagent_containers/pill/corophizine
	name = "Corophizine pill"
	desc = "A wide-spectrum antibiotic drug. Powerful and uncomfortable in equal doses."
	icon_state = "pill2"

/obj/item/weapon/reagent_containers/pill/corophizine/Initialize()
	..()
	reagents.add_reagent("corophizine", 5)
	color = reagents.get_color()

/obj/item/weapon/reagent_containers/pill/healing_nanites
	name = "Healing nanites capsule"
	desc = "Miniature medical robots that swiftly restore bodily damage."
	icon_state = "pill1"

/obj/item/weapon/reagent_containers/pill/healing_nanites/Initialize()
	..()
	reagents.add_reagent("healing_nanites", 30)
	color = reagents.get_color()

/obj/item/weapon/reagent_containers/pill/sleevingcure
	name = "Kitsuhanan Cure pill"
	desc = "A rare cure provided by KHI that helps counteract negative side effects of using imperfect resleeving machinery."
	icon_state = "pill3"

/obj/item/weapon/reagent_containers/pill/sleevingcure/Initialize()
	..()
	reagents.add_reagent("sleevingcure", 1)
	color = reagents.get_color()
