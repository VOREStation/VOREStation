/**
 * Assume control of a borer's host, putting the borer's client in control, and putting the other into a dominated brain.
 */
/mob/living/simple_mob/animal/borer/verb/bond_brain()
	set category = "Abilities.Borer"
	set name = "Assume Control"
	set desc = "Fully connect to the brain of your host."

	if(!can_use_power_in_host())
		return
	if(!can_use_power_docile())
		return
	if(host.stat == DEAD)
		to_chat(src, span_warning("Your host is in no condition to do that."))
		return

	to_chat(src, span_alien("You begin delicately adjusting your connection to the host brain..."))
	addtimer(CALLBACK(src, PROC_REF(finish_bond_brain)), 100 + (host.brainloss * 5), TIMER_DELETE_ME)

// This entire section is awful and a relic of ancient times. It needs to be replaced
/mob/living/simple_mob/animal/borer/proc/finish_bond_brain()
	PRIVATE_PROC(TRUE)
	RETURN_TYPE(null)

	if(!host || QDELETED(src) || controlling)
		return
	if(host.stat == DEAD)
		to_chat(src, span_warning("Your host is in no condition to do that."))
		return

	to_chat(src, span_alien("You plunge your probosci deep into the cortex of the host brain, interfacing directly with their nervous system."))
	to_chat(host, span_danger("You feel a strange shifting sensation behind your eyes as an alien consciousness displaces yours."))
	host.add_language("Cortical Link")

	// host -> brain
	var/h2b_id = host.computer_id
	var/h2b_ip= host.lastKnownIP
	host.computer_id = null
	host.lastKnownIP = null

	qdel(host_brain)
	host_brain = new(src)
	host_brain.ckey = host.ckey
	host_brain.name = host.name

	if(!host_brain.computer_id)
		host_brain.computer_id = h2b_id

	if(!host_brain.lastKnownIP)
		host_brain.lastKnownIP = h2b_ip

	// self -> host
	var/s2h_id = src.computer_id
	var/s2h_ip= src.lastKnownIP
	src.computer_id = null
	src.lastKnownIP = null

	host.ckey = src.ckey

	if(!host.computer_id)
		host.computer_id = s2h_id
	if(!host.lastKnownIP)
		host.lastKnownIP = s2h_ip
	controlling = TRUE

	add_verb(host, /mob/living/carbon/proc/release_control)
	add_verb(host, /mob/living/carbon/proc/punish_host)
	if(antag)
		add_verb(host, /mob/living/carbon/proc/spawn_larvae)
// End horrible ip swapping code for bans

/**
 * Releases manual control of the borer from a mind-dominated host. Returning control to the original mind.
 */
/mob/living/simple_mob/animal/borer/verb/release_host()
	set category = "Abilities.Borer"
	set name = "Release Host"
	set desc = "Slither out of your host."

	if(!host)
		to_chat(src, span_warning("You are not inside a host body."))
		return
	if(stat)
		to_chat(src, span_warning("You cannot leave your host in your current state."))
		return
	if(!can_use_power_docile())
		return

	to_chat(src, span_alien("You begin disconnecting from [host]'s synapses and prodding at their internal ear canal."))
	if(!host.stat)
		to_chat(host, span_danger("An odd, uncomfortable pressure begins to build inside your skull, behind your ear..."))

	addtimer(CALLBACK(src, PROC_REF(finish_release_host)), 10 SECONDS, TIMER_DELETE_ME)

/mob/living/simple_mob/animal/borer/proc/finish_release_host()
	PRIVATE_PROC(TRUE)

	if(!host || QDELETED(src))
		return

	if(stat)
		to_chat(src, span_warning("You cannot release your host in your current state."))
		return

	to_chat(src, span_alien("You wiggle out of [host]'s ear and plop to the ground."))
	if(host.mind)
		if(!host.stat)
			to_chat(host, span_danger("Something slimy wiggles out of your ear and plops to the ground!"))
		to_chat(host, span_danger("As though waking from a dream, you shake off the insidious mind control of the brain worm. Your thoughts are your own again."))

	detatch()
	leave_host()
