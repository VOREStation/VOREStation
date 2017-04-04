#define TRICORDER_IDLE "Idle"
#define TRICORDER_ATMOS "Atmos"
#define TRICORDER_HEALTH_VAGUE "Health"

/obj/item/device/tricorder
	name = "tricorder"
	desc = "A hand-held scanning device used for various utility functions."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "tricorder0"
	item_state = "tricorder0"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	throwforce = 1
	w_class = ITEMSIZE_SMALL
	throw_speed = 5
	throw_range = 10
	matter = list(DEFAULT_WALL_MATERIAL = 200)
	origin_tech = list(TECH_MAGNET = 1, TECH_BIO = 1)
	var/list/settings = list(TRICORDER_ATMOS, TRICORDER_HEALTH_VAGUE, TRICORDER_IDLE)
	var/mode
	var/scanmode = 0
	var/scanning = 0

/obj/item/device/tricorder/attack_self(mob/user)
	mode = !mode
	icon_state = "tricorder[mode]"
	if(mode)
		user << "<span class='notice'>You turn on \the [src].</span>"
	else
		user << "<span class='notice'>You turn off \the [src].</span>"

/obj/item/device/tricorder/attack(atom/A, mob/user)
	scan(A, user)

/obj/item/device/tricorder/verb/toggle_mode()
	set name = "Switch Modes"
	set category = "Object"

	if(usr.stat || !usr.canmove || usr.restrained())
		return

	mode = input("Which setting do you want to use?", "Tricorder", mode) in settings
	switch (mode)
		if(TRICORDER_HEALTH_VAGUE)
			to_chat(usr,"The scanner will support minimal health analysis.")
		if(TRICORDER_ATMOS)
			to_chat(usr, "The scanner now shows atmospheric data.")
		if(TRICORDER_IDLE)
			to_chat(usr, "The scanner now in idle.")

/obj/item/device/tricorder/proc/scan(atom/A, mob/user, mob/living/M, var/obj/target, var/datum/gas_mixture/mixture)
	set waitfor = 0

	if(!scanning)
		// Can remotely scan objects and mobs.
		if(!in_range(A, user) && !(A in view(world.view, user)))
			return
		if(loc != user)
			return

		scanning = 1
		icon_state = "tricorder1_s"

		user.visible_message("\The [user] points the [src.name] at \the [A] and performs a remote scan.")
		to_chat(user, "<span class='notice'>You scan \the [A]. The scanner is now analysing the results...</span>")

		if(scanmode == TRICORDER_IDLE)
			return

		if(scanmode == TRICORDER_ATMOS) //Atmosia scanning
			if(do_after(user, 20))
				var/pressure = mixture.return_pressure()
				var/total_moles = mixture.total_moles

				var/list/results = list()
				if (total_moles>0)
					results += "<span class='notice'>Pressure: [round(pressure,0.1)] kPa</span>"
					for(var/mix in mixture.gas)
						results += "<span class='notice'>[gas_data.name[mix]]: [round((mixture.gas[mix] / total_moles) * 100)]%</span>"
					results += "<span class='notice'>Temperature: [round(mixture.temperature-T0C)]&deg;C</span>"
				else
					results += "<span class='notice'>\The [target] is empty!</span>"

				return results

		if(scanmode == TRICORDER_HEALTH_VAGUE) //vague medical scanning
			if (!istype(M,/mob/living/carbon/human) || M.isSynthetic())
				user.show_message("<span class='notice'>ERROR: Nonbiological lifeform in scan target.</span>")
				return
			if(do_after(user, 20))
				var/fake_oxy = max(rand(1,40), M.getOxyLoss(), (300 - (M.getToxLoss() + M.getFireLoss() + M.getBruteLoss())))
				var/OX = M.getOxyLoss() > 50 	? 	"<b>[M.getOxyLoss()]</b>" 		: M.getOxyLoss()
				var/TX = M.getToxLoss() > 50 	? 	"<b>[M.getToxLoss()]</b>" 		: M.getToxLoss()
				var/BU = M.getFireLoss() > 50 	? 	"<b>[M.getFireLoss()]</b>" 		: M.getFireLoss()
				var/BR = M.getBruteLoss() > 50 	? 	"<b>[M.getBruteLoss()]</b>" 	: M.getBruteLoss()
				if(M.status_flags & FAKEDEATH)
					OX = fake_oxy > 50 			? 	"<b>[fake_oxy]</b>" 			: fake_oxy
					user.show_message("<span class='notice'>Analyzing Results for [M]:</span>")
					user.show_message("<span class='notice'>Overall Status: dead</span>")
				else
					user.show_message("<span class='notice'>Analyzing Results for [M]:\n\t Overall Status: [M.stat > 1 ? "dead" : "[round((M.health/M.maxHealth)*100) ]% healthy"]</span>")
				user.show_message("<span class='notice'>    Key: <font color='cyan'>Suffocation</font>/<font color='green'>Toxin</font>/<font color='#FFA500'>Burns</font>/<font color='red'>Brute</font></span>", 1)
				user.show_message("<span class='notice'>    Damage Specifics: <font color='cyan'>[OX]</font> - <font color='green'>[TX]</font> - <font color='#FFA500'>[BU]</font> - <font color='red'>[BR]</font></span>")
				user.show_message("<span class='notice'>Body Temperature: [M.bodytemperature-T0C]&deg;C ([M.bodytemperature*1.8-459.67]&deg;F)</span>", 1)
				OX = M.getOxyLoss() > 50 ? 	"<font color='cyan'><b>Severe oxygen deprivation detected</b></font>" 		: 	"Subject bloodstream oxygen level normal"
				TX = M.getToxLoss() > 50 ? 	"<font color='green'><b>Dangerous amount of toxins detected</b></font>" 	: 	"Subject bloodstream toxin level minimal"
				BU = M.getFireLoss() > 50 ? 	"<font color='#FFA500'><b>Severe burn damage detected</b></font>" 			:	"Subject burn injury status O.K"
				BR = M.getBruteLoss() > 50 ? "<font color='red'><b>Severe anatomical damage detected</b></font>" 		: 	"Subject brute-force injury status O.K"
				if(M.status_flags & FAKEDEATH)
					OX = fake_oxy > 50 ? 		"<span class='warning'>Severe oxygen deprivation detected</span>" 	: 	"Subject bloodstream oxygen level normal"
				user.show_message("[OX] | [TX] | [BU] | [BR]")
				return

	scanning = 0
	icon_state = "tricorder1"

/obj/structure/cable/attackby(obj/item/W, mob/user)
	. = ..()
	if(istype(W, /obj/item/device/tricorder))

		if(powernet && (powernet.avail > 0))		// is it powered?
			user << "<span class='warning'>[powernet.avail]W in power network.</span>"

		else
			user << "<span class='warning'>The cable is not powered.</span>"

/proc/tricordatmosanalyzer_scan(var/obj/target, var/datum/gas_mixture/mixture, var/mob/user)
	var/pressure = mixture.return_pressure()
	var/total_moles = mixture.total_moles

	var/list/results = list()
	if (total_moles>0)
		results += "<span class='notice'>Pressure: [round(pressure,0.1)] kPa</span>"
		for(var/mix in mixture.gas)
			results += "<span class='notice'>[gas_data.name[mix]]: [round((mixture.gas[mix] / total_moles) * 100)]%</span>"
		results += "<span class='notice'>Temperature: [round(mixture.temperature-T0C)]&deg;C</span>"
	else
		results += "<span class='notice'>\The [target] is empty!</span>"

	return results
