/mob/living/verb/toggle_autowhisper()
	set name = "Autowhisper Toggle"
	set desc = "Toggle whether you will automatically whisper/subtle"
	set category = "IC.Settings"

	autowhisper = !autowhisper
	if(autowhisper_display)
		autowhisper_display.icon_state = "[autowhisper ? "autowhisper1" : "autowhisper"]"

	if(autowhisper_mode == "Psay/Pme")
		if(isbelly(loc) && absorbed)
			var/obj/belly/b = loc
			if(b.mode_flags & DM_FLAG_FORCEPSAY)
				var/mes = "but you are affected by forced psay right now, so you will automatically use psay/pme instead of any other option."
				to_chat(src, span_notice("autowhisper [autowhisper ? "enabled, [mes]" : "disabled, [mes]"]."))
				return
		else
			forced_psay = autowhisper
			balloon_alert(src, "autowhisper [autowhisper ? "enabled, using psay/pme" : "disabled"]")
	else
		balloon_alert(src, "autowhisper [autowhisper ? "enabled" : "disabled"]")

/mob/living/verb/autowhisper_mode()
	set name = "Autowhisper Mode"
	set desc = "Set the mode your emotes will default to while using Autowhisper"
	set category = "IC.Settings"


	var/choice = tgui_input_list(src, "Select Custom Subtle Mode", "Custom Subtle Mode", list("Adjacent Turfs (Default)", "My Turf", "My Table", "Current Belly (Prey)", "Specific Belly (Pred)", "Specific Person", "Psay/Pme"))
	if(!choice || choice == "Adjacent Turfs (Default)")
		autowhisper_mode = null
		balloon_alert(src, "subtles returned to default setting")
		return
	if(choice == "Psay/Pme")
		if(autowhisper)
			if(isbelly(loc) && absorbed)
				var/obj/belly/b = loc
				if(b.mode_flags & DM_FLAG_FORCEPSAY)
					to_chat(src, span_warning("You can't set that mode right now, as you appear to be absorbed in a belly using forced psay!"))
					return
			forced_psay = TRUE
			to_chat(src, span_notice("As a note, this option will only work if you are in a situation where you can send psay/pme messages! Otherwise it will work as default whisper/subtle."))
	autowhisper_mode = choice
	balloon_alert(src, "subtles set to [autowhisper_mode]")
