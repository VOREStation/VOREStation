/datum/component/haunted_item
	/// Our throwforce before being haunted
	var/pre_haunt_throwforce
	/// Optional message displayed when we're despawned / dehaunted
	var/despawn_message
	/// List of types that, if they hit our item, we will instantly stop the haunting
	var/list/types_which_dispell_us
