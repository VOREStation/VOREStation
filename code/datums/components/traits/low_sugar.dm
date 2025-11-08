///Component that gives negative effects when at low nutrition.
/datum/component/diabetic
	var/nutrition_threshold = 200
	var/nutrition_weak = 100
	var/nutrition_danger = 50
	var/nutrition_critical = 25

/datum/component/diabetic/Initialize()

	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/diabetic/RegisterWithParent()
	RegisterSignal(parent, COMSIG_LIVING_LIFE, PROC_REF(process_component))

/datum/component/diabetic/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_LIVING_LIFE))

/datum/component/diabetic/proc/process_component()
	SIGNAL_HANDLER
	var/mob/living/living_guy = parent
	if(living_guy.nutrition > nutrition_threshold || isbelly(living_guy.loc))
		return
	if((living_guy.nutrition < nutrition_threshold) && prob(5))
		if(living_guy.nutrition > nutrition_weak)
			to_chat(living_guy, span_warning("You start to feel noticeably weak as your stomach rumbles, begging for more food. Maybe you should eat something to keep your blood sugar up"))
		else if(living_guy.nutrition > nutrition_danger)
			to_chat(living_guy, span_warning("You begin to feel rather weak, and your stomach rumbles loudly. You feel lightheaded and it's getting harder to think. You really need to eat something."))
		else if(living_guy.nutrition > nutrition_critical)
			to_chat(living_guy, span_danger("You're feeling very weak and lightheaded, and your stomach continously rumbles at you. You really need to eat something!"))
		else
			to_chat(living_guy,span_critical("You're feeling extremely weak and lightheaded. You feel as though you might pass out any moment and your stomach is screaming for food by now! You should really find something to eat!"))
	if((living_guy.nutrition < nutrition_weak) && prob(10))
		living_guy.Confuse(10)
	if((living_guy.nutrition < nutrition_danger) && prob(25))
		living_guy.hallucination = max(30,living_guy.hallucination+8)
	if((living_guy.nutrition < nutrition_critical) && prob(5))
		living_guy.drowsyness = max(100,living_guy.drowsyness+30)
