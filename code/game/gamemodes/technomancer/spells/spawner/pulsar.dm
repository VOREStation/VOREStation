/datum/technomancer/spell/pulsar
	name = "Pulsar"
	desc = "Emits electronic pulses to destroy, disable, or otherwise harm devices and machines.  Be sure to not hit yourself with this."
	cost = 100
	obj_path = /obj/item/weapon/spell/spawner/pulsar
	category = OFFENSIVE_SPELLS

/obj/item/weapon/spell/spawner/pulsar
	name = "pulsar"
	desc = "Be sure to not hit yourself!"
	icon_state = "radiance"
	cast_methods = CAST_RANGED | CAST_THROW
	aspect = ASPECT_EMP
	spawner_type = /obj/effect/temporary_effect/pulsar

/obj/item/weapon/spell/spawner/pulsar/New()
	..()
	set_light(3, 2, l_color = "#2ECCFA")

/obj/item/weapon/spell/spawner/pulsar/on_ranged_cast(atom/hit_atom, mob/user)
	if(within_range(hit_atom) && pay_energy(4000))
		adjust_instability(8)
		..()

/obj/item/weapon/spell/spawner/pulsar/on_throw_cast(atom/hit_atom, mob/user)
	empulse(hit_atom, 1, 1, 1, 1, log=1)

/obj/effect/temporary_effect/pulsar
	name = "pulsar"
	desc = "Not a real pulsar, but still emits loads of EMP."
	icon_state = "shield2"
	time_to_die = null
	light_range = 4
	light_power = 5
	light_color = "#2ECCFA"
	var/pulses_remaining = 3

/obj/effect/temporary_effect/pulsar/New()
	..()
	spawn(0)
		pulse_loop()

/obj/effect/temporary_effect/pulsar/proc/pulse_loop()
	while(pulses_remaining)
		sleep(2 SECONDS)
		empulse(src, 1, 1, 2, 2, log = 1)
		pulses_remaining--
	qdel(src)

