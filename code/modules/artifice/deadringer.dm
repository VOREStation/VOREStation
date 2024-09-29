/obj/item/deadringer
	name = "silver pocket watch"
	desc = "A fancy silver-plated digital pocket watch. Looks expensive."
	icon = 'icons/obj/deadringer.dmi'
	icon_state = "deadringer"
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_ID | SLOT_BELT | SLOT_TIE
	origin_tech = list(TECH_ILLEGAL = 3)
	var/activated = 0
	var/timer = 0
	var/bruteloss_prev = 999999
	var/fireloss_prev = 999999
	var/mob/living/carbon/human/corpse = null
	var/mob/living/carbon/human/watchowner = null


/obj/item/deadringer/New()
	..()
	START_PROCESSING(SSobj, src)

/obj/item/deadringer/Destroy() //just in case some smartass tries to stay invisible by destroying the watch
	reveal()
	STOP_PROCESSING(SSobj, src)
	..()

/obj/item/deadringer/dropped()
	if(timer > 20)
		reveal()
		watchowner = null
	return

/obj/item/deadringer/attack_self(var/mob/living/user as mob)
	var/mob/living/H = src.loc
	if (!istype(H, /mob/living/carbon/human))
		to_chat(H, span_blue("You have no clue what to do with this thing."))
		return
	if(!activated)
		if(timer == 0)
			to_chat(H, span_blue("You press a small button on [src]'s side. It starts to hum quietly."))
			bruteloss_prev = H.getBruteLoss()
			fireloss_prev = H.getFireLoss()
			activated = 1
			return
		else
			to_chat(H, span_blue("You press a small button on [src]'s side. It buzzes a little."))
			return
	if(activated)
		to_chat(H, span_blue("You press a small button on [src]'s side. It stops humming."))
		activated = 0
		return

/obj/item/deadringer/process()
	if(activated)
		if (ismob(src.loc))
			var/mob/living/carbon/human/H = src.loc
			watchowner = H
			if(H.getBruteLoss() > bruteloss_prev || H.getFireLoss() > fireloss_prev)
				deathprevent()
				activated = 0
				if(watchowner.isSynthetic())
					to_chat(watchowner, span_blue("You fade into nothingness! [src]'s screen blinks, being unable to copy your synthetic body!"))
				else
					to_chat(watchowner, span_blue("You fade into nothingness, leaving behind a fake body!"))
				icon_state = "deadringer_cd"
				timer = 50
				return
	if(timer > 0)
		timer--
	if(timer == 20)
		reveal()
		if(corpse)
			new /obj/effect/effect/smoke/chem(corpse.loc)
			qdel(corpse)
	if(timer == 0)
		icon_state = "deadringer"
	return

/obj/item/deadringer/proc/deathprevent()
	for(var/mob/living/simple_mob/D in oviewers(7, src))
		if(!D.has_AI())
			continue
		D.ai_holder.lose_target()

	watchowner.emote("deathgasp")
	watchowner.alpha = 15
	makeacorpse(watchowner)
	return

/obj/item/deadringer/proc/reveal()
	if(watchowner)
		watchowner.alpha = 255
		playsound(src, 'sound/effects/uncloak.ogg', 35, 1, -1)
	return

/obj/item/deadringer/proc/makeacorpse(var/mob/living/carbon/human/H)
	if(H.isSynthetic())
		return
	corpse = new /mob/living/carbon/human(H.loc)
	corpse.setDNA(H.dna.Clone())
	corpse.death(1) //Kills the new mob
	var/obj/item/clothing/temp = null
	if(H.get_equipped_item(slot_w_uniform))
		corpse.equip_to_slot_or_del(new /obj/item/clothing/under/chameleon/changeling(corpse), slot_w_uniform)
		temp = corpse.get_equipped_item(slot_w_uniform)
		var/obj/item/clothing/c_type = H.get_equipped_item(slot_w_uniform)
		temp.disguise(c_type.type)
		temp.canremove = FALSE
	if(H.get_equipped_item(slot_wear_suit))
		corpse.equip_to_slot_or_del(new /obj/item/clothing/suit/chameleon/changeling(corpse), slot_wear_suit)
		temp = corpse.get_equipped_item(slot_wear_suit)
		var/obj/item/clothing/c_type = H.get_equipped_item(slot_wear_suit)
		temp.disguise(c_type.type)
		temp.canremove = FALSE
	if(H.get_equipped_item(slot_shoes))
		corpse.equip_to_slot_or_del(new /obj/item/clothing/shoes/chameleon/changeling(corpse), slot_shoes)
		temp = corpse.get_equipped_item(slot_shoes)
		var/obj/item/clothing/c_type = H.get_equipped_item(slot_shoes)
		temp.disguise(c_type.type)
		temp.canremove = FALSE
	if(H.get_equipped_item(slot_gloves))
		corpse.equip_to_slot_or_del(new /obj/item/clothing/gloves/chameleon/changeling(corpse), slot_gloves)
		temp = corpse.get_equipped_item(slot_gloves)
		var/obj/item/clothing/c_type = H.get_equipped_item(slot_gloves)
		temp.disguise(c_type.type)
		temp.canremove = FALSE
	if(H.get_equipped_item(slot_l_ear))
		temp = H.get_equipped_item(slot_l_ear)
		corpse.equip_to_slot_or_del(new temp.type(corpse), slot_l_ear)
		temp = corpse.get_equipped_item(slot_l_ear)
		temp.canremove = FALSE
	if(H.get_equipped_item(slot_glasses))
		corpse.equip_to_slot_or_del(new /obj/item/clothing/glasses/chameleon/changeling(corpse), slot_glasses)
		temp = corpse.get_equipped_item(slot_glasses)
		var/obj/item/clothing/c_type = H.get_equipped_item(slot_glasses)
		temp.disguise(c_type.type)
		temp.canremove = FALSE
	if(H.get_equipped_item(slot_wear_mask))
		corpse.equip_to_slot_or_del(new /obj/item/clothing/mask/chameleon/changeling(corpse), slot_wear_mask)
		temp = corpse.get_equipped_item(slot_wear_mask)
		var/obj/item/clothing/c_type = H.get_equipped_item(slot_wear_mask)
		temp.disguise(c_type.type)
		temp.canremove = FALSE
	if(H.get_equipped_item(slot_head))
		corpse.equip_to_slot_or_del(new /obj/item/clothing/head/chameleon/changeling(corpse), slot_head)
		temp = corpse.get_equipped_item(slot_head)
		var/obj/item/clothing/c_type = H.get_equipped_item(slot_head)
		temp.disguise(c_type.type)
		temp.canremove = FALSE
	if(H.get_equipped_item(slot_belt))
		corpse.equip_to_slot_or_del(new /obj/item/storage/belt/chameleon/changeling(corpse), slot_belt)
		temp = corpse.get_equipped_item(slot_belt)
		var/obj/item/clothing/c_type = H.get_equipped_item(slot_belt)
		temp.disguise(c_type.type)
		temp.canremove = FALSE
	if(H.get_equipped_item(slot_back))
		corpse.equip_to_slot_or_del(new /obj/item/storage/backpack/chameleon/changeling(corpse), slot_back)
		temp = corpse.get_equipped_item(slot_back)
		var/obj/item/clothing/c_type = H.get_equipped_item(slot_back)
		temp.disguise(c_type.type)
		temp.canremove = FALSE
	corpse.identifying_gender = H.identifying_gender
	corpse.flavor_texts = H.flavor_texts.Copy()
	corpse.real_name = H.real_name
	corpse.name = H.name
	corpse.set_species(corpse.dna.species)
	corpse.change_hair(H.h_style)
	corpse.change_facial_hair(H.f_style)
	corpse.change_hair_color(H.r_hair, H.g_hair, H.b_hair)
	corpse.change_facial_hair_color(H.r_facial, H.g_facial, H.b_facial)
	corpse.change_skin_color(H.r_skin, H.g_skin, H.b_skin)
	corpse.adjustFireLoss(H.getFireLoss())
	corpse.adjustBruteLoss(H.getBruteLoss())
	corpse.UpdateAppearance()
	corpse.regenerate_icons()
	QDEL_NULL_LIST(corpse.internal_organs)
