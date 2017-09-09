/obj/effect/spider/grub
	name = "grub larva"
	desc = "It never stays still for long."
//	icon = 'grub_vr.dmi'
	icon_state = "spiderling"
	anchored = 0
	layer = 2.7
	health = 3
	var/last_itch = 0
	var/amount_grown = -1
	var/obj/machinery/atmospherics/unary/vent_pump/entry_vent
	var/travelling_in_vent = 0

/obj/effect/spider/grub/New(var/location, var/atom/parent)
	pixel_x = rand(6,-6)
	pixel_y = rand(6,-6)
	processing_objects |= src
	//60% chance to grow up
	if(prob(60))
		amount_grown = 1
	get_light_and_color(parent)
	..()

/obj/effect/spider/grub/proc/die()
	visible_message("<span class='alert'>[src] dies!</span>")
	new /obj/effect/decal/cleanable/spiderling_remains(src.loc) //Leaving this. It works.
	qdel(src)

/obj/effect/spider/grub/healthcheck()
	if(health <= 0)
		die()

	if(isturf(loc))
		if(prob(25))
			var/list/nearby = trange(5, src) - loc
			if(nearby.len)
				var/target_atom = pick(nearby)
				walk_to(src, target_atom, 5)
				if(prob(25))
					src.visible_message("<span class='notice'>\The [src] slides[pick(" away"," around","")].</span>")
		else if(prob(5))
			//vent crawl!
			for(var/obj/machinery/atmospherics/unary/vent_pump/v in view(7,src))
				if(!v.welded)
					entry_vent = v
					walk_to(src, entry_vent, 5)
					break

		if(amount_grown >= 100)
			var/spawn_type = /mob/living/simple_animal/retaliate/solargrub
			new spawn_type(src.loc, src)
			qdel(src)
	else if(isorgan(loc))
		if(!amount_grown) amount_grown = 1
		var/obj/item/organ/external/O = loc
		if(!O.owner || O.owner.stat == DEAD || amount_grown > 80)
			O.implants -= src
			src.loc = O.owner ? O.owner.loc : O.loc
			src.visible_message("<span class='warning'>\A [src] makes its way out of [O.owner ? "[O.owner]'s [O.name]" : "\the [O]"]!</span>")
			if(O.owner)
				O.owner.apply_damage(1, BRUTE, O.organ_tag)
		else if(prob(1))
			O.owner.apply_damage(1, TOX, O.organ_tag)
			if(world.time > last_itch + 30 SECONDS)
				last_itch = world.time
				O.owner << "<span class='notice'>Your [O.name] itches...</span>"
	else if(prob(1))
		src.visible_message("<span class='notice'>\The [src] squelches.</span>")
