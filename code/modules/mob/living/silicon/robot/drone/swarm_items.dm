
//Swarm Assimilator / Breacher
/obj/item/matter_decompiler/swarm
	name = "matter assimilator"
	desc = "Used to eat some forms of simple machinery; and large, wall-shaped blocks of metal with energetic fields."
	icon = 'icons/obj/device.dmi'
	pickup_sound = 'sound/items/pickup/device.ogg'
	drop_sound = 'sound/items/drop/device.ogg'
	icon_state = "decompiler_swarm"

	var/field_cooldown = 1 MINUTE
	var/last_field = 0

/obj/item/matter_decompiler/swarm/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, proximity, params)

	if(!proximity) return //Not adjacent.

	//We only want to deal with using this on turfs. Specific items aren't important.
	var/turf/T = get_turf(target)
	if(!istype(T))
		return

	//Used to give the right message.
	var/grabbed_something = FALSE

	for(var/mob/M in T)
		if(istype(M,/mob/living/simple_mob/animal/passive/lizard) || istype(M,/mob/living/simple_mob/animal/passive/mouse))
			src.loc.visible_message("<span class='danger'>[src.loc] sucks [M] into its decompiler. There's a horrible crunching noise.</span>","<span class='danger'>It's a bit of a struggle, but you manage to suck [M] into your decompiler. It makes a series of visceral crunching noises.</span>")
			new/obj/effect/decal/cleanable/blood/splatter(get_turf(src))
			qdel(M)
			if(wood)
				wood.add_charge(2000)
			if(plastic)
				plastic.add_charge(2000)
			return

		else if(istype(M,/mob/living/silicon/robot/drone) && !M.client)

			var/mob/living/silicon/robot/D = src.loc

			if(!istype(D))
				return

			to_chat(D, "<span class='danger'>You begin decompiling [M].</span>")

			if(!do_after(D,50))
				to_chat(D, "<span class='danger'>You need to remain still while decompiling such a large object.</span>")
				return

			if(!M || !D) return

			to_chat(D, "<span class='danger'>You carefully and thoroughly decompile [M], storing as much of its resources as you can within yourself.</span>")
			qdel(M)
			new/obj/effect/decal/cleanable/blood/oil(get_turf(src))

			if(metal)
				metal.add_charge(15000)
			if(glass)
				glass.add_charge(15000)
			if(wood)
				wood.add_charge(2000)
			if(plastic)
				plastic.add_charge(1000)
			return
		else
			continue

	for(var/obj/W in T)
		//Different classes of items give different commodities.
		if(istype(W,/obj/structure/girder))
			if(metal)
				metal.add_charge(500)
		else if(istype(W,/obj/machinery/power/emitter))
			if(metal)
				metal.add_charge(3000)
			if(plastic)
				plastic.add_charge(1000)
		else if(istype(W,/obj/machinery/space_heater))
			if(metal)
				metal.add_charge(1500)
			if(plastic)
				plastic.add_charge(750)
		else if(istype(W,/obj/structure/closet))
			var/obj/structure/closet/C = W
			if(!C.opened)
				continue
			if(istype(W,/obj/structure/closet/coffin))
				if(wood)
					wood.add_charge(1000)
			else if(istype(W,/obj/structure/closet/crate/plastic))
				if(plastic)
					plastic.add_charge(750)
			else
				if(metal)
					metal.add_charge(1000)
		else
			continue

		qdel(W)
		grabbed_something = TRUE

	if(istype(T,/turf/simulated/wall) && (last_field < world.time + field_cooldown))
		if(!(locate(/obj/effect/temporary_effect/pulse/disintegrate)))
			last_field = world.time
			to_chat(user, "<span class='alien'>You deploy an energetic field through \the [T], beginning its deconstruction.</span>")
			to_chat(user, "<span class='warning'>You should stand back.</span>")
			new /obj/effect/temporary_effect/pulse/disintegrate(T)
		else
			to_chat(user, "<span class='notice'>There is already a disintigration field affecting \the [T].</span>")

	if(grabbed_something)
		to_chat(user, "<span class='notice'>You deploy your decompiler and clear out the contents of \the [T].</span>")
	else
		to_chat(user, "<span class='danger'>Nothing on \the [T] is useful to you.</span>")
	return

/obj/effect/temporary_effect/pulse/disintegrate
	name = "molecular debonding field"
	desc = "This is something you do not want to near."
	icon = 'icons/mob/swarmbot.dmi'
	icon_state = "disintegrate_pulse"
	light_range = 4
	light_power = 5
	light_color = "#00B4D9"
	pulses_remaining = 5
	pulse_delay = 2 SECONDS

/obj/effect/temporary_effect/pulse/disintegrate/emp_act()
	visible_message("<span class='warning'>\The [src] flickers, before dispersing energetically.</span>")
	qdel(src)

/obj/effect/temporary_effect/pulse/disintegrate/on_pulse()
	var/turf/T = get_turf(src)
	if(istype(T,/turf/simulated/wall))
		T.take_damage(rand(20, 50))
	else
		qdel(src)

/obj/effect/temporary_effect/pulse/disintegrate/Destroy()
	if(istype(get_turf(src), /turf/simulated/wall))
		explosion(get_turf(src), -1, 1, 2, 5, adminlog = 1)
	..()

/obj/item/gun/energy/xray/swarm
	name = "spectral projector"
	desc = "A high-power laser gun capable of expelling concentrated gamma blasts, which are able to penetrate matter easier than \
	standard xray beams, resulting in an effective 'anti-everything' energy weapon."
	icon_state = "xray"
	item_state = "xray"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3, TECH_MAGNET = 2)
	projectile_type = /obj/item/projectile/beam/shock
	charge_cost = 175

	self_recharge = TRUE
	use_external_power = TRUE

	firemodes = list(
		list(mode_name="kill", projectile_type=/obj/item/projectile/beam/gamma, charge_cost = 300),
		list(mode_name="deter", projectile_type=/obj/item/projectile/beam/shock, charge_cost = 175),
		)

/obj/item/gun/energy/xray/swarm/Initialize()
	. = ..()
	adjust_scale(-1, 1)
