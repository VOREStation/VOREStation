/* Containers for all warm beverages!
 *
 * Contains:
 *		Coffee Mug Base
 *		Coffee Cup Base
 *		Tea Cup Base
 *		Coffee Pot
 *		British Mug
 *		Text Mug
 *		Government Mugs
 *		Corporate Mugs
 *		Symbols and Markings Mugs
 *		Pure Colors and Other Mugs
 *		Tall Mugs
 */

/*
 * Coffee Mug Base
 */
/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeemug
	name = "coffee mug"
	base_name = "mug"
	desc = "A plain ceramic coffee mug."
	icon = 'icons/obj/drinks_coffee.dmi'
	base_icon = "coffeemug"
	volume = 30
	var/fillsource = "coffeemug"

/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeemug/update_icon()
	cut_overlays()

	if(reagents.total_volume)
		var/image/filling = image('icons/obj/drinks_coffee.dmi', src, null)
		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 39)
				filling.icon_state = null
				return
			if(40 to 79) 	filling.icon_state = "[fillsource]40"
			if(80 to 99)	filling.icon_state = "[fillsource]80"
			if(100 to INFINITY)	filling.icon_state = "[fillsource]100"
		filling.color = reagents.get_color()
		add_overlay(filling)

/*
 * Coffee Cup Base
 */
/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeecup
	name = "coffee cup"
	base_name = "cup"
	desc = "The container of oriental luxuries."
	icon = 'icons/obj/drinks_coffee.dmi'
	base_icon = "coffeecup"
	volume = 20 //Slightly smaller cup shouldn't have the same volume as a mug
	var/fillsource = "coffeecup"

/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeecup/update_icon()
	cut_overlays()

	if(reagents.total_volume)
		var/image/filling = image('icons/obj/drinks_coffee.dmi', src, null)
		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 44)
				filling.icon_state = null
				return
			if(45 to 74) 	filling.icon_state = "[fillsource]50"
			if(75 to INFINITY)	filling.icon_state = "[fillsource]100"
		filling.color = reagents.get_color()
		add_overlay(filling)

/*
 * Tea Cup Base
 */
/obj/item/weapon/reagent_containers/food/drinks/glass2/teacup
	name = "tea cup"
	base_name = "cup"
	desc = "A cup in which tea is served. Hence the name."
	icon = 'icons/obj/drinks_coffee.dmi'
	base_icon = "teacup"
	volume = 15
	var/fillsource = "teacup"

/obj/item/weapon/reagent_containers/food/drinks/glass2/teacup/update_icon()
	cut_overlays()

	if(reagents.total_volume)
		var/image/filling = image('icons/obj/drinks_coffee.dmi', src, null)
		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 44)
				filling.icon_state = null
				return
			if(45 to 74) 	filling.icon_state = "[fillsource]50"
			if(75 to INFINITY)	filling.icon_state = "[fillsource]100"
		filling.color = reagents.get_color()
		add_overlay(filling)

/obj/item/weapon/reagent_containers/food/drinks/glass2/teacup/big
	name = "big tea cup"
	base_name = "cup"
	desc = "An absolute unit of a cup in which tea is served. Hence the name."
	base_icon = "bigteacup"
	volume = 45
	fillsource = "bigteacup"

/*
 * Coffee Pot
 */
/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeepot
	name = "coffee pot"
	base_name = "coffeepot"
	base_icon = "coffeepot"
	desc = "A coffee pot"
	icon = 'icons/obj/drinks_coffee.dmi'
	matter = list(MAT_GLASS = 25, MAT_PLASTIC = 25)
	volume = 120 //Enough for four full coffee mugs
	var/fillsource = "coffeepot"

/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeepot/update_icon()
	cut_overlays()

	if(reagents.total_volume)
		var/image/filling = image('icons/obj/drinks_coffee.dmi', src, null)
		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 14)
				filling.icon_state = null
				return
			if(15 to 29) 	filling.icon_state = "[fillsource]15"
			if(30 to 44)	filling.icon_state = "[fillsource]30"
			if(45 to 59)	filling.icon_state = "[fillsource]45"
			if(60 to 74)	filling.icon_state = "[fillsource]60"
			if(75 to 99)	filling.icon_state = "[fillsource]75"
			if(100 to INFINITY)	filling.icon_state = "[fillsource]90"
		filling.color = reagents.get_color()
		add_overlay(filling)

/*
 * Syrup Bottles
 */
/obj/item/weapon/reagent_containers/food/condiment/small/syrup_bottle
	name = "vanilla syrup"
	desc = "Now everything can taste like weak almonds!"
	icon = 'icons/obj/drinks_coffee.dmi'
	icon_state = "vanilla_bottle"
	possible_transfer_amounts = list(1,5,10)
	volume = 60

/obj/item/weapon/reagent_containers/food/condiment/small/syrup_bottle/afterattack(var/obj/target, var/mob/user, var/flag)
	if(!user.Adjacent(target))
		return
	if(standard_dispenser_refill(user, target))
		return
	if(standard_pour_into(user, target))
		return

	flick("[icon_state]_anim", src)
	if(istype(target, /obj/item/weapon/reagent_containers/food/snacks)) // These are not opencontainers but we can transfer to them
		if(!reagents || !reagents.total_volume)
			to_chat(user, "<span class='notice'>There is no condiment left in \the [src].</span>")
			return

		if(!target.reagents.get_free_space())
			to_chat(user, "<span class='notice'>You can't add more condiment to \the [target].</span>")
			return

		var/trans = reagents.trans_to_obj(target, amount_per_transfer_from_this)
		to_chat(user, "<span class='notice'>You add [trans] units of the condiment to \the [target].</span>")
	else
		..()

/obj/item/weapon/reagent_containers/food/condiment/small/syrup_bottle/Initialize()
	. = ..()
	reagents.add_reagent("vanilla", 50)

/obj/item/weapon/reagent_containers/food/condiment/small/syrup_bottle/chocolate
	name = "chocolate syrup"
	desc = "An easy way to dispense chocolately goodness."
	icon = 'icons/obj/drinks_coffee.dmi'
	icon_state = "chocolate_bottle"

/obj/item/weapon/reagent_containers/food/condiment/small/syrup_bottle/chocolate/Initialize()
	. = ..()
	reagents.add_reagent("chocolate", 50)

/obj/item/weapon/reagent_containers/food/condiment/small/syrup_bottle/caramel
	name = "caramel syrup"
	desc = "Buttery sweetness in a bottle."
	icon = 'icons/obj/drinks_coffee.dmi'
	icon_state = "caramel_bottle"

/obj/item/weapon/reagent_containers/food/condiment/small/syrup_bottle/caramel/Initialize()
	. = ..()
	reagents.add_reagent("caramel", 50)

/obj/item/weapon/storage/box/syrup_bottle
	name = "box of syrup bottles"
	desc = "A box that containing several bottles of syrup used for mixed drinks."
	icon_state = "box"
	max_storage_space = ITEMSIZE_COST_SMALL * 6
	starts_with = list(
		/obj/item/weapon/reagent_containers/food/condiment/small/syrup_bottle = 2,
		/obj/item/weapon/reagent_containers/food/condiment/small/syrup_bottle/chocolate = 2,
		/obj/item/weapon/reagent_containers/food/condiment/small/syrup_bottle/caramel = 2
	)

/*
 * Britcup
 */
/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeemug/britcup
	name = "cup"
	desc = "A cup with the old British flag emblazoned on it."
	base_icon = "britcup"

/*
 * Text Mug
 */
/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeemug/textmug
	name = "mug with text"
	desc = "A mug with something written on it."
	base_icon = "textmug"

/*
 * Government Mugs
 */
/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeemug/sol
	name = "\improper SCG coffee mug"
	desc = "A blue coffee mug emblazoned with the crest of the Solar Confederate Government."
	base_icon = "coffeecup_sol"

/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeemug/fleet
	name = "\improper SCG Fleet coffee cup"
	desc = "A coffee mug imprinted with the emblem of the Solar Confederate Fleet."
	base_icon = "coffeecup_fleet"

/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeemug/fivearrows
	name = "\improper Five Arrows coffee mug"
	desc = "A coffee mug with the flag of the Five Arrows proudly displayed on it."
	base_icon = "coffeecup_fivearrows"

/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeemug/alma
	name = "\improper Almach Association coffee cup"
	desc = "A grey coffee cup emblazoned with the star of the Almach Association."
	base_icon = "coffeecup_alma"

/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeemug/almp
	name = "\improper Almach Protectorate coffee cup"
	desc = "A purple coffee cup emblazoned with the star of the Almach Protectorate."
	base_icon = "coffeecup_almp"

/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeemug/psc
	name = "\improper Pearlshield coffee mug"
	desc = "A coffee mug bearing the symbol of the Pearlshield Coalition."
	base_icon = "coffeecup_psc"

/*
 * Corporate Mugs
 */
/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeemug/nt
	name = "\improper NT coffee mug"
	desc = "A blue NanoTrasen coffee mug."
	base_icon = "coffeecup_NT"

/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeemug/metal/wulf
	name = "\improper Wulf Aeronautics coffee mug"
	desc = "A metal coffee mug bearing the livery of Wulf Aeronautics."
	base_icon = "coffeecup_wulf"

/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeemug/gilthari
	name = "\improper Gilthari Exports coffee mug"
	desc = "A coffee mug bearing golden G of Gilthari Exports."
	base_icon = "coffeecup_gilth"

/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeemug/wt
	name = "\improper Ward-Takahashi coffee mug"
	desc = "A coffee mug in a geometric Ward-Takahashi design."
	base_icon = "coffeecup_wt"

/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeemug/aether
	name = "\improper Aether Atmospherics coffee mug"
	desc = "A coffee mug in Aether Atmospherics colours."
	base_icon = "coffeecup_aether"

/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeemug/zeng
	name = "\improper Zeng-Hu coffee cup"
	desc = "A coffee cup bearing the Zeng-Hu logo."
	base_icon = "coffeecup_zeng"

/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeemug/bishop
	name = "\improper Bishop coffee mug"
	desc = "A black coffee mug adorned with Bishop's logo."
	base_icon = "coffeecup_bishop"

/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeemug/oculum
	name = "pawn coffee mug"
	desc = "A black and blue coffee mug decorated with the logo of Oculum Broadcast."
	base_icon = "coffeecup_oculum"

/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeemug/talon
	name = "\improper Talon coffee mug"
	desc = "A teal colored coffee mug with the Talon star logo on its face."
	base_icon = "coffeecup_talon"

/*
 * Symbols and Markings Mugs
 */
/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeemug/one
	name = "#1 coffee mug"
	desc = "A white coffee mug, prominently featuring a #1."
	base_icon = "coffeecup_one"

/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeemug/puni
	name = "#1 monkey coffee mug"
	desc = "A white coffee mug, prominently featuring a \"#1 monkey\" decal."
	base_icon = "coffeecup_puni"

/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeemug/heart
	name = "heart coffee mug"
	desc = "A white coffee mug, it prominently features a red heart."
	base_icon = "coffeecup_heart"

/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeemug/pawn
	name = "pawn coffee mug"
	desc = "A black coffee mug adorned with the image of a red chess pawn."
	base_icon = "coffeecup_pawn"

/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeemug/diona
	name = "diona nymph coffee mug"
	desc = "A green coffee mug featuring the image of a diona nymph."
	base_icon = "coffeecup_diona"

/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeemug/britcup
	name = "british coffee mug"
	desc = "A coffee mug with the British flag emblazoned on it."
	base_icon = "coffeecup_brit"

/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeemug/flame
	name = "flame coffee cup"
	desc = "A coffee cup with the a flame emblazoned on it."
	base_icon = "coffeecup_flame"

/*
 * Solid Colors and Other Mugs
 */
/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeemug/black
	name = "black coffee mug"
	desc = "A sleek black coffee mug."
	base_icon = "coffeecup_black"

/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeemug/green
	name = "green coffee mug"
	desc = "A pale green and pink coffee mug."
	base_icon = "coffeecup_green"

/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeemug/green/dark
	desc = "A dark green coffee mug."
	base_icon = "coffeecup_corp"

/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeemug/blue
	name = "blue coffee mug"
	desc = "A blue coffee mug."
	base_icon = "coffeecup_blue"

/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeemug/rainbow
	name = "rainbow coffee mug"
	desc = "A rainbow coffee mug. The colors are almost as blinding as a welder."
	base_icon = "coffeecup_rainbow"

/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeemug/metal
	name = "metal coffee mug"
	desc = "A metal coffee mug. You're not sure which metal."
	base_icon = "coffeecup_metal"

/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeemug/glass
	name = "glass coffee mug"
	desc = "A glass coffee mug, using space age technology to keep it cool for use."
	base_icon = "glasscoffeecup"
	fillsource = "glasscoffeecup"

/*
 * Tall Mugs
 */
/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeemug/tall
	name = "tall coffee mug"
	desc = "An unreasonably tall coffee mug, for when you really need to wake up in the morning."
	icon = 'icons/obj/drinks_mugs_tall.dmi'
	base_icon = "coffeecup_tall"
	fillsource = "coffeecup_tall"
	volume = 60

/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeemug/tall/update_icon()
	cut_overlays()

	if(reagents.total_volume)
		var/image/filling = image('icons/obj/drinks_mugs_tall.dmi', src, null)
		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 69)
				filling.icon_state = null
				return
			if(70 to 89) 	filling.icon_state = "[fillsource]70"
			if(90 to 99)	filling.icon_state = "[fillsource]90"
			if(100 to INFINITY)	filling.icon_state = "[fillsource]100"
		filling.color = reagents.get_color()
		add_overlay(filling)

/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeemug/tall/black
	name = "tall black coffee mug"
	desc = "An unreasonably tall coffee mug, for when you really need to wake up in the morning. This one is black."
	base_icon = "coffeecup_tall_black"

/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeemug/tall/metal
	name = "tall metal coffee mug"
	desc = "An unreasonably tall coffee mug, for when you really need to wake up in the morning. This one is made of metal."
	base_icon = "coffeecup_tall_metal"

/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeemug/tall/rainbow
	name = "tall rainbow coffee mug"
	desc = "An unreasonably tall coffee mug, for when you really need to wake up in the morning. This one is rainbow colored."
	base_icon = "coffeecup_tall_rainbow"
