///////////////////////////////////////////////////////////////////////////////////
/// Micro/Macro chemicals

/datum/chemical_reaction/sizeoxadone
	name = "sizeoxadone"
	id = "sizeoxadone"
	result = "sizeoxadone"
	required_reagents = list("clonexadone" = 1, "tramadol" = 3, "phoron" = 1)
	catalysts = list("phoron" = 5)
	result_amount = 5

/datum/chemical_reaction/macrocillin
	name = "Macrocillin"
	id = "macrocillin"
	result = "macrocillin"
	// POLARISTODO requires_heating = 1
	required_reagents = list("sizeoxadone" = 20, "diethylamine" = 20)
	result_amount = 1

/datum/chemical_reaction/microcillin
	name = "Microcillin"
	id = "microcillin"
	result = "microcillin"
	// POLARISTODO requires_heating = 1
	required_reagents = list("sizeoxadone" = 20, "sodiumchloride" = 20)
	result_amount = 1

/datum/chemical_reaction/normalcillin
	name = "Normalcillin"
	id = "normalcillin"
	result = "normalcillin"
	// POLARISTODO requires_heating = 1
	required_reagents = list("sizeoxadone" = 20, "leporazine" = 20)
	result_amount = 1

/datum/chemical_reaction/dontcrossthebeams
	name = "Don't Cross The Beams"
	id = "dontcrossthebeams"
	result = null
	required_reagents = list("microcillin" = 1, "macrocillin" = 1)

/datum/chemical_reaction/dontcrossthebeams/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	playsound(location, 'sound/weapons/gauss_shoot.ogg', 50, 1)
	var/datum/effect/effect/system/grav_pull/s = new /datum/effect/effect/system/grav_pull
	s.set_up(3, 3, location)
	s.start()
	holder.clear_reagents()

///////////////////////////////////////////////////////////////////////////////////
/// Vore Drugs

/datum/chemical_reaction/ickypak
	name = "Ickypak"
	id = "ickypak"
	result = "ickypak"
	required_reagents = list("hyperzine" = 4, "fluorosurfactant" = 1)
	result_amount = 5

/datum/chemical_reaction/unsorbitol
	name = "Unsorbitol"
	id = "unsorbitol"
	result = "unsorbitol"
	required_reagents = list("mutagen" = 3, "lipozine" = 2)
	result_amount = 5







///////////////////////////////
//SLIME CORES BELOW HERE///////
///////////////////////////////



/datum/chemical_reaction/slime_food
	name = "Slime Bork"
	id = "m_tele2"
	result = null
	required_reagents = list("phoron" = 10, "slimejelly" = 10, "nutriment" = 10)
	result_amount = 1
	on_reaction(var/datum/reagents/holder)

		var/list/borks = typesof(/obj/item/weapon/reagent_containers/food/snacks) - /obj/item/weapon/reagent_containers/food/snacks // BORK BORK BORK

		playsound(get_turf(holder.my_atom), 'sound/effects/phasein.ogg', 100, 1)
/* Removed at some point, unsure what to replace with
		for(var/mob/living/carbon/human/M in viewers(get_turf(holder.my_atom), null))
			if(M:eyecheck() <= 0)
				flick("e_flash", M.flash)
*/
		for(var/i = 1, i <= 4 + rand(1,2), i++)
			var/chosen = pick(borks)
			var/obj/B = new chosen
			if(B)
				B.loc = get_turf(holder.my_atom)
				if(prob(50))
					for(var/j = 1, j <= rand(1, 3), j++)
						step(B, pick(NORTH,SOUTH,EAST,WEST))




/datum/chemical_reaction/materials
	name = "Slime materials"
	id = "slimematerial"
	result = null
	required_reagents = list("phoron" = 20, "slimejelly" = 40, "aluminum" = 20) //Woah there! You have the possibility of making diamonds! 8 ground up slimes required for one of these, and you still have a 10% chance for it to fail.
	result_amount = 1
	on_reaction(var/datum/reagents/holder)
		var/fail_chance = rand(1,1000)
		if(fail_chance == 1) // 0.1% chance of exploding, so scientists don't exclusively abuse this to obtain materials.
			for(var/mob/O in viewers(get_turf(holder.my_atom), null))
				O.show_message(text("<span class='warning'>The solution begins to vibrate violently!</span>"), 1) // It was at this moment, the Xenobiologist knew... he fucked up.
			sleep(30)
			playsound(get_turf(holder.my_atom), 'sound/items/Welder2.ogg', 100, 1)
			for(var/mob/O in viewers(get_turf(holder.my_atom), null))
				O.show_message(text("<span class='warning'>The reaction begins to rapidly sizzle and swell outwards!</span>"), 1)
			sleep(20)
			explosion(get_turf(holder.my_atom), 0 ,4, 8) //Enough to cause severe damage in the area, but not so much that it'll instantly gib the person.
			empulse(get_turf(holder.my_atom), 3, 7) //Uh oh, it produced some uranium, too! EMP blast!
			return

		if(fail_chance < 101) // 10% chance of it not working at all.
			playsound(get_turf(holder.my_atom), 'sound/items/Welder.ogg', 100, 1)
			for(var/mob/O in viewers(get_turf(holder.my_atom), null))
				O.show_message(text("<span class='warning'>The slime core fizzles disappointingly.</span>"), 1)
			return

		var/blocked = list(/obj/item/stack/material, /obj/item/stack/material/cyborg, /obj/item/stack/material/cyborg/plastic, /obj/item/stack/material/cyborg/plasteel, /obj/item/stack/material/cyborg/glass/reinforced, /obj/item/stack/material/cyborg/wood, /obj/item/stack/material/animalhide/human, /obj/item/stack/material/animalhide/corgi, /obj/item/stack/material/animalhide/cat, /obj/item/stack/material/animalhide/monkey, /obj/item/stack/material/animalhide/lizard , /obj/item/stack/material/animalhide/xeno, /obj/item/stack/material/cyborg, /obj/item/stack/material/cyborg/glass/reinforced)
		var/list/material = typesof(/obj/item/stack/material) - blocked

		playsound(get_turf(holder.my_atom), 'sound/effects/phasein.ogg', 100, 1)
/* Removed at some point, unsure what to replace with
		for(var/mob/living/carbon/human/M in viewers(get_turf(holder.my_atom), null))
			if(M:eyecheck() <= 0)
				flick("e_flash", M.flash)
*/
		var/spawn_amount = rand(1,50)
		var/chosen = pick(material)
		var/obj/item/stack/material/C = new chosen
		C.amount = spawn_amount
		C.loc = get_turf(holder.my_atom)


/datum/chemical_reaction/slimelight
	name = "Slime Glow"
	id = "m_glow"
	result = null
	required_reagents = list("phoron" = 5, "slimejelly" = 5, "water" = 10) //Takes 10 water so it doesn't mess with the frost oil.
	result_amount = 1
	on_reaction(var/datum/reagents/holder)
		for(var/mob/O in viewers(get_turf(holder.my_atom), null))
			O.show_message(text("<span class='warning'> The contents of the slime core harden and begin to emit a warm, bright light.</span>"), 1)
		var/obj/item/device/flashlight/slime/F = new /obj/item/device/flashlight/slime
		F.loc = get_turf(holder.my_atom)


/datum/chemical_reaction/slimephoron
	name = "Slime Phoron"
	id = "m_plasma"
	result = null
	required_reagents = list("phoron" = 20, "uranium" = 20, "slimejelly" = 20)
	result_amount = 1
	on_reaction(var/datum/reagents/holder)
		var/obj/item/stack/material/phoron/P = new /obj/item/stack/material/phoron
		P.amount = 10
		P.loc = get_turf(holder.my_atom)

/datum/chemical_reaction/slimefreeze
	name = "Slime Freeze"
	id = "m_freeze"
	result = null
	required_reagents = list("phoron" = 10, "coolant" = 10, "slimejelly" = 10)
	result_amount = 1
	on_reaction(var/datum/reagents/holder)
		for(var/mob/O in viewers(get_turf(holder.my_atom), null))
			O.show_message(text("<span class='warning'>The slime extract begins to vibrate violently!</span>"), 1)
		sleep(50)
		playsound(get_turf(holder.my_atom), 'sound/effects/phasein.ogg', 100, 1)
		for(var/mob/living/M in range (get_turf(holder.my_atom), 7))
			M.bodytemperature -= 140
			M << "<span class='notice'> You suddenly feel a chill!</span>"




/datum/chemical_reaction/slimefrost
	name = "Slime Frost Oil"
	id = "m_frostoil"
	result = "frostoil"
	required_reagents = list("phoron" = 5, "slimejelly" = 5, "water" = 5, "coolant" = 5)
	result_amount = 10




/datum/chemical_reaction/slimefire
	name = "Slime fire"
	id = "m_fire"
	result = null
	required_reagents = list("phoron" = 60, "slimejelly" = 30, "potassium" = 30)
	result_amount = 1
	on_reaction(var/datum/reagents/holder)
		for(var/mob/O in viewers(get_turf(holder.my_atom), null))
			O.show_message(text("<span class='warning'>The slime extract begins to vibrate violently!</span>"), 1)
		sleep(50)
		var/turf/location = get_turf(holder.my_atom.loc)
		for(var/turf/simulated/floor/target_tile in range(0,location))
			target_tile.assume_gas("phoron", 25, 1400)
			spawn (0) target_tile.hotspot_expose(700, 400)


/datum/chemical_reaction/slimeify
	name = "Advanced Mutation Toxin"
	id = "advmutationtoxin2"
	result = "advmutationtoxin"
	required_reagents = list("phoron" = 15, "slimejelly" = 15, "mutationtoxin" = 15) //In case a xenobiologist wants to become a fully fledged slime person.
	result_amount = 1





/datum/chemical_reaction/slimeheal //A slime healing mixture. Why not.
	name = "Slime Health"
	id = "slimeheal"
	result = "null"
	required_reagents = list("phoron" = 10, "bicaridine" = 10, "kelotane" = 10, "inaprovaline" = 10, "slimejelly" = 10)
	on_reaction(var/datum/reagents/holder, var/created_volume)
		for (var/mob/living/carbon/C in viewers(get_turf(holder.my_atom), null))
			C << "<span class='notice'>A wave of energy suddenly invigorates you.</span>"
			C.adjustBruteLoss(-25)
			C.adjustFireLoss(-25)
			C.adjustToxLoss(-25)
			C.adjustOxyLoss(-25)
			C.adjustBrainLoss(-25)
			C.adjustCloneLoss(-25)
			C.updatehealth()

/datum/chemical_reaction/slimejelly
	name = "Slime Jam"
	id = "m_jam"
	result = "slimejelly"
	required_reagents = list("phoron" = 20, "sugar" = 50, "lithium" = 50) //In case a xenobiologist is impatient and is willing to drain their dispenser resources, along with plasma!
	result_amount = 5





/datum/chemical_reaction/slimevore
	name = "Slime Vore" // Hostile vore mobs only
	id = "m_tele"
	result = null
	required_reagents = list("phoron" = 20, "nutriment" = 20, "sugar" = 20, "mutationtoxin" = 20) //Can't do slime jelly as it'll conflict with another, but mutation toxin will do.
	result_amount = 1
	on_reaction(var/datum/reagents/holder)
		var/mob_path = /mob/living/simple_animal/hostile/vore
		var/blocked = list(
			/mob/living/simple_animal/hostile/vore/mimic,
			/mob/living/simple_animal/hostile/vore/mimic/copy,
			/mob/living/simple_animal/hostile/vore/mimic/crate,
			/mob/living/simple_animal/hostile/vore/alien/queen/large
			)//exclusion list for things you don't want the reaction to create.
		var/list/voremobs = typesof(mob_path) - mob_path - blocked // list of possible hostile mobs

		playsound(get_turf(holder.my_atom), 'sound/effects/phasein.ogg', 100, 1)
/* Removed at some point, unsure what to replace with
		for(var/mob/living/carbon/human/M in viewers(get_turf(holder.my_atom), null))
			if(M:eyecheck() <= 0)
				flick("e_flash", M.flash)
*/
		var/spawn_count = rand(1,3)
		for(var/i = 1, i <= spawn_count, i++)
			var/chosen = pick(voremobs)
			var/mob/living/simple_animal/hostile/C = new chosen
			C.faction = "slimesummon"
			C.loc = get_turf(holder.my_atom)
			if(prob(50))
				for(var/j = 1, j <= rand(1, 3), j++)
					step(C, pick(NORTH,SOUTH,EAST,WEST))
