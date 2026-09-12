GLOBAL_LIST_INIT(holiday_mail, list())
GLOBAL_LIST(holidays)

/proc/check_holidays(holiday_to_find)
	if(isnull(GLOB.holidays))
		return // Failed to generate holidays, for some reason

	return GLOB.holidays[holiday_to_find]

/**
 * Fills the holidays list if applicable, or leaves it an empty list.
 */
/proc/fill_holidays()
	GLOB.holidays = list()
	for(var/holiday_type in subtypesof(/datum/holiday))
		var/datum/holiday/holiday = new holiday_type()
		var/delete_holiday = TRUE
		for(var/timezone in holiday.timezones)
			var/time_in_timezone = world.realtime + timezone HOURS

			var/YYYY = text2num(time2text(time_in_timezone, "YYYY", world.timezone)) // get the current year
			var/MM = text2num(time2text(time_in_timezone, "MM", world.timezone)) // get the current month
			var/DD = text2num(time2text(time_in_timezone, "DD", world.timezone)) // get the current day
			var/DDD = time2text(time_in_timezone, "DDD", world.timezone) // get the current weekday

			if(holiday.shouldCelebrate(DD, MM, YYYY, DDD))
				holiday.celebrate()
				GLOB.holidays[holiday.name] = holiday
				delete_holiday = FALSE
				break
		if(delete_holiday)
			qdel(holiday)

	if(GLOB.holidays.len)
		shuffle_inplace(GLOB.holidays)

	return TRUE

// Run at the start of a round
/proc/Holiday_Game_Start()
	if(isnull(GLOB.holidays))
		return

	var/list/holidays = list()
	var/list/holiday_blurbs = list()

	for(var/holiday in GLOB.holidays)
		var/datum/holiday/merry = GLOB.holidays[holiday]
		holidays.Add(merry.name)
		holiday_blurbs.Add(merry.greet())
	var/holidays_string = english_list(holidays, nothing_text = "nothing", and_text = " and ", comma_text = ", ", final_comma_text = "" )
	to_chat(world, span_filter_system(span_blue("and...")))
	to_chat(world, span_filter_system("<h4>Happy [holidays_string] Everybody!</h4>"))
	if(holiday_blurbs.len != 0)
		for(var/blurb in holiday_blurbs)
			to_chat(world, span_filter_system(span_blue("<div align='center'>[blurb]</div>")))
	return

//Allows GA and GM to set the Holiday
ADMIN_VERB(Set_Holiday, R_SERVER, "Set Holiday", "Force-set the Holiday to make the game think it's a certain day.", ADMIN_CATEGORY_FUN_EVENT_KIT)
	var/list/holiday_list = list()
	for(var/datum/holiday/holiday_type in subtypesof(/datum/holiday))
		var/datum/holiday/holiday = new holiday_type()
		holiday_list[holiday.name] += holiday

	var/holid = tgui_input_list(user, "What holiday is it today?", "Set Holiday", holiday_list)
	if(!holid)
		return

	var/datum/holiday/picked_holiday = holiday_list[holid]

	picked_holiday.celebrate()

	message_admins(span_notice("ADMIN: Event: [key_name(user)] force-set Holiday to \"[picked_holiday.name]\""))
	log_admin("[key_name(user)] force-set Holiday to \"[picked_holiday.name]\"")


/datum/holiday
	/// Name of the holiday itself. Visible to the player.Get_Holiday()
	var/name = "If you see this, the holiday code is broken."
	/// What day does it begin?
	var/begin_day = 1
	/// What month does the holiday begin on?
	var/begin_month = 0
	/// What day of end_month does the holida end? Default of 9 means the holiday lasts a single day.
	var/end_day = 0
	///What month the holiday ends on?
	var/end_month = 0
	// Forces a holiday to be celebrated
	var/always_celebrate = FALSE
	/// Held variable to better calculate when certain holidays may fall on, like easter.
	var/current_year = 0
	/// How many years are you offsetting your calculations for begin_day and end_day on. Used for holidays like easter.
	var/year_offset = 0
	///Timezones this holiday is celebrated in (defaults to three timezones spanning a 50 hour window covering all timezones)
	var/list/timezones = list(TIMEZONE_LINT, TIMEZONE_UTC, TIMEZONE_ANYWHERE_ON_EARTH)
	///If this is defined, drones/assistants without a default hat will spawn with this item in their head clothing slot.
	var/obj/item/holiday_hat
	///When this holiday is active, does this prevent mail from arriving to cargo? Overrides var/list/holiday_mail. Try not to use this for longer holidays.
	var/no_mail_holiday = FALSE
	/// The list of items we add to the mail pool. Can either be a weighted list or a normal list. Leave empty for nothing.
	var/list/holiday_mail = list()
	/// Color scheme for this holiday
	var/list/holiday_colors
	/// The default pattern of the holiday, if the requested pattern is null.
	var/holiday_pattern = PATTERN_DEFAULT

// This proc gets run before the game starts when the holiday is activated. Do festive shit here.
/datum/holiday/proc/celebrate()
	if(no_mail_holiday)
		SSmail.mail_blocked = TRUE
	if(LAZYLEN(holiday_mail) && !no_mail_holiday)
		GLOB.holiday_mail += holiday_mail
	return

// When the round starts, this proc is ran to get a text message to display to everyone to wish them a happy holiday
/datum/holiday/proc/greet()
	return "Have a happy [name]!"

// Return 1 if this holidy should be celebrated today
/datum/holiday/proc/shouldCelebrate(dd, mm, yyyy, ddd)
	if(always_celebrate)
		return TRUE

	if(!end_day)
		end_day = begin_day
	if(!end_month)
		end_month = begin_month
	if(end_month > begin_month) //holiday spans multiple months in one year
		if(mm == end_month) //in final month
			if(dd <= end_day)
				return TRUE

		else if(mm == begin_month)//in first month
			if(dd >= begin_day)
				return TRUE

		else if(mm in begin_month to end_month) //holiday spans 3+ months and we're in the middle, day doesn't matter at all
			return TRUE

	else if(end_month == begin_month) // starts and stops in same month, simplest case
		if(mm == begin_month && (dd in begin_day to end_day))
			return TRUE

	else // starts in one year, ends in the next
		if(mm >= begin_month && dd >= begin_day) // Holiday ends next year
			return TRUE
		if(mm <= end_month && dd <= end_day) // Holiday started last year
			return TRUE

	return FALSE

/datum/holiday/proc/get_holiday_colors(atom/thing_to_color, pattern)
	return get_decoration_color_from_pattern(thing_to_color, pattern || holiday_pattern, holiday_colors)

// January

/datum/holiday/new_year
	name = HOLIDAY_NEWYEARS
	begin_month = JANUARY
	begin_day = 1

/datum/holiday/new_year/greet()
	return "The day of the new solar year on Sol."

/datum/holiday/vertalliq
	name = HOLIDAY_VERTALLIQ
	begin_month = JANUARY
	begin_day = 12

/datum/holiday/vertalliq/greet()
	return "Vertalliq-Qerr, translated to mean 'Festival of the Royals', is a \
					skrellian holiday that celebrates the Qerr-Katish and all they have provided for the rest of skrellian society, \
					it often features colourful displays and skilled performers take this time to show off some of their more \
					elaborate displays."

/datum/holiday/lohri
	name = HOLIDAY_LOHRI
	begin_month = JANUARY
	begin_day = 14

/datum/holiday/lohri/greet()
	return "A human festival traditionally celebrating the end of winter on the Indian subcontinent. \
					The holiday is now celebrated independently of seasons in many colonies with large populations of Indian \
					descent. Traditions include the burning of bonfires, dancing, and door-to-door singing in exchange for treats."

/datum/holiday/lunarnewyear
	name = HOLIDAY_LUNARNEWYEAR
	begin_month = JANUARY
	begin_day = 30

/datum/holiday/lunarnewyear/greet()
	return "Originally the new year on the ancient lunisolar calendar, the Lunar New Year is \
					celebrated with a wide variety of east Asian traditions with roots in Chinese, Japanese, Korean, Vietnamese, \
					Tibetan, Mongolian, and Ryukyu cultures. Elaborate parades, performances, dances and meals are usual staples."

// February

/datum/holiday/groundhog
	name = HOLIDAY_GROUNDHOGDAY
	begin_month = FEBRUARY
	begin_day = 2

/datum/holiday/groundhog/greet()
	return "An unoffical holiday based on medieval folklore that originated on Earth, \
					that involves the reverence of a prophetic animal - traditionally a badger, fox or groundhog - that was \
					said to be able to predict, or even control the changing of the seasons."

/datum/holiday/valentine
	name = HOLIDAY_VALENTINE
	begin_month = FEBRUARY
	begin_day = 14
	holiday_mail = list(
		/obj/item/paper/card/heart,
		/obj/item/reagent_containers/food/snacks/chocolatepiece,
		/obj/item/reagent_containers/food/snacks/chocolatepiece/white,
		/obj/item/reagent_containers/food/snacks/chocolatepiece/truffle
	)

/datum/holiday/valentine/greet()
	return "A human holiday that revolves around expressions of romance and love. \
					In particular, the exchanging of gifts, letters and cards is traditional."

/datum/holiday/lantern
	name = HOLIDAY_LANTERNFEST
	begin_month = FEBRUARY
	begin_day = 15

/datum/holiday/lantern/greet()
	return "A human holiday with origins in Chinese new year celebrations. Participants \
					carry or hang elaborate paper lanterns that are thought to bring good luck. Today, electric lights are often used \
					in environments where open flames would be hazardous or non-functional."

/datum/holiday/actskindness
	name = HOLIDAY_KINDNESSACT
	begin_month = FEBRUARY
	begin_day = 17

/datum/holiday/actskindness/greet()
	return "An unoffical holiday that challenges everyone to perform \
					acts of kindness to their friends, co-workers, and strangers, with no strings attached."

/datum/holiday/leapday
	name = HOLIDAY_LEAP
	begin_month = FEBRUARY
	begin_day = 29

// March

/datum/holiday/qixmtes
	name = HOLIDAY_QIXMTES
	begin_month = MARCH
	begin_day = 3

/datum/holiday/qixmtes/greet()
	return "Qixm-tes, or 'Day of mourning', is a skrellian holiday where skrell gather at places \
					of worship and sing a song of mourning for all those who have died in service to their kingdoms."

/datum/holiday/pi
	name = HOLIDAY_PIDAY
	begin_month = MARCH
	begin_day = 14
	holiday_mail = list(
		/obj/item/reagent_containers/food/snacks/slice/pumpkinpie,
		/obj/item/reagent_containers/food/snacks/slice/lemoncake,
		/obj/item/reagent_containers/food/snacks/slice/limecake,
		/obj/item/reagent_containers/food/snacks/slice/braincake,
		/obj/item/reagent_containers/food/snacks/slice/birthdaycake,
		/obj/item/reagent_containers/food/snacks/slice/applecake,
		/obj/item/reagent_containers/food/snacks/slice/carrotcake,
		/obj/item/reagent_containers/food/snacks/slice/chocolatecake,
		/obj/item/reagent_containers/food/snacks/slice/carrotcake,
		/obj/item/reagent_containers/food/snacks/slice/plaincake
	)

/datum/holiday/pi/greet()
	return "An unoffical holiday celebrating the mathematical constant Pi.  It is celebrated on \
					March 14th, as the digits form 3 14, the first three significant digits of Pi.  Observance of Pi Day generally \
					involve eating (or throwing) pie, due to a pun.  Pies also tend to be round, and thus relatable to Pi."

/datum/holiday/patrick
	name = HOLIDAY_PATRICK
	begin_month = MARCH
	begin_day = 17
	holiday_colors = list(
		COLOR_IRISH_GREEN,
		COLOR_WHITE,
		COLOR_IRISH_ORANGE
	)
	holiday_pattern = PATTERN_VERTICAL_STRIPE
	holiday_mail = list(
		/obj/item/reagent_containers/food/drinks/bottle/small/ale
		// Add Irish Cream bottle too at some point
	)

/datum/holiday/patrick/greet()
	return "A holiday originating on Earth, celebrating a popular version of Irish culture. \
					Traditions include elaborate parades, wearing of the colour green, and drinking alcohol."

/datum/holiday/holi
	name = HOLIDAY_HOLI
	begin_month = MARCH
	begin_day = 18

/datum/holiday/holi/greet()
	return "Also known as the Festival of Colours, a human Hindu festival celebrating divine love and the \
					triumph of good over evil. Traditionally a bonfire is lit overnight, followed by the free-for-all smearing of \
					celebrants with colourful pigments, and the forgiveness of past wrongs."

// April

/datum/holiday/aprilfool
	name = HOLIDAY_APRILFOOLS
	begin_month = APRIL
	begin_day = 1
	holiday_mail = list(
		/obj/item/bananapeel
	)

/datum/holiday/aprilfool/greet()
	return "A human holiday that endevours one to pull pranks and spread hoaxes on their friends."

/datum/holiday/passover
	name = HOLIDAY_PASSOVERDAY
	begin_month = APRIL
	begin_day = 5

/datum/holiday/passover/greet()
	return "The first of eight days of a human holiday celebrating the exodus of ancient Jewish people \
					from slavery, and of the spring harvest. The most well-known tradition is the Sedar meal. The date was standardized in the 22nd century."

/datum/holiday/earth
	name = HOLIDAY_EARTHDAY
	begin_month = APRIL
	begin_day = 22

/datum/holiday/earth/greet()
	return "A holiday of enviromentalism, that originated on it's namesake, Earth."

// May

/datum/holiday/workday
	name = HOLIDAY_WORKERDAY
	begin_month = MAY
	begin_day = 1

/datum/holiday/workday/greet()
	return "This holiday celebrates the work of laborers and the working class."

/datum/holiday/remembrance
	name = HOLIDAY_REMEMBRANCEDAY
	begin_month = MAY
	begin_day = 18

/datum/holiday/remembrance/greet()
	return "Remembrance Day (or, as it is more informally known, Armistice Day) is a confederation-wide holiday \
					mostly observed by its member states since late 2280. Officially, it is a day of remembering the men and women who died in various armed conflicts \
					throughout human history. Unofficially, however, it is commonly treated as a holiday honoring the victims of the Human-Unathi war. \
					Observance of this day varies throughout human space, but most common traditions are the act of bringing flowers to graves,\
					attending parades, and the wearing of poppies (either paper or real) in one's clothing."

/datum/holiday/jiqltes
	name = HOLIDAY_JIQLTES
	begin_month = MAY
	begin_day = 28

/datum/holiday/jiqltes/greet()
	return "A skrellian holiday that translates to 'Day of Celebration', skrell communities \
					gather for a grand feast and give gifts to friends and close relatives."

// June

/datum/holiday/sapient
	name = HOLIDAY_SAPIENTDAY
	begin_month = JUNE
	begin_day = 6

/datum/holiday/sapient/greet()
	return "This holiday celebrates the passing of the Declaration of Sapient Rights by SolGov, which guarantees the \
					same protections humans are granted to all sapient, living species."

/datum/holiday/blood
	name = HOLIDAY_BLOODDAY
	begin_month = JUNE
	begin_day = 14

/datum/holiday/blood/greet()
	return "This holiday was created to raise awareness of the need for safe blood and blood products, \
					and to thank blood donors for their voluntary, life-saving gifts of blood."

/datum/holiday/civserv
	name = HOLIDAY_CIVSERDAY
	begin_month = JUNE
	begin_day = 20

/datum/holiday/civserv/greet()
	return "Civil Servant's Day is a holiday observed in SCG member states that honors civil servants everywhere,\
					(especially those who are members of the armed forces and the emergency services), or have been or have been civil servants in the past."

// July

/datum/holiday/doctor
	name = HOLIDAY_DOCTORDAY
	begin_month = JULY
	begin_day = 1
	holiday_hat = /obj/item/clothing/head/nursehat
	holiday_hat = list(
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/medical/ointment
	)

/datum/holiday/doctor/greet()
	return "A holiday that recognizes the services of physicians, commonly celebrated \
					in healthcare organizations and facilities."

/datum/holiday/friendship
	name = HOLIDAY_FRIENDSHIPDAY
	begin_month = JULY
	begin_day = 30

/datum/holiday/friendship/greet()
	return "An unoffical holiday that recognizes the value of friends and companionship.  Indeed, not having someone watch \
					your back while in space can be dangerous, and the cold, isolating nature of space makes friends all the more important."

// August

/datum/holiday/vore
	name = HOLIDAY_VOREDAY
	begin_month = AUGUST
	begin_day = 8
	holiday_colors = list(COLOR_LIGHT_PINK, COLOR_SALAD_GREEN)

/datum/holiday/vore/greet()
	return "A holiday representing the innate desire in all/most/some/a few of us to devour each other or be devoured. \
					That's probably why you're here, isn't it? Get to it, then!"

/datum/holiday/obon
	name = HOLIDAY_OBON
	begin_month = AUGUST
	begin_day = 20

/datum/holiday/obon/greet()
	return "An ancient Earth holiday originating in east Asia, for the honouring of one's ancestral spirits. \
					Traditions include the maintenance of grave sites and memorials, and community traditional dance performances."

/datum/holiday/forgiveness
	name = HOLIDAY_FORGIVENESS
	begin_month = AUGUST
	begin_day = 27

/datum/holiday/forgiveness/greet()
	return "A time to forgive and be forgiven."

// September

/datum/holiday/qillxamr
	name = HOLIDAY_QILLXAMR
	begin_month = SEPTEMBER
	begin_day = 17

/datum/holiday/qillxamr/greet()
	return "Translated to 'Night of the dead', it is a skrellian holiday where skrell \
					communities hold parties in order to remember loved ones who passed, unlike Qixm-tes, this applies to everyone \
					and is a joyful celebration."

/datum/holiday/pirate
	name = HOLIDAY_PIRATEDAY
	begin_month = SEPTEMBER
	begin_day = 19
	holiday_hat = /obj/item/clothing/head/pirate
	holiday_mail = list(
		/obj/item/reagent_containers/food/drinks/bottle/rum
	)

/datum/holiday/pirate/greet()
	return "Ahoy, matey! It be the unoffical holiday celebratin' the salty \
					sea humor of speakin' like the pirates of old."

/datum/holiday/rosh
	name = HOLIDAY_ROSHHASH
	begin_month = SEPTEMBER
	begin_day = 20

/datum/holiday/rosh/greet()
	return "An old human holiday that marks the traditional Hebrew new year."

/datum/holiday/stupidquestions
	name = HOLIDAY_STUPIDQUESTION
	begin_month = SEPTEMBER
	begin_day = 28

/datum/holiday/stupidquestions/greet()
	return "Known as Ask A Stupid Question Day, it is an unoffical holiday \
					created by teachers in Sol, very long ago, to encourage students to ask more questions in the classroom."

// October

/datum/holiday/lief
	name = HOLIDAY_LIEFERIKSSON
	begin_month = OCTOBER
	begin_day = 9

/datum/holiday/lief/greet()
	return "A day commemorating Norse explorer Lief Eriksson, an early Scandinavian cultural figure \
					who is thought to have been the first European to set foot in North America."

/datum/holiday/boss
	name = HOLIDAY_BOSSDAY
	begin_month = OCTOBER
	begin_day = 16

/datum/holiday/boss/greet()
	return "Boss' Day has traditionally been a day for employees to thank their bosses for the difficult work that they do \
					throughout the year. This day was created for the purpose of strengthening the bond between employer and employee."

/datum/holiday/diwali
	name = HOLIDAY_DIWALI
	begin_day = OCTOBER
	begin_day = 21

/datum/holiday/diwali/greet()
	return "An ancient Hindu, Jain and Sikh festival lasting five days, celebrating victory of light over darkness, good over \
					evil, and knowledge over ignorance. It is celebrated by the wearing of your finest clothes, decorating with oil lamps and rangolis, \
					fireworks, and gift-giving. Electric lights are often used in modern times where oil lamps would be hazardous or inoperable."

/datum/holiday/halloween
	name = HOLIDAY_HALLOWEEN
	begin_month = OCTOBER
	begin_day = 29
	end_day = 2
	end_month = NOVEMBER
	holiday_colors = list(COLOR_MOSTLY_PURE_ORANGE, COLOR_PRISONER_BLACK)

/datum/holiday/halloween/greet()
	return "Originating from Earth, Halloween is also known as All Saints' Eve, and \
					is celebrated by some by attending costume parties, trick-or-treating, carving faces in pumpkins, or visiting \
					'haunted' locations.  Some people make it a goal to scare other people."

// November

/datum/holiday/kindnessday
	name = HOLIDAY_KINDNESS
	begin_day = 13
	begin_month = NOVEMBER

/datum/holiday/appreciation
	name = HOLIDAY_APPRECIATION
	begin_month = NOVEMBER
	begin_day = 28

/datum/holiday/appreciation/greet()
	return "Originally an old holiday from Earth, Appreciation Day follows many of the \
					traditions that its predecessor did, such as having a large feast (turkey often included), gathering with family, and being thankful \
					for what one has in life."

// December

/datum/holiday/festive_season
	name = HOLIDAY_FESTIVE
	begin_day = 1
	begin_month = DECEMBER
	end_day = 31
	holiday_hat = /obj/item/clothing/head/santa

/datum/holiday/festive_season/greet()
	return "Have a nice festive season!"

/datum/holiday/human_rights
	name = HOLIDAY_HUMANRIGHTS
	begin_day = 10
	begin_month = DECEMBER

/datum/holiday/human_rights/greet()
	return "An old holiday created by an intergovernmental organization known back than as the United Nations, \
					human rights were not recognized globally at the time, and the holiday was made in honor of the Universal Declaration of Human Rights.  \
					These days, SolGov ensures that past efforts were not in vein, and continues to honor this holiday across the galaxy as a historical \
					reminder."

/datum/holiday/vertalliqqixim
	name = HOLIDAY_VERTALLIQIXIM
	begin_day = 22
	begin_month = DECEMBER

/datum/holiday/vertalliqqixim/greet()
	return "A skrellian holiday that celebrates the skrell's first landing on one of \
					their moons. It's often celebrated with grand festivals."

/datum/holiday/xmas
	name = HOLIDAY_CRHISTMAS
	begin_day = 18
	begin_month = DECEMBER
	end_day = 27
	holiday_hat = /obj/item/clothing/head/santa
	holiday_mail = list(
		/obj/item/clothing/accessory/sweater/uglyxmas,
		/obj/item/clothing/accessory/scarf/christmas,
		/obj/item/toy/xmas_cracker,
		/obj/item/reagent_containers/food/snacks/sugarcookie,
		/obj/item/gift
	)
	holiday_colors = list(
		COLOR_CHRISTMAS_GREEN,
		COLOR_CHRISTMAS_RED
	)

/datum/holiday/xmas/greet()
	return "Have a merry Christmas!"

/datum/holiday/xmas/celebrate()
	. = ..()
	for(var/obj/structure/flora/tree/pine/xmas in world)
		if(isNotStationLevel(xmas.z))
			continue
		for(var/turf/simulated/floor/T in orange(1, xmas))
			for(var/i = 1, i <= rand(1, 5), i++)
				new /obj/item/a_gift(T)

/datum/holiday/newyearseve
	name = HOLIDAY_NEWYEARSEVE
	begin_day = 31
	begin_month = DECEMBER
	no_mail_holiday = TRUE

/datum/holiday/newyearseve/greet()
	return"The eve of the New Year for Sol.  It is traditionally celebrated by counting down to midnight, as that is \
					when the new year begins.  Other activities include planning for self-improvement over the new year, attending New Year's parties, or \
					watching a timer count to zero, a large object descending, and fireworks exploding in the sky, in person or on broadcast."

// Special

/datum/holiday/friday_thirteen
	name = HOLIDAY_FRIDAY13
	holiday_colors = list(COLOR_PRISONER_BLACK)

/datum/holiday/friday_thirteen/shouldCelebrate(dd, mm, yyyy, ddd)
	if(dd == 13 && ddd == FRIDAY)
		return TRUE
	return FALSE

/datum/holiday/easter
	name = HOLIDAY_EASTER
	holiday_mail = list(
		/obj/item/reagent_containers/food/snacks/egg/blue,
		/obj/item/reagent_containers/food/snacks/egg/green,
		/obj/item/reagent_containers/food/snacks/egg/mime,
		/obj/item/reagent_containers/food/snacks/egg/orange,
		/obj/item/reagent_containers/food/snacks/egg/purple,
		/obj/item/reagent_containers/food/snacks/egg/rainbow,
		/obj/item/reagent_containers/food/snacks/egg/red,
		/obj/item/reagent_containers/food/snacks/egg/yellow
	)
	var/const/days_early = 1
	var/const/days_extra = 1

/datum/holiday/easter/shouldCelebrate(dd, mm, yyyy, ddd)
	if(!begin_month)
		current_year = text2num(time2text(world.timeofday, "YYYY", world.timezone))
		var/list/easterResults = EasterDate(current_year+year_offset)

		begin_day = easterResults["day"]
		begin_month = easterResults["month"]

		end_day = begin_day + days_extra
		end_month = begin_month
		if(end_day >= 32 && end_month == MARCH) //begins in march, ends in april
			end_day -= 31
			end_month++
		if(end_day >= 31 && end_month == APRIL) //begins in april, ends in june
			end_day -= 30
			end_month++

		begin_day -= days_early
		if(begin_day <= 0)
			if(begin_month == APRIL)
				begin_day += 31
				begin_month-- //begins in march, ends in april

	return ..()

/datum/holiday/easter/greet()
	return "A Earth springtime festival variously celebrating rebirth and the beginning of the planting \
					season. Traditionally celebrated with the painting and exchange of eggs, sometimes made from chocolate. \
					The holiday's date was standardized in the 22nd century."

/// Takes a holiday datum, a starting month, ending month, max amount of days to test in, and min/max year as input
/// Returns a list in the form list("yyyy/m/d", ...) representing all days the holiday runs on in the tested range
/proc/poll_holiday(datum/holiday/path, min_month, max_month, min_year, max_year, max_day)
	var/list/deets = list()
	for(var/year in min_year to max_year)
		for(var/month in min_month to max_month)
			for(var/day in 1 to max_day)
				var/datum/holiday/new_day = new path()
				if(new_day.shouldCelebrate(day, month, year, iso_to_weekday(day_of_month(year, month, day))))
					deets += "[year]/[month]/[day]"
	return deets
