// Chaos cake

/datum/recipe/chaoscake_layerone
	reagents = list(REAGENT_ID_FLOUR = 30,REAGENT_ID_MILK = 20, REAGENT_ID_SUGAR = 10, REAGENT_ID_EGG = 9)
	fruit = list(PLANT_POISONBERRIES = 2, PLANT_CHERRY =  2)
	items = list(
			/obj/item/reagent_containers/food/snacks/meat/,
			/obj/item/reagent_containers/food/snacks/meat/,
			/obj/item/reagent_containers/food/snacks/meat/,
			/obj/item/reagent_containers/food/snacks/meat/
		)
	result = /obj/structure/chaoscake
	wiki_flag = WIKI_SPOILER

/datum/recipe/chaoscake_layertwo
	reagents = list(REAGENT_ID_FLOUR = 30, REAGENT_ID_MILK = 20, REAGENT_ID_SUGAR = 10, REAGENT_ID_EGG = 9, )
	fruit = list(PLANT_VANILLA =  2, PLANT_BANANA = 2)
	items = list(
			/obj/item/reagent_containers/food/snacks/dough,
			/obj/item/reagent_containers/food/snacks/dough,
			/obj/item/reagent_containers/food/snacks/dough,
			/obj/item/reagent_containers/food/snacks/dough
		)
	result = /obj/item/chaoscake_layer
	wiki_flag = WIKI_SPOILER

/datum/recipe/chaoscake_layerthree
	reagents = list(REAGENT_ID_FLOUR = 25, REAGENT_ID_MILK = 15, REAGENT_ID_SUGAR = 10, REAGENT_ID_EGG = 6, REAGENT_ID_DEATHBELL = 10)
	fruit = list(PLANT_GRAPES = 3)
	items = list(
			/obj/item/reagent_containers/food/snacks/dough,
			/obj/item/reagent_containers/food/snacks/dough,
			/obj/item/reagent_containers/food/snacks/dough
		)
	result = /obj/item/chaoscake_layer/three
	wiki_flag = WIKI_SPOILER

/datum/recipe/chaoscake_layerfour
	reagents = list(REAGENT_ID_FLOUR = 25, REAGENT_ID_MILK = 15, REAGENT_ID_SUGAR = 10, REAGENT_ID_EGG = 6, REAGENT_ID_MILKSHAKE = 30)
	fruit = list(PLANT_RICE = 3)
	items = list(
			/obj/item/reagent_containers/food/snacks/dough,
			/obj/item/reagent_containers/food/snacks/dough,
			/obj/item/reagent_containers/food/snacks/dough
		)
	result = /obj/item/chaoscake_layer/four
	wiki_flag = WIKI_SPOILER

/datum/recipe/chaoscake_layerfive
	reagents = list(REAGENT_ID_FLOUR = 20, REAGENT_ID_MILK = 10, REAGENT_ID_SUGAR = 10, REAGENT_ID_EGG = 6, REAGENT_ID_BLOOD = 30)
	fruit = list(PLANT_TOMATO = 2)
	items = list() //supposed to be made with lobster, still has to be ported.
	result = /obj/item/chaoscake_layer/five
	wiki_flag = WIKI_SPOILER

/datum/recipe/chaoscake_layersix
	reagents = list(REAGENT_ID_FLOUR = 20, REAGENT_ID_MILK = 10, REAGENT_ID_SUGAR = 10, REAGENT_ID_EGG = 6, REAGENT_ID_SPRINKLES = 5)
	fruit = list(PLANT_APPLE = 2)
	items = list(
			/obj/item/reagent_containers/food/snacks/dough,
			/obj/item/reagent_containers/food/snacks/dough,
			/obj/item/reagent_containers/food/snacks/dough,
			/obj/item/reagent_containers/food/snacks/chocolatebar,
			/obj/item/reagent_containers/food/snacks/chocolatebar,
			/obj/item/reagent_containers/food/snacks/chocolatebar
		)
	result = /obj/item/chaoscake_layer/six
	wiki_flag = WIKI_SPOILER

/datum/recipe/chaoscake_layerseven
	reagents = list(REAGENT_ID_FLOUR = 15, REAGENT_ID_MILK = 10, REAGENT_ID_SUGAR = 5, REAGENT_ID_EGG = 3, REAGENT_ID_DEVILSKISS = 20)
	fruit = list(PLANT_POTATO = 1)
	items = list(
			/obj/item/reagent_containers/food/snacks/dough,
			/obj/item/reagent_containers/food/snacks/dough,
			/obj/item/reagent_containers/food/snacks/dough
		)
	result = /obj/item/chaoscake_layer/seven
	wiki_flag = WIKI_SPOILER

/datum/recipe/chaoscake_layereight
	reagents = list(REAGENT_ID_FLOUR = 15, REAGENT_ID_MILK = 10, REAGENT_ID_SUGAR = 5, REAGENT_ID_EGG = 3, REAGENT_ID_CREAM = 20)
	fruit = list(PLANT_LEMON = 1)
	items = list(
			/obj/item/reagent_containers/food/snacks/dough,
			/obj/item/reagent_containers/food/snacks/dough,
			/obj/item/reagent_containers/food/snacks/dough
		)
	result = /obj/item/chaoscake_layer/eight
	wiki_flag = WIKI_SPOILER

/datum/recipe/chaoscake_layernine
	reagents = list(REAGENT_ID_WATER = 10, REAGENT_ID_BLOOD = 10)
	fruit = list(PLANT_GOLDAPPLE = 1)
	items = list()
	result = /obj/item/chaoscake_layer/nine
	wiki_flag = WIKI_SPOILER

/obj/structure/chaoscake
	name = "An unfinished cake"
	desc = "A single layer of a strange cake, you can see the cherry paste ooze, but it feels very incomplete..."

	icon = 'icons/obj/food64x64.dmi'
	icon_state = "chaoscake_unfinished-1"
	pixel_x = -16

	var/slices = 6
	var/maxslices = 6
	var/stage = 1
	var/maxstages = 9
	var/edible = 0

	var/regentime = 1000
	var/interval = 0

	var/static/list/desclist2 = list(
			"The first layer of a strange cake, you can see the cherry paste ooze.",
			"The second layer of the cake sits in place now, smelling of pear with delicious colourful cream.",
			"The third layer of cake adds a strange purple layer, glazed over with frosting. It smells of grapes, but with a hint of something foul underneath.",
			"With the fourth layer added the cake looks happier again. Reeking of vanilla, it brings up memories of childhood joy.",
			"The fifth layer is extremely disturbing on that cake. Smelling of pure copper, it seems that bright blood clots are forming on top.",
			"The cake is getting closer with the sixth layer added, the pink hue smelling of chocolate, with colourful sprinkles on top.",
			"The first pair of triplets rest on the cake, despite being mostly similar to the first three, an evil aura becomes noticable.",
			"The second pair of triplets rest on the cake, if you stand on the bright side, you can feel a good aura lifting your mood.",
			"A chaos cake. Both a creation of dark and light, the two cakes are kept in a careful balance by that mystical coin in the middle. It's said its effects would dissipate if the balance is ever tipped in favour of one side too much, so both sides much be cut equally."
		)

/obj/item/chaoscake_layer
	name = "A layer of cake"
	desc = "a layer of cake, it is made out of colourful cream."
	icon = 'icons/obj/food.dmi'
	icon_state = "chaoscake_layer-2"
	var/layer_stage = 1

/obj/item/chaoscake_layer/three
	desc = "a layer of cake, glazed in purple."
	icon_state = "chaoscake_layer-3"
	layer_stage = 2

/obj/item/chaoscake_layer/four
	desc = "a layer of cake, reminding you of a colouring book."
	icon_state = "chaoscake_layer-4"
	layer_stage = 3

/obj/item/chaoscake_layer/five
	desc = "A layer of cake, smells like copper."
	icon_state = "chaoscake_layer-5"
	layer_stage = 4

/obj/item/chaoscake_layer/six
	desc = "A layer of cake, featuring colourful sprinkles."
	icon_state = "chaoscake_layer-6"
	layer_stage = 5

/obj/item/chaoscake_layer/seven
	desc = "A triplet of evil cake parts."
	icon_state = "chaoscake_layer-7"
	layer_stage = 6

/obj/item/chaoscake_layer/eight
	desc = "A triplet of good cake parts."
	icon_state = "chaoscake_layer-8"
	layer_stage = 7

/obj/item/chaoscake_layer/nine
	name = "A coin of balance"
	desc = "A very peculiar coin, it seems to stabilise the air around it."
	icon_state = "chaoscake_layer-9"
	layer_stage = 8

/obj/structure/chaoscake/proc/HasSliceMissing()
	if(slices < maxslices)
		if(interval >= regentime)
			interval = 0
			slices++
			HasSliceMissing()
		else
			interval++
			HasSliceMissing()
	else
		return

/obj/item/reagent_containers/food/snacks/chaoscakeslice
	name = "The Chaos Cake Slice"
	desc = "A slice from The Chaos Cake, it pulses weirdly, as if angry to be separated from the whole"
	icon_state = "chaoscake_slice-1"

	center_of_mass_x = 16
	center_of_mass_y = 10
	nutriment_desc = list()
	nutriment_amt = 4
	volume = 80

/obj/item/reagent_containers/food/snacks/chaoscakeslice/Initialize(mapload)
	. = ..()
	var/i = rand(1,6)
	icon_state = "chaoscake_slice-[i]"
	switch(i)
		if(1)
			name = "Slice Of Evil" //Pretty damn poisonous, takes a lot of work to make safe for consumption, useful for medical.
			desc = "An odd slice, despite the grease and cherries oozing off the top, it smells delicious."
			nutriment_desc = list("The desire to consume" = 10) // You won't even taste the poison.
			reagents.add_reagent(REAGENT_ID_NEUROTOXIC_PROTEIN, 2)
			reagents.add_reagent(REAGENT_ID_SHOCKCHEM, 2)
			reagents.add_reagent(REAGENT_ID_AMATOXIN, 2)
			reagents.add_reagent(REAGENT_ID_CARPOTOXIN, 2)
			reagents.add_reagent(REAGENT_ID_SPIDERTOXIN, 2)
			bitesize = 7
		if(2)
			name = "Slice Of Evil" //A bad trip
			desc = "A mysterious slice, coated in purple frosting that smells like grapes."
			nutriment_desc = list("The desire to show off an party" = 10)
			reagents.add_reagent(REAGENT_ID_STOXIN, 2)
			reagents.add_reagent(REAGENT_ID_BLISS, 10)
			reagents.add_reagent(REAGENT_ID_SEROTROTIUM, 4)
			reagents.add_reagent(REAGENT_ID_CRYPTOBIOLIN, 8)
			reagents.add_reagent(REAGENT_ID_MINDBREAKER, 10)
			reagents.add_reagent(REAGENT_ID_PSILOCYBIN, 10)
			bitesize = 30 //even a single bite won't make you escape fate.
		if(3)
			name = "Slice Of Evil" //acidic
			desc = "A menacing slice, smelling clearly of copper, blood clots float on top."
			nutriment_desc = list("Infernal Rage" = 10)
			reagents.add_reagent(REAGENT_ID_BLOOD, 20)
			reagents.add_reagent(REAGENT_ID_STOMACID, 10)
			reagents.add_reagent(REAGENT_ID_MUTAGEN, 4)
			reagents.add_reagent(REAGENT_ID_THIRTEENLOKO, 20)
			reagents.add_reagent(REAGENT_ID_HYPERZINE, 10)
			bitesize = 30
		if(4)
			name = "Slice Of Good" //anti-tox
			desc = "A colourful slice, smelling of pear and coated in delicious cream."
			nutriment_desc = list("Hapiness" = 10)
			reagents.add_reagent(REAGENT_ID_ANTITOXIN, 2)
			reagents.add_reagent(REAGENT_ID_TRICORDRAZINE, 2)
			bitesize = 3
		if(5)
			name = "Slice Of Good" //anti-oxy
			desc = "A light slice, it's pretty to look at and smells of vanilla."
			nutriment_desc = list("Freedom" = 10)
			reagents.add_reagent(REAGENT_ID_DEXALINP, 2)
			reagents.add_reagent(REAGENT_ID_TRICORDRAZINE, 2)
			bitesize = 3
		if(6)
			name = "Slice Of Good" //anti-burn/brute
			desc = "A hearty slice, it smells of chocolate and strawberries."
			nutriment_desc = list("Love" = 10)
			reagents.add_reagent(REAGENT_ID_BICARIDINE, 2)
			reagents.add_reagent(REAGENT_ID_TRICORDRAZINE, 2)
			reagents.add_reagent(REAGENT_ID_KELOTANE, 2)
			bitesize = 4

/obj/structure/chaoscake/attackby(var/obj/item/W, var/mob/living/user)
	if(istype(W,/obj/item/material/knife))
		if(edible == 1)
			HasSliceMissing()
			if(slices <= 0)
				to_chat(user, "The cake hums away quietly as the chaos powered goodness slowly recovers the large amount of lost mass, best to give it a moment before cutting another slice.")
				return
			else
				to_chat(user, "You cut a slice of the cake. The slice looks like the cake was just baked, and you can see before your eyes as the spot where you cut the slice slowly regenerates!")
				slices = slices - 1
				icon_state = "chaoscake-[slices]"
				new /obj/item/reagent_containers/food/snacks/chaoscakeslice(src.loc)

		else
			to_chat(user, span_notice("It looks so good... But it feels so wrong to eat it before it's finished..."))
			return
	if(istype(W,/obj/item/chaoscake_layer))
		var/obj/item/chaoscake_layer/C = W
		if(C.layer_stage == 8)
			to_chat(user, "Finally! The coin on the top, the almighty chaos cake is complete!")
			qdel(W)
			stage++
			desc = desclist2[stage]
			icon_state = "chaoscake-6"
			edible = 1
			name = "The Chaos Cake!"
		else if(stage == maxstages)
			to_chat(user, "The cake is already done!")
		else if(stage == C.layer_stage)
			to_chat(user, "You add another layer to the cake, nice.")
			qdel(W)
			stage++
			desc = desclist2[stage]
			icon_state = "chaoscake_unfinished-[stage]"
		else
			to_chat(user, "Hmm, doesn't seem like this layer is supposed to be added there?")


// The One Pizza

/obj/structure/theonepizza
	name = "The One Pizza"
	desc = "...it's real."

	icon = 'icons/obj/food64x64.dmi'
	icon_state = "theonepizza"
	pixel_x = -16
	pixel_y = -16

	var/slicetime = 15 SECONDS

	var/slicelist = list(/obj/item/reagent_containers/food/snacks/sliceable/pizza/margherita/bigslice,
							/obj/item/reagent_containers/food/snacks/sliceable/pizza/pineapple/bigslice,
							/obj/item/reagent_containers/food/snacks/sliceable/pizza/meatpizza/bigslice,
							/obj/item/reagent_containers/food/snacks/sliceable/pizza/mushroompizza/bigslice,
							/obj/item/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza/bigslice)

/obj/structure/theonepizza/attackby(var/obj/item/W, var/mob/living/user)
	if(istype(W,/obj/item/material/knife))
		user.visible_message(span_infoplain(span_bold("\The [user]") + " starts to slowly cut through The One Pizza."), span_notice("You start to slowly cut through The One Pizza."))
		if(do_after(user, slicetime, exclusive = TASK_USER_EXCLUSIVE))
			if(!src)
				return		// We got disappeared already
			user.visible_message(span_infoplain(span_bold("\The [user]") + " successfully cuts The One Pizza."), span_notice("You successfully cut The One Pizza."))
			for(var/slicetype in slicelist)
				new slicetype(src.loc)
			qdel(src)

/obj/item/reagent_containers/food/snacks/sliceable/pizza/margherita/bigslice
	name = "Giant Margherita slice"
	desc = "Big enough to be a sign at a pizzeria."
	icon_state = "big_cheese_slice"

/obj/item/reagent_containers/food/snacks/sliceable/pizza/pineapple/bigslice
	name = "Giant ham & pineapple pizza slice"
	desc = "This thing probably constitutes an italian warcrime."
	icon_state = "big_pineapple_slice"

/obj/item/reagent_containers/food/snacks/sliceable/pizza/meatpizza/bigslice
	name = "Giant meatpizza slice"
	desc = "A Meat Feast fit for a king."
	icon_state = "big_meat_slice"

/obj/item/reagent_containers/food/snacks/sliceable/pizza/mushroompizza/bigslice
	name = "Giant mushroompizza slice"
	desc = "Practically a honey mushroom at this scale."
	icon_state = "big_mushroom_slice"

/obj/item/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza/bigslice
	name = "Giant vegetable pizza slice"
	desc = "So healthy it'll give you a heart attack."
	icon_state = "big_veggie_slice"

/datum/recipe/theonepizza
	fruit = list(PLANT_TOMATO = 5, PLANT_MUSHROOMS = 5, PLANT_EGGPLANT = 1, PLANT_CARROT = 1, PLANT_CORN = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/pineapple_ring,
		/obj/item/reagent_containers/food/snacks/pineapple_ring
	)
	result = /obj/structure/theonepizza
