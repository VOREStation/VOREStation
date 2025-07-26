//backpack item
/obj/item/medigun_backpack
	name = "protoype bluespace medigun backpack"
	desc = "Contains a bluespace medigun, this portable unit digitizes and stores chems and battery power used by the attached gun."
	icon = 'icons/obj/borkmedigun.dmi'
	icon_override = 'icons/obj/borkmedigun.dmi'
	icon_state = "mg-backpack"
	item_state = "mg-backpack-onmob"
	slot_flags = SLOT_BACK
	force = 5
	throwforce = 6
	preserve_item = TRUE
	w_class = ITEMSIZE_HUGE
	unacidable = TRUE
	origin_tech = list(TECH_BIO = 4, TECH_POWER = 2, TECH_BLUESPACE = 4)
	actions_types = list(/datum/action/item_action/remove_replace_medigun)

	var/obj/item/bork_medigun/linked/medigun
	var/obj/item/cell/bcell = /obj/item/cell
	var/obj/item/stock_parts/matter_bin/sbin = /obj/item/stock_parts/matter_bin
	var/obj/item/stock_parts/scanning_module/smodule = /obj/item/stock_parts/scanning_module
	var/obj/item/stock_parts/manipulator/smanipulator = /obj/item/stock_parts/manipulator
	var/obj/item/stock_parts/capacitor/scapacitor = /obj/item/stock_parts/capacitor
	var/obj/item/stock_parts/micro_laser/slaser = /obj/item/stock_parts/micro_laser
	var/charging = FALSE
	var/phoronvol = 0
	var/brutecharge = 0
	var/toxcharge = 0
	var/burncharge = 0
	var/brutevol = 0
	var/toxvol = 0
	var/burnvol = 0
	var/chemcap = 60
	var/tankmax = 30
	var/containsgun = TRUE
	var/maintenance = FALSE
	var/smaniptier = 1
	var/sbintier = 1
	var/gridstatus = 0
	var/chargecap = 1000

//backpack item
/obj/item/medigun_backpack/cmo
	name = "prototype bluespace medigun backpack - CMO"
	desc = "Contains a compact version of the bluespace medigun able to be used one handed, this portable unit digitizes and stores chems and battery power used by the attached gun."
	icon_state = "mg-backpack_cmo"
	item_state = "mg-backpack_cmo-onmob"
	scapacitor = /obj/item/stock_parts/capacitor/adv
	smanipulator = /obj/item/stock_parts/manipulator/nano
	smodule = /obj/item/stock_parts/scanning_module/adv
	slaser = /obj/item/stock_parts/micro_laser/high
	bcell = /obj/item/cell/apc
	tankmax = 60
	brutecharge = 60
	toxcharge = 60
	burncharge = 60
	chemcap = 120
	brutevol = 120
	toxvol = 120
	burnvol = 120
	chargecap = 5000

/obj/item/medigun_backpack/proc/is_twohanded()
	return TRUE

/obj/item/medigun_backpack/cmo/is_twohanded()
	return FALSE

/obj/item/medigun_backpack/proc/apc_charge()
	gridstatus = 0
	var/area/A = get_area(src)
	if(!istype(A) || !A.powered(EQUIP))
		return FALSE
	gridstatus = 1
	if(bcell && (bcell.charge < bcell.maxcharge))
		var/cur_charge = bcell.charge
		var/delta = min(50, bcell.maxcharge-cur_charge)
		bcell.give(delta)
		A.use_power_oneoff(delta*100, EQUIP)
		gridstatus = 2
		if(charging && ismob(loc))
			to_chat(loc, span_notice("With the grid connection enabled, the phoron generator sputters then stops."))
		charging = FALSE
	return TRUE

/obj/item/medigun_backpack/proc/adjust_brutevol(modifier)
	if(modifier > brutevol)
		modifier = brutevol
	if(modifier > (tankmax - brutecharge))
		modifier = tankmax - brutecharge
	brutevol -= modifier
	brutecharge += modifier

/obj/item/medigun_backpack/proc/adjust_burnvol(modifier)
	if(modifier > burnvol)
		modifier = burnvol
	if(modifier > (tankmax - burncharge))
		modifier = tankmax - burncharge
	burnvol -= modifier
	burncharge += modifier

/obj/item/medigun_backpack/proc/adjust_toxvol(modifier)
	if(modifier > toxvol)
		modifier = toxvol
	if(modifier > (tankmax - toxcharge))
		modifier = tankmax - toxcharge
	toxvol -= modifier
	toxcharge += modifier

/obj/item/medigun_backpack/process()
	if(!bcell)
		return

	if(bcell.charge >= 10)
		var/icon_needs_update = FALSE
		if(brutecharge < tankmax && brutevol > 0 && (bcell.checked_use(smaniptier * 2)))
			adjust_brutevol(smaniptier * 2)
			icon_needs_update = TRUE
		if(burncharge < tankmax && burnvol > 0 && (bcell.checked_use(smaniptier * 2)))
			adjust_burnvol(smaniptier * 2)
			icon_needs_update = TRUE
		if(toxcharge < tankmax && toxvol > 0 && (bcell.checked_use(smaniptier * 2)))
			adjust_toxvol(smaniptier * 2)
			icon_needs_update = TRUE
		//Alien tier
		if(sbintier >= 5 && medigun.busy == MEDIGUN_IDLE && (bcell.charge >= 10))
			if(brutevol < chemcap && (bcell.checked_use(10)))
				icon_needs_update = TRUE
				brutevol ++
			if(burnvol < chemcap && (bcell.checked_use(10)))
				icon_needs_update = TRUE
				burnvol ++
			if(toxvol < chemcap && (bcell.checked_use(10)))
				icon_needs_update = TRUE
				toxvol ++

		if(icon_needs_update)
			update_icon()
	else if(!charging && phoronvol > 0)
		if(ismob(loc))
			to_chat(loc, span_warning("With a sudden whirr, the phoron generator spins up."))
		charging = TRUE

	if(scapacitor.get_rating() >= 5)
		apc_charge()

	if(!charging)
		return

	if((bcell.amount_missing() >= 50))
		if(phoronvol > 0)
			phoronvol --
			bcell.give(50)
			update_icon()
			return

		if(ismob(loc))
			to_chat(loc, span_notice("The phoron generator sputters then stops."))
		charging = FALSE

/obj/item/medigun_backpack/get_cell()
	return bcell

/obj/item/medigun_backpack/update_icon()
	. = ..()
	cut_overlays()
	if((bcell.percent() <= 5 ))
		add_overlay(image('icons/obj/borkmedigun.dmi', "no_battery"))
	else if((bcell.percent() <= 25 && bcell.percent() > 5))
		add_overlay(image('icons/obj/borkmedigun.dmi', "low_battery"))

	if(brutevol <= 0 && brutecharge > 0)
		add_overlay(image('icons/obj/borkmedigun.dmi', "red"))
	else if(brutecharge <= 0 && brutevol <= 0)
		add_overlay(image('icons/obj/borkmedigun.dmi', "redstrike-blink"))

	if(toxvol <= 0 && toxcharge > 0)
		add_overlay(image('icons/obj/borkmedigun.dmi', "green"))
	else if(toxcharge <= 0 && toxvol <= 0)
		add_overlay(image('icons/obj/borkmedigun.dmi', "greenstrike-blink"))

	if(burnvol <= 0 && burncharge > 0)
		add_overlay(image('icons/obj/borkmedigun.dmi', "orange"))
	else if(burncharge <= 0 && burnvol <= 0)
		add_overlay(image('icons/obj/borkmedigun.dmi', "orangestrike-blink"))

/obj/item/medigun_backpack/proc/replace_icon(inhand)
	if(inhand)
		icon_state = "mg-backpack-deployed"
		item_state = "mg-backpack-deployed-onmob"
		if(is_twohanded())
			medigun.icon_state = "medblaster"
			medigun.base_icon_state = "medblaster"
			medigun.wielded_item_state = "medblaster-wielded"
			medigun.update_icon()
		else
			medigun.icon_state = "medblaster_cmo"
			medigun.base_icon_state = "medblaster_cmo"
			medigun.wielded_item_state = ""
			medigun.update_icon()
	else if(is_twohanded())
		icon_state = "mg-backpack"
		item_state = "mg-backpack-onmob"
		medigun.icon_state = "medblaster"
		medigun.base_icon_state = "medblaster"
	else
		icon_state = "mg-backpack_cmo"
		item_state = "mg-backpack_cmo-onmob"
		medigun.icon_state = "medblaster_cmo"
		medigun.base_icon_state = "medblaster_cmo"

	update_icon()

/obj/item/medigun_backpack/Initialize(mapload)
	. = ..()
	if(ispath(medigun))
		medigun = new medigun(src, src)
	else
		medigun = new(src, src)
	if(!is_twohanded())
		medigun.beam_range = 4
	if(ispath(bcell))
		bcell = new bcell(src)
	if(ispath(sbin))
		sbin = new sbin(src)
	if(ispath(smodule))
		smodule = new smodule(src)
		START_PROCESSING(SSobj, src)
	if(ispath(smanipulator))
		smanipulator = new smanipulator(src)
	if(ispath(scapacitor))
		scapacitor = new scapacitor(src)
	if(ispath(slaser))
		slaser = new slaser(src)
	update_icon()


/obj/item/medigun_backpack/Destroy()
	STOP_PROCESSING(SSobj, src)
	QDEL_NULL(medigun)
	QDEL_NULL(bcell)
	QDEL_NULL(smodule)
	QDEL_NULL(smanipulator)
	QDEL_NULL(scapacitor)
	QDEL_NULL(slaser)
	. = ..()

/obj/item/medigun_backpack/ui_action_click()
	if(charging)
		to_chat(usr, span_notice("You disable the phoron generator."))
		charging = FALSE
		return

	if(phoronvol > 0)
		to_chat(usr, span_notice("You enable the phoron generator."))
		charging = TRUE
		return

	to_chat(usr, span_warning("Not Enough Phoron stored."))

/obj/item/medigun_backpack/emp_act(severity)
	. = ..()
	if(bcell)
		bcell.emp_act(severity)

/obj/item/medigun_backpack/attack_hand(mob/user)
	/*if(maintenance)
		maintenance = FALSE
		to_chat(user, span_notice("You close the maintenance hatch on \the [src]."))
		return*/

	if(loc == user)
		toggle_medigun()
		return

	..()

/obj/item/medigun_backpack/MouseDrop()
	if(ismob(src.loc))
		if(!CanMouseDrop(src))
			return
		var/mob/M = src.loc
		if(!M.unEquip(src))
			return
		src.add_fingerprint(usr)
		M.put_in_any_hand_if_possible(src)
		/*icon_state = "mg-backpack"
		item_state = "mg-backpack-onmob"
		update_icon() //success
		usr.update_inv_back()*/


/obj/item/medigun_backpack/attackby(obj/item/W, mob/user, params)
	if(refill_reagent(W, user))
		return
	if(W == medigun)
		//to_chat(user, span_warning("backpack clicked with gun"))
		reattach_medigun(user)
		return
	if(W.is_crowbar() && maintenance)
		if(smodule )
			smodule.forceMove(get_turf(loc))
			smodule = null

		if(smanipulator)
			STOP_PROCESSING(SSobj, src)
			smanipulator.forceMove(get_turf(loc))
			smanipulator = null
			smaniptier = 0

		if(slaser)
			slaser.forceMove(get_turf(loc))
			slaser = null

		if(scapacitor)
			STOP_PROCESSING(SSobj, src)
			scapacitor.forceMove(get_turf(loc))
			scapacitor = null

		if(sbin)
			STOP_PROCESSING(SSobj, src)
			sbin.forceMove(get_turf(loc))
			sbin = null
			sbintier = 0

		to_chat(user, span_notice("You remove the Components from \the [src]."))
		update_icon()
		return TRUE

	if(W.is_screwdriver())
		if(!maintenance)
			maintenance = TRUE
			to_chat(user, span_notice("You open the maintenance hatch on \the [src]."))
			reattach_medigun(user)
			return

		maintenance = FALSE
		to_chat(user, span_notice("You close the maintenance hatch on \the [src]."))
		return

	if(maintenance)
		if(istype(W, /obj/item/stock_parts/scanning_module))
			if(smodule)
				to_chat(user, span_notice("\The [src] already has a scanning module."))
			else
				if(!user.unEquip(W))
					return
				W.forceMove(src)
				smodule = W
				to_chat(user, span_notice("You install the [W] into \the [src]."))
				medigun.beam_range = 3+smodule.get_rating()
				update_icon()
				return

		if(istype(W, /obj/item/stock_parts/manipulator))
			if(smanipulator)
				to_chat(user, span_notice("\The [src] already has a manipulator."))
				return
			if(!user.unEquip(W))
				return
			W.forceMove(src)
			smanipulator = W
			smaniptier = smanipulator.get_rating()
			if(sbin && scapacitor)START_PROCESSING(SSobj, src)
			to_chat(user, span_notice("You install the [W] into \the [src]."))
			update_icon()
			return

		if(istype(W, /obj/item/stock_parts/micro_laser))
			if(slaser)
				to_chat(user, span_notice("\The [src] already has a micro laser."))
				return
			if(!user.unEquip(W))
				return
			W.forceMove(src)
			slaser = W
			to_chat(user, span_notice("You install the [W] into \the [src]."))
			update_icon()
			return

		if(istype(W, /obj/item/stock_parts/capacitor))
			if(scapacitor)
				to_chat(user, span_notice("\The [src] already has a capacitor."))
				return
			if(!user.unEquip(W))
				return
			W.forceMove(src)
			scapacitor = W
			var/scaptier = scapacitor.get_rating()
			if(scaptier == 1)
				chargecap = 1000
				bcell.maxcharge = 1000
				if(bcell.charge > chargecap)
					bcell.charge = chargecap
			else if(scaptier == 2)
				chargecap = 5000
				bcell.maxcharge = 5000
				if(bcell.charge > chargecap)
					bcell.charge = chargecap
			else if(scaptier == 3)
				chargecap = 10000
				bcell.maxcharge = 10000
				if(bcell.charge > chargecap)
					bcell.charge = chargecap
			else if(scaptier == 4)
				chargecap = 20000
				bcell.maxcharge = 20000
				if(bcell.charge > chargecap)
					bcell.charge = chargecap
			else if(scaptier == 5)
				chargecap = 30000
				bcell.maxcharge = 30000
				if(bcell.charge > chargecap)
					bcell.charge = chargecap

			if(sbin && smanipulator)START_PROCESSING(SSobj, src)
			to_chat(user, span_notice("You install the [W] into \the [src]."))
			update_icon()
			return

		if(istype(W, /obj/item/stock_parts/matter_bin))
			if(sbin)
				to_chat(user, span_notice("\The [src] already has a matter bin."))
				return
			if(!user.unEquip(W))
				return
			W.forceMove(src)
			sbin = W
			sbintier = sbin.get_rating()
			if(sbintier >= 5)
				chemcap = 300
				tankmax = 150
			else
				chemcap = 60*(sbintier)
				tankmax = 30*sbintier
			if(brutecharge > chemcap)
				brutecharge = chemcap
			if(burncharge > chemcap)
				burncharge = chemcap
			if(toxcharge > chemcap)
				toxcharge = chemcap
			if(brutecharge > tankmax)
				brutecharge = tankmax
			if(burncharge > tankmax)
				burncharge = tankmax
			if(toxcharge > tankmax)
				toxcharge = tankmax
			if(scapacitor && smanipulator)START_PROCESSING(SSobj, src)
			to_chat(user, span_notice("You install the [W] into \the [src]."))
			update_icon()
			return

	return ..()


/obj/item/medigun_backpack/proc/refill_reagent(var/obj/item/container, mob/user)
	. = FALSE
	if(!maintenance && (istype(container, /obj/item/reagent_containers/glass/beaker) || istype(container, /obj/item/reagent_containers/glass/bottle)))

		if(!(container.flags & OPENCONTAINER))
			to_chat(user, span_warning("You need to open the [container] first!"))
			return

		var/reagentwhitelist = list("bicaridine", "anti_toxin", "kelotane", "dermaline", "phoron")//, "tricordrazine")

		for(var/G in container.reagents.reagent_list)
			var/datum/reagent/R = G
			var/modifier = 1
			var/totransfer = 0
			var/name = ""

			if(R.id in reagentwhitelist)
				switch(R.id)
					if("bicaridine")
						name = "bruteheal"
						modifier = 4
						totransfer = chemcap - brutevol
					if("anti_toxin")
						name = "toxheal"
						modifier = 4
						totransfer = chemcap - toxvol
					if("kelotane")
						name = "burnheal"
						modifier = 4
						totransfer = chemcap - burnvol
					if("dermaline")
						name = "burnheal"
						modifier = 8
						totransfer = chemcap - burnvol
					if("phoron")
						name = "phoron"
						modifier = 1
						totransfer = chemcap - phoronvol
					/*if("tricordrazine")
						name = "tricordrazine"
						modifier = 1
						if((brutevol != chemcap) && (burnvol != chemcap) && (toxvol != chemcap))
							totransfer = 1  //tempcheck to get past the totransfer check
						else
							totransfer = 0*/
				if(totransfer <= 0)
					to_chat(user, span_notice("The [src] cannot accept anymore [name]!"))
				totransfer = min(totransfer, container.reagents.get_reagent_amount(R.id) * modifier)

				switch(R.id)
					if("bicaridine")
						brutevol += totransfer
					if("anti_toxin")
						toxvol += totransfer
					if("kelotane")
						burnvol += totransfer
					if("dermaline")
						burnvol += totransfer
					if("phoron")
						phoronvol += totransfer
					/*if("tricordrazine") //Tricord too problematic
						var/maxamount = container.reagents.get_reagent_amount(R.id)
						var/amountused
						var/oldbrute = brutevol
						var/oldburn = burnvol
						var/oldtox = toxvol

						while(maxamount > 0)
							if(brutevol >= chemcap && burnvol >= chemcap && toxvol >= chemcap)
								break
							maxamount --
							amountused++
							totransfer ++
							if(brutevol < chemcap)
								brutevol ++
							if(burnvol < chemcap)
								burnvol ++
							if(toxvol < chemcap)
								toxvol ++
						var/readout = "You add [amountused] units of [R.name] to the [src]. \n The [src] Stores "
						var/readoutadditions = FALSE
						if(oldbrute != brutevol)
							readout += "[round(brutevol - oldbrute)] U of bruteheal vol"
							readoutadditions = TRUE
						if(oldburn != burnvol)
							if(readoutadditions)
								readout += ", "
							readout += "[round(burnvol - oldburn)] U of burnheal vol"
							readoutadditions = TRUE
						if(oldtox != toxvol)
							if(readoutadditions)
								readout += ", "
							readout += "[round(toxvol - oldtox)] U of toxheal vol"
						if(oldbrute != brutevol || oldburn != burnvol || oldtox != toxvol)to_chat(user, span_notice("[readout]."))*/
				if(totransfer > 0)
					if(R.id != "tricordrazine")
						to_chat(user, span_notice("You add [totransfer / modifier] units of [R.name] to the [src]. \n The [src] stores [round(totransfer)] U of [name]."))
					container.reagents.remove_reagent(R.id, totransfer / modifier)
					playsound(src, 'sound/weapons/empty.ogg', 50, 1)
				update_icon()
				. = TRUE
	return

//checks that the base unit is in the correct slot to be used
/obj/item/medigun_backpack/proc/slot_check()
	var/mob/M = loc
	if(!istype(M))
		return FALSE //not equipped

	if((slot_flags & SLOT_BACK) && M.get_equipped_item(slot_back) == src)
		return TRUE
	if((slot_flags & SLOT_BACK) && M.get_equipped_item(slot_s_store) == src)
		return TRUE
	return FALSE

/obj/item/medigun_backpack/dropped(mob/user)
	..()
	replace_icon()
	reattach_medigun(user) //medigun attached to a base unit should never exist outside of their base unit or the mob equipping the base unit

/obj/item/medigun_backpack/proc/reattach_medigun(mob/user)
	if(containsgun)
		return

	containsgun = TRUE
	if(!medigun)
		return
	if(medigun.busy)
		medigun.busy = MEDIGUN_IDLE
	replace_icon()
	user.update_inv_back()
	if(ismob(medigun.loc))
		var/mob/M = medigun.loc
		if(M.drop_from_inventory(medigun, src))
			to_chat(user, span_notice("\The [medigun] snaps back into the main unit."))
		return

	medigun.forceMove(src)
	to_chat(user, span_notice("\The [medigun] snaps back into the main unit."))

/obj/item/medigun_backpack/proc/checked_use(var/charge_amt)
	return (bcell && bcell.checked_use(charge_amt))
