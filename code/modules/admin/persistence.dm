ADMIN_VERB(view_persistent_data, R_MOD|R_ADMIN, "View Persistent Data", "Shows a list of persistent data for this round. Allows modification by admins.", ADMIN_CATEGORY_GAME)
	SSpersistence.show_info(user)
