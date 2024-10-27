//Brain slug proc for voluntary removal of control.
/mob/living/carbon/proc/release_control()

	set category = "Abilities"
	set name = "Release Control"
	set desc = "Release control of your host's body."

	var/mob/living/simple_mob/animal/borer/B = has_brain_worms()

	if(B && B.host_brain)
		to_chat(src, span_danger("You withdraw your probosci, releasing control of [B.host_brain]"))

		B.detatch()

		remove_verb(src, /mob/living/carbon/proc/release_control)
		remove_verb(src, /mob/living/carbon/proc/punish_host)
		remove_verb(src, /mob/living/carbon/proc/spawn_larvae)

	else
		to_chat(src, span_danger("ERROR NO BORER OR BRAINMOB DETECTED IN THIS MOB, THIS IS A BUG !"))

//Brain slug proc for tormenting the host.
/mob/living/carbon/proc/punish_host()
	set category = "Abilities"
	set name = "Torment host"
	set desc = "Punish your host with agony."

	var/mob/living/simple_mob/animal/borer/B = has_brain_worms()

	if(!B)
		return

	if(B.host_brain.ckey)
		to_chat(src, span_danger("You send a punishing spike of psychic agony lancing into your host's brain."))
		if (!can_feel_pain())
			to_chat(B.host_brain, span_warning("You feel a strange sensation as a foreign influence prods your mind."))
			to_chat(src, span_danger("It doesn't seem to be as effective as you hoped."))
		else
			to_chat(B.host_brain, span_danger("<FONT size=3>Horrific, burning agony lances through you, ripping a soundless scream from your trapped mind!</FONT>"))

/mob/living/carbon/proc/spawn_larvae()
	set category = "Abilities"
	set name = "Reproduce"
	set desc = "Spawn several young."

	var/mob/living/simple_mob/animal/borer/B = has_brain_worms()

	if(!B)
		return

	if(B.chemicals >= 100)
		to_chat(src, span_danger("Your host twitches and quivers as you rapidly excrete a larva from your sluglike body."))
		visible_message(span_danger("\The [src] heaves violently, expelling a rush of vomit and a wriggling, sluglike creature!"))
		B.chemicals -= 100
		B.has_reproduced = 1

		vomit(1)
		new /mob/living/simple_mob/animal/borer(get_turf(src))

	else
		to_chat(src, span_warning("You do not have enough chemicals stored to reproduce."))
		return
