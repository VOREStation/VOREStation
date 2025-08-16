/*!
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

/**
 * tgui state: admin_state
 *
 * Checks if the user has specific admin permissions.
 */

GLOBAL_DATUM_INIT(admin_states, /alist, alist())
GLOBAL_PROTECT(admin_states)

/datum/tgui_state/admin_state
	/// The specific admin permissions required for the UI using this state.
	VAR_FINAL/required_perms = R_ADMIN

/datum/tgui_state/admin_state/New(required_perms = R_ADMIN)
	. = ..()
	src.required_perms = required_perms

/datum/tgui_state/admin_state/can_use_topic(src_object, mob/user)
	if(check_rights_for(user.client, required_perms))
		return STATUS_INTERACTIVE
	return STATUS_CLOSE

/datum/tgui_state/admin_state/vv_edit_var(var_name, var_value)
	if(var_name == NAMEOF(src, required_perms))
		return FALSE
	return ..()
