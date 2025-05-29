#define ICON_STATE_CHECKED 1 /// this dmi is checked. We don't check this one anymore.
#define ICON_STATE_NULL 2 /// this dmi has null-named icon_state, allowing it to show a sprite on vv editor.

/client/proc/debug_variables(datum/D in world)
	set category = "Debug.Investigate"
	set name = "View Variables"
	//set src in world
	var/static/cookieoffset = rand(1, 9999) //to force cookies to reset after the round.

	if(!usr.client || !usr.client.holder) //The usr vs src abuse in this proc is intentional and must not be changed
		to_chat(usr, span_danger("You need to be an administrator to access this."))
		return

	if(!D)
		return

	var/dark = usr.client.prefs ? usr.client.prefs.read_preference(/datum/preference/toggle/holder/vv_dark) : TRUE
	var/use_gfi = usr.client.prefs ? usr.client.prefs.read_preference(/datum/preference/toggle/holder/vv_gfi) : TRUE

	var/datum/asset/asset_cache_datum = get_asset_datum(/datum/asset/simple/vv)
	asset_cache_datum.send(usr)

	var/islist = islist(D) || (!isdatum(D) && hascall(D, "Cut")) // Some special lists don't count as lists, but can be detected by if they have list procs
	if(!islist && !isdatum(D))
		return

	//VOREStation Edit Start - the rest of this proc in a spawn
	spawn(0)
		var/title = ""
		var/refid = "\ref[D]"
		var/icon/sprite
		var/hash

		var/type = islist ? /list : D.type
		var/no_icon = FALSE

		if(isatom(D))
			var/atom/AT = D
			if(use_gfi)
				sprite = getFlatIcon(D)
				if(!sprite)
					no_icon = TRUE
			else if(AT.icon && AT.icon_state)
				sprite = new /icon(AT.icon, AT.icon_state)
			else
				no_icon = TRUE

		else if(isimage(D))
			// icon_state=null shows first image even if dmi has no icon_state for null name.
			// This list remembers which dmi has null icon_state, to determine if icon_state=null should display a sprite
			// (NOTE: icon_state="" is correct, but saying null is obvious)
			var/static/list/dmi_nullstate_checklist = list()
			var/image/image_object = D
			var/icon_filename_text = "[image_object.icon]" // "icon(null)" type can exist. textifying filters it.
			if(icon_filename_text)
				if(image_object.icon_state)
					sprite = icon(image_object.icon, image_object.icon_state)

				else // it means: icon_state=""
					if(!dmi_nullstate_checklist[icon_filename_text])
						dmi_nullstate_checklist[icon_filename_text] = ICON_STATE_CHECKED
						if(icon_exists(image_object.icon, ""))
							// this dmi has nullstate. We'll allow "icon_state=null" to show image.
							dmi_nullstate_checklist[icon_filename_text] = ICON_STATE_NULL

					if(dmi_nullstate_checklist[icon_filename_text] == ICON_STATE_NULL)
						sprite = icon(image_object.icon, image_object.icon_state)

		var/sprite_text
		if(sprite)
			hash = md5(sprite)
			src << browse_rsc(sprite, "vv[hash].png")
			sprite_text = no_icon ? "\[NO ICON\]" : "<img src='vv[hash].png'></td><td>"

		title = "[D] (\ref[D]) = [type]"
		var/formatted_type = replacetext("[type]", "/", "<wbr>/")

		var/list/header = islist(D)? list(span_bold("/list")) : D.vv_get_header()

		var/ref_line = "@[copytext(refid, 2, -1)]" // get rid of the brackets, add a @ prefix for copy pasting in asay

		var/marked_line
		if(holder && holder.marked_datum && holder.marked_datum == D)
			marked_line = VV_MSG_MARKED
		var/varedited_line = ""
		if(!islist && (D.datum_flags & DF_VAR_EDITED))
			varedited_line = VV_MSG_EDITED
		var/deleted_line
		if(!islist && D.gc_destroyed)
			deleted_line = VV_MSG_DELETED

		var/list/dropdownoptions = list()
		var/autoconvert_dropdown = FALSE
		if (islist)
			dropdownoptions = list(
				"---",
				"Add Item" = "?_src_=vars;[HrefToken()];[VV_HK_LIST_ADD]=TRUE;target=[refid]",
				"Remove Nulls" = "?_src_=vars;[HrefToken()];[VV_HK_LIST_ERASE_NULLS]=TRUE;target=[refid]",
				"Remove Dupes" = "?_src_=vars;[HrefToken()];[VV_HK_LIST_ERASE_DUPES]=TRUE;target=[refid]",
				"Set len" = "?_src_=vars;[HrefToken()];[VV_HK_LIST_SET_LENGTH]=TRUE;target=[refid]",
				"Shuffle" = "?_src_=vars;[HrefToken()];[VV_HK_LIST_SHUFFLE]=TRUE;target=[refid]",
				// "Show VV To Player" = "?_src_=vars;[HrefToken()];[VV_HK_EXPOSE]=TRUE;target=[refid]" // TODO - Not yet implemented for lists
				)
			autoconvert_dropdown = TRUE
		else
			dropdownoptions = D.vv_get_dropdown()
		var/list/dropdownoptions_html = list()
		if(autoconvert_dropdown)
			for (var/name in dropdownoptions)
				var/link = dropdownoptions[name]
				if (link)
					dropdownoptions_html += "<option value='[link]'>[name]</option>"
				else
					dropdownoptions_html += "<option value>[name]</option>"
		else
			dropdownoptions_html = dropdownoptions + D.get_view_variables_options()

		var/list/names = list()
		if (!islist)
			names = D.get_variables()
		//sleep(1)//For some reason, without this sleep, VVing will cause client to disconnect on certain objects. //VOREStation edit - commented out, replaced with spawn(0) above

		var/ui_scale = prefs?.read_preference(/datum/preference/toggle/ui_scale)

		var/list/variable_html = list()
		if(islist)
			var/list/L = D
			for (var/i in 1 to L.len)
				var/key = L[i]
				var/value
				if(IS_NORMAL_LIST(L) && IS_VALID_ASSOC_KEY(key))
					value = L[key]
				variable_html += debug_variable(i, value, 0, D)
		else
			names = sortList(names)
			for (var/V in names)
				if(D.can_vv_get(V))
					variable_html += D.vv_get_var(V)

		var/html = {"
	<!DOCTYPE html>
	<html class="[dark ? "dark" : ""]">
		<head>
			<meta http-equiv="X-UA-Compatible" content="IE=edge" />
			<meta charset="utf-8" />
			<title>[title]</title>
			<link rel="stylesheet" type="text/css" href="[SSassets.transport.get_asset_url("view_variables.css")]">
			[!ui_scale && window_scaling ? "<style>body {zoom: [100 / window_scaling]%;}</style>" : ""]
		</head>
		<body onload='selectTextField()' onkeydown='return handle_keydown()' onkeyup='handle_keyup()'>
			<script type="text/javascript">
				// onload
				function selectTextField() {
					var filter_text = document.getElementById('filter');
					filter_text.focus();
					filter_text.select();
					var lastsearch = getCookie("[refid][cookieoffset]search");
					if (lastsearch) {
						filter_text.value = lastsearch;
						updateSearch();
					}
				}
				function getCookie(cname) {
					var name = cname + "=";
					var ca = document.cookie.split(';');
					for(var i=0; i<ca.length; i++) {
						var c = ca\[i];
						while (c.charAt(0)==' ') c = c.substring(1,c.length);
						if (c.indexOf(name)==0) return c.substring(name.length,c.length);
					}
					return "";
				}

				// main search functionality
				var last_filter = "";
				function updateSearch() {
					var filter = document.getElementById('filter').value.toLowerCase();
					var vars_ol = document.getElementById("vars");

					if (filter === last_filter) {
						// An event triggered an update but nothing has changed.
						return;
					} else if (filter.indexOf(last_filter) === 0) {
						// The new filter starts with the old filter, fast path by removing only.
						var children = vars_ol.childNodes;
						for (var i = children.length - 1; i >= 0; --i) {
							try {
								var li = children\[i];
								if (li.innerText.toLowerCase().indexOf(filter) == -1) {
									vars_ol.removeChild(li);
								}
							} catch(err) {}
						}
					} else {
						// Remove everything and put back what matches.
						while (vars_ol.hasChildNodes()) {
							vars_ol.removeChild(vars_ol.lastChild);
						}

						for (var i = 0; i < complete_list.length; ++i) {
							try {
								var li = complete_list\[i];
								if (!filter || li.innerText.toLowerCase().indexOf(filter) != -1) {
									vars_ol.appendChild(li);
								}
							} catch(err) {}
						}
					}

					last_filter = filter;
					document.cookie="[refid][cookieoffset]search="+encodeURIComponent(filter);

				}

				// onkeydown
				function handle_keydown() {
					if(event.keyCode == 116) {  //F5 (to refresh properly)
						document.getElementById("refresh_link").click();
						event.preventDefault ? event.preventDefault() : (event.returnValue = false);
						return false;
					}
					return true;
				}

				// onkeyup
				function handle_keyup() {
					updateSearch();
				}

				// onchange
				function handle_dropdown(list) {
					var value = list.options\[list.selectedIndex].value;
					if (value !== "") {
						location.href = value;
					}
					list.selectedIndex = 0;
					document.getElementById('filter').focus();
				}

				// byjax
				function replace_span(what) {
					var idx = what.indexOf(':');
					document.getElementById(what.substr(0, idx)).innerHTML = what.substr(idx + 1);
				}
			</script>
			<div align='center'>
				<table width='100%'>
					<tr>
						<td width='50%'>
							<table align='center' width='100%'>
								<tr>
									<td>
										[sprite_text]
										<div align='center'>
											[header.Join()]
										</div>
									</td>
								</tr>
							</table>
							<div align='center'>
								<b><font size='1'>[formatted_type]</font></b>
								<br><b><font size='1'>[ref_line]</font></b>
								<span id='marked'>[marked_line]</span>
								<span id='varedited'>[varedited_line]</span>
								<span id='deleted'>[deleted_line]</span>
							</div>
						</td>
						<td width='50%'>
							<div align='center'>
								<a id='refresh_link' href='byond://?_src_=vars;
	datumrefresh=[refid]'>Refresh</a>
								<form>
									<select name="file" size="1"
										onchange="handle_dropdown(this)"
										onmouseclick="this.focus()">
										<option value selected>Select option</option>
										[dropdownoptions_html.Join()]
									</select>
								</form>
							</div>
						</td>
					</tr>
				</table>
			</div>
			<hr>
				<b>E</b> - Edit, tries to determine the variable type by itself.<br>
				<b>C</b> - Change, asks you for the var type first.<br>
				<b>M</b> - Mass modify: changes this variable for all objects of this type.<br>
			<hr>
			<table width='100%'>
				<tr>
					<td width='20%'>
						<div align='center'>
							<b>Search:</b>
						</div>
					</td>
					<td width='80%'>
						<input type='text' id='filter' name='filter_text' value='' style='width:100%;'>
					</td>
				</tr>
			</table>
			<hr>
			<ol id='vars'>
				[variable_html.Join()]
			</ol>
			<script type='text/javascript'>
				var complete_list = \[\];
				var lis = document.getElementById("vars").children;
				for(var i = lis.length; i--;) complete_list\[i\] = lis\[i\];
			</script>
		</body>
	</html>
	"}
		var/size_string = "size=475x650";
		if(ui_scale && window_scaling)
			size_string = "size=[475 * window_scaling]x[650 * window_scaling]"

		src << browse(html, "window=variables[refid];[size_string]")

/client/proc/vv_update_display(datum/D, span, content)
	src << output("[span]:[content]", "variables\ref[D].browser:replace_span")

#undef ICON_STATE_CHECKED
#undef ICON_STATE_NULL
