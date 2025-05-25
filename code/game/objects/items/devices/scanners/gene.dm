/obj/item/gene_scanner
	name = "DNA identifier"
	desc = "Assess the cargo sale value of items."
	icon = 'icons/obj/device_alt.dmi'
	icon_state = "health"
	flags = NOBLUDGEON
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_DATA = 1)

// Always face the user when put on a table
/obj/item/gene_scanner/afterattack(atom/movable/AM, mob/user, proximity)
	if(!proximity)
		return
	if(!ismob(AM) && !istype(AM,/obj/item/organ))
		return

	to_chat(user,span_boldnotice("You assesses \the [AM]'s genetic traits."))
	playsound(src, 'sound/misc/bloop.ogg', 50, 1)
	flick("health2", src)

	if(do_after(user,6 SECONDS,AM))
		scan_genes(AM,user)

/obj/item/gene_scanner/proc/scan_genes(atom/movable/AM,mob/user)
	var/obj/item/organ/O = AM
	var/mob/living/L = AM
	var/output = ""

	// Actually do the scan
	if(isliving(L)) // Mobs
		if(!L.dna)
			output += span_danger("Inconclusive.")
			to_chat(user,output)
			return

		if(SKELETON in L.mutations)
			output += span_vdanger("SUBJECT IS SPOOKY SCARY SKELETON")
			to_chat(user,output)
			return

		var/mob/living/carbon/human/H = L
		if(ishuman(L))
			if(H.species.flags & NO_DNA)
				output += span_warning("Subject incompatible.")
				to_chat(user,output)
				return
			if(H.species.flags & NO_SLEEVE)
				output += span_danger("!!Subject incompatible with cloning!!") + "<br>"
		output += span_infoplain("Unique enzymes: [L.dna.unique_enzymes]") + "<br>"
		output += span_infoplain("Bloodtype: [L.dna.b_type]") + "<br>"

		if(L.radiation > 0)
			if(L.radiation > 200)
				output += span_danger("Subject is severely irradiated") + "<br>"
			else
				output += span_warning("Subject is irradiated") + "<br>"
		if(L.getCloneLoss())
			if(L.getCloneLoss() > 50)
				output += span_danger("[L.getCloneLoss()] Genetic damage") + "<br>"
			else
				output += span_warning("[L.getCloneLoss()] Genetic damage") + "<br>"

		if(NOCLONE in L.mutations)
			output += span_warning("Subject's dna is unstable") + "<br>"
		if(HUSK in L.mutations)
			output += span_warning("Subject's anatomical structure is destroyed") + "<br>"

		output += span_boldnotice("Detected genes:") + "<br>"
		for(var/datum/gene/G in GLOB.dna_genes)
			if(!L.dna.GetSEState(G.block))
				continue
			if(istype(G,/datum/gene/trait))
				var/datum/gene/trait/TG = G
				if(ishuman(L))
					output += span_info("-[TG.linked_trait.name]") + span_warning((TG.has_conflict(H.species.traits) ? " (Suppressed)" : "")) + "<br>"
				else
					output += span_info("-[TG.linked_trait.name]") + "<br>"
				output += span_infoplain("  [TG.linked_trait.desc]") + "<br>"
			else
				output += span_info("-[G.name]") + "<br>"
				output += span_infoplain("  [G.desc]") + "<br>"

	else if(istype(O)) // Organs
		if(!O.data)
			output += span_danger("Inconclusive.")
			to_chat(user,output)
			return

		output += span_infoplain("Unique enzymes: [O.data.unique_enzymes]") + "<br>"
		output += span_infoplain("Bloodtype: [O.data.b_type]") + "<br>"

	to_chat(user,output)
