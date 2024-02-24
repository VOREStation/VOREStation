/obj/item/weapon/reagent_containers/hypospray/autoinjector/burn
	name = "autoinjector (burn)"
	icon_state = "purple"
	filled_reagents = list("dermaline" = 3.5, "leporazine" = 1.5)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/trauma
	name = "autoinjector (trauma)"
	icon_state = "black"
	filled_reagents = list("bicaridine" = 4, "tramadol" = 1)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/oxy
	name = "autoinjector (oxy)"
	icon_state = "blue"
	filled_reagents = list("dexalinp" = 5)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/rad
	name = "autoinjector (rad)"
	icon_state = "black"
	filled_reagents = list("hyronalin" = 5)

/obj/item/weapon/storage/box/traumainjectors
	name = "box of emergency injectors"
	desc = "Contains emergency autoinjectors."
	icon_state = "syringe"
	max_storage_space = ITEMSIZE_COST_SMALL * 7 // 14
	starts_with = list(
		/obj/item/weapon/reagent_containers/hypospray/autoinjector/trauma = 4,
		/obj/item/weapon/reagent_containers/hypospray/autoinjector/detox = 2,
		/obj/item/weapon/reagent_containers/hypospray/autoinjector/burn = 1
	)

/obj/item/weapon/reagent_containers/hypospray
	var/prototype = 0

/obj/item/weapon/reagent_containers/hypospray/science
	name = "prototype hypospray"
	desc = "This reproduction hypospray is nearly a perfect replica of the early model DeForest hyposprays, sharing many of the same features. However, there are additional safety measures installed to prevent unwanted injections."
	prototype = 1
