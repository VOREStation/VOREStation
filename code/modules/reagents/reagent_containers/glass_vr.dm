/obj/item/weapon/reagent_containers/glass/beaker/neurotoxin
	New()
		..()
		reagents.add_reagent("neurotoxin",50)
		update_icon()

/obj/item/weapon/reagent_containers/glass/beaker/vial/vr
	possible_transfer_amounts = list(5,10,15,30) //Dunno why there was no '30' option before.
	w_class = ITEMSIZE_SMALL //Why would it be the same size as a beaker?
	var/comes_with = list() //Easy way of doing this.

/obj/item/weapon/reagent_containers/glass/beaker/vial/vr/New()
	..()
	for(var/R in comes_with)
		reagents.add_reagent(R,comes_with[R])

/obj/item/weapon/reagent_containers/glass/beaker/vial/vr/bicaridine
	name = "vial (bicaridine)"
	comes_with = list("bicaridine" = 30)

/obj/item/weapon/reagent_containers/glass/beaker/vial/vr/dylovene
	name = "vial (dylovene)"
	comes_with = list("dylovene" = 30)

/obj/item/weapon/reagent_containers/glass/beaker/vial/vr/dermaline
	name = "vial (dermaline)"
	comes_with = list("dermaline" = 30)

/obj/item/weapon/reagent_containers/glass/beaker/vial/vr/kelotane
	name = "vial (kelotane)"
	comes_with = list("kelotane" = 30)

/obj/item/weapon/reagent_containers/glass/beaker/vial/vr/inaprovaline
	name = "vial (inaprovaline)"
	comes_with = list("inaprovaline" = 30)

/obj/item/weapon/reagent_containers/glass/beaker/vial/vr/dexalin
	name = "vial (dexalin)"
	comes_with = list("dexalin" = 30)

/obj/item/weapon/reagent_containers/glass/beaker/vial/vr/dexalinplus
	name = "vial (dexalinp)"
	comes_with = list("dexalinp" = 30)

/obj/item/weapon/reagent_containers/glass/beaker/vial/vr/tricordrazine
	name = "vial (tricordrazine)"
	comes_with = list("tricordrazine" = 30)

/obj/item/weapon/reagent_containers/glass/beaker/vial/vr/alkysine
	name = "vial (alkysine)"
	comes_with = list("alkysine" = 30)

/obj/item/weapon/reagent_containers/glass/beaker/vial/vr/imidazoline
	name = "vial (imidazoline)"
	comes_with = list("imidazoline" = 30)

/obj/item/weapon/reagent_containers/glass/beaker/vial/vr/peridaxon
	name = "vial (peridaxon)"
	comes_with = list("peridaxon" = 30)

/obj/item/weapon/reagent_containers/glass/beaker/vial/vr/hyronalin
	name = "vial (hyronalin)"
	comes_with = list("hyronalin" = 30)
