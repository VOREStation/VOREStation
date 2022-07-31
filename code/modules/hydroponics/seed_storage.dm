/datum/seed_pile
	var/name
	var/amount
	var/datum/seed/seed_type // Keeps track of what our seed is
	var/list/obj/item/seeds/seeds = list() // Tracks actual objects contained in the pile
	var/ID

/datum/seed_pile/New(var/obj/item/seeds/O, var/ID)
	name = O.name
	amount = 1
	seed_type = O.seed
	seeds += O
	src.ID = ID

/datum/seed_pile/proc/matches(var/obj/item/seeds/O)
	if (O.seed == seed_type)
		return 1
	return 0

/obj/machinery/seed_storage
	name = "Seed storage"
	desc = "It stores, sorts, and dispenses seeds."
	icon = 'icons/obj/vending.dmi'
	icon_state = "seeds"
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 100

	var/seeds_initialized = 0 // Map-placed ones break if seeds are loaded right at the start of the round, so we do it on the first interaction
	var/list/datum/seed_pile/piles = list()
	var/list/datum/seed_pile/piles_contra = list() //Hacked.
	var/list/starting_seeds = list()
	var/list/contraband_seeds = list() //Seeds we only show if we've been hacked.
	var/list/scanner = list() // What properties we can view
	var/seconds_electrified = 0 //Shock users like an airlock.
	var/smart = 0 //Used for hacking. Overrides the scanner.
	var/hacked = 0
	var/lockdown = 0
	var/datum/wires/seedstorage/wires = null

/obj/machinery/seed_storage/Initialize()
	. = ..()
	wires = new(src)
	if(!contraband_seeds.len)
		contraband_seeds = pick( 	/// Some form of ambrosia in all lists.
			prob(30);list( /// General produce
				/obj/item/seeds/ambrosiavulgarisseed = 3,
				/obj/item/seeds/greengrapeseed = 3,
				/obj/item/seeds/icepepperseed = 2,
				/obj/item/seeds/kudzuseed = 1
			),
			prob(30);list( ///Mushroom batch
				/obj/item/seeds/ambrosiavulgarisseed = 1,
				/obj/item/seeds/glowberryseed = 2,
				/obj/item/seeds/libertymycelium = 1,
				/obj/item/seeds/reishimycelium = 2,
				/obj/item/seeds/sporemycelium = 1
			),
			prob(15);list( /// Survivalist
				/obj/item/seeds/ambrosiadeusseed = 2,
				/obj/item/seeds/redtowermycelium = 2,
				/obj/item/seeds/vale = 2,
				/obj/item/seeds/siflettuce = 2
			),
			prob(20);list( /// Cold plants
				/obj/item/seeds/ambrosiavulgarisseed = 2,
				/obj/item/seeds/thaadra = 2,
				/obj/item/seeds/icepepperseed = 2,
				/obj/item/seeds/siflettuce = 1
			),
			prob(10);list( ///Poison party
				/obj/item/seeds/ambrosiavulgarisseed = 3,
				/obj/item/seeds/surik = 1,
				/obj/item/seeds/telriis = 1,
				/obj/item/seeds/nettleseed = 2,
				/obj/item/seeds/poisonberryseed = 1
			),
			prob(5);list( /// Extra poison party!
				/obj/item/seeds/ambrosiainfernusseed = 1,
				/obj/item/seeds/amauri = 1,
				/obj/item/seeds/surik = 1,
				/obj/item/seeds/deathberryseed = 1 /// Very ow.
			)
		)
	return

/obj/machinery/seed_storage/process()
	..()
	if(seconds_electrified > 0)
		seconds_electrified--
	return

/obj/machinery/seed_storage/random // This is mostly for testing, but I guess admins could spawn it
	name = "Random seed storage"
	scanner = list("stats", "produce", "soil", "temperature", "light", "pressure")
	starting_seeds = list(/obj/item/seeds/random = 50)

/obj/machinery/seed_storage/garden
	name = "Garden seed storage"
	scanner = list("stats")
	starting_seeds = list(
		/obj/item/seeds/appleseed = 3,
		/obj/item/seeds/bananaseed = 3,
		/obj/item/seeds/berryseed = 3,
		/obj/item/seeds/cabbageseed = 3,
		/obj/item/seeds/carrotseed = 3,
		/obj/item/seeds/celery = 3,
		/obj/item/seeds/chantermycelium = 3,
		/obj/item/seeds/cherryseed = 3,
		/obj/item/seeds/chiliseed = 3,
		/obj/item/seeds/cocoapodseed = 3,
		/obj/item/seeds/cornseed = 3,
		/obj/item/seeds/durian = 3,
		/obj/item/seeds/eggplantseed = 3,
		/obj/item/seeds/grapeseed = 3,
		/obj/item/seeds/grassseed = 3,
		/obj/item/seeds/replicapod = 3,
		/obj/item/seeds/lavenderseed = 3,
		/obj/item/seeds/lemonseed = 3,
		/obj/item/seeds/lettuce = 3,
		/obj/item/seeds/limeseed = 3,
		/obj/item/seeds/mtearseed = 2,
		/obj/item/seeds/orangeseed = 3,
		/obj/item/seeds/onionseed = 3,
		/obj/item/seeds/peanutseed = 3,
		/obj/item/seeds/plumpmycelium = 3,
		/obj/item/seeds/poppyseed = 3,
		/obj/item/seeds/potatoseed = 3,
		/obj/item/seeds/pumpkinseed = 3,
		/obj/item/seeds/rhubarb = 3,
		/obj/item/seeds/riceseed = 3,
		/obj/item/seeds/rose = 3,
		/obj/item/seeds/soyaseed = 3,
		/obj/item/seeds/pineapple = 3,
		/obj/item/seeds/sugarcaneseed = 3,
		/obj/item/seeds/sunflowerseed = 3,
		/obj/item/seeds/shandseed = 2,
		/obj/item/seeds/tobaccoseed = 3,
		/obj/item/seeds/tomatoseed = 3,
		/obj/item/seeds/towermycelium = 3,
		/obj/item/seeds/vanilla = 3,
		/obj/item/seeds/wabback = 2,
		/obj/item/seeds/watermelonseed = 3,
		/obj/item/seeds/wheatseed = 3,
		/obj/item/seeds/whitebeetseed = 3,
		/obj/item/seeds/wurmwoad = 3
		)

/obj/machinery/seed_storage/xenobotany
	name = "Xenobotany seed storage"
	scanner = list("stats", "produce", "soil", "temperature", "light", "pressure")
	smart = 1
	starting_seeds = list(
		/obj/item/seeds/ambrosiavulgarisseed = 3,
		/obj/item/seeds/appleseed = 3,
		/obj/item/seeds/amanitamycelium = 2,
		/obj/item/seeds/bananaseed = 3,
		/obj/item/seeds/berryseed = 3,
		/obj/item/seeds/cabbageseed = 3,
		/obj/item/seeds/carrotseed = 3,
		/obj/item/seeds/celery = 3,
		/obj/item/seeds/chantermycelium = 3,
		/obj/item/seeds/cherryseed = 3,
		/obj/item/seeds/chiliseed = 3,
		/obj/item/seeds/cocoapodseed = 3,
		/obj/item/seeds/cornseed = 3,
		/obj/item/seeds/durian = 3,
		/obj/item/seeds/replicapod = 3,
		/obj/item/seeds/eggplantseed = 3,
		/obj/item/seeds/glowshroom = 2,
		/obj/item/seeds/grapeseed = 3,
		/obj/item/seeds/grassseed = 3,
		/obj/item/seeds/lavenderseed = 3,
		/obj/item/seeds/lemonseed = 3,
		/obj/item/seeds/lettuce = 3,
		/obj/item/seeds/libertymycelium = 2,
		/obj/item/seeds/limeseed = 3,
		/obj/item/seeds/mtearseed = 2,
		/obj/item/seeds/nettleseed = 2,
		/obj/item/seeds/orangeseed = 3,
		/obj/item/seeds/peanutseed = 3,
		/obj/item/seeds/plastiseed = 3,
		/obj/item/seeds/plumpmycelium = 3,
		/obj/item/seeds/poppyseed = 3,
		/obj/item/seeds/potatoseed = 3,
		/obj/item/seeds/pumpkinseed = 3,
		/obj/item/seeds/reishimycelium = 2,
		/obj/item/seeds/rhubarb = 3,
		/obj/item/seeds/riceseed = 3,
		/obj/item/seeds/rose = 3,
		/obj/item/seeds/soyaseed = 3,
		/obj/item/seeds/pineapple = 3,
		/obj/item/seeds/sugarcaneseed = 3,
		/obj/item/seeds/sunflowerseed = 3,
		/obj/item/seeds/shandseed = 2,
		/obj/item/seeds/tobaccoseed = 3,
		/obj/item/seeds/tomatoseed = 3,
		/obj/item/seeds/towermycelium = 3,
		/obj/item/seeds/vanilla = 3,
		/obj/item/seeds/wabback = 2,
		/obj/item/seeds/watermelonseed = 3,
		/obj/item/seeds/wheatseed = 3,
		/obj/item/seeds/whitebeetseed = 3,
		/obj/item/seeds/wurmwoad = 3
		)

/obj/machinery/seed_storage/attack_hand(mob/user as mob)
	if(stat & (BROKEN|NOPOWER))
		return

	if(seconds_electrified != 0)
		if(shock(user, 100))
			return

	if(panel_open)
		wires.Interact(user)
	if(lockdown)
		return
	user.set_machine(src)
	tgui_interact(user)

/obj/machinery/seed_storage/tgui_interact(mob/user, datum/tgui/ui)
	if(!seeds_initialized)
		for(var/typepath in starting_seeds)
			var/amount = starting_seeds[typepath]
			if(isnull(amount)) amount = 1

			for(var/i = 1 to amount)
				var/O = new typepath
				add(O)
		for(var/typepath in contraband_seeds)
			var/amount = contraband_seeds[typepath]
			if(isnull(amount)) amount = 1

			for (var/i = 1 to amount)
				var/O = new typepath
				add(O, 1)
		seeds_initialized = 1

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SeedStorage", name)
		ui.open()

/obj/machinery/seed_storage/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	if(smart)
		scanner = list("stats", "produce", "soil", "temperature", "light", "pressure")
	else
		scanner = initial(scanner)

	data["scanner"] = scanner

	var/list/piles_to_check = piles
	if(hacked || emagged)
		piles_to_check = piles + piles_contra

	var/list/seeds = list()
	for(var/datum/seed_pile/S in piles_to_check)
		var/datum/seed/seed = S.seed_type
		if(!seed)
			continue
		var/list/seedinfo = list(
			"name" = seed.seed_name,
			"uid" = seed.uid,
			"amount" = S.amount,
			"id" = S.ID,
		)

		seedinfo["traits"] = list()
		if("stats" in scanner)
			seedinfo["traits"]["Endurance"] = seed.get_trait(TRAIT_ENDURANCE)
			seedinfo["traits"]["Yield"] = seed.get_trait(TRAIT_YIELD)
			seedinfo["traits"]["Production"] = seed.get_trait(TRAIT_PRODUCTION)
			seedinfo["traits"]["Potency"] = seed.get_trait(TRAIT_POTENCY)
			seedinfo["traits"]["Repeat Harvest"] = seed.get_trait(TRAIT_HARVEST_REPEAT)
		if("temperature" in scanner)
			seedinfo["traits"]["Ideal Heat"] = seed.get_trait(TRAIT_IDEAL_HEAT)
		if("light" in scanner)
			seedinfo["traits"]["Ideal Light"] = seed.get_trait(TRAIT_IDEAL_LIGHT)
		if("soil" in scanner)
			if(seed.get_trait(TRAIT_REQUIRES_NUTRIENTS))
				if(seed.get_trait(TRAIT_NUTRIENT_CONSUMPTION) < 0.05)
					seedinfo["traits"]["Nutrient Consumption"] = "Low"
				else if(seed.get_trait(TRAIT_NUTRIENT_CONSUMPTION) > 0.2)
					seedinfo["traits"]["Nutrient Consumption"] = "High"
				else
					seedinfo["traits"]["Nutrient Consumption"] = "Norm"
			else
				seedinfo["traits"]["Nutrient Consumption"] = "No"
			if(seed.get_trait(TRAIT_REQUIRES_WATER))
				if(seed.get_trait(TRAIT_WATER_CONSUMPTION) < 1)
					seedinfo["traits"]["Water Consumption"] = "Low"
				else if(seed.get_trait(TRAIT_WATER_CONSUMPTION) > 5)
					seedinfo["traits"]["Water Consumption"] = "High"
				else
					seedinfo["traits"]["Water Consumption"] = "Norm"
			else
				seedinfo["traits"]["Water Consumption"] = "No"

		seedinfo["traits"]["notes"] = ""
		switch(seed.get_trait(TRAIT_CARNIVOROUS))
			if(1)
				seedinfo["traits"]["notes"] += "CARN "
			if(2)
				seedinfo["traits"]["notes"] += "FASTCARN"
		switch(seed.get_trait(TRAIT_SPREAD))
			if(1)
				seedinfo["traits"]["notes"] += "VINE "
			if(2)
				seedinfo["traits"]["notes"] += "FASTVINE"
		if ("pressure" in scanner)
			if(seed.get_trait(TRAIT_LOWKPA_TOLERANCE) < 20)
				seedinfo["traits"]["notes"] += "LP "
			if(seed.get_trait(TRAIT_HIGHKPA_TOLERANCE) > 220)
				seedinfo["traits"]["notes"] += "HP "
		if ("temperature" in scanner)
			if(seed.get_trait(TRAIT_HEAT_TOLERANCE) > 30)
				seedinfo["traits"]["notes"] += "TEMRES "
			else if(seed.get_trait(TRAIT_HEAT_TOLERANCE) < 10)
				seedinfo["traits"]["notes"] += "TEMSEN "
		if ("light" in scanner)
			if(seed.get_trait(TRAIT_LIGHT_TOLERANCE) > 10)
				seedinfo["traits"]["notes"] += "LIGRES "
			else if(seed.get_trait(TRAIT_LIGHT_TOLERANCE) < 3)
				seedinfo["traits"]["notes"] += "LIGSEN "
		if(seed.get_trait(TRAIT_TOXINS_TOLERANCE) < 3)
			seedinfo["traits"]["notes"] += "TOXSEN "
		else if(seed.get_trait(TRAIT_TOXINS_TOLERANCE) > 6)
			seedinfo["traits"]["notes"] += "TOXRES "
		if(seed.get_trait(TRAIT_PEST_TOLERANCE) < 3)
			seedinfo["traits"]["notes"] += "PESTSEN "
		else if(seed.get_trait(TRAIT_PEST_TOLERANCE) > 6)
			seedinfo["traits"]["notes"] += "PESTRES "
		if(seed.get_trait(TRAIT_WEED_TOLERANCE) < 3)
			seedinfo["traits"]["notes"] += "WEEDSEN "
		else if(seed.get_trait(TRAIT_WEED_TOLERANCE) > 6)
			seedinfo["traits"]["notes"] += "WEEDRES "
		if(seed.get_trait(TRAIT_PARASITE))
			seedinfo["traits"]["notes"] += "PAR "
		if ("temperature" in scanner)
			if(seed.get_trait(TRAIT_ALTER_TEMP) > 0)
				seedinfo["traits"]["notes"] += "TEMP+ "
			if(seed.get_trait(TRAIT_ALTER_TEMP) < 0)
				seedinfo["traits"]["notes"] += "TEMP- "
		if(seed.get_trait(TRAIT_BIOLUM))
			seedinfo["traits"]["notes"] += "LUM "

		seeds.Add(list(seedinfo))

	data["seeds"] = seeds

	return data

/obj/machinery/seed_storage/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE
	var/ID = text2num(params["id"])

	var/list/piles_to_check = piles
	if(hacked || emagged)
		piles_to_check = piles + piles_contra

	for(var/datum/seed_pile/N in piles_to_check)
		if(N.ID == ID)
			if(action == "vend")
				var/obj/O = pick(N.seeds)
				if(O)
					--N.amount
					N.seeds -= O
					if(N.amount <= 0 || N.seeds.len <= 0)
						piles -= N
						qdel(N)
					O.loc = src.loc
				else
					piles -= N
					qdel(N)
				return TRUE
			else if(action == "purge")
				for(var/obj/O in N.seeds)
					qdel(O)
					piles -= N
					qdel(N)
				return TRUE
			break

/obj/machinery/seed_storage/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if (istype(O, /obj/item/seeds) && !lockdown)
		add(O)
		user.visible_message("[user] puts \the [O.name] into \the [src].", "You put \the [O] into \the [src].")
		return
	else if (istype(O, /obj/item/storage/bag/plants) && !lockdown)
		var/obj/item/storage/P = O
		var/loaded = 0
		for(var/obj/item/seeds/G in P.contents)
			++loaded
			add(G)
		if (loaded)
			user.visible_message("[user] puts the seeds from \the [O.name] into \the [src].", "You put the seeds from \the [O.name] into \the [src].")
		else
			to_chat(user, "<span class='notice'>There are no seeds in \the [O.name].</span>")
		return
	else if(O.is_wrench())
		playsound(src, O.usesound, 50, 1)
		anchored = !anchored
		to_chat(user, "You [anchored ? "wrench" : "unwrench"] \the [src].")
	else if(O.is_screwdriver())
		panel_open = !panel_open
		to_chat(user, "You [panel_open ? "open" : "close"] the maintenance panel.")
		playsound(src, O.usesound, 50, 1)
		cut_overlays()
		if(panel_open)
			overlays += image(icon, "[initial(icon_state)]-panel")
	else if((O.is_wirecutter() || istype(O, /obj/item/multitool)) && panel_open)
		wires.Interact(user)

/obj/machinery/seed_storage/emag_act(var/remaining_charges, var/mob/user)
	if(!src.emagged)
		emagged = 1
		if(lockdown)
			to_chat(user, "<span class='notice'>\The [src]'s control panel thunks, as its cover retracts.</span>")
			lockdown = 0
		if(LAZYLEN(req_access) || LAZYLEN(req_one_access))
			req_access = list()
			req_one_access = list()
			to_chat(user, "<span class='warning'>\The [src]'s access mechanism shorts out.</span>")
			var/datum/effect_system/spark_spread/sparks = new /datum/effect_system/spark_spread()
			sparks.set_up(3, 0, get_turf(src))
			sparks.start()
			visible_message("<span class='warning'>\The [src]'s panel sparks!</span>")
			qdel(sparks)
		return 1

/obj/machinery/seed_storage/proc/add(var/obj/item/seeds/O as obj, var/contraband = 0)
	if (istype(O.loc, /mob))
		var/mob/user = O.loc
		user.remove_from_mob(O)
	else if(istype(O.loc,/obj/item/storage))
		var/obj/item/storage/S = O.loc
		S.remove_from_storage(O, src)

	O.loc = src
	var/newID = 0

	if(contraband)
		var/datum/seed_pile/final_pile = piles[piles.len]
		newID = final_pile.ID + 1
		for (var/datum/seed_pile/N in piles_contra)
			if (N.matches(O))
				++N.amount
				N.seeds += (O)
				return
			else if(N.ID >= newID)
				newID = N.ID + 1
		piles_contra += new /datum/seed_pile(O, newID)
		return

	for (var/datum/seed_pile/N in piles)
		if (N.matches(O))
			++N.amount
			N.seeds += (O)
			return
		else if(N.ID >= newID)
			newID = N.ID + 1

	piles += new /datum/seed_pile(O, newID)

	return
