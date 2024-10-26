//
//Robotic Component Analyser, basically a health analyser for robots
//
/obj/item/robotanalyzer
	name = "cyborg analyzer"
	icon = 'icons/obj/device.dmi'
	icon_state = "robotanalyzer"
	item_state = "analyzer"
	desc = "A hand-held scanner able to diagnose robotic injuries."
	description_info = "Alt-click to toggle between robot analysis and robot module scan mode."
	slot_flags = SLOT_BELT
	throwforce = 3
	w_class = ITEMSIZE_SMALL
	throw_speed = 5
	throw_range = 10
	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 1, TECH_ENGINEERING = 2)
	matter = list(MAT_STEEL = 500, MAT_GLASS = 200)
	var/mode = 1;
	pickup_sound = 'sound/items/pickup/device.ogg'
	drop_sound = 'sound/items/drop/device.ogg'

/obj/item/robotanalyzer/attack(mob/living/M as mob, mob/living/user as mob)
	do_scan(M, user)

/obj/item/robotanalyzer/AltClick(mob/user)
	mode = !mode
	user.show_message(span_blue("[mode ? "Toggled to cyborg analyzing mode." : "Toggled to cyborg upgrade scan mode."]"), 1)

/obj/item/robotanalyzer/proc/do_scan(mob/living/M as mob, mob/living/user as mob)
	if((CLUMSY in user.mutations) && prob(50))
		to_chat(user, span_red("You try to analyze the floor's vitals!"))
		for(var/mob/O in viewers(M, null))
			O.show_message(span_red(text("[user] has analyzed the floor's vitals!")), 1)
		user.show_message(span_blue(text("Analyzing Results for The floor:\n\t Overall Status: Healthy")), 1)
		user.show_message(span_blue(text("\t Damage Specifics: [0]-[0]-[0]-[0]")), 1)
		user.show_message(span_blue("Key: Suffocation/Toxin/Burns/Brute"), 1)
		user.show_message(span_blue("Body Temperature: ???"), 1)
		return

	var/scan_type
	if(istype(M, /mob/living/silicon/robot))
		scan_type = "robot"
	else if(istype(M, /mob/living/carbon/human))
		scan_type = "prosthetics"
	else if(istype(M, /obj/mecha))
		scan_type = "mecha"
	else
		to_chat(user, span_red("You can't analyze non-robotic things!"))
		return

	user.visible_message(span_notice("\The [user] has analyzed [M]'s components."),span_notice("You have analyzed [M]'s components."))
	switch(scan_type)
		if("robot")
			if(mode)
				var/BU = M.getFireLoss() > 50 	? 	span_bold("[M.getFireLoss()]") 		: M.getFireLoss()
				var/BR = M.getBruteLoss() > 50 	? 	span_bold("[M.getBruteLoss()]") 	: M.getBruteLoss()
				user.show_message(span_blue("Analyzing Results for [M]:\n\t Overall Status: [M.stat > 1 ? "fully disabled" : "[M.health - M.halloss]% functional"]"))
				user.show_message("\t Key: [span_orange("Electronics")]/[span_red("Brute")]", 1)
				user.show_message("\t Damage Specifics: [span_orange("[BU]")] - [span_red("[BR]")]")
				if(M.tod && M.stat == DEAD)
					user.show_message(span_blue("Time of Disable: [M.tod]"))
				var/mob/living/silicon/robot/R = M
				var/obj/item/cell/cell = R.get_cell()
				if(cell)
					var/cell_charge = round(cell.percent())
					var/cell_text
					if(cell_charge > 60)
						cell_text = span_green("[cell_charge]")
					else if (cell_charge > 30)
						cell_text = span_yellow("[cell_charge]")
					else if (cell_charge > 10)
						cell_text = span_orange("[cell_charge]")
					else if (cell_charge > 1)
						cell_text = span_red("[cell_charge]")
					else
						cell_text = span_red(span_bold("[cell_charge]"))
					user.show_message("\t Power Cell Status: [span_blue("[capitalize(cell.name)]")] at [cell_text]% charge")
				var/list/damaged = R.get_damaged_components(1,1,1)
				user.show_message(span_blue("Localized Damage:"),1)
				if(length(damaged)>0)
					for(var/datum/robot_component/org in damaged)
						user.show_message(span_blue(text("\t []: [][] - [] - [] - []",	\
						span_blue(capitalize(org.name)),					\
						(org.installed == -1)	?	"[span_red(span_bold("DESTROYED"))] "					:"",\
						(org.electronics_damage > 0)	?	"[span_orange("[org.electronics_damage]")]"	:0,	\
						(org.brute_damage > 0)	?	"[span_red("[org.brute_damage]")]"					:0,	\
						(org.toggled)	?	"Toggled ON"	:	"[span_red("Toggled OFF")]",\
						(org.powered)	?	"Power ON"		:	"[span_red("Power OFF")]")),1)
				else
					user.show_message(span_blue("\t Components are OK."),1)
				if(R.emagged && prob(5))
					user.show_message(span_red("\t ERROR: INTERNAL SYSTEMS COMPROMISED"),1)
				user.show_message(span_blue("Operating Temperature: [M.bodytemperature-T0C]&deg;C ([M.bodytemperature*1.8-459.67]&deg;F)"), 1)
			else
				var/mob/living/silicon/robot/R = M
				var/obj/item/cell/cell = R.get_cell()
				user.show_message(span_blue("Upgrade Analyzing Results for [M]:"))
				if(cell)
					user.show_message("\t Power Cell Details: [span_blue("[capitalize(cell.name)]")] with a capacity of [cell.maxcharge] at [round(cell.percent())]% charge")
				var/show_title = TRUE
				for(var/datum/design/item/prosfab/robot_upgrade/utility/upgrade)
					var/obj/item/borg/upgrade/utility/upgrade_type = initial(upgrade.build_path)
					var/needs_module = initial(upgrade_type.require_module)
					if((!R.module && needs_module) || !initial(upgrade.name) || (R.stat != DEAD && (upgrade_type == /obj/item/borg/upgrade/utility/restart)) || (isshell(R) && (upgrade_type == /obj/item/borg/upgrade/utility/rename)))
						continue
					if(show_title)
						user.show_message("\t Utility Modules, used for modifying purposes:")
						show_title = FALSE
					if(R.stat == DEAD)
						if(initial(upgrade.name) == "Emergency Restart Module")
							user.show_message(span_blue("\t\t [capitalize(initial(upgrade.name))]: [span_green("Usable")]"))
					else
						user.show_message(span_blue("\t\t [capitalize(initial(upgrade.name))]: [span_green("Usable")]"))
				show_title = TRUE
				for(var/datum/design/item/prosfab/robot_upgrade/basic/upgrade)
					var/obj/item/borg/upgrade/basic/upgrade_type = initial(upgrade.build_path)
					var/needs_module = initial(upgrade_type.require_module)
					if((!R.module && needs_module) || !initial(upgrade.name) || R.stat == DEAD)
						continue
					if(show_title)
						user.show_message("\t Basic Modules, used for direct upgrade purposes:")
						show_title = FALSE
					if(R.has_basic_upgrade(initial(upgrade.build_path)) == "")
						user.show_message(span_blue("\t\t [capitalize(initial(upgrade.name))]: [span_red(span_bold("ERROR"))]"))
					else
						user.show_message(span_blue("\t\t [capitalize(initial(upgrade.name))]: [R.has_basic_upgrade(initial(upgrade.build_path)) ? span_green("Installed") : span_red("Missing")]"))
				show_title = TRUE
				for(var/datum/design/item/prosfab/robot_upgrade/advanced/upgrade)
					var/obj/item/borg/upgrade/advanced/upgrade_type = initial(upgrade.build_path)
					var/needs_module = initial(upgrade_type.require_module)
					if((!R.module && needs_module) || !initial(upgrade.name) || R.stat == DEAD)
						continue
					if(show_title)
						user.show_message("\t Advanced Modules, used for module upgrade purposes:")
						show_title = FALSE
					if(R.has_advanced_upgrade(initial(upgrade.build_path)) == "")
						user.show_message(span_blue("\t\t [capitalize(initial(upgrade.name))]: [span_red(span_bold("ERROR"))]"))
					else
						user.show_message(span_blue("\t\t [capitalize(initial(upgrade.name))]: [R.has_advanced_upgrade(initial(upgrade.build_path)) ? span_green("Installed") : span_red("Missing")]"))
				show_title = TRUE
				for(var/datum/design/item/prosfab/robot_upgrade/restricted/upgrade)
					var/obj/item/borg/upgrade/restricted/upgrade_type = initial(upgrade.build_path)
					var/needs_module = initial(upgrade_type.require_module)
					if((!R.module && needs_module) || !initial(upgrade.name) || !R.supports_upgrade(initial(upgrade.build_path)) || R.stat == DEAD)
						continue
					if(show_title)
						user.show_message("\t Restricted Modules, used for module upgrade purposes on specific chassis:")
						show_title = FALSE
					if(R.has_restricted_upgrade(initial(upgrade.build_path)) == "")
						user.show_message(span_blue("\t\t [capitalize(initial(upgrade.name))]: [span_red(span_bold("ERROR"))]"))
					else
						user.show_message(span_blue("\t\t [capitalize(initial(upgrade.name))]: [R.has_restricted_upgrade(initial(upgrade.build_path)) ? span_green("Installed") : span_red("Missing")]"))
				show_title = TRUE
				for(var/datum/design/item/prosfab/robot_upgrade/no_prod/upgrade)
					var/obj/item/borg/upgrade/no_prod/upgrade_type = initial(upgrade.build_path)
					var/needs_module = initial(upgrade_type.require_module)
					var/hidden = initial(upgrade_type.hidden_from_scan)
					if((!R.module && needs_module) || !initial(upgrade.name) || hidden || R.stat == DEAD)
						continue
					if(show_title)
						user.show_message("\t Special Modules, used for recreation purposes:")
						show_title = FALSE
					if(R.has_no_prod_upgrade(initial(upgrade.build_path)) == "")
						user.show_message(span_blue("\t\t [capitalize(initial(upgrade.name))]: [span_red(span_bold("ERROR"))]"))
					else
						user.show_message(span_blue("\t\t [capitalize(initial(upgrade.name))]: [R.has_no_prod_upgrade(initial(upgrade.build_path)) ? span_green("Installed") : span_red("Missing")]"))

		if("prosthetics")

			var/mob/living/carbon/human/H = M
			to_chat(user, span_notice("Analyzing Results for \the [H]:"))
			if(H.isSynthetic())
				to_chat(user, "System instability: [span_green("[H.getToxLoss()]")]")
			to_chat(user, "Key: [span_orange("Electronics")]/[span_red("Brute")]")
			to_chat(user, span_notice("External prosthetics:"))
			var/organ_found
			if(H.internal_organs.len)
				for(var/obj/item/organ/external/E in H.organs)
					if(!(E.robotic >= ORGAN_ROBOT))
						continue
					organ_found = 1
					to_chat(user, "[E.name]: [span_red("[E.brute_dam] ")] [span_orange("[E.burn_dam]")]")
			if(!organ_found)
				to_chat(user, "No prosthetics located.")
			to_chat(user, "<hr>")
			to_chat(user, span_notice("Internal prosthetics:"))
			organ_found = null
			if(H.internal_organs.len)
				for(var/obj/item/organ/O in H.internal_organs)
					if(!(O.robotic >= ORGAN_ROBOT))
						continue
					organ_found = 1
					to_chat(user, "[O.name]: [span_red("[O.damage]")]")
			if(!organ_found)
				to_chat(user, "No prosthetics located.")

		if("mecha")

			var/obj/mecha/Mecha = M

			var/integrity = Mecha.health/initial(Mecha.health)*100
			var/cell_charge = Mecha.get_charge()
			var/tank_pressure = Mecha.internal_tank ? round(Mecha.internal_tank.return_pressure(),0.01) : "None"
			var/tank_temperature = Mecha.internal_tank ? Mecha.internal_tank.return_temperature() : "Unknown"
			var/cabin_pressure = round(Mecha.return_pressure(),0.01)

			var/output = span_notice("Analyzing Results for \the [Mecha]:") + {"<br>
				<b>Chassis Integrity: </b> [integrity]%<br>
				<b>Powercell charge: </b>[isnull(cell_charge)?"No powercell installed":"[capitalize(initial(Mecha.cell.name))] at [Mecha.cell.percent()]%"]<br>
				<b>Air source: </b>[Mecha.use_internal_tank?"Internal Airtank":"Environment"]<br>
				<b>Airtank pressure: </b>[tank_pressure]kPa<br>
				<b>Airtank temperature: </b>[tank_temperature]K|[tank_temperature - T0C]&deg;C<br>
				<b>Cabin pressure: </b>[cabin_pressure>WARNING_HIGH_PRESSURE ? span_red("[cabin_pressure]"): cabin_pressure]kPa<br>
				<b>Cabin temperature: </b> [Mecha.return_temperature()]K|[Mecha.return_temperature() - T0C]&deg;C<br>
				<b>DNA Lock: </b> [Mecha.dna?"Mecha.dna":"Not Found"]<br>
				"}

			to_chat(user, output)
			to_chat(user, "<hr>")
			to_chat(user, span_notice("Internal Diagnostics:"))
			for(var/slot in Mecha.internal_components)
				var/obj/item/mecha_parts/component/MC = Mecha.internal_components[slot]
				to_chat(user, "[MC? ("[slot]: [MC] " + span_notice("[round((MC.integrity / MC.max_integrity) * 100, 0.1)]%") + " integrity. [MC.get_efficiency() * 100] Operational capacity.") : span_warning("[slot]: Component Not Found")]")

			to_chat(user, "<hr>")
			to_chat(user, span_notice("General Statistics:"))
			to_chat(user, span_notice("Movement Weight: [Mecha.get_step_delay()]") + "<br>")

	src.add_fingerprint(user)
	return
