/obj/item/reagent_containers/hypospray/autoinjector/burn
	name = "autoinjector (burn)"
	icon_state = "purple"
	filled_reagents = list(REAGENT_ID_DERMALINE = 3.5, REAGENT_ID_LEPORAZINE = 1.5)

/obj/item/reagent_containers/hypospray/autoinjector/trauma
	name = "autoinjector (trauma)"
	icon_state = "black"
	filled_reagents = list(REAGENT_ID_BICARIDINE = 4, REAGENT_ID_TRAMADOL = 1)

/obj/item/reagent_containers/hypospray/autoinjector/oxy
	name = "autoinjector (oxy)"
	icon_state = "blue"
	filled_reagents = list(REAGENT_ID_DEXALINP = 5)

/obj/item/reagent_containers/hypospray/autoinjector/rad
	name = "autoinjector (rad)"
	icon_state = "black"
	filled_reagents = list(REAGENT_ID_HYRONALIN = 5)

/obj/item/storage/box/traumainjectors
	name = "box of emergency injectors"
	desc = "Contains emergency autoinjectors."
	icon_state = "syringe"
	max_storage_space = ITEMSIZE_COST_SMALL * 7 // 14
	starts_with = list(
		/obj/item/reagent_containers/hypospray/autoinjector/trauma = 4,
		/obj/item/reagent_containers/hypospray/autoinjector/detox = 2,
		/obj/item/reagent_containers/hypospray/autoinjector/burn = 1
	)

/obj/item/reagent_containers/hypospray
	var/prototype = 0

/obj/item/reagent_containers/hypospray/science
	name = "prototype hypospray"
	desc = "This reproduction hypospray is nearly a perfect replica of the early model DeForest hyposprays, sharing many of the same features. However, there are additional safety measures installed to prevent unwanted injections."
	prototype = 1
