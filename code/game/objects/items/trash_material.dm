/obj/item/trash/material
	icon = 'icons/obj/material_trash.dmi'
	matter = list()
	var/matter_chances = list()	//List of lists: list(mat_name, chance, amount)


/obj/item/trash/material/Initialize(mapload)
	. = ..()
	if(!matter)
		matter = list()

	for(var/list/L in matter_chances)
		if(prob(L[2]))
			matter |= L[1]
			matter[L[1]] += max(0, L[3] + rand(-2,2))




/obj/item/trash/material/metal
	name = "scrap metal"
	desc = "A piece of metal that can be recycled in an autolathe."
	icon_state = "metal0"
	matter_chances = list(
		list(MAT_STEEL, 100, 15),
		list(MAT_STEEL, 50, 10),
		list(MAT_STEEL, 10, 20),
		list(MAT_PLASTEEL, 10, 5),
		list(MAT_PLASTEEL, 5, 10)
	)

/obj/item/trash/material/metal/Initialize(mapload)
	. = ..()
	icon_state = "metal[rand(4)]"


/obj/item/trash/material/circuit
	name = "burnt circuit"
	desc = "A burnt circuit that can be recycled in an autolathe."
	w_class = ITEMSIZE_SMALL
	icon_state = "circuit0"
	matter_chances = list(
		list(MAT_GLASS, 100, 4),
		list(MAT_GLASS, 50, 3),
		list(MAT_PLASTIC, 40, 3),
		list(MAT_SILVER, 18, 3),
		list(MAT_GOLD, 17, 3),
		list(MAT_DIAMOND, 4, 2),
	)

/obj/item/trash/material/circuit/Initialize(mapload)
	. = ..()
	icon_state = "circuit[rand(3)]"


/obj/item/trash/material/device
	name = "broken device"
	desc = "A broken device that can be recycled in an autolathe."
	w_class = ITEMSIZE_SMALL
	icon_state = "device0"
	matter_chances = list(
		list(MAT_STEEL, 100, 10),
		list(MAT_GLASS, 90, 7),
		list(MAT_PLASTIC, 100, 10),
		list(MAT_SILVER, 16, 7),
		list(MAT_GOLD, 15, 5),
		list(MAT_DIAMOND, 5, 2),
	)

/obj/item/trash/material/device/Initialize(mapload)
	. = ..()
	icon_state = "device[rand(3)]"
