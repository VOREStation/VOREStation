/obj/item/proc/describe_power()
	switch(force)
		if(0)
			return "a negligable amount of"
		if(1 to 2)
			return "a very small amount of"
		if(3 to 5)
			return "a small amount of"
		if(6 to 10)
			return "a modest amount of"
		if(11 to 15)
			return "a moderate amount of"
		if(16 to 20)
			return "a respectable amount of"
		if(21 to 35)
			return "a serious amount of"
		if(36 to 50)
			return "a very serious amount of"
		if(51 to 100)
			return "a very lethal amount of"
		if(101 to 2000)
			return "a truly ruinous amount of"

/obj/item/proc/describe_throwpower()
	switch(throwforce)
		if(1 to 2)
			return "a very small amount of"
		if(3 to 5)
			return "a small amount of"
		if(6 to 10)
			return "a modest amount of"
		if(11 to 15)
			return "a respectable amount of"
		if(16 to 20)
			return "a serious amount of"
		if(21 to 100)
			return "a lot of"

/obj/item/proc/describe_penetration()
	switch(armor_penetration)
		if(0)
			return "cannot pierce armor"
		if(1 to 20)
			return "barely pierces armor"
		if(21 to 30)
			return "slightly pierces armor"
		if(31 to 40)
			return "reliably pierces lighter armors"
		if(41 to 50)
			return "pierces standard-issue armor reliably"
		if(51 to 60)
			return "pierces most armor reliably"
		if(61 to 70)
			return "pierces a great deal of armor"
		if(71 to 80)
			return "pierces the vast majority of armor"
		if(81 to 99)
			return "almost completely pierces all armor"
		if(100)
			return "completely and utterly pierces all armor"

/obj/item/proc/describe_speed()
	if(attackspeed > DEFAULT_ATTACK_COOLDOWN)
		return "a slow attack speed"
	else if(attackspeed < DEFAULT_ATTACK_COOLDOWN)
		return "a high attack speed"
	else
		return "an average attack speed"

/obj/item/get_description_info()
	var/weapon_stats = description_info + "\
	<br>"

	if(force)
		weapon_stats += "\nIf used in melee, it deals [describe_power()] [sharp ? "sharp" : "blunt"] damage, [describe_penetration()], and has [describe_speed()]."
	if(throwforce)
		weapon_stats += "\nIf thrown, it would deal [describe_throwpower()] [sharp ? "sharp" : "blunt"] damage."
	if(can_cleave)
		weapon_stats += "\nIt is capable of hitting multiple targets with a single swing."
	if(reach > 1)
		weapon_stats += "\nIt can attack targets up to [reach] tiles away, and can attack over certain objects."

	return weapon_stats