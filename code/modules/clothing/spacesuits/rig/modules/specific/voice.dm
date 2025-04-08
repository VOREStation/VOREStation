/obj/item/rig_module/voice

	name = "hardsuit voice synthesiser"
	desc = "A speaker box and sound processor."
	icon_state = "megaphone"
	usable = 1
	selectable = 0
	toggleable = 0
	disruptive = 0

	engage_string = "Configure Synthesiser"

	interface_name = "voice synthesiser"
	interface_desc = "A flexible and powerful voice modulator system."

	var/obj/item/voice_changer/voice_holder

/obj/item/rig_module/voice/Initialize(mapload)
	. = ..()
	voice_holder = new(src)
	voice_holder.active = 0

/obj/item/rig_module/voice/installed()
	..()
	holder.speech = src

/obj/item/rig_module/voice/engage()

	if(!..())
		return 0

	var/choice = tgui_alert(usr, "Would you like to toggle the synthesiser or set the name?","",list("Enable","Disable","Set Name","Cancel"))

	if(!choice || choice == "Cancel")
		return 0

	switch(choice)
		if("Enable")
			active = 1
			voice_holder.active = 1
			to_chat(usr, span_blue("You enable the speech synthesiser."))
		if("Disable")
			active = 0
			voice_holder.active = 0
			to_chat(usr, span_blue("You disable the speech synthesiser."))
		if("Set Name")
			var/raw_choice = sanitize(tgui_input_text(usr, "Please enter a new name.", voice_holder.voice, MAX_NAME_LEN))
			if(!raw_choice)
				return 0
			voice_holder.voice = raw_choice
			to_chat(usr, span_blue("You are now mimicking <B>[voice_holder.voice]</B>."))
	return 1
