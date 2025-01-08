/* Paint and crayons */

/datum/reagent/crayon_dust
	name = REAGENT_CRAYONDUST
	id = REAGENT_ID_CRAYONDUST
	description = "Intensely coloured powder obtained by grinding crayons."
	taste_description = "powdered wax"
	reagent_state = LIQUID
	color = "#888888"
	overdose = 5

/datum/reagent/crayon_dust/red
	name = REAGENT_CRAYONDUSTRED
	id = REAGENT_ID_CRAYONDUSTRED
	color = "#FE191A"

/datum/reagent/crayon_dust/orange
	name = REAGENT_CRAYONDUSTORANGE
	id = REAGENT_ID_CRAYONDUSTORANGE
	color = "#FFBE4F"

/datum/reagent/crayon_dust/yellow
	name = REAGENT_CRAYONDUSTYELLOW
	id = REAGENT_ID_CRAYONDUSTYELLOW
	color = "#FDFE7D"

/datum/reagent/crayon_dust/green
	name = REAGENT_CRAYONDUSTGREEN
	id = REAGENT_ID_CRAYONDUSTGREEN
	color = "#18A31A"

/datum/reagent/crayon_dust/blue
	name = REAGENT_CRAYONDUSTBLUE
	id = REAGENT_ID_CRAYONDUSTBLUE
	color = "#247CFF"

/datum/reagent/crayon_dust/purple
	name = REAGENT_CRAYONDUSTPURPLE
	id = REAGENT_ID_CRAYONDUSTPURPLE
	color = "#CC0099"

/datum/reagent/crayon_dust/grey //Mime
	name = REAGENT_CRAYONDUSTGREY
	id = REAGENT_ID_CRAYONDUSTGREY
	color = "#808080"

/datum/reagent/crayon_dust/brown //Rainbow
	name = REAGENT_CRAYONDUSTBROWN
	id = REAGENT_ID_CRAYONDUSTBROWN
	color = "#846F35"

/datum/reagent/marker_ink
	name = REAGENT_MARKERINK
	id = REAGENT_ID_MARKERINK
	description = "Intensely coloured ink used in markers."
	taste_description = "extremely bitter"
	reagent_state = LIQUID
	color = "#888888"
	overdose = 5

/datum/reagent/marker_ink/black
	name = REAGENT_MARKERINKBLACK
	id = REAGENT_ID_MARKERINKBLACK
	color = "#000000"

/datum/reagent/marker_ink/red
	name = REAGENT_MARKERINKRED
	id = REAGENT_ID_MARKERINKRED
	color = "#FE191A"

/datum/reagent/marker_ink/orange
	name = REAGENT_MARKERINKORANGE
	id = REAGENT_ID_MARKERINKORANGE
	color = "#FFBE4F"

/datum/reagent/marker_ink/yellow
	name = REAGENT_MARKERINKYELLOW
	id = REAGENT_ID_MARKERINKYELLOW
	color = "#FDFE7D"

/datum/reagent/marker_ink/green
	name = REAGENT_MARKERINKGREEN
	id = REAGENT_ID_MARKERINKGREEN
	color = "#18A31A"

/datum/reagent/marker_ink/blue
	name = REAGENT_MARKERINKBLUE
	id = REAGENT_ID_MARKERINKBLUE
	color = "#247CFF"

/datum/reagent/marker_ink/purple
	name = REAGENT_MARKERINKPURPLE
	id = REAGENT_ID_MARKERINKPURPLE
	color = "#CC0099"

/datum/reagent/marker_ink/grey //Mime
	name = REAGENT_MARKERINKGREY
	id = REAGENT_ID_MARKERINKGREY
	color = "#808080"

/datum/reagent/marker_ink/brown //Rainbow
	name = REAGENT_MARKERINKBROWN
	id = REAGENT_ID_MARKERINKBROWN
	color = "#846F35"

/datum/reagent/paint
	name = REAGENT_PAINT
	id = REAGENT_ID_PAINT
	description = "This paint will stick to almost any object."
	taste_description = "chalk"
	reagent_state = LIQUID
	color = "#808080"
	overdose = REAGENTS_OVERDOSE * 0.5
	color_weight = 20

/datum/reagent/paint/touch_turf(var/turf/T)
	..()
	if(istype(T) && !istype(T, /turf/space))
		T.color = color

/datum/reagent/paint/touch_obj(var/obj/O)
	..()
	if(istype(O))
		O.color = color

/datum/reagent/paint/touch_mob(var/mob/M)
	..()
	if(istype(M) && !istype(M, /mob/observer)) //painting ghosts: not allowed
		M.color = color //maybe someday change this to paint only clothes and exposed body parts for human mobs.

/datum/reagent/paint/get_data()
	return color

/datum/reagent/paint/initialize_data(var/newdata)
	color = newdata
	return

/datum/reagent/paint/mix_data(var/newdata, var/newamount)
	var/list/colors = list(0, 0, 0, 0)
	var/tot_w = 0

	var/hex1 = uppertext(color)
	var/hex2 = uppertext(newdata)
	if(length(hex1) == 7)
		hex1 += "FF"
	if(length(hex2) == 7)
		hex2 += "FF"
	if(length(hex1) != 9 || length(hex2) != 9)
		return
	colors[1] += hex2num(copytext(hex1, 2, 4)) * volume
	colors[2] += hex2num(copytext(hex1, 4, 6)) * volume
	colors[3] += hex2num(copytext(hex1, 6, 8)) * volume
	colors[4] += hex2num(copytext(hex1, 8, 10)) * volume
	tot_w += volume
	colors[1] += hex2num(copytext(hex2, 2, 4)) * newamount
	colors[2] += hex2num(copytext(hex2, 4, 6)) * newamount
	colors[3] += hex2num(copytext(hex2, 6, 8)) * newamount
	colors[4] += hex2num(copytext(hex2, 8, 10)) * newamount
	tot_w += newamount

	color = rgb(colors[1] / tot_w, colors[2] / tot_w, colors[3] / tot_w, colors[4] / tot_w)
	return

/* Things that didn't fit anywhere else */

/datum/reagent/adminordrazine //An OP chemical for admins
	name = REAGENT_ADMINORDRAZINE
	id = REAGENT_ID_ADMINORDRAZINE
	description = "It's magic. We don't have to explain it."
	taste_description = "bwoink"
	reagent_state = LIQUID
	color = "#C8A5DC"
	affects_dead = TRUE //This can even heal dead people.
	metabolism = 0.1
	mrate_static = TRUE //Just in case

	glass_name = "liquid gold"
	glass_desc = "It's magic. We don't have to explain it."

/datum/reagent/adminordrazine/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	affect_blood(M, alien, removed)

/datum/reagent/adminordrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.heal_organ_damage(40,40)
	M.adjustCloneLoss(-40)
	M.adjustToxLoss(-40)
	M.adjustOxyLoss(-300)
	M.hallucination = 0
	M.setBrainLoss(0)
	M.disabilities = 0
	M.sdisabilities = 0
	M.eye_blurry = 0
	M.SetBlinded(0)
	M.SetWeakened(0)
	M.SetStunned(0)
	M.SetParalysis(0)
	M.silent = 0
	M.dizziness = 0
	M.drowsyness = 0
	M.stuttering = 0
	M.SetConfused(0)
	M.SetSleeping(0)
	M.jitteriness = 0
	M.radiation = 0
	M.ExtinguishMob()
	M.fire_stacks = 0
	M.add_chemical_effect(CE_ANTIBIOTIC, ANTIBIO_SUPER)
	M.add_chemical_effect(CE_STABLE, 15)
	M.add_chemical_effect(CE_PAINKILLER, 200)
	M.remove_a_modifier_of_type(/datum/modifier/poisoned)
	if(M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (40 * TEMPERATURE_DAMAGE_COEFFICIENT))
	else if(M.bodytemperature < 311)
		M.bodytemperature = min(310, M.bodytemperature + (40 * TEMPERATURE_DAMAGE_COEFFICIENT))
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/wound_heal = 5
		for(var/obj/item/organ/I in H.internal_organs)
			if(I.damage > 0) //Adminordrazine heals even robits, it is magic
				I.damage = max(I.damage - wound_heal, 0)
		for(var/obj/item/organ/external/O in H.bad_external_organs)
			if(O.status & ORGAN_BROKEN)
				O.mend_fracture()		//Only works if the bone won't rebreak, as usual
			for(var/datum/wound/W in O.wounds)
				if(W.bleeding())
					W.damage = max(W.damage - wound_heal, 0)
					if(W.damage <= 0)
						O.wounds -= W
				if(W.internal)
					W.damage = max(W.damage - wound_heal, 0)
					if(W.damage <= 0)
						O.wounds -= W

/datum/reagent/gold
	name = REAGENT_GOLD
	id = REAGENT_ID_GOLD
	description = "Gold is a dense, soft, shiny metal and the most malleable and ductile metal known."
	taste_description = "metal"
	reagent_state = SOLID
	color = "#F7C430"

/datum/reagent/silver
	name = REAGENT_SILVER
	id = REAGENT_ID_SILVER
	description = "A soft, white, lustrous transition metal, it has the highest electrical conductivity of any element and the highest thermal conductivity of any metal."
	taste_description = "metal"
	reagent_state = SOLID
	color = "#D0D0D0"

/datum/reagent/platinum
	name = REAGENT_PLATINUM
	id = REAGENT_ID_PLATINUM
	description = "Platinum is a dense, malleable, ductile, highly unreactive, precious, gray-white transition metal.  It is very resistant to corrosion."
	taste_description = "metal"
	reagent_state = SOLID
	color = "#777777"

/datum/reagent/uranium
	name = REAGENT_URANIUM
	id = REAGENT_ID_URANIUM
	description = "A silvery-white metallic chemical element in the actinide series, weakly radioactive."
	taste_description = "metal"
	reagent_state = SOLID
	color = "#B8B8C0"

/datum/reagent/uranium/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	affect_ingest(M, alien, removed)

/datum/reagent/uranium/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.apply_effect(5 * removed, IRRADIATE, 0)

/datum/reagent/uranium/touch_turf(var/turf/T)
	..()
	if(volume >= 3)
		if(!istype(T, /turf/space))
			var/obj/effect/decal/cleanable/greenglow/glow = locate(/obj/effect/decal/cleanable/greenglow, T)
			if(!glow)
				new /obj/effect/decal/cleanable/greenglow(T)
			return

/datum/reagent/hydrogen/deuterium
	name = REAGENT_DEUTERIUM
	id = REAGENT_ID_DEUTERIUM
	description = "A isotope of hydrogen. It has one extra neutron, and shares all chemical characteristics with hydrogen."

/datum/reagent/hydrogen/tritium
	name = REAGENT_TRITIUM
	id = REAGENT_ID_SLIMEJELLY
	description = "A radioactive isotope of hydrogen. It has two extra neutrons, and shares all other chemical characteristics with hydrogen."

/datum/reagent/lithium/lithium6
	name = REAGENT_LITHIUM6
	id = REAGENT_ID_LITHIUM6
	description = "An isotope of lithium. It has 3 neutrons, but shares all chemical characteristics with regular lithium."

/datum/reagent/helium/helium3
	name = REAGENT_HELIUM3
	id = REAGENT_ID_HELIUM3
	description = "An isotope of helium. It only has one neutron, but shares all chemical characteristics with regular helium."
	taste_mult = 0
	reagent_state = GAS
	color = "#808080"

/datum/reagent/boron/boron11
	name = REAGENT_BORON11
	id = REAGENT_ID_BORON11
	description = "An isotope of boron. It has 6 neutrons."
	taste_description = "metallic" // Apparently noone on the internet knows what boron tastes like. Or at least they won't share

/datum/reagent/supermatter
	name = REAGENT_SUPERMATTER
	id = REAGENT_ID_SUPERMATTER
	color = "#fffd6b"
	reagent_state = SOLID
	affects_dead = TRUE
	affects_robots = TRUE
	description = "The immense power of a supermatter crystal, in liquid form. You're not entirely sure how that's possible, but it's probably best handled with care."
	taste_description = "taffy" // 0. The supermatter is tasty, tasty taffy.

// Same as if you boop it wrong. It touches you, you die
/datum/reagent/supermatter/affect_touch(mob/living/carbon/M, alien, removed)
	. = ..()
	M.ash()

/datum/reagent/supermatter/affect_ingest(mob/living/carbon/M, alien, removed)
	. = ..()
	M.ash()

/datum/reagent/supermatter/affect_blood(mob/living/carbon/M, alien, removed)
	. = ..()
	M.ash()


/datum/reagent/adrenaline
	name = REAGENT_ADRENALINE
	id = REAGENT_ID_ADRENALINE
	description = "Adrenaline is a hormone used as a drug to treat cardiac arrest and other cardiac dysrhythmias resulting in diminished or absent cardiac output."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#C8A5DC"
	mrate_static = TRUE

/datum/reagent/adrenaline/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.SetParalysis(0)
	M.SetWeakened(0)
	M.adjustToxLoss(rand(3))

/datum/reagent/water/holywater
	name = REAGENT_HOLYWATER
	id = REAGENT_ID_HOLYWATER
	description = "An ashen-obsidian-water mix, this solution will alter certain sections of the brain's rationality."
	taste_description = "water"
	color = "#E0E8EF"
	mrate_static = TRUE

	glass_name = "holy water"
	glass_desc = "An ashen-obsidian-water mix, this solution will alter certain sections of the brain's rationality."

/datum/reagent/water/holywater/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(ishuman(M)) // Any location
		if(M.mind && GLOB.cult.is_antagonist(M.mind) && prob(10))
			GLOB.cult.remove_antagonist(M.mind)

/datum/reagent/water/holywater/touch_turf(var/turf/T)
	..()
	if(volume >= 5)
		T.holy = 1
	return

/datum/reagent/ammonia
	name = REAGENT_AMMONIA
	id = REAGENT_ID_AMMONIA
	description = "A caustic substance commonly used in fertilizer or household cleaners."
	taste_description = "mordant"
	taste_mult = 2
	reagent_state = GAS
	color = "#404030"

/datum/reagent/diethylamine
	name = REAGENT_DIETHYLAMINE
	id = REAGENT_ID_DIETHYLAMINE
	description = "A secondary amine, mildly corrosive."
	taste_description = REAGENT_ID_IRON
	reagent_state = LIQUID
	color = "#604030"

/datum/reagent/fluorosurfactant // Foam precursor
	name = REAGENT_FLUOROSURFACTANT
	id = REAGENT_ID_FLUOROSURFACTANT
	description = "A perfluoronated sulfonic acid that forms a foam when mixed with water."
	taste_description = "metal"
	reagent_state = LIQUID
	color = "#9E6B38"

/datum/reagent/foaming_agent // Metal foaming agent. This is lithium hydride. Add other recipes (e.g. LiH + H2O -> LiOH + H2) eventually.
	name = REAGENT_FOAMINGAGENT
	id = REAGENT_ID_FOAMINGAGENT
	description = "A agent that yields metallic foam when mixed with light metal and a strong acid."
	taste_description = "metal"
	reagent_state = SOLID
	color = "#664B63"

/datum/reagent/thermite
	name = REAGENT_THERMITE
	id = REAGENT_ID_THERMITE
	description = "Thermite produces an aluminothermic reaction known as a thermite reaction. Can be used to melt walls."
	taste_description = "sweet tasting metal"
	reagent_state = SOLID
	color = "#673910"
	touch_met = 50

/datum/reagent/thermite/touch_turf(var/turf/T)
	..()
	if(volume >= 5)
		if(istype(T, /turf/simulated/wall))
			var/turf/simulated/wall/W = T
			W.thermite = 1
			W.add_overlay(image('icons/effects/effects.dmi',icon_state = "#673910")) // What??
			remove_self(5)
	return

/datum/reagent/thermite/touch_mob(var/mob/living/L, var/amount)
	..()
	if(istype(L))
		L.adjust_fire_stacks(amount / 5)

/datum/reagent/thermite/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustFireLoss(3 * removed)

/datum/reagent/space_cleaner
	name = REAGENT_CLEANER
	id = REAGENT_ID_CLEANER
	description = "A compound used to clean things. Now with 50% more sodium hypochlorite!"
	taste_description = "sourness"
	reagent_state = LIQUID
	color = "#A5F0EE"
	touch_met = 50

/datum/reagent/space_cleaner/touch_mob(var/mob/M)
	..()
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		C.clean_blood(TRUE)

/datum/reagent/space_cleaner/touch_obj(var/obj/O)
	..()
	O.clean_blood()

/datum/reagent/space_cleaner/touch_turf(var/turf/T)
	..()
	if(volume >= 1)
		if(istype(T, /turf/simulated))
			var/turf/simulated/S = T
			S.dirt = 0
		T.clean_blood()
		for(var/obj/effect/O in T)
			if(istype(O,/obj/effect/rune) || istype(O,/obj/effect/decal/cleanable) || istype(O,/obj/effect/overlay))
				qdel(O)

		for(var/mob/living/simple_mob/slime/M in T)
			M.adjustToxLoss(rand(5, 10))

/datum/reagent/space_cleaner/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.r_hand)
		M.r_hand.clean_blood()
	if(M.l_hand)
		M.l_hand.clean_blood()
	if(M.wear_mask)
		if(M.wear_mask.clean_blood())
			M.update_inv_wear_mask(0)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(alien == IS_SLIME)
			M.adjustToxLoss(rand(5, 10))
		if(H.head)
			if(H.head.clean_blood())
				H.update_inv_head(0)
		if(H.wear_suit)
			if(H.wear_suit.clean_blood())
				H.update_inv_wear_suit(0)
		else if(H.w_uniform)
			if(H.w_uniform.clean_blood())
				H.update_inv_w_uniform(0)
		if(H.shoes)
			if(H.shoes.clean_blood())
				H.update_inv_shoes(0)
		else
			H.clean_blood(1)
			return
	M.clean_blood()

/datum/reagent/space_cleaner/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_SLIME)
		M.adjustToxLoss(6 * removed)
	else
		M.adjustToxLoss(3 * removed)
		if(prob(5))
			M.vomit()

/datum/reagent/space_cleaner/touch_mob(var/mob/living/L, var/amount)
	..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(H.wear_mask)
			if(istype(H.wear_mask, /obj/item/clothing/mask/smokable))
				var/obj/item/clothing/mask/smokable/S = H.wear_mask
				if(S.lit)
					S.quench() // No smoking in my medbay!
					H.visible_message(span_notice("[H]\'s [S.name] is put out."))

/datum/reagent/lube // TODO: spraying on borgs speeds them up
	name = REAGENT_LUBE
	id = REAGENT_ID_LUBE
	description = "Lubricant is a substance introduced between two moving surfaces to reduce the friction and wear between them. giggity."
	taste_description = "slime"
	reagent_state = LIQUID
	color = "#009CA8"

/datum/reagent/lube/touch_turf(var/turf/simulated/T)
	..()
	if(!istype(T))
		return
	if(volume >= 1)
		T.wet_floor(2)

/datum/reagent/silicate
	name = REAGENT_SILICATE
	id = REAGENT_ID_SILICATE
	description = "A compound that can be used to reinforce glass."
	taste_description = "plastic"
	reagent_state = LIQUID
	color = "#C7FFFF"

/datum/reagent/silicate/touch_obj(var/obj/O)
	..()
	if(istype(O, /obj/structure/window))
		var/obj/structure/window/W = O
		W.apply_silicate(volume)
		remove_self(volume)
	return

/datum/reagent/glycerol
	name = REAGENT_GLYCEROL
	id = REAGENT_ID_GLYCEROL
	description = "Glycerol is a simple polyol compound. Glycerol is sweet-tasting and of low toxicity."
	taste_description = "sweetness"
	reagent_state = LIQUID
	color = "#808080"

/datum/reagent/nitroglycerin
	name = REAGENT_NITROGLYCERIN
	id = REAGENT_ID_NITROGLYCERIN
	description = "Nitroglycerin is a heavy, colorless, oily, explosive liquid obtained by nitrating glycerol."
	taste_description = "oil"
	reagent_state = LIQUID
	color = "#808080"

/datum/reagent/coolant
	name = REAGENT_COOLANT
	id = REAGENT_ID_COOLANT
	description = "Industrial cooling substance."
	taste_description = "sourness"
	taste_mult = 1.1
	reagent_state = LIQUID
	color = "#C8A5DC"

	affects_robots = TRUE

/datum/reagent/coolant/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.isSynthetic() && ishuman(M))
		var/mob/living/carbon/human/H = M

		var/datum/reagent/blood/coolant = H.get_blood(H.vessel)

		if(coolant)
			H.vessel.add_reagent(REAGENT_ID_BLOOD, removed, coolant.data)

		else
			H.vessel.add_reagent(REAGENT_ID_BLOOD, removed)
			H.fixblood()

	else
		..()

/datum/reagent/ultraglue
	name = REAGENT_GLUE
	id = REAGENT_ID_GLUE
	description = "An extremely powerful bonding agent."
	taste_description = "a special education class"
	color = "#FFFFCC"

/datum/reagent/woodpulp
	name = REAGENT_WOODPULP
	id = REAGENT_ID_WOODPULP
	description = "A mass of wood fibers."
	taste_description = "wood"
	reagent_state = LIQUID
	color = "#B97A57"

/datum/reagent/luminol
	name = REAGENT_LUMINOL
	id = REAGENT_ID_LUMINOL
	description = "A compound that interacts with blood on the molecular level."
	taste_description = "metal"
	reagent_state = LIQUID
	color = "#F2F3F4"

/datum/reagent/luminol/touch_obj(var/obj/O)
	..()
	O.reveal_blood()

/datum/reagent/luminol/touch_mob(var/mob/living/L)
	..()
	L.reveal_blood()

/datum/reagent/nutriment/biomass
	name = REAGENT_BIOMASS
	id = REAGENT_ID_BIOMASS
	description = "A slurry of compounds that contains the basic requirements for life."
	taste_description = "salty meat"
	reagent_state = LIQUID
	color = "#DF9FBF"

/datum/reagent/mineralfluid
	name = REAGENT_MINERALIZEDFLUID
	id = REAGENT_ID_MINERALIZEDFLUID
	description = "A warm, mineral-rich fluid."
	taste_description = "salt"
	reagent_state = LIQUID
	color = "#ff205255"

// The opposite to healing nanites, exists to make unidentified hypos implied to have nanites not be 100% safe.
/datum/reagent/defective_nanites
	name = REAGENT_DEFECTIVENANITES
	id = REAGENT_ID_DEFECTIVENANITES
	description = "Miniature medical robots that are malfunctioning and cause bodily harm. Fortunately, they cannot self-replicate."
	taste_description = "metal"
	reagent_state = SOLID
	color = "#333333"
	metabolism = REM * 3 // Broken nanomachines go a bit slower.
	scannable = 1

/datum/reagent/defective_nanites/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.take_organ_damage(2 * removed, 2 * removed)
	M.adjustOxyLoss(4 * removed)
	M.adjustToxLoss(2 * removed)
	M.adjustCloneLoss(2 * removed)

/datum/reagent/nutriment/fishbait
	name = REAGENT_FISHBAIT
	id = REAGENT_ID_FISHBAIT
	description = "A natural slurry that particularily appeals to fish."
	taste_description = "slimy dirt"
	reagent_state = LIQUID
	color = "#62764E"
	nutriment_factor = 15

/datum/reagent/carpet
	name = REAGENT_LIQUIDCARPET
	id = REAGENT_ID_LIQUIDCARPET
	description = "Liquified carpet fibers, ready for dyeing."
	reagent_state = LIQUID
	color = "#b51d05"
	taste_description = "carpet"

/datum/reagent/carpet/black
	name = REAGENT_LIQUIDCARPETB
	id = REAGENT_ID_LIQUIDCARPETB
	description = "Black Carpet Fibers, ready for reinforcement."
	reagent_state = LIQUID
	color = "#000000"
	taste_description = "rare and ashy carpet"

/datum/reagent/carpet/blue
	name = REAGENT_LIQUIDCARPETBLU
	id = REAGENT_ID_LIQUIDCARPETBLU
	description = "Blue Carpet Fibers, ready for reinforcement."
	reagent_state = LIQUID
	color = "#3f4aee"
	taste_description = "commanding carpet"

/datum/reagent/carpet/turquoise
	name = REAGENT_LIQUIDCARPETTUR
	id = REAGENT_ID_LIQUIDCARPETTUR
	description = "Turquoise Carpet Fibers, ready for reinforcement."
	reagent_state = LIQUID
	color = "#0592b5"
	taste_description = "water-logged carpet"

/datum/reagent/carpet/sblue
	name = REAGENT_LIQUIDCARPETSBLU
	id = REAGENT_ID_LIQUIDCARPETSBLU
	description = "Silver Blue Carpet Fibers, ready for reinforcement."
	reagent_state = LIQUID
	color = "#0011ff"
	taste_description = "sterile and medicinal carpet"

/datum/reagent/carpet/clown
	name = REAGENT_LIQUIDCARPETC
	id = REAGENT_ID_LIQUIDCARPETC
	description = "Clown Carpet Fibers.... No clowns were harmed in the making of this."
	reagent_state = LIQUID
	color = "#e925be"
	taste_description = "clown shoes and banana peels"

/datum/reagent/carpet/purple
	name = REAGENT_LIQUIDCARPETP
	id = REAGENT_ID_LIQUIDCARPETP
	description = "Purple Carpet Fibers, ready for reinforcement."
	reagent_state = LIQUID
	color = "#a614d3"
	taste_description = "bleeding edge carpet research"

/datum/reagent/carpet/orange
	name = REAGENT_LIQUIDCARPETO
	id = REAGENT_ID_LIQUIDCARPETO
	description = "Orange Carpet Fibers, ready for reinforcement."
	reagent_state = LIQUID
	color = "#f16e16"
	taste_description = "extremely overengineered carpet"

/datum/reagent/essential_oil
	name = REAGENT_ESSENTIALOIL
	id = REAGENT_ID_ESSENTIALOIL
	description = "A slurry of compounds that contains the basic requirements for life."
	taste_description = "a mixture of thick, sweet, salty, salty and spicy flavours that all blend together to not be very nice at all"
	reagent_state = LIQUID
	color = "#e8e2b0"
