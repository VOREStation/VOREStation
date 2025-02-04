/obj/item/reagent_containers/food/drinks/cans
	volume = 40 //just over one and a half cups
	amount_per_transfer_from_this = 5
	flags = 0 //starts closed
	drop_sound = 'sound/items/drop/soda.ogg'
	pickup_sound = 'sound/items/pickup/soda.ogg'
	cant_chance = 1 //arbitrarily high for april fools; if it's not reverted in its entirety I suggest rolling it down to 2% or something

//DRINKS

/obj/item/reagent_containers/food/drinks/cans/cola
	name = "\improper Space Cola"
	desc = "Reassuringly artificial. Contains caffeine."
	description_fluff = "The 'Space' branding was originally added to the 'Alpha Cola' product line in order to justify selling cans for 50% higher prices to 'off-world' retailers. Despite being chemically identical, Space Cola proved so popular that Centauri Provisions eventually applied the name to the entire product line - price hike and all."
	icon_state = "cola"
	center_of_mass_x = 16
	center_of_mass_y = 10

/obj/item/reagent_containers/food/drinks/cans/cola/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_COLA, 30)

/obj/item/reagent_containers/food/drinks/cans/decaf_cola
	name = "\improper Space Cola Free"
	desc = "More reassuringly artificial than ever before."
	description_fluff = "The 'Space' branding was originally added to the 'Alpha Cola' product line in order to justify selling cans for 50% higher prices to 'off-world' retailers. Despite being chemically identical, Space Cola proved so popular that Centauri Provisions eventually applied the name to the entire product line - price hike and all."
	icon_state = "decafcola"
	center_of_mass_x = 16
	center_of_mass_y = 10

/obj/item/reagent_containers/food/drinks/cans/decaf_cola/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_DECAFCOLA, 30)

/obj/item/reagent_containers/food/drinks/cans/waterbottle
	name = "bottled water"
	desc = "Ice cold and utterly tasteless, this 'all-natural' mineral water comes 'fresh' from one of NanoTrasen's heavy-duty bottling plants in the Sivian poles."
	icon_state = "waterbottle"
	center_of_mass_x = 16
	center_of_mass_y = 8
	drop_sound = 'sound/items/drop/disk.ogg'
	pickup_sound = 'sound/items/pickup/disk.ogg'
	cant_chance = 0

/obj/item/reagent_containers/food/drinks/cans/waterbottle/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_WATER, 30)

/obj/item/reagent_containers/food/drinks/cans/space_mountain_wind
	name = "\improper Space Mountain Wind"
	desc = "Blows right through you like a space wind. Contains caffeine."
	description_fluff = "The 'Space' branding was originally added to the 'Alpha Cola' product line in order to justify selling cans for 50% higher prices to 'off-world' retailers. Despite being chemically identical, Space Cola proved so popular that Centauri Provisions eventually applied the name to the entire product line - price hike and all."
	icon_state = "space_mountain_wind"
	center_of_mass_x = 16
	center_of_mass_y = 8

/obj/item/reagent_containers/food/drinks/cans/space_mountain_wind/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_SPACEMOUNTAINWIND, 30)

/obj/item/reagent_containers/food/drinks/cans/thirteenloko
	name = "\improper Thirteen Loko"
	desc = "The Vir Health Board has advised consumers that consumption of Thirteen Loko may result in seizures, blindness, drunkenness, or even death. Please Drink Responsibly."
	icon_state = "thirteen_loko"
	center_of_mass_x = 16
	center_of_mass_y = 10

/obj/item/reagent_containers/food/drinks/cans/thirteenloko/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_THIRTEENLOKO, 30)

/obj/item/reagent_containers/food/drinks/cans/dr_gibb
	name = "\improper Dr. Gibb"
	desc = "A delicious mixture of 42 different flavors. Contains caffine."
	description_fluff = "Following a 2490 lawsuit and a spate of deaths, Gilthari Exports reminds customers that the 'Dr.' legally stands for 'Drink'."
	icon_state = "dr_gibb"
	center_of_mass_x = 16
	center_of_mass_y = 8

/obj/item/reagent_containers/food/drinks/cans/dr_gibb/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_DRGIBB, 30)

/obj/item/reagent_containers/food/drinks/cans/dr_gibb_diet
	name = "\improper Diet Dr. Gibb"
	desc = "A delicious mixture of 42 different flavors, one of which is water. Contains caffeine."
	description_fluff = "Following a 2490 lawsuit and a spate of deaths, Gilthari Exports reminds customers that the 'Dr.' legally stands for 'Drink'."
	icon_state = "dr_gibb_diet"
	center_of_mass_x = 16
	center_of_mass_y = 8

/obj/item/reagent_containers/food/drinks/cans/dr_gibb_diet/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_DIETDRGIBB, 30)

/obj/item/reagent_containers/food/drinks/cans/starkist
	name = "\improper Star-kist"
	desc = "The taste of a star in liquid form. And, a bit of tuna...? Contains caffeine."
	description_fluff = "Brought back by popular demand in 2275 after a limited-run release in 2270, the cult success of this bizarre tasting soda has never truly been accounted for by economists."
	icon_state = "starkist"
	center_of_mass_x = 16
	center_of_mass_y = 8

/obj/item/reagent_containers/food/drinks/cans/starkist/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_BROWNSTAR, 30)

/obj/item/reagent_containers/food/drinks/cans/starkistdecaf
	name = "\improper Star-kist Classic"
	desc = "The taste of a star in liquid form, in a special decaffineated blend. Still tastes faintly of tuna?"
	description_fluff = "A special variant of the Starkist brand soda introduced after popular outcry following a reformulation of the basic drink decades ago. This decaffineated variant outsells 'New' Starkist in many markets."
	icon_state = "decafstarkist"
	center_of_mass_x = 16
	center_of_mass_y = 8

/obj/item/reagent_containers/food/drinks/cans/starkistdecaf/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_BROWNSTARDECAF, 30)

/obj/item/reagent_containers/food/drinks/cans/space_up
	name = "\improper Space-Up"
	desc = "Tastes like a hull breach in your mouth."
	description_fluff = "The 'Space' branding was originally added to the 'Alpha Cola' product line in order to justify selling cans for 50% higher prices to 'off-world' retailers. Despite being chemically identical, Space Cola proved so popular that Centauri Provisions eventually applied the name to the entire product line - price hike and all."
	icon_state = "space-up"
	center_of_mass_x = 16
	center_of_mass_y = 8

/obj/item/reagent_containers/food/drinks/cans/space_up/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_SPACEUP, 30)

/obj/item/reagent_containers/food/drinks/cans/lemon_lime
	name = "\improper Lemon-Lime"
	desc = "You wanted ORANGE. It gave you Lemon-Lime."
	description_fluff = "Not to be confused with 'lemon & lime soda', Lemon-Lime is specially formulated using the highly propriatary Lemon-Lime Fruit. Growing the Lemon-Lime without a license is punishable by fines or jail time. Accept no immitations."
	icon_state = "lemon-lime"
	center_of_mass_x = 16
	center_of_mass_y = 8

/obj/item/reagent_containers/food/drinks/cans/lemon_lime/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_LEMONLIME, 30)

/obj/item/reagent_containers/food/drinks/cans/iced_tea
	name = "\improper Vrisk Serket Iced Tea"
	desc = "That sweet, refreshing southern earthy flavor. That's where it's from, right? South Earth? Contains caffeine."
	description_fluff = "Produced exclusively on the planet Oasis, Vrisk Serket Iced Tea is not sold outside of the Golden Crescent, let alone Earth."
	icon_state = "ice_tea_can"
	center_of_mass_x = 16
	center_of_mass_y = 8

/obj/item/reagent_containers/food/drinks/cans/iced_tea/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_ICETEA, 30)

/obj/item/reagent_containers/food/drinks/cans/grape_juice
	name = "\improper Grapel Juice"
	desc = "500 pages of rules of how to appropriately enter into a combat with this juice!"
	description_fluff = "Strangely, this unassuming grape soda is a product of Hephaestus Industries."
	icon_state = "purple_can"
	center_of_mass_x = 16
	center_of_mass_y = 8

/obj/item/reagent_containers/food/drinks/cans/grape_juice/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_GRAPEJUICE, 30)

/obj/item/reagent_containers/food/drinks/cans/tonic
	name = "\improper T-Borg's Tonic Water"
	desc = "Quinine tastes funny, but at least it'll keep the Malaria away."
	description_fluff = "Due to its technically medicinal properties and the complexities of chemical copyright law, T-Borg's Tonic Water is a rare product of Zeng-Hu's 'LifeWater' refreshments division."
	icon_state = "tonic"
	center_of_mass_x = 16
	center_of_mass_y = 8

/obj/item/reagent_containers/food/drinks/cans/tonic/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_TONIC, 30)

/obj/item/reagent_containers/food/drinks/cans/sodawater
	name = "soda water"
	desc = "A can of soda water. Still water's more refreshing cousin."
	icon_state = "sodawater"
	center_of_mass_x = 16
	center_of_mass_y = 8

/obj/item/reagent_containers/food/drinks/cans/sodawater/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_SODAWATER, 30)

/obj/item/reagent_containers/food/drinks/cans/gingerale
	name = "\improper Classic Ginger Ale"
	desc = "For when you need to be more retro than NanoTrasen already pays you for."
	description_fluff = "'Classic' beverages is a registered trademark of the Centauri Provisions corporation."
	icon_state = "gingerale"
	center_of_mass_x = 16
	center_of_mass_y = 8

/obj/item/reagent_containers/food/drinks/cans/gingerale/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_GINGERALE, 30)

/obj/item/reagent_containers/food/drinks/cans/root_beer
	name = "\improper R&D Root Beer"
	desc = "Guaranteed to be both Rootin' and Tootin'."
	description_fluff = "Despite centuries of humanity's expansion, this particular soda is still produced almost exclusively on Earth, in North America."
	icon_state = "root_beer"
	center_of_mass_x = 16
	center_of_mass_y = 10

/obj/item/reagent_containers/food/drinks/cans/root_beer/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_ROOTBEER, 30)

/////////////////////////BODA VENDOR DRINKS/////////////////////////

/obj/item/reagent_containers/food/drinks/cans/kvass
	name = "\improper Kvass"
	desc = "A true Slavic soda."
	description_fluff = "A classic Slavic beverage which many space-faring Slavs still enjoy to this day. Fun fact, it is actually considered a weak beer by non-Russians."
	icon_state = "kvass"
	center_of_mass_x = 16
	center_of_mass_y = 10

/obj/item/reagent_containers/food/drinks/cans/kvass/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_KVASS, 30)

/obj/item/reagent_containers/food/drinks/cans/kompot
	name = "\improper Kompot"
	desc = "A taste of Russia in the summertime - canned for you consumption."
	description_fluff = "A sweet and fruity beverage that was traditionally used to preserve fruits in harsh Russian winters that is now available for widespread consumption."
	icon_state = "kompot"
	center_of_mass_x = 16
	center_of_mass_y = 10

/obj/item/reagent_containers/food/drinks/cans/kompot/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_KOMPOT, 30)

/obj/item/reagent_containers/food/drinks/cans/boda
	name = "\improper Boda"
	desc = "State regulated soda beverage. Enjoy comrades."
	icon_state = "boda"
	center_of_mass_x = 16
	center_of_mass_y = 8

/obj/item/reagent_containers/food/drinks/cans/boda/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_SODAWATER, 30)

/obj/item/reagent_containers/food/drinks/cans/bodaplus
	name = "\improper Boda-Plyus"
	desc = "State regulated soda beverage, now with added surplus flavoring. Enjoy comrades."
	icon_state = "bodaplus"
	center_of_mass_x = 16
	center_of_mass_y = 8

/obj/item/reagent_containers/food/drinks/cans/bodaplus/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_SODAWATER, 15)
	reagents.add_reagent(pick(list(
				REAGENT_ID_APPLEJUICE,
				REAGENT_ID_GRAPEJUICE,
				REAGENT_ID_LEMONJUICE,
				REAGENT_ID_LIMEJUICE,
				REAGENT_ID_WATERMELONJUICE,
				REAGENT_ID_BANANA,
				REAGENT_ID_BERRYJUICE,
				REAGENT_ID_PINEAPPLEJUICE)), 15)

/obj/item/reagent_containers/food/drinks/cans/redarmy
	name = "\improper Red Army Twist"
	desc = "A taste of what keeps our glorious nation running! Served as Space Commissariat Stahlin prefers it! Luke warm."
	icon_state = "red_army"
	center_of_mass_x = 16
	center_of_mass_y = 8

/obj/item/reagent_containers/food/drinks/cans/redarmy/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_POTATOJUICE, 15)
	reagents.add_reagent(REAGENT_ID_SODAWATER, 15)

/obj/item/reagent_containers/food/drinks/cans/arstbru
	name = "\improper Arstotzka Brü"
	desc = "Just what any bureaucrat needs to get through the day. Keep stamping those papers!"
	icon_state = "arst_bru"
	center_of_mass_x = 16
	center_of_mass_y = 8

/obj/item/reagent_containers/food/drinks/cans/arstbru/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_TURNIPJUICE, 30)

/obj/item/reagent_containers/food/drinks/cans/terra_cola
	name = "\improper Terra-Cola"
	desc = "Made by the people. Served to the people."
	description_fluff = "A can of the only soft drink state approved for the benefit of the people. Served at room temperature regardless of ambient temperatures thanks to innovative Terran insulation technology."
	icon_state = "terra_cola"
	center_of_mass_x = 16
	center_of_mass_y = 8

/obj/item/reagent_containers/food/drinks/cans/terra_cola/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_WATER, 25)
	reagents.add_reagent(REAGENT_ID_IRON, 5)

/////////////////////////MISC VENDOR DRINKS/////////////////////////

/obj/item/reagent_containers/food/drinks/cans/straw_cola
	name = "\improper Superior Strawberry"
	desc = "Feel superior above all with Superior Strawberry!"
	icon_state = "strawcoke"
	center_of_mass_x = 16
	center_of_mass_y = 8

/obj/item/reagent_containers/food/drinks/cans/straw_cola/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_STRAWSODA, 30)

/obj/item/reagent_containers/food/drinks/cans/apple_cola
	name = "\improper Andromeda Apple"
	desc = "Look to the stars and prepare to explore with Andromeda Apple!"
	icon_state = "applecoke"
	center_of_mass_x = 16
	center_of_mass_y = 8

/obj/item/reagent_containers/food/drinks/cans/apple_cola/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_APPLESODA, 30)

/obj/item/reagent_containers/food/drinks/cans/lemon_cola
	name = "\improper Lunar Lemon"
	desc = "Feel back at home on the Lunar Colonies with this classic beverage straight from the source!"
	icon_state = "lemoncoke"
	center_of_mass_x = 16
	center_of_mass_y = 8

/obj/item/reagent_containers/food/drinks/cans/lemon_cola/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_LEMONSODA, 30)

/obj/item/reagent_containers/food/drinks/cans/sarsaparilla
	name = "\improper Starship Sarsaparilla"
	desc = "Take off and shoot for the stars with this classic cowboy cola!"
	icon_state = "sarsaparilla"
	center_of_mass_x = 16
	center_of_mass_y = 8

/obj/item/reagent_containers/food/drinks/cans/sarsaparilla/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_SARSAPARILLA, 30)

/obj/item/reagent_containers/food/drinks/cans/grape_cola
	name = "\improper Gravity Grape"
	desc = "Get down with Newton's favorite carbonated science experiment!"
	icon_state = "grapesoda"
	center_of_mass_x = 16
	center_of_mass_y = 8

/obj/item/reagent_containers/food/drinks/cans/grape_cola/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_GRAPESODA, 30)

/obj/item/reagent_containers/food/drinks/cans/orange_cola
	name = "\improper Orion Orange"
	desc = "Take a taste-tastic trip to Orion's Belt with Orion Orange!"
	icon_state = "orangesoda"
	center_of_mass_x = 16
	center_of_mass_y = 8

/obj/item/reagent_containers/food/drinks/cans/orange_cola/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_ORANGESODA, 30)

/obj/item/reagent_containers/food/drinks/cans/baconsoda
	name = "\improper Bacon Soda"
	desc = "Taste something out of this world with Bacon Soda!"
	icon_state = "porkcoke"
	center_of_mass_x = 16
	center_of_mass_y = 8

/obj/item/reagent_containers/food/drinks/cans/baconsoda/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_PORKSODA, 30)

/obj/item/reagent_containers/food/drinks/cans/bepis
	name = "\improper Bepis"
	desc = "It has a smell of 'off-brand' whenever you open it..."
	description_fluff = "Puts the 'B' in Best Soda! Bepis is the number one competitor to \
	Space Cola and has vendors scattered across the frontier. While the drink is not as \
	popular as Space Cola, many people across known space enjoy the sweet beverage."
	icon = 'icons/obj/drinks_vr.dmi'
	icon_state = "bepis"
	center_of_mass_x = 16
	center_of_mass_y = 10

/obj/item/reagent_containers/food/drinks/cans/bepis/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_BEPIS, 30)

/obj/item/reagent_containers/food/drinks/cans/astrodew
	name = "\improper Astro Dew Spring Water"
	desc = "A can of refreshing 'spring' water! Or so the can claims."
	icon = 'icons/obj/drinks_vr.dmi'
	icon_state = "watercan"
	center_of_mass_x = 16
	center_of_mass_y = 10

/obj/item/reagent_containers/food/drinks/cans/astrodew/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_WATER, 30)

/obj/item/reagent_containers/food/drinks/cans/icecoffee
	name = "\improper Café Del Consumir"
	desc = "A can of deliciously sweet iced coffee that originates from Earth."
	description_fluff = "Café Del Consumir originates from a small coffee brewery in México \
	that still operates to this day. Café Del Consumir prides itself on being true to form \
	and retaining its original recipe. They've been producing and selling their product across \
	the galaxy for decades without fail. NanoTrasen has attempted to by out the small company for \
	years now, however all attempts they've made have failed."
	icon = 'icons/obj/drinks_vr.dmi'
	icon_state = "coffeecan"
	center_of_mass_x = 16
	center_of_mass_y = 10

/obj/item/reagent_containers/food/drinks/cans/icecoffee/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_ICECOFFEE, 30)

/obj/item/reagent_containers/food/drinks/cans/buzz
	name = "\improper Buzz Fuzz"
	desc = "Uses real honey, making it a sweet tooth's dream drink."
	icon = 'icons/obj/drinks_vr.dmi'
	icon_state = "buzzfuzz"
	center_of_mass_x = 16
	center_of_mass_y = 10

/obj/item/reagent_containers/food/drinks/cans/buzz/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_BUZZFUZZ, 30)

/obj/item/reagent_containers/food/drinks/cans/shambler
	name = "\improper Shambler's Juice"
	desc = "~Shake me up some of that Shambler's Juice!~"
	icon = 'icons/obj/drinks_vr.dmi'
	icon_state = "shambler"
	center_of_mass_x = 16
	center_of_mass_y = 10

/obj/item/reagent_containers/food/drinks/cans/shambler/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_SHAMBLERS, 30)

/obj/item/reagent_containers/food/drinks/cans/cranberry
	name = "\improper Sprited Cranberry"
	desc = "A delicious blend of fresh cranberry juice and various spices, the perfect drink."
	icon = 'icons/obj/drinks_vr.dmi'
	icon_state = "cranberry"
	center_of_mass_x = 16
	center_of_mass_y = 10

/obj/item/reagent_containers/food/drinks/cans/cranberry/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_SPRITEDCRANBERRY, 30)

/////////////////////////CANNED BOOZE DRINKS/////////////////////////

/obj/item/reagent_containers/food/drinks/cans/beercan
	name = "\improper Sunshine Brew"
	desc = "Beat the heat with this refreshing brewed beverage."
	icon_state = "beercan"
	center_of_mass_x = 16
	center_of_mass_y = 8

/obj/item/reagent_containers/food/drinks/cans/beercan/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_BEER, 30)

/obj/item/reagent_containers/food/drinks/cans/alecan
	name = "\improper Spacecastle Pale Ale"
	desc = "A delicious IPA that's canned for your pleasure. Drink up!"
	icon_state = "alecan"
	center_of_mass_x = 16
	center_of_mass_y = 8

/obj/item/reagent_containers/food/drinks/cans/alecan/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_ALE, 30)

/////////////////////////ENERGY DRINKS/////////////////////////

/obj/item/reagent_containers/food/drinks/cans/nukie_peach
	name = "\improper Nukies - Peach Blaster"
	desc = "Harness the power of the atom with this over-caffinated energy drink."
	icon_state = "nukie_peach"
	center_of_mass_x = 16
	center_of_mass_y = 8
	volume = 60

/obj/item/reagent_containers/food/drinks/cans/nukie_peach/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_NUKIEPEACH, 60)

/obj/item/reagent_containers/food/drinks/cans/nukie_pear
	name = "\improper Nukies - Great Pear"
	desc = "Harness the power of the atom with this over-caffinated energy drink."
	icon_state = "nukie_pear"
	center_of_mass_x = 16
	center_of_mass_y = 8
	volume = 60

/obj/item/reagent_containers/food/drinks/cans/nukie_pear/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_NUKIEPEAR, 60)

/obj/item/reagent_containers/food/drinks/cans/nukie_cherry
	name = "\improper Nukies - Popping Cherry"
	desc = "Harness the power of the atom with this over-caffinated energy drink."
	icon_state = "nukie_cherry"
	center_of_mass_x = 16
	center_of_mass_y = 8
	volume = 60

/obj/item/reagent_containers/food/drinks/cans/nukie_cherry/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_NUKIECHERRY, 60)

/obj/item/reagent_containers/food/drinks/cans/nukie_melon
	name = "\improper Nukies - Melon Squirter"
	desc = "Harness the power of the atom with this over-caffinated energy drink."
	icon_state = "nukie_melon"
	center_of_mass_x = 16
	center_of_mass_y = 8
	volume = 60

/obj/item/reagent_containers/food/drinks/cans/nukie_melon/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_NUKIEMELON, 60)

/obj/item/reagent_containers/food/drinks/cans/nukie_banana
	name = "\improper Nukies - Bursting Banana"
	desc = "Harness the power of the atom with this over-caffinated energy drink."
	icon_state = "nukie_banana"
	center_of_mass_x = 16
	center_of_mass_y = 8
	volume = 60

/obj/item/reagent_containers/food/drinks/cans/nukie_banana/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_NUKIEBANANA, 60)

/obj/item/reagent_containers/food/drinks/cans/nukie_rose
	name = "\improper Nukies - Insatiable Rose"
	desc = "Harness the power of the atom with this over-caffinated energy drink."
	icon_state = "nukie_rose"
	center_of_mass_x = 16
	center_of_mass_y = 8
	volume = 60

/obj/item/reagent_containers/food/drinks/cans/nukie_rose/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_NUKIEROSE, 60)

/obj/item/reagent_containers/food/drinks/cans/nukie_lemon
	name = "\improper Nukies - Citrus Got Real"
	desc = "Harness the power of the atom with this over-caffinated energy drink."
	icon_state = "nukie_lemon"
	center_of_mass_x = 16
	center_of_mass_y = 8
	volume = 60

/obj/item/reagent_containers/food/drinks/cans/nukie_lemon/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_NUKIELEMON, 60)

/obj/item/reagent_containers/food/drinks/cans/nukie_fruit
	name = "\improper Nukies - Swelling Fruit"
	desc = "Harness the power of the atom with this over-caffinated energy drink."
	icon_state = "nukie_fruit"
	center_of_mass_x = 16
	center_of_mass_y = 8
	volume = 60

/obj/item/reagent_containers/food/drinks/cans/nukie_fruit/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_NUKIEFRUIT, 60)

/obj/item/reagent_containers/food/drinks/cans/nukie_special
	name = "\improper Nukies - Limited Edition"
	desc = "Harness the power of the atom with this over-caffinated energy drink."
	icon_state = "nukie_special"
	center_of_mass_x = 16
	center_of_mass_y = 8
	volume = 60

/obj/item/reagent_containers/food/drinks/cans/nukie_special/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_NUKIESPECIAL, 60)

/////////////////////////MEGA NUKIES/////////////////////////
//Rare loot energy drinks with special properties, for the funnies.

/obj/item/reagent_containers/food/drinks/cans/nukie_mega_sight
	name = "\improper Nukies Mega - Plum Peeper"
	desc = "Harness the power of the atom with this illegal, unfit for organic consumption and absolutely not regulator approved energy drink."
	icon_state = "nukie_mega_sight"
	center_of_mass_x = 16
	center_of_mass_y = 8
	volume = 60

/obj/item/reagent_containers/food/drinks/cans/nukie_mega_sight/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_NUKIEMEGASIGHT, 60)

/obj/item/reagent_containers/food/drinks/cans/nukie_mega_heart
	name = "\improper Nukies Mega - Juice Pumper"
	desc = "Harness the power of the atom with this illegal, unfit for organic consumption and absolutely not regulator approved energy drink."
	icon_state = "nukie_mega_heart"
	center_of_mass_x = 16
	center_of_mass_y = 8
	volume = 60

/obj/item/reagent_containers/food/drinks/cans/nukie_mega_heart/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_NUKIEMEGAHEART, 60)

/obj/item/reagent_containers/food/drinks/cans/nukie_mega_sleep
	name = "\improper Nukies Nega - Vibrating Nights"
	desc = "Harness the power of the atom with this illegal, unfit for organic consumption and absolutely not regulator approved energy drink."
	icon_state = "nukie_mega_sleep"
	center_of_mass_x = 16
	center_of_mass_y = 8
	volume = 60

/obj/item/reagent_containers/food/drinks/cans/nukie_mega_sleep/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_NUKIEMEGASLEEP, 60)

/obj/item/reagent_containers/food/drinks/cans/nukie_mega_shock
	name = "\improper Nukies Mega - Jolt Railer"
	desc = "Harness the power of the atom with this illegal, unfit for organic consumption and absolutely not regulator approved energy drink."
	icon_state = "nukie_mega_strong"
	center_of_mass_x = 16
	center_of_mass_y = 8
	volume = 60

/obj/item/reagent_containers/food/drinks/cans/nukie_mega_shock/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_NUKIEMEGASHOCK, 60)

/obj/item/reagent_containers/food/drinks/cans/nukie_mega_fast
	name = "\improper Nukies Mega - Rapid Rager"
	desc = "Harness the power of the atom with this illegal, unfit for organic consumption and absolutely not regulator approved energy drink."
	icon_state = "nukie_mega_fast"
	center_of_mass_x = 16
	center_of_mass_y = 8
	volume = 60

/obj/item/reagent_containers/food/drinks/cans/nukie_mega_fast/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_NUKIEMEGAFAST, 60)

/obj/item/reagent_containers/food/drinks/cans/nukie_mega_high
	name = "\improper Nukies Mega - Diamond Sky"
	desc = "Harness the power of the atom with this illegal, unfit for organic consumption and absolutely not regulator approved energy drink."
	icon_state = "nukie_mega_high"
	center_of_mass_x = 16
	center_of_mass_y = 8
	volume = 60

/obj/item/reagent_containers/food/drinks/cans/nukie_mega_high/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_NUKIEMEGAHIGH, 60)

/obj/item/reagent_containers/food/drinks/cans/nukie_mega_shrink
	name = "\improper Nukies Mega - Shrinking Flower"
	desc = "Harness the power of the atom with this illegal, unfit for organic consumption and absolutely not regulator approved energy drink."
	icon_state = "nukie_mega_shrink"
	center_of_mass_x = 16
	center_of_mass_y = 8
	volume = 60

/obj/item/reagent_containers/food/drinks/cans/nukie_mega_shrink/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_NUKIEMEGASHRINK, 60)

/obj/item/reagent_containers/food/drinks/cans/nukie_mega_grow
	name = "\improper Nukies Mega - Growing Geyser"
	desc = "Harness the power of the atom with this illegal, unfit for organic consumption and absolutely not regulator approved energy drink."
	icon_state = "nukie_mega_grow"
	center_of_mass_x = 16
	center_of_mass_y = 8
	volume = 60

/obj/item/reagent_containers/food/drinks/cans/nukie_mega_grow/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_NUKIEMEGAGROWTH, 60)
