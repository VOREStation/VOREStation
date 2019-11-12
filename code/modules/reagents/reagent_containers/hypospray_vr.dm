/obj/item/weapon/reagent_containers/hypospray/autoinjector/miner
	name = "Emergency trauma injector"
	desc = "A rapid injector for emergency treatment of injuries. The warning label advises that it is not a substitute for proper medical treatment."
	icon_state = "autoinjector"
	item_state = "autoinjector"
	amount_per_transfer_from_this = 10
	volume = 10

/obj/item/weapon/reagent_containers/hypospray/autoinjector/miner/Initialize()
	..()
	reagents.add_reagent("bicaridine", 5)
	reagents.add_reagent("tricordrazine", 3)
	reagents.add_reagent("tramadol", 2)
	update_icon()

/obj/item/weapon/storage/box/traumainjectors
	name = "box of emergency trauma injectors"
	desc = "Contains emergency trauma autoinjectors."
	icon_state = "syringe"

/obj/item/weapon/storage/box/traumainjectors/Initialize()
	..()
	for (var/i = 1 to 7)
		new /obj/item/weapon/reagent_containers/hypospray/autoinjector/miner(src)

/obj/item/weapon/reagent_containers/hypospray
	var/prototype = 0

/obj/item/weapon/reagent_containers/hypospray/science
	name = "prototype hypospray"
	desc = "This reproduction hypospray is nearly a perfect replica of the early model DeForest hyposprays, sharing many of the same features. However, there are additional safety measures installed to prevent unwanted injections."
	prototype = 1
