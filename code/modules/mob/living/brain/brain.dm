<<<<<<< HEAD:code/modules/mob/living/carbon/brain/brain.dm
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
	return ..()

/mob/living/carbon/brain/say_understands(var/other)//Goddamn is this hackish, but this say code is so odd
	if(istype(container, /obj/item/device/mmi))
		if(issilicon(other))
			return TRUE
	if(ishuman(other))
		return TRUE
	if(isslime(other))
		return TRUE
	return ..()

/mob/living/carbon/brain/update_canmove()
	if(in_contents_of(/obj/mecha) || istype(loc, /obj/item/device/mmi))
		canmove = 1
		use_me = 1
	else
		canmove = 0
	return canmove

/mob/living/carbon/brain/isSynthetic()
	return istype(loc, /obj/item/device/mmi)

/mob/living/carbon/brain/runechat_holder(datum/chatmessage/CM)
	if(isturf(loc))
		return ..()
		
	return loc

/mob/living/carbon/brain/set_typing_indicator(var/state)
	if(isturf(loc))
		return ..()

	if(!is_preference_enabled(/datum/client_preference/show_typing_indicator))
		loc.cut_overlay(typing_indicator, TRUE)
		return

	if(!typing_indicator)
		init_typing_indicator("[speech_bubble_appearance()]_typing")

	if(state && !typing)
		loc.add_overlay(typing_indicator, TRUE)
		typing = TRUE
	else if(typing)
		loc.cut_overlay(typing_indicator, TRUE)
		typing = FALSE

	return state

// Vorestation edit start

/mob/living/carbon/brain/verb/backup_ping()
	set category = "IC"
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
				to_chat(src, "<span class='notice'>New notification has been sent.</span>")
			else
				to_chat(src, "<span class='warning'>Your backup is not past-due yet.</span>")
		else if((world.time - record.last_notification) < 5 MINUTES)
			to_chat(src, "<span class='warning'>Too little time has passed since your last notification.</span>")
		else
			db.notify(record)
			record.last_notification = world.time
			to_chat(src, "<span class='notice'>New notification has been sent.</span>")
	else
		to_chat(src,"<span class='warning'>No backup record could be found, sorry.</span>")

// VS edit ends
=======
/mob/living/carbon/brain
	var/obj/item/container = null
	var/timeofhostdeath = 0
	var/emp_damage = FALSE // Handles a type of MMI damage
	var/alert = null
	use_me = FALSE // Can't use the me verb, it's a freaking immobile brain
	icon = 'icons/obj/surgery.dmi'
	icon_state = "brain1"

/mob/living/carbon/brain/Initialize()
	. = ..()
	default_language = GLOB.all_languages[LANGUAGE_GALCOM]

/mob/living/carbon/brain/Destroy()
	if(key)              //If there is a mob connected to this thing. Have to check key twice to avoid false death reporting.
		if(stat != DEAD) //If not dead.
			death(1)     //Brains can die again. AND THEY SHOULD AHA HA HA HA HA HA
		ghostize()       //Ghostize checks for key so nothing else is necessary.
	return ..()

/mob/living/carbon/brain/say_understands(var/other)//Goddamn is this hackish, but this say code is so odd
	return ishuman(other) || isslime(other) || (istype(container, /obj/item/mmi) && issilicon(other)) || ..()

/mob/living/carbon/brain/update_canmove()
	if(in_contents_of(/obj/mecha) || istype(container, /obj/item/mmi))
		canmove = TRUE
		use_me = TRUE
	else
		canmove = FALSE
	return canmove

/mob/living/carbon/brain/isSynthetic()
	return istype(container, /obj/item/mmi)

/mob/living/carbon/brain/set_typing_indicator(var/state)
	if(isturf(loc))
		return ..()

	if(!is_preference_enabled(/datum/client_preference/show_typing_indicator))
		loc.cut_overlay(typing_indicator, TRUE)
		return

	if(!typing_indicator)
		init_typing_indicator("[speech_bubble_appearance()]_typing")

	if(state && !typing)
		loc.add_overlay(typing_indicator, TRUE)
		typing = TRUE
	else if(typing)
		loc.cut_overlay(typing_indicator, TRUE)
		typing = FALSE

	return state
>>>>>>> f1e82ef21af... Merge pull request #8561 from Atermonera/remove_carbonmob_dependencies:code/modules/mob/living/brain/brain.dm
