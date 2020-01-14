#define PROCESS_ACCURACY 10

/obj/item/organ/internal/heart
	name = "heart"
	icon_state = "heart-on"
	organ_tag = O_HEART
	parent_organ = BP_TORSO
	dead_icon = "heart-off"

	var/standard_pulse_level = PULSE_NORM	// We run on a normal clock. This is NOT CONNECTED to species heart-rate modifier.

/obj/item/organ/internal/heart/handle_germ_effects()
	. = ..() //Up should return an infection level as an integer
	if(!.) return

	//Endocarditis (very rare, usually for artificially implanted heart valves/pacemakers)
	if (. >= 1)
		if(prob(1))
			owner.custom_pain("Your chest feels uncomfortably tight!",0)
	if (. >= 2)
		if(prob(1))
			owner.custom_pain("A stabbing pain rolls through your chest!",1)
			owner.apply_damage(damage = 25, damagetype = HALLOSS, def_zone = parent_organ)

/obj/item/organ/internal/heart/robotize()
	..()
	standard_pulse_level = PULSE_NONE

/obj/item/organ/internal/heart/grey
	icon_state = "heart_grey-on"
	dead_icon = "heart_grey-off"

/obj/item/organ/internal/heart/grey/colormatch/New()
	..()
	var/mob/living/carbon/human/H = null
	spawn(15)
		if(ishuman(owner))
			H = owner
			color = H.species.blood_color
