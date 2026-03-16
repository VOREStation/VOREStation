//Rig-Suits with AI or supernatural forces controlling them, a dead person inside.
//The base is based off of the EVA Rig.
//todo: Add catalogue data.

/mob/living/simple_mob/humanoid/possessed
	name = "old EVA RIG suit"
	desc = "A light hardsuit for repairs and maintenance to the outside of habitats and vessels. Seems to be worn down and damaged. But it seems to still be moving. Is someone in it?"
	icon = 'icons/mob/possessed.dmi'
	icon_state = "eva-rig"

	faction = "Possessed"
	movement_cooldown = 10

	health = 200
	maxHealth = 200
	taser_kill = 0

	var/idle = 4 //how long between the breathing sounds, in seconds.
	var/silenced = 0 //Wither or not the sounds and speaking will play.

	//It's a RIG. It's spaceproof.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	harm_intent_damage = 1
	melee_damage_lower = 10
	melee_damage_upper = 25
	attacktext = list("punched", "kicked", "smacked")
	attack_sound = "punch"
	armor = list(melee = 30, bullet = 10, laser = 20,energy = 25, bomb = 20, bio = 100, rad = 100) //This should be the same as the base RIG.

	has_hands = 1
	humanoid_hands = 1

	grab_resist = 100

	movement_sound = 'sound/effects/footstep/floor1.ogg'

	//Simple mob merc so it stops, says something, then charges.
	ai_holder_type = /datum/ai_holder/simple_mob/merc
	say_list_type = /datum/say_list/possessed //Set to Null on silenced.

	can_pain_emote = FALSE

//	corpse = /obj/effect/landmark/mobcorpse/possessed
// Will eventually leave a full corpse with an activated RIG on it. But not yet.

//Miasma Cloud "Item"
/obj/item/grenade/chem_grenade/miasma
	name = "Miasma Bomb"
	desc = "You probably shouldn't be able to see this."
	stage = 2
	path = 1

/obj/item/grenade/chem_grenade/miasma/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent(REAGENT_ID_MIASMA, 30)
	B1.reagents.add_reagent(REAGENT_ID_POTASSIUM, 5)
	B2.reagents.add_reagent(REAGENT_ID_SUGAR, 5)
	B2.reagents.add_reagent(REAGENT_ID_PHOSPHORUS, 5)

	beakers += B1
	beakers += B2

	icon_state = null

	detonate()

//Has a chance to play one of the listed sounds when it moves.
/mob/living/simple_mob/humanoid/possessed/Moved()
	. = ..()
	if(prob(5) && silenced == 0)
		playsound(src, pick('sound/h_sounds/headcrab.ogg', 'sound/h_sounds/holla.ogg', 'sound/h_sounds/lynx.ogg', 'sound/h_sounds/mumble.ogg', 'sound/h_sounds/yell.ogg'), 50, 1)

//Plays the sound every ~4 seconds.
/mob/living/simple_mob/humanoid/possessed/Life()
	if(idle <= 0 && silenced == 0)
		playsound(src, 'sound/h_sounds/breathing.ogg', 60, 1)
		idle = 4
	idle--

//Dies with a variety of messages, a disgusting sound, then drops the control module, bones, blood, gibs, and a cloud of miasma.
/mob/living/simple_mob/humanoid/possessed/Destroy()
	var/droploc = get_turf(src)
	playsound(src, 'sound/effects/blobattack.ogg', 40, 1)
	visible_message(span_critical(pick("The horrid screech of metal grating metal cuts through the air as the suit's interlocking joints grind and fold inwards upon itself. A putrid wash of decayed flesh spills forwards, staining the ground dark with the contents of the collapsing RIG's long expired pilot.",
	"\The [src] shudders as some hurt living thing, reeling as screaming servos overcompensate beneath the weight of that debilitating strike - the horrid sounds of shattered metal resonate as the RIG rips itself apart. Limbs flung about in distinctly inhuman motions in a final failed effort at balance before buckling inwards at the joints, hydraulic fluid jettisoned as blood from a severed artery as the long liquidized contents of the suit's ex-pilot spill from its chassis in a thick slurry.",
	"Hissing atmosphereic valves pop and snap, breaking the ageless seal as the putrid stench of rot and carrion assaults the senses in debilitating waves. The damaged RIG's visor alight with warnings of hazardous atmospheric conditions as a final distorted scream echos from within the damaged chassis. The fetid miasma that breeches through those wheezing seals overtaken by a wet burble and plop as the suit is bathed in the liquid contents of its passenger, blackened flesh fed through those narrow seals as rotten grounds.",
	"The timeworn suit's seals finally crack open with a hiss - spilling forth a thick fungal mist. The control module ejects from the rig as it loses all control impulses - leaving behind but a pile of bones and the rotten sludge it had been swimming in for heaven knows how long.",
	"\The [src]'s emergency protocols kick in, retracting around the former-person, who's now little more than a disgusting pile of parts not even a vulture would want. The control module appears to be intact, however.",
	"The suit finally lets go of the prisoner it had held for so long. Unfortunately, this guy reminds you of that news report of someone who forgot that Ganymede rock lobster in a fridge for a year, the thick miasma of fungi and rotten gasses visibly pouring out, pushing out rancid bits of meat and slimy bones. The only salvageable bit appears to be the Control Module.",
	"A few last desperate seals give out with a weary series of pops, and the suit contorts with the final pressure differentials resolved: the suit tangles and leaks, and finally compacts back into it's rightful shape.",
	"Tightening, the suit re-attempts to remain it's current form, before it collapses under the stress, supporting mechanisms closing in on themselves like a noose with nothing left to catch on.",
	"The suit makes a noise akin to clockwork binding, and shutters, before something imperceptible gives with an abysmal noise and the suit returns to it's default form.")))
	gib()
	/* Nah
	if(rand(1,2) == 1)
		new rig1(droploc)
	else
		new rig2(droploc)
	*/
	new /obj/effect/decal/remains/human(droploc)
	new /obj/item/grenade/chem_grenade/miasma(droploc)
	/*Broken smoke spawn code. Above line is a bandaid.
	var/datum/reagents/R = new/datum/reagents(30)
	reagents.add_reagent(REAGENT_ID_MIASMA, 30)
	var/datum/effect_system/smoke_spread/chem/S = new /datum/effect_system/smoke_spread/chem
	S.attach(droploc)
	S.set_up(R, 30, 0, droploc)
	spawn(0)
		S.start()*/
	. = ..()

//What about if someone's in it? Well here you go.
/mob/living/simple_mob/humanoid/possessed/Login()
	to_chat(src,span_infoplain(span_bold("Why are you in this [src]? Why can't you say more than a few phrases? Why. What. Kill. Kill. Kill. Kill. KILL! KILL! KILL!") + " [player_msg]"))

/obj/item/rig/eva/old
	name = "old EVA suit control module"
	desc = "A light hardsuit for repairs and maintenance to the outside of habitats and vessels. It appears to be pretty old and worn down."

//Now let's make some more!
/mob/living/simple_mob/humanoid/possessed/industrial
	name = "old industrial RIG suit"
	desc = "A heavy, powerful hardsuit used by construction crews and mining corporations. Seems to be worn down and damaged. But it seems to still be moving. Is someone in it?"
	icon_state = "industrial-rig"
	loot_list = list(/obj/item/rig/industrial/old = 100)
	armor = list(melee = 60, bullet = 50, laser = 30,energy = 15, bomb = 30, bio = 100, rad = 100)

/obj/item/rig/industrial/old
	name = "old Industrial hardsuit"
	desc = "A heavy, powerful hardsuit used by construction crews and mining corporations. It appears to be pretty old and worn down."

/mob/living/simple_mob/humanoid/possessed/merc
	name = "old crimson hardsuit"
	desc = "A blood-red hardsuit featuring some fairly illegal technology. Seems to be worn down and damaged. But it seems to still be moving. Is someone in it?"
	icon_state = "merc-rig"
	loot_list = list(/obj/item/rig/merc/old = 100)
	armor = list(melee = 80, bullet = 65, laser = 50, energy = 15, bomb = 80, bio = 100, rad = 60)

/obj/item/rig/merc/old
	name = "old crimson hardsuit control module"
	desc = "A blood-red hardsuit featuring some fairly illegal technology. It appears to be pretty old and worn down."

/mob/living/simple_mob/humanoid/possessed/merc/feral	// Special one that moves faster attacks faster. Intended as a special mech pilot
	desc = "A blood-red hardsuit featuring some fairly illegal technology. Seems to be worn down and damaged but moving with surprising speed!"
	movement_cooldown 				= 3		//You can try running
	base_attack_cooldown 			= 3		//You will just die tired
	melee_miss_chance				= 25	//Not very coordinated though
