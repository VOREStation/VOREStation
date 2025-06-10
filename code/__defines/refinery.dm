#define REFINERY_SINTERING_SMOKE "FLAG_SMOKE"
#define REFINERY_SINTERING_EXPLODE "FLAG_EXPLODE"
#define REFINERY_SINTERING_SPIDERS "FLAG_SPIDERS"

#define REFINERY_DEFAULT_TRANSFER_AMOUNTS list(0,1,2,5,10,15,20,25,30,40,60,80,100,120)
#define SHEET_TO_REAGENT_EQUIVILENT *(1/REAGENTS_PER_SHEET) // 0.05 normally 1/20
// The tl;dr here is that the supply_conversion_value of the reagent should just match the per sheet value with the macro above.
// That should keep everything inline and not cause any cargo exploits.

#define REFINERY_TUTORIAL_INPUT (1 << 0)
#define REFINERY_TUTORIAL_FILTER (1 << 1)
#define REFINERY_TUTORIAL_HUB (1 << 2)
#define REFINERY_TUTORIAL_NOPOWER (1 << 3)
#define REFINERY_TUTORIAL_NOINPUT (1 << 4)
#define REFINERY_TUTORIAL_NOOUTPUT (1 << 5)
#define REFINERY_TUTORIAL_ALLIN (1 << 6)
#define REFINERY_TUTORIAL_SINGLEOUTPUT (1 << 7)

#define REAGENT_VAT_VOLUME 500
#define CARGOTANKER_VOLUME 3000

// Use these, unless it had a sheet analog to match,    VAL * 0.05 * 2000 = per full tank points
#define REFINERYEXPORT_VALUE_NO 0.1 SHEET_TO_REAGENT_EQUIVILENT			// 10 per tank
#define REFINERYEXPORT_VALUE_UNWANTED 0.5 SHEET_TO_REAGENT_EQUIVILENT	// 50 per tank
#define REFINERYEXPORT_VALUE_COMMON 1 SHEET_TO_REAGENT_EQUIVILENT		// 100 per tank
#define REFINERYEXPORT_VALUE_RARE 2 SHEET_TO_REAGENT_EQUIVILENT			// 200 per tank
#define REFINERYEXPORT_VALUE_PROCESSED 3 SHEET_TO_REAGENT_EQUIVILENT	// 300 per tank
#define REFINERYEXPORT_VALUE_HIGHREFINED 4 SHEET_TO_REAGENT_EQUIVILENT	// 400 per tank
#define REFINERYEXPORT_VALUE_MASSINDUSTRY 8 SHEET_TO_REAGENT_EQUIVILENT	// 800 per tank
#define REFINERYEXPORT_VALUE_PEAK 16 SHEET_TO_REAGENT_EQUIVILENT		// 1600 per tank
#define REFINERYEXPORT_VALUE_GODTIER 20 SHEET_TO_REAGENT_EQUIVILENT		// 2000 per tank

// Use these or you'll get weird endround lists
#define REFINERYEXPORT_REASON_BIOHAZARD "unwanted biohazards"
#define REFINERYEXPORT_REASON_RAW "raw industrial materials"
#define REFINERYEXPORT_REASON_PHORON "Nanotrasen patent violations" // Outpost 21 specific
#define REFINERYEXPORT_REASON_DRUG "pharmaceutical drugs"
#define REFINERYEXPORT_REASON_ILLDRUG "illegal drugs"
#define REFINERYEXPORT_REASON_RECDRUG "widespread recreational drugs"
#define REFINERYEXPORT_REASON_CLONEDRUG "vat cloning stablizers"
#define REFINERYEXPORT_REASON_SPECIALDRUG "specialized high end drugs"
#define REFINERYEXPORT_REASON_DIET "dietary supplements"
#define REFINERYEXPORT_REASON_FOOD "culinary ingredients"
#define REFINERYEXPORT_REASON_MATSCI "material science research"
#define REFINERYEXPORT_REASON_MEDSCI "medical science research"
#define REFINERYEXPORT_REASON_INDUSTRY "heavy industrial materials"
#define REFINERYEXPORT_REASON_PRECURSOR "industrial precursor chemicals"
#define REFINERYEXPORT_REASON_WEAPONS "chemical weaponry"
#define REFINERYEXPORT_REASON_COMSTIM "combat stimulants"
#define REFINERYEXPORT_REASON_COSMETIC "cosmetic coatings and drugs"
#define REFINERYEXPORT_REASON_CLEAN "cleaning products"
#define REFINERYEXPORT_REASON_LUBE "industrial lubricants"
