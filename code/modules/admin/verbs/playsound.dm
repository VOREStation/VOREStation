//world/proc/shelleo
#define SHELLEO_ERRORLEVEL 1
#define SHELLEO_STDOUT 2
#define SHELLEO_STDERR 3

var/list/sounds_cache = list()

/client/proc/play_sound(S as sound)
	set category = "Fun"
	set name = "Play Global Sound"
	if(!check_rights(R_SOUNDS))
		return

	var/freq = 1
	var/vol = tgui_input_number(usr, "What volume would you like the sound to play at?",, 100, 100, 1)
	if(!vol)
		return
	vol = clamp(vol, 1, 100)

	var/sound/admin_sound = new()
	admin_sound.file = S
	admin_sound.priority = 250
	admin_sound.channel = 777
	admin_sound.frequency = freq
	admin_sound.wait = 1
	admin_sound.repeat = FALSE
	admin_sound.status = SOUND_STREAM
	admin_sound.volume = vol

	sounds_cache += S

	var/res = tgui_alert(usr, "Show the title of this song ([S]) to the players?\nOptions 'Yes' and 'No' will play the sound.",, list("Yes", "No", "Cancel"))
	switch(res)
		if("Yes")
			to_chat(world, "<span class='boldannounce'>An admin played: [S]</span>", confidential = TRUE)
		if("Cancel")
			return

	log_admin("[key_name(src)] played sound [S]")
	message_admins("[key_name_admin(src)] played sound [S]", 1)

	for(var/mob/M in player_list)
		if(M.is_preference_enabled(/datum/client_preference/play_admin_midis))
			admin_sound.volume = vol * M.client.admin_music_volume
			SEND_SOUND(M, admin_sound)
			admin_sound.volume = vol

	feedback_add_details("admin_verb", "Play Global Sound")

/client/proc/play_local_sound(S as sound)
	set category = "Fun"
	set name = "Play Local Sound"
	if(!check_rights(R_SOUNDS))
		return

	log_admin("[key_name(src)] played a local sound [S]")
	message_admins("[key_name_admin(src)] played a local sound [S]", 1)
	playsound(src.mob, S, 50, 0, 0)
	feedback_add_details("admin_verb", "Play Local Sound")

/client/proc/play_direct_mob_sound(S as sound, mob/M)
	set category = "Fun"
	set name = "Play Direct Mob Sound"
	if(!check_rights(R_SOUNDS))
		return

	if(!M)
		M = tgui_input_list(usr, "Choose a mob to play the sound to. Only they will hear it.", "Play Mob Sound", sortNames(player_list))
	if(!M || QDELETED(M))
		return
	log_admin("[key_name(src)] played a direct mob sound [S] to [M].")
	message_admins("[key_name_admin(src)] played a direct mob sound [S] to [ADMIN_LOOKUPFLW(M)].")
	SEND_SOUND(M, S)
	feedback_add_details("admin_verb", "Play Direct Mob Sound")

/client/proc/play_z_sound(S as sound)
	set category = "Fun"
	set name = "Play Z Sound"
	if(!check_rights(R_SOUNDS))	return
	var/target_z = mob.z
	var/sound/uploaded_sound = sound(S, repeat = 0, wait = 1, channel = 777)
	uploaded_sound.priority = 250

	sounds_cache += S

	if(tgui_alert(usr, "Do you ready?\nSong: [S]\nNow you can also play this sound using \"Play Server Sound\".", "Confirmation request", list("Play","Cancel")) == "Cancel")
		return

	log_admin("[key_name(src)] played sound [S] on Z[target_z]")
	message_admins("[key_name_admin(src)] played sound [S] on Z[target_z]", 1)
	for(var/mob/M in player_list)
		if(M.is_preference_enabled(/datum/client_preference/play_admin_midis) && M.z == target_z)
			M << uploaded_sound

	feedback_add_details("admin_verb", "Play Z Sound") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/proc/play_server_sound()
	set category = "Fun"
	set name = "Play Server Sound"
	if(!check_rights(R_SOUNDS))
		return

	var/list/sounds = file2list("sound/serversound_list.txt");
	sounds += "--CANCEL--"
	sounds += sounds_cache

	var/melody = tgui_input_list(usr, "Select a sound from the server to play", "Server sound list", sounds, "--CANCEL--")

	if(melody == "--CANCEL--")
		return

	play_sound(melody)
	feedback_add_details("admin_verb", "Play Server Sound") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

///Takes an input from either proc/play_web_sound or the request manager and runs it through youtube-dl and prompts the user before playing it to the server.
/proc/web_sound(mob/user, input, credit)
	if(!check_rights(R_SOUNDS))
		return
	var/ytdl = config.invoke_youtubedl
	if(!ytdl)
		to_chat(user, "<span class='boldwarning'>Youtube-dl was not configured, action unavailable</span>", confidential = TRUE) //Check config.txt for the INVOKE_YOUTUBEDL value
		return
	var/web_sound_url = ""
	var/stop_web_sounds = FALSE
	var/list/music_extra_data = list()
	var/duration = 0
	if(istext(input))
		var/shell_scrubbed_input = shell_url_scrub(input)
		var/list/output = world.shelleo("[ytdl] --geo-bypass --format \"bestaudio\[ext=mp3]/best\[ext=mp4]\[height <= 360]/bestaudio\[ext=m4a]/bestaudio\[ext=aac]\" --dump-single-json --no-playlist -- \"[shell_scrubbed_input]\"")
		var/errorlevel = output[SHELLEO_ERRORLEVEL]
		var/stdout = output[SHELLEO_STDOUT]
		var/stderr = output[SHELLEO_STDERR]
		if(errorlevel)
			to_chat(user, "<span class='boldwarning'>Youtube-dl URL retrieval FAILED:</span>", confidential = TRUE)
			to_chat(user, "<span class='warning'>[stderr]</span>", confidential = TRUE)
			return
		var/list/data
		try
			data = json_decode(stdout)
		catch(var/exception/e)
			to_chat(user, "<span class='boldwarning'>Youtube-dl JSON parsing FAILED:</span>", confidential = TRUE)
			to_chat(user, "<span class='warning'>[e]: [stdout]</span>", confidential = TRUE)
			return
		if (data["url"])
			web_sound_url = data["url"]
		var/title = "[data["title"]]"
		var/webpage_url = title
		if (data["webpage_url"])
			webpage_url = "<a href=\"[data["webpage_url"]]\">[title]</a>"
		music_extra_data["duration"] = DisplayTimeText(data["duration"] * 1 SECONDS)
		music_extra_data["link"] = data["webpage_url"]
		music_extra_data["artist"] = data["artist"]
		music_extra_data["upload_date"] = data["upload_date"]
		music_extra_data["album"] = data["album"]
		duration = data["duration"] * 1 SECONDS
		if (duration > 10 MINUTES)
			if((tgui_alert(user, "This song is over 10 minutes long. Are you sure you want to play it?", "Length Warning!", list("No", "Yes", "Cancel")) != "Yes"))
				return
		var/res = tgui_alert(user, "Show the title of and link to this song to the players?\n[title]", "Show Info?", list("Yes", "No", "Cancel"))
		switch(res)
			if("Yes")
				music_extra_data["title"] = data["title"]
			if("No")
				music_extra_data["link"] = "Song Link Hidden"
				music_extra_data["title"] = "Song Title Hidden"
				music_extra_data["artist"] = "Song Artist Hidden"
				music_extra_data["upload_date"] = "Song Upload Date Hidden"
				music_extra_data["album"] = "Song Album Hidden"
			if("Cancel", null)
				return
		var/anon = tgui_alert(user, "Display who played the song?", "Credit Yourself?", list("Yes", "No", "Cancel"))
		switch(anon)
			if("Yes")
				if(res == "Yes")
					to_chat(world, "<span class='boldannounce'>[user.key] played: [webpage_url]</span>", confidential = TRUE)
				else
					to_chat(world, "<span class='boldannounce'>[user.key] played a sound</span>", confidential = TRUE)
			if("No")
				if(res == "Yes")
					to_chat(world, "<span class='boldannounce'>An admin played: [webpage_url]</span>", confidential = TRUE)
			if("Cancel", null)
				return
		if(credit)
			to_chat(world, "<span class='boldannounce'>[credit]</span>", confidential = TRUE)
		//SSblackbox.record_feedback("nested tally", "played_url", 1, list("[user.ckey]", "[input]"))
		log_admin("[key_name(user)] played web sound: [input]")
		message_admins("[key_name(user)] played web sound: [input]")
	else
		//pressed ok with blank
		log_admin("[key_name(user)] stopped web sounds.")

		message_admins("[key_name(user)] stopped web sounds.")
		web_sound_url = null
		stop_web_sounds = TRUE
	if(web_sound_url && !findtext(web_sound_url, GLOB.is_http_protocol))
		tgui_alert(user, "The media provider returned a content URL that isn't using the HTTP or HTTPS protocol. This is a security risk and the sound will not be played.", "Security Risk", list("OK"))
		to_chat(user, "<span class='boldwarning'>BLOCKED: Content URL not using HTTP(S) Protocol!</span>", confidential = TRUE)

		return
	if(web_sound_url || stop_web_sounds)
		for(var/m in player_list)
			var/mob/M = m
			var/client/C = M.client
			if(C.is_preference_enabled(/datum/client_preference/play_admin_midis))
				if(!stop_web_sounds)
					C.tgui_panel?.play_music(web_sound_url, music_extra_data)
				else
					C.tgui_panel?.stop_music()

	S_TIMER_COOLDOWN_START(SStimer, COOLDOWN_INTERNET_SOUND, duration)

	feedback_add_details("admin_verb", "Play Internet Sound")

/client/proc/play_web_sound()
	set category = "Fun"
	set name = "Play Internet Sound"
	if(!check_rights(R_SOUNDS))
		return

	var/ytdl = config.invoke_youtubedl
	if(!ytdl)
		to_chat(src, "<span class='boldwarning'>Youtube-dl was not configured, action unavailable</span>", confidential = TRUE) //Check config.txt for the INVOKE_YOUTUBEDL value
		return

	if(S_TIMER_COOLDOWN_TIMELEFT(SStimer, COOLDOWN_INTERNET_SOUND))
		if(tgui_alert(usr, "Someone else is already playing an Internet sound! It has [DisplayTimeText(S_TIMER_COOLDOWN_TIMELEFT(SStimer, COOLDOWN_INTERNET_SOUND), 1)] remaining. \
		Would you like to override?", "Musicalis Interruptus", list("No","Yes")) != "Yes")
			return

	var/web_sound_input = tgui_input_text(usr, "Enter content URL (supported sites only, leave blank to stop playing)", "Play Internet Sound", null)

	if(length(web_sound_input))
		web_sound_input = trim(web_sound_input)
		if(findtext(web_sound_input, ":") && !findtext(web_sound_input, GLOB.is_http_protocol))
			to_chat(src, "<span class='boldwarning'>Non-http(s) URIs are not allowed.</span>", confidential = TRUE)
			to_chat(src, "<span class='warning'>For youtube-dl shortcuts like ytsearch: please use the appropriate full URL from the website.</span>", confidential = TRUE)
			return
		web_sound(usr, web_sound_input)
	else
		web_sound(usr, null)

/client/proc/stop_sounds()
	set category = "Debug"
	set name = "Stop All Playing Sounds"
	if(!src.holder)
		return

	log_admin("[key_name(src)] stopped all currently playing sounds.")
	message_admins("[key_name_admin(src)] stopped all currently playing sounds.")
	for(var/mob/M in player_list)
		SEND_SOUND(M, sound(null))
		var/client/C = M.client
		C?.tgui_panel?.stop_music()

	S_TIMER_COOLDOWN_RESET(SStimer, COOLDOWN_INTERNET_SOUND)
	feedback_add_details("admin_verb", "Stop All Playing Sounds")

//world/proc/shelleo
#undef SHELLEO_ERRORLEVEL
#undef SHELLEO_STDOUT
#undef SHELLEO_STDERR

/*
/client/proc/cuban_pete()
	set category = "Fun"
	set name = "Cuban Pete Time"

	message_admins("[key_name_admin(usr)] has declared Cuban Pete Time!", 1)
	for(var/mob/M in player_list)
		if(M.client)
			if(M.client.midis)
				M << 'cubanpetetime.ogg'

	for(var/mob/living/carbon/human/CP in human_mob_list)
		if(CP.real_name=="Cuban Pete" && CP.key!="Rosham")
			to_chat(CP, "Your body can't contain the rhumba beat")
			CP.gib()


/client/proc/bananaphone()
	set category = "Fun"
	set name = "Banana Phone"

	message_admins("[key_name_admin(usr)] has activated Banana Phone!", 1)
	for(var/mob/M in player_list)
		if(M.client)
			if(M.client.midis)
				M << 'bananaphone.ogg'


/client/proc/space_asshole()
	set category = "Fun"
	set name = "Space Asshole"

	message_admins("[key_name_admin(usr)] has played the Space Asshole Hymn.", 1)
	for(var/mob/M in player_list)
		if(M.client)
			if(M.client.midis)
				M << 'sound/music/space_asshole.ogg'


/client/proc/honk_theme()
	set category = "Fun"
	set name = "Honk"

	message_admins("[key_name_admin(usr)] has creeped everyone out with Blackest Honks.", 1)
	for(var/mob/M in player_list)
		if(M.client)
			if(M.client.midis)
				M << 'honk_theme.ogg'*/
