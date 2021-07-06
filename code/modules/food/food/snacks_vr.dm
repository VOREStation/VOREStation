//I guess we're not always eating PEOPLE.
/obj/item/weapon/reagent_containers/food/snacks/sliceable/sushi
	name = "sushi roll"
	desc = "A whole sushi roll! Slice it up and enjoy with some soy sauce and wasabi."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "sushi"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/slice/sushi/filled
	slices_num = 5
	nutriment_desc = list("rice" = 5, "fish" = 5)
	nutriment_amt = 15

/obj/item/weapon/reagent_containers/food/snacks/sliceable/sushi/Initialize()
	. = ..()
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

/obj/item/weapon/reagent_containers/food/snacks/goulash
	name = "goulash"
	desc = "Paprika put to good use, finally, in a soup of meat and vegetables."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "goulash"
	trash = /obj/item/trash/snack_bowl
	nutriment_amt = 6
	nutriment_desc = list("meat" = 2, "vegetables" = 2, "seasoning" = 5)

/obj/item/weapon/reagent_containers/food/snacks/goulash/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3) //For meaty things.
	reagents.add_reagent("water", 5)


/obj/item/weapon/reagent_containers/food/snacks/donerkebab
	name = "doner kebab"
	desc = "A delicious sandwich-like food from ancient Earth. The meat is typically cooked on a vertical rotisserie."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "doner_kebab"
	nutriment_amt = 5
	nutriment_desc = list("vegetables" = 2, "seasoned meat" = 5)

/obj/item/weapon/reagent_containers/food/snacks/donerkebab/Initialize()
	. = ..()
	reagents.add_reagent("protein", 2) //For meaty things.


/obj/item/weapon/reagent_containers/food/snacks/roastbeef
	name = "roast beef"
	desc = "It's beef. It's roasted. It's been a staple of dining tradition for centuries."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "roastbeef"
	trash = /obj/item/trash/plate
	nutriment_amt = 8
	nutriment_desc = list("cooked meat" = 5)

/obj/item/weapon/reagent_containers/food/snacks/roastbeef/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4) //For meaty things.
	bitesize = 2


/obj/item/weapon/reagent_containers/food/snacks/reishicup
	name = "reishi's cup"
	desc = "A chocolate treat with an odd flavor."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "reishiscup"
	nutriment_amt = 3
	nutriment_desc = list("chocolate" = 4, "colors" = 2)

/obj/item/weapon/reagent_containers/food/snacks/reishicup/Initialize()
	. = ..()
	reagents.add_reagent("psilocybin", 3)
	bitesize = 6

/obj/item/weapon/storage/box/wings //This is kinda like the donut box.
	name = "wing basket"
	desc = "A basket of chicken wings! Get some before they're all gone! Or maybe you're too late..."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "wings5"
	var/icon_base = "wings"
	var/startswith = 5
	max_storage_space = ITEMSIZE_COST_SMALL * 5
	can_hold = list(/obj/item/weapon/reagent_containers/food/snacks/chickenwing)
	starts_with = list(
		/obj/item/weapon/reagent_containers/food/snacks/chickenwing = 5
	)
	foldable = null

/obj/item/weapon/storage/box/wings/Initialize()
	. = ..()
	update_icon()
	return

/obj/item/weapon/storage/box/wings/update_icon()
	var/i = 0
	for(var/obj/item/weapon/reagent_containers/food/snacks/W in contents)
		i++
	icon_state = "[icon_base][i]"

/obj/item/weapon/reagent_containers/food/snacks/chickenwing
	name = "chicken wing"
	desc = "What flavor even is this? Buffalo? Barbecue? Or something more exotic?"
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "wing"
	nutriment_amt = 2
	nutriment_desc = list("chicken" = 2, "unplacable flavor sauce" = 4)

/obj/item/weapon/reagent_containers/food/snacks/chickenwing/Initialize()
	. = ..()
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

/obj/item/weapon/reagent_containers/food/snacks/hotandsoursoup/Initialize()
	. = ..()
	bitesize = 2


/obj/item/weapon/reagent_containers/food/snacks/kitsuneudon
	name = "kitsune udon"
	desc = "A purported favorite of kitsunes in ancient japanese myth: udon noodles, fried egg, and tofu."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "kitsuneudon"
	trash = /obj/item/trash/snack_bowl
	nutriment_amt = 6
	nutriment_desc = list("fried egg" = 2, "egg noodles" = 4)

/obj/item/weapon/reagent_containers/food/snacks/kitsuneudon/Initialize()
	. = ..()
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/generalschicken
	name = "general's chicken"
	desc = "Sweet, spicy, and fried. General's Chicken has been around for more than five-hundred years now, and still tastes good."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "generaltso"
	trash = /obj/item/trash/plate
	nutriment_amt = 6
	nutriment_desc = list("sweet and spicy sauce" = 5, "chicken" = 3)

/obj/item/weapon/reagent_containers/food/snacks/generalschicken/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4)
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/meat/grubmeat
	name = "grubmeat"
	desc = "A slab of grub meat, it gives a gentle shock if you touch it"
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "grubmeat"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/weapon/reagent_containers/food/snacks/meat/grubmeat/Initialize()
	. = ..()
	reagents.add_reagent("protein", 1)
	reagents.add_reagent("shockchem", 6)
	bitesize = 6

/obj/item/weapon/reagent_containers/food/snacks/bugball
	name = "bugball"
	desc = "A hard piece of chitin, don't chip a tooth!"
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "pillbugball"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/pillbug
	slices_num = 1
	trash = /obj/item/weapon/reagent_containers/food/snacks/pillbug
	nutriment_amt = 1
	nutriment_desc = list("crunchy shell bits" = 5)

/obj/item/weapon/reagent_containers/food/snacks/bugball/Initialize()
	. = ..()
	reagents.add_reagent("protein", 1)
	reagents.add_reagent("carbon", 5)
	bitesize = 7

/obj/item/weapon/reagent_containers/food/snacks/pillbug
	name = "pillbug"
	desc = "A delicacy discovered and popularized by a famous restaurant called Mudca's Meat Hut."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "pillbug"
	trash = /obj/item/weapon/reagent_containers/food/snacks/pillbugempty
	nutriment_amt = 3
	nutriment_desc = list("sparkles" = 5, "ancient inca culture" =3)

/obj/item/weapon/reagent_containers/food/snacks/pillbug/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3)
	reagents.add_reagent("shockchem", 6)
	bitesize = 6

/obj/item/weapon/reagent_containers/food/snacks/pillbugempty
	name = "pillbug shell"
	desc = "Waste not, want not."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "pillbugempty"
	nutriment_amt = 1
	nutriment_desc = list("crunchy shell bits" = 5)

/obj/item/weapon/reagent_containers/food/snacks/pillbug/Initialize()
	. = ..()
	reagents.add_reagent("protein", 1)
	reagents.add_reagent("carbon", 5)
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/mammi
	name = "mämmi"
	desc = "Traditional finnish desert, some like it, others don't. It's drifting in some milk, add sugar!"
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "mammi"
	trash = /obj/item/trash/plate
	nutriment_amt = 3
	nutriment_desc = list("brothy sweet goodness" = 5)

/obj/item/weapon/reagent_containers/food/snacks/mammi/Initialize()
	. = ..()
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/makaroni
	name = "makaronilaatikko"
	desc = "A special kind of macaroni, it's a big dish, and this one has special meat in it."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "makaroni"
	trash = /obj/item/trash/plate
	nutriment_amt = 15
	nutriment_desc = list("Cheese" = 5, "eggs" = 3, "pasta" = 4, "sparkles" = 3)

/obj/item/weapon/reagent_containers/food/snacks/makaroni/Initialize()
	. = ..()
	reagents.add_reagent("protein", 1)
	reagents.add_reagent("shockchem", 6)
	bitesize = 7

/obj/item/weapon/reagent_containers/food/snacks/lobster
	name = "raw lobster"
	desc = "A shifty lobster. You can try eating it, but its shell is extremely tough."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "lobster_raw"
	nutriment_amt = 5

/obj/item/weapon/reagent_containers/food/snacks/lobster/Initialize()
	. = ..()
	bitesize = 0.1

/obj/item/weapon/reagent_containers/food/snacks/lobstercooked
	name = "cooked lobster"
	desc = "A luxurious plate of cooked lobster, its taste accentuated by lemon juice. Reinvigorating!"
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "lobster_cooked"
	trash = /obj/item/trash/plate
	nutriment_amt = 20
	nutriment_desc = list("lemon" = 2, "lobster" = 5, "salad" = 2)

/obj/item/weapon/reagent_containers/food/snacks/lobstercooked/Initialize()
	. = ..()
	bitesize = 5
	reagents.add_reagent("protein", 20)
	reagents.add_reagent("tricordrazine", 5)
	reagents.add_reagent("iron", 5)

/obj/item/weapon/reagent_containers/food/snacks/cuttlefish
	name = "raw cuttlefish"
	desc = "It's an adorable squid! You couldn't possibly be thinking about eating this, right?"
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "cuttlefish_raw"
	nutriment_amt = 5

/obj/item/weapon/reagent_containers/food/snacks/cuttlefish/Initialize()
	. = ..()
	bitesize = 10

/obj/item/weapon/reagent_containers/food/snacks/cuttlefishcooked
	name = "cooked cuttlefish"
	desc = "It's a roasted cuttlefish. Rubbery, squishy, an acquired taste."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "cuttlefish_cooked"
	nutriment_amt = 20
	nutriment_desc = list("cuttlefish" = 5, "rubber" = 5, "grease" = 1)

/obj/item/weapon/reagent_containers/food/snacks/cuttlefishcooked/Initialize()
	. = ..()
	bitesize = 5
	reagents.add_reagent("protein", 10)

/obj/item/weapon/reagent_containers/food/snacks/sliceable/monkfish
	name = "extra large monkfish"
	desc = "It's a huge monkfish. Better clean it first, you can't possibly eat it like this."
	icon = 'icons/obj/food48x48_vr.dmi'
	icon_state = "monkfish_raw"
	nutriment_amt = 30
	w_class = ITEMSIZE_HUGE //Is that a monkfish in your pocket, or are you just happy to see me?
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/monkfishfillet
	slices_num = 6
	trash = /obj/item/weapon/reagent_containers/food/snacks/sliceable/monkfishremains

/obj/item/weapon/reagent_containers/food/snacks/sliceable/monkfish/Initialize()
	. = ..()
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/monkfishfillet
	name = "monkfish fillet"
	desc = "It's a fillet sliced from a monkfish."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "monkfish_fillet"
	nutriment_amt = 5

/obj/item/weapon/reagent_containers/food/snacks/monkfishfillet/Initialize()
	. = ..()
	bitesize = 3
	reagents.add_reagent("protein", 1)

/obj/item/weapon/reagent_containers/food/snacks/monkfishcooked
	name = "seasoned monkfish"
	desc = "A delicious slice of monkfish prepared with sweet chili and spring onion."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "monkfish_cooked"
	nutriment_amt = 10
	nutriment_desc = list("fish" = 3, "oil" = 1, "sweet chili" = 3, "spring onion" = 2)
	trash = /obj/item/trash/fancyplate

/obj/item/weapon/reagent_containers/food/snacks/monkfishcooked/Initialize()
	. = ..()
	bitesize = 4
	reagents.add_reagent("protein", 5)

/obj/item/weapon/reagent_containers/food/snacks/sliceable/monkfishremains
	name = "monkfish remains"
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "monkfish_remains"
	desc = "The work of a madman."
	w_class = ITEMSIZE_LARGE
	nutriment_amt = 10
	slice_path = /obj/item/clothing/head/fish
	slices_num = 1

/obj/item/weapon/reagent_containers/food/snacks/sliceable/monkfishremains/Initialize()
	. = ..()
	bitesize = 0.01 //impossible to eat
	reagents.add_reagent("carbon", 5)

/obj/item/weapon/reagent_containers/food/snacks/sliceable/sharkchunk
	name = "chunk of shark meat"
	desc = "Still rough, needs to be cut into even smaller chunks."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "sharkmeat_chunk"
	nutriment_amt = 15
	w_class = ITEMSIZE_LARGE
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/carpmeat/fish/sharkmeat
	slices_num = 5

/obj/item/weapon/reagent_containers/food/snacks/sliceable/sharkchunk/Initialize()
	. = ..()
	bitesize = 3
	reagents.add_reagent("protein", 20)

/obj/item/weapon/reagent_containers/food/snacks/carpmeat/fish/sharkmeat
	name = "slice of sharkmeat"
	desc = "Now it's small enough to cook with."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "sharkmeat"
	nutriment_amt = 2
	toxin_amount = null

/obj/item/weapon/reagent_containers/food/snacks/carpmeat/fish/sharkmeat/Initialize()
	. = ..()
	bitesize = 3
	reagents.add_reagent("protein", 2)

/obj/item/weapon/reagent_containers/food/snacks/sharkmeatcooked
	name = "shark steak"
	desc = "Finally, some food for real men."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "sharkmeat_cooked"
	nutriment_amt = 5
	trash = /obj/item/trash/plate
	nutriment_desc = list("manliness" = 1, "fish oil" = 2, "shark" = 2)

/obj/item/weapon/reagent_containers/food/snacks/sharkmeatcooked/Initialize()
	. = ..()
	bitesize = 3
	reagents.add_reagent("protein", 8)

/obj/item/weapon/reagent_containers/food/snacks/sharkmeatdip
	name = "hot shark shank"
	desc = "A shank of shark meat dipped in hot sauce."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "sharkmeat_dip"
	nutriment_amt = 5
	trash = /obj/item/trash/snack_bowl
	nutriment_desc = list("salt" = 1, "fish oil" = 2, "spicy shark" = 2)

/obj/item/weapon/reagent_containers/food/snacks/sharkmeatdip/Initialize()
	. = ..()
	bitesize = 3
	reagents.add_reagent("capsaicin", 4)
	reagents.add_reagent("protein", 4)

/obj/item/weapon/reagent_containers/food/snacks/sharkmeatcubes
	name = "shark cubes"
	desc = "Foul scented fermented shark cubes, it's said to make men fly, or just make them really fat."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "sharkmeat_cubes"
	nutriment_amt = 8
	trash = /obj/item/trash/plate
	nutriment_desc = list("viking spirit" = 1, "rot" = 2, "fermented sauce" = 2)

/obj/item/weapon/reagent_containers/food/snacks/sharkmeatcubes/Initialize()
	. = ..()
	bitesize = 10
	reagents.add_reagent("potatojuice", 30) // for people who want to get fat, FAST.

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

// food cubes
/obj/item/weapon/reagent_containers/food/snacks/cube
	name = "protein cube"
	desc = "A colony of meat cells, Just add water!"
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "proteincube"
	w_class = ITEMSIZE_TINY
	flags = OPENCONTAINER
	bitesize = 12
	filling_color = "#ADAC7F"
	center_of_mass = list("x"=16, "y"=14)

	var/food_type = "/obj/item/weapon/reagent_containers/food/snacks/proteinslab"

/obj/item/weapon/reagent_containers/food/snacks/cube/Initialize()
	. = ..()

/obj/item/weapon/reagent_containers/food/snacks/cube/proc/Expand()
	src.visible_message("<b>\The [src]</b> expands!")
	new food_type(get_turf(src))
	qdel(src)

/obj/item/weapon/reagent_containers/food/snacks/cube/on_reagent_change()
	if(reagents.has_reagent("water"))
		Expand()

/obj/item/weapon/reagent_containers/food/snacks/cube/protein

/obj/item/weapon/reagent_containers/food/snacks/cube/protein/Initialize()
	. = ..()
	reagents.add_reagent("meatcolony", 5)

/obj/item/weapon/reagent_containers/food/snacks/proteinslab
	name = "Protein slab"
	desc = "A slab of near pure protein, extremely artificial, and thoroughly disgusting."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "proteinslab"
	bitesize = 10
	nutriment_amt = 5
	nutriment_desc = list("bitter chyme" = 50)

/obj/item/weapon/reagent_containers/food/snacks/proteinslab/Initialize()
	. = ..()
	reagents.add_reagent("protein", 30)

/obj/item/weapon/reagent_containers/food/snacks/cube/nutriment
	name = "Nutriment cube"
	desc = "A colony of plant cells, Just add water!"
	icon_state = "nutrimentcube"
	food_type = "/obj/item/weapon/reagent_containers/food/snacks/nutrimentslab"

/obj/item/weapon/reagent_containers/food/snacks/cube/nutriment/Initialize()
	. = ..()
	reagents.add_reagent("plantcolony", 5)

/obj/item/weapon/reagent_containers/food/snacks/nutrimentslab
	name = "Nutriment slab"
	desc = "A slab of near pure plant-based nutrients, extremely artificial, and thoroughly disgusting."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "nutrimentslab"
	bitesize = 10
	nutriment_amt = 20
	nutriment_desc = list("compost" = 50)

/obj/item/weapon/storage/box/wings/tray //Might as well re-use this code.
	name = "ration cube tray"
	desc = "A tray of food cubes, the label warns not to consume before adding water or mixing with virusfood."
	icon_state = "tray8"
	icon_base = "tray"
	startswith = 8
	w_class = ITEMSIZE_SMALL
	max_storage_space = ITEMSIZE_COST_TINY * 8
	starts_with = list(
		/obj/item/weapon/reagent_containers/food/snacks/cube/protein = 4,
		/obj/item/weapon/reagent_containers/food/snacks/cube/nutriment = 4
	)
	can_hold = list(/obj/item/weapon/reagent_containers/food/snacks/cube/protein,
					/obj/item/weapon/reagent_containers/food/snacks/cube/nutriment)

/obj/item/weapon/reagent_containers/food/snacks/carpmeat/sif //Making fish meat non-toxic!  As advised by Ascian!
	toxin_type = null
	toxin_amount = null

/obj/item/weapon/reagent_containers/food/snacks/carpmeat/sif/murkfish
	toxin_type = null

/obj/item/weapon/reagent_containers/food/snacks/carpmeat/fish
	toxin_type = null
	toxin_amount = null

/obj/item/weapon/reagent_containers/food/snacks/honeybun
	name = "Honeybun"
	desc = "A delicious and sweet treat made with honey instead of sugar. On the sticky side."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "honeybun"
	bitesize = 2
	nutriment_amt = 4
	nutriment_desc = list("honey" = 2, "pastry" = 1)

/obj/item/weapon/reagent_containers/food/snacks/bun/Initialize()
	. = ..()

//Readded Polaris Foods
/obj/item/weapon/reagent_containers/food/snacks/nachos
	name = "nachos"
	desc = "Chips from Old Mexico."
	icon_state = "nachos"
	nutriment_amt = 2
	nutriment_desc = list("salt" = 1)

/obj/item/weapon/reagent_containers/food/snacks/nachos/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 1)
	bitesize = 1

/obj/item/weapon/reagent_containers/food/snacks/cheesenachos
	name = "cheesy nachos"
	desc = "The delicious combination of nachos and melting cheese."
	icon_state = "cheesenachos"
	nutriment_amt = 5
	nutriment_desc = list("salt" = 2, "cheese" = 3)

/obj/item/weapon/reagent_containers/food/snacks/cheesenachos/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 5)
	reagents.add_reagent("protein", 2)
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/onionsoup
	name = "Onion Soup"
	desc = "A soup with layers."
	icon_state = "onionsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#E0C367"
	center_of_mass = list("x"=16, "y"=7)
	nutriment_amt = 5
	nutriment_desc = list("onion" = 2, "soup" = 2)

/obj/item/weapon/reagent_containers/food/snacks/onionsoup/Initialize()
	. = ..()
	bitesize = 3

//Fennec foods
/obj/item/weapon/storage/box/wings/bucket
	name = "Bucket o' grubs"
	desc = "A bucket full of writhing grubs."
	icon_state = "bucket6"
	icon_base = "bucket"
	startswith = 6
	w_class = ITEMSIZE_LARGE
	max_storage_space = ITEMSIZE_COST_SMALL * 6
	starts_with = list(
		/obj/item/weapon/reagent_containers/food/snacks/grub = 6
	)
	can_hold = list(/obj/item/weapon/reagent_containers/food/snacks/grub)

/obj/item/weapon/reagent_containers/food/snacks/grub
	name = "grub"
	desc = "A still writhing grub, soft and squishy."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "grub"
	nutriment_amt = 3
	nutriment_desc = list("goo" = 1, "slime" = 1)

/obj/item/weapon/reagent_containers/food/snacks/grub/Initialize()
	. = ..()
	reagents.add_reagent("protein", 2)
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/grub_pink
	name = "pink candy grub"
	desc = "A thoroughly candied grub, it smells of raspberry."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "grub_pink"
	nutriment_amt = 5
	nutriment_desc = list("raspberry" = 4, "goo" = 1)

/obj/item/weapon/reagent_containers/food/snacks/grub_pink/Initialize()
	. = ..()
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/grub_purple
	name = "pink candy grub"
	desc = "A thoroughly candied grub, it smells of grape."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "grub_purple"
	nutriment_amt = 5
	nutriment_desc = list("grape" = 4, "goo" = 1)

/obj/item/weapon/reagent_containers/food/snacks/grub_purple/Initialize()
	. = ..()
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/grub_blue
	name = "pink candy grub"
	desc = "A thoroughly candied grub, it smells of blueberry."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "grub_blue"
	nutriment_amt = 5
	nutriment_desc = list("blueberry" = 4, "goo" = 1)

/obj/item/weapon/reagent_containers/food/snacks/grub_blue/Initialize()
	. = ..()
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/scorpion
	name = "scorpion"
	desc = "A scorpion from the sandy deserts, don't get stung!"
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "scorpion"
	nutriment_amt = 8
	nutriment_desc = list("crunchy" = 4, "shell bits" = 1)

/obj/item/weapon/reagent_containers/food/snacks/scorpion/Initialize()
	. = ..()
	bitesize = 1

/obj/item/weapon/reagent_containers/food/snacks/scorpion_cooked
	name = "cooked scorpion"
	desc = "A scorpion. Baked nice and crispy."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "scorpion_cooked"
	nutriment_amt = 6
	nutriment_desc = list("crispy" = 4, "exotic meat" = 1)

/obj/item/weapon/reagent_containers/food/snacks/scorpion_cooked/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 2)
	reagents.add_reagent("protein", 4)
	bitesize = 4

/obj/item/weapon/reagent_containers/food/snacks/ant
	name = "giant honey ant"
	desc = "A sweetly scented honey ant. It has a huge swollen abdomen full of yummy."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "honeyant"
	nutriment_amt = 2
	nutriment_desc = list("crunchy" = 1, "goo" = 1)
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/antball
	slices_num = 1

/obj/item/weapon/reagent_containers/food/snacks/ant/Initialize()
	. = ..()
	reagents.add_reagent("honey", 2)
	reagents.add_reagent("protein", 3)
	bitesize = 1

/obj/item/weapon/reagent_containers/food/snacks/antball
	name = "giant honey ball"
	desc = "A sweetly scented honey ball, minus the ant. For those who don't like bug bits between their teeth."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "honeyant_clean"
	nutriment_amt = 4
	nutriment_desc = list("goo" = 1)

/obj/item/weapon/reagent_containers/food/snacks/antball/Initialize()
	. = ..()
	reagents.add_reagent("honey", 2)
	bitesize = 1

/obj/item/weapon/reagent_containers/food/snacks/honey_candy
	name = "honey candy"
	desc = "A clever mimicry of a honey ant abdomen, but it's just a piece of candy. Does not contain actual honey!"
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "candy_honey"
	nutriment_amt = 4
	nutriment_desc = list("goo" = 1, "honey" = 1)
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/antball
	slices_num = 1

/obj/item/weapon/reagent_containers/food/snacks/honey_candy/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 2)
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/locust
	name = "yellow jacket locust"
	desc = "A vibrant bug that looks like a wasp, but is in fact a locust. Crunchy."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "locust"
	nutriment_amt = 4
	nutriment_desc = list("crunchy" = 1, "goo" = 1)

/obj/item/weapon/reagent_containers/food/snacks/locust/Initialize()
	. = ..()
	reagents.add_reagent("protein", 1)
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/locust_cooked
	name = "fried locust"
	desc = "A fried locust, extremely crunchy."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "locust_cooked"
	nutriment_amt = 2
	nutriment_desc = list("crunchy" = 4)

/obj/item/weapon/reagent_containers/food/snacks/locust_cooked/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3)
	bitesize = 2
