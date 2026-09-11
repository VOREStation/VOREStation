//Uncommenting ALLOW_HOLIDAYS in config.txt will enable Holidays

//Just thinking ahead! Here's the foundations to a more robust Holiday event system.
//It's easy as hell to add stuff. Just set Holiday to something using the switch (or something else)
//then use if(Holiday == "MyHoliday") to make stuff happen on that specific day only
//Please, Don't spam stuff up with easter eggs, I'd rather somebody just delete this than people cause
//the game to lag even more in the name of one-day content.

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//ALSO, MOST IMPORTANTLY: Don't add stupid stuff! Discuss bonus content with Project-Heads first please!//
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//																							~Carn

//Allows GA and GM to set the Holiday variable
ADMIN_VERB(Set_Holiday, R_SERVER, "Set Holiday", "Force-set the Holiday variable to make the game think it's a certain day.", ADMIN_CATEGORY_FUN_EVENT_KIT)
	GLOB.Holiday = list()

	var/H = tgui_input_text(user,"What holiday is it today?","Set Holiday")
	if(!H)
		return
	var/B = tgui_input_text(user,"Now explain what the holiday is about","Set Holiday", multiline = TRUE, prevent_enter = TRUE)
	if(!B)
		return


	GLOB.Holiday[H] = B

	//update our hub status
	world.update_status()
	Holiday_Game_Start()

	message_admins(span_notice("ADMIN: Event: [key_name(user)] force-set Holiday to \"[GLOB.Holiday]\""))
	log_admin("[key_name(user)] force-set Holiday to \"[GLOB.Holiday]\"")


//Run at the  start of a round
/proc/Holiday_Game_Start()
	if(GLOB.Holiday.len != 0)
		var/list/holidays = list()
		var/list/holiday_blurbs = list()
		for(var/p in GLOB.Holiday)
			holidays.Add(p)
			holiday_blurbs.Add("[GLOB.Holiday[p]]")
		var/holidays_string = english_list(holidays, nothing_text = "nothing", and_text = " and ", comma_text = ", ", final_comma_text = "" )
		to_chat(world, span_filter_system(span_blue("and...")))
		to_chat(world, span_filter_system("<h4>Happy [holidays_string] Everybody!</h4>"))
		if(holiday_blurbs.len != 0)
			for(var/blurb in holiday_blurbs)
				to_chat(world, span_filter_system(span_blue("<div align='center'>[blurb]</div>")))
		switch(GLOB.Holiday)			//special holidays
			//if("Easter")
				//do easter stuff
			if("Christmas Eve","Christmas")
				Christmas_Game_Start()

	return

//Nested in the random events loop. Will be triggered every 2 minutes
/proc/Holiday_Random_Event()
	if(isemptylist(GLOB.Holiday))
		return 0
	switch(GLOB.Holiday)			//special holidays
		//if("Easter")		//I'll make this into some helper procs at some point
/*			var/list/turf/simulated/floor/Floorlist = list()
			for(var/turf/simulated/floor/T)
				if(T.contents)
					Floorlist += T
			var/turf/simulated/floor/F = Floorlist[rand(1,Floorlist.len)]
			Floorlist = null
			var/obj/structure/closet/C = locate(/obj/structure/closet) in F
			var/obj/item/reagent_containers/food/snacks/chocolateegg/wrapped/Egg
			if( C )			Egg = new(C)
			else			Egg = new(F)
*/
/*			var/list/obj/containers = list()
			for(var/obj/item/storage/S in world)
				if(isNotStationLevel(S.z))	continue
				containers += S

			message_admins(span_notice("DEBUG: Event: Egg spawned at [Egg.loc] ([Egg.x],[Egg.y],[Egg.z])"))*/
		if("End of the World")
			if(prob(GLOB.eventchance))	GameOver()

		if("Christmas","Christmas Eve")
			if(prob(GLOB.eventchance))	ChristmasEvent()
