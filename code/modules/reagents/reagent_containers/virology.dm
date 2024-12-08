/obj/item/reagent_containers/glass/bottle/culture
	name = "virus culture"
	desc = "A bottle with a virus culture"
	icon_state = "bottle-1"
	var/list/data = list("donor" = null, "viruses" = null, "blood_DNA" = null, "blood_type" = null, "resistances" = null, "trace_chems" = null)
	var/list/diseases = list()

/obj/item/reagent_containers/glass/bottle/culture/cold
	name = "cold virus culture"
	desc = "A bottle with the common cold culture"

/obj/item/reagent_containers/glass/bottle/culture/cold/Initialize()
	. = ..()
	diseases += new /datum/disease/advance/cold
	data["viruses"] = diseases
	reagents.add_reagent(REAGENT_ID_BLOOD, 10, data)

/obj/item/reagent_containers/glass/bottle/culture/flu
	name = "flu virus culture"
	desc = "A bottle with the flu culture"

/obj/item/reagent_containers/glass/bottle/culture/flu/Initialize()
	. = ..()
	diseases += new /datum/disease/advance/flu
	data["viruses"] = diseases
	reagents.add_reagent(REAGENT_ID_BLOOD, 10, data)
