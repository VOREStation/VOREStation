/mob/living/carbon/human
	var/datum/unarmed_attack/default_attack

/mob/living/carbon/human/verb/check_attacks()
	set name = "Check Attacks"
	set category = "IC"
	set src = usr

	var/dat = "<b><font size = 5>Known Attacks</font></b><br/><br/>"

	for(var/datum/unarmed_attack/u_attack in species.unarmed_attacks)
		dat += "<b>Primarily [u_attack.attack_name] </b><br/><br/><br/>"

	src << browse(dat, "window=checkattack")
	return

/mob/living/carbon/human/check_attacks()
	var/dat = "<b><font size = 5>Known Attacks</font></b><br/><br/>"

	if(default_attack)
		dat += "Current default attack: [default_attack.attack_name] - <a href='byond://?src=\ref[src];default_attk=reset_attk'>reset</a><br/><br/>"

	for(var/datum/unarmed_attack/u_attack in species.unarmed_attacks)
		if(u_attack == default_attack)
			dat += "<b>Primarily [u_attack.attack_name]</b> - default - <a href='byond://?src=\ref[src];default_attk=reset_attk'>reset</a><br/><br/><br/>"
		else
			dat += "<b>Primarily [u_attack.attack_name]</b> - <a href='byond://?src=\ref[src];default_attk=\ref[u_attack]'>set default</a><br/><br/><br/>"

	src << browse(dat, "window=checkattack")

/mob/living/carbon/human/Topic(href, href_list)
	if(href_list["default_attk"])
		if(href_list["default_attk"] == "reset_attk")
			set_default_attack(null)
		else
			var/datum/unarmed_attack/u_attack = locate(href_list["default_attk"])
			if(u_attack && (u_attack in species.unarmed_attacks))
				set_default_attack(u_attack)
		check_attacks()
		return 1
	else
		return ..()

/mob/living/carbon/human/proc/set_default_attack(var/datum/unarmed_attack/u_attack)
	default_attack = u_attack

/datum/unarmed_attack
	var/attack_name = "fist"

/datum/unarmed_attack
	bite/attack_name = "bite"
	bite/sharp/attack_name = "sharp bite"
	bite/strong/attack_name = "strong bite"
	punch/attack_name = "punch"
	kick/attack_name = "kick"
	stomp/attack_name = "stomp"
	stomp/weak/attack_name = "weak stomp"
	light_strike/attack_name = "light hit"
	diona attack_name = "tendrils"
	claws/attack_name = "claws"
	claws/strong/attack_name = "strong claws"
	slime_glomp/attack_name = "glomp"
	bite/sharp/numbing/attack_name = "numbing bite"