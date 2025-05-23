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

/obj/item/organ/internal/heart/grey/colormatch/Initialize(mapload, internal)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/item/organ/internal/heart/grey/colormatch/LateInitialize()
	. = ..()
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		color = H.species.blood_color

/obj/item/organ/internal/heart/machine
	name = "hydraulic hub"
	icon_state = "pump-on"
	organ_tag = O_PUMP
	dead_icon = "pump-off"
	robotic = ORGAN_ROBOT

	standard_pulse_level = PULSE_NONE

/obj/item/organ/internal/stomach/machine/handle_organ_proc_special()
	..()
	if(owner && owner.stat != DEAD)
		owner.bodytemperature += round(owner.robobody_count * 0.25, 0.1)

	return
