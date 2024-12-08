// These reactions happen instantaneously, when added to a container that has all other necessary reagents
// They are a subtype of chemical_reaction so that such containers can iterate over only these reactions, and not have to skip other reaction types

/* Common reactions */

/decl/chemical_reaction/instant/inaprovaline
	name = REAGENT_INAPROVALINE
	id = REAGENT_ID_INAPROVALINE
	result = REAGENT_ID_INAPROVALINE
	required_reagents = list(REAGENT_ID_OXYGEN = 1, REAGENT_ID_CARBON = 1, REAGENT_ID_SUGAR = 1)
	result_amount = 3

/decl/chemical_reaction/instant/dylovene
	name = REAGENT_ANTITOXIN
	id = REAGENT_ID_ANTITOXIN
	result = REAGENT_ID_ANTITOXIN
	required_reagents = list(REAGENT_ID_SILICON = 1, REAGENT_ID_POTASSIUM = 1, REAGENT_ID_NITROGEN = 1)
	result_amount = 3

/decl/chemical_reaction/instant/carthatoline
	name = REAGENT_CARTHATOLINE
	id = REAGENT_ID_CARTHATOLINE
	result = REAGENT_ID_CARTHATOLINE
	required_reagents = list(REAGENT_ID_ANTITOXIN = 1, REAGENT_ID_CARBON = 2, REAGENT_ID_PHORON = 0.1)
	catalysts = list(REAGENT_ID_PHORON = 1)
	result_amount = 2

/decl/chemical_reaction/instant/paracetamol
	name = REAGENT_PARACETAMOL
	id = REAGENT_ID_PARACETAMOL
	result = REAGENT_ID_PARACETAMOL
	required_reagents = list(REAGENT_ID_INAPROVALINE = 1, REAGENT_ID_NITROGEN = 1, REAGENT_ID_WATER = 1)
	result_amount = 2

/decl/chemical_reaction/instant/tramadol
	name = REAGENT_TRAMADOL
	id = REAGENT_ID_TRAMADOL
	result = REAGENT_ID_TRAMADOL
	required_reagents = list(REAGENT_ID_PARACETAMOL = 1, REAGENT_ID_ETHANOL = 1, REAGENT_ID_OXYGEN = 1)
	result_amount = 3

/decl/chemical_reaction/instant/oxycodone
	name = REAGENT_OXYCODONE
	id = REAGENT_ID_OXYCODONE
	result = REAGENT_ID_OXYCODONE
	required_reagents = list(REAGENT_ID_ETHANOL = 1, REAGENT_ID_TRAMADOL = 1)
	catalysts = list(REAGENT_ID_PHORON = 5)
	result_amount = 1

/decl/chemical_reaction/instant/sterilizine
	name = REAGENT_STERILIZINE
	id = REAGENT_ID_STERILIZINE
	result = REAGENT_ID_STERILIZINE
	required_reagents = list(REAGENT_ID_ETHANOL = 1, REAGENT_ID_ANTITOXIN = 1, REAGENT_ID_CHLORINE = 1)
	result_amount = 3

/decl/chemical_reaction/instant/silicate
	name = REAGENT_SILICATE
	id = REAGENT_ID_SILICATE
	result = REAGENT_ID_SILICATE
	required_reagents = list(REAGENT_ID_ALUMINIUM = 1, REAGENT_ID_SILICON = 1, REAGENT_ID_OXYGEN = 1)
	result_amount = 3

/decl/chemical_reaction/instant/mutagen
	name = REAGENT_MUTAGEN
	id = REAGENT_ID_MUTAGEN
	result = REAGENT_ID_MUTAGEN
	required_reagents = list(REAGENT_ID_RADIUM = 1, REAGENT_ID_PHOSPHORUS = 1, REAGENT_ID_CHLORINE = 1)
	result_amount = 3

/decl/chemical_reaction/instant/water
	name = REAGENT_WATER
	id = REAGENT_ID_WATER
	result = REAGENT_ID_WATER
	required_reagents = list(REAGENT_ID_OXYGEN = 1, REAGENT_ID_HYDROGEN = 2)
	result_amount = 1

/decl/chemical_reaction/instant/thermite
	name = REAGENT_THERMITE
	id = REAGENT_ID_THERMITE
	result = REAGENT_ID_THERMITE
	required_reagents = list(REAGENT_ID_ALUMINIUM = 1, REAGENT_ID_IRON = 1, REAGENT_ID_OXYGEN = 1)
	result_amount = 3

/decl/chemical_reaction/instant/bliss
	name = REAGENT_BLISS
	id = REAGENT_ID_BLISS
	result = REAGENT_ID_BLISS
	required_reagents = list(REAGENT_ID_MERCURY = 1, REAGENT_ID_SUGAR = 1, REAGENT_ID_LITHIUM = 1)
	result_amount = 3

/decl/chemical_reaction/instant/lube
	name = REAGENT_LUBE
	id = REAGENT_ID_LUBE
	result = REAGENT_ID_LUBE
	required_reagents = list(REAGENT_ID_WATER = 1, REAGENT_ID_SILICON = 1, REAGENT_ID_OXYGEN = 1)
	result_amount = 4

/decl/chemical_reaction/instant/pacid
	name = REAGENT_PACID
	id = REAGENT_ID_PACID
	result = REAGENT_ID_PACID
	required_reagents = list(REAGENT_ID_SACID = 1, REAGENT_ID_CHLORINE = 1, REAGENT_ID_POTASSIUM = 1)
	result_amount = 3

/decl/chemical_reaction/instant/synaptizine
	name = REAGENT_SYNAPTIZINE
	id = REAGENT_ID_SYNAPTIZINE
	result = REAGENT_ID_SYNAPTIZINE
	required_reagents = list(REAGENT_ID_SUGAR = 1, REAGENT_ID_LITHIUM = 1, REAGENT_ID_WATER = 1)
	result_amount = 3

/decl/chemical_reaction/instant/hyronalin
	name = REAGENT_HYRONALIN
	id = REAGENT_ID_HYRONALIN
	result = REAGENT_ID_HYRONALIN
	required_reagents = list(REAGENT_ID_RADIUM = 1, REAGENT_ID_ANTITOXIN = 1)
	result_amount = 2

/decl/chemical_reaction/instant/arithrazine
	name = REAGENT_ARITHRAZINE
	id = REAGENT_ID_ARITHRAZINE
	result = REAGENT_ID_ARITHRAZINE
	required_reagents = list(REAGENT_ID_HYRONALIN = 1, REAGENT_ID_HYDROGEN = 1)
	result_amount = 2

/decl/chemical_reaction/instant/impedrezene
	name = REAGENT_IMPEDREZENE
	id = REAGENT_ID_IMPEDREZENE
	result = REAGENT_ID_IMPEDREZENE
	required_reagents = list(REAGENT_ID_MERCURY = 1, REAGENT_ID_OXYGEN = 1, REAGENT_ID_SUGAR = 1)
	result_amount = 2

/decl/chemical_reaction/instant/kelotane
	name = REAGENT_KELOTANE
	id = REAGENT_ID_KELOTANE
	result = REAGENT_ID_KELOTANE
	required_reagents = list(REAGENT_ID_SILICON = 1, REAGENT_ID_CARBON = 1)
	result_amount = 2
	log_is_important = 1

/decl/chemical_reaction/instant/peridaxon
	name = REAGENT_PERIDAXON
	id = REAGENT_ID_PERIDAXON
	result = REAGENT_ID_PERIDAXON
	required_reagents = list(REAGENT_ID_BICARIDINE = 2, REAGENT_ID_CLONEXADONE = 2)
	catalysts = list(REAGENT_ID_PHORON = 5)
	result_amount = 2

/decl/chemical_reaction/instant/osteodaxon
	name = REAGENT_OSTEODAXON
	id = REAGENT_ID_OSTEODAXON
	result = REAGENT_ID_OSTEODAXON
	required_reagents = list(REAGENT_ID_BICARIDINE = 2, REAGENT_ID_PHORON = 0.1, REAGENT_ID_CARPOTOXIN = 1)
	catalysts = list(REAGENT_ID_PHORON = 5)
	inhibitors = list(REAGENT_ID_CLONEXADONE = 1) // Messes with cryox
	result_amount = 2

/decl/chemical_reaction/instant/respirodaxon
	name = REAGENT_RESPIRODAXON
	id = REAGENT_ID_HYRONALIN
	result = REAGENT_ID_HYRONALIN
	required_reagents = list(REAGENT_ID_DEXALINP = 2, REAGENT_ID_BIOMASS = 2, REAGENT_ID_PHORON = 1)
	catalysts = list(REAGENT_ID_PHORON = 5)
	inhibitors = list(REAGENT_ID_DEXALIN = 1)
	result_amount = 2

/decl/chemical_reaction/instant/gastirodaxon
	name = REAGENT_GASTIRODAXON
	id = REAGENT_ID_GASTIRODAXON
	result = REAGENT_ID_GASTIRODAXON
	required_reagents = list(REAGENT_ID_CARTHATOLINE = 1, REAGENT_ID_BIOMASS = 2, REAGENT_ID_TUNGSTEN = 2)
	catalysts = list(REAGENT_ID_PHORON = 5)
	inhibitors = list(REAGENT_ID_LITHIUM = 1)
	result_amount = 3

/decl/chemical_reaction/instant/hepanephrodaxon
	name = REAGENT_HEPANEPHRODAXON
	id = REAGENT_ID_HEPANEPHRODAXON
	result = REAGENT_ID_HEPANEPHRODAXON
	required_reagents = list(REAGENT_ID_CARTHATOLINE = 2, REAGENT_ID_BIOMASS = 2, REAGENT_ID_LITHIUM = 1)
	catalysts = list(REAGENT_ID_PHORON = 5)
	inhibitors = list(REAGENT_ID_TUNGSTEN = 1)
	result_amount = 2

/decl/chemical_reaction/instant/cordradaxon
	name = REAGENT_CORDRADAXON
	id = REAGENT_ID_CORDRADAXON
	result = REAGENT_ID_CORDRADAXON
	required_reagents = list(REAGENT_ID_POTASSIUMCHLOROPHORIDE = 1, REAGENT_ID_BIOMASS = 2, REAGENT_ID_BICARIDINE = 2)
	catalysts = list(REAGENT_ID_PHORON = 5)
	inhibitors = list(REAGENT_ID_CLONEXADONE = 1)
	result_amount = 2

/decl/chemical_reaction/instant/virus_food
	name = REAGENT_VIRUSFOOD
	id = REAGENT_ID_VIRUSFOOD
	result = REAGENT_ID_VIRUSFOOD
	required_reagents = list(REAGENT_ID_WATER = 1, REAGENT_ID_MILK = 1)
	result_amount = 5

/decl/chemical_reaction/instant/leporazine
	name = REAGENT_LEPORAZINE
	id = REAGENT_ID_LEPORAZINE
	result = REAGENT_ID_LEPORAZINE
	required_reagents = list(REAGENT_ID_SILICON = 1, REAGENT_ID_COPPER = 1)
	catalysts = list(REAGENT_ID_PHORON = 5)
	result_amount = 2

/decl/chemical_reaction/instant/cryptobiolin
	name = REAGENT_CRYPTOBIOLIN
	id = REAGENT_ID_CRYPTOBIOLIN
	result = REAGENT_ID_CRYPTOBIOLIN
	required_reagents = list(REAGENT_ID_POTASSIUM = 1, REAGENT_ID_OXYGEN = 1, REAGENT_ID_SUGAR = 1)
	result_amount = 3

/decl/chemical_reaction/instant/tricordrazine
	name = REAGENT_TRICORDRAZINE
	id = REAGENT_ID_TRICORDRAZINE
	result = REAGENT_ID_TRICORDRAZINE
	required_reagents = list(REAGENT_ID_INAPROVALINE = 1, REAGENT_ID_ANTITOXIN = 1)
	result_amount = 2

/decl/chemical_reaction/instant/alkysine
	name = REAGENT_ALKYSINE
	id = REAGENT_ID_ALKYSINE
	result = REAGENT_ID_ALKYSINE
	required_reagents = list(REAGENT_ID_CHLORINE = 1, REAGENT_ID_NITROGEN = 1, REAGENT_ID_ANTITOXIN = 1)
	result_amount = 2

/decl/chemical_reaction/instant/dexalin
	name = REAGENT_DEXALIN
	id = REAGENT_ID_DEXALIN
	result = REAGENT_ID_DEXALIN
	required_reagents = list(REAGENT_ID_OXYGEN = 2, REAGENT_ID_PHORON = 0.1)
	catalysts = list(REAGENT_ID_PHORON = 1)
	inhibitors = list(REAGENT_ID_WATER = 1) // Messes with cryox
	result_amount = 1

/decl/chemical_reaction/instant/dermaline
	name = REAGENT_DERMALINE
	id = REAGENT_ID_DERMALINE
	result = REAGENT_ID_DERMALINE
	required_reagents = list(REAGENT_ID_OXYGEN = 1, REAGENT_ID_PHOSPHORUS = 1, REAGENT_ID_KELOTANE = 1)
	result_amount = 3

/decl/chemical_reaction/instant/dexalinp
	name = REAGENT_DEXALINP
	id = REAGENT_ID_DEXALINP
	result = REAGENT_ID_DEXALINP
	required_reagents = list(REAGENT_ID_DEXALIN = 1, REAGENT_ID_CARBON = 1, REAGENT_ID_IRON = 1)
	result_amount = 3

/decl/chemical_reaction/instant/bicaridine
	name = REAGENT_BICARIDINE
	id = REAGENT_ID_BICARIDINE
	result = REAGENT_ID_BICARIDINE
	required_reagents = list(REAGENT_ID_INAPROVALINE = 1, REAGENT_ID_CARBON = 1)
	inhibitors = list(REAGENT_ID_SUGAR = 1) // Messes up with inaprovaline
	result_amount = 2

/decl/chemical_reaction/instant/myelamine
	name = REAGENT_MYELAMINE
	id = REAGENT_ID_MYELAMINE
	result = REAGENT_ID_MYELAMINE
	required_reagents = list(REAGENT_ID_BICARIDINE = 1, REAGENT_ID_IRON = 2, REAGENT_ID_SPIDERTOXIN = 1)
	result_amount = 2

/decl/chemical_reaction/instant/hyperzine
	name = REAGENT_HYPERZINE
	id = REAGENT_ID_HYPERZINE
	result = REAGENT_ID_HYPERZINE
	required_reagents = list(REAGENT_ID_SUGAR = 1, REAGENT_ID_PHOSPHORUS = 1, REAGENT_ID_SULFUR = 1)
	result_amount = 3

/decl/chemical_reaction/instant/stimm
	name = REAGENT_STIMM
	id = REAGENT_ID_STIMM
	result = REAGENT_ID_STIMM
	required_reagents = list(REAGENT_ID_LEFT4ZED = 1, REAGENT_ID_FUEL = 1)
	catalysts = list(REAGENT_ID_FUEL = 5)
	result_amount = 2

/decl/chemical_reaction/instant/ryetalyn
	name = REAGENT_RYETALYN
	id = REAGENT_ID_RYETALYN
	result = REAGENT_ID_RYETALYN
	required_reagents = list(REAGENT_ID_ARITHRAZINE = 1, REAGENT_ID_CARBON = 1)
	result_amount = 2

/decl/chemical_reaction/instant/cryoxadone
	name = REAGENT_CRYOXADONE
	id = REAGENT_ID_CRYOXADONE
	result = REAGENT_ID_CRYOXADONE
	required_reagents = list(REAGENT_ID_DEXALIN = 1, REAGENT_ID_WATER = 1, REAGENT_ID_OXYGEN = 1)
	result_amount = 3

/decl/chemical_reaction/instant/clonexadone
	name = REAGENT_CLONEXADONE
	id = REAGENT_ID_CLONEXADONE
	result = REAGENT_ID_CLONEXADONE
	required_reagents = list(REAGENT_ID_CRYOXADONE = 1, REAGENT_ID_SODIUM = 1, REAGENT_ID_PHORON = 0.1)
	catalysts = list(REAGENT_ID_PHORON = 5)
	result_amount = 2

/decl/chemical_reaction/instant/mortiferin
	name = REAGENT_MORTIFERIN
	id = REAGENT_ID_MORTIFERIN
	result = REAGENT_ID_MORTIFERIN
	required_reagents = list(REAGENT_ID_CRYPTOBIOLIN = 1, REAGENT_ID_CLONEXADONE = 1, REAGENT_ID_COROPHIZINE = 1)
	result_amount = 2
	catalysts = list(REAGENT_ID_PHORON = 5)

/decl/chemical_reaction/instant/spaceacillin
	name = REAGENT_SPACEACILLIN
	id = REAGENT_ID_SPACEACILLIN
	result = REAGENT_ID_SPACEACILLIN
	required_reagents = list(REAGENT_ID_CRYPTOBIOLIN = 1, REAGENT_ID_INAPROVALINE = 1)
	result_amount = 2

/decl/chemical_reaction/instant/corophizine
	name = REAGENT_COROPHIZINE
	id = REAGENT_ID_COROPHIZINE
	result = REAGENT_ID_COROPHIZINE
	required_reagents = list(REAGENT_ID_SPACEACILLIN = 1, REAGENT_ID_CARBON = 1, REAGENT_ID_PHORON = 0.1)
	catalysts = list(REAGENT_ID_PHORON = 5)
	result_amount = 2

/decl/chemical_reaction/instant/immunosuprizine
	name = REAGENT_IMMUNOSUPRIZINE
	id = REAGENT_ID_IMMUNOSUPRIZINE
	result = REAGENT_ID_IMMUNOSUPRIZINE
	required_reagents = list(REAGENT_ID_COROPHIZINE = 1, REAGENT_ID_TUNGSTEN = 1, REAGENT_ID_SACID = 1)
	catalysts = list(REAGENT_ID_PHORON = 5)
	result_amount = 2

/decl/chemical_reaction/instant/imidazoline
	name = REAGENT_ID_IMIDAZOLINE
	id = REAGENT_ID_IMIDAZOLINE
	result = REAGENT_ID_IMIDAZOLINE
	required_reagents = list(REAGENT_ID_CARBON = 1, REAGENT_ID_HYDROGEN = 1, REAGENT_ID_ANTITOXIN = 1)
	result_amount = 2

/decl/chemical_reaction/instant/ethylredoxrazine
	name = REAGENT_ETHYLREDOXRAZINE
	id = REAGENT_ID_ETHYLREDOXRAZINE
	result = REAGENT_ID_ETHYLREDOXRAZINE
	required_reagents = list(REAGENT_ID_OXYGEN = 1, REAGENT_ID_ANTITOXIN = 1, REAGENT_ID_CARBON = 1)
	result_amount = 3

/decl/chemical_reaction/instant/calciumcarbonate
	name = "Calcium Carbonate"
	id = REAGENT_ID_CALCIUMCARBONATE
	result = REAGENT_ID_CALCIUMCARBONATE
	required_reagents = list(REAGENT_ID_OXYGEN = 3, REAGENT_ID_CALCIUM = 1, REAGENT_ID_CARBON = 1)
	result_amount = 2

/decl/chemical_reaction/instant/soporific
	name = REAGENT_STOXIN
	id = REAGENT_ID_STOXIN
	result = REAGENT_ID_STOXIN
	required_reagents = list(REAGENT_ID_CHLORALHYDRATE = 1, REAGENT_ID_SUGAR = 4)
	inhibitors = list(REAGENT_ID_PHOSPHORUS) // Messes with the smoke
	result_amount = 5

/decl/chemical_reaction/instant/chloralhydrate
	name = REAGENT_CHLORALHYDRATE
	id = REAGENT_ID_CHLORALHYDRATE
	result = REAGENT_ID_CHLORALHYDRATE
	required_reagents = list(REAGENT_ID_ETHANOL = 1, REAGENT_ID_CHLORINE = 3, REAGENT_ID_WATER = 1)
	result_amount = 1

/decl/chemical_reaction/instant/potassium_chloride
	name = REAGENT_POTASSIUMCHLORIDE
	id = REAGENT_ID_POTASSIUMCHLORIDE
	result = REAGENT_ID_POTASSIUMCHLORIDE
	required_reagents = list(REAGENT_ID_SODIUMCHLORIDE = 1, REAGENT_ID_POTASSIUM = 1)
	result_amount = 2

/decl/chemical_reaction/instant/potassium_chlorophoride
	name = REAGENT_POTASSIUMCHLOROPHORIDE
	id = REAGENT_ID_POTASSIUMCHLOROPHORIDE
	result = REAGENT_ID_POTASSIUMCHLOROPHORIDE
	required_reagents = list(REAGENT_ID_POTASSIUMCHLORIDE = 1, REAGENT_ID_PHORON = 1, REAGENT_ID_CHLORALHYDRATE = 1)
	result_amount = 4

/decl/chemical_reaction/instant/zombiepowder
	name = REAGENT_ZOMBIEPOWDER
	id = REAGENT_ID_ZOMBIEPOWDER
	result = REAGENT_ID_ZOMBIEPOWDER
	required_reagents = list(REAGENT_ID_CARPOTOXIN = 5, REAGENT_ID_STOXIN = 5, REAGENT_ID_COPPER = 5)
	result_amount = 2

/decl/chemical_reaction/instant/carpotoxin
	name = REAGENT_CARPOTOXIN
	id = REAGENT_ID_CARPOTOXIN
	result = REAGENT_ID_CARPOTOXIN
	required_reagents = list(REAGENT_ID_SPIDERTOXIN = 2, REAGENT_ID_BIOMASS = 1, REAGENT_ID_SIFSAP = 2)
	catalysts = list(REAGENT_ID_SIFSAP = 10)
	inhibitors = list(REAGENT_ID_RADIUM = 1)
	result_amount = 2

/decl/chemical_reaction/instant/mindbreaker
	name = REAGENT_MINDBREAKER
	id = REAGENT_ID_MINDBREAKER
	result = REAGENT_ID_MINDBREAKER
	required_reagents = list(REAGENT_ID_SILICON = 1, REAGENT_ID_HYDROGEN = 1, REAGENT_ID_ANTITOXIN = 1)
	result_amount = 3

/decl/chemical_reaction/instant/lipozine
	name = REAGENT_LIPOZINE
	id = REAGENT_ID_LIPOZINE
	result = REAGENT_ID_LIPOZINE
	required_reagents = list(REAGENT_ID_SODIUMCHLORIDE = 1, REAGENT_ID_ETHANOL = 1, REAGENT_ID_RADIUM = 1)
	result_amount = 3

/decl/chemical_reaction/instant/surfactant
	name = "Foam surfactant"
	id = "foam surfactant"
	result = REAGENT_ID_FLUOROSURFACTANT
	required_reagents = list(REAGENT_ID_FLUORINE = 2, REAGENT_ID_CARBON = 2, REAGENT_ID_SACID = 1)
	result_amount = 5

/decl/chemical_reaction/instant/ammonia
	name = REAGENT_AMMONIA
	id = REAGENT_ID_AMMONIA
	result = REAGENT_ID_AMMONIA
	required_reagents = list(REAGENT_ID_HYDROGEN = 3, REAGENT_ID_NITROGEN = 1)
	inhibitors = list(REAGENT_ID_PHORON = 1) // Messes with lexorin
	result_amount = 3

/decl/chemical_reaction/instant/diethylamine
	name = REAGENT_DIETHYLAMINE
	id = REAGENT_ID_DIETHYLAMINE
	result = REAGENT_ID_DIETHYLAMINE
	required_reagents = list (REAGENT_ID_AMMONIA = 1, REAGENT_ID_ETHANOL = 1)
	result_amount = 2

/decl/chemical_reaction/instant/left4zed
	name = "Left4Zed"
	id = REAGENT_ID_LEFT4ZED
	result = REAGENT_ID_LEFT4ZED
	required_reagents = list (REAGENT_ID_DIETHYLAMINE = 2, REAGENT_ID_MUTAGEN = 1)
	result_amount = 3

/decl/chemical_reaction/instant/robustharvest
	name = "RobustHarvest"
	id = REAGENT_ID_ROBUSTHARVEST
	result = REAGENT_ID_ROBUSTHARVEST
	required_reagents = list (REAGENT_ID_AMMONIA = 1, REAGENT_ID_CALCIUM = 1, REAGENT_ID_NEUROTOXIC_PROTEIN = 1)
	result_amount = 3

/decl/chemical_reaction/instant/space_cleaner
	name = REAGENT_CLEANER
	id = REAGENT_ID_CLEANER
	result = REAGENT_ID_CLEANER
	required_reagents = list(REAGENT_ID_AMMONIA = 1, REAGENT_ID_WATER = 1)
	result_amount = 2

/decl/chemical_reaction/instant/plantbgone
	name = REAGENT_PLANTBGONE
	id = REAGENT_ID_PLANTBGONE
	result = REAGENT_ID_PLANTBGONE
	required_reagents = list(REAGENT_ID_TOXIN = 1, REAGENT_ID_WATER = 4)
	result_amount = 5

/decl/chemical_reaction/instant/foaming_agent
	name = "Foaming Agent"
	id = REAGENT_ID_FOAMINGAGENT
	result = REAGENT_ID_FOAMINGAGENT
	required_reagents = list(REAGENT_ID_LITHIUM = 1, REAGENT_ID_HYDROGEN = 1)
	result_amount = 1

/decl/chemical_reaction/instant/glycerol
	name = REAGENT_GLYCEROL
	id = REAGENT_ID_GLYCEROL
	result = REAGENT_ID_GLYCEROL
	required_reagents = list(REAGENT_ID_CORNOIL = 3, REAGENT_ID_SACID = 1)
	result_amount = 1

/decl/chemical_reaction/instant/sodiumchloride
	name = "Sodium Chloride"
	id = REAGENT_ID_SODIUMCHLORIDE
	result = REAGENT_ID_SODIUMCHLORIDE
	required_reagents = list(REAGENT_ID_SODIUM = 1, REAGENT_ID_CHLORINE = 1)
	result_amount = 2

/decl/chemical_reaction/instant/condensedcapsaicin
	name = REAGENT_CONDENSEDCAPSAICIN
	id = REAGENT_ID_CONDENSEDCAPSAICIN
	result = REAGENT_ID_CONDENSEDCAPSAICIN
	required_reagents = list(REAGENT_ID_CAPSAICIN = 2)
	catalysts = list(REAGENT_ID_PHORON = 5)
	result_amount = 1

/decl/chemical_reaction/instant/coolant
	name = REAGENT_COOLANT
	id = REAGENT_ID_COOLANT
	result = REAGENT_ID_COOLANT
	required_reagents = list(REAGENT_ID_TUNGSTEN = 1, REAGENT_ID_OXYGEN = 1, REAGENT_ID_WATER = 1)
	result_amount = 3
	log_is_important = 1

/decl/chemical_reaction/instant/rezadone
	name = REAGENT_REZADONE
	id = REAGENT_ID_REZADONE
	result = REAGENT_ID_REZADONE
	required_reagents = list(REAGENT_ID_CARPOTOXIN = 1, REAGENT_ID_CRYPTOBIOLIN = 1, REAGENT_ID_COPPER = 1)
	result_amount = 3

/decl/chemical_reaction/instant/lexorin
	name = REAGENT_LEXORIN
	id = REAGENT_ID_LEXORIN
	result = REAGENT_ID_LEXORIN
	required_reagents = list(REAGENT_ID_PHORON = 1, REAGENT_ID_HYDROGEN = 1, REAGENT_ID_NITROGEN = 1)
	result_amount = 3

/decl/chemical_reaction/instant/methylphenidate
	name = REAGENT_METHYLPHENIDATE
	id = REAGENT_ID_METHYLPHENIDATE
	result = REAGENT_ID_METHYLPHENIDATE
	required_reagents = list(REAGENT_ID_MINDBREAKER = 1, REAGENT_ID_HYDROGEN = 1)
	result_amount = 3

/decl/chemical_reaction/instant/citalopram
	name = REAGENT_CITALOPRAM
	id = REAGENT_ID_CITALOPRAM
	result = REAGENT_ID_CITALOPRAM
	required_reagents = list(REAGENT_ID_MINDBREAKER = 1, REAGENT_ID_CARBON = 1)
	result_amount = 3

/decl/chemical_reaction/instant/paroxetine
	name = REAGENT_PAROXETINE
	id = REAGENT_ID_PAROXETINE
	result = REAGENT_ID_PAROXETINE
	required_reagents = list(REAGENT_ID_MINDBREAKER = 1, REAGENT_ID_OXYGEN = 1, REAGENT_ID_INAPROVALINE = 1)
	result_amount = 3

/decl/chemical_reaction/instant/neurotoxin
	name = REAGENT_NEUROTOXIN
	id = REAGENT_ID_NEUROTOXIN
	result = REAGENT_ID_NEUROTOXIN
	required_reagents = list(REAGENT_ID_GARGLEBLASTER = 1, REAGENT_ID_STOXIN = 1)
	result_amount = 2

/decl/chemical_reaction/instant/luminol
	name = REAGENT_LUMINOL
	id = REAGENT_ID_LUMINOL
	result = REAGENT_ID_LUMINOL
	required_reagents = list(REAGENT_ID_HYDROGEN = 2, REAGENT_ID_CARBON = 2, REAGENT_ID_AMMONIA = 2)
	result_amount = 6

/* Solidification */

/decl/chemical_reaction/instant/solidification
	name = "Solid Iron"
	id = "solidiron"
	result = null
	required_reagents = list(REAGENT_ID_FROSTOIL = 5, REAGENT_ID_IRON = REAGENTS_PER_SHEET)
	result_amount = 1
	var/sheet_to_give = /obj/item/stack/material/iron

/decl/chemical_reaction/instant/solidification/on_reaction(var/datum/reagents/holder, var/created_volume)
	new sheet_to_give(get_turf(holder.my_atom), created_volume)
	return


/decl/chemical_reaction/instant/solidification/phoron
	name = "Solid Phoron"
	id = "solidphoron"
	required_reagents = list(REAGENT_ID_FROSTOIL = 5, REAGENT_ID_PHORON = REAGENTS_PER_SHEET)
	sheet_to_give = /obj/item/stack/material/phoron


/decl/chemical_reaction/instant/solidification/silver
	name = "Solid Silver"
	id = "solidsilver"
	required_reagents = list(REAGENT_ID_FROSTOIL = 5, REAGENT_ID_SILVER = REAGENTS_PER_SHEET)
	sheet_to_give = /obj/item/stack/material/silver


/decl/chemical_reaction/instant/solidification/gold
	name = "Solid Gold"
	id = "solidgold"
	required_reagents = list(REAGENT_ID_FROSTOIL = 5, REAGENT_ID_GOLD = REAGENTS_PER_SHEET)
	sheet_to_give = /obj/item/stack/material/gold


/decl/chemical_reaction/instant/solidification/platinum
	name = "Solid Platinum"
	id = "solidplatinum"
	required_reagents = list(REAGENT_ID_FROSTOIL = 5, REAGENT_ID_PLATINUM = REAGENTS_PER_SHEET)
	sheet_to_give = /obj/item/stack/material/platinum


/decl/chemical_reaction/instant/solidification/uranium
	name = "Solid Uranium"
	id = "soliduranium"
	required_reagents = list(REAGENT_ID_FROSTOIL = 5, REAGENT_ID_URANIUM = REAGENTS_PER_SHEET)
	sheet_to_give = /obj/item/stack/material/uranium


/decl/chemical_reaction/instant/solidification/hydrogen
	name = "Solid Hydrogen"
	id = "solidhydrogen"
	required_reagents = list(REAGENT_ID_FROSTOIL = 100, REAGENT_ID_HYDROGEN = REAGENTS_PER_SHEET)
	sheet_to_give = /obj/item/stack/material/mhydrogen


// These are from Xenobio.
/decl/chemical_reaction/instant/solidification/steel
	name = "Solid Steel"
	id = "solidsteel"
	required_reagents = list(REAGENT_ID_FROSTOIL = 5, "steel" = REAGENTS_PER_SHEET)
	sheet_to_give = /obj/item/stack/material/steel


/decl/chemical_reaction/instant/solidification/plasteel
	name = "Solid Plasteel"
	id = "solidplasteel"
	required_reagents = list(REAGENT_ID_FROSTOIL = 10, "plasteel" = REAGENTS_PER_SHEET)
	sheet_to_give = /obj/item/stack/material/plasteel


/decl/chemical_reaction/instant/plastication
	name = "Plastic"
	id = "solidplastic"
	result = null
	required_reagents = list(REAGENT_ID_PACID = 1, REAGENT_ID_PLASTICIDE = 2)
	result_amount = 1

/decl/chemical_reaction/instant/plastication/on_reaction(var/datum/reagents/holder, var/created_volume)
	new /obj/item/stack/material/plastic(get_turf(holder.my_atom), created_volume)
	return

/*Carpet Creation*/

/decl/chemical_reaction/instant/carpetify
	name = "Carpet"
	id = "redcarpet"
	result = null
	required_reagents = list(REAGENT_ID_LIQUIDCARPET = 2, REAGENT_ID_PLASTICIDE = 1)
	result_amount = 2
	var/carpet_type = /obj/item/stack/tile/carpet

/decl/chemical_reaction/instant/carpetify/on_reaction(var/datum/reagents/holder, var/created_volume)
	new carpet_type(get_turf(holder.my_atom), created_volume)
	return

/decl/chemical_reaction/instant/carpetify/bcarpet
	name = "Black Carpet"
	id = "blackcarpet"
	required_reagents = list(REAGENT_ID_LIQUIDCARPETB = 2, REAGENT_ID_PLASTICIDE = 1)
	carpet_type = /obj/item/stack/tile/carpet/bcarpet

/decl/chemical_reaction/instant/carpetify/blucarpet
	name = "Blue Carpet"
	id = "bluecarpet"
	required_reagents = list (REAGENT_ID_LIQUIDCARPETBLU = 2, REAGENT_ID_PLASTICIDE = 1)
	carpet_type = /obj/item/stack/tile/carpet/blucarpet

/decl/chemical_reaction/instant/carpetify/turcarpet
	name = "Turquise Carpet"
	id = "turcarpet"
	required_reagents = list(REAGENT_ID_LIQUIDCARPETTUR = 2, REAGENT_ID_PLASTICIDE = 1)
	carpet_type = /obj/item/stack/tile/carpet/turcarpet

/decl/chemical_reaction/instant/carpetify/sblucarpet
	name = "Silver Blue Carpet"
	id = "sblucarpet"
	required_reagents = list(REAGENT_ID_LIQUIDCARPETSBLU = 2, REAGENT_ID_PLASTICIDE = 1)
	carpet_type = /obj/item/stack/tile/carpet/sblucarpet

/decl/chemical_reaction/instant/carpetify/clowncarpet
	name = "Clown Carpet"
	id = "clowncarpet"
	required_reagents = list(REAGENT_ID_LIQUIDCARPETC = 2, REAGENT_ID_PLASTICIDE = 1)
	carpet_type = /obj/item/stack/tile/carpet/gaycarpet

/decl/chemical_reaction/instant/carpetify/pcarpet
	name = "Purple Carpet"
	id = "Purplecarpet"
	required_reagents = list(REAGENT_ID_LIQUIDCARPETP = 2, REAGENT_ID_PLASTICIDE = 1)
	carpet_type = /obj/item/stack/tile/carpet/purcarpet

/decl/chemical_reaction/instant/carpetify/ocarpet
	name = "Orange Carpet"
	id = "orangecarpet"
	required_reagents = list(REAGENT_ID_LIQUIDCARPETO = 2, REAGENT_ID_PLASTICIDE = 1)
	carpet_type = /obj/item/stack/tile/carpet/oracarpet

/decl/chemical_reaction/instant/concrete
	name = "Concrete"
	id = "concretereagent"
	required_reagents = list(REAGENT_ID_CALCIUM = 2, REAGENT_ID_SILICATE = 2, REAGENT_ID_WATER = 2)
	result_amount = 1

/decl/chemical_reaction/instant/concrete/on_reaction(var/datum/reagents/holder, var/created_volume)
	new /obj/item/stack/material/concrete(get_turf(holder.my_atom), created_volume)
	return

/* Grenade reactions */

/decl/chemical_reaction/instant/explosion_potassium
	name = "Explosion"
	id = "explosion_potassium"
	result = null
	required_reagents = list(REAGENT_ID_WATER = 1, REAGENT_ID_POTASSIUM = 1)
	result_amount = 2
	mix_message = null

/decl/chemical_reaction/instant/explosion_potassium/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/datum/effect/effect/system/reagents_explosion/e = new()
	e.set_up(round (created_volume/10, 1), holder.my_atom, 0, 0)
	if(isliving(holder.my_atom))
		e.amount *= 0.5
		var/mob/living/L = holder.my_atom
		if(L.stat != DEAD)
			e.amount *= 0.5
	//VOREStation Add Start
	else
		holder.clear_reagents() //No more powergaming by creating a tiny amount of this
	//VORESTation Add End
	e.start()
	//holder.clear_reagents() //VOREStation Removal
	return

/decl/chemical_reaction/instant/flash_powder
	name = "Flash powder"
	id = "flash_powder"
	result = null
	required_reagents = list(REAGENT_ID_ALUMINIUM = 1, REAGENT_ID_POTASSIUM = 1, REAGENT_ID_SULFUR = 1 )
	result_amount = null

/decl/chemical_reaction/instant/flash_powder/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(2, 1, location)
	s.start()
	for(var/mob/living/carbon/M in viewers(world.view, location))
		switch(get_dist(M, location))
			if(0 to 3)
				if(hasvar(M, "glasses"))
					if(istype(M:glasses, /obj/item/clothing/glasses/sunglasses))
						continue

				M.flash_eyes()
				M.Weaken(15)

			if(4 to 5)
				if(hasvar(M, "glasses"))
					if(istype(M:glasses, /obj/item/clothing/glasses/sunglasses))
						continue

				M.flash_eyes()
				M.Stun(5)

/decl/chemical_reaction/instant/emp_pulse
	name = "EMP Pulse"
	id = "emp_pulse"
	result = null
	required_reagents = list(REAGENT_ID_URANIUM = 1, REAGENT_ID_IRON = 1) // Yes, laugh, it's the best recipe I could think of that makes a little bit of sense
	result_amount = 2

/decl/chemical_reaction/instant/emp_pulse/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	// 100 created volume = 4 heavy range & 7 light range. A few tiles smaller than traitor EMP grandes.
	// 200 created volume = 8 heavy range & 14 light range. 4 tiles larger than traitor EMP grenades.
	empulse(location, round(created_volume / 24), round(created_volume / 20), round(created_volume / 18), round(created_volume / 14), 1)
	//VOREStation Edit Start
	if(!isliving(holder.my_atom)) //No more powergaming by creating a tiny amount of this
		holder.clear_reagents()
	//VOREStation Edit End
	return

/decl/chemical_reaction/instant/nitroglycerin
	name = REAGENT_NITROGLYCERIN
	id = REAGENT_ID_NITROGLYCERIN
	result = REAGENT_ID_NITROGLYCERIN
	required_reagents = list(REAGENT_ID_GLYCEROL = 1, REAGENT_ID_PACID = 1, REAGENT_ID_SACID = 1)
	result_amount = 2
	log_is_important = 1

/decl/chemical_reaction/instant/nitroglycerin/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/datum/effect/effect/system/reagents_explosion/e = new()
	e.set_up(round (created_volume/2, 1), holder.my_atom, 0, 0)
	if(isliving(holder.my_atom))
		e.amount *= 0.5
		var/mob/living/L = holder.my_atom
		if(L.stat!=DEAD)
			e.amount *= 0.5
	//VOREStation Add Start
	else
		holder.clear_reagents() //No more powergaming by creating a tiny amount of this
	//VOREStation Add End
	e.start()

	//holder.clear_reagents() //VOREStation Removal
	return

/decl/chemical_reaction/instant/napalm
	name = "Napalm"
	id = "napalm"
	result = null
	required_reagents = list(REAGENT_ID_ALUMINIUM = 1, REAGENT_ID_PHORON = 1, REAGENT_ID_SACID = 1 )
	result_amount = 1

/decl/chemical_reaction/instant/napalm/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/turf/location = get_turf(holder.my_atom.loc)
	for(var/turf/simulated/floor/target_tile in range(0,location))
		target_tile.assume_gas(GAS_VOLATILE_FUEL, created_volume, 400+T0C)
		spawn (0) target_tile.hotspot_expose(700, 400)
	holder.del_reagent("napalm")
	return

/decl/chemical_reaction/instant/chemsmoke
	name = "Chemsmoke"
	id = "chemsmoke"
	result = null
	required_reagents = list(REAGENT_ID_POTASSIUM = 1, REAGENT_ID_SUGAR = 1, REAGENT_ID_PHOSPHORUS = 1)
	result_amount = 0.4

/decl/chemical_reaction/instant/chemsmoke/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	var/datum/effect/effect/system/smoke_spread/chem/S = new /datum/effect/effect/system/smoke_spread/chem
	S.attach(location)
	S.set_up(holder, created_volume, 0, location)
	playsound(location, 'sound/effects/smoke.ogg', 50, 1, -3)
	spawn(0)
		S.start()
	//VOREStation Edit Start
	if(!isliving(holder.my_atom)) //No more powergaming by creating a tiny amount of this
		holder.clear_reagents()
	//VOREStation Edit End
	return

/decl/chemical_reaction/instant/foam
	name = "Foam"
	id = "foam"
	result = null
	required_reagents = list(REAGENT_ID_FLUOROSURFACTANT = 1, REAGENT_ID_WATER = 1)
	result_amount = 2
	mix_message = "The solution violently bubbles!"

/decl/chemical_reaction/instant/foam/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)

	for(var/mob/M in viewers(5, location))
		to_chat(M, span_warning("The solution spews out foam!"))

	var/datum/effect/effect/system/foam_spread/s = new()
	s.set_up(created_volume, location, holder, 0)
	s.start()
	//VOREStation Edit Start
	if(!isliving(holder.my_atom)) //No more powergaming by creating a tiny amount of this
		holder.clear_reagents()
	//VOREStation Edit End
	return

/decl/chemical_reaction/instant/metalfoam
	name = "Metal Foam"
	id = "metalfoam"
	result = null
	required_reagents = list(REAGENT_ID_ALUMINIUM = 3, REAGENT_ID_FOAMINGAGENT = 1, REAGENT_ID_PACID = 1)
	result_amount = 5

/decl/chemical_reaction/instant/metalfoam/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)

	for(var/mob/M in viewers(5, location))
		to_chat(M, span_warning("The solution spews out a metalic foam!"))

	var/datum/effect/effect/system/foam_spread/s = new()
	s.set_up(created_volume, location, holder, 1)
	s.start()
	return

/decl/chemical_reaction/instant/ironfoam
	name = "Iron Foam"
	id = "ironlfoam"
	result = null
	required_reagents = list(REAGENT_ID_IRON = 3, REAGENT_ID_FOAMINGAGENT = 1, REAGENT_ID_PACID = 1)
	result_amount = 5

/decl/chemical_reaction/instant/ironfoam/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)

	for(var/mob/M in viewers(5, location))
		to_chat(M, span_warning("The solution spews out a metalic foam!"))

	var/datum/effect/effect/system/foam_spread/s = new()
	s.set_up(created_volume, location, holder, 2)
	s.start()
	return

/* Paint */

/decl/chemical_reaction/instant/red_paint
	name = "Red paint"
	id = "red_paint"
	result = REAGENT_ID_PAINT
	required_reagents = list(REAGENT_ID_PLASTICIDE = 1, REAGENT_ID_WATER = 3, REAGENT_ID_MARKERINKRED = 1)
	result_amount = 5

/decl/chemical_reaction/instant/red_paint/send_data()
	return "#FE191A"

/decl/chemical_reaction/instant/orange_paint
	name = "Orange paint"
	id = "orange_paint"
	result = REAGENT_ID_PAINT
	required_reagents = list(REAGENT_ID_PLASTICIDE = 1, REAGENT_ID_WATER = 3, REAGENT_ID_MARKERINKORANGE = 1)
	result_amount = 5

/decl/chemical_reaction/instant/orange_paint/send_data()
	return "#FFBE4F"

/decl/chemical_reaction/instant/yellow_paint
	name = "Yellow paint"
	id = "yellow_paint"
	result = REAGENT_ID_PAINT
	required_reagents = list(REAGENT_ID_PLASTICIDE = 1, REAGENT_ID_WATER = 3, REAGENT_ID_MARKERINKYELLOW = 1)
	result_amount = 5

/decl/chemical_reaction/instant/yellow_paint/send_data()
	return "#FDFE7D"

/decl/chemical_reaction/instant/green_paint
	name = "Green paint"
	id = "green_paint"
	result = REAGENT_ID_PAINT
	required_reagents = list(REAGENT_ID_PLASTICIDE = 1, REAGENT_ID_WATER = 3, REAGENT_ID_MARKERINKGREEN = 1)
	result_amount = 5

/decl/chemical_reaction/instant/green_paint/send_data()
	return "#18A31A"

/decl/chemical_reaction/instant/blue_paint
	name = "Blue paint"
	id = "blue_paint"
	result = REAGENT_ID_PAINT
	required_reagents = list(REAGENT_ID_PLASTICIDE = 1, REAGENT_ID_WATER = 3, REAGENT_ID_MARKERINKBLUE = 1)
	result_amount = 5

/decl/chemical_reaction/instant/blue_paint/send_data()
	return "#247CFF"

/decl/chemical_reaction/instant/purple_paint
	name = "Purple paint"
	id = "purple_paint"
	result = REAGENT_ID_PAINT
	required_reagents = list(REAGENT_ID_PLASTICIDE = 1, REAGENT_ID_WATER = 3, REAGENT_ID_MARKERINKPURPLE = 1)
	result_amount = 5

/decl/chemical_reaction/instant/purple_paint/send_data()
	return "#CC0099"

/decl/chemical_reaction/instant/grey_paint //mime
	name = "Grey paint"
	id = "grey_paint"
	result = REAGENT_ID_PAINT
	required_reagents = list(REAGENT_ID_PLASTICIDE = 1, REAGENT_ID_WATER = 3, REAGENT_ID_MARKERINKGREY = 1)
	result_amount = 5

/decl/chemical_reaction/instant/grey_paint/send_data()
	return "#808080"

/decl/chemical_reaction/instant/brown_paint
	name = "Brown paint"
	id = "brown_paint"
	result = REAGENT_ID_PAINT
	required_reagents = list(REAGENT_ID_PLASTICIDE = 1, REAGENT_ID_WATER = 3, REAGENT_ID_MARKERINKBROWN = 1)
	result_amount = 5

/decl/chemical_reaction/instant/brown_paint/send_data()
	return "#846F35"

/decl/chemical_reaction/instant/blood_paint
	name = "Blood paint"
	id = "blood_paint"
	result = REAGENT_ID_PAINT
	required_reagents = list(REAGENT_ID_PLASTICIDE = 1, REAGENT_ID_WATER = 3, REAGENT_ID_BLOOD = 2)
	result_amount = 5

/decl/chemical_reaction/instant/blood_paint/send_data(var/datum/reagents/T)
	var/t = T.get_data(REAGENT_ID_BLOOD)
	if(t && t["blood_colour"])
		return t["blood_colour"]
	return "#FE191A" // Probably red

/decl/chemical_reaction/instant/milk_paint
	name = "Milk paint"
	id = "milk_paint"
	result = REAGENT_ID_PAINT
	required_reagents = list(REAGENT_ID_PLASTICIDE = 1, REAGENT_ID_WATER = 3, REAGENT_ID_MILK = 5)
	result_amount = 5

/decl/chemical_reaction/instant/milk_paint/send_data()
	return "#F0F8FF"

/decl/chemical_reaction/instant/orange_juice_paint
	name = "Orange juice paint"
	id = "orange_juice_paint"
	result = REAGENT_ID_PAINT
	required_reagents = list(REAGENT_ID_PLASTICIDE = 1, REAGENT_ID_WATER = 3, REAGENT_ID_ORANGEJUICE = 5)
	result_amount = 5

/decl/chemical_reaction/instant/orange_juice_paint/send_data()
	return "#E78108"

/decl/chemical_reaction/instant/tomato_juice_paint
	name = "Tomato juice paint"
	id = "tomato_juice_paint"
	result = REAGENT_ID_PAINT
	required_reagents = list(REAGENT_ID_PLASTICIDE = 1, REAGENT_ID_WATER = 3, REAGENT_ID_TOMATOJUICE = 5)
	result_amount = 5

/decl/chemical_reaction/instant/tomato_juice_paint/send_data()
	return "#731008"

/decl/chemical_reaction/instant/lime_juice_paint
	name = "Lime juice paint"
	id = "lime_juice_paint"
	result = REAGENT_ID_PAINT
	required_reagents = list(REAGENT_ID_PLASTICIDE = 1, REAGENT_ID_WATER = 3, REAGENT_ID_LIMEJUICE = 5)
	result_amount = 5

/decl/chemical_reaction/instant/lime_juice_paint/send_data()
	return "#365E30"

/decl/chemical_reaction/instant/carrot_juice_paint
	name = "Carrot juice paint"
	id = "carrot_juice_paint"
	result = REAGENT_ID_PAINT
	required_reagents = list(REAGENT_ID_PLASTICIDE = 1, REAGENT_ID_WATER = 3, REAGENT_ID_CARROTJUICE = 5)
	result_amount = 5

/decl/chemical_reaction/instant/carrot_juice_paint/send_data()
	return "#973800"

/decl/chemical_reaction/instant/berry_juice_paint
	name = "Berry juice paint"
	id = "berry_juice_paint"
	result = REAGENT_ID_PAINT
	required_reagents = list(REAGENT_ID_PLASTICIDE = 1, REAGENT_ID_WATER = 3, REAGENT_ID_BERRYJUICE = 5)
	result_amount = 5

/decl/chemical_reaction/instant/berry_juice_paint/send_data()
	return "#990066"

/decl/chemical_reaction/instant/grape_juice_paint
	name = "Grape juice paint"
	id = "grape_juice_paint"
	result = REAGENT_ID_PAINT
	required_reagents = list(REAGENT_ID_PLASTICIDE = 1, REAGENT_ID_WATER = 3, REAGENT_ID_GRAPEJUICE = 5)
	result_amount = 5

/decl/chemical_reaction/instant/grape_juice_paint/send_data()
	return "#863333"

/decl/chemical_reaction/instant/poisonberry_juice_paint
	name = "Poison berry juice paint"
	id = "poisonberry_juice_paint"
	result = REAGENT_ID_PAINT
	required_reagents = list(REAGENT_ID_PLASTICIDE = 1, REAGENT_ID_WATER = 3, REAGENT_ID_POISONBERRYJUICE = 5)
	result_amount = 5

/decl/chemical_reaction/instant/poisonberry_juice_paint/send_data()
	return "#863353"

/decl/chemical_reaction/instant/watermelon_juice_paint
	name = "Watermelon juice paint"
	id = "watermelon_juice_paint"
	result = REAGENT_ID_PAINT
	required_reagents = list(REAGENT_ID_PLASTICIDE = 1, REAGENT_ID_WATER = 3, REAGENT_ID_WATERMELONJUICE = 5)
	result_amount = 5

/decl/chemical_reaction/instant/watermelon_juice_paint/send_data()
	return "#B83333"

/decl/chemical_reaction/instant/lemon_juice_paint
	name = "Lemon juice paint"
	id = "lemon_juice_paint"
	result = REAGENT_ID_PAINT
	required_reagents = list(REAGENT_ID_PLASTICIDE = 1, REAGENT_ID_WATER = 3, REAGENT_ID_LEMONJUICE = 5)
	result_amount = 5

/decl/chemical_reaction/instant/lemon_juice_paint/send_data()
	return "#AFAF00"

/decl/chemical_reaction/instant/banana_juice_paint
	name = "Banana juice paint"
	id = "banana_juice_paint"
	result = REAGENT_ID_PAINT
	required_reagents = list(REAGENT_ID_PLASTICIDE = 1, REAGENT_ID_WATER = 3, REAGENT_ID_BANANA = 5)
	result_amount = 5

/decl/chemical_reaction/instant/banana_juice_paint/send_data()
	return "#C3AF00"

/decl/chemical_reaction/instant/potato_juice_paint
	name = "Potato juice paint"
	id = "potato_juice_paint"
	result = REAGENT_ID_PAINT
	required_reagents = list(REAGENT_ID_PLASTICIDE = 1, REAGENT_ID_WATER = 3, REAGENT_ID_POTATOJUICE = 5)
	result_amount = 5

/decl/chemical_reaction/instant/potato_juice_paint/send_data()
	return "#302000"

/decl/chemical_reaction/instant/carbon_paint
	name = "Carbon paint"
	id = "carbon_paint"
	result = REAGENT_ID_PAINT
	required_reagents = list(REAGENT_ID_PLASTICIDE = 1, REAGENT_ID_WATER = 3, REAGENT_ID_CARBON = 1)
	result_amount = 5

/decl/chemical_reaction/instant/carbon_paint/send_data()
	return "#333333"

/decl/chemical_reaction/instant/aluminum_paint
	name = "Aluminum paint"
	id = "aluminum_paint"
	result = REAGENT_ID_PAINT
	required_reagents = list(REAGENT_ID_PLASTICIDE = 1, REAGENT_ID_WATER = 3, REAGENT_ID_ALUMINIUM = 1)
	result_amount = 5

/decl/chemical_reaction/instant/aluminum_paint/send_data()
	return "#F0F8FF"

/*Carpet Recoloring*/
/decl/chemical_reaction/instant/carpetdye
	name = "Black Carpet Dyeing"
	id = "carpetdyeblack"
	result = REAGENT_ID_LIQUIDCARPETB
	required_reagents = list(REAGENT_ID_LIQUIDCARPET = 5, REAGENT_ID_CARBON = 1)
	result_amount = 5

/decl/chemical_reaction/instant/carpetdye/blue
	name = "Blue Carpet Dyeing"
	id = "carpetdyeblue"
	result = REAGENT_ID_LIQUIDCARPETBLU
	required_reagents = list(REAGENT_ID_LIQUIDCARPET = 5, REAGENT_ID_FROSTOIL = 1)

/decl/chemical_reaction/instant/carpetdye/tur
	name = "Turqouise Carpet Dyeing"
	id = "carpetdyetur"
	result = REAGENT_ID_LIQUIDCARPETTUR
	required_reagents = list(REAGENT_ID_LIQUIDCARPET = 5, REAGENT_ID_WATER = 1)

/decl/chemical_reaction/instant/carpetdye/sblu
	name = "Silver Blue Carpet Dyeing"
	id = "carpetdyesblu"
	result = REAGENT_ID_LIQUIDCARPETSBLU
	required_reagents = list(REAGENT_ID_LIQUIDCARPET = 5, REAGENT_ID_ICE = 1)

/decl/chemical_reaction/instant/carpetdye/clown
	name = "Clown Carpet Dyeing"
	id = "carpetdyeclown"
	result = REAGENT_ID_LIQUIDCARPETC
	required_reagents = list(REAGENT_ID_LIQUIDCARPET = 5, REAGENT_ID_BANANA = 1)

/decl/chemical_reaction/instant/carpetdye/purple
	name = "Purple Carpet Dyeing"
	id = "carpetdyepurple"
	result = REAGENT_ID_LIQUIDCARPETP
	required_reagents = list(REAGENT_ID_LIQUIDCARPET = 5, REAGENT_ID_BERRYJUICE = 1)

/decl/chemical_reaction/instant/carpetdye/orange
	name = "Orange Carpet Dyeing"
	id = "carpetdyeorange"
	result = REAGENT_ID_LIQUIDCARPETO
	required_reagents = list(REAGENT_ID_LIQUIDCARPET = 5, REAGENT_ID_ORANGEJUICE = 1)


//R-UST Port
/decl/chemical_reaction/instant/hydrophoron
	name = REAGENT_HYDROPHORON
	id = REAGENT_ID_HYDROPHORON
	result = REAGENT_ID_HYDROPHORON
	required_reagents = list(REAGENT_ID_HYDROGEN = 1, REAGENT_ID_PHORON = 1)
	inhibitors = list(REAGENT_ID_NITROGEN = 1) //So it doesn't mess with lexorin
	result_amount = 2

/decl/chemical_reaction/instant/deuterium
	name = REAGENT_DEUTERIUM
	id = REAGENT_ID_DEUTERIUM
	result = REAGENT_ID_DEUTERIUM
	required_reagents = list(REAGENT_ID_HYDROPHORON = 1, REAGENT_ID_WATER = 2)
	result_amount = 3

//Skrellian crap.
/decl/chemical_reaction/instant/talum_quem
	name = REAGENT_TALUMQUEM
	id = REAGENT_ID_TALUMQUEM
	result = REAGENT_ID_TALUMQUEM
	required_reagents = list(REAGENT_ID_BLISS = 2, REAGENT_ID_SUGAR = 1, REAGENT_ID_AMATOXIN = 1)
	result_amount = 4

/decl/chemical_reaction/instant/qerr_quem
	name = REAGENT_QERRQUEM
	id = REAGENT_ID_QERRQUEM
	result = REAGENT_ID_QERRQUEM
	required_reagents = list(REAGENT_ID_NICOTINE = 1, REAGENT_ID_CARBON = 1, REAGENT_ID_SUGAR = 2)
	result_amount = 4

/decl/chemical_reaction/instant/malish_qualem
	name = REAGENT_MALISHQUALEM
	id = REAGENT_ID_MALISHQUALEM
	result = REAGENT_ID_MALISHQUALEM
	required_reagents = list(REAGENT_ID_IMMUNOSUPRIZINE = 1, REAGENT_ID_QERRQUEM = 1, REAGENT_ID_INAPROVALINE = 1)
	catalysts = list(REAGENT_ID_PHORON = 5)
	result_amount = 2

// Biomass, for cloning and bioprinters
/decl/chemical_reaction/instant/biomass
	name = REAGENT_BIOMASS
	id = REAGENT_ID_BIOMASS
	result = REAGENT_ID_BIOMASS
	required_reagents = list(REAGENT_ID_PROTEIN = 1, REAGENT_ID_SUGAR = 1, REAGENT_ID_PHORON = 1)
	result_amount = 1	// Roughly 20u per phoron sheet

// Neutralization.

/decl/chemical_reaction/instant/neutralize_neurotoxic_protein
	name = "Neutralize Toxic Proteins"
	id = "neurotoxic_protein_neutral"
	result = REAGENT_ID_PROTEIN
	required_reagents = list(REAGENT_ID_ANTITOXIN = 1, REAGENT_ID_NEUROTOXIC_PROTEIN = 2)
	result_amount = 2

/decl/chemical_reaction/instant/neutralize_carpotoxin
	name = "Neutralize Carpotoxin"
	id = "carpotoxin_neutral"
	result = REAGENT_ID_PROTEIN
	required_reagents = list(REAGENT_ID_ENZYME = 1, REAGENT_ID_CARPOTOXIN = 1, REAGENT_ID_SIFSAP = 1)
	result_amount = 1

/decl/chemical_reaction/instant/neutralize_spidertoxin
	name = "Neutralize Spidertoxin"
	id = "spidertoxin_neutral"
	result = REAGENT_ID_PROTEIN
	required_reagents = list(REAGENT_ID_ENZYME = 1, REAGENT_ID_SPIDERTOXIN = 1, REAGENT_ID_SIFSAP = 1)
	result_amount = 1
