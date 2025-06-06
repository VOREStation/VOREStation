/datum/data/pda/utility/flashlight
	name = "Enable Flashlight"
	icon = "lightbulb-o"

	var/fon = 0 //Is the flashlight function on?
	var/f_lum = 2 //Luminosity for the flashlight function

/datum/data/pda/utility/flashlight/start()
	fon = !fon
	name = fon ? "Disable Flashlight" : "Enable Flashlight"
	pda.update_shortcuts()
	pda.set_light(fon ? f_lum : 0)
	if(fon)
		pda.add_overlay("light-o")
	else
		pda.cut_overlay("light-o")

/datum/data/pda/utility/honk
	name = "Honk Synthesizer"
	icon = "smile-o"
	category = "Clown"

	var/last_honk //Also no honk spamming that's bad too

/datum/data/pda/utility/honk/start()
	if(!(last_honk && world.time < last_honk + 20))
		playsound(pda.loc, 'sound/items/bikehorn.ogg', 50, 1)
		last_honk = world.time

/datum/data/pda/utility/toggle_door
	name = "Toggle Door"
	icon = "external-link"
	var/remote_door_id = ""

// /datum/data/pda/utility/toggle_door/start()
// 	for(var/obj/machinery/door/poddoor/M in airlocks)
// 		if(M.id_tag == remote_door_id)
// 			if(M.density)
// 				M.open()
// 			else
// 				M.close()

/datum/data/pda/utility/scanmode/medical
	base_name = "Med Scanner"
	icon = "heart-o"

/datum/data/pda/utility/scanmode/medical/scan_mob(mob/living/C as mob, mob/living/user as mob)
	C.visible_message(span_warning("[user] has analyzed [C]'s vitals!"))

	user.show_message(span_notice("Analyzing Results for [C]:"))
	user.show_message(span_notice("    Overall Status: [C.stat > 1 ? "dead" : "[C.health - C.halloss]% healthy"]"), 1)
	user.show_message(span_notice("    Damage Specifics:") + " [(C.getOxyLoss() > 50) ? span_warning(C.getOxyLoss()) : C.getOxyLoss()]-\
									[(C.getToxLoss() > 50) ? span_warning("[C.getToxLoss()]") : C.getToxLoss()]-\
									[(C.getFireLoss() > 50) ? span_warning("[C.getFireLoss()]") : C.getFireLoss()]-\
									[(C.getBruteLoss() > 50) ? span_warning("[C.getBruteLoss()]") : C.getBruteLoss()]", 1)
	user.show_message(span_notice("    Key: Suffocation/Toxin/Burns/Brute"), 1)
	user.show_message(span_notice("    Body Temperature: [C.bodytemperature-T0C]&deg;C ([C.bodytemperature*1.8-459.67]&deg;F)"), 1)
	if(C.tod && (C.stat == DEAD || (C.status_flags & FAKEDEATH)))
		user.show_message(span_notice("    Time of Death: [C.tod]"))
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		var/list/damaged = H.get_damaged_organs(1,1)
		user.show_message(span_notice("Localized Damage, Brute/Burn:"),1)
		if(length(damaged)>0)
			for(var/obj/item/organ/external/org in damaged)
				user.show_message(span_notice("     [capitalize(org.name)]: [(org.brute_dam > 0) ? span_warning("[org.brute_dam]") : span_notice("[org.brute_dam]")]-\
								[(org.burn_dam > 0) ? span_warning("[org.burn_dam]") : span_notice("[org.burn_dam]")]"), 1)
		else
			user.show_message(span_notice("    Limbs are OK."),1)

/datum/data/pda/utility/scanmode/dna
	base_name = "DNA Scanner"
	icon = "link"

/datum/data/pda/utility/scanmode/dna/scan_mob(mob/living/C as mob, mob/living/user as mob)
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		if(!istype(H.dna, /datum/dna))
			to_chat(user, span_notice("No fingerprints found on [H]"))
		else
			to_chat(user, span_notice("[H]'s Fingerprints: [md5(H.dna.uni_identity)]"))
	scan_blood(C, user)

/datum/data/pda/utility/scanmode/dna/scan_atom(atom/A as mob|obj|turf|area, mob/user as mob)
	scan_blood(A, user)

/datum/data/pda/utility/scanmode/dna/proc/scan_blood(atom/A, mob/user)
	var/list/blood_dna = A.forensic_data?.get_blooddna()
	if(!blood_dna)
		to_chat(user, span_notice("No blood found on [A]"))
	else
		to_chat(user, span_notice("Blood found on [A]. Analysing..."))
		spawn(15)
			for(var/blood in blood_dna)
				to_chat(user, span_notice("Blood type: [blood_dna[blood]]\nDNA: [blood]"))

/datum/data/pda/utility/scanmode/halogen
	base_name = "Halogen Counter"
	icon = "exclamation-circle"

/datum/data/pda/utility/scanmode/halogen/scan_mob(mob/living/C as mob, mob/living/user as mob)
	C.visible_message(span_warning("[user] has analyzed [C]'s radiation levels!"))

	user.show_message(span_notice("Analyzing Results for [C]:"))
	if(C.radiation)
		user.show_message(span_notice("Radiation Level: [C.radiation > 0 ? span_danger("[C.radiation]") : "0"]"))
	else
		user.show_message(span_notice("No radiation detected."))

/datum/data/pda/utility/scanmode/reagent
	base_name = "Reagent Scanner"
	icon = "flask"

/datum/data/pda/utility/scanmode/reagent/scan_atom(atom/A as mob|obj|turf|area, mob/user as mob)
	if(!isnull(A.reagents))
		if(A.reagents.reagent_list.len > 0)
			var/reagents_length = A.reagents.reagent_list.len
			to_chat(user, span_notice("[reagents_length] chemical agent[reagents_length > 1 ? "s" : ""] found."))
			for(var/re in A.reagents.reagent_list)
				to_chat(user, span_notice("\t [re]"))
		else
			to_chat(user, span_notice("No active chemical agents found in [A]."))
	else
		to_chat(user, span_notice("No significant chemical agents found in [A]."))

/datum/data/pda/utility/scanmode/gas
	base_name = "Gas Scanner"
	icon = "tachometer-alt"

/datum/data/pda/utility/scanmode/gas/scan_atom(atom/A as mob|obj|turf|area, mob/user as mob)
	pda.analyze_gases(A, user)

/datum/data/pda/utility/scanmode/notes
	base_name = "Note Scanner"
	icon = "clipboard"
	var/datum/data/pda/app/notekeeper/notes

/datum/data/pda/utility/scanmode/notes/start()
	. = ..()
	notes = pda.find_program(/datum/data/pda/app/notekeeper)

/datum/data/pda/utility/scanmode/notes/scan_atom(atom/A as mob|obj|turf|area, mob/user as mob)
	if(notes && istype(A, /obj/item/paper))
		var/obj/item/paper/P = A
		var/list/brlist = list("p", "/p", "br", "hr", "h1", "h2", "h3", "h4", "/h1", "/h2", "/h3", "/h4")

		// JMO 20140705: Makes scanned document show up properly in the notes. Not pretty for formatted documents,
		// as this will clobber the HTML, but at least it lets you scan a document. You can restore the original
		// notes by editing the note again. (Was going to allow you to edit, but scanned documents are too long.)
		var/raw_scan = sanitize_simple(P.info, list("\t" = "", "ÿ" = ""))
		var/formatted_scan = ""
		// Scrub out the tags (replacing a few formatting ones along the way)
		// Find the beginning and end of the first tag.
		var/tag_start = findtext(raw_scan, "<")
		var/tag_stop = findtext(raw_scan, ">")
		// Until we run out of complete tags...
		while(tag_start && tag_stop)
			var/pre = copytext(raw_scan, 1, tag_start) // Get the stuff that comes before the tag
			var/tag = lowertext(copytext(raw_scan, tag_start + 1, tag_stop)) // Get the tag so we can do intellegent replacement
			var/tagend = findtext(tag, " ") // Find the first space in the tag if there is one.
			// Anything that's before the tag can just be added as is.
			formatted_scan = formatted_scan + pre
			// If we have a space after the tag (and presumably attributes) just crop that off.
			if(tagend)
				tag = copytext(tag, 1, tagend)
			if(tag in brlist) // Check if it's I vertical space tag.
				formatted_scan = formatted_scan + "<br>" // If so, add some padding in.
			raw_scan = copytext(raw_scan, tag_stop + 1) // continue on with the stuff after the tag
			// Look for the next tag in what's left
			tag_start = findtext(raw_scan, "<")
			tag_stop = findtext(raw_scan, ">")
		// Anything that is left in the page. just tack it on to the end as is
		formatted_scan = formatted_scan + raw_scan
		// If there is something in there already, pad it out.
		if(length(notes.note) > 0)
			notes.note += "<br><br>"
		// Store the scanned document to the notes
		notes.note = formatted_scan
		notes.notetitle = sanitize_simple(P.name, list("\n" = "", "\t" = "", "ÿ" = ""))
		// update the saved note too incase we kept the pda open, this is really silly due to how the notehtml is actually what's passed to the editor's text.
		// If I don't update it here, it loses the data when you edit it!
		notes.storednotes[notes.currentnote] = notes.note
		notes.storedtitles[notes.currentnote] = notes.notetitle
		notes.notehtml = html_decode(replacetext(notes.note,"<br>", "\n"))
		// Inform the user
		var/scannedtitle = "Paper"
		if(!isnull(notes.notetitle) && notes.notetitle != "")
			scannedtitle = "'[notes.notetitle]'"
		to_chat(user, span_notice("[scannedtitle] scanned to Notekeeper in note [GLOB.alphabet_upper[notes.currentnote]]."))//concept of scanning paper copyright brainoblivion 2009

	else
		to_chat(user, span_warning("Error scanning [A]."))
