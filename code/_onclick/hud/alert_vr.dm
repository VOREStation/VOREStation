/obj/screen/alert/fat
	name = "Full"
	desc = "You overate! If you don't exercise soon, you might find yourself gaining weight."

/obj/screen/alert/fat/vampire
	desc = "You overdrank! If you don't exercise soon, you might find yourself gaining weight."

/obj/screen/alert/fat/synth
	name = "Overcharged"

/obj/screen/alert/hungry/vampire
	desc = "You could use a bloodpack or two."

/obj/screen/alert/hungry/synth
	name = "Undercharged"

/obj/screen/alert/starving
	desc = "You're extremely hungry. The hunger pains make moving around a chore."

/obj/screen/alert/starving/vampire
	desc = "You are starving! Without some blood, moving around is a pain."

/obj/screen/alert/starving/synth
	name = "Low Power"
	desc = "Your battery is very low! Low power mode makes all movements slower."

/obj/screen/alert/xenochimera/reconstitution
	name = "Reconstructing Form"
	desc = "You're still rebuilding your body! Click the alert to find out how long you have left."
	icon_state = "regenerating"

/* // Commenting this out for now, will revisit later once I can figure out how to override Click() appropriately.
/obj/screen/alert/xenochimera/reconstitution/Click(mob/usr)
	var/mob/living/carbon/human/H = usr
	if(istype(H) && istype(H.species, /datum/species/xenochimera)) // If you're somehow able to click this while not a chimera, this should prevent weird runtimes. Will need changing if regeneration is ever opened to non-chimera using the same alert.
		if(H.revive_ready == REVIVING_NOW)
			to_chat(usr, "We are currently reviving, and will be done in [(H.revive_finished - world.time) / 10] seconds.")
		else if(H.revive_ready == REVIVING_DONE)
			to_chat(usr, "You should have a notification + alert for this! Bug report that this is still here!")
*/

/obj/screen/alert/xenochimera/readytohatch
	name = "Ready to Hatch"
	desc = "You're done reconstructing your cells! Click me to Hatch!"
	icon_state = "hatch_ready"

/*	// Commenting this out for now, will revisit later once I can figure out how to override Click() appropriately.
/obj/screen/alert/xenochimera/readytohatch/Click(mob/usr)
	var/mob/living/carbon/human/H = usr
	if(istype(H) && istype(H.species, /datum/species/xenochimera)) // If you're somehow able to click this while not a chimera, this should prevent weird runtimes. Will need changing if regeneration is ever opened to non-chimera using the same alert.
		if(H.revive_ready == REVIVING_DONE) // Sanity check.
			H.hatch() // Hatch.
*/
