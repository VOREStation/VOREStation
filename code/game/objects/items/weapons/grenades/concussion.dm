//Concussion, or 'dizzyness' grenades.

/obj/item/grenade/concussion
	name = "concussion grenade"
	desc = "A polymer concussion grenade, optimized for disorienting personnel without causing large amounts of injury."
	icon_state = "concussion"
	item_state = "grenade"

	var/blast_radius = 5

/obj/item/grenade/concussion/detonate()
	..()
	concussion_blast(get_turf(src), blast_radius)
	qdel(src)
	return

/obj/proc/concussion_blast(atom/target, var/radius = 5)
	var/turf/T = get_turf(target)
	if(is_below_sound_pressure(T))
		visible_message(span_notice("Whump."))
		return
	playsound(src, 'sound/effects/bang.ogg', 75, 1, -3)
	if(istype(T))
		for(var/mob/living/L in orange(T, radius))
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				to_chat(H, span_critical("WHUMP."))

				var/ear_safety = 0

				H.get_ear_protection()

				var/bang_effectiveness = H.species.sound_mod

				if((get_dist(H, T) <= round(radius * 0.3 * bang_effectiveness) || src.loc == H.loc || src.loc == H))
					if(ear_safety > 0)
						H.Confuse(2)
					else
						H.Confuse(8)
						H.Weaken(1)
						if ((prob(14) || (H == src.loc && prob(70))))
							H.ear_damage += rand(1, 10)
						else
							H.ear_damage += rand(0, 5)
							H.ear_deaf = max(H.ear_deaf,15)
					if(H.client)
						if(prob(50))
							H.client.spinleft()
						else
							H.client.spinright()

				else if(get_dist(H, T) <= round(radius * 0.5 * bang_effectiveness))
					if(!ear_safety)
						H.Confuse(6)
						H.ear_damage += rand(0, 3)
						H.ear_deaf = max(H.ear_deaf,10)

					if(H.client)
						if(prob(50))
							H.client.spinleft()
						else
							H.client.spinright()

				else if(!ear_safety && get_dist(H, T) <= (radius * bang_effectiveness))
					H.Confuse(4)
					H.ear_damage += rand(0, 1)
					H.ear_deaf = max(H.ear_deaf,5)

				if(H.ear_damage >= 15)
					to_chat(H, span_danger("Your ears start to ring badly!"))

					if(prob(H.ear_damage - 5))
						to_chat(H, span_danger("You can't hear anything!"))
						H.sdisabilities |= DEAF
				else if(H.ear_damage >= 5)
					to_chat(H, span_danger("Your ears start to ring!"))
			if(istype(L, /mob/living/silicon/robot))
				var/mob/living/silicon/robot/R = L
				if(L.client)
					if(prob(50))
						L.client.spinleft()
					else
						L.client.spinright()
				to_chat(R, span_critical("Gyroscopic failure."))
	return
