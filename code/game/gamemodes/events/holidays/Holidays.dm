//Uncommenting ALLOW_HOLIDAYS in config.txt will enable Holidays
var/global/list/Holiday = list() //Holidays are lists now, so we can have more than one holiday at the same time (hey, you never know).

//Just thinking ahead! Here's the foundations to a more robust Holiday event system.
//It's easy as hell to add stuff. Just set Holiday to something using the switch (or something else)
//then use if(Holiday == "MyHoliday") to make stuff happen on that specific day only
//Please, Don't spam stuff up with easter eggs, I'd rather somebody just delete this than people cause
//the game to lag even more in the name of one-day content.

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//ALSO, MOST IMPORTANTLY: Don't add stupid stuff! Discuss bonus content with Project-Heads first please!//
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//																							~Carn

/hook/startup/proc/updateHoliday()
	Get_Holiday()
	return 1

//sets up the Holiday global variable. Shouldbe called on game configuration or something.
/proc/Get_Holiday()
	if(!Holiday)	return		// Holiday stuff was not enabled in the config!

	Holiday = list()			// reset our switch now so we can recycle it as our Holiday name

	var/YY	=	text2num(time2text(world.timeofday, "YY")) 	// get the current year
	var/MM	=	text2num(time2text(world.timeofday, "MM")) 	// get the current month
	var/DD	=	text2num(time2text(world.timeofday, "DD")) 	// get the current day

	//Main switch. If any of these are too dumb/inappropriate, or you have better ones, feel free to change whatever
	//Holidays are now associate lists.  You should write holidays like this.
	//Holiday["Holiday Name Here"] = "Blurb about the holiday here."
	switch(MM)
		if(1)	//Jan
			switch(DD)
				if(1)
					Holiday["New Years's Day"] = "The day of the new solar year on Sol."
				if(12)
					Holiday["Vertalliq-Qerr"] = "Vertalliq-Qerr, translated to mean 'Festival of the Royals', is a \
					Skrell holiday that celebrates the Qerr-Katish and all they have provided for the rest of Skrell society, \
					it often features colourful displays and skilled performers take this time to show off some of their more \
					fancy displays."

		if(2)	//Feb
			switch(DD)
				if(2)
					Holiday["Groundhog Day"] = "An unoffical holiday based on ancient folklore that originated on Earth, \
					that involves the worship of an almighty groundhog, that could control the weather based on if it casted a shadow."
				if(14)
					Holiday["Valentine's Day"] = "An old holiday that revolves around romance and love."
				if(17)
					Holiday["Random Acts of Kindness Day"] = "An unoffical holiday that challenges everyone to perform \
					acts of kindness to their friends, co-workers, and strangers, for no reason."

		if(3)	//Mar
			switch(DD)
				if(3)
					Holiday["Qixm-tes"] = "Qixm-tes, or 'Day of mourning', is a Skrell holiday where Skrell gather at places \
					of worship and sing a song of mourning for all those who have died in service to their empire."
				if(14)
					Holiday["Pi Day"] = "An unoffical holiday celebrating the mathematical constant Pi.  It is celebrated on \
					March 14th, as the digits form 3 14, the first three significant digits of Pi.  Observance of Pi Day generally \
					involve eating (or throwing) pie, due to a pun.  Pies also tend to be round, and thus relatable to Pi."
				if(17)
					Holiday["St. Patrick's Day"] = "An old holiday originating from Earth, Sol, celebrating the color green, \
					shamrocks, attending parades, and drinking alcohol."
				if(27)
					if(YY == 16)
						Holiday["Easter"] = ""
				if(31)
					if(YY == 13)
						Holiday["Easter"] = ""

		if(4)	//Apr
			switch(DD)
				if(1)
					Holiday["April Fool's Day"] = "An old holiday that endevours one to pull pranks and spread hoaxes on their friends."
					if(YY == 18)
						Holiday["Easter"] = ""
				if(8)
					if(YY == 15)
						Holiday["Easter"] = ""
				if(16)
					if(YY == 17) //Easter can go die for all of this copypasta.
						Holiday["Easter"] = ""

				if(20)
					if(YY == 14)
						Holiday["Easter"] = ""
				if(22)
					Holiday["Earth Day"] = "A holiday of enviromentalism, that originated on it's namesake, Earth."

		if(5)	//May
			switch(DD)
				if(1)
					Holiday["Interstellar Workers' Day"] = "This holiday celebrates the work of laborers and the working class."
				if(18)
					Holiday["Remembrance Day"] = "Remembrance Day (or, as it is more informally known, Armistice Day) is a confederation-wide holiday \
					mostly observed by its member states since late 2520. Officially, it is a day of remembering the men and women who died in various armed conflicts \
					throughout human history. Unofficially, however, it is commonly treated as a holiday honoring the victims of the Human-Unathi war. \
					Observance of this day varies throughout human space, but most common traditions are the act of bringing flowers to graves,\
					attending parades, and the wearing of poppies (either paper or real) in one's clothing."
				if(28)
					Holiday["Jiql-tes"] = "A Skrellian holiday that translates to 'Day of Celebration', Skrell communities \
					gather for a grand feast and give gifts to friends and close relatives."

		if(6)	//Jun
			switch(DD)
				if(6)
					Holiday["Sapient Rights Day"] = "This holiday celebrates the passing of the Declaration of Sapient Rights by SolGov, which guarantees the \
					same protections humans are granted to all sapient, living species."
				if(14)
					Holiday["Blood Donor Day"] = "This holiday was created to raise awareness of the need for safe blood and blood products, \
					and to thank blood donors for their voluntary, life-saving gifts of blood."
				if(20)
					Holiday["Civil Servant's Day"] = "Civil Servant's Day is a holiday observed in SCG member states that honors civil servants everywhere,\
+					(especially those who are members of the armed forces and the emergency services), or have been or have been civil servants in the past."

		if(7)	//Jul
			switch(DD)
				if(1)
					Holiday["Doctors' Day"] = "A holiday that recognizes the services of physicians, commonly celebrated \
					in healthcare organizations and facilities."
				if(30)
					Holiday["Friendship Day"] = "An unoffical holiday that recognizes the value of friends and companionship.  Indeed, not having someone watch \
					your back while in space can be dangerous, and the cold, isolating nature of space makes friends all the more important."

		if(8)	//Aug
			switch(DD)
//				if(10)
//					Holiday["S'randarr's Day"] = "A Tajaran holiday that occurs on the longest day of the year in summer,
//					on Ahdomai. It is named after the Tajaran deity of Light, and huge celebrations are common."
//VOREStation Add - Of course we need this.
				if(8)
					Holiday["Vore Day"] = "A holiday representing the innate desire in all/most/some/a few of us to devour each other or be devoured. \
					That's probably why you're here, isn't it? Get to it, then!"
//VOREStation Add End.

				if(27)
					Holiday["Forgiveness Day"] = "A time to forgive and be forgiven."

		if(9)	//Sep
			switch(DD)
				if(17)
					Holiday["Qill-xamr"] = "Translated to 'Night of the dead', it is a Skrell holiday where Skrell \
					communities hold parties in order to remember loved ones who passed, unlike Qixm-tes, this applies to everyone \
					and is a joyful celebration."
				if(19)
					Holiday["Talk-Like-a-Pirate Day"] = "Ahoy, matey!  Tis unoffical holiday be celebratin' the jolly \
					good humor of speakin' like the pirates of old."
				if(28)
					Holiday["Stupid-Questions Day"] = "Known as Ask A Stupid Question Day, it is an unoffical holiday \
					created by teachers in Sol, very long ago, to encourage students to ask more questions in the classroom."

		if(10)	//Oct
			switch(DD)
				if(16)
					Holiday["Boss' Day"] = "Boss' Day has traditionally been a day for employees to thank their bosses for the difficult work that they do \
					throughout the year. This day was created for the purpose of strengthening the bond between employer and employee."
				if(31)
					Holiday["Halloween"] = "Originating from Earth, Halloween is also known as All Saints' Eve, and \
					is celebrated by some by attending costume parties, trick-or-treating, carving faces in pumpkins, or visiting \
					'haunted' locations.  Some people make it a goal to scare other people."

		if(11)	//Nov
			switch(DD)
				if(13)
					Holiday["Kindness Day"] = "Kindness Day is an unofficial holiday to highlight good deeds in the \
					community, focusing on the positive power and the common thread of kindness which binds humanity and \
					friends together."
				if(28) //Space thanksgiving.
					Holiday["Appreciation Day"] = "Originally an old holiday from Earth, Appreciation Day follows many of the \
					traditions that its predecessor did, such as having a large feast (turkey often included), gathering with family, and being thankful \
					for what one has in life."
			if(28 > DD > 20)
				if(time2text(world.timeofday, "Day") == "Thursday")
					Holiday["Thanksgiving"] = "Originally an old holiday from Earth, Thanksgiving follows many of the \
					traditions that its predecessor did, such as having a large feast (turkey often included), gathering with family, and being thankful \
					for what one has in life."

		if(12)	//Dec
			switch(DD)
				if(10)
					Holiday["Human-Rights Day"] = "An old holiday created by an intergovernmental organization known back than as the United Nations, \
					human rights were not recognized globally at the time, and the holiday was made in honor of the Universal Declaration of Human Rights.  \
					These days, SolGov ensures that past efforts were not in vein, and continues to honor this holiday across the galaxy."
				if(22)
					Holiday["Vertalliq-qixim"] = "A Skrellian holiday that celebrates the Skrell's first landing on one of \
					their moons.  It's often celebrated with grand festivals."
				if(24)
					Holiday["Christmas Eve"] = "The eve of Christmas, an old holiday from Earth that mainly involves gift \
					giving, decorating, family reunions, and a fat red human breaking into people's homes to steal milk and cookies."
				if(25)
					Holiday["Christmas"] = "Christmas is a very old holiday that originated in Earth, Sol.  It was a \
					religious holiday for the Christian religion, which would later form Unitarianism.  Nowdays, the holiday is celebrated \
					generally by giving gifts, symbolic decoration, and reuniting with one's family.  It also features a mythical fat \
					red human, known as Santa, who broke into people's homes to loot cookies and milk."
				if(31)
					Holiday["New Year's Eve"] = "The eve of the New Year for Sol.  It is traditionally celebrated by counting down to midnight, as that is \
					when the new year begins.  Other activities include planning for self-improvement over the new year, attending New Year's parties, or \
					watching a timer count to zero, a large object descending, and fireworks exploding in the sky, in person or on broadcast."

	if(!Holiday)
		//Friday the 13th
		if(DD == 13)
			if(time2text(world.timeofday, "DDD") == "Fri")
				Holiday["Friday the 13th"] = "Friday the 13th is a superstitious day, associated with bad luck and misfortune."

//Allows GA and GM to set the Holiday variable
/client/proc/Set_Holiday()
	set name = ".Set Holiday"
	set category = "Fun"
	set desc = "Force-set the Holiday variable to make the game think it's a certain day."
	if(!check_rights(R_SERVER))	return

	Holiday = list()

	var/H = tgui_input_text(src,"What holiday is it today?","Set Holiday")
	var/B = tgui_input_text(src,"Now explain what the holiday is about","Set Holiday", multiline = TRUE, prevent_enter = TRUE)


	Holiday[H] = B

	//update our hub status
	world.update_status()
	Holiday_Game_Start()

	message_admins("<span class='notice'>ADMIN: Event: [key_name(src)] force-set Holiday to \"[Holiday]\"</span>")
	log_admin("[key_name(src)] force-set Holiday to \"[Holiday]\"")


//Run at the  start of a round
/proc/Holiday_Game_Start()
	if(Holiday.len != 0)
		var/list/holidays = list()
		var/list/holiday_blurbs = list()
		for(var/p in Holiday)
			holidays.Add(p)
			holiday_blurbs.Add("[Holiday[p]]")
		var/holidays_string = english_list(holidays, nothing_text = "nothing", and_text = " and ", comma_text = ", ", final_comma_text = "" )
		to_world("<font color='blue'>and...</font>")
		to_world("<h4>Happy [holidays_string] Everybody!</h4>")
		if(holiday_blurbs.len != 0)
			for(var/blurb in holiday_blurbs)
				to_world("<div align='center'><font color='blue'>[blurb]</font></div>")
		switch(Holiday)			//special holidays
			if("Easter")
				//do easter stuff
			if("Christmas Eve","Christmas")
				Christmas_Game_Start()

	return

//Nested in the random events loop. Will be triggered every 2 minutes
/proc/Holiday_Random_Event()
	if(isemptylist(Holiday))
		return 0
	switch(Holiday)			//special holidays
		if("Easter")		//I'll make this into some helper procs at some point
/*			var/list/turf/simulated/floor/Floorlist = list()
			for(var/turf/simulated/floor/T)
				if(T.contents)
					Floorlist += T
			var/turf/simulated/floor/F = Floorlist[rand(1,Floorlist.len)]
			Floorlist = null
			var/obj/structure/closet/C = locate(/obj/structure/closet) in F
			var/obj/item/weapon/reagent_containers/food/snacks/chocolateegg/wrapped/Egg
			if( C )			Egg = new(C)
			else			Egg = new(F)
*/
/*			var/list/obj/containers = list()
			for(var/obj/item/weapon/storage/S in world)
				if(isNotStationLevel(S.z))	continue
				containers += S

			message_admins("<span class='notice'>DEBUG: Event: Egg spawned at [Egg.loc] ([Egg.x],[Egg.y],[Egg.z])</span>")*/
		if("End of the World")
			if(prob(eventchance))	GameOver()

		if("Christmas","Christmas Eve")
			if(prob(eventchance))	ChristmasEvent()
