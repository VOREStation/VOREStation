/obj/item/device/radio/sleevecard
	canhear_range = 0

/obj/item/device/radio/sleevecard/tgui_state(mob/user)
	return GLOB.tgui_always_state

/obj/item/device/sleevecard
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

	var/obj/item/device/radio/sleevecard/radio
	var/mob/living/silicon/infomorph/infomorph
	var/current_emotion = 1

	matter = list(MAT_STEEL = 4000, MAT_GLASS = 4000)

/obj/item/device/sleevecard/relaymove(var/mob/user, var/direction)
	if(user.stat || user.stunned)
		return
	var/obj/item/weapon/rig/rig = src.get_rig()
	if(istype(rig))
		rig.forced_move(direction, user)

/obj/item/device/sleevecard/New()
	..()
	add_overlay("pai-off")
	radio = new(src)

/obj/item/device/sleevecard/Destroy()
	if(!isnull(infomorph))
		infomorph.death(0)
		infomorph = null
	QDEL_NULL(radio)
	return ..()

/obj/item/device/sleevecard/attack_self(mob/user)
	add_fingerprint(user)

	if(!infomorph)
		to_chat(user,"<span class='warning'>\The [src] does not have a mind in it!</span>")
	else
		to_chat(user,"<span class='notice'>\The [src] displays the name '[infomorph]'.</span>")

//This is a 'hard' proc, it does no permission checking, do that on the computer
/obj/item/device/sleevecard/proc/sleeveInto(var/datum/transhuman/mind_record/MR, var/db_key)
	infomorph = new(src,MR.mindname,db_key=db_key)

	for(var/datum/language/L in MR.languages)
		infomorph.add_language(L.name)
	MR.mind_ref.active = 1 //Well, it's about to be.
	MR.mind_ref.transfer_to(infomorph) //Does mind+ckey+client.
	infomorph.ooc_notes = MR.mind_oocnotes
	infomorph.apply_vore_prefs() //Cheap hack for now to give them SOME bellies.

	//Don't set 'real_name' because then we get a nice (as sleevecard) thing.
	infomorph.name = "[initial(infomorph.name)] ([MR.mindname])"
	name = "[initial(name)] ([MR.mindname])"
	var/emoname = infomorph_emotions[1]
	setEmotion(infomorph_emotions[emoname])

	if(infomorph.client)
		return 1

	return 0

/obj/item/device/sleevecard/proc/removePersonality()
	if(infomorph)
		infomorph.death(0)

	turnOff()

/obj/item/device/sleevecard/proc/turnOff()
	if(infomorph)
		infomorph.close_up()
	cut_overlays()
	name = "[initial(name)]"

/obj/item/device/sleevecard/proc/setEmotion(var/emotion)
	if(infomorph && emotion)
		cut_overlays()
		switch(emotion)
			if(1) add_overlay("pai-happy")
			if(2) add_overlay("pai-cat")
			if(3) add_overlay("pai-extremely-happy")
			if(4) add_overlay("pai-face")
			if(5) add_overlay("pai-laugh")
			if(6) add_overlay("pai-off")
			if(7) add_overlay("pai-sad")
			if(8) add_overlay("pai-angry")
			if(9) add_overlay("pai-what")
			if(10) add_overlay("pai-neutral")
			if(11) add_overlay("pai-silly")
			if(12) add_overlay("pai-nose")
			if(13) add_overlay("pai-smirk")
			if(14) add_overlay("pai-exclamation")
			if(15) add_overlay("pai-question")
		current_emotion = emotion

/obj/item/device/sleevecard/emp_act(severity)
	for(var/mob/M in src)
		M.emp_act(severity)

/obj/item/device/sleevecard/ex_act(severity)
	if(infomorph)
		infomorph.ex_act(severity)
	else
		qdel(src)

/obj/item/device/sleevecard/see_emote(mob/living/M, text)
	if(infomorph && infomorph.client && !infomorph.canmove)
		var/rendered = "<span class='message'>[text]</span>"
		infomorph.show_message(rendered, 2)
	..()

/obj/item/device/sleevecard/show_message(msg, type, alt, alt_type)
	if(infomorph && infomorph.client)
		var/rendered = "<span class='message'>[msg]</span>"
		infomorph.show_message(rendered, type)
	..()
