// For convenience and easier comparing and maintaining of item prices,
// all these will be defined here and sorted in different sections.

// The item price in thalers. atom/movable so we can also assign a price to animals and other things.
/atom/movable/var/price_tag = null

// The proc that is called when the price is being asked for. Use this to refer to another object if necessary.
/atom/movable/proc/get_item_cost()
	return price_tag


//***************//
//---Beverages---//
//***************//

/datum/reagent/var/price_tag = 0


// Juices, soda and similar //

/datum/reagent/water
	price_tag = 2

/datum/reagent/drink/juice
	price_tag = 2

/datum/reagent/toxin/poisonberryjuice
	price_tag = 2

/datum/reagent/drink/milk
	price_tag = 2

/datum/reagent/drink/soda
	price_tag = 2

/datum/reagent/drink/doctor_delight
	price_tag = 2

/datum/reagent/drink/nothing
	price_tag = 2

/datum/reagent/drink/milkshake
	price_tag = 2

/datum/reagent/drink/roy_rogers
	price_tag = 2

/datum/reagent/drink/shirley_temple
	price_tag = 2

/datum/reagent/drink/arnold_palmer
	price_tag = 2

/datum/reagent/drink/collins_mix
	price_tag = 2


// Beer //

/datum/reagent/ethanol/ale
	price_tag = 2

/datum/reagent/ethanol/beer
	price_tag = 2


// Hot Drinks //

/datum/reagent/drink/rewriter
	price_tag = 3

/datum/reagent/drink/tea
	price_tag = 3

/datum/reagent/drink/coffee
	price_tag = 3

/datum/reagent/drink/hot_coco
	price_tag = 3

/obj/item/food/drinks/coffee
	price_tag = 3

/obj/item/food/drinks/tea
	price_tag = 3

/obj/item/food/drinks/h_chocolate
	price_tag = 3


// Spirituous liquors //

/datum/reagent/ethanol/irish_cream
	price_tag = 5

/datum/reagent/ethanol/absinthe
	price_tag = 5

/datum/reagent/ethanol/bluecuracao
	price_tag = 5

/datum/reagent/ethanol/deadrum
	price_tag = 5

/datum/reagent/ethanol/gin
	price_tag = 5

/datum/reagent/ethanol/coffee/kahlua
	price_tag = 5

/datum/reagent/ethanol/melonliquor
	price_tag = 5

/datum/reagent/ethanol/rum
	price_tag = 5

/datum/reagent/ethanol/tequila
	price_tag = 5

/datum/reagent/ethanol/thirteenloko
	price_tag = 5

/datum/reagent/ethanol/vodka
	price_tag = 5

/datum/reagent/ethanol/whiskey
	price_tag = 5

/datum/reagent/ethanol/specialwhiskey
	price_tag = 5

/datum/reagent/ethanol/patron
	price_tag = 5

/datum/reagent/ethanol/goldschlager
	price_tag = 5

/datum/reagent/ethanol/coffee/brave_bull // Not an original liquor in its own. But since it's a mix of purely Tequila
	price_tag = 5						 // and Kahlua, it's basically just another one and gets the same price.


// Wines //

/datum/reagent/ethanol/wine
	price_tag = 8

/datum/reagent/ethanol/cognac
	price_tag = 8

/datum/reagent/ethanol/sake
	price_tag = 8

/datum/reagent/ethanol/vermouth
	price_tag = 8

/datum/reagent/ethanol/pwine
	price_tag = 8


// Cocktails //

/datum/reagent/ethanol/acid_spit
	price_tag = 4

/datum/reagent/ethanol/alliescocktail
	price_tag = 4

/datum/reagent/ethanol/aloe
	price_tag = 4

/datum/reagent/ethanol/amasec
	price_tag = 4

/datum/reagent/ethanol/andalusia
	price_tag = 4

/datum/reagent/ethanol/antifreeze
	price_tag = 4

/datum/reagent/ethanol/atomicbomb
	price_tag = 4

/datum/reagent/ethanol/coffee/b52
	price_tag = 4

/datum/reagent/ethanol/bahama_mama
	price_tag = 4

/datum/reagent/ethanol/barefoot
	price_tag = 4

/datum/reagent/ethanol/beepsky_smash
	price_tag = 4

/datum/reagent/ethanol/bilk
	price_tag = 4

/datum/reagent/ethanol/black_russian
	price_tag = 4

/datum/reagent/ethanol/bloody_mary
	price_tag = 4

/datum/reagent/ethanol/booger
	price_tag = 4

/datum/reagent/ethanol/coffee/brave_bull
	price_tag = 4

/datum/reagent/ethanol/changeling_sting
	price_tag = 4

/datum/reagent/ethanol/martini
	price_tag = 4

/datum/reagent/ethanol/cuba_libre
	price_tag = 4

/datum/reagent/ethanol/rum_and_cola
	price_tag = 4

/datum/reagent/ethanol/demonsblood
	price_tag = 4

/datum/reagent/ethanol/devilskiss
	price_tag = 4

/datum/reagent/ethanol/driestmartini
	price_tag = 4

/datum/reagent/ethanol/ginfizz
	price_tag = 4

/datum/reagent/ethanol/grog
	price_tag = 4

/datum/reagent/ethanol/erikasurprise
	price_tag = 4

/datum/reagent/ethanol/gargle_blaster
	price_tag = 4

/datum/reagent/ethanol/gintonic
	price_tag = 4

/datum/reagent/ethanol/hippies_delight
	price_tag = 4

/datum/reagent/ethanol/iced_beer
	price_tag = 4

/datum/reagent/ethanol/irishcarbomb
	price_tag = 4

/datum/reagent/ethanol/coffee/irishcoffee
	price_tag = 4

/datum/reagent/ethanol/longislandicedtea
	price_tag = 4

/datum/reagent/ethanol/manhattan
	price_tag = 4

/datum/reagent/ethanol/manhattan_proj
	price_tag = 4

/datum/reagent/ethanol/manly_dorf
	price_tag = 4

/datum/reagent/ethanol/margarita
	price_tag = 4

/datum/reagent/ethanol/mead
	price_tag = 4

/datum/reagent/ethanol/moonshine
	price_tag = 4

/datum/reagent/ethanol/neurotoxin
	price_tag = 4

/datum/reagent/ethanol/red_mead
	price_tag = 4

/datum/reagent/ethanol/sbiten
	price_tag = 4

/datum/reagent/ethanol/screwdrivercocktail
	price_tag = 4

/datum/reagent/ethanol/silencer
	price_tag = 4

/datum/reagent/ethanol/singulo
	price_tag = 4

/datum/reagent/ethanol/snowwhite
	price_tag = 4

/datum/reagent/ethanol/suidream
	price_tag = 4

/datum/reagent/ethanol/syndicatebomb
	price_tag = 4

/datum/reagent/ethanol/tequila_sunrise
	price_tag = 4

/datum/reagent/ethanol/threemileisland
	price_tag = 4

/datum/reagent/ethanol/toxins_special
	price_tag = 4

/datum/reagent/ethanol/vodkamartini
	price_tag = 4

/datum/reagent/ethanol/vodkatonic
	price_tag = 4

/datum/reagent/ethanol/white_russian
	price_tag = 4

/datum/reagent/ethanol/whiskey_cola
	price_tag = 4

/datum/reagent/ethanol/whiskeysoda
	price_tag = 4

/datum/reagent/ethanol/binmanbliss
	price_tag = 4

/datum/reagent/ethanol/xanaducannon
	price_tag = 4

/datum/reagent/ethanol/balloon
	price_tag = 4

/datum/reagent/ethanol/coffee/elysiumfacepunch
	price_tag = 4

/datum/reagent/ethanol/saketini
	price_tag = 4

/datum/reagent/ethanol/tokyorose
	price_tag = 4

/datum/reagent/ethanol/ginzamary
	price_tag = 4

/datum/reagent/ethanol/tamagozake
	price_tag = 4

/datum/reagent/ethanol/sakebomb
	price_tag = 4

/datum/reagent/ethanol/erebusmoonrise
	price_tag = 4

// The Cheap Shit //

/datum/reagent/ethanol/hooch
	price_tag = 2

/datum/reagent/ethanol/debugger
	price_tag = 2

/datum/reagent/ethanol/spacersbrew
	price_tag = 2

/datum/reagent/ethanol/natunabrandy
	price_tag = 2

// Cocktails without alcohol //

/datum/reagent/ethanol/bananahonk
	price_tag = 3

// From the machine //

/obj/item/food/drinks/cans/cola
	price_tag = 1

/obj/item/food/drinks/cans/space_mountain_wind
	price_tag = 1

/obj/item/food/drinks/cans/dr_gibb
	price_tag = 1

/obj/item/food/drinks/cans/starkist
	price_tag = 1

/obj/item/food/drinks/cans/waterbottle
	price_tag = 2

/obj/item/food/drinks/cans/space_up
	price_tag = 1

/obj/item/food/drinks/cans/iced_tea
	price_tag = 1

/obj/item/food/drinks/cans/grape_juice
	price_tag = 1

/obj/item/food/drinks/cans/gingerale
	price_tag = 1

//***************//
//----Bottles----//
//***************//

// Juices, soda and similar //

/obj/item/food/drinks/bottle/cola
	price_tag = 6

/obj/item/food/drinks/bottle/space_up
	price_tag = 6

/obj/item/food/drinks/bottle/space_mountain_wind
	price_tag = 6

/obj/item/food/drinks/bottle/orangejuice
	price_tag = 6

/obj/item/food/drinks/bottle/applejuice
	price_tag = 6

/obj/item/food/drinks/bottle/cream
	price_tag = 6

/obj/item/food/drinks/bottle/tomatojuice
	price_tag = 6

/obj/item/food/drinks/bottle/limejuice
	price_tag = 6


// Beer //

/obj/item/food/drinks/bottle/small/beer
	price_tag = 3

/obj/item/food/drinks/bottle/small/ale
	price_tag = 3


// Spirituous Liquors //

/obj/item/food/drinks/bottle/absinthe
	price_tag = 15

/obj/item/food/drinks/bottle/bluecuracao
	price_tag = 15

/obj/item/food/drinks/bottle/gin
	price_tag = 15

/obj/item/food/drinks/bottle/kahlua
	price_tag = 15

/obj/item/food/drinks/bottle/melonliquor
	price_tag = 15

/obj/item/food/drinks/bottle/rum
	price_tag = 15

/obj/item/food/drinks/bottle/tequila
	price_tag = 15

/obj/item/food/drinks/bottle/vodka
	price_tag = 15

/obj/item/food/drinks/bottle/whiskey
	price_tag = 15

/obj/item/food/drinks/bottle/specialwhiskey
	price_tag = 15

/obj/item/food/drinks/bottle/patron
	price_tag = 15

/obj/item/food/drinks/bottle/goldschlager
	price_tag = 15

/obj/item/food/drinks/bottle/bottleofnothing
	price_tag = 15

/obj/item/food/drinks/bottle/grenadine
	price_tag = 15


// Wines //

/obj/item/food/drinks/bottle/wine
	price_tag = 25

/obj/item/food/drinks/bottle/cognac
	price_tag = 25

/obj/item/food/drinks/bottle/vermouth
	price_tag = 25

/obj/item/food/drinks/bottle/pwine
	price_tag = 25

/obj/item/food/drinks/bottle/sake
	price_tag = 25

/obj/item/food/drinks/bottle/jager
	price_tag = 25

//***************//
//---Foodstuff---//
//***************//

// Snacks //

/obj/item/food/candy
	price_tag = 1

/obj/item/food/sosjerky
	price_tag = 2

/obj/item/food/unajerky
	price_tag = 12

/obj/item/food/cheesiehonkers
	price_tag = 1

/obj/item/food/tastybread
	price_tag = 2

/obj/item/food/no_raisin
	price_tag = 1

/obj/item/food/packaged/spacetwinkie
	price_tag = 1

/obj/item/food/skrellsnacks
	price_tag = 4

/obj/item/food/chips
	price_tag = 1

/obj/item/food/drinks/dry_ramen
	price_tag = 5


// Burger //

/obj/item/food/brainburger
	price_tag = 2

/obj/item/food/ghostburger
	price_tag = 2

/obj/item/food/human/burger
	price_tag = 2

/obj/item/food/cheeseburger
	price_tag = 2

/obj/item/food/monkeyburger
	price_tag = 2

/obj/item/food/fishburger
	price_tag = 2

/obj/item/food/tofuburger
	price_tag = 2

/obj/item/food/roburger
	price_tag = 2

/obj/item/food/roburgerbig
	price_tag = 2

/obj/item/food/xenoburger
	price_tag = 2

/obj/item/food/clownburger
	price_tag = 2

/obj/item/food/mimeburger
	price_tag = 2

/obj/item/food/spellburger
	price_tag = 2

/obj/item/food/jellyburger
	price_tag = 2

/obj/item/food/bigbiteburger
	price_tag = 4

/obj/item/food/superbiteburger
	price_tag = 8


// Sandwiches //

/obj/item/food/sandwich
	price_tag = 3

/obj/item/food/toastedsandwich
	price_tag = 3

/obj/item/food/grilledcheese
	price_tag = 3

/obj/item/food/jellysandwich
	price_tag = 3


// Cookies and Candies //

/obj/item/food/cookie
	price_tag = 1

/obj/item/food/chocolatebar
	price_tag = 1

/obj/item/food/chocolateegg
	price_tag = 1

/obj/item/food/candy_corn
	price_tag = 1

/obj/item/food/donut
	price_tag = 1

/obj/item/food/donut/chaos
	price_tag = 5

/obj/item/food/popcorn
	price_tag = 3

/obj/item/food/fortunecookie
	price_tag = 1

/obj/item/food/candiedapple
	price_tag = 2

/obj/item/food/plumphelmetbiscuit
	price_tag = 1

/obj/item/food/chawanmushi
	price_tag = 2

/obj/item/food/cracker
	price_tag = 1


// Full meals //

/obj/item/food/friedegg
	price_tag = 5

/obj/item/food/tofurkey
	price_tag = 5

/obj/item/food/carpmeat
	price_tag = 5

/obj/item/food/fishfingers
	price_tag = 5

/obj/item/food/omelette
	price_tag = 5

/obj/item/food/berryclafoutis
	price_tag = 5

/obj/item/food/waffles
	price_tag = 5

/obj/item/food/eggplantparm
	price_tag = 5

/obj/item/food/soylentgreen
	price_tag = 5

/obj/item/food/soylenviridians
	price_tag = 5

/obj/item/food/wingfangchu
	price_tag = 5

/obj/item/food/monkeykabob
	price_tag = 5

/obj/item/food/tofukabob
	price_tag = 5

/obj/item/food/cubancarp
	price_tag = 5

/obj/item/food/loadedbakedpotato
	price_tag = 5

/obj/item/food/fries
	price_tag = 5

/obj/item/food/spagetti
	price_tag = 5

/obj/item/food/cheesyfries
	price_tag = 5

/obj/item/food/enchiladas
	price_tag = 5

/obj/item/food/taco
	price_tag = 5

/obj/item/food/monkeysdelight
	price_tag = 5

/obj/item/food/fishandchips
	price_tag = 5

/obj/item/food/rofflewaffles
	price_tag = 5

/obj/item/food/stew
	price_tag = 5

/obj/item/food/stewedsoymeat
	price_tag = 5

/obj/item/food/boiledspagetti
	price_tag = 5

/obj/item/food/boiledrice
	price_tag = 5

/obj/item/food/ricepudding
	price_tag = 5

/obj/item/food/pastatomato
	price_tag = 5

/obj/item/food/meatballspagetti
	price_tag = 5

/obj/item/food/spesslaw
	price_tag = 5

/obj/item/food/carrotfries
	price_tag = 5

/obj/item/food/appletart
	price_tag = 5

/obj/item/food/sliceable/pizza
	price_tag = 5

/obj/item/food/slice/margherita
	price_tag = 1

/obj/item/food/slice/meatpizza
	price_tag = 1

/obj/item/food/slice/mushroompizza
	price_tag = 1

/obj/item/food/slice/vegetablepizza
	price_tag = 1

// Baked Goods //

/obj/item/food/poppypretzel
	price_tag = 2

/obj/item/food/baguette
	price_tag = 2

/obj/item/food/jelliedtoast
	price_tag = 1

/obj/item/food/twobread
	price_tag = 2

/obj/item/food/sliceable/meatbread
	price_tag = 5

/obj/item/food/slice/meatbread
	price_tag = 1

/obj/item/food/sliceable/xenomeatbread
	price_tag = 5

/obj/item/food/slice/xenomeatbread
	price_tag = 1

/obj/item/food/sliceable/bananabread
	price_tag = 5

/obj/item/food/slice/bananabread
	price_tag = 1

/obj/item/food/sliceable/tofubread
	price_tag = 5

/obj/item/food/slice/tofubread
	price_tag = 1

/obj/item/food/sliceable/bread
	price_tag = 5

/obj/item/food/slice/bread
	price_tag = 1

/obj/item/food/sliceable/creamcheesebread
	price_tag = 5

/obj/item/food/slice/creamcheesebread
	price_tag = 1


// Soups //

/obj/item/food/meatballsoup
	price_tag = 3

/obj/item/food/slimesoup
	price_tag = 3

/obj/item/food/bloodsoup
	price_tag = 3

/obj/item/food/clownstears
	price_tag = 3

/obj/item/food/vegetablesoup
	price_tag = 3

/obj/item/food/nettlesoup
	price_tag = 3

/obj/item/food/mysterysoup
	price_tag = 3

/obj/item/food/wishsoup
	price_tag = 3

/obj/item/food/hotchili
	price_tag = 3

/obj/item/food/coldchili
	price_tag = 3

/obj/item/food/tomatosoup
	price_tag = 3

/obj/item/food/milosoup
	price_tag = 3

/obj/item/food/mushroomsoup
	price_tag = 3

/obj/item/food/beetsoup
	price_tag = 3


// Pies //

/obj/item/food/pie
	price_tag = 4

/obj/item/food/meatpie
	price_tag = 4

/obj/item/food/tofupie
	price_tag = 4

/obj/item/food/plump_pie
	price_tag = 4

/obj/item/food/xemeatpie
	price_tag = 4

/obj/item/food/applepie
	price_tag = 4

/obj/item/food/cherrypie
	price_tag = 4


// Cakes //

/obj/item/food/sliceable/carrotcake
	price_tag = 5

/obj/item/food/slice/carrotcake
	price_tag = 1

/obj/item/food/sliceable/braincake
	price_tag = 5

/obj/item/food/slice/braincake
	price_tag = 1

/obj/item/food/sliceable/cheesecake
	price_tag = 5

/obj/item/food/slice/cheesecake
	price_tag = 1

/obj/item/food/sliceable/plaincake
	price_tag = 5

/obj/item/food/slice/plaincake
	price_tag = 1

/obj/item/food/sliceable/orangecake
	price_tag = 5

/obj/item/food/slice/orangecake
	price_tag = 1

/obj/item/food/sliceable/limecake
	price_tag = 5

/obj/item/food/slice/limecake
	price_tag = 1

/obj/item/food/sliceable/lemoncake
	price_tag = 5

/obj/item/food/slice/lemoncake
	price_tag = 1

/obj/item/food/sliceable/chocolatecake
	price_tag = 5

/obj/item/food/slice/chocolatecake
	price_tag = 1

/obj/item/food/sliceable/birthdaycake
	price_tag = 5

/obj/item/food/slice/birthdaycake
	price_tag = 1

/obj/item/food/sliceable/applecake
	price_tag = 5

/obj/item/food/slice/applecake
	price_tag = 1

/obj/item/food/sliceable/pumpkinpie
	price_tag = 5

/obj/item/food/slice/pumpkinpie
	price_tag = 1


// Misc //

/obj/item/food/boiledegg
	price_tag = 2

/obj/item/food/donkpocket
	price_tag = 1

/obj/item/food/sausage
	price_tag = 2

/obj/item/food/muffin
	price_tag = 2

/obj/item/food/tossedsalad
	price_tag = 2

/obj/item/food/validsalad
	price_tag = 2

/obj/item/food/dionaroast
	price_tag = 25

/obj/item/pizzabox/get_item_cost()
	return get_item_cost(pizza)


//***************//
//----Smokes-----//
//***************//

/obj/item/storage/fancy/cigarettes
	price_tag = 15

/obj/item/storage/fancy/cigarettes/luckystars
	price_tag = 17

/obj/item/storage/fancy/cigarettes/jerichos
	price_tag = 22

/obj/item/storage/fancy/cigarettes/menthols
	price_tag = 18

/obj/item/storage/fancy/cigar
	price_tag = 27

/obj/item/storage/fancy/cigarettes/carcinomas
	price_tag  = 23

/obj/item/storage/fancy/cigarettes/professionals
	price_tag = 25

/obj/item/storage/box/matches
	price_tag = 1

/obj/item/flame/lighter
	price_tag = 2

/obj/item/flame/lighter/zippo
	price_tag = 5

//******************************//
//|IN THIS MOMENT I AM EUPHORIC|//
//******************************//

/datum/reagent/ethanol/euphoria
	price_tag = 30
