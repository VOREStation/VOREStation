//Config stuff
#define SUPPLY_DOCKZ 2				//Z-level of the Dock.
#define SUPPLY_STATIONZ 1			//Z-level of the Station.
#define SUPPLY_STATION_AREATYPE "/area/supply/station"	//Type of the supply shuttle area for station
#define SUPPLY_DOCK_AREATYPE "/area/supply/dock"	//Type of the supply shuttle area for dock

//Supply packs are in /code/datums/supplypacks
//Computers are in /code/game/machinery/computer/supply.dm

/datum/supply_order
	var/ordernum
	var/datum/supply_packs/object = null
	var/orderedby = null
	var/comment = null

/datum/exported_crate
	var/name
	var/value


var/datum/controller/supply/supply_controller = new()

/datum/controller/supply
	//supply points
	var/points = 50
	var/points_per_process = 1.5
	var/points_per_slip = 2
	var/points_per_platinum = 5 // 5 points per sheet
	var/points_per_phoron = 5
	var/points_per_money = 0.02 // 1 point for $50
	//control
	var/ordernum
	var/list/shoppinglist = list()
	var/list/requestlist = list()
	var/list/supply_packs = list()
	var/list/exported_crates = list()
	//shuttle movement
	var/movetime = 1200
	var/datum/shuttle/ferry/supply/shuttle

/datum/controller/supply/New()
	ordernum = rand(1,9000)

	for(var/typepath in (typesof(/datum/supply_packs) - /datum/supply_packs))
		var/datum/supply_packs/P = new typepath()
		supply_packs[P.name] = P

/datum/controller/process/supply/setup()
	name = "supply controller"
	schedule_interval = 300 // every 30 seconds

/datum/controller/process/supply/doWork()
	supply_controller.process()

// Supply shuttle ticker - handles supply point regeneration
// This is called by the process scheduler every thirty seconds
/datum/controller/supply/proc/process()
	points += points_per_process

//To stop things being sent to CentCom which should not be sent to centcomm. Recursively checks for these types.
/datum/controller/supply/proc/forbidden_atoms_check(atom/A)
	if(isliving(A))
		return 1
	if(istype(A,/obj/item/weapon/disk/nuclear))
		return 1
	if(istype(A,/obj/machinery/nuclearbomb))
		return 1
	if(istype(A,/obj/item/device/radio/beacon))
		return 1

	for(var/atom/B in A.contents)
		if(.(B))
			return 1

//Selling
/datum/controller/supply/proc/sell()
	var/area/area_shuttle = shuttle.get_location_area()
	if(!area_shuttle)
		return

	callHook("sell_shuttle", list(area_shuttle));

	var/phoron_count = 0
	var/plat_count = 0
	var/money_count = 0

	exported_crates = list()

	for(var/atom/movable/MA in area_shuttle)
		if(MA.anchored)
			continue

		// Must be in a crate!
		if(istype(MA,/obj/structure/closet/crate))
			var/oldpoints = points
			var/oldphoron = phoron_count
			var/oldplatinum = plat_count
			var/oldmoney = money_count

			var/obj/structure/closet/crate/CR = MA
			callHook("sell_crate", list(CR, area_shuttle))

			points += CR.points_per_crate
			var/find_slip = 1

			for(var/atom/A in CR)
				// Sell manifests
				if(find_slip && istype(A,/obj/item/weapon/paper/manifest))
					var/obj/item/weapon/paper/manifest/slip = A
					if(!slip.is_copy && slip.stamped && slip.stamped.len) //yes, the clown stamp will work. clown is the highest authority on the station, it makes sense
						points += points_per_slip
						find_slip = 0
					continue

				// Sell phoron and platinum
				if(istype(A, /obj/item/stack))
					var/obj/item/stack/P = A
					switch(P.get_material_name())
						if("phoron")
							phoron_count += P.get_amount()
						if("platinum")
							plat_count += P.get_amount()

				//Sell spacebucks
				if(istype(A, /obj/item/weapon/spacecash))
					var/obj/item/weapon/spacecash/cashmoney = A
					money_count += cashmoney.worth

			var/datum/exported_crate/EC = new /datum/exported_crate()
			EC.name = CR.name
			EC.value = points - oldpoints
			EC.value += (phoron_count - oldphoron) * points_per_phoron
			EC.value += (plat_count - oldplatinum) * points_per_platinum
			EC.value += (money_count - oldmoney) * points_per_money
			exported_crates += EC

		qdel(MA)

	points += phoron_count * points_per_phoron
	points += plat_count * points_per_platinum
	points += money_count * points_per_money

//Buying
/datum/controller/supply/proc/buy()
	if(!shoppinglist.len)
		return

	var/orderedamount = shoppinglist.len

	var/area/area_shuttle = shuttle.get_location_area()
	if(!area_shuttle)
		return

	var/list/clear_turfs = list()

	for(var/turf/T in area_shuttle)
		if(T.density)
			continue
		var/contcount
		for(var/atom/A in T.contents)
			if(!A.simulated)
				continue
			contcount++
		if(contcount)
			continue
		clear_turfs += T

	for(var/S in shoppinglist)
		if(!clear_turfs.len)
			break

		var/i = rand(1,clear_turfs.len)
		var/turf/pickedloc = clear_turfs[i]
		clear_turfs.Cut(i,i+1)
		shoppinglist -= S

		var/datum/supply_order/SO = S
		var/datum/supply_packs/SP = SO.object

		var/obj/A = new SP.containertype(pickedloc)
		A.name = "[SP.containername] [SO.comment ? "([SO.comment])":"" ]"

		//supply manifest generation begin
		var/obj/item/weapon/paper/manifest/slip
		if(!SP.contraband)
			slip = new /obj/item/weapon/paper/manifest(A)
			slip.is_copy = 0
			slip.info = "<h3>[command_name()] Shipping Manifest</h3><hr><br>"
			slip.info +="Order #[SO.ordernum]<br>"
			slip.info +="Destination: [station_name()]<br>"
			slip.info +="[orderedamount] PACKAGES IN THIS SHIPMENT<br>"
			slip.info +="CONTENTS:<br><ul>"

		//spawn the stuff, finish generating the manifest while you're at it
		if(SP.access)
			if(isnum(SP.access))
				A.req_access = list(SP.access)
			else if(islist(SP.access))
				var/list/L = SP.access // access var is a plain var, we need a list
				A.req_access = L.Copy()
			else
				log_debug("<span class='danger'>Supply pack with invalid access restriction [SP.access] encountered!</span>")

		var/list/contains
		if(istype(SP,/datum/supply_packs/randomised))
			var/datum/supply_packs/randomised/SPR = SP
			contains = list()
			if(SPR.contains.len)
				for(var/j=1,j<=SPR.num_contained,j++)
					contains += pick(SPR.contains)
		else
			contains = SP.contains

		for(var/typepath in contains)
			if(!typepath)
				continue

			var/number_of_items = max(1, contains[typepath])
			for(var/j = 1 to number_of_items)
				var/atom/B2 = new typepath(A)
				if(slip)
					slip.info += "<li>[B2.name]</li>" //add the item to the manifest

		//manifest finalisation
		if(slip)
			slip.info += "</ul><br>"
			slip.info += "CHECK CONTENTS AND STAMP BELOW THE LINE TO CONFIRM RECEIPT OF GOODS<hr>"

	return
