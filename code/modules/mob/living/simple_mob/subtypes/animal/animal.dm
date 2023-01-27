/mob/living/simple_mob/animal
	mob_class = MOB_CLASS_ANIMAL
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat

	response_help  = "pets"
	response_disarm = "shoos"
	response_harm   = "hits"

	organ_names = /decl/mob_organ_names/quadruped

	ai_holder_type = /datum/ai_holder/simple_mob/melee

	internal_organs = list(\
		/obj/item/organ/internal/brain,\
		/obj/item/organ/internal/heart,\
		/obj/item/organ/internal/liver,\
		/obj/item/organ/internal/stomach,\
		/obj/item/organ/internal/intestine,\
		/obj/item/organ/internal/lungs\
		)

	butchery_loot = list(\
		/obj/item/stack/animalhide = 3\
		)

/decl/mob_organ_names/quadruped //Most subtypes have this basic body layout.
<<<<<<< HEAD
	hit_zones = list("head", "torso", "left foreleg", "right foreleg", "left hind leg", "right hind leg", "tail")
=======
	hit_zones = list("head", "torso", "left foreleg", "right foreleg", "left hind leg", "right hind leg", "tail")

/mob/living/simple_mob/animal/get_examine_desc()
	return flavor_text || desc

/mob/living/simple_mob/animal/verb/set_flavour_text()
	set name = "Set Flavour Text"
	set category = "IC"
	set desc = "Set your flavour text."
	set src = usr
	var/new_flavour_text = sanitize((input("Please describe yourself.", "Flavour Text", flavor_text) as message|null), MAX_MESSAGE_LEN)
	if(length(new_flavour_text) && !QDELETED(src))
		flavor_text = new_flavour_text
		to_chat(src, SPAN_NOTICE("Your flavour text has been updated."))

/mob/living/simple_mob/animal/leaves_tracks_type()
	return tracks_type

/mob/living/simple_mob/animal/proc/has_appetite()
	return TRUE

/mob/living/simple_mob/animal/proc/add_nutrition(var/amt)
	nutrition = clamp(nutrition + amt, 0, max_nutrition)

/mob/living/simple_mob/animal/proc/remove_nutrition(var/amt)
	nutrition = clamp(nutrition - amt, 0, max_nutrition)

/mob/living/simple_mob/animal/get_snow_footprint_state()
	if(!hovering)
		return "snow_animalprints"

/mob/living/simple_mob/animal/do_interaction(var/atom/A)

	// Can we do some critter interaction?
	var/static/list/atom_types_with_animal_interactions = list(
		/obj/structure/animal_den,
		/obj/structure/flora,
		/turf/simulated/floor/outdoors,
		/obj/item/organ,
		/obj/item/reagent_containers/food,
		/obj/machinery/door
	)
	for(var/checktype in atom_types_with_animal_interactions)
		if(istype(A, checktype))
			A.attack_generic(src, 0, "investigates")
			return TRUE

	// Can we eat a dead guy?
	if(scavenger && isliving(A) && a_intent == I_HURT)
		var/mob/living/M = A
		if(M.stat == DEAD && length(M.internal_organs))

			if(!has_appetite())
				to_chat(src, SPAN_WARNING("You don't have much of an appetite at the moment."))
				return TRUE

			to_chat(src, SPAN_NOTICE("You dig into the guts of \the [M], hunting for the sweetest meat."))
			set_AI_busy(TRUE)
			if(do_after(src, 2 SECONDS, M) && !QDELETED(M) && length(M.internal_organs))
				var/obj/item/organ = M.rip_out_internal_organ(check_zone(zone_sel?.selecting), damage_descriptor = "animal teeth")
				if(organ)
					visible_message(SPAN_DANGER("\The [src] rips \the [organ] out of \the [M] and devours [organ.gender == PLURAL ? "them" : "it"]!"))
					eat_food_item(organ)
					if(!length(M.internal_organs) && M.gib_on_butchery)
						M.gib()
			set_AI_busy(FALSE)
			return TRUE
	return ..()

/mob/living/simple_mob/animal/proc/eat_food_item(var/obj/item/snack, var/override_bitesize, var/silent)

	if(istype(snack, /obj/item/organ))
		var/obj/item/organ/organ = snack
		if(organ.meat_type)
			snack = new organ.meat_type(src)
			qdel(organ)
	else if(!istype(snack) || !snack.reagents?.total_volume)
		to_chat(src, SPAN_WARNING("\The [snack] doesn't seem edible."))
		return

	if(!silent)
		visible_message("<b>\The [src]</b> nibbles away at \the [snack].")
		playsound(src, 'sound/items/eatfood.ogg', rand(10,50), 1)

	if(snack.reagents?.total_volume)
		var/use_bitesize = max(override_bitesize, bitesize)
		var/removing_reagents = clamp(use_bitesize, 0, min(max(0, reagents?.maximum_volume - reagents?.total_volume), snack.reagents.total_volume))
		if(reagents && removing_reagents)
			snack.reagents.trans_to_holder(reagents, removing_reagents)
		else
			snack.reagents.trans_to_mob(src, use_bitesize, CHEM_INGEST)

	// If there's some left, drop it onto the ground.
	if(snack.reagents?.total_volume > 0)
		snack.dropInto(loc)
	else
		snack.animal_consumed(src)

/mob/living/simple_mob/animal/proc/get_dietary_food_modifier(var/datum/reagent/nutriment/food)
	return 1
>>>>>>> 5ce4801b708... Merge pull request #8894 from MistakeNot4892/flavour
