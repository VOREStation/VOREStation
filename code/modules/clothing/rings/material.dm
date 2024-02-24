/////////////////////////////////////////
//Material Rings
/obj/item/clothing/gloves/ring/material
	icon = 'icons/inventory/hands/item.dmi'
	icon_state = "material"

/obj/item/clothing/gloves/ring/material/New(var/newloc, var/new_material)
	..(newloc)
	if(!new_material)
		new_material = MAT_STEEL
	material = get_material_by_name(new_material)
	if(!istype(material))
		qdel(src)
		return
	name = "[material.display_name] ring"
	desc = "A ring made from [material.display_name]."
	color = material.icon_colour

/obj/item/clothing/gloves/ring/material/get_material()
	return material

/obj/item/clothing/gloves/ring/material/wood/New(var/newloc)
	..(newloc, MAT_WOOD)

/obj/item/clothing/gloves/ring/material/plastic/New(var/newloc)
	..(newloc, MAT_PLASTIC)

/obj/item/clothing/gloves/ring/material/iron/New(var/newloc)
	..(newloc, MAT_IRON)

/obj/item/clothing/gloves/ring/material/glass/New(var/newloc)
	..(newloc, MAT_GLASS)

/obj/item/clothing/gloves/ring/material/steel/New(var/newloc)
	..(newloc, MAT_STEEL)

/obj/item/clothing/gloves/ring/material/silver/New(var/newloc)
	..(newloc, MAT_SILVER)

/obj/item/clothing/gloves/ring/material/gold/New(var/newloc)
	..(newloc, MAT_GOLD)

/obj/item/clothing/gloves/ring/material/platinum/New(var/newloc)
	..(newloc, MAT_PLATINUM)

/obj/item/clothing/gloves/ring/material/phoron/New(var/newloc)
	..(newloc, MAT_PHORON)

/obj/item/clothing/gloves/ring/material/titanium/New(var/newloc)
	..(newloc, MAT_TITANIUM)

/obj/item/clothing/gloves/ring/material/copper/New(var/newloc)
	..(newloc, MAT_COPPER)

/obj/item/clothing/gloves/ring/material/bronze/New(var/newloc)
	..(newloc, MAT_BRONZE)

/obj/item/clothing/gloves/ring/material/uranium/New(var/newloc)
	..(newloc, MAT_URANIUM)

/obj/item/clothing/gloves/ring/material/osmium/New(var/newloc)
	..(newloc, MAT_OSMIUM)

/obj/item/clothing/gloves/ring/material/lead/New(var/newloc)
	..(newloc, MAT_LEAD)

/obj/item/clothing/gloves/ring/material/diamond/New(var/newloc)
	..(newloc, MAT_DIAMOND)

/obj/item/clothing/gloves/ring/material/tin/New(var/newloc)
	..(newloc, MAT_TIN)

/obj/item/clothing/gloves/ring/material/void_opal/New(var/newloc)
	..(newloc, MAT_VOPAL)