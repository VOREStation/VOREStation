/datum/power/changeling/fakedeath
	name = "Regenerative Stasis"
	desc = "We become weakened to a death-like state, where we will rise again from death."
	helptext = "Can be used before or after death. Duration varies greatly."
	ability_icon_state = "ling_regenerative_stasis"
	genomecost = 0
	allowduringlesserform = 1
	verbpath = /mob/proc/changeling_fakedeath

//Fake our own death and fully heal. You will appear to be dead but regenerate fully after a short delay.
/mob/proc/changeling_fakedeath()
	set category = "Changeling"
	set name = "Regenerative Stasis (20)"

	var/datum/changeling/changeling = changeling_power(CHANGELING_STASIS_COST,1,100,DEAD)
	if(!changeling)
		return

	var/mob/living/carbon/C = src

	if(changeling.max_geneticpoints < 0) //Absorbed by another ling
		to_chat(src, span_danger("We have no genomes, not even our own, and cannot regenerate."))
		return 0

	if(!C.stat && tgui_alert(src, "Are we sure we wish to regenerate? We will appear to be dead while doing so.","Revival",list("Yes","No")) != "Yes")
		return
	to_chat(C, span_notice("We will attempt to regenerate our form."))

	C.update_canmove()
	C.remove_changeling_powers()
	changeling.chem_charges -= CHANGELING_STASIS_COST

	if(C.suiciding)
		C.suiciding = 0

	if(C.does_not_breathe)
		C.does_not_breathe = 0	//This means they don't autoheal the oxy damage from the next step

	if(C.stat != DEAD)
		C.adjustOxyLoss(C.maxHealth * 2)

	C.forbid_seeing_deadchat = TRUE

	spawn(rand(2 MINUTES, 4 MINUTES))
		//The ling will now be able to choose when to revive
		add_verb(src, /mob/proc/changeling_revive)

		new /obj/changeling_revive_holder(src)

		to_chat(src, span_notice("<font size='5'>We are ready to rise.  Use the <b>Revive</b> verb when you are ready.</font>"))

	feedback_add_details("changeling_powers","FD")
	return 1
