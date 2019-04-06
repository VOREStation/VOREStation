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
	. = sorttext(b.department, a.department)
	if (. == 0) //Same department, push up if they're a head
		. = b.head_position - a.head_position
	if (. == 0) //Already in head/nothead spot, sort by name
		. = sorttext(b.title, a.title)

// Sorts entries in a performance stats list.
/proc/cmp_generic_stat_item_time(list/A, list/B)
	. = B[STAT_ENTRY_TIME] - A[STAT_ENTRY_TIME]
	if (!.)
		. = B[STAT_ENTRY_COUNT] - A[STAT_ENTRY_COUNT]
