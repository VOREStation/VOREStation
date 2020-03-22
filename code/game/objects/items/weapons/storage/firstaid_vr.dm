/obj/item/weapon/storage/firstaid/clotting
	icon_state = "clottingkit"

/obj/item/weapon/storage/firstaid/bonemed
	icon_state = "pinky"

/obj/item/weapon/storage/pill_bottle/adminordrazine
	name = "pill bottle (Adminordrazine)"
	desc = "It's magic. We don't have to explain it."
	starts_with = list(/obj/item/weapon/reagent_containers/pill/adminordrazine = 21)

/obj/item/weapon/storage/pill_bottle/nutriment
	name = "pill bottle (Food)"
	desc = "Contains pills used to feed people."
	starts_with = list(/obj/item/weapon/reagent_containers/pill/nutriment = 7, /obj/item/weapon/reagent_containers/pill/protein = 7)

/obj/item/weapon/storage/pill_bottle/rezadone
	name = "pill bottle (Rezadone)"
	desc = "A powder with almost magical properties, this substance can effectively treat genetic damage in humanoids, though excessive consumption has side effects."
	starts_with = list(/obj/item/weapon/reagent_containers/pill/rezadone = 7)
	wrapper_color = COLOR_GREEN_GRAY

/obj/item/weapon/storage/pill_bottle/peridaxon
	name = "pill bottle (Peridaxon)"
	desc = "Used to encourage recovery of internal organs and nervous systems. Medicate cautiously."
	starts_with = list(/obj/item/weapon/reagent_containers/pill/peridaxon = 7)
	wrapper_color = COLOR_PURPLE

/obj/item/weapon/storage/pill_bottle/carthatoline
	name = "pill bottle (Carthatoline)"
	desc = "Carthatoline is strong evacuant used to treat severe poisoning."
	starts_with = list(/obj/item/weapon/reagent_containers/pill/carthatoline = 7)
	wrapper_color = COLOR_GREEN_GRAY

/obj/item/weapon/storage/pill_bottle/alkysine
	name = "pill bottle (Alkysine)"
	desc = "Alkysine is a drug used to lessen the damage to neurological tissue after a catastrophic injury. Can heal brain tissue."
	starts_with = list(/obj/item/weapon/reagent_containers/pill/alkysine = 7)
	wrapper_color = COLOR_YELLOW

/obj/item/weapon/storage/pill_bottle/imidazoline
	name = "pill bottle (Imidazoline)"
	desc = "Heals eye damage."
	starts_with = list(/obj/item/weapon/reagent_containers/pill/imidazoline = 7)
	wrapper_color = COLOR_PURPLE_GRAY

/obj/item/weapon/storage/pill_bottle/osteodaxon
	name = "pill bottle (Osteodaxon)"
	desc = "An experimental drug used to heal bone fractures."
	starts_with = list(/obj/item/weapon/reagent_containers/pill/osteodaxon = 7)
	wrapper_color = COLOR_WHITE

/obj/item/weapon/storage/pill_bottle/myelamine
	name = "pill bottle (Myelamine)"
	desc = "Used to rapidly clot internal hemorrhages by increasing the effectiveness of platelets."
	starts_with = list(/obj/item/weapon/reagent_containers/pill/myelamine = 7)
	wrapper_color = COLOR_PALE_PURPLE_GRAY

/obj/item/weapon/storage/pill_bottle/hyronalin
	name = "pill bottle (Hyronalin)"
	desc = "Hyronalin is a medicinal drug used to counter the effect of radiation poisoning."
	starts_with = list(/obj/item/weapon/reagent_containers/pill/hyronalin = 7)
	wrapper_color = COLOR_TEAL

/obj/item/weapon/storage/pill_bottle/arithrazine
	name = "pill bottle (Arithrazine)"
	desc = "Arithrazine is an unstable medication used for the most extreme cases of radiation poisoning."
	starts_with = list(/obj/item/weapon/reagent_containers/pill/arithrazine = 7)
	wrapper_color = COLOR_TEAL

/obj/item/weapon/storage/pill_bottle/corophizine
	name = "pill bottle (Corophizine)"
	desc = "A wide-spectrum antibiotic drug. Powerful and uncomfortable in equal doses."
	starts_with = list(/obj/item/weapon/reagent_containers/pill/corophizine = 7)
	wrapper_color = COLOR_PALE_GREEN_GRAY

/obj/item/weapon/storage/pill_bottle/healing_nanites
	name = "pill bottle (Healing nanites)"
	desc = "Miniature medical robots that swiftly restore bodily damage."
	starts_with = list(/obj/item/weapon/reagent_containers/pill/healing_nanites = 7)

/obj/item/weapon/storage/pill_bottle/sleevingcure
	name = "pill bottle (Kitsuhanan Cure)"
	desc = "A rare cure provided by KHI that helps counteract negative side effects of using imperfect resleeving machinery."
	starts_with = list(/obj/item/weapon/reagent_containers/pill/sleevingcure = 7)

/obj/item/weapon/storage/pill_bottle/sleevingcure/full
	starts_with = list(/obj/item/weapon/reagent_containers/pill/sleevingcure = 14)

/obj/item/weapon/storage/firstaid/insiderepair
	name = "combat organ kit"
	desc = "Contains advanced organ medical treatments."
	icon_state = "bezerk"
	item_state_slots = list(slot_r_hand_str = "firstaid-advanced", slot_l_hand_str = "firstaid-advanced")
	starts_with = list(
		/obj/item/weapon/storage/pill_bottle/rezadone,
		/obj/item/weapon/storage/pill_bottle/peridaxon,
		/obj/item/weapon/storage/pill_bottle/carthatoline,
		/obj/item/weapon/storage/pill_bottle/alkysine,
		/obj/item/weapon/storage/pill_bottle/imidazoline,
		/obj/item/weapon/storage/pill_bottle/osteodaxon,
		/obj/item/weapon/storage/pill_bottle/myelamine,
		/obj/item/weapon/storage/pill_bottle/arithrazine,
		/obj/item/device/healthanalyzer/advanced
	)

/obj/item/weapon/storage/mrebag/pill
	name = "vacuum-sealed pill"
	desc = "A small vacuum-sealed package containing a singular pill. For emergencies only."
	icon_state = "pouch_small"
	max_w_class = ITEMSIZE_TINY
	can_hold = list(/obj/item/weapon/reagent_containers/pill)

/obj/item/weapon/storage/mrebag/pill/sleevingcure
	name = "vacuum-sealed pill (Kitsuhanan Cure)"
	desc = "A small vacuum-sealed package containing a singular pill. For emergencies only."
	starts_with = list(/obj/item/weapon/reagent_containers/pill/sleevingcure)

/obj/item/weapon/storage/pill_bottle/paracetamol
	name = "pill bottle (Paracetamol)"
	desc = "Contains over the counter medicine to treat pain."
	starts_with = list(/obj/item/weapon/reagent_containers/pill/paracetamol = 7)
	wrapper_color = COLOR_GRAY
