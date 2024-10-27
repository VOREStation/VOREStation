/obj/item/mecha_parts/mecha_equipment/weapon/honker
	name = "sound emission device"
	desc = "A perfectly normal bike-horn, for your exosuit."
	icon_state = "mecha_honker"
	energy_drain = 300
	equip_cooldown = 150
	origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 4, TECH_ILLEGAL = 1)

	equip_type = EQUIP_SPECIAL

/obj/item/mecha_parts/mecha_equipment/weapon/honker/action(target)
	if(!chassis)
		return 0
	if(energy_drain && chassis.get_charge() < energy_drain)
		return 0
	if(!equip_ready)
		return 0

	playsound(src, 'sound/effects/bang.ogg', 30, 1, 30)
	chassis.occupant_message(span_warning("You emit a high-pitched noise from the mech."))
	for(var/mob/living/carbon/M in ohearers(6, chassis))
		if(istype(M, /mob/living/carbon/human))
			var/ear_safety = 0
			ear_safety = M.get_ear_protection()
			if(ear_safety > 0)
				return
		to_chat(M, span_warning("Your ears feel like they're bleeding!"))
		playsound(M, 'sound/effects/bang.ogg', 70, 1, 30)
		M.SetSleeping(0)
		M.ear_deaf += 30
		M.ear_damage += rand(5, 20)
		M.Weaken(3)
		M.Stun(5)
	chassis.use_power(energy_drain)
	log_message("Used a sound emission device.")
	do_after_cooldown()
	return
