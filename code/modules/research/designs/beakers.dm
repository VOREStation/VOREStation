// Various beakers

/datum/design/item/beaker/AssembleDesignName()
	name = "Beaker prototype ([item_name])"

/datum/design/item/beaker/noreact
	name = "cryostasis"
	desc = "A cryostasis beaker that allows for chemical storage without reactions. Can hold up to 50 units."
	id = "splitbeaker"
	req_tech = list(TECH_MATERIAL = 2)
	materials = list(MAT_STEEL = 3000)
	build_path = /obj/item/reagent_containers/glass/beaker/noreact
	sort_string = "IAAAA"

/datum/design/item/beaker/bluespace
	name = TECH_BLUESPACE
	desc = "A bluespace beaker, powered by experimental bluespace technology and Element Cuban combined with the Compound Pete. Can hold up to 300 units."
	id = "bluespacebeaker"
	req_tech = list(TECH_BLUESPACE = 2, TECH_MATERIAL = 6)
<<<<<<< HEAD
	materials = list(MAT_STEEL = 3000, MAT_PHORON = 3000, MAT_DIAMOND = 500)
	build_path = /obj/item/weapon/reagent_containers/glass/beaker/bluespace
=======
	materials = list(MAT_STEEL = 3000, "phoron" = 3000, "diamond" = 500)
	build_path = /obj/item/reagent_containers/glass/beaker/bluespace
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	sort_string = "IAAAB"