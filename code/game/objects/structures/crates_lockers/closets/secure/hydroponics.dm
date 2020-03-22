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
	icon_state = "scihydrosecure1"
	icon_closed = "scihydrosecure"
	icon_locked = "scihydrosecure1"
	icon_opened = "scihydrosecureopen"
	icon_broken = "scihydrosecurebroken"
	icon_off = "scihydrosecureoff"

/obj/structure/closet/secure_closet/hydroponics/sci/Initialize()
	starts_with += /obj/item/clothing/head/bio_hood/scientist
	starts_with += /obj/item/clothing/suit/bio_suit/scientist
	starts_with += /obj/item/clothing/mask/gas					// VOREStation Edit: Gasmasks we use are different

	if(prob(1))
		starts_with += /obj/item/weapon/chainsaw

	return ..()
