/obj/structure/closet/secure_closet/hydroponics
	name = "botanist's locker"
	req_access = list(access_hydroponics)
	icon_state = "hydrosecure1"
	icon_closed = "hydrosecure"
	icon_locked = "hydrosecure1"
	icon_opened = "hydrosecureopen"
	icon_broken = "hydrosecurebroken"
	icon_off = "hydrosecureoff"

	starts_with = list(
		/obj/item/weapon/storage/bag/plants,
		/obj/item/clothing/under/rank/hydroponics,
		/obj/item/device/analyzer/plant_analyzer,
		/obj/item/device/radio/headset/headset_service,
		/obj/item/clothing/head/greenbandana,
		/obj/item/weapon/material/minihoe,
		/obj/item/weapon/material/knife/machete/hatchet,
		/obj/item/weapon/tool/wirecutters/clippers,
		/obj/item/weapon/reagent_containers/spray/plantbgone,
		/obj/item/clothing/suit/storage/hooded/wintercoat/hydro,
		/obj/item/clothing/shoes/boots/winter/hydro)

/obj/structure/closet/secure_closet/hydroponics/initialize()
	if(prob(50))
		starts_with += /obj/item/clothing/suit/storage/apron
	else
		starts_with += /obj/item/clothing/suit/storage/apron/overalls
	return ..()
