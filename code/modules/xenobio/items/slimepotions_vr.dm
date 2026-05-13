/obj/item/slimepotion/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/slimepotion/mimic))
		to_chat(user, span_notice("You apply the mimic to the slime potion as it copies it's effects."))
		playsound(src, 'sound/effects/bubbles.ogg', 50, 1)
		var/newtype = src.type
		new newtype(get_turf(src))
		qdel(O)
	..()


/obj/item/slimepotion/infertility
	name = "slime infertility agent"
	desc = "A potent chemical mix that will reduce the amount of offspring this slime will have."
	icon_state = "potpurple"
	description_info = "The slime needs to be alive for this to work. It will reduce the amount of slime babies by 2 (to minimum of 2)."

/obj/item/slimepotion/infertility/attack(mob/living/M, mob/living/user, target_zone, attack_modifier)
	if(!istype(M, /mob/living/simple_mob/slime/xenobio))
		to_chat(user, span_warning("The stabilizer only works on slimes!"))
		return ..()
	var/mob/living/simple_mob/slime/xenobio/xenobio_slime = M

	if(xenobio_slime.stat == DEAD)
		to_chat(user, span_warning("The slime is dead!"))
		return ..()
	if(xenobio_slime.split_amount <= 2)
		to_chat(user, span_warning("The slime cannot get any less fertile!"))
		return ..()

	to_chat(user, span_notice("You feed the slime the infertility agent. It will now have less offspring."))
	xenobio_slime.split_amount = between(2, xenobio_slime.split_amount - 2, 6)
	playsound(src, 'sound/effects/bubbles.ogg', 50, 1)
	qdel(src)
	return ITEM_INTERACT_SUCCESS

/obj/item/slimepotion/fertility
	name = "slime fertility agent"
	desc = "A potent chemical mix that will increase the amount of offspring this slime will have."
	icon_state = "potpurple"
	description_info = "The slime needs to be alive for this to work. It will increase the amount of slime babies by 2 (to maximum of 6)."

/obj/item/slimepotion/fertility/attack(mob/living/M, mob/living/user, target_zone, attack_modifier)
	if(!istype(M, /mob/living/simple_mob/slime/xenobio))
		to_chat(user, span_warning("The stabilizer only works on slimes!"))
		return ..()
	var/mob/living/simple_mob/slime/xenobio/xenobio_slime = M

	if(xenobio_slime.stat == DEAD)
		to_chat(user, span_warning("The slime is dead!"))
		return ..()
	if(xenobio_slime.split_amount >= 6)
		to_chat(user, span_warning("The slime cannot get any more fertile!"))
		return ..()

	to_chat(user, span_notice("You feed the slime the fertility agent. It will now have more offspring."))
	xenobio_slime.split_amount = between(2, xenobio_slime.split_amount + 2, 6)
	playsound(src, 'sound/effects/bubbles.ogg', 50, 1)
	qdel(src)
	return ITEM_INTERACT_SUCCESS

/obj/item/slimepotion/shrink
	name = "slime shrinking agent"
	desc = "A potent chemical mix that will turn adult slime into a baby one."
	icon_state = "potpurple"
	description_info = "The slime needs to be alive for this to work."

/obj/item/slimepotion/shrink/attack(mob/living/M, mob/living/user, target_zone, attack_modifier)
	if(!istype(M, /mob/living/simple_mob/slime/xenobio))
		to_chat(user, span_warning("The stabilizer only works on slimes!"))
		return ..()
	var/mob/living/simple_mob/slime/xenobio/xenobio_slime = M

	if(xenobio_slime.stat == DEAD)
		to_chat(user, span_warning("The slime is dead!"))
		return ..()
	if(!(xenobio_slime.is_adult))
		to_chat(user, span_warning("The slime is already a baby!"))
		return ..()

	to_chat(user, span_notice("You feed the slime the shrinking agent. It is now back to being a baby."))
	xenobio_slime.make_baby()
	playsound(src, 'sound/effects/bubbles.ogg', 50, 1)
	qdel(src)
	return ITEM_INTERACT_SUCCESS

/obj/item/slimepotion/death
	name = "slime death agent"
	desc = "A potent chemical mix that will instantly kill a slime."
	icon_state = "potblue"
	description_info = "The slime needs to be alive for this to work."

/obj/item/slimepotion/death/attack(mob/living/M, mob/living/user, target_zone, attack_modifier)
	if(!istype(M, /mob/living/simple_mob/slime/xenobio))
		to_chat(user, span_warning("The stabilizer only works on slimes!"))
		return ..()
	var/mob/living/simple_mob/slime/xenobio/xenobio_slime = M

	if(xenobio_slime.stat == DEAD)
		to_chat(user, span_warning("The slime is already dead!"))
		return ..()

	to_chat(user, span_notice("You feed the slime the death agent. Its face flashes pain of betrayal before it goes still."))
	xenobio_slime.adjustToxLoss(500)
	playsound(src, 'sound/effects/bubbles.ogg', 50, 1)
	qdel(src)
	return ITEM_INTERACT_SUCCESS

/obj/item/slimepotion/ferality
	name = "slime ferality agent"
	desc = "A potent chemical mix that will make a slime untamable."
	icon_state = "potred"
	description_info = "The slime needs to be alive for this to work."

/obj/item/slimepotion/ferality/attack(mob/living/M, mob/living/user, target_zone, attack_modifier)
	if(!istype(M, /mob/living/simple_mob/slime/xenobio))
		to_chat(user, span_warning("The stabilizer only works on slimes!"))
		return ..()
	var/mob/living/simple_mob/slime/xenobio/xenobio_slime = M

	if(xenobio_slime.stat == DEAD)
		to_chat(user, span_warning("The slime is already dead!"))
		return ..()
	if(xenobio_slime.untamable && xenobio_slime.untamable_inheirit)
		to_chat(user, span_warning("The slime is already untamable!"))
		return ..()

	to_chat(user, span_notice("You feed the slime the death agent. It will now only get angrier at taming attempts."))
	xenobio_slime.untamable = TRUE
	xenobio_slime.untamable_inheirit = TRUE
	playsound(src, 'sound/effects/bubbles.ogg', 50, 1)
	qdel(src)
	return ITEM_INTERACT_SUCCESS

/obj/item/slimepotion/reinvigoration
	name = "extract reinvigoration agent"
	desc = "A potent chemical mix that will create a slime of appropriate type out of an extract."
	icon_state = "potcyan"
	description_info = "This will even work on inert extracts. Extract is destroyed in process."

/obj/item/slimepotion/mimic
	name = "mimic agent"
	desc = "A potent chemical mix that will mimic effects of other slime-produced agents."
	icon_state = "potsilver"
	description_info = "Warning: avoid combining multiple doses of mimic agent."

/obj/item/slimepotion/mimic/attackby(mob/living/M, mob/living/user, target_zone, attack_modifier)
	if(istype(M, /obj/item/slimepotion/mimic))
		to_chat(user, span_warning("You apply the mimic to the mimic, resulting a mimic that copies a mimic that copies a mimic that copies a mimic that-"))
		var/location = get_turf(src)
		playsound(location, 'sound/weapons/gauss_shoot.ogg', 50, 1)
		var/datum/effect/effect/system/grav_pull/s = new /datum/effect/effect/system/grav_pull
		s.set_up(3, 3, location)
		s.start()
		qdel(M)
		qdel(src)
		return ITEM_INTERACT_SUCCESS
	..()

/obj/item/slimepotion/sapience
	name = "slime sapience agent"
	desc = "A potent chemical mix that makes an animal capable of developing more advanced, sapient thought."
	description_info = "The slime or other animal needs to be alive for this to work. The development is not always immedeate and may take indeterminate time before effects show."
	icon_state = "potblue"

/obj/item/slimepotion/sapience/attack(mob/living/M, mob/living/user, target_zone, attack_modifier)
	if(!istype(M, /mob/living/simple_mob/slime/xenobio))
		to_chat(user, span_warning("The stabilizer only works on slimes!"))
		return ..()
	var/mob/living/simple_mob/slime/xenobio/xenobio_slime = M

	if(xenobio_slime.stat == DEAD)
		to_chat(user, span_warning("The creature is dead!"))
		return ..()
	if(xenobio_slime.ghostjoin)
		to_chat(user, span_warning("The creature is already developing sapience."))
		return ..()
	if(xenobio_slime.ckey)
		to_chat(user, span_warning("The creature is already sapient!"))
		return ..()

	to_chat(user, span_notice("You feed \the [xenobio_slime] the agent. It may now eventually develop proper sapience."))
	xenobio_slime.ghostjoin = 1
	GLOB.active_ghost_pods |= xenobio_slime
	if(!xenobio_slime.vore_active)
		add_verb(xenobio_slime, /mob/living/simple_mob/proc/animal_nom)
	xenobio_slime.ghostjoin_icon()
	log_and_message_admins("used a sapience potion on a simple mob: [xenobio_slime]. [ADMIN_FLW(src)]", user)
	playsound(src, 'sound/effects/bubbles.ogg', 50, 1)
	qdel(src)
	return ITEM_INTERACT_SUCCESS

/obj/item/slimepotion/obedience
	name = "slime obedience agent"
	desc = "A potent chemical mix that makes slime extremely obedient."
	icon_state = "potlightpink"
	description_info = "The target needs to be alive and currently misbehaving. Effect is equivalent to very strong discipline."

/obj/item/slimepotion/obedience/attack(mob/living/M, mob/living/user, target_zone, attack_modifier)
	if(!istype(M, /mob/living/simple_mob/slime/xenobio))
		to_chat(user, span_warning("The stabilizer only works on slimes!"))
		return ..()
	var/mob/living/simple_mob/slime/xenobio/xenobio_slime = M

	if(xenobio_slime.stat == DEAD)
		to_chat(user, span_warning("The slime is dead!"))
		return ..()

	to_chat(user, span_notice("You feed the slime the agent. It has been disciplined, for better or worse..."))
	var/justified = xenobio_slime.is_justified_to_discipline()
	xenobio_slime.adjust_discipline(10)
	var/datum/ai_holder/simple_mob/xenobio_slime/AI = xenobio_slime.ai_holder
	if(istype(AI) && justified)
		AI.obedience = 10
	playsound(src, 'sound/effects/bubbles.ogg', 50, 1)
	qdel(src)
	return ITEM_INTERACT_SUCCESS
