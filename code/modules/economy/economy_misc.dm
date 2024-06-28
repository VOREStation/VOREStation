//---- The following corporations are friendly with NanoTrasen and loosely enable trade and travel:
//Corporation NanoTrasen - Generalised / high tech research and phoron exploitation.
//Corporation Vessel Contracting - Ship and station construction, materials research.
//Corporation Osiris Atmospherics - Atmospherics machinery construction and chemical research.
//Corporation Second Red Cross Society - 26th century Red Cross reborn as a dominating economic force in biomedical science (research and materials).
//Corporation Blue Industries - High tech and high energy research, in particular into the mysteries of bluespace manipulation and power generation.
//Corporation Kusanagi Robotics - Founded by robotics legend Kaito Kusanagi in the 2070s, they have been on the forefront of mechanical augmentation and robotics development ever since.
//Corporation Free traders - Not so much a corporation as a loose coalition of spacers, Free Traders are a roving band of smugglers, traders and fringe elements following a rigid (if informal) code of loyalty and honour. Mistrusted by most corporations, they are tolerated because of their uncanny ability to smell out a profit.

//---- Descriptions of destination types
//Space stations can be purpose built for a number of different things, but generally require regular shipments of essential supplies.
//Corvettes are small, fast warships generally assigned to border patrol or chasing down smugglers.
//Battleships are large, heavy cruisers designed for slugging it out with other heavies or razing planets.
//Yachts are fast civilian craft, often used for pleasure or smuggling.
//Destroyers are medium sized vessels, often used for escorting larger ships but able to go toe-to-toe with them if need be.
//Frigates are medium sized vessels, often used for escorting larger ships. They will rapidly find themselves outclassed if forced to face heavy warships head on.

var/global/current_date_string

var/global/datum/money_account/vendor_account
var/global/datum/money_account/station_account
var/global/list/datum/money_account/department_accounts = list()
var/global/num_financial_terminals = 1
var/global/next_account_number = 0
var/global/list/all_money_accounts = list()
var/global/list/transaction_devices = list()
var/global/economy_init = 0

/proc/setup_economy()
	if(economy_init)
		return 2

	//news_network.CreateFeedChannel("The [using_map.starsys_name] Times", "[using_map.starsys_name] Times ExoNode - [using_map.station_short]", 1, 1)
	news_network.CreateFeedChannel("The Gibson Gazette", "Editor Mike Hammers", 1, 1)
	news_network.CreateFeedChannel("Oculum Content Aggregator", "Oculus v6rev7", 1, 1)

	for(var/loc_type in subtypesof(/datum/trade_destination))
		var/datum/trade_destination/D = new loc_type
		weighted_randomevent_locations[D] = D.viable_random_events.len
		weighted_mundaneevent_locations[D] = D.mundane_probability

	create_station_account()

	for(var/department in station_departments)
		create_department_account(department)
	create_department_account("Vendor")
	vendor_account = department_accounts["Vendor"]

	for(var/obj/item/device/retail_scanner/RS in transaction_devices)
		if(RS.account_to_connect)
			RS.linked_account = department_accounts[RS.account_to_connect]
	for(var/obj/machinery/cash_register/CR in transaction_devices)
		if(CR.account_to_connect)
			CR.linked_account = department_accounts[CR.account_to_connect]

	current_date_string = "[num2text(rand(1,31))] [pick("January","February","March","April","May","June","July","August","September","October","November","December")], [game_year]"

	economy_init = 1
	return 1

/proc/create_station_account()
	if(!station_account)
		next_account_number = rand(111111, 999999)

		station_account = new()
		station_account.owner_name = "[station_name()] Station Account"
		station_account.account_number = rand(111111, 999999)
		station_account.remote_access_pin = rand(1111, 111111)
		station_account.money = 75000

		//create an entry in the account transaction log for when it was created
		var/datum/transaction/T = new()
		T.target_name = station_account.owner_name
		T.purpose = "Account creation"
		T.amount = 75000
		T.date = "2nd April, 2555"
		T.time = "11:24"
		T.source_terminal = "Biesel GalaxyNet Terminal #277"

		//add the account
		station_account.transaction_log.Add(T)
		all_money_accounts.Add(station_account)

/proc/create_department_account(department)
	next_account_number = rand(111111, 999999)

	var/datum/money_account/department_account = new()
	department_account.owner_name = "[department] Account"
	department_account.account_number = rand(111111, 999999)
	department_account.remote_access_pin = rand(1111, 111111)
	department_account.money = 5000

	//create an entry in the account transaction log for when it was created
	var/datum/transaction/T = new()
	T.target_name = department_account.owner_name
	T.purpose = "Account creation"
	T.amount = department_account.money
	T.date = "2nd April, 2555"
	T.time = "11:24"
	T.source_terminal = "Biesel GalaxyNet Terminal #277"

	//add the account
	department_account.transaction_log.Add(T)
	all_money_accounts.Add(department_account)

	department_accounts[department] = department_account
