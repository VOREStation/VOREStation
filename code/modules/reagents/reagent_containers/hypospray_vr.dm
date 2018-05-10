/obj/item/weapon/reagent_containers/hypospray/autoinjector/miner
	name = "Emergency trauma injector"
	desc = "A rapid injector for emergency treatment of injuries. The warning label advises that it is not a substitute for proper medical treatment."
	icon_state = "autoinjector"
	item_state = "autoinjector"
	amount_per_transfer_from_this = 10
	volume = 10

/obj/item/weapon/reagent_containers/hypospray/autoinjector/miner/New()
	..()
	reagents.add_reagent("bicaridine", 5)
	reagents.add_reagent("tricordrazine", 3)
	reagents.add_reagent("tramadol", 2)
	update_icon()

/obj/item/weapon/storage/box/traumainjectors
	name = "box of emergency trauma injectors"
	desc = "Contains emergency trauma autoinjectors."
	icon_state = "syringe"

/obj/item/weapon/storage/box/traumainjectors/New()
	..()
	for (var/i = 1 to 7)
		new /obj/item/weapon/reagent_containers/hypospray/autoinjector/miner(src)
