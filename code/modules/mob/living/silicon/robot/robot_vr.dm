/mob/living/silicon/robot/verb/robot_nom(var/mob/living/T in oview(1))
	set name = "Robot Nom"
	set category = "IC"
	set desc = "Allows you to eat someone."

	if (stat != CONSCIOUS)
		return
	return feed_grabbed_to_self(src,T)

/mob/living/silicon/robot/updateicon()
	..()
	if(stat == CONSCIOUS)
		if(sleeper_g == 1)
			overlays += "[module_sprites[icontype]]-sleeper_g"
		if(sleeper_r == 1)
			overlays += "[module_sprites[icontype]]-sleeper_r"

/mob/living/silicon/robot/Move(a, b, flag)

	. = ..()

	if(module)
		if(module.type == /obj/item/weapon/robot_module/scrubpup)//no water reserve mechanics yet.
			var/turf/tile = loc
			if(isturf(tile))
				tile.clean_blood()
				if(istype(tile, /turf/simulated))
					var/turf/simulated/T = tile
					T.dirt = 0
				for(var/A in tile)
					if(istype(A,/obj/effect/rune) || istype(A,/obj/effect/decal/cleanable) || istype(A,/obj/effect/overlay))
						qdel(A)
					else if(istype(A, /mob/living/carbon/human))
						var/mob/living/carbon/human/cleaned_human = A
						if(cleaned_human.lying)
							if(cleaned_human.head)
								cleaned_human.head.clean_blood()
								cleaned_human.update_inv_head(0)
							if(cleaned_human.wear_suit)
								cleaned_human.wear_suit.clean_blood()
								cleaned_human.update_inv_wear_suit(0)
							else if(cleaned_human.w_uniform)
								cleaned_human.w_uniform.clean_blood()
								cleaned_human.update_inv_w_uniform(0)
							if(cleaned_human.shoes)
								cleaned_human.shoes.clean_blood()
								cleaned_human.update_inv_shoes(0)
							cleaned_human.clean_blood(1)
							cleaned_human << "<span class='warning'>[src] cleans your face!</span>"//Again travis what the fuck? You and your random unrelated bugs.
		return
	return