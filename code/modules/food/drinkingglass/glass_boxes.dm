/obj/item/storage/box/mixedglasses
	name = "glassware box"
	desc = "A box of assorted glassware"
	icon_state = "glass"
	can_hold = list(/obj/item/reagent_containers/food/drinks/glass2)
	starts_with = list(
		/obj/item/reagent_containers/food/drinks/glass2/square,
		/obj/item/reagent_containers/food/drinks/glass2/rocks,
		/obj/item/reagent_containers/food/drinks/glass2/shake,
		/obj/item/reagent_containers/food/drinks/glass2/cocktail,
		/obj/item/reagent_containers/food/drinks/glass2/shot,
		/obj/item/reagent_containers/food/drinks/glass2/pint,
		/obj/item/reagent_containers/food/drinks/glass2/mug,
		/obj/item/reagent_containers/food/drinks/glass2/wine,
		/obj/item/reagent_containers/food/drinks/metaglass,
		/obj/item/reagent_containers/food/drinks/metaglass/metapint
	)

/obj/item/storage/box/glasses
	name = "box of glasses"
	can_hold = list(/obj/item/reagent_containers/food/drinks/glass2)
	starts_with = list(/obj/item/reagent_containers/food/drinks/glass2 = 7)

/obj/item/storage/box/glasses/square
	name = "box of half-pint glasses"
	starts_with = list(/obj/item/reagent_containers/food/drinks/glass2/square = 7)

/obj/item/storage/box/glasses/rocks
	name = "box of rocks glasses"
	starts_with = list(/obj/item/reagent_containers/food/drinks/glass2/rocks = 7)

/obj/item/storage/box/glasses/shake
	name = "box of milkshake glasses"
	starts_with = list(/obj/item/reagent_containers/food/drinks/glass2/shake = 7)

/obj/item/storage/box/glasses/cocktail
	name = "box of cocktail glasses"
	starts_with = list(/obj/item/reagent_containers/food/drinks/glass2/cocktail = 7)

/obj/item/storage/box/glasses/shot
	name = "box of shot glasses"
	starts_with = list(/obj/item/reagent_containers/food/drinks/glass2/shot = 7)

/obj/item/storage/box/glasses/pint
	name = "box of pint glasses"
	starts_with = list(/obj/item/reagent_containers/food/drinks/glass2/pint = 7)

/obj/item/storage/box/glasses/mug
	name = "box of glass mugs"
	starts_with = list(/obj/item/reagent_containers/food/drinks/glass2/mug = 7)

/obj/item/storage/box/glasses/wine
	name = "box of wine glasses"
	starts_with = list(/obj/item/reagent_containers/food/drinks/glass2/wine = 7)

/obj/item/storage/box/glasses/meta
	name = "box of half-pint metamorphic glasses"
	starts_with = list(/obj/item/reagent_containers/food/drinks/metaglass = 7)

/obj/item/storage/box/glasses/meta/metapint
	name = "box of metamorphic pint glasses"
	starts_with = list(/obj/item/reagent_containers/food/drinks/metaglass/metapint = 7)

/obj/item/storage/box/glass_extras
	name = "box of cocktail garnishings"
	can_hold = list(/obj/item/glass_extra)
	storage_slots = 14
	starts_with = list(/obj/item/glass_extra = 14)

/obj/item/storage/box/glass_extras/straws
	name = "box of straws"
	starts_with = list(/obj/item/glass_extra/straw = 14)

/obj/item/storage/box/glass_extras/sticks
	name = "box of drink sticks"
	starts_with = list(/obj/item/glass_extra/stick = 14)

/obj/item/storage/box/glasses/coffeecup
	name = "box of coffee cups"
	starts_with = list(/obj/item/reagent_containers/food/drinks/cup = 7)

/obj/item/storage/box/glasses/coffeemug
	name = "box of coffee mugs"
	starts_with = list(/obj/item/reagent_containers/food/drinks/glass2/coffeemug = 7)