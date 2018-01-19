/*
 * SC Science
 */


/obj/structure/closet/secure_closet/RD_wardrobe
	name = "research director's locker"
	req_access = list(access_rd)
	icon_state = "rdsecure1"
	icon_closed = "rdsecure"
	icon_locked = "rdsecure1"
	icon_opened = "rdsecureopen"
	icon_broken = "rdsecurebroken"
	icon_off = "rdsecureoff"

/obj/structure/closet/secure_closet/RD_wardrobe/New()
	..()
	new /obj/item/clothing/under/rank/research_director(src)
	new /obj/item/clothing/under/rank/research_director/rdalt(src)
	new /obj/item/clothing/under/rank/research_director/dress_rd(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/weapon/cartridge/rd(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/shoes/leather(src)
	new /obj/item/clothing/gloves/sterile/latex(src)
	new /obj/item/device/radio/headset/heads/rd(src)
	return