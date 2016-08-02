//Important definitions for xenos, traits datum.

//Definitions for gene grouping.
#define GENE_XENO_BIOCHEMISTRY "biochemistry"
#define GENE_XENO_HEALTH "health"
#define GENE_XENO_RESISTANCES "resistances"
#define GENE_XENO_INTERNAL "internal"
#define GENE_XENO_COLOR "color"
#define GENE_XENO_GLOW "glow"
#define GENE_XENO_LEARN "learn"
#define GENE_XENO_SPEAK "speak"
#define GENE_XENO_SPEED "speed"
#define GENE_XENO_SPECIAL "special"

#define ALL_XENO_GENES list(GENE_XENO_BIOCHEMISTRY, GENE_XENO_HEALTH, GENE_XENO_RESISTANCES, GENE_XENO_INTERNAL, GENE_XENO_COLOR, GENE_XENO_LEARN, GENE_XENO_SPEAK, GENE_XENO_SPEED, GENE_XENO_SPECIAL)

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
						"rezadone",
						"mutationtoxin",
						"docilitytoxin")
						
/datum/xeno/traits
	var/list/traits = list()
	var/list/chemlist = list()
	var/list/chems = list()
	var/source = "unknown"
	
/datum/xeno/traits/proc/set_trait(var/trait, var/newval)
	traits["[trait]"] = newval
	return
	
/datum/xeno/traits/proc/get_trait(var/trait)
	var/val = traits["[trait]"]
	return val
	
/datum/xeno/traits/proc/copy_traits(var/datum/xeno/traits/target)
	target.traits = traits
	target.chemlist = chemlist
	target.chems = chems
	target.source = source
	
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
	
/datum/xeno/traits/proc/get_gene(var/genetype)
	
	if(!genetype) return 0
	
	var/datum/xeno/genes/G = new()
	G.genetype = genetype
	G.values = list()
	
	switch(genetype)
		if(GENE_XENO_BIOCHEMISTRY)
			G.values["[TRAIT_XENO_CHEMVOL]"] = get_trait(TRAIT_XENO_CHEMVOL)
			G.chems = chems
		if(GENE_XENO_HEALTH)
			G.values["[TRAIT_XENO_HEALTH]"] = get_trait(TRAIT_XENO_HEALTH)
			G.values["[TRAIT_XENO_STRENGTH]"] = get_trait(TRAIT_XENO_STRENGTH)
			G.values["[TRAIT_XENO_STR_RANGE]"] = get_trait(TRAIT_XENO_STR_RANGE)
		if(GENE_XENO_RESISTANCES)
			G.values["[TRAIT_XENO_COLDRES]"] = get_trait(TRAIT_XENO_HEALTH)
			G.values["[TRAIT_XENO_HEATRES]"] = get_trait(TRAIT_XENO_STRENGTH)
		if(GENE_XENO_INTERNAL)
			G.values["[TRAIT_XENO_NUTRITIONAL_CHEMS]"] = get_trait(TRAIT_XENO_NUTRITIONAL_CHEMS)
			G.values["[TRAIT_XENO_HEALING_CHEMS]"] = get_trait(TRAIT_XENO_HEALING_CHEMS)
			G.values["[TRAIT_XENO_TOXIC_CHEMS]"] = get_trait(TRAIT_XENO_TOXIC_CHEMS)
			G.values["[TRAIT_XENO_MUTATING_CHEMS]"] = get_trait(TRAIT_XENO_MUTATING_CHEMS)
		if(GENE_XENO_COLOR)
			G.values["[TRAIT_XENO_COLOR]"] = get_trait(TRAIT_XENO_COLOR)
			G.values["[TRAIT_XENO_BIO_COLOR]"] = get_trait(TRAIT_XENO_BIO_COLOR)
		if(GENE_XENO_GLOW)
			G.values["[TRAIT_XENO_BIOLUMESCENT]"] = get_trait(TRAIT_XENO_BIOLUMESCENT)
			G.values["[TRAIT_XENO_GLOW_RANGE]"] = get_trait(TRAIT_XENO_GLOW_RANGE)
			G.values["[TRAIT_XENO_GLOW_STRENGTH]"] = get_trait(TRAIT_XENO_GLOW_STRENGTH)
		if(GENE_XENO_LEARN)
			G.values["[TRAIT_XENO_LEARNCHANCE]"] = get_trait(TRAIT_XENO_LEARNCHANCE)
			G.values["[TRAIT_XENO_CANLEARN]"] = get_trait(TRAIT_XENO_CANLEARN)
		if(GENE_XENO_SPEAK)
			G.values["[TRAIT_XENO_SPEAKCHANCE]"] = get_trait(TRAIT_XENO_SPEAKCHANCE)
			G.values["[TRAIT_XENO_CANSPEAK]"] = get_trait(TRAIT_XENO_CANSPEAK)
		if(GENE_XENO_SPEED)
			G.values["[TRAIT_XENO_SPEED]"] = get_trait(TRAIT_XENO_SPEED)
		if(GENE_XENO_SPECIAL)
			G.values["[TRAIT_XENO_HOSTILE]"] = get_trait(TRAIT_XENO_HOSTILE)
			G.values["[TRAIT_XENO_CHROMATIC]"] = get_trait(TRAIT_XENO_CHROMATIC)
			
	return G
			
/datum/xeno/traits/proc/apply_gene(var/datum/xeno/genes/genes)
	if(!genes.genetype) return 0
	
	switch(genes.genetype)
		if(GENE_XENO_BIOCHEMISTRY)
			set_trait(TRAIT_XENO_CHEMVOL, genes.values["[TRAIT_XENO_CHEMVOL]"])
			for(var/reagent in genes.chems)
				chems[reagent] = genes[reagent]
				
		if(GENE_XENO_HEALTH)
			set_trait(TRAIT_XENO_HEALTH, genes.values["[TRAIT_XENO_HEALTH]"])
			set_trait(TRAIT_XENO_STRENGTH, genes.values["[TRAIT_XENO_STRENGTH]"])
			set_trait(TRAIT_XENO_STR_RANGE, genes.values["[TRAIT_XENO_STR_RANGE]"])
		if(GENE_XENO_RESISTANCES)
			set_trait(TRAIT_XENO_COLDRES, genes.values["[TRAIT_XENO_COLDRES]"])
			set_trait(TRAIT_XENO_HEATRES, genes.values["[TRAIT_XENO_HEATRES]"])
		if(GENE_XENO_INTERNAL)
			set_trait(TRAIT_XENO_NUTRITIONAL_CHEMS, genes.values["[TRAIT_XENO_NUTRITIONAL_CHEMS]"])
			set_trait(TRAIT_XENO_HEALING_CHEMS, genes.values["[TRAIT_XENO_HEALING_CHEMS]"])
			set_trait(TRAIT_XENO_TOXIC_CHEMS, genes.values["[TRAIT_XENO_TOXIC_CHEMS]"])
			set_trait(TRAIT_XENO_MUTATING_CHEMS, genes.values["[TRAIT_XENO_MUTATING_CHEMS]"])
		if(GENE_XENO_COLOR)
			set_trait(TRAIT_XENO_COLOR, genes.values["[TRAIT_XENO_COLOR]"])
			set_trait(TRAIT_XENO_BIO_COLOR, genes.values["[TRAIT_XENO_BIO_COLOR]"])
		if(GENE_XENO_GLOW)
			set_trait(TRAIT_XENO_BIOLUMESCENT, genes.values["[TRAIT_XENO_BIOLUMESCENT]"])
			set_trait(TRAIT_XENO_GLOW_RANGE, genes.values["[TRAIT_XENO_GLOW_RANGE]"])
			set_trait(TRAIT_XENO_GLOW_STRENGTH, genes.values["[TRAIT_XENO_GLOW_STRENGTH]"])
		if(GENE_XENO_LEARN)
			set_trait(TRAIT_XENO_LEARNCHANCE, genes.values["[TRAIT_XENO_LEARNCHANCE]"])
			set_trait(TRAIT_XENO_CANLEARN, genes.values["[TRAIT_XENO_CANLEARN]"])
		if(GENE_XENO_SPEAK)
			set_trait(TRAIT_XENO_SPEAKCHANCE, genes.values["[TRAIT_XENO_SPEAKCHANCE]"])
			set_trait(TRAIT_XENO_CANSPEAK, genes.values["[TRAIT_XENO_CANSPEAK]"])
		if(GENE_XENO_SPEED)
			set_trait(TRAIT_XENO_SPEED ,genes.values["[TRAIT_XENO_SPEED]"])
		if(GENE_XENO_SPECIAL)
			set_trait(TRAIT_XENO_HOSTILE, genes.values["[TRAIT_XENO_HOSTILE]"])
			set_trait(TRAIT_XENO_CHROMATIC, genes.values["[TRAIT_XENO_CHROMATIC]"])
			
/datum/xeno/genes
	var/genetype	//Label for specifying what gene is used.
	var/list/values	//What's going to be put into specific traits
	var/list/chems
	

	