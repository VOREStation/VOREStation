mob/living/silicon/pai/infomorph
	name = "sleevecard" //Has the same name as the card for consistency, but this is the MOB in the card.
	//icon = 'icons/mob/pai_vr.dmi' //Changed to the virgo icon, giving more sprite options.
	//icon_state = "pai-repairbot"

	emote_type = 2		// pAIs emotes are heard, not seen, so they can be seen through a container (eg. person)
	pass_flags = 1
	mob_size = MOB_SMALL

	can_pull_size = ITEMSIZE_SMALL
	can_pull_mobs = MOB_PULL_SMALLER

	idcard_type = /obj/item/weapon/card/id

/mob/living/silicon/pai/infomorph/New(var/obj/item/device/paicard/sleevecard/paicard)
	. = ..()

/obj/item/device/paicard/sleevecard
	name = "sleevecard"
	desc = "This KHI-upgraded pAI module has enough capacity to run a whole mind of human-level intelligence."
	catalogue_data = list(/datum/category_item/catalogue/information/organization/khi,
						/datum/category_item/catalogue/technology/resleeving)

	icon = 'icons/obj/pda.dmi'
	icon_state = "pai"
	item_state = "electronic"

	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_DATA = 2)
	show_messages = 0
	/*
	var/obj/item/device/radio/sleevecard/radio
	var/mob/living/silicon/infomorph/infomorph
	var/current_emotion = 1
	*/
	matter = list(MAT_STEEL = 4000, MAT_GLASS = 4000)

/obj/item/device/paicard/sleevecard/proc/sleeveInto(var/datum/transhuman/mind_record/MR, var/db_key)
	pai = new(src,MR.mindname,db_key=db_key)

	for(var/datum/language/L in MR.languages)
		pai.add_language(L.name)
	MR.mind_ref.active = 1 //Well, it's about to be.
	MR.mind_ref.transfer_to(pai) //Does mind+ckey+client.
	pai.ooc_notes = MR.mind_oocnotes
	pai.apply_vore_prefs() //Cheap hack for now to give them SOME bellies.

	//Don't set 'real_name' because then we get a nice (as sleevecard) thing.
	pai.name = "[initial(pai.name)] ([MR.mindname])"
	name = "[initial(name)] ([MR.mindname])"
	var/emoname = pai_emotions[1]
	setEmotion(pai_emotions[emoname])

	if(pai.client)
		return 1

	return 0