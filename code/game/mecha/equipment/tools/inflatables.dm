/obj/item/mecha_parts/mecha_equipment/tool/powertool/inflatables
	name = "inflatable deployment mechanism"
	desc = "An exosuit-mounted inflatable barrier deployer. Useful!"
	icon_state = "mecha_inflatables"
	origin_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3)
	equip_cooldown = 3
	energy_drain = 30
	range = MELEE
	equip_type = EQUIP_UTILITY
	ready_sound = 'sound/effects/spray.ogg'
	required_type = list(/obj/mecha/working/ripley)

	tooltype = /obj/item/inflatable_dispenser/robot
	var/obj/item/inflatable_dispenser/my_deployer = null

/obj/item/mecha_parts/mecha_equipment/tool/powertool/inflatables/Initialize()
	. = ..()
	my_deployer = my_tool

/obj/item/mecha_parts/mecha_equipment/tool/powertool/inflatables/Topic(href, href_list)
	..()
	if(href_list["toggle_deployable_mode"])
		my_deployer.attack_self()
		update_chassis_page()
	return

/obj/item/mecha_parts/mecha_equipment/tool/powertool/inflatables/get_equip_info()
	if(!chassis) return
	var/data_return = (equip_ready ? span_green("*") : span_red("*")) + "&nbsp;[chassis.selected==src?"<b>":"<a href='byond://?src=\ref[chassis];select_equip=\ref[src]'>"][src.name][chassis.selected==src?"</b>":"</a>"] - <a href='byond://?src=\ref[src];toggle_deployable_mode=1'>Deploy [my_deployer.mode?"Door":"Wall"]</a><br>\
	&nbsp; - Doors left: " + span_yellow("[my_deployer.stored_doors]") + "/[my_deployer.max_doors]<br>\
	&nbsp; - Walls left: " + span_yellow("[my_deployer.stored_walls]") + "/[my_deployer.max_walls]"

	return data_return

/obj/item/mecha_parts/mecha_equipment/tool/powertool/inflatables/action(atom/target, params)
	if(!action_checks(target))
		return

	if(istype(target, /turf))
		my_deployer.try_deploy_inflatable(target, chassis.occupant)
	if(istype(target, /obj/item/inflatable) || istype(target, /obj/structure/inflatable))
		my_deployer.pick_up(target, chassis.occupant)

	set_ready_state(FALSE)
	chassis.use_power(energy_drain)
	do_after_cooldown()
	return
