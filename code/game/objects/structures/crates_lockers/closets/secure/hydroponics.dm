/obj/structure/closet/secure_closet/hydroponics
	name = "botanist's locker"
	req_access = list(access_hydroponics)
	closet_appearance = /decl/closet_appearance/secure_closet/hydroponics

	starts_with = list(
		/obj/item/weapon/storage/bag/plants,
		/obj/item/clothing/under/rank/hydroponics,
		/obj/item/clothing/gloves/botanic_leather,
		/obj/item/device/analyzer/plant_analyzer,
		/obj/item/device/radio/headset/headset_service,
		/obj/item/clothing/head/greenbandana,
		/obj/item/weapon/material/minihoe,
		/obj/item/weapon/material/knife/machete/hatchet,
		/obj/item/weapon/reagent_containers/glass/beaker = 2,
		/obj/item/weapon/tool/wirecutters/clippers/trimmers,
		/obj/item/weapon/reagent_containers/spray/plantbgone,
		/obj/item/clothing/suit/storage/hooded/wintercoat/hydro,
		/obj/item/clothing/shoes/boots/winter/hydro)

/obj/structure/closet/secure_closet/hydroponics/Initialize()
	if(prob(50))
		starts_with += /obj/item/clothing/suit/storage/apron
	else
		starts_with += /obj/item/clothing/suit/storage/apron/overalls
	return ..()

/obj/structure/closet/secure_closet/hydroponics/sci
	name = "xenoflorist's locker"
	req_access = list(access_xenobiology)
	closet_appearance = /decl/closet_appearance/secure_closet/hydroponics/xenoflora

/obj/structure/closet/secure_closet/hydroponics/sci/Initialize()
	starts_with += /obj/item/clothing/head/bio_hood/scientist
	starts_with += /obj/item/clothing/suit/bio_suit/scientist
	starts_with += /obj/item/clothing/mask/gas					// VOREStation Edit: Gasmasks we use are different

	if(prob(1))
		starts_with += /obj/item/weapon/chainsaw

	return ..()
