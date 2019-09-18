/obj/item/stack/nanopaste
	var/restoration_external = 5
	var/restoration_internal = 20
	var/repair_external = FALSE

/obj/item/stack/nanopaste/advanced
	name = "advanced nanopaste"
	singular_name = "advanced nanite swarm"
	desc = "A tube of paste containing swarms of repair nanites. Very effective in repairing robotic machinery. These ones are capable of restoring condition even of most thrashed robotic parts"
	icon = 'icons/obj/stacks_vr.dmi'
	icon_state = "adv_nanopaste"
	restoration_external = 10
	repair_external = TRUE