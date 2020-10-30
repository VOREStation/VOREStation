//////////////
//Defensive//
//////////////

/obj/item/mecha_parts/mecha_equipment/shocker
	name = "exosuit electrifier"
	desc = "A device to electrify the external portions of a mecha in order to increase its defensive capabilities."
	icon_state = "mecha_coil"
	equip_cooldown = 10
	energy_drain = 100
	range = RANGED
	origin_tech = list(TECH_COMBAT = 3, TECH_POWER = 6)
	var/shock_damage = 15
	var/active

	equip_type = EQUIP_HULL

/*
/obj/item/mecha_parts/mecha_equipment/shocker/can_attach(obj/mecha/M as obj)
	if(..())
		if(!M.proc_res["dynattackby"] && !M.proc_res["dynattackhand"] && !M.proc_res["dynattackalien"])
			return 1
	return 0

/obj/item/mecha_parts/mecha_equipment/shocker/attach(obj/mecha/M as obj)
	..()
	chassis.proc_res["dynattackby"] = src
	return
*/

/obj/item/mecha_parts/mecha_equipment/shocker/handle_melee_contact(var/obj/item/weapon/W, var/mob/living/user, var/inc_damage = null)
	if(!action_checks(user) || !active)
		return

	user.electrocute_act(shock_damage, src)
	return inc_damage
