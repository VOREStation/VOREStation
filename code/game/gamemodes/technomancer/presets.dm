/datum/technomancer/presets
	name = "Preset Template"
	desc = "If you see me, I'm broken."
	obj_path = null
	var/list/bundled = list()

/datum/technomancer/presets/summoner
	name = "Summoner"
	desc = "This preset includes a few functions to teleport creatures to you, if you can't find any when you leave, as well as \
	the Control function, to command said creatures.  It also includes Aspect Aura and Mend Wounds to allow for an area of effect \
	heal that will keep your creature army healthy.  Finally, it includes Discharge, a damaging and draining function that can go \
	over your creatures."
	cost = 600

/datum/technomancer/presets/healer
	name = "Healer"
	desc = "This preset is recommended for apprentices who wish to support their master.  It contains many healing and support \
	functions, such as Mend Wounds, Mend Burns, Purify, Oxygenate, Aspect Aura, Shared Burden, Link, Resurrect, and Great Mend Wounds.  \
	Be aware that a lot of these functions create a lot of instability, so prepare for that if you can."
	cost = 600

/datum/technomancer/presets/support
	name = "Support"
	desc = "This preset is recommended for apprentices who wish to support their master.  It contains many functions focused on \
	augmenting you and your master's survival and capabilities, with functions such as Repel Missiles, Aspect Aura, Shared Burden, \
	."
	cost = 600

/datum/technomancer/presets/rainbow
	name = "Rainbow Mage"
	desc = "This preset includes many Aspect functions, such as Aspect Aura, Aspect Bolt, Aspect Cloud, Aspect Weapon, etc, as well as \
	cheap functions beloning to each aspect, for the purposes of combining with an aspect function.  This allows you to be \
	very flexable, however functions made from aspect functions tend to be weaker due to this."
	cost = 600