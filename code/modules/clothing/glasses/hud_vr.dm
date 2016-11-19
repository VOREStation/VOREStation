/obj/item/clothing/glasses/sunglasses/omnihud
	name = "AR sunglasses"
	desc = "The KHI-63 AR Sunglasses are a design from Kitsuhana Heavy Industries. \
	Not as complete as specialist HUD systems in their standard configuration, but they \
	do combine features from several different existing HUDs."
	origin_tech = list(TECH_MAGNET = 3, TECH_BIO = 3)
	var/obj/item/clothing/glasses/hud/omni/hud = null

	icon = 'icons/vore/custom_items_vr.dmi'
	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "omniglasses"
	var/mode = "civ"

	New()
		..()
		src.hud = new/obj/item/clothing/glasses/hud/omni(src)
		return

/obj/item/clothing/glasses/sunglasses/omnihud/cmo
	name = "AR-M sunglasses"
	desc = "The KHI-63-M AR Sunglasses are a design from Kitsuhana Heavy Industries. \
	These have been upgraded with advanced medical records integration."
	mode = "med"

/obj/item/clothing/glasses/sunglasses/omnihud/hos
	name = "AR-S sunglasses"
	desc = "The KHI-63-S AR Sunglasses are a design from Kitsuhana Heavy Industries. \
	These have been upgraded with advanced security records integration."
	mode = "sec"

/obj/item/clothing/glasses/sunglasses/omnihud/best
	name = "AR-B sunglasses"
	desc = "The KHI-63-B AR Sunglasses are a design from Kitsuhana Heavy Industries. \
	These have been upgraded with advanced medical and security records integration."
	mode = "best"

/obj/item/clothing/glasses/hud/omni
	name = "internal omni hud"
	desc = "You shouldn't see this. This is an internal item for sunglasses."
	var/obj/item/clothing/glasses/sunglasses/omnihud/shades = null

	vision_flags = SEE_MOBS
	see_invisible = SEE_INVISIBLE_NOLIGHTING

	New()
		..()
		if(istype(loc,/obj/item/clothing/glasses/sunglasses/omnihud))
			shades = loc
		else
			qdel(src)

/obj/item/clothing/glasses/hud/omni/process_hud(var/mob/M)
	process_omni_hud(M,shades.mode)