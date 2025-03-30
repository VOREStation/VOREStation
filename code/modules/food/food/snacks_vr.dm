//I guess we're not always eating PEOPLE.
/obj/item/reagent_containers/food/snacks/sliceable/sushi
	name = "sushi roll"
	desc = "A whole sushi roll! Slice it up and enjoy with some soy sauce and wasabi."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "sushi"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/sushi/filled
	slices_num = 5
	nutriment_desc = list(REAGENT_ID_RICE = 5, "fish" = 5)
	nutriment_amt = 15

/obj/item/reagent_containers/food/snacks/sliceable/sushi/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_PROTEIN, 10)
	bitesize = 5

/obj/item/reagent_containers/food/snacks/slice/sushi/filled
	name = "stuffed sushi roll"
	name = "piece of sushi"
	desc = "A slice of a larger sushi roll, ready to devour."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "sushi_s"
	bitesize = 5
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/sushi

/obj/item/reagent_containers/food/snacks/slice/sushi/filled/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/goulash
	name = "goulash"
	desc = "Paprika put to good use, finally, in a soup of meat and vegetables."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "goulash"
	trash = /obj/item/trash/snack_bowl
	nutriment_amt = 6
	nutriment_desc = list("meat" = 2, "vegetables" = 2, "seasoning" = 5)
	eating_sound = 'sound/items/drink.ogg'

/obj/item/reagent_containers/food/snacks/goulash/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_PROTEIN, 3) //For meaty things.
	reagents.add_reagent(REAGENT_ID_WATER, 5)


/obj/item/reagent_containers/food/snacks/donerkebab
	name = "doner kebab"
	desc = "A delicious sandwich-like food from ancient Earth. The meat is typically cooked on a vertical rotisserie."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "doner_kebab"
	nutriment_amt = 5
	nutriment_desc = list("vegetables" = 2, "seasoned meat" = 5)

/obj/item/reagent_containers/food/snacks/donerkebab/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_PROTEIN, 2) //For meaty things.


/obj/item/reagent_containers/food/snacks/roastbeef
	name = "roast beef"
	desc = "It's beef. It's roasted. It's been a staple of dining tradition for centuries."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "roastbeef"
	trash = /obj/item/trash/plate
	nutriment_amt = 8
	nutriment_desc = list("cooked meat" = 5)

/obj/item/reagent_containers/food/snacks/roastbeef/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_PROTEIN, 4) //For meaty things.
	bitesize = 2


/obj/item/reagent_containers/food/snacks/reishicup
	name = "reishi's cup"
	desc = "A chocolate treat with an odd flavor."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "reishiscup"
	nutriment_amt = 3
	nutriment_desc = list(REAGENT_ID_CHOCOLATE = 4, "colors" = 2)

/obj/item/reagent_containers/food/snacks/reishicup/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_PSILOCYBIN, 3)
	bitesize = 6

/obj/item/storage/box/wings //This is kinda like the donut box.
	name = "wing basket"
	desc = "A basket of chicken wings! Get some before they're all gone! Or maybe you're too late..."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "wings5"
	var/icon_base = "wings"
	var/startswith = 5
	max_storage_space = ITEMSIZE_COST_SMALL * 5
	can_hold = list(/obj/item/reagent_containers/food/snacks/chickenwing)
	starts_with = list(
		/obj/item/reagent_containers/food/snacks/chickenwing = 5
	)
	foldable = null

/obj/item/storage/box/wings/Initialize(mapload)
	. = ..()
	update_icon()
	return

/obj/item/storage/box/wings/update_icon()
	var/i = 0
	for(var/obj/item/reagent_containers/food/snacks/W in contents)
		i++
	icon_state = "[icon_base][i]"

/obj/item/reagent_containers/food/snacks/chickenwing
	name = "chicken wing"
	desc = "What flavor even is this? Buffalo? Barbecue? Or something more exotic?"
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "wing"
	nutriment_amt = 2
	nutriment_desc = list("chicken" = 2, "unplacable flavor sauce" = 4)

/obj/item/reagent_containers/food/snacks/chickenwing/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_PROTEIN, 1)
	bitesize = 3


/obj/item/reagent_containers/food/snacks/hotandsoursoup
	name = "hot & sour soup"
	desc = "A soup both spicy and sour from ancient Earth cooking traditions. This one is made with tofu."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "hotandsoursoup"
	trash = /obj/item/trash/asian_bowl
	nutriment_amt = 6
	nutriment_desc = list("spicyness" = 4, "sourness" = 4, REAGENT_ID_TOFU = 1)
	eating_sound = 'sound/items/drink.ogg'

/obj/item/reagent_containers/food/snacks/hotandsoursoup/Initialize(mapload)
	. = ..()
	bitesize = 2
	reagents.add_reagent(REAGENT_ID_HOTNSOURSOUP, 10)

/obj/item/reagent_containers/food/snacks/kitsuneudon
	name = "kitsune udon"
	desc = "A purported favorite of kitsunes in ancient Japanese myth: udon noodles, fried egg, and tofu."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "kitsuneudon"
	trash = /obj/item/trash/asian_bowl
	nutriment_amt = 6
	nutriment_desc = list("fried egg" = 2, "egg noodles" = 4)
	eating_sound = 'sound/items/drink.ogg'

/obj/item/reagent_containers/food/snacks/kitsuneudon/Initialize(mapload)
	. = ..()
	bitesize = 2

/obj/item/reagent_containers/food/snacks/generalschicken
	name = "general's chicken"
	desc = "Sweet, spicy, and fried. General's Chicken has been around for more than five-hundred years now, and still tastes good."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "generaltso"
	trash = /obj/item/trash/asian_bowl
	nutriment_amt = 6
	nutriment_desc = list("sweet and spicy sauce" = 5, "chicken" = 3)

/obj/item/reagent_containers/food/snacks/generalschicken/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_PROTEIN, 4)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/bugball
	name = "bugball"
	desc = "A hard piece of chitin, don't chip a tooth!"
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "pillbugball"
	slice_path = /obj/item/reagent_containers/food/snacks/pillbug
	slices_num = 1
	trash = /obj/item/reagent_containers/food/snacks/pillbug
	nutriment_amt = 1
	nutriment_desc = list("crunchy shell bits" = 5)

/obj/item/reagent_containers/food/snacks/bugball/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_PROTEIN, 1)
	reagents.add_reagent(REAGENT_ID_CARBON, 5)
	bitesize = 7

/obj/item/reagent_containers/food/snacks/pillbug
	name = "pillbug"
	desc = "A delicacy discovered and popularized by a famous restaurant called Mudca's Meat Hut."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "pillbug"
	trash = /obj/item/reagent_containers/food/snacks/pillbugempty
	nutriment_amt = 3
	nutriment_desc = list("sparkles" = 5, "ancient inca culture" =3)

/obj/item/reagent_containers/food/snacks/pillbug/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_PROTEIN, 3)
	reagents.add_reagent(REAGENT_ID_SHOCKCHEM, 6)
	bitesize = 6

/obj/item/reagent_containers/food/snacks/pillbugempty
	name = "pillbug shell"
	desc = "Waste not, want not."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "pillbugempty"
	nutriment_amt = 1
	nutriment_desc = list("crunchy shell bits" = 5)

/obj/item/reagent_containers/food/snacks/pillbug/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_PROTEIN, 1)
	reagents.add_reagent(REAGENT_ID_CARBON, 5)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/mammi
	name = "mämmi"
	desc = "Traditional Finnish desert, some like it, others don't. It's drifting in some milk, add sugar!"
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "mammi"
	trash = /obj/item/trash/plate
	nutriment_amt = 3
	nutriment_desc = list("brothy sweet goodness" = 5)

/obj/item/reagent_containers/food/snacks/mammi/Initialize(mapload)
	. = ..()
	bitesize = 3

/obj/item/reagent_containers/food/snacks/makaroni
	name = "makaronilaatikko"
	desc = "A special kind of macaroni, it's a big dish, and this one has special meat in it."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "makaroni"
	trash = /obj/item/trash/plate
	nutriment_amt = 15
	nutriment_desc = list("Cheese" = 5, "eggs" = 3, "pasta" = 4, "sparkles" = 3)

/obj/item/reagent_containers/food/snacks/makaroni/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_PROTEIN, 1)
	reagents.add_reagent(REAGENT_ID_SHOCKCHEM, 6)
	bitesize = 7

/obj/item/reagent_containers/food/snacks/lobster
	name = "raw lobster"
	desc = "A shifty lobster. You can try eating it, but its shell is extremely tough."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "lobster_raw"
	nutriment_amt = 5

/obj/item/reagent_containers/food/snacks/lobster/Initialize(mapload)
	. = ..()
	bitesize = 0.1

/obj/item/reagent_containers/food/snacks/lobstercooked
	name = "cooked lobster"
	desc = "A luxurious plate of cooked lobster, its taste accentuated by lemon juice. Reinvigorating!"
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "lobster_cooked"
	trash = /obj/item/trash/plate
	nutriment_amt = 20
	nutriment_desc = list(PLANT_LEMON = 2, "lobster" = 5, "salad" = 2)

/obj/item/reagent_containers/food/snacks/lobstercooked/Initialize(mapload)
	. = ..()
	bitesize = 5
	reagents.add_reagent(REAGENT_ID_PROTEIN, 20)
	reagents.add_reagent(REAGENT_ID_TRICORDRAZINE, 5)
	reagents.add_reagent(REAGENT_ID_IRON, 5)

/obj/item/reagent_containers/food/snacks/cuttlefish
	name = "raw cuttlefish"
	desc = "It's an adorable squid! You couldn't possibly be thinking about eating this, right?"
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "cuttlefish_raw"
	nutriment_amt = 5

/obj/item/reagent_containers/food/snacks/cuttlefish/Initialize(mapload)
	. = ..()
	bitesize = 10

/obj/item/reagent_containers/food/snacks/cuttlefishcooked
	name = "cooked cuttlefish"
	desc = "It's a roasted cuttlefish. Rubbery, squishy, an acquired taste."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "cuttlefish_cooked"
	nutriment_amt = 20
	nutriment_desc = list("cuttlefish" = 5, "rubber" = 5, "grease" = 1)

/obj/item/reagent_containers/food/snacks/cuttlefishcooked/Initialize(mapload)
	. = ..()
	bitesize = 5
	reagents.add_reagent(REAGENT_ID_PROTEIN, 10)

/obj/item/reagent_containers/food/snacks/sliceable/monkfish
	name = "extra large monkfish"
	desc = "It's a huge monkfish. Better clean it first, you can't possibly eat it like this."
	icon = 'icons/obj/food48x48_vr.dmi'
	icon_state = "monkfish_raw"
	nutriment_amt = 30
	w_class = ITEMSIZE_HUGE //Is that a monkfish in your pocket, or are you just happy to see me?
	slice_path = /obj/item/reagent_containers/food/snacks/monkfishfillet
	slices_num = 6
	trash = /obj/item/reagent_containers/food/snacks/sliceable/monkfishremains

/obj/item/reagent_containers/food/snacks/sliceable/monkfish/Initialize(mapload)
	. = ..()
	bitesize = 2

/obj/item/reagent_containers/food/snacks/monkfishfillet
	name = "monkfish fillet"
	desc = "It's a fillet sliced from a monkfish."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "monkfish_fillet"
	nutriment_amt = 5

/obj/item/reagent_containers/food/snacks/monkfishfillet/Initialize(mapload)
	. = ..()
	bitesize = 3
	reagents.add_reagent(REAGENT_ID_PROTEIN, 1)

/obj/item/reagent_containers/food/snacks/monkfishcooked
	name = "seasoned monkfish"
	desc = "A delicious slice of monkfish prepared with sweet chili and spring onion."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "monkfish_cooked"
	nutriment_amt = 10
	nutriment_desc = list("fish" = 3, REAGENT_ID_OIL = 1, "sweet chili" = 3, "spring onion" = 2)
	trash = /obj/item/trash/fancyplate

/obj/item/reagent_containers/food/snacks/monkfishcooked/Initialize(mapload)
	. = ..()
	bitesize = 4
	reagents.add_reagent(REAGENT_ID_PROTEIN, 5)

/obj/item/reagent_containers/food/snacks/sliceable/monkfishremains
	name = "monkfish remains"
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "monkfish_remains"
	desc = "The work of a madman."
	w_class = ITEMSIZE_LARGE
	nutriment_amt = 10
	slice_path = /obj/item/clothing/head/fish
	slices_num = 1

/obj/item/reagent_containers/food/snacks/sliceable/monkfishremains/Initialize(mapload)
	. = ..()
	bitesize = 0.01 //impossible to eat
	reagents.add_reagent(REAGENT_ID_CARBON, 5)

/obj/item/reagent_containers/food/snacks/sliceable/sharkchunk
	name = "chunk of shark meat"
	desc = "Still rough, needs to be cut into even smaller chunks."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "sharkmeat_chunk"
	nutriment_amt = 15
	w_class = ITEMSIZE_LARGE
	slice_path = /obj/item/reagent_containers/food/snacks/carpmeat/fish/sharkmeat
	slices_num = 5

/obj/item/reagent_containers/food/snacks/sliceable/sharkchunk/Initialize(mapload)
	. = ..()
	bitesize = 3
	reagents.add_reagent(REAGENT_ID_PROTEIN, 20)

/obj/item/reagent_containers/food/snacks/carpmeat/fish/sharkmeat
	name = "slice of sharkmeat"
	desc = "Now it's small enough to cook with."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "sharkmeat"
	nutriment_amt = 2
	toxin_amount = null

/obj/item/reagent_containers/food/snacks/carpmeat/fish/sharkmeat/Initialize(mapload)
	. = ..()
	bitesize = 3
	reagents.add_reagent(REAGENT_ID_PROTEIN, 2)

/obj/item/reagent_containers/food/snacks/sharkmeatcooked
	name = "shark steak"
	desc = "Finally, some food for real men."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "sharkmeat_cooked"
	trash = /obj/item/trash/small_bowl
	nutriment_amt = 5
	trash = /obj/item/trash/plate
	nutriment_desc = list("manliness" = 1, "fish oil" = 2, "shark" = 2)

/obj/item/reagent_containers/food/snacks/sharkmeatcooked/Initialize(mapload)
	. = ..()
	bitesize = 3
	reagents.add_reagent(REAGENT_ID_PROTEIN, 8)

/obj/item/reagent_containers/food/snacks/sharkmeatdip
	name = "hot shark shank"
	desc = "A shank of shark meat dipped in hot sauce."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "sharkmeat_dip"
	nutriment_amt = 5
	trash = /obj/item/trash/snack_bowl
	nutriment_desc = list("salt" = 1, "fish oil" = 2, "spicy shark" = 2)

/obj/item/reagent_containers/food/snacks/sharkmeatdip/Initialize(mapload)
	. = ..()
	bitesize = 3
	reagents.add_reagent(REAGENT_ID_CAPSAICIN, 4)
	reagents.add_reagent(REAGENT_ID_PROTEIN, 4)

/obj/item/reagent_containers/food/snacks/sharkmeatcubes
	name = "shark cubes"
	desc = "Foul scented fermented shark cubes, it's said to make men fly, or just make them really fat."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "sharkmeat_cubes"
	nutriment_amt = 8
	trash = /obj/item/trash/plate
	nutriment_desc = list("viking spirit" = 1, "rot" = 2, "fermented sauce" = 2)

/obj/item/reagent_containers/food/snacks/sharkmeatcubes/Initialize(mapload)
	. = ..()
	bitesize = 10
	reagents.add_reagent(REAGENT_ID_POTATOJUICE, 30) // for people who want to get fat, FAST.

/obj/item/reagent_containers/food/snacks/monkeycube/sobakacube
	name = "sobaka cube"
	monkey_type = SPECIES_MONKEY_AKULA

/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/sobakacube
	name = "sobaka cube"
	monkey_type = SPECIES_MONKEY_AKULA

/obj/item/reagent_containers/food/snacks/monkeycube/sarucube
	name = "saru cube"
	monkey_type = SPECIES_MONKEY_SERGAL

/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/sarucube
	name = "saru cube"
	monkey_type = SPECIES_MONKEY_SERGAL

/obj/item/reagent_containers/food/snacks/monkeycube/sparracube
	name = "sparra cube"
	monkey_type = SPECIES_MONKEY_NEVREAN

/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/sparracube
	name = "sparra cube"
	monkey_type = SPECIES_MONKEY_NEVREAN

/obj/item/reagent_containers/food/snacks/monkeycube/wolpincube
	name = "wolpin cube"
	monkey_type = SPECIES_MONKEY_VULPKANIN

/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/wolpincube
	name = "wolpin cube"
	monkey_type = SPECIES_MONKEY_VULPKANIN

// food cubes
/obj/item/reagent_containers/food/snacks/cube
	name = "protein cube"
	desc = "A colony of meat cells, Just add water!"
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "proteincube"
	w_class = ITEMSIZE_TINY
	flags = OPENCONTAINER
	bitesize = 12
	filling_color = "#ADAC7F"
	center_of_mass_x = 16
	center_of_mass_y = 14

	var/food_type = "/obj/item/reagent_containers/food/snacks/proteinslab"

/obj/item/reagent_containers/food/snacks/cube/Initialize(mapload)
	. = ..()

/obj/item/reagent_containers/food/snacks/cube/proc/Expand()
	src.visible_message(span_infoplain(span_bold("\The [src]") + " expands!"))
	new food_type(get_turf(src))
	qdel(src)

/obj/item/reagent_containers/food/snacks/cube/on_reagent_change()
	if(reagents.has_reagent(REAGENT_ID_WATER))
		Expand()

/obj/item/reagent_containers/food/snacks/cube/protein

/obj/item/reagent_containers/food/snacks/cube/protein/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_MEATCOLONY, 5)

/obj/item/reagent_containers/food/snacks/proteinslab
	name = "Protein slab"
	desc = "A slab of near pure protein, extremely artificial, and thoroughly disgusting."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "proteinslab"
	bitesize = 10
	nutriment_amt = 5
	nutriment_desc = list("bitter chyme" = 50)

/obj/item/reagent_containers/food/snacks/proteinslab/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_PROTEIN, 30)

/obj/item/reagent_containers/food/snacks/cube/nutriment
	name = "Nutriment cube"
	desc = "A colony of plant cells, Just add water!"
	icon_state = "nutrimentcube"
	food_type = "/obj/item/reagent_containers/food/snacks/nutrimentslab"

/obj/item/reagent_containers/food/snacks/cube/nutriment/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_PLANTCOLONY, 5)

/obj/item/reagent_containers/food/snacks/nutrimentslab
	name = "Nutriment slab"
	desc = "A slab of near pure plant-based nutrients, extremely artificial, and thoroughly disgusting."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "nutrimentslab"
	bitesize = 10
	nutriment_amt = 20
	nutriment_desc = list("compost" = 50)

/obj/item/storage/box/wings/tray //Might as well re-use this code.
	name = "ration cube tray"
	desc = "A tray of food cubes, the label warns not to consume before adding water or mixing with virusfood."
	icon_state = "tray8"
	icon_base = "tray"
	startswith = 8
	w_class = ITEMSIZE_SMALL
	max_storage_space = ITEMSIZE_COST_TINY * 8
	starts_with = list(
		/obj/item/reagent_containers/food/snacks/cube/protein = 4,
		/obj/item/reagent_containers/food/snacks/cube/nutriment = 4
	)
	can_hold = list(/obj/item/reagent_containers/food/snacks/cube/protein,
					/obj/item/reagent_containers/food/snacks/cube/nutriment)

/obj/item/reagent_containers/food/snacks/carpmeat/sif //Making fish meat non-toxic!  As advised by Ascian!
	toxin_type = null
	toxin_amount = null

/obj/item/reagent_containers/food/snacks/carpmeat/sif/murkfish
	toxin_type = null

/obj/item/reagent_containers/food/snacks/carpmeat/fish
	toxin_type = null
	toxin_amount = null

/obj/item/reagent_containers/food/snacks/honeybun
	name = "Honeybun"
	desc = "A delicious and sweet treat made with honey instead of sugar. On the sticky side."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "honeybun"
	bitesize = 2
	nutriment_amt = 4
	nutriment_desc = list(REAGENT_ID_HONEY = 2, "pastry" = 1)

/obj/item/reagent_containers/food/snacks/bun/Initialize(mapload)
	. = ..()

//Readded Polaris Foods
/obj/item/reagent_containers/food/snacks/nachos
	name = "nachos"
	desc = "Chips from Old Mexico."
	icon_state = "nachos"
	nutriment_amt = 2
	nutriment_desc = list("salt" = 1)

/obj/item/reagent_containers/food/snacks/nachos/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_NUTRIMENT, 1)
	bitesize = 1

/obj/item/reagent_containers/food/snacks/cheesenachos
	name = "cheesy nachos"
	desc = "The delicious combination of nachos and melting cheese."
	icon_state = "cheesenachos"
	nutriment_amt = 5
	nutriment_desc = list("salt" = 2, REAGENT_ID_CHEESE = 3)

/obj/item/reagent_containers/food/snacks/cheesenachos/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_NUTRIMENT, 5)
	reagents.add_reagent(REAGENT_ID_PROTEIN, 2)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/milosoup
	name = "Miso soup"
	desc = "The universes best soup! Yum!!!"
	icon_state = "milosoup"
	trash = /obj/item/trash/snack_bowl
	center_of_mass_x = 16
	center_of_mass_y = 7
	nutriment_amt = 8
	nutriment_desc = list("soy" = 8)
	bitesize = 4
	eating_sound = 'sound/items/drink.ogg'

/obj/item/reagent_containers/food/snacks/milosoup/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_WATER, 5)

/obj/item/reagent_containers/food/snacks/onionsoup
	name = "Onion Soup"
	desc = "A soup with layers."
	icon_state = "onionsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#E0C367"
	center_of_mass_x = 16
	center_of_mass_y = 7
	bitesize = 3
	eating_sound = 'sound/items/drink.ogg'

/obj/item/reagent_containers/food/snacks/onionsoup/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_ONIONSOUP, 10)

//Fennec foods
/obj/item/storage/box/wings/bucket
	name = "Bucket o' grubs"
	desc = "A bucket full of writhing grubs."
	icon_state = "bucket6"
	icon_base = "bucket"
	startswith = 6
	w_class = ITEMSIZE_LARGE
	max_storage_space = ITEMSIZE_COST_SMALL * 6
	starts_with = list(
		/obj/item/reagent_containers/food/snacks/grub = 6
	)
	can_hold = list(/obj/item/reagent_containers/food/snacks/grub)

/obj/item/reagent_containers/food/snacks/grub
	name = "grub"
	desc = "A still writhing grub, soft and squishy."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "grub"
	nutriment_amt = 3
	nutriment_desc = list("goo" = 1, "slime" = 1)

/obj/item/reagent_containers/food/snacks/grub/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_PROTEIN, 2)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/grub_pink
	name = "pink candy grub"
	desc = "A thoroughly candied grub, it smells of cherry."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "grub_pink"
	nutriment_amt = 5
	nutriment_desc = list(PLANT_CHERRY = 4, "goo" = 1)

/obj/item/reagent_containers/food/snacks/grub_pink/Initialize(mapload)
	. = ..()
	bitesize = 3

/obj/item/reagent_containers/food/snacks/grub_purple
	name = "purple candy grub"
	desc = "A thoroughly candied grub, it smells of grape."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "grub_purple"
	nutriment_amt = 5
	nutriment_desc = list("grape" = 4, "goo" = 1)

/obj/item/reagent_containers/food/snacks/grub_purple/Initialize(mapload)
	. = ..()
	bitesize = 3

/obj/item/reagent_containers/food/snacks/grub_blue
	name = "blue candy grub"
	desc = "A thoroughly candied grub, it smells of blueberry."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "grub_blue"
	nutriment_amt = 5
	nutriment_desc = list("blueberry" = 4, "goo" = 1)

/obj/item/reagent_containers/food/snacks/grub_blue/Initialize(mapload)
	. = ..()
	bitesize = 3

/obj/item/reagent_containers/food/snacks/scorpion
	name = "scorpion"
	desc = "A scorpion from the sandy deserts, don't get stung!"
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "scorpion"
	nutriment_amt = 8
	nutriment_desc = list("crunchy" = 4, "shell bits" = 1)

/obj/item/reagent_containers/food/snacks/scorpion/Initialize(mapload)
	. = ..()
	bitesize = 1

/obj/item/reagent_containers/food/snacks/scorpion_cooked
	name = "cooked scorpion"
	desc = "A scorpion. Baked nice and crispy."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "scorpion_cooked"
	nutriment_amt = 6
	nutriment_desc = list("crispy" = 4, "exotic meat" = 1)

/obj/item/reagent_containers/food/snacks/scorpion_cooked/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_NUTRIMENT, 2)
	reagents.add_reagent(REAGENT_ID_PROTEIN, 4)
	bitesize = 4

/obj/item/reagent_containers/food/snacks/ant
	name = "giant honey ant"
	desc = "A sweetly scented honey ant. It has a huge swollen abdomen full of yummy."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "honeyant"
	nutriment_amt = 2
	nutriment_desc = list("crunchy" = 1, "goo" = 1)
	slice_path = /obj/item/reagent_containers/food/snacks/antball
	slices_num = 1

/obj/item/reagent_containers/food/snacks/ant/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_HONEY, 2)
	reagents.add_reagent(REAGENT_ID_PROTEIN, 3)
	bitesize = 1

/obj/item/reagent_containers/food/snacks/antball
	name = "giant honey ball"
	desc = "A sweetly scented honey ball, minus the ant. For those who don't like bug bits between their teeth."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "honeyant_clean"
	nutriment_amt = 4
	nutriment_desc = list("goo" = 1)

/obj/item/reagent_containers/food/snacks/antball/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_HONEY, 2)
	bitesize = 1

/obj/item/reagent_containers/food/snacks/honey_candy
	name = "honey candy"
	desc = "A clever mimicry of a honey ant abdomen, but it's just a piece of candy. Does not contain actual honey!"
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "candy_honey"
	nutriment_amt = 4
	nutriment_desc = list("goo" = 1, REAGENT_ID_HONEY = 1)
	slice_path = /obj/item/reagent_containers/food/snacks/antball
	slices_num = 1

/obj/item/reagent_containers/food/snacks/honey_candy/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_SUGAR, 2)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/locust
	name = "yellow jacket locust"
	desc = "A vibrant bug that looks like a wasp, but is in fact a locust. Crunchy."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "locust"
	nutriment_amt = 4
	nutriment_desc = list("crunchy" = 1, "goo" = 1)

/obj/item/reagent_containers/food/snacks/locust/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_PROTEIN, 1)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/locust_cooked
	name = "fried locust"
	desc = "A fried locust, extremely crunchy."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "locust_cooked"
	nutriment_amt = 2
	nutriment_desc = list("crunchy" = 4)

/obj/item/reagent_containers/food/snacks/locust_cooked/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_PROTEIN, 3)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/donkpocket/ascended
	name = "Donk-pocket EX"
	desc = "This donk-pocket has seen things beyond comprehension of mortals. It survived because the fire inside it burned brighter than fire around it."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "donkpocket_ascended"
	nutriment_amt = 5
	nutriment_desc = list("burning fires of radioactive hell" = 20)
	heated_reagents = list(REAGENT_ID_SUPERMATTER = 1)

/obj/item/reagent_containers/food/snacks/donkpocket/ascended/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_URANIUM, 3)
	reagents.add_reagent(REAGENT_ID_THERMITEV, 3)

// Altevian Foobs

/obj/item/reagent_containers/food/snacks/ratprotein
	name = "AN Flavor Unit C"
	desc = "A snack made from a group of space-faring rodents that is packed with the maximized potential of caloric intake to cubic inch. This one seems to be flavored of smoked cheddar and salami."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "altevian_cheese_block"
	package_open_state = "altevian_cheese_block-open"
	package = TRUE
	trash = /obj/item/trash/ratcheese
	nutriment_amt = 5
	nutriment_desc = list("smoked cheese" = 4)

/obj/item/reagent_containers/food/snacks/ratveggies
	name = "Premium Ration Packet - VEG"
	desc = "A package of a mixture of somehow still fresh from day 1 greens with a light hint of vinegar dressing to add extra kick."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "altevian_veggies"
	package_open_state = "altevian_veggies-open"
	package = TRUE
	trash = /obj/item/trash/ratveg
	nutriment_amt = 3
	nutriment_desc = list("fresh mixed veggies" = 3, REAGENT_ID_VINEGAR = 1)

/obj/item/reagent_containers/food/snacks/ratliquid
	name = "Admiral's Choice Space-Safe Meal"
	desc = "A vacuum sealed pouch of a liquid meal. This one seems to be flavored with the accent of steak."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "altevian_juice"
	package_open_state = "altevian_juice-open"
	package = TRUE
	trash = /obj/item/trash/ratjuice
	nutriment_amt = 2
	nutriment_desc = list("essence of steak" = 6)
	eating_sound = 'sound/items/drink.ogg'

/obj/item/reagent_containers/food/snacks/ratliquid/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_PROTEIN, 4)

/obj/item/reagent_containers/food/snacks/ratsteak
	name = "altevian traditional steak"
	desc = "This abomination of processed foods resembles a steak plate. Probably contains nothing a normal steak does, but mimics its flavor and nutrition well-enough."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "altevian_steak"
	trash = /obj/item/trash/plate
	nutriment_amt = 8
	nutriment_desc = list("steak" = 5, "smoked cheese" = 2, "veggies" = 1)

/obj/item/reagent_containers/food/snacks/ratsteak/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_PROTEIN, 3)

/obj/item/reagent_containers/food/snacks/ratfruitcake
	name = "Premade Fruit Block"
	desc = "A block of processed material that is infused with a mix of fruits and other nutrients."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "altevian_fruitcake"
	package_open_state = "altevian_fruitcake-open"
	package = TRUE
	trash = /obj/item/trash/ratfruitcake
	nutriment_amt = 2
	nutriment_desc = list("fruitiness" = 4)

/obj/item/reagent_containers/food/snacks/ratpackburger
	name = "Altevian Prepackaged Meal - Burger"
	desc = "A unique twist on what most know as MREs. This seems to be made with using a specialized compression technology that possibly utilizes Bluespace alongside it. Whatever it is, it seems to keep the freshness of whatever is inside to restaurant quality. This one is a combo of a burger and fries!"
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "altevian_pack_burger"
	package_open_state = "altevian_pack_burger-open"
	package_opening_state = "altevian_pack_burger-opening"
	package = TRUE
	trash = /obj/item/trash/ratpackburger
	nutriment_amt = 2
	nutriment_desc = list("fresh buns" = 2, "burger patty" = 4, "pickles" = 1)

/obj/item/reagent_containers/food/snacks/ratpackcheese
	name = "Generations Novelty Packaged Wedge"
	desc = "A unique twist on what most know as MREs. This seems to be made with using a specialized compression technology that possibly utilizes Bluespace alongside it. Whatever it is, it seems to keep the freshness of whatever is inside to restaurant quality. This one appears to have no real markings on it, save for its different coloring, and an image of the altevian emblem."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "altevian_pack_cheese"
	package_open_state = "altevian_pack_cheese-open"
	package_opening_state = "altevian_pack_cheese-opening"
	package = TRUE
	trash = /obj/item/trash/ratpackcheese
	nutriment_amt = 2
	nutriment_desc = list("gourmand cheese" = 4)

/obj/item/reagent_containers/food/snacks/ratpackturkey
	name = "Compact Holiday Special Bird"
	desc = "A great gift for that special celebration or holiday for assorted species. This package contains a full freshly cooked turkey. Open and enjoy. Courtesy of altevian packaging."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "altevian_pack_turkey"
	package_open_state = "altevian_pack_turkey-open"
	package_opening_state = "altevian_pack_turkey-opening"
	package = TRUE
	trash = /obj/item/trash/ratpackturkey
	nutriment_amt = 18
	nutriment_desc = list("high-quality poultry" = 4)

/obj/item/reagent_containers/food/snacks/ratpackramen
	name = "Big Noodle Package"
	desc = "A compression sealed package containing a fully cooked ramen meal. It comes with some seafood-and-rice based sides. Utensils included."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "altevian_pack_ramen"
	package_open_state = "altevian_pack_ramen_standard-open"
	package_opening_state = "altevian_pack_ramen_standard-opening"
	package = TRUE
	trash = /obj/item/trash/ratpackramen/standard
	nutriment_amt = 2
	nutriment_desc = list("savory noodles" = 4)
	var/list/bowl_color_options = list("standard" = 6,
										"lacquer1" = 2,
										"lacquer2" = 2,
										"lacquer3" = 2,
										"fleet" = 6,
										"trans" = 3,
										"ace" = 3)
	var/randomize_bowl_color = TRUE

/obj/item/reagent_containers/food/snacks/ratpackramen/Initialize(mapload)
	. = ..()
	if(randomize_bowl_color)
		var/bowl_color = pickweight(bowl_color_options)
		package_open_state = "altevian_pack_ramen_[bowl_color]-open"
		package_opening_state = "altevian_pack_ramen_[bowl_color]-opening"
		trash = text2path("/obj/item/trash/ratpackramen/[bowl_color]")

/obj/item/reagent_containers/food/snacks/ratpacktaco
	name = "Triple Taco Tuck"
	desc = "A compression sealed package containing three mini-tacos, miniaturized further via altevian mad science into a convenient container."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "altevian_pack_taco"
	package_open_state = "altevian_pack_taco-open"
	package_opening_state = "altevian_pack_taco-opening"
	package = TRUE
	trash = /obj/item/trash/ratpacktaco
	nutriment_amt = 2
	nutriment_desc = list("salsa sauce" = 2, "meat chunks" = 4, REAGENT_ID_CHEESE = 3)

/obj/item/reagent_containers/food/snacks/ratpackcake
	name = "Instant Sweet Celebration"
	desc = "A compressed sweet treat in one easy container. The label states that it's a slice of vanilla cake."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "altevian_pack_cake"
	package_open_state = "altevian_pack_cake-open"
	package_opening_state = "altevian_pack_cake-opening"
	package = TRUE
	trash = /obj/item/trash/ratpackcake
	nutriment_amt = 2
	nutriment_desc = list("nice mix of vanilla and sugar" = 5)

/obj/item/reagent_containers/food/snacks/ratpackmeat
	name = "unmarked compression package"
	desc = "This package looks familiar to the compression packs commonly seen from the Altevians. However, it looks to be unfinished or a possible test product that somehow ended up in your hands."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "altevian_pack_meat"
	package_open_state = "altevian_pack_meat-open"
	package_opening_state = "altevian_pack_meat-opening"
	package = TRUE
	trash = /obj/item/trash/ratpackmeat
	nutriment_amt = 2
	nutriment_desc = list("synthetic meat" = 6)


//desatti snacks

/obj/item/reagent_containers/food/snacks/jaffacake
	name = "Jaffa Cake"
	desc = "A delicious miniature cake with a soft sponge base, topped with orange jelly and covered with a thin layer of chocolate."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "jaffacake"
	nutriment_amt = 1
	bitesize = 2
	nutriment_desc = list(REAGENT_ID_CHOCOLATE = 2, PLANT_ORANGE = 4, "cake" = 3)

/obj/item/reagent_containers/food/snacks/bourbon/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_COCO, 2)

/obj/item/storage/box/jaffacake //This is kinda like the donut box.
	name = "Desatti Jaffa Cakes"
	desc = "A box full of desatti brand jaffa cakes, with twelve in a pack!"
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "jaffacake_pack"
	var/icon_base = "jaffacake_pack"
	var/startswith = 12
	max_storage_space = ITEMSIZE_COST_SMALL * 12
	can_hold = list(/obj/item/reagent_containers/food/snacks/jaffacake)
	starts_with = list(
		/obj/item/reagent_containers/food/snacks/jaffacake = 12
	)
	foldable = null

/obj/item/reagent_containers/food/snacks/winegum
	name = "wine gum"
	desc = "A small firm and chewy sweet filled with artificial flavour."
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "winegum_red"
	w_class = ITEMSIZE_TINY
	nutriment_amt = 1
	bitesize = 2
	nutriment_desc = list(REAGENT_ID_SUGAR = 5, "berry" = 2)


/obj/item/reagent_containers/food/snacks/winegum/orange
	icon_state = "winegum_orange"
	nutriment_desc = list(REAGENT_ID_SUGAR = 5, PLANT_ORANGE = 2)

/obj/item/reagent_containers/food/snacks/winegum/black
	icon_state = "winegum_black"
	nutriment_desc = list(REAGENT_ID_SUGAR = 5, "berry" = 2)

/obj/item/reagent_containers/food/snacks/winegum/green
	icon_state = "winegum_green"
	nutriment_desc = list(REAGENT_ID_SUGAR = 5, PLANT_LIME = 2)

/obj/item/reagent_containers/food/snacks/winegum/yellow
	icon_state = "winegum_yellow"
	nutriment_desc = list(REAGENT_ID_SUGAR = 5, PLANT_LEMON = 2)

/obj/item/reagent_containers/food/snacks/winegum/white
	icon_state = "winegum_white"
	nutriment_desc = list(REAGENT_ID_SUGAR = 5, REAGENT_ID_PINEAPPLEJUICE = 2)

/obj/item/storage/box/winegum //This is kinda like the donut box.
	name = "Desatti Wine Gums"
	desc = "A pack of wine gums, randomly assorted shapes and fruity flavours!"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "winegum_pack"
	var/icon_base = "winegum_pack"
	var/startswith = 20
	max_storage_space = ITEMSIZE_COST_TINY * 20
	can_hold = list(/obj/item/reagent_containers/food/snacks/winegum)
	starts_with = list(
		/obj/item/reagent_containers/food/snacks/winegum = 3,
		/obj/item/reagent_containers/food/snacks/winegum/orange = 4,
		/obj/item/reagent_containers/food/snacks/winegum/black = 3,
		/obj/item/reagent_containers/food/snacks/winegum/green = 3,
		/obj/item/reagent_containers/food/snacks/winegum/yellow = 3,
		/obj/item/reagent_containers/food/snacks/winegum/white = 4
	)
	foldable = null

/obj/item/reagent_containers/food/snacks/packaged/pasty
	name = "Terran Pasty"
	icon_state = "pasty"
	desc = "A pre-packaged terran pasty with Desatti Catering branding. Claims to contain lamb, potato and onion in a pastry casing!"
	package_trash = /obj/item/trash/pasty
	package_open_state = "pasty_open"
	nutriment_amt = 4
	nutriment_desc = list("pastry" = 5, "meat" = 5, PLANT_ONION = 2, PLANT_POTATO = 3)

/obj/item/reagent_containers/food/snacks/packaged/pasty/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_PROTEIN, 2)

/obj/item/reagent_containers/food/snacks/saucer
	name = "Sherbert Saucer"
	desc = "A small saucer shaped piece of rice paper filled with sugar."
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "saucer_pink"
	w_class = ITEMSIZE_TINY
	nutriment_amt = 1
	bitesize = 2
	nutriment_desc = list(REAGENT_ID_SUGAR = 5)
	var/list/color_options = list("saucer_pink","saucer_blue","saucer_orange","saucer_green","saucer_yellow")

/obj/item/reagent_containers/food/snacks/saucer/Initialize(mapload)
	. = ..()
	icon_state = pick(color_options)

/obj/item/storage/box/saucer //This is kinda like the donut box.
	name = "Desatti Sherbert Saucers"
	desc = "A pack of sherbert saucers, delicious pure sugar barely held together in packets of rice paper!"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "saucer_pack"
	var/icon_base = "saucer_pack"
	var/startswith = 20
	max_storage_space = ITEMSIZE_COST_TINY * 20
	can_hold = list(/obj/item/reagent_containers/food/snacks/saucer)
	starts_with = list(
		/obj/item/reagent_containers/food/snacks/saucer = 20,
	)
	foldable = null

/obj/item/reagent_containers/food/snacks/custardcream
	name = "Custard Cream"
	desc = "A small sandwich biscuit with a layer of custard flavoured cream as the filling and a pleasant design on the top and bottom."
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "custard_cream"
	nutriment_amt = 1
	bitesize = 1
	nutriment_desc = list("biscuit" = 5, REAGENT_ID_CREAM = 3, "custard" = 3)

/obj/item/storage/box/custardcream //This is kinda like the donut box.
	name = "Desatti Custard Creams"
	desc = "A box full of desatti brand custard cream biscuits!"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "custard_cream_pack"
	var/icon_base = "custard_cream_pack"
	var/startswith = 12
	max_storage_space = ITEMSIZE_COST_SMALL * 12
	can_hold = list(/obj/item/reagent_containers/food/snacks/custardcream)
	starts_with = list(
		/obj/item/reagent_containers/food/snacks/custardcream = 12
	)
	foldable = null

/obj/item/reagent_containers/food/snacks/bourbon
	name = "Bourbon Biscuit"
	desc = "A long chocolate sandwich biscuit with a layer of chocolate flavoured cream as the filling and the word 'bourbon' on top."
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "bourbon"
	nutriment_amt = 1
	bitesize = 1
	nutriment_desc = list("biscuit" = 5, REAGENT_ID_CREAM = 3, REAGENT_ID_CHOCOLATE = 5)

/obj/item/storage/box/bourbon //This is kinda like the donut box.
	name = "Desatti Bourbons"
	desc = "A box full of desatti brand chocolate bourbon biscuits!"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "bourbon_pack"
	var/icon_base = "bourbon_pack"
	var/startswith = 12
	max_storage_space = ITEMSIZE_COST_SMALL * 12
	can_hold = list(/obj/item/reagent_containers/food/snacks/bourbon)
	starts_with = list(
		/obj/item/reagent_containers/food/snacks/bourbon = 12
	)
	foldable = null

/obj/item/reagent_containers/food/snacks/bourbon/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_COCO, 2)

/obj/item/reagent_containers/food/snacks/packaged/sausageroll
	name = "Sausage Roll"
	icon_state = "sausageroll"
	desc = "A pre-packaged sausage roll with Desatti Catering branding. Claims to contain real meat covered in pastry!"
	package_trash = /obj/item/trash/sausageroll
	package_open_state = "sausageroll_open"
	nutriment_amt = 3
	nutriment_desc = list("pastry" = 5, "meat" = 5)

/obj/item/reagent_containers/food/snacks/packaged/sausageroll/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_PROTEIN, 2)

/obj/item/reagent_containers/food/snacks/packaged/scotchegg
	name = "Scotch Egg"
	icon_state = "scotchegg"
	desc = "A pre-packaged scotch egg with Desatti Catering branding. Claims to contain a boiled egg covered in meat and coated with breadcrumbs!"
	package_trash = /obj/item/trash/scotchegg
	package_open_state = "scotchegg_open"
	nutriment_amt = 3
	nutriment_desc = list(REAGENT_ID_EGG = 5, "meat" = 5, "bread" = 2)

/obj/item/reagent_containers/food/snacks/packaged/scotchegg/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_PROTEIN, 2)

/obj/item/reagent_containers/food/snacks/foam_banana
	name = "Foam Banana"
	desc = "A small vaguely banana shaped sweet with a foam-like texture."
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "foam_banana"
	w_class = ITEMSIZE_TINY
	nutriment_amt = 1
	bitesize = 2
	nutriment_desc = list(REAGENT_ID_SUGAR = 5, REAGENT_ID_BANANA = 3)

/obj/item/reagent_containers/food/snacks/foam_shrimp
	name = "Foam Shrimp"
	desc = "A small vaguely shrimp shaped sweet with a foam-like texture."
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "foam_shrimp"
	w_class = ITEMSIZE_TINY
	nutriment_amt = 1
	bitesize = 2
	nutriment_desc = list(REAGENT_ID_SUGAR = 5, "strawberry" = 3)

/obj/item/storage/box/shrimpsandbananas //This is kinda like the donut box.
	name = "Shrimps and Bananas"
	desc = "A pack of foam bananas and shrimps, the shrimps apparently don't taste of seafood! Branded as Desatti Catering."
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "shrimpbanana_pack"
	var/icon_base = "shrimpbanana_pack"
	var/startswith = 20
	max_storage_space = ITEMSIZE_COST_TINY * 20
	can_hold = list(/obj/item/reagent_containers/food/snacks/foam_banana,/obj/item/reagent_containers/food/snacks/foam_shrimp)
	starts_with = list(
		/obj/item/reagent_containers/food/snacks/foam_banana = 10,
		/obj/item/reagent_containers/food/snacks/foam_shrimp = 10
	)
	foldable = null

/obj/item/reagent_containers/food/snacks/rhubarbcustard
	name = "Rhubarb and Custard Sweet"
	desc = "A small pink and yellow boiled sweet."
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "rhubarbcustard_1"
	w_class = ITEMSIZE_TINY
	nutriment_amt = 1
	bitesize = 2
	nutriment_desc = list(REAGENT_ID_SUGAR = 5, PLANT_ROSE = 2, "custard" = 2)
	var/list/color_options = list("rhubarbcustard_1","rhubarbcustard_2")

/obj/item/reagent_containers/food/snacks/rhubarbcustard/Initialize(mapload)
	. = ..()
	icon_state = pick(color_options)

/obj/item/storage/box/rhubarbcustard //This is kinda like the donut box.
	name = "Desatti Rhubarb and Custards"
	desc = "A pack of rhubarb and custard boiled sweets, the taste combination might sound usual, but they insist it's actually kind of okay!"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "rhubarbcustard_pack"
	var/icon_base = "rhubarbcustard_pack"
	var/startswith = 15
	max_storage_space = ITEMSIZE_COST_TINY * 15
	can_hold = list(/obj/item/reagent_containers/food/snacks/rhubarbcustard)
	starts_with = list(
		/obj/item/reagent_containers/food/snacks/rhubarbcustard = 15,
	)
	foldable = null

/obj/item/reagent_containers/food/snacks/packaged/porkpie
	name = "Pork Pie"
	icon_state = "porkpie"
	desc = "A pre-packaged pork pie with Desatti Catering branding. Claims to contain real meat covered in pastry!"
	package_trash = /obj/item/trash/porkpie
	package_open_state = "porkpie_open"
	nutriment_amt = 3
	nutriment_desc = list("pastry" = 5, "meat" = 5)

/obj/item/reagent_containers/food/snacks/packaged/porkpie/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_PROTEIN, 2)
