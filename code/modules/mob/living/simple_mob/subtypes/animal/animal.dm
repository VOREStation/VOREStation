/mob/living/simple_mob/animal
	mob_class = MOB_CLASS_ANIMAL
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat

	response_help  = "pets"
	response_disarm = "shoos"
	response_harm   = "hits"

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
