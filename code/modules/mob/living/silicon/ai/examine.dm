/mob/living/silicon/ai/examine(mob/user)
	. = ..()

	if (src.stat == DEAD)
		. += span_deadsay("It appears to be powered-down.")
	else
		if (src.getBruteLoss())
			if (src.getBruteLoss() < 30)
				. += span_warning("It looks slightly dented.")
			else
				. += span_boldwarning("It looks severely dented!")
		if (src.getFireLoss())
			if (src.getFireLoss() < 30)
				. += span_warning("It looks slightly charred.")
			else
				. += span_boldwarning("Its casing is melted and heat-warped!")
		if (src.getOxyLoss() && (aiRestorePowerRoutine != 0 && !APU_power))
			if (src.getOxyLoss() > 175)
				. += span_boldwarning("It seems to be running on backup power. Its display is blinking a \"BACKUP POWER CRITICAL\" warning.")
			else if(src.getOxyLoss() > 100)
				. += span_boldwarning("It seems to be running on backup power. Its display is blinking a \"BACKUP POWER LOW\" warning.")
			else
				. += span_warning("It seems to be running on backup power.")

		if (src.stat == UNCONSCIOUS)
			. += span_warning("It is non-responsive and displaying the text: \"RUNTIME: Sensory Overload, stack 26/3\".")

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
