/mob/living/carbon/human/proc/consider_birthday()
	if(!bday_month || !bday_day)	//If we don't have one of these set, don't worry about it
		return
	if(!real_name == client.prefs.real_name)	//let's not celebrate the birthday of that weird mob we got dropped into
		return
	if(!(client.prefs.last_birthday_notification < world_time_year))	//you only get notified once a year
		return
	if((world_time_month == bday_month) && (world_time_day == bday_day))	//it is your birthday
		birthday(1)
	else if(world_time_month > bday_month)	//your birthday was in a previous month
		birthday()
	else if((world_time_month == bday_month) && (world_time_day > bday_day))	//your birthday was earlier this month
		birthday()

/mob/living/carbon/human/proc/birthday(var/birthday = 0)
	var/msg
	if(birthday)	//woo
		msg = "Today is your birthday! Do you want to increase your character's listed age?"
	else
		msg = "Your birthday has passed! Do you want to increase your character's listed age?"	//sad, but thus is the life of an adult
	if(tgui_alert(src, msg,"BIRTHDAY! ([bday_month]/[bday_day])",list("Level me up, baby","No way, I'mma stay young forever")) == "Level me up, baby")
		if(client.prefs.last_birthday_notification == 0)	//We've never been asked, so let's just assume you were keeping track before now and only add 1
			age += 1
		else
			var/howmuch = world_time_year - client.prefs.last_birthday_notification
			age += howmuch
		to_chat(src, "<span class = 'notice'>You are now [age]! Happy birthday!</span>")
		client.prefs.age = age	//Set the age on the character sheet

	client.prefs.last_birthday_notification = world_time_year	//We only want to ask once a year per character, this persists
	client.prefs.save_character()	//Save the info
