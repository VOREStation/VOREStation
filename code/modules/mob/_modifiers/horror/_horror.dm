// These are modifiers used for various spooky areas that are meant to be SCARY and THREATENING.
// Outside of extreme circumstances, these should not be used.
// For the primary effect, if someone is not in one of the below 'redspace_areas' Then they can not have the modifier
// applied to them. This acts as a failsafe from it from accidentally being used outside of events.
// If you DO want to use this for an event, make the event area a child of /redgate or add it to the below areas list.
// These have some extremely spooky effects and players should know about it beforehand.


// REDSPACE AREAS
// This list needs expansion...  Currently, we have very few proper redspace areas.
// Tossing /area/redgate in here as well. Entering one of these areas (unless coded to do such) doesn't apply
// the modifier, but if you're in one of these areas, you'll keep the modifier until you leave.
GLOBAL_LIST_INIT(redspace_areas, list(
	/area/redspace_abduction,
	/area/redgate,
	/area/survivalpod/redspace // Redspace shelters effectively pull a bit of redspace into realspace, so
))
