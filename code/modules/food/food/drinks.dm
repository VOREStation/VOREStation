/obj/item/food/drinks/golden_cup
	desc = "A golden cup"
	name = "golden cup"
	icon_state = "golden_cup"
	item_state = "" //nope :(
	w_class = ITEMSIZE_LARGE
	force = 14
	throwforce = 10
	amount_per_transfer_from_this = 20
	max_transfer_amount = null
	volume = 150
	flags = OPENCONTAINER

/obj/item/food/drinks/golden_cup/on_reagent_change()
	..()

///////////////////////////////////////////////Drinks
//Notes by Darem: Drinks are simply containers that start preloaded. Unlike condiments, the contents can be ingested directly
//	rather then having to add it to something else first. They should only contain liquids. They have a default container size of 50.
//	Formatting is the same as food.

/obj/item/food/drinks/milk
	name = "milk carton"
	desc = "It's milk. White and nutritious goodness!"
	description_fluff = "A product of NanoPastures. Who would have thought that cows would thrive in zero-G?"
	icon_state = "milk"
	item_state = "carton"
	center_of_mass_x = 16
	center_of_mass_y = 9
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'

/obj/item/food/drinks/milk/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_MILK, 50)

/obj/item/food/drinks/soymilk
	name = "soymilk carton"
	desc = "It's soy milk. White and nutritious goodness!"
	description_fluff = "A product of NanoPastures. For those skeptical that cows can thrive in zero-G."
	icon_state = "soymilk"
	item_state = "carton"
	center_of_mass_x = 16
	center_of_mass_y = 9
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'

/obj/item/food/drinks/soymilk/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_SOYMILK, 50)

/obj/item/food/drinks/smallmilk
	name = "small milk carton"
	desc = "It's milk. White and nutritious goodness!"
	description_fluff = "A product of NanoPastures. Who would have thought that cows would thrive in zero-G?"
	volume = 30
	icon_state = "mini-milk"
	item_state = "carton"
	center_of_mass_x = 16
	center_of_mass_y = 9
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'

/obj/item/food/drinks/smallmilk/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_MILK, 30)

/obj/item/food/drinks/smallchocmilk
	name = "small chocolate milk carton"
	desc = "It's milk! This one is in delicious chocolate flavour."
	description_fluff = "A product of NanoPastures. Who would have thought that cows would thrive in zero-G?"
	volume = 30
	icon_state = "mini-milk_choco"
	item_state = "carton"
	center_of_mass_x = 16
	center_of_mass_y = 9
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'

/obj/item/food/drinks/smallchocmilk/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_CHOCOLATEMILK, 30)

/obj/item/food/drinks/coffee
	name = "\improper Robust Coffee"
	desc = "Careful, the beverage you're about to enjoy is extremely hot."
	description_fluff = "Fresh coffee is almost unheard of outside of planets and stations where it is grown. Robust Coffee proudly advertises the six separate times it is freeze-dried during the production process of every cup of instant."
	icon_state = "coffee"
	trash = /obj/item/trash/coffee
	center_of_mass_x = 15
	center_of_mass_y = 10
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'

/obj/item/food/drinks/coffee/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_COFFEE, 30)

/obj/item/food/drinks/tea
	name = "cup of Duke Purple tea"
	desc = "An insult to Duke Purple is an insult to the Space Queen! Any proper gentleman will fight you, if you sully this tea."
	description_fluff = "Duke Purple is NanoPasture's proprietary strain of black tea, noted for its strong but otherwise completely non-distinctive flavour."
	icon_state = "chai_vended"
	item_state = "coffee"
	trash = /obj/item/trash/coffee
	center_of_mass_x = 16
	center_of_mass_y = 14
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'

/obj/item/food/drinks/tea/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_TEA, 30)

/obj/item/food/drinks/decaf_tea
	name = "cup of Count Mauve decaffeinated tea"
	desc = "Why should bedtime stop you from enjoying a nice cuppa?"
	description_fluff = "Count Mauve is a milder strain of NanoPasture's proprietary black tea, noted for its strong but otherwise completely non-distinctive flavour and total lack of caffeination."
	icon_state = "chai_vended"
	item_state = "coffee"
	trash = /obj/item/trash/coffee
	center_of_mass_x = 16
	center_of_mass_y = 14
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'

/obj/item/food/drinks/decaf_tea/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_TEADECAF, 30)

/obj/item/food/drinks/ice
	name = "cup of ice"
	desc = "Careful, cold ice, do not chew."
	icon_state = "ice"
	center_of_mass_x = 15
	center_of_mass_y = 10
/obj/item/food/drinks/ice/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_ICE, 30)

/obj/item/food/drinks/h_chocolate
	name = "cup of Counselor's Choice hot cocoa"
	desc = "Who needs character traits when you can enjoy a hot mug of cocoa?"
	description_fluff = "Counselor's Choice brand hot cocoa is made with a blend of hot water and non-dairy milk powder substitute, in a compromise destined to annoy all parties."
	icon_state = "coffee"
	item_state = "hot_choc"
	trash = /obj/item/trash/coffee
	center_of_mass_x = 15
	center_of_mass_y = 13
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'

/obj/item/food/drinks/h_chocolate/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_HOTCOCO, 30)

/obj/item/food/drinks/greentea
	name = "cup of green tea"
	desc = "Exceptionally traditional, delightfully subtle."
	description_fluff = "Tea remains an important tradition in many cultures originating on Earth. Among these, green tea is probably the most traditional of the bunch... Though the vending machines of the modern era hardly do it justice."
	icon_state = "greentea_vended"
	item_state = "coffee"
	trash = /obj/item/trash/coffee
	center_of_mass_x = 16
	center_of_mass_y = 14
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'

/obj/item/food/drinks/greentea/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_GREENTEA, 30)

/obj/item/food/drinks/chaitea
	name = "cup of chai tea"
	desc = "The name is redundant but the flavor is delicious!"
	description_fluff = "Chai Tea - tea blended with a spice mix of cinnamon and cloves - borders on a national drink on Kishar."
	icon_state = "chai_vended"
	item_state = "coffee"
	trash = /obj/item/trash/coffee
	center_of_mass_x = 16
	center_of_mass_y = 14
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'

/obj/item/food/drinks/chaitea/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_CHAITEA, 30)

/obj/item/food/drinks/decaf
	name = "cup of decaf coffee"
	desc = "Coffee with all the wake-up sucked out."
	description_fluff = "A trial run on two NanoTrasen stations in 2481 attempted to replace all vending machine coffee with decaf in order to combat an epidemic of caffeine addiction. After two days, three major industrial accidents and a death, the initiative was cancelled. Decaf is now thankfully optional."
	icon_state = "coffee"
	item_state = "coffee"
	trash = /obj/item/trash/coffee
	center_of_mass_x = 16
	center_of_mass_y = 14
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'

/obj/item/food/drinks/decaf/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_DECAF, 30)

/obj/item/food/drinks/dry_ramen
	name = "Cup Ramen"
	desc = "Just add 10ml water and boil! A taste that reminds you of your school years."
	description_fluff = "Konohagakure Brand Ramen has been an instant meal staple for centuries. Cheap, quick and available in over two hundred varieties - though most taste like artifical chicken."
	icon_state = "ramen"
	trash = /obj/item/trash/ramen
	center_of_mass_x = 16
	center_of_mass_y = 11
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'

/obj/item/food/drinks/dry_ramen/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_DRYRAMEN, 30)

/obj/item/food/drinks/sillycup
	name = "paper cup"
	desc = "A paper water cup."
	icon_state = "water_cup_e"
	max_transfer_amount = null
	volume = 10
	center_of_mass_x = 16
	center_of_mass_y = 12
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'

/obj/item/food/drinks/sillycup/Initialize(mapload)
	. = ..()

/obj/item/food/drinks/sillycup/on_reagent_change()
	..()
	if(reagents.total_volume)
		icon_state = "water_cup"
	else
		icon_state = "water_cup_e"

/obj/item/food/drinks/sillycup/MouseDrop(obj/over_object as obj)
	if(!reagents.total_volume && istype(over_object, /obj/structure/reagent_dispensers/water_cooler))
		if(over_object.Adjacent(usr))
			var/obj/structure/reagent_dispensers/water_cooler/W = over_object
			if(W.cupholder && W.cups < 10)
				W.cups++
				to_chat(usr, span_notice("You put the [src] in the cup dispenser."))
				qdel(src)
				W.update_icon()
	else
		return ..()

//////////////////////////drinkingglass and shaker//
//Note by Darem: This code handles the mixing of drinks. New drinks go in three places: In Chemistry-Reagents.dm (for the drink
//	itself), in Chemistry-Recipes.dm (for the reaction that changes the components into the drink), and here (for the drinking glass
//	icon states.

/obj/item/food/drinks/shaker
	name = "shaker"
	desc = "A metal shaker to mix drinks in."
	icon_state = "shaker"
	amount_per_transfer_from_this = 10
	volume = 120
	center_of_mass_x = 17
	center_of_mass_y = 10

/obj/item/food/drinks/shaker/on_reagent_change()
	..()

/obj/item/food/drinks/teapot
	name = "teapot"
	desc = "An elegant teapot. It simply oozes class."
	icon_state = "teapot"
	item_state = "teapot"
	amount_per_transfer_from_this = 10
	volume = 120
	center_of_mass_x = 17
	center_of_mass_y = 7

/obj/item/food/drinks/teapot/on_reagent_change()
	..()

/obj/item/food/drinks/flask
	name = "\improper " + JOB_SITE_MANAGER + "'s flask"
	desc = "A metal flask belonging to the " + JOB_SITE_MANAGER

	icon_state = "flask"
	volume = 60
	center_of_mass_x = 17
	center_of_mass_y = 7

/obj/item/food/drinks/flask/on_reagent_change()
	..()

/obj/item/food/drinks/flask/shiny
	name = "shiny flask"
	desc = "A shiny metal flask. It appears to have a Greek symbol inscribed on it."
	icon_state = "shinyflask"

/obj/item/food/drinks/flask/lithium
	name = "lithium flask"
	desc = "A flask with a Lithium Atom symbol on it."
	icon_state = "lithiumflask"

/obj/item/food/drinks/flask/detflask
	name = "\improper " + JOB_DETECTIVE + "'s flask"
	desc = "A metal flask with a leather band and golden badge belonging to the detective."
	icon_state = "detflask"
	volume = 60
	center_of_mass_x = 17
	center_of_mass_y = 8

/obj/item/food/drinks/flask/barflask
	name = "flask"
	desc = "For those who can't be bothered to hang out at the bar to drink."
	icon_state = "barflask"
	volume = 60
	center_of_mass_x = 17
	center_of_mass_y = 7

/obj/item/food/drinks/flask/vacuumflask
	name = "vacuum flask"
	desc = "Keeping your drinks at the perfect temperature since 1892."
	icon_state = "vacuumflask"
	volume = 60
	center_of_mass_x = 15
	center_of_mass_y = 4
