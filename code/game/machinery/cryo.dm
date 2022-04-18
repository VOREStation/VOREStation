#define HEAT_CAPACITY_HUMAN 100 //249840 J/K, for a 72 kg person.

/obj/machinery/atmospherics/unary/cryo_cell
	name = "cryo cell"
	desc = "Used to cool people down for medical reasons. Totally."
	icon = 'icons/obj/cryogenics.dmi' // map only
	icon_state = "pod_preview"
	density = TRUE
	anchored = TRUE
	layer = UNDER_JUNK_LAYER
	interact_offline = 1

	var/on = 0
	use_power = USE_POWER_IDLE
	idle_power_usage = 20
	active_power_usage = 200
	buckle_lying = FALSE
	buckle_dir = SOUTH
	clicksound = 'sound/machines/buttonbeep.ogg'
	clickvol = 30

	var/temperature_archived
	var/mob/living/carbon/occupant = null
	var/obj/item/reagent_containers/glass/beaker = null

	var/current_heat_capacity = 50

	var/image/fluid

/obj/machinery/atmospherics/unary/cryo_cell/New()
	..()
	icon = 'icons/obj/cryogenics_split.dmi'
	icon_state = "base"
	initialize_directions = dir

/obj/machinery/atmospherics/unary/cryo_cell/Initialize()
	. = ..()
	var/image/tank = image(icon,"tank")
	tank.alpha = 200
	tank.pixel_y = 18
	tank.plane = MOB_PLANE
	tank.layer = MOB_LAYER+0.2 //Above fluid
	fluid = image(icon, "tube_filler")
	fluid.pixel_y = 18
	fluid.alpha = 200
	fluid.plane = MOB_PLANE
	fluid.layer = MOB_LAYER+0.1 //Below glass, above mob
	add_overlay(tank)
	update_icon()

/obj/machinery/atmospherics/unary/cryo_cell/Destroy()
	var/turf/T = src.loc
	T.contents += contents
	if(beaker)
		beaker.forceMove(get_step(loc, SOUTH)) //Beaker is carefully ejected from the wreckage of the cryotube
		beaker = null
	. = ..()

/obj/machinery/atmospherics/unary/cryo_cell/process()
	..()
	if(!node)
		return
	if(!on)
		return

	if(occupant)
		if(occupant.stat != 2)
			process_occupant()

	if(air_contents)
		temperature_archived = air_contents.temperature
		heat_gas_contents()
		expel_gas()

	if(abs(temperature_archived-air_contents.temperature) > 1)
		network.update = 1

	return 1

/obj/machinery/atmospherics/unary/cryo_cell/relaymove(mob/user as mob)
	// note that relaymove will also be called for mobs outside the cell with UI open
	if(occupant == user && !user.stat)
		go_out()

/obj/machinery/atmospherics/unary/cryo_cell/attack_ghost(mob/user)
	tgui_interact(user)

/obj/machinery/atmospherics/unary/cryo_cell/attack_hand(mob/user)
	if(user == occupant)
		return

	if(panel_open)
		to_chat(usr, "<span class='boldnotice'>Close the maintenance panel first.</span>")
		return

	tgui_interact(user)

/obj/machinery/atmospherics/unary/cryo_cell/tgui_interact(mob/user, datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Cryo", "Cryo Cell") // 520, 470
		ui.open()

/obj/machinery/atmospherics/unary/cryo_cell/tgui_data(mob/user)
	// this is the data which will be sent to the ui
	var/data[0]
	data["isOperating"] = on
	data["hasOccupant"] = occupant ? TRUE : FALSE

	var/occupantData[0]
	if(occupant)
		occupantData["name"] = occupant.name
		occupantData["stat"] = occupant.stat
		occupantData["health"] = occupant.health
		occupantData["maxHealth"] = occupant.getMaxHealth()
		occupantData["minHealth"] = config.health_threshold_dead
		occupantData["bruteLoss"] = occupant.getBruteLoss()
		occupantData["oxyLoss"] = occupant.getOxyLoss()
		occupantData["toxLoss"] = occupant.getToxLoss()
		occupantData["fireLoss"] = occupant.getFireLoss()
		occupantData["bodyTemperature"] = occupant.bodytemperature
	data["occupant"] = occupantData;

	data["cellTemperature"] = round(air_contents.temperature)
	data["cellTemperatureStatus"] = "good"
	if(air_contents.temperature > T0C) // if greater than 273.15 kelvin (0 celcius)
		data["cellTemperatureStatus"] = "bad"
	else if(air_contents.temperature > 225)
		data["cellTemperatureStatus"] = "average"

	data["isBeakerLoaded"] = beaker ? TRUE : FALSE
	data["beakerLabel"] = null
	data["beakerVolume"] = 0
	if(beaker)
		data["beakerLabel"] = beaker.label_text ? beaker.label_text : null
		if(beaker.reagents && beaker.reagents.reagent_list.len)
			for(var/datum/reagent/R in beaker.reagents.reagent_list)
				data["beakerVolume"] += R.volume

	return data

/obj/machinery/atmospherics/unary/cryo_cell/tgui_act(action, params)
	if(..() || usr == occupant)
		return TRUE

	. = TRUE
	switch(action)
		if("switchOn")
			on = 1
			update_icon()
		if("switchOff")
			on = 0
			update_icon()
		if("ejectBeaker")
			if(beaker)
				beaker.loc = get_step(src.loc, SOUTH)
				beaker = null
				update_icon()
		if("ejectOccupant")
			if(!occupant || isslime(usr) || ispAI(usr))
				return 0 // don't update UIs attached to this object
			go_out()
		else
			return FALSE

	add_fingerprint(usr)

/obj/machinery/atmospherics/unary/cryo_cell/attackby(var/obj/item/G as obj, var/mob/user as mob)
	if(istype(G, /obj/item/reagent_containers/glass))
		if(beaker)
			to_chat(user, "<span class='warning'>A beaker is already loaded into the machine.</span>")
			return

		beaker =  G
		user.drop_item()
		G.loc = src
		user.visible_message("[user] adds \a [G] to \the [src]!", "You add \a [G] to \the [src]!")
		SStgui.update_uis(src)
		update_icon()
	else if(istype(G, /obj/item/grab))
		var/obj/item/grab/grab = G
		if(!ismob(grab.affecting))
			return
		if(occupant)
			to_chat(user,"<span class='warning'>\The [src] is already occupied by [occupant].</span>")
		if(grab.affecting.has_buckled_mobs())
			to_chat(user, span("warning", "\The [grab.affecting] has other entities attached to it. Remove them first."))
			return
		var/mob/M = grab.affecting
		qdel(grab)
		put_mob(M)
			
	return

/obj/machinery/atmospherics/unary/cryo_cell/MouseDrop_T(var/mob/target, var/mob/user) //Allows borgs to put people into cryo without external assistance
	if(user.stat || user.lying || !Adjacent(user) || !target.Adjacent(user)|| !ishuman(target))
		return
	put_mob(target)

/obj/machinery/atmospherics/unary/cryo_cell/update_icon()
	cut_overlay(fluid)
	fluid.color = null
	if(on)
		if(beaker)
			fluid.color = beaker.reagents.get_color()
		add_overlay(fluid)

/obj/machinery/atmospherics/unary/cryo_cell/proc/process_occupant()
	if(air_contents.total_moles < 10)
		return
	if(occupant)
		if(occupant.stat >= DEAD)
			return
		occupant.bodytemperature += 2*(air_contents.temperature - occupant.bodytemperature)*current_heat_capacity/(current_heat_capacity + air_contents.heat_capacity())
		occupant.bodytemperature = max(occupant.bodytemperature, air_contents.temperature) // this is so ugly i'm sorry for doing it i'll fix it later i promise
		occupant.set_stat(UNCONSCIOUS)
		occupant.dir = SOUTH
		if(occupant.bodytemperature < T0C)
			occupant.Sleeping(max(5, (1/occupant.bodytemperature)*2000))
			occupant.Paralyse(max(5, (1/occupant.bodytemperature)*3000))
			if(air_contents.gas["oxygen"] > 2)
				if(occupant.getOxyLoss()) occupant.adjustOxyLoss(-1)
			else
				occupant.adjustOxyLoss(-1)
			//severe damage should heal waaay slower without proper chemicals
			if(occupant.bodytemperature < 225)
				if(occupant.getToxLoss())
					occupant.adjustToxLoss(max(-1, -20/occupant.getToxLoss()))
				var/heal_brute = occupant.getBruteLoss() ? min(1, 20/occupant.getBruteLoss()) : 0
				var/heal_fire = occupant.getFireLoss() ? min(1, 20/occupant.getFireLoss()) : 0
				occupant.heal_organ_damage(heal_brute,heal_fire)
		var/has_cryo = occupant.reagents.get_reagent_amount("cryoxadone") >= 1
		var/has_clonexa = occupant.reagents.get_reagent_amount("clonexadone") >= 1
		var/has_cryo_medicine = has_cryo || has_clonexa
		if(beaker && !has_cryo_medicine)
			beaker.reagents.trans_to_mob(occupant, 1, CHEM_BLOOD, 10)

/obj/machinery/atmospherics/unary/cryo_cell/proc/heat_gas_contents()
	if(air_contents.total_moles < 1)
		return
	var/air_heat_capacity = air_contents.heat_capacity()
	var/combined_heat_capacity = current_heat_capacity + air_heat_capacity
	if(combined_heat_capacity > 0)
		var/combined_energy = T20C*current_heat_capacity + air_heat_capacity*air_contents.temperature
		air_contents.temperature = combined_energy/combined_heat_capacity

/obj/machinery/atmospherics/unary/cryo_cell/proc/expel_gas()
	if(air_contents.total_moles < 1)
		return
//	var/datum/gas_mixture/expel_gas = new
//	var/remove_amount = air_contents.total_moles()/50
//	expel_gas = air_contents.remove(remove_amount)

	// Just have the gas disappear to nowhere.
	//expel_gas.temperature = T20C // Lets expel hot gas and see if that helps people not die as they are removed
	//loc.assume_air(expel_gas)

/obj/machinery/atmospherics/unary/cryo_cell/proc/go_out()
	if(!(occupant))
		return
	//for(var/obj/O in src)
	//	O.loc = src.loc
	if(occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	vis_contents -= occupant
	occupant.pixel_x = occupant.default_pixel_x
	occupant.pixel_y = occupant.default_pixel_y
	occupant.loc = get_step(src.loc, SOUTH)	//this doesn't account for walls or anything, but i don't forsee that being a problem.
	if(occupant.bodytemperature < 261 && occupant.bodytemperature >= 70) //Patch by Aranclanos to stop people from taking burn damage after being ejected
		occupant.bodytemperature = 261									  // Changed to 70 from 140 by Zuhayr due to reoccurance of bug.
	unbuckle_mob(occupant, force = TRUE)
	occupant = null
	current_heat_capacity = initial(current_heat_capacity)
	update_use_power(USE_POWER_IDLE)
	SStgui.update_uis(src)
	return

/obj/machinery/atmospherics/unary/cryo_cell/proc/put_mob(mob/living/carbon/M as mob)
	if(stat & (NOPOWER|BROKEN))
		to_chat(usr, "<span class='warning'>The cryo cell is not functioning.</span>")
		return
	if(!istype(M))
		to_chat(usr, "<span class='danger'>The cryo cell cannot handle such a lifeform!</span>")
		return
	if(occupant)
		to_chat(usr, "<span class='danger'>The cryo cell is already occupied!</span>")
		return
	if(M.abiotic())
		to_chat(usr, "<span class='warning'>Subject may not have abiotic items on.</span>")
		return
	if(!node)
		to_chat(usr, "<span class='warning'>The cell is not correctly connected to its pipe network!</span>")
		return
	if(M.client)
		M.client.perspective = EYE_PERSPECTIVE
		M.client.eye = src
	M.stop_pulling()
	M.loc = src
	M.ExtinguishMob()
	if(M.health > -100 && (M.health < 0 || M.sleeping))
		to_chat(M, "<span class='notice'><b>You feel a cold liquid surround you. Your skin starts to freeze up.</b></span>")
	occupant = M
	buckle_mob(occupant, forced = TRUE, check_loc = FALSE)
	vis_contents |= occupant
	occupant.pixel_y += 19
	current_heat_capacity = HEAT_CAPACITY_HUMAN
	update_use_power(USE_POWER_ACTIVE)
//	M.metabslow = 1
	add_fingerprint(usr)
	update_icon()
	SStgui.update_uis(src)
	return 1

/obj/machinery/atmospherics/unary/cryo_cell/verb/move_eject()
	set name = "Eject occupant"
	set category = "Object"
	set src in oview(1)
	if(usr == occupant)//If the user is inside the tube...
		if(usr.stat == 2)//and he's not dead....
			return
		to_chat(usr, "<span class='notice'>Release sequence activated. This will take two minutes.</span>")
		sleep(1200)
		if(!src || !usr || !occupant || (occupant != usr)) //Check if someone's released/replaced/bombed him already
			return
		go_out()//and release him from the eternal prison.
	else
		if(usr.stat != 0)
			return
		go_out()
	add_fingerprint(usr)
	return

/obj/machinery/atmospherics/unary/cryo_cell/verb/move_inside()
	set name = "Move Inside"
	set category = "Object"
	set src in oview(1)
	if(isliving(usr))
		var/mob/living/L = usr
		if(L.has_buckled_mobs())
			to_chat(L, span("warning", "You have other entities attached to yourself. Remove them first."))
			return
		if(L.stat != CONSCIOUS)
			return
		put_mob(L)

/atom/proc/return_air_for_internal_lifeform(var/mob/living/lifeform)
	return return_air()

/obj/machinery/atmospherics/unary/cryo_cell/return_air_for_internal_lifeform()
	//assume that the cryo cell has some kind of breath mask or something that
	//draws from the cryo tube's environment, instead of the cold internal air.
	if(src.loc)
		return loc.return_air()
	else
		return null

/datum/data/function/proc/reset()
	return

/datum/data/function/proc/r_input(href, href_list, mob/user as mob)
	return

/datum/data/function/proc/display()
	return
