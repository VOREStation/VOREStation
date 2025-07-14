/**
 * returns the arguments given to a generator and manually extracts them from the internal byond object
 * returns:
 * * flat list of strings for args given to the generator.
 * * Note: this means things like "list(1,2,3)" will need to be processed
 */
/proc/return_generator_args(generator/target, has_lists = FALSE)
	var/string_repr = "[target]" //the name of the generator is the string representation of its _binobj, which also contains its args
	string_repr = copytext(string_repr, 11, length(string_repr)) // strips extraneous data
	string_repr = replacetext(string_repr, "\"", "") // removes the " around the type
	var/list/splitted = splittext(string_repr, ", ")
	if(has_lists)
		var/list/real_list = list()
		var/last_index = 0
		var/combine = FALSE
		for(var/entry in splitted)
			if(findtext(entry, "list"))
				real_list += entry
				combine = TRUE
				last_index++
				continue
			else if(findtext(entry, ")"))
				combine = FALSE
				real_list[last_index] += ", [entry]"
				continue

			if(combine)
				real_list[last_index] += ", [entry]"
				continue

			real_list += entry
			last_index++
		return real_list

	return splitted
