//Transparent Glamour (invisibility potion)

/obj/item/potion_material/glamour_transparent
	name = "transparent glamour"
	desc = "A shard of hardened white crystal that is clearly translucent."
	icon = 'icons/obj/glamour.dmi'
	icon_state = "transparent"
	base_reagent = /obj/item/potion_base/aqua_regia
	product_potion = /obj/item/reagent_containers/glass/bottle/potion/invisibility

/obj/item/reagent_containers/glass/bottle/potion/invisibility
	name = "transparent potion"
	desc = "A small white potion, the clear liquid inside can barely be seen at all."
	prefill = list("transparent glamour" = 1)

/datum/reagent/glamour_transparent
	name = "Clear Glamour"
	id = "transparent glamour"
	description = "This material is from somewhere else, it can barely be seen by the naked eye."
	taste_description = "nothingness"
	reagent_state = LIQUID
	color = "#ffffff"
	scannable = 1

/datum/reagent/glamour_transparent/affect_blood(var/mob/living/carbon/target, var/removed)
	if(!target.cloaked)
		target.visible_message("<b>\The [target]</b> vanishes from sight.")
		target.cloak()
	target.bloodstr.clear_reagents() //instantly clears reagents afterwards
	target.ingested.clear_reagents()
	target.touching.clear_reagents()
	spawn(600)
		if(target.cloaked)
			target.uncloak()
			target.visible_message("<b>\The [target]</b> appears as if from thin air.")

//Shrinking Glamour (scaling potion)

/obj/item/potion_material/glamour_shrinking
	name = "shrinking glamour"
	desc = "A soft clump of white material that seems to shrink at your touch."
	icon = 'icons/obj/glamour.dmi'
	icon_state = "shrinking"
	base_reagent = /obj/item/potion_base/aqua_regia
	product_potion = /obj/item/reagent_containers/glass/bottle/potion/scaling

/obj/item/reagent_containers/glass/bottle/potion/scaling
	name = "scaling potion"
	desc = "A small white potion, the clear liquid inside can barely be seen at all."
	prefill = list("scaling glamour" = 1)

/datum/reagent/glamour_scaling
	name = "Scaling Glamour"
	id = "scaling glamour"
	description = "This material is from somewhere else, it appears to change volumes readily at a glance."
	taste_description = "difficult to discern"
	reagent_state = LIQUID
	color = "#ffffff"
	scannable = 1

/datum/reagent/glamour_scaling/affect_blood(var/mob/living/carbon/target, var/removed)
	if(!(/mob/living/proc/set_size in target.verbs))
		to_chat(target, "<span class='warning'>You feel as though you could change size at any moment.</span>")
		target.verbs |= /mob/living/proc/set_size
	target.bloodstr.clear_reagents() //instantly clears reagents afterwards
	target.ingested.clear_reagents()
	target.touching.clear_reagents()

//Twinkling Glamour (Sparkling potion - Gives darksight)

/obj/item/potion_material/glamour_twinkling
	name = "twinkling glamour"
	desc = "A sheet of white material that twinkles on its own accord."
	icon = 'icons/obj/glamour.dmi'
	icon_state = "twinkling"
	base_reagent = /obj/item/potion_base/aqua_regia
	product_potion = /obj/item/reagent_containers/glass/bottle/potion/darksight

/obj/item/reagent_containers/glass/bottle/potion/darksight
	name = "twinling potion"
	desc = "A small white potion, the thin white liquid inside twinkles brightly."
	prefill = list("twinkling glamour" = 1)

/datum/reagent/glamour_twinkling
	name = "Twinkling Glamour"
	id = "twinkling glamour"
	description = "This material is from somewhere else, it appears to be twinkling."
	taste_description = "bright"
	reagent_state = LIQUID
	color = "#ffffff"
	scannable = 1

/datum/reagent/glamour_twinkling/affect_blood(var/mob/living/carbon/human/target, var/removed)
	if(target.species.darksight < 10)
		to_chat(target, "<span class='warning'>You can suddenly see much better than before.</span>")
		target.species.darksight = 10
	if(target.disabilities & NEARSIGHTED)
		target.disabilities &= ~NEARSIGHTED
		to_chat(target, "<span class='warning'>Everything is much less blurry.</span>")
	target.bloodstr.clear_reagents() //instantly clears reagents afterwards
	target.ingested.clear_reagents()
	target.touching.clear_reagents()

//Glamour Cell (variant of capture crystal)

/obj/item/capture_crystal/glamour
	name = "glamour cell"
	desc = "A large but light round ball of glamour that glows from somewhere within."
	icon = 'icons/obj/glamour.dmi'

/obj/item/capture_crystal/glamour/animate_action(atom/thing)
	var/image/coolanimation = image('icons/obj/glamour.dmi', null, "animation")
	coolanimation.plane = PLANE_LIGHTING_ABOVE
	thing.overlays += coolanimation
	sleep(14)
	thing.overlays -= coolanimation

//Face of Glamour (creates a clone of a target)

/obj/item/glamour_face
	name = "face of glamour"
	desc = "A piece of glamour that is formed vaguely into the shape of a face."
	icon = 'icons/obj/glamour.dmi'
	icon_state = "face"
	var/mob/living/homunculus = 0

/obj/item/glamour_face/attack_self(var/mob/user)
	if(!homunculus)
		var/list/targets = list()
		for(var/mob/living/carbon/human/M in mob_list)
			if(M.z != user.z || get_dist(user,M) > 10)
				continue
			if(!M.allow_mimicry)
				continue
			targets |= M

		if(!targets)
			to_chat(user, "<span class='warning'>There are no appropriate targets in range.</span>")
			return

		var/mob/living/carbon/human/chosen_target = tgui_input_list(user, "Which target do you wish to create a homunculus of?", "homunculus", targets)
		if(!chosen_target)
			return

		var/spawnloc = get_turf(user)
		var/mob/living/simple_mob/homunculus/H = new(spawnloc)
		H.name = chosen_target.name
		H.desc = chosen_target.desc
		H.icon = chosen_target.icon
		H.icon_state = chosen_target.icon_state
		H.copy_overlays(chosen_target, TRUE)
		H.resize(chosen_target.size_multiplier, ignore_prefs = TRUE)
		homunculus = H
		H.owner = src
		return
	if(homunculus)
		var/mob/living/simple_mob/homunculus/H = homunculus
		var/h_action = tgui_alert(user, "What would you like to do with your homunculus?", "Actions", list("Recall", "Speak Through", "Cancel"))
		if(!h_action || h_action == "Cancel")
			return
		if(h_action == "Recall")
			H.visible_message("<b>\The [H]</b> returns to the face.")
			qdel(H)
			homunculus = 0
			return
		if(h_action == "Speak Through")
			var/words_to_say = tgui_input_text(user, "What should the homunculus say:", "Speak Through")
			H.say(words_to_say)
			return


//Speaking Glamour (universal translator)

/obj/item/universal_translator/glamour
	name = "speaking glamour"
	desc = "A shard of glamour that translates all known language for the user."
	icon = 'icons/obj/glamour.dmi'
	icon_state = "translator"

/obj/item/universal_translator/glamour/hear_talk(mob/M, list/message_pieces, verb)
	if(!listening || !istype(M))
		return

	//Show the "I heard something" animation.
	if(mult_icons)
		flick("[initial(icon_state)]2",src)

	//Handheld or pocket only.
	if(!isliving(loc))
		return

	var/mob/living/L = loc
	if(visual && ((L.sdisabilities & BLIND) || L.eye_blind))
		return
	if(audio && ((L.sdisabilities & DEAF) || L.ear_deaf))
		return

	// Using two for loops kinda sucks, but I think it's more efficient
	// to shortcut past string building if we're just going to discard the string
	// anyways.
	if(user_understands(M, L, message_pieces))
		return

	var/new_message = ""

	for(var/datum/multilingual_say_piece/S in message_pieces)
		if(S.speaking.flags & NONVERBAL)
			continue

		new_message += (S.message + " ")

	if(!L.say_understands(null, langset))
		new_message = langset.scramble(new_message)

	to_chat(L, "<span class='filter_say'><i><b>[src]</b> translates, </i>\"<span class='[langset.colour]'>[new_message]</span>\"</span>")

//Teleporter ring

/obj/structure/glamour_ring
	name = "glamour ring"
	desc = "A ring of glowing white, oddly reflective material."
	icon = 'icons/obj/glamour.dmi'
	icon_state = "ring"
	density = 0
	anchored = 1

	var/connected_mob
	var/area_name

/obj/structure/glamour_ring/Initialize()
	. = ..()
	var/area/A = get_area(src)
	area_name = A.name
	name = "[area_name] glamour ring"

/obj/structure/glamour_ring/attack_hand(mob/living/M as mob)

	var/mob/living/carbon/human/L = connected_mob
	var/datum/species/lleill/LL = L.species

	var/m_action
	if(M == L)
		m_action= tgui_alert(M, "Do you want to destroy the ring, or restore energy?", "Destroy ring", list("Yes", "No", "Restore Energy"))
	else
		m_action= tgui_alert(M, "Do you want to destroy the ring, the owner of it may be aware that you have done this?", "Destroy ring", list("Yes", "No"))

	if(!m_action || m_action == "No")
		return

	if(m_action == "Yes")
		to_chat(M, "<span class='warning'>You begin to break the lines of the glamour ring.</span>")
		if(!do_after(M, 10 SECONDS, src, exclusive = TASK_USER_EXCLUSIVE))
			to_chat(M, "<span class='warning'>You leave the glamour ring alone.</span>")
			return
		to_chat(M, "<span class='warning'>You have destroyed \the [src].</span>")
		src.visible_message("<b>\The [M]</b> has broken apart \the [src].")
		if(M != connected_mob && connected_mob)
			to_chat(connected_mob, "<span class='warning'>\The [src] has been destroyed by \the [M].</span>")
		if(istype(LL))
			L.teleporters -= src
		qdel(src)

	if(m_action == "Restore Energy")
		if(LL.ring_cooldown + 10 MINUTES > world.time)
			to_chat(M, "<span class='warning'>You must wait a while before drawing energy from the glamour again.</span>")
			return
		if(!do_after(M, 10 SECONDS, src, exclusive = TASK_USER_EXCLUSIVE))
			to_chat(M, "<span class='warning'>You stop drawing energy.</span>")
			return
		LL.lleill_energy = min((LL.lleill_energy + 75),LL.lleill_energy_max)

//Glamour Helm

/obj/item/clothing/mask/gas/glamour
	desc = "A bubble-like helmet of glamour that can protect your face from the atmosphere, or lack thereof, outside."
	name = "glamour bubble"
	icon = 'icons/obj/glamour.dmi'
	icon_state = "bubble"
	item_flags = BLOCK_GAS_SMOKE_EFFECT | AIRTIGHT | ALLOW_SURVIVALFOOD | INFINITE_AIR

//Glamour Pockets

/obj/item/clothing/under/permit/glamour
	name = "pocket of glamour"
	desc = "A small crystal of glamour that is capable of storing small items inside of it."
	icon = 'icons/obj/glamour.dmi'
	icon_state = "pocket"

//Glamour Floor
//Glamour Wall
