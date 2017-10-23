/datum/technomancer/spell/control
	name = "Control"
	desc = "This function allows you to exert control over simple-minded entities to an extent, such as spiders and carp.  \
	Controlled entities will not be hostile towards you, and you may direct them to move to specific areas or to attack specific \
	targets.  This function will have no effect on entities of higher intelligence, such as humans and similar alien species, as it's \
	not true mind control, but merely pheromone synthesis for living animals, and electronic hacking for simple robots.  The green web \
	around the entity is merely a hologram used to allow the user to know if the creature is safe or not."
	cost = 100
	obj_path = /obj/item/weapon/spell/control
	ability_icon_state = "tech_control"
	category = UTILITY_SPELLS

/mob/living/carbon/human/proc/technomancer_control()
	place_spell_in_hand(/obj/item/weapon/spell/control)

/obj/item/weapon/spell/control
	name = "control"
	icon_state = "control"
	desc = "Now you can command your own army!"
	cast_methods = CAST_RANGED|CAST_USE
	aspect = ASPECT_BIOMED //Not sure if this should be something else.
	var/image/control_overlay = null
	var/list/controlled_mobs = list()
	var/list/allowed_mobs = list(
		/mob/living/bot,
		/mob/living/simple_animal/cat,
		/mob/living/simple_animal/chick,
		/mob/living/simple_animal/chicken,
		/mob/living/simple_animal/corgi,
		/mob/living/simple_animal/cow,
		/mob/living/simple_animal/crab,
		/mob/living/simple_animal/lizard,
		/mob/living/simple_animal/mouse,
		/mob/living/simple_animal/parrot,
		/mob/living/simple_animal/slime,
//		/mob/living/simple_animal/adultslime,
		/mob/living/simple_animal/tindalos,
		/mob/living/simple_animal/yithian,
		/mob/living/simple_animal/hostile/scarybat,
		/mob/living/simple_animal/hostile/viscerator,
		/mob/living/simple_animal/hostile/malf_drone,
		/mob/living/simple_animal/hostile/giant_spider,
		/mob/living/simple_animal/hostile/hivebot,
		/mob/living/simple_animal/hostile/diyaab, //Doubt these will get used but might as well,
		/mob/living/simple_animal/hostile/samak,
		/mob/living/simple_animal/hostile/shantak
		)

//This unfortunately is gonna be rather messy due to the various mobtypes involved.
/obj/item/weapon/spell/control/proc/select(var/mob/living/L)
	if(!(is_type_in_list(L, allowed_mobs)))
		return 0

	if(istype(L, /mob/living/simple_animal))
		var/mob/living/simple_animal/SA = L
		SA.ai_inactive = 1
		SA.friends |= src.owner
		SA.stance = STANCE_IDLE

	L.overlays |= control_overlay
	controlled_mobs |= L

/obj/item/weapon/spell/control/proc/deselect(var/mob/living/L)
	if(!(L in controlled_mobs))
		return 0

	if(istype(L, /mob/living/simple_animal))
		var/mob/living/simple_animal/SA = L
		SA.ai_inactive = 1
		if(istype(SA, /mob/living/simple_animal/hostile))
			var/mob/living/simple_animal/hostile/SAH = SA
			SAH.friends.Remove(owner)

	L.overlays.Remove(control_overlay)
	controlled_mobs.Remove(L)

/obj/item/weapon/spell/control/proc/move_all(turf/T)
	for(var/mob/living/living in controlled_mobs)
		if(living.stat)
			deselect(living)
			continue
		if(istype(living, /mob/living/simple_animal))
			var/mob/living/simple_animal/SA = living
			SA.target_mob = null
			SA.stance = STANCE_IDLE
			walk_towards(SA,T,SA.speed)
		else
			walk_towards(living,T,5)

/obj/item/weapon/spell/control/proc/attack_all(mob/target)
	for(var/mob/living/L in controlled_mobs)
		if(L.stat)
			deselect(L)
			continue
		if(istype(L, /mob/living/simple_animal/hostile))
			var/mob/living/simple_animal/hostile/SAH
			SAH.target_mob = target
		else if(istype(L, /mob/living/bot))
			var/mob/living/bot/B = L
			B.UnarmedAttack(L)

/obj/item/weapon/spell/control/New()
	control_overlay = image('icons/obj/spells.dmi',"controlled")
	..()

/obj/item/weapon/spell/control/Destroy()
	for(var/mob/living/simple_animal/hostile/SM in controlled_mobs)
		deselect(SM)
	controlled_mobs = list()
	return ..()

/obj/item/weapon/spell/control/on_use_cast(mob/living/user)
	if(controlled_mobs.len != 0)
		var/choice = alert(user,"Would you like to release control of the entities you are controlling?  They won't be friendly \
		to you anymore if you do this, so be careful.","Release Control?","No","Yes")
		if(choice == "Yes")
			for(var/mob/living/L in controlled_mobs)
				deselect(L)
			user << "<span class='notice'>You've released control of all entities you had in control.</span>"


/obj/item/weapon/spell/control/on_ranged_cast(atom/hit_atom, mob/living/user)
	if(isliving(hit_atom))
		var/mob/living/L = hit_atom
		if(L == user && !controlled_mobs.len)
			user << "<span class='warning'>This function doesn't work on higher-intelligence entities, however since you're \
			trying to use it on yourself, perhaps you're an exception?  Regardless, nothing happens.</span>"
			return 0

		if(is_type_in_list(L, allowed_mobs))
			if(!(L in controlled_mobs)) //Selecting
				if(L.client)
					user << "<span class='danger'>\The [L] seems to resist you!</span>"
					return 0
				if(pay_energy(500))
					select(L)
					user << "<span class='notice'>\The [L] is now under your (limited) control.</span>"
			else //Deselect them
				deselect(L)
				user << "<span class='notice'>You free \the [L] from your grasp.</span>"

		else //Let's attack
			if(!controlled_mobs.len)
				user << "<span class='warning'>You have no entities under your control to command.</span>"
				return 0
			if(pay_energy(25 * controlled_mobs.len))
				attack_all(L)
				log_and_message_admins("has commanded their army of [controlled_mobs.len] to attack [L].")
				user << "<span class='notice'>You command your [controlled_mobs.len > 1 ? "entities" : "[controlled_mobs[1]]"] to \
				attack \the [L].</span>"
				//This is to stop someone from controlling beepsky and getting him to stun someone 5 times a second.
				user.setClickCooldown(8)
				adjust_instability(controlled_mobs.len)

	else if(isturf(hit_atom))
		var/turf/T = hit_atom
		if(!controlled_mobs.len)
			user << "<span class='warning'>You have no entities under your control to command.</span>"
			return 0
		if(pay_energy(10 * controlled_mobs.len))
			move_all(T)
			adjust_instability(controlled_mobs.len)
			user << "<span class='notice'>You command your [controlled_mobs.len > 1 ? "entities" : "[controlled_mobs[1]]"] to move \
			towards \the [T].</span>"

