// Little define makes it cleaner to read the tripple color values out of mobs.
#define MOB_HEX_COLOR(M, V) "#[num2hex(M.r_##V, 2)][num2hex(M.g_##V, 2)][num2hex(M.b_##V, 2)]"

#define MENU_MAIN "Main"
#define MENU_BODYRECORDS "Body Records"
#define MENU_STOCKRECORDS "Stock Records"
#define MENU_SPECIFICRECORD "Specific Record"
#define MENU_OOCNOTES "OOC Notes"

/obj/machinery/computer/transhuman/designer
	name = "body design console"
	catalogue_data = list(/datum/category_item/catalogue/technology/resleeving)
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "med_key"
	icon_screen = "explosive"
	light_color = "#315ab4"
	circuit = /obj/item/circuitboard/body_designer
	req_access = list(access_medical) // Used for loading people's designs
	var/temp = ""
	var/menu = MENU_MAIN //Which menu screen to display
	var/datum/transhuman/body_record/active_br = null
	//Mob preview
	var/map_name
	var/obj/screen/south_preview = null
	var/obj/screen/east_preview = null
	var/obj/screen/west_preview = null
	var/obj/screen/north_preview = null
	// Mannequins are somewhat expensive to create, so cache it
	var/mob/living/carbon/human/dummy/mannequin/mannequin = null
	var/obj/item/disk/body_record/disk = null

	// Resleeving database this machine interacts with. Blank for default database
	// Needs a matching /datum/transcore_db with key defined in code
	var/db_key
	var/datum/transcore_db/our_db // These persist all round and are never destroyed, just keep a hard ref

/obj/machinery/computer/transhuman/designer/Initialize()
	. = ..()
	map_name = "transhuman_designer_[REF(src)]_map"

	south_preview = new
	south_preview.name = ""
	south_preview.assigned_map = map_name
	south_preview.del_on_map_removal = FALSE
	south_preview.screen_loc = "[map_name]:2,1"

	east_preview = new
	east_preview.name = ""
	east_preview.assigned_map = map_name
	east_preview.del_on_map_removal = FALSE
	east_preview.screen_loc = "[map_name]:4,1"

	west_preview = new
	west_preview.name = ""
	west_preview.assigned_map = map_name
	west_preview.del_on_map_removal = FALSE
	west_preview.screen_loc = "[map_name]:0,1"

	north_preview = new
	north_preview.name = ""
	north_preview.assigned_map = map_name
	north_preview.del_on_map_removal = FALSE
	north_preview.screen_loc = "[map_name]:6,1"

	our_db = SStranscore.db_by_key(db_key)

/obj/machinery/computer/transhuman/designer/Destroy()
	active_br = null
	mannequin = null
	disk = null
	return ..()

/obj/machinery/computer/transhuman/designer/dismantle()
	if(disk)
		disk.forceMove(get_turf(src))
		disk = null
	..()

/obj/machinery/computer/transhuman/designer/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/disk/body_record))
		user.unEquip(W)
		disk = W
		disk.forceMove(src)
		to_chat(user, span_notice("You insert \the [W] into \the [src]."))
		updateUsrDialog()
	else
		..()
	return

/obj/machinery/computer/transhuman/designer/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/transhuman/designer/attack_hand(mob/user as mob)
	add_fingerprint(user)
	if(inoperable())
		return
	tgui_interact(user)

/obj/machinery/computer/transhuman/designer/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		give_client_previews(user.client)
		ui = new(user, src, "BodyDesigner", name)
		ui.open()

/obj/machinery/computer/transhuman/designer/tgui_static_data(mob/user)
	var/list/data = ..()
	data["mapRef"] = map_name
	return data

/obj/machinery/computer/transhuman/designer/tgui_data(mob/user)
	var/list/data = list()

	if(menu == MENU_BODYRECORDS)
		var/bodyrecords_list_ui[0]
		for(var/N in our_db.body_scans)
			var/datum/transhuman/body_record/BR = our_db.body_scans[N]
			bodyrecords_list_ui[++bodyrecords_list_ui.len] = list("name" = N, "recref" = "\ref[BR]")
		if(bodyrecords_list_ui.len)
			data["bodyrecords"] = bodyrecords_list_ui

	if(menu == MENU_STOCKRECORDS)
		var/stock_bodyrecords_list_ui[0]
		for (var/N in GLOB.all_species)
			var/datum/species/S = GLOB.all_species[N]
			if((S.spawn_flags & (SPECIES_IS_WHITELISTED|SPECIES_CAN_JOIN)) != SPECIES_CAN_JOIN) continue
			stock_bodyrecords_list_ui += N
		if(stock_bodyrecords_list_ui.len)
			data["stock_bodyrecords"] = stock_bodyrecords_list_ui

	if(active_br)
		data["activeBodyRecord"] = list(
			"real_name" = active_br.mydna.name,
			"speciesname" = active_br.speciesname ? active_br.speciesname : active_br.mydna.dna.species,
			"blood_type" = active_br.mydna.dna.b_type,
			"blood_color" = active_br.mydna.dna.blood_color,
			"blood_reagents" = active_br.mydna.dna.blood_reagents,
			"weight" = !isnull(active_br.weight) ? active_br.weight : 137, // 137 id default in code\modules\client\preference_setup\vore\02_size.dm
			"flavors" = list(),
			"scale_appearance" = active_br.mydna.dna.scale_appearance ? "Fuzzy" : "Sharp",
			"offset_override" = active_br.mydna.dna.offset_override ? "Odd" : "Even",
			"species_sound" = active_br.mydna.dna.species_sounds,
			"gender" = active_br.bodygender,
			"synthetic" = active_br.synthetic ? "Yes" : "No",
			"locked" = active_br.locked,
			"scale" = player_size_name(active_br.sizemult),
			"booc" = active_br.body_oocnotes,
			"styles" = list()
		)

		var/list/flavors = data["activeBodyRecord"]["flavors"]
		flavors += active_br.mydna.flavor.Copy()

		var/list/styles = data["activeBodyRecord"]["styles"]
		var/list/temp

		if (mannequin.species && mannequin.species.selects_bodytype)
			if (!mannequin.species.base_species)
				mannequin.species.base_species = mannequin.species.name
			styles["Bodytype"] = list("styleHref" = "custom_base", "style" = mannequin.species.base_species)

		temp = list("styleHref" = "ear_style", "style" = "Normal")
		if(mannequin.ear_style)
			temp["style"] = mannequin.ear_style.name
			if(mannequin.ear_style.do_colouration)
				temp["color"] = MOB_HEX_COLOR(mannequin, ears)
				temp["colorHref"] = "ear_color"
			if(mannequin.ear_style.extra_overlay)
				temp["color2"] = MOB_HEX_COLOR(mannequin, ears2)
				temp["colorHref2"] = "ear_color2"
			if(mannequin.ear_style.extra_overlay2)
				temp["color3"] = MOB_HEX_COLOR(mannequin, ears3)
				temp["colorHref3"] = "ear_color3"
		styles["Ears"] = temp

		temp = list("styleHref" = "ear_style", "style" = "Normal")
		if(mannequin.ear_secondary_style)
			temp["style"] = mannequin.ear_secondary_style.name
			if(length(mannequin.ear_secondary_colors) >= 1)
				temp["color"] = mannequin.ear_secondary_colors[1]
				temp["colorHref"] = list("act" = "ear_secondary_color", "channel" = 1)
			if(length(mannequin.ear_secondary_colors) >= 2)
				temp["color"] = mannequin.ear_secondary_colors[2]
				temp["colorHref"] = list("act" = "ear_secondary_color", "channel" = 2)
		styles["Horns"] = temp

		temp = list("styleHref" = "tail_style", "style" = "Normal")
		if(mannequin.tail_style)
			temp["style"] = mannequin.tail_style.name
			if(mannequin.tail_style.do_colouration)
				temp["color"] = MOB_HEX_COLOR(mannequin, tail)
				temp["colorHref"] = "tail_color"
			if(mannequin.tail_style.extra_overlay)
				temp["color2"] = MOB_HEX_COLOR(mannequin, tail2)
				temp["colorHref2"] = "tail_color2"
			if(mannequin.tail_style.extra_overlay2)
				temp["color3"] = MOB_HEX_COLOR(mannequin, tail3)
				temp["colorHref3"] = "tail_color3"
		styles["Tail"] = temp

		temp = list("styleHref" = "wing_style", "style" = "Normal")
		if(mannequin.wing_style)
			temp["style"] = mannequin.wing_style.name
			if(mannequin.wing_style.do_colouration)
				temp["color"] = MOB_HEX_COLOR(mannequin, wing)
				temp["colorHref"] = "wing_color"
			if(mannequin.wing_style.extra_overlay)
				temp["color2"] = MOB_HEX_COLOR(mannequin, wing2)
				temp["colorHref2"] = "wing_color2"
			if(mannequin.wing_style.extra_overlay2)
				temp["color3"] = MOB_HEX_COLOR(mannequin, wing3)
				temp["colorHref3"] = "wing_color3"
		styles["Wing"] = temp

		temp = list("styleHref" = "hair_style", "style" = mannequin.h_style)
		if(mannequin.species && (mannequin.species.appearance_flags & HAS_HAIR_COLOR))
			temp["color"] = MOB_HEX_COLOR(mannequin, hair)
			temp["colorHref"] = "hair_color"
		styles["Hair"] = temp

		temp = list("styleHref" = "facial_style", "style" = mannequin.f_style)
		if(mannequin.species && (mannequin.species.appearance_flags & HAS_HAIR_COLOR))
			temp["color"] = MOB_HEX_COLOR(mannequin, facial)
			temp["colorHref"] = "facial_color"
		styles["Facial"] = temp

		if(mannequin.species && (mannequin.species.appearance_flags & HAS_EYE_COLOR))
			styles["Eyes"] = list("colorHref" = "eye_color", "color" = MOB_HEX_COLOR(mannequin, eyes))

		if(mannequin.species && (mannequin.species.appearance_flags & HAS_SKIN_COLOR))
			styles["Body Color"] = list("colorHref" = "skin_color", "color" = MOB_HEX_COLOR(mannequin, skin))

		var/datum/preferences/designer/P = new()
		apply_markings_to_prefs(mannequin, P)
		data["activeBodyRecord"]["markings"] = P.body_markings
		data["activeBodyRecord"]["digitigrade"] = mannequin.digitigrade

	data["menu"] = menu
	data["temp"] = temp
	data["disk"] = disk ? 1 : 0
	data["diskStored"] = disk && disk.stored ? 1 : 0

	return data

/obj/machinery/computer/transhuman/designer/tgui_act(action, params, datum/tgui/ui)
	if(..())
		return TRUE

	switch(action)
		if("debug_load_my_body")
			active_br = new /datum/transhuman/body_record(ui.user, FALSE, FALSE)
			update_preview_icon()
			menu = MENU_SPECIFICRECORD

		if("view_brec")
			var/datum/transhuman/body_record/BR = locate(params["view_brec"])
			if(BR && istype(BR.mydna))
				if(allowed(ui.user) || BR.ckey == ui.user.ckey)
					active_br = new /datum/transhuman/body_record(BR) // Load a COPY!
					update_preview_icon()
					menu = MENU_SPECIFICRECORD
				else
					active_br = null
					temp = "Access denied: Body records are confidential."
			else
				active_br = null
				temp = "ERROR: Record missing."

		if("view_stock_brec")
			var/datum/species/S = GLOB.all_species[params["view_stock_brec"]]
			if(S && (S.spawn_flags & (SPECIES_IS_WHITELISTED|SPECIES_CAN_JOIN)) == SPECIES_CAN_JOIN)
				// Generate body record from species!
				mannequin = new(null, S.name)
				mannequin.real_name = "Stock [S.name] Body"
				mannequin.name = mannequin.real_name
				mannequin.dna.real_name = mannequin.real_name
				mannequin.dna.base_species = mannequin.species.base_species
				active_br = new(mannequin, FALSE, FALSE)
				active_br.speciesname = "Custom Sleeve"
				update_preview_icon()
				menu = MENU_SPECIFICRECORD
			else
				active_br = null
				temp = "ERROR: Stock Record missing."

		if("boocnotes")
			menu = MENU_OOCNOTES

		if("loadfromdisk")
			if(disk && disk.stored)
				active_br = new /datum/transhuman/body_record(disk.stored) // Loads a COPY!
				update_preview_icon()
				menu = MENU_SPECIFICRECORD

		if("savetodisk")
			if(active_br.locked)
				var/answer = tgui_alert(ui.user,"This body record will be written to a disk and allow any mind to inhabit it. This is against the current body owner's configured OOC preferences for body impersonation. Please confirm that you have permission to do this, and are sure! Admins will be notified.","Mind Compatability",list("No","Yes"))
				if(!answer)
					return
				if(answer == "No")
					to_chat(ui.user, span_warning("ERROR: This body record is restricted."))
					return
				else
					message_admins("[ui.user] wrote an unlocked version of [active_br.mydna.name]'s bodyrecord to a disk. Their preferences do not allow body impersonation, but may be allowed with OOC consent.")
			if(disk && active_br)
				active_br.locked = FALSE // remove lock
				disk.stored = new /datum/transhuman/body_record(active_br) // Saves a COPY!
				disk.name = "[initial(disk.name)] ([active_br.mydna.name])"

		if("ejectdisk")
			disk.forceMove(get_turf(src))
			disk = null

		if("menu")
			menu = params["menu"]
			temp = ""

		if("href_conversion")
			PrefHrefMiddleware(params, ui.user)

	add_fingerprint(ui.user)
	return TRUE // Return 1 to refresh UI

//
// Code below is for generating preview icons based on a body_record
//

// Based on /datum/preferences/proc/update_preview_icon()
/obj/machinery/computer/transhuman/designer/proc/update_preview_icon()
	if(!mannequin)
		mannequin = new ()
	mannequin.delete_inventory(TRUE)
	update_preview_mob(mannequin)
	mannequin.ImmediateOverlayUpdate()

	var/mutable_appearance/MA = new(mannequin)
	south_preview.appearance = MA
	south_preview.dir = SOUTH
	south_preview.screen_loc = "[map_name]:2,1"
	south_preview.name = ""
	east_preview.appearance = MA
	east_preview.dir = EAST
	east_preview.screen_loc = "[map_name]:4,1"
	east_preview.name = ""
	west_preview.appearance = MA
	west_preview.dir = WEST
	west_preview.screen_loc = "[map_name]:0,1"
	west_preview.name = ""
	north_preview.appearance = MA
	north_preview.dir = NORTH
	north_preview.screen_loc = "[map_name]:6,1"
	north_preview.name = ""

/obj/machinery/computer/transhuman/designer/proc/give_client_previews(client/C)
	C.register_map_obj(south_preview)
	C.register_map_obj(east_preview)
	C.register_map_obj(west_preview)
	C.register_map_obj(north_preview)


/obj/machinery/computer/transhuman/designer/proc/update_preview_mob(var/mob/living/carbon/human/H)
	ASSERT(!QDELETED(H))
	ASSERT(!QDELETED(active_br))
	//log_debug("designer.update_preview_mob([H]) active_br = \ref[active_br]")
	//Get the DNA and generate a new mob
	var/datum/dna2/record/R = active_br.mydna
	H.set_species(R.dna.species) // This needs to happen before anything else becuase it sets some variables.

	// Update the external organs
	for(var/part in active_br.limb_data)
		var/status = active_br.limb_data[part]
		if(status == null) continue //Species doesn't have limb? Child of amputated limb?

		var/obj/item/organ/external/O = H.organs_by_name[part]
		if(!O) continue //Not an organ. Perhaps another amputation removed it already.

		if(status == 1) //Normal limbs
			continue
		else if(status == 0) //Missing limbs
			O.remove_rejuv()
		else if(status) //Anything else is a manufacturer
			if(active_br.synthetic)
				O.robotize(status)
			else
				O.remove_rejuv()

	// Then the internal organs.  I think only O_EYES acutally counts, but lets do all just in case
	for(var/part in active_br.organ_data)
		var/status = active_br.organ_data[part]
		if(status == null) continue //Species doesn't have organ? Child of missing part?

		var/obj/item/organ/I = H.internal_organs_by_name[part]
		if(!I) continue//Not an organ. Perhaps external conversion changed it already?

		if(status == 0) //Normal organ
			continue
		else if(status == 1) //Assisted organ
			I.mechassist()
		else if(status == 2) //Mechanical organ
			I.robotize()
		else if(status == 3) //Digital organ
			I.digitize()

	// Apply DNA
	qdel_swap(H.dna, R.dna.Clone())
	H.UpdateAppearance() // Update all appearance stuff from the DNA record
	// H.sync_dna_traits(FALSE) // Traitgenes edit - Sync traits to genetics if needed // Currently not implemented
	H.sync_organ_dna() // Do this because sprites depend on DNA-gender of organs (chest etc)
	H.resize(active_br.sizemult, FALSE)

	// Emissiive...
	if(H.ear_style)
		H.ear_style.em_block = FALSE
	if(H.tail_style)
		H.tail_style.em_block = FALSE
	if(H.wing_style)
		H.wing_style.em_block = FALSE

	for(var/key in R.flavor)
		H.flavor_texts[key]	= R.flavor[key]
	H.weight = active_br.weight
	// stupid dupe vars
	H.b_type = active_br.mydna.dna.b_type
	H.blood_color = active_br.mydna.dna.blood_color

	// And as for clothing...
	// We don't actually dress them! This is a medical machine, handle the nakedness DOCTOR!

	H.regenerate_icons()
	return 0 // Success!

// HORROR SHOW BELOW
// In order to avoid duplicating the many lines of code in player_setup that handle customizing
// body setup, we acutally are invoking those methods in order to let people customize the body here.
// Problem is, those procs save their data to /datum/preferences, not a body_record.
// Luckily the procs to convert from body_record to /datum/preferences and back already exist.
// Its ugly, but I think its still better than duplicating and maintaining all that code.
/obj/machinery/computer/transhuman/designer/proc/PrefHrefMiddleware(list/params, var/mob/user)
	if(!mannequin || !active_br)
		return

	if(params["target_href"] == "size_multiplier")
		var/new_size = tgui_input_number(user, "Choose your character's size, ranging from 25% to 200%", "Character Preference", null, 200, 25)
		if(new_size && ISINRANGE(new_size,25,200))
			active_br.sizemult = (new_size/100)
			update_preview_icon()
		return 1

	// The black magic horror show begins
	var/datum/preferences/designer/P = new()

	// We did DNA to mob, now mob to prefs!
	P.species = mannequin.species.name
	apply_coloration_to_prefs(mannequin, P)
	apply_organs_to_prefs(mannequin, P)
	apply_markings_to_prefs(mannequin, P)
	apply_ears_to_prefs(mannequin, P)

	for(var/key in active_br.mydna.flavor)
		P.flavor_texts[key]	= active_br.mydna.flavor[key]
	P.fuzzy = active_br.mydna.dna.scale_appearance
	P.offset_override = active_br.mydna.dna.offset_override
	// P.species_sound = active_br.mydna.dna.species_sounds // Currently not implemented on virgo

	// Now we start using the player_setup objects to do stuff!
	var/datum/category_collection/CC = P.player_setup
	var/datum/category_group/CG = CC.categories_by_name["General"]

	var/datum/category_item/player_setup_item/general/body/B = CG.items_by_name["Body"]
	ASSERT(istype(B))
	var/datum/category_item/player_setup_item/general/basic/G = CG.items_by_name["Basic"]
	ASSERT(istype(G))
	var/datum/category_item/player_setup_item/general/flavor/F = CG.items_by_name["Flavor"]
	ASSERT(istype(F))
	var/datum/category_item/player_setup_item/vore/size/S = CC.categories_by_name["VORE"].items_by_name["Size"]
	ASSERT(istype(S))
	var/datum/category_item/player_setup_item/vore/traits/V = CC.categories_by_name["VORE"].items_by_name["Traits"]
	ASSERT(istype(V))
	var/list/use_different_category = list("rename" = G, "bio_gender" = G, "blood_reagents" = V, "custom_species" = V, "blood_color" = V, "custom_base" = V, "species_sound_options" = S, "toggle_fuzzy" = S, "toggle_offset_override" = S, "weight" = S, "flavor_text" = F) //add more here if needed


	var/href_list = list()
	href_list["src"] = "\ref[src]"
	var/list/target_href_maybe = params["target_href"]
	// convert list-form inputs as needed
	if(islist(target_href_maybe))
		href_list[target_href_maybe["act"]] = TRUE
		for(var/key in target_href_maybe["params"])
			var/val = target_href_maybe["params"][key]
			href_list[key] = "[val]"
	else
		href_list[target_href_maybe] = params["target_value"]
	var/datum/category_item/player_setup_item/to_use = (params["target_href"] in use_different_category) ? use_different_category[params["target_href"]] : B

	var/action = 0
	action = to_use.OnTopic(list2params(href_list), href_list, user)
	if((action & TOPIC_UPDATE_PREVIEW || action & TOPIC_REFRESH_UPDATE_PREVIEW || action & TOPIC_HANDLED || action & TOPIC_REFRESH) && mannequin && active_br) // Outpost 21 edit - Handled and Refreshes also count for check!
		switch(params["target_href"])
			if("rename")
				active_br.mydna.name = P.real_name
				active_br.mydna.dna.real_name = P.real_name
				update_preview_icon()
				return TRUE
			if("bio_gender")
				active_br.bodygender = P.biological_gender
				active_br.mydna.dna.SetUIState(DNA_UI_GENDER, P.biological_gender!=MALE, 1)
				update_preview_icon()
				return TRUE
			if("custom_species")
				active_br.mydna.dna.custom_species = P.custom_species
				active_br.speciesname = P.custom_species
				update_preview_icon()
				return TRUE
			if("blood_color")
				active_br.mydna.dna.blood_color = P.blood_color
				update_preview_icon()
				return TRUE
			if("blood_type")
				active_br.mydna.dna.b_type = P.b_type
				update_preview_icon()
				return TRUE
			if("blood_reagents")
				active_br.mydna.dna.blood_reagents = P.blood_reagents
				update_preview_icon()
				return TRUE
			if("weight")
				active_br.weight = P.weight_vr
				update_preview_icon()
				return TRUE
			if("flavor_text")
				to_use.copy_to_mob(mannequin)
				for(var/key in mannequin.flavor_texts) // Get the flavors from the mob, which we just got from pref!
					active_br.mydna.flavor[key] = mannequin.flavor_texts[key]
				update_preview_icon()
				return TRUE
			if("toggle_fuzzy")
				active_br.mydna.dna.scale_appearance = P.fuzzy
				update_preview_icon()
				return TRUE
			if("toggle_offset_override")
				active_br.mydna.dna.offset_override = P.offset_override
				update_preview_icon()
				return TRUE
			if("species_sound_options")
				/* Currently not implemented on virgo
				active_br.mydna.dna.species_sounds = P.species_sound
				update_preview_icon() */
				return TRUE
		to_use.copy_to_mob(mannequin)
		mannequin.species.blood_color = active_br.mydna.dna.blood_color
		mannequin.species.blood_reagents = active_br.mydna.dna.blood_reagents
		active_br.mydna.dna.ResetUIFrom(mannequin)
		update_preview_icon()
		return TRUE

// Fake subtype of preferences we can use to steal code from player_setup
/datum/preferences/designer/New()
	player_setup = new(src)
	// Do NOT call ..(), it expects real stuff

// Disk for manually moving body records between the designer and sleever console etc.
/obj/item/disk/body_record
	name = "Body Design Disk"
	desc = "It has a small label: \n\
	\"Portable Body Record Storage Disk. \n\
	Insert into resleeving control console\""
	icon = 'icons/obj/discs_vr.dmi'
	icon_state = "data-green"
	item_state = "card-id"
	w_class = ITEMSIZE_SMALL
	var/datum/transhuman/body_record/stored = null

/*
 *	Diskette Box
 */

/obj/item/storage/box/body_record_disk
	name = "body record disk box"
	desc = "A box of body record disks, apparently."
	icon_state = "disk_kit"

/obj/item/storage/box/body_record_disk/New()
	..()
	for(var/i = 0 to 7)
		new /obj/item/disk/body_record(src)

#undef MOB_HEX_COLOR

#undef MENU_MAIN
#undef MENU_BODYRECORDS
#undef MENU_STOCKRECORDS
#undef MENU_SPECIFICRECORD
#undef MENU_OOCNOTES
