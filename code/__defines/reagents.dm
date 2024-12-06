// Gasses

#define GAS_CO2 "carbon_dioxide"
#define GAS_N2 "nitrogen"
#define GAS_N2O "nitrous_oxide"
#define GAS_O2 "oxygen"
#define GAS_PHORON "phoron"
#define GAS_VOLATILE_FUEL "volatile_fuel"

// Gas Reagents
#define REAGENT_CARBON_DIOXIDE "Nitrogen"
#define REAGENT_NITROGEN "Nitrogen"
#define REAGENT_ID_NITROGEN "nitrogen"
#define REAGENT_NITROUS_OXIDE "Nitrous Oxide"
#define REAGENT_OXYGEN "Oxygen"
#define REAGENT_ID_OXYGEN "oxygen"
#define REAGENT_VOLATILE_FUEL "Volatile Fuel"











#define REAGENT_ID_HYDROGEN "hydrogen"

// Fluid Reagents
#define REAGENT_WATER "Water"
#define REAGENT_ID_WATER "water"
#define REAGENT_PACID "pacid"

// Solid Reagents
#define REAGENT_IRON "Iron"
#define REAGENT_ID_IRON "iron"
#define REAGENT_COPPER "Copper"
#define REAGENT_ID_COPPER "copper"
#define REAGENT_SILVER "Silver"
#define REAGENT_ID_SILVER "silver"
#define REAGENT_GOLD "Gold"
#define REAGENT_ID_GOLD "gold"
#define REAGENT_SLIMEJELLY "Slimejelly"
#define REAGENT_ID_SLIMEJELLY "slimejelly"

// Toxins
#define REAGEMT_PHORON "Phoron"
#define REAGENT_ID_PHORON "phoron"
#define REAGENT_LEAD "Lead"
#define REAGENT_ID_LEAD "lead"
#define REAGENT_SPIDERTOXIN "Spidertoxin"
#define REAGENT_ID_SPIDERTOXIN "spidertoxin"


#define REAGENT_ID_SILICATE "silicate"
#define REAGENT_ID_POTASSIUM "potassium"
#define REAGENT_ID_URANIUM "uranium"
#define REAGENT_ID_CARBON "carbon"
#define REAGENT_ID_PLATINUM "platinum"
#define REAGENT_ID_ALUMINIUM "aluminum"
#define REAGENT_ID_CALCIUMCARBONATE "calciumcarbonate"

todos
defective_nanites

	var/list/produceable_chemicals = list("inaprovaline","anti_toxin","alkysine","bicaridine","tramadol","kelotane","leporazine",REAGENT_ID_IRON,REAGENT_ID_PHORON,"condensedcapsaicin_v","frostoil")
	var/randomized_reagent = REAGENT_ID_IRON	// The reagent chosen at random to be produced, if there's no one piloting the worm.
	var/passive_reagent = "paracetamol"	// Reagent passively produced by the leech. Should usually be a painkiller.
supermatter
mydrogen
silicon
lithium
deuterium
tritium
helium-3
boron

	chemreact = list(	"nutriment" = list("nutr" = 0.5),
						"radium" = list("toxic" = 0.3, "mut" = 1),
						"mutagen" = list("nutr" = 0.4, "mut" = 2),
						"water" = list("nutr" = -0.1),
						"milk" = list("nutr" = 0.3),
						"sacid" = list("toxic" = 1),
						"pacid" = list("toxic" = 2),
						"chlorine" = list("toxic" = 0.5),
						"ammonia" = list("toxic" = 0.5),
						"sodawater" = list("toxic" = 0.1, "nutr" = -0.1),
						"beer" = list("nutr" = 0.6),
						"diethylamine" = list("nutr" = 0.9),
						"sugar" = list("toxic" = 0.4, "nutr" = 0.2),
						"eznutrient" = list("nutr" = 0.8),
						"cryoxadone" = list("toxic" = 0.4),
						"flourine" = list("toxic" = 0.1),
						"robustharvest" = list("nutr" = 1.5),
						"glucose" = list("nutr" = 0.5),
						"blood" = list("nutr" = 0.75, "toxic" = 0.05, "mut" = 0.45),
						"fuel" = list("toxic" = 0.4),
						"toxin" = list("toxic" = 0.5),
						"carpotoxin" = list("toxic" = 1, "mut" = 1.5),
						REAGENT_ID_PHORON = list("toxic" = 1.5, "mut" = 0.03),
						"virusfood" = list("nutr" = 1.5, "mut" = 0.32),
						"cyanide" = list("toxic" = 3.5),
						"slimejelly" = list("nutr" = 0.5),
						"amutationtoxin" = list("toxic" = 0.1, "heal" = 1.5, "mut" = 3),
						"mutationtoxin" = list("toxic" = 0.1, "heal" = 1, "mut" = 1.5),
						"gold" = list("heal" = 0.3, "nutr" = 0.7, "mut" = 0.3),
						"uranium" = list("heal" = 0.3, "toxic" = 0.7, "mut" = 1.2),
						"glycerol" = list("nutr" = 0.6),
						"woodpulp" = list("heal" = 0.1, "nutr" = 0.7),
						"docilitytoxin" = list("nutr" = 0.3)	)
