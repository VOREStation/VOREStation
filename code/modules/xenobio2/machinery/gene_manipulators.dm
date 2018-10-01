/*
	This file contains:

	Xenobiological disk:
	Holds traits that can be taken from cores and transplanted into slimes.

	Biological Product Destructive Analyzer:
	Takes certain traits in gene grouping from a core and places them into a disk.

	Biological genetic bombarder:
	Takes traits from a disk and replaces/adds to the genes in a xenobiological creature.
*/
/obj/item/weapon/disk/xenobio
	name = "biological data disk"
	desc = "A small disk used for carrying data on genetics."
	icon = 'icons/obj/hydroponics_machines.dmi'
	icon_state = "disk"
	w_class = ITEMSIZE_TINY

	var/list/genes = list()
	var/genesource = "unknown"

/obj/item/weapon/disk/xenobio/attack_self(var/mob/user as mob)
	if(genes.len)
		var/choice = alert(user, "Are you sure you want to wipe the disk?", "Xenobiological Data", "No", "Yes")
		if(src && user && genes && choice && choice == "Yes" && user.Adjacent(get_turf(src)))
			to_chat(user, "You wipe the disk data.")
			name = initial(name)
			desc = initial(name)
			genes = list()
			genesource = "unknown"

/obj/item/weapon/storage/box/xenobiodisk
	name = "biological disk box"
	desc = "A box of biological data disks, apparently."

/obj/item/weapon/storage/box/xenobiodisk/New()
	..()
	for(var/i = 0 to 7)
		new /obj/item/weapon/disk/xenobio(src)

/obj/machinery/xenobio
	density = 1
	anchored = 1
	use_power = 1

	var/obj/item/weapon/disk/xenobio/loaded_disk //Currently loaded data disk.

	var/open = 0
	var/active = 0
	var/action_time = 5
	var/last_action = 0
	var/eject_disk = 0
	var/failed_task = 0
	var/disk_needs_genes = 0

/obj/machinery/xenobio/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/xenobio/attack_hand(mob/user as mob)
	ui_interact(user)

/obj/machinery/xenobio/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return
	if(istype(W,/obj/item/weapon/disk/xenobio))
		if(loaded_disk)
			to_chat(user, "There is already a data disk loaded.")
			return
		else
			var/obj/item/weapon/disk/xenobio/B = W

			if(B.genes && B.genes.len)
				if(!disk_needs_genes)
					to_chat(user, "That disk already has gene data loaded.")
					return
			else
				if(disk_needs_genes)
					to_chat(user, "That disk does not have any gene data loaded.")
					return

			user.drop_from_inventory(W)
			W.forceMove(src)
			loaded_disk = W
			to_chat(user, "You load [W] into [src].")

		return
	..()

/obj/machinery/xenobio/process()

	..()
	if(!active) return

	if(world.time > last_action + action_time)
		finished_task()

/obj/machinery/xenobio/proc/finished_task()
	active = 0
	in_use = 0
	if(failed_task)
		failed_task = 0
		visible_message("\icon[src] [src] pings unhappily, flashing a red warning light.")
	else
		visible_message("\icon[src] [src] pings happily.")

	if(eject_disk)
		eject_disk = 0
		if(loaded_disk)
			loaded_disk.forceMove(get_turf(src))
			visible_message("\icon[src] [src] beeps and spits out [loaded_disk].")
			loaded_disk = null

/obj/machinery/xenobio/extractor
	name = "biological product destructive analyzer"
	icon = 'icons/obj/hydroponics_machines.dmi'
	icon_state = "traitcopier"
	circuit = /obj/item/weapon/circuitboard/bioproddestanalyzer

	var/obj/item/xenoproduct/product
	var/datum/xeno/traits/genetics // Currently scanned xeno genetic structure.
	var/degradation = 0     // Increments with each scan, stops allowing gene mods after a certain point.

/obj/machinery/xenobio/extractor/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/scanning_module(src)
	component_parts += new /obj/item/weapon/stock_parts/scanning_module(src)
	component_parts += new /obj/item/weapon/stock_parts/scanning_module(src)
	RefreshParts()

/obj/machinery/xenobio/extractor/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/xenoproduct))
		if(product)
			to_chat(user, "There is already a xenobiological product loaded.")
			return
		else
			var/obj/item/xenoproduct/B = W
			user.drop_from_inventory(B)
			B.forceMove(src)
			product = B
			to_chat(user, "You load [B] into [src].")

		return
	..()

/obj/machinery/xenobio/extractor/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(!user)
		return

	var/list/data = list()

	var/list/geneMasks[0]
	for(var/gene_tag in xenobio_controller.gene_tag_masks)
		geneMasks.Add(list(list("tag" = gene_tag, "mask" = xenobio_controller.gene_tag_masks[gene_tag])))
	data["geneMasks"] = geneMasks

	data["activity"] = active
	data["degradation"] = degradation

	if(loaded_disk)
		data["disk"] = 1
	else
		data["disk"] = 0

	if(product)
		data["loaded"] = "[product.source] [product.product]"
	else
		data["loaded"] = 0

	if(genetics)
		data["hasGenetics"] = 1
		data["sourceName"] = genetics.source
	else
		data["hasGenetics"] = 0
		data["sourceName"] = 0

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "xenobio_isolator.tmpl", "B.P.D. Analyzer UI", 470, 450)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/xenobio/proc/eject_disk()
	if(!loaded_disk) return
	loaded_disk.forceMove(loc)
	visible_message("\icon[src] [src] beeps and spits out [loaded_disk].")
	loaded_disk = null

/obj/machinery/xenobio/extractor/Topic(href, href_list)

	if(..())
		return 1

	if(href_list["eject_product"])
		if(!product) return

		product.forceMove(get_turf(src))
		visible_message("\icon[src] [src] beeps and spits out [product].")
		product = null

	if(href_list["eject_disk"])
		eject_disk()

	if(href_list["scan_genome"])

		if(!product) return

		last_action = world.time
		active = 1

		if(product && product.product)
			genetics = product.traits
			degradation = 0

		qdel(product)
		product = null

	if(href_list["get_gene"])

		if(!genetics || !loaded_disk) return

		last_action = world.time
		active = 1

		var/datum/xeno/genes/G = genetics.get_gene(href_list["get_gene"])
		if(!G) return
		loaded_disk.genes += G

		loaded_disk.genesource = "[genetics.source]"

		loaded_disk.name += " ([xenobio_controller.gene_tag_masks[href_list["get_gene"]]], [genetics.source])"
		loaded_disk.desc += " The label reads \'gene [xenobio_controller.gene_tag_masks[href_list["get_gene"]]], sampled from [genetics.source]\'."
		eject_disk = 1

		degradation += rand(20,60)
		if(degradation >= 100)
			failed_task = 1
			genetics = null
			degradation = 0

	if(href_list["clear_buffer"])
		if(!genetics) return
		genetics = null
		degradation = 0

	usr.set_machine(src)
	src.add_fingerprint(usr)

	src.updateUsrDialog()
	return

/obj/machinery/xenobio/editor
	name = "biological genetic bombarder"
	icon = 'icons/obj/cryogenics.dmi'
	icon_state = "cellold0"
	disk_needs_genes = 1
	circuit = /obj/item/weapon/circuitboard/biobombarder

	var/mob/living/simple_animal/xeno/slime/occupant

/obj/machinery/xenobio/editor/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/scanning_module(src)
	component_parts += new /obj/item/weapon/stock_parts/scanning_module(src)
	RefreshParts()

/obj/machinery/xenobio/editor/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = W
		if(occupant)
			to_chat(user, "There is already an organism loaded.")
			return
		else
			if(isxeno(G.affecting))
				var/mob/living/simple_animal/xeno/X = G.affecting
				if(do_after(user, 30) && X.Adjacent(src) && user.Adjacent(src) && X.Adjacent(user) && !occupant)
					user.drop_from_inventory(G)
					X.forceMove(src)
					occupant = X
					to_chat(user, "You load [X] into [src]."
			else
				to_chat(user, "<span class='danger'>This specimen is incompatible with the machinery!</span>")
		return
	..()


/obj/machinery/xenobio/editor/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)

	if(!user)
		return

	var/list/data = list()

	data["activity"] = active

	if(occupant)
		data["degradation"] = occupant.stability
	else
		data["degradation"] = 0

	if(loaded_disk && loaded_disk.genes.len)
		data["disk"] = 1
		data["sourceName"] = loaded_disk.genesource
		data["locus"] = ""

		for(var/datum/xeno/genes/X in loaded_disk.genes)
			if(data["locus"] != "") data["locus"] += ", "
			data["locus"] += "[xenobio_controller.gene_tag_masks[X.genetype]]"

	else
		data["disk"] = 0
		data["sourceName"] = 0
		data["locus"] = 0

	if(occupant)
		data["loaded"] = "[occupant]"
	else
		data["loaded"] = 0

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "xenobio_editor.tmpl", "biological genetic bombarder UI", 470, 450)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/xenobio/editor/Topic(href, href_list)

	if(..())
		return 1

	if(href_list["apply_gene"])
		if(!loaded_disk || !occupant) return

		last_action = world.time
		active = 1
		occupant.nameVar = "modified"

		if(prob(occupant.stability))
			failed_task = 1
			occupant.stability = 101

		for(var/datum/xeno/genes/gene in loaded_disk.genes)
			occupant.traitdat.apply_gene(gene)
			occupant.stability += rand(5,10)
			occupant.ProcessTraits()

	if(href_list["eject_disk"])
		eject_disk()

	if(href_list["eject_xeno"])
		eject_xeno()

	usr.set_machine(src)
	src.add_fingerprint(usr)

/obj/machinery/xenobio/editor/MouseDrop_T(mob/target, mob/user)
	if(user.stat || user.restrained())
		return
	move_into_editor(user,target)

/obj/machinery/xenobio/editor/proc/move_into_editor(var/mob/user,var/mob/living/victim)

	if(src.occupant)
		to_chat(user, "<span class='danger'>The [src] is full, empty it first!</span>")
		return

	if(in_use)
		to_chat(user, "<span class='danger'>The [src] is locked and running, wait for it to finish.</span>")
		return

	if(!(istype(victim, /mob/living/simple_animal/xeno/slime)) )
		to_chat(user, "<span class='danger'>This is not a suitable subject for the [src]!</span>")
		return

	user.visible_message("<span class='danger'>[user] starts to put [victim] into the [src]!</span>")
	src.add_fingerprint(user)
	if(do_after(user, 30) && victim.Adjacent(src) && user.Adjacent(src) && victim.Adjacent(user) && !occupant)
		user.visible_message("<span class='danger'>[user] stuffs [victim] into the [src]!</span>")
		if(victim.client)
			victim.client.perspective = EYE_PERSPECTIVE
			victim.client.eye = src
		victim.forceMove(src)
		occupant = victim

/obj/machinery/xenobio/editor/proc/eject_contents()
	eject_disk()
	eject_xeno()

/obj/machinery/xenobio/editor/proc/eject_xeno()
	if(occupant)
		occupant.forceMove(loc)
		occupant = null

/obj/item/weapon/circuitboard/bioproddestanalyzer
	name = T_BOARD("biological product destructive analyzer")
	build_path = "/obj/machinery/xenobio/extractor"
	board_type = "machine"
	origin_tech = list(TECH_DATA = 4, TECH_BIO = 4)
	req_components = list(
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/weapon/stock_parts/matter_bin = 1,
							/obj/item/weapon/stock_parts/scanning_module = 3
							)

/obj/item/weapon/circuitboard/biobombarder
	name = T_BOARD("biological genetic bombarder")
	build_path = "/obj/machinery/xenobio/editor"
	board_type = "machine"
	origin_tech = list(TECH_DATA = 4, TECH_BIO = 4)
	req_components = list(
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/weapon/stock_parts/matter_bin = 2,
							/obj/item/weapon/stock_parts/scanning_module = 2
							)
