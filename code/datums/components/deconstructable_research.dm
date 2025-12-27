/datum/component/deconstructable_research
	///Used by R&D to determine how many points the item gives.
	var/techweb_points = 0
	///Used by R&D to determine what point type the item gives, if any
	var/techweb_point_type = TECHWEB_POINT_TYPE_GENERIC

/datum/component/deconstructable_research/Initialize(techweb_points, techweb_point_type)
	if(!isobj(parent))
		return COMPONENT_INCOMPATIBLE

	if(!isnull(techweb_points))
		src.techweb_points = techweb_points
	if(!isnull(techweb_point_type))
		src.techweb_point_type = techweb_point_type

/datum/component/deconstructable_research/RegisterWithParent()
	RegisterSignal(parent, COMSIG_TECHWEB_POINT_CHECK, PROC_REF(point_check))
	RegisterSignal(parent, COMSIG_TECHWEB_TYPE_CHECK, PROC_REF(type_check))

/datum/component/deconstructable_research/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_TECHWEB_POINT_CHECK)
	UnregisterSignal(parent, COMSIG_TECHWEB_TYPE_CHECK)

/datum/component/deconstructable_research/proc/point_check(atom/movable/source)
	return techweb_points

/datum/component/deconstructable_research/proc/type_check(atom/movable/source, list/modify_me)
	modify_me["type"] = techweb_point_type
