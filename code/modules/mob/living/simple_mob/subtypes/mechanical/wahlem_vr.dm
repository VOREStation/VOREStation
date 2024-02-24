// Ancient "soul"-infused mechanical shells. Used by Hlf'erath.

/mob/living/simple_mob/mechanical/wahlem
	name = "Ancient Mechanical Warrior"
	desc = "This construct is made of a brass-like material. Though aged, its shine is still brilliant, as it hovers ominously over the battlefield. Red flames spew from its shell. It diligently holds its shield and blade, at the ready, for any threats that may threaten its existence."
	icon = 'icons/tgstation/clockworkwarrior.dmi'
	icon_state = "clockM"
	health = 300
	maxHealth = 300

	faction = "golem"

	response_help   = "brushes over"
	response_disarm = "repulses away"
	response_harm   = "slices"
	harm_intent_damage = 3
	friendly = "tolerates"

	melee_damage_lower = 30 // It has an ancient magic sword.
	melee_damage_upper = 30
	attack_sound = 'sound/weapons/bladeslice.ogg'
	attacktext = list("slashed")

	ai_holder_type = /datum/ai_holder/simple_mob/melee

	// Cataloguer data below - strange we can catalogue space golem wizards
/datum/category_item/catalogue/technology/drone/wahlem
	name = "Ancient Construct"
	desc = "Some sort of ancient, mechanical warrior, built for combat.\
	It has a brass and red theme. It wields a brass, slightly broken shield in its right hand. It has a sharp, foot-long blade in its other hand..\
	The drone has pristine armor, golden and shiny, with red cracks in its armour glowing visibly from inside.\
	<br><br>\
	The drone's frame is heavy and armored, unbendable by hand, is barren of any markings or ID,\
	no traces of paint visible and any 'writing' visible is uncomprehendable, short term scan unable to translate."
	value = CATALOGUER_REWARD_MEDIUM
