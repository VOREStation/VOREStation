/obj/item/organ/internal/appendix
	name = "appendix"
	icon_state = "appendix"
	parent_organ = BP_GROIN
	organ_tag = "appendix"
	var/inflamed = 0
	var/inflame_progress = 0

/mob/living/carbon/human/proc/appendicitis()
	return ForceContractDisease(new /datum/disease/appendicitis)

/*
/obj/item/organ/internal/appendix/process()
	..()

	if(!inflamed || !owner)
		return

	if(++inflame_progress > 200)
		++inflamed
		inflame_progress = 0

	if(inflamed == 1)
		if(prob(5))
			to_chat(owner, span_warning("You feel a stinging pain in your abdomen!"))
			owner.automatic_custom_emote(VISIBLE_MESSAGE, "winces slightly.", check_stat = TRUE)
	if(inflamed > 1)
		if(prob(3))
			to_chat(owner, span_warning("You feel a stabbing pain in your abdomen!"))
			owner.automatic_custom_emote(VISIBLE_MESSAGE, "winces painfully.", check_stat = TRUE)
			owner.adjustToxLoss(1)
	if(inflamed > 2)
		if(prob(1))
			owner.vomit()
	if(inflamed > 3)
		if(prob(1))
			to_chat(owner, span_danger("Your abdomen is a world of pain!"))
			owner.Weaken(10)

			var/obj/item/organ/external/groin = owner.get_organ(BP_GROIN)
			var/datum/wound/W = new /datum/wound/internal_bleeding(20)
			owner.adjustToxLoss(25)
			groin.wounds += W
			inflamed = 1
*/
/obj/item/organ/internal/appendix/removed()
	if(inflamed)
		icon_state = "[initial(icon_state)]inflamed"
		name = "inflamed appendix"
	..()
