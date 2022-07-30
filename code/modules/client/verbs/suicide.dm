/mob/var/suiciding = 0

/mob/living/carbon/human/verb/suicide() /// At best, useful for admins to see if it's being called.
	set hidden = 1

	if (stat == DEAD)
		to_chat(src, "You're already dead!")
		return

	if (!ticker)
		to_chat(src, "You can't commit suicide before the game starts!")
		return

	to_chat(src, "<span class='warning'>No. Adminhelp if there is a legitimate reason, and please review our server rules.</span>")
	message_admins("[ckey] has tried to trigger the suicide verb as human, but it is currently disabled.")

/mob/living/carbon/brain/verb/suicide()
	set hidden = 1

	if (stat == 2)
		to_chat(src, "You're already dead!")
		return

	if (!ticker)
		to_chat(src, "You can't commit suicide before the game starts!")
		return

	if (suiciding)
		to_chat(src, "You're already committing suicide! Be patient!")
		return

	var/confirm = tgui_alert(usr, "Are you sure you want to commit suicide?", "Confirm Suicide", list("Yes", "No"))

	if(confirm == "Yes")
		suiciding = 1
		to_chat(viewers(loc),"<span class='danger'>[src]'s brain is growing dull and lifeless. It looks like it's lost the will to live.</span>")
		spawn(50)
			death(0)
			suiciding = 0

/mob/living/silicon/ai/verb/suicide()
	set hidden = 1

	if (stat == 2)
		to_chat(src, "You're already dead!")
		return

	if (suiciding)
		to_chat(src, "You're already committing suicide! Be patient!")
		return

	var/confirm = tgui_alert(usr, "Are you sure you want to commit suicide?", "Confirm Suicide", list("Yes", "No"))

	if(confirm == "Yes")
		suiciding = 1
		to_chat(viewers(src),"<span class='danger'>[src] is powering down. It looks like they're trying to commit suicide.</span>")
		//put em at -175
		adjustOxyLoss(max(getMaxHealth() * 2 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		updatehealth()

/mob/living/silicon/robot/verb/suicide()
	set hidden = 1

	if (stat == 2)
		to_chat(src, "You're already dead!")
		return

	if (suiciding)
		to_chat(src, "You're already committing suicide! Be patient!")
		return

	var/confirm = tgui_alert(usr, "Are you sure you want to commit suicide?", "Confirm Suicide", list("Yes", "No"))

	if(confirm == "Yes")
		suiciding = 1
		to_chat(viewers(src),"<span class='danger'>[src] is powering down. It looks like they're trying to commit suicide.</span>")
		//put em at -175
		adjustOxyLoss(max(getMaxHealth() * 2 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		updatehealth()

/*
/mob/living/silicon/pai/verb/suicide()
	set category = "pAI Commands"
	set desc = "Kill yourself and become a ghost (You will receive a confirmation prompt)"
	set name = "pAI Suicide"
	var/answer = tgui_alert(usr, "REALLY kill yourself? This action can't be undone.", "Suicide", list("Yes","No"))
	if(answer == "Yes")
		var/obj/item/paicard/card = loc
		card.removePersonality()
		var/turf/T = get_turf_or_move(card.loc)
		for (var/mob/M in viewers(T))
			M.show_message("<span class='notice'>[src] flashes a message across its screen, \"Wiping core files. Please acquire a new personality to continue using pAI device functions.\"</span>", 3, "<span class='notice'>[src] bleeps electronically.</span>", 2)
		death(0)
	else
		to_chat(src, "Aborting suicide attempt.")
*/
