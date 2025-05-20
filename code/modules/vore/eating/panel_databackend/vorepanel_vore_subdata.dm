#define DEFAULT_MESSAGE "Default"
#define ABSORBED_MESSAGE "Absorbed"
#define WITH_PREY "With Prey"
#define WITH_ABSORBED_PREY "With Absorbed Prey"
#define TRASH_EAT "Eat"
#define TRASH_EXPEL "Expel"
#define OUTSIDE_MESSAGE "Outside"
#define INSIDE_MESSAGE "Inside"
#define TO_YOU "To You"
#define TO_PREY "To Prey"
#define ATTEMPT_MESSAGE "Attempt"
#define SUCCESS_MESSAGE "Success"
#define ITEM_MESSAGE "Item"
#define FAIL_MESSAGE "Fail"
#define PRIMARY_MESSAGE "Primary"
#define SECONARY_MESSAGE "Secondary"
#define PRIMARY_AUTO_MESSAGE "Primary (Auto)"
#define SECONARY_AUTO_MESSAGE "Secondary (Auto)"
#define DIGEST_MESSAGE "Digest"
#define HOLD_MESSAGE "Hold"
#define HOLDABSORBED_MESSAGE "Hold (Absorbed)"
#define ABSORB_MESSAGE "Absorb"
#define HEAL_MESSAGE  "Heal"
#define DRAIN_MESSAGE  "Drain"
#define STEAL_MESSAGE  "Steal"
#define EGG_MESSAGE  "Egg"
#define SHRINK_MESSAGE  "Shrink"
#define GROW_MESSAGE  "Grow"
#define UNABSORB_MESSAGE  "Unabsorb"

/datum/vore_look/proc/compile_message_data(obj/belly/selected)
	if(message_option == VPANEL_DESCRIPTION_TAB)
		var/list/tab_data = list(
			"possible_messages" = list(DEFAULT_MESSAGE, ABSORBED_MESSAGE)
			)
		if(!selected_message)
			selected_message = DEFAULT_MESSAGE
		if(selected_message == DEFAULT_MESSAGE)
			tab_data["max_length"] = BELLIES_DESC_MAX
			tab_data["active_message"] = selected.desc
			tab_data["set_action"] = BELLY_DESCRIPTION_MESSAGE
			tab_data["tooltip"] = "Displayed to prey upon consumption."
			return tab_data
		if(selected_message == ABSORBED_MESSAGE)
			tab_data["max_length"] = BELLIES_DESC_MAX
			tab_data["active_message"] = selected.absorbed_desc
			tab_data["set_action"] = BELLY_DESCRIPTION_MESSAGE_ABSROED
			tab_data["tooltip"] = "Displayed to prey after absorption."
		return tab_data

	if(message_option == VPANEL_EXAMINE_TAB)
		var/list/tab_data = list(
			"possible_messages" = list(WITH_PREY, WITH_ABSORBED_PREY)
			)
		if(!selected_message)
			selected_message = WITH_PREY
		if(selected_message == WITH_PREY)
			tab_data["max_length"] = BELLIES_EXAMINE_MAX
			tab_data["active_message"] = selected.examine_messages
			tab_data["set_action"] = EXAMINES
			tab_data["tooltip"] = "Displayed to nearby players during examination when the vorgan is full."
			return tab_data
		if(selected_message == WITH_ABSORBED_PREY)
			tab_data["max_length"] = BELLIES_EXAMINE_MAX
			tab_data["active_message"] = selected.examine_messages_absorbed
			tab_data["set_action"] = EXAMINES_ABSORBED
			tab_data["tooltip"] = "Displayed to nearby players during examination when the vorgan contains absorbed prey."
		return tab_data

	if(message_option == VPANEL_TRASH_EATER_TAB)
		var/list/tab_data = list(
			"possible_messages" = list(TRASH_EAT, TRASH_EXPEL)
			)
		if(!selected_message)
			selected_message = TRASH_EAT
		if(selected_message == TRASH_EAT)
			tab_data["max_length"] = BELLIES_MESSAGE_MAX
			tab_data["active_message"] = selected.trash_eater_in
			tab_data["set_action"] = BELLY_TRASH_EATER_IN
			tab_data["tooltip"] = "Displayed to nearby players when you ingest trash items."
			return tab_data
		if(selected_message == TRASH_EXPEL)
			tab_data["max_length"] = BELLIES_MESSAGE_MAX
			tab_data["active_message"] = selected.trash_eater_out
			tab_data["set_action"] = BELLY_TRASH_EATER_OUT
			tab_data["tooltip"] = "Displayed to nearby players when you expel trash items."
		return tab_data

	if(message_option == VPANEL_STRUGGLE_TAB)
		var/list/tab_data = list(
			"subtypes" = list(DEFAULT_MESSAGE, ABSORBED_MESSAGE)
			)
		if(!message_subtab)
			message_subtab = DEFAULT_MESSAGE
		if(message_subtab == DEFAULT_MESSAGE)
			tab_data["possible_messages"] = list(OUTSIDE_MESSAGE, INSIDE_MESSAGE)
			if(!selected_message)
				selected_message = OUTSIDE_MESSAGE
			if(selected_message == OUTSIDE_MESSAGE)
				tab_data["max_length"] = BELLIES_MESSAGE_MAX
				tab_data["active_message"] = selected.struggle_messages_outside
				tab_data["set_action"] = STRUGGLE_OUTSIDE
				tab_data["tooltip"] = "Displayed to nearby players when your prey resists."
				return tab_data
			if(selected_message == INSIDE_MESSAGE)
				tab_data["max_length"] = BELLIES_MESSAGE_MAX
				tab_data["active_message"] = selected.struggle_messages_inside
				tab_data["set_action"] = STRUGGLE_INSIDE
				tab_data["tooltip"] = "Displayed to your prey when they resists."
				return tab_data
		if(message_subtab == ABSORBED_MESSAGE)
			tab_data["possible_messages"] = list(OUTSIDE_MESSAGE, INSIDE_MESSAGE)
			if(!selected_message)
				selected_message = OUTSIDE_MESSAGE
			if(selected_message == OUTSIDE_MESSAGE)
				tab_data["max_length"] = BELLIES_MESSAGE_MAX
				tab_data["active_message"] = selected.absorbed_struggle_messages_outside
				tab_data["set_action"] = ABSORBED_STRUGGLE_OUSIDE
				tab_data["tooltip"] = "Displayed to nearby players when your absorb prey resists."
				return tab_data
			if(selected_message == INSIDE_MESSAGE)
				tab_data["max_length"] = BELLIES_MESSAGE_MAX
				tab_data["active_message"] = selected.absorbed_struggle_messages_inside
				tab_data["set_action"] = ABSORBED_STRUGGLE_INSIDE
				tab_data["tooltip"] = "Displayed to your prey when absorbed prey resists."
		return tab_data

	if(message_option == VPANEL_ESCAPE_TAB)
		var/list/tab_data = list(
			"subtypes" = list(ITEM_MESSAGE, ATTEMPT_MESSAGE, FAIL_MESSAGE)
			)
		if(selected.message_mode || selected.escapechance)
			tab_data["subtypes"] += SUCCESS_MESSAGE
		if(!message_subtab)
			message_subtab = ATTEMPT_MESSAGE
		if(message_subtab == ATTEMPT_MESSAGE)
			tab_data["possible_messages"] = list(TO_PREY, TO_YOU)
			if(!selected_message)
				selected_message = TO_PREY
			if(selected_message == TO_PREY)
				tab_data["max_length"] = BELLIES_MESSAGE_MAX
				tab_data["active_message"] = selected.escape_attempt_messages_prey
				tab_data["set_action"] = ESCAPE_ATTEMPT_PREY
				tab_data["tooltip"] = "Displayed to your prey when they trigger an escape attempt."
				return tab_data
			if(selected_message == TO_YOU)
				tab_data["max_length"] = BELLIES_MESSAGE_MAX
				tab_data["active_message"] = selected.escape_attempt_messages_owner
				tab_data["set_action"] = ESCAPE_ATTEMPT_OWNER
				tab_data["tooltip"] = "Displayed to you when your prey triggers an escape attempt."
			return tab_data
		if(message_subtab == SUCCESS_MESSAGE)
			tab_data["possible_messages"] = list(TO_PREY, TO_YOU, OUTSIDE_MESSAGE)
			if(!selected_message)
				selected_message = TO_PREY
			if(selected_message == TO_PREY)
				tab_data["max_length"] = BELLIES_MESSAGE_MAX
				tab_data["active_message"] = selected.escape_messages_prey
				tab_data["set_action"] = ESCAPE_PREY
				tab_data["tooltip"] = "Displayed to your prey when they succeed an escape attempt."
				return tab_data
			if(selected_message == TO_YOU)
				tab_data["max_length"] = BELLIES_MESSAGE_MAX
				tab_data["active_message"] = selected.escape_messages_owner
				tab_data["set_action"] = ESCAPE_OWNER
				tab_data["tooltip"] = "Displayed to you when your prey succeeds an escape attempt."
				return tab_data
			if(selected_message == OUTSIDE_MESSAGE)
				tab_data["max_length"] = BELLIES_MESSAGE_MAX
				tab_data["active_message"] = selected.escape_messages_outside
				tab_data["set_action"] = ESCAPE_OUTSIDE
				tab_data["tooltip"] = "Displayed to nearby players when your prey succeeds an escape attempt."
			return tab_data
		if(message_subtab == ITEM_MESSAGE)
			tab_data["possible_messages"] = list(TO_PREY, TO_YOU, OUTSIDE_MESSAGE)
			if(!selected_message)
				selected_message = TO_PREY
			if(selected_message == TO_PREY)
				tab_data["max_length"] = BELLIES_MESSAGE_MAX
				tab_data["active_message"] = selected.escape_item_messages_prey
				tab_data["set_action"] = ESCAPE_ITEM_PREY
				tab_data["tooltip"] = "Displayed to your prey when they manage to push an item out of your belly."
				return tab_data
			if(selected_message == TO_YOU)
				tab_data["max_length"] = BELLIES_MESSAGE_MAX
				tab_data["active_message"] = selected.escape_item_messages_owner
				tab_data["set_action"] = ESCAPE_ITEM_OWNER
				tab_data["tooltip"] = "Displayed to you when your prey manages to push an item out of your belly."
				return tab_data
			if(selected_message == OUTSIDE_MESSAGE)
				tab_data["max_length"] = BELLIES_MESSAGE_MAX
				tab_data["active_message"] = selected.escape_item_messages_outside
				tab_data["set_action"] = ESCAPE_ITEM_OUTSIDE
				tab_data["tooltip"] = "Displayed to nearby players when your prey manages to push an item out of your belly."
			return tab_data
		if(message_subtab == FAIL_MESSAGE)
			tab_data["possible_messages"] = list(TO_PREY, TO_YOU)
			if(!selected_message)
				selected_message = TO_PREY
			if(selected_message == TO_PREY)
				tab_data["max_length"] = BELLIES_MESSAGE_MAX
				tab_data["active_message"] = selected.escape_fail_messages_prey
				tab_data["set_action"] = ESCAPE_FAIL_PREY
				tab_data["tooltip"] = "Displayed to your prey when they fail an escape attempt."
				return tab_data
			if(selected_message == TO_YOU)
				tab_data["max_length"] = BELLIES_MESSAGE_MAX
				tab_data["active_message"] = selected.escape_fail_messages_owner
				tab_data["set_action"] = ESCAPE_FAIL_OWNER
				tab_data["tooltip"] = "Displayed to you when your prey fails an escape attempt."
		return tab_data

	if(message_option == VPANEL_ESCAPE_ABSORBED_TAB)
		var/list/tab_data = list(
			"subtypes" = list(ATTEMPT_MESSAGE, FAIL_MESSAGE)
			)
		if(selected.message_mode || selected.escapechance_absorbed)
			tab_data["subtypes"] += SUCCESS_MESSAGE
		if(!message_subtab)
			message_subtab = ATTEMPT_MESSAGE
		if(message_subtab == ATTEMPT_MESSAGE)
			tab_data["possible_messages"] = list(TO_PREY, TO_YOU)
			if(!selected_message)
				selected_message = TO_PREY
			if(selected_message == TO_PREY)
				tab_data["max_length"] = BELLIES_MESSAGE_MAX
				tab_data["active_message"] = selected.escape_attempt_absorbed_messages_prey
				tab_data["set_action"] = ABSORBED_ESCAPE_ATTEMPT_PREY
				tab_data["tooltip"] = "Displayed to your prey when they trigger an escape attempt."
				return tab_data
			if(selected_message == TO_YOU)
				tab_data["max_length"] = BELLIES_MESSAGE_MAX
				tab_data["active_message"] = selected.escape_attempt_absorbed_messages_owner
				tab_data["set_action"] = ABSORBED_ESCAPE_ATTEMPT_OWNER
				tab_data["tooltip"] = "Displayed to you when your prey triggers an escape attempt."
			return tab_data
		if(message_subtab == SUCCESS_MESSAGE)
			tab_data["possible_messages"] = list(TO_PREY, TO_YOU, OUTSIDE_MESSAGE)
			if(!selected_message)
				selected_message = TO_PREY
			if(selected_message == TO_PREY)
				tab_data["max_length"] = BELLIES_MESSAGE_MAX
				tab_data["active_message"] = selected.escape_absorbed_messages_prey
				tab_data["set_action"] = ABSORBED_ESCAPE_PREY
				tab_data["tooltip"] = "Displayed to your absorbed prey when they succeed an escape attempt."
				return tab_data
			if(selected_message == TO_YOU)
				tab_data["max_length"] = BELLIES_MESSAGE_MAX
				tab_data["active_message"] = selected.escape_absorbed_messages_owner
				tab_data["set_action"] = ABSORBED_ESCAPE_OWNER
				tab_data["tooltip"] = "Displayed to you when your absorbed prey succeeds an escape attempt."
				return tab_data
			if(selected_message == OUTSIDE_MESSAGE)
				tab_data["max_length"] = BELLIES_MESSAGE_MAX
				tab_data["active_message"] = selected.escape_absorbed_messages_outside
				tab_data["set_action"] = ABSORBED_ESCAPE_OUTSIDE
				tab_data["tooltip"] = "Displayed to nearby players when your absorbed prey succeeds an escape attempt."
			return tab_data
		if(message_subtab == FAIL_MESSAGE)
			tab_data["possible_messages"] = list(TO_PREY, TO_YOU)
			if(!selected_message)
				selected_message = TO_PREY
			if(selected_message == TO_PREY)
				tab_data["max_length"] = BELLIES_MESSAGE_MAX
				tab_data["active_message"] = selected.escape_fail_absorbed_messages_prey
				tab_data["set_action"] = ABSORBED_ESCAPE_FAIL_PREY
				tab_data["tooltip"] = "Displayed to your absorbed prey when they fail an escape attempt."
				return tab_data
			if(selected_message == TO_YOU)
				tab_data["max_length"] = BELLIES_MESSAGE_MAX
				tab_data["active_message"] = selected.escape_fail_absorbed_messages_owner
				tab_data["set_action"] = ABSORBED_ESCAPE_FAIL_OWNER
				tab_data["tooltip"] = "Displayed to you when your absorbed prey fails an escape attempt."
		return tab_data

	if(message_option == VPANEL_TRANSFER_TAB)
		var/list/tab_data = list(
			"subtypes" = list()
			)
		if(selected.message_mode || selected.transferlocation)
			tab_data["subtypes"] += PRIMARY_MESSAGE
		if(selected.message_mode || selected.transferlocation_secondary)
			tab_data["subtypes"] += SECONARY_MESSAGE
		if(selected.message_mode || selected.autotransferlocation)
			tab_data["subtypes"] += PRIMARY_AUTO_MESSAGE
		if(selected.message_mode || selected.autotransferlocation_secondary)
			tab_data["subtypes"] += SECONARY_AUTO_MESSAGE
		if(!message_subtab)
			message_subtab = PRIMARY_MESSAGE
		if(message_subtab == PRIMARY_MESSAGE)
			tab_data["possible_messages"] = list(TO_PREY, TO_YOU)
			if(!selected_message)
				selected_message = TO_PREY
			if(selected_message == TO_PREY)
				tab_data["max_length"] = BELLIES_MESSAGE_MAX
				tab_data["active_message"] = selected.primary_transfer_messages_prey
				tab_data["set_action"] = PRIMARY_TRANSFER_PREY
				tab_data["tooltip"] = "Displayed to your prey when they get transfered to the primary transfer location."
				return tab_data
			if(selected_message == TO_YOU)
				tab_data["max_length"] = BELLIES_MESSAGE_MAX
				tab_data["active_message"] = selected.primary_transfer_messages_owner
				tab_data["set_action"] = PRIMARY_TRANSFER_OWNER
				tab_data["tooltip"] = "Displayed to you when your prey gets transfered to the primary transfer location."
			return tab_data
		if(message_subtab == SECONARY_MESSAGE)
			tab_data["possible_messages"] = list(TO_PREY, TO_YOU)
			if(!selected_message)
				selected_message = TO_PREY
			if(selected_message == TO_PREY)
				tab_data["max_length"] = BELLIES_MESSAGE_MAX
				tab_data["active_message"] = selected.secondary_transfer_messages_prey
				tab_data["set_action"] = SECONDARY_TRANSFER_PREY
				tab_data["tooltip"] = "Displayed to your prey when they get transfered to the secondary transfer location."
				return tab_data
			if(selected_message == TO_YOU)
				tab_data["max_length"] = BELLIES_MESSAGE_MAX
				tab_data["active_message"] = selected.secondary_transfer_messages_owner
				tab_data["set_action"] = SECONDARY_TRANSFER_OWNER
				tab_data["tooltip"] = "Displayed to you when your prey gets transfered to the secondary transfer location."
			return tab_data
		if(message_subtab == PRIMARY_AUTO_MESSAGE)
			tab_data["possible_messages"] = list(TO_PREY, TO_YOU)
			if(!selected_message)
				selected_message = TO_PREY
			if(selected_message == TO_PREY)
				tab_data["max_length"] = BELLIES_MESSAGE_MAX
				tab_data["active_message"] = selected.primary_autotransfer_messages_prey
				tab_data["set_action"] = PRIMARY_AUTO_TRANSFER_PREY
				tab_data["tooltip"] = "Displayed to your prey when they get transfered to the primary auto transfer location."
				return tab_data
			if(selected_message == TO_YOU)
				tab_data["max_length"] = BELLIES_MESSAGE_MAX
				tab_data["active_message"] = selected.primary_autotransfer_messages_owner
				tab_data["set_action"] = PRIMARY_AUTO_TRANSFER_OWNER
				tab_data["tooltip"] = "Displayed to you when your prey gets transfered to the primary auto transfer location."
			return tab_data
		if(message_subtab == SECONARY_AUTO_MESSAGE)
			tab_data["possible_messages"] = list(TO_PREY, TO_YOU)
			if(!selected_message)
				selected_message = TO_PREY
			if(selected_message == TO_PREY)
				tab_data["max_length"] = BELLIES_MESSAGE_MAX
				tab_data["active_message"] = selected.secondary_autotransfer_messages_prey
				tab_data["set_action"] = SECONDARY_AUTO_TRANSFER_PREY
				tab_data["tooltip"] = "Displayed to your prey when they get transfered to the secondary auto transfer location."
				return tab_data
			if(selected_message == TO_YOU)
				tab_data["max_length"] = BELLIES_MESSAGE_MAX
				tab_data["active_message"] = selected.secondary_autotransfer_messages_owner
				tab_data["set_action"] = SECONDARY_AUTO_TRANSFER_OWNER
				tab_data["tooltip"] = "Displayed to you when your prey gets transfered to the secondary auto transfer location."
		return tab_data

	if(message_option == VPANEL_INTERACTION_TAB)
		var/list/tab_data = list(
			"subtypes" = list()
			)
		if(selected.message_mode || selected.digestchance)
			tab_data["subtypes"] += DIGEST_MESSAGE
		if(selected.message_mode || selected.absorbchance)
			tab_data["subtypes"] += ABSORB_MESSAGE
		if(!message_subtab)
			message_subtab = DIGEST_MESSAGE
		if(message_subtab == DIGEST_MESSAGE)
			tab_data["possible_messages"] = list(TO_PREY, TO_YOU)
			if(!selected_message)
				selected_message = TO_PREY
			if(selected_message == TO_PREY)
				tab_data["max_length"] = BELLIES_MESSAGE_MAX
				tab_data["active_message"] = selected.digest_chance_messages_prey
				tab_data["set_action"] = DIGEST_CHANCE_PREY
				tab_data["tooltip"] = "Displayed to your prey when their struggles trigger digest mode."
				return tab_data
			if(selected_message == TO_YOU)
				tab_data["max_length"] = BELLIES_MESSAGE_MAX
				tab_data["active_message"] = selected.digest_chance_messages_owner
				tab_data["set_action"] = DIGEST_CHANCE_OWNER
				tab_data["tooltip"] = "Displayed to you when your prey's struggles trigger digest mode."
				return tab_data
		if(message_subtab == ABSORB_MESSAGE)
			tab_data["possible_messages"] = list(TO_PREY, TO_YOU)
			if(!selected_message)
				selected_message = TO_PREY
			if(selected_message == TO_PREY)
				tab_data["max_length"] = BELLIES_MESSAGE_MAX
				tab_data["active_message"] = selected.absorb_chance_messages_prey
				tab_data["set_action"] = ABSORB_CHANCE_PREY
				tab_data["tooltip"] = "Displayed to your prey when their struggles trigger absorb mode."
				return tab_data
			if(selected_message == TO_YOU)
				tab_data["max_length"] = BELLIES_MESSAGE_MAX
				tab_data["active_message"] = selected.absorb_chance_messages_owner
				tab_data["set_action"] = ABSORB_CHANCE_OWNER
				tab_data["tooltip"] = "Displayed to you when your prey's struggles trigger absorb mode."
		return tab_data

	if(message_option == VPANEL_BELLYMODE_TAB)
		var/list/tab_data = list(
			"subtypes" = list()
			)
		if(selected.message_mode || selected.digest_mode == DM_DIGEST || DM_SELECT)
			tab_data["subtypes"] += DIGEST_MESSAGE
		if(selected.message_mode || selected.digest_mode == DM_ABSORB || DM_SELECT)
			tab_data["subtypes"] += ABSORB_MESSAGE
		if(selected.message_mode || selected.digest_mode == DM_UNABSORB)
			tab_data["subtypes"] += UNABSORB_MESSAGE
		if(!message_subtab)
			message_subtab = DIGEST_MESSAGE
		if(message_subtab == DIGEST_MESSAGE)
			tab_data["possible_messages"] = list(TO_PREY, TO_YOU)
			if(!selected_message)
				selected_message = TO_PREY
			if(selected_message == TO_PREY)
				tab_data["max_length"] = BELLIES_MESSAGE_MAX
				tab_data["active_message"] = selected.digest_messages_prey
				tab_data["set_action"] = DIGEST_PREY
				tab_data["tooltip"] = "Displayed to your prey when they get digested."
				return tab_data
			if(selected_message == TO_YOU)
				tab_data["max_length"] = BELLIES_MESSAGE_MAX
				tab_data["active_message"] = selected.digest_messages_owner
				tab_data["set_action"] = DIGEST_OWNER
				tab_data["tooltip"] = "Displayed to you when your prey gets digested."
				return tab_data
		if(message_subtab == ABSORBED_MESSAGE)
			tab_data["possible_messages"] = list(TO_PREY, TO_YOU)
			if(!selected_message)
				selected_message = TO_PREY
			if(selected_message == TO_PREY)
				tab_data["max_length"] = BELLIES_MESSAGE_MAX
				tab_data["active_message"] = selected.absorb_messages_prey
				tab_data["set_action"] = ABSORB_PREY
				tab_data["tooltip"] = "Displayed to your prey when they get absorbed."
				return tab_data
			if(selected_message == TO_YOU)
				tab_data["max_length"] = BELLIES_MESSAGE_MAX
				tab_data["active_message"] = selected.absorb_messages_owner
				tab_data["set_action"] = ABSORB_OWNER
				tab_data["tooltip"] = "Displayed to you when your prey gets absorbed."
		if(message_subtab == UNABSORB_MESSAGE)
			tab_data["possible_messages"] = list(TO_PREY, TO_YOU)
			if(!selected_message)
				selected_message = TO_PREY
			if(selected_message == TO_PREY)
				tab_data["max_length"] = BELLIES_MESSAGE_MAX
				tab_data["active_message"] = selected.unabsorb_messages_prey
				tab_data["set_action"] = UNABSORBS_PREY
				tab_data["tooltip"] = "Displayed to your prey when they get unabsorbed."
				return tab_data
			if(selected_message == TO_YOU)
				tab_data["max_length"] = BELLIES_MESSAGE_MAX
				tab_data["active_message"] = selected.unabsorb_messages_owner
				tab_data["set_action"] = UNABSORBS_OWNER
				tab_data["tooltip"] = "Displayed to you when your prey gets unabsorbed."
		return tab_data

	if(message_option == VPANEL_IDLE_TAB)
		var/list/tab_data = list(
			"possible_messages" = list()
			)
		if(selected.message_mode || selected.digest_mode == DM_DIGEST || selected.digest_mode == DM_SELECT)
			tab_data["possible_messages"] += DIGEST_MESSAGE
		if(selected.message_mode || selected.digest_mode == DM_HOLD || selected.digest_mode == DM_SELECT)
			tab_data["possible_messages"] += HOLD_MESSAGE
			tab_data["possible_messages"] += HOLDABSORBED_MESSAGE
		if(selected.message_mode || selected.digest_mode == DM_ABSORB || selected.digest_mode == DM_SELECT)
			tab_data["possible_messages"] += ABSORB_MESSAGE
		if(selected.message_mode || selected.digest_mode == DM_HEAL)
			tab_data["possible_messages"] += HEAL_MESSAGE
		if(selected.message_mode || selected.digest_mode == DM_DRAIN || selected.digest_mode == DM_SELECT)
			tab_data["possible_messages"] += DRAIN_MESSAGE
		if(selected.message_mode || selected.digest_mode == DM_SIZE_STEAL)
			tab_data["possible_messages"] += STEAL_MESSAGE
		if(selected.message_mode || selected.digest_mode == DM_EGG)
			tab_data["possible_messages"] += EGG_MESSAGE
		if(selected.message_mode || selected.digest_mode == DM_SHRINK)
			tab_data["possible_messages"] += SHRINK_MESSAGE
		if(selected.message_mode || selected.digest_mode == DM_GROW)
			tab_data["possible_messages"] += GROW_MESSAGE
		if(selected.message_mode || selected.digest_mode == DM_UNABSORB)
			tab_data["possible_messages"] += UNABSORB_MESSAGE
		if(!selected_message)
			selected_message = DIGEST_MESSAGE
		if(selected_message == DIGEST_MESSAGE)
			tab_data["max_length"] = BELLIES_IDLE_MAX
			tab_data["active_message"] = SANITIZE_LIST(selected.emote_lists[DM_DIGEST])
			tab_data["set_action"] = BELLY_MODE_DIGEST
			tab_data["tooltip"] = "Cyclic idle messages while your prey is getting digested."
			return tab_data
		if(selected_message == HOLD_MESSAGE)
			tab_data["max_length"] = BELLIES_IDLE_MAX
			tab_data["active_message"] = SANITIZE_LIST(selected.emote_lists[DM_HOLD])
			tab_data["set_action"] = BELLY_MODE_HOLD
			tab_data["tooltip"] = "Cyclic idle messages while your prey is being held."
			return tab_data
		if(selected_message == HOLDABSORBED_MESSAGE)
			tab_data["max_length"] = BELLIES_IDLE_MAX
			tab_data["active_message"] = SANITIZE_LIST(selected.emote_lists[DM_HOLD_ABSORBED])
			tab_data["set_action"] = BELLY_MODE_HOLD_ABSORB
			tab_data["tooltip"] = "Cyclic idle messages while your absorbed prey is being held."
			return tab_data
		if(selected_message == ABSORB_MESSAGE)
			tab_data["max_length"] = BELLIES_IDLE_MAX
			tab_data["active_message"] = SANITIZE_LIST(selected.emote_lists[DM_ABSORB])
			tab_data["set_action"] = BELLY_MODE_ABSORB
			tab_data["tooltip"] = "Cyclic idle messages while your prey is getting absorbed."
			return tab_data
		if(selected_message == HEAL_MESSAGE)
			tab_data["max_length"] = BELLIES_IDLE_MAX
			tab_data["active_message"] = SANITIZE_LIST(selected.emote_lists[DM_HEAL])
			tab_data["set_action"] = BELLY_MODE_HEAL
			tab_data["tooltip"] = "Cyclic idle messages while your prey is getting healed."
			return tab_data
		if(selected_message == DRAIN_MESSAGE)
			tab_data["max_length"] = BELLIES_IDLE_MAX
			tab_data["active_message"] = SANITIZE_LIST(selected.emote_lists[DM_DRAIN])
			tab_data["set_action"] = BELLY_MODE_DRAIN
			tab_data["tooltip"] = "Cyclic idle messages while your prey is getting drained."
			return tab_data
		if(selected_message == STEAL_MESSAGE)
			tab_data["max_length"] = BELLIES_IDLE_MAX
			tab_data["active_message"] = SANITIZE_LIST(selected.emote_lists[DM_SIZE_STEAL])
			tab_data["set_action"] = BELLY_MODE_STEAL
			tab_data["tooltip"] = "Cyclic idle messages while your prey's size is stolen."
			return tab_data
		if(selected_message == EGG_MESSAGE)
			tab_data["max_length"] = BELLIES_IDLE_MAX
			tab_data["active_message"] = SANITIZE_LIST(selected.emote_lists[DM_EGG])
			tab_data["set_action"] = BELLY_MODE_EGG
			tab_data["tooltip"] = "Cyclic idle messages while your prey is getting getting encased in an egg."
			return tab_data
		if(selected_message == SHRINK_MESSAGE)
			tab_data["max_length"] = BELLIES_IDLE_MAX
			tab_data["active_message"] = SANITIZE_LIST(selected.emote_lists[DM_SHRINK])
			tab_data["set_action"] = BELLY_MODE_SHRINK
			tab_data["tooltip"] = "Cyclic idle messages while your prey is getting shrunk."
			return tab_data
		if(selected_message == GROW_MESSAGE)
			tab_data["max_length"] = BELLIES_IDLE_MAX
			tab_data["active_message"] = SANITIZE_LIST(selected.emote_lists[DM_GROW])
			tab_data["set_action"] = BELLY_MODE_GROW
			tab_data["tooltip"] = "Cyclic idle messages while your prey is getting grown."
			return tab_data
		if(selected_message == UNABSORB_MESSAGE)
			tab_data["max_length"] = BELLIES_IDLE_MAX
			tab_data["active_message"] = SANITIZE_LIST(selected.emote_lists[DM_UNABSORB])
			tab_data["set_action"] = BELLY_MODE_UNABSORB
			tab_data["tooltip"] = "Cyclic idle messages while your prey is getting unabsorbed."
		return tab_data


/datum/vore_look/proc/compile_interact_data(obj/belly/selected)
	var/list/interact_data = list()
	if(selected.escapable)
		interact_data += list(
			"escapechance" = selected.escapechance,
			"escapechance_absorbed" = selected.escapechance_absorbed,
			"escapetime" = selected.escapetime,
			"transferchance" = selected.transferchance,
			"transferlocation" = selected.transferlocation,
			"transferchance_secondary" = selected.transferchance_secondary,
			"transferlocation_secondary" = selected.transferlocation_secondary,
			"absorbchance" = selected.absorbchance,
			"digestchance" = selected.digestchance,
			"belchchance" = selected.belchchance
		)

	return interact_data

/datum/vore_look/proc/compile_autotransfer_data(obj/belly/selected)
	var/list/autotransfer_data = list()
	if(selected.autotransfer_enabled)
		//auto-transfer flags
		var/list/at_whitelist = list()
		for(var/flag_name in selected.autotransfer_flags_list)
			if(selected.autotransfer_whitelist & selected.autotransfer_flags_list[flag_name])
				at_whitelist.Add(flag_name)
		var/list/at_blacklist = list()
		for(var/flag_name in selected.autotransfer_flags_list)
			if(selected.autotransfer_blacklist & selected.autotransfer_flags_list[flag_name])
				at_blacklist.Add(flag_name)
		var/list/at_whitelist_items = list()
		for(var/flag_name in selected.autotransfer_flags_list_items)
			if(selected.autotransfer_whitelist_items & selected.autotransfer_flags_list_items[flag_name])
				at_whitelist_items.Add(flag_name)
		var/list/at_blacklist_items = list()
		for(var/flag_name in selected.autotransfer_flags_list_items)
			if(selected.autotransfer_blacklist_items & selected.autotransfer_flags_list_items[flag_name])
				at_blacklist_items.Add(flag_name)
		var/list/at_secondary_whitelist = list()
		for(var/flag_name in selected.autotransfer_flags_list)
			if(selected.autotransfer_secondary_whitelist & selected.autotransfer_flags_list[flag_name])
				at_secondary_whitelist.Add(flag_name)
		var/list/at_secondary_blacklist = list()
		for(var/flag_name in selected.autotransfer_flags_list)
			if(selected.autotransfer_secondary_blacklist & selected.autotransfer_flags_list[flag_name])
				at_secondary_blacklist.Add(flag_name)
		var/list/at_secondary_whitelist_items = list()
		for(var/flag_name in selected.autotransfer_flags_list_items)
			if(selected.autotransfer_secondary_whitelist_items & selected.autotransfer_flags_list_items[flag_name])
				at_secondary_whitelist_items.Add(flag_name)
		var/list/at_secondary_blacklist_items = list()
		for(var/flag_name in selected.autotransfer_flags_list_items)
			if(selected.autotransfer_secondary_blacklist_items & selected.autotransfer_flags_list_items[flag_name])
				at_secondary_blacklist_items.Add(flag_name)

		autotransfer_data += list(
			"autotransferchance" = selected.autotransferchance,
			"autotransferwait" = selected.autotransferwait,
			"autotransferlocation" = selected.autotransferlocation,
			"autotransferextralocation" = selected.autotransferextralocation,
			"autotransferchance_secondary" = selected.autotransferchance_secondary,
			"autotransferlocation_secondary" = selected.autotransferlocation_secondary,
			"autotransferextralocation_secondary" = selected.autotransferextralocation_secondary,
			"autotransfer_min_amount" = selected.autotransfer_min_amount,
			"autotransfer_max_amount" = selected.autotransfer_max_amount,
			"autotransfer_whitelist" = at_whitelist,
			"autotransfer_blacklist" = at_blacklist,
			"autotransfer_whitelist_items" = at_whitelist_items,
			"autotransfer_blacklist_items" = at_blacklist_items,
			"autotransfer_secondary_whitelist" = at_secondary_whitelist,
			"autotransfer_secondary_blacklist" = at_secondary_blacklist,
			"autotransfer_secondary_whitelist_items" = at_secondary_whitelist_items,
			"autotransfer_secondary_blacklist_items" = at_secondary_blacklist_items,
		)
	return autotransfer_data

#undef DEFAULT_MESSAGE
#undef ABSORBED_MESSAGE
#undef WITH_PREY
#undef WITH_ABSORBED_PREY
#undef TRASH_EAT
#undef TRASH_EXPEL
#undef OUTSIDE_MESSAGE
#undef INSIDE_MESSAGE
#undef TO_YOU
#undef TO_PREY
#undef ATTEMPT_MESSAGE
#undef SUCCESS_MESSAGE
#undef ITEM_MESSAGE
#undef FAIL_MESSAGE
#undef PRIMARY_MESSAGE
#undef SECONARY_MESSAGE
#undef PRIMARY_AUTO_MESSAGE
#undef SECONARY_AUTO_MESSAGE
#undef DIGEST_MESSAGE
#undef HOLD_MESSAGE
#undef HOLDABSORBED_MESSAGE
#undef ABSORB_MESSAGE
#undef HEAL_MESSAGE
#undef DRAIN_MESSAGE
#undef STEAL_MESSAGE
#undef EGG_MESSAGE
#undef SHRINK_MESSAGE
#undef GROW_MESSAGE
#undef UNABSORB_MESSAGE
