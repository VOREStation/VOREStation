/obj/item/reagent_containers/food/snacks/meat
	name = "meat"
	desc = "A slab of meat."
	icon_state = "meat"
	health = 180
	filling_color = "#FF1C1C"
	center_of_mass = list("x"=16, "y"=14)

/obj/item/reagent_containers/food/snacks/meat/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)
	reagents.add_reagent("triglyceride", 2)
	src.bitesize = 1.5

/obj/item/reagent_containers/food/snacks/meat/cook()

	if (!isnull(cooked_icon))
		icon_state = cooked_icon
		flat_icon = null //Force regenating the flat icon for coatings, since we've changed the icon of the thing being coated
	..()

	if (name == initial(name))
		name = "cooked [name]"

/obj/item/reagent_containers/food/snacks/meat/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/material/knife))
		new /obj/item/reagent_containers/food/snacks/rawcutlet(src)
		new /obj/item/reagent_containers/food/snacks/rawcutlet(src)
		new /obj/item/reagent_containers/food/snacks/rawcutlet(src)
		to_chat(user, "You cut the meat into thin strips.")
		qdel(src)
	else
		..()

/obj/item/reagent_containers/food/snacks/meat/syntiflesh
	name = "synthetic meat"
	desc = "A synthetic slab of flesh."

// Seperate definitions because some food likes to know if it's human.
// TODO: rewrite kitchen code to check a var on the meat item so we can remove
// all these sybtypes.
/obj/item/reagent_containers/food/snacks/meat/human
/obj/item/reagent_containers/food/snacks/meat/monkey
	//same as plain meat

/obj/item/reagent_containers/food/snacks/meat/corgi
	name = "dogmeat"
	desc = "Tastes like... well, you know."

/obj/item/reagent_containers/food/snacks/meat/chicken
	name = "poultry"
	icon_state = "chickenbreast"
	cooked_icon = "chickensteak"
	filling_color = "#BBBBAA"

/obj/item/reagent_containers/food/snacks/meat/chicken/Initialize()
	. = ..()
	reagents.remove_reagent("triglyceride", INFINITY)
	//Chicken is low fat. Less total calories than other meats

/obj/item/reagent_containers/food/snacks/crabmeat
	name = "crustacean legs"
	desc = "... Coffee? Is that you?"
	icon_state = "crabmeat"
	bitesize = 1

/obj/item/reagent_containers/food/snacks/crabmeat/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 2)

/obj/item/reagent_containers/food/snacks/hugemushroomslice
	name = "fungus slice"
	desc = "A slice from a huge mushroom."
	icon_state = "hugemushroomslice"
	filling_color = "#E0D7C5"
	center_of_mass = list("x"=17, "y"=16)
	nutriment_amt = 3
	nutriment_desc = list("raw" = 2, "mushroom" = 2)
	bitesize = 6

/obj/item/reagent_containers/food/snacks/hugemushroomslice/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_PSILOCYBIN, 3)

/obj/item/reagent_containers/food/snacks/tomatomeat
	name = "tomato slice"
	desc = "A slice from a huge tomato"
	icon_state = "tomatomeat"
	filling_color = "#DB0000"
	center_of_mass = list("x"=17, "y"=16)
	nutriment_amt = 3
	nutriment_desc = list("raw" = 2, "tomato" = 3)
	bitesize = 6

/obj/item/reagent_containers/food/snacks/bearmeat
	name = "bearmeat"
	desc = "A very manly slab of meat."
	icon_state = "bearmeat"
	filling_color = "#DB0000"
	center_of_mass = list("x"=16, "y"=10)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/bearmeat/Initialize()
	. = ..()
	reagents.add_reagent("protein", 12)
	reagents.add_reagent("hyperzine", 5)

/obj/item/reagent_containers/food/snacks/xenomeat
	name = "xenomeat"
	desc = "A slab of green meat. Smells like acid."
	icon_state = "xenomeat"
	filling_color = "#43DE18"
	center_of_mass = list("x"=16, "y"=10)
	bitesize = 6

/obj/item/reagent_containers/food/snacks/xenomeat/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)
	reagents.add_reagent(REAGENT_ID_PACID,6)

/obj/item/reagent_containers/food/snacks/xenomeat/spidermeat // Substitute for recipes requiring xeno meat.
	name = "insect meat"
	desc = "A slab of green meat."
	icon_state = "xenomeat"
	filling_color = "#43DE18"
	center_of_mass = list("x"=16, "y"=10)
	bitesize = 6

/obj/item/reagent_containers/food/snacks/xenomeat/spidermeat/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_SPIDERTOXIN,6)
	reagents.remove_reagent(REAGENT_ID_PACID,6)

/obj/item/reagent_containers/food/snacks/rawturkey
	name = "raw turkey"
	desc = "Naked and hollow."
	icon_state = "rawturkey"
	bitesize = 2.5

/obj/item/reagent_containers/food/snacks/rawturkey/Initialize()
	. = ..()
	reagents.add_reagent("protein", 10)

/obj/item/reagent_containers/food/snacks/meat/fox
	name = "foxmeat"
	desc = "The fox doesn't say a goddamn thing, now."

/obj/item/reagent_containers/food/snacks/meat/grubmeat
	name = "grubmeat"
	desc = "A slab of grub meat, it gives a gentle shock if you touch it"
	icon = 'icons/obj/food.dmi'
	icon_state = "grubmeat"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/snacks/meat/grubmeat/Initialize()
	. = ..()
	reagents.add_reagent("protein", 1)
	reagents.add_reagent(REAGENT_ID_SHOCKCHEM, 6)
	bitesize = 6

/obj/item/reagent_containers/food/snacks/meat/worm
	name = "weird meat"
	desc = "A chunk of pulsating meat."
	icon_state = "wormmeat"
	health = 180
	filling_color = "#551A8B"
	center_of_mass = list("x"=16, "y"=14)

/obj/item/reagent_containers/food/snacks/meat/worm/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)
	reagents.add_reagent(REAGENT_ID_PHORON, 3)
	reagents.add_reagent("myelamine", 3)
	src.bitesize = 3

/obj/item/reagent_containers/food/snacks/meat/worm/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/material/knife))
		var/to_spawn = pickweight(/obj/random/junk = 30,
		/obj/random/trash = 30,
		/obj/random/maintenance/clean = 15,
		/obj/random/tool = 15,
		/obj/random/medical = 3,
		/obj/random/bomb_supply = 7,
		/obj/random/contraband = 3,
		/obj/random/unidentified_medicine/old_medicine = 7,
		/obj/item/strangerock = 3,
		/obj/item/ore/phoron = 7,
		/obj/random/handgun = 1,
		/obj/random/toolbox = 4,
		/obj/random/drinkbottle = 5
		)

		new to_spawn(get_turf(src))

		if(prob(20))
			user.visible_message(span_alien("Something oozes out of \the [src] as it is cut."))

		to_chat(user, span_alien("You cut the tissue holding the chunks together."))

	..()
