/datum/component/gargoyle
	var/energy = 100
	var/transformed = FALSE
	var/paused = FALSE
	var/paused_loc
	var/cooldown

	var/mob/living/carbon/human/gargoyle //easy reference
	var/obj/structure/gargoyle/statue //another easy ref

	//Adjustable mod
	var/identifier = "statue"
	var/adjective = "hardens"
	var/material = "stone"
	var/tint = "#FFFFFF"

/datum/component/gargoyle/Initialize()
	if (!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	gargoyle = parent
	add_verb(gargoyle,/mob/living/carbon/human/proc/gargoyle_transformation)
	add_verb(gargoyle,/mob/living/carbon/human/proc/gargoyle_pause)
	add_verb(gargoyle,/mob/living/carbon/human/proc/gargoyle_checkenergy)
	RegisterSignal(gargoyle, COMSIG_GARGOYLE_TRANSFORMATION, PROC_REF(gargoyle_transformation))
	RegisterSignal(gargoyle, COMSIG_GARGOYLE_PAUSE, PROC_REF(gargoyle_pause))
	RegisterSignal(gargoyle, COMSIG_GARGOYLE_CHECK_ENERGY, PROC_REF(gargoyle_checkenergy))

	RegisterSignal(gargoyle, COMSIG_LIVING_LIFE, PROC_REF(process_component))

/datum/component/gargoyle/proc/process_component()
	if (QDELETED(gargoyle))
		return
	if (paused && gargoyle.loc != paused_loc)
		unpause()
	if (energy > 0)
		if (!transformed && !paused)
			energy = max(0,energy-0.05)
	else if (!transformed && isturf(gargoyle.loc))
		gargoyle.gargoyle_transformation()
	if (transformed)
		if (!statue)
			transformed = FALSE
		statue.damage(-0.5)
		energy = min(energy+0.3, 100)

/datum/component/gargoyle/Destroy(force = FALSE)
	UnregisterSignal(gargoyle, COMSIG_GARGOYLE_TRANSFORMATION)
	UnregisterSignal(gargoyle, COMSIG_GARGOYLE_PAUSE)
	UnregisterSignal(gargoyle, COMSIG_GARGOYLE_CHECK_ENERGY)
	UnregisterSignal(gargoyle, COMSIG_LIVING_LIFE)
	gargoyle = null
	statue = null
	. = ..()

/datum/component/gargoyle/proc/unpause()
	SIGNAL_HANDLER
	if (!paused || transformed)
		paused = FALSE
		paused_loc = null
		UnregisterSignal(gargoyle, COMSIG_ATOM_ENTERING)
		return
	if (gargoyle?.loc != paused_loc)
		paused = FALSE
		paused_loc = null
		energy = max(energy - 5, 0)
		if (energy == 0)
			gargoyle.gargoyle_transformation()
		UnregisterSignal(gargoyle, COMSIG_ATOM_ENTERING)

//verbs or action buttons...?
/mob/living/carbon/human/proc/gargoyle_transformation()
	set name = "Gargoyle - Petrification"
	set category = "Abilities.Gargoyle"
	set desc = "Turn yourself into (or back from) being a gargoyle."
	SEND_SIGNAL(src, COMSIG_GARGOYLE_TRANSFORMATION)


/datum/component/gargoyle/proc/gargoyle_transformation()
	if (gargoyle.stat == DEAD)
		return
	if (energy <= 0 && isturf(gargoyle.loc))
		to_chat(gargoyle, span_danger("You suddenly turn into a [identifier] as you run out of energy!"))
	else if (cooldown > world.time)
		var/time_to_wait = (cooldown - world.time) / (1 SECONDS)
		to_chat(gargoyle, span_warning("You can't transform just yet again! Wait for another [round(time_to_wait,0.1)] seconds!"))
		return
	if (istype(gargoyle.loc, /obj/structure/gargoyle))
		qdel(gargoyle.loc)
	else if (isturf(gargoyle.loc))
		new /obj/structure/gargoyle(gargoyle.loc, gargoyle)

/mob/living/carbon/human/proc/gargoyle_pause()
	set name = "Gargoyle - Pause"
	set category = "Abilities.Gargoyle"
	set desc = "Pause your energy while standing still, so you don't use up any more, though you will lose a small amount upon moving again."
	SEND_SIGNAL(src, COMSIG_GARGOYLE_PAUSE)

/datum/component/gargoyle/proc/gargoyle_pause()
	if (gargoyle.stat)
		return

	if (!transformed && !paused)
		paused = TRUE
		paused_loc = gargoyle.loc
		RegisterSignal(gargoyle, COMSIG_ATOM_ENTERING, /datum/component/gargoyle/proc/unpause)
		to_chat(gargoyle, span_notice("You start conserving your energy."))

/mob/living/carbon/human/proc/gargoyle_checkenergy()
	set name = "Gargoyle - Check Energy"
	set category = "Abilities.Gargoyle"
	set desc = "Check how much energy you have remaining as a gargoyle."
	SEND_SIGNAL(src, COMSIG_GARGOYLE_CHECK_ENERGY)

/datum/component/gargoyle/proc/gargoyle_checkenergy()
	to_chat(gargoyle, span_notice("You have [round(energy,0.01)] energy remaining. It is currently [paused ? "stable" : (transformed ? "increasing" : "decreasing")]."))
