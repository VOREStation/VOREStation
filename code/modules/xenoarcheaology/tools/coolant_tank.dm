#define COOLING_FACTOR 12500 //5000 in a near empty 7x7 room with a heat cap of 478325 drops it by 20.9C. 125000 drops it by 52.25C. This seems appropriate.
/obj/structure/reagent_dispensers/coolanttank
	name = "coolant tank"
	desc = "A tank of industrial coolant"
	icon = 'icons/obj/objects.dmi'
	icon_state = "coolanttank"
	amount_per_transfer_from_this = 10

/obj/structure/reagent_dispensers/coolanttank/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_COOLANT, 1000)

/obj/structure/reagent_dispensers/coolanttank/bullet_act(var/obj/item/projectile/Proj)
	if(Proj.get_structure_damage())
		explode()

/obj/structure/reagent_dispensers/coolanttank/ex_act()
	explode()

/obj/structure/reagent_dispensers/coolanttank/proc/explode()
	var/datum/effect/effect/system/smoke_spread/S = new /datum/effect/effect/system/smoke_spread
	S.set_up(5, 0, src.loc)

	playsound(src, 'sound/effects/smoke.ogg', 50, 1, -3)
	S.start()
	var/datum/gas_mixture/env = src.loc.return_air()
	if(env)
		var/cooling_strength = reagents.machine_cooling_power()
		if(cooling_strength > 0)
			env.add_thermal_energy(-(cooling_strength * COOLING_FACTOR))

	QDEL_IN(src, 10)

#undef COOLING_FACTOR
