//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/mob/living/carbon/brain
	var/obj/item/container = null
	var/timeofhostdeath = 0
	var/emp_damage = 0//Handles a type of MMI damage
	var/alert = null
	use_me = 0 //Can't use the me verb, it's a freaking immobile brain
	icon = 'icons/obj/surgery.dmi'
	icon_state = "brain1"
	no_vore = TRUE //VOREStation Edit - PLEASE. lol.

/mob/living/carbon/brain/Initialize()
	. = ..()
	var/datum/reagents/R = new/datum/reagents(1000)
	reagents = R
	R.my_atom = src
	default_language = GLOB.all_languages[LANGUAGE_GALCOM]

/mob/living/carbon/brain/Destroy()
	if(key)				//If there is a mob connected to this thing. Have to check key twice to avoid false death reporting.
		if(stat != DEAD)	//If not dead.
			death(1)	//Brains can die again. AND THEY SHOULD AHA HA HA HA HA HA
		ghostize()		//Ghostize checks for key so nothing else is necessary.
	qdel(dna)
	return ..()

/mob/living/carbon/brain/say_understands(var/other)//Goddamn is this hackish, but this say code is so odd
	if(istype(container, /obj/item/mmi))
		if(issilicon(other))
			return TRUE
	if(ishuman(other))
		return TRUE
	if(isslime(other))
		return TRUE
	return ..()

/mob/living/carbon/brain/update_canmove()
	if(in_contents_of(/obj/mecha) || istype(loc, /obj/item/mmi))
		canmove = 1
		use_me = 1
	else
		canmove = 0
	return canmove

/mob/living/carbon/brain/isSynthetic()
	return istype(loc, /obj/item/mmi)

/mob/living/carbon/brain/runechat_holder(datum/chatmessage/CM)
	if(isturf(loc))
		return ..()

	return loc

// Vorestation edit start

/mob/living/carbon/brain/verb/backup_ping()
	set category = "IC.Game"
	set name = "Notify Transcore"
	set desc = "Your body is gone. Notify robotics to be resleeved!"
	var/datum/transcore_db/db = SStranscore.db_by_mind_name(mind.name)
	if(db)
		var/datum/transhuman/mind_record/record = db.backed_up[src.mind.name]
		if(!(record.dead_state == MR_DEAD))
			if((world.time - timeofhostdeath ) > 5 MINUTES)	//Allows notify transcore to be used if you have an entry but for some reason weren't marked as dead
				record.dead_state = MR_DEAD				//Such as if you got scanned but didn't take an implant. It's a little funky, but I mean, you got scanned
				db.notify(record)						//So you probably will want to let someone know if you die.
				record.last_notification = world.time
				to_chat(src, span_notice("New notification has been sent."))
			else
				to_chat(src, span_warning("Your backup is not past-due yet."))
		else if((world.time - record.last_notification) < 5 MINUTES)
			to_chat(src, span_warning("Too little time has passed since your last notification."))
		else
			db.notify(record)
			record.last_notification = world.time
			to_chat(src, span_notice("New notification has been sent."))
	else
		to_chat(src,span_warning("No backup record could be found, sorry."))

// VS edit ends
