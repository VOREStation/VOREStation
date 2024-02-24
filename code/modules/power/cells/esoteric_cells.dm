
/obj/item/weapon/cell/spike
	name = "modified power cell"
	desc = "A modified power cell sitting in a highly conductive chassis."
	origin_tech = list(TECH_POWER = 2)
	icon_state = "modded"
	maxcharge = 10000
	matter = list(MAT_STEEL = 1000, MAT_GLASS = 80, MAT_SILVER = 100)
	self_recharge = TRUE
	charge_amount = 150

/obj/item/weapon/cell/spike/process()
	..()

	var/turf/Center = get_turf(src)

	var/shock_count = 0
	for(var/turf/T in range(Center, 1))

		if(prob(round(charge / 250)) && charge >= (maxcharge / 4))

			if(locate(/obj/effect/temporary_effect/pulse/staticshock) in T)
				continue

			var/conductive = FALSE

			if(istype(T, /turf/simulated/wall))
				var/turf/simulated/wall/WT = T

				if(WT.material.conductive)
					conductive = TRUE
				else if(WT.girder_material.conductive)
					conductive = TRUE
				else if(WT.reinf_material && WT.reinf_material.conductive)
					conductive = TRUE

			if(istype(T, /turf/simulated/floor))
				var/turf/simulated/floor/F = T
				if(istype(F.flooring, /decl/flooring/reinforced))
					conductive = TRUE

			if(conductive)
				shock_count += 1
				new /obj/effect/temporary_effect/pulse/staticshock(T)

	if(shock_count)
		while(shock_count)
			use(200)
			shock_count--

/obj/effect/temporary_effect/pulse/staticshock
	name = "electric field"
	desc = "Caution: Do not touch."
	pulses_remaining = 10
	pulse_delay = 2 SECONDS
	icon_state = "blue_static"

/obj/effect/temporary_effect/pulse/staticshock/on_pulse()
	..()

	for(var/mob/living/L in view(1, src))
		if(!issilicon(L) && prob(L.mob_size))
			var/obj/item/projectile/beam/shock/weak/P = new (get_turf(src))
			P.launch_projectile_from_turf(L, BP_TORSO)

	var/obj/item/weapon/plastique/C4 = locate() in get_turf(src)

	if(C4)
		C4.visible_message("<span class='danger'>The current fries \the [C4]!</span>")

		if(prob(10))
			C4.explode(get_turf(src))
		else
			qdel(C4)
