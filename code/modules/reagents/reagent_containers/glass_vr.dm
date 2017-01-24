/obj/item/weapon/reagent_containers/glass/beaker/neurotoxin
	New()
		..()
		reagents.add_reagent("neurotoxin",50)
		update_icon()

/obj/item/weapon/reagent_containers/glass/beaker/vial/vr
	possible_transfer_amounts = list(5,10,15,30) //Dunno why there was no '30' option before.
	w_class = ITEMSIZE_SMALL //Why would it be the same size as a beaker?
	var/starting_reagent //Easy way of doing this.

/obj/item/weapon/reagent_containers/glass/beaker/vial/vr/New()
	..()
	if(starting_reagent)
		reagents.add_reagent(starting_reagent, 30)
		update_icon()

/obj/item/weapon/reagent_containers/glass/beaker/vial/vr/bicaridine
	name = "vial (bicaridine)"
	starting_reagent = "bicaridine"

/obj/item/weapon/reagent_containers/glass/beaker/vial/vr/dylovene
	name = "vial (dylovene)"
	starting_reagent = "dylovene"

/obj/item/weapon/reagent_containers/glass/beaker/vial/vr/dermaline
	name = "vial (dermaline)"
	starting_reagent = "dermaline"

/obj/item/weapon/reagent_containers/glass/beaker/vial/vr/kelotane
	name = "vial (kelotane)"
	starting_reagent = "kelotane"

/obj/item/weapon/reagent_containers/glass/beaker/vial/vr/inaprovaline
	name = "vial (inaprovaline)"
	starting_reagent = "inaprovaline"

/obj/item/weapon/reagent_containers/glass/beaker/vial/vr/dexalin
	name = "vial (dexalin)"
	starting_reagent = "dexalin"

/obj/item/weapon/reagent_containers/glass/beaker/vial/vr/dexalinplus
	name = "vial (dexalinp)"
	starting_reagent = "dexalinp"

/obj/item/weapon/reagent_containers/glass/beaker/vial/vr/tricordrazine
	name = "vial (tricordrazine)"
	starting_reagent = "tricordrazine"

/obj/item/weapon/reagent_containers/glass/beaker/vial/vr/alkysine
	name = "vial (alkysine)"
	starting_reagent = "alkysine"

/obj/item/weapon/reagent_containers/glass/beaker/vial/vr/imidazoline
	name = "vial (imidazoline)"
	starting_reagent = "imidazoline"

/obj/item/weapon/reagent_containers/glass/beaker/vial/vr/peridaxon
	name = "vial (peridaxon)"
	starting_reagent = "peridaxon"

/obj/item/weapon/reagent_containers/glass/beaker/vial/vr/hyronalin
	name = "vial (hyronalin)"
	starting_reagent = "hyronalin"
