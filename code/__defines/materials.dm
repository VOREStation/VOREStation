#define MAT_IRON			"iron"
#define MAT_MARBLE			"marble"
#define MAT_STEEL			"steel"
#define MAT_PLASTIC			"plastic"
#define MAT_GLASS			"glass"
#define MAT_SILVER			"silver"
#define MAT_GOLD			"gold"
#define MAT_URANIUM			"uranium"
#define MAT_TITANIUM		"titanium"
#define MAT_PHORON			"phoron"
#define MAT_DIAMOND			"diamond"
#define MAT_SNOW			"snow"
#define MAT_SNOWBRICK		"packed snow"
#define MAT_WOOD			"wood"
#define MAT_LOG				"log"
#define MAT_SIFWOOD			"alien wood"
#define MAT_SIFLOG			"alien log"
#define MAT_STEELHULL		"steel hull"
#define MAT_PLASTEEL		"plasteel"
#define MAT_PLASTEELHULL	"plasteel hull"
#define MAT_DURASTEEL		"durasteel"
#define MAT_DURASTEELHULL	"durasteel hull"
#define MAT_TITANIUMHULL	"titanium hull"
#define MAT_VERDANTIUM		"verdantium"
#define MAT_MORPHIUM		"morphium"
#define MAT_MORPHIUMHULL	"morphium hull"
#define MAT_VALHOLLIDE		"valhollide"
#define MAT_LEAD			"lead"
#define MAT_SUPERMATTER		"supermatter"
#define MAT_METALHYDROGEN	"mhydrogen"
#define MAT_OSMIUM			"osmium"
#define MAT_GRAPHITE		"graphite"
#define MAT_LEATHER			"leather"
#define MAT_CHITIN			"chitin"
#define MAT_CLOTH			"cloth"
#define MAT_SYNCLOTH		"syncloth"
#define MAT_FIBERS			"fibers"
#define MAT_COPPER			"copper"
#define MAT_QUARTZ			"quartz"
#define MAT_TIN				"tin"
#define MAT_VOPAL			"void opal"
#define MAT_ALUMINIUM		"aluminium"
#define MAT_BRONZE			"bronze"
#define MAT_PAINITE			"painite"
#define MAT_BOROSILICATE	"borosilicate glass"
#define MAT_SANDSTONE		"sandstone"

#define DEFAULT_TABLE_MATERIAL MAT_PLASTIC
#define DEFAULT_WALL_MATERIAL MAT_STEEL

#define SHARD_SHARD "shard"
#define SHARD_SHRAPNEL "shrapnel"
#define SHARD_STONE_PIECE "piece"
#define SHARD_SPLINTER "splinters"
#define SHARD_NONE ""

#define MATERIAL_UNMELTABLE 0x1
#define MATERIAL_BRITTLE    0x2
#define MATERIAL_PADDING    0x4

#define TABLE_BRITTLE_MATERIAL_MULTIPLIER 4 // Amount table damage is multiplied by if it is made of a brittle material (e.g. glass)

//Material Container Flags.
///If the container shows the amount of contained materials on examine.
#define MATCONTAINER_EXAMINE (1<<0)
///If the container cannot have materials inserted through attackby().
#define MATCONTAINER_NO_INSERT (1<<1)
///if the user can insert mats into the container despite the intent.
#define MATCONTAINER_ANY_INTENT (1<<2)
///if the user won't receive a warning when attacking the container with an unallowed item.
#define MATCONTAINER_SILENT (1<<3)

#define GET_MATERIAL_REF(arguments...) _GetMaterialRef(list(##arguments))