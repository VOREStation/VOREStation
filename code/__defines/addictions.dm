#define CE_WITHDRAWL "withdrawl" // Withdrawl symptoms

#define ADDICT_NORMAL 1
#define ADDICT_SLOW 2
#define ADDICT_FAST 3
#define ADDICT_ALL 4

GLOBAL_LIST_INIT(reagent_addictive_standard,list(REAGENT_ID_AMBROSIAEXTRACT,REAGENT_ID_TALUMQUEM,REAGENT_ID_METHYLPHENIDATE))
GLOBAL_LIST_INIT(reagent_addictive_fast,list(REAGENT_ID_HYPERZINE,REAGENT_ID_BLISS))
GLOBAL_LIST_INIT(reagent_addictive_slow,list(REAGENT_ID_TRAMADOL,REAGENT_ID_OXYCODONE,REAGENT_ID_TRICORDRAZINE,REAGENT_ID_ASUSTENANCE,REAGENT_ID_ETHANOL,REAGENT_ID_NICOTINE,REAGENT_ID_COFFEE))

/proc/get_addictive_reagents(var/addict_type)
	RETURN_TYPE(/list)
	switch(addict_type)
		if(ADDICT_NORMAL)
			return GLOB.reagent_addictive_standard
		if(ADDICT_SLOW)
			return GLOB.reagent_addictive_slow
		if(ADDICT_FAST)
			return GLOB.reagent_addictive_fast
	return GLOB.reagent_addictive_standard + GLOB.reagent_addictive_fast + GLOB.reagent_addictive_slow
