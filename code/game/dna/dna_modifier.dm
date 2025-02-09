#define DNA_BLOCK_SIZE 3

#define PAGE_SE "se"
#define PAGE_BUFFER "buffer"
#define PAGE_REJUVENATORS "rejuvenators"

//list("data" = null, "owner" = null, "label" = null, "type" = null, "ue" = 0),
/datum/dna2/record
	var/datum/dna/dna = null
	var/types=0
	var/name="Empty"

	// Stuff for cloners
	var/id=null
	var/implant=null
	var/ckey=null
	var/mind=null
	var/languages=null
	var/list/flavor=null
	var/gender = null
	var/list/body_descriptors = null // Guess we'll keep null.
	var/list/genetic_modifiers = list() // Modifiers with the MODIFIER_GENETIC flag are saved.  Note that only the type is saved, not an instance.

/datum/dna2/record/proc/GetData()
	var/list/ser=list("data" = null, "owner" = null, "label" = null, "type" = null, "ue" = 0)
	if(dna)
		ser["ue"] = (types & DNA2_BUF_UE) == DNA2_BUF_UE
		if(types & DNA2_BUF_SE)
			ser["data"] = dna.SE
		else
			ser["data"] = dna.UI
		ser["owner"] = src.dna.real_name
		ser["label"] = name
		if(types & DNA2_BUF_UI)
			ser["type"] = "ui"
		else
			ser["type"] = "se"
	return ser

/datum/dna2/record/proc/copy()
	var/datum/dna2/record/newrecord = new /datum/dna2/record
	qdel_swap(newrecord.dna, dna.Clone())
	newrecord.types = types
	newrecord.name = name
	newrecord.mind = mind
	newrecord.ckey = ckey
	newrecord.languages = languages
	newrecord.implant = implant
	newrecord.flavor = flavor
	newrecord.gender = gender
	if(body_descriptors)
		newrecord.body_descriptors = body_descriptors.Copy()
	newrecord.genetic_modifiers = genetic_modifiers.Copy()
	return newrecord


/////////////////////////// DNA MACHINES
/obj/machinery/dna_scannernew
	name = "\improper DNA modifier"
	desc = "It scans DNA structures."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "scanner_0"
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 50
	active_power_usage = 300
	interact_offline = 1
	circuit = /obj/item/circuitboard/clonescanner
	var/locked = 0
	var/datum/weakref/occupant = null
	var/obj/item/reagent_containers/glass/beaker = null
	var/opened = 0
	var/damage_coeff
	var/scan_level
	var/precision_coeff

/obj/machinery/dna_scannernew/Initialize()
	. = ..()
	default_apply_parts()
	RefreshParts()

/obj/machinery/dna_scannernew/Destroy()
	eject_occupant()
	. = ..()

/obj/machinery/dna_scannernew/RefreshParts()
	scan_level = 0
	damage_coeff = 0
	precision_coeff = 0
	for(var/obj/item/stock_parts/scanning_module/P in component_parts)
		scan_level += P.rating
	for(var/obj/item/stock_parts/manipulator/P in component_parts)
		precision_coeff = P.rating
	for(var/obj/item/stock_parts/micro_laser/P in component_parts)
		damage_coeff = P.rating

/obj/machinery/dna_scannernew/relaymove(mob/user as mob)
	if(user.stat)
		return
	src.go_out()
	return

/obj/machinery/dna_scannernew/verb/eject()
	set src in oview(1)
	set category = "Object"
	set name = "Eject DNA Scanner"

	if(usr.stat != 0)
		return

	eject_occupant()

	add_fingerprint(usr)
	return

/obj/machinery/dna_scannernew/proc/eject_occupant()
	var/mob/living/carbon/WC = occupant.resolve()
	go_out()
	for(var/obj/O in src)
		if((!istype(O,/obj/item/reagent_containers)) && (!istype(O,/obj/item/circuitboard/clonescanner)) && (!istype(O,/obj/item/stock_parts)) && (!istype(O,/obj/item/stack/cable_coil)))
			O.forceMove(get_turf(src)) //Ejects items that manage to get in there (exluding the components)
	if(!WC)
		for(var/mob/M in src)//Failsafe so you can get mobs out
			M.forceMove(get_turf(src))

/obj/machinery/dna_scannernew/MouseDrop_T(var/mob/target, var/mob/user) //Allows borgs to clone people without external assistance
	var/mob/living/carbon/WC = occupant?.resolve()
	if(user.stat || user.lying || !Adjacent(user) || !target.Adjacent(user)|| !ishuman(target) || WC)
		return
	// Traitgenes Do not allow buckled or ridden mobs
	if(target.buckled)
		return
	if(target.has_buckled_mobs())
		to_chat(user, span_warning("\The [target] has other entities attached to it. Remove them first."))
		return
	put_in(target)

/obj/machinery/dna_scannernew/verb/move_inside()
	set src in oview(1)
	set category = "Object"
	set name = "Enter DNA Scanner"


	if(usr.stat != 0)
		return
	if(!ishuman(usr) && !issmall(usr)) //Make sure they're a mob that has dna
		to_chat(usr, span_notice("Try as you might, you can not climb up into the scanner."))
		return
	if(occupant)
		to_chat(usr, span_warning("The scanner is already occupied!"))
		return
	if(usr.abiotic())
		to_chat(usr, span_warning("The subject cannot have abiotic items on."))
		return
	var/mob/living/carbon/WC = occupant?.resolve()
	if(WC)
		to_chat(usr, span_warning("There is already something inside."))
		return
	usr.stop_pulling()
	usr.client.perspective = EYE_PERSPECTIVE
	usr.client.eye = src
	usr.forceMove(src)
	occupant = WEAKREF(usr)
	icon_state = "scanner_1"
	add_fingerprint(usr)
	SStgui.update_uis(src)

/obj/machinery/dna_scannernew/attackby(var/obj/item/item as obj, var/mob/user as mob)
	// Traitgenes Deconstructable dna scanner
	if(default_deconstruction_screwdriver(user, item))
		return
	if(default_deconstruction_crowbar(user, item))
		return
	if(istype(item, /obj/item/reagent_containers/glass))
		if(beaker)
			to_chat(user, span_warning("A beaker is already loaded into the machine."))
			return

		beaker = item
		user.drop_item()
		item.forceMove(src)
		user.visible_message("\The [user] adds \a [item] to \the [src]!", "You add \a [item] to \the [src]!")
		SStgui.update_uis(src)
		return

	else if(istype(item, /obj/item/organ/internal/brain))
		if(occupant)
			to_chat(user, span_warning("The scanner is already occupied!"))
			return
		var/obj/item/organ/internal/brain/brain = item
		if(brain.clone_source)
			user.drop_item()
			brain.forceMove(src)
			put_in(brain.brainmob)
			src.add_fingerprint(user)
			user.visible_message("\The [user] adds \a [item] to \the [src]!", "You add \a [item] to \the [src]!")
			SStgui.update_uis(src)
			return
		else
			to_chat(user, "\The [brain] is not acceptable for genetic sampling!")

	else if(!istype(item, /obj/item/grab))
		return
	var/obj/item/grab/G = item
	if(!ismob(G.affecting))
		return
	if(occupant)
		to_chat(user, span_warning("The scanner is already occupied!"))
		return
	if(G.affecting.abiotic())
		to_chat(user, span_warning("The subject cannot have abiotic items on."))
		return
	put_in(G.affecting)
	src.add_fingerprint(user)
	qdel(G)
	return

// Traitgenes Deconstructable dna scanner
/obj/machinery/dna_scannernew/dismantle()
	// release contents
	if(beaker)
		beaker.forceMove(get_turf(src))
		beaker = null
	if(occupant)
		var/mob/living/carbon/WC = occupant.resolve()
		WC.forceMove(get_turf(src))
		occupant = null
	// Disconnect from our terminal
	for(var/dirfind in cardinal)
		var/obj/machinery/computer/scan_consolenew/console = locate(/obj/machinery/computer/scan_consolenew, get_step(src, dirfind))
		if(console && console.connected == src)
			console.connected = null
			SStgui.close_uis(console)
			break
	. = ..()

/obj/machinery/dna_scannernew/proc/put_in(var/mob/M)
	if(M.client)
		M.client.perspective = EYE_PERSPECTIVE
		M.client.eye = src
	M.forceMove(src)
	occupant = WEAKREF(M)
	icon_state = "scanner_1"

	// search for ghosts, if the corpse is empty and the scanner is connected to a cloner
	if(locate(/obj/machinery/computer/cloning, get_step(src, NORTH)) \
		|| locate(/obj/machinery/computer/cloning, get_step(src, SOUTH)) \
		|| locate(/obj/machinery/computer/cloning, get_step(src, EAST)) \
		|| locate(/obj/machinery/computer/cloning, get_step(src, WEST)))

		if(!M.client && M.mind)
			for(var/mob/observer/dead/ghost in player_list)
				if(ghost.mind == M.mind)
					to_chat(ghost, span_interface(span_large(span_bold("Your corpse has been placed into a cloning scanner. Return to your body if you want to be resurrected/cloned!") + " (Verbs -> Ghost -> Re-enter corpse)")))
					break
	SStgui.update_uis(src)

/obj/machinery/dna_scannernew/proc/go_out()
	if((!(occupant) || locked))
		return
	var/mob/living/carbon/WC = occupant.resolve()
	if(WC.client)
		WC.client.eye = WC.client.mob
		WC.client.perspective = MOB_PERSPECTIVE
	if(istype(WC,/mob/living/carbon/brain))
		for(var/obj/O in src)
			if(istype(O,/obj/item/organ/internal/brain))
				O.forceMove(get_turf(src))
				WC.forceMove(O)
				break
	else
		WC.forceMove(loc)
	occupant = null
	icon_state = "scanner_0"
	SStgui.update_uis(src)

/obj/machinery/dna_scannernew/ex_act(severity)
	var/our_tile = loc //This is done here as if you try to feed loc in the A.forcemove, it will runtime as src id qdel'd before they can be moved.
	switch(severity)
		if(1.0)
			for(var/atom/movable/A as mob|obj in src)
				A.forceMove(our_tile)
				ex_act(severity)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				for(var/atom/movable/A as mob|obj in src)
					A.forceMove(our_tile)
					ex_act(severity)
				qdel(src)
				return
		if(3.0)
			if(prob(25))
				for(var/atom/movable/A as mob|obj in src)
					A.forceMove(our_tile)
					ex_act(severity)
				qdel(src)
				return
		else
	return

/obj/machinery/computer/scan_consolenew
	name = "DNA Modifier Access Console"
	desc = "Scan DNA."
	icon_keyboard = "med_key"
	icon_screen = "dna"
	density = TRUE
	circuit = /obj/item/circuitboard/scan_consolenew
	var/selected_ui_block = 1.0
	var/selected_ui_subblock = 1.0
	var/selected_se_block = 1.0
	var/selected_se_subblock = 1.0
	var/selected_ui_target = 1
	var/selected_ui_target_hex = 1
	var/radiation_duration = 2.0
	var/radiation_intensity = 1.0
	var/list/datum/transhuman/body_record/buffers[3] // Traitgenes Use bodyrecords
	var/irradiating = 0
	var/injector_ready = 0	//Quick fix for issue 286 (screwdriver the screen twice to restore injector)	-Pete
	var/obj/machinery/dna_scannernew/connected = null
	// Traitgenes body record disks are used instead of a unique disk
	var/obj/item/disk/body_record/disk = null
	var/selected_menu_key = PAGE_SE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	active_power_usage = 400

/obj/machinery/computer/scan_consolenew/attackby(obj/item/I as obj, mob/user as mob)
	// Traitgenes body record disks are used instead of a unique disk
	if(istype(I, /obj/item/disk/body_record)) //INSERT SOME diskS
		if(connected)
			if(!disk)
				user.drop_item()
				I.forceMove(src)
				disk = I
				to_chat(user, "You insert [I].")
				SStgui.update_uis(src) // update all UIs attached to src
				return
		else
			to_chat(user, "\The [src] will not accept a disk without a DNA modifier connected.")
			return
	else
		..()
	return

/obj/machinery/computer/scan_consolenew/ex_act(severity)

	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				qdel(src)
				return
		else
	return

/obj/machinery/computer/scan_consolenew/Initialize()
	. = ..()
	for(var/i=0;i<3;i++)
		// Traitgenes Use bodyrecords
		var/datum/transhuman/body_record/R = new /datum/transhuman/body_record()
		R.mydna = new
		R.mydna.dna = new
		R.mydna.dna.ResetUI()
		R.mydna.dna.ResetSE()
		buffers[i+1]=R
	// Traitgenes don't alter direction of computer as this scans for neighbour
	for(var/dirfind in cardinal)
		connected = locate(/obj/machinery/dna_scannernew, get_step(src, dirfind))
		if(connected)
			break
	VARSET_IN(src, injector_ready, TRUE, 25 SECONDS)

/obj/machinery/computer/scan_consolenew/proc/all_dna_blocks(var/list/buffer)
	var/list/arr = list()
	for(var/i = 1, i <= buffer.len, i++)
		arr += "[i]:[EncodeDNABlock(buffer[i])]"
	return arr

/obj/machinery/computer/scan_consolenew/proc/setInjectorBlock(var/obj/item/dnainjector/I, var/blk, var/datum/transhuman/body_record/buffer) // Traitgenes Stores the entire body record
	var/pos = findtext(blk,":")
	if(!pos) return 0
	var/id = text2num(copytext(blk,1,pos))
	if(!id) return 0
	I.block = id
	I.buf = buffer
	return 1

/obj/machinery/computer/scan_consolenew/attack_ai(user as mob)
	src.add_hiddenprint(user)
	tgui_interact(user)

/obj/machinery/computer/scan_consolenew/attack_hand(user as mob)
	if(!..())
		tgui_interact(user)

/obj/machinery/computer/scan_consolenew/tgui_interact(mob/user, datum/tgui/ui)
	var/mob/living/carbon/WC = connected?.occupant?.resolve()
	if(!connected || user == WC || user.stat)
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DNAModifier", name)
		ui.open()

/obj/machinery/computer/scan_consolenew/tgui_data(mob/user)
	// this is the data which will be sent to the ui
	var/data[0]
	data["selectedMenuKey"] = selected_menu_key
	data["locked"] = src.connected.locked
	data["hasOccupant"] = connected.occupant ? 1 : 0

	data["isInjectorReady"] = injector_ready

	data["hasDisk"] = disk ? 1 : 0

	var/diskData[0]
	if(!disk || !disk.stored || !disk.stored.mydna) // Traitgenesbody record disks are used instead of a unique disk
		diskData["data"] = null
		diskData["owner"] = null
		diskData["label"] = null
		diskData["type"] = null
		diskData["ue"] = null
	else
		diskData = disk.stored.mydna.GetData() // Traitgenes body record disks are used instead of a unique disk
	data["disk"] = diskData

	// Traitgenes Fixed buffer menu
	var/list/new_buffers[src.buffers.len]
	for(var/i=1;i<=src.buffers.len;i++)
		var/datum/transhuman/body_record/R = buffers[i]
		if(R && R.mydna)
			new_buffers[i]=R.mydna.GetData()
		else
			new_buffers[i]=list("data" = list(), "owner" = null, "label" = null, "type" = DNA2_BUF_SE, "ue" = 0)
	data["buffers"]=new_buffers

	data["radiationIntensity"] = radiation_intensity
	data["radiationDuration"] = radiation_duration
	data["irradiating"] = irradiating

	data["dnaBlockSize"] = DNA_BLOCK_SIZE
	data["selectedUIBlock"] = selected_ui_block
	data["selectedUISubBlock"] = selected_ui_subblock
	data["selectedSEBlock"] = selected_se_block
	data["selectedSESubBlock"] = selected_se_subblock
	data["selectedUITarget"] = selected_ui_target
	data["selectedUITargetHex"] = selected_ui_target_hex

	var/occupantData[0]
	var/mob/living/carbon/WC = connected?.occupant?.resolve()
	if(!WC || !WC.dna)
		occupantData["name"] = null
		occupantData["stat"] = null
		occupantData["isViableSubject"] = null
		occupantData["health"] = null
		occupantData["maxHealth"] = null
		occupantData["minHealth"] = null
		occupantData["uniqueEnzymes"] = null
		occupantData["uniqueIdentity"] = null
		occupantData["structuralEnzymes"] = null
		occupantData["radiationLevel"] = null
	else
		occupantData["name"] = WC.real_name
		occupantData["stat"] = WC.stat
		occupantData["isViableSubject"] = 1
		// Traitgenes NO_SCAN and Synthetics cannot be mutated
		var/allowed = TRUE
		if(WC.isSynthetic())
			allowed = FALSE
		if(ishuman(WC))
			var/mob/living/carbon/human/H = WC
			if(!H.species || (H.species.flags & NO_SCAN))
				allowed = FALSE
		if(!allowed || (NOCLONE in WC.mutations) || !WC.dna)
			occupantData["isViableSubject"] = 0
		occupantData["health"] = WC.health
		occupantData["maxHealth"] = WC.maxHealth
		occupantData["minHealth"] = CONFIG_GET(number/health_threshold_dead)
		occupantData["uniqueEnzymes"] = WC.dna.unique_enzymes
		occupantData["uniqueIdentity"] = WC.dna.uni_identity
		occupantData["structuralEnzymes"] = WC.dna.struc_enzymes
		occupantData["radiationLevel"] = WC.radiation
	data["occupant"] = occupantData;

	data["isBeakerLoaded"] = connected.beaker ? 1 : 0
	data["beakerLabel"] = null
	data["beakerVolume"] = 0
	if(connected.beaker)
		data["beakerLabel"] = connected.beaker.label_text ? connected.beaker.label_text : null
		if(connected.beaker.reagents && connected.beaker.reagents.reagent_list.len)
			for(var/datum/reagent/R in connected.beaker.reagents.reagent_list)
				data["beakerVolume"] += R.volume

	// Transfer modal information if there is one
	data["modal"] = tgui_modal_data(src)

	return data

/obj/machinery/computer/scan_consolenew/tgui_act(action, params, datum/tgui/ui)
	if(..())
		return TRUE
	if(!istype(ui.user.loc, /turf))
		return TRUE
	if(!src || !connected)
		return TRUE
	if(irradiating) // Make sure that it isn't already irradiating someone...
		return TRUE

	add_fingerprint(ui.user)

	if(tgui_act_modal(action, params))
		return TRUE

	switch(action)
		if("selectMenuKey")
			playsound(src, 'sound/machines/button.ogg', 30, 1, 0)
			var/key = params["key"]
			if(!(key in list(/*PAGE_UI,*/ PAGE_SE, PAGE_BUFFER, PAGE_REJUVENATORS))) // Traitgenes Body design console is used to edit UIs now
				return TRUE
			selected_menu_key = key
			return TRUE
		if("toggleLock")
			playsound(src, 'sound/machines/button.ogg', 30, 1, 0)
			if(connected && connected.occupant)
				connected.locked = !(connected.locked)
			return TRUE

		if("pulseRadiation")
			playsound(src, 'sound/machines/button.ogg', 30, 1, 0)
			irradiating = radiation_duration
			var/lock_state = connected.locked
			connected.locked = TRUE //lock it
			addtimer(CALLBACK(src, PROC_REF(do_pulse), lock_state), radiation_duration SECONDS, TIMER_DELETE_ME)
			return TRUE
		if("radiationDuration")
			radiation_duration = clamp(text2num(params["value"]), 1, 20)
			return TRUE
		if("radiationIntensity")
			radiation_intensity = clamp(text2num(params["value"]), 1, 10)
			return TRUE
		if("injectRejuvenators")
			playsound(src, 'sound/machines/button.ogg', 30, 1, 0)
			if(!connected.occupant || !connected.beaker)
				return TRUE
			var/mob/living/carbon/WC = connected?.occupant?.resolve()
			var/inject_amount = clamp(round(text2num(params["amount"]), 5), 0, 50) // round to nearest 5 and clamp to 0-50
			if(!inject_amount)
				return TRUE
			connected.beaker.reagents.trans_to_mob(WC, inject_amount, CHEM_BLOOD)
			return TRUE
	////////////////////////////////////////////////////////
		if("selectSEBlock") // This chunk of code updates selected block / sub-block based on click (se stands for strutural enzymes)
			playsound(src, "keyboard", 40)
			var/select_block = text2num(params["block"])
			var/select_subblock = text2num(params["subblock"])
			if(!select_block || !select_subblock)
				return TRUE

			selected_se_block = clamp(select_block, 1, DNA_SE_LENGTH)
			selected_se_subblock = clamp(select_subblock, 1, DNA_BLOCK_SIZE)
			return TRUE
		if("pulseSERadiation")
			if(!connected?.occupant)
				return TRUE
			var/mob/living/carbon/WC = connected?.occupant?.resolve()
			playsound(src, "keyboard", 40)
			var/block = WC.dna.GetSESubBlock(selected_se_block,selected_se_subblock)
			//var/original_block=block
			//testing("Irradiating SE block [selected_se_block]:[selected_se_subblock] ([block])...")

			irradiating = radiation_duration
			var/lock_state = connected.locked
			connected.locked = TRUE //lock it

			//We call the do_irradiate proc here after radation_duration SECONDS
			addtimer(CALLBACK(src, PROC_REF(do_irradiate), lock_state, block), radiation_duration SECONDS, TIMER_DELETE_ME)
			return TRUE

		if("ejectBeaker")
			playsound(src, 'sound/machines/button.ogg', 30, 1, 0)
			if(connected.beaker)
				var/obj/item/reagent_containers/glass/B = connected.beaker
				B.forceMove(connected.loc)
				connected.beaker = null
			return TRUE
		if("ejectOccupant")
			playsound(src, 'sound/machines/button.ogg', 30, 1, 0)
			connected.eject_occupant()
			// Eject disk too, because we can't get to the UI otherwise
			if(!disk)
				return TRUE
			disk.forceMove(get_turf(src))
			disk = null
		// Transfer Buffer Management
		if("bufferOption")
			var/bufferOption = params["option"]
			var/bufferId = text2num(params["id"])
			if(bufferId < 1 || bufferId > 3) // Not a valid buffer id
				return TRUE

			var/datum/transhuman/body_record/buffer = buffers[bufferId] // Traitgenes Use bodyrecords
			switch(bufferOption)
				// Traitgenes Moved SE and UI saves to storing the entire body record
				if("saveDNA")
					playsound(src, "keyboard", 40) // into console
					var/mob/living/carbon/WC = connected?.occupant?.resolve()
					if(WC && WC.dna)
						// Traitgenes Properly clone records
						var/datum/transhuman/body_record/databuf = new /datum/transhuman/body_record()
						databuf.init_from_mob(WC)
						databuf.mydna.types = DNA2_BUF_SE // structurals only
						if(ishuman(WC))
							var/mob/living/carbon/human/H = WC
							databuf.mydna.dna.real_name = H.dna.real_name
							databuf.mydna.gender = H.gender
							databuf.mydna.body_descriptors = H.descriptors
						buffers[bufferId] = databuf
					return TRUE
				if("clear")
					playsound(src, "keyboard", 40)
					// Traitgenes Storing the entire body record
					var/datum/transhuman/body_record/R = new /datum/transhuman/body_record()
					R.mydna = new
					R.mydna.dna = new
					R.mydna.dna.ResetUI()
					R.mydna.dna.ResetSE()
					buffers[bufferId] = R
					return TRUE
				if("changeLabel")
					playsound(src, "keyboard", 40)
					tgui_modal_input(src, "changeBufferLabel", "Please enter the new buffer label:", null, list("id" = bufferId), buffer.mydna.name, TGUI_MODAL_INPUT_MAX_LENGTH_NAME)
					return TRUE
				if("transfer")
					var/mob/living/carbon/WC = connected?.occupant?.resolve()
					if(!WC || (NOCLONE in WC.mutations) || !WC.dna)
						return TRUE
					irradiating = 2
					var/lock_state = connected.locked
					connected.locked = 1//lock it
					addtimer(CALLBACK(src, PROC_REF(do_transfer), lock_state, bufferId), 2 SECONDS, TIMER_DELETE_ME)
					return TRUE
				if("createInjector")
					if(!injector_ready)
						return TRUE
					if(text2num(params["block"]) > 0)
						var/list/choices = all_dna_blocks(buffer.mydna.dna.SE) // Traitgenes Storing the entire body record, and no more using UIs
						tgui_modal_choice(src, "createInjectorBlock", "Please select the block to create an injector from:", null, list("id" = bufferId), null, choices)
					else
						create_injector(bufferId, TRUE)
					return TRUE
				// Traitgenes Storing the entire body record
				if("loadDisk")
					playsound(src, "keyboard", 40)
					if(isnull(disk) || !disk.stored)
						return
					// Traitgenes Properly clone records
					var/datum/transhuman/body_record/databuf = new /datum/transhuman/body_record()
					databuf.init_from_br(disk.stored)
					databuf.mydna.types = DNA2_BUF_SE // structurals only
					buffers[bufferId] = databuf
				if("saveDisk")
					playsound(src, "keyboard", 40)
					if(isnull(disk)) // Traitgenes Removed readonly
						return TRUE
					var/datum/transhuman/body_record/buf = buffers[bufferId]
					// Traitgenes Properly clone records
					disk.stored = new /datum/transhuman/body_record()
					disk.stored.init_from_br(buf)
					disk.stored.mydna.types = DNA2_BUF_UI|DNA2_BUF_UE|DNA2_BUF_SE // DNA disks need to maintain their data
					disk.name = "Body Design Disk ('[buf.mydna.name]')"
					return TRUE
				if("sleeveDisk")
					playsound(src, "keyboard", 40)
					var/datum/transhuman/body_record/buf = buffers[bufferId]
					// Send printable record to first sleevepod in area
					print_sleeve(usr, buf)
					return TRUE

		if("wipeDisk")
			playsound(src, "keyboard", 40)
			// Traitgenes Storing the entire body record
			if(isnull(disk))
				return TRUE
			disk.stored = null
			return TRUE
		if("ejectDisk")
			playsound(src, 'sound/machines/button.ogg', 30, 1, 0)
			if(!disk)
				return TRUE
			disk.forceMove(get_turf(src))
			disk = null
			return TRUE

/**
  * Creates a blank injector with the name of the buffer at the given buffer_id
  *
  * Arguments:
  * * buffer_id - The ID of the buffer
  * * copy_buffer - Whether the injector should copy the buffer contents
  */
/obj/machinery/computer/scan_consolenew/proc/create_injector(buffer_id, copy_buffer = FALSE)
	if(buffer_id < 1 || buffer_id > length(buffers))
		return

	// Cooldown
	injector_ready = FALSE
	addtimer(CALLBACK(src, PROC_REF(injector_cooldown_finish)), 30 SECONDS)

	// Create it
	var/datum/transhuman/body_record/buf = buffers[buffer_id] // Traitgenes Use bodyrecords
	var/obj/item/dnainjector/I = new()
	buf.mydna.types = DNA2_BUF_SE // Traitgenes SE only, use the designer for UI and UEs, super broken in this codebase due to years of no one respecting genetics...
	I.forceMove(loc)
	I.name += " ([buf.mydna.name])"
	if(copy_buffer)
		I.buf = buf.mydna.copy()
	return I

/**
  * Called when the injector creation cooldown finishes
  */
/obj/machinery/computer/scan_consolenew/proc/injector_cooldown_finish()
	injector_ready = TRUE

/**
  * Called in tgui_act() to process modal actions
  *
  * Arguments:
  * * action - The action passed by tgui
  * * params - The params passed by tgui
  */
/obj/machinery/computer/scan_consolenew/proc/tgui_act_modal(action, params)
	. = TRUE
	var/id = params["id"] // The modal's ID
	var/list/arguments = istext(params["arguments"]) ? json_decode(params["arguments"]) : params["arguments"]
	switch(tgui_modal_act(src, action, params))
		if(TGUI_MODAL_ANSWER)
			var/answer = params["answer"]
			switch(id)
				if("createInjectorBlock")
					var/buffer_id = text2num(arguments["id"])
					if(buffer_id < 1 || buffer_id > length(buffers))
						return
					var/datum/transhuman/body_record/buf = buffers[buffer_id] // Traitgenes Use bodyrecords
					var/obj/item/dnainjector/I = create_injector(buffer_id)
					setInjectorBlock(I, answer, buf.mydna.copy()) // Traitgenes Use bodyrecords
					I.name += " - Block [answer]" // Traitgenes By default show the block of a block injector
				if("changeBufferLabel")
					var/buffer_id = text2num(arguments["id"])
					if(buffer_id < 1 || buffer_id > length(buffers))
						return
					var/datum/transhuman/body_record/buf = buffers[buffer_id] // Traitgenes Use bodyrecords
					buf.mydna.name = answer // Traitgenes Use bodyrecords
					buffers[buffer_id] = buf
				else
					return FALSE
		else
			return FALSE


/**
  * Triggers sleeve growing in a clonepod within the area
  *
  * Arguments:
  * * active_br - Body record to print
  */
/obj/machinery/computer/scan_consolenew/proc/print_sleeve(var/mob/user, var/datum/transhuman/body_record/active_br)
	//deleted record
	if(!istype(active_br))
		to_chat(user, span_danger( "Error: Data corruption."))
		return
	//Trying to make an fbp
	if(active_br.synthetic )
		to_chat(user, span_danger( "Error: Cannot grow synthetic."))
		return
	//No pods
	var/obj/machinery/clonepod/transhuman/pod = locate() in get_area(src)
	if(!pod)
		to_chat(user, span_danger( "Error: No growpods detected."))
		return
	//Already doing someone.
	if(pod.occupant)
		to_chat(user, span_danger( "Error: Growpod is currently occupied."))
		return
	//Not enough materials.
	if(pod.get_biomass() < CLONE_BIOMASS)
		to_chat(user, span_danger( "Error: Not enough biomass."))
		return
	//Gross pod (broke mid-cloning or something).
	if(pod.mess)
		to_chat(user, span_danger( "Error: Growpod malfunction."))
		return
	//Disabled in config.
	if(!CONFIG_GET(flag/revival_cloning))
		to_chat(user, span_danger( "Error: Unable to initiate growing cycle."))
		return
	//Invalid genes!
	if(active_br.mydna.name == "Empty" || active_br.mydna.id == null)
		to_chat(user, span_danger( "Error: Data corruption."))
		return
	//Do the cloning!
	if(!pod.growclone(active_br))
		to_chat(user, span_danger( "Initiating growing cycle... Error: Post-initialisation failed. Growing cycle aborted."))
		return
	to_chat(user, span_notice( "Initiating growing cycle..."))

/obj/machinery/computer/scan_consolenew/proc/do_irradiate(var/lock_state, var/block)
	var/mob/living/carbon/WC = connected?.occupant?.resolve()
	irradiating = 0
	connected.locked = lock_state
	if(!WC)
		return

	if(prob((80 + (radiation_duration / 2))))
		// FIXME: Find out what these corresponded to and change them to the WHATEVERBLOCK they need to be.
		//if((selected_se_block != 2 || selected_se_block != 12 || selected_se_block != 8 || selected_se_block || 10) && prob (20))
		var/real_SE_block=selected_se_block
		block = miniscramble(block, radiation_intensity, radiation_duration)
		if(prob(20))
			if(selected_se_block > 1 && selected_se_block < DNA_SE_LENGTH/2)
				real_SE_block++
			else if(selected_se_block > DNA_SE_LENGTH/2 && selected_se_block < DNA_SE_LENGTH)
				real_SE_block--

		//testing("Irradiated SE block [real_SE_block]:[selected_se_subblock] ([original_block] now [block]) [(real_SE_block!=selected_se_block) ? "(SHIFTED)":""]!")
		WC.dna.SetSESubBlock(real_SE_block,selected_se_subblock,block)
		WC.apply_effect((radiation_intensity+radiation_duration), IRRADIATE, check_protection = 0)
	else
		WC.apply_effect(((radiation_intensity*2)+radiation_duration), IRRADIATE, check_protection = 0)
		if	(prob(80-radiation_duration))
			//testing("Random bad mut!")
			randmutb(WC)
	// Traitgenes Do gene updates here, and more comprehensively
	if(ishuman(WC))
		var/mob/living/carbon/human/H = WC
		H.sync_dna_traits(FALSE,TRUE)
		H.sync_organ_dna()
	WC.regenerate_icons()

/obj/machinery/computer/scan_consolenew/proc/do_pulse(var/lock_state)
	var/mob/living/carbon/WC = connected?.occupant?.resolve()
	irradiating = 0
	connected.locked = lock_state

	if(!WC)
		return
	// Traitgenes Make the fullbody irritation more risky
	if(prob((radiation_intensity*2) + (radiation_duration*2)))
		if(prob(95))
			if(prob(75))
				randmutb(WC)
		else
			if(prob(95))
				randmutg(WC)
	// Traitgenes Do gene updates here, and more comprehensively
	if(ishuman(WC))
		var/mob/living/carbon/human/H = WC
		H.sync_dna_traits(FALSE,FALSE)
		H.sync_organ_dna()
	WC.regenerate_icons()

	WC.apply_effect(((radiation_intensity*3)+radiation_duration*3), IRRADIATE, check_protection = 0)


/obj/machinery/computer/scan_consolenew/proc/do_transfer(var/lock_state, var/bufferId)
	irradiating = 0
	connected.locked = lock_state

	playsound(src, "keyboard", 40)

	var/mob/living/carbon/WC = connected?.occupant?.resolve()
	if(!WC)
		return TRUE
	var/datum/transhuman/body_record/buf = buffers[bufferId] // Traitgenes- Use bodyrecords
	if(buf.mydna.types & DNA2_BUF_SE)
		// Apply SEs only to the current occupant!
		WC.dna.SE = buf.mydna.dna.SE.Copy()
		WC.dna.UpdateSE()
		domutcheck(WC,connected, MUTCHK_FORCED | MUTCHK_HIDEMSG) // TOO MANY MUTATIONS FOR MESSAGES
		to_chat(WC, span_warning("Your body stings as it wildly changes!"))

		// apply genes
		if(ishuman(WC))
			var/mob/living/carbon/human/H = WC
			H.sync_organ_dna()

		//Apply genetic modifiers
		WC.dna.genetic_modifiers.Cut() // clear em!
		for(var/modifier_type in buf.genetic_modifiers)
			WC.add_modifier(modifier_type)
	WC.apply_effect(rand(20,50), IRRADIATE, check_protection = 0)



#undef DNA_BLOCK_SIZE

#undef PAGE_SE
#undef PAGE_BUFFER
#undef PAGE_REJUVENATORS

/////////////////////////// DNA MACHINES
