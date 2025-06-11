/obj/effect/overlay/aiholo
	var/mob/living/silicon/ai/master //This will receive the AI controlling the Hologram. For referencing purposes.
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	alpha = HOLO_ORIGINAL_ALPHA //Half alpha here rather than in the icon so we can toggle it easily.
	color = HOLO_ORIGINAL_COLOR //This is the blue from icons.dm that it was before.
	desc = "A hologram representing an AI persona."

/obj/effect/overlay/aiholo/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/holographic_nature)

/obj/effect/overlay/aiholo/Destroy()
	for(var/obj/belly/B in src)
		B.forceMove(master)

	walk(src, 0) // Because we might have called walk_to, we must stop the walk loop or BYOND keeps an internal reference to us forever.
	return ..()

/mob/living/silicon/ai/verb/holo_nom()
	set name = "Hardlight Nom"
	set category = "AI.Vore"
	set desc = "Wrap up a person in hardlight holograms."

	// Wrong state
	if (!eyeobj || !holo)
		to_chat(src, span_vwarning("You can only use this when holo-projecting!"))
		return

	if(isbelly(loc))
		to_chat(src, span_vwarning("For safety reasons, you cannot consume people with holograms while you are inside someone else."))
		return

	//Holopads have this 'masters' list where the keys are AI names and the values are the hologram effects
	var/obj/effect/overlay/aiholo/hologram = holo.masters[src]

	//Something wrong on holopad
	if(!hologram)
		return

	var/list/possible_prey
	for(var/mob/living/L in oview(1, eyeobj))
		LAZYADD(possible_prey, L)

	if(!LAZYLEN(possible_prey))
		to_chat(src, span_vwarning("There's no one in range to eat."))
		return

	var/mob/living/prey = tgui_input_list(src, "Select a mob to eat", "Holonoms", possible_prey)
	if(!prey)
		return //Probably cancelled

	if(!istype(prey))
		to_chat(src, span_vwarning("Invalid mob choice!"))
		return


	hologram.visible_message("[hologram] starts engulfing [prey] in hardlight holograms!")
	to_chat(src, span_vnotice("You begin engulfing [prey] in hardlight holograms.")) //Can't be part of the above, because the above is from the hologram.
	if(do_after(user = eyeobj,delay = 50,target = prey, needhand = 0) && holo && hologram) //Didn't move and still projecting and effect exists and no other bellied people
		feed_grabbed_to_self(src, prey)

/mob/living/AIShiftClick(var/mob/user) //Shift-click as AI overridden on mobs to examine.
	if(user.client)
		examine(user)
	return

//This can go here with all the references.
/obj/effect/overlay/aiholo/examine(mob/user)
	. = ..()
	if(master)
		var/flavor_text = master.print_flavor_text()
		if(flavor_text)
			. += "[flavor_text]"

		if(master.ooc_notes)
			. += span_deptradio("OOC Notes:") + "<a href='byond://?src=\ref[master];ooc_notes=1'>\[View\]</a> - <a href='byond://?src=\ref[master];print_ooc_notes_chat=1'>\[Print\]</a>"

// Allow dissipating ai holograms by attacking them
/obj/effect/overlay/aiholo/attack_hand(mob/living/user)
	if(user.a_intent == I_HURT)
		to_chat(user, span_attack("You dissipate [src]."))
		master?.holo?.clear_holo(master)
	return ..()

/obj/effect/overlay/aiholo/attackby(obj/item/I, mob/user)
	if(user.a_intent == I_HURT)
		to_chat(user, span_attack("You dissipate [src] with [I]."))
		master?.holo?.clear_holo(master)
	return ..()
