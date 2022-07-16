// Body weight limits on a character.
#define WEIGHT_MIN 70
#define WEIGHT_MAX 500
#define WEIGHT_CHANGE_MIN 0
#define WEIGHT_CHANGE_MAX 100
#define MAX_VOICE_FREQ 70000
#define MIN_VOICE_FREQ 15000

// Define a place to save in character setup
/datum/preferences
	var/size_multiplier = RESIZE_NORMAL
	// Body weight stuff.
	var/weight_vr = 137		// bodyweight of character (pounds, because I'm not doing the math again -Spades)
	var/weight_gain = 100	// Weight gain rate.
	var/weight_loss = 50	// Weight loss rate.
	var/fuzzy = 0			// Preference toggle for sharp/fuzzy icon. Default sharp.
	var/voice_freq = 0
	var/voice_sounds_list

// Definition of the stuff for Sizing
/datum/category_item/player_setup_item/vore/size
	name = "Size"
	sort_order = 2

/datum/category_item/player_setup_item/vore/size/load_character(var/savefile/S)
	S["size_multiplier"]	>> pref.size_multiplier
	S["weight_vr"]			>> pref.weight_vr
	S["weight_gain"]		>> pref.weight_gain
	S["weight_loss"]		>> pref.weight_loss
	S["fuzzy"]				>> pref.fuzzy
	S["voice_freq"]			>> pref.voice_freq
	S["voice_sounds_list"]	>> pref.voice_sounds_list

/datum/category_item/player_setup_item/vore/size/save_character(var/savefile/S)
	S["size_multiplier"]	<< pref.size_multiplier
	S["weight_vr"]			<< pref.weight_vr
	S["weight_gain"]		<< pref.weight_gain
	S["weight_loss"]		<< pref.weight_loss
	S["fuzzy"]				<< pref.fuzzy
	S["voice_freq"]			<< pref.voice_freq
	S["voice_sounds_list"]	<< pref.voice_sounds_list

/datum/category_item/player_setup_item/vore/size/sanitize_character()
	pref.weight_vr			= sanitize_integer(pref.weight_vr, WEIGHT_MIN, WEIGHT_MAX, initial(pref.weight_vr))
	pref.weight_gain		= sanitize_integer(pref.weight_gain, WEIGHT_CHANGE_MIN, WEIGHT_CHANGE_MAX, initial(pref.weight_gain))
	pref.weight_loss		= sanitize_integer(pref.weight_loss, WEIGHT_CHANGE_MIN, WEIGHT_CHANGE_MAX, initial(pref.weight_loss))
	pref.fuzzy				= sanitize_integer(pref.fuzzy, 0, 1, initial(pref.fuzzy))
	if(pref.voice_freq != 0)
		pref.voice_freq			= sanitize_integer(pref.voice_freq, MIN_VOICE_FREQ, MAX_VOICE_FREQ, initial(pref.fuzzy))
	if(pref.size_multiplier == null || pref.size_multiplier < RESIZE_TINY || pref.size_multiplier > RESIZE_HUGE)
		pref.size_multiplier = initial(pref.size_multiplier)

/datum/category_item/player_setup_item/vore/size/copy_to_mob(var/mob/living/carbon/human/character)
	character.weight			= pref.weight_vr
	character.weight_gain		= pref.weight_gain
	character.weight_loss		= pref.weight_loss
	character.fuzzy				= pref.fuzzy
	character.voice_freq		= pref.voice_freq
	character.resize(pref.size_multiplier, animate = FALSE, ignore_prefs = TRUE)
	switch(pref.voice_sounds_list)
		if("beep-boop")
			character.voice_sounds_list	= pref.voice_sounds_list
		else
			character.voice_sounds_list = talk_sound


/datum/category_item/player_setup_item/vore/size/content(var/mob/user)
	. += "<br>"
	. += "<b>Scale:</b> <a href='?src=\ref[src];size_multiplier=1'>[round(pref.size_multiplier*100)]%</a><br>"
	. += "<b>Scaled Appearance:</b> <a [pref.fuzzy ? "" : ""] href='?src=\ref[src];toggle_fuzzy=1'><b>[pref.fuzzy ? "Fuzzy" : "Sharp"]</b></a><br>"
	. += "<b>Voice Frequency:</b> <a href='?src=\ref[src];voice_freq=1'>[pref.voice_freq]</a><br>"
//	. += "<b>Voice Sounds:</b> <a href='?src=\ref[src];voice_sounds_list=1'>[pref.voice_sounds_list]</a><br>"	//Maybe later when there's more options
	. += "<br>"
	. += "<b>Relative Weight:</b>  <a href='?src=\ref[src];weight=1'>[pref.weight_vr]</a><br>"
	. += "<b>Weight Gain Rate:</b> <a href='?src=\ref[src];weight_gain=1'>[pref.weight_gain]</a><br>"
	. += "<b>Weight Loss Rate:</b> <a href='?src=\ref[src];weight_loss=1'>[pref.weight_loss]</a><br>"

/datum/category_item/player_setup_item/vore/size/OnTopic(var/href, var/list/href_list, var/mob/user)
	if(href_list["size_multiplier"])
		var/new_size = tgui_input_number(user, "Choose your character's size, ranging from 25% to 200%", "Set Size", null, 200, 25)
		if (!ISINRANGE(new_size,25,200))
			pref.size_multiplier = 1
			to_chat(user, "<span class='notice'>Invalid size.</span>")
			return TOPIC_REFRESH_UPDATE_PREVIEW
		else if(new_size)
			pref.size_multiplier = (new_size/100)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["toggle_fuzzy"])
		pref.fuzzy = pref.fuzzy ? 0 : 1;
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["weight"])
		var/new_weight = tgui_input_number(user, "Choose your character's relative body weight.\n\
			This measurement should be set relative to a normal 5'10'' person's body and not the actual size of your character.\n\
			If you set your weight to 500 because you're a naga or have metal implants then complain that you're a blob I\n\
			swear to god I will find you and I will punch you for not reading these directions!\n\
			([WEIGHT_MIN]-[WEIGHT_MAX])", "Character Preference", null, WEIGHT_MAX, WEIGHT_MIN)
		if(new_weight)
			var/unit_of_measurement = tgui_alert(user, "Is that number in pounds (lb) or kilograms (kg)?", "Confirmation", list("Pounds", "Kilograms"))
			if(unit_of_measurement == "Pounds")
				new_weight = round(text2num(new_weight),4)
			if(unit_of_measurement == "Kilograms")
				new_weight = round(2.20462*text2num(new_weight),4)
			pref.weight_vr = sanitize_integer(new_weight, WEIGHT_MIN, WEIGHT_MAX, pref.weight_vr)
			return TOPIC_REFRESH

	else if(href_list["weight_gain"])
		var/weight_gain_rate = tgui_input_number(user, "Choose your character's rate of weight gain between 100% \
			(full realism body fat gain) and 0% (no body fat gain).\n\
			(If you want to disable weight gain, set this to 0.01 to round it to 0%.)\
			([WEIGHT_CHANGE_MIN]-[WEIGHT_CHANGE_MAX])", "Character Preference", pref.weight_gain)
		if(weight_gain_rate)
			pref.weight_gain = round(text2num(weight_gain_rate),1)
			return TOPIC_REFRESH

	else if(href_list["weight_loss"])
		var/weight_loss_rate = tgui_input_number(user, "Choose your character's rate of weight loss between 100% \
			(full realism body fat loss) and 0% (no body fat loss).\n\
			(If you want to disable weight loss, set this to 0.01 round it to 0%.)\
			([WEIGHT_CHANGE_MIN]-[WEIGHT_CHANGE_MAX])", "Character Preference", pref.weight_loss)
		if(weight_loss_rate)
			pref.weight_loss = round(text2num(weight_loss_rate),1)
			return TOPIC_REFRESH

	else if(href_list["voice_freq"])
		var/list/preset_voice_freqs = list("high" = MAX_VOICE_FREQ, "middle-high" = 56250, "middle" = 425000, "middle-low"= 28750, "low" = MIN_VOICE_FREQ, "custom" = 1, "random" = 0)
		var/choice = tgui_input_list(usr, "What would you like to set your voice frequency to? ([MIN_VOICE_FREQ] - [MAX_VOICE_FREQ])", "Voice Frequency", preset_voice_freqs)
		if(!choice)
			return
		choice = preset_voice_freqs[choice]
		if(choice == 0)
			pref.voice_freq = choice
			return TOPIC_REFRESH
		else if(choice == 1)
			choice = tgui_input_number(user, "Choose your character's voice frequency, ranging from [MIN_VOICE_FREQ] to [MAX_VOICE_FREQ]", "Custom Voice Frequency", null, MAX_VOICE_FREQ, MIN_VOICE_FREQ, round_value = TRUE)
		if(choice > MAX_VOICE_FREQ)
			choice = MAX_VOICE_FREQ
		else if(choice < MIN_VOICE_FREQ)
			choice = MIN_VOICE_FREQ

		pref.voice_freq = choice
		return TOPIC_REFRESH
	else if(href_list["voice_sounds_list"])
		var/choice = tgui_alert(usr, "Which set of sounds would you like to use for your character's speech sounds?", "Voice Sounds", list("beep-boop"))
		if(choice)
			pref.voice_sounds_list = choice
	return ..();
