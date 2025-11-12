/**
 * Consumes the brain of a dead host, turning it into a husk zombie.
 *
 * Disabled currently due to ghosting behavior, allows you to enter a dead body ghost around for meta knowledge, then return and jumpstart the host.
 * Ideally a borer is about cooperating with your host in some way, and not just killing and eating their brain to go full single player antag anyway...
 */
/mob/living/simple_mob/animal/borer/verb/devour_brain()
	set category = "Abilities.Borer"
	set name = "Devour Brain"
	set desc = "Take permanent control of a dead host."

	if(!can_use_power_in_host())
		return
	if(!can_use_power_docile())
		return
	if(host.stat != DEAD)
		to_chat(src, span_warning("Your host is still alive."))
		return

	to_chat(src, span_alien("It only takes a few moments to render the dead host brain down into a nutrient-rich slurry..."))
	add_attack_logs(src, host, "devour host brain (borer)")
	replace_brain()

/// BRAIN WORM ZOMBIES AAAAH. Husks mob and turns them into a borer zombie.
/mob/living/simple_mob/animal/borer/proc/replace_brain()
	if(!istype(host))
		to_chat(src, span_warning("This host does not have a suitable brain."))
		return
	to_chat(src, span_alien("You settle into the empty brainpan and begin to expand, fusing inextricably with the dead flesh of [host]."))

	host.add_language("Cortical Link")

	if(host.stat == DEAD)
		add_verb(host, /mob/living/carbon/human/proc/jumpstart)
	add_verb(host, /mob/living/carbon/human/proc/psychic_whisper)
	add_verb(host, /mob/living/carbon/human/proc/tackle)
	if(antag)
		add_verb(host, /mob/living/carbon/proc/spawn_larvae)

	// Zombify
	if(host.client)
		host.ghostize(FALSE)
	if(mind)
		mind.special_role = "Borer Husk"
		mind.transfer_to(host)
	host.ChangeToHusk()

	// Convert into borer brain
	var/obj/item/organ/internal/borer/borer_organ = new(host)
	host.internal_organs_by_name[O_BRAIN] = borer_organ
	host.internal_organs |= borer_organ
	var/obj/item/organ/external/affecting = host.get_organ(BP_HEAD)
	affecting.implants -= src

	// This section is awful and a relic of ancient times. It needs to be replaced
	var/s2h_id = computer_id
	var/s2h_ip= lastKnownIP
	computer_id = null
	lastKnownIP = null

	if(!host.computer_id)
		host.computer_id = s2h_id

	if(!host.lastKnownIP)
		host.lastKnownIP = s2h_ip
	// End ip trickery
