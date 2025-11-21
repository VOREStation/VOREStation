/**
 *  Brain slug proc for voluntary removal of control.
 */
/mob/living/carbon/proc/release_control()

	set category = "Abilities.Brainslug"
	set name = "Release Control"
	set desc = "Release control of your host's body."

	var/mob/living/simple_mob/animal/borer/B = has_brain_worms()
	if(!B)
		return
	if(!B.host_brain)
		return

	to_chat(src, span_alien("You withdraw your probosci, releasing control of [B.host_brain]"))
	B.detatch()

/**
 *  Brain slug proc for tormenting the host.
 */
/mob/living/carbon/proc/punish_host()
	set category = "Abilities.Brainslug"
	set name = "Torment host"
	set desc = "Punish your host with agony."

	var/mob/living/simple_mob/animal/borer/B = has_brain_worms()
	if(!B)
		return
	if(!B.host_brain)
		return
	if(!B.can_use_power_docile())
		return
	if(!B.use_chems(BORER_POWER_COST_TORTURE))
		return

	to_chat(src, span_alien("You send a punishing spike of psychic agony lancing into your host's brain."))
	if(!B.host_brain.client || !can_feel_pain())
		to_chat(B.host_brain, span_warning("You feel a strange sensation as a foreign influence prods your mind."))
		to_chat(src, span_danger("It doesn't seem to be as effective as you hoped."))
		return
	to_chat(B.host_brain, span_danger(span_large("Horrific, burning agony lances through you, ripping a soundless scream from your trapped mind!")))

/**
 *  Brain slug proc for spitting up new borers. They are ghostjoin by default, but are infertile.
 */
/mob/living/carbon/proc/spawn_larvae()
	set category = "Abilities.Brainslug"
	set name = "Reproduce"
	set desc = "Spawn several young."

	var/mob/living/simple_mob/animal/borer/B = has_brain_worms()
	if(!B || !B.can_use_power_controlling_host())
		return
	if(!B.can_use_power_docile())
		return
	if(!B.antag)
		to_chat(src, span_warning("You cannot reproduce, you are infertile!"))
		return
	if(!B.use_chems(BORER_POWER_COST_REPRODUCE))
		return

	to_chat(src, span_alien("Your host twitches and quivers as you rapidly excrete a larva from your sluglike body."))
	visible_message(span_danger("\The [src] heaves violently, expelling a rush of vomit and a wriggling, sluglike creature!"))

	do_vomit(lost_nutrition = 1) // Needs to be instant
	new /mob/living/simple_mob/animal/borer/non_antag(get_turf(src))
	B.has_reproduced = TRUE
