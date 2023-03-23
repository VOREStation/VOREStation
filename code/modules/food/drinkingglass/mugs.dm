/* Warm Mugs!
 *
 * Contains:
 *		Britcup
 *		Text Mug
 *		Coffee Mugs
 *		Tall Mugs
 */

/*
 * Britcup
 */
/obj/item/weapon/reagent_containers/food/drinks/britcup
	name = "cup"
	desc = "A cup with the British flag emblazoned on it."
	icon_state = "britcup"
	volume = 30
	center_of_mass = list("x"=15, "y"=13)

/obj/item/weapon/reagent_containers/food/drinks/britcup/on_reagent_change()
	..()

/*
 * Text Mug
 */
/obj/item/weapon/reagent_containers/food/drinks/textmug
	name = "mug with text"
	desc = "A mug with something written on it."
	icon = 'icons/obj/drinks_vr.dmi'
	icon_state = "textmug"
	volume = 30
	center_of_mass = list("x"=15, "y"=13)

/*
 * Coffee Mugs
 */
/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeemug
	name = "coffee mug"
	base_name = "mug"
	desc = "A plain white coffee mug."
	icon = 'icons/obj/drinks_mugs.dmi'
	base_icon = "coffeecup"
	volume = 30
	var/fillsource = "coffeecup"

/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeemug/update_icon()
	cut_overlays()

	if(reagents.total_volume)
		var/image/filling = image('icons/obj/drinks_mugs.dmi', src, null)
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

// Government
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

// Corporations
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

// Symbols, markings
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

// Pure colors & other
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
