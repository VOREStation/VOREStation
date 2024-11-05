/mob/living/simple_mob/animal
	mob_class = MOB_CLASS_ANIMAL
	meat_type = /obj/item/reagent_containers/food/snacks/meat

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
	hit_zones = list("head", "torso", "left foreleg", "right foreleg", "left hind leg", "right hind leg", "tail")

/mob/living/simple_mob/animal/get_examine_desc()
	return flavor_text || desc

/mob/living/simple_mob/animal/verb/set_flavour_text()
	set name = "Set Flavour Text"
	set category = "IC.Settings"
	set desc = "Set your flavour text."
	set src = usr
	var/new_flavour_text = sanitize((input("Please describe yourself.", "Flavour Text", flavor_text) as message|null), MAX_MESSAGE_LEN)
	if(length(new_flavour_text) && !QDELETED(src))
		flavor_text = new_flavour_text
		to_chat(src, span_notice("Your flavour text has been updated."))
