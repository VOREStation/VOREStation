//Transparent Glamour (invisibility potion)

/obj/item/weapon/potion_material/glamour_transparent
	name = "transparent glamour"
	desc = "A shard of hardened white crystal that is clearly translucent."
	icon = 'icons/obj/glamour.dmi'
	icon_state = "transparent"
	base_reagent = /obj/item/weapon/potion_base/aqua_regia
	product_potion = /obj/item/weapon/reagent_containers/glass/bottle/potion/invisibility

/obj/item/weapon/reagent_containers/glass/bottle/potion/invisibility
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

/obj/item/weapon/potion_material/glamour_shrinking
	name = "shrinking glamour"
	desc = "A soft clump of white material that seems to shrink at your touch."
	icon = 'icons/obj/glamour.dmi'
	icon_state = "shrinking"
	base_reagent = /obj/item/weapon/potion_base/aqua_regia
	product_potion = /obj/item/weapon/reagent_containers/glass/bottle/potion/scaling

/obj/item/weapon/reagent_containers/glass/bottle/potion/scaling
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

/obj/item/weapon/potion_material/glamour_twinkling
	name = "twinkling glamour"
	desc = "A sheet of white material that twinkles on its own accord."
	icon = 'icons/obj/glamour.dmi'
	icon_state = "twinkling"
	base_reagent = /obj/item/weapon/potion_base/aqua_regia
	product_potion = /obj/item/weapon/reagent_containers/glass/bottle/potion/darksight

/obj/item/weapon/reagent_containers/glass/bottle/potion/darksight
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
			if(istype(M) && M.resleeve_lock && M.ckey != M.resleeve_lock)
				continue
			targets |= M

		if(!targets)
			to_chat(user, "<span class='warning'>There are no appropriate targets in range.</span>")
			return

		var/mob/living/carbon/human/chosen_target = tgui_input_list(user, "Which target do you wish to create a homunculus of?", "homunculus", targets)

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
		if(h_action == "Cancel")
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

/obj/item/device/universal_translator/glamour
	name = "speaking glamour"
	desc = "A shard of glamour that translates all known language for the user."
	icon = 'icons/obj/glamour.dmi'
	icon_state = "translator"

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

//Glamour Floor
//Glamour Wall