/*
This is mostly just for testing and is not something anyone should ever actually use beyond spawning it in & renaming it as bait for exploration

*/

/obj/item/endoware/bomb
	name = "Internal Voltage Multiplier"
	desc = "A device that supposedly multiplies the voltage in the system it's installed in (Nervous or synthetic) by a factor of 60 orders of magnitude. it promises exciting results."
	icon_state = "worm"

	is_activatable = TRUE
	image_text =  "BOOM"

/obj/item/endoware/bomb/activate()
	. = ..()
	host?.apply_damage(500, BURN, installed_in)
	//host?.adjustBruteLoss(500)
