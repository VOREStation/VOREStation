/obj/structure/closet/secure_closet/pathfinder
	name = "pathfinder locker"
	icon = 'icons/obj/closet_vr.dmi'
	icon_state = "secureexp1"
	icon_closed = "secureexp"
	icon_locked = "secureexp1"
	icon_opened = "secureexpopen"
	icon_broken = "secureexpbroken"
	icon_off = "secureexpoff"
	req_access = list(access_explorer)

	starts_with = list(
		/obj/item/clothing/under/explorer,
		/obj/item/clothing/suit/storage/hooded/explorer,
		/obj/item/clothing/mask/gas/explorer,
		/obj/item/clothing/shoes/boots/winter/explorer,
		/obj/item/clothing/gloves/black,
		/obj/item/device/radio/headset/explorer,
		/obj/item/device/flashlight,
		/obj/item/device/gps/explorer,
		/obj/item/weapon/storage/box/flare,
		/obj/item/weapon/storage/box/explorerkeys,
		/obj/item/device/geiger,
		/obj/item/weapon/cell/device,
		/obj/item/device/radio,
		/obj/item/stack/marker_beacon/thirty,
		/obj/item/weapon/material/knife/tacknife/survival,
		/obj/item/weapon/material/knife/machete/deluxe,
		/obj/item/clothing/accessory/holster/machete,
		/obj/item/weapon/reagent_containers/food/snacks/liquidfood = 2)

/obj/structure/closet/secure_closet/explorer/initialize()
	if(prob(50))
		starts_with += /obj/item/weapon/storage/backpack
	else
		starts_with += /obj/item/weapon/storage/backpack/satchel/norm
	return ..()
