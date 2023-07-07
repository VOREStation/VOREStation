/obj/item/weapon/disk/botany
	name = "flora data disk"
	desc = "A small disk used for carrying data on plant genetics."
	icon = 'icons/obj/hydroponics_machines.dmi'
	icon_state = "disk"
	w_class = ITEMSIZE_TINY

	var/list/genes = list()
	var/genesource = "unknown"

/obj/item/weapon/disk/botany/New()
	..()
	pixel_x = rand(-5,5)
	pixel_y = rand(-5,5)

/obj/item/weapon/disk/botany/attack_self(var/mob/user as mob)
	if(genes.len)
		var/choice = tgui_alert(user, "Are you sure you want to wipe the disk?", "Xenobotany Data", list("No", "Yes"))
		if(src && user && genes && choice && choice == "Yes" && user.Adjacent(get_turf(src)))
			to_chat(user, "<span class='filter_notice'>You wipe the disk data.</span>")
			name = initial(name)
			desc = initial(name)
			genes = list()
			genesource = "unknown"

/obj/item/weapon/storage/box/botanydisk
	name = "flora disk box"
	desc = "A box of flora data disks, apparently."

/obj/item/weapon/storage/box/botanydisk/New()
	..()
	for(var/i = 0;i<7;i++)
		new /obj/item/weapon/disk/botany(src)

/obj/machinery/botany
	icon = 'icons/obj/hydroponics_machines_vr.dmi' //VOREStation Edit
	icon_state = "hydrotray3"
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE

	var/obj/item/seeds/seed // Currently loaded seed packet.
	var/obj/item/weapon/disk/botany/loaded_disk //Currently loaded data disk.

	var/open = 0
	var/active = 0
	var/action_time = 5
	var/last_action = 0
	var/eject_disk = 0
	var/failed_task = 0
	var/disk_needs_genes = 0

/obj/machinery/botany/process()

	..()
	if(!active) return

	if(world.time > last_action + action_time)
		finished_task()

/obj/machinery/botany/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/botany/attack_hand(mob/user as mob)
	tgui_interact(user)

/obj/machinery/botany/proc/finished_task()
	active = 0
	if(failed_task)
		failed_task = 0
		visible_message("<span class='filter_notice'>\icon[src][bicon(src)] [src] pings unhappily, flashing a red warning light.</span>")
	else
		visible_message("<span class='filter_notice'>\icon[src][bicon(src)] [src] pings happily.</span>")

	if(eject_disk)
		eject_disk = 0
		if(loaded_disk)
			loaded_disk.loc = get_turf(src)
			visible_message("<span class='filter_notice'>\icon[src][bicon(src)] [src] beeps and spits out [loaded_disk].</span>")
			loaded_disk = null

/obj/machinery/botany/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/seeds))
		if(seed)
			to_chat(user, "<span class='filter_notice'>There is already a seed loaded.</span>")
			return
		var/obj/item/seeds/S =W
		if(S.seed && S.seed.get_trait(TRAIT_IMMUTABLE) > 0)
			to_chat(user, "<span class='filter_notice'>That seed is not compatible with our genetics technology.</span>")
		else
			user.drop_from_inventory(W)
			W.loc = src
			seed = W
			to_chat(user, "<span class='filter_notice'>You load [W] into [src].</span>")
		return

	if(default_deconstruction_screwdriver(user, W))
		return
	if(W.is_wrench())
		playsound(src, W.usesound, 100, 1)
		to_chat(user, "<span class='notice'>You [anchored ? "un" : ""]secure \the [src].</span>")
		anchored = !anchored
		return
//	if(default_deconstruction_crowbar(user, W))	//No circuit boards to give.
//		return
	if(istype(W,/obj/item/weapon/disk/botany))
		if(loaded_disk)
			to_chat(user, "<span class='filter_notice'>There is already a data disk loaded.</span>")
			return
		else
			var/obj/item/weapon/disk/botany/B = W

			if(B.genes && B.genes.len)
				if(!disk_needs_genes)
					to_chat(user, "<span class='filter_notice'>That disk already has gene data loaded.</span>")
					return
			else
				if(disk_needs_genes)
					to_chat(user, "<span class='filter_notice'>That disk does not have any gene data loaded.</span>")
					return

			user.drop_from_inventory(W)
			W.loc = src
			loaded_disk = W
			to_chat(user, "<span class='filter_notice'>You load [W] into [src].</span>")

		return
	..()

// Allows for a trait to be extracted from a seed packet, destroying that seed.
/obj/machinery/botany/extractor
	name = "lysis-isolation centrifuge"
	icon_state = "traitcopier"

	var/datum/seed/genetics // Currently scanned seed genetic structure.
	var/degradation = 0     // Increments with each scan, stops allowing gene mods after a certain point.

/obj/machinery/botany/extractor/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BotanyIsolator", name)
		ui.open()

/obj/machinery/botany/extractor/tgui_data(mob/user)
	var/list/data = ..()

	var/list/geneMasks = SSplants.gene_masked_list
	data["geneMasks"] = geneMasks

	data["activity"] = active
	data["degradation"] = degradation

	if(loaded_disk)
		data["disk"] = 1
	else
		data["disk"] = 0

	if(seed)
		data["loaded"] = "[seed.name]"
	else
		data["loaded"] = 0

	if(genetics)
		data["hasGenetics"] = 1
		data["sourceName"] = genetics.display_name
		if(!genetics.roundstart)
			data["sourceName"] += " (variety #[genetics.uid])"
	else
		data["hasGenetics"] = 0
		data["sourceName"] = 0

	return data

/obj/machinery/botany/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	usr.set_machine(src)
	add_fingerprint(usr)

	switch(action)
		if("eject_packet")
			if(!seed)
				return
			seed.forceMove(get_turf(src))

			if(seed.seed.name == "new line" || isnull(SSplants.seeds[seed.seed.name]))
				seed.seed.uid = SSplants.seeds.len + 1
				seed.seed.name = "[seed.seed.uid]"
				SSplants.seeds[seed.seed.name] = seed.seed

			seed.update_seed()
			visible_message("\icon[src][bicon(src)] [src] beeps and spits out [seed].")

			seed = null
			return TRUE

		if("eject_disk")
			if(!loaded_disk)
				return
			loaded_disk.forceMove(get_turf(src))
			visible_message("\icon[src][bicon(src)] [src] beeps and spits out [loaded_disk].")
			loaded_disk = null
			return TRUE

/obj/machinery/botany/extractor/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("scan_genome")
			if(!seed)
				return

			last_action = world.time
			active = 1

			if(seed && seed.seed)
				genetics = seed.seed
				degradation = 0

			qdel(seed)
			seed = null
			return TRUE

		if("get_gene")
			if(!genetics || !loaded_disk)
				return

			last_action = world.time
			active = 1

			var/datum/plantgene/P = genetics.get_gene(params["get_gene"])
			if(!P)
				return
			loaded_disk.genes += P

			loaded_disk.genesource = "[genetics.display_name]"
			if(!genetics.roundstart)
				loaded_disk.genesource += " (variety #[genetics.uid])"

			loaded_disk.name += " ([SSplants.gene_tag_masks[params["get_gene"]]], #[genetics.uid])"
			loaded_disk.desc += " The label reads \'gene [SSplants.gene_tag_masks[params["get_gene"]]], sampled from [genetics.display_name]\'."
			eject_disk = 1

			degradation += rand(20,60)
			if(degradation >= 100)
				failed_task = 1
				genetics = null
				degradation = 0
			return TRUE

		if("clear_buffer")
			if(!genetics)
				return
			genetics = null
			degradation = 0
			return TRUE

// Fires an extracted trait into another packet of seeds with a chance
// of destroying it based on the size/complexity of the plasmid.
/obj/machinery/botany/editor
	name = "bioballistic delivery system"
	icon_state = "traitgun"
	disk_needs_genes = 1

/obj/machinery/botany/editor/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BotanyEditor", name)
		ui.open()

/obj/machinery/botany/editor/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	data["activity"] = active

	if(seed)
		data["degradation"] = seed.modified
	else
		data["degradation"] = 0

	if(loaded_disk && loaded_disk.genes.len)
		data["disk"] = 1
		data["sourceName"] = loaded_disk.genesource
		data["locus"] = ""

		for(var/datum/plantgene/P in loaded_disk.genes)
			if(data["locus"] != "") data["locus"] += ", "
			data["locus"] += "[SSplants.gene_tag_masks[P.genetype]]"

	else
		data["disk"] = 0
		data["sourceName"] = 0
		data["locus"] = 0

	if(seed)
		data["loaded"] = "[seed.name]"
	else
		data["loaded"] = 0

	return data

/obj/machinery/botany/editor/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("apply_gene")
			if(!loaded_disk || !seed)
				return

			last_action = world.time
			active = 1

			if(!isnull(SSplants.seeds[seed.seed.name]))
				seed.seed = seed.seed.diverge(1)
				seed.seed_type = seed.seed.name
				seed.update_seed()

			if(prob(seed.modified))
				failed_task = 1
				seed.modified = 101

			for(var/datum/plantgene/gene in loaded_disk.genes)
				seed.seed.apply_gene(gene)
				seed.modified += rand(5,10)
			return TRUE
