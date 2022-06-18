/obj/structure/closet/secure_closet/freezer/kitchen
	name = "kitchen cabinet"
	req_access = list(access_kitchen)

	starts_with = list(
		/obj/item/weapon/reagent_containers/food/condiment/carton/flour = 6,
		/obj/item/weapon/reagent_containers/food/condiment/carton/sugar = 1,
		/obj/item/weapon/reagent_containers/food/condiment/carton/flour/rustic = 1,
		/obj/item/weapon/reagent_containers/food/condiment/carton/sugar/rustic = 1,
		/obj/item/weapon/reagent_containers/food/condiment/spacespice = 2
		)

	open_sound = 'sound/machines/click.ogg'
	close_sound = 'sound/machines/click.ogg'

/obj/structure/closet/secure_closet/freezer/kitchen/mining
	req_access = list()


/obj/structure/closet/secure_closet/freezer/meat
	name = "meat fridge"
	icon = 'icons/obj/closets/fridge.dmi'
	closet_appearance = null

	starts_with = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/monkey = 10)


/obj/structure/closet/secure_closet/freezer/fridge
	name = "refrigerator"
	icon = 'icons/obj/closets/fridge.dmi'
	closet_appearance = null

	starts_with = list(
		/obj/item/weapon/reagent_containers/food/drinks/milk = 6,
		/obj/item/weapon/reagent_containers/food/drinks/soymilk = 4,
		/obj/item/weapon/storage/fancy/egg_box = 4,
		/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/glucose = 2)


/obj/structure/closet/secure_closet/freezer/money
	name = "freezer"
	icon = 'icons/obj/closets/fridge.dmi'
	closet_appearance = null
	req_access = list(access_heads_vault)


	starts_with = list(
		/obj/item/weapon/spacecash/c1000 = 3,
		/obj/item/weapon/spacecash/c500 = 4,
		/obj/item/weapon/spacecash/c200 = 5)
