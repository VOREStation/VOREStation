///////////////////////////////////////////////////////////////////////////////////
/// Special drinks
/decl/chemical_reaction/instant/drinks/grubshake
	name = "Grub protein drink"
	id = REAGENT_ID_GRUBSHAKE
	result = REAGENT_ID_GRUBSHAKE
	required_reagents = list(REAGENT_ID_SHOCKCHEM = 5, REAGENT_ID_WATER = 25)
	result_amount = 30

/decl/chemical_reaction/instant/drinks/deathbell
	name = "Deathbell"
	id = "deathbell"
	result = "deathbell"
	required_reagents = list("antifreeze" = 1, "gargleblaster" = 1, "syndicatebomb" =1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/burnout
	name = REAGENT_BURNOUT
	id = REAGENT_ID_BURNOUT
	result = REAGENT_ID_BURNOUT
	required_reagents = list("antifreeze" = 1, "deathbell" = 1, REAGENT_ID_LOVEMAKER =1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/monstertamer
	name = REAGENT_MONSTERTAMER
	id = REAGENT_ID_MONSTERTAMER
	result = REAGENT_ID_MONSTERTAMER
	required_reagents = list("whiskey" = 1, "protein" = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/bigbeer
	name = REAGENT_BIGBEER
	id = REAGENT_ID_BIGBEER
	result = REAGENT_ID_BIGBEER
	required_reagents = list("syndicatebomb" = 1, "manlydorf" = 1, "grog" =1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/sweettea
	name = "Sweetened Tea"
	id = REAGENT_ID_SWEETTEA
	result = REAGENT_ID_SWEETTEA
	required_reagents = list("icetea" = 2, REAGENT_ID_SUGAR = 1,)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/unsweettea
	name = REAGENT_UNSWEETTEA
	id = REAGENT_ID_UNSWEETTEA
	result = REAGENT_ID_UNSWEETTEA
	required_reagents = list(REAGENT_ID_SWEETTEA = 3, REAGENT_ID_PHORON = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/galacticpanic
	name = REAGENT_GALACTICPANIC
	id = REAGENT_ID_GALACTICPANIC
	result = REAGENT_ID_GALACTICPANIC
	required_reagents = list("gargleblaster" = 1, "singulo" = 1, "phoronspecial" =1, "neurotoxin" = 1, "atomicbomb" = 1, "hippiesdelight" = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/bulldog
	name = REAGENT_BULLDOG
	id = REAGENT_ID_BULLDOG
	result = REAGENT_ID_BULLDOG
	required_reagents = list("whiterussian" = 4, "cola" =1)
	result_amount = 4

/decl/chemical_reaction/instant/drinks/sbagliato
	name = REAGENT_SBAGLIATO
	id = REAGENT_ID_SBAGLIATO
	result = REAGENT_ID_SBAGLIATO
	required_reagents = list("redwine" = 1, "vermouth" = 1, "sodawater" =1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/italiancrisis
	name = REAGENT_ITALIANCRISIS
	id = REAGENT_ID_ITALIANCRISIS
	result = REAGENT_ID_ITALIANCRISIS
	required_reagents = list(REAGENT_ID_BULLDOG = 1, REAGENT_ID_SBAGLIATO = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/sugarrush
	name = REAGENT_SUGARRUSH
	id = REAGENT_ID_SUGARRUSH
	result = REAGENT_ID_SUGARRUSH
	required_reagents = list(REAGENT_ID_SUGAR = 1, "sodawater" = 1, "vodka" =1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/lotus
	name = REAGENT_LOTUS
	id = REAGENT_ID_LOTUS
	result = REAGENT_ID_LOTUS
	required_reagents = list(REAGENT_ID_SBAGLIATO = 1, REAGENT_ID_SUGARRUSH = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/shroomjuice
	name = REAGENT_SHROOMJUICE
	id = REAGENT_ID_SHROOMJUICE
	result = REAGENT_ID_SHROOMJUICE
	required_reagents = list(REAGENT_ID_PSILOCYBIN = 1, "applejuice" = 1, "limejuice" =1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/russianroulette
	name = REAGENT_RUSSIANROULETTE
	id =REAGENT_ID_RUSSIANROULETTE
	result =REAGENT_ID_RUSSIANROULETTE
	required_reagents = list("whiterussian" = 5, REAGENT_ID_IRON = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/lovemaker
	name = REAGENT_LOVEMAKER
	id = REAGENT_ID_LOVEMAKER
	result = REAGENT_ID_LOVEMAKER
	required_reagents = list("honey" = 1, "sexonthebeach" = 5)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/honeyshot
	name = REAGENT_HONEYSHOT
	id = REAGENT_ID_HONEYSHOT
	result = REAGENT_ID_HONEYSHOT
	required_reagents = list("honey" = 1, "vodka" = 1, "grenadine" =1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/appletini
	name = REAGENT_APPLETINI
	id = REAGENT_ID_APPLETINIT
	result = REAGENT_ID_APPLETINIT
	required_reagents = list("applejuice" = 2, "vodka" = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/glowingappletini
	name = REAGENT_GLOWINGAPPLETINI
	id = REAGENT_ID_GLOWINGAPPLETINI
	result = REAGENT_ID_GLOWINGAPPLETINI
	required_reagents = list(REAGENT_ID_APPLETINIT = 5, "uranium" = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/scsatw
	name = REAGENT_SCSATW
	id = REAGENT_ID_SCSATW
	result = REAGENT_ID_SCSATW
	required_reagents = list("screwdrivercocktail" = 3, "rum" =1, "whiskey" =1, "gin" =1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/choccymilk
	name = REAGENT_CHOCCYMILK
	id = REAGENT_ID_CHOCCYMILK
	result = REAGENT_ID_CHOCCYMILK
	inhibitors = list("enzyme" = 1)
	required_reagents = list("milk" = 3, "coco" = 1)
	result_amount = 4

/decl/chemical_reaction/instant/drinks/redspaceflush
	name = "Redspace Flush"
	id = REAGENT_ID_REDSPACEFLUSH
	result = REAGENT_ID_REDSPACEFLUSH
	required_reagents = list("rum" = 2, "whiskey" = 2, REAGENT_ID_BLOOD =1, REAGENT_ID_PHORON =1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/graveyard
	name = REAGENT_GRAVEYARD
	id = REAGENT_ID_GRAVEYARD
	result = REAGENT_ID_GRAVEYARD
	required_reagents = list("cola" = 1, "spacemountainwind" = 1, "dr_gibb" =1, "space_up" = 1)
	result_amount = 4

/decl/chemical_reaction/instant/drinks/hairoftherat
	name = REAGENT_HAIROFTHERAT
	id = REAGENT_ID_HAIROFTHERAT
	result = REAGENT_ID_HAIROFTHERAT
	required_reagents = list(REAGENT_ID_MONSTERTAMER = 2, REAGENT_ID_NUTRIMENT = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/pink_russian
	name = REAGENT_PINKRUSSIAN
	id = REAGENT_ID_PINKRUSSIAN
	result = REAGENT_ID_PINKRUSSIAN
	required_reagents = list("blackrussian" = 2, "berryshake" = 1)
	result_amount = 3

/decl/chemical_reaction/instant/drinks/originalsin
	name = REAGENT_ORIGINALSIN
	id = REAGENT_ID_ORIGINALSIN
	result = REAGENT_ID_ORIGINALSIN
	required_reagents = list("holywine" = 1)
	catalysts = list("applejuice" = 1)
	result_amount = 1

/decl/chemical_reaction/instant/drinks/windgarita
	name = REAGENT_WINDGARITA
	id = REAGENT_ID_WINDGARITA
	result = REAGENT_ID_WINDGARITA
	required_reagents = list("margarita" = 3, "spacemountainwind" = 2, "melonliquor" = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/newyorksour
	name = REAGENT_NEWYORKSOUR
	id = REAGENT_ID_NEWYORKSOUR
	result = REAGENT_ID_NEWYORKSOUR
	required_reagents = list("whiskeysour" = 3, "redwine" = 2, "egg" = 1)
	result_amount = 6

/decl/chemical_reaction/instant/drinks/mudslide
	name = REAGENT_MUDSLIDE
	id = REAGENT_ID_MUDSLIDE
	result = REAGENT_ID_MUDSLIDE
	required_reagents = list("blackrussian" = 1, "irishcream" = 1)
	result_amount = 2

/decl/chemical_reaction/instant/drinks/protein_shake
	name = REAGENT_PROTEINSHAKE
	id = REAGENT_ID_PROTEINSHAKE
	result = REAGENT_ID_PROTEINSHAKE
	required_reagents = list(REAGENT_ID_WATER = 5, REAGENT_ID_PROTEINPOWDER = 1)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/protein_shake/vanilla
	name = REAGENT_VANILLAPROTEINSHAKE
	id = REAGENT_ID_VANILLAPROTEINSHAKER
	result = REAGENT_ID_VANILLAPROTEINSHAKER
	required_reagents = list(REAGENT_ID_WATER = 5, REAGENT_ID_VANILLAPROTEINPOWDER = 1)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/protein_shake/banana
	name = REAGENT_BANANAPROTEINSHAKE
	id = REAGENT_ID_BANANAPROTEINSHAKE
	result = REAGENT_ID_BANANAPROTEINSHAKE
	required_reagents = list(REAGENT_ID_WATER = 5, REAGENT_ID_BANANAPROTEINPOWDER = 1)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/protein_shake/chocolate
	name = REAGENT_CHOCOLATEPROTEINSHAKE
	id = REAGENT_ID_CHOCOLATEPROTEINSHAKE
	result = REAGENT_ID_CHOCOLATEPROTEINSHAKE
	required_reagents = list(REAGENT_ID_WATER = 5, REAGENT_CHOCOLATEPROTEINPOWDER = 1)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/protein_shake/strawberry
	name = REAGENT_STRAWBERRYPROTEINSHAKE
	id = REAGENT_ID_STRAWBERRYPROTEINSHAKE
	result = REAGENT_ID_STRAWBERRYPROTEINSHAKE
	required_reagents = list(REAGENT_ID_WATER = 5, REAGENT_ID_STRAWBERRYPROTEINPOWDER = 1)
	result_amount = 5

/decl/chemical_reaction/instant/drinks/manager_summoner
	name = REAGENT_MANAGERSUMMONER
	id = REAGENT_ID_MANAGERSUMMONER
	result = REAGENT_ID_MANAGERSUMMONER
	required_reagents = list("margarita" = 1, "redwine" = 1, "essential_oil" = 1)
	result_amount = 3
