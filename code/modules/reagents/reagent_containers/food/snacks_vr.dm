//I guess we're not always eating PEOPLE.
/*
/obj/item/weapon/reagent_containers/food/snacks/my_new_food
	name = "cheesemeaties"
	desc = "The cheese adds a good flavor. Not great. Just good"
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "cheesemeaties"
	trash = /obj/item/trash/plate //What I leave behind when eaten (waffles instead of plate = bigsquareplate)
	center_of_mass = list("x"=16, "y"=16) //If your thing is too huge and you don't want it in the center.
	nutriment_amt = 5
	nutriment_desc = list("gargonzola" = 2, "burning" = 2)

/obj/item/weapon/reagent_containers/food/snacks/my_new_food/New()
	..()
	reagents.add_reagent("protein", 2) //For meaty things.
	bitesize = 3 //How many reagents to transfer per bite?
*/

/obj/item/weapon/reagent_containers/food/snacks/sliceable/sushi
	name = "sushi roll"
	desc = "A whole sushi roll! Slice it up and enjoy with some soy sauce and wasabi."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "sushi"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/slice/sushi/filled
	slices_num = 5
	nutriment_desc = list("rice" = 5, "fish" = 5)
	nutriment_amt = 15

/obj/item/weapon/reagent_containers/food/snacks/sliceable/sushi/New()
	..()
	reagents.add_reagent("protein", 10)
	bitesize = 5

/obj/item/weapon/reagent_containers/food/snacks/slice/sushi/filled
	name = "piece of sushi"
	desc = "A slice of a larger sushi roll, ready to devour."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "sushi_s"
	bitesize = 5
	whole_path = /obj/item/weapon/reagent_containers/food/snacks/sliceable/sushi

/obj/item/weapon/reagent_containers/food/snacks/slice/sushi/filled/filled
	filled = TRUE


/obj/item/weapon/reagent_containers/food/snacks/lasagna
	name = "lasagna"
	desc = "Meaty, tomato-y, and ready to eat-y. Favorite of cats."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "lasagna"
	nutriment_amt = 5
	nutriment_desc = list("tomato" = 4, "meat" = 2)

/obj/item/weapon/reagent_containers/food/snacks/lasagna/New()
	..()
	reagents.add_reagent("protein", 2) //For meaty things.


/obj/item/weapon/reagent_containers/food/snacks/goulash
	name = "goulash"
	desc = "Paprika put to good use, finally, in a soup of meat and vegitables."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "goulash"
	trash = /obj/item/trash/snack_bowl
	nutriment_amt = 6
	nutriment_desc = list("meat" = 2, "vegitables" = 2, "seasoning" = 5)

/obj/item/weapon/reagent_containers/food/snacks/goulash/New()
	..()
	reagents.add_reagent("protein", 3) //For meaty things.
	reagents.add_reagent("water", 5)


/obj/item/weapon/reagent_containers/food/snacks/donerkebab
	name = "doner kebab"
	desc = "A delicious sandwich-like food from ancient Earth. The meat is typically cooked on a vertical rotisserie."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "doner_kebab"
	nutriment_amt = 5
	nutriment_desc = list("vegitables" = 2, "seasoned meat" = 5)

/obj/item/weapon/reagent_containers/food/snacks/donerkebab/New()
	..()
	reagents.add_reagent("protein", 2) //For meaty things.


/obj/item/weapon/reagent_containers/food/snacks/roastbeef
	name = "roast beef"
	desc = "It's beef. It's roasted. It's been a staple of dining tradition for centuries."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "roastbeef"
	trash = /obj/item/trash/waffles
	nutriment_amt = 8
	nutriment_desc = list("cooked meat" = 5)

/obj/item/weapon/reagent_containers/food/snacks/roastbeef/New()
	..()
	reagents.add_reagent("protein", 4) //For meaty things.
	bitesize = 2


/obj/item/weapon/reagent_containers/food/snacks/reishicup
	name = "reishi's cup"
	desc = "A chocolate treat with an odd flavor."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "reishiscup"
	nutriment_amt = 3
	nutriment_desc = list("chocolate" = 4, "colors" = 2)

/obj/item/weapon/reagent_containers/food/snacks/reishicup/New()
	..()
	reagents.add_reagent("psilocybin", 3)
	bitesize = 6

/obj/item/weapon/storage/box/wings //This is kinda like the donut box.
	name = "wing basket"
	desc = "A basket of chicken wings! Get some before they're all gone! Or maybe you're too late..."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "wings5"
	var/startswith = 5
	max_storage_space = ITEMSIZE_COST_SMALL * 5
	can_hold = list(/obj/item/weapon/reagent_containers/food/snacks/chickenwing)
	foldable = null

/obj/item/weapon/storage/box/wings/New()
	..()
	for(var/i=1 to startswith)
		new /obj/item/weapon/reagent_containers/food/snacks/chickenwing(src)
	update_icon()
	return

/obj/item/weapon/storage/box/wings/update_icon()
	var/i = 0
	for(var/obj/item/weapon/reagent_containers/food/snacks/chickenwing/W in contents)
		i++
	icon_state = "wings[i]"

/obj/item/weapon/reagent_containers/food/snacks/chickenwing
	name = "chicken wing"
	desc = "What flavor even is this? Buffalo? Barbeque? Or something more exotic?"
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "wing"
	nutriment_amt = 2
	nutriment_desc = list("chicken" = 2, "unplacable flavor sauce" = 4)

/obj/item/weapon/reagent_containers/food/snacks/chickenwing/New()
	..()
	reagents.add_reagent("protein", 1)
	bitesize = 3


/obj/item/weapon/reagent_containers/food/snacks/hotandsoursoup
	name = "hot & sour soup"
	desc = "A soup both spicy and sour from ancient Earth cooking traditions. This one is made with tofu."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "hotandsoursoup"
	trash = /obj/item/trash/snack_bowl
	nutriment_amt = 6
	nutriment_desc = list("spicyness" = 4, "sourness" = 4, "tofu" = 1)

/obj/item/weapon/reagent_containers/food/snacks/hotandsoursoup/New()
	..()
	bitesize = 2


/obj/item/weapon/reagent_containers/food/snacks/kitsuneudon
	name = "kitsune udon"
	desc = "A purported favorite of kitsunes in ancient japanese myth: udon noodles, friend egg, and tofu."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "kitsuneudon"
	trash = /obj/item/trash/snack_bowl
	nutriment_amt = 6
	nutriment_desc = list("fried egg" = 2, "egg noodles" = 4)

/obj/item/weapon/reagent_containers/food/snacks/kitsuneudon/New()
	..()
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/generalschicken
	name = "general's chicken"
	desc = "Sweet, spicy, and fried. General's Chicken has been around for more than five-hundred years now, and still tastes good."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "generaltso"
	trash = /obj/item/trash/plate
	nutriment_amt = 6
	nutriment_desc = list("sweet and spicy sauce" = 5, "chicken" = 3)

/obj/item/weapon/reagent_containers/food/snacks/generalschicken/New()
	..()
	reagents.add_reagent("protein", 4)
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/monkeycube/sobakacube
	name = "sobaka cube"
	monkey_type = "Sobaka"

/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/sobakacube
	name = "sobaka cube"
	monkey_type = "Sobaka"

/obj/item/weapon/reagent_containers/food/snacks/monkeycube/sarucube
	name = "saru cube"
	monkey_type = "Saru"

/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/sarucube
	name = "saru cube"
	monkey_type = "Saru"

/obj/item/weapon/reagent_containers/food/snacks/monkeycube/sparracube
	name = "sparra cube"
	monkey_type = "Sparra"

/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/sparracube
	name = "sparra cube"
	monkey_type = "Sparra"

/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wolpincube
	name = "wolpin cube"
	monkey_type = "Wolpin"

/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/wolpincube
	name = "wolpin cube"
	monkey_type = "Wolpin"
