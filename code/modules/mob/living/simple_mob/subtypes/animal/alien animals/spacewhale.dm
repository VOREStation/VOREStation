/datum/category_item/catalogue/fauna/spacewhale
	name = "Alien Wildlife - Space Whale"
	desc = "A massive space creature! These are typically peaceful to anything smaller than themselves, with exception given to space carp, which it eats.\
	It is known to ravage and devour other large space dwelling species.\
	It occasionally gets restless and moves around erratically, which may affect the local space weather.\
	This creature shows no real interest in or aversion to spacecraft."
	value = CATALOGUER_REWARD_SUPERHARD

/mob/living/simple_mob/vore/overmap/spacewhale
	name = "space whale"
	desc = "It's a space whale. I don't know what more you expected."
	scanner_desc = "An absolutely massive space-born creature. A layer of radical energy around its body prevents detailed scanning, though, the energy along with its movements seem to be what propels it through space. A series of bio-luminescent lights ripple rhythmically across its surface. It is difficult to spot at range except for the wake of energy that swirls around it."
	catalogue_data = list(/datum/category_item/catalogue/fauna/spacewhale)

	icon = 'icons/mob/alienanimals_x32.dmi'
	icon_state = "space_whale"
	icon_living = "space_whale"
	icon_dead = "space_ghost_dead"

	om_child_type = /obj/effect/overmap/visitable/simplemob/spacewhale

	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "punches"
	attacktext = list("chomped", "bashed", "monched", "bumped")

	ai_holder_type = /datum/ai_holder/simple_mob/melee/spacewhale

	speak_emote = list("rumbles")

	say_list_type = /datum/say_list/spacewhale

	var/hazard_pickup_chance = 35
	var/hazard_drop_chance = 35
	var/held_hazard
	var/restless = FALSE
	var/post_restless_tired = 0

	vore_active = 1
	vore_capacity = 99
	vore_bump_chance = 99
	vore_pounce_chance = 99
	vore_ignores_undigestable = 0
	vore_default_mode = DM_DIGEST
	vore_icons = SA_ICON_LIVING
	vore_stomach_name = "stomach"
	vore_default_contamination_flavor = "Wet"
	vore_default_contamination_color = "grey"
	vore_default_item_mode = IM_DIGEST

/datum/say_list/spacewhale
	emote_see = list("ripples and flows", "flashes rhythmically","glows faintly","investigates something")

/mob/living/simple_mob/vore/overmap/spacewhale/init_vore()
	..()
	var/obj/belly/B = vore_selected
	B.name = "stomach"
	B.desc = "It's warm and wet, makes sense, considering it's inside of a space whale. You should take a moment to reflect upon how you got here, and how you might avoid situations like this in the future, while this whale attempts to mercilessly destroy you through various gastric processes."
	B.mode_flags = DM_FLAG_THICKBELLY | DM_FLAG_NUMBING
	B.digest_brute = 50
	B.digest_burn = 50
	B.escapechance = 0
	B.escapechance_absorbed = 20

/mob/living/simple_mob/vore/overmap/spacewhale/Initialize()
	. = ..()
	handle_restless()

/mob/living/simple_mob/vore/overmap/spacewhale/Moved()
	. = ..()
	if(restless && prob(5))
		handle_restless()

	for(var/obj/effect/decal/cleanable/C in loc)
		qdel(C)
	for(var/obj/item/organ/O in loc)
		qdel(O)
	var/detected = FALSE
	for(var/obj/effect/overmap/event/E in loc)
		detected = TRUE
		if(istype(E, /obj/effect/overmap/event/carp))
			qdel(E)
			continue
		else if(!held_hazard && prob(hazard_pickup_chance))
			held_hazard = E.type
			qdel(E)
			return
	if(held_hazard && !detected && prob(hazard_drop_chance))
		if(!(locate(/obj/effect/overmap/visitable/sector) in loc))
			new held_hazard(loc)
			held_hazard = null

/mob/living/simple_mob/vore/overmap/spacewhale/Life()
	. = ..()
	if(post_restless_tired)
		post_restless_tired--
		return
	if(prob(0.5))
		handle_restless()

/mob/living/simple_mob/vore/overmap/spacewhale/proc/handle_restless()
	if(restless)
		restless = FALSE
		hazard_pickup_chance = initial(hazard_pickup_chance)
		hazard_drop_chance = initial(hazard_drop_chance)
		movement_cooldown = initial(movement_cooldown)
		ai_holder.base_wander_delay = initial(ai_holder.base_wander_delay)
		ai_holder.wander = FALSE
		post_restless_tired = 250
		update_icon()
	else
		restless = TRUE
		hazard_pickup_chance *= 1.5
		hazard_drop_chance *= 1.5
		movement_cooldown = -1
		ai_holder.base_wander_delay = 2
		ai_holder.wander_delay = 2
		ai_holder.wander = TRUE
		update_icon()

/mob/living/simple_mob/vore/overmap/spacewhale/update_icon()
	. = ..()
	if(child_om_marker.known == TRUE)
		if(restless)
			child_om_marker.icon_state = "space_whale_restless"
			visible_message("<span class='notice'>\The [child_om_marker.name] ripples excitedly.</span>")
		else
			child_om_marker.icon_state = "space_whale"
			visible_message("<span class='notice'>\The [child_om_marker.name] settles down.</span>")

/datum/ai_holder/simple_mob/melee/spacewhale
	hostile = TRUE
	retaliate = TRUE
	destructive = TRUE
	violent_breakthrough = TRUE
	unconscious_vore = TRUE
	handle_corpse = TRUE
	mauling = TRUE
	base_wander_delay = 50

/datum/ai_holder/simple_mob/melee/spacewhale/set_stance(var/new_stance)
	. = ..()
	var/mob/living/simple_mob/vore/overmap/spacewhale/W = holder
	if(stance == STANCE_FIGHT)
		W.movement_cooldown = -2
		W.child_om_marker.glide_size = 0
	if(stance == STANCE_IDLE)
		W.hazard_pickup_chance = initial(W.hazard_pickup_chance)
		W.hazard_drop_chance = initial(W.hazard_drop_chance)
		W.restless = FALSE
		W.handle_restless()
		W.movement_cooldown = initial(W.movement_cooldown)
		W.child_om_marker.glide_size = 0.384

/mob/living/simple_mob/vore/overmap/spacewhale/apply_melee_effects(var/atom/A)
	. = ..()
	if(istype(A, /mob/living))
		var/mob/living/L = A
		if(L.stat == DEAD && !L.allowmobvore)
			L.gib()
		else
			return ..()

/obj/effect/overmap/visitable/simplemob/spacewhale
	skybox_icon = 'icons/skybox/anomaly.dmi'
	skybox_icon_state = "space_whale"
	skybox_pixel_x = 0
	skybox_pixel_y = 0
	glide_size = 0.384
	parent_mob_type = /mob/living/simple_mob/vore/overmap/spacewhale
	scanner_desc = "An absolutely massive space-born creature. A layer of radical energy around its body prevents detailed scanning, though, the energy along with its movements seem to be what propels it through space. A series of bio-luminescent lights ripple rhythmically across its surface. It is difficult to spot at range except for the wake of energy that swirls around it."
