#define EFFECT_GLASS "glass"
#define EFFECT_FIRE "glass"

/obj/effect/abstract/abberation
	name = "Abberation"
	desc = "Some sort of weird, pulsating entity."
	icon_state = "pre_confuse"
	alpha = 0

	///What type of effect type the abberation has
	var/effect_type = EFFECT_FIRE

	///If the abberation starts active or not.
	var/start_active = TRUE

	///If the abberation has a toggling effect (Turns on-off)
	var/enabled = FALSE

	///If it pulses or not. i.e. has a non-continuous effect
	var/pulses = FALSE

	///How frequently pulses occur
	var/pulse_time = 30 SECONDS

	///The cooldown for our pulse
	COOLDOWN_DECLARE(pulse)

/obj/effect/abstract/abberation/Initialize(mapload)
	. = ..()
	if(start_active)
		START_PROCESSING(SSobj, src)

/obj/effect/abstract/abberation/Destroy()
	. = ..()
	STOP_PROCESSING(SSobj, src)

/obj/effect/abstract/abberation/process()
	if(COOLDOWN_FINISHED(pulse))
		perform_pulse()
		COOLDOWN_START(src, pulse, pulse_time)
	perform_ambient_effects()

/obj/effect/abstract/abberation/proc/perform_pulse()
	return

/obj/effect/abstract/abberation/proc/perform_ambient_effects()
	return



//Fire abberation

/obj/effect/abstract/abberation/fire
	name = "Fire Abberation"

/obj/effect/abstract/abberation/fire/Initialize(mapload)
	. = ..()

#undef EFFECT_GLASS
#undef EFFECT_FIRE
