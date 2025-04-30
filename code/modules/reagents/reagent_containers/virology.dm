/obj/item/reagent_containers/glass/beaker/vial/culture
	name = "virus culture"
	desc = "A bottle with a virus culture"
	var/list/data = list("donor" = null, "viruses" = null, "blood_DNA" = null, "blood_type" = null, "resistances" = null, "trace_chems" = null)
	var/list/diseases = list()

/obj/item/reagent_containers/glass/beaker/vial/culture/cold
	name = "cold virus culture"
	desc = "A bottle with the common cold culture"

/obj/item/reagent_containers/glass/beaker/vial/culture/cold/Initialize(mapload)
	. = ..()
	diseases += new /datum/disease/advance/cold
	data["viruses"] = diseases
	reagents.add_reagent(REAGENT_ID_BLOOD, 10, data)

/obj/item/reagent_containers/glass/beaker/vial/culture/flu
	name = "flu virus culture"
	desc = "A bottle with the flu culture"

/obj/item/reagent_containers/glass/beaker/vial/culture/flu/Initialize(mapload)
	. = ..()
	diseases += new /datum/disease/advance/flu
	data["viruses"] = diseases
	reagents.add_reagent(REAGENT_ID_BLOOD, 10, data)

/obj/item/reagent_containers/glass/beaker/vial/culture/blobspores
	name = "blob spores culture"
	desc = "A bottle with blob spores"

/obj/item/reagent_containers/glass/beaker/vial/culture/blobspores/Initialize(mapload)
	. = ..()
	diseases += new /datum/disease/advance/blobspores
	data["viruses"] = diseases
	reagents.add_reagent(REAGENT_ID_BLOOD, 10, data)

/obj/item/reagent_containers/glass/beaker/vial/culture/macrophages
	name = "macrophages culture"
	desc = "A bottle with giant viruses"

/obj/item/reagent_containers/glass/beaker/vial/culture/macrophages/Initialize(mapload)
	. = ..()
	diseases += new /datum/disease/advance/macrophage
	data["viruses"] = diseases
	reagents.add_reagent(REAGENT_ID_BLOOD, 10, data)

/obj/item/reagent_containers/glass/beaker/vial/culture/random_virus
	name = "experimental disease culture bottle"
	desc = "A small bottle. Contains an untested viral culture."

/obj/item/reagent_containers/glass/beaker/vial/culture/random_virus/Initialize(mapload)
	. = ..()
	diseases += new /datum/disease/advance/random
	data["viruses"] = diseases
	reagents.add_reagent(REAGENT_ID_BLOOD, 10, data)

/obj/item/reagent_containers/glass/beaker/vial/culture/random_virus/minor
	name = "minor experimental disease culture bottle"
	desc = "A small bottle. Contains a weak version of an untested viral culture."

/obj/item/reagent_containers/glass/beaker/vial/culture/random_virus/minor/Initialize(mapload)
	. = ..()
	diseases += new /datum/disease/advance/random/minor
	data["viruses"] = diseases
	reagents.add_reagent(REAGENT_ID_BLOOD, 10, data)
