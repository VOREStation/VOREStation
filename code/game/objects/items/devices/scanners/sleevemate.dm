var/global/mob/living/carbon/human/dummy/mannequin/sleevemate_mob

//SleeveMate!
/obj/item/sleevemate
	name = "\improper SleeveMate 3700"
	desc = "A hand-held sleeve management tool for performing one-time backups and managing mindstates."
	icon = 'icons/obj/device_alt.dmi'
	icon_state = "sleevemate"
	item_state = "healthanalyzer"
	slot_flags = SLOT_BELT
	throwforce = 3
	w_class = ITEMSIZE_SMALL
	throw_speed = 5
	throw_range = 10
	matter = list(MAT_STEEL = 200)
	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)

	var/datum/mind/stored_mind

	var/ooc_notes = null //For holding prefs
	var/ooc_notes_likes = null
	var/ooc_notes_dislikes = null

	// Resleeving database this machine interacts with. Blank for default database
	// Needs a matching /datum/transcore_db with key defined in code
	var/db_key
	var/datum/transcore_db/our_db // These persist all round and are never destroyed, just keep a hard ref
	pickup_sound = 'sound/items/pickup/device.ogg'
	drop_sound = 'sound/items/drop/device.ogg'

/obj/item/sleevemate/Initialize(mapload)
	. = ..()
	our_db = SStranscore.db_by_key(db_key)

//These don't perform any checks and need to be wrapped by checks
/obj/item/sleevemate/proc/clear_mind()
	stored_mind = null
	ooc_notes = null
	ooc_notes_likes = null
	ooc_notes_dislikes = null
	update_icon()

/obj/item/sleevemate/proc/get_mind(mob/living/M)
	ASSERT(M.mind)
	ooc_notes = M.ooc_notes
	ooc_notes_likes = M.ooc_notes_likes
	ooc_notes_dislikes = M.ooc_notes_dislikes
	stored_mind = M.mind
	M.ghostize()
	stored_mind.current = null
	update_icon()

/obj/item/sleevemate/proc/put_mind(mob/living/M)
	stored_mind.active = TRUE
	stored_mind.transfer_to(M)
	M.ooc_notes = ooc_notes
	M.ooc_notes_likes = ooc_notes_likes
	M.ooc_notes_dislikes = ooc_notes_dislikes
	clear_mind()



/obj/item/sleevemate/attack(mob/living/M, mob/living/user)
	// Gather potential subtargets
	var/list/choices = list(M)
	if(istype(M))
		for(var/obj/belly/B as anything in M.vore_organs)
			for(var/mob/living/carbon/human/H in B) // I do want an istype
				choices += H
	// Subtargets
	if(choices.len > 1)
		var/mob/living/new_M = tgui_input_list(user, "Ambiguous target. Please validate target:", "Target Validation", choices, M)
		if(!new_M || !M.Adjacent(user))
			return
		M = new_M

	if(isrobot(M))
		var/mob/living/silicon/robot/R = M
		var/obj/item/dogborg/sleeper/S = locate() in R.module.modules
		if(S && S.patient)
			scan_mob(S.patient, user)
			return

	if(ishuman(M))
		scan_mob(M, user)
	else
		to_chat(user,span_warning("Not a compatible subject to work with!"))

/obj/item/sleevemate/attack_self(mob/living/user)
	if(!stored_mind)
		to_chat(user,span_warning("No stored mind in \the [src]."))
		return

	var/choice = tgui_alert(user,"What would you like to do?","Stored: [stored_mind.name]",list("Delete","Backup","Cancel"))
	if(!stored_mind || user.get_active_hand() != src)
		return
	switch(choice)
		if("Delete")
			to_chat(user,span_notice("Internal copy of [stored_mind.name] deleted."))
			clear_mind()
		if("Backup")
			to_chat(user,span_notice("Internal copy of [stored_mind.name] backed up to database."))
			our_db.m_backup(stored_mind,null,one_time = TRUE)
		if("Cancel")
			return

/obj/item/sleevemate/proc/scan_mob(mob/living/carbon/human/H, mob/living/user)
	var/output = ""

	output += "<br><br>" + span_boldnotice("[src.name] Scan Results") + "<br>"

	//Mind name
	output += span_bold("Sleeved Mind:") + " "
	if(H.mind)
		output += "[H.mind.name]<br>"
	else
		output += span_warning("Unknown/None") + "<br>"

	//Mind status
	output += span_bold("Mind Status:") + " "
	if(H.client)
		output += "Healthy<br>"
	else
		output += "Space Sleep Disorder<br>"

	//Body status
	output += span_bold("Sleeve Status:") + " "
	switch(H.stat)
		if(CONSCIOUS)
			output += "Alive<br>"
		if(UNCONSCIOUS)
			output += "Unconscious<br>"
		if(DEAD)
			output += span_warning("Deceased") + "<br>"
		else
			output += span_warning("Unknown") + "<br>"

	//Mind/body comparison
	output += span_bold("Sleeve Pair:")
	if(!H.ckey)
		output += span_warning("No mind in that body") + " [stored_mind != null ? "\[<a href='byond://?src=\ref[src];target=\ref[H];mindupload=1'>Upload</a>\]" : null]<br>"
	else if(H.mind && ckey(H.mind.key) != H.ckey)
		output += span_warning("May not be correct body") + "<br>"
	else if(H.mind && ckey(H.mind.key) == H.ckey)
		output += "Appears to be correct mind in body<br>"
	else
		output += "Unable to perform comparison<br>"

	//Actions
	output += "<br><b>-- Possible Actions --</b><br>"
	output += span_bold("Mind-Scan (One Time): ") + "\[<a href='byond://?src=\ref[src];target=\ref[H];mindscan=1'>Perform</a>\]<br>"
	output += span_bold("Body-Scan (One Time): ") + "\[<a href='byond://?src=\ref[src];target=\ref[H];bodyscan=1'>Perform</a>\]<br>"

	//Saving a mind
	output += span_bold("Store Full Mind:") + " "
	if(stored_mind)
		output += span_notice("Already Stored") + " ([stored_mind.name])<br>"
	else if(H.mind)
		output += "\[<a href='byond://?src=\ref[src];target=\ref[H];mindsteal=1'>Perform</a>\]<br>"
	else
		output += span_warning("Unable") + "<br>"

	//Soulcatcher transfer
	if(H.nif)
		var/datum/nifsoft/soulcatcher/SC = H.nif.imp_check(NIF_SOULCATCHER)
		if(SC)
			output += "<br>"
			output += span_bold("Soulcatcher detected ([SC.brainmobs.len] minds)") + "<br>"
			for(var/mob/living/carbon/brain/caught_soul/mind in SC.brainmobs)
				output += "<i>[mind.name]: </i> [mind.transient == FALSE ? "\[<a href='byond://?src=\ref[src];target=\ref[H];mindrelease=[mind.name]'>Load</a>\]" : span_warning("Incompatible")]<br>"

			if(stored_mind)
				output += span_bold("Store in Soulcatcher: ") + "\[<a href='byond://?src=\ref[src];target=\ref[H];mindput=1'>Perform</a>\]<br>"

	to_chat(user,output)

/obj/item/sleevemate/Topic(href, href_list)
	usr.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	//Sanity checking/href-hacking checking
	if(usr.get_active_hand() != src)
		to_chat(usr,span_warning("You're not holding \the [src]."))
		return

	var/target_ref = href_list["target"]
	var/mob/living/target = locate(target_ref) in mob_list
	if(!target)
		to_chat(usr,span_warning("Unable to operate on that target."))
		return

	if(!usr.Adjacent(target))
		to_chat(usr,span_warning("You are too far from that target."))
		return

	//The actual options
	if(href_list["mindscan"])
		if(!target.mind || (target.mind.name in prevent_respawns))
			to_chat(usr,span_warning("Target seems totally braindead."))
			return

		var/nif
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			nif = H.nif
			persist_nif_data(H)

		usr.visible_message("[usr] begins scanning [target]'s mind.",span_notice("You begin scanning [target]'s mind."))
		if(do_after(usr,8 SECONDS,target))
			our_db.m_backup(target.mind,nif,one_time = TRUE)
			to_chat(usr,span_notice("Mind backed up!"))
		else
			to_chat(usr,span_warning("You must remain close to your target!"))

		return

	if(href_list["bodyscan"])
		if(!ishuman(target))
			to_chat(usr,span_warning("Target is not of an acceeptable body type."))
			return

		var/mob/living/carbon/human/H = target

		usr.visible_message("[usr] begins scanning [target]'s body.",span_notice("You begin scanning [target]'s body."))
		if(do_after(usr,8 SECONDS,target))
			var/datum/transhuman/body_record/BR = new()
			BR.init_from_mob(H, TRUE, TRUE, database_key = db_key)
			to_chat(usr,span_notice("Body scanned!"))
		else
			to_chat(usr,span_warning("You must remain close to your target!"))

		return

	if(href_list["mindsteal"])
		if(!target.mind || (target.mind.name in prevent_respawns))
			to_chat(usr,span_warning("Target seems totally braindead."))
			return

		if(stored_mind)
			to_chat(usr,span_warning("There is already someone's mind stored inside"))
			return

		var/choice = tgui_alert(usr,"This will remove the target's mind from their body (and from the game as long as they're in the sleevemate). You can put them into a (mindless) body, a NIF, or back them up for normal resleeving, but you should probably have a plan in advance so you don't leave them unable to interact for too long. Continue?","Confirmation",list("Continue","Cancel"))
		if(choice == "Continue" && usr.get_active_hand() == src && usr.Adjacent(target))

			usr.visible_message(span_warning("[usr] begins downloading [target]'s mind!"),span_notice("You begin downloading [target]'s mind!"))
			if(do_after(usr,35 SECONDS,target)) //This is powerful, yo.
				if(!stored_mind && target.mind)
					get_mind(target)
					to_chat(usr,span_notice("Mind downloaded!"))

		return

	if(href_list["mindput"])
		if(!stored_mind)
			to_chat(usr,span_warning("\The [src] no longer has a stored mind."))
			return

		var/mob/living/carbon/human/H = target

		if(!istype(target))
			return //href hacking only

		if(!H.nif)
			return //Lost it? or href hacking

		var/datum/nifsoft/soulcatcher/SC = H.nif.imp_check(NIF_SOULCATCHER)
		if(!SC)
			return //Uninstalled it?

		//Lazzzyyy.
		if(!sleevemate_mob)
			sleevemate_mob = new()

		put_mind(sleevemate_mob)
		SC.catch_mob(sleevemate_mob)
		to_chat(usr,span_notice("Mind transferred into Soulcatcher!"))

	if(href_list["mindupload"])
		if(!stored_mind)
			to_chat(usr,span_warning("\The [src] no longer has a stored mind."))
			return

		if(!istype(target))
			return

		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			if(H.resleeve_lock && stored_mind.loaded_from_ckey != H.resleeve_lock)
				to_chat(usr,span_warning("\The [H] is protected from impersonation!"))
				return

		usr.visible_message(span_warning("[usr] begins uploading someone's mind into [target]!"),span_notice("You begin uploading a mind into [target]!"))
		if(do_after(usr,35 SECONDS,target))
			if(!stored_mind)
				to_chat(usr,span_warning("\The [src] no longer has a stored mind."))
				return
			put_mind(target)
			to_chat(usr,span_notice("Mind transferred into [target]!"))

	if(href_list["mindrelease"])
		if(stored_mind)
			to_chat(usr,span_warning("There is already someone's mind stored inside"))
			return
		var/mob/living/carbon/human/H = target
		var/datum/nifsoft/soulcatcher/SC = H.nif.imp_check(NIF_SOULCATCHER)
		if(!SC)
			return
		for(var/mob/living/carbon/brain/caught_soul/soul in SC.brainmobs)
			if(soul.name == href_list["mindrelease"])
				get_mind(soul)
				qdel(soul)
				to_chat(usr,span_notice("Mind downloaded!"))
				return
		to_chat(usr,span_notice("Unable to find that mind in Soulcatcher!"))

/obj/item/sleevemate/update_icon()
	if(stored_mind)
		icon_state = "[initial(icon_state)]_on"
	else
		icon_state = initial(icon_state)

/obj/item/sleevemate/emag_act(var/remaining_charges, var/mob/user)
	to_chat(user,span_danger("You hack [src]!"))
	var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
	spark_system.set_up(5, 0, src.loc)
	spark_system.start()
	playsound(src, "sparks", 50, 1)
	if(isliving(src.loc))
		var/mob/living/L = src.loc
		L.unEquip(src)
	src.forceMove(get_turf(src))
	new /obj/item/bodysnatcher(src.loc)
	qdel(src)
	return 1
