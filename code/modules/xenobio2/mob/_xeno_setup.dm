//Important definitions for xenos, traits datum.

//Definitions for gene grouping.
#define GENE_XENO_BIOCHEMISTRY "biochemistry"
#define GENE_XENO_HEALTH "health"
#define GENE_XENO_RESISTANCES "resistances"
#define GENE_XENO_INTERNAL "internal"
#define GENE_XENO_COLOR "color"
#define GENE_XENO_LEARN "learn"
#define GENE_XENO_SPEAK "speak"
#define GENE_XENO_SPEED "speed"
#define GENE_XENO_SPECIAL "special"

//Definitions for traits.

#define TRAIT_XENO_COLOR 				"color"
#define TRAIT_XENO_CHEMISTRY 			"chems"
#define TRAIT_XENO_CHEMVOL 				"chem_vol"
#define TRAIT_XENO_HEALTH 				"health"
#define TRAIT_XENO_HUNGER 				"hunger"
#define TRAIT_XENO_STARVEDAMAGE 		"starvedamage"
#define TRAIT_XENO_EATS 				"eats"
#define TRAIT_XENO_CHROMATIC 			"chrom"
#define TRAIT_XENO_HOSTILE 				"hostile"
#define TRAIT_XENO_BIOLUMESCENT 		"biolum"
#define TRAIT_XENO_BIO_COLOR 			"biocolor"
#define TRAIT_XENO_GLOW_STRENGTH 		"biostrength"
#define TRAIT_XENO_GLOW_RANGE 			"biorange"
#define TRAIT_XENO_TOXIC_CHEMS 			"tox_chems"
#define TRAIT_XENO_NUTRITIONAL_CHEMS 	"nutr_chems"
#define TRAIT_XENO_HEALING_CHEMS 		"heal_chems"
#define TRAIT_XENO_MUTATING_CHEMS 		"mut_chems"
#define TRAIT_XENO_SPEED 				"speed"
#define TRAIT_XENO_COLDRES 				"cold_resistance"
#define TRAIT_XENO_HEATRES 				"heat_resistance"
#define TRAIT_XENO_LEARNCHANCE 			"learn_chance"
#define TRAIT_XENO_CANLEARN 			"can_learn"
#define TRAIT_XENO_SPEAKCHANCE 			"speak_chance"
#define TRAIT_XENO_CANSPEAK 			"can_speak"
#define TRAIT_XENO_STRENGTH 			"melee_strength"
#define TRAIT_XENO_STR_RANGE 			"melee_range"

//Maleability defines.
#define MAX_MALEABLE 	2
#define MINOR_MALEABLE 	1
#define MIN_MALEABLE	0

var/global/list/xenoChemList = list("mutationtoxin", 
						"psilocybin", 
						"mindbreaker", 
						"impedrezene", 
						"cryptobiolin", 
						"serotronium", 
						"space_drugs", 
						"chloralhydrate", 
						"stoxin", 
						"mutagen", 
						"lexorin", 
						"pacid", 
						"cyanide", 
						"phoron", 
						"plasticide", 
						"amatoxin", 
						"carbon", 
						"radium", 
						"sacid", 
						"sugar", 
						"kelotane", 
						"dermaline", 
						"anti_toxin", 
						"dexalin", 
						"synaptizine", 
						"alkysine", 
						"imidazoline", 
						"peridaxon", 
						"rezadone")
						
/datum/xeno/traits
	var/list/traits = list()
	var/list/chemlist = list()
	var/obj/chems
	
/datum/xeno/traits/proc/set_trait(var/trait, var/newval)
	traits["[trait]"] = newval
	return
	
/datum/xeno/traits/New()
	..()
	set_trait(TRAIT_XENO_COLOR,	"#CACACA")
	set_trait(TRAIT_XENO_CHEMVOL, 100)
	set_trait(TRAIT_XENO_HEALTH, 20)
	set_trait(TRAIT_XENO_HUNGER, 2)
	set_trait(TRAIT_XENO_STARVEDAMAGE, 0)
	set_trait(TRAIT_XENO_EATS, 1)
	set_trait(TRAIT_XENO_CHROMATIC, 0)
	set_trait(TRAIT_XENO_HOSTILE, 0)
	set_trait(TRAIT_XENO_BIOLUMESCENT, 0)
	set_trait(TRAIT_XENO_BIO_COLOR, "#CACACA")
	set_trait(TRAIT_XENO_GLOW_STRENGTH, 0)
	set_trait(TRAIT_XENO_GLOW_RANGE, 0)
	set_trait(TRAIT_XENO_SPEED, 4)
	set_trait(TRAIT_XENO_COLDRES, 20)
	set_trait(TRAIT_XENO_HEATRES, 20)
	set_trait(TRAIT_XENO_LEARNCHANCE, 100)
	set_trait(TRAIT_XENO_CANLEARN, 1)
	set_trait(TRAIT_XENO_SPEAKCHANCE, 1)
	set_trait(TRAIT_XENO_CANSPEAK, 1)
	set_trait(TRAIT_XENO_STRENGTH, 0)
	set_trait(TRAIT_XENO_STR_RANGE, 0)
	chems = new()
	chems.create_reagents(traits[TRAIT_XENO_CHEMVOL])