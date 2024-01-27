//
//Robotic Component Analyser, basically a health analyser for robots
//
/obj/item/device/robotanalyzer
	name = "cyborg analyzer"
	icon_state = "robotanalyzer"
	item_state = "analyzer"
	desc = "A hand-held scanner able to diagnose robotic injuries."
	slot_flags = SLOT_BELT
	throwforce = 3
	w_class = ITEMSIZE_SMALL
	throw_speed = 5
	throw_range = 10
	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 1, TECH_ENGINEERING = 2)
	matter = list(MAT_STEEL = 500, MAT_GLASS = 200)
	var/mode = 1;

/obj/item/device/robotanalyzer/attack(mob/living/M as mob, mob/living/user as mob)
	do_scan(M, user)

/obj/item/device/robotanalyzer/proc/do_scan(mob/living/M as mob, mob/living/user as mob)
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

	user.visible_message("<span class='notice'>\The [user] has analyzed [M]'s components.</span>","<span class='notice'>You have analyzed [M]'s components.</span>")
	switch(scan_type)
		if("robot")
			var/BU = M.getFireLoss() > 50 	? 	"<b>[M.getFireLoss()]</b>" 		: M.getFireLoss()
			var/BR = M.getBruteLoss() > 50 	? 	"<b>[M.getBruteLoss()]</b>" 	: M.getBruteLoss()
			user.show_message(span_blue("Analyzing Results for [M]:\n\t Overall Status: [M.stat > 1 ? "fully disabled" : "[M.health - M.halloss]% functional"]"))
			user.show_message("\t Key: [span_orange("Electronics")]/[span_red("Brute")]", 1)
			user.show_message("\t Damage Specifics: [span_orange("[BU]")] - [span_red("[BR]")]")
			if(M.tod && M.stat == DEAD)
				user.show_message(span_blue("Time of Disable: [M.tod]"))
			var/mob/living/silicon/robot/H = M
			var/list/damaged = H.get_damaged_components(1,1,1)
			user.show_message(span_blue("Localized Damage:"),1)
			if(length(damaged)>0)
				for(var/datum/robot_component/org in damaged)
					user.show_message(span_blue(text("\t []: [][] - [] - [] - []",	\
					span_blue(capitalize(org.name)),					\
					(org.installed == -1)	?	"[span_red("<b>DESTROYED</b>")] "					:"",\
					(org.electronics_damage > 0)	?	"[span_orange("[org.electronics_damage]")]"	:0,	\
					(org.brute_damage > 0)	?	"[span_red("[org.brute_damage]")]"					:0,	\
					(org.toggled)	?	"Toggled ON"	:	"[span_red("Toggled OFF")]",\
					(org.powered)	?	"Power ON"		:	"[span_red("Power OFF")]")),1)
			else
				user.show_message(span_blue("\t Components are OK."),1)
			if(H.emagged && prob(5))
				user.show_message(span_red("\t ERROR: INTERNAL SYSTEMS COMPROMISED"),1)
			user.show_message(span_blue("Operating Temperature: [M.bodytemperature-T0C]&deg;C ([M.bodytemperature*1.8-459.67]&deg;F)"), 1)

		if("prosthetics")

			var/mob/living/carbon/human/H = M
			to_chat(user, "<span class='notice'>Analyzing Results for \the [H]:</span>")
			if(H.isSynthetic())
				to_chat(user, "System instability: [span_green("[H.getToxLoss()]")]")
			to_chat(user, "Key: [span_orange("Electronics")]/[span_red("Brute")]")
			to_chat(user, "<span class='notice'>External prosthetics:</span>")
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
			to_chat(user, "<span class='notice'>Internal prosthetics:</span>")
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

			var/output = {"<span class='notice'>Analyzing Results for \the [Mecha]:</span><br>
				<b>Chassis Integrity: </b> [integrity]%<br>
				<b>Powercell charge: </b>[isnull(cell_charge)?"No powercell installed":"[Mecha.cell.percent()]%"]<br>
				<b>Air source: </b>[Mecha.use_internal_tank?"Internal Airtank":"Environment"]<br>
				<b>Airtank pressure: </b>[tank_pressure]kPa<br>
				<b>Airtank temperature: </b>[tank_temperature]K|[tank_temperature - T0C]&deg;C<br>
				<b>Cabin pressure: </b>[cabin_pressure>WARNING_HIGH_PRESSURE ? span_red("[cabin_pressure]"): cabin_pressure]kPa<br>
				<b>Cabin temperature: </b> [Mecha.return_temperature()]K|[Mecha.return_temperature() - T0C]&deg;C<br>
				<b>DNA Lock: </b> [Mecha.dna?"Mecha.dna":"Not Found"]<br>
				"}

			to_chat(user, output)
			to_chat(user, "<hr>")
			to_chat(user, "<span class='notice'>Internal Diagnostics:</span>")
			for(var/slot in Mecha.internal_components)
				var/obj/item/mecha_parts/component/MC = Mecha.internal_components[slot]
				to_chat(user, "[MC?"[slot]: [MC] <span class='notice'>[round((MC.integrity / MC.max_integrity) * 100, 0.1)]%</span> integrity. [MC.get_efficiency() * 100] Operational capacity.":"<span class='warning'>[slot]: Component Not Found</span>"]")

			to_chat(user, "<hr>")
			to_chat(user, "<span class='notice'>General Statistics:</span>")
			to_chat(user, "<span class='notice'>Movement Weight: [Mecha.get_step_delay()]</span><br>")

	src.add_fingerprint(user)
	return
