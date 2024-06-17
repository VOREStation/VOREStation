/obj/item/clothing/proc/describe_armor(var/armor_type, var/descriptive_attack_type)
	if(armor[armor_type])
		switch(armor[armor_type])
			if(1 to 20)
				return "It provides negligibly small defense against [descriptive_attack_type]."
			if(21 to 30)
				return "It provides very small defense against [descriptive_attack_type]."
			if(31 to 40)
				return "It offers a small amount of protection against [descriptive_attack_type]."
			if(41 to 50)
				return "It offers a moderate defense against [descriptive_attack_type]."
			if(51 to 60)
				return "It provides a strong defense against [descriptive_attack_type]."
			if(61 to 70)
				return "It is very strong against [descriptive_attack_type]."
			if(71 to 80)
				return "This gives extremely strong defense against [descriptive_attack_type]."
			if(81 to 99)
				return "Wearing this would make you nigh-invulerable against [descriptive_attack_type]."
			if(100)
				return "You would be immune to [descriptive_attack_type] if you wore this."

/obj/item/clothing/proc/describe_slowdown()
	switch(slowdown)
		if(-INFINITY to -0.1)
			return "It looks like it might actually make you faster!"
		if(0,null)
			return "It doesn't look like it'll impede your mobility."
		if(0.5)
			return "It might slow you down a little bit."
		if(1)
			return "It'll slow you down noticeably, but not too much."
		if(1.5)
			return "You'll be moving a fair bit slower than everyone else."
		if(2)
			return "Your speed will be noticeably impaired by its weight and inflexibility."
		if(3)
			return "You'd have a pretty hard time moving in it."
		if(4)
			return "It looks heavy enough to seriously impede your mobility."
		if(5)
			return "It's heavy enough that moving in it will be extremely difficult!"
		else
			return "It's difficult to tell how much it'll influence your speed."

/obj/item/clothing/get_description_info()
	var/armor_stats = description_info + "\
	<br>"

	if(armor["melee"])
		armor_stats += "[describe_armor("melee","blunt force")] \n"
	if(armor["bullet"])
		armor_stats += "[describe_armor("bullet","ballistics")] \n"
	if(armor["laser"])
		armor_stats += "[describe_armor("laser","lasers")] \n"
	if(armor["energy"])
		armor_stats += "[describe_armor("energy","energy")] \n"
	if(armor["bomb"])
		armor_stats += "[describe_armor("bomb","explosions")] \n"
	if(armor["bio"])
		armor_stats += "[describe_armor("bio","biohazards")] \n"
	if(armor["rad"])
		armor_stats += "[describe_armor("rad","radiation")] \n"

	armor_stats += "\n"

	armor_stats += "[describe_slowdown()] \n"

	if(flags & AIRTIGHT)
		armor_stats += "It is airtight. \n"

	if(min_pressure_protection != null)
		armor_stats += "It is rated for pressures as low as [min_pressure_protection] kPa. \n"
	if(max_pressure_protection)
		armor_stats += "It is rated for pressures as high as [max_pressure_protection] kPa. \n"

	if(flags & THICKMATERIAL)	//stops syringes
		armor_stats += "The material is exceptionally thick. \n"

	if(min_cold_protection_temperature)
		armor_stats += "It is rated for temperatures as low as [min_cold_protection_temperature] Kelvin. \n"
	if(max_heat_protection_temperature)
		armor_stats += "It is rated for temperatures as high as [max_heat_protection_temperature] Kelvin. \n"

	var/list/covers = list()
	var/list/slots = list()

	for(var/name in string_part_flags)
		if(body_parts_covered & string_part_flags[name])
			covers += name

	for(var/name in string_slot_flags)
		if(slot_flags & string_slot_flags[name])
			slots += name

	if(covers.len)
		armor_stats += "It covers the [english_list(covers)]. \n"

	if(slots.len)
		armor_stats += "It can be worn on your [english_list(slots)]. \n"

	return armor_stats
