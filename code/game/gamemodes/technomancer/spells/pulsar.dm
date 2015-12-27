/datum/power/technomancer/pulsar
	name = "Pulsar"
	desc = "Emits electronic pulses to destroy, disable, or otherwise harm devices and machines.  Be sure to not hit yourself with this."
	verbpath = /mob/living/carbon/human/proc/technomancer_pulsar

/mob/living/carbon/human/proc/technomancer_pulsar()
	place_spell_in_hand(/obj/item/weapon/spell/pulsar)

/obj/item/weapon/spell/pulsar
	name = "pulsar"
	desc = "Be sure to not hit yourself!"
	icon_state = "radiance"
	cast_methods = CAST_RANGED | CAST_THROW
	aspect = ASPECT_EMP

/obj/item/weapon/spell/pulsar/New()
	..()
	set_light(3, 2, l_color = "#2ECCFA")

/obj/effect/pulsar
	name = "pulsar"
	desc = "Not a real pulsar, but still emits loads of EMP."
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield2"
	var/pulses_remaining = 3

/obj/effect/pulsar/New()
	..()
	set_light(4, 5, l_color = "#2ECCFA")
	spawn(1)
		pulse_loop()

/obj/effect/pulsar/proc/pulse_loop()
	while(pulses_remaining)
		sleep(2 SECONDS)
		empulse(src, heavy_range = 1, light_range = 2, log = 1)
		pulses_remaining--
	qdel(src)

/obj/item/weapon/spell/pulsar/on_ranged_cast(atom/hit_atom, mob/user)
	var/turf/T = get_turf(hit_atom)
	if(T && pay_energy(4000) )
		new /obj/effect/pulsar(T)
		user << "<span class='notice'>You create an electromagnetic disturbance on \the [T].</span>"
		owner.adjust_instability(8)
		qdel(src)

/obj/item/weapon/spell/pulsar/on_throw_cast(atom/hit_atom, mob/user)
	empulse(hit_atom, 1, 1, log=1)
