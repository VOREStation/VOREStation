///////////////////////////////////////////////////////////////////////////////////
/// Micro/Macro chemicals

/decl/chemical_reaction/instant/sizeoxadone
	name = "sizeoxadone"
	id = "sizeoxadone"
	result = "sizeoxadone"
	required_reagents = list("clonexadone" = 1, "tramadol" = 3, "phoron" = 1)
	catalysts = list("phoron" = 5)
	result_amount = 5

/decl/chemical_reaction/instant/macrocillin
	name = "Macrocillin"
	id = "macrocillin"
	result = "macrocillin"
	// POLARISTODO requires_heating = 1
	required_reagents = list("sizeoxadone" = 20, "diethylamine" = 20)
	result_amount = 1

/decl/chemical_reaction/instant/microcillin
	name = "Microcillin"
	id = "microcillin"
	result = "microcillin"
	// POLARISTODO requires_heating = 1
	required_reagents = list("sizeoxadone" = 20, "sodiumchloride" = 20)
	result_amount = 1

/decl/chemical_reaction/instant/normalcillin
	name = "Normalcillin"
	id = "normalcillin"
	result = "normalcillin"
	// POLARISTODO requires_heating = 1
	required_reagents = list("sizeoxadone" = 20, "leporazine" = 20)
	result_amount = 1

/decl/chemical_reaction/instant/dontcrossthebeams
	name = "Don't Cross The Beams"
	id = "dontcrossthebeams"
	result = null
	required_reagents = list("microcillin" = 1, "macrocillin" = 1)

/decl/chemical_reaction/instant/dontcrossthebeams/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	playsound(location, 'sound/weapons/gauss_shoot.ogg', 50, 1)
	var/datum/effect/effect/system/grav_pull/s = new /datum/effect/effect/system/grav_pull
	s.set_up(3, 3, location)
	s.start()
	holder.clear_reagents()

///////////////////////////////////////////////////////////////////////////////////
/// TF chemicals
/decl/chemical_reaction/instant/amorphorovir
	name = "Amorphorovir"
	id = "amorphorovir"
	result = "amorphorovir"
	required_reagents = list("cryptobiolin" = 30, "biomass" = 30, "hyperzine" = 20)
	catalysts = list("phoron" = 5)
	result_amount = 1

/decl/chemical_reaction/instant/androrovir
	name = "Androrovir"
	id = "androrovir"
	result = "androrovir"
	required_reagents = list("amorphorovir" = 1, "bicaridine" = 20, "iron" = 20, "ethanol" = 20)
	result_amount = 1

/decl/chemical_reaction/instant/gynorovir
	name = "Gynorovir"
	id = "gynorovir"
	result = "gynorovir"
	required_reagents = list("amorphorovir" = 1, "inaprovaline" = 20, "silicon" = 20, "sugar" = 20)
	result_amount = 1

/decl/chemical_reaction/instant/androgynorovir
	name = "Androgynorovir"
	id = "androgynorovir"
	result = "androgynorovir"
	required_reagents = list("amorphorovir" = 1, "anti_toxin" = 20, "fluorine" = 20, "tungsten" = 20)
	result_amount = 1

/decl/chemical_reaction/instant/androrovir_bootleg
	name = "Bootleg Androrovir"
	id = "androrovir_bootleg"
	result = "androrovir"
	required_reagents = list("amorphorovir" = 1, "protein" = 10, "capsaicin" = 10)
	result_amount = 1

/decl/chemical_reaction/instant/gynorovir_bootleg
	name = "Bootleg Gynorovir"
	id = "gynorovir_bootleg"
	result = "gynorovir"
	required_reagents = list("amorphorovir" = 1, "soymilk" = 10, "sugar" = 10)
	result_amount = 1

/decl/chemical_reaction/instant/androgynorovir_bootleg
	name = "Bootleg Androgynorovir"
	id = "androgynorovir_bootleg"
	result = "androgynorovir"
	required_reagents = list("amorphorovir" = 1, "cola" = 10, "berryjuice" = 10)
	result_amount = 1

///////////////////////////////////////////////////////////////////////////////////
/// Miscellaneous Reactions

/decl/chemical_reaction/instant/xenolazarus
	name = "Discount Lazarus"
	id = "discountlazarus"
	result = null
	required_reagents = list("monstertamer" = 5, "clonexadone" = 5)

/decl/chemical_reaction/instant/xenolazarus/on_reaction(var/datum/reagents/holder, var/created_volume) //literally all this does is mash the regenerate button
	if(ishuman(holder.my_atom))
		var/mob/living/carbon/human/H = holder.my_atom
		if(H.stat == DEAD && (/mob/living/carbon/human/proc/reconstitute_form in H.verbs)) //no magical regen for non-regenners, and can't force the reaction on live ones
			if(H.hasnutriment()) // make sure it actually has the conditions to revive
				if(H.revive_ready >= 1) // if it's not reviving, start doing so
					H.revive_ready = REVIVING_READY // overrides the normal cooldown
					H.visible_message("<span class='info'>[H] shudders briefly, then relaxes, faint movements stirring within.</span>")
					H.chimera_regenerate()
				else if (/mob/living/carbon/human/proc/hatch in H.verbs)// already reviving, check if they're ready to hatch
					H.chimera_hatch()
					H.visible_message("<span class='danger'><p><font size=4>[H] violently convulses and then bursts open, revealing a new, intact copy in the pool of viscera.</font></p></span>") // Hope you were wearing waterproofs, doc...
					H.adjustBrainLoss(10) // they're reviving from dead, so take 10 brainloss
				else //they're already reviving but haven't hatched. Give a little message to tell them to wait.
					H.visible_message("<span class='info'>[H] stirs faintly, but doesn't appear to be ready to wake up yet.</span>")
			else
				H.visible_message("<span class='info'>[H] twitches for a moment, but remains still.</span>") // no nutriment


/decl/chemical_reaction/instant/foam/softdrink
	required_reagents = list("cola" = 1, "mint" = 1)

/decl/chemical_reaction/instant/firefightingfoam //TODO: Make it so we can add this to the foam tanks to refill them
    name = "Firefighting Foam"
    id = "firefighting foam"
    result = "firefoam"
    required_reagents = list("water" = 1)
    catalysts = list("fluorine" = 10)
    result_amount = 1

/decl/chemical_reaction/instant/firefightingfoamqol //Please don't abuse this and make us remove it. Seriously.
    name = "Firefighting Foam EZ"
    id = "firefighting foam ez"
    result = "firefoam"
    required_reagents = list("water" = 1)
    catalysts = list("firefoam" = 5)
    inhibitors = list("fluorine" = 0.01)
    result_amount = 1

/decl/chemical_reaction/instant/nutridax
	name = "Nutridax"
	id = "nutridax"
	result = "nutridax"
	required_reagents = list("oxygen" = 1, "lipozine" = 1, "carbon" = 1)
	result_amount = 3

///////////////////////////////////////////////////////////////////////////////////
/// Vore Drugs

/decl/chemical_reaction/instant/ickypak
	name = "Ickypak"
	id = "ickypak"
	result = "ickypak"
	required_reagents = list("hyperzine" = 4, "fluorosurfactant" = 1)
	result_amount = 5

/decl/chemical_reaction/instant/unsorbitol
	name = "Unsorbitol"
	id = "unsorbitol"
	result = "unsorbitol"
	required_reagents = list("mutagen" = 3, "lipozine" = 2)
	result_amount = 5

///////////////////////////////////////////////////////////////////////////////////
/// Other Drugs
/decl/chemical_reaction/instant/adranol
	name = "Adranol"
	id = "adranol"
	result = "adranol"
	required_reagents = list("milk" = 2, "hydrogen" = 1, "potassium" = 1)
	result_amount = 3

/decl/chemical_reaction/instant/vermicetol
	name = "Vermicetol"
	id = "vermicetol"
	result = "vermicetol"
	required_reagents = list("bicaridine" = 2, "shockchem" = 1, "phoron" = 0.1)
	catalysts = list("phoron" = 5)
	result_amount = 3

///////////////////////////////////////////////////////////////////////////////////
/// Reagent colonies.
/decl/chemical_reaction/instant/meatcolony
	name = "protein"
	id = "meatcolony"
	result = "protein"
	required_reagents = list("meatcolony" = 5, "virusfood" = 5)
	result_amount = 60

/decl/chemical_reaction/instant/plantcolony
	name = "nutriment"
	id = "plantcolony"
	result = "nutriment"
	required_reagents = list("plantcolony" = 5, "virusfood" = 5)
	result_amount = 60

///////////////////////////////
//SLIME CORES BELOW HERE///////
///////////////////////////////
/decl/chemical_reaction/instant/slime_food
	name = "Slime Bork"
	id = "m_tele2"
	result = null
	required_reagents = list("phoron" = 10, "slimejelly" = 5, "nutriment" = 20)
	result_amount = 1

/decl/chemical_reaction/instant/slime_food/on_reaction(var/datum/reagents/holder)
	var/list/borks = subtypesof(/obj/item/weapon/reagent_containers/food/snacks)

	playsound(holder.my_atom, 'sound/effects/phasein.ogg', 100, 1)

	for(var/i = 1, i <= 4 + rand(1,2), i++)
		var/chosen = pick(borks)
		var/obj/B = new chosen
		if(B)
			B.loc = get_turf(holder.my_atom)
			if(prob(50))
				for(var/j = 1, j <= rand(1, 3), j++)
					step(B, pick(NORTH,SOUTH,EAST,WEST))

/decl/chemical_reaction/instant/materials
	name = "Slime materials"
	id = "slimematerial"
	result = null
	required_reagents = list("phoron" = 20, "slimejelly" = 40, "aluminum" = 20) //Woah there! You have the possibility of making diamonds! 8 ground up slimes required for one of these, and you still have a 10% chance for it to fail.
	result_amount = 1

/decl/chemical_reaction/instant/materials/on_reaction(var/datum/reagents/holder)
	var/fail_chance = rand(1,1000)
	if(fail_chance == 1) // 0.1% chance of exploding, so scientists don't exclusively abuse this to obtain materials.
		for(var/mob/O in viewers(get_turf(holder.my_atom), null))
			O.show_message(text("<span class='warning'>The solution begins to vibrate violently!</span>"), 1) // It was at this moment, the Xenobiologist knew... he fucked up.
		spawn(30)
			playsound(holder.my_atom, 'sound/items/Welder2.ogg', 100, 1)
			for(var/mob/O in viewers(get_turf(holder.my_atom), null))
				O.show_message(text("<span class='warning'>The reaction begins to rapidly sizzle and swell outwards!</span>"), 1)
			
			spawn(20)
				explosion(get_turf(holder.my_atom), 0 ,4, 8) //Enough to cause severe damage in the area, but not so much that it'll instantly gib the person.
				empulse(get_turf(holder.my_atom), 3, 7) //Uh oh, it produced some uranium, too! EMP blast!
				return

	if(fail_chance < 101) // 10% chance of it not working at all.
		playsound(holder.my_atom, 'sound/items/Welder.ogg', 100, 1)
		for(var/mob/O in viewers(get_turf(holder.my_atom), null))
			O.show_message(text("<span class='warning'>The slime core fizzles disappointingly.</span>"), 1)
		return

	var/blocked = list(
						/obj/item/stack/material,					//Technical stacks
						/obj/item/stack/hairlesshide,		//Useless leather production steps
						/obj/item/stack/wetleather,
						/obj/item/stack/material/algae/ten)			//Why is this one even a separate thing
	blocked += typesof(/obj/item/stack/material/cyborg)				//Borg matter synths, should only exist in borgs
	blocked += typesof(/obj/item/stack/animalhide)			//Hides which are only used for leather production anyway

	var/rare_types = list(
						/obj/item/stack/material/morphium,			//Complex materials requiring Particle Smasher to create
						/obj/item/stack/material/morphium/hull,
						/obj/item/stack/material/valhollide,
						/obj/item/stack/material/supermatter)

	var/list/material = typesof(/obj/item/stack/material) - blocked

	playsound(holder.my_atom, 'sound/effects/phasein.ogg', 100, 1)

	var/spawn_amount = rand(1,50)
	var/chosen = pick(material)
	if(chosen in rare_types)
		spawn_amount = rand(1,15)
	new chosen(get_turf(holder.my_atom), spawn_amount)

/decl/chemical_reaction/instant/slimelight
	name = "Slime Glow"
	id = "m_glow"
	result = null
	required_reagents = list("phoron" = 5, "slimejelly" = 5, "water" = 10) //Takes 10 water so it doesn't mess with the frost oil.
	result_amount = 1

/decl/chemical_reaction/instant/slimelight/on_reaction(var/datum/reagents/holder)
	for(var/mob/O in viewers(get_turf(holder.my_atom), null))
		O.show_message(text("<span class='warning'> The contents of the slime core harden and begin to emit a warm, bright light.</span>"), 1)
	var/obj/item/device/flashlight/slime/F = new /obj/item/device/flashlight/slime
	F.loc = get_turf(holder.my_atom)


/decl/chemical_reaction/instant/slimephoron
	name = "Slime Phoron"
	id = "m_plasma"
	result = null
	required_reagents = list("phoron" = 20, "uranium" = 20, "slimejelly" = 20)
	result_amount = 1

/decl/chemical_reaction/instant/slimephoron/on_reaction(var/datum/reagents/holder)
	new /obj/item/stack/material/phoron(get_turf(holder.my_atom), 10)

/decl/chemical_reaction/instant/slimefreeze
	name = "Slime Freeze"
	id = "m_freeze"
	result = null
	required_reagents = list("phoron" = 10, "coolant" = 10, "slimejelly" = 10)
	result_amount = 1

/decl/chemical_reaction/instant/slimefreeze/on_reaction(var/datum/reagents/holder)
	for(var/mob/O in viewers(get_turf(holder.my_atom), null))
		O.show_message(text("<span class='warning'>The slime extract begins to vibrate violently!</span>"), 1)
	spawn(50)
		playsound(holder.my_atom, 'sound/effects/phasein.ogg', 100, 1)
		for(var/mob/living/M in range (get_turf(holder.my_atom), 7))
			M.bodytemperature -= 140
			to_chat(M, "<span class='notice'> You suddenly feel a chill!</span>")

/decl/chemical_reaction/instant/slimefrost
	name = "Slime Frost Oil"
	id = "m_frostoil"
	result = "frostoil"
	required_reagents = list("phoron" = 5, "slimejelly" = 5, "water" = 5, "coolant" = 5)
	result_amount = 10

/decl/chemical_reaction/instant/slimefire
	name = "Slime fire"
	id = "m_fire"
	result = null
	required_reagents = list("phoron" = 60, "slimejelly" = 30, "potassium" = 30)
	result_amount = 1

/decl/chemical_reaction/instant/slimefire/on_reaction(var/datum/reagents/holder)
	for(var/mob/O in viewers(get_turf(holder.my_atom), null))
		O.show_message(text("<span class='warning'>The slime extract begins to vibrate violently!</span>"), 1)
	spawn(50)
		var/turf/location = get_turf(holder.my_atom.loc)
		for(var/turf/simulated/floor/target_tile in range(0,location))
			target_tile.assume_gas("phoron", 25, 1400)
			spawn (0) target_tile.hotspot_expose(700, 400)

/decl/chemical_reaction/instant/slimeify
	name = "Advanced Mutation Toxin"
	id = "advmutationtoxin2"
	result = "advmutationtoxin"
	required_reagents = list("phoron" = 15, "slimejelly" = 15, "mutationtoxin" = 15) //In case a xenobiologist wants to become a fully fledged slime person.
	result_amount = 1

/decl/chemical_reaction/instant/slimeheal //A slime healing mixture. Why not.
	name = "Slime Health"
	id = "slimeheal"
	result = "null"
	required_reagents = list("phoron" = 10, "bicaridine" = 10, "kelotane" = 10, "inaprovaline" = 10, "slimejelly" = 10)

/decl/chemical_reaction/instant/slimeheal/on_reaction(var/datum/reagents/holder, var/created_volume)
	for (var/mob/living/carbon/C in viewers(get_turf(holder.my_atom), null))
		to_chat(C, "<span class='notice'>A wave of energy suddenly invigorates you.</span>")
		C.adjustBruteLoss(-25)
		C.adjustFireLoss(-25)
		C.adjustToxLoss(-25)
		C.adjustOxyLoss(-25)
		C.adjustBrainLoss(-25)
		C.adjustCloneLoss(-25)
		C.updatehealth()

/decl/chemical_reaction/instant/slimejelly
	name = "Slime Jam"
	id = "m_jam"
	result = "slimejelly"
	required_reagents = list("phoron" = 20, "sugar" = 50, "lithium" = 50) //In case a xenobiologist is impatient and is willing to drain their dispenser resources, along with plasma!
	result_amount = 5

/decl/chemical_reaction/instant/slimevore
	name = "Slime Vore" // Hostile vore mobs only
	id = "m_tele"
	result = null
	required_reagents = list("phoron" = 20, "nutriment" = 20, "sugar" = 20, "mutationtoxin" = 20) //Can't do slime jelly as it'll conflict with another, but mutation toxin will do.
	result_amount = 1

/decl/chemical_reaction/instant/slimevore/on_reaction(var/datum/reagents/holder)
	var/mob_path = /mob/living/simple_mob
	var/blocked = list(														//List of things we do NOT want to spawn
		/mob/living/simple_mob,												//Technical parent mobs
		/mob/living/simple_mob/animal,
		/mob/living/simple_mob/animal/passive,
		/mob/living/simple_mob/animal/space,
		/mob/living/simple_mob/blob,
		/mob/living/simple_mob/mechanical,
		/mob/living/simple_mob/mechanical/mecha,
		/mob/living/simple_mob/slime,
		/mob/living/simple_mob/vore,
		/mob/living/simple_mob/vore/aggressive,
		/mob/living/simple_mob/illusion,									//Other technical mobs
		/mob/living/simple_mob/animal/passive/crab/Coffee,					//Unique pets/named mobs
		/mob/living/simple_mob/animal/passive/cat/runtime,
		/mob/living/simple_mob/animal/passive/cat/bones,
		/mob/living/simple_mob/animal/passive/cat/tabiranth,
		/mob/living/simple_mob/animal/passive/dog/corgi/puppy/Bockscar,
		/mob/living/simple_mob/animal/passive/dog/corgi/Ian,
		/mob/living/simple_mob/animal/passive/dog/corgi/Lisa,
		/mob/living/simple_mob/animal/passive/dog/tamaskan/Spice,
		/mob/living/simple_mob/animal/passive/fox/renault,
		/mob/living/simple_mob/animal/passive/bird/azure_tit/tweeter,
		/mob/living/simple_mob/animal/passive/bird/parrot/poly,
		/mob/living/simple_mob/animal/sif/fluffy,
		/mob/living/simple_mob/animal/sif/fluffy/silky,
		/mob/living/simple_mob/animal/passive/snake/python/noodle,
		/mob/living/simple_mob/slime/xenobio/rainbow/kendrick,
		/mob/living/simple_mob/animal/space/space_worm,						//Space Worm parts that aren't proper heads
		/mob/living/simple_mob/animal/space/space_worm/head/severed,
		/mob/living/simple_mob/animal/borer,								//Event/player-control-only mobs
		/mob/living/simple_mob/vore/hostile/morph
		)//exclusion list for things you don't want the reaction to create.
	blocked += typesof(/mob/living/simple_mob/mechanical/ward)				//Wards that should be created with ward items, are mobs mostly on technicalities
	blocked += typesof(/mob/living/simple_mob/construct)					//Should only exist
	blocked += typesof(/mob/living/simple_mob/vore/demon)					//as player-controlled
	blocked += typesof(/mob/living/simple_mob/shadekin)						//and/or event things
	var/list/voremobs = typesof(mob_path) - blocked // list of possible hostile mobs

	playsound(holder.my_atom, 'sound/effects/phasein.ogg', 100, 1)
	var/spawn_count = rand(1,3)
	for(var/i = 1, i <= spawn_count, i++)
		var/chosen = pick(voremobs)
		var/mob/living/simple_mob/C = new chosen
		C.faction = "slimesummon"
		C.loc = get_turf(holder.my_atom)
		if(prob(50))
			for(var/j = 1, j <= rand(1, 3), j++)
				step(C, pick(NORTH,SOUTH,EAST,WEST))

/decl/chemical_reaction/instant/slime/sapphire_mutation
	name = "Slime Mutation Toxins"
	id = "slime_mutation_tox"
	result = "mutationtoxin"
	required_reagents = list("blood" = 5)
	result_amount = 30
	required = /obj/item/slime_extract/sapphire

/decl/chemical_reaction/instant/biomass
	result_amount = 6	// Roughly 120u per phoron sheet
