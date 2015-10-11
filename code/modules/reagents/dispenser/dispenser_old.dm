//This has the 'old' chem dispenser.  The new one is in dispenser2.dm

#define CHEM_DISPENSER_ENERGY_COST	0.1	//How many energy points do we use per unit of chemical?
#define BOTTLE_SPRITES list("bottle-1", "bottle-2", "bottle-3", "bottle-4") //list of available bottle sprites

/obj/machinery/chemical_dispenser/energy
	name = "chemical dispenser"
	density = 1
	anchored = 1
	icon = 'icons/obj/chemical.dmi'
	icon_state = "dispenser"
	use_power = 0
	idle_power_usage = 40
	var/ui_title = "Chem Dispenser 5000"
	var/energy = 100
	var/max_energy = 100
	var/amount = 30
	var/accept_glass = 0 //At 0 ONLY accepts glass containers. Kinda misleading varname.
	var/atom/beaker = null
	var/recharged = 0
	var/hackedcheck = 0
	var/list/dispensable_reagents = list("hydrogen","lithium","carbon","nitrogen","oxygen","fluorine","sodium","aluminum","silicon","phosphorus","sulfur","chlorine","potassium","iron","copper","mercury","radium","water","ethanol","sugar","sacid","tungsten")

/obj/machinery/chemical_dispenser/energy/proc/recharge()
	if(stat & (BROKEN|NOPOWER))
		return
	var/addenergy = 1
	var/oldenergy = energy
	energy = min(energy + addenergy, max_energy)
	if(energy != oldenergy)
		use_power(CHEM_SYNTH_ENERGY / CHEM_DISPENSER_ENERGY_COST) // This thing uses up "alot" of power (this is still low as shit for creating reagents from thin air)
		nanomanager.update_uis(src) // update all UIs attached to src

/obj/machinery/chemical_dispenser/energy/power_change()
	..()
	nanomanager.update_uis(src) // update all UIs attached to src

/obj/machinery/chemical_dispenser/energy/process()
	if(recharged <= 0)
		recharge()
		recharged = 15
	else
		recharged -= 1

/obj/machinery/chemical_dispenser/energy/New()
	..()
	recharge()
	dispensable_reagents = sortList(dispensable_reagents)


/obj/machinery/chemical_dispenser/energy/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return

 /**
  * The ui_interact proc is used to open and update Nano UIs
  * If ui_interact is not used then the UI will not update correctly
  * ui_interact is currently defined for /atom/movable
  *
  * @param user /mob The mob who is interacting with this ui
  * @param ui_key string A string key to use for this ui. Allows for multiple unique uis on one obj/mob (defaut value "main")
  *
  * @return nothing
  */
/obj/machinery/chemical_dispenser/energy/ui_interact(mob/user, ui_key = "main",var/datum/nanoui/ui = null, var/force_open = 1)
	if(stat & (BROKEN|NOPOWER)) return
	if(user.stat || user.restrained()) return

	// this is the data which will be sent to the ui
	var/data[0]
	data["amount"] = amount
	data["energy"] = round(energy)
	data["maxEnergy"] = round(max_energy)
	data["isBeakerLoaded"] = beaker ? 1 : 0
	data["glass"] = accept_glass
	var beakerContents[0]
	var beakerCurrentVolume = 0
	if(beaker && beaker:reagents && beaker:reagents.reagent_list.len)
		for(var/datum/reagent/R in beaker:reagents.reagent_list)
			beakerContents.Add(list(list("name" = R.name, "volume" = R.volume))) // list in a list because Byond merges the first list...
			beakerCurrentVolume += R.volume
	data["beakerContents"] = beakerContents

	if (beaker)
		data["beakerCurrentVolume"] = beakerCurrentVolume
		data["beakerMaxVolume"] = beaker:volume
	else
		data["beakerCurrentVolume"] = null
		data["beakerMaxVolume"] = null

	var chemicals[0]
	for (var/re in dispensable_reagents)
		var/datum/reagent/temp = chemical_reagents_list[re]
		if(temp)
			chemicals.Add(list(list("title" = temp.name, "id" = temp.id, "commands" = list("dispense" = temp.id)))) // list in a list because Byond merges the first list...
	data["chemicals"] = chemicals

	// update the ui if it exists, returns null if no ui is passed/found
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "chem_dispenser_energy.tmpl", ui_title, 390, 655)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()

/obj/machinery/chemical_dispenser/energy/Topic(href, href_list)
	if(stat & (NOPOWER|BROKEN))
		return 0 // don't update UIs attached to this object

	if(href_list["amount"])
		amount = round(text2num(href_list["amount"]), 5) // round to nearest 5
		if (amount < 0) // Since the user can actually type the commands himself, some sanity checking
			amount = 0
		if (amount > 120)
			amount = 120

	if(href_list["dispense"])
		if (dispensable_reagents.Find(href_list["dispense"]) && beaker != null && beaker.is_open_container())
			var/obj/item/weapon/reagent_containers/B = src.beaker
			var/datum/reagents/R = B.reagents
			var/space = R.maximum_volume - R.total_volume

			//uses 1 energy per 10 units.
			var/added_amount = min(amount, energy / CHEM_DISPENSER_ENERGY_COST, space)
			R.add_reagent(href_list["dispense"], added_amount)
			energy = max(energy - added_amount * CHEM_DISPENSER_ENERGY_COST, 0)

	if(href_list["ejectBeaker"])
		if(beaker)
			var/obj/item/weapon/reagent_containers/B = beaker
			B.loc = loc
			beaker = null

	add_fingerprint(usr)
	return 1 // update UIs attached to this object

/obj/machinery/chemical_dispenser/energy/attackby(var/obj/item/weapon/reagent_containers/B as obj, var/mob/user as mob)
	if(isrobot(user))
		return
	if(src.beaker)
		user << "Something is already loaded into the machine."
		return
	if(istype(B, /obj/item/weapon/reagent_containers/glass) || istype(B, /obj/item/weapon/reagent_containers/food))
		if(!accept_glass && istype(B,/obj/item/weapon/reagent_containers/food))
			user << "<span class='notice'>This machine only accepts beakers</span>"
		src.beaker =  B
		user.drop_item()
		B.loc = src
		user << "You set [B] on the machine."
		nanomanager.update_uis(src) // update all UIs attached to src
		return

/obj/machinery/chemical_dispenser/energy/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/chemical_dispenser/energy/attack_hand(mob/user as mob)
	if(stat & BROKEN)
		return
	ui_interact(user)

/obj/machinery/chemical_dispenser/energy/soda
	icon_state = "soda_dispenser"
	name = "soda fountain"
	desc = "A drink fabricating machine, capable of producing many sugary drinks with just one touch."
	ui_title = "Soda Dispens-o-matic"
	energy = 100
	accept_glass = 1
	max_energy = 100
	dispensable_reagents = list("water","ice","coffee","cream","tea","icetea","cola","spacemountainwind","dr_gibb","space_up","tonic","sodawater","lemon_lime","sugar","orangejuice","limejuice","watermelonjuice")

/obj/machinery/chemical_dispenser/energy/soda/attackby(var/obj/item/weapon/B as obj, var/mob/user as mob)
	..()
	if(istype(B, /obj/item/device/multitool))
		if(hackedcheck == 0)
			user << "You change the mode from 'McNano' to 'Pizza King'."
			dispensable_reagents += list("thirteenloko","grapesoda")
			hackedcheck = 1
			return

		else
			user << "You change the mode from 'Pizza King' to 'McNano'."
			dispensable_reagents -= list("thirteenloko","grapesoda")
			hackedcheck = 0
			return

/obj/machinery/chemical_dispenser/energy/beer
	icon_state = "booze_dispenser"
	name = "booze dispenser"
	ui_title = "Booze Portal 9001"
	energy = 100
	accept_glass = 1
	max_energy = 100
	desc = "A technological marvel, supposedly able to mix just the mixture you'd like to drink the moment you ask for one."
	dispensable_reagents = list("lemon_lime","sugar","orangejuice","limejuice","sodawater","tonic","beer","kahlua",
								"whiskey","wine","vodka","gin","rum","tequilla","vermouth","cognac","ale","mead")

/obj/machinery/chemical_dispenser/energy/beer/attackby(var/obj/item/weapon/B as obj, var/mob/user as mob)
	..()

	if(istype(B, /obj/item/device/multitool))
		if(hackedcheck == 0)
			user << "You disable the 'nanotrasen-are-cheap-bastards' lock, enabling hidden and very expensive boozes."
			dispensable_reagents += list("goldschlager","patron","watermelonjuice","berryjuice")
			hackedcheck = 1
			return

		else
			user << "You re-enable the 'nanotrasen-are-cheap-bastards' lock, disabling hidden and very expensive boozes."
			dispensable_reagents -= list("goldschlager","patron","watermelonjuice","berryjuice")
			hackedcheck = 0
			return

/obj/machinery/chemical_dispenser/energy/meds
	name = "ultra chem dispenser"
	density = 1
	anchored = 1
	icon = 'icons/obj/chemical.dmi'
	icon_state = "dispenser"
	use_power = 0
	idle_power_usage = 40
	ui_title = "Chem Dispenser 9000"
	energy = 100
	max_energy = 100
	amount = 30
	accept_glass = 0 //At 0 ONLY accepts glass containers. Kinda misleading varname.
	beaker = null
	recharged = 0
	hackedcheck = 0
	dispensable_reagents = list("inaprovaline","ryetalyn","paracetamol","tramadol","oxycodone","sterilizine","leporazine","kelotane",
								"dermaline","dexalin","dexalinp","tricordrazine","anti_toxin","synaptizine","hyronalin","arithrazine",
								"alkysine","imidazoline","peridaxon","bicaridine","hyperzine","rezadone","spaceacillin","ethylredoxrazine",
								"stoxin","chloralhydrate","cryoxadone","clonexadone")