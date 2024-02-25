/client/proc/vv_get_class(var/var_name, var/var_value)
	if(isnull(var_value))
		. = VV_NULL

	else if (isnum(var_value))
		if (var_name in GLOB.bitfields)
			. = VV_BITFIELD
		else
			. = VV_NUM

	else if (istext(var_value))
		if (findtext(var_value, "\n"))
			. = VV_MESSAGE
		else
			. = VV_TEXT

	else if (isicon(var_value))
		. = VV_ICON

	else if (ismob(var_value))
		. = VV_MOB_REFERENCE

	else if (isloc(var_value))
		. = VV_ATOM_REFERENCE

	else if (istype(var_value, /client))
		. = VV_CLIENT

	else if (istype(var_value, /datum))
		. = VV_DATUM_REFERENCE

	else if (ispath(var_value))
		if (ispath(var_value, /atom))
			. = VV_ATOM_TYPE
		else if (ispath(var_value, /datum))
			. = VV_DATUM_TYPE
		else
			. = VV_TYPE

	else if (islist(var_value))
		. = VV_LIST

	else if (isfile(var_value))
		. = VV_FILE
	else
		. = VV_NULL

/client/proc/vv_get_value(class, default_class, current_value, list/restricted_classes, list/extra_classes, list/classes, var_name)
	. = list("class" = class, "value" = null)
	if (!class)
		if (!classes)
			classes = list (
				VV_NUM,
				VV_TEXT,
				VV_MESSAGE,
				VV_ICON,
				VV_ATOM_REFERENCE,
				VV_DATUM_REFERENCE,
				VV_MOB_REFERENCE,
				VV_CLIENT,
				VV_ATOM_TYPE,
				VV_DATUM_TYPE,
				VV_TYPE,
				VV_FILE,
				VV_NEW_ATOM,
				VV_NEW_DATUM,
				VV_NEW_TYPE,
				VV_NEW_LIST,
				VV_NULL,
				VV_RESTORE_DEFAULT
				)

		if(holder && holder.marked_datum && !(VV_MARKED_DATUM in restricted_classes))
			classes += "[VV_MARKED_DATUM] ([holder.marked_datum.type])"
		if (restricted_classes)
			classes -= restricted_classes

		if (extra_classes)
			classes += extra_classes

		.["class"] = tgui_input_list(src, "What kind of data?", "Variable Type", classes, default_class)
		if (holder && holder.marked_datum && .["class"] == "[VV_MARKED_DATUM] ([holder.marked_datum.type])")
			.["class"] = VV_MARKED_DATUM


	switch(.["class"])
		if (VV_TEXT)
			.["value"] = tgui_input_text(usr, "Enter new text:", "Text", current_value)
			if (.["value"] == null)
				.["class"] = null
				return
		if (VV_MESSAGE)
			.["value"] = tgui_input_text(usr, "Enter new text:", "Text", current_value, multiline = TRUE)
			if (.["value"] == null)
				.["class"] = null
				return


		if (VV_NUM)
			.["value"] = tgui_input_number(usr, "Enter new number:", "Num", current_value, INFINITY, -INFINITY, round_value = FALSE)
			if (.["value"] == null)
				.["class"] = null
				return

		if (VV_BITFIELD)
			.["value"] = input_bitfield(usr, "Editing bitfield: [var_name]", var_name, current_value)
			if (.["value"] == null)
				.["class"] = null
				return

		if (VV_ATOM_TYPE)
			.["value"] = pick_closest_path(FALSE)
			if (.["value"] == null)
				.["class"] = null
				return

		if (VV_DATUM_TYPE)
			.["value"] = pick_closest_path(FALSE, get_fancy_list_of_datum_types())
			if (.["value"] == null)
				.["class"] = null
				return

		if (VV_TYPE)
			var/type = current_value
			var/error = ""
			do
				type = tgui_input_text(usr, "Enter type:[error]", "Type", type)
				if (!type)
					break
				type = text2path(type)
				error = "\nType not found, Please try again"
			while(!type)
			if (!type)
				.["class"] = null
				return
			.["value"] = type


		if (VV_ATOM_REFERENCE)
			var/type = pick_closest_path(FALSE)
			var/subtypes = vv_subtype_prompt(type)
			if (subtypes == null)
				.["class"] = null
				return
			var/list/things = vv_reference_list(type, subtypes)
			var/value = tgui_input_list(usr, "Select reference:", "Reference", things, current_value)
			if (!value)
				.["class"] = null
				return
			.["value"] = things[value]

		if (VV_DATUM_REFERENCE)
			var/type = pick_closest_path(FALSE, get_fancy_list_of_datum_types())
			var/subtypes = vv_subtype_prompt(type)
			if (subtypes == null)
				.["class"] = null
				return
			var/list/things = vv_reference_list(type, subtypes)
			var/value = tgui_input_list(usr, "Select reference:", "Reference", things, current_value)
			if (!value)
				.["class"] = null
				return
			.["value"] = things[value]

		if (VV_MOB_REFERENCE)
			var/type = pick_closest_path(FALSE, make_types_fancy(typesof(/mob)))
			var/subtypes = vv_subtype_prompt(type)
			if (subtypes == null)
				.["class"] = null
				return
			var/list/things = vv_reference_list(type, subtypes)
			var/value = tgui_input_list(usr, "Select reference:", "Reference", things, current_value)
			if (!value)
				.["class"] = null
				return
			.["value"] = things[value]



		if (VV_CLIENT)
			.["value"] = tgui_input_list(usr, "Select reference:", "Reference", GLOB.clients, current_value)
			if (.["value"] == null)
				.["class"] = null
				return


		if (VV_FILE)
			.["value"] = input(usr, "Pick file:", "File") as null|file
			if (.["value"] == null)
				.["class"] = null
				return


		if (VV_ICON)
			.["value"] = input(usr, "Pick icon:", "Icon") as null|icon
			if (.["value"] == null)
				.["class"] = null
				return


		if (VV_MARKED_DATUM)
			.["value"] = holder.marked_datum
			if (.["value"] == null)
				.["class"] = null
				return


		if (VV_NEW_ATOM)
			var/type = pick_closest_path(FALSE)
			if (!type)
				.["class"] = null
				return
			.["type"] = type
			var/atom/newguy = new type()
			newguy.datum_flags |= DF_VAR_EDITED
			.["value"] = newguy

		if (VV_NEW_DATUM)
			var/type = pick_closest_path(FALSE, get_fancy_list_of_datum_types())
			if (!type)
				.["class"] = null
				return
			.["type"] = type
			var/datum/newguy = new type()
			newguy.datum_flags |= DF_VAR_EDITED
			.["value"] = newguy

		if (VV_NEW_TYPE)
			var/type = current_value
			var/error = ""
			do
				type = tgui_input_text(usr, "Enter type:[error]", "Type", type)
				if (!type)
					break
				type = text2path(type)
				error = "\nType not found, Please try again"
			while(!type)
			if (!type)
				.["class"] = null
				return
			.["type"] = type
			var/datum/newguy = new type()
			if(istype(newguy))
				newguy.datum_flags |= DF_VAR_EDITED
			.["value"] = newguy


		if (VV_NEW_LIST)
			.["value"] = list()
			.["type"] = /list
