//checks if a file exists and contains text
//returns text as a string if these conditions are met
/proc/return_file_text(filename)
	if(fexists(filename) == 0)
		error("File not found ([filename])")
		return

	var/text = file2text(filename)
	if(!text)
		error("File empty ([filename])")
		return

	return text

//Sends resource files to client cache
/client/proc/getFiles()
	for(var/file in args)
		src << browse_rsc(file)

/client/proc/browse_files(root="data/logs/", max_iterations=10, list/valid_extensions=list(".txt",".log",".htm"))
	var/path = root

	for(var/i=0, i<max_iterations, i++)
		var/list/choices = sortList(flist(path))
		if(path != root)
			choices.Insert(1,"/")

		var/choice = tgui_input_list(src, "Choose a file to access:", "Download", choices)
		switch(choice)
			if(null)
				return
			if("/")
				path = root
				continue
		path += choice

		if(copytext(path,-1,0) != "/")		//didn't choose a directory, no need to iterate again
			break

	var/extension = copytext(path,-4,0)
	if( !fexists(path) || !(extension in valid_extensions) )
		to_chat(src, "<font color='red'>Error: browse_files(): File not found/Invalid file([path]).</font>")
		return

	return path

#define FTPDELAY 200	//200 tick delay to discourage spam
/*	This proc is a failsafe to prevent spamming of file requests.
	It is just a timer that only permits a download every [FTPDELAY] ticks.
	This can be changed by modifying FTPDELAY's value above.

	PLEASE USE RESPONSIBLY, Some log files canr each sizes of 4MB!	*/
/client/proc/file_spam_check()
	var/time_to_wait = fileaccess_timer - world.time
	if(time_to_wait > 0)
		to_chat(src, "<font color='red'>Error: file_spam_check(): Spam. Please wait [round(time_to_wait/10)] seconds.</font>")
		return 1
	fileaccess_timer = world.time + FTPDELAY
	return 0
#undef FTPDELAY

/// Reads path as a text file, splitting it on delimiter matches.
/proc/read_lines(path)
	var/static/regex/pattern = regex(@"\r?\n")
	return splittext_char(file2text(path) || "", pattern)


/// Read path as a text file to a list, stripping empty space and comments.
/proc/read_commentable(path)
	var/static/regex/pattern = regex(@"^([^#]+)")
	to_world_log("PATTERN: [pattern] [istype(pattern)]")
	var/list/result = list()
	for (var/line in read_lines(path))
		if (!pattern.Find_char(line))
			continue
		line = trim(pattern.group[1])
		if (!line)
			continue
		result += line
	return result


/// Read path as a text file to a map of key value or key list pairs.
/proc/read_config(path, lowercase_keys = TRUE)
	var/static/regex/pattern = regex(@"\s+")
	var/list/result = list()
	for (var/line in read_commentable(path))
		if (!pattern.Find_char(line))
			if (lowercase_keys)
				line = lowertext(line)
			if (!result[line])
				result[line] = TRUE
			else if (result[line] != TRUE)
				log_error({"Mixed-type key "[line]" discovered in config file "[path]"!"})
			else
				log_debug({"Duplicate key "[line]" discovered in config file "[path]"!"})
			continue
		var/key = copytext_char(line, 1, pattern.index)
		if (lowercase_keys)
			key = lowertext(key)
		var/value = copytext_char(line, pattern.index + 1)
		if (!result[key])
			result[key] = value
			continue
		if (!islist(result[key]))
			if (result[key] == TRUE)
				log_error({"Mixed-type key "[key]" discovered in config file "[path]"!"})
				continue
			result[key] = list(result[key])
		result[key] += value
	return result
