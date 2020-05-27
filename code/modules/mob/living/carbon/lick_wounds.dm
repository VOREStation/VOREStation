/mob/living/carbon/human/proc/lick_wounds(var/mob/living/carbon/M in living_mobs(1))
	set name = "Lick Wounds"
	set category = "Abilities"
	set desc = "Disinfect and heal small wounds with your saliva."

	if(nutrition < 50)
		to_chat(src, "<span class='warning'>You need more energy to produce antiseptic enzymes. Eat something and try again.</span>")
		return

	if ( ! (istype(src, /mob/living/carbon/human) || \
			istype(src, /mob/living/silicon)) )
		to_chat(src, "<span class='warning'>If you even have a tongue, it doesn't work that way.</span>")
		return

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(src.zone_sel.selecting)

		if(!affecting)
			to_chat(src, "<span class='warning'>No body part there to work on!</span>")
			return

		if(affecting.organ_tag == BP_HEAD)
			if(H.head && istype(H.head,/obj/item/clothing/head/helmet/space))
				to_chat(src, "<span class='warning'>You can't seem to lick through [H.head]!</span>")
				return

		else
			if(H.wear_suit && istype(H.wear_suit,/obj/item/clothing/suit/space))
				to_chat(src, "<span class='warning'>You can't lick your way through [H.wear_suit]!</span>")
				return

		if(affecting.robotic == ORGAN_ROBOT)
			to_chat(src, "<span class='warning'>You don't think your spit will help a robotic limb.</span>")
			return

		if(affecting.robotic >= ORGAN_LIFELIKE)
			to_chat(src, "<span class='warning'>You lick [M]'s [affecting.name], but it seems to have no effect...</span>")
			return

		if(affecting.open)
			to_chat(src, "<span class='notice'>The [affecting.name] is cut open, you don't think your spit will help them!</span>")
			return

		if(affecting.is_bandaged() && affecting.is_salved())
			to_chat(src, "<span class='warning'>The wounds on [M]'s [affecting.name] have already been treated.</span>")
			return

		if(affecting.brute_dam > 20 || affecting.burn_dam > 20)
			to_chat(src, "<span class='warning'>The wounds on [M]'s [affecting.name] are too severe to treat with just licking.</span>")
			return
           
		else
			visible_message("<span class='notice'>\The [src] starts licking the wounds on [M]'s [affecting.name] clean.</span>", \
					             "<span class='notice'>You start licking the wounds on [M]'s [affecting.name] clean.</span>" )

			for (var/datum/wound/W in affecting.wounds)

				if(W.bandaged && W.salved && W.disinfected)
					continue

				if(!do_mob(src, M, W.damage/5))
					to_chat(src, "<span class='notice'>You must stand still to clean wounds.</span>")
					break

				if(affecting.is_bandaged() && affecting.is_salved()) // We do a second check after the delay, in case it was bandaged after the first check.
					to_chat(src, "<span class='warning'>The wounds on [M]'s [affecting.name] have already been treated.</span>")
					return 

				else
					visible_message("<span class='notice'>\The [src] [pick("slathers \a [W.desc] on [M]'s [affecting.name] with their spit.", 
																			   "drags their tongue across \a [W.desc] on [M]'s [affecting.name].",
																			   "drips saliva onto \a [W.desc] on [M]'s [affecting.name].",
																			   "uses their tongue to disinfect \a [W.desc] on [M]'s [affecting.name].",
																			   "licks \a [W.desc] on [M]'s [affecting.name], cleaning it.")]</span>", \
					                        	"<span class='notice'>You treat \a [W.desc] on [M]'s [affecting.name] with your antiseptic saliva.</span>" )
					adjust_nutrition(-20)
					W.salve()
					W.bandage()
					W.disinfect()
					H.UpdateDamageIcon()
					playsound(src, 'sound/effects/ointment.ogg', 25)