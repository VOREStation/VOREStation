/turf/simulated/floor/weird_things
	icon = 'icons/turf/flooring/weird_vr.dmi'

/turf/simulated/floor/weird_things/dark
	name = "dark"
	desc = "It's a strange, impenetrable darkness."
	icon_state = "dark"
	can_dirty = FALSE

/turf/simulated/floor/weird_things/dark/Initialize(mapload)
	. = ..()
	if(prob(5))
		add_glow()

/turf/simulated/floor/weird_things/dark/Crossed(O)
	. = ..()
	if(!isliving(O))
		return
	cut_overlays()
	if(prob(5))
		add_glow()
	if(ishuman(O))
		var/mob/living/carbon/human/L = O
		if(istype(L.species, /datum/species/crew_shadekin))
			L.halloss += 5
			if(prob(50))
				to_chat(L, span_danger("The more you move through this darkness, the more you can feel a throbbing, shooting ache in your bones."))
			if(prob(5))
				L.visible_message("[L]'s body gives off a faint, sparking, haze...", "Your body gives off a faint, sparking, haze...", runemessage = "gives off a faint, sparking haze")
		else if(istype(L.species, /datum/species/shadekin))
			var/obj/item/organ/internal/brain/shadekin/B = L.internal_organs_by_name[O_BRAIN]
			B.dark_energy += 10
			if(prob(10))
				to_chat(L, span_notice("You can feel the energy flowing into you!"))
		else
			if(prob(0.25))
				to_chat(L, span_danger("The darkness seethes under your feet..."))
				L.hallucination += 50

/turf/simulated/floor/weird_things/dark/proc/add_glow()
	var/choice = "overlay-[rand(1,6)]"
	var/image/i = image('icons/turf/flooring/weird_vr.dmi', choice)
	i.plane = PLANE_LIGHTING_ABOVE
	add_overlay(i)

/turf/unsimulated/wall/dark
	name = "dark"
	desc = "It's a strange, impenetrable darkness."
	icon = 'icons/turf/flooring/weird_vr.dmi'
	icon_state = "dark"

/turf/unsimulated/wall/dark/Initialize(mapload)
	. = ..()
	if(prob(5))
		add_glow()

/turf/unsimulated/wall/dark/proc/add_glow()
	var/choice = "overlay-[rand(1,6)]"
	var/image/i = image('icons/turf/flooring/weird_vr.dmi', choice)
	i.plane = PLANE_LIGHTING_ABOVE
	add_overlay(i)

/turf/unsimulated/floor/dark
	name = "dark"
	desc = "It's a strange, impenetrable darkness."
	icon = 'icons/turf/flooring/weird_vr.dmi'
	icon_state = "dark"

/turf/unsimulated/floor/dark/Initialize(mapload)
	. = ..()
	if(prob(5))
		add_glow()

/turf/unsimulated/floor/dark/Crossed(O)
	. = ..()
	if(!isliving(O))
		return
	cut_overlays()
	if(prob(5))
		add_glow()
	if(ishuman(O))
		var/mob/living/carbon/human/L = O
		if(istype(L.species, /datum/species/crew_shadekin))
			L.halloss += 5
			if(prob(50))
				to_chat(L, span_danger("The more you move through this darkness, the more you can feel a throbbing, shooting ache in your bones."))
			if(prob(5))
				L.visible_message("[L]'s body gives off a faint, sparking, haze...", "Your body gives off a faint, sparking, haze...", runemessage = "gives off a faint, sparking haze")
		else if(istype(L.species, /datum/species/shadekin))
			var/obj/item/organ/internal/brain/shadekin/B = L.internal_organs_by_name[O_BRAIN]
			B.dark_energy += 10
			if(prob(10))
				to_chat(L, span_notice("You can feel the energy flowing into you!"))
		else
			if(prob(0.25))
				to_chat(L, span_danger("The darkness seethes under your feet..."))
				L.hallucination += 50

/turf/unsimulated/floor/dark/proc/add_glow()
	var/flip = rand(1,2)
	var/choice
	var/choiceb
	if(flip == 1)
		choice = "overlay-[rand(1,6)]"
	if(flip == 2)
		choice = "overlay-[rand(7,12)]"
	var/image/i = image('icons/turf/flooring/weird_vr.dmi', choice)
	i.plane = PLANE_LIGHTING_ABOVE
	add_overlay(i)
	if(prob(10))
		if(flip == 1)
			choiceb = "overlay-[rand(7,12)]"
		if(flip == 2)
			choiceb = "overlay-[rand(1,6)]"
		var/image/ii = image('icons/turf/flooring/weird_vr.dmi', choiceb)
		add_overlay(ii)
