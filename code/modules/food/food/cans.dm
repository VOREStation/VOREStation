/obj/item/weapon/reagent_containers/food/drinks/cans
	volume = 40 //just over one and a half cups
	amount_per_transfer_from_this = 5
	flags = 0 //starts closed
	drop_sound = 'sound/items/drop/soda.ogg'
	pickup_sound = 'sound/items/pickup/soda.ogg'

//DRINKS

/obj/item/weapon/reagent_containers/food/drinks/cans/cola
	name = "\improper Space Cola"
	desc = "Reassuringly artificial."
	description_fluff = "The 'Space' branding was originally added to the 'Alpha Cola' product line in order to justify selling cans for 50% higher prices to 'off-world' retailers. Despite being chemically identical, Space Cola proved so popular that Centauri Provisions eventually applied the name to the entire product line - price hike and all."
	icon_state = "cola"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/weapon/reagent_containers/food/drinks/cans/cola/Initialize()
	. = ..()
	reagents.add_reagent("cola", 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/waterbottle
	name = "bottled water"
	desc = "Ice cold and utterly tasteless, this 'all-natural' mineral water comes 'fresh' from one of NanoTrasen's heavy-duty bottling plants in the Sivian poles."
	icon_state = "waterbottle"
	center_of_mass = list("x"=16, "y"=8)
	drop_sound = 'sound/items/drop/disk.ogg'
	pickup_sound = 'sound/items/pickup/disk.ogg'

/obj/item/weapon/reagent_containers/food/drinks/cans/waterbottle/Initialize()
	. = ..()
	reagents.add_reagent("water", 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/space_mountain_wind
	name = "\improper Space Mountain Wind"
	desc = "Blows right through you like a space wind."
	description_fluff = "The 'Space' branding was originally added to the 'Alpha Cola' product line in order to justify selling cans for 50% higher prices to 'off-world' retailers. Despite being chemically identical, Space Cola proved so popular that Centauri Provisions eventually applied the name to the entire product line - price hike and all."
	icon_state = "space_mountain_wind"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/weapon/reagent_containers/food/drinks/cans/space_mountain_wind/Initialize()
	. = ..()
	reagents.add_reagent("spacemountainwind", 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/thirteenloko
	name = "\improper Thirteen Loko"
	desc = "The Vir Health Board has advised consumers that consumption of Thirteen Loko may result in seizures, blindness, drunkenness, or even death. Please Drink Responsibly."
	icon_state = "thirteen_loko"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/weapon/reagent_containers/food/drinks/cans/thirteenloko/Initialize()
	. = ..()
	reagents.add_reagent("thirteenloko", 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/dr_gibb
	name = "\improper Dr. Gibb"
	desc = "A delicious mixture of 42 different flavors."
	description_fluff = "Following a 2490 lawsuit and a spate of deaths, Gilthari Exports reminds customers that the 'Dr.' legally stands for 'Drink'."
	icon_state = "dr_gibb"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/weapon/reagent_containers/food/drinks/cans/dr_gibb/Initialize()
		..()
		reagents.add_reagent("dr_gibb", 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/dr_gibb_diet
	name = "\improper Diet Dr. Gibb"
	desc = "A delicious mixture of 42 different flavors, one of which is water."
	description_fluff = "Following a 2490 lawsuit and a spate of deaths, Gilthari Exports reminds customers that the 'Dr.' legally stands for 'Drink'."
	icon_state = "dr_gibb_diet"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/weapon/reagent_containers/food/drinks/cans/dr_gibb_diet/Initialize()
		..()
		reagents.add_reagent("diet_dr_gibb", 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/starkist
	name = "\improper Star-kist"
	desc = "The taste of a star in liquid form. And, a bit of tuna...?"
	description_fluff = "Brought back by popular demand in 2515 after a limited-run release in 2510, the cult success of this bizarre tasting soda has never truly been accounted for by economists."
	icon_state = "starkist"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/weapon/reagent_containers/food/drinks/cans/starkist/Initialize()
	. = ..()
	reagents.add_reagent("brownstar", 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/space_up
	name = "\improper Space-Up"
	desc = "Tastes like a hull breach in your mouth."
	description_fluff = "The 'Space' branding was originally added to the 'Alpha Cola' product line in order to justify selling cans for 50% higher prices to 'off-world' retailers. Despite being chemically identical, Space Cola proved so popular that Centauri Provisions eventually applied the name to the entire product line - price hike and all."
	icon_state = "space-up"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/weapon/reagent_containers/food/drinks/cans/space_up/Initialize()
	. = ..()
	reagents.add_reagent("space_up", 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/lemon_lime
	name = "\improper Lemon-Lime"
	desc = "You wanted ORANGE. It gave you Lemon-Lime."
	description_fluff = "Not to be confused with 'lemon & lime soda', Lemon-Lime is specially formulated using the highly propriatary Lemon-Lime Fruit. Growing the Lemon-Lime without a license is punishable by fines or jail time. Accept no immitations."
	icon_state = "lemon-lime"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/weapon/reagent_containers/food/drinks/cans/lemon_lime/Initialize()
	. = ..()
	reagents.add_reagent("lemon_lime", 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/iced_tea
	name = "\improper Vrisk Serket Iced Tea"
	desc = "That sweet, refreshing southern earthy flavor. That's where it's from, right? South Earth?"
	description_fluff = "Produced exclusively on the planet Oasis, Vrisk Serket Iced Tea is not sold outside of the Golden Crescent, let alone Earth."
	icon_state = "ice_tea_can"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/weapon/reagent_containers/food/drinks/cans/iced_tea/Initialize()
	. = ..()
	reagents.add_reagent("icetea", 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/grape_juice
	name = "\improper Grapel Juice"
	desc = "500 pages of rules of how to appropriately enter into a combat with this juice!"
	description_fluff = "Strangely, this unassuming grape soda is a product of Hephaestus Industries."
	icon_state = "purple_can"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/weapon/reagent_containers/food/drinks/cans/grape_juice/Initialize()
	. = ..()
	reagents.add_reagent("grapejuice", 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/tonic
	name = "\improper T-Borg's Tonic Water"
	desc = "Quinine tastes funny, but at least it'll keep the Malaria away."
	description_fluff = "Due to its technically medicinal properties and the complexities of chemical copyright law, T-Borg's Tonic Water is a rare product of Zeng-Hu's 'LifeWater' refreshments division."
	icon_state = "tonic"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/weapon/reagent_containers/food/drinks/cans/tonic/Initialize()
	. = ..()
	reagents.add_reagent("tonic", 50)

/obj/item/weapon/reagent_containers/food/drinks/cans/sodawater
	name = "soda water"
	desc = "A can of soda water. Still water's more refreshing cousin."
	icon_state = "sodawater"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/weapon/reagent_containers/food/drinks/cans/sodawater/Initialize()
	. = ..()
	reagents.add_reagent("sodawater", 50)

/obj/item/weapon/reagent_containers/food/drinks/cans/gingerale
	name = "\improper Classic Ginger Ale"
	desc = "For when you need to be more retro than NanoTrasen already pays you for."
	description_fluff = "'Classic' beverages is a registered trademark of the Centauri Provisions corporation."
	icon_state = "gingerale"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/weapon/reagent_containers/food/drinks/cans/gingerale/Initialize()
	. = ..()
	reagents.add_reagent("gingerale", 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/root_beer
	name = "\improper R&D Root Beer"
	desc = "Guaranteed to be both Rootin' and Tootin'."
	description_fluff = "Despite centuries of humanity's expansion, this particular soda is still produced almost exclusively on Earth, in North America."
	icon_state = "root_beer"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/weapon/reagent_containers/food/drinks/cans/root_beer/Initialize()
	. = ..()
	reagents.add_reagent("rootbeer", 30)

