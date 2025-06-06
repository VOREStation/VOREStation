////////////////////////////////////////////////////////////////////////////////
/// Drinks.
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_containers/food/drinks
	name = "drink"
	desc = "yummy"
	icon = 'icons/obj/drinks.dmi'
	drop_sound = 'sound/items/drop/drinkglass.ogg'
	pickup_sound =  'sound/items/pickup/drinkglass.ogg'
	icon_state = null
	flags = OPENCONTAINER
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5,10,15,25,30)
	volume = 50
	var/trash = null
	var/cant_open = 0
	var/cant_chance = 0

	/// Yims
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/drinks/Initialize(mapload)
	. = ..()
	if (prob(cant_chance))
		cant_open = 1

/obj/item/reagent_containers/food/drinks/on_reagent_change()
	if (reagents.reagent_list.len > 0)
		var/datum/reagent/R = reagents.get_master_reagent()
		if(R.price_tag)
			price_tag = R.price_tag
		else
			price_tag = null
	return

/obj/item/reagent_containers/food/drinks/Destroy()
	if(food_inserted_micros)
		for(var/mob/M in food_inserted_micros)
			M.dropInto(loc)
			food_inserted_micros -= M
	. = ..()

	return

/obj/item/reagent_containers/food/drinks/attackby(obj/item/W as obj, mob/user as mob)
	if(food_can_insert_micro && istype(W, /obj/item/holder))
		if(!(istype(W, /obj/item/holder/micro) || istype(W, /obj/item/holder/mouse)))
			. = ..()
			return

		if(!is_open_container())
			to_chat(user, span_warning("You cannot drop anything into \the [src] without opening it first."))
			return

		var/obj/item/holder/H = W

		if(!food_inserted_micros)
			food_inserted_micros = list()

		var/mob/living/M = H.held_mob

		M.forceMove(src)
		H.held_mob = null
		user.drop_from_inventory(H)
		qdel(H)

		food_inserted_micros += M

		to_chat(user, span_warning("You drop [M] into \the [src]."))
		to_chat(M, span_warning("[user] drops you into \the [src]."))
		return

	return ..()

/obj/item/reagent_containers/food/drinks/MouseDrop_T(mob/living/M, mob/user)
	if(!user.stat && istype(M) && (M == user) && Adjacent(M) && (M.get_effective_size(TRUE) <= 0.50) && food_can_insert_micro)
		if(!food_inserted_micros)
			food_inserted_micros = list()

		M.forceMove(src)

		food_inserted_micros += M

		to_chat(user, span_warning("You climb into \the [src]."))
		return

	return ..()

/obj/item/reagent_containers/food/drinks/proc/On_Consume(var/mob/living/M, var/mob/user, var/changed = FALSE)
	if(!user)
		user = M

	if(food_inserted_micros && food_inserted_micros.len)
		if(M.can_be_drop_pred && M.food_vore && M.vore_selected)
			for(var/mob/living/F in food_inserted_micros)
				if(!F.can_be_drop_prey || !F.food_vore)
					continue

				if(isanimal(M) && !F.allowmobvore && !M.ckey) //If the one doing the eating is a simple mob controlled by AI, check mob vore prefs
					continue

				var/do_nom = FALSE

				if(!reagents.total_volume)
					do_nom = TRUE
				else
					var/nom_chance = (1 - (reagents.total_volume / volume))*100
					if(prob(nom_chance))
						do_nom = TRUE

				if(do_nom)
					F.forceMove(M.vore_selected)
					food_inserted_micros -= F

	if(!reagents.total_volume && changed)
		M.visible_message(span_notice("[M] finishes drinking \the [src]."),span_notice("You finish drinking \the [src]."))
		if(trash)
			user.drop_from_inventory(src)	//so icons update :[
			if(ispath(trash,/obj/item))
				var/obj/item/TrashItem = new trash(user)
				user.put_in_hands(TrashItem)
			else if(istype(trash,/obj/item))
				user.put_in_hands(trash)
			qdel(src)
	return

/obj/item/reagent_containers/food/drinks/on_rag_wipe(var/obj/item/reagent_containers/glass/rag/R)
	wash(CLEAN_SCRUB)

/obj/item/reagent_containers/food/drinks/attack_self(mob/user as mob)
	if(!is_open_container())
		open(user)

/obj/item/reagent_containers/food/drinks/proc/open(mob/user)
	if(!cant_open)
		playsound(src,"canopen", rand(10,50), 1)
		GLOB.cans_opened_roundstat++
		to_chat(user, span_notice("You open [src] with an audible pop!"))
		flags |= OPENCONTAINER
	else
		to_chat(user, span_warning("...wait a second, this one doesn't have a ring pull. It's not a <b>can</b>, it's a <b>can't!</b>"))
		name = "\improper can't of [initial(name)]"	//don't update the name until they try to open it

/obj/item/reagent_containers/food/drinks/attack(mob/M as mob, mob/user as mob, def_zone)
	if(force && !(flags & NOBLUDGEON) && user.a_intent == I_HURT)
		return ..()

	if(standard_feed_mob(user, M))
		return

	return 0

/obj/item/reagent_containers/food/drinks/afterattack(obj/target, mob/user, proximity)
	if(!proximity) return

	if(standard_dispenser_refill(user, target))
		return
	if(standard_pour_into(user, target))
		return
	return ..()

/obj/item/reagent_containers/food/drinks/standard_feed_mob(var/mob/user, var/mob/target)
	if(!is_open_container())
		to_chat(user, span_notice("You need to open [src]!"))
		return 1
	var/original_volume = reagents.total_volume
	.=..()
	var/changed = !(reagents.total_volume == original_volume)
	On_Consume(target,user,changed)
	return

/obj/item/reagent_containers/food/drinks/standard_dispenser_refill(var/mob/user, var/obj/structure/reagent_dispensers/target)
	if(!is_open_container())
		to_chat(user, span_notice("You need to open [src]!"))
		return 1
	return ..()

/obj/item/reagent_containers/food/drinks/standard_pour_into(var/mob/user, var/atom/target)
	if(!is_open_container())
		to_chat(user, span_notice("You need to open [src]!"))
		return 1
	return ..()

/obj/item/reagent_containers/food/drinks/self_feed_message(var/mob/user)
	if(amount_per_transfer_from_this == volume)	//I wanted to use a switch, but switch statements can't use vars and the maximum volume of containers varies
		to_chat(user, span_notice("You knock back the entire [src] in one go!"))
	else if(amount_per_transfer_from_this <= 4)	//below the standard 5
		to_chat(user, span_notice("You take a modest sip from \the [src]."))
	else if(amount_per_transfer_from_this <= 10)	//the standard five to a bit more
		to_chat(user, span_notice("You swallow a gulp from \the [src]."))
	else if(amount_per_transfer_from_this <= 30)
		to_chat(user, span_notice("You take a long drag from \the [src]."))
	else	//default message as a fallback
		to_chat(user, span_notice("You swallow a gulp from \the [src]."))

/obj/item/reagent_containers/food/drinks/feed_sound(var/mob/user)
	playsound(src, 'sound/items/drink.ogg', rand(10, 50), 1)

/obj/item/reagent_containers/food/drinks/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		if(cant_open)
			. += span_warning("It doesn't have a ring pull!")
		if(food_inserted_micros && food_inserted_micros.len)
			. += span_notice("It has [english_list(food_inserted_micros)] [!reagents?.total_volume ? "sitting" : "floating"] in it.")
		if(!reagents?.total_volume)
			. += span_notice("It is empty!")
		else if (reagents.total_volume <= volume * 0.25)
			. += span_notice("It is almost empty!")
		else if (reagents.total_volume <= volume * 0.66)
			. += span_notice("It is half full!")
		else if (reagents.total_volume <= volume * 0.90)
			. += span_notice("It is almost full!")
		else
			. += span_notice("It is full!")


////////////////////////////////////////////////////////////////////////////////
/// Drinks. END
////////////////////////////////////////////////////////////////////////////////

/obj/item/reagent_containers/food/drinks/golden_cup
	desc = "A golden cup"
	name = "golden cup"
	icon_state = "golden_cup"
	item_state = "" //nope :(
	w_class = ITEMSIZE_LARGE
	force = 14
	throwforce = 10
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = null
	volume = 150
	flags = OPENCONTAINER

/obj/item/reagent_containers/food/drinks/golden_cup/on_reagent_change()
	..()

///////////////////////////////////////////////Drinks
//Notes by Darem: Drinks are simply containers that start preloaded. Unlike condiments, the contents can be ingested directly
//	rather then having to add it to something else first. They should only contain liquids. They have a default container size of 50.
//	Formatting is the same as food.

/obj/item/reagent_containers/food/drinks/milk
	name = "milk carton"
	desc = "It's milk. White and nutritious goodness!"
	description_fluff = "A product of NanoPastures. Who would have thought that cows would thrive in zero-G?"
	icon_state = "milk"
	item_state = "carton"
	center_of_mass_x = 16
	center_of_mass_y = 9
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'

/obj/item/reagent_containers/food/drinks/milk/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_MILK, 50)

/obj/item/reagent_containers/food/drinks/soymilk
	name = "soymilk carton"
	desc = "It's soy milk. White and nutritious goodness!"
	description_fluff = "A product of NanoPastures. For those skeptical that cows can thrive in zero-G."
	icon_state = "soymilk"
	item_state = "carton"
	center_of_mass_x = 16
	center_of_mass_y = 9
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'

/obj/item/reagent_containers/food/drinks/soymilk/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_SOYMILK, 50)

/obj/item/reagent_containers/food/drinks/smallmilk
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

/obj/item/reagent_containers/food/drinks/smallmilk/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_MILK, 30)

/obj/item/reagent_containers/food/drinks/smallchocmilk
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

/obj/item/reagent_containers/food/drinks/smallchocmilk/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_CHOCOLATEMILK, 30)

/obj/item/reagent_containers/food/drinks/coffee
	name = "\improper Robust Coffee"
	desc = "Careful, the beverage you're about to enjoy is extremely hot."
	description_fluff = "Fresh coffee is almost unheard of outside of planets and stations where it is grown. Robust Coffee proudly advertises the six separate times it is freeze-dried during the production process of every cup of instant."
	icon_state = "coffee"
	trash = /obj/item/trash/coffee
	center_of_mass_x = 15
	center_of_mass_y = 10
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'

/obj/item/reagent_containers/food/drinks/coffee/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_COFFEE, 30)

/obj/item/reagent_containers/food/drinks/tea
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

/obj/item/reagent_containers/food/drinks/tea/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_TEA, 30)

/obj/item/reagent_containers/food/drinks/decaf_tea
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

/obj/item/reagent_containers/food/drinks/decaf_tea/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_TEADECAF, 30)

/obj/item/reagent_containers/food/drinks/ice
	name = "cup of ice"
	desc = "Careful, cold ice, do not chew."
	icon_state = "ice"
	center_of_mass_x = 15
	center_of_mass_y = 10
/obj/item/reagent_containers/food/drinks/ice/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_ICE, 30)

/obj/item/reagent_containers/food/drinks/h_chocolate
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

/obj/item/reagent_containers/food/drinks/h_chocolate/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_HOTCOCO, 30)

/obj/item/reagent_containers/food/drinks/greentea
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

/obj/item/reagent_containers/food/drinks/greentea/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_GREENTEA, 30)

/obj/item/reagent_containers/food/drinks/chaitea
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

/obj/item/reagent_containers/food/drinks/chaitea/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_CHAITEA, 30)

/obj/item/reagent_containers/food/drinks/decaf
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

/obj/item/reagent_containers/food/drinks/decaf/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_DECAF, 30)

/obj/item/reagent_containers/food/drinks/dry_ramen
	name = "Cup Ramen"
	desc = "Just add 10ml water, self heats! A taste that reminds you of your school years."
	description_fluff = "Konohagakure Brand Ramen has been an instant meal staple for centuries. Cheap, quick and available in over two hundred varieties - though most taste like artifical chicken."
	icon_state = "ramen"
	trash = /obj/item/trash/ramen
	center_of_mass_x = 16
	center_of_mass_y = 11
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'

/obj/item/reagent_containers/food/drinks/dry_ramen/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_DRYRAMEN, 30)

/obj/item/reagent_containers/food/drinks/sillycup
	name = "paper cup"
	desc = "A paper water cup."
	icon_state = "water_cup_e"
	possible_transfer_amounts = null
	volume = 10
	center_of_mass_x = 16
	center_of_mass_y = 12
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'

/obj/item/reagent_containers/food/drinks/sillycup/Initialize(mapload)
	. = ..()

/obj/item/reagent_containers/food/drinks/sillycup/on_reagent_change()
	..()
	if(reagents.total_volume)
		icon_state = "water_cup"
	else
		icon_state = "water_cup_e"

/obj/item/reagent_containers/food/drinks/sillycup/MouseDrop(obj/over_object as obj)
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

/obj/item/reagent_containers/food/drinks/shaker
	name = "shaker"
	desc = "A metal shaker to mix drinks in."
	icon_state = "shaker"
	amount_per_transfer_from_this = 10
	volume = 120
	center_of_mass_x = 17
	center_of_mass_y = 10

/obj/item/reagent_containers/food/drinks/shaker/on_reagent_change()
	..()

/obj/item/reagent_containers/food/drinks/teapot
	name = "teapot"
	desc = "An elegant teapot. It simply oozes class."
	icon_state = "teapot"
	item_state = "teapot"
	amount_per_transfer_from_this = 10
	volume = 120
	center_of_mass_x = 17
	center_of_mass_y = 7

/obj/item/reagent_containers/food/drinks/teapot/on_reagent_change()
	..()

/obj/item/reagent_containers/food/drinks/flask
	name = "\improper " + JOB_SITE_MANAGER + "'s flask"
	desc = "A metal flask belonging to the " + JOB_SITE_MANAGER

	icon_state = "flask"
	volume = 60
	center_of_mass_x = 17
	center_of_mass_y = 7

/obj/item/reagent_containers/food/drinks/flask/on_reagent_change()
	..()

/obj/item/reagent_containers/food/drinks/flask/shiny
	name = "shiny flask"
	desc = "A shiny metal flask. It appears to have a Greek symbol inscribed on it."
	icon_state = "shinyflask"

/obj/item/reagent_containers/food/drinks/flask/lithium
	name = "lithium flask"
	desc = "A flask with a Lithium Atom symbol on it."
	icon_state = "lithiumflask"

/obj/item/reagent_containers/food/drinks/flask/detflask
	name = "\improper " + JOB_DETECTIVE + "'s flask"
	desc = "A metal flask with a leather band and golden badge belonging to the detective."
	icon_state = "detflask"
	volume = 60
	center_of_mass_x = 17
	center_of_mass_y = 8

/obj/item/reagent_containers/food/drinks/flask/barflask
	name = "flask"
	desc = "For those who can't be bothered to hang out at the bar to drink."
	icon_state = "barflask"
	volume = 60
	center_of_mass_x = 17
	center_of_mass_y = 7

/obj/item/reagent_containers/food/drinks/flask/vacuumflask
	name = "vacuum flask"
	desc = "Keeping your drinks at the perfect temperature since 1892."
	icon_state = "vacuumflask"
	volume = 60
	center_of_mass_x = 15
	center_of_mass_y = 4
