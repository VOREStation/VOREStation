/obj/machinery/computer/aifixer
	name = "\improper AI system integrity restorer"
	desc = "Used with intelliCards containing nonfunctional AIs to restore them to working order."
	req_one_access = list(access_robotics, access_heads)
	circuit = /obj/item/weapon/circuitboard/aifixer
	icon_keyboard = "tech_key"
	icon_screen = "ai-fixer"
	light_color = LIGHT_COLOR_PINK

	active_power_usage = 1000

	/// Variable containing transferred AI
	var/mob/living/silicon/ai/occupier
	/// Variable dictating if we are in the process of restoring the occupier AI
	var/restoring = FALSE

/obj/machinery/computer/aifixer/attackby(obj/item/I, mob/living/user)
	if(I.has_tool_quality(TOOL_SCREWDRIVER))
		if(occupier)
			if(stat & (NOPOWER|BROKEN))
				to_chat(user, "<span class='warning'>The screws on [name]'s screen won't budge.</span>")
			else
				to_chat(user, "<span class='warning'>The screws on [name]'s screen won't budge and it emits a warning beep.</span>")
			return
	if(istype(I, /obj/item/device/aicard))
		if(stat & (NOPOWER|BROKEN))
			to_chat(user, "<span class='warning'>This terminal isn't functioning right now.</span>")
			return
		if(restoring)
			to_chat(user, "<span class='danger'>Terminal is busy restoring [occupier] right now.</span>")
			return

		var/obj/item/device/aicard/card = I
		if(occupier)
			if(card.grab_ai(occupier, user))
				occupier = null
		else if(card.carded_ai)
			var/mob/living/silicon/ai/new_occupant = card.carded_ai
			to_chat(new_occupant, "<span class='notice'>You have been transferred into a stationary terminal. Sadly there is no remote access from here.</span>")
			to_chat(user, "<span class='notice'>Transfer Successful:</span> [new_occupant] placed within stationary terminal.")
			new_occupant.forceMove(src)
			new_occupant.cancel_camera()
			new_occupant.control_disabled = TRUE
			occupier = new_occupant
			card.clear()
			update_icon()
		else
			to_chat(user, "<span class='notice'>There is no AI loaded onto this computer, and no AI loaded onto [I]. What exactly are you trying to do here?</span>")
	return ..()

/obj/machinery/computer/aifixer/attack_hand(mob/user)
	if(stat & (NOPOWER|BROKEN))
		return
	tgui_interact(user)

/obj/machinery/computer/aifixer/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AiRestorer", name)
		ui.open()

/obj/machinery/computer/aifixer/tgui_data(mob/user)
	var/list/data = list()

	data["ejectable"] = FALSE
	data["AI_present"] = FALSE
	data["error"] = null
	if(!occupier)
		data["error"] = "Please transfer an AI unit."
	else
		data["AI_present"] = TRUE
		data["name"] = occupier.name
		data["restoring"] = restoring
		data["health"] = (occupier.health + 100) / 2
		data["isDead"] = occupier.stat == DEAD
		var/list/laws = list()
		for(var/datum/ai_law/law in occupier.laws.all_laws())
			laws += "[law.get_index()]: [law.law]"
		data["laws"] = laws

	return data

/obj/machinery/computer/aifixer/tgui_act(action, params)
	if(..())
		return TRUE
	if(!occupier)
		restoring = FALSE

	if(action)
		playsound(src, "terminal_type", 50, 1)

	switch(action)
		if("PRG_beginReconstruction")
			if(occupier?.health < 100)
				to_chat(usr, "<span class='notice'>Reconstruction in progress. This will take several minutes.</span>")
				playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 25, FALSE)
				restoring = TRUE
				var/mob/observer/dead/ghost = occupier.get_ghost()
				if(ghost)
					ghost.notify_revive("Your core files are being restored!", source = src)
				. = TRUE

/obj/machinery/computer/aifixer/proc/Fix()
	use_power(active_power_usage)
	occupier.adjustOxyLoss(-5, 0, FALSE)
	occupier.adjustFireLoss(-5, 0, FALSE)
	occupier.adjustBruteLoss(-5, 0)
	if(occupier.health >= 0 && occupier.stat == DEAD)
		occupier.revive()

	return occupier.health < 100

/obj/machinery/computer/aifixer/process()
	if(..())
		if(restoring)
			var/oldstat = occupier.stat
			restoring = Fix()
			if(oldstat != occupier.stat)
				update_icon()

/obj/machinery/computer/aifixer/update_icon()
	. = ..()
	if(stat & (NOPOWER|BROKEN))
		return

	if(restoring)
		. += "ai-fixer-on"
	if (occupier)
		switch (occupier.stat)
			if (CONSCIOUS)
				. += "ai-fixer-full"
			if (UNCONSCIOUS)
				. += "ai-fixer-404"
	else
		. += "ai-fixer-empty"