//Misc
#define DEAD_PLANT_COLOUR "#C2A180"
#define FROZEN_PLANT_COLOUR "#CCFFFF"

// Definitions for genes (trait groupings)
#define GENE_BIOCHEMISTRY "biochemistry"
#define GENE_HARDINESS "hardiness"
#define GENE_ENVIRONMENT "environment"
#define GENE_METABOLISM "metabolism"
#define GENE_STRUCTURE "appearance"
#define GENE_DIET "diet"
#define GENE_PIGMENT "pigment"
#define GENE_OUTPUT "output"
#define GENE_ATMOSPHERE "atmosphere"
#define GENE_VIGOUR "vigour"
#define GENE_FRUIT "fruit"
#define GENE_SPECIAL "special"

#define ALL_GENES list(GENE_BIOCHEMISTRY,GENE_HARDINESS,GENE_ENVIRONMENT,GENE_METABOLISM,GENE_STRUCTURE,GENE_DIET,GENE_PIGMENT,GENE_OUTPUT,GENE_ATMOSPHERE,GENE_VIGOUR,GENE_FRUIT,GENE_SPECIAL)

//Definitions for traits (individual descriptors)
#define TRAIT_CHEMS                1
#define TRAIT_EXUDE_GASSES         2
#define TRAIT_ALTER_TEMP           3
#define TRAIT_POTENCY              4
#define TRAIT_HARVEST_REPEAT       5
#define TRAIT_PRODUCES_POWER       6
#define TRAIT_JUICY                7
#define TRAIT_PRODUCT_ICON         8
#define TRAIT_PLANT_ICON           0
#define TRAIT_CONSUME_GASSES       10
#define TRAIT_REQUIRES_NUTRIENTS   11
#define TRAIT_NUTRIENT_CONSUMPTION 12
#define TRAIT_REQUIRES_WATER       13
#define TRAIT_WATER_CONSUMPTION    14
#define TRAIT_CARNIVOROUS          15
#define TRAIT_PARASITE             16
#define TRAIT_STINGS               17
#define TRAIT_IDEAL_HEAT           18
#define TRAIT_HEAT_TOLERANCE       19
#define TRAIT_IDEAL_LIGHT          20
#define TRAIT_LIGHT_TOLERANCE      21
#define TRAIT_LOWKPA_TOLERANCE     22
#define TRAIT_HIGHKPA_TOLERANCE    23
#define TRAIT_EXPLOSIVE            24
#define TRAIT_TOXINS_TOLERANCE     25
#define TRAIT_PEST_TOLERANCE       26
#define TRAIT_WEED_TOLERANCE       27
#define TRAIT_ENDURANCE            28
#define TRAIT_YIELD                29
#define TRAIT_SPREAD               30
#define TRAIT_MATURATION           31
#define TRAIT_PRODUCTION           32
#define TRAIT_TELEPORTING          33
#define TRAIT_PLANT_COLOUR         34
#define TRAIT_PRODUCT_COLOUR       35
#define TRAIT_BIOLUM               36
#define TRAIT_BIOLUM_COLOUR        37
#define TRAIT_IMMUTABLE            38
#define TRAIT_FLESH_COLOUR         39
#define TRAIT_SPORING              40
#define TRAIT_BENEFICIAL_REAG      41
#define TRAIT_MUTAGENIC_REAG       42
#define TRAIT_TOXIC_REAG           43

// Global list initialization for plants.

GLOBAL_LIST_INIT(plant_mob_products, list(
	/mob/living/simple_mob/creature = 10,
	/mob/living/simple_mob/blob/spore = 20,
	/mob/living/simple_mob/tomato = 30,
	/mob/living/simple_mob/animal/passive/dog = 5,
	/mob/living/simple_mob/animal/passive/chicken = 5,
	/mob/living/simple_mob/animal/passive/crab = 5,
	/mob/living/simple_mob/animal/passive/lizard = 4,
	/mob/living/simple_mob/animal/passive/lizard/large = 1,
	/mob/living/simple_mob/animal/giant_spider/pepper = 1,
	/mob/living/simple_mob/animal/giant_spider/frost = 1,
	/mob/living/simple_mob/animal/giant_spider/webslinger = 1,
	/mob/living/simple_mob/animal/passive/mouse = 1,
	/mob/living/simple_mob/animal/space/carp = 1,
	/mob/living/human/monkey = 1,
	/mob/living/simple_mob/diona_nymph = 1
	))

GLOBAL_LIST_INIT(plant_item_products, list(
	/obj/item/stack/material/cloth = 30,
	/obj/item/stack/material/wax = 20,
	/obj/item/stack/material/log = 30,
	/obj/item/stack/material/resin = 10,
	/obj/item/material/shard/shrapnel = 2,
	/obj/item/ore = 5,
	/obj/item/ore/iron = 2,
	/obj/item/ore/coal = 2,
	/obj/item/reagent_containers/food/snacks/meat = 3,
	/obj/random/meat = 1,
	/obj/item/reagent_containers/food/drinks/smallchocmilk = 2,
	/obj/item/reagent_containers/food/drinks/smallmilk = 2,
	/obj/item/ammo_casing/a145 = 1,
	/obj/item/ammo_casing/chemdart/small = 1,
	/obj/item/ammo_casing/chemdart = 1,
	/obj/item/organ/internal/brain/grey = 1,
	/obj/item/organ/internal/heart/grey = 1,
	/obj/item/spacecash/c1 = 3,
	/obj/item/spacecash/c10 = 1
	))

GLOBAL_LIST_INIT(forbidden_plant_growth_sprites, list(
	"gnomes"
	))

GLOBAL_LIST_INIT(forbidden_plant_product_sprites, list(
	"gnomes"
	))