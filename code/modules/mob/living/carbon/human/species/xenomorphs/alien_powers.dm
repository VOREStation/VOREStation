/proc/alien_queen_exists(var/ignore_self,var/mob/living/carbon/human/self)
	for(var/mob/living/carbon/human/Q in living_mob_list)
		if(self && ignore_self && self == Q)
			continue
		if(Q.species.name != SPECIES_XENO_QUEEN)
			continue
		if(!Q.key || !Q.client || Q.stat)
			continue
		return 1
	return 0

/mob/living/carbon/human/proc/gain_plasma(var/amount)

	var/obj/item/organ/internal/xenos/plasmavessel/I = internal_organs_by_name[O_PLASMA]
	if(!istype(I)) return

	if(amount)
		I.stored_plasma += amount
	I.stored_plasma = max(0,min(I.stored_plasma,I.max_plasma))

/mob/living/carbon/human/proc/check_alien_ability(var/cost,var/needs_foundation,var/needs_organ)	//Returns 1 if the ability is clear for usage.

	var/obj/item/organ/internal/xenos/plasmavessel/P = internal_organs_by_name[O_PLASMA]
	if(!istype(P))
		to_chat(src, span_danger("Your plasma vessel has been removed!"))
		return

	if(needs_organ)
		var/obj/item/organ/internal/I = internal_organs_by_name[needs_organ]
		if(!I)
			to_chat(src, span_danger("Your [needs_organ] has been removed!"))
			return
		else if((I.status & ORGAN_CUT_AWAY) || I.is_broken())
			to_chat(src, span_danger("Your [needs_organ] is too damaged to function!"))
			return

	if(P.stored_plasma < cost)
		to_chat(src, span_danger("You don't have enough phoron stored to do that."))
		return 0

	if(needs_foundation)
		var/turf/T = get_turf(src)
		var/has_foundation
		if(T)
			//TODO: Work out the actual conditions this needs.
			if(!(istype(T,/turf/space)))
				has_foundation = 1
		if(!has_foundation)
			to_chat(src, span_danger("You need a solid foundation to do that on."))
			return 0

	P.stored_plasma -= cost
	return 1

// Free abilities.
/mob/living/carbon/human/proc/transfer_plasma(mob/living/carbon/human/M as mob in oview())
	set name = "Transfer Plasma"
	set desc = "Transfer Plasma to another alien"
	set category = "Abilities.Alien"

	if (get_dist(src,M) <= 1)
		to_chat(src, span_alium("You need to be closer."))
		return

	var/obj/item/organ/internal/xenos/plasmavessel/I = M.internal_organs_by_name[O_PLASMA]
	if(!istype(I))
		to_chat(src, span_alium("Their plasma vessel is missing."))
		return

	var/amount = tgui_input_number(usr, "Amount:", "Transfer Plasma to [M]")
	if (amount)
		amount = abs(round(amount))
		if(check_alien_ability(amount,0,O_PLASMA))
			M.gain_plasma(amount)
			to_chat(M, span_alium("[src] has transfered [amount] plasma to you."))
			to_chat(src, span_alium("You have transferred [amount] plasma to [M]."))
	return

// Queen verbs.
/mob/living/carbon/human/proc/lay_egg()

	set name = "Lay Egg (500)" //Cost is entire queen reserve, to compensate being able to reproduce on it's own
	set desc = "Lay an egg that will eventually hatch into a new xenomorph larva. Life finds a way."
	set category = "Abilities.Alien"

	if(!CONFIG_GET(flag/aliens_allowed))
		to_chat(src, "You begin to lay an egg, but hesitate. You suspect it isn't allowed.")
		remove_verb(src, /mob/living/carbon/human/proc/lay_egg)
		return

	if(locate(/obj/structure/ghost_pod/automatic/xenomorph_egg) in get_turf(src))
		to_chat(src, "There's already an egg here.")
		return

	if(check_alien_ability(500,1,O_EGG))
		visible_message(span_alium(span_bold("[src] has laid an egg!")))
		new /obj/structure/ghost_pod/automatic/xenomorph_egg(loc)

	return

// Drone verbs.
/mob/living/carbon/human/proc/evolve()
	set name = "Evolve (500)"
	set desc = "Produce an internal egg sac capable of spawning children. Only one queen can exist at a time."
	set category = "Abilities.Alien"

	if(alien_queen_exists())
		to_chat(src, span_notice("We already have an active queen."))
		return

	if(check_alien_ability(500))
		visible_message(span_alium(span_bold("[src] begins to twist and contort!")), span_alium("You begin to evolve!"))
		src.set_species("Xenomorph Queen")

	return

/mob/living/carbon/human/proc/plant()
	set name = "Plant Weeds (50)"
	set desc = "Plants some alien weeds"
	set category = "Abilities.Alien"

	if(check_alien_ability(50,1,O_RESIN))
		visible_message(span_alium(span_bold("[src] has planted some alien weeds!")))
		new /obj/effect/alien/weeds/node(get_turf(src), null, "#321D37")
	return

/mob/living/carbon/human/proc/Spit(var/atom/A)
	if((last_spit + 1 SECONDS) > world.time) //To prevent YATATATATATAT spitting.
		to_chat(src, span_warning("You have not yet prepared your chemical glands. You must wait before spitting again."))
		return
	else
		last_spit = world.time

	if(spitting && incapacitated(INCAPACITATION_DISABLED))
		to_chat(src, "You cannot spit in your current state.")
		spitting = 0
		return
	else if(spitting)
		if(!check_alien_ability(20,0,O_ACID))
			spitting = 0
			return
		visible_message(span_warning("[src] spits [spit_name] at \the [A]!"), span_alium("You spit [spit_name] at \the [A]."))
		var/obj/item/projectile/P = new spit_projectile(get_turf(src))
		P.firer = src
		P.old_style_target(A)
		P.fire()
		playsound(src, 'sound/weapons/alien_spitacid.ogg', 25, 0)

/mob/living/carbon/human/proc/corrosive_acid(O as obj|turf in oview(1)) //If they right click to corrode, an error will flash if its an invalid target./N
	set name = "Corrosive Acid (200)"
	set desc = "Drench an object in acid, destroying it over time."
	set category = "Abilities.Alien"

	if(!(O in oview(1)))
		to_chat(src, span_alium("[O] is too far away."))
		return

	// OBJ CHECK
	var/cannot_melt
	if(isobj(O))
		var/obj/I = O //Gurgs : Melts pretty much any object that isn't considered unacidable = TRUE
		if(I.unacidable)
			cannot_melt = 1
	else
		if(istype(O, /turf/simulated/wall))
			var/turf/simulated/wall/W = O //Gurgs : Walls are deconstructed into girders.
			if(W.material.flags & MATERIAL_UNMELTABLE)
				cannot_melt = 1
		else if(istype(O, /turf/simulated/floor))
			var/turf/simulated/floor/F = O	//Gurgs : Floors are destroyed with ex_act(1), turning them into whatever tile it would be if empty. Z-Level Friendly, does not destroy pipes.
			if(F.flooring && (F.flooring.flags & TURF_ACID_IMMUNE))
				cannot_melt = 1
		else
			cannot_melt = 1 //Gurgs : Everything that isn't a object, simulated wall, or simulated floor is assumed to be acid immune. Includes weird things like unsimulated floors and space.

	if(cannot_melt)
		to_chat(src, span_alium("You cannot dissolve this object."))
		return

	if(check_alien_ability(200,0,O_ACID))
		new /obj/effect/alien/acid(get_turf(O), O)
		visible_message(span_alium(span_bold("[src] vomits globs of vile stuff all over [O]. It begins to sizzle and melt under the bubbling mess of acid!")))

	return

/mob/living/carbon/human/proc/neurotoxin()
	set name = "Toggle Neurotoxic Spit (40)"
	set desc = "Readies a neurotoxic spit, which paralyzes the target for a short time if they are not wearing protective gear."
	set category = "Abilities.Alien"

	if(spitting)
		to_chat(src, span_alium("You stop preparing to spit."))
		spitting = 0
		return

	if(!check_alien_ability(40,0,O_ACID))
		spitting = 0
		return

	else
		last_spit = world.time
		spitting = 1
		spit_projectile = /obj/item/projectile/energy/neurotoxin
		spit_name = "neurotoxin"
		to_chat(src, span_alium("You prepare to spit neurotoxin."))

/mob/living/carbon/human/proc/acidspit()
	set name = "Toggle Acid Spit (50)"
	set desc = "Readies an acidic spit, which burns the target if they are not wearing protective gear."
	set category = "Abilities.Alien"

	if(spitting)
		to_chat(src, span_alium("You stop preparing to spit."))
		spitting = 0
		return

	if(!check_alien_ability(50,0,O_ACID))
		spitting = 0
		return

	else
		last_spit = world.time
		spitting = 1
		spit_projectile = /obj/item/projectile/energy/acid
		spit_name = "acid"
		to_chat(src, span_alium("You prepare to spit acid."))

/mob/living/carbon/human/proc/resin() //Gurgs : Refactored resin ability, big thanks to Jon.
	set name = "Secrete Resin (75)"
	set desc = "Secrete tough malleable resin."
	set category = "Abilities.Alien"

	var/list/options = list("resin door","resin wall","resin membrane","nest","resin blob")
	for(var/option in options)
		LAZYSET(options, option, new /image('icons/mob/alien.dmi', option)) // based off 'icons/effects/thinktank_labels.dmi'

	var/choice = show_radial_menu(src, src, options, radius = 42, require_near = TRUE)

	if(!choice || QDELETED(src) || src.incapacitated())
		return FALSE

	var/targetLoc = get_step(src, dir)

	if(iswall(targetLoc))
		targetLoc = get_turf(src)

	var/obj/O

	switch(choice)
		if("resin door")
			if(!check_alien_ability(75,1,O_RESIN))
				return
			else O = new /obj/structure/simple_door/resin(targetLoc)
		if("resin wall")
			if(!check_alien_ability(75,1,O_RESIN))
				return
			else O = new /obj/structure/alien/wall(targetLoc)
		if("resin membrane")
			if(!check_alien_ability(75,1,O_RESIN))
				return
			else O = new /obj/structure/alien/membrane(targetLoc)
		if("nest")
			if(!check_alien_ability(75,1,O_RESIN))
				return
			else O = new /obj/structure/bed/nest(targetLoc)
		if("resin blob")
			if(!check_alien_ability(75,1,O_RESIN))
				return
			else O = new /obj/item/stack/material/resin(targetLoc)

	if(O)
		visible_message(span_boldwarning("[src] vomits up a thick purple substance and begins to shape it!"), span_alium("You shape a [choice]."))
		O.color = "#321D37"
		playsound(src, 'sound/effects/blobattack.ogg', 40, 1)

	return

/mob/living/carbon/human/proc/leap()
	set category = "Abilities.Alien"
	set name = "Leap"
	set desc = "Leap at a target and grab them aggressively."

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		to_chat(src, "You cannot leap in your current state.")
		return

	var/list/choices = list()
	for(var/mob/living/M in view(6,src))
		if(!istype(M,/mob/living/silicon))
			choices += M
	choices -= src

	var/mob/living/T = tgui_input_list(src, "Who do you wish to leap at?", "Target Choice", choices)

	if(!T || !src || src.stat) return

	if(get_dist(get_turf(T), get_turf(src)) > 4) return

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		to_chat(src, "You cannot leap in your current state.")
		return

	last_special = world.time + 75
	status_flags |= LEAPING

	src.visible_message(span_danger("\The [src] leaps at [T]!"))
	src.throw_at(get_step(get_turf(T),get_turf(src)), 4, 1, src)
	playsound(src, 'sound/voice/hiss5.ogg', 50, 1)

	sleep(5)

	if(status_flags & LEAPING) status_flags &= ~LEAPING

	if(!src.Adjacent(T))
		to_chat(src, span_warning("You miss!"))
		return

	T.Weaken(3)

	var/use_hand = "left"
	if(l_hand)
		if(r_hand)
			to_chat(src, span_danger("You need to have one hand free to grab someone."))
			return
		else
			use_hand = "right"

	src.visible_message(span_boldwarning("\The [src]") + " seizes [T] aggressively!")

	var/obj/item/grab/G = new(src,T)
	if(use_hand == "left")
		l_hand = G
	else
		r_hand = G

	G.state = GRAB_PASSIVE
	G.icon_state = "grabbed1"
	G.synch()

/mob/living/carbon/human/proc/gut()
	set category = "Abilities.Alien"
	set name = "Slaughter"
	set desc = "While grabbing someone aggressively, rip their guts out or tear them apart."

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying)
		to_chat(src, span_danger("You cannot do that in your current state."))
		return

	var/obj/item/grab/G = locate() in src
	if(!G || !istype(G))
		to_chat(src, span_danger("You are not grabbing anyone."))
		return

	if(G.state < GRAB_AGGRESSIVE)
		to_chat(src, span_danger("You must have an aggressive grab to slaughter your prey!"))
		return

	last_special = world.time + 50

	visible_message(span_warning(span_bold("\The [src]") + " rips viciously at \the [G.affecting]'s body with its claws!"))

	if(istype(G.affecting,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = G.affecting
		H.apply_damage(50,BRUTE)
		if(H.stat == 2)
			H.gib()

	else
		var/mob/living/M = G.affecting
		if(!istype(M)) return //wut
		M.apply_damage(50,BRUTE)
		if(M.stat == 2)
			M.gib()
