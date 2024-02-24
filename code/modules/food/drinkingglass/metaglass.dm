/obj/item/weapon/reagent_containers/food/drinks/metaglass
	name = "metamorphic glass"
	desc = "This glass changes shape and form depending on the drink inside... fancy!"
	icon_state = "glass_empty"
	amount_per_transfer_from_this = 5
	volume = 30
	unacidable = TRUE //glass
	center_of_mass = list("x"=16, "y"=10)
	matter = list(MAT_GLASS = 500)
	icon = 'icons/obj/drinks.dmi'

/obj/item/weapon/reagent_containers/food/drinks/metaglass/metapint
	name = "metamorphic pint glass"
	desc = "This glass changes shape and form depending on the drink inside... fancy!"
	icon_state = "pglass_empty"
	volume = 60

/obj/item/weapon/reagent_containers/food/drinks/metaglass/on_reagent_change()
	if (reagents.reagent_list.len > 0)
		var/datum/reagent/R = reagents.get_master_reagent()

		if(R.glass_icon_file)
			icon = R.glass_icon_file
		else
			icon = initial(icon)

		if(R.glass_icon_state)
			icon_state = R.glass_icon_state
		else
			icon_state = "glass_brown"

		if(R.glass_name)
			name = R.glass_name
		else
			name = "Glass of.. what?"

		if(R.glass_desc)
			desc = R.glass_desc
		else
			desc = "You can't really tell what this is."

		if(R.glass_center_of_mass)
			center_of_mass = R.glass_center_of_mass
		else
			center_of_mass = list("x"=16, "y"=10)

		if(R.price_tag)
			price_tag = R.price_tag
		else
			price_tag = null
	else
		if(type == /obj/item/weapon/reagent_containers/food/drinks/metaglass/metapint)
			icon_state = "pglass_empty"
			name = "metamorphic pint glass"
			desc = "This glass changes shape and form depending on the drink inside... fancy!"
			center_of_mass = list("x"=16, "y"=10)
		else
			icon_state = "glass_empty"
			name = "metamorphic glass"
			desc = "This glass changes shape and form depending on the drink inside... fancy!"
			center_of_mass = list("x"=16, "y"=10)
			return


/*
Drinks Data
*/

/datum/reagent
	var/glass_icon_file = null
	var/glass_icon_state = null
	var/glass_center_of_mass = null

/datum/reagent/adminordrazine
	glass_icon_state = "golden_cup"

/datum/reagent/chloralhydrate/beer2
	glass_icon_state = "beerglass"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/blood
	glass_icon_state = "glass_red"

/datum/reagent/water
	glass_icon_state = "glass_clear"

/datum/reagent/fuel
	glass_icon_state = "dr_gibb_glass"

/datum/reagent/ethanol
	glass_icon_state = "glass_clear"

/datum/reagent/sugar
	glass_icon_state = "iceglass"

/datum/reagent/drink/juice/banana
	glass_icon_state = "banana"

/datum/reagent/drink/juice/berry
	glass_icon_state = "berryjuice"

/datum/reagent/drink/juice/carrot
	glass_icon_state = "carrotjuice"

/datum/reagent/drink/juice/
	glass_icon_state = "grapejuice"

/datum/reagent/drink/juice/lemon
	glass_icon_state = "lemonjuice"

/datum/reagent/drink/juice/apple
	glass_icon_state = "applejuice"

/datum/reagent/drink/juice/lime
	glass_icon_state = "glass_green"

/datum/reagent/drink/juice/orange
	glass_icon_state = "glass_orange"

/datum/reagent/toxin/poisonberryjuice
	glass_icon_state = "poisonberryjuice"

/datum/reagent/drink/juice/potato
	glass_icon_state = "glass_brown"

/datum/reagent/drink/juice/tomato
	glass_icon_state = "glass_red"

/datum/reagent/drink/juice/watermelon
	glass_icon_state = "glass_red"

/datum/reagent/drink/milk
	glass_icon_state = "glass_white"

/datum/reagent/drink/chocolate
	glass_icon_state = "glass_brown"

/datum/reagent/drink/tea
	glass_icon_state = "bigteacup"

/datum/reagent/drink/tea/icetea
	glass_icon_state = "icedteaglass"
	glass_center_of_mass = list("x"=15, "y"=10)

/datum/reagent/drink/coffee
	glass_icon_state = "hot_coffee"

/datum/reagent/drink/icecoffee
	glass_icon_state = "icedcoffeeglass"

/datum/reagent/drink/soy_latte
	glass_icon_state = "soy_latte"
	glass_center_of_mass = list("x"=15, "y"=9)

/datum/reagent/drink/cafe_latte
	glass_icon_state = "cafe_latte"
	glass_center_of_mass = list("x"=15, "y"=9)

/datum/reagent/drink/hot_coco
	glass_icon_state = "chocolateglass"

/datum/reagent/drink/soda/sodawater
	glass_icon_state = "glass_clear"

/datum/reagent/drink/soda/grapesoda
	glass_icon_state = "gsodaglass"

/datum/reagent/drink/soda/tonic
	glass_icon_state = "glass_clear"

/datum/reagent/drink/soda/lemonade
	glass_icon_state = "lemonadeglass"

/datum/reagent/drink/soda/kiraspecial
	glass_icon_state = "kiraspecial"
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/drink/soda/brownstar
	glass_icon_state = "brownstar"

/datum/reagent/drink/milkshake
	glass_icon_state = "milkshake"
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/drink/rewriter
	glass_icon_state = "rewriter"
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/drink/soda/nuka_cola
	glass_icon_state = "nuka_colaglass"
	glass_center_of_mass = list("x"=16, "y"=6)

/datum/reagent/drink/grenadine
	glass_icon_state = "grenadineglass"
	glass_center_of_mass = list("x"=17, "y"=6)

/datum/reagent/drink/soda/space_cola
	glass_icon_state = "glass_brown"

/datum/reagent/drink/soda/spacemountainwind
	glass_icon_state = "Space_mountain_wind_glass"

/datum/reagent/drink/soda/dr_gibb
	glass_icon_state = "dr_gibb_glass"

/datum/reagent/drink/soda/space_up
	glass_icon_state = "space-up_glass"

/datum/reagent/drink/soda/lemon_lime
	glass_icon_state = "lemonlime"

/datum/reagent/drink/doctor_delight
	glass_icon_state = "doctorsdelightglass"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/drink/ice
	glass_icon_state = "iceglass"

/datum/reagent/drink/nothing
	glass_icon_state = "nothing"

/datum/reagent/drink/oilslick
	glass_icon_state = "jar_oil"
	glass_center_of_mass = list("x"=15, "y"=12)

/datum/reagent/drink/nuclearwaste
	glass_icon_state = "jar_rad"
	glass_center_of_mass = list("x"=15, "y"=12)

/datum/reagent/drink/sodaoil
	glass_icon_state = "jar_water"
	glass_center_of_mass = list("x"=15, "y"=12)

/datum/reagent/ethanol/absinthe
	glass_icon_state = "absintheglass"
	glass_center_of_mass = list("x"=16, "y"=5)

/datum/reagent/ethanol/ale
	glass_icon_state = "aleglass"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/beer
	glass_icon_state = "beerglass"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/bluecuracao
	glass_icon_state = "curacaoglass"
	glass_center_of_mass = list("x"=16, "y"=5)

/datum/reagent/ethanol/cognac
	glass_icon_state = "cognacglass"
	glass_center_of_mass = list("x"=16, "y"=6)

/datum/reagent/ethanol/deadrum
	glass_icon_state = "rumglass"
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/ethanol/gin
	glass_icon_state = "ginvodkaglass"
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/ethanol/coffee/kahlua
	glass_icon_state = "kahluaglass"
	glass_center_of_mass = list("x"=15, "y"=7)

/datum/reagent/ethanol/melonliquor
	glass_icon_state = "emeraldglass"
	glass_center_of_mass = list("x"=16, "y"=5)

/datum/reagent/ethanol/rum
	glass_icon_state = "rumglass"
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/ethanol/sake
	glass_icon_state = "sakecup"
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/ethanol/godsake
	glass_icon_state = "sakeporcelain"
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/ethanol/tequila
	glass_icon_state = "tequillaglass"
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/ethanol/thirteenloko
	glass_icon_state = "thirteen_loko_glass"

/datum/reagent/ethanol/vermouth
	glass_icon_state = "vermouthglass"
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/ethanol/vodka
	glass_icon_state = "ginvodkaglass"
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/ethanol/whiskey
	glass_icon_state = "whiskeyglass"
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/ethanol/wine
	glass_icon_state = "wineglass"
	glass_center_of_mass = list("x"=15, "y"=7)

/datum/reagent/ethanol/acid_spit
	glass_icon_state = "acidspitglass"
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/ethanol/alliescocktail
	glass_icon_state = "alliescocktail"
	glass_center_of_mass = list("x"=17, "y"=8)

/datum/reagent/ethanol/aloe
	glass_icon_state = "aloe"
	glass_center_of_mass = list("x"=17, "y"=8)

/datum/reagent/ethanol/amasec
	glass_icon_state = "amasecglass"
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/ethanol/andalusia
	glass_icon_state = "andalusia"
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/ethanol/antifreeze
	glass_icon_state = "antifreeze"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/atomicbomb
	glass_icon_state = "atomicbombglass"
	glass_center_of_mass = list("x"=15, "y"=7)

/datum/reagent/ethanol/coffee/b52
	glass_icon_state = "b52glass"

/datum/reagent/ethanol/bahama_mama
	glass_icon_state = "bahama_mama"
	glass_center_of_mass = list("x"=16, "y"=5)

/datum/reagent/ethanol/bananahonk
	glass_icon_state = "bananahonkglass"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/barefoot
	glass_icon_state = "b&p"
	glass_center_of_mass = list("x"=17, "y"=8)

/datum/reagent/ethanol/beepsky_smash
	glass_icon_state = "beepskysmashglass"
	glass_center_of_mass = list("x"=18, "y"=10)

/datum/reagent/ethanol/bilk
	glass_icon_state = "glass_brown"

/datum/reagent/ethanol/black_russian
	glass_icon_state = "blackrussianglass"
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/ethanol/bloody_mary
	glass_icon_state = "bloodymaryglass"

/datum/reagent/ethanol/booger
	glass_icon_state = "booger"

/datum/reagent/ethanol/coffee/brave_bull
	glass_icon_state = "bravebullglass"
	glass_center_of_mass = list("x"=15, "y"=8)

/datum/reagent/ethanol/changelingsting
	glass_icon_state = "changelingsting"

/datum/reagent/ethanol/martini
	glass_icon_state = "martiniglass"
	glass_center_of_mass = list("x"=17, "y"=8)

/datum/reagent/ethanol/rum_and_cola
	glass_icon_state = "rumcolaglass"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/cuba_libre
	glass_icon_state = "cubalibreglass"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/demonsblood
	glass_icon_state = "demonsblood"
	glass_center_of_mass = list("x"=16, "y"=2)

/datum/reagent/ethanol/devilskiss
	glass_icon_state = "devilskiss"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/driestmartini
	glass_icon_state = "driestmartiniglass"
	glass_center_of_mass = list("x"=17, "y"=8)

/datum/reagent/ethanol/ginfizz
	glass_icon_state = "ginfizzglass"
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/ethanol/grog
	glass_icon_state = "grogglass"

/datum/reagent/ethanol/erikasurprise
	glass_icon_state = "erikasurprise"
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/ethanol/gargle_blaster
	glass_icon_state = "gargleblasterglass"
	glass_center_of_mass = list("x"=17, "y"=6)

/datum/reagent/ethanol/gintonic
	glass_icon_state = "gintonicglass"

/datum/reagent/ethanol/goldschlager
	glass_icon_state = "goldschlagerglass"
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/ethanol/hippies_delight
	glass_icon_state = "hippiesdelightglass"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/hooch
	glass_icon_state = "glass_brown2"

/datum/reagent/ethanol/iced_beer
	glass_icon_state = "iced_beerglass"
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/ethanol/irishcarbomb
	glass_icon_state = "irishcarbomb"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/coffee/irishcoffee
	glass_icon_state = "irishcoffeeglass"
	glass_center_of_mass = list("x"=15, "y"=10)

/datum/reagent/ethanol/irish_cream
	glass_icon_state = "irishcreamglass"
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/ethanol/longislandicedtea
	glass_icon_state = "longislandicedteaglass"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/manhattan
	glass_icon_state = "manhattanglass"
	glass_center_of_mass = list("x"=17, "y"=8)

/datum/reagent/ethanol/manhattan_proj
	glass_icon_state = "proj_manhattanglass"
	glass_center_of_mass = list("x"=17, "y"=8)

/datum/reagent/ethanol/manly_dorf
	glass_icon_state = "manlydorfglass"

/datum/reagent/ethanol/margarita
	glass_icon_state = "margaritaglass"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/mead
	glass_icon_state = "meadglass"
	glass_center_of_mass = list("x"=17, "y"=10)

/datum/reagent/ethanol/moonshine
	glass_icon_state = "glass_clear"

/datum/reagent/ethanol/neurotoxin
	glass_icon_state = "neurotoxinglass"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/patron
	glass_icon_state = "patronglass"
	glass_center_of_mass = list("x"=7, "y"=8)

/datum/reagent/ethanol/pwine
	glass_icon_state = "pwineglass"
	glass_center_of_mass = list("x"=16, "y"=5)

/datum/reagent/ethanol/red_mead
	glass_icon_state = "red_meadglass"
	glass_center_of_mass = list("x"=17, "y"=10)

/datum/reagent/ethanol/sbiten
	glass_icon_state = "sbitenglass"
	glass_center_of_mass = list("x"=17, "y"=8)

/datum/reagent/ethanol/screwdrivercocktail
	glass_icon_state = "screwdriverglass"
	glass_center_of_mass = list("x"=15, "y"=10)

/datum/reagent/ethanol/silencer
	glass_icon_state = "silencerglass"
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/ethanol/singulo
	glass_icon_state = "singulo"
	glass_center_of_mass = list("x"=17, "y"=4)

/datum/reagent/ethanol/snowwhite
	glass_icon_state = "snowwhite"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/suidream
	glass_icon_state = "sdreamglass"
	glass_center_of_mass = list("x"=16, "y"=5)

/datum/reagent/ethanol/syndicatebomb
	glass_icon_state = "syndicatebomb"
	glass_center_of_mass = list("x"=16, "y"=4)

/datum/reagent/ethanol/tequilla_sunrise
	glass_icon_state = "tequillasunriseglass"

/datum/reagent/ethanol/threemileisland
	glass_icon_state = "threemileislandglass"
	glass_center_of_mass = list("x"=16, "y"=2)

/datum/reagent/ethanol/toxins_special
	glass_icon_state = "toxinsspecialglass"

/datum/reagent/ethanol/vodkamartini
	glass_icon_state = "martiniglass"
	glass_center_of_mass = list("x"=17, "y"=8)

/datum/reagent/ethanol/vodkatonic
	glass_icon_state = "vodkatonicglass"
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/ethanol/white_russian
	glass_icon_state = "whiterussianglass"
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/ethanol/whiskey_cola
	glass_icon_state = "whiskeycolaglass"
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/ethanol/whiskeysoda
	glass_icon_state = "whiskeysodaglass2"
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/ethanol/specialwhiskey
	glass_icon_state = "whiskeyglass"
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/ethanol/godka
	glass_icon_state = "godkabottle"
	glass_center_of_mass = list("x"=17, "y"=15)

/datum/reagent/ethanol/holywine
	glass_icon_state = "holywineglass"
	glass_center_of_mass = list("x"=15, "y"=7)

/datum/reagent/ethanol/holy_mary
	glass_icon_state = "holymaryglass"

/datum/reagent/ethanol/angelswrath
	glass_icon_state = "angelswrath"
	glass_center_of_mass = list("x"=16, "y"=2)

/datum/reagent/ethanol/angelskiss
	glass_icon_state = "angelskiss"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/ichor_mead
	glass_icon_state = "ichor_meadglass"
	glass_center_of_mass = list("x"=17, "y"=10)

/datum/reagent/drink/eggnog
	glass_icon_state = "eggnog"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/drink/cider
	glass_icon_state = "ciderglass"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/drink/driverspunch
	glass_icon_state = "driverspunch"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/coffee/elysiumfacepunch
	glass_icon_state = "elysiumfacepunch"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/drink/entdraught
	glass_icon_state = "entdraught"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/erebusmoonrise
	glass_icon_state = "erebusmoonrise"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/euphoria
	glass_icon_state = "euphoria"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/drink/collins_mix
	glass_icon_state = "collinsmix"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/daiquiri
	glass_icon_state = "daiquiri"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/drink/dreamcream
	glass_icon_state = "dreamcream"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/debugger
	glass_icon_state = "debugger"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/binmanbliss
	glass_icon_state = "binmanbliss"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/bitters
	glass_icon_state = "bitters"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/chrysanthemum
	glass_icon_state = "chrysanthemum"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/cloverclub
	glass_icon_state = "cloverclub"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/coldfront
	glass_icon_state = "coldfront"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/balloon
	glass_icon_state = "balloon"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/drink/berrycordial
	glass_icon_state = "berrycordial"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/drink/milkshake/chocoshake
	glass_icon_state = "chocoshake"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/drink/milkshake/coffeeshake
	glass_icon_state = "coffeeshake"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/drink/milkshake/berryshake
	glass_icon_state = "berryshake"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/drink/soda/melonade
	glass_icon_state = "melonade"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/drink/soda/appleade
	glass_icon_state = "appleade"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/drink/mintapplesparkle
	glass_icon_state = "mintapplesparkle"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/drink/soda/pineappleade
	glass_icon_state = "pineappleade"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/drink/soda/lemonade
	glass_icon_state = "lemonade"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/drink/arnold_palmer
	glass_icon_state = "arnoldpalmer"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/mojito
	glass_icon_state = "mojito"
