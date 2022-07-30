/*
	Here lives the slime core extractor
	This machine extracts slime cores at the cost of the slime itself.
	To create more of these slimes, stick the slime core in the extractor.
*/
/obj/machinery/slime/extractor
	name = "Slime extractor"
	desc = "A machine for cutting up slimes to get to their cores."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "scanner_0old"
	density = TRUE
	anchored = TRUE
	circuit = /obj/item/circuitboard/slimeextractor
	var/inuse
	var/mob/living/simple_mob/xeno/slime/occupant = null
	var/occupiedcolor = "#22FF22"
	var/emptycolor = "#FF2222"
	var/operatingcolor = "#FFFF22"


/obj/machinery/slime/extractor/Initialize()
	. = ..()
	default_apply_parts()
	update_light_color()

/obj/machinery/slime/extractor/attackby(var/obj/item/W, var/mob/user)

	//Let's try to deconstruct first.
	if(W.is_screwdriver() && !inuse)
		default_deconstruction_screwdriver(user, W)
		return

	if(W.is_crowbar())
		default_deconstruction_crowbar(user, W)
		return

	if(panel_open)
		to_chat(user, "<span class='warning'>Close the panel first!</span>")

	var/obj/item/grab/G = W

	if(!istype(G))
		return ..()

	if(G.state < 2)
		to_chat(user, "<span class='danger'>You need a better grip to do that!</span>")
		return

	move_into_extractor(user,G.affecting)

/obj/machinery/slime/extractor/MouseDrop_T(mob/target, mob/user)
	if(user.stat || user.restrained())
		return
	move_into_extractor(user,target)

/obj/machinery/slime/extractor/proc/move_into_extractor(var/mob/user,var/mob/living/victim)

	if(src.occupant)
		to_chat(user, "<span class='danger'>The core extractor is full, empty it first!</span>")
		return

	if(inuse)
		to_chat(user, "<span class='danger'>The core extractor is locked and running, wait for it to finish.</span>")
		return

	if(!(istype(victim, /mob/living/simple_mob/xeno/slime)))
		to_chat(user, "<span class='danger'>This is not a suitable subject for the core extractor!</span>")
		return

	var/mob/living/simple_mob/xeno/slime/S = victim
	if(S.is_child)
		to_chat(user, "<span class='danger'>This subject is not developed enough for the core extractor!</span>")
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
		set_light(2, 2, occupiedcolor)
	else if(src.occupant)
		set_light(2, 2, operatingcolor)
	else
		set_light(2, 2, emptycolor)

/obj/machinery/slime/extractor/proc/extract_cores()
	if(!src.occupant)
		src.visible_message("\icon[src][bicon(src)] [src] pings unhappily.")
	else if(inuse)
		return

	inuse = 1
	update_light_color()
	spawn(30)
		icon_state = "scanner_1old"
		for(var/i=1 to occupant.cores)
			var/obj/item/xenoproduct/slime/core/C = new(src)
			C.traits = new()
			occupant.traitdat.copy_traits(C.traits)

			C.nameVar = occupant.nameVar

			C.create_reagents(C.traits.traits[TRAIT_XENO_CHEMVOL])
			for(var/reagent in occupant.traitdat.chems)
				C.reagents.add_reagent(reagent, occupant.traitdat.chems[reagent])

			C.color = C.traits.traits[TRAIT_XENO_COLOR]
			if(occupant.traitdat.get_trait(TRAIT_XENO_BIOLUMESCENT))
				C.set_light(occupant.traitdat.get_trait(TRAIT_XENO_GLOW_STRENGTH),occupant.traitdat.get_trait(TRAIT_XENO_GLOW_RANGE), occupant.traitdat.get_trait(TRAIT_XENO_BIO_COLOR))

		spawn(30)
			icon_state = "scanner_0old"
			qdel(occupant)
			occupant = null	//If qdel's being slow or acting up, let's make sure we can't make more cores from this one.
			inuse = 0
			eject_contents()
			update_light_color()
			src.updateUsrDialog()

/obj/machinery/slime/extractor/proc/eject_slime()
	if(occupant)
		occupant.forceMove(loc)
		occupant = null

/obj/machinery/slime/extractor/proc/eject_core()
	for(var/obj/thing in (contents - component_parts - circuit))
		thing.forceMove(loc)

/obj/machinery/slime/extractor/proc/eject_contents()
	eject_core()
	eject_slime()

//Here lies the UI
/obj/machinery/slime/extractor/attack_hand(mob/user as mob)
	user.set_machine(src)
	interact(user)

/obj/machinery/slime/extractor/interact(mob/user as mob)
	var/dat = ""
	if(!inuse)
		dat = {"
	<b>Slime held:</b><br>
	[occupant]<br>
	"}
		if (occupant && !(stat & (NOPOWER|BROKEN)))
			dat += "<A href='?src=\ref[src];action=extract'>Start the core extraction.</a><BR>"
		if(occupant)
			dat += "<A href='?src=\ref[src];action=eject'>Eject the slime</a><BR>"
	else
		dat += "Please wait..."
	var/datum/browser/popup = new(user, "Slime Extractor", "Slime Extractor", src)
	popup.set_content(dat)
	popup.open()
	return


/obj/machinery/slime/extractor/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	switch(href_list["action"])
		if ("extract")
			extract_cores()
		if("eject")
			eject_slime()
	src.updateUsrDialog()
	return

//Circuit board below,
/obj/item/circuitboard/slimeextractor
	name = T_BOARD("Slime extractor")
	build_path = "/obj/machinery/slime/extractor"
	board_type = "machine"
	origin_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	req_components = list(
							/obj/item/stock_parts/manipulator = 2,
							/obj/item/stock_parts/matter_bin = 1,
							/obj/item/stock_parts/micro_laser = 2
							)
