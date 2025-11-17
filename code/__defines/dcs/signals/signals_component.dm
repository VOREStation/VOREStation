// conflict checking elements
/// (id) - returns flags - Registered on something by conflict checking elements.
#define COMSIG_CONFLICT_ELEMENT_CHECK "conflict_element_check"
	/// A conflict was found
	#define ELEMENT_CONFLICT_FOUND	(1<<0)

///Misc signal for checking for godmode. Used by /datum/element/godmode
#define COMSIG_CHECK_FOR_GODMODE "check_for_godmode"
///Returned by /datum/element/godmode if the target is in godmode and whatever we're checking we want to cancel
	#define COMSIG_GODMODE_CANCEL (1<<0)
