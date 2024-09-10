/mob/living/silicon/ai/examine(mob/user)
	. = ..()

	if (src.stat == DEAD)
		. += "<span class='deadsay'>It appears to be powered-down.</span>"
	else
		if (src.getBruteLoss())
			if (src.getBruteLoss() < 30)
				. += "<span class='warning'>It looks slightly dented.</span>"
			else
				. += "<span class='warning'><B>It looks severely dented!</B></span>"
		if (src.getFireLoss())
			if (src.getFireLoss() < 30)
				. += "<span class='warning'>It looks slightly charred.</span>"
			else
				. += "<span class='warning'><B>Its casing is melted and heat-warped!</B></span>"
		if (src.getOxyLoss() && (aiRestorePowerRoutine != 0 && !APU_power))
			if (src.getOxyLoss() > 175)
				. += "<span class='warning'><B>It seems to be running on backup power. Its display is blinking a \"BACKUP POWER CRITICAL\" warning.</B></span>"
			else if(src.getOxyLoss() > 100)
				. += "<span class='warning'><B>It seems to be running on backup power. Its display is blinking a \"BACKUP POWER LOW\" warning.</B></span>"
			else
				. += "<span class='warning'>It seems to be running on backup power.</span>"

		if (src.stat == UNCONSCIOUS)
			. += "<span class='warning'>It is non-responsive and displaying the text: \"RUNTIME: Sensory Overload, stack 26/3\".</span>"

		if(deployed_shell)
			. += "The wireless networking light is blinking."

	. += ""

	if(hardware && (hardware.owner == src))
		. += hardware.get_examine_desc()

	user.showLaws(src)

/mob/proc/showLaws(var/mob/living/silicon/S)
	return

/mob/observer/dead/showLaws(var/mob/living/silicon/S)
	if(antagHUD || is_admin(src))
		S.laws.show_laws(src)
