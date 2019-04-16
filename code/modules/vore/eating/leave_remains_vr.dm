/obj/belly/proc/handle_remains_leaving(var/mob/living/M)

	if(istype(M,/mob/living/carbon/human))	//Are we even humanoid?
		var/mob/living/carbon/human/H = M

		if((H.species.name in remainless_species) || H.isSynthetic())	//Don't leave anything if there is nothing to leave
			return

		else
			var/bones_amount = rand(2,3) //some random variety in amount of bones left

			if(prob(20))	//ribcage surviving whole is some luck
				new /obj/item/weapon/digestion_remains/ribcage(src,owner)
				bones_amount--

			while(bones_amount)	//throw in the rest
				new /obj/item/weapon/digestion_remains(src,owner)
				bones_amount--

			var/skull_amount = 1
			switch(H.species.name)	//oh boy here we go, finding us a right skull
				if(SPECIES_HUMAN)
					new /obj/item/weapon/digestion_remains/skull(src,owner)
					skull_amount--
				if(SPECIES_TAJ)
					new /obj/item/weapon/digestion_remains/skull/tajaran(src,owner)
					skull_amount--
				if(SPECIES_UNATHI)
					new /obj/item/weapon/digestion_remains/skull/unathi(src,owner)
					skull_amount--
				if(SPECIES_SKRELL)
					new /obj/item/weapon/digestion_remains/skull/skrell(src,owner)
					skull_amount--
				if(SPECIES_VASILISSAN)
					new /obj/item/weapon/digestion_remains/skull/vasilissan(src,owner)
					skull_amount--
				if(SPECIES_AKULA)
					new /obj/item/weapon/digestion_remains/skull/akula(src,owner)
					skull_amount--
				if(SPECIES_RAPALA)
					new /obj/item/weapon/digestion_remains/skull/rapala(src,owner)
					skull_amount--
				if(SPECIES_VULPKANIN)
					new /obj/item/weapon/digestion_remains/skull/vulpkanin(src,owner)
					skull_amount--
				if(SPECIES_SERGAL)
					new /obj/item/weapon/digestion_remains/skull/sergal(src,owner)
					skull_amount--
				if(SPECIES_ZORREN_FLAT || SPECIES_ZORREN_HIGH)
					new /obj/item/weapon/digestion_remains/skull/zorren(src,owner)
					skull_amount--
				if(SPECIES_NEVREAN)
					new /obj/item/weapon/digestion_remains/skull/nevrean(src,owner)
					skull_amount--
				if(SPECIES_TESHARI)
					new /obj/item/weapon/digestion_remains/skull/teshari(src,owner)
					skull_amount--
				if(SPECIES_VOX)
					new /obj/item/weapon/digestion_remains/skull/vox(src,owner)
					skull_amount--
				if(SPECIES_XENOHYBRID)
					new /obj/item/weapon/digestion_remains/skull/xenohybrid(src,owner)
					skull_amount--
			if(skull_amount && H.species.selects_bodytype)	//We still haven't found correct skull...
				if(H.species.base_species == SPECIES_HUMAN)
					new /obj/item/weapon/digestion_remains/skull/unknown(src,owner)
				else
					new /obj/item/weapon/digestion_remains/skull/unknown/anthro(src,owner)
			else if(skull_amount)		//Something entirely different...
				new /obj/item/weapon/digestion_remains/skull/unknown(src,owner)
	else
		return

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

/obj/item/weapon/digestion_remains/New(var/newloc,var/mob/living/pred)
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

/obj/item/weapon/digestion_remains/skull/xenohybrid
	desc = "A bleached skull. It looks very weakened. Seems like it belonged to something with an elongated head."
	icon_state = "skull_xenohybrid"