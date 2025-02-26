#define MAINTVENDOR_GENERIC "Unsorted Listings"
#define MAINTVENDOR_SCENETOOLS "Funky Town Odds & Ends"
#define MAINTVENDOR_CONSTRUCTION "DIY Construction Supplies"
#define MAINTVENDOR_SWAG ""

#define MAINTVENDOR_ACCESS_CHECK_OR = TRUE
#define MAINTVENDOR_ACCESS_CHECK_AND = FALSE


/datum/maint_recycler_vendor_entry
	name = "Cool Object to buy" //what it's shown as in the vendor
	desc = "What the object actually is" //what's shown to the user upon clicking the .../? details button
	var/object_type_to_spawn
	var/item_cost = 15 //in RP/Recycle Points

	var/tagline = "" //what's said by the vendor upon vending
	var/per_person_cap = -1 //-1 for infinite!
	var/per_round_cap = -1 //ditto. Global. for everyone. etc.
	var/list/purchased_by //associated list. client.key to amount bought.

	var/required_access = null //for stuff that doesn't make sense to have as standard station equipment or from cargo
	// but would be weird to hand out to just anyone.
	//can technically be cheesed as the source of "money" isn't tied to the ID, so you can borrow someone's access
	//but if someone's willing to be a big enough nerd, I'm not gonna waste time trying to stop it.

	var/access_select_mode = MAINTVENDOR_ACCESS_CHECK_OR //OR means at least one is valid, AND requires all of them to be valid (but doesn't say no if there's extras)

	var/dispense_sound //played on top of the standard vendor one

	var/vendor_category = MAINTVENDOR_GENERIC
