/obj/item/detective_scanner
	name = "forensic scanner"
	desc = "Used to scan objects for DNA and fingerprints."
	icon_state = "forensic"
	var/list/stored = list()
	w_class = ITEMSIZE_SMALL
	item_state = "electronic"
	flags = NOBLUDGEON
	slot_flags = SLOT_BELT

	var/reveal_fingerprints = TRUE
	var/reveal_incompletes = FALSE
	var/reveal_blood = TRUE
	var/reveal_fibers = FALSE

/obj/item/detective_scanner/attack(mob/living/carbon/human/M as mob, mob/user as mob)
	if (!ishuman(M))
		to_chat(user, "<span class='warning'>\The [M] does not seem to be compatible with this device.</span>")
		flick("[icon_state]0",src)
		return 0

	if(reveal_fingerprints)
		if((!( istype(M.dna, /datum/dna) ) || M.gloves))
			to_chat(user, "<span class='notice'>No fingerprints found on [M]</span>")
			flick("[icon_state]0",src)
			return 0
		else if(user.zone_sel.selecting == "r_hand" || user.zone_sel.selecting == "l_hand")
			var/obj/item/sample/print/P = new /obj/item/sample/print(user.loc)
			P.attack(M, user)
			to_chat(user, "<span class='notice'>Done printing.</span>")
	//		to_chat(user, "<span class='notice'>[M]'s Fingerprints: [md5(M.dna.uni_identity)]</span>")

	if(reveal_blood && M.blood_DNA && M.blood_DNA.len)
		to_chat(user, "<span class='notice'>Blood found on [M]. Analysing...</span>")
		spawn(15)
			for(var/blood in M.blood_DNA)
				to_chat(user, "<span class='notice'>Blood type: [M.blood_DNA[blood]]\nDNA: [blood]</span>")
	return

/obj/item/detective_scanner/afterattack(atom/A as obj|turf, mob/user, proximity)
	if(!proximity) return
	if(ismob(A))
		return

/*
	if(istype(A,/obj/machinery/computer/forensic_scanning))
		user.visible_message("[user] takes a cord out of [src] and hooks its end into [A]" ,\
		"<span class='notice'>You download data from [src] to [A]</span>")
		var/obj/machinery/computer/forensic_scanning/F = A
		F.sync_data(stored)
		return
*/

	if(istype(A,/obj/item/sample/print))
		to_chat(user, "The scanner displays on the screen: \"ERROR 43: Object on Excluded Object List.\"")
		flick("[icon_state]0",src)
		return

	add_fingerprint(user)

	if(!(do_after(user, 1 SECOND)))
		to_chat(user, "<span class='warning'>You must remain still for the device to complete its work.</span>")
		return 0

	//General
	if ((!A.fingerprints || !A.fingerprints.len) && !A.suit_fibers && !A.blood_DNA)
		user.visible_message("\The [user] scans \the [A] with \a [src], the air around [user.gender == MALE ? "him" : "her"] humming[prob(70) ? " gently." : "."]" ,\
		"<span class='warning'>Unable to locate any fingerprints, materials, fibers, or blood on [A]!</span>",\
		"You hear a faint hum of electrical equipment.")
		flick("[icon_state]0",src)
		return 0

	if(add_data(A))
		to_chat(user,"<span class='notice'>Object already in internal memory. Consolidating data...</span>")
		flick("[icon_state]1",src)
		return

	//PRINTS
	if(A.fingerprints && A.fingerprints.len)
		to_chat(user, "<span class='notice'>Isolated [A.fingerprints.len] fingerprints:</span>")
		if(!reveal_incompletes)
			to_chat(user, "<span class='warning'>Rapid Analysis Imperfect: Scan samples with H.R.F.S. equipment to determine nature of incomplete prints.</span>")
		var/list/complete_prints = list()
		var/list/incomplete_prints = list()
		for(var/i in A.fingerprints)
			var/print = A.fingerprints[i]
			if(stringpercent(print) <= FINGERPRINT_COMPLETE)
				complete_prints += print
			else
				incomplete_prints += print
		if(complete_prints.len < 1)
			to_chat(user, "<span class='notice'>No intact prints found</span>")
		else
			to_chat(user, "<span class='notice'>Found [complete_prints.len] intact prints</span>")
			if(reveal_fingerprints)
				for(var/i in complete_prints)
					to_chat(user, "<span class='notice'>&nbsp;&nbsp;&nbsp;&nbsp;[i]</span>")

		to_chat(user, "<span class='notice'>Found [incomplete_prints.len] incomplete prints</span>")
		if(reveal_incompletes)
			for(var/i in incomplete_prints)
				to_chat(user, "<span class='notice'>&nbsp;&nbsp;&nbsp;&nbsp;[i]</span>")


	//FIBERS
	if(A.suit_fibers && A.suit_fibers.len)
		to_chat(user,"<span class='notice'>Fibers/Materials detected.[reveal_fibers ? " Analysing..." : " Acquisition of fibers for H.R.F.S. analysis advised."]</span>")
		flick("[icon_state]1",src)
		if(reveal_fibers && do_after(user, 5 SECONDS))
			to_chat(user, "<span class='notice'>Apparel samples scanned:</span>")
			for(var/sample in A.suit_fibers)
				to_chat(user, " - <span class='notice'>[sample]</span>")

	//Blood
	if (A.blood_DNA && A.blood_DNA.len)
		to_chat(user, "<span class='notice'>Blood detected.[reveal_blood ? " Analysing..." : " Acquisition of swab for H.R.F.S. analysis advised."]</span>")
		if(reveal_blood && do_after(user, 5 SECONDS))
			flick("[icon_state]1",src)
			for(var/blood in A.blood_DNA)
				to_chat(user, "Blood type: <span class='warning'>[A.blood_DNA[blood]]</span> DNA: <span class='warning'>[blood]</span>")

	user.visible_message("\The [user] scans \the [A] with \a [src], the air around [user.gender == MALE ? "him" : "her"] humming[prob(70) ? " gently." : "."]" ,\
	"<span class='notice'>You finish scanning \the [A].</span>",\
	"You hear a faint hum of electrical equipment.")
	flick("[icon_state]1",src)
	return 0

/obj/item/detective_scanner/proc/add_data(atom/A as mob|obj|turf|area)
	var/datum/data/record/forensic/old = stored["\ref [A]"]
	var/datum/data/record/forensic/fresh = new(A)

	if(old)
		fresh.merge(old)
		. = 1
	stored["\ref [A]"] = fresh

/obj/item/detective_scanner/verb/examine_data()
	set name = "Examine Forensic Data"
	set category = "Object"
	set src in view(1)

	//to_world("usr is [usr]") //why was this a thing? -KK.
	display_data(usr)

/obj/item/detective_scanner/proc/display_data(var/mob/user)
	if(user && stored && stored.len)
		for(var/objref in stored)
			if(!do_after(user, 1 SECOND)) // So people can move and stop the spam, if they refuse to wipe data.
				break

			var/datum/data/record/forensic/F = stored[objref]
			var/list/fprints = F.fields["fprints"]
			var/list/fibers = F.fields["fibers"]
			var/list/bloods = F.fields["blood"]

			to_chat(user, "<span class='notice'>Data for: [F.fields["name"]]</span>")

			if(reveal_fingerprints)
				var/list/complete_prints = list()
				var/list/incomplete_prints = list()
				for(var/i in fprints)
					var/print = fprints[i]
					if(stringpercent(print) <= FINGERPRINT_COMPLETE)
						complete_prints += print
						to_chat(user, " - <span class='notice'>[print]</span>")
					else
						incomplete_prints += print

				if(complete_prints.len < 1)
					to_chat(user, "<span class='notice'>No intact prints found.</span>")

				if(reveal_incompletes)
					for(var/print in incomplete_prints)
						to_chat(user, " - <span class='notice'>[print]</span>")

			if(fibers && fibers.len)
				to_chat(user, "<span class='notice'>[fibers.len] samples of material were present.</span>")
				if(reveal_fibers)
					for(var/sample in fibers)
						to_chat(user, " - <span class='notice'>[sample]</span>")

			if(bloods && bloods.len)
				to_chat(user, "<span class='notice'>[bloods.len] samples of blood were present.</span>")
				if(reveal_blood)
					for(var/bloodsample in bloods)
						to_chat(user, " - <span class='warning'>[bloodsample]</span> Type: [bloods[bloodsample]]")

/obj/item/detective_scanner/verb/wipe()
	set name = "Wipe Forensic Data"
	set category = "Object"
	set src in view(1)

	if (tgui_alert(usr, "Are you sure you want to wipe all data from [src]?","Wipe Data",list("Yes","No")) == "Yes")
		stored = list()
		to_chat(usr, "<span class='notice'>Forensic data erase complete.</span>")

/obj/item/detective_scanner/advanced
	name = "advanced forensic scanner"
	icon_state = "forensic_neo"
	reveal_fibers = TRUE
	reveal_incompletes = TRUE
