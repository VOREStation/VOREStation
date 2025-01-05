/mob/living/carbon/human/proc/lick_wounds(var/mob/living/carbon/M as mob in view(1)) // Allows the user to lick themselves. Given how rarely this trait is used, I don't see an issue with a slight buff.
	set name = "Lick Wounds"
	set category = "Abilities.General"
	set desc = "Disinfect and heal small wounds with your saliva."

	if(stat || paralysis || weakened || stunned)
		to_chat(src, span_warning("You can't do that in your current state."))
		return

	if(nutrition < 50)
		to_chat(src, span_warning("You need more energy to produce antiseptic enzymes. Eat something and try again."))
		return

	if (get_dist(src,M) >= 2)
		to_chat(src, span_warning("You need to be closer to do that."))
		return

	if ( ! (ishuman(src) || issilicon(src)) )
		to_chat(src, span_warning("If you even have a tongue, it doesn't work that way."))
		return

	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(src.zone_sel.selecting)

		if(!affecting)
			to_chat(src, span_warning("No body part there to work on!"))
			return

		if(affecting.organ_tag == BP_HEAD)
			if(H.head && istype(H.head,/obj/item/clothing/head/helmet/space))
				to_chat(src, span_warning("You can't seem to lick through [H.head]!"))
				return

		else
			if(H.wear_suit && istype(H.wear_suit,/obj/item/clothing/suit/space))
				to_chat(src, span_warning("You can't lick your way through [H.wear_suit]!"))
				return

		if(affecting.robotic == ORGAN_ROBOT)
			to_chat(src, span_warning("You don't think your spit will help a robotic limb."))
			return

		if(affecting.robotic >= ORGAN_LIFELIKE)
			to_chat(src, span_warning("You lick [M]'s [affecting.name], but it seems to have no effect..."))
			return

		if(affecting.open)
			to_chat(src, span_notice("The [affecting.name] is cut open, you don't think your spit will help them!"))
			return

		if(affecting.is_bandaged() && affecting.is_salved())
			to_chat(src, span_warning("The wounds on [M]'s [affecting.name] have already been treated."))
			return

		if(affecting.brute_dam > 20 || affecting.burn_dam > 20)
			to_chat(src, span_warning("The wounds on [M]'s [affecting.name] are too severe to treat with just licking."))
			return

		else
			visible_message(span_infoplain(span_bold("\The [src]") + " starts licking the wounds on [M]'s [affecting.name] clean."), \
					             span_notice("You start licking the wounds on [M]'s [affecting.name] clean.") )

			for (var/datum/wound/W in affecting.wounds)

				if(W.bandaged && W.salved && W.disinfected)
					continue

				if(!do_mob(src, M, W.damage/5))
					to_chat(src, span_notice("You must stand still to clean wounds."))
					break

				if(affecting.is_bandaged() && affecting.is_salved()) // We do a second check after the delay, in case it was bandaged after the first check.
					to_chat(src, span_warning("The wounds on [M]'s [affecting.name] have already been treated."))
					return

				else
					visible_message(span_notice("\The [src] [pick("slathers \a [W.desc] on [M]'s [affecting.name] with their spit.",
																			   "drags their tongue across \a [W.desc] on [M]'s [affecting.name].",
																			   "drips saliva onto \a [W.desc] on [M]'s [affecting.name].",
																			   "uses their tongue to disinfect \a [W.desc] on [M]'s [affecting.name].",
																			   "licks \a [W.desc] on [M]'s [affecting.name], cleaning it.")]"), \
					                        	span_notice("You treat \a [W.desc] on [M]'s [affecting.name] with your antiseptic saliva.") )
					adjust_nutrition(-20)
					W.salve()
					W.bandage()
					W.disinfect()
					H.UpdateDamageIcon()
					playsound(src, 'sound/effects/ointment.ogg', 25)
