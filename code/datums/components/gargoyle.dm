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

	START_PROCESSING(SSprocessing, src)

/datum/component/gargoyle/process()
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

/datum/component/gargoyle/proc/unpause()
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

	if (stat == DEAD)
		return

	var/datum/component/gargoyle/comp = GetComponent(/datum/component/gargoyle)
	if (comp)
		if (comp.energy <= 0 && isturf(loc))
			to_chat(src, span_danger("You suddenly turn into a [comp.identifier] as you run out of energy!"))
		else if (comp.cooldown > world.time)
			var/time_to_wait = (comp.cooldown - world.time) / (1 SECONDS)
			to_chat(src, span_warning("You can't transform just yet again! Wait for another [round(time_to_wait,0.1)] seconds!"))
			return
	if (istype(loc, /obj/structure/gargoyle))
		qdel(loc)
	else if (isturf(loc))
		new /obj/structure/gargoyle(loc, src)

/mob/living/carbon/human/proc/gargoyle_pause()
	set name = "Gargoyle - Pause"
	set category = "Abilities.Gargoyle"
	set desc = "Pause your energy while standing still, so you don't use up any more, though you will lose a small amount upon moving again."

	if (stat)
		return

	var/datum/component/gargoyle/comp = GetComponent(/datum/component/gargoyle)
	if (comp && !comp.transformed && !comp.paused)
		comp.paused = TRUE
		comp.paused_loc = loc
		comp.RegisterSignal(src, COMSIG_ATOM_ENTERING, /datum/component/gargoyle/proc/unpause)
		to_chat(src, span_notice("You start conserving your energy."))

/mob/living/carbon/human/proc/gargoyle_checkenergy()
	set name = "Gargoyle - Check Energy"
	set category = "Abilities.Gargoyle"
	set desc = "Check how much energy you have remaining as a gargoyle."

	var/datum/component/gargoyle/comp = GetComponent(/datum/component/gargoyle)
	if (comp)
		to_chat(src, span_notice("You have [round(comp.energy,0.01)] energy remaining. It is currently [comp.paused ? "stable" : (comp.transformed ? "increasing" : "decreasing")]."))
