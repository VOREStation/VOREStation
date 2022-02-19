//
// Comparators for use with /datum/sortInstance (or wherever you want)
// They should return negative, zero, or positive numbers for a < b, a == b, and a > b respectively.
//

// Sorts numeric ascending
/proc/cmp_numeric_asc(a,b)
	return a - b

// Sorts subsystems alphabetically
/proc/cmp_subsystem_display(datum/controller/subsystem/a, datum/controller/subsystem/b)
	return sorttext(b.name, a.name)

// Sorts subsystems by init_order
/proc/cmp_subsystem_init(datum/controller/subsystem/a, datum/controller/subsystem/b)
	return initial(b.init_order) - initial(a.init_order)	//uses initial() so it can be used on types

// Sorts subsystems by priority
/proc/cmp_subsystem_priority(datum/controller/subsystem/a, datum/controller/subsystem/b)
	return a.priority - b.priority

/proc/cmp_timer(datum/timedevent/a, datum/timedevent/b)
	return a.timeToRun - b.timeToRun

// Sorts qdel statistics recorsd by time and count
/proc/cmp_qdel_item_time(datum/qdel_item/A, datum/qdel_item/B)
	. = B.hard_delete_time - A.hard_delete_time
	if (!.)
		. = B.destroy_time - A.destroy_time
	if (!.)
		. = B.failures - A.failures
	if (!.)
		. = B.qdels - A.qdels

// Sorts jobs by department, and then by flag within department
/proc/cmp_job_datums(var/datum/job/a, var/datum/job/b)
	. = 0
	if( LAZYLEN(a.departments) && LAZYLEN(b.departments) )
		var/list/common_departments = a.departments & b.departments // Makes a list that contains only departments that were in both.
		if(!common_departments.len)
			. = sorttext(b.departments[1], a.departments[1])

	if(. == 0) //Same department, push up if they're a head
		. = b.sorting_order - a.sorting_order

	if(. == 0) //Already in same sorting order, sort by name
		. = sorttext(b.title, a.title)

/proc/cmp_department_datums(var/datum/department/a, var/datum/department/b)
	. = b.sorting_order - a.sorting_order // First, sort by the sorting order vars.
	if(. == 0) // If they have the same var, then sort by name.
		. = sorttext(b.name, a.name)

// Sorts entries in a performance stats list.
/proc/cmp_generic_stat_item_time(list/A, list/B)
	. = B[STAT_ENTRY_TIME] - A[STAT_ENTRY_TIME]
	if (!.)
		. = B[STAT_ENTRY_COUNT] - A[STAT_ENTRY_COUNT]

/proc/cmp_typepaths_asc(A, B)
	return sorttext("[B]","[A]") 
	
/**
 * Sorts crafting recipe requirements before the crafting recipe is inserted into GLOB.crafting_recipes
 *
 * Prioritises [/datum/reagent] to ensure reagent requirements are always processed first when crafting.
 * This prevents any reagent_containers from being consumed before the reagents they contain, which can
 * lead to runtimes and item duplication when it happens.
 */
/proc/cmp_crafting_req_priority(A, B)
	var/lhs
	var/rhs

	lhs = ispath(A, /datum/reagent) ? 0 : 1
	rhs = ispath(B, /datum/reagent) ? 0 : 1

	return lhs - rhs

/proc/cmp_text_asc(a,b)
	return sorttext(b,a)

///Tracks are sorted by genre then by title inside that.
/proc/cmp_media_track_asc(datum/track/A, datum/track/B)
	var/genre_sort = sorttext(B.genre || "Uncategorized", A.genre || "Uncategorized")
	return genre_sort || sorttext(B.title, A.title)
	
///Filters have a numerical priority.
/proc/cmp_filter_data_priority(list/A, list/B)
	return A["priority"] - B["priority"]

///Traits have sort they have defined on them to categorize themselves into groups. After that, alphabetical.
/proc/cmp_trait_datums_name(datum/trait/A, datum/trait/B)
	return A.sort == B.sort ? sorttext("[B.name]","[A.name]") : A.sort - B.sort

///Species have sort_hint they self-generate to hint themselves into groups. After that, alphabetical.
/proc/cmp_species(datum/species/A, datum/species/B)
	return A.sort_hint == B.sort_hint ? sorttext("[B.name]","[A.name]") : A.sort_hint - B.sort_hint

/proc/cmp_stored_item_name(datum/stored_item/A, datum/stored_item/B)
	return sorttext(B.item_name, A.item_name)