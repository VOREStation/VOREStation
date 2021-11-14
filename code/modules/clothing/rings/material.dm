/////////////////////////////////////////
//Material Rings
/obj/item/clothing/gloves/ring/material
	icon = 'icons/inventory/hands/item.dmi'
	icon_state = "material"

/obj/item/clothing/gloves/ring/material/Initialize(var/ml, var/new_material)
	. = ..(ml)
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

/obj/item/clothing/gloves/ring/material/wood/Initialize(var/ml)
	. = ..(ml, MAT_WOOD)

/obj/item/clothing/gloves/ring/material/plastic/Initialize(var/ml)
	. = ..(ml, MAT_PLASTIC)

/obj/item/clothing/gloves/ring/material/iron/Initialize(var/ml)
	. = ..(ml, MAT_IRON)

/obj/item/clothing/gloves/ring/material/glass/Initialize(var/ml)
	. = ..(ml, MAT_GLASS)

/obj/item/clothing/gloves/ring/material/steel/Initialize(var/ml)
	. = ..(ml, MAT_STEEL)

/obj/item/clothing/gloves/ring/material/silver/Initialize(var/ml)
	. = ..(ml, MAT_SILVER)

/obj/item/clothing/gloves/ring/material/gold/Initialize(var/ml)
	. = ..(ml, MAT_GOLD)

/obj/item/clothing/gloves/ring/material/platinum/Initialize(var/ml)
	. = ..(ml, MAT_PLATINUM)

/obj/item/clothing/gloves/ring/material/phoron/Initialize(var/ml)
	. = ..(ml, MAT_PHORON)

/obj/item/clothing/gloves/ring/material/titanium/Initialize(var/ml)
	. = ..(ml, MAT_TITANIUM)

/obj/item/clothing/gloves/ring/material/copper/Initialize(var/ml)
	. = ..(ml, MAT_COPPER)

/obj/item/clothing/gloves/ring/material/bronze/Initialize(var/ml)
	. = ..(ml, MAT_BRONZE)

/obj/item/clothing/gloves/ring/material/uranium/Initialize(var/ml)
	. = ..(ml, MAT_URANIUM)

/obj/item/clothing/gloves/ring/material/osmium/Initialize(var/ml)
	. = ..(ml, MAT_OSMIUM)

/obj/item/clothing/gloves/ring/material/lead/Initialize(var/ml)
	. = ..(ml, MAT_LEAD)

/obj/item/clothing/gloves/ring/material/diamond/Initialize(var/ml)
	. = ..(ml, MAT_DIAMOND)

/obj/item/clothing/gloves/ring/material/tin/Initialize(var/ml)
	. = ..(ml, MAT_TIN)
