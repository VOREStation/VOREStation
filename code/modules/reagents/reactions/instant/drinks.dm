/decl/chemical_reaction/instant/drinks/coffee
	name = REAGENT_COFFEE
	id = REAGENT_ID_COFFEE
	result = REAGENT_ID_COFFEE
	required_reagents = list(REAGENT_ID_WATER = 5, REAGENT_ID_COFFEEPOWDER = 1)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/tea
	name = "Black tea"
	id = REAGENT_ID_TEA
	result = REAGENT_ID_TEA
	required_reagents = list(REAGENT_ID_WATER = 5, REAGENT_ID_TEAPOWDER = 1)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/hot_coco
	name = "Hot Coco"
	id = REAGENT_ID_HOTCOCO
	result = REAGENT_ID_HOTCOCO
	required_reagents = list(REAGENT_ID_WATER = 5, REAGENT_ID_COCO = 1)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/grapejuice
	name = REAGENT_GRAPEJUICE
	id = REAGENT_ID_GRAPEJUICE
	result = REAGENT_ID_GRAPEJUICE
	required_reagents = list(REAGENT_ID_WATER = 3, REAGENT_ID_INSTANTGRAPE = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/orangejuice
	name = REAGENT_ORANGEJUICE
	id = REAGENT_ID_ORANGEJUICE
	result = REAGENT_ID_ORANGEJUICE
	required_reagents = list(REAGENT_ID_WATER = 3, REAGENT_ID_INSTANTORANGE = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/watermelonjuice
	name = REAGENT_WATERMELONJUICE
	id = REAGENT_ID_WATERMELONJUICE
	result = REAGENT_ID_WATERMELONJUICE
	required_reagents = list(REAGENT_ID_WATER = 3, REAGENT_ID_INSTANTWATERMELON = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/applejuice
	name = REAGENT_APPLEJUICE
	id = REAGENT_ID_APPLEJUICE
	result = REAGENT_ID_APPLEJUICE
	required_reagents = list(REAGENT_ID_WATER = 3, REAGENT_ID_INSTANTAPPLE = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/goldschlager
	name = "Goldschlager"
	id = "goldschlager"
	result = "goldschlager"
	required_reagents = list("vodka" = 10, REAGENT_ID_GOLD = 1)
	result_amount = 10

/decl/chemical_reaction/instant/drinks/patron
	name = "Patron"
	id = "patron"
	result = "patron"
	required_reagents = list("tequilla" = 10, REAGENT_ID_SILVER = 1)
	result_amount = 10

/decl/chemical_reaction/instant/drinks/bilk
	name = "Bilk"
	id = "bilk"
	result = "bilk"
	required_reagents = list(REAGENT_ID_MILK = 1, "beer" = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/icetea
	name = REAGENT_ICETEA
	id = REAGENT_ID_ICETEA
	result = REAGENT_ID_ICETEA
	required_reagents = list("ice" = 1, REAGENT_ID_TEA = 2)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/icecoffee
	name = REAGENT_ICECOFFEE
	id = REAGENT_ID_ICECOFFEE
	result = REAGENT_ID_ICECOFFEE
	required_reagents = list("ice" = 1, REAGENT_ID_COFFEE = 2)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/icecoffee/alt
	name = "Iced Drip Coffee"
	id = REAGENT_ID_ICECOFFEE
	result = REAGENT_ID_ICECOFFEE
	required_reagents = list("ice" = 1, REAGENT_ID_DRIPCOFFEE = 2)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/blackeye
	name = REAGENT_BLACKEYE
	id = REAGENT_ID_BLACKEYE
	result = REAGENT_ID_BLACKEYE
	required_reagents = list(REAGENT_ID_DRIPCOFFEE = 1, REAGENT_ID_COFFEE = 1)
	result_amount = 1

/decl/chemical_reaction/instant/drinks/americano
	name = REAGENT_AMERICANO
	id = REAGENT_ID_AMERICANO
	result = REAGENT_ID_AMERICANO
	required_reagents = list("water" = 1, REAGENT_ID_LONGBLACK = 2)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/long_black
	name = REAGENT_LONGBLACK
	id = REAGENT_ID_LONGBLACK
	result = REAGENT_ID_LONGBLACK
	required_reagents = list("water" = 1, REAGENT_ID_COFFEE = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/macchiato
	name = REAGENT_MACCHIATO
	id = REAGENT_ID_MACCHIATO
	result = REAGENT_ID_MACCHIATO
	required_reagents = list(REAGENT_ID_MILK = 1, REAGENT_ID_COFFEE = 2)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/cortado
	name = REAGENT_CORTADO
	id = REAGENT_ID_CORTADO
	result = REAGENT_ID_CORTADO
	required_reagents = list(REAGENT_ID_MACCHIATO = 3, REAGENT_ID_MILKFOAM = 1) // 2 coffee, 1 milk, 1 milk foam
	result_amount = 4

/decl/chemical_reaction/instant/drinks/breve
	name = REAGENT_BREVE
	id = REAGENT_ID_BREVE
	result = REAGENT_ID_BREVE
	required_reagents = list(REAGENT_ID_CORTADO = 4, REAGENT_ID_CREAM = 1) // 2 coffee, 1 milk, 1 milk foam, 1 cream
	result_amount = 5

/decl/chemical_reaction/instant/drinks/cappuccino
	name = REAGENT_CAPPUCCINO
	id = REAGENT_ID_CAPPUCCINO
	result = REAGENT_ID_CAPPUCCINO
	required_reagents = list(REAGENT_ID_MILK = 1, REAGENT_ID_MILKFOAM = 1, REAGENT_ID_CORTADO = 4) // 2 coffee, 2 milk, 2 milk foam
	result_amount = 6

/decl/chemical_reaction/instant/drinks/flat_white
	name = REAGENT_FLATWHITE
	id = REAGENT_ID_FLATWHITE
	result = REAGENT_ID_FLATWHITE
	required_reagents = list(REAGENT_ID_MILK = 2, REAGENT_ID_DRIPCOFFEE = 1) // 2 drip coffee, 4 milk I'M SORRY THAT ITS DRIP COFFEE, otherwise it just gets in the way of all other reactions
	result_amount = 3

/decl/chemical_reaction/instant/drinks/mocha
	name = REAGENT_MOCHA
	id = REAGENT_ID_MOCHA
	result = REAGENT_ID_MOCHA
	required_reagents = list(REAGENT_ID_MILK = 1, REAGENT_ID_CREAM = 1, REAGENT_ID_MILKFOAM = 1, REAGENT_ID_HOTCOCO = 2, REAGENT_ID_BREVE = 5) // 2 coffee, 2 milk, 2 cream, 2 milk foam and 2 hot coco
	result_amount = 10

/decl/chemical_reaction/instant/drinks/mocha/alt //incase they use cream before milk
	name = REAGENT_MOCHA
	id = REAGENT_ID_MOCHA
	result = REAGENT_ID_MOCHA
	required_reagents = list(REAGENT_ID_CREAM = 2, REAGENT_ID_HOTCOCO = 2, REAGENT_ID_CAPPUCCINO = 6) // 2 coffee, 2 milk, 2 cream, 2 milk foam and 2 hot coco
	result_amount = 10

/decl/chemical_reaction/instant/drinks/vienna
	name = REAGENT_VIENNA
	id = REAGENT_ID_VIENNA
	result = REAGENT_ID_VIENNA
	required_reagents = list(REAGENT_ID_CREAM = 2, REAGENT_ID_COFFEE = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/nuka_cola
	name = "Nuclear Cola"
	id = REAGENT_ID_NUKACOLA
	result = REAGENT_ID_NUKACOLA
	required_reagents = list(REAGENT_ID_URANIUM = 1, REAGENT_ID_COLA = 5)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/moonshine
	name = "Moonshine"
	id = "moonshine"
	result = "moonshine"
	required_reagents = list(REAGENT_ID_NUTRIMENT = 10)
	catalysts = list(REAGENT_ID_ENZYME = 5)
	result_amount = 10

/decl/chemical_reaction/instant/drinks/grenadine
	name = REAGENT_GRENADINE
	id = REAGENT_ID_GRENADINE
	result = REAGENT_ID_GRENADINE
	required_reagents = list(REAGENT_ID_BERRYJUICE = 10)
	catalysts = list(REAGENT_ID_ENZYME = 5)
	result_amount = 10

/decl/chemical_reaction/instant/drinks/wine
	name = "Wine"
	id = "redwine"
	result = "redwine"
	required_reagents = list(REAGENT_ID_GRAPEJUICE = 10)
	catalysts = list(REAGENT_ID_ENZYME = 5)
	result_amount = 10

/decl/chemical_reaction/instant/drinks/pwine
	name = "Poison Wine"
	id = "pwine"
	result = "pwine"
	required_reagents = list(REAGENT_ID_POISONBERRYJUICE = 10)
	catalysts = list(REAGENT_ID_ENZYME = 5)
	result_amount = 10

/decl/chemical_reaction/instant/drinks/melonliquor
	name = "Melon Liquor"
	id = "melonliquor"
	result = "melonliquor"
	required_reagents = list(REAGENT_ID_WATERMELONJUICE = 10)
	catalysts = list(REAGENT_ID_ENZYME = 5)
	result_amount = 10

/decl/chemical_reaction/instant/drinks/bluecuracao
	name = "Blue Curacao"
	id = "bluecuracao"
	result = "bluecuracao"
	required_reagents = list(REAGENT_ID_ORANGEJUICE = 10)
	catalysts = list(REAGENT_ID_ENZYME = 5)
	result_amount = 10

/decl/chemical_reaction/instant/drinks/spacebeer
	name = "Space Beer"
	id = "spacebeer"
	result = "beer"
	required_reagents = list(REAGENT_ID_CORNOIL = 5, REAGENT_ID_FLOUR = 5)
	catalysts = list(REAGENT_ID_ENZYME = 5)
	result_amount = 10

/decl/chemical_reaction/instant/drinks/vodka
	name = "Vodka"
	id = "vodka"
	result = "vodka"
	required_reagents = list(REAGENT_ID_POTATOJUICE = 10)
	catalysts = list(REAGENT_ID_ENZYME = 5)
	result_amount = 10

/decl/chemical_reaction/instant/drinks/cider
	name = "Cider"
	id = "cider"
	result = "cider"
	required_reagents = list(REAGENT_ID_APPLEJUICE = 10)
	catalysts = list(REAGENT_ID_ENZYME = 5)
	result_amount = 10


/decl/chemical_reaction/instant/drinks/sake
	name = "Sake"
	id = "sake"
	result = "sake"
	required_reagents = list(REAGENT_ID_RICE = 10)
	catalysts = list(REAGENT_ID_ENZYME = 5)
	result_amount = 10

/decl/chemical_reaction/instant/drinks/kahlua
	name = "Kahlua"
	id = "kahlua"
	result = "kahlua"
	required_reagents = list(REAGENT_ID_COFFEE = 5, REAGENT_ID_SUGAR = 5)
	catalysts = list(REAGENT_ID_ENZYME = 5)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/gin_tonic
	name = "Gin and Tonic"
	id = "gintonic"
	result = "gintonic"
	required_reagents = list("gin" = 2, REAGENT_ID_TONIC = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/rum_and_cola
	name = "Rum and Cola"
	id = "rumandcola"
	result = "rumandcola"
	required_reagents = list("rum" = 2, REAGENT_ID_COLA = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/cuba_libre
	name = "Cuba Libre"
	id = "cubalibre"
	result = "cubalibre"
	required_reagents = list("rumandcola" = 3, REAGENT_ID_LIMEJUICE = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/martini
	name = "Classic Martini"
	id = "martini"
	result = "martini"
	inhibitors = list("bitters" = 1)
	required_reagents = list("gin" = 2, "vermouth" = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/vodkamartini
	name = "Vodka Martini"
	id = "vodkamartini"
	result = "vodkamartini"
	required_reagents = list("vodka" = 2, "vermouth" = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/white_russian
	name = "White Russian"
	id = "whiterussian"
	result = "whiterussian"
	required_reagents = list("blackrussian" = 2, REAGENT_ID_CREAM = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/whiskey_cola
	name = "Whiskey Cola"
	id = "whiskeycola"
	result = "whiskeycola"
	required_reagents = list("whiskey" = 2, REAGENT_ID_COLA = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/screwdriver
	name = "Screwdriver"
	id = "screwdrivercocktail"
	result = "screwdrivercocktail"
	required_reagents = list("vodka" = 2, REAGENT_ID_ORANGEJUICE = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/bloody_mary
	name = "Bloody Mary"
	id = "bloodymary"
	result = "bloodymary"
	required_reagents = list("vodka" = 2, REAGENT_ID_TOMATOJUICE = 3, REAGENT_ID_LIMEJUICE = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/gargle_blaster
	name = "Pan-Galactic Gargle Blaster"
	id = "gargleblaster"
	result = "gargleblaster"
	required_reagents = list("vodka" = 2, "gin" = 1, "whiskey" = 1, "cognac" = 1, REAGENT_ID_LIMEJUICE = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/brave_bull
	name = "Brave Bull"
	id = "bravebull"
	result = "bravebull"
	required_reagents = list("tequilla" = 2, "kahlua" = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/tequilla_sunrise
	name = "Tequilla Sunrise"
	id = "tequillasunrise"
	result = "tequillasunrise"
	required_reagents = list("tequilla" = 2, REAGENT_ID_ORANGEJUICE = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/phoron_special
	name = "Toxins Special"
	id = "phoronspecial"
	result = "phoronspecial"
	required_reagents = list("rum" = 2, "vermouth" = 2, REAGENT_ID_PHORON = 2)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/beepsky_smash
	name = "Beepksy Smash"
	id = "beepksysmash"
	result = "beepskysmash"
	required_reagents = list(REAGENT_ID_LIMEJUICE = 1, "whiskey" = 1, REAGENT_ID_IRON = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/doctor_delight
	name = REAGENT_DOCTORSDELIGHT
	id = "doctordelight"
	result = REAGENT_ID_DOCTORSDELIGHT
	required_reagents = list(REAGENT_ID_LIMEJUICE = 1, REAGENT_ID_TOMATOJUICE = 1, REAGENT_ID_ORANGEJUICE = 1, REAGENT_ID_CREAM = 2, REAGENT_ID_TRICORDRAZINE = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/irish_cream
	name = "Irish Cream"
	id = "irishcream"
	result = "irishcream"
	required_reagents = list("whiskey" = 2, REAGENT_ID_CREAM = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/manly_dorf
	name = "The Manly Dorf"
	id = "manlydorf"
	result = "manlydorf"
	required_reagents = list ("beer" = 1, "ale" = 2)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/hooch
	name = "Hooch"
	id = "hooch"
	result = "hooch"
	required_reagents = list (REAGENT_ID_SUGAR = 1, REAGENT_ID_ETHANOL = 2, REAGENT_ID_FUEL = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/irish_coffee
	name = "Irish Coffee"
	id = "irishcoffee"
	result = "irishcoffee"
	required_reagents = list("irishcream" = 1, REAGENT_ID_COFFEE = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/b52
	name = "B-52"
	id = "b52"
	result = "b52"
	required_reagents = list("irishcream" = 1, "kahlua" = 1, "cognac" = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/atomicbomb
	name = "Atomic Bomb"
	id = "atomicbomb"
	result = "atomicbomb"
	required_reagents = list("b52" = 10, REAGENT_ID_URANIUM = 1)
	result_amount = 10

/decl/chemical_reaction/instant/drinks/margarita
	name = "Margarita"
	id = "margarita"
	result = "margarita"
	required_reagents = list("tequilla" = 2, REAGENT_ID_LIMEJUICE = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/longislandicedtea
	name = "Long Island Iced Tea"
	id = "longislandicedtea"
	result = "longislandicedtea"
	required_reagents = list("vodka" = 1, "gin" = 1, "tequilla" = 1, "rumandcola" = 3)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/threemileisland
	name = "Three Mile Island Iced Tea"
	id = "threemileisland"
	result = "threemileisland"
	required_reagents = list("longislandicedtea" = 10, REAGENT_ID_URANIUM = 1)
	result_amount = 10

/decl/chemical_reaction/instant/drinks/whiskeysoda
	name = "Whiskey Soda"
	id = "whiskeysoda"
	result = "whiskeysoda"
	required_reagents = list("whiskey" = 2, REAGENT_ID_SODAWATER = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/black_russian
	name = "Black Russian"
	id = "blackrussian"
	result = "blackrussian"
	required_reagents = list("vodka" = 2, "kahlua" = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/manhattan
	name = "Manhattan"
	id = "manhattan"
	result = "manhattan"
	required_reagents = list("whiskey" = 2, "vermouth" = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/manhattan_proj
	name = "Manhattan Project"
	id = "manhattan_proj"
	result = "manhattan_proj"
	required_reagents = list("manhattan" = 10, REAGENT_ID_URANIUM = 1)
	result_amount = 10

/decl/chemical_reaction/instant/drinks/vodka_tonic
	name = "Vodka and Tonic"
	id = "vodkatonic"
	result = "vodkatonic"
	required_reagents = list("vodka" = 2, REAGENT_ID_TONIC = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/gin_fizz
	name = "Gin Fizz"
	id = "ginfizz"
	result = "ginfizz"
	required_reagents = list("gin" = 1, REAGENT_ID_SODAWATER = 1, REAGENT_ID_LIMEJUICE = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/bahama_mama
	name = "Bahama mama"
	id = "bahama_mama"
	result = "bahama_mama"
	required_reagents = list("rum" = 2, REAGENT_ID_ORANGEJUICE = 2, REAGENT_ID_LIMEJUICE = 1, "ice" = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/singulo
	name = "Singulo"
	id = "singulo"
	result = "singulo"
	required_reagents = list("vodka" = 5, REAGENT_ID_RADIUM = 1, "redwine" = 5)
	result_amount = 10

/decl/chemical_reaction/instant/drinks/alliescocktail
	name = "Allies Cocktail"
	id = "alliescocktail"
	result = "alliescocktail"
	required_reagents = list("martini" = 1, "vodka" = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/demonsblood
	name = "Demons Blood"
	id = "demonsblood"
	result = "demonsblood"
	required_reagents = list("rum" = 3, REAGENT_ID_SPACEMOUNTAINWIND = 1, REAGENT_ID_BLOOD = 1, REAGENT_ID_DRGIBB = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/booger
	name = "Booger"
	id = "booger"
	result = "booger"
	required_reagents = list(REAGENT_ID_CREAM = 2, REAGENT_ID_BANANA = 1, "rum" = 1, REAGENT_ID_WATERMELONJUICE = 1)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/antifreeze
	name = "Anti-freeze"
	id = "antifreeze"
	result = "antifreeze"
	required_reagents = list("vodka" = 1, REAGENT_ID_CREAM = 1, "ice" = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/barefoot
	name = "Barefoot"
	id = "barefoot"
	result = "barefoot"
	required_reagents = list(REAGENT_ID_BERRYJUICE = 1, REAGENT_ID_CREAM = 1, "vermouth" = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/grapesoda
	name = REAGENT_GRAPESODA
	id = REAGENT_ID_GRAPESODA
	result = REAGENT_ID_GRAPESODA
	required_reagents = list(REAGENT_ID_GRAPEJUICE = 2, REAGENT_ID_COLA = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/sbiten
	name = "Sbiten"
	id = "sbiten"
	result = "sbiten"
	required_reagents = list("vodka" = 10, REAGENT_ID_CAPSAICIN = 1)
	result_amount = 10

/decl/chemical_reaction/instant/drinks/red_mead
	name = "Red Mead"
	id = "red_mead"
	result = "red_mead"
	required_reagents = list(REAGENT_ID_BLOOD = 1, "mead" = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/mead
	name = "Mead"
	id = "mead"
	result = "mead"
	required_reagents = list(REAGENT_ID_SUGAR = 1, REAGENT_ID_WATER = 1)
	catalysts = list(REAGENT_ID_ENZYME = 5)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/iced_beer
	name = "Iced Beer"
	id = "iced_beer"
	result = "iced_beer"
	required_reagents = list("beer" = 10, REAGENT_ID_FROSTOIL = 1)
	result_amount = 10

/decl/chemical_reaction/instant/drinks/iced_beer2
	name = "Iced Beer"
	id = "iced_beer"
	result = "iced_beer"
	required_reagents = list("beer" = 5, "ice" = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/grog
	name = "Grog"
	id = "grog"
	result = "grog"
	required_reagents = list("rum" = 1, REAGENT_ID_WATER = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/soy_latte
	name = REAGENT_SOYLATTE
	id = REAGENT_ID_SOYLATTE
	result = REAGENT_ID_SOYLATTE
	required_reagents = list(REAGENT_ID_COFFEE = 1, REAGENT_ID_SOYMILK = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/cafe_latte
	name = REAGENT_CAFELATTE
	id = REAGENT_ID_CAFELATTE
	result = REAGENT_ID_CAFELATTE
	required_reagents = list(REAGENT_ID_FLATWHITE = 1, REAGENT_ID_MILK = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/acidspit
	name = "Acid Spit"
	id = "acidspit"
	result = "acidspit"
	required_reagents = list(REAGENT_ID_SACID = 1, "redwine" = 5)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/amasec
	name = "Amasec"
	id = "amasec"
	result = "amasec"
	required_reagents = list(REAGENT_ID_IRON = 1, "redwine" = 5, "vodka" = 5)
	result_amount = 10

/decl/chemical_reaction/instant/drinks/changelingsting
	name = "Changeling Sting"
	id = "changelingsting"
	result = "changelingsting"
	required_reagents = list("screwdrivercocktail" = 1, REAGENT_ID_LIMEJUICE = 1, REAGENT_ID_LEMONJUICE = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/aloe
	name = "Aloe"
	id = "aloe"
	result = "aloe"
	required_reagents = list(REAGENT_ID_CREAM = 1, "whiskey" = 1, REAGENT_ID_WATERMELONJUICE = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/andalusia
	name = "Andalusia"
	id = "andalusia"
	result = "andalusia"
	required_reagents = list("rum" = 1, "whiskey" = 1, REAGENT_ID_LEMONJUICE = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/snowwhite
	name = "Snow White"
	id = "snowwhite"
	result = "snowwhite"
	required_reagents = list(REAGENT_ID_PINEAPPLEJUICE = 1, "rum" = 1, REAGENT_ID_LEMONLIME = 1, REAGENT_ID_EGG = 1, "kahlua" = 1, REAGENT_ID_SUGAR = 1) //VoreStation Edit
	result_amount = 2

/decl/chemical_reaction/instant/drinks/irishcarbomb
	name = "Irish Car Bomb"
	id = "irishcarbomb"
	result = "irishcarbomb"
	required_reagents = list("ale" = 1, "irishcream" = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/syndicatebomb
	name = "Syndicate Bomb"
	id = "syndicatebomb"
	result = "syndicatebomb"
	required_reagents = list("beer" = 1, "whiskeycola" = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/erikasurprise
	name = "Erika Surprise"
	id = "erikasurprise"
	result = "erikasurprise"
	required_reagents = list("ale" = 2, REAGENT_ID_LIMEJUICE = 1, "whiskey" = 1, REAGENT_ID_BANANA = 1, "ice" = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/devilskiss
	name = "Devils Kiss"
	id = "devilskiss"
	result = "devilskiss"
	required_reagents = list(REAGENT_ID_BLOOD = 1, "kahlua" = 1, "rum" = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/hippiesdelight
	name = "Hippies Delight"
	id = "hippiesdelight"
	result = "hippiesdelight"
	required_reagents = list(REAGENT_ID_PSILOCYBIN = 1, "gargleblaster" = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/bananahonk
	name = "Banana Honk"
	id = "bananahonk"
	result = "bananahonk"
	required_reagents = list(REAGENT_ID_BANANA = 1, REAGENT_ID_CREAM = 1, REAGENT_ID_SUGAR = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/silencer
	name = "Silencer"
	id = "silencer"
	result = "silencer"
	required_reagents = list("nothing" = 1, REAGENT_ID_CREAM = 1, REAGENT_ID_SUGAR = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/driestmartini
	name = "Driest Martini"
	id = "driestmartini"
	result = "driestmartini"
	required_reagents = list("nothing" = 1, "gin" = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/lemonade
	name = REAGENT_LEMONADE
	id = REAGENT_ID_LEMONADE
	result = REAGENT_ID_LEMONADE
	required_reagents = list(REAGENT_ID_LEMONJUICE = 1, REAGENT_ID_SUGAR = 1, REAGENT_ID_WATER = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/melonade
	name = REAGENT_MELONADE
	id = REAGENT_ID_MELONADE
	result = REAGENT_ID_MELONADE
	required_reagents = list(REAGENT_ID_WATERMELONJUICE = 1, REAGENT_ID_SUGAR = 1, REAGENT_ID_SODAWATER = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/appleade
	name = REAGENT_APPLEADE
	id = REAGENT_ID_APPLEADE
	result = REAGENT_ID_APPLEADE
	required_reagents = list(REAGENT_ID_APPLEJUICE = 1, REAGENT_ID_SUGAR = 1, REAGENT_ID_SODAWATER = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/pineappleade
	name = REAGENT_PINEAPPLEADE
	id = REAGENT_ID_PINEAPPLEADE
	result = REAGENT_ID_PINEAPPLEADE
	required_reagents = list(REAGENT_ID_PINEAPPLEJUICE = 2, REAGENT_ID_LIMEJUICE = 1, REAGENT_ID_SODAWATER = 2, REAGENT_ID_HONEY = 1)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/driverspunch
	name = "Driver`s Punch"
	id = "driverspunch"
	result = "driverspunch"
	required_reagents = list(REAGENT_ID_APPLEADE = 2, REAGENT_ID_ORANGEJUICE = 1, REAGENT_ID_MINT = 1, REAGENT_ID_SODAWATER = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/mintapplesparkle
	name = "Mint Apple Sparkle"
	id = "mintapplesparkle"
	result = "mintapplesparkle"
	required_reagents = list(REAGENT_ID_APPLEADE = 2, REAGENT_ID_MINT = 1)
	inhibitors = list(REAGENT_ID_SODAWATER = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/berrycordial
	name = "Berry Cordial"
	id = "berrycordial"
	result = "berrycordial"
	required_reagents = list(REAGENT_ID_BERRYJUICE = 4, REAGENT_ID_SUGAR = 1, REAGENT_ID_LEMONJUICE = 1)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/tropicalfizz
	name = "Tropical Fizz"
	id = "tropicalfizz"
	result = "tropicalfizz"
	required_reagents = list(REAGENT_ID_SODAWATER = 6, REAGENT_ID_BERRYJUICE = 1, REAGENT_ID_MINT = 1, REAGENT_ID_LIMEJUICE = 1, REAGENT_ID_LEMONJUICE = 1, REAGENT_ID_PINEAPPLEJUICE = 1)
	inhibitors = list(REAGENT_ID_SUGAR = 1)
	result_amount = 8

/decl/chemical_reaction/instant/drinks/melonspritzer
	name = "Melon Spritzer"
	id = "melonspritzer"
	result = "melonspritzer"
	required_reagents = list(REAGENT_ID_WATERMELONJUICE = 2, "redwine" = 2, REAGENT_ID_APPLEJUICE = 1, REAGENT_ID_LIMEJUICE = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/fauxfizz
	name = "Faux Fizz"
	id = "fauxfizz"
	result = "fauxfizz"
	required_reagents = list(REAGENT_ID_SODAWATER = 2, REAGENT_ID_BERRYJUICE = 1, REAGENT_ID_APPLEJUICE = 1, REAGENT_ID_LIMEJUICE = 1, REAGENT_ID_HONEY = 1)
	inhibitors = list(REAGENT_ID_SUGAR = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/firepunch
	name = "Fire Punch"
	id = "firepunch"
	result = "firepunch"
	required_reagents = list(REAGENT_ID_SUGAR = 1, "rum" = 2)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/kiraspecial
	name = REAGENT_KIRASPECIAL
	id = REAGENT_ID_KIRASPECIAL
	result = REAGENT_ID_KIRASPECIAL
	required_reagents = list(REAGENT_ID_ORANGEJUICE = 1, REAGENT_ID_LIMEJUICE = 1, REAGENT_ID_SODAWATER = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/brownstar
	name = REAGENT_BROWNSTAR
	id = REAGENT_ID_BROWNSTAR
	result = REAGENT_ID_BROWNSTAR
	required_reagents = list(REAGENT_ID_ORANGEJUICE = 2, REAGENT_ID_COLA = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/brownstar_decaf
	name = REAGENT_BROWNSTARDECAF
	id = REAGENT_ID_BROWNSTARDECAF
	result = REAGENT_ID_BROWNSTARDECAF
	required_reagents = list(REAGENT_ID_ORANGEJUICE = 2, REAGENT_ID_DECAFCOLA = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/milkshake
	name = REAGENT_MILKSHAKE
	id = REAGENT_ID_MILKSHAKE
	result = REAGENT_ID_MILKSHAKE
	required_reagents = list(REAGENT_ID_CREAM = 1, "ice" = 2, REAGENT_ID_MILK = 2)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/peanutmilkshake
	name = "Peanutbutter Milkshake"
	id = REAGENT_ID_PEANUTMILKSHAKE
	result = REAGENT_ID_PEANUTMILKSHAKE
	required_reagents = list(REAGENT_ID_CREAM = 1, "ice" = 1, REAGENT_ID_PEANUTBUTTER = 2, REAGENT_ID_MILK = 1)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/rewriter
	name = REAGENT_REWRITER
	id = REAGENT_ID_REWRITER
	result = REAGENT_ID_REWRITER
	required_reagents = list(REAGENT_ID_SPACEMOUNTAINWIND = 1, REAGENT_ID_COFFEE = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/suidream
	name = "Sui Dream"
	id = "suidream"
	result = "suidream"
	required_reagents = list(REAGENT_ID_SPACEUP = 1, "bluecuracao" = 1, "melonliquor" = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/shirleytemple
	name = REAGENT_SHIRLEYTEMPLE
	id = REAGENT_ID_SHIRLEYTEMPLE
	result = REAGENT_ID_SHIRLEYTEMPLE
	required_reagents = list(REAGENT_ID_GINGERALE = 4, REAGENT_ID_GRENADINE = 1)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/royrogers
	name = REAGENT_ROYROGERS
	id = REAGENT_ID_ROYROGERS
	result = REAGENT_ID_ROYROGERS
	required_reagents = list(REAGENT_ID_SHIRLEYTEMPLE = 5, REAGENT_ID_LEMONLIME = 2)
	result_amount = 7

/decl/chemical_reaction/instant/drinks/collinsmix
	name = REAGENT_COLLINSMIX
	id = REAGENT_ID_COLLINSMIX
	result = REAGENT_ID_COLLINSMIX
	required_reagents = list(REAGENT_ID_LEMONLIME = 3, REAGENT_ID_SODAWATER = 1)
	result_amount = 4

/decl/chemical_reaction/instant/drinks/arnoldpalmer
	name = REAGENT_ARNOLDPALMER
	id = REAGENT_ID_ARNOLDPALMER
	result = REAGENT_ID_ARNOLDPALMER
	required_reagents = list(REAGENT_ID_ICETEA = 1, REAGENT_ID_LEMONADE = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/minttea
	name = REAGENT_MINTTEA
	id = REAGENT_ID_MINTTEA
	result = REAGENT_ID_MINTTEA
	required_reagents = list(REAGENT_ID_TEA = 5, REAGENT_ID_MINT = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/minttea_decaf
	name = REAGENT_MINTTEADECAF
	id = "decafminttea"
	result = REAGENT_ID_MINTTEADECAF
	required_reagents = list(REAGENT_ID_TEADECAF = 5, REAGENT_ID_MINT = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/lemontea
	name = REAGENT_LEMONTEA
	id = REAGENT_ID_LEMONTEA
	result = REAGENT_ID_LEMONTEA
	required_reagents = list(REAGENT_ID_TEA = 5, REAGENT_ID_LEMONJUICE = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/lemontea_decaf
	name = REAGENT_LEMONTEADECAF
	id = "decaflemontea"
	result = REAGENT_ID_LEMONTEADECAF
	required_reagents = list(REAGENT_ID_TEADECAF = 5, REAGENT_ID_LEMONJUICE = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/limetea
	name = REAGENT_LIMETEA
	id = REAGENT_ID_LIMETEA
	result = REAGENT_ID_LIMETEA
	required_reagents = list(REAGENT_ID_TEA = 5, REAGENT_ID_LIMEJUICE = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/limetea_decaf
	name = REAGENT_LIMETEADECAF
	id = "decaflimetea"
	result = REAGENT_ID_LIMETEADECAF
	required_reagents = list(REAGENT_ID_TEADECAF = 5, REAGENT_ID_LIMEJUICE = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/orangetea
	name = REAGENT_ORANGETEA
	id = REAGENT_ID_ORANGETEA
	result = REAGENT_ID_ORANGETEA
	required_reagents = list(REAGENT_ID_TEA = 5, REAGENT_ID_ORANGEJUICE = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/orangetea_decaf
	name = "Decaf Orange Tea"
	id = "decaforangetea"
	result = REAGENT_ID_ORANGETEADECAF
	required_reagents = list(REAGENT_ID_TEADECAF = 5, REAGENT_ID_ORANGEJUICE = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/berrytea
	name = REAGENT_BERRYTEA
	id = REAGENT_ID_BERRYTEA
	result = REAGENT_ID_BERRYTEA
	required_reagents = list(REAGENT_ID_TEA = 5, REAGENT_ID_BERRYJUICE = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/berrytea_decaf
	name = REAGENT_BERRYTEADECAF
	id = "decafberrytea"
	result = REAGENT_ID_BERRYTEADECAF
	required_reagents = list(REAGENT_ID_TEADECAF = 5, REAGENT_ID_BERRYJUICE = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/sakebomb
	name = "Sake Bomb"
	id = "sakebomb"
	result = "sakebomb"
	required_reagents = list("beer" = 2, "sake" = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/tamagozake
	name = "Tamagozake"
	id = "tamagozake"
	result = "tamagozake"
	required_reagents = list("sake" = 10, REAGENT_ID_SUGAR = 5, REAGENT_ID_EGG = 3)
	result_amount = 15

/decl/chemical_reaction/instant/drinks/ginzamary
	name = "Ginza Mary"
	id = "ginzamary"
	result = "ginzamary"
	required_reagents = list("sake" = 2, "vodka" = 2, REAGENT_ID_TOMATOJUICE = 1)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/tokyorose
	name = "Tokyo Rose"
	id = "tokyorose"
	result = "tokyorose"
	required_reagents = list("sake" = 1, REAGENT_ID_BERRYJUICE = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/saketini
	name = "Saketini"
	id = "saketini"
	result = "saketini"
	required_reagents = list("sake" = 1, "gin" = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/elysiumfacepunch
	name = "Elysium Facepunch"
	id = "elysiumfacepunch"
	result = "elysiumfacepunch"
	required_reagents = list("kahlua" = 1, REAGENT_ID_LEMONJUICE = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/erebusmoonrise
	name = "Erebus Moonrise"
	id = "erebusmoonrise"
	result = "erebusmoonrise"
	required_reagents = list("whiskey" = 1, "vodka" = 1, "tequilla" = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/balloon
	name = "Balloon"
	id = "balloon"
	result = "balloon"
	required_reagents = list(REAGENT_ID_CREAM = 1, "bluecuracao" = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/natunabrandy
	name = "Natuna Brandy"
	id = "natunabrandy"
	result = "natunabrandy"
	required_reagents = list("beer" = 1, REAGENT_ID_SODAWATER = 2)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/euphoria
	name = "Euphoria"
	id = "euphoria"
	result = "euphoria"
	required_reagents = list("specialwhiskey" = 1, "cognac" = 2)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/xanaducannon
	name = "Xanadu Cannon"
	id = "xanaducannon"
	result = "xanaducannon"
	required_reagents = list("ale" = 1, REAGENT_ID_DRGIBB = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/debugger
	name = "Debugger"
	id = "debugger"
	result = "debugger"
	required_reagents = list(REAGENT_ID_FUEL = 1, REAGENT_ID_SUGAR = 2, REAGENT_ID_COOKINGOIL = 2)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/spacersbrew
	name = "Spacer's Brew"
	id = "spacersbrew"
	result = "spacersbrew"
	required_reagents = list(REAGENT_ID_BROWNSTAR = 4, REAGENT_ID_ETHANOL = 1)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/binmanbliss
	name = "Binman Bliss"
	id = "binmanbliss"
	result = "binmanbliss"
	required_reagents = list("sake" = 1, "tequilla" = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/chrysanthemum
	name = "Chrysanthemum"
	id = "chrysanthemum"
	result = "chrysanthemum"
	required_reagents = list("sake" = 1, "melonliquor" = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/deathbell
	name = "Deathbell"
	id = "deathbell"
	result = "deathbell"
	required_reagents = list("antifreeze" = 1, "gargleblaster" = 1, "syndicatebomb" =1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/bitters
	name = "Bitters"
	id = "bitters"
	result = "bitters"
	required_reagents = list(REAGENT_ID_MINT = 5)
	catalysts = list(REAGENT_ID_ENZYME = 5)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/soemmerfire
	name = "Soemmer Fire"
	id = "soemmerfire"
	result = "soemmerfire"
	required_reagents = list("manhattan" = 2, REAGENT_ID_CONDENSEDCAPSAICIN = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/winebrandy
    name = "Wine brandy"
    id = "winebrandy"
    result = "winebrandy"
    required_reagents = list("redwine" = 10)
    catalysts = list(REAGENT_ID_ENZYME = 10) //10u enzyme so it requires more than is usually added. Stops overlap with wine recipe
    result_amount = 5

/decl/chemical_reaction/instant/drinks/lovepotion
	name = "Love Potion"
	id = "lovepotion"
	result = "lovepotion"
	required_reagents = list(REAGENT_ID_CREAM = 1, REAGENT_ID_BERRYJUICE = 1, REAGENT_ID_SUGAR = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/morningafter
	name = "Morning After"
	id = "morningafter"
	result = "morningafter"
	required_reagents = list("sbiten" = 1, REAGENT_ID_COFFEE = 5)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/vesper
	name = "Vesper"
	id = "vesper"
	result = "vesper"
	required_reagents = list("gin" = 3, "vodka" = 1, "redwine" = 1)
	result_amount = 4

/decl/chemical_reaction/instant/drinks/rotgut
	name = "Rotgut Fever Dream"
	id = "rotgut"
	result = "rotgut"
	required_reagents = list("vodka" = 3, "rum" = 1, "whiskey" = 1, REAGENT_ID_COLA = 3)
	result_amount = 8

/decl/chemical_reaction/instant/drinks/entdraught
	name = "Ent's Draught"
	id = "entdraught"
	result = "entdraught"
	required_reagents = list(REAGENT_ID_TONIC = 1, REAGENT_ID_HOLYWATER = 1, REAGENT_ID_HONEY = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/voxdelight
	name = "Vox's Delight"
	id = "voxdelight"
	result = "voxdelight"
	required_reagents = list(REAGENT_ID_PHORON = 3, REAGENT_ID_FUEL = 1, REAGENT_ID_WATER = 1)
	result_amount = 4

/decl/chemical_reaction/instant/drinks/screamingviking
	name = "Screaming Viking"
	id = "screamingviking"
	result = "screamingviking"
	required_reagents = list("martini" = 2, "vodkatonic" = 2, REAGENT_ID_LIMEJUICE = 1, "rum" = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/vilelemon
	name = "Vile Lemon"
	id = "vilelemon"
	result = "vilelemon"
	required_reagents = list(REAGENT_ID_LEMONADE = 5, REAGENT_ID_SPACEMOUNTAINWIND = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/dreamcream
	name = "Dream Cream"
	id = "dreamcream"
	result = "dreamcream"
	required_reagents = list(REAGENT_ID_MILK = 2, REAGENT_ID_CREAM = 1, REAGENT_ID_HONEY = 1)
	result_amount = 4

/decl/chemical_reaction/instant/drinks/robustin
	name = "Robustin"
	id = "robustin"
	result = "robustin"
	required_reagents = list("antifreeze" = 1, REAGENT_ID_PHORON = 1, REAGENT_ID_FUEL = 1, "vodka" = 1)
	result_amount = 4

/decl/chemical_reaction/instant/drinks/virginsip
	name = "Virgin Sip"
	id = "virginsip"
	result = "virginsip"
	required_reagents = list("driestmartini" = 1, REAGENT_ID_WATER = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/chocoshake
	name = REAGENT_CHOCOSHAKE
	id = REAGENT_ID_CHOCOSHAKE
	result = REAGENT_ID_CHOCOSHAKE
	required_reagents = list(REAGENT_ID_MILKSHAKE = 1, REAGENT_ID_COCO = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/berryshake
	name = REAGENT_BERRYSHAKE
	id = REAGENT_ID_BERRYSHAKE
	result = REAGENT_ID_BERRYSHAKE
	required_reagents = list(REAGENT_ID_MILKSHAKE = 1, REAGENT_ID_BERRYJUICE = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/coffeeshake
	name = REAGENT_COFFEESHAKE
	id = REAGENT_ID_COFFEESHAKE
	result = REAGENT_ID_COFFEESHAKE
	required_reagents = list(REAGENT_ID_MILKSHAKE = 1, REAGENT_ID_COFFEE = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/jellyshot
	name = "Jelly Shot"
	id = "jellyshot"
	result = "jellyshot"
	required_reagents = list(REAGENT_ID_CHERRYJELLY = 4, "vodka" = 1)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/slimeshot
	name = "Named Bullet"
	id = "slimeshot"
	result = "slimeshot"
	required_reagents = list(REAGENT_ID_SLIMEJELLY = 4, "vodka" = 1)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/negroni
	name = "Negroni"
	id = "negroni"
	result = "negroni"
	required_reagents = list("gin" = 1, "bitters" = 1, "vermouth" = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/cloverclub
	name = "Clover Club"
	id = "cloverclub"
	result = "cloverclub"
	required_reagents = list(REAGENT_ID_BERRYJUICE = 1, REAGENT_ID_LEMONJUICE = 1, "gin" = 3)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/oldfashioned
	name = "Old Fashioned"
	id = "oldfashioned"
	result = "oldfashioned"
	required_reagents = list("whiskey" = 3, "bitters" = 1, REAGENT_ID_SUGAR = 1)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/whiskeysour
	name = "Whiskey Sour"
	id = "whiskeysour"
	result = "whiskeysour"
	required_reagents = list("whiskey" = 2, REAGENT_ID_LEMONJUICE = 1, REAGENT_ID_SUGAR = 1)
	result_amount = 4

/decl/chemical_reaction/instant/drinks/daiquiri
	name = "Daiquiri"
	id = "daiquiri"
	result = "daiquiri"
	required_reagents = list("rum" = 3, REAGENT_ID_LIMEJUICE = 2, REAGENT_ID_SUGAR = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/mintjulep
	name = "Mint Julep"
	id = "mintjulep"
	result = "mintjulep"
	required_reagents = list("whiskey" = 2, REAGENT_ID_WATER = 1, REAGENT_ID_MINT = 1)
	result_amount = 4

/decl/chemical_reaction/instant/drinks/paloma
	name = "Paloma"
	id = "paloma"
	result = "paloma"
	required_reagents = list(REAGENT_ID_SODAWATER = 1, "tequillasunrise" = 2)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/mojito
	name = "Mojito"
	id = "mojito"
	result = "mojito"
	required_reagents = list("rum" = 3, REAGENT_ID_LIMEJUICE = 1, REAGENT_ID_MINT = 1)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/virginmojito
	name = "Mojito"
	id = "virginmojito"
	result = "virginmojito"
	required_reagents = list(REAGENT_ID_SODAWATER = 3, REAGENT_ID_LIMEJUICE = 1, REAGENT_ID_MINT = 1, REAGENT_ID_SUGAR = 1)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/piscosour
	name = "Pisco Sour"
	id = "piscosour"
	result = "piscosour"
	required_reagents = list("winebrandy" = 1, REAGENT_ID_LEMONJUICE = 1, REAGENT_ID_SUGAR = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/coldfront
	name = "Cold Front"
	id = "coldfront"
	result = "coldfront"
	required_reagents = list(REAGENT_ID_ICECOFFEE = 1, "whiskey" = 1, REAGENT_ID_MINT = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/godsake
	name = "Gods Sake"
	id = "godsake"
	result = "godsake"
	required_reagents = list("sake" = 2, REAGENT_ID_HOLYWATER = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/godka //Why you would put this in your body, I don't know.
	name = "Godka"
	id = "godka"
	result = "godka"
	required_reagents = list("vodka" = 1, REAGENT_ID_HOLYWATER = 1, REAGENT_ID_ETHANOL = 1, REAGENT_ID_CARTHATOLINE = 1)
	catalysts = list(REAGENT_ID_ENZYME = 5, REAGENT_ID_HOLYWATER = 5)
	result_amount = 1

/decl/chemical_reaction/instant/drinks/holywine
	name = "Angel Ichor"
	id = "holywine"
	result = "holywine"
	required_reagents = list(REAGENT_ID_GRAPEJUICE = 5, REAGENT_ID_GOLD = 5)
	catalysts = list(REAGENT_ID_HOLYWATER = 5)
	result_amount = 10

/decl/chemical_reaction/instant/drinks/holy_mary
	name = "Holy Mary"
	id = "holymary"
	result = "holymary"
	required_reagents = list("vodka" = 2, "holywine" = 3, REAGENT_ID_LIMEJUICE = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/angelskiss
	name = "Angels Kiss"
	id = "angelskiss"
	result = "angelskiss"
	required_reagents = list("holywine" = 1, "kahlua" = 1, "rum" = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/angelswrath
	name = "Angels Wrath"
	id = "angelswrath"
	result = "angelswrath"
	required_reagents = list("rum" = 3, REAGENT_ID_SPACEMOUNTAINWIND = 1, "holywine" = 1, REAGENT_ID_DRGIBB = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/ichor_mead
	name = "Ichor Mead"
	id = "ichor_mead"
	result = "ichor_mead"
	required_reagents = list("holywine" = 1, "mead" = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/oilslick
	name = "Oil Slick"
	id = "oilslick"
	result = "oilslick"
	required_reagents = list(REAGENT_ID_COOKINGOIL = 2, REAGENT_ID_HONEY = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/slimeslam
	name = "Slick Slime Slammer"
	id = "slimeslammer"
	result = "slimeslammer"
	required_reagents = list(REAGENT_ID_COOKINGOIL = 2, REAGENT_ID_PEANUTBUTTER = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/virginsexonthebeach
	name = "Virgin Sex On The Beach"
	id = "virginsexonthebeach"
	result = "virginsexonthebeach"
	required_reagents = list(REAGENT_ID_ORANGEJUICE = 3, REAGENT_ID_GRENADINE = 2)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/sexonthebeach
	name = "Sex On The Beach"
	id = "sexonthebeach"
	result = "sexonthebeach"
	required_reagents = list("virginsexonthebeach" = 5, "vodka" = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/eggnog
	name = "Eggnog"
	id = "eggnog"
	result = "eggnog"
	required_reagents = list(REAGENT_ID_MILK = 5, REAGENT_ID_CREAM = 5, REAGENT_ID_SUGAR = 5, REAGENT_ID_EGG = 3)
	result_amount = 15

/decl/chemical_reaction/instant/drinks/nuclearwaste_radium
	name = "Nuclear Waste"
	id = "nuclearwasterad"
	result = "nuclearwaste"
	required_reagents = list("oilslick" = 1, REAGENT_ID_RADIUM = 1, REAGENT_ID_LIMEJUICE = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/nuclearwaste_uranium
	name = "Nuclear Waste"
	id = "nuclearwasteuran"
	result = "nuclearwaste"
	required_reagents = list("oilslick" = 2, REAGENT_ID_URANIUM = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/sodaoil
	name = "Soda Oil"
	id = "sodaoil"
	result = "sodaoil"
	required_reagents = list(REAGENT_ID_COOKINGOIL = 4, REAGENT_ID_SODAWATER = 1, REAGENT_ID_CARBON = 1, REAGENT_ID_TRICORDRAZINE = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/fusionnaire
	name = "Fusionnaire"
	id = "fusionnaire"
	result = "fusionnaire"
	required_reagents = list(REAGENT_ID_LEMONJUICE = 3, "vodka" = 2, "schnapps_pep" = 1, "schnapps_lem" = 1, "rum" = 1, "ice" = 1)
	result_amount = 9
