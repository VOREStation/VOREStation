/obj/mecha/combat/phazon
	desc = "An exosuit which can only be described as 'WTF?'."
	name = "Phazon"
	icon_state = "phazon"
	initial_icon = "phazon"
	step_in = 1
	dir_in = 1 //Facing North.
	step_energy_drain = 3
	health = 200
	maxhealth = 200
	deflect_chance = 30
	damage_absorption = list("brute"=0.7,"fire"=0.7,"bullet"=0.7,"laser"=0.7,"energy"=0.7,"bomb"=0.7)
	max_temperature = 25000
	infra_luminosity = 3
	wreckage = /obj/effect/decal/mecha_wreckage/phazon
	add_req_access = 1
	//operation_req_access = list()
	internal_damage_threshold = 25
	force = 15
	var/phasing = 0
	var/phasing_energy_drain = 200
	max_equip = 4

	max_hull_equip = 3
	max_weapon_equip = 3
	max_utility_equip = 3
	max_universal_equip = 3
	max_special_equip = 4

/obj/mecha/combat/phazon/equipped/New()
	..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/tool/rcd
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/gravcatapult
	ME.attach(src)
	return

/obj/mecha/combat/phazon/Bump(var/atom/obstacle)
	if(phasing && get_charge()>=phasing_energy_drain)
		spawn()
			if(can_move)
				can_move = 0
				flick("[initial_icon]-phase", src)
				src.loc = get_step(src,src.dir)
				src.use_power(phasing_energy_drain)
				sleep(step_in*3)
				can_move = 1
	else
		. = ..()
	return

/obj/mecha/combat/phazon/click_action(atom/target,mob/user)
	if(phasing)
		src.occupant_message("Unable to interact with objects while phasing")
		return
	else
		return ..()

/obj/mecha/combat/phazon/verb/switch_damtype()
	set category = "Exosuit Interface"
	set name = "Change melee damage type"
	set src = usr.loc
	set popup_menu = 0
	if(usr!=src.occupant)
		return

	query_damtype()

/obj/mecha/combat/phazon/proc/query_damtype()
	var/new_damtype = alert(src.occupant,"Melee Damage Type",null,"Brute","Fire","Toxic")
	switch(new_damtype)
		if("Brute")
			damtype = "brute"
		if("Fire")
			damtype = "fire"
		if("Toxic")
			damtype = "tox"
	src.occupant_message("Melee damage type switched to [new_damtype ]")
	return

/obj/mecha/combat/phazon/get_commands()
	var/output = {"<div class='wr'>
						<div class='header'>Special</div>
						<div class='links'>
						<a href='?src=\ref[src];phasing=1'><span id="phasing_command">[phasing?"Dis":"En"]able phasing</span></a><br>
						<a href='?src=\ref[src];switch_damtype=1'>Change melee damage type</a><br>
						</div>
						</div>
						"}
	output += ..()
	return output

/obj/mecha/combat/phazon/Topic(href, href_list)
	..()
	if (href_list["switch_damtype"])
		src.switch_damtype()
	if (href_list["phasing"])
		phasing = !phasing
		send_byjax(src.occupant,"exosuit.browser","phasing_command","[phasing?"Dis":"En"]able phasing")
		src.occupant_message("<font color=\"[phasing?"#00f\">En":"#f00\">Dis"]abled phasing.</font>")
	return

/obj/mecha/combat/phazon/janus
	name = "Phazon Prototype Janus Class"
	desc = "An exosuit which a more crude civilization such as yours might describe as WTF?."
	description_fluff = "An incredibly high-tech exosuit constructed out of salvaged alien and cutting-edge modern technology.\
	This machine, theoretically, is capable of travelling through time, however due to the strange nature of its miniaturized \
	supermatter-fueled bluespace drive, it is uncertain how this ability manifests."
	icon_state = "janus"
	initial_icon = "janus"
	step_in = 1
	dir_in = 1 //Facing North.
	step_energy_drain = 3
	health = 350
	maxhealth = 350
	deflect_chance = 30
	damage_absorption = list("brute"=0.6,"fire"=0.7,"bullet"=0.7,"laser"=0.9,"energy"=0.7,"bomb"=0.5)
	max_temperature = 10000
	infra_luminosity = 3
	wreckage = /obj/effect/decal/mecha_wreckage/janus
	internal_damage_threshold = 25
	force = 20
	phasing = FALSE
	phasing_energy_drain = 300

	max_hull_equip = 2
	max_weapon_equip = 1
	max_utility_equip = 2
	max_universal_equip = 2
	max_special_equip = 2

/obj/mecha/combat/phazon/janus/take_damage(amount, type="brute")
	..()
	if(phasing)
		phasing = FALSE
		SSradiation.radiate(get_turf(src), 30)
		log_append_to_last("WARNING: BLUESPACE DRIVE INSTABILITY DETECTED. DISABLING DRIVE.",1)
		visible_message("<span class='alien'>The [src.name] appears to flicker, before its silhouette stabilizes!</span>")
	return

/obj/mecha/combat/phazon/janus/dynbulletdamage(var/obj/item/projectile/Proj)
	if((Proj.damage && !Proj.nodamage) && !istype(Proj, /obj/item/projectile/beam) && prob(max(1, 33 - round(Proj.damage / 4))))
		src.occupant_message("<span class='alien'>The armor absorbs the incoming projectile's force, negating it!</span>")
		src.visible_message("<span class='alien'>The [src.name] absorbs the incoming projectile's force, negating it!</span>")
		src.log_append_to_last("Armor negated.")
		return
	else if((Proj.damage && !Proj.nodamage) && istype(Proj, /obj/item/projectile/beam) && prob(max(1, (50 - round((Proj.damage / 2) * damage_absorption["laser"])) * (1 - (Proj.armor_penetration / 100)))))	// Base 50% chance to deflect a beam,lowered by half the beam's damage scaled to laser absorption, then multiplied by the remaining percent of non-penetrated armor, with a minimum chance of 1%.
		src.occupant_message("<span class='alien'>The armor reflects the incoming beam, negating it!</span>")
		src.visible_message("<span class='alien'>The [src.name] reflects the incoming beam, negating it!</span>")
		src.log_append_to_last("Armor reflected.")
		return

	..()

/obj/mecha/combat/phazon/janus/dynattackby(obj/item/weapon/W as obj, mob/user as mob)
	if(prob(max(1, (50 - round((W.force / 2) * damage_absorption["brute"])) * (1 - (W.armor_penetration / 100)))))
		src.occupant_message("<span class='alien'>The armor absorbs the incoming attack's force, negating it!</span>")
		src.visible_message("<span class='alien'>The [src.name] absorbs the incoming attack's force, negating it!</span>")
		src.log_append_to_last("Armor absorbed.")
		return

	..()

/obj/mecha/combat/phazon/janus/query_damtype()
	var/new_damtype = alert(src.occupant,"Gauntlet Phase Emitter Mode",null,"Force","Energy","Stun")
	switch(new_damtype)
		if("Force")
			damtype = "brute"
		if("Energy")
			damtype = "fire"
		if("Stun")
			damtype = "halloss"
	src.occupant_message("Melee damage type switched to [new_damtype]")
	return
