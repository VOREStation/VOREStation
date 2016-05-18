/*
	Here lives the slime core extractor
	This machine extracts slime cores at the cost of the slime itself.
	To create more of these slimes, stick the slime core in the replicator.
*/
/obj/machinery/slime/extractor
	name = "Slime extractor"
	desc = "A machine for cutting up slimes to get to their cores."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "scanner_0old"
	density = 1
	anchored = 1
	circuit = /obj/item/weapon/circuitboard/slimeextractor
	var/inuse
	var/mob/living/simple_animal/xeno/slime/occupant = null
	var/occupiedcolor = "#22FF22"
	var/emptycolor = "#FF2222"
	var/operatingcolor = "#FFFF22"
	
/obj/machinery/slime/extractor/map/New()
	..()
	circuit = new circuit(src)
	component_parts = list()
	//Component parts go here,
	
	
/obj/machinery/slime/extractor/attackby(var/obj/item/W, var/mob/user)

	//Let's try to deconstruct first.
	if(istype(W, /obj/item/weapon/screwdriver) && !inuse)
		default_deconstruction_screwdriver(user, W)
		return
	
	if(istype(W, /obj/item/weapon/crowbar))
		default_deconstruction_crowbar(user, W)
		return

	if(panel_open)
		user << "<span class='warning'>Close the panel first!</span>"

	var/obj/item/weapon/grab/G = W
	
	if(!istype(G))
		return ..()

	if(G.state < 2)
		user << "<span class='danger'>You need a better grip to do that!</span>"
		return

	move_into_extractor(user,G.affecting)
	
/obj/machinery/slime/extractor/MouseDrop_T(mob/target, mob/user)
	if(user.stat || user.restrained())
		return
	move_into_extractor(user,target)
	
/obj/machinery/slime/extractor/proc/move_into_extractor(var/mob/user,var/mob/living/victim)

	if(src.occupant)
		user << "<span class='danger'>The core extractor is full, empty it first!</span>"
		return

	if(in_use)
		user << "<span class='danger'>The core extractor is locked and running, wait for it to finish.</span>"
		return

	if(!(istype(victim, /mob/living/simple_animal/xeno/slime)) )
		user << "<span class='danger'>This is not a suitable subject for the core extractor!</span>"
		return

	user.visible_message("<span class='danger'>[user] starts to put [victim] into the core extractor!</span>")
	src.add_fingerprint(user)
	if(do_after(user, 30) && victim.Adjacent(src) && user.Adjacent(src) && victim.Adjacent(user) && !occupant)
		user.visible_message("<span class='danger'>[user] stuffs [victim] into the core extractor!</span>")
		if(victim.client)
			victim.client.perspective = EYE_PERSPECTIVE
			victim.client.eye = src
		victim.forceMove(src)
		src.occupant = victim
		update_light_color()
		
/obj/machinery/slime/extractor/proc/update_light_color()
	if(src.occupant && !(inuse))
		set_light(4, 4, occupiedcolor)
	else if(src.occupant)
		set_light(4, 4, operatingcolor)
	else
		set_light(4, 4, emptycolor)
		
/obj/machinery/slime/extractor/proc/extract_cores()
	if(!src.occupant)
		src.visible_message("\icon[src] [src] pings unhappily.")
	else if(inuse)
		return
		
	inuse = 1
	update_light_color()
	spawn(30)
		icon_state = "scanner_1old"
		for(var/i=1 to occupant.cores)
			var/obj/item/xenoproduct/slime/core/C = new(src)
			C.traits = occupant.traitdat
			
			C.create_reagents(C.traits.traits[TRAIT_XENO_CHEMVOL])
			for(var/reagent in occupant.traitdat.chems.reagents)
				var/amount = occupant.traitdat.chems.reagents[reagent]
				C.reagents.add_reagent(reagent, amount)
				
			C.color = C.traits.traits[TRAIT_XENO_COLOR]
			
		spawn(30)
			icon_state = "scanner_0old"
			qdel(occupant)
			inuse = 0
			eject_contents()
			update_light_color()
			
/obj/machinery/slime/extractor/proc/eject_contents()
	for(var/obj/thing in (contents - component_parts - circuit))
		thing.forceMove(loc)
	if(occupant)
		occupant.forceMove(loc)
		occupant = null
	
//Circuit board below,
/obj/item/weapon/circuitboard/slimeextractor
	name = T_BOARD("Slime extractor")
	build_path = "/obj/machinery/slime/extractor"
	board_type = "machine"
	origin_tech = list()	//To be filled,
	req_components = list()	//To be filled, 
	