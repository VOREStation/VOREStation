/mob/living/verb/toggle_autowhisper()
	set name = "Toggle Autowhisper"
	set desc = "Toggle whether you will automatically whisper/subtle"
	set category = "IC"

	autowhisper = !autowhisper
	if(autowhisper_mode == "Psay/Pme")
		if(isbelly(loc) && absorbed)
			var/obj/belly/b = loc
			if(b.mode_flags & DM_FLAG_FORCEPSAY)
				var/mes = "but you are affected by forced psay right now, so you will automatically use psay/pme instead of any other option."
				to_chat(src, "<span class='notice'>Autowhisper has been [autowhisper ? "enabled, [mes]" : "disabled, [mes]"].</span>")
				return
		else
			forced_psay = autowhisper
			to_chat(src, "<span class='notice'>Autowhisper has been [autowhisper ? "enabled. You will now automatically psay/pme when using say/me. As a note, this option will only work if you are in a situation where you can send psay/pme messages! Otherwise it will work as default whisper/subtle" : "disabled"].</span>")

	else
		to_chat(src, "<span class='notice'>Autowhisper has been [autowhisper ? "enabled. You will now automatically whisper/subtle when using say/me" : "disabled"].</span>")

/mob/living/verb/autowhisper_mode()
	set name = "Set Autosubtle Mode"
	set desc = "Set the mode your emotes will default to while using Autowhisper"
	set category = "IC"


	var/choice = tgui_input_list(src, "Select Custom Subtle Mode", "Custom Subtle Mode", list("Adjacent Turfs (Default)", "My Turf", "My Table", "Current Belly (Prey)", "Specific Belly (Pred)", "Specific Person", "Psay/Pme"))
	if(!choice || choice == "Adjacent Turfs (Default)")
		autowhisper_mode = null
		to_chat(src, "<span class='notice'>Your subtles have returned to the default setting.</span>")
		return
	if(choice == "Psay/Pme")
		if(autowhisper)
			if(isbelly(loc) && absorbed)
				var/obj/belly/b = loc
				if(b.mode_flags & DM_FLAG_FORCEPSAY)
					to_chat(src, "<span class='warning'>You can't set that mode right now, as you appear to be absorbed in a belly using forced psay!</span>")
					return
			forced_psay = TRUE
			to_chat(src, "<span class='notice'>As a note, this option will only work if you are in a situation where you can send psay/pme messages! Otherwise it will work as default whisper/subtle.</span>")
	autowhisper_mode = choice
	to_chat(src, "<span class='notice'>Your subtles have been set to <b>[autowhisper_mode]</b>.</span>")
