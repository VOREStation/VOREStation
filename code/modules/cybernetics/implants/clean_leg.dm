/obj/item/endoware/cleaner_leg
	name = "Submuscular Rinse Nozzle"
	desc = "A subtly implemented nozzle at the base of the calf, it sprays out a thin mist of cleaner as the owner walks."
	icon_state = "implant"

	var/datum/component/clean_floor_movement/component
	image_text = "CLEAN"
	var/enabled = FALSE


/obj/item/endoware/cleaner_leg/build_human_components(mob/living/carbon/target)
	component = AddComponent(target,/datum/component/clean_floor_movement)
	. = ..()

/obj/item/endoware/cleaner_leg/dissolve_human_components(mob/living/carbon/human/human)
	. = ..()
