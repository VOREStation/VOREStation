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
/// Miscellaneous Reactions

/datum/chemical_reaction/xenolazarus
	name = "Discount Lazarus"
	id = "discountlazarus"
	result = null
	required_reagents = list("monstertamer" = 5, "clonexadone" = 5)

/datum/chemical_reaction/xenolazarus/on_reaction(var/datum/reagents/holder, var/created_volume) //literally all this does is mash the regenerate button
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


/datum/chemical_reaction/foam/softdrink
	required_reagents = list("cola" = 1, "mint" = 1)

/datum/chemical_reaction/firefightingfoam //TODO: Make it so we can add this to the foam tanks to refill them
    name = "Firefighting Foam"
    id = "firefighting foam"
    result = "firefoam"
    required_reagents = list("water" = 1)
    catalysts = list("fluorine" = 10)
    result_amount = 1
	
/datum/chemical_reaction/firefightingfoamqol //Please don't abuse this and make us remove it. Seriously.
    name = "Firefighting Foam EZ"
    id = "firefighting foam ez"
    result = "firefoam"
    required_reagents = list("water" = 1)
    catalysts = list("firefoam" = 5)
    inhibitors = list("fluorine" = 0.01)
    result_amount = 1

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

///////////////////////////////////////////////////////////////////////////////////
/// Other Drugs
/datum/chemical_reaction/adranol
	name = "Adranol"
	id = "adranol"
	result = "adranol"
	required_reagents = list("milk" = 2, "hydrogen" = 1, "potassium" = 1)
	result_amount = 3

/datum/chemical_reaction/vermicetol
	name = "Vermicetol"
	id = "vermicetol"
	result = "vermicetol"
	required_reagents = list("bicaridine" = 2, "shockchem" = 1, "phoron" = 0.1)
	catalysts = list("phoron" = 5)
	result_amount = 3

///////////////////////////////////////////////////////////////////////////////////
/// Special drinks
/datum/chemical_reaction/drinks/grubshake
	name = "Grub protein drink"
	id = "grubshake"
	result = "grubshake"
	required_reagents = list("shockchem" = 5, "water" = 25)
	result_amount = 30

/datum/chemical_reaction/drinks/deathbell
	name = "Deathbell"
	id = "deathbell"
	result = "deathbell"
	required_reagents = list("antifreeze" = 1, "gargleblaster" = 1, "syndicatebomb" =1)
	result_amount = 3

/datum/chemical_reaction/drinks/monstertamer
	name = "Monster Tamer"
	id = "monstertamer"
	result = "monstertamer"
	required_reagents = list("whiskey" = 1, "protein" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/bigbeer
	name = "Giant Beer"
	id = "bigbeer"
	result = "bigbeer"
	required_reagents = list("syndicatebomb" = 1, "manlydorf" = 1, "grog" =1)
	result_amount = 3

/datum/chemical_reaction/drinks/sweettea
	name = "Sweetened Tea"
	id = "sweettea"
	result = "sweettea"
	required_reagents = list("icetea" = 2, "sugar" = 1,)
	result_amount = 3

/datum/chemical_reaction/drinks/unsweettea
	name = "Unsweetened Tea"
	id = "unsweettea"
	result = "unsweettea"
	required_reagents = list("sweettea" = 3, "phoron" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/galacticpanic
	name = "Galactic Panic Attack"
	id = "galacticpanic"
	result = "galacticpanic"
	required_reagents = list("gargleblaster" = 1, "singulo" = 1, "phoronspecial" =1, "neurotoxin" = 1, "atomicbomb" = 1, "hippiesdelight" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/bulldog
	name = "Space Bulldog"
	id = "bulldog"
	result = "bulldog"
	required_reagents = list("whiterussian" = 4, "cola" =1)
	result_amount = 4

/datum/chemical_reaction/drinks/sbagliato
	name = "Negroni Sbagliato"
	id = "sbagliato"
	result = "sbagliato"
	required_reagents = list("wine" = 1, "vermouth" = 1, "sodawater" =1)
	result_amount = 3

/datum/chemical_reaction/drinks/italiancrisis
	name = "Italian Crisis"
	id = "italiancrisis"
	result = "italiancrisis"
	required_reagents = list("bulldog" = 1, "sbagliato" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/sugarrush
	name = "Sweet Rush"
	id = "sugarrush"
	result = "sugarrush"
	required_reagents = list("sugar" = 1, "sodawater" = 1, "vodka" =1)
	result_amount = 3

/datum/chemical_reaction/drinks/lotus
	name = "Lotus"
	id = "lotus"
	result = "lotus"
	required_reagents = list("sbagliato" = 1, "sugarrush" = 1)
	result_amount = 2

/datum/chemical_reaction/drinks/shroomjuice
	name = "Dumb Shroom Juice"
	id = "shroomjuice"
	result = "shroomjuice"
	required_reagents = list("psilocybin" = 1, "applejuice" = 1, "limejuice" =1)
	result_amount = 3

/datum/chemical_reaction/drinks/russianroulette
	name = "Russian Roulette"
	id = "russianroulette"
	result = "russianroulette"
	required_reagents = list("whiterussian" = 5, "iron" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/lovemaker
	name = "The Love Maker"
	id = "lovemaker"
	result = "lovemaker"
	required_reagents = list("honey" = 1, "sexonthebeach" = 5)
	result_amount = 6

/datum/chemical_reaction/drinks/honeyshot
	name = "Honey Shot"
	id = "honeyshot"
	result = "honeyshot"
	required_reagents = list("honey" = 1, "vodka" = 1, "grenadine" =1)
	result_amount = 3

/datum/chemical_reaction/drinks/appletini
	name = "Appletini"
	id = "appletini"
	result = "appletini"
	required_reagents = list("applejuice" = 2, "vodka" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/glowingappletini
	name = "Glowing Appletini"
	id = "glowingappletini"
	result = "glowingappletini"
	required_reagents = list("appletini" = 5, "uranium" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/scsatw
	name = "Slow Comfortable Screw Against the Wall"
	id = "scsatw"
	result = "scsatw"
	required_reagents = list("screwdrivercocktail" = 3, "rum" =1, "whiskey" =1, "gin" =1)
	result_amount = 6

/datum/chemical_reaction/drinks/choccymilk
	name = "Choccy Milk"
	id = "choccymilk"
	result = "choccymilk"
	required_reagents = list("milk" = 3, "coco" = 1)
	result_amount = 4

/datum/chemical_reaction/drinks/redspaceflush
	name = "Redspace Flush"
	id = "redspaceflush"
	result = "redspaceflush"
	required_reagents = list("rum" = 2, "whiskey" = 2, "blood" =1, "phoron" =1)
	result_amount = 6

/datum/chemical_reaction/drinks/graveyard
	name = "Graveyard"
	id = "graveyard"
	result = "graveyard"
	required_reagents = list("cola" = 1, "spacemountainwind" = 1, "dr_gibb" =1, "space_up" = 1)
	result_amount = 4

/datum/chemical_reaction/drinks/hairoftherat
	name = "Hair of the Rat"
	id = "hairoftherat"
	result = "hairoftherat"
	required_reagents = list("monstertamer" = 2, "nutriment" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/pink_moo
	name = "Pink Moo"
	id = "pinkmoo"
	result = "pinkmoo"
	required_reagents = list("blackrussian" = 2, "berryshake" = 1)
	result_amount = 3

/datum/chemical_reaction/drinks/originalsin
	name = "Original Sin"
	id = "originalsin"
	result = "originalsin"
	required_reagents = list("holywine" = 1)
	catalysts = list("applejuice" = 1)
	result_amount = 1

/datum/chemical_reaction/drinks/windgarita
	name = "WND-Garita"
	id = "windgarita"
	result = "windgarita"
	required_reagents = list("margarita" = 3, "spacemountainwind" = 2, "melonliquor" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/newyorksour
	name = "New York Sour"
	id = "newyorksour"
	result = "newyorksour"
	required_reagents = list("whiskeysour" = 3, "wine" = 2, "egg" = 1)
	result_amount = 6

/datum/chemical_reaction/drinks/mudslide
	name = "Mudslide"
	id = "mudslide"
	result = "mudslide"
	required_reagents = list("blackrussian" = 1, "irishcream" = 1)
	result_amount = 2

///////////////////////////////////////////////////////////////////////////////////
/// Reagent colonies.
/datum/chemical_reaction/meatcolony
	name = "protein"
	id = "meatcolony"
	result = "protein"
	required_reagents = list("meatcolony" = 5, "virusfood" = 5)
	result_amount = 60

/datum/chemical_reaction/plantcolony
	name = "nutriment"
	id = "plantcolony"
	result = "nutriment"
	required_reagents = list("plantcolony" = 5, "virusfood" = 5)
	result_amount = 60

///////////////////////////////
//SLIME CORES BELOW HERE///////
///////////////////////////////



/datum/chemical_reaction/slime_food
	name = "Slime Bork"
	id = "m_tele2"
	result = null
	required_reagents = list("phoron" = 10, "slimejelly" = 5, "nutriment" = 20)
	result_amount = 1
	on_reaction(var/datum/reagents/holder)

		var/list/borks = typesof(/obj/item/weapon/reagent_containers/food/snacks) - /obj/item/weapon/reagent_containers/food/snacks // BORK BORK BORK

		playsound(holder.my_atom, 'sound/effects/phasein.ogg', 100, 1)
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
			playsound(holder.my_atom, 'sound/items/Welder2.ogg', 100, 1)
			for(var/mob/O in viewers(get_turf(holder.my_atom), null))
				O.show_message(text("<span class='warning'>The reaction begins to rapidly sizzle and swell outwards!</span>"), 1)
			sleep(20)
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
/* Removed at some point, unsure what to replace with
		for(var/mob/living/carbon/human/M in viewers(get_turf(holder.my_atom), null))
			if(M:eyecheck() <= 0)
				flick("e_flash", M.flash)
*/
		var/spawn_amount = rand(1,50)
		var/chosen = pick(material)
		if(chosen in rare_types)
			spawn_amount = rand(1,15)
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
		playsound(holder.my_atom, 'sound/effects/phasein.ogg', 100, 1)
		for(var/mob/living/M in range (get_turf(holder.my_atom), 7))
			M.bodytemperature -= 140
			to_chat(M, "<span class='notice'> You suddenly feel a chill!</span>")




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
			to_chat(C, "<span class='notice'>A wave of energy suddenly invigorates you.</span>")
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
			/mob/living/simple_mob/animal/passive/snake/noodle,
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
		blocked += typesof(/mob/living/simple_mob/horror)
		var/list/voremobs = typesof(mob_path) - blocked // list of possible hostile mobs

		playsound(holder.my_atom, 'sound/effects/phasein.ogg', 100, 1)
/* Removed at some point, unsure what to replace with
		for(var/mob/living/carbon/human/M in viewers(get_turf(holder.my_atom), null))
			if(M:eyecheck() <= 0)
				flick("e_flash", M.flash)
*/
		var/spawn_count = rand(1,3)
		for(var/i = 1, i <= spawn_count, i++)
			var/chosen = pick(voremobs)
			var/mob/living/simple_mob/C = new chosen
			C.faction = "slimesummon"
			C.loc = get_turf(holder.my_atom)
			if(prob(50))
				for(var/j = 1, j <= rand(1, 3), j++)
					step(C, pick(NORTH,SOUTH,EAST,WEST))


/datum/chemical_reaction/food/syntiflesh
	required_reagents = list("blood" = 5, "clonexadone" = 1)

/datum/chemical_reaction/biomass
	result_amount = 6	// Roughly 120u per phoron sheet
