/mob/living/silicon/robot
	var/sleeper_g
	var/sleeper_r
	var/leaping = 0
	var/pounce_cooldown = 0
	var/pounce_cooldown_time = 40
	var/leap_at
	var/dogborg = FALSE

/mob/living/silicon/robot/verb/robot_nom(var/mob/living/T in living_mobs(1))
	set name = "Robot Nom"
	set category = "IC"
	set desc = "Allows you to eat someone."

	if (stat != CONSCIOUS)
		return
	return feed_grabbed_to_self(src,T)

/mob/living/silicon/robot/updateicon()
	..()
	if(dogborg == TRUE && stat == CONSCIOUS)
		if(sleeper_g == TRUE)
			overlays += "[module_sprites[icontype]]-sleeper_g"
		if(sleeper_r == TRUE)
			overlays += "[module_sprites[icontype]]-sleeper_r"
		if(istype(module_active,/obj/item/weapon/gun/energy/laser/mounted))
			overlays += "laser"
		if(istype(module_active,/obj/item/weapon/gun/energy/taser/mounted/cyborg))
			overlays += "taser"
		if(resting)
			overlays.Cut() // Hide that gut for it has no ground sprite yo.
			icon_state = "[module_sprites[icontype]]-rest"
		else
			icon_state = "[module_sprites[icontype]]"
	if(dogborg == TRUE && stat == DEAD)
		icon_state = "[module_sprites[icontype]]-wreck"
		overlays += "wreck-overlay"

/mob/living/silicon/robot/Move(a, b, flag)

	. = ..()

	if(module)
		if(module.type == /obj/item/weapon/robot_module/robot/scrubpup)//no water reserve mechanics yet.
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
							cleaned_human << "<span class='warning'>[src] cleans your face!</span>"
		return
	return
