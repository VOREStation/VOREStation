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
	return b.init_order - a.init_order

// Sorts subsystems by priority
/proc/cmp_subsystem_priority(datum/controller/subsystem/a, datum/controller/subsystem/b)
	return a.priority - b.priority
