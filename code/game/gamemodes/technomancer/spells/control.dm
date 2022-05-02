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

<<<<<<< HEAD
/mob/living/carbon/human/proc/technomancer_control()
	place_spell_in_hand(/obj/item/weapon/spell/control)
=======
/mob/living/human/proc/technomancer_control()
	place_spell_in_hand(/obj/item/spell/control)
>>>>>>> 666428014d2... Merge pull request #8546 from Atermonera/surgery_refactor

/obj/item/weapon/spell/control
	name = "control"
	icon_state = "control"
	desc = "Now you can command your own army!"
	cast_methods = CAST_RANGED|CAST_USE
	aspect = ASPECT_BIOMED //Not sure if this should be something else.
	var/image/control_overlay = null
	var/list/controlled_mobs = list()
	var/allowed_mob_classes = MOB_CLASS_ANIMAL|MOB_CLASS_SYNTHETIC

//This unfortunately is gonna be rather messy due to the various mobtypes involved.
/obj/item/weapon/spell/control/proc/select(var/mob/living/L)
	if(!(L.mob_class & allowed_mob_classes))
		return FALSE

	if(!L.has_AI())
		return FALSE

	var/datum/ai_holder/AI = L.ai_holder
	AI.hostile = FALSE // The Technomancer chooses the target, not the AI.
	AI.retaliate = TRUE
	AI.wander = FALSE
	AI.forget_everything()

	if(istype(L, /mob/living/simple_mob))
		var/mob/living/simple_mob/SM = L
		SM.friends |= src.owner

	L.add_overlay(control_overlay, TRUE)
	controlled_mobs |= L

/obj/item/weapon/spell/control/proc/deselect(var/mob/living/L)
	if(!(L in controlled_mobs))
		return FALSE

	if(L.has_AI())
		var/datum/ai_holder/AI = L.ai_holder
		AI.hostile = initial(AI.hostile)
		AI.retaliate = initial(AI.retaliate)
		AI.wander = initial(AI.wander)
		AI.forget_everything()

	if(istype(L, /mob/living/simple_mob))
		var/mob/living/simple_mob/SM = L
		SM.friends -= owner

	L.cut_overlay(control_overlay, TRUE)
	controlled_mobs.Remove(L)

/obj/item/weapon/spell/control/proc/move_all(turf/T)
	for(var/mob/living/L in controlled_mobs)
		if(!L.has_AI() || L.stat)
			deselect(L)
			continue
		L.ai_holder.give_destination(T, 0, TRUE)

/obj/item/weapon/spell/control/proc/attack_all(mob/target)
	for(var/mob/living/L in controlled_mobs)
		if(!L.has_AI() || L.stat)
			deselect(L)
			continue
		L.ai_holder.give_target(target)

/obj/item/weapon/spell/control/Initialize()
	control_overlay = image('icons/obj/spells.dmi',"controlled")
	return ..()

/obj/item/weapon/spell/control/Destroy()
	for(var/mob/living/L in controlled_mobs)
		deselect(L)
	controlled_mobs = list()
	return ..()

/obj/item/weapon/spell/control/on_use_cast(mob/living/user)
	if(controlled_mobs.len != 0)
		var/choice = tgui_alert(user,"Would you like to release control of the entities you are controlling? They won't be friendly to you anymore if you do this, so be careful.","Release Control?",list("No","Yes"))
		if(choice == "Yes")
			for(var/mob/living/L in controlled_mobs)
				deselect(L)
			to_chat(user, "<span class='notice'>You've released control of all entities you had in control.</span>")


/obj/item/weapon/spell/control/on_ranged_cast(atom/hit_atom, mob/living/user)
	if(isliving(hit_atom))
		var/mob/living/L = hit_atom
		if(L == user && !controlled_mobs.len)
			to_chat(user, "<span class='warning'>This function doesn't work on higher-intelligence entities, however since you're \
			trying to use it on yourself, perhaps you're an exception?  Regardless, nothing happens.</span>")
			return 0

		if(L.mob_class & allowed_mob_classes)
			if(!(L in controlled_mobs)) //Selecting
				if(L.client)
					to_chat(user, "<span class='danger'>\The [L] seems to resist you!</span>")
					return 0
				if(!L.has_AI())
					to_chat(user, span("warning", "\The [L] seems too dim for this to work on them."))
					return FALSE
				if(pay_energy(500))
					select(L)
					to_chat(user, "<span class='notice'>\The [L] is now under your (limited) control.</span>")
			else //Deselect them
				deselect(L)
				to_chat(user, "<span class='notice'>You free \the [L] from your grasp.</span>")

		else //Let's attack
			if(!controlled_mobs.len)
				to_chat(user, "<span class='warning'>You have no entities under your control to command.</span>")
				return 0
			if(pay_energy(25 * controlled_mobs.len))
				attack_all(L)
				add_attack_logs(user,L,"Commanded their army of [controlled_mobs.len]")
				to_chat(user, "<span class='notice'>You command your [controlled_mobs.len > 1 ? "entities" : "[controlled_mobs[1]]"] to \
				attack \the [L].</span>")
				//This is to stop someone from controlling beepsky and getting him to stun someone 5 times a second.
				user.setClickCooldown(8)
				adjust_instability(controlled_mobs.len)

	else if(isturf(hit_atom))
		var/turf/T = hit_atom
		if(!controlled_mobs.len)
			to_chat(user, "<span class='warning'>You have no entities under your control to command.</span>")
			return 0
		if(pay_energy(10 * controlled_mobs.len))
			move_all(T)
			adjust_instability(controlled_mobs.len)
			to_chat(user, "<span class='notice'>You command your [controlled_mobs.len > 1 ? "entities" : "[controlled_mobs[1]]"] to move \
			towards \the [T].</span>")

