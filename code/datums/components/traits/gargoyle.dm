/datum/component/gargoyle
	var/energy = 100
	var/transformed = FALSE
	var/paused = FALSE
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
	add_verb(parent,/mob/living/carbon/human/proc/gargoyle_transformation)
	add_verb(parent,/mob/living/carbon/human/proc/gargoyle_pause)
	add_verb(parent,/mob/living/carbon/human/proc/gargoyle_checkenergy)

/datum/component/gargoyle/RegisterWithParent()
	RegisterSignal(parent, COMSIG_GARGOYLE_TRANSFORMATION, PROC_REF(gargoyle_transformation))
	RegisterSignal(parent, COMSIG_GARGOYLE_PAUSE, PROC_REF(gargoyle_pause))
	RegisterSignal(parent, COMSIG_GARGOYLE_CHECK_ENERGY, PROC_REF(gargoyle_checkenergy))

	RegisterSignal(parent, COMSIG_LIVING_LIFE, PROC_REF(process_component))

/datum/component/gargoyle/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_GARGOYLE_TRANSFORMATION)
	UnregisterSignal(parent, COMSIG_GARGOYLE_PAUSE)
	UnregisterSignal(parent, COMSIG_GARGOYLE_CHECK_ENERGY)
	UnregisterSignal(parent, COMSIG_LIVING_LIFE)
	UnregisterSignal(parent, COMSIG_MOVABLE_MOVED) //happens if gargoyle_pause is used

/datum/component/gargoyle/proc/process_component()
	if(QDELETED(gargoyle))
		return
	if(transformed)
		if(!statue)
			transformed = FALSE
		if(paused) //We somehow lost our energy while paused.
			unpause()
		statue.damage(-0.5)
		energy = min(energy+0.3, 100)

		//This is where we do all the 'make sure we don't die in statue form' stuff (unless you succumb or take MASSIVE damage.)
		//Bloodloss will still kill us, but if we are patient enough, we'll survive most other stuff.
		//If we had 150 brute (crit for most species) it'll take 3000 seconds (50 minutes) to heal back to full hp...So yes, while you can heal, it's not a good idea.
		if(gargoyle.health < gargoyle.getMaxHealth())
			gargoyle.adjustBruteLoss(-0.1)
			gargoyle.adjustFireLoss(-0.1)
			gargoyle.adjustOxyLoss(-1) //So you don't suffocate to death.
			gargoyle.adjustToxLoss(-0.1)
			gargoyle.adjustCloneLoss(-0.02) //yeah this is uber slow, no cheese allowed by combining it with bad genetics.
		return //Early return. If we're transformed, we can stop, we don't need to check anything else.
	if(energy > 0)
		if(!transformed && !paused)
			energy = max(0,energy-0.05)
	else if(!transformed && isturf(gargoyle.loc))
		gargoyle.gargoyle_transformation()

/datum/component/gargoyle/Destroy(force = FALSE)
	gargoyle = null
	statue = null
	. = ..()

/datum/component/gargoyle/proc/unpause()
	SIGNAL_HANDLER
	paused = FALSE
	UnregisterSignal(gargoyle, COMSIG_MOVABLE_MOVED)
	return

//verbs or action buttons...?
/mob/living/carbon/human/proc/gargoyle_transformation()
	set name = "Gargoyle - Petrification"
	set category = "Abilities.Gargoyle"
	set desc = "Turn yourself into (or back from) being a gargoyle."
	SEND_SIGNAL(src, COMSIG_GARGOYLE_TRANSFORMATION)


/datum/component/gargoyle/proc/gargoyle_transformation()
	SIGNAL_HANDLER
	if(gargoyle.stat == DEAD)
		return
	if(energy <= 0 && isturf(gargoyle.loc))
		to_chat(gargoyle, span_danger("You suddenly turn into a [identifier] as you run out of energy!"))
	else if(cooldown > world.time)
		var/time_to_wait = (cooldown - world.time) / (1 SECONDS)
		to_chat(gargoyle, span_warning("You can't transform just yet again! Wait for another [round(time_to_wait,0.1)] seconds!"))
		return
	if(istype(gargoyle.loc, /obj/structure/gargoyle))
		qdel(gargoyle.loc)
	else if(isturf(gargoyle.loc))
		new /obj/structure/gargoyle(gargoyle.loc, gargoyle)

/mob/living/carbon/human/proc/gargoyle_pause()
	set name = "Gargoyle - Pause"
	set category = "Abilities.Gargoyle"
	set desc = "Pause your energy while standing still, so you don't use up any more, though you will lose a small amount upon moving again."
	SEND_SIGNAL(src, COMSIG_GARGOYLE_PAUSE)

/datum/component/gargoyle/proc/gargoyle_pause()
	SIGNAL_HANDLER
	if(gargoyle.stat)
		return

	if(!transformed && !paused)
		paused = TRUE
		RegisterSignal(parent, COMSIG_MOVABLE_MOVED, /datum/component/gargoyle/proc/unpause)
		to_chat(parent, span_notice("You start conserving your energy."))

/mob/living/carbon/human/proc/gargoyle_checkenergy()
	set name = "Gargoyle - Check Energy"
	set category = "Abilities.Gargoyle"
	set desc = "Check how much energy you have remaining as a gargoyle."
	SEND_SIGNAL(src, COMSIG_GARGOYLE_CHECK_ENERGY)

/datum/component/gargoyle/proc/gargoyle_checkenergy()
	SIGNAL_HANDLER
	to_chat(parent, span_notice("You have [round(energy,0.01)] energy remaining. It is currently [paused ? "stable" : (transformed ? "increasing" : "decreasing")]."))
