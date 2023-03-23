/*
 * Holds procs to help with list operations
 * Contains groups:
 *			Misc
 *			Sorting
 */

// Determiner constants
#define DET_NONE		0x00
#define DET_DEFINITE	0x01 // the
#define DET_INDEFINITE	0x02 // a, an, some
#define DET_AUTO		0x04

/*
 * Misc
 */

//Returns a list in plain english as a string
/proc/english_list(var/list/input, nothing_text = "nothing", and_text = " and ", comma_text = ", ", final_comma_text = ",")
	// this proc cannot be merged with counting_english_list to maintain compatibility
	// with shoddy use of this proc for code logic and for cases that require original order
	switch(input.len)
		if(0) return nothing_text
		if(1) return "[input[1]]"
		if(2) return "[input[1]][and_text][input[2]]"
		else  return "[jointext(input, comma_text, 1, -1)][final_comma_text][and_text][input[input.len]]"

//Returns a newline-separated list that counts equal-ish items, outputting count and item names, optionally with icons and specific determiners
/proc/counting_english_list(var/list/input, output_icons = TRUE, determiners = DET_NONE, nothing_text = "nothing", line_prefix = "\t", first_item_prefix = "\n", last_item_suffix = "\n", and_text = "\n", comma_text = "\n", final_comma_text = ",")
	var/list/counts = list() // counted input items
	var/list/items = list() // actual objects for later reference (for icons and formatting)

	// count items
	for(var/item in input)
		var/name = "[item]" // index items by name; usually works fairly well for loose equality
		if(name in counts)
			counts[name]++
		else
			counts[name] = 1
			items.Add(item)

	// assemble the output list
	var/list/out = list()
	var/i = 0
	for(var/item in items)
		var/name = "[item]"
		var/count = counts[name]
		var/item_str = line_prefix
		if(count > 1)
			item_str += "[count]x&nbsp;"

		if(isatom(item))
			// atoms/items/objects can be pretty and whatnot
			var/atom/A = item
			if(output_icons && isicon(A.icon) && !ismob(A)) // mobs tend to have unusable icons
				item_str += "\icon[A][bicon(A)]&nbsp;"
			switch(determiners)
				if(DET_NONE) item_str += A.name
				if(DET_DEFINITE) item_str += "\the [A]"
				if(DET_INDEFINITE) item_str += "\a [A]"
				else item_str += name
		else
			// non-atoms use plain string conversion
			item_str += name

		if(i == 0)
			item_str = first_item_prefix + item_str
		if(i == items.len - 1)
			item_str = item_str + last_item_suffix

		out.Add(item_str)
		i++

	// finally return the list using regular english_list builder
	return english_list(out, nothing_text, and_text, comma_text, final_comma_text)

//A "preset" for counting_english_list that displays the list "inline" (comma separated)
/proc/inline_counting_english_list(var/list/input, output_icons = TRUE, determiners = DET_NONE, nothing_text = "nothing", and_text = " and ", comma_text = ", ", final_comma_text = "", line_prefix = "", first_item_prefix = "", last_item_suffix = "")
	return counting_english_list(input, output_icons, determiners, nothing_text, and_text, comma_text, final_comma_text)

//Returns list element or null. Should prevent "index out of bounds" error.
/proc/listgetindex(var/list/list,index)
	if(istype(list) && list.len)
		if(isnum(index))
			if(InRange(index,1,list.len))
				return list[index]
		else if(index in list)
			return list[index]
	return

//Return either pick(list) or null if list is not of type /list or is empty
/proc/safepick(list/list)
	if(!islist(list) || !list.len)
		return
	return pick(list)

//Checks if the list is empty
/proc/isemptylist(list/list)
	if(!list.len)
		return 1
	return 0

//Checks for specific types in a list
/proc/is_type_in_list(var/atom/A, var/list/L)
	for(var/type in L)
		if(istype(A, type))
			return 1
	return 0

//Checks for specific paths in a list
/proc/is_path_in_list(var/atom/A, var/list/L)
	for(var/path in L)
		if(ispath(A, path))
			return 1
	return 0

//////////////////////////////////////////////////////
// "typecache" utilities - Making and searching them
//////////////////////////////////////////////////////

//Checks for specific types in specifically structured (Assoc "type" = TRUE) lists ('typecaches')
/proc/is_type_in_typecache(atom/A, list/L)
	if(!LAZYLEN(L) || !A)
		return FALSE
	return L[A.type]

//returns a new list with only atoms that are in typecache L
/proc/typecache_filter_list(list/atoms, list/typecache)
	. = list()
	for(var/atom/A as anything in atoms)
		if(typecache[A.type])
			. += A

/proc/typecache_filter_list_reverse(list/atoms, list/typecache)
	. = list()
	for(var/atom/A as anything in atoms)
		if(!typecache[A.type])
			. += A

/proc/typecache_filter_multi_list_exclusion(list/atoms, list/typecache_include, list/typecache_exclude)
	. = list()
	for(var/atom/A as anything in atoms)
		if(typecache_include[A.type] && !typecache_exclude[A.type])
			. += A

//Like typesof() or subtypesof(), but returns a typecache instead of a list
/proc/typecacheof(path, ignore_root_path, only_root_path = FALSE)
	if(ispath(path))
		var/list/types = list()
		if(only_root_path)
			types = list(path)
		else
			types = ignore_root_path ? subtypesof(path) : typesof(path)
		var/list/L = list()
		for(var/T in types)
			L[T] = TRUE
		return L
	else if(islist(path))
		var/list/pathlist = path
		var/list/L = list()
		if(ignore_root_path)
			for(var/P in pathlist)
				for(var/T in subtypesof(P))
					L[T] = TRUE
		else
			for(var/P in pathlist)
				if(only_root_path)
					L[P] = TRUE
				else
					for(var/T in typesof(P))
						L[T] = TRUE
		return L

//////////////////////////////////////////////////////

//Empties the list by setting the length to 0. Hopefully the elements get garbage collected
/proc/clearlist(list/list)
	if(istype(list))
		list.len = 0
	return

//Removes any null entries from the list
/proc/listclearnulls(list/list)
	if(istype(list))
		while(null in list)
			list -= null
	return

/*
 * Returns list containing all the entries from first list that are not present in second.
 * If skiprep = 1, repeated elements are treated as one.
 * If either of arguments is not a list, returns null
 */
/proc/difflist(var/list/first, var/list/second, var/skiprep=0)
	if(!islist(first) || !islist(second))
		return
	var/list/result = new
	if(skiprep)
		for(var/e in first)
			if(!(e in result) && !(e in second))
				result += e
	else
		result = first - second
	return result

/*
Two lists may be different (A!=B) even if they have the same elements.
This actually tests if they have the same entries and values.
*/
/proc/same_entries(var/list/first, var/list/second)
	if(!islist(first) || !islist(second))
		return 0
	if(length(first) != length(second))
		return 0
	for(var/entry in first)
		if(!(entry in second) || (first[entry] != second[entry]))
			return 0
	return 1

/*
Checks if a list has the same entries and values as an element of big.
*/
/proc/in_as_list(var/list/little, var/list/big)
	if(!islist(big))
		return 0
	for(var/element in big)
		if(same_entries(little, element))
			return 1
	return 0

/*
 * Returns list containing entries that are in either list but not both.
 * If skipref = 1, repeated elements are treated as one.
 * If either of arguments is not a list, returns null
 */
/proc/uniquemergelist(var/list/first, var/list/second, var/skiprep=0)
	if(!islist(first) || !islist(second))
		return
	var/list/result = new
	if(skiprep)
		result = difflist(first, second, skiprep)+difflist(second, first, skiprep)
	else
		result = first ^ second
	return result

//Pretends to pick an element based on its weight but really just seems to pick a random element.
/proc/pickweight(list/L)
	var/total = 0
	var/item
	for (item in L)
		if (!L[item])
			L[item] = 1
		total += L[item]

	total = rand(1, total)
	for (item in L)
		total -=L [item]
		if (total <= 0)
			return item

	return null

//Pick a random element from the list and remove it from the list.
/proc/pick_n_take(list/listfrom)
	if (listfrom.len > 0)
		var/picked = pick(listfrom)
		listfrom -= picked
		return picked
	return null

//Returns the top(last) element from the list and removes it from the list (typical stack function)
/proc/pop(list/listfrom)
	if (listfrom.len > 0)
		var/picked = listfrom[listfrom.len]
		listfrom.len--
		return picked
	return null

//Returns the next element in parameter list after first appearance of parameter element. If it is the last element of the list or not present in list, returns first element.
/proc/next_in_list(element, list/L)
	for(var/i=1, i<L.len, i++)
		if(L[i] == element)
			return L[i+1]
	return L[1]

/*
 * Sorting
 */

//Reverses the order of items in the list
/proc/reverselist(list/L)
	var/list/output = list()
	if(L)
		for(var/i = L.len; i >= 1; i--)
			output += L[i]
	return output

//Randomize: Return the list in a random order
/proc/shuffle(var/list/L)
	if(!L)
		return

	L = L.Copy()

	for(var/i=1; i<L.len; i++)
		L.Swap(i, rand(i,L.len))
	return L

//same, but returns nothing and acts on list in place
/proc/shuffle_inplace(list/L)
	if(!L)
		return

	for(var/i=1, i<L.len, ++i)
		L.Swap(i,rand(i,L.len))

//same, but returns nothing and acts on list in place (also handles associated values properly)
/proc/uniqueList_inplace(list/L)
	var/temp = L.Copy()
	L.len = 0
	for(var/key in temp)
		if (isnum(key))
			L |= key
		else
			L[key] = temp[key]

// Return a list of the values in an assoc list (including null)
/proc/list_values(var/list/L)
	var/list/V  = list()
	V.len = L.len // Preallocate!
	for(var/i in 1 to L.len)
		V[i] = L[L[i]]  // We avoid += in case the value is itself a list
	return V

//Mergesort: divides up the list into halves to begin the sort
/proc/sortKey(var/list/client/L, var/order = 1)
	if(isnull(L) || L.len < 2)
		return L
	var/middle = L.len / 2 + 1
	return mergeKey(sortKey(L.Copy(0,middle)), sortKey(L.Copy(middle)), order)

//Mergsort: does the actual sorting and returns the results back to sortAtom
/proc/mergeKey(var/list/client/L, var/list/client/R, var/order = 1)
	var/Li=1
	var/Ri=1
	var/list/result = new()
	while(Li <= L.len && Ri <= R.len)
		var/client/rL = L[Li]
		var/client/rR = R[Ri]
		if(sorttext(rL.ckey, rR.ckey) == order)
			result += L[Li++]
		else
			result += R[Ri++]

	if(Li <= L.len)
		return (result + L.Copy(Li, 0))
	return (result + R.Copy(Ri, 0))

//Mergesort: divides up the list into halves to begin the sort
/proc/sortAtom(var/list/atom/L, var/order = 1)
	if(isnull(L) || L.len < 2)
		return L
	var/middle = L.len / 2 + 1
	return mergeAtoms(sortAtom(L.Copy(0,middle)), sortAtom(L.Copy(middle)), order)

//Mergsort: does the actual sorting and returns the results back to sortAtom
/proc/mergeAtoms(var/list/atom/L, var/list/atom/R, var/order = 1)
	var/Li=1
	var/Ri=1
	var/list/result = new()
	while(Li <= L.len && Ri <= R.len)
		var/atom/rL = L[Li]
		var/atom/rR = R[Ri]
		if(sorttext(rL.name, rR.name) == order)
			result += L[Li++]
		else
			result += R[Ri++]

	if(Li <= L.len)
		return (result + L.Copy(Li, 0))
	return (result + R.Copy(Ri, 0))




//Mergesort: Specifically for record datums in a list.
/proc/sortRecord(var/list/datum/data/record/L, var/field = "name", var/order = 1)
	if(isnull(L))
		return list()
	if(L.len < 2)
		return L
	var/middle = L.len / 2 + 1
	return mergeRecordLists(sortRecord(L.Copy(0, middle), field, order), sortRecord(L.Copy(middle), field, order), field, order)

//Mergsort: does the actual sorting and returns the results back to sortRecord
/proc/mergeRecordLists(var/list/datum/data/record/L, var/list/datum/data/record/R, var/field = "name", var/order = 1)
	var/Li=1
	var/Ri=1
	var/list/result = new()
	if(!isnull(L) && !isnull(R))
		while(Li <= L.len && Ri <= R.len)
			var/datum/data/record/rL = L[Li]
			if(isnull(rL))
				L -= rL
				continue
			var/datum/data/record/rR = R[Ri]
			if(isnull(rR))
				R -= rR
				continue
			if(sorttext(rL.fields[field], rR.fields[field]) == order)
				result += L[Li++]
			else
				result += R[Ri++]

		if(Li <= L.len)
			return (result + L.Copy(Li, 0))
	return (result + R.Copy(Ri, 0))



//any value in a list
/proc/sortList(list/L, cmp=/proc/cmp_text_asc)
	return sortTim(L.Copy(), cmp)

//Mergsorge: uses sortList() but uses the var's name specifically. This should probably be using mergeAtom() instead
/proc/sortNames(var/list/L)
	var/list/Q = new()
	for(var/atom/x in L)
		Q[x.name] = x
	return sortList(Q)

/proc/mergeLists(var/list/L, var/list/R)
	var/Li=1
	var/Ri=1
	var/list/result = new()
	while(Li <= L.len && Ri <= R.len)
		if(sorttext(L[Li], R[Ri]) < 1)
			result += R[Ri++]
		else
			result += L[Li++]

	if(Li <= L.len)
		return (result + L.Copy(Li, 0))
	return (result + R.Copy(Ri, 0))


// List of lists, sorts by element[key] - for things like crew monitoring computer sorting records by name.
/proc/sortByKey(var/list/L, var/key)
	if(L.len < 2)
		return L
	var/middle = L.len / 2 + 1
	return mergeKeyedLists(sortByKey(L.Copy(0, middle), key), sortByKey(L.Copy(middle), key), key)

/proc/mergeKeyedLists(var/list/L, var/list/R, var/key)
	var/Li=1
	var/Ri=1
	var/list/result = new()
	while(Li <= L.len && Ri <= R.len)
		if(sorttext(L[Li][key], R[Ri][key]) < 1)
			// Works around list += list2 merging lists; it's not pretty but it works
			result += "temp item"
			result[result.len] = R[Ri++]
		else
			result += "temp item"
			result[result.len] = L[Li++]

	if(Li <= L.len)
		return (result + L.Copy(Li, 0))
	return (result + R.Copy(Ri, 0))


//Mergesort: any value in a list, preserves key=value structure
/proc/sortAssoc(var/list/L)
	if(L.len < 2)
		return L
	var/middle = L.len / 2 + 1 // Copy is first,second-1
	return mergeAssoc(sortAssoc(L.Copy(0,middle)), sortAssoc(L.Copy(middle))) //second parameter null = to end of list

/proc/mergeAssoc(var/list/L, var/list/R)
	var/Li=1
	var/Ri=1
	var/list/result = new()
	while(Li <= L.len && Ri <= R.len)
		if(sorttext(L[Li], R[Ri]) < 1)
			result += R&R[Ri++]
		else
			result += L&L[Li++]

	if(Li <= L.len)
		return (result + L.Copy(Li, 0))
	return (result + R.Copy(Ri, 0))

// Macros to test for bits in a bitfield. Note, that this is for use with indexes, not bit-masks!
#define BITTEST(bitfield,index)  ((bitfield)  &   (1 << (index)))
#define BITSET(bitfield,index)   (bitfield)  |=  (1 << (index))
#define BITRESET(bitfield,index) (bitfield)  &= ~(1 << (index))
#define BITFLIP(bitfield,index)  (bitfield)  ^=  (1 << (index))

//Converts a bitfield to a list of numbers (or words if a wordlist is provided)
/proc/bitfield2list(bitfield = 0, list/wordlist)
	var/list/r = list()
	if(istype(wordlist,/list))
		var/max = min(wordlist.len,16)
		var/bit = 1
		for(var/i=1, i<=max, i++)
			if(bitfield & bit)
				r += wordlist[i]
			bit = bit << 1
	else
		for(var/bit=1, bit<=65535, bit = bit << 1)
			if(bitfield & bit)
				r += bit

	return r

// Returns the key based on the index
/proc/get_key_by_index(var/list/L, var/index)
	var/i = 1
	for(var/key in L)
		if(index == i)
			return key
		i++
	return null

// Returns the key based on the index
/proc/get_key_by_value(var/list/L, var/value)
	for(var/key in L)
		if(L[key] == value)
			return key

/proc/count_by_type(var/list/L, type)
	var/i = 0
	for(var/T in L)
		if(istype(T, type))
			i++
	return i

//Don't use this on lists larger than half a dozen or so
/proc/insertion_sort_numeric_list_ascending(var/list/L)
	//to_world_log("ascending len input: [L.len]")
	var/list/out = list(pop(L))
	for(var/entry in L)
		if(isnum(entry))
			var/success = 0
			for(var/i=1, i<=out.len, i++)
				if(entry <= out[i])
					success = 1
					out.Insert(i, entry)
					break
			if(!success)
				out.Add(entry)

	//to_world_log("	output: [out.len]")
	return out

/proc/insertion_sort_numeric_list_descending(var/list/L)
	//to_world_log("descending len input: [L.len]")
	var/list/out = insertion_sort_numeric_list_ascending(L)
	//to_world_log("	output: [out.len]")
	return reverselist(out)

/proc/dd_sortedObjectList(var/list/L, var/cache=list())
	if(L.len < 2)
		return L
	var/middle = L.len / 2 + 1 // Copy is first,second-1
	return dd_mergeObjectList(dd_sortedObjectList(L.Copy(0,middle), cache), dd_sortedObjectList(L.Copy(middle), cache), cache) //second parameter null = to end of list

/proc/dd_mergeObjectList(var/list/L, var/list/R, var/list/cache)
	var/Li=1
	var/Ri=1
	var/list/result = new()
	while(Li <= L.len && Ri <= R.len)
		var/LLi = L[Li]
		var/RRi = R[Ri]
		var/LLiV = cache[LLi]
		var/RRiV = cache[RRi]
		if(!LLiV)
			LLiV = LLi:dd_SortValue()
			cache[LLi] = LLiV
		if(!RRiV)
			RRiV = RRi:dd_SortValue()
			cache[RRi] = RRiV
		if(LLiV < RRiV)
			result += L[Li++]
		else
			result += R[Ri++]

	if(Li <= L.len)
		return (result + L.Copy(Li, 0))
	return (result + R.Copy(Ri, 0))

// Insert an object into a sorted list, preserving sortedness
/proc/dd_insertObjectList(var/list/L, var/O)
	var/min = 1
	var/max = L.len
	var/Oval = O:dd_SortValue()

	while(1)
		var/mid = min+round((max-min)/2)

		if(mid == max)
			L.Insert(mid, O)
			return

		var/Lmid = L[mid]
		var/midval = Lmid:dd_SortValue()
		if(Oval == midval)
			L.Insert(mid, O)
			return
		else if(Oval < midval)
			max = mid
		else
			min = mid+1

/*
/proc/dd_sortedObjectList(list/incoming)
	/*
	   Use binary search to order by dd_SortValue().
	   This works by going to the half-point of the list, seeing if the node in
	   question is higher or lower cost, then going halfway up or down the list
	   and checking again. This is a very fast way to sort an item into a list.
	*/
	var/list/sorted_list = new()
	var/low_index
	var/high_index
	var/insert_index
	var/midway_calc
	var/current_index
	var/current_item
	var/current_item_value
	var/current_sort_object_value
	var/list/list_bottom

	var/current_sort_object
	for (current_sort_object in incoming)
		low_index = 1
		high_index = sorted_list.len
		while (low_index <= high_index)
			// Figure out the midpoint, rounding up for fractions.  (BYOND rounds down, so add 1 if necessary.)
			midway_calc = (low_index + high_index) / 2
			current_index = round(midway_calc)
			if (midway_calc > current_index)
				current_index++
			current_item = sorted_list[current_index]

			current_item_value = current_item:dd_SortValue()
			current_sort_object_value = current_sort_object:dd_SortValue()
			if (current_sort_object_value < current_item_value)
				high_index = current_index - 1
			else if (current_sort_object_value > current_item_value)
				low_index = current_index + 1
			else
				// current_sort_object == current_item
				low_index = current_index
				break

		// Insert before low_index.
		insert_index = low_index

		// Special case adding to end of list.
		if (insert_index > sorted_list.len)
			sorted_list += current_sort_object
			continue

		// Because BYOND lists don't support insert, have to do it by:
		// 1) taking out bottom of list, 2) adding item, 3) putting back bottom of list.
		list_bottom = sorted_list.Copy(insert_index)
		sorted_list.Cut(insert_index)
		sorted_list += current_sort_object
		sorted_list += list_bottom
	return sorted_list
*/

/proc/dd_sortedtextlist(list/incoming, case_sensitive = 0)
	// Returns a new list with the text values sorted.
	// Use binary search to order by sortValue.
	// This works by going to the half-point of the list, seeing if the node in question is higher or lower cost,
	// then going halfway up or down the list and checking again.
	// This is a very fast way to sort an item into a list.
	var/list/sorted_text = new()
	var/low_index
	var/high_index
	var/insert_index
	var/midway_calc
	var/current_index
	var/current_item
	var/list/list_bottom
	var/sort_result

	var/current_sort_text
	for (current_sort_text in incoming)
		low_index = 1
		high_index = sorted_text.len
		while (low_index <= high_index)
			// Figure out the midpoint, rounding up for fractions.  (BYOND rounds down, so add 1 if necessary.)
			midway_calc = (low_index + high_index) / 2
			current_index = round(midway_calc)
			if (midway_calc > current_index)
				current_index++
			current_item = sorted_text[current_index]

			if (case_sensitive)
				sort_result = sorttextEx(current_sort_text, current_item)
			else
				sort_result = sorttext(current_sort_text, current_item)

			switch(sort_result)
				if (1)
					high_index = current_index - 1	// current_sort_text < current_item
				if (-1)
					low_index = current_index + 1	// current_sort_text > current_item
				if (0)
					low_index = current_index		// current_sort_text == current_item
					break

		// Insert before low_index.
		insert_index = low_index

		// Special case adding to end of list.
		if (insert_index > sorted_text.len)
			sorted_text += current_sort_text
			continue

		// Because BYOND lists don't support insert, have to do it by:
		// 1) taking out bottom of list, 2) adding item, 3) putting back bottom of list.
		list_bottom = sorted_text.Copy(insert_index)
		sorted_text.Cut(insert_index)
		sorted_text += current_sort_text
		sorted_text += list_bottom
	return sorted_text


/proc/dd_sortedTextList(list/incoming)
	var/case_sensitive = 1
	return dd_sortedtextlist(incoming, case_sensitive)


/datum/proc/dd_SortValue()
	return "[src]"

/obj/machinery/dd_SortValue()
	return "[sanitize_old(name)]"

/obj/machinery/camera/dd_SortValue()
	return "[c_tag]"

/datum/alarm/dd_SortValue()
	return "[sanitize_old(last_name)]"

/proc/subtypesof(prototype)
	return (typesof(prototype) - prototype)

//creates every subtype of prototype (excluding prototype) and adds it to list L.
//if no list/L is provided, one is created.
/proc/init_subtypes(prototype, list/L)
	if(!istype(L))	L = list()
	for(var/path in subtypesof(prototype))
		L += new path()
	return L

//creates every subtype of prototype (excluding prototype) and adds it to list L as a type/instance pair.
//if no list/L is provided, one is created.
/proc/init_subtypes_assoc(prototype, list/L)
	if(!istype(L))	L = list()
	for(var/path in subtypesof(prototype))
		L[path] = new path()
	return L

//Move a single element from position fromIndex within a list, to position toIndex
//All elements in the range [1,toIndex) before the move will be before the pivot afterwards
//All elements in the range [toIndex, L.len+1) before the move will be after the pivot afterwards
//In other words, it's as if the range [fromIndex,toIndex) have been rotated using a <<< operation common to other languages.
//fromIndex and toIndex must be in the range [1,L.len+1]
//This will preserve associations ~Carnie
/proc/moveElement(list/L, fromIndex, toIndex)
	if(fromIndex == toIndex || fromIndex+1 == toIndex)	//no need to move
		return
	if(fromIndex > toIndex)
		++fromIndex	//since a null will be inserted before fromIndex, the index needs to be nudged right by one

	L.Insert(toIndex, null)
	L.Swap(fromIndex, toIndex)
	L.Cut(fromIndex, fromIndex+1)

//Move elements [fromIndex,fromIndex+len) to [toIndex-len, toIndex)
//Same as moveElement but for ranges of elements
//This will preserve associations ~Carnie
/proc/moveRange(list/L, fromIndex, toIndex, len=1)
	var/distance = abs(toIndex - fromIndex)
	if(len >= distance)	//there are more elements to be moved than the distance to be moved. Therefore the same result can be achieved (with fewer operations) by moving elements between where we are and where we are going. The result being, our range we are moving is shifted left or right by dist elements
		if(fromIndex <= toIndex)
			return	//no need to move
		fromIndex += len	//we want to shift left instead of right

		for(var/i=0, i<distance, ++i)
			L.Insert(fromIndex, null)
			L.Swap(fromIndex, toIndex)
			L.Cut(toIndex, toIndex+1)
	else
		if(fromIndex > toIndex)
			fromIndex += len

		for(var/i=0, i<len, ++i)
			L.Insert(toIndex, null)
			L.Swap(fromIndex, toIndex)
			L.Cut(fromIndex, fromIndex+1)

//replaces reverseList ~Carnie
/proc/reverseRange(list/L, start=1, end=0)
	if(L.len)
		start = start % L.len
		end = end % (L.len+1)
		if(start <= 0)
			start += L.len
		if(end <= 0)
			end += L.len + 1

		--end
		while(start < end)
			L.Swap(start++,end--)

	return L

//Copies a list, and all lists inside it recusively
//Does not copy any other reference type
/proc/deepCopyList(list/l)
	if(!islist(l))
		return l
	. = l.Copy()
	for(var/i = 1 to l.len)
		if(islist(.[i]))
			.[i] = .(.[i])

//Return a list with no duplicate entries
/proc/uniqueList(list/L)
	. = list()
	for(var/i in L)
		. |= i

#define listequal(A, B) (A.len == B.len && !length(A^B))

/proc/popleft(list/L)
	if(L.len)
		. = L[1]
		L.Cut(1,2)

//generates a list used to randomize transit animations so they aren't in lockstep
/proc/get_cross_shift_list(var/size)
	var/list/result = list()

	result += rand(0, 14)
	for(var/i in 2 to size)
		var/shifts = list(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14)
		shifts -= result[i - 1] //consecutive shifts should not be equal
		if(i == size)
			shifts -= result[1] //because shift list is a ring buffer
		result += pick(shifts)

	return result

var/global/list/json_cache = list()
/proc/cached_json_decode(var/json_to_decode)
	if(!json_to_decode || !length(json_to_decode))
		return list()
	try
		if(isnull(global.json_cache[json_to_decode]))
			global.json_cache[json_to_decode] = json_decode(json_to_decode)
		. = global.json_cache[json_to_decode]
	catch(var/exception/e)
		log_error("Exception during JSON decoding ([json_to_decode]): [e]")
		return list()

//takes an input_key, as text, and the list of keys already used, outputting a replacement key in the format of "[input_key] ([number_of_duplicates])" if it finds a duplicate
//use this for lists of things that might have the same name, like mobs or objects, that you plan on giving to a player as input
/proc/avoid_assoc_duplicate_keys(input_key, list/used_key_list)
	if(!input_key || !istype(used_key_list))
		return
	if(used_key_list[input_key])
		used_key_list[input_key]++
		input_key = "[input_key] ([used_key_list[input_key]])"
	else
		used_key_list[input_key] = 1
	return input_key
