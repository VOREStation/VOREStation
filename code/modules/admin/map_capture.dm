
ADMIN_VERB(capture_map, R_ADMIN, "Capture Map Part", "Usage: Capture-Map-Part target_x_cord target_y_cord target_z_cord range (captures part of a map originating from bottom left corner).", ADMIN_CATEGORY_SERVER_GAME, tx as null|num, ty as null|num, tz as null|num, range as null|num)
	if(isnull(tx) || isnull(ty) || isnull(tz) || isnull(range))
		to_chat(user, span_filter_notice("Capture Map Part, captures part of a map using camara like rendering."))
		to_chat(user, span_filter_notice("Usage: Capture-Map-Part target_x_cord target_y_cord target_z_cord range."))
		to_chat(user, span_filter_notice("Target coordinates specify bottom left corner of the capture, range defines render distance to opposite corner."))
		return

	if(range > 32 || range <= 0)
		to_chat(user, span_filter_notice("Capturing range is incorrect, it must be within 1-32."))
		return

	if(locate(tx,ty,tz))
		var/list/turfstocapture = list()
		var/hasasked = FALSE
		for(var/xoff = 0 to range)
			for(var/yoff = 0 to range)
				var/turf/T = locate(tx + xoff,ty + yoff,tz)
				if(T)
					turfstocapture.Add(T)
				else
					if(!hasasked)
						var/answer = tgui_alert(user, "Capture includes non existant turf, Continue capture?","Continue capture?", list("No", "Yes"))
						hasasked = TRUE
						if(answer != "Yes")
							return

		var/list/atoms = list()
		for(var/turf/T in turfstocapture)
			atoms.Add(T)
			for(var/atom/A in T)
				if(A.invisibility) continue
				atoms.Add(A)

		atoms = sort_atoms_by_layer(atoms)
		var/icon/cap = icon('icons/effects/96x96.dmi', "")
		cap.Scale(range*32, range*32)
		cap.Blend("#000", ICON_OVERLAY)
		for(var/atom/A in atoms)
			if(A)
				var/icon/img = getFlatIcon(A)
				if(istype(img, /icon))
					if(isliving(A) && A:lying)
						img.BecomeLying()
					var/xoff = (A.x - tx) * 32
					var/yoff = (A.y - ty) * 32
					cap.Blend(img, blendMode2iconMode(A.blend_mode),  A.pixel_x + xoff, A.pixel_y + yoff)

		var/file_name = "map_capture_x[tx]_y[ty]_z[tz]_r[range].png"
		to_chat(user, span_filter_notice("Saved capture in cache as [file_name]."))
		DIRECT_OUTPUT(user, browse_rsc(cap, file_name))
	else
		to_chat(user, span_filter_notice("Target coordinates are incorrect."))
