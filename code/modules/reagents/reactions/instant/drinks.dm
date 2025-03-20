/decl/chemical_reaction/instant/drinks
	name = REAGENT_DEVELOPER_WARNING // Unit test ignore

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
	name = REAGENT_GOLDSCHLAGER
	id = REAGENT_ID_GOLDSCHLAGER
	result = REAGENT_ID_GOLDSCHLAGER
	required_reagents = list(REAGENT_ID_VODKA = 10, REAGENT_ID_GOLD = 1)
	result_amount = 10

/decl/chemical_reaction/instant/drinks/patron
	name = REAGENT_PATRON
	id = REAGENT_ID_PATRON
	result = REAGENT_ID_PATRON
	required_reagents = list(REAGENT_ID_TEQUILA = 10, REAGENT_ID_SILVER = 1)
	result_amount = 10

/decl/chemical_reaction/instant/drinks/bilk
	name = REAGENT_BILK
	id = REAGENT_ID_BILK
	result = REAGENT_ID_BILK
	required_reagents = list(REAGENT_ID_MILK = 1, REAGENT_ID_BEER = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/icetea
	name = REAGENT_ICETEA
	id = REAGENT_ID_ICETEA
	result = REAGENT_ID_ICETEA
	required_reagents = list(REAGENT_ID_ICE = 1, REAGENT_ID_TEA = 2)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/icecoffee
	name = REAGENT_ICECOFFEE
	id = REAGENT_ID_ICECOFFEE
	result = REAGENT_ID_ICECOFFEE
	required_reagents = list(REAGENT_ID_ICE = 1, REAGENT_ID_COFFEE = 2)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/icecoffee/alt
	name = "Iced Drip Coffee"
	id = REAGENT_ID_ICECOFFEE + "_drip"
	result = REAGENT_ID_ICECOFFEE
	required_reagents = list(REAGENT_ID_ICE = 1, REAGENT_ID_DRIPCOFFEE = 2)
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
	required_reagents = list(REAGENT_ID_WATER = 1, REAGENT_ID_LONGBLACK = 2)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/long_black
	name = REAGENT_LONGBLACK
	id = REAGENT_ID_LONGBLACK
	result = REAGENT_ID_LONGBLACK
	required_reagents = list(REAGENT_ID_WATER = 1, REAGENT_ID_COFFEE = 1)
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
	id = REAGENT_ID_MOCHA + "_milk"
	result = REAGENT_ID_MOCHA
	required_reagents = list(REAGENT_ID_MILK = 1, REAGENT_ID_CREAM = 1, REAGENT_ID_MILKFOAM = 1, REAGENT_ID_HOTCOCO = 2, REAGENT_ID_BREVE = 5) // 2 coffee, 2 milk, 2 cream, 2 milk foam and 2 hot coco
	result_amount = 10

/decl/chemical_reaction/instant/drinks/mocha/alt //incase they use cream before milk
	name = REAGENT_MOCHA
	id = REAGENT_ID_MOCHA + "_cream"
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
	name = REAGENT_MOONSHINE
	id = REAGENT_ID_MOONSHINE
	result = REAGENT_ID_MOONSHINE
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
	id = REAGENT_ID_REDWINE
	result = REAGENT_ID_REDWINE
	required_reagents = list(REAGENT_ID_GRAPEJUICE = 10)
	catalysts = list(REAGENT_ID_ENZYME = 5)
	result_amount = 10

/decl/chemical_reaction/instant/drinks/pwine
	name = REAGENT_PWINE
	id = REAGENT_ID_PWINE
	result = REAGENT_ID_PWINE
	required_reagents = list(REAGENT_ID_POISONBERRYJUICE = 10)
	catalysts = list(REAGENT_ID_ENZYME = 5)
	result_amount = 10

/decl/chemical_reaction/instant/drinks/melonliquor
	name = REAGENT_MELONLIQUOR
	id = REAGENT_ID_MELONLIQUOR
	result = REAGENT_ID_MELONLIQUOR
	required_reagents = list(REAGENT_ID_WATERMELONJUICE = 10)
	catalysts = list(REAGENT_ID_ENZYME = 5)
	result_amount = 10

/decl/chemical_reaction/instant/drinks/bluecuracao
	name = REAGENT_BLUECURACAO
	id = REAGENT_ID_BLUECURACAO
	result = REAGENT_ID_BLUECURACAO
	required_reagents = list(REAGENT_ID_ORANGEJUICE = 10)
	catalysts = list(REAGENT_ID_ENZYME = 5)
	result_amount = 10

/decl/chemical_reaction/instant/drinks/spacebeer
	name = "Space Beer"
	id = "spacebeer"
	result = REAGENT_ID_BEER
	required_reagents = list(REAGENT_ID_CORNOIL = 5, REAGENT_ID_FLOUR = 5)
	catalysts = list(REAGENT_ID_ENZYME = 5)
	result_amount = 10

/decl/chemical_reaction/instant/drinks/vodka
	name = REAGENT_VODKA
	id = REAGENT_ID_VODKA
	result = REAGENT_ID_VODKA
	required_reagents = list(REAGENT_ID_POTATOJUICE = 10)
	catalysts = list(REAGENT_ID_ENZYME = 5)
	result_amount = 10

/decl/chemical_reaction/instant/drinks/cider
	name = REAGENT_CIDER
	id = REAGENT_ID_CIDER
	result = REAGENT_ID_CIDER
	required_reagents = list(REAGENT_ID_APPLEJUICE = 10)
	catalysts = list(REAGENT_ID_ENZYME = 5)
	result_amount = 10


/decl/chemical_reaction/instant/drinks/sake
	name = REAGENT_SAKE
	id = REAGENT_ID_SAKE
	result = REAGENT_ID_SAKE
	required_reagents = list(REAGENT_ID_RICE = 10)
	catalysts = list(REAGENT_ID_ENZYME = 5)
	result_amount = 10

/decl/chemical_reaction/instant/drinks/kahlua
	name = REAGENT_KAHLUA
	id = REAGENT_ID_KAHLUA
	result = REAGENT_ID_KAHLUA
	required_reagents = list(REAGENT_ID_COFFEE = 5, REAGENT_ID_SUGAR = 5)
	catalysts = list(REAGENT_ID_ENZYME = 5)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/gin_tonic
	name = REAGENT_GINTONIC
	id = REAGENT_ID_GINTONIC
	result = REAGENT_ID_GINTONIC
	required_reagents = list(REAGENT_ID_GIN = 2, REAGENT_ID_TONIC = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/rum_and_cola
	name = REAGENT_RUMANDCOLA
	id = REAGENT_ID_RUMANDCOLA
	result = REAGENT_ID_RUMANDCOLA
	required_reagents = list(REAGENT_ID_RUM = 2, REAGENT_ID_COLA = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/cuba_libre
	name = REAGENT_CUBALIBRE
	id = REAGENT_ID_CUBALIBRE
	result = REAGENT_ID_CUBALIBRE
	required_reagents = list(REAGENT_ID_RUMANDCOLA = 3, REAGENT_ID_LIMEJUICE = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/martini
	name = REAGENT_MARTINI
	id = REAGENT_ID_MARTINI
	result = REAGENT_ID_MARTINI
	inhibitors = list(REAGENT_ID_BITTERS = 1)
	required_reagents = list(REAGENT_ID_GIN = 2, REAGENT_ID_VERMOUTH = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/vodkamartini
	name = REAGENT_VODKAMARTINI
	id = REAGENT_ID_VODKAMARTINI
	result = REAGENT_ID_VODKAMARTINI
	required_reagents = list(REAGENT_ID_VODKA = 2, REAGENT_ID_VERMOUTH = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/white_russian
	name = REAGENT_WHITERUSSIAN
	id = REAGENT_ID_WHITERUSSIAN
	result = REAGENT_ID_WHITERUSSIAN
	required_reagents = list(REAGENT_ID_BLACKRUSSIAN = 2, REAGENT_ID_CREAM = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/whiskey_cola
	name = REAGENT_WHISKEYCOLA
	id = REAGENT_ID_WHISKEYCOLA
	result = REAGENT_ID_WHISKEYCOLA
	required_reagents = list(REAGENT_ID_WHISKEY = 2, REAGENT_ID_COLA = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/screwdriver
	name = REAGENT_SCREWDRIVERCOCKTAIL
	id = REAGENT_ID_SCREWDRIVERCOCKTAIL
	result = REAGENT_ID_SCREWDRIVERCOCKTAIL
	required_reagents = list(REAGENT_ID_VODKA = 2, REAGENT_ID_ORANGEJUICE = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/bloody_mary
	name = REAGENT_BLOODYMARY
	id = REAGENT_ID_BLOODYMARY
	result = REAGENT_ID_BLOODYMARY
	required_reagents = list(REAGENT_ID_VODKA = 2, REAGENT_ID_TOMATOJUICE = 3, REAGENT_ID_LIMEJUICE = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/gargle_blaster
	name = REAGENT_GARGLEBLASTER
	id = REAGENT_ID_GARGLEBLASTER
	result = REAGENT_ID_GARGLEBLASTER
	required_reagents = list(REAGENT_ID_VODKA = 2, REAGENT_ID_GIN = 1, REAGENT_ID_WHISKEY = 1, REAGENT_ID_COGNAC = 1, REAGENT_ID_LIMEJUICE = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/brave_bull
	name = REAGENT_BRAVEBULL
	id = REAGENT_ID_BRAVEBULL
	result = REAGENT_ID_BRAVEBULL
	required_reagents = list(REAGENT_ID_TEQUILA = 2, REAGENT_ID_KAHLUA = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/tequila_sunrise
	name = "Tequilla Sunrise"
	id = REAGENT_ID_TEQUILASUNRISE
	result = REAGENT_ID_TEQUILASUNRISE
	required_reagents = list(REAGENT_ID_TEQUILA = 2, REAGENT_ID_ORANGEJUICE = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/phoron_special
	name = REAGENT_PHORONSPECIAL
	id = REAGENT_ID_PHORONSPECIAL
	result = REAGENT_ID_PHORONSPECIAL
	required_reagents = list(REAGENT_ID_RUM = 2, REAGENT_ID_VERMOUTH = 2, REAGENT_ID_PHORON = 2)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/beepsky_smash
	name = "Beepksy Smash"
	id = "beepksysmash"
	result = REAGENT_ID_BEEPSKYSMASH
	required_reagents = list(REAGENT_ID_LIMEJUICE = 1, REAGENT_ID_WHISKEY = 1, REAGENT_ID_IRON = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/doctor_delight
	name = REAGENT_DOCTORSDELIGHT
	id = "doctordelight"
	result = REAGENT_ID_DOCTORSDELIGHT
	required_reagents = list(REAGENT_ID_LIMEJUICE = 1, REAGENT_ID_TOMATOJUICE = 1, REAGENT_ID_ORANGEJUICE = 1, REAGENT_ID_CREAM = 2, REAGENT_ID_TRICORDRAZINE = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/irish_cream
	name = REAGENT_IRISHCREAM
	id = REAGENT_ID_IRISHCREAM
	result = REAGENT_ID_IRISHCREAM
	required_reagents = list(REAGENT_ID_WHISKEY = 2, REAGENT_ID_CREAM = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/manly_dorf
	name = REAGENT_MANLYDORF
	id = REAGENT_ID_MANLYDORF
	result = REAGENT_ID_MANLYDORF
	required_reagents = list (REAGENT_ID_BEER = 1, REAGENT_ID_ALE = 2)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/hooch
	name = REAGENT_HOOCH
	id = REAGENT_ID_HOOCH
	result = REAGENT_ID_HOOCH
	required_reagents = list (REAGENT_ID_SUGAR = 1, REAGENT_ID_ETHANOL = 2, REAGENT_ID_FUEL = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/irish_coffee
	name = REAGENT_IRISHCOFFEE
	id = REAGENT_ID_IRISHCOFFEE
	result = REAGENT_ID_IRISHCOFFEE
	required_reagents = list(REAGENT_ID_IRISHCREAM = 1, REAGENT_ID_COFFEE = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/b52
	name = REAGENT_B52
	id = REAGENT_ID_B52
	result = REAGENT_ID_B52
	required_reagents = list(REAGENT_ID_IRISHCREAM = 1, REAGENT_ID_KAHLUA = 1, REAGENT_ID_COGNAC = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/atomicbomb
	name = REAGENT_ATOMICBOMB
	id = REAGENT_ID_ATOMICBOMB
	result = REAGENT_ID_ATOMICBOMB
	required_reagents = list(REAGENT_ID_B52 = 10, REAGENT_ID_URANIUM = 1)
	result_amount = 10

/decl/chemical_reaction/instant/drinks/margarita
	name = REAGENT_MARGARITA
	id = REAGENT_ID_MARGARITA
	result = REAGENT_ID_MARGARITA
	required_reagents = list(REAGENT_ID_TEQUILA = 2, REAGENT_ID_LIMEJUICE = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/longislandicedtea
	name = REAGENT_LONGISLANDICEDTEA
	id = REAGENT_ID_LONGISLANDICEDTEA
	result = REAGENT_ID_LONGISLANDICEDTEA
	required_reagents = list(REAGENT_ID_VODKA = 1, REAGENT_ID_GIN = 1, REAGENT_ID_TEQUILA = 1, REAGENT_ID_RUMANDCOLA = 3)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/threemileisland
	name = REAGENT_THREEMILEISLAND
	id = REAGENT_ID_THREEMILEISLAND
	result = REAGENT_ID_THREEMILEISLAND
	required_reagents = list(REAGENT_ID_LONGISLANDICEDTEA = 10, REAGENT_ID_URANIUM = 1)
	result_amount = 10

/decl/chemical_reaction/instant/drinks/whiskeysoda
	name = REAGENT_WHISKEYSODA
	id = REAGENT_ID_WHISKEYSODA
	result = REAGENT_ID_WHISKEYSODA
	required_reagents = list(REAGENT_ID_WHISKEY = 2, REAGENT_ID_SODAWATER = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/black_russian
	name = REAGENT_BLACKRUSSIAN
	id = REAGENT_ID_BLACKRUSSIAN
	result = REAGENT_ID_BLACKRUSSIAN
	required_reagents = list(REAGENT_ID_VODKA = 2, REAGENT_ID_KAHLUA = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/manhattan
	name = REAGENT_MANHATTAN
	id = REAGENT_ID_MANHATTAN
	result = REAGENT_ID_MANHATTAN
	required_reagents = list(REAGENT_ID_WHISKEY = 2, REAGENT_ID_VERMOUTH = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/manhattan_proj
	name = REAGENT_MANHATTANPROJ
	id = REAGENT_ID_MANHATTANPROJ
	result = REAGENT_ID_MANHATTANPROJ
	required_reagents = list(REAGENT_ID_MANHATTAN = 10, REAGENT_ID_URANIUM = 1)
	result_amount = 10

/decl/chemical_reaction/instant/drinks/vodka_tonic
	name = REAGENT_VODKATONIC
	id = REAGENT_ID_VODKATONIC
	result = REAGENT_ID_VODKATONIC
	required_reagents = list(REAGENT_ID_VODKA = 2, REAGENT_ID_TONIC = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/gin_fizz
	name = REAGENT_GINFIZZ
	id = REAGENT_ID_GINFIZZ
	result = REAGENT_ID_GINFIZZ
	required_reagents = list(REAGENT_ID_GIN = 1, REAGENT_ID_SODAWATER = 1, REAGENT_ID_LIMEJUICE = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/bahama_mama
	name = REAGENT_BAHAMAMAMA
	id = REAGENT_ID_BAHAMAMAMA
	result = REAGENT_ID_BAHAMAMAMA
	required_reagents = list(REAGENT_ID_RUM = 2, REAGENT_ID_ORANGEJUICE = 2, REAGENT_ID_LIMEJUICE = 1, REAGENT_ID_ICE = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/singulo
	name = REAGENT_SINGULO
	id = REAGENT_ID_SINGULO
	result = REAGENT_ID_SINGULO
	required_reagents = list(REAGENT_ID_VODKA = 5, REAGENT_ID_RADIUM = 1, REAGENT_ID_REDWINE = 5)
	result_amount = 10

/decl/chemical_reaction/instant/drinks/alliescocktail
	name = REAGENT_ALLIESCOCKTAIL
	id = REAGENT_ID_ALLIESCOCKTAIL
	result = REAGENT_ID_ALLIESCOCKTAIL
	required_reagents = list(REAGENT_ID_MARTINI = 1, REAGENT_ID_VODKA = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/demonsblood
	name = REAGENT_DEMONSBLOOD
	id = REAGENT_ID_DEMONSBLOOD
	result = REAGENT_ID_DEMONSBLOOD
	required_reagents = list(REAGENT_ID_RUM = 3, REAGENT_ID_SPACEMOUNTAINWIND = 1, REAGENT_ID_BLOOD = 1, REAGENT_ID_DRGIBB = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/booger
	name = REAGENT_BOOGER
	id = REAGENT_ID_BOOGER
	result = REAGENT_ID_BOOGER
	required_reagents = list(REAGENT_ID_CREAM = 2, REAGENT_ID_BANANA = 1, REAGENT_ID_RUM = 1, REAGENT_ID_WATERMELONJUICE = 1)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/antifreeze
	name = REAGENT_ANTIFREEZE
	id = REAGENT_ID_ANTIFREEZE
	result = REAGENT_ID_ANTIFREEZE
	required_reagents = list(REAGENT_ID_VODKA = 1, REAGENT_ID_CREAM = 1, REAGENT_ID_ICE = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/barefoot
	name = REAGENT_BAREFOOT
	id = REAGENT_ID_BAREFOOT
	result = REAGENT_ID_BAREFOOT
	required_reagents = list(REAGENT_ID_BERRYJUICE = 1, REAGENT_ID_CREAM = 1, REAGENT_ID_VERMOUTH = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/grapesoda
	name = REAGENT_GRAPESODA
	id = REAGENT_ID_GRAPESODA
	result = REAGENT_ID_GRAPESODA
	required_reagents = list(REAGENT_ID_GRAPEJUICE = 2, REAGENT_ID_COLA = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/sbiten
	name = REAGENT_SBITEN
	id = REAGENT_ID_SBITEN
	result = REAGENT_ID_SBITEN
	required_reagents = list(REAGENT_ID_VODKA = 10, REAGENT_ID_CAPSAICIN = 1)
	result_amount = 10

/decl/chemical_reaction/instant/drinks/red_mead
	name = REAGENT_REDMEAD
	id = REAGENT_ID_REDMEAD
	result = REAGENT_ID_REDMEAD
	required_reagents = list(REAGENT_ID_BLOOD = 1, REAGENT_ID_MEAD = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/mead
	name = REAGENT_MEAD
	id = REAGENT_ID_MEAD
	result = REAGENT_ID_MEAD
	required_reagents = list(REAGENT_ID_SUGAR = 1, REAGENT_ID_WATER = 1)
	catalysts = list(REAGENT_ID_ENZYME = 5)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/iced_beer
	name = REAGENT_ICEDBEER
	id = REAGENT_ID_ICEDBEER
	result = REAGENT_ID_ICEDBEER
	required_reagents = list(REAGENT_ID_BEER = 10, REAGENT_ID_FROSTOIL = 1)
	result_amount = 10

/decl/chemical_reaction/instant/drinks/iced_beer2
	name = REAGENT_ICEDBEER
	id = REAGENT_ID_ICEDBEER + "_ice"
	result = REAGENT_ID_ICEDBEER
	required_reagents = list(REAGENT_ID_BEER = 5, REAGENT_ID_ICE = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/grog
	name = REAGENT_GROG
	id = REAGENT_ID_GROG
	result = REAGENT_ID_GROG
	required_reagents = list(REAGENT_ID_RUM = 1, REAGENT_ID_WATER = 1)
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
	name = REAGENT_ACIDSPIT
	id = REAGENT_ID_ACIDSPIT
	result = REAGENT_ID_ACIDSPIT
	required_reagents = list(REAGENT_ID_SACID = 1, REAGENT_ID_REDWINE = 5)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/amasec
	name = REAGENT_AMASEC
	id = REAGENT_ID_AMASEC
	result = REAGENT_ID_AMASEC
	required_reagents = list(REAGENT_ID_IRON = 1, REAGENT_ID_REDWINE = 5, REAGENT_ID_VODKA = 5)
	result_amount = 10

/decl/chemical_reaction/instant/drinks/changeling_sting
	name = REAGENT_CHANGELINGSTING
	id = REAGENT_ID_CHANGELINGSTING
	result = REAGENT_ID_CHANGELINGSTING
	required_reagents = list(REAGENT_ID_SCREWDRIVERCOCKTAIL = 1, REAGENT_ID_LIMEJUICE = 1, REAGENT_ID_LEMONJUICE = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/aloe
	name = REAGENT_ALOE
	id = REAGENT_ID_ALOE
	result = REAGENT_ID_ALOE
	required_reagents = list(REAGENT_ID_CREAM = 1, REAGENT_ID_WHISKEY = 1, REAGENT_ID_WATERMELONJUICE = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/andalusia
	name = REAGENT_ANDALUSIA
	id = REAGENT_ID_ANDALUSIA
	result = REAGENT_ID_ANDALUSIA
	required_reagents = list(REAGENT_ID_RUM = 1, REAGENT_ID_WHISKEY = 1, REAGENT_ID_LEMONJUICE = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/snowwhite
	name = REAGENT_SNOWWHITE
	id = REAGENT_ID_SNOWWHITE
	result = REAGENT_ID_SNOWWHITE
	required_reagents = list(REAGENT_ID_PINEAPPLEJUICE = 1, REAGENT_ID_RUM = 1, REAGENT_ID_LEMONLIME = 1, REAGENT_ID_EGG = 1, REAGENT_ID_KAHLUA = 1, REAGENT_ID_SUGAR = 1) //VoreStation Edit
	result_amount = 2

/decl/chemical_reaction/instant/drinks/irishcarbomb
	name = REAGENT_IRISHCARBOMB
	id = REAGENT_ID_IRISHCARBOMB
	result = REAGENT_ID_IRISHCARBOMB
	required_reagents = list(REAGENT_ID_ALE = 1, REAGENT_ID_IRISHCREAM = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/syndicatebomb
	name = REAGENT_SYNDICATEBOMB
	id = REAGENT_ID_SYNDICATEBOMB
	result = REAGENT_ID_SYNDICATEBOMB
	required_reagents = list(REAGENT_ID_BEER = 1, REAGENT_ID_WHISKEYCOLA = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/erikasurprise
	name = REAGENT_ERIKASURPRISE
	id = REAGENT_ID_ERIKASURPRISE
	result = REAGENT_ID_ERIKASURPRISE
	required_reagents = list(REAGENT_ID_ALE = 2, REAGENT_ID_LIMEJUICE = 1, REAGENT_ID_WHISKEY = 1, REAGENT_ID_BANANA = 1, REAGENT_ID_ICE = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/devilskiss
	name = REAGENT_DEVILSKISS
	id = REAGENT_ID_DEVILSKISS
	result = REAGENT_ID_DEVILSKISS
	required_reagents = list(REAGENT_ID_BLOOD = 1, REAGENT_ID_KAHLUA = 1, REAGENT_ID_RUM = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/hippiesdelight
	name = "Hippies Delight"
	id = REAGENT_ID_HIPPIESDELIGHT
	result = REAGENT_ID_HIPPIESDELIGHT
	required_reagents = list(REAGENT_ID_PSILOCYBIN = 1, REAGENT_ID_GARGLEBLASTER = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/bananahonk
	name = "Banana Honk"
	id = REAGENT_ID_BANANAHONK
	result = REAGENT_ID_BANANAHONK
	required_reagents = list(REAGENT_ID_BANANA = 1, REAGENT_ID_CREAM = 1, REAGENT_ID_SUGAR = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/silencer
	name = REAGENT_SILENCER
	id = REAGENT_ID_SILENCER
	result = REAGENT_ID_SILENCER
	required_reagents = list(REAGENT_ID_NOTHING = 1, REAGENT_ID_CREAM = 1, REAGENT_ID_SUGAR = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/driestmartini
	name = REAGENT_DRIESTMARTINI
	id = REAGENT_ID_DRIESTMARTINI
	result = REAGENT_ID_DRIESTMARTINI
	required_reagents = list(REAGENT_ID_NOTHING = 1, REAGENT_ID_GIN = 1)
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
	id = REAGENT_ID_DRIVERSPUNCH
	result = REAGENT_ID_DRIVERSPUNCH
	required_reagents = list(REAGENT_ID_APPLEADE = 2, REAGENT_ID_ORANGEJUICE = 1, REAGENT_ID_MINT = 1, REAGENT_ID_SODAWATER = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/mintapplesparkle
	name = REAGENT_MINTAPPLESPARKLE
	id = REAGENT_ID_MINTAPPLESPARKLE
	result = REAGENT_ID_MINTAPPLESPARKLE
	required_reagents = list(REAGENT_ID_APPLEADE = 2, REAGENT_ID_MINT = 1)
	inhibitors = list(REAGENT_ID_SODAWATER = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/berrycordial
	name = REAGENT_BERRYCORDIAL
	id = REAGENT_ID_BERRYCORDIAL
	result = REAGENT_ID_BERRYCORDIAL
	required_reagents = list(REAGENT_ID_BERRYJUICE = 4, REAGENT_ID_SUGAR = 1, REAGENT_ID_LEMONJUICE = 1)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/tropicalfizz
	name = REAGENT_TROPICALFIZZ
	id = REAGENT_ID_TROPICALFIZZ
	result = REAGENT_ID_TROPICALFIZZ
	required_reagents = list(REAGENT_ID_SODAWATER = 6, REAGENT_ID_BERRYJUICE = 1, REAGENT_ID_MINT = 1, REAGENT_ID_LIMEJUICE = 1, REAGENT_ID_LEMONJUICE = 1, REAGENT_ID_PINEAPPLEJUICE = 1)
	inhibitors = list(REAGENT_ID_SUGAR = 1)
	result_amount = 8

/decl/chemical_reaction/instant/drinks/melonspritzer
	name = REAGENT_MELONSPRITZER
	id = REAGENT_ID_MELONSPRITZER
	result = REAGENT_ID_MELONSPRITZER
	required_reagents = list(REAGENT_ID_WATERMELONJUICE = 2, REAGENT_ID_REDWINE = 2, REAGENT_ID_APPLEJUICE = 1, REAGENT_ID_LIMEJUICE = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/fauxfizz
	name = REAGENT_FAUXFIZZ
	id = REAGENT_ID_FAUXFIZZ
	result = REAGENT_ID_FAUXFIZZ
	required_reagents = list(REAGENT_ID_SODAWATER = 2, REAGENT_ID_BERRYJUICE = 1, REAGENT_ID_APPLEJUICE = 1, REAGENT_ID_LIMEJUICE = 1, REAGENT_ID_HONEY = 1)
	inhibitors = list(REAGENT_ID_SUGAR = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/firepunch
	name = REAGENT_FIREPUNCH
	id = REAGENT_ID_FIREPUNCH
	result = REAGENT_ID_FIREPUNCH
	required_reagents = list(REAGENT_ID_SUGAR = 1, REAGENT_ID_RUM = 2)
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
	required_reagents = list(REAGENT_ID_CREAM = 1, REAGENT_ID_ICE = 2, REAGENT_ID_MILK = 2)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/peanutmilkshake
	name = "Peanutbutter Milkshake"
	id = REAGENT_ID_PEANUTMILKSHAKE
	result = REAGENT_ID_PEANUTMILKSHAKE
	required_reagents = list(REAGENT_ID_CREAM = 1, REAGENT_ID_ICE = 1, REAGENT_ID_PEANUTBUTTER = 2, REAGENT_ID_MILK = 1)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/rewriter
	name = REAGENT_REWRITER
	id = REAGENT_ID_REWRITER
	result = REAGENT_ID_REWRITER
	required_reagents = list(REAGENT_ID_SPACEMOUNTAINWIND = 1, REAGENT_ID_COFFEE = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/suidream
	name = REAGENT_SUIDREAM
	id = REAGENT_ID_SUIDREAM
	result = REAGENT_ID_SUIDREAM
	required_reagents = list(REAGENT_ID_SPACEUP = 1, REAGENT_ID_BLUECURACAO = 1, REAGENT_ID_MELONLIQUOR = 1)
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
	name = REAGENT_SAKEBOMB
	id = REAGENT_ID_SAKEBOMB
	result = REAGENT_ID_SAKEBOMB
	required_reagents = list(REAGENT_ID_BEER = 2, REAGENT_ID_SAKE = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/tamagozake
	name = REAGENT_TAMAGOZAKE
	id = REAGENT_ID_TAMAGOZAKE
	result = REAGENT_ID_TAMAGOZAKE
	required_reagents = list(REAGENT_ID_SAKE = 10, REAGENT_ID_SUGAR = 5, REAGENT_ID_EGG = 3)
	result_amount = 15

/decl/chemical_reaction/instant/drinks/ginzamary
	name = REAGENT_GINZAMARY
	id = REAGENT_ID_GINZAMARY
	result = REAGENT_ID_GINZAMARY
	required_reagents = list(REAGENT_ID_SAKE = 2, REAGENT_ID_VODKA = 2, REAGENT_ID_TOMATOJUICE = 1)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/tokyorose
	name = REAGENT_TOKYOROSE
	id = REAGENT_ID_TOKYOROSE
	result = REAGENT_ID_TOKYOROSE
	required_reagents = list(REAGENT_ID_SAKE = 1, REAGENT_ID_BERRYJUICE = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/saketini
	name = REAGENT_SAKETINI
	id = REAGENT_ID_SAKETINI
	result = REAGENT_ID_SAKETINI
	required_reagents = list(REAGENT_ID_SAKE = 1, REAGENT_ID_GIN = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/elysiumfacepunch
	name = REAGENT_ELYSIUMFACEPUNCH
	id = REAGENT_ID_ELYSIUMFACEPUNCH
	result = REAGENT_ID_ELYSIUMFACEPUNCH
	required_reagents = list(REAGENT_ID_KAHLUA = 1, REAGENT_ID_LEMONJUICE = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/erebusmoonrise
	name = REAGENT_EREBUSMOONRISE
	id = REAGENT_ID_EREBUSMOONRISE
	result = REAGENT_ID_EREBUSMOONRISE
	required_reagents = list(REAGENT_ID_WHISKEY = 1, REAGENT_ID_VODKA = 1, REAGENT_ID_TEQUILA = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/balloon
	name = REAGENT_BALLOON
	id = REAGENT_ID_BALLOON
	result = REAGENT_ID_BALLOON
	required_reagents = list(REAGENT_ID_CREAM = 1, REAGENT_ID_BLUECURACAO = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/natunabrandy
	name = REAGENT_NATUNABRANDY
	id = REAGENT_ID_NATUNABRANDY
	result = REAGENT_ID_NATUNABRANDY
	required_reagents = list(REAGENT_ID_BEER = 1, REAGENT_ID_SODAWATER = 2)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/euphoria
	name = REAGENT_EUPHORIA
	id = REAGENT_ID_EUPHORIA
	result = REAGENT_ID_EUPHORIA
	required_reagents = list(REAGENT_ID_SPECIALWHISKEY = 1, REAGENT_ID_COGNAC = 2)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/xanaducannon
	name = REAGENT_XANADUCANNON
	id = REAGENT_ID_XANADUCANNON
	result = REAGENT_ID_XANADUCANNON
	required_reagents = list(REAGENT_ID_ALE = 1, REAGENT_ID_DRGIBB = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/debugger
	name = REAGENT_DEBUGGER
	id = REAGENT_ID_DEBUGGER
	result = REAGENT_ID_DEBUGGER
	required_reagents = list(REAGENT_ID_FUEL = 1, REAGENT_ID_SUGAR = 2, REAGENT_ID_COOKINGOIL = 2)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/spacersbrew
	name = REAGENT_SPACERSBREW
	id = REAGENT_ID_SPACERSBREW
	result = REAGENT_ID_SPACERSBREW
	required_reagents = list(REAGENT_ID_BROWNSTAR = 4, REAGENT_ID_ETHANOL = 1)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/binmanbliss
	name = REAGENT_BINMANBLISS
	id = REAGENT_ID_BINMANBLISS
	result = REAGENT_ID_BINMANBLISS
	required_reagents = list(REAGENT_ID_SAKE = 1, REAGENT_ID_TEQUILA = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/chrysanthemum
	name = REAGENT_CHRYSANTHEMUM
	id = REAGENT_ID_CHRYSANTHEMUM
	result = REAGENT_ID_CHRYSANTHEMUM
	required_reagents = list(REAGENT_ID_SAKE = 1, REAGENT_ID_MELONLIQUOR = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/deathbell
	name = REAGENT_DEATHBELL
	id = REAGENT_ID_DEATHBELL
	result = REAGENT_ID_DEATHBELL
	required_reagents = list(REAGENT_ID_ANTIFREEZE = 1, REAGENT_ID_GARGLEBLASTER = 1, REAGENT_ID_SYNDICATEBOMB =1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/bitters
	name = REAGENT_BITTERS
	id = REAGENT_ID_BITTERS
	result = REAGENT_ID_BITTERS
	required_reagents = list(REAGENT_ID_MINT = 5)
	catalysts = list(REAGENT_ID_ENZYME = 5)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/soemmerfire
	name = REAGENT_SOEMMERFIRE
	id = REAGENT_ID_SOEMMERFIRE
	result = REAGENT_ID_SOEMMERFIRE
	required_reagents = list(REAGENT_ID_MANHATTAN = 2, REAGENT_ID_CONDENSEDCAPSAICIN = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/winebrandy
	name = "Wine brandy"
	id = REAGENT_ID_WINEBRANDY
	result = REAGENT_ID_WINEBRANDY
	required_reagents = list(REAGENT_ID_REDWINE = 10)
	catalysts = list(REAGENT_ID_ENZYME = 10) //10u enzyme so it requires more than is usually added. Stops overlap with wine recipe
	result_amount = 5

/decl/chemical_reaction/instant/drinks/love_potion
	name = REAGENT_LOVEPOTION
	id = REAGENT_ID_LOVEPOTION
	result = REAGENT_ID_LOVEPOTION
	required_reagents = list(REAGENT_ID_CREAM = 1, REAGENT_ID_BERRYJUICE = 1, REAGENT_ID_SUGAR = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/morningafter
	name = REAGENT_MORNINGAFTER
	id = REAGENT_ID_MORNINGAFTER
	result = REAGENT_ID_MORNINGAFTER
	required_reagents = list(REAGENT_ID_SBITEN = 1, REAGENT_ID_COFFEE = 5)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/vesper
	name = REAGENT_VESPER
	id = REAGENT_ID_VESPER
	result = REAGENT_ID_VESPER
	required_reagents = list(REAGENT_ID_GIN = 3, REAGENT_ID_VODKA = 1, REAGENT_ID_REDWINE = 1)
	result_amount = 4

/decl/chemical_reaction/instant/drinks/rotgut
	name = REAGENT_ROTGUT
	id = REAGENT_ID_ROTGUT
	result = REAGENT_ID_ROTGUT
	required_reagents = list(REAGENT_ID_VODKA = 3, REAGENT_ID_RUM = 1, REAGENT_ID_WHISKEY = 1, REAGENT_ID_COLA = 3)
	result_amount = 8

/decl/chemical_reaction/instant/drinks/entdraught
	name = REAGENT_ENTDRAUGHT
	id = REAGENT_ID_ENTDRAUGHT
	result = REAGENT_ID_ENTDRAUGHT
	required_reagents = list(REAGENT_ID_TONIC = 1, REAGENT_ID_HOLYWATER = 1, REAGENT_ID_HONEY = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/voxdelight
	name = REAGENT_VOXDELIGHT
	id = REAGENT_ID_VOXDELIGHT
	result = REAGENT_ID_VOXDELIGHT
	required_reagents = list(REAGENT_ID_PHORON = 3, REAGENT_ID_FUEL = 1, REAGENT_ID_WATER = 1)
	result_amount = 4

/decl/chemical_reaction/instant/drinks/screamingviking
	name =REAGENT_SCREAMINGVIKING
	id = REAGENT_ID_SCREAMINGVIKING
	result = REAGENT_ID_SCREAMINGVIKING
	required_reagents = list(REAGENT_ID_MARTINI = 2, REAGENT_ID_VODKATONIC = 2, REAGENT_ID_LIMEJUICE = 1, REAGENT_ID_RUM = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/vilelemon
	name = REAGENT_VILELEMON
	id = REAGENT_ID_VILELEMON
	result = REAGENT_ID_VILELEMON
	required_reagents = list(REAGENT_ID_LEMONADE = 5, REAGENT_ID_SPACEMOUNTAINWIND = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/dreamcream
	name = REAGENT_DREAMCREAM
	id = REAGENT_ID_DREAMCREAM
	result = REAGENT_ID_DREAMCREAM
	required_reagents = list(REAGENT_ID_MILK = 2, REAGENT_ID_CREAM = 1, REAGENT_ID_HONEY = 1)
	result_amount = 4

/decl/chemical_reaction/instant/drinks/robustin
	name = REAGENT_ROBUSTIN
	id = REAGENT_ID_ROBUSTIN
	result = REAGENT_ID_ROBUSTIN
	required_reagents = list(REAGENT_ID_ANTIFREEZE = 1, REAGENT_ID_PHORON = 1, REAGENT_ID_FUEL = 1, REAGENT_ID_VODKA = 1)
	result_amount = 4

/decl/chemical_reaction/instant/drinks/virginsip
	name = REAGENT_VIRGINSIP
	id = REAGENT_ID_VIRGINSIP
	result = REAGENT_ID_VIRGINSIP
	required_reagents = list(REAGENT_ID_DRIESTMARTINI = 1, REAGENT_ID_WATER = 1)
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
	name = REAGENT_JELLYSHOT
	id = REAGENT_ID_JELLYSHOT
	result = REAGENT_ID_JELLYSHOT
	required_reagents = list(REAGENT_ID_CHERRYJELLY = 4, REAGENT_ID_VODKA = 1)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/slimeshot
	name = REAGENT_SLIMESHOT
	id = REAGENT_ID_SLIMESHOT
	result = REAGENT_ID_SLIMESHOT
	required_reagents = list(REAGENT_ID_SLIMEJELLY = 4, REAGENT_ID_VODKA = 1)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/negroni
	name = REAGENT_NEGRONI
	id = REAGENT_ID_NEGRONI
	result = REAGENT_ID_NEGRONI
	required_reagents = list(REAGENT_ID_GIN = 1, REAGENT_ID_BITTERS = 1, REAGENT_ID_VERMOUTH = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/cloverclub
	name = REAGENT_CLOVERCLUB
	id = REAGENT_ID_CLOVERCLUB
	result = REAGENT_ID_CLOVERCLUB
	required_reagents = list(REAGENT_ID_BERRYJUICE = 1, REAGENT_ID_LEMONJUICE = 1, REAGENT_ID_GIN = 3)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/oldfashioned
	name = REAGENT_OLDFASHIONED
	id = REAGENT_ID_OLDFASHIONED
	result = REAGENT_ID_OLDFASHIONED
	required_reagents = list(REAGENT_ID_WHISKEY = 3, REAGENT_ID_BITTERS = 1, REAGENT_ID_SUGAR = 1)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/whiskeysour
	name = REAGENT_WHISKEYSOUR
	id = REAGENT_ID_WHISKEYSOUR
	result = REAGENT_ID_WHISKEYSOUR
	required_reagents = list(REAGENT_ID_WHISKEY = 2, REAGENT_ID_LEMONJUICE = 1, REAGENT_ID_SUGAR = 1)
	result_amount = 4

/decl/chemical_reaction/instant/drinks/daiquiri
	name = REAGENT_DAIQUIRI
	id = REAGENT_ID_DAIQUIRI
	result = REAGENT_ID_DAIQUIRI
	required_reagents = list(REAGENT_ID_RUM = 3, REAGENT_ID_LIMEJUICE = 2, REAGENT_ID_SUGAR = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/mintjulep
	name = REAGENT_MINTJULEP
	id = REAGENT_ID_MINTJULEP
	result = REAGENT_ID_MINTJULEP
	required_reagents = list(REAGENT_ID_WHISKEY = 2, REAGENT_ID_WATER = 1, REAGENT_ID_MINT = 1)
	result_amount = 4

/decl/chemical_reaction/instant/drinks/paloma
	name = REAGENT_PALOMA
	id = REAGENT_ID_PALOMA
	result = REAGENT_ID_PALOMA
	required_reagents = list(REAGENT_ID_SODAWATER = 1, REAGENT_ID_TEQUILASUNRISE = 2)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/mojito
	name = REAGENT_MOJITO
	id = REAGENT_ID_MOJITO
	result = REAGENT_ID_MOJITO
	required_reagents = list(REAGENT_ID_RUM = 3, REAGENT_ID_LIMEJUICE = 1, REAGENT_ID_MINT = 1)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/virgin_mojito
	name = REAGENT_VIRGINMOJITO
	id = REAGENT_ID_VIRGINMOJITO
	result = REAGENT_ID_VIRGINMOJITO
	required_reagents = list(REAGENT_ID_SODAWATER = 3, REAGENT_ID_LIMEJUICE = 1, REAGENT_ID_MINT = 1, REAGENT_ID_SUGAR = 1)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/piscosour
	name = REAGENT_PISCOSOUR
	id = REAGENT_ID_PISCOSOUR
	result = REAGENT_ID_PISCOSOUR
	required_reagents = list(REAGENT_ID_WINEBRANDY = 1, REAGENT_ID_LEMONJUICE = 1, REAGENT_ID_SUGAR = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/coldfront
	name = REAGENT_COLDFRONT
	id = REAGENT_ID_COLDFRONT
	result = REAGENT_ID_COLDFRONT
	required_reagents = list(REAGENT_ID_ICECOFFEE = 1, REAGENT_ID_WHISKEY = 1, REAGENT_ID_MINT = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/godsake
	name = REAGENT_GODSAKE
	id = REAGENT_ID_GODSAKE
	result = REAGENT_ID_GODSAKE
	required_reagents = list(REAGENT_ID_SAKE = 2, REAGENT_ID_HOLYWATER = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/godka //Why you would put this in your body, I don't know.
	name = REAGENT_GODKA
	id = REAGENT_ID_GODKA
	result = REAGENT_ID_GODKA
	required_reagents = list(REAGENT_ID_VODKA = 1, REAGENT_ID_HOLYWATER = 1, REAGENT_ID_ETHANOL = 1, REAGENT_ID_CARTHATOLINE = 1)
	catalysts = list(REAGENT_ID_ENZYME = 5, REAGENT_ID_HOLYWATER = 5)
	result_amount = 1

/decl/chemical_reaction/instant/drinks/holywine
	name = REAGENT_HOLYWINE
	id = REAGENT_ID_HOLYWINE
	result = REAGENT_ID_HOLYWINE
	required_reagents = list(REAGENT_ID_GRAPEJUICE = 5, REAGENT_ID_GOLD = 5)
	catalysts = list(REAGENT_ID_HOLYWATER = 5)
	result_amount = 10

/decl/chemical_reaction/instant/drinks/holy_mary
	name = REAGENT_HOLYMARY
	id = REAGENT_ID_HOLYMARY
	result = REAGENT_ID_HOLYMARY
	required_reagents = list(REAGENT_ID_VODKA = 2, REAGENT_ID_HOLYWINE = 3, REAGENT_ID_LIMEJUICE = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/angelskiss
	name = REAGENT_ANGELSKISS
	id = REAGENT_ID_ANGELSKISS
	result = REAGENT_ID_ANGELSKISS
	required_reagents = list(REAGENT_ID_HOLYWINE = 1, REAGENT_ID_KAHLUA = 1, REAGENT_ID_RUM = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/angelswrath
	name = REAGENT_ANGELSWRATH
	id = REAGENT_ID_ANGELSWRATH
	result = REAGENT_ID_ANGELSWRATH
	required_reagents = list(REAGENT_ID_RUM = 3, REAGENT_ID_SPACEMOUNTAINWIND = 1, REAGENT_ID_HOLYWINE = 1, REAGENT_ID_DRGIBB = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/ichor_mead
	name = REAGENT_ICHORMEAD
	id = REAGENT_ID_ICHORMEAD
	result = REAGENT_ID_ICHORMEAD
	required_reagents = list(REAGENT_ID_HOLYWINE = 1, REAGENT_ID_MEAD = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/oilslick
	name = REAGENT_OILSLICK
	id = REAGENT_ID_OILSLICK
	result = REAGENT_ID_OILSLICK
	required_reagents = list(REAGENT_ID_COOKINGOIL = 2, REAGENT_ID_HONEY = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/slimeslam
	name = "Slick Slime Slammer"
	id = REAGENT_ID_SLIMESLAMMER
	result = REAGENT_ID_SLIMESLAMMER
	required_reagents = list(REAGENT_ID_COOKINGOIL = 2, REAGENT_ID_PEANUTBUTTER = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/virginsexonthebeach
	name = REAGENT_VIRGINSEXONTHEBEACH
	id = REAGENT_ID_VIRGINSEXONTHEBEACH
	result = REAGENT_ID_VIRGINSEXONTHEBEACH
	required_reagents = list(REAGENT_ID_ORANGEJUICE = 3, REAGENT_ID_GRENADINE = 2)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/sexonthebeach
	name = REAGENT_SEXONTHEBEACH
	id = REAGENT_ID_SEXONTHEBEACH
	result = REAGENT_ID_SEXONTHEBEACH
	required_reagents = list(REAGENT_ID_VIRGINSEXONTHEBEACH = 5, REAGENT_ID_VODKA = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/eggnog
	name = REAGENT_EGGNOG
	id = REAGENT_ID_EGGNOG
	result = REAGENT_ID_EGGNOG
	required_reagents = list(REAGENT_ID_MILK = 5, REAGENT_ID_CREAM = 5, REAGENT_ID_SUGAR = 5, REAGENT_ID_EGG = 3)
	result_amount = 15

/decl/chemical_reaction/instant/drinks/nuclearwaste_radium
	name = REAGENT_NUCLEARWASTE
	id = "nuclearwasterad"
	result = REAGENT_ID_NUCLEARWASTE
	required_reagents = list(REAGENT_ID_OILSLICK = 1, REAGENT_ID_RADIUM = 1, REAGENT_ID_LIMEJUICE = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/nuclearwaste_uranium
	name = REAGENT_NUCLEARWASTE
	id = "nuclearwasteuran"
	result = REAGENT_ID_NUCLEARWASTE
	required_reagents = list(REAGENT_ID_OILSLICK = 2, REAGENT_ID_URANIUM = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/sodaoil
	name = REAGENT_SODAOIL
	id = REAGENT_ID_SODAOIL
	result = REAGENT_ID_SODAOIL
	required_reagents = list(REAGENT_ID_COOKINGOIL = 4, REAGENT_ID_SODAWATER = 1, REAGENT_ID_CARBON = 1, REAGENT_ID_TRICORDRAZINE = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/fusionnaire
	name = REAGENT_FUSIONNAIRE
	id = REAGENT_ID_FUSIONNAIRE
	result = REAGENT_ID_FUSIONNAIRE
	required_reagents = list(REAGENT_ID_LEMONJUICE = 3, REAGENT_ID_VODKA = 2, REAGENT_ID_SCHNAPPSPEP = 1, REAGENT_ID_SCHNAPPSLEM = 1, REAGENT_ID_RUM = 1, REAGENT_ID_ICE = 1)
	result_amount = 9
