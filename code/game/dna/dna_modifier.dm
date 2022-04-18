#define DNA_BLOCK_SIZE 3

// Buffer datatype flags.
#define DNA2_BUF_UI 1
#define DNA2_BUF_UE 2
#define DNA2_BUF_SE 4

#define PAGE_UI "ui"
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
	var/list/body_descriptors = null
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
	newrecord.dna = dna.Clone()
	newrecord.types = types
	newrecord.name = name
	newrecord.mind = mind
	newrecord.ckey = ckey
	newrecord.languages = languages
	newrecord.implant = implant
	newrecord.flavor = flavor
	newrecord.gender = gender
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
	var/mob/living/carbon/occupant = null
	var/obj/item/reagent_containers/glass/beaker = null
	var/opened = 0
	var/damage_coeff
	var/scan_level
	var/precision_coeff

/obj/machinery/dna_scannernew/Initialize()
	. = ..()
	default_apply_parts()
	RefreshParts()

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
	src.go_out()
	for(var/obj/O in src)
		if((!istype(O,/obj/item/reagent_containers)) && (!istype(O,/obj/item/circuitboard/clonescanner)) && (!istype(O,/obj/item/stock_parts)) && (!istype(O,/obj/item/stack/cable_coil)))
			O.loc = get_turf(src)//Ejects items that manage to get in there (exluding the components)
	if(!occupant)
		for(var/mob/M in src)//Failsafe so you can get mobs out
			M.loc = get_turf(src)

/obj/machinery/dna_scannernew/MouseDrop_T(var/mob/target, var/mob/user) //Allows borgs to clone people without external assistance
	if(user.stat || user.lying || !Adjacent(user) || !target.Adjacent(user)|| !ishuman(target))
		return
	put_in(target)

/obj/machinery/dna_scannernew/verb/move_inside()
	set src in oview(1)
	set category = "Object"
	set name = "Enter DNA Scanner"

	if(usr.stat != 0)
		return
	if(!ishuman(usr) && !issmall(usr)) //Make sure they're a mob that has dna
		to_chat(usr, "<span class='notice'>Try as you might, you can not climb up into the scanner.</span>")
		return
	if(src.occupant)
		to_chat(usr, "<span class='warning'>The scanner is already occupied!</span>")
		return
	if(usr.abiotic())
		to_chat(usr, "<span class='warning'>The subject cannot have abiotic items on.</span>")
		return
	usr.stop_pulling()
	usr.client.perspective = EYE_PERSPECTIVE
	usr.client.eye = src
	usr.loc = src
	src.occupant = usr
	src.icon_state = "scanner_1"
	src.add_fingerprint(usr)
	SStgui.update_uis(src)

/obj/machinery/dna_scannernew/attackby(var/obj/item/item as obj, var/mob/user as mob)
	if(istype(item, /obj/item/reagent_containers/glass))
		if(beaker)
			to_chat(user, "<span class='warning'>A beaker is already loaded into the machine.</span>")
			return

		beaker = item
		user.drop_item()
		item.loc = src
		user.visible_message("\The [user] adds \a [item] to \the [src]!", "You add \a [item] to \the [src]!")
		SStgui.update_uis(src)
		return

	else if(istype(item, /obj/item/organ/internal/brain))
		if(src.occupant)
			to_chat(user, "<span class='warning'>The scanner is already occupied!</span>")
			return
		var/obj/item/organ/internal/brain/brain = item
		if(brain.clone_source)
			user.drop_item()
			brain.loc = src
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
	if(src.occupant)
		to_chat(user, "<span class='warning'>The scanner is already occupied!</span>")
		return
	if(G.affecting.abiotic())
		to_chat(user, "<span class='warning'>The subject cannot have abiotic items on.</span>")
		return
	put_in(G.affecting)
	src.add_fingerprint(user)
	qdel(G)
	return

/obj/machinery/dna_scannernew/proc/put_in(var/mob/M)
	if(M.client)
		M.client.perspective = EYE_PERSPECTIVE
		M.client.eye = src
	M.loc = src
	src.occupant = M
	src.icon_state = "scanner_1"

	// search for ghosts, if the corpse is empty and the scanner is connected to a cloner
	if(locate(/obj/machinery/computer/cloning, get_step(src, NORTH)) \
		|| locate(/obj/machinery/computer/cloning, get_step(src, SOUTH)) \
		|| locate(/obj/machinery/computer/cloning, get_step(src, EAST)) \
		|| locate(/obj/machinery/computer/cloning, get_step(src, WEST)))

		if(!M.client && M.mind)
			for(var/mob/observer/dead/ghost in player_list)
				if(ghost.mind == M.mind)
					to_chat(ghost, "<b><font color = #330033><font size = 3>Your corpse has been placed into a cloning scanner. Return to your body if you want to be resurrected/cloned!</b> (Verbs -> Ghost -> Re-enter corpse)</font></font>")
					break
	SStgui.update_uis(src)

/obj/machinery/dna_scannernew/proc/go_out()
	if((!( src.occupant ) || src.locked))
		return
	if(src.occupant.client)
		src.occupant.client.eye = src.occupant.client.mob
		src.occupant.client.perspective = MOB_PERSPECTIVE
	if(istype(occupant,/mob/living/carbon/brain))
		for(var/obj/O in src)
			if(istype(O,/obj/item/organ/internal/brain))
				O.loc = get_turf(src)
				src.occupant.loc = O
				break
	else
		src.occupant.loc = src.loc
	src.occupant = null
	src.icon_state = "scanner_0"
	SStgui.update_uis(src)

/obj/machinery/dna_scannernew/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/atom/movable/A as mob|obj in src)
				A.loc = src.loc
				ex_act(severity)
				//Foreach goto(35)
			//SN src = null
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
					//Foreach goto(108)
				//SN src = null
				qdel(src)
				return
		if(3.0)
			if(prob(25))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
					//Foreach goto(181)
				//SN src = null
				qdel(src)
				return
		else
	return

/obj/machinery/computer/scan_consolenew
	name = "DNA Modifier Access Console"
	desc = "Scan DNA."
	icon_keyboard = "med_key"
	icon_screen = "dna"
<<<<<<< HEAD
	density = TRUE
	circuit = /obj/item/weapon/circuitboard/scan_consolenew
=======
	density = 1
	circuit = /obj/item/circuitboard/scan_consolenew
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	var/selected_ui_block = 1.0
	var/selected_ui_subblock = 1.0
	var/selected_se_block = 1.0
	var/selected_se_subblock = 1.0
	var/selected_ui_target = 1
	var/selected_ui_target_hex = 1
	var/radiation_duration = 2.0
	var/radiation_intensity = 1.0
	var/list/datum/dna2/record/buffers[3]
	var/irradiating = 0
	var/injector_ready = 0	//Quick fix for issue 286 (screwdriver the screen twice to restore injector)	-Pete
	var/obj/machinery/dna_scannernew/connected = null
	var/obj/item/disk/data/disk = null
	var/selected_menu_key = PAGE_UI
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	active_power_usage = 400

/obj/machinery/computer/scan_consolenew/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/disk/data)) //INSERT SOME diskS
		if(!src.disk)
			user.drop_item()
			I.loc = src
			src.disk = I
			to_chat(user, "You insert [I].")
			SStgui.update_uis(src) // update all UIs attached to src
			return
	else
		..()
	return

/obj/machinery/computer/scan_consolenew/ex_act(severity)

	switch(severity)
		if(1.0)
			//SN src = null
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				//SN src = null
				qdel(src)
				return
		else
	return

/obj/machinery/computer/scan_consolenew/Initialize()
	. = ..()
	for(var/i=0;i<3;i++)
		buffers[i+1]=new /datum/dna2/record
	for(dir in list(NORTH,EAST,SOUTH,WEST))
		connected = locate(/obj/machinery/dna_scannernew, get_step(src, dir))
		if(connected)
			break
	VARSET_IN(src, injector_ready, TRUE, 25 SECONDS)

/obj/machinery/computer/scan_consolenew/proc/all_dna_blocks(var/list/buffer)
	var/list/arr = list()
	for(var/i = 1, i <= buffer.len, i++)
		arr += "[i]:[EncodeDNABlock(buffer[i])]"
	return arr

/obj/machinery/computer/scan_consolenew/proc/setInjectorBlock(var/obj/item/dnainjector/I, var/blk, var/datum/dna2/record/buffer)
	var/pos = findtext(blk,":")
	if(!pos) return 0
	var/id = text2num(copytext(blk,1,pos))
	if(!id) return 0
	I.block = id
	I.buf = buffer
	return 1

/*
/obj/machinery/computer/scan_consolenew/process() //not really used right now
	if(stat & (NOPOWER|BROKEN))
		return
	if(!( src.status )) //remove this
		return
	return
*/

/obj/machinery/computer/scan_consolenew/attack_ai(user as mob)
	src.add_hiddenprint(user)
	tgui_interact(user)

/obj/machinery/computer/scan_consolenew/attack_hand(user as mob)
	if(!..())
		tgui_interact(user)

/obj/machinery/computer/scan_consolenew/tgui_interact(mob/user, datum/tgui/ui)
	if(!connected || user == connected.occupant || user.stat)
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
	if(!disk || !disk.buf)
		diskData["data"] = null
		diskData["owner"] = null
		diskData["label"] = null
		diskData["type"] = null
		diskData["ue"] = null
	else
		diskData = disk.buf.GetData()
	data["disk"] = diskData

	var/list/new_buffers = list()
	for(var/datum/dna2/record/buf in src.buffers)
		new_buffers += list(buf.GetData())
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
	if(!src.connected.occupant || !src.connected.occupant.dna)
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
		occupantData["name"] = connected.occupant.real_name
		occupantData["stat"] = connected.occupant.stat
		occupantData["isViableSubject"] = 1
		if(NOCLONE in connected.occupant.mutations || !src.connected.occupant.dna)
			occupantData["isViableSubject"] = 0
		occupantData["health"] = connected.occupant.health
		occupantData["maxHealth"] = connected.occupant.maxHealth
		occupantData["minHealth"] = config.health_threshold_dead
		occupantData["uniqueEnzymes"] = connected.occupant.dna.unique_enzymes
		occupantData["uniqueIdentity"] = connected.occupant.dna.uni_identity
		occupantData["structuralEnzymes"] = connected.occupant.dna.struc_enzymes
		occupantData["radiationLevel"] = connected.occupant.radiation
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

/obj/machinery/computer/scan_consolenew/tgui_act(action, params)
	if(..())
		return TRUE
	if(!istype(usr.loc, /turf))
		return TRUE
	if(!src || !src.connected)
		return TRUE
	if(irradiating) // Make sure that it isn't already irradiating someone...
		return TRUE

	add_fingerprint(usr)

	if(tgui_act_modal(action, params))
		return TRUE

	. = TRUE
	switch(action)
		if("selectMenuKey")
			var/key = params["key"]
			if(!(key in list(PAGE_UI, PAGE_SE, PAGE_BUFFER, PAGE_REJUVENATORS)))
				return
			selected_menu_key = key
		if("toggleLock")
			if(connected && connected.occupant)
				connected.locked = !(connected.locked)

		if("pulseRadiation")
			irradiating = radiation_duration
			var/lock_state = connected.locked
			connected.locked = TRUE //lock it

			SStgui.update_uis(src) // update all UIs attached to src
			sleep(10 * radiation_duration) // sleep for radiation_duration seconds

			irradiating = 0
			connected.locked = lock_state

			if(!connected.occupant)
				return

			if(prob(95))
				if(prob(75))
					randmutb(connected.occupant)
				else
					randmuti(connected.occupant)
			else
				if(prob(95))
					randmutg(connected.occupant)
				else
					randmuti(connected.occupant)

			connected.occupant.apply_effect(((radiation_intensity*3)+radiation_duration*3), IRRADIATE, check_protection = 0)
		if("radiationDuration")
			radiation_duration = clamp(text2num(params["value"]), 1, 20)
		if("radiationIntensity")
			radiation_intensity = clamp(text2num(params["value"]), 1, 10)
	////////////////////////////////////////////////////////
		if("changeUITarget")
			selected_ui_target = clamp(text2num(params["value"]), 1, 15)
			selected_ui_target_hex = num2text(selected_ui_target, 1, 16)
		if("selectUIBlock") // This chunk of code updates selected block / sub-block based on click
			var/select_block = text2num(params["block"])
			var/select_subblock = text2num(params["subblock"])
			if(!select_block || !select_subblock)
				return

			selected_ui_block = clamp(select_block, 1, DNA_UI_LENGTH)
			selected_ui_subblock = clamp(select_subblock, 1, DNA_BLOCK_SIZE)
		if("pulseUIRadiation")
			var/block = connected.occupant.dna.GetUISubBlock(selected_ui_block,selected_ui_subblock)

			irradiating = radiation_duration
			var/lock_state = connected.locked
			connected.locked = TRUE //lock it

			SStgui.update_uis(src) // update all UIs attached to src
			sleep(10 * radiation_duration) // sleep for radiation_duration seconds

			irradiating = 0
			connected.locked = lock_state

			if(!connected.occupant)
				return

			if(prob((80 + (radiation_duration / 2))))
				block = miniscrambletarget(num2text(selected_ui_target), radiation_intensity, radiation_duration)
				connected.occupant.dna.SetUISubBlock(selected_ui_block,selected_ui_subblock,block)
				connected.occupant.UpdateAppearance()
				connected.occupant.apply_effect((radiation_intensity+radiation_duration), IRRADIATE, check_protection = 0)
			else
				if(prob(20 + radiation_intensity))
					randmutb(connected.occupant)
					domutcheck(connected.occupant,connected)
				else
					randmuti(connected.occupant)
					connected.occupant.UpdateAppearance()
				connected.occupant.apply_effect(((radiation_intensity*2)+radiation_duration), IRRADIATE, check_protection = 0)
	////////////////////////////////////////////////////////
		if("injectRejuvenators")
			if(!connected.occupant || !connected.beaker)
				return
			var/inject_amount = clamp(round(text2num(params["amount"]), 5), 0, 50) // round to nearest 5 and clamp to 0-50
			if(!inject_amount)
				return
			connected.beaker.reagents.trans_to_mob(connected.occupant, inject_amount, CHEM_BLOOD)
	////////////////////////////////////////////////////////
		if("selectSEBlock") // This chunk of code updates selected block / sub-block based on click (se stands for strutural enzymes)
			var/select_block = text2num(params["block"])
			var/select_subblock = text2num(params["subblock"])
			if(!select_block || !select_subblock)
				return

			selected_se_block = clamp(select_block, 1, DNA_SE_LENGTH)
			selected_se_subblock = clamp(select_subblock, 1, DNA_BLOCK_SIZE)
		if("pulseSERadiation")
			var/block = connected.occupant.dna.GetSESubBlock(selected_se_block,selected_se_subblock)
			//var/original_block=block
			//testing("Irradiating SE block [selected_se_block]:[selected_se_subblock] ([block])...")

			irradiating = radiation_duration
			var/lock_state = connected.locked
			connected.locked = TRUE //lock it

			SStgui.update_uis(src) // update all UIs attached to src
			sleep(10 * radiation_duration) // sleep for radiation_duration seconds

			irradiating = 0
			connected.locked = lock_state

			if(connected.occupant)
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
					connected.occupant.dna.SetSESubBlock(real_SE_block,selected_se_subblock,block)
					connected.occupant.apply_effect((radiation_intensity+radiation_duration), IRRADIATE, check_protection = 0)
					domutcheck(connected.occupant,connected)
				else
					connected.occupant.apply_effect(((radiation_intensity*2)+radiation_duration), IRRADIATE, check_protection = 0)
					if	(prob(80-radiation_duration))
						//testing("Random bad mut!")
						randmutb(connected.occupant)
						domutcheck(connected.occupant,connected)
					else
						randmuti(connected.occupant)
						//testing("Random identity mut!")
						connected.occupant.UpdateAppearance()
		if("ejectBeaker")
			if(connected.beaker)
				var/obj/item/reagent_containers/glass/B = connected.beaker
				B.loc = connected.loc
				connected.beaker = null
		if("ejectOccupant")
			connected.eject_occupant()
		// Transfer Buffer Management
		if("bufferOption")
			var/bufferOption = params["option"]
			var/bufferId = text2num(params["id"])
			if(bufferId < 1 || bufferId > 3) // Not a valid buffer id
				return

			var/datum/dna2/record/buffer = buffers[bufferId]
			switch(bufferOption)
				if("saveUI")
					if(connected.occupant && connected.occupant.dna)
						var/datum/dna2/record/databuf=new
						databuf.types = DNA2_BUF_UI // DNA2_BUF_UE
						databuf.dna = connected.occupant.dna.Clone()
						if(ishuman(connected.occupant))
							var/mob/living/carbon/human/H = connected.occupant
							databuf.dna.real_name = H.dna.real_name
							databuf.gender = H.gender
							databuf.body_descriptors = H.descriptors
						databuf.name = "Unique Identifier"
						buffers[bufferId] = databuf
				if("saveUIAndUE")
					if(connected.occupant && connected.occupant.dna)
						var/datum/dna2/record/databuf=new
						databuf.types = DNA2_BUF_UI|DNA2_BUF_UE
						databuf.dna = connected.occupant.dna.Clone()
						if(ishuman(connected.occupant))
							var/mob/living/carbon/human/H = connected.occupant
							databuf.dna.real_name = H.dna.real_name
							databuf.gender = H.gender
							databuf.body_descriptors = H.descriptors
						databuf.name = "Unique Identifier + Unique Enzymes"
						buffers[bufferId] = databuf
				if("saveSE")
					if(connected.occupant && connected.occupant.dna)
						var/datum/dna2/record/databuf=new
						databuf.types = DNA2_BUF_SE
						databuf.dna = connected.occupant.dna.Clone()
						if(ishuman(connected.occupant))
							var/mob/living/carbon/human/H = connected.occupant
							databuf.dna.real_name = H.dna.real_name
							databuf.gender = H.gender
							databuf.body_descriptors = H.descriptors
						databuf.name = "Structural Enzymes"
						buffers[bufferId] = databuf
				if("clear")
					buffers[bufferId] = new /datum/dna2/record()
				if("changeLabel")
					tgui_modal_input(src, "changeBufferLabel", "Please enter the new buffer label:", null, list("id" = bufferId), buffer.name, TGUI_MODAL_INPUT_MAX_LENGTH_NAME)
				if("transfer")
					if(!connected.occupant || (NOCLONE in connected.occupant.mutations) || !connected.occupant.dna)
						return

					irradiating = 2
					var/lock_state = connected.locked
					connected.locked = 1//lock it

					SStgui.update_uis(src) // update all UIs attached to src
					sleep(2 SECONDS) // sleep for 2 seconds

					irradiating = 0
					connected.locked = lock_state

					var/datum/dna2/record/buf = buffers[bufferId]

					if((buf.types & DNA2_BUF_UI))
						if((buf.types & DNA2_BUF_UE))
							connected.occupant.real_name = buf.dna.real_name
							connected.occupant.name = buf.dna.real_name
							if(ishuman(connected.occupant))
								var/mob/living/carbon/human/H = connected.occupant
								H.gender = buf.gender
								H.descriptors = buf.body_descriptors
						connected.occupant.UpdateAppearance(buf.dna.UI.Copy())
					else if(buf.types & DNA2_BUF_SE)
						connected.occupant.dna.SE = buf.dna.SE
						connected.occupant.dna.UpdateSE()
						if(ishuman(connected.occupant))
							var/mob/living/carbon/human/H = connected.occupant
							H.gender = buf.gender
							H.descriptors = buf.body_descriptors
						domutcheck(connected.occupant,connected)
					connected.occupant.apply_effect(rand(20,50), IRRADIATE, check_protection = 0)
				if("createInjector")
					if(!injector_ready)
						return
					if(text2num(params["block"]) > 0)
						var/list/choices = all_dna_blocks((buffer.types & DNA2_BUF_SE) ? buffer.dna.SE : buffer.dna.UI)
						tgui_modal_choice(src, "createInjectorBlock", "Please select the block to create an injector from:", null, list("id" = bufferId), null, choices)
					else
						create_injector(bufferId, TRUE)
				if("loadDisk")
					if(isnull(disk) || disk.read_only)
						return
					buffers[bufferId] = disk.buf.copy()
				if("saveDisk")
					if(isnull(disk) || disk.read_only)
						return
					var/datum/dna2/record/buf = buffers[bufferId]
					disk.buf = buf.copy()
					disk.name = "data disk - '[buf.dna.real_name]'"

		if("wipeDisk")
			if(isnull(disk) || disk.read_only)
				return
			disk.buf = null
		if("ejectDisk")
			if(!disk)
				return
			disk.forceMove(get_turf(src))
			disk = null

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
	addtimer(CALLBACK(src, .proc/injector_cooldown_finish), 30 SECONDS)

	// Create it
	var/datum/dna2/record/buf = buffers[buffer_id]
	var/obj/item/dnainjector/I = new()
	I.forceMove(loc)
	I.name += " ([buf.name])"
	if(copy_buffer)
		I.buf = buf.copy()
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
					var/datum/dna2/record/buf = buffers[buffer_id]
					var/obj/item/dnainjector/I = create_injector(buffer_id)
					setInjectorBlock(I, answer, buf.copy())
				if("changeBufferLabel")
					var/buffer_id = text2num(arguments["id"])
					if(buffer_id < 1 || buffer_id > length(buffers))
						return
					var/datum/dna2/record/buf = buffers[buffer_id]
					buf.name = answer
					buffers[buffer_id] = buf
				else
					return FALSE
		else
			return FALSE


#undef PAGE_UI
#undef PAGE_SE
#undef PAGE_BUFFER
#undef PAGE_REJUVENATORS

/////////////////////////// DNA MACHINES