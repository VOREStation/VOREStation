/*
 * Controls the ability to do a scan for internal damage / temperature.
 */

/obj/item/organ/internal/robotic/diagnostic
	name = "diagnostic processor"

	icon_state = "diagnostic"

	organ_tag = O_DIAGNOSTIC

	organ_verbs = list(
	/mob/living/human/proc/self_diagnostics
	)
