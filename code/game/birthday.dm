/mob/living/carbon/human/proc/consider_birthday()
	var/bday_month = read_preference(/datum/preference/numeric/human/bday_month)
	var/bday_day = read_preference(/datum/preference/numeric/human/bday_day)
	if(!bday_month || !bday_day)	//If we don't have one of these set, don't worry about it
		return
	if(real_name != client.prefs.real_name)	//let's not celebrate the birthday of that weird mob we got dropped into
		return

	if(!(read_preference(/datum/preference/numeric/human/last_bday_note) < GLOB.world_time_year))	//you only get notified once a year
		return
	if((GLOB.world_time_month == bday_month) && (GLOB.world_time_day == bday_day))	//it is your birthday
		birthday(1)
	else if(GLOB.world_time_month > bday_month)	//your birthday was in a previous month
		birthday()
	else if((GLOB.world_time_month == bday_month) && (GLOB.world_time_day > bday_day))	//your birthday was earlier this month
		birthday()

/mob/living/carbon/human/proc/birthday(var/birthday = 0)
	var/msg
	var/lastyear = read_preference(/datum/preference/numeric/human/last_bday_note)
	write_preference_directly(/datum/preference/numeric/human/last_bday_note, GLOB.world_time_year)	//We only want to ask once a year per character, this persists, update early in case of shenanigans
	if(birthday)	//woo
		msg = "Today is your birthday! Do you want to increase your character's listed age?"
		if(read_preference(/datum/preference/toggle/human/bday_announce))
			var/list/sounds = list('sound/voice/BIRTH.ogg')
			var/oursound = pickweight(sounds)
			command_announcement.Announce("Confirmed presence of BIRTHDAY aboard the station! It is [src.real_name]'s birthday or similar sort of celebration, name day, hatchday, WHATEVER! We encourage you to go find [src.real_name] and show them how we celebrate around here! Have a secure day!", "BIRTHDAY!", oursound)
	else
		msg = "Your birthday has passed! Do you want to increase your character's listed age?"	//sad, but thus is the life of an adult
	if(tgui_alert(src, msg,"BIRTHDAY! ([read_preference(/datum/preference/numeric/human/bday_month)]/[read_preference(/datum/preference/numeric/human/bday_day)])",list("Level me up, baby","No way, I'mma stay young forever")) == "Level me up, baby")
		if(lastyear == 0)	//We've never been asked, so let's just assume you were keeping track before now and only add 1
			age += 1
		else
			var/howmuch = GLOB.world_time_year - lastyear
			age += howmuch
		to_chat(src, span_notice("You are now [age]! Happy birthday!"))
		write_preference_directly(/datum/preference/numeric/human/age, age)	//Set the age on the character sheet

	client.prefs.save_character()	//Save the info
