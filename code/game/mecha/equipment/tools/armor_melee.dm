/obj/item/mecha_parts/mecha_equipment/anticcw_armor_booster //what is that noise? A BAWWW from TK mutants.
	name = "\improper CCW armor booster"
	desc = "Close-combat armor booster. Boosts exosuit armor against armed melee attacks. Requires energy to operate."
	icon_state = "mecha_abooster_ccw"
	origin_tech = list(TECH_MATERIAL = 3)
	equip_cooldown = 10
	energy_drain = 50
	range = 0
	var/deflect_coeff = 1.15
	var/damage_coeff = 0.8

	step_delay = 0.5

	equip_type = EQUIP_HULL

/obj/item/mecha_parts/mecha_equipment/anticcw_armor_booster/get_equip_info()
	if(!chassis) return
	return "<span style=\"color:[equip_ready?"#0f0":"#f00"];\">*</span>&nbsp;[src.name]"

/obj/item/mecha_parts/mecha_equipment/anticcw_armor_booster/handle_melee_contact(var/obj/item/weapon/W, var/mob/living/user, var/inc_damage = null)
	if(!action_checks(user))
		return inc_damage
	chassis.log_message("Attacked by [W]. Attacker - [user]")
	if(prob(chassis.deflect_chance*deflect_coeff))
		to_chat(user, "<span class='danger'>\The [W] bounces off \the [chassis]'s armor.</span>")
		chassis.log_append_to_last("Armor saved.")
		inc_damage = 0
	else
		chassis.occupant_message("<span class='danger'>\The [user] hits [chassis] with [W].</span>")
		user.visible_message("<span class='danger'>\The [user] hits [chassis] with [W].</span>", "<span class='danger'>You hit [src] with [W].</span>")
		inc_damage *= damage_coeff
	set_ready_state(FALSE)
	chassis.use_power(energy_drain)
	spawn()
		do_after_cooldown()
	return max(0, inc_damage)

/*

/obj/item/mecha_parts/mecha_equipment/anticcw_armor_booster/can_attach(obj/mecha/M as obj)
	if(..())
		if(!M.proc_res["dynattackby"])
			return 1
	return 0

/obj/item/mecha_parts/mecha_equipment/anticcw_armor_booster/attach(obj/mecha/M as obj)
	..()
	chassis.proc_res["dynattackby"] = src
	return

/obj/item/mecha_parts/mecha_equipment/anticcw_armor_booster/detach()
	chassis.proc_res["dynattackby"] = null
	..()
	return

/obj/item/mecha_parts/mecha_equipment/anticcw_armor_booster/proc/dynattackby(obj/item/weapon/W as obj, mob/user as mob)
	if(!action_checks(user))
		return chassis.dynattackby(W,user)
	chassis.log_message("Attacked by [W]. Attacker - [user]")
	if(prob(chassis.deflect_chance*deflect_coeff))
		to_chat(user, "<span class='danger'>\The [W] bounces off [chassis] armor.</span>")
		chassis.log_append_to_last("Armor saved.")
	else
		chassis.occupant_message("<span class='danger'>\The [user] hits [chassis] with [W].</span>")
		user.visible_message("<span class='danger'>\The [user] hits [chassis] with [W].</span>", "<span class='danger'>You hit [src] with [W].</span>")
		chassis.take_damage(round(W.force*damage_coeff),W.damtype)
		chassis.check_for_internal_damage(list(MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST))
	set_ready_state(FALSE)
	chassis.use_power(energy_drain)
	do_after_cooldown()
	return
*/
