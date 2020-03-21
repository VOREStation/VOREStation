/datum/species
	var/skull_type = /obj/item/weapon/digestion_remains/skull
/datum/species/tajaran
	skull_type = /obj/item/weapon/digestion_remains/skull/tajaran
/datum/species/unathi
	skull_type = /obj/item/weapon/digestion_remains/skull/unathi
/datum/species/skrell
	skull_type = /obj/item/weapon/digestion_remains/skull/skrell
/datum/species/spider
	skull_type = /obj/item/weapon/digestion_remains/skull/vasilissan
/datum/species/akula
	skull_type = /obj/item/weapon/digestion_remains/skull/akula
/datum/species/harpy
	skull_type = /obj/item/weapon/digestion_remains/skull/rapala
/datum/species/vulpkanin
	skull_type = /obj/item/weapon/digestion_remains/skull/vulpkanin
/datum/species/sergal
	skull_type = /obj/item/weapon/digestion_remains/skull/sergal
/datum/species/hi_zorren
	skull_type = /obj/item/weapon/digestion_remains/skull/zorren
/datum/species/nevrean
	skull_type = /obj/item/weapon/digestion_remains/skull/nevrean
/datum/species/teshari
	skull_type = /obj/item/weapon/digestion_remains/skull/teshari
/datum/species/vox
	skull_type = /obj/item/weapon/digestion_remains/skull/vox

/obj/belly/proc/handle_remains_leaving(var/mob/living/M)
	if(!ishuman(M))	//Are we even humanoid?
		return
	var/mob/living/carbon/human/H = M

	if((H.species.name in remainless_species) || H.isSynthetic())	//Don't leave anything if there is nothing to leave
		return

	var/bones_amount = rand(2,3) //some random variety in amount of bones left
	if(prob(20))	//ribcage surviving whole is some luck
		new /obj/item/weapon/digestion_remains/ribcage(src,owner)
		bones_amount--

	while(bones_amount)	//throw in the rest
		new /obj/item/weapon/digestion_remains(src,owner)
		bones_amount--

	var/skull_amount = 1
	if(H.species.skull_type)
		new H.species.skull_type(src, owner)
		skull_amount--
	
	if(skull_amount && H.species.selects_bodytype)
		// We still haven't found correct skull...
		if(H.species.base_species == SPECIES_HUMAN)
			new /obj/item/weapon/digestion_remains/skull/unknown(src,owner)
		else
			new /obj/item/weapon/digestion_remains/skull/unknown/anthro(src,owner)
	else if(skull_amount)
		// Something entirely different...
		new /obj/item/weapon/digestion_remains/skull/unknown(src,owner)


/obj/item/weapon/digestion_remains
	name = "bone"
	desc = "A bleached bone. It's very non-descript and its hard to tell what species or part of the body it came from."
	icon = 'icons/obj/bones_vr.dmi'
	icon_state = "generic"
	force = 0
	throwforce = 0
	item_state = "bone"
	w_class = ITEMSIZE_SMALL
	var/pred_ckey
	var/pred_name

/obj/item/weapon/digestion_remains/New(newloc, mob/living/pred)
	..(newloc)
	pred_ckey = pred.ckey
	pred_name = pred.name

/obj/item/weapon/digestion_remains/attack_self(mob/user)
	if(user.a_intent == I_HURT)
		to_chat(user,"<span class='warning'>As you squeeze the [name], it crumbles into dust and falls apart into nothing!</span>")
		qdel(src)

/obj/item/weapon/digestion_remains/ribcage
	name = "ribcage"
	desc = "A bleached ribcage. It's very white and definitely has seen better times. Hard to tell what it belonged to."
	icon_state = "ribcage"

/obj/item/weapon/digestion_remains/skull
	name = "skull"
	desc = "A bleached skull. It looks very weakened. Seems like it belonged to a human."
	icon_state = "skull"

/obj/item/weapon/digestion_remains/skull/tajaran
	desc = "A bleached skull. It looks very weakened. Seems like it belonged to a tajara."
	icon_state = "skull_taj"

/obj/item/weapon/digestion_remains/skull/unathi
	desc = "A bleached skull. It looks very weakened. Seems like it belonged to an unathi."
	icon_state = "skull_unathi"

/obj/item/weapon/digestion_remains/skull/skrell
	desc = "A bleached skull. It looks very weakened. Seems like it belonged to a skrell."
	icon_state = "skull"

/obj/item/weapon/digestion_remains/skull/vasilissan
	desc = "A bleached skull. It looks very weakened. Seems like it belonged to a vasilissan."
	icon_state = "skull"

/obj/item/weapon/digestion_remains/skull/akula
	desc = "A bleached skull. It looks very weakened. Seems like it belonged to an akula."
	icon_state = "skull_unathi"

/obj/item/weapon/digestion_remains/skull/rapala
	desc = "A bleached skull. It looks very weakened. Seems like it belonged to a rapala."
	icon_state = "skull"

/obj/item/weapon/digestion_remains/skull/vulpkanin
	desc = "A bleached skull. It looks very weakened. Seems like it belonged to a vulpkanin."
	icon_state = "skull_taj"

/obj/item/weapon/digestion_remains/skull/sergal
	desc = "A bleached skull. It looks very weakened. Seems like it belonged to a sergal."
	icon_state = "skull_taj"

/obj/item/weapon/digestion_remains/skull/zorren
	desc = "A bleached skull. It looks very weakened. Seems like it belonged to a zorren."
	icon_state = "skull_taj"

/obj/item/weapon/digestion_remains/skull/nevrean
	desc = "A bleached skull. It looks very weakened. Seems like it belonged to a nevrean."
	icon_state = "skull_taj"

/obj/item/weapon/digestion_remains/skull/teshari
	desc = "A bleached skull. It looks very weakened. Seems like it belonged to a teshari."
	icon_state = "skull_taj"

/obj/item/weapon/digestion_remains/skull/vox
	desc = "A bleached skull. It looks very weakened. Seems like it belonged to a vox."
	icon_state = "skull_taj"

/obj/item/weapon/digestion_remains/skull/unknown
	desc = "A bleached skull. It looks very weakened. You can't quite tell what species it belonged to."
	icon_state = "skull"

/obj/item/weapon/digestion_remains/skull/unknown/anthro
	icon_state = "skull_taj"
