/* Toxins, poisons, venoms */

/datum/reagent/toxin
	name = REAGENT_TOXIN
	id = REAGENT_ID_TOXIN
	description = "A toxic chemical."
	taste_description = "bitterness"
	taste_mult = 1.2
	reagent_state = LIQUID
	color = "#CF3600"
	metabolism = REM * 0.25 // 0.05 by default. Hopefully enough to get some help, or die horribly, whatever floats your boat
	filtered_organs = list(O_LIVER, O_KIDNEYS)
	var/strength = 4 // How much damage it deals per unit
	var/skin_danger = 0.2 // The multiplier for how effective the toxin is when making skin contact.

/datum/reagent/toxin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	strength *= M.species.chem_strength_tox
	if(strength && alien != IS_DIONA)
		if(issmall(M)) removed *= 2 // Small bodymass, more effect from lower volume.
		if(alien == IS_SLIME)
			removed *= 0.25 // Results in half the standard tox as normal. Prometheans are 'Small' for flaps.
			if(dose >= 10)
				M.adjust_nutrition(strength * removed) // Body has to deal with the massive influx of toxins, rather than try using them to repair.
			else
				M.heal_organ_damage((10/strength) * removed, (10/strength) * removed) //Doses of toxins below 10 units, and 10 strength, are capable of providing useful compounds for repair.
		M.adjustToxLoss(strength * removed)

/datum/reagent/toxin/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	affect_blood(M, alien, removed * 0.2)

/datum/reagent/toxin/plasticide
	name = REAGENT_PLASTICIDE
	id = REAGENT_ID_PLASTICIDE
	description = "Liquid plastic, do not eat."
	taste_description = "plastic"
	reagent_state = LIQUID
	color = "#CF3600"
	strength = 5

/datum/reagent/toxin/amatoxin
	name = REAGENT_AMATOXIN
	id = REAGENT_ID_AMATOXIN
	description = "A powerful poison derived from certain species of mushroom."
	taste_description = "mushroom"
	reagent_state = LIQUID
	color = "#792300"
	strength = 10

/datum/reagent/toxin/amatoxin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	// Trojan horse. Waits until most of the toxin has gone through the body before dealing the bulk of it in one big strike.
	if(volume < max_dose * 0.2)
		M.adjustToxLoss(max_dose * strength * removed / (max_dose * 0.2))

/datum/reagent/toxin/carpotoxin
	name = REAGENT_CARPOTOXIN
	id = REAGENT_ID_CARPOTOXIN
	description = "A deadly neurotoxin produced by the dreaded space carp."
	taste_description = "fish"
	reagent_state = LIQUID
	color = "#003333"
	strength = 10

/datum/reagent/toxin/carpotoxin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.adjustBrainLoss(strength / 4 * removed)

/datum/reagent/toxin/neurotoxic_protein
	name = REAGENT_NEUROTOXIC_PROTEIN
	id = REAGENT_ID_NEUROTOXIC_PROTEIN
	description = "A weak neurotoxic chemical."
	taste_description = "fish"
	reagent_state = LIQUID
	color = "#005555"
	strength = 8
	skin_danger = 0.4

/datum/reagent/toxin/neurotoxic_protein/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_CHIMERA)
		return
	..()
	if(alien != IS_DIONA)
		if(M.canmove && !M.restrained() && istype(M.loc, /turf/space))
			step(M, pick(cardinal))
		if(prob(5))
			M.emote(pick("twitch", "drool", "moan"))
		if(prob(20))
			M.adjustBrainLoss(0.1)

//R-UST port
// Produced during deuterium synthesis. Super poisonous, SUPER flammable (doesn't need oxygen to burn).
/datum/reagent/toxin/hydrophoron
	name = REAGENT_HYDROPHORON
	id = REAGENT_ID_HYDROPHORON
	description = "An exceptionally flammable molecule formed from deuterium synthesis."
	strength = 80
	var/fire_mult = 30

/datum/reagent/toxin/hydrophoron/touch_mob(var/mob/living/L, var/amount)
	..()
	if(istype(L))
		L.adjust_fire_stacks(amount / fire_mult)

/datum/reagent/toxin/hydrophoron/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	M.take_organ_damage(0, removed * 0.1) //being splashed directly with hydrophoron causes minor chemical burns
	if(prob(10 * fire_mult))
		M.pl_effects()

/datum/reagent/toxin/hydrophoron/touch_turf(var/turf/simulated/T)
	if(!istype(T))
		return
	..()
	T.assume_gas(GAS_PHORON, CEILING(volume/2, 1), T20C)
	for(var/turf/simulated/floor/target_tile in range(0,T))
		target_tile.assume_gas(GAS_PHORON, volume/2, 400+T0C)
		spawn (0) target_tile.hotspot_expose(700, 400)
	remove_self(volume)

/datum/reagent/toxin/hydrophoron/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_SLIME)
		M.adjust_fire_stacks(removed * 10)
		if(prob(10))
			to_chat(M, span_critical("You feel something boiling within you!"))
			spawn(rand(30, 60))
				M.IgniteMob()

/datum/reagent/toxin/lead
	name = REAGENT_LEAD
	id = REAGENT_ID_LEAD
	description = "Elemental Lead."
	color = "#273956"
	strength = 4

/datum/reagent/toxin/spidertoxin
	name = REAGENT_SPIDERTOXIN
	id = REAGENT_ID_SPIDERTOXIN
	description = "A liquifying toxin produced by giant spiders."
	color = "#2CE893"
	strength = 5

/datum/reagent/toxin/phoron
	name = REAGEMT_PHORON
	id = REAGENT_ID_PHORON
	description = "Phoron in its liquid form."
	taste_mult = 1.5
	reagent_state = LIQUID
	color = "#9D14DB"
	strength = 30
	touch_met = 5
	skin_danger = 1

/datum/reagent/toxin/phoron/touch_mob(var/mob/living/L, var/amount)
	..()
	if(istype(L))
		L.adjust_fire_stacks(amount / 5)

/datum/reagent/toxin/phoron/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.adjust_fire_stacks(removed / 5)
	if(alien == IS_VOX)
		return
	M.take_organ_damage(0, removed * 0.1) //being splashed directly with phoron causes minor chemical burns
	if(prob(50))
		M.pl_effects()

/datum/reagent/toxin/phoron/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_VOX)
		M.adjustOxyLoss(-100 * removed) //5 oxyloss healed per tick.
		return //You're wasting plasma (a semi-limited chemical) to save someone, so it might as well be somewhat strong.
	if(alien == IS_SLIME)
		M.adjust_fire_stacks(removed * 3) //Not quite 'converting' it. It's like mixing fuel into a jelly. You get explosive, or at least combustible, jelly.
	..()

/datum/reagent/toxin/phoron/touch_turf(var/turf/simulated/T, var/amount)
	..()
	if(!istype(T))
		return
	T.assume_gas(GAS_VOLATILE_FUEL, amount, T20C)
	remove_self(amount)

/datum/reagent/toxin/cyanide //Fast and Lethal
	name = REAGENT_CYANIDE
	id = REAGENT_ID_CYANIDE
	description = "A highly toxic chemical."
	taste_description = "almond"
	taste_mult = 0.6
	reagent_state = LIQUID
	color = "#CF3600"
	strength = 20
	metabolism = REM * 2

/datum/reagent/toxin/cyanide/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.adjustOxyLoss(20 * removed)
	M.Sleeping(1)

/datum/reagent/toxin/mold
	name = REAGENT_MOLD
	id = REAGENT_ID_MOLD
	description = "A mold is a fungus that causes biodegradation of natural materials. This variant contains mycotoxins, and is dangerous to humans."
	taste_description = "mold"
	reagent_state = SOLID
	strength = 5

/datum/reagent/toxin/mold/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(prob(5))
		M.vomit()

/datum/reagent/toxin/expired_medicine
	name = REAGENT_EXPIREDMEDICINE
	id = REAGENT_ID_EXPIREDMEDICINE
	description = "Some form of liquid medicine that is well beyond its shelf date. Administering it now would cause illness."
	taste_description = "bitterness"
	reagent_state = LIQUID
	strength = 5
	filtered_organs = list(O_SPLEEN)

/datum/reagent/toxin/expired_medicine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(prob(5))
		M.vomit()

/datum/reagent/toxin/expired_medicine/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	affect_blood(M, alien, removed * 0.66)


/datum/reagent/toxin/stimm	//Homemade Hyperzine
	name = REAGENT_STIMM
	id = REAGENT_ID_STIMM
	description = "A homemade stimulant with some serious side-effects."
	taste_description = "sweetness"
	taste_mult = 1.8
	color = "#d0583a"
	metabolism = REM * 3
	overdose = 10
	overdose_mod = 0.5
	strength = 3

/datum/reagent/toxin/stimm/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_TAJARA)
		removed *= 1.25
	..()
	if(prob(15))
		M.emote(pick("twitch", "blink_r", "shiver"))
	if(prob(15))
		M.visible_message("[M] shudders violently.", "You shudder uncontrollably, it hurts.")
		M.take_organ_damage(6 * removed, 0)
	M.add_chemical_effect(CE_SPEEDBOOST, 1)

/datum/reagent/toxin/stimm/overdose(var/mob/living/carbon/M, var/alient, var/removed)
	..()
	if(prob(10)) // 1 in 10. This thing's made with welder fuel and fertilizer, what do you expect?
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/heart/ht = H.internal_organs_by_name[O_HEART]
		ht?.take_damage(1)
		to_chat(M, span_warning("Huh... Is this what a heart attack feels like?"))

/datum/reagent/toxin/potassium_chloride
	name = REAGENT_POTASSIUMCHLORIDE
	id = REAGENT_ID_POTASSIUMCHLORIDE
	description = "A delicious salt that stops the heart when injected into cardiac muscle."
	taste_description = "salt"
	reagent_state = SOLID
	color = "#FFFFFF"
	strength = 0
	overdose = REAGENTS_OVERDOSE
	filtered_organs = list(O_SPLEEN, O_KIDNEYS)

/datum/reagent/toxin/potassium_chloride/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_SLIME)
		M.adjustFireLoss(removed * 2)

/datum/reagent/toxin/potassium_chloride/overdose(var/mob/living/carbon/M, var/alien)
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.stat != 1)
			if(H.losebreath >= 10)
				H.losebreath = max(10, H.losebreath - 10)
			H.adjustOxyLoss(2)
			H.Weaken(10)

/datum/reagent/toxin/potassium_chlorophoride
	name = REAGENT_POTASSIUMCHLOROPHORIDE
	id = REAGENT_ID_POTASSIUMCHLOROPHORIDE
	description = "A specific chemical based on Potassium Chloride to stop the heart for surgery. Not safe to eat!"
	taste_description = "salt"
	reagent_state = SOLID
	color = "#FFFFFF"
	strength = 10
	overdose = 20
	filtered_organs = list(O_SPLEEN, O_KIDNEYS)

/datum/reagent/toxin/potassium_chlorophoride/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.stat != 1)
			if(H.losebreath >= 10)
				H.losebreath = max(10, M.losebreath-10)
			H.adjustOxyLoss(2)
			H.Weaken(10)
	if(alien == IS_SLIME)
		M.adjustFireLoss(removed * 3)

/datum/reagent/toxin/zombiepowder
	name = REAGENT_ZOMBIEPOWDER
	id = REAGENT_ID_ZOMBIEPOWDER
	description = "A strong neurotoxin that puts the subject into a death-like state."
	taste_description = "numbness"
	reagent_state = SOLID
	color = "#669900"
	metabolism = REM
	strength = 3
	mrate_static = TRUE

/datum/reagent/toxin/zombiepowder/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	M.status_flags |= FAKEDEATH
	M.adjustOxyLoss(3 * removed)
	M.Weaken(10)
	M.silent = max(M.silent, 10)
	M.tod = stationtime2text()

/datum/reagent/toxin/zombiepowder/Destroy()
	if(holder && holder.my_atom && ismob(holder.my_atom))
		var/mob/M = holder.my_atom
		M.status_flags &= ~FAKEDEATH
	return ..()

/datum/reagent/toxin/lichpowder
	name = REAGENT_LICHPOWDER
	id = REAGENT_ID_LICHPOWDER
	description = "A stablized nerve agent that puts the subject into a strange state of un-death."
	reagent_state = SOLID
	color = "#666666"
	metabolism = REM * 0.75
	strength = 2
	mrate_static = TRUE

/datum/reagent/toxin/lichpowder/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	M.status_flags |= FAKEDEATH
	M.adjustOxyLoss(1 * removed)
	M.silent = max(M.silent, 10)
	M.tod = stationtime2text()

	if(prob(1))
		M.visible_message("[M] wheezes.", "You wheeze sharply... it's cold.")
		M.bodytemperature = max(M.bodytemperature - 10 * TEMPERATURE_DAMAGE_COEFFICIENT, T0C - 10)

/datum/reagent/toxin/lichpowder/Destroy()
	if(holder && holder.my_atom && ismob(holder.my_atom))
		var/mob/M = holder.my_atom
		M.status_flags &= ~FAKEDEATH
	return ..()

/datum/reagent/toxin/fertilizer //Reagents used for plant fertilizers.
	name = REAGENT_FERTILIZER
	id = REAGENT_ID_FERTILIZER
	description = "A chemical mix good for growing plants with."
	taste_description = "plant food"
	taste_mult = 0.5
	reagent_state = LIQUID
	strength = 0.5 // It's not THAT poisonous.
	color = "#664330"

/datum/reagent/toxin/fertilizer/eznutrient
	name = REAGENT_EZNUTRIENT
	id = REAGENT_ID_EZNUTRIENT

/datum/reagent/toxin/fertilizer/left4zed
	name = REAGENT_LEFT4ZED
	id = REAGENT_ID_LEFT4ZED

/datum/reagent/toxin/fertilizer/robustharvest
	name = REAGENT_ROBUSTHARVEST
	id = REAGENT_ID_ROBUSTHARVEST

/datum/reagent/toxin/fertilizer/tannin
	name = REAGENT_TANNIN
	id = REAGENT_ID_TANNIN
	description = "A chemical found in some plants as a natural pesticide. It may also aid in regulating growth."
	taste_description = "puckering"
	taste_mult = 1.2
	reagent_state = LIQUID
	strength = 1.5
	color = "#e67819"

/datum/reagent/toxin/fertilizer/tannin/touch_obj(var/obj/O, var/volume)
	..()
	if(istype(O, /obj/item/stack/hairlesshide))
		var/obj/item/stack/hairlesshide/HH = O
		HH.rapidcure(round(volume))
	..()

/datum/reagent/toxin/plantbgone
	name = REAGENT_PLANTBGONE
	id = REAGENT_ID_PLANTBGONE
	description = "A harmful toxic mixture to kill plantlife. Do not ingest!"
	taste_mult = 1
	reagent_state = LIQUID
	color = "#49002E"
	strength = 4

/datum/reagent/toxin/plantbgone/touch_turf(var/turf/T)
	..()
	if(istype(T, /turf/simulated/wall))
		var/turf/simulated/wall/W = T
		if(locate(/obj/effect/overlay/wallrot) in W)
			for(var/obj/effect/overlay/wallrot/E in W)
				qdel(E)
			W.visible_message(span_notice("The fungi are completely dissolved by the solution!"))

/datum/reagent/toxin/plantbgone/touch_obj(var/obj/O, var/volume)
	..()
	if(istype(O, /obj/effect/plant))
		qdel(O)
	else if(istype(O, /obj/effect/alien/weeds/))
		var/obj/effect/alien/weeds/alien_weeds = O
		alien_weeds.health -= rand(15, 35)
		alien_weeds.healthcheck()

/datum/reagent/toxin/plantbgone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		M.adjustToxLoss(50 * removed)

/datum/reagent/toxin/plantbgone/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		M.adjustToxLoss(50 * removed)

/datum/reagent/toxin/sifslurry
	name = REAGENT_SIFSAP
	id = REAGENT_ID_SIFSAP
	description = "A natural slurry comprised of fluorescent bacteria native to Sif, in the Vir system."
	taste_description = "sour"
	reagent_state = LIQUID
	color = "#C6E2FF"
	strength = 2
	overdose = 20

/datum/reagent/toxin/sifslurry/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA) // Symbiotic bacteria.
		M.adjust_nutrition(strength * removed)
		return
	else
		M.add_modifier(/datum/modifier/slow_pulse, 30 SECONDS)
	..()

/datum/reagent/toxin/sifslurry/overdose(var/mob/living/carbon/M, var/alien, var/removed) // Overdose effect.
	if(alien == IS_DIONA)
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		overdose_mod *= H.species.chemOD_mod
	M.apply_effect(2 * removed,IRRADIATE, 0, 0)
	M.apply_effect(5 * removed,DROWSY, 0, 0)

/datum/reagent/toxin/sifslurry/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	affect_blood(M, alien, removed * 0.7)

/datum/reagent/acid/polyacid
	name = REAGENT_PACID
	id = REAGENT_ID_PACID
	description = "Polytrinic acid is a an extremely corrosive chemical substance."
	taste_description = "acid"
	reagent_state = LIQUID
	color = "#8E18A9"
	power = 10
	meltdose = 4

/datum/reagent/acid/digestive
	name = REAGENT_STOMACID
	id = REAGENT_ID_STOMACID
	description = "Some form of digestive slurry."
	taste_description = "vomit"
	reagent_state = LIQUID
	color = "#664330"
	power = 2
	meltdose = 30

/datum/reagent/thermite/venom
	name = REAGENT_THERMITEV
	id = REAGENT_ID_THERMITEV
	description = "A biologically produced compound capable of melting steel or other metals, similarly to thermite."
	taste_description = "sweet chalk"
	reagent_state = SOLID
	color = "#673910"
	touch_met = 50

/datum/reagent/thermite/venom/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustFireLoss(3 * removed)
	if(M.fire_stacks <= 1.5)
		M.adjust_fire_stacks(0.15)
	if(alien == IS_DIONA)
		return
	if(prob(10))
		to_chat(M, span_warning("Your veins feel like they're on fire!"))
		M.adjust_fire_stacks(0.1)
	else if(prob(5))
		M.IgniteMob()
		to_chat(M, span_critical("Some of your veins rupture, the exposed blood igniting!"))

/datum/reagent/condensedcapsaicin/venom
	name = REAGENT_CONDENSEDCAPSAICINV
	id = REAGENT_ID_CONDENSEDCAPSAICINV
	description = "A biological agent that acts similarly to pepperspray. This compound seems to be particularly cruel, however, capable of permeating the barriers of blood vessels."
	taste_description = "fire"
	color = "#B31008"
	filtered_organs = list(O_SPLEEN)

/datum/reagent/condensedcapsaicin/venom/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(prob(50))
		M.adjustToxLoss(0.5 * removed)
	if(prob(50))
		M.apply_effect(4, AGONY, 0)
		if(prob(20))
			to_chat(M, span_danger("You feel like your insides are burning!"))
		else if(prob(20))
			M.visible_message(span_warning("[M] [pick("dry heaves!","coughs!","splutters!","rubs at their eyes!")]"))
	else
		M.eye_blurry = max(M.eye_blurry, 10)

/datum/reagent/lexorin
	name = REAGENT_LEXORIN
	id = REAGENT_ID_LEXORIN
	description = "Lexorin temporarily stops respiration. Causes tissue damage."
	taste_description = "acid"
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose = REAGENTS_OVERDOSE

/datum/reagent/lexorin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(alien == IS_SLIME)
		M.apply_effect(5, AGONY, 0)
		M.adjustToxLoss(3 * removed)
		if(prob(10))
			to_chat(M, span_warning("Your cellular mass hardens for a moment."))
			M.Stun(6)
		return
	if(alien == IS_SKRELL)
		M.take_organ_damage(2.4 * removed, 0)
		if(M.losebreath < 10)
			M.AdjustLosebreath(1)
	else
		M.take_organ_damage(3 * removed, 0)
		if(M.losebreath < 15)
			M.AdjustLosebreath(1)

/datum/reagent/mutagen
	name = REAGENT_MUTAGEN
	id = REAGENT_ID_MUTAGEN
	description = "Might cause unpredictable mutations. Keep away from children."
	taste_description = "slime"
	taste_mult = 0.9
	reagent_state = LIQUID
	color = "#13BC5E"

/datum/reagent/mutagen/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	if(prob(33))
		affect_blood(M, alien, removed)

/datum/reagent/mutagen/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(prob(67))
		affect_blood(M, alien, removed)

/datum/reagent/mutagen/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)

	if(M.isSynthetic())
		return

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(alien == IS_SLIME && prob(25))
			var/color_shift = rand(-100, 100)
			spawn(1)
				if(prob(33))
					if(H.r_skin)
						H.r_skin = max(0, min(255, H.r_skin + color_shift))
					if(H.r_hair)
						H.r_hair = max(0, min(255, H.r_hair + color_shift))
					if(H.r_facial)
						H.r_facial = max(0, min(255, H.r_facial + color_shift))
				if(prob(33))
					if(H.g_skin)
						H.g_skin = max(0, min(255, H.g_skin + color_shift))
					if(H.g_hair)
						H.g_hair = max(0, min(255, H.g_hair + color_shift))
					if(H.g_facial)
						H.g_facial = max(0, min(255, H.g_facial + color_shift))
				if(prob(33))
					if(H.b_skin)
						H.b_skin = max(0, min(255, H.b_skin + color_shift))
					if(H.b_hair)
						H.b_hair = max(0, min(255, H.b_hair + color_shift))
					if(H.b_facial)
						H.b_facial = max(0, min(255, H.b_facial + color_shift))
		if(H.species.flags & NO_SCAN)
			return

//The original coder comment here wanted it to be "Approx. one mutation per 10 injected/20 ingested/30 touching units"
//The issue was, it was removed (.2) multiplied by .1, which resulted in a .02% chance per tick to have a mutation occur. Or more accurately, 5000 injected for a single mutation.
//To honor their original idea, let's keep it as 10/20/30 as they wanted... For the most part.

	if(M.dna)
		if(prob(removed * 10)) // Removed is .2 per tick. Multiplying it by 10 makes it a 2% chance per tick. 10 units has 50 ticks, so 10 units injected should give a single good/bad mutation.
			randmuti(M)
			if(prob(98))
				randmutb(M)
			else
				randmutg(M)
			domutcheck(M, null)
			M.UpdateAppearance()
		if(prob(removed * 40)) //Additionally, let's make it so there's an 8% chance per tick for a random cosmetic/not guranteed good/bad mutation.
			randmuti(M)//This should equate to 4 random cosmetic mutations per 10 injected/20 ingested/30 touching units
			to_chat(M, span_warning("You feel odd!"))
	M.apply_effect(10 * removed, IRRADIATE, 0)

/datum/reagent/slimejelly
	name = REAGENT_SLIMEJELLY
	id = REAGENT_ID_SLIMEJELLY
	description = "A gooey semi-liquid produced from one of the deadliest lifeforms in existence. SO REAL."
	taste_description = "slime"
	taste_mult = 1.3
	reagent_state = LIQUID
	color = "#801E28"

/datum/reagent/slimejelly/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(alien == IS_SLIME) //Partially made of the stuff. Why would it hurt them?
		if(prob(75))
			M.heal_overall_damage(25 * removed, 25 * removed)
			M.adjustToxLoss(rand(-30, -10) * removed)
			M.druggy = max(M.druggy, 10)
			M.add_chemical_effect(CE_PAINKILLER, 60)
	else
		if(prob(10))
			to_chat(M, span_danger("Your insides are burning!"))
			M.adjustToxLoss(rand(100, 300) * removed)
		else if(prob(40))
			M.heal_organ_damage(25 * removed, 0)

/datum/reagent/soporific
	name = REAGENT_STOXIN
	id = REAGENT_ID_STOXIN
	description = "An effective hypnotic used to treat insomnia."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#009CA8"
	metabolism = REM * 0.5
	ingest_met = REM * 1.5
	overdose = REAGENTS_OVERDOSE

/datum/reagent/soporific/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return

	var/threshold = 1 * M.species.chem_strength_tox
	if(alien == IS_SKRELL)
		threshold = 1.2

	if(alien == IS_SLIME)
		threshold = 6	//Evens to 3 due to the fact they are considered 'small' for flaps.

	var/effective_dose = dose
	if(issmall(M))
		effective_dose *= 2

	if(effective_dose < 1 * threshold)
		if(effective_dose == metabolism * 2 || prob(5))
			M.emote("yawn")
	else if(effective_dose < 1.5 * threshold)
		M.eye_blurry = max(M.eye_blurry, 10)
	else if(effective_dose < 5 * threshold)
		if(prob(50))
			M.Weaken(2)
		M.drowsyness = max(M.drowsyness, 20)
	else
		if(alien == IS_SLIME) //They don't have eyes, and they don't really 'sleep'. Fumble their general senses.
			M.eye_blurry = max(M.eye_blurry, 30)
			if(prob(20))
				M.ear_deaf = max(M.ear_deaf, 4)
				M.Confuse(2)
			else
				M.Weaken(2)
		else
			M.Sleeping(20)
		M.drowsyness = max(M.drowsyness, 60)

/datum/reagent/chloralhydrate
	name = REAGENT_CHLORALHYDRATE
	id = REAGENT_ID_CHLORALHYDRATE
	description = "A powerful sedative."
	taste_description = "bitterness"
	reagent_state = SOLID
	color = "#000067"
	metabolism = REM * 0.5
	ingest_met = REM * 1.5
	overdose = REAGENTS_OVERDOSE * 0.5
	overdose_mod = 2	//For that good, lethal feeling // Reduced with overdose changes. Slightly stronger than before

/datum/reagent/chloralhydrate/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return

	var/threshold = 1 * M.species.chem_strength_tox
	if(alien == IS_SKRELL)
		threshold = 1.2

	if(alien == IS_SLIME)
		threshold = 6	//Evens to 3 due to the fact they are considered 'small' for flaps.

	var/effective_dose = dose
	if(issmall(M))
		effective_dose *= 2

	if(effective_dose == metabolism)
		M.Confuse(2)
		M.drowsyness += 2
	else if(effective_dose < 2 * threshold)
		M.Weaken(30)
		M.eye_blurry = max(M.eye_blurry, 10)
	else
		if(alien == IS_SLIME)
			if(prob(30))
				M.ear_deaf = max(M.ear_deaf, 4)
			M.eye_blurry = max(M.eye_blurry, 60)
			M.Weaken(30)
			M.Confuse(40)
		else
			M.Sleeping(30)

	if(effective_dose > 1 * threshold)
		M.adjustToxLoss(removed)

/datum/reagent/chloralhydrate/overdose(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.SetLosebreath(10)
	M.adjustOxyLoss(removed * overdose_mod)

/datum/reagent/chloralhydrate/beer2 //disguised as normal beer for use by emagged brobots
	name = REAGENT_BEER2
	id = REAGENT_ID_BEER2
	description = "An alcoholic beverage made from malted grains, hops, yeast, and water. The fermentation appears to be incomplete." //If the players manage to analyze this, they deserve to know something is wrong.
	taste_description = "beer"
	reagent_state = LIQUID
	color = "#FFD300"

	glass_name = REAGENT_ID_BEER
	glass_desc = "A freezing pint of beer"

/* Drugs */

/datum/reagent/serotrotium
	name = REAGENT_SEROTROTIUM
	id = REAGENT_ID_SEROTROTIUM
	description = "A chemical compound that promotes concentrated production of the serotonin neurotransmitter in humans."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#202040"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE

/datum/reagent/serotrotium/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(prob(7))
		M.emote(pick("twitch", "drool", "moan", "gasp"))
	return

/datum/reagent/serotrotium/venom
	name = REAGENT_SEROTROTIUMV
	id = REAGENT_ID_SEROTROTIUMV
	description = "A chemical compound that promotes concentrated production of the serotonin neurotransmitter in humans. This appears to be a biologically produced form, resulting in a specifically toxic nature."
	taste_description = "chalky bitterness"
	filtered_organs = list(O_SPLEEN)

/datum/reagent/serotrotium/venom/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(prob(30))
		if(prob(25))
			M.emote(pick("shiver", "blink_r"))
		M.adjustBrainLoss(0.2 * removed)
	return ..()

/datum/reagent/cryptobiolin
	name = REAGENT_CRYPTOBIOLIN
	id = REAGENT_ID_CRYPTOBIOLIN
	description = "Cryptobiolin causes confusion and dizzyness."
	taste_description = "sourness"
	reagent_state = LIQUID
	color = "#000055"
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE

/datum/reagent/cryptobiolin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	var/drug_strength = 4 * M.species.chem_strength_tox

	if(alien == IS_SKRELL)
		drug_strength = drug_strength * 0.8

	if(alien == IS_SLIME)
		drug_strength = drug_strength * 1.2

	M.make_dizzy(drug_strength)
	M.Confuse(drug_strength * 5)

/datum/reagent/impedrezene
	name = REAGENT_IMPEDREZENE
	id = REAGENT_ID_IMPEDREZENE
	description = "Impedrezene is a narcotic that impedes one's ability by slowing down the higher brain cell functions."
	taste_description = "numbness"
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose = REAGENTS_OVERDOSE
	filtered_organs = list(O_SPLEEN)

/datum/reagent/impedrezene/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.jitteriness = max(M.jitteriness - 5, 0)
	if(prob(80))
		M.adjustBrainLoss(0.1 * removed)
	if(prob(50))
		M.drowsyness = max(M.drowsyness, 3)
	if(prob(10))
		M.emote("drool")

/datum/reagent/mindbreaker
	name = REAGENT_MINDBREAKER
	id = REAGENT_ID_MINDBREAKER
	description = "A powerful hallucinogen, it can cause fatal effects in users."
	taste_description = "sourness"
	reagent_state = LIQUID
	color = "#B31008"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE

/datum/reagent/mindbreaker/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return

	var/drug_strength = 100 * M.species.chem_strength_tox

	if(alien == IS_SKRELL)
		drug_strength *= 0.8

	if(alien == IS_SLIME)
		drug_strength *= 1.2

	M.hallucination = max(M.hallucination, drug_strength)

/* Transformations */

/datum/reagent/slimetoxin
	name = REAGENT_MUTATIONTOXIN
	id = REAGENT_ID_MUTATIONTOXIN
	description = "A corruptive toxin produced by slimes."
	taste_description = "sludge"
	reagent_state = LIQUID
	color = "#13BC5E"

/datum/reagent/slimetoxin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.isSynthetic())
		return

	var/mob/living/carbon/human/H = M
	if(istype(H) && (H.species.flags & NO_SCAN))
		return

	if(M.dna)
		if(prob(removed * 10))
			randmuti(M)
			if(prob(98))
				randmutb(M)
			else
				randmutg(M)
			domutcheck(M, null)
			M.UpdateAppearance()
		if(prob(removed * 40))
			randmuti(M)
			to_chat(M, span_warning("You feel odd!"))
	M.apply_effect(16 * removed, IRRADIATE, 0)

/datum/reagent/aslimetoxin
	name = REAGENT_DOCILITYTOXIN
	id = REAGENT_ID_DOCILITYTOXIN
	description = "A corruptive toxin produced by slimes."
	taste_description = "sludge"
	reagent_state = LIQUID
	color = "#FF69B4"

/datum/reagent/aslimetoxin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed) // TODO: check if there's similar code anywhere else
	if(M.isSynthetic())
		return

	var/mob/living/carbon/human/H = M
	if(istype(H) && (H.species.flags & NO_SCAN))
		return

	if(M.dna)
		if(prob(removed * 10))
			randmuti(M)
			if(prob(98))
				randmutb(M)
			else
				randmutg(M)
			domutcheck(M, null)
			M.UpdateAppearance()
		if(prob(removed * 40))
			randmuti(M)
			to_chat(M, span_warning("You feel odd!"))
	M.apply_effect(6 * removed, IRRADIATE, 0)

/*
 * Hostile nanomachines.
 * Unscannable, and commonly all look the same.
 */

/datum/reagent/shredding_nanites
	name = REAGENT_SHREDDINGNANITES
	id = REAGENT_ID_SHREDDINGNANITES
	description = "Miniature medical robots that swiftly restore bodily damage. These ones seem to be malfunctioning."
	taste_description = "metal"
	reagent_state = SOLID
	color = "#555555"
	metabolism = REM * 4 // Nanomachines. Fast.
	affects_robots = TRUE

/datum/reagent/shredding_nanites/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustBruteLoss(4 * removed)
	M.adjustOxyLoss(4 * removed)

/datum/reagent/irradiated_nanites
	name = REAGENT_IRRADIATEDNANITES
	id = REAGENT_ID_IRRADIATEDNANITES
	description = "Miniature medical robots that swiftly restore bodily damage. These ones seem to be malfunctioning."
	taste_description = "metal"
	reagent_state = SOLID
	color = "#555555"
	metabolism = REM * 4
	affects_robots = TRUE

/datum/reagent/irradiated_nanites/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	SSradiation.radiate(get_turf(M), 20)	// Irradiate people around you.
	M.radiation = max(M.radiation + 5 * removed, 0)	// Irradiate you. Because it's inside you.

/datum/reagent/neurophage_nanites
	name = REAGENT_NEUROPHAGENANITES
	id = REAGENT_ID_NEUROPHAGENANITES
	description = "Miniature medical robots that swiftly restore bodily damage. These ones seem to be completely hostile."
	taste_description = "metal"
	reagent_state = SOLID
	color = "#555555"
	metabolism = REM * 4
	filtered_organs = list(O_SPLEEN)
	affects_robots = TRUE

/datum/reagent/neurophage_nanites/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustBrainLoss(2 * removed)	// Their job is to give you a bad time.
	M.adjustBruteLoss(2 * removed)

/datum/reagent/salmonella
	name = REAGENT_SALMONELLA
	id = REAGENT_ID_SALMONELLA
	description = "A nasty bacteria found in spoiled food."
	reagent_state = LIQUID
	color = "#1E4600"
	taste_mult = 0

/datum/reagent/salmonella/on_mob_life(mob/living/carbon/M)
	M.ForceContractDisease(new /datum/disease/food_poisoning(0))
	return ..()
