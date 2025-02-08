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
		target.visible_message(span_infoplain(span_bold("\The [target]") + " vanishes from sight."))
		target.cloak()
	target.bloodstr.clear_reagents() //instantly clears reagents afterwards
	target.ingested.clear_reagents()
	target.touching.clear_reagents()
	spawn(600)
		if(target.cloaked)
			target.uncloak()
			target.visible_message(span_infoplain(span_bold("\The [target]") + " appears as if from thin air."))

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
		to_chat(target, span_warning("You feel as though you could change size at any moment."))
		add_verb(target, /mob/living/proc/set_size)
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
		to_chat(target, span_warning("You can suddenly see much better than before."))
		target.species.darksight = 10
	if(target.disabilities & NEARSIGHTED)
		target.disabilities &= ~NEARSIGHTED
		to_chat(target, span_warning("Everything is much less blurry."))
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
			to_chat(user, span_warning("There are no appropriate targets in range."))
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
			H.visible_message(span_infoplain(span_bold("\The [H]") + " returns to the face."))
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

	to_chat(L, span_filter_say("<i><b>[src]</b> translates, </i>\"<span class='[langset.colour]'>[new_message]</span>\""))

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
		to_chat(M, span_warning("You begin to break the lines of the glamour ring."))
		if(!do_after(M, 10 SECONDS, src, exclusive = TASK_USER_EXCLUSIVE))
			to_chat(M, span_warning("You leave the glamour ring alone."))
			return
		to_chat(M, span_warning("You have destroyed \the [src]."))
		src.visible_message(span_infoplain(span_bold("\The [M]") + " has broken apart \the [src]."))
		if(M != connected_mob && connected_mob)
			to_chat(connected_mob, span_warning("\The [src] has been destroyed by \the [M]."))
		if(istype(LL))
			L.teleporters -= src
		qdel(src)

	if(m_action == "Restore Energy")
		if(LL.ring_cooldown + 10 MINUTES > world.time)
			to_chat(M, span_warning("You must wait a while before drawing energy from the glamour again."))
			return
		if(!do_after(M, 10 SECONDS, src, exclusive = TASK_USER_EXCLUSIVE))
			to_chat(M, span_warning("You stop drawing energy."))
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

//Unstable Glamour

/obj/item/glamour_unstable
	name = "unstable glamour"
	desc = "A bright white glowing object that appears to move about on its own."
	icon = 'icons/obj/glamour.dmi'
	icon_state = "unstable"
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_BLUESPACE = 7, TECH_MATERIAL = 2)
	var/tele_range = 4
	var/tf_type = /mob/living/simple_mob/animal/passive/mouse
	var/tf_possible_types = list(
		"mouse" = /mob/living/simple_mob/animal/passive/mouse,
		"rat" = /mob/living/simple_mob/animal/passive/mouse/rat,
		"giant rat" = /mob/living/simple_mob/vore/aggressive/rat,
		"dust jumper" = /mob/living/simple_mob/vore/alienanimals/dustjumper,
		"woof" = /mob/living/simple_mob/vore/woof,
		"corgi" = /mob/living/simple_mob/animal/passive/dog/corgi,
		"cat" = /mob/living/simple_mob/animal/passive/cat,
		"chicken" = /mob/living/simple_mob/animal/passive/chicken,
		"cow" = /mob/living/simple_mob/animal/passive/cow,
		"lizard" = /mob/living/simple_mob/animal/passive/lizard,
		"rabbit" = /mob/living/simple_mob/vore/rabbit,
		"fox" = /mob/living/simple_mob/animal/passive/fox,
		"fennec" = /mob/living/simple_mob/vore/fennec,
		"cute fennec" = /mob/living/simple_mob/animal/passive/fennec,
		"fennix" = /mob/living/simple_mob/vore/fennix,
		"red panda" = /mob/living/simple_mob/vore/redpanda,
		"opossum" = /mob/living/simple_mob/animal/passive/opossum,
		"horse" = /mob/living/simple_mob/vore/horse,
		"goose" = /mob/living/simple_mob/animal/space/goose,
		"sheep" = /mob/living/simple_mob/vore/sheep,
		"space bumblebee" = /mob/living/simple_mob/vore/bee,
		"space bear" = /mob/living/simple_mob/animal/space/bear,
		"voracious lizard" = /mob/living/simple_mob/vore/aggressive/dino,
		"giant frog" = /mob/living/simple_mob/vore/aggressive/frog,
		"jelly blob" = /mob/living/simple_mob/vore/jelly,
		"wolf" = /mob/living/simple_mob/vore/wolf,
		"direwolf" = /mob/living/simple_mob/vore/wolf/direwolf,
		"great wolf" = /mob/living/simple_mob/vore/greatwolf,
		"sect queen" = /mob/living/simple_mob/vore/sect_queen,
		"sect drone" = /mob/living/simple_mob/vore/sect_drone,
		"panther" = /mob/living/simple_mob/vore/aggressive/panther,
		"giant snake" = /mob/living/simple_mob/vore/aggressive/giant_snake,
		"deathclaw" = /mob/living/simple_mob/vore/aggressive/deathclaw,
		"otie" = /mob/living/simple_mob/vore/otie,
		"mutated otie" =/mob/living/simple_mob/vore/otie/feral,
		"red otie" = /mob/living/simple_mob/vore/otie/red,
		"defanged xenomorph" = /mob/living/simple_mob/vore/xeno_defanged,
		"catslug" = /mob/living/simple_mob/vore/alienanimals/catslug,
		"monkey" = /mob/living/carbon/human/monkey,
		"wolpin" = /mob/living/carbon/human/wolpin,
		"sparra" = /mob/living/carbon/human/sparram,
		"saru" = /mob/living/carbon/human/sergallingm,
		"sobaka" = /mob/living/carbon/human/sharkm,
		"farwa" = /mob/living/carbon/human/farwa,
		"neaera" = /mob/living/carbon/human/neaera,
		"stok" = /mob/living/carbon/human/stok,
		"weretiger" = /mob/living/simple_mob/vore/weretiger,
		"dragon" = /mob/living/simple_mob/vore/bigdragon/friendly,
		"leopardmander" = /mob/living/simple_mob/vore/leopardmander
		)

/obj/item/glamour_unstable/attack_self(mob/user)
	var/mob/living/M = user
	if(!istype(M))
		return
	user.visible_message(span_warning("[user] triggers \the [src]!"), span_danger("You trigger \the [src]!"))
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
	s.set_up(5, 1, get_turf(src))
	s.start()
	var/effect_choice = rand(1,4)
	switch(effect_choice)
		if(1) //teleport
			blink_mob(M)
		if(2) //mob_tf, uses polymorph potion code
			if(!M.allow_spontaneous_tf)
				M.AdjustWeakened(50)
			else
				mob_tf(M)
		if(3)
			size_change(M)
		if(4)
			M.apply_effect(200, IRRADIATE)

/obj/item/glamour_unstable/proc/blink_mob(mob/living/L)
	var/starting_loc = (get_turf(src))
	var/list/target_loc = list()
	for(var/turf/simulated/floor/T in range(tele_range, starting_loc)) //Only appear on floors
		if(!istype(T))
			continue
		if(T == starting_loc)
			continue
		target_loc |= T

	if(target_loc.len)
		var/final_loc = pick(target_loc)
		do_teleport(L, final_loc, asoundin = 'sound/effects/phasein.ogg')

/obj/item/glamour_unstable/proc/mob_tf(mob/living/target)
	var/mob/living/M = target
	if(!istype(M))
		return
	if(M.tf_mob_holder)
		var/mob/living/ourmob = M.tf_mob_holder
		if(ourmob.ai_holder)
			var/datum/ai_holder/our_AI = ourmob.ai_holder
			our_AI.set_stance(STANCE_IDLE)
		M.tf_mob_holder = null
		ourmob.ckey = M.ckey
		var/turf/get_dat_turf = get_turf(target)
		ourmob.loc = get_dat_turf
		ourmob.forceMove(get_dat_turf)
		ourmob.vore_selected = M.vore_selected
		M.vore_selected = null
		ourmob.mob_belly_transfer(M)

		ourmob.Life(1)
		if(ishuman(M))
			for(var/obj/item/W in M)
				if(istype(W, /obj/item/implant/backup) || istype(W, /obj/item/nif))
					continue
				M.drop_from_inventory(W)

		qdel(target)
		return
	else
		if(M.stat == DEAD)	//We can let it undo the TF, because the person will be dead, but otherwise things get weird.
			return
		var/mob/living/new_mob = spawn_mob(M)
		new_mob.faction = M.faction

		new_mob.mob_tf(M)


/obj/item/glamour_unstable/proc/spawn_mob(var/mob/living/target)
	var/choice = pick(tf_possible_types)
	tf_type = tf_possible_types[choice]
	if(!ispath(tf_type))
		return
	var/new_mob = new tf_type(get_turf(target))
	return new_mob

/obj/item/glamour_unstable/proc/size_change(mob/living/L)
	var/new_size = (rand(25,200))/100
	L.resize(new_size, ignore_prefs = FALSE)

/obj/item/glamour_unstable/attack_hand(mob/user)
	. = ..()

	var/mob/living/M = user
	if(!istype(M))
		return

	if(ishuman(M))
		var/mob/living/carbon/human/H = user
		var/obj/item/clothing/gloves/G = H.gloves
		if(istype(G) && ((G.flags & THICKMATERIAL && prob(70)) || istype(G, /obj/item/clothing/gloves/gauntlets)))
			return

		if((H.species.name == SPECIES_HANNER) || (H.species.name == SPECIES_LLEILL))
			return

		attack_self(H)
