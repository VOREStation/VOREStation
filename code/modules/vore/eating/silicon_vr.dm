//Dat AI vore yo
#define HOLO_ORIGINAL_COLOR null //Original hologram color: "#7db4e1"
#define HOLO_HARDLIGHT_COLOR "#d97de0"
#define HOLO_ORIGINAL_ALPHA 120
#define HOLO_HARDLIGHT_ALPHA 200

/obj/effect/overlay/aiholo
	var/mob/living/bellied //Only belly one person at a time. No huge vore-organs setup for AIs.
	var/mob/living/silicon/ai/master //This will receive the AI controlling the Hologram. For referencing purposes.
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	alpha = HOLO_ORIGINAL_ALPHA //Half alpha here rather than in the icon so we can toggle it easily.
	color = HOLO_ORIGINAL_COLOR //This is the blue from icons.dm that it was before.
	desc = "A hologram representing an AI persona."

/obj/effect/overlay/aiholo/Destroy()
	drop_prey()
	for(var/mob/M in contents)
		M.forceMove(loc)
	walk(src, 0) // Because we might have called walk_to, we must stop the walk loop or BYOND keeps an internal reference to us forever.
	return ..()

/obj/effect/overlay/aiholo/proc/get_prey(var/mob/living/prey)
	if(bellied) return
	playsound(src, 'sound/effects/stealthoff.ogg',50,0)
	bellied = prey
	prey.forceMove(src)
	visible_message("[src] entirely engulfs [prey] in hardlight holograms!")
	to_chat(usr, "<span class='vnotice'>You completely engulf [prey] in hardlight holograms!</span>") //Can't be part of the above, because the above is from the hologram.

	desc = "[initial(desc)] It seems to have hardlight mode enabled and someone inside."
	pass_flags = 0
	color = HOLO_HARDLIGHT_COLOR
	alpha = HOLO_HARDLIGHT_ALPHA

/obj/effect/overlay/aiholo/proc/drop_prey()
	if(!bellied) return
	playsound(src, 'sound/effects/stealthoff.ogg',50,0)
	bellied.forceMove(get_turf(src))
	bellied.Weaken(2)
	bellied.visible_message("[bellied] flops out of [src].","You flop out of [src].","You hear a thud.")
	bellied = null

	desc = "[initial(desc)]"
	pass_flags = initial(pass_flags)
	color = HOLO_ORIGINAL_COLOR
	alpha = HOLO_ORIGINAL_ALPHA

/mob/living/silicon/ai/verb/holo_nom()
	set name = "Hardlight Nom"
	set category = "AI Commands"
	set desc = "Wrap up a person in hardlight holograms."

	// Wrong state
	if (!eyeobj || !holo)
		to_chat(usr, "<span class='vwarning'>You can only use this when holo-projecting!</span>")
		return

	//Holopads have this 'masters' list where the keys are AI names and the values are the hologram effects
	var/obj/effect/overlay/aiholo/hologram = holo.masters[src]

	//Something wrong on holopad
	if(!hologram)
		return

	//Already full
	if (hologram.bellied)
		var/choice = tgui_alert(usr, "You can only contain one person. [hologram.bellied] is in you.", "Already Full", list("Drop Mob", "Cancel"))
		if(choice == "Drop Mob")
			hologram.drop_prey()
		return

	var/mob/living/prey = tgui_input_list(src,"Select a mob to eat","Holonoms", oview(0,eyeobj))
	if(!prey)
		return //Probably cancelled

	if(!istype(prey))
		to_chat(usr, "<span class='vwarning'>Invalid mob choice!</span>")
		return

	hologram.visible_message("[hologram] starts engulfing [prey] in hardlight holograms!")
	to_chat(src, "<span class='vnotice'>You begin engulfing [prey] in hardlight holograms.</span>") //Can't be part of the above, because the above is from the hologram.
	if(do_after(user=eyeobj,delay=50,target=prey,needhand=0) && holo && hologram && !hologram.bellied) //Didn't move and still projecting and effect exists and no other bellied people
		hologram.get_prey(prey)

/*	Can't, lets them examine things in camera blackout areas
//I basically have to do this, you know?
/mob/living/silicon/ai/examinate(atom/A as mob|obj|turf in view(eyeobj))
	set name = "Examine"
	set category = "IC"

	A.examine(src)
*/

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
			. += "<span class = 'deptradio'>OOC Notes:</span> <a href='?src=\ref[master];ooc_notes=1'>\[View\]</a> - <a href='?src=\ref[master];print_ooc_notes_to_chat=1'>\[Print\]</a>"
