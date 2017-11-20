var/global/mob/living/carbon/human/dummy/mannequin/sleevemate_mob

//SleeveMate!
/obj/item/device/sleevemate
	name = "\improper SleeveMate 3200"
	desc = "A hand-held sleeve management tool for performing one-time backups and managing mindstates."
	icon = 'icons/obj/device_alt.dmi'
	icon_state = "sleevemate"
	item_state = "healthanalyzer"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	throwforce = 3
	w_class = ITEMSIZE_SMALL
	throw_speed = 5
	throw_range = 10
	matter = list(DEFAULT_WALL_MATERIAL = 200)
	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)

	var/datum/mind/stored_mind

/obj/item/device/sleevemate/attack(mob/living/M, mob/living/user)
	if(ishuman(M))
		scan_mob(M, user)
	else
		to_chat(user,"<span class='warning'>Not a compatible subject to work with!</span>")

/obj/item/device/sleevemate/attack_self(mob/living/user)
	if(!stored_mind)
		to_chat(user,"<span class='warning'>No stored mind in \the [src].</span>")
		return

	var/choice = alert(user,"What would you like to do?","Stored: [stored_mind.name]","Delete","Backup","Cancel")
	if(!stored_mind || user.get_active_hand() != src)
		return
	switch(choice)
		if("Delete")
			to_chat(user,"<span class='notice'>Internal copy of [stored_mind.name] deleted.</span>")
			stored_mind = null
			update_icon()
		if("Backup")
			to_chat(user,"<span class='notice'>Internal copy of [stored_mind.name] backed up to database.</span>")
			SStranscore.m_backup(stored_mind,null,one_time = TRUE)
		if("Cancel")
			return

/obj/item/device/sleevemate/proc/scan_mob(mob/living/carbon/human/H, mob/living/user)
	var/output = ""

	output += "<br><br><span class='notice'><b>[src.name] Scan Results</b></span><br>"

	//Mind name
	output += "<b>Sleeved Mind:</b> "
	if(H.mind)
		output += "[H.mind.name]<br>"
	else
		output += "<span class='warning'>Unknown/None</span><br>"

	//Mind status
	output += "<b>Mind Status:</b> "
	if(H.client)
		output += "Healthy<br>"
	else
		output += "Space Sleep Disorder<br>"

	//Body status
	output += "<b>Sleeve Status:</b> "
	switch(H.stat)
		if(CONSCIOUS)
			output += "Alive<br>"
		if(UNCONSCIOUS)
			output += "Unconscious<br>"
		if(DEAD)
			output += "<span class='warning'>Deceased</span><br>"
		else
			output += "<span class='warning'>Unknown</span><br>"

	//Mind/body comparison
	output += "<b>Sleeve Pair:</b> "
	if(H.mind && ckey(H.mind.key) != H.ckey)
		output += "<span class='warning'>May not be correct body</span><br>"
	else if(H.mind && ckey(H.mind.key) == H.ckey)
		output += "Appears to be correct mind in body<br>"
	else
		output += "Unable to perform comparison<br>"

	//Actions
	output += "<br><b>-- Possible Actions --</b><br>"
	output += "<b>Mind-Scan (One Time): </b>\[<a href='?src=\ref[src];target=\ref[H];mindscan=1'>Perform</a>\]<br>"
	output += "<b>Body-Scan (One Time): </b>\[<a href='?src=\ref[src];target=\ref[H];bodyscan=1'>Perform</a>\]<br>"

	//Saving a mind
	output += "<b>Store Full Mind: </b>"
	if(stored_mind)
		output += "<span class='notice'>Already Stored</span> ([stored_mind.name])<br>"
	else if(H.mind)
		output += "\[<a href='?src=\ref[src];target=\ref[H];mindsteal=1'>Perform</a>\]<br>"
	else
		output += "<span class='warning'>Unable</span><br>"

	//Soulcatcher transfer
	if(stored_mind && H.nif)
		var/datum/nifsoft/soulcatcher/SC = H.nif.imp_check(NIF_SOULCATCHER)
		if(SC)
			output += "<b>Store in Soulcatcher: </b>\[<a href='?src=\ref[src];target=\ref[H];mindput=1'>Perform</a>\]<br>"

	to_chat(user,output)

/obj/item/device/sleevemate/Topic(href, href_list)
	usr.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	//Sanity checking/href-hacking checking
	if(usr.get_active_hand() != src)
		to_chat(usr,"<span class='warning'>You're not holding \the [src].</span>")
		return

	var/target_ref = href_list["target"]
	var/mob/living/target = locate(target_ref) in mob_list
	if(!target)
		to_chat(usr,"<span class='warning'>Unable to operate on that target.</span>")
		return

	if(!usr.Adjacent(target))
		to_chat(usr,"<span class='warning'>You are too far from that target.</span>")
		return

	//The actual options
	if(href_list["mindscan"])
		if(!target.mind || target.mind.name in prevent_respawns)
			to_chat(usr,"<span class='warning'>Target seems totally braindead.</span>")
			return

		var/nif
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			nif = H.nif
			persist_nif_data(H)

		usr.visible_message("[usr] begins scanning [target]'s mind.","<span class='notice'>You begin scanning [target]'s mind.</span>")
		if(do_after(usr,8 SECONDS,target))
			SStranscore.m_backup(target.mind,nif,one_time = TRUE)
			to_chat(usr,"<span class='notice'>Mind backed up!</span>")
		else
			to_chat(usr,"<span class='warning'>You must remain close to your target!</span>")

		return

	if(href_list["bodyscan"])
		if(!ishuman(target))
			to_chat(usr,"<span class='warning'>Target is not of an acceeptable body type.</span>")
			return

		var/mob/living/carbon/human/H = target

		usr.visible_message("[usr] begins scanning [target]'s body.","<span class='notice'>You begin scanning [target]'s body.</span>")
		if(do_after(usr,8 SECONDS,target))
			var/datum/transhuman/body_record/BR = new()
			BR.init_from_mob(H, TRUE, TRUE)
			to_chat(usr,"<span class='notice'>Body scanned!</span>")
		else
			to_chat(usr,"<span class='warning'>You must remain close to your target!</span>")

		return

	if(href_list["mindsteal"])
		if(!target.mind || target.mind.name in prevent_respawns)
			to_chat(usr,"<span class='warning'>Target seems totally braindead.</span>")
			return

		var/choice = alert(usr,"This will remove the target's mind from their body. The only way to put it back is via a resleeving pod. Continue?","Confirmation","Continue","Cancel")
		if(choice == "Continue" && usr.get_active_hand() == src && usr.Adjacent(target))

			usr.visible_message("<span class='warning'>[usr] begins downloading [target]'s mind!</span>","<span class='notice'>You begin downloading [target]'s mind!</span>")
			if(do_after(usr,35 SECONDS,target)) //This is powerful, yo.
				if(!stored_mind && target.mind)
					stored_mind = target.mind
					target.ghostize()
					stored_mind.current = null
					update_icon()
					to_chat(usr,"<span class='notice'>Mind downloaded!</span>")

		return

	if(href_list["mindput"])
		if(!stored_mind)
			to_chat(usr,"<span class='warning'>\The [src] no longer has a stored mind.</span>")
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

		stored_mind.active = TRUE //Setting this causes transfer_to, to key them into the mob
		stored_mind.transfer_to(sleevemate_mob)
		SC.catch_mob(sleevemate_mob)
		stored_mind = null
		to_chat(usr,"<span class='notice'>Mind transferred into Soulcatcher!</span>")
		update_icon()

/obj/item/device/sleevemate/update_icon()
	if(stored_mind)
		icon_state = "[initial(icon_state)]_on"
	else
		icon_state = initial(icon_state)
