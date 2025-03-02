#define DISEASE_LIMIT		1
#define VIRUS_SYMPTOM_LIMIT	6

//Visibility Flags
#define HIDDEN_SCANNER	(1<<0)
#define HIDDEN_PANDEMIC	(1<<1)

//Disease Flags
#define CURABLE				(1<<0)
#define CAN_CARRY			(1<<1)
#define CAN_RESIST			(1<<2)
#define CAN_NOT_POPULATE	(1<<3)

//Spread Flags
#define DISEASE_SPREAD_SPECIAL			(1<<0)
#define DISEASE_SPREAD_NON_CONTAGIOUS	(1<<1)
#define DISEASE_SPREAD_BLOOD			(1<<2)
#define DISEASE_SPREAD_FLUIDS			(1<<3)
#define DISEASE_SPREAD_CONTACT			(1<<4)
#define DISEASE_SPREAD_AIRBORNE			(1<<5)

//Severity Defines
#define DISEASE_BENEFICIAL	"Beneficial"
#define DISEASE_POSITIVE	"Positive"
#define DISEASE_NONTHREAT	"No threat"
#define DISEASE_MINOR		"Minor"
#define DISEASE_MEDIUM		"Medium"
#define DISEASE_HARMFUL		"Harmful"
#define DISEASE_DANGEROUS 	"Dangerous"
#define DISEASE_BIOHAZARD	"BIOHAZARD"
#define DISEASE_PANDEMIC	"PANDEMIC"

#define EXTRAPOLATOR_RESULT_DISEASES		"extrapolator_result_disease"
#define EXTRAPOLATOR_RESULT_ACT_PRIORITY	"extrapolator_result_action_priority"
#define EXTRAPOLATOR_ACT_PRIORITY_SPECIAL	"extrapolator_action_priority_special"
#define EXTRAPOLATOR_ACT_PRIORITY_ISOLATE	"extrapolator_action_priority_isolate"
#define EXTRAPOLATOR_ACT_ADD_DISEASES(target_list, diseases)\
	do {\
		var/_D = ##diseases;\
		if ((islist(_D) && length(_D)) || istype(_D, /datum/disease)) {	\
			LAZYORASSOCLIST(##target_list, EXTRAPOLATOR_RESULT_DISEASES, _D);\
		}\
	} while(0)
#define EXTRAPOLATOR_ACT_CHECK(target_list, wanted_action_priority) (##target_list[EXTRAPOLATOR_RESULT_ACT_PRIORITY] == ##wanted_action_priority)
#define EXTRAPOLATOR_ACT_SET(target_list, wanted_action_priority) (##target_list[EXTRAPOLATOR_RESULT_ACT_PRIORITY] = ##wanted_action_priority)
