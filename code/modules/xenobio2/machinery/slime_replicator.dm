/*
	Here lives the slime replicator
	This machine consumes cores to create a slime.
	To create more of these cores, stick the slime core in the extractor.
*/
/obj/machinery/slime/replicator
	name = "slime core growth apparatus"
	desc = "A machine for creating slimes from cores. Amazing!"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "restruct_0"
	density = TRUE
	anchored = TRUE
	circuit = /obj/item/weapon/circuitboard/slimereplicator
	var/obj/item/xenoproduct/slime/core/core = null
	var/inuse
	var/occupiedcolor = "#22FF22"
	var/emptycolor = "#FF2222"
	var/operatingcolor = "#FFFF22"

/obj/machinery/slime/replicator/Initialize()
	. = ..()
	default_apply_parts()
	update_light_color()

/obj/machinery/slime/replicator/attackby(var/obj/item/W, var/mob/user)
	//Let's try to deconstruct first.
	if(W.is_screwdriver() && !inuse)
		default_deconstruction_screwdriver(user, W)
		return

	if(W.is_crowbar())
		default_deconstruction_crowbar(user, W)
		return

	var/obj/item/xenoproduct/slime/core/G = W

	if(!istype(G))
		return ..()

	if(core)
		to_chat(user, "<span class='warning'>[src] is already filled!</span>")
		return
	if(panel_open)
		to_chat(user, "<span class='warning'>Close the panel first!</span>")
	core = G
	user.drop_from_inventory(G)
	G.forceMove(src)
	update_light_color()

/obj/machinery/slime/replicator/proc/update_light_color()
	if(src.core && !(inuse))
		set_light(2, 2, occupiedcolor)
	else if(src.core)
		set_light(2, 2, operatingcolor)
	else
		set_light(2, 2, emptycolor)

/obj/machinery/slime/replicator/proc/replicate_slime()
	if(!src.core)
		src.visible_message("[bicon(src)] [src] pings unhappily.")
	else if(inuse)
		return

	inuse = 1
	update_light_color()
	icon_state = "restruct_1"
	spawn(30)
		var/mob/living/simple_mob/xeno/slime/S = new(src)
		S.traitdat = new()	//New instance, so that if the core is deleted, the slime retains a trait datum.
		S.nameVar = core.nameVar
		S.name = "[S.nameVar] baby slime"
		core.traits.copy_traits(S.traitdat)
		S.ProcessTraits()
		spawn(30)
			qdel(core)
			core = null	//If qdel's being a bit slow or acting up, let's just make sure we can't clone the core.
			inuse = 0
			eject_slime()
			icon_state = "restruct_0"
			update_light_color()
			src.updateUsrDialog()

/obj/machinery/slime/replicator/proc/eject_slime()
	for(var/mob/thing in contents)
		thing.forceMove(loc)

/obj/machinery/slime/replicator/proc/eject_core()
	if(core)
		core.forceMove(loc)
		core = null

/obj/machinery/slime/replicator/proc/eject_contents()
	eject_slime()
	eject_core()

//Here lies the UI
/obj/machinery/slime/replicator/attack_hand(mob/user as mob)
	user.set_machine(src)
	interact(user)

/obj/machinery/slime/replicator/interact(mob/user as mob)
	var/dat = ""
	if(!inuse)
		dat = {"
	<b>Slime core container holds:</b><br>
	[core]<br>
	"}
		if (core && !(stat & (NOPOWER|BROKEN)))
			dat += "<A href='?src=\ref[src];action=replicate'>Start the replication process</a><BR>"
		if(core)
			dat += "<A href='?src=\ref[src];action=eject'>Eject the core</a><BR>"
	else
		dat += "Please wait..."
	var/datum/browser/popup = new(user, "Slime Replicator", "Slime Replicator", src)
	popup.set_content(dat)
	popup.open()
	return


/obj/machinery/slime/replicator/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	switch(href_list["action"])
		if ("replicate")
			replicate_slime()
		if("eject")
			eject_core()
	src.updateUsrDialog()
	return

//Circuit board below,
/obj/item/weapon/circuitboard/slimereplicator
	name = T_BOARD("Slime replicator")
	build_path = "/obj/machinery/slime/replicator"
	board_type = "machine"
	origin_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	req_components = list(
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/weapon/stock_parts/matter_bin = 1,
							/obj/item/weapon/stock_parts/micro_laser = 1
							)

