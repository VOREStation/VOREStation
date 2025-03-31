
//Not to be confused with /obj/item/reagent_containers/food/drinks/bottle

/obj/item/reagent_containers/glass/bottle
	name = "bottle"
	desc = "A small bottle."
	icon = 'icons/obj/chemical.dmi'
	icon_state = null
	item_state = "atoxinbottle"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60)
	flags = 0
	volume = 60
	drop_sound = 'sound/items/drop/bottle.ogg'
	pickup_sound = 'sound/items/pickup/bottle.ogg'

/obj/item/reagent_containers/glass/bottle/on_reagent_change()
	update_icon()

/obj/item/reagent_containers/glass/bottle/pickup(mob/user)
	..()
	update_icon()

/obj/item/reagent_containers/glass/bottle/dropped(mob/user)
	..()
	update_icon()

/obj/item/reagent_containers/glass/bottle/attack_hand()
	..()
	update_icon()

/obj/item/reagent_containers/glass/bottle/Initialize(mapload)
	. = ..()
	if(!icon_state)
		icon_state = "bottle-[rand(1,4)]"

/obj/item/reagent_containers/glass/bottle/update_icon()
	cut_overlays()

	if(reagents.total_volume)
		var/image/filling = image('icons/obj/reagentfillings.dmi', src, "[icon_state]10")

		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0.1 to 20)	filling.icon_state = "[icon_state]-10"
			if(20 to 40) 	filling.icon_state = "[icon_state]-20"
			if(40 to 60)	filling.icon_state = "[icon_state]-40"
			if(60 to 80)	filling.icon_state = "[icon_state]-60"
			if(80 to 100)	filling.icon_state = "[icon_state]-80"
			if(100 to INFINITY)	filling.icon_state = "[icon_state]-100"

		filling.color = reagents.get_color()
		add_overlay(filling)

	if (!is_open_container())
		add_overlay("lid_[icon_state]")

	if (label_text)
		add_overlay("label_[icon_state]")

/obj/item/reagent_containers/glass/bottle/inaprovaline
	name = "inaprovaline bottle"
	desc = "A small bottle. Contains inaprovaline - used to stabilize patients."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-4"
	prefill = list(REAGENT_ID_INAPROVALINE = 60)

/obj/item/reagent_containers/glass/bottle/toxin
	name = "toxin bottle"
	desc = "A small bottle of toxins. Do not drink, it is poisonous."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-3"
	prefill = list(REAGENT_ID_TOXIN = 60)

/obj/item/reagent_containers/glass/bottle/cyanide
	name = "cyanide bottle"
	desc = "A small bottle of cyanide. Bitter almonds?"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-3"
	prefill = list(REAGENT_ID_CYANIDE = 30) //volume changed to match chloral

/obj/item/reagent_containers/glass/bottle/stoxin
	name = "soporific bottle"
	desc = "A small bottle of soporific. Just the fumes make you sleepy."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-3"
	prefill = list(REAGENT_ID_STOXIN = 60)

/obj/item/reagent_containers/glass/bottle/chloralhydrate
	name = "chloral hydrate bottle"
	desc = "A small bottle of Choral Hydrate. Mickey's Favorite!"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-3"
	prefill = list(REAGENT_ID_CHLORALHYDRATE = 30) //Intentionally low since it is so strong. Still enough to knock someone out.

/obj/item/reagent_containers/glass/bottle/antitoxin
	name = "dylovene bottle"
	desc = "A small bottle of dylovene. Counters poisons, and repairs damage. A wonder drug."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-4"
	prefill = list(REAGENT_ID_ANTITOXIN = 60)

/obj/item/reagent_containers/glass/bottle/mutagen
	name = "unstable mutagen bottle"
	desc = "A small bottle of unstable mutagen. Randomly changes the DNA structure of whoever comes in contact."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-1"
	prefill = list(REAGENT_ID_MUTAGEN = 60)

/obj/item/reagent_containers/glass/bottle/ammonia
	name = "ammonia bottle"
	desc = "A small bottle."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-1"
	prefill = list(REAGENT_ID_AMMONIA = 60)

/obj/item/reagent_containers/glass/bottle/eznutrient
	name = "\improper EZ NUtrient bottle"
	desc = "A small bottle."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-4"
	prefill = list(REAGENT_ID_EZNUTRIENT = 60)

/obj/item/reagent_containers/glass/bottle/left4zed
	name = "\improper Left-4-Zed bottle"
	desc = "A small bottle."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-4"
	prefill = list(REAGENT_ID_LEFT4ZED = 60)

/obj/item/reagent_containers/glass/bottle/robustharvest
	name = "\improper Robust Harvest"
	desc = "A small bottle."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-4"
	prefill = list(REAGENT_ID_ROBUSTHARVEST = 60)

/obj/item/reagent_containers/glass/bottle/diethylamine
	name = "diethylamine bottle"
	desc = "A small bottle."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-4"
	prefill = list(REAGENT_ID_DIETHYLAMINE = 60)

/obj/item/reagent_containers/glass/bottle/pacid
	name = "polytrinic acid bottle"
	desc = "A small bottle. Contains a small amount of Polytrinic Acid"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-4"
	prefill = list(REAGENT_ID_PACID = 60)

/obj/item/reagent_containers/glass/bottle/adminordrazine
	name = "adminordrazine bottle"
	desc = "A small bottle. Contains the liquid essence of the gods."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "holyflask"
	prefill = list(REAGENT_ID_ADMINORDRAZINE = 60)

/obj/item/reagent_containers/glass/bottle/capsaicin
	name = "capsaicin bottle"
	desc = "A small bottle. Contains hot sauce."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-4"
	prefill = list(REAGENT_ID_CAPSAICIN = 60)

/obj/item/reagent_containers/glass/bottle/frostoil
	name = "frost oil bottle"
	desc = "A small bottle. Contains cold sauce."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-4"
	prefill = list(REAGENT_ID_FROSTOIL = 60)

/obj/item/reagent_containers/glass/bottle/biomass
	name = "biomass bottle"
	desc = "A bottle of raw biomass! Gross!"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-3"
	prefill = list(REAGENT_ID_BIOMASS = 60)

/obj/item/reagent_containers/glass/bottle/cakebatter
	name = "cake batter bottle"
	desc = "A bottle of pre-made cake batter."
	icon_state = "bottle-1"
	prefill = list(REAGENT_ID_CAKEBATTER = 60)

/obj/item/reagent_containers/glass/bottle/cinnamonpowder
	name = "cinnamon powder bottle"
	desc = "A bottle with expensive cinnamon powder."
	icon_state = "bottle-1"
	prefill = list(REAGENT_ID_CINNAMONPOWDER = 30) // Expensive!

/obj/item/reagent_containers/glass/bottle/nothing
	name = "empty bottle?"
	desc = "An apparently empty bottle."
	icon_state = "bottle-1"
	prefill = list(REAGENT_ID_NOTHING = 60)

/obj/item/reagent_containers/glass/bottle/gelatin
	name = "gelatin bottle"
	desc = "A bottle full of gelatin."
	icon_state = "bottle-1"
	prefill = list(REAGENT_ID_GELATIN = 60)

/obj/item/reagent_containers/glass/bottle/lube
	name = "lube bottle"
	desc = "A bottle full of lube."
	icon_state = "bottle-1"
	prefill = list(REAGENT_ID_LUBE = 60)
