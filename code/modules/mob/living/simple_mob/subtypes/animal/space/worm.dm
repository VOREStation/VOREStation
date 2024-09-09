/mob/living/simple_mob/animal/space/space_worm
	name = "space worm segment"
	desc = "A part of a space worm."
	icon = 'icons/mob/worm.dmi'
	icon_state = "spaceworm"
	icon_living = "spaceworm"
	icon_dead = "spacewormdead"

	tt_desc = "U Tyranochaetus imperator"

	anchored = TRUE	// Theoretically, you shouldn't be able to move this without moving the head.

	maxHealth = 200
	health = 200
	movement_cooldown = -1

	faction = "worm"

	status_flags = 0
	universal_speak = 0
	universal_understand = 1
	animate_movement = SYNC_STEPS

	response_help  = "touches"
	response_disarm = "flails at"
	response_harm   = "punches the"

	harm_intent_damage = 2

	attacktext = list("slammed")

	organ_names = /decl/mob_organ_names

	ai_holder_type = /datum/ai_holder/simple_mob/inert

	mob_class = MOB_CLASS_ABERRATION	// It's a monster.

	meat_amount = 10
	meat_type = /obj/item/reagent_containers/food/snacks/meat/worm

	var/mob/living/simple_mob/animal/space/space_worm/previous //next/previous segments, correspondingly
	var/mob/living/simple_mob/animal/space/space_worm/next     //head is the nextest segment

	var/severed = FALSE	// Is this a severed segment?

	var/severed_head_type = /mob/living/simple_mob/animal/space/space_worm/head/severed	// What type of head do we spawn when detaching?
	var/segment_type = /mob/living/simple_mob/animal/space/space_worm	// What type of segment do our heads make?

	var/stomachProcessProbability = 50
	var/digestionProbability = 20
	var/flatPlasmaValue = 5 //flat Phoron amount given for non-items

	var/atom/currentlyEating // Worm's current Maw target.

	var/z_transitioning = FALSE	// Are we currently moving between Z-levels, or doing something that might mean we can't rely on distance checking for segments?
	var/sever_chunks = FALSE	// Do we fall apart when dying?

	var/time_maw_opened = 0
	var/maw_cooldown = 30 SECONDS
	var/open_maw = FALSE	// Are we trying to eat things?

/mob/living/simple_mob/animal/space/space_worm/head
	name = "space worm"
	icon_state = "spacewormhead"
	icon_living = "spacewormhead"

	anchored = FALSE	// You can pull the head to pull the body.

	maxHealth = 300
	health = 300

	hovering = TRUE

	melee_damage_lower = 10
	melee_damage_upper = 25
	attack_sharp = TRUE
	attack_edge = TRUE
	attack_armor_pen = 30
	attacktext = list("bitten", "gored", "gouged", "chomped", "slammed")

	animate_movement = SLIDE_STEPS

	var/segment_count = 6

/mob/living/simple_mob/animal/space/space_worm/head/severed
	segment_count = 0
	severed = TRUE

/mob/living/simple_mob/animal/space/space_worm/head/short
	segment_count = 3

/mob/living/simple_mob/animal/space/space_worm/head/long
	segment_count = 10

/mob/living/simple_mob/animal/space/space_worm/head/handle_special()
	..()
	update_body_faction()

/mob/living/simple_mob/animal/space/space_worm/head/update_icon()
	..()
	if(!open_maw && !stat)
		icon_state = "[icon_living][previous ? 1 : 0]_hunt"
	else
		icon_state = "[icon_living][previous ? 1 : 0]"

	if(previous)
		set_dir(get_dir(previous,src))

	if(stat)
		icon_state = "[icon_state]_dead"

/mob/living/simple_mob/animal/space/space_worm/head/Initialize()
	. = ..()

	var/mob/living/simple_mob/animal/space/space_worm/current = src

	if(segment_count && !severed)
		for(var/i = 1 to segment_count)
			var/mob/living/simple_mob/animal/space/space_worm/newSegment = new segment_type(loc)
			current.Attach(newSegment)
			current = newSegment
			current.faction = faction

/mob/living/simple_mob/animal/space/space_worm/head/verb/toggle_devour()
	set name = "Toggle Feeding"
	set desc = "Extends your teeth for 30 seconds so that you can chew through mobs and structures alike."
	set category = "Abilities"

	if(world.time < time_maw_opened + maw_cooldown)
		if(open_maw)
			to_chat(src, "<span class='notice'>You retract your teeth.</span>")
			time_maw_opened -= maw_cooldown / 2	// Recovers half cooldown if you end it early manually.
		else
			to_chat(src, "<span class='notice'>You are too tired to do this..</span>")
		set_maw(FALSE)
	else
		set_maw(!open_maw)

/mob/living/simple_mob/animal/space/space_worm/proc/set_maw(var/state = FALSE)
	open_maw = state
	if(open_maw)
		time_maw_opened = world.time
		movement_cooldown = initial(movement_cooldown) + 1.5
	else
		movement_cooldown = initial(movement_cooldown)
	update_icon()

/mob/living/simple_mob/animal/space/space_worm/death()
	..()

	DumpStomach()

	if(previous)
		previous.death()

/mob/living/simple_mob/animal/space/space_worm/handle_special()	// Processed in life. Nicer to have it modular incase something in Life change(d)(s)
	..()

	if(world.time > time_maw_opened + maw_cooldown)	// Auto-stop eating.
		if(open_maw)
			to_chat(src, "<span class='notice'>Your jaws cannot remain open..</span>")
			set_maw(FALSE)

	if(next && !(next in view(src,1)) && !z_transitioning)
		Detach(1)

	if(stat == DEAD && sever_chunks) // Dead chunks fall off and die immediately if we sever_chunks
		if(previous)
			previous.Detach(1)
		if(next)
			Detach(1)

	if(prob(stomachProcessProbability))
		ProcessStomach()

	update_icon()

	return

/mob/living/simple_mob/animal/space/space_worm/CanPass(atom/movable/mover, turf/target)
	if(istype(mover, /mob/living/simple_mob/animal/space/space_worm/head))
		var/mob/living/simple_mob/animal/space/space_worm/head/H = mover
		if(H.previous == src)
			return FALSE

	if(istype(mover, /mob/living/simple_mob/animal/space/space_worm))	// Worms don't run over worms. That's weird. And also really annoying.
		return TRUE
	else if(src.stat == DEAD && !istype(mover, /obj/item/projectile))	// Projectiles need to do their normal checks.
		return TRUE
	return ..()

/mob/living/simple_mob/animal/space/space_worm/Destroy() // If a chunk is destroyed, kill the back half.
	DumpStomach()
	if(previous)
		previous.Detach(1)
	if(next)
		next.previous = null
		next = null
	..()

/mob/living/simple_mob/animal/space/space_worm/Moved(atom/old_loc, direction, forced = FALSE)
	. = ..()
	if(previous)
		if(previous.z != z)
			previous.z_transitioning = TRUE
		else
			previous.z_transitioning = FALSE
		previous.forceMove(old_loc)	// None of this 'ripped in half by an airlock' business.
	update_icon()

/mob/living/simple_mob/animal/space/space_worm/head/Bump(atom/obstacle)
	if(open_maw && !stat && obstacle != previous)
		spawn(1)
			if(currentlyEating != obstacle)
				currentlyEating = obstacle

			set_AI_busy(TRUE)
			if(AttemptToEat(obstacle))
				currentlyEating = null
			set_AI_busy(FALSE)
	else
		currentlyEating = null
		. = ..(obstacle)

/mob/living/simple_mob/animal/space/space_worm/update_icon()
	if(previous) //midsection
		icon_state = "spaceworm[get_dir(src,previous) | get_dir(src,next)]"
		if(stat)
			icon_state = "[icon_state]_dead"

	else //tail
		icon_state = "spacewormtail"
		if(stat)
			icon_state = "[icon_state]_dead"
		set_dir(get_dir(src,next))

	if(next)
		color = next.color

	return

/mob/living/simple_mob/animal/space/space_worm/proc/AttemptToEat(var/atom/target)
	if(istype(target,/turf/simulated/wall))
		var/turf/simulated/wall/W = target
		if((!W.reinf_material && do_after(src, 5 SECONDS)) || do_after(src, 10 SECONDS)) // 10 seconds for an R-wall, 5 seconds for a normal one.
			if(target)
				W.dismantle_wall()
				return 1
	else if(istype(target,/atom/movable))
		if(istype(target,/mob) || do_after(src, 5)) // 5 ticks to eat stuff like tables.
			var/atom/movable/objectOrMob = target
			if(istype(objectOrMob, /obj/machinery/door))	// Doors and airlocks take time based on their durability and our damageo.
				var/obj/machinery/door/D = objectOrMob
				var/total_hits = max(2, round(D.maxhealth / (2 * melee_damage_upper)))

				for(var/I = 1 to total_hits)

					if(!D)
						objectOrMob = null
						break

					if(do_after(src, 5))
						D.visible_message("<span class='danger'>Something crashes against \the [D]!</span>")
						D.take_damage(2 * melee_damage_upper)
					else
						objectOrMob = null
						break

					if(D && (D.stat & BROKEN|NOPOWER))
						D.open(TRUE)
						break

			if(istype(objectOrMob, /obj/effect/energy_field))
				var/obj/effect/energy_field/EF = objectOrMob
				objectOrMob = null	// No eating shields.
				if(EF.opacity)
					EF.visible_message("<span class='danger'>Something begins forcing itself through \the [EF]!</span>")
				else
					EF.visible_message("<span class='danger'>\The [src] begins forcing itself through \the [EF]!</span>")
				if(do_after(src, EF.strength * 5))
					EF.adjust_strength(rand(-8, -10))
					EF.visible_message("<span class='danger'>\The [src] crashes through \the [EF]!</span>")
				else
					EF.visible_message("<span class='danger'>\The [EF] reverberates as it returns to normal.</span>")

			if(objectOrMob)
				objectOrMob.update_nearby_tiles(need_rebuild=1)
				objectOrMob.forceMove(src)
				return 1

	return 0

/mob/living/simple_mob/animal/space/space_worm/proc/Attach(var/mob/living/simple_mob/animal/space/space_worm/attachement)
	if(!attachement)
		return

	previous = attachement
	attachement.next = src

	return

/mob/living/simple_mob/animal/space/space_worm/proc/Detach(die = 0)
	var/mob/living/simple_mob/animal/space/space_worm/head/newHead = new severed_head_type(loc,0)
	var/mob/living/simple_mob/animal/space/space_worm/newHeadPrevious = previous

	previous = null //so that no extra heads are spawned

	newHead.Attach(newHeadPrevious)

	if(die)
		newHead.death()

	qdel(src)

/mob/living/simple_mob/animal/space/space_worm/proc/ProcessStomach()
	for(var/atom/movable/stomachContent in contents)
		if(stomach_special(stomachContent))
			continue
		if(prob(digestionProbability))
			if(stomach_special_digest(stomachContent))
				continue
			if(istype(stomachContent,/obj/item/stack)) //converts to plasma, keeping the stack value
				if(!istype(stomachContent,/obj/item/stack/material/phoron))
					var/obj/item/stack/oldStack = stomachContent
					new /obj/item/stack/material/phoron(src, oldStack.get_amount())
					qdel(oldStack)
					continue
			else if(istype(stomachContent,/obj/item)) //converts to plasma, keeping the w_class
				var/obj/item/oldItem = stomachContent
				new /obj/item/stack/material/phoron(src, oldItem.w_class)
				qdel(oldItem)
				continue
			else
				new /obj/item/stack/material/phoron(src, flatPlasmaValue) //just flat amount
				if(!isliving(stomachContent))
					qdel(stomachContent)
				else
					var/mob/living/L = stomachContent
					if(iscarbon(L))
						var/mob/living/carbon/C = L
						var/damage_cycles = rand(3, 5)
						for(var/I = 0, I < damage_cycles, I++)
							C.apply_damage(damage = rand(10,20), damagetype = BIOACID, def_zone = pick(BP_ALL))
					else
						L.apply_damage(damage = rand(10,60), damagetype = BIOACID)
				continue

	DumpStomach()

	return

/mob/living/simple_mob/animal/space/space_worm/proc/DumpStomach()
	if(previous && previous.stat != DEAD)
		for(var/atom/movable/stomachContent in contents) //transfer it along the digestive tract
			stomachContent.forceMove(previous)
	else
		for(var/atom/movable/stomachContent in contents) // Or dump it out.
			stomachContent.forceMove(get_turf(src))
	return

/mob/living/simple_mob/animal/space/space_worm/proc/stomach_special(var/atom/A)	// Futureproof. Anything that interacts with contents without relying on digestion probability. Return TRUE if it should skip digest.
	return FALSE

/mob/living/simple_mob/animal/space/space_worm/proc/stomach_special_digest(var/atom/A)	// Futureproof. Any special checks that interact with digested atoms. I.E., ore processing. Return TRUE if it should skip future digest checks.
	return FALSE

/mob/living/simple_mob/animal/space/space_worm/proc/update_body_faction()
	if(next)	// Keep us on the same page, here.
		faction = next.faction
	if(previous)
		previous.update_body_faction()
		return 1
	return 0
