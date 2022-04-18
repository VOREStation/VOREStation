/obj/mecha/combat/phazon
	desc = "An exosuit which can only be described as 'WTF?'."
	name = "Phazon"
	icon_state = "phazon"
	initial_icon = "phazon"
	step_in = 1
	dir_in = 1 //Facing North.
	step_energy_drain = 3
	health = 200		//God this is low
	maxhealth = 200		//Don't forget to update the /old variant if  you change this number.
	deflect_chance = 30
	damage_absorption = list("brute"=0.7,"fire"=0.7,"bullet"=0.7,"laser"=0.7,"energy"=0.7,"bomb"=0.7)
	max_temperature = 25000
	infra_luminosity = 3
	wreckage = /obj/effect/decal/mecha_wreckage/phazon
	add_req_access = 1
	//operation_req_access = list()
	internal_damage_threshold = 25
	force = 15
	max_equip = 4

	max_hull_equip = 3
	max_weapon_equip = 3
	max_utility_equip = 3
	max_universal_equip = 3
	max_special_equip = 4

	encumbrance_gap = 2

	starting_components = list(
		/obj/item/mecha_parts/component/hull/durable,
		/obj/item/mecha_parts/component/actuator,
		/obj/item/mecha_parts/component/armor/alien,
		/obj/item/mecha_parts/component/gas,
		/obj/item/mecha_parts/component/electrical
		)

	cloak_possible = TRUE
	phasing_possible = TRUE
	switch_dmg_type_possible = TRUE

/obj/mecha/combat/phazon/equipped/Initialize()
	. = ..()
	starting_equipment = list(
		/obj/item/mecha_parts/mecha_equipment/tool/rcd,
		/obj/item/mecha_parts/mecha_equipment/gravcatapult
		)
	return

/* Leaving this until we are really sure we don't need it for reference.
/obj/mecha/combat/phazon/Bump(var/atom/obstacle)
	if(phasing && get_charge()>=phasing_energy_drain)
		spawn()
			if(can_phase)
				can_phase = FALSE
				flick("[initial_icon]-phase", src)
				src.loc = get_step(src,src.dir)
				src.use_power(phasing_energy_drain)
				sleep(step_in*3)
				can_phase = TRUE
	else
		. = ..()
	return
*/


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
	phasing_energy_drain = 300

	max_hull_equip = 2
	max_weapon_equip = 1
	max_utility_equip = 2
	max_universal_equip = 2
	max_special_equip = 2

	phasing_possible = TRUE
	switch_dmg_type_possible = TRUE
	cloak_possible = FALSE

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

/obj/mecha/combat/phazon/janus/dynattackby(obj/item/W as obj, mob/user as mob)
	if(prob(max(1, (50 - round((W.force / 2) * damage_absorption["brute"])) * (1 - (W.armor_penetration / 100)))))
		src.occupant_message("<span class='alien'>The armor absorbs the incoming attack's force, negating it!</span>")
		src.visible_message("<span class='alien'>The [src.name] absorbs the incoming attack's force, negating it!</span>")
		src.log_append_to_last("Armor absorbed.")
		return

	..()

/obj/mecha/combat/phazon/janus/query_damtype()
	var/new_damtype = tgui_alert(src.occupant,"Gauntlet Phase Emitter Mode","Damage Type",list("Force","Energy","Stun"))
	switch(new_damtype)
		if("Force")
			damtype = "brute"
		if("Energy")
			damtype = "fire"
		if("Stun")
			damtype = "halloss"
	src.occupant_message("Melee damage type switched to [new_damtype]")
	return

//Meant for random spawns.
/obj/mecha/combat/phazon/old
	desc = "An exosuit which can only be described as 'WTF?'. This one is particularly worn looking and likely isn't as sturdy."

/obj/mecha/combat/phazon/old/New()
	..()
	health = 25
	maxhealth = 150	//Just slightly worse.
	cell.charge = rand(0, (cell.charge/2))