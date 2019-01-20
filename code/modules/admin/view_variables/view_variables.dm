
// Variables to not even show in the list.
// step_* and bound_* are here because they literally break the game and do nothing else.
// parent_type is here because it's pointless to show in VV.
/var/list/view_variables_hide_vars = list("bound_x", "bound_y", "bound_height", "bound_width", "bounds", "parent_type", "step_x", "step_y", "step_size")
// Variables not to expand the lists of. Vars is pointless to expand, and overlays/underlays cannot be expanded.
/var/list/view_variables_dont_expand = list("overlays", "underlays", "vars")

/client/proc/debug_variables(datum/D in world)
	set category = "Debug"
	set name = "View Variables"

	if(!check_rights(0))
		return

	if(!D)
		return

	var/icon/sprite
	if(istype(D, /atom))
<<<<<<< HEAD
		var/atom/A = D
		if(A.icon && A.icon_state)
			sprite = icon(A.icon, A.icon_state)
			usr << browse_rsc(sprite, "view_vars_sprite.png")
=======
		var/atom/AT = D
		if(AT.icon && AT.icon_state)
			sprite = new /icon(AT.icon, AT.icon_state)
			hash = md5(AT.icon)
			hash = md5(hash + AT.icon_state)
			src << browse_rsc(sprite, "vv[hash].png")

	title = "[D] (\ref[D]) = [type]"
	var/formatted_type = replacetext("[type]", "/", "<wbr>/")

	var/sprite_text
	if(sprite)
		sprite_text = "<img src='vv[hash].png'></td><td>"
	var/list/header = islist(D)? list("<b>/list</b>") : D.vv_get_header()

	var/marked
	if(holder && holder.marked_datum && holder.marked_datum == D)
		marked = VV_MSG_MARKED
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
			"Add Item" = "?_src_=vars;listadd=[refid]",
			"Remove Nulls" = "?_src_=vars;listnulls=[refid]",
			"Remove Dupes" = "?_src_=vars;listdupes=[refid]",
			"Set len" = "?_src_=vars;listlen=[refid]",
			"Shuffle" = "?_src_=vars;listshuffle=[refid]",
			"Show VV To Player" = "?_src_=vars;expose=[refid]"
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
		for (var/V in D.vars)
			names += V
	sleep(1)//For some reason, without this sleep, VVing will cause client to disconnect on certain objects.
>>>>>>> c480a51... Merge pull request #5883 from kevinz000/150_hours_of_testing

	usr << browse_rsc('code/js/view_variables.js', "view_variables.js")

	var/html = {"
<<<<<<< HEAD
		<html>
		<head>
			<script src='view_variables.js'></script>
			<title>[D] (\ref[D] - [D.type])</title>
			<style>
				body { font-family: Verdana, sans-serif; font-size: 9pt; }
				.value { font-family: "Courier New", monospace; font-size: 8pt; }
			</style>
		</head>
		<body onload='selectTextField(); updateSearch()'; onkeyup='updateSearch()'>
			<div align='center'>
				<table width='100%'><tr>
=======
<html>
	<head>
		<title>[title]</title>
		<style>
			body {
				font-family: Verdana, sans-serif;
				font-size: 9pt;
			}
			.value {
				font-family: "Courier New", monospace;
				font-size: 8pt;
			}
		</style>
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
>>>>>>> c480a51... Merge pull request #5883 from kevinz000/150_hours_of_testing
					<td width='50%'>
						<table align='center' width='100%'><tr>
							[sprite ? "<td><img src='view_vars_sprite.png'></td>" : ""]
							<td><div align='center'>[D.get_view_variables_header()]</div></td>
						</tr></table>
						<div align='center'>
							<b><font size='1'>[replacetext("[D.type]", "/", "/<wbr>")]</font></b>
							[holder.marked_datum == D ? "<br/><font size='1' color='red'><b>Marked Object</b></font>" : ""]
						</div>
					</td>
					<td width='50%'>
						<div align='center'>
							<a href='?_src_=vars;datumrefresh=\ref[D]'>Refresh</a>
							<form>
<<<<<<< HEAD
								<select name='file'
								        size='1'
								        onchange='loadPage(this.form.elements\[0\])'
								        target='_parent._top'
								        onmouseclick='this.focus()'
								        style='background-color:#ffffff'>
									<option>Select option</option>
									<option />
									<option value='?_src_=vars;mark_object=\ref[D]'>Mark Object</option>
									<option value='?_src_=vars;call_proc=\ref[D]'>Call Proc</option>
									[D.get_view_variables_options()]
=======
								<select name="file" size="1"
									onchange="handle_dropdown(this)"
									onmouseclick="this.focus()">
									<option value selected>Select option</option>
									[dropdownoptions_html.Join()]
>>>>>>> c480a51... Merge pull request #5883 from kevinz000/150_hours_of_testing
								</select>
							</form>
						</div>
					</td>
				</tr></table>
			</div>
			<hr/>
			<font size='1'>
				<b>E</b> - Edit, tries to determine the variable type by itself.<br/>
				<b>C</b> - Change, asks you for the var type first.<br/>
				<b>M</b> - Mass modify: changes this variable for all objects of this type.<br/>
			</font>
			<hr/>
			<table width='100%'><tr>
				<td width='20%'>
					<div align='center'>
						<b>Search:</b>
					</div>
				</td>
				<td width='80%'>
					<input type='text'
					       id='filter'
					       name='filter_text'
					       value=''
					       style='width:100%;' />
				</td>
			</tr></table>
			<hr/>
			<ol id='vars'>
				[make_view_variables_var_list(D)]
			</ol>
		</body>
		</html>
		"}

	usr << browse(html, "window=variables\ref[D];size=475x650")


/proc/make_view_variables_var_list(datum/D)
	. = ""
	var/list/variables = list()
	for(var/x in D.vars)
		if(x in view_variables_hide_vars)
			continue
		variables += x
	variables = sortList(variables)
	for(var/x in variables)
		. += make_view_variables_var_entry(D, x, D.vars[x])

/proc/make_view_variables_var_entry(datum/D, varname, value, level=0)
	var/ecm = null
	var/vtext = null
	var/extra = null

	if(D)
		ecm = {"
			(<a href='?_src_=vars;datumedit=\ref[D];varnameedit=[varname]'>E</a>)
			(<a href='?_src_=vars;datumchange=\ref[D];varnamechange=[varname]'>C</a>)
			(<a href='?_src_=vars;datummass=\ref[D];varnamemass=[varname]'>M</a>)
			"}

	if(isnull(value))
		vtext = "null"
	else if(istext(value))
		vtext = "\"[value]\""
	else if(isicon(value))
		vtext = "[value]"
	else if(isfile(value))
		vtext = "'[value]'"
	else if(istype(value, /datum))
		var/datum/DA = value
		if("[DA]" == "[DA.type]" || !"[DA]")
			vtext = "<a href='?_src_=vars;Vars=\ref[DA]'>\ref[DA]</a> - [DA.type]"
		else
			vtext = "<a href='?_src_=vars;Vars=\ref[DA]'>\ref[DA]</a> - [DA] ([DA.type])"
	else if(istype(value, /client))
		var/client/C = value
		vtext = "<a href='?_src_=vars;Vars=\ref[C]'>\ref[C]</a> - [C] ([C.type])"
	else if(islist(value))
		var/list/L = value
		var/removed = 0
		if(varname == "contents")
			var/list/original = value
			L = original.Copy() //We'll take a copy to manipulate
			removed = D.view_variables_filter_contents(L)
		vtext = "/list ([L.len]+[removed]H)"
		if(!(varname in view_variables_dont_expand) && L.len > 0 && L.len < 100)
			extra = "<ul>"
			var/index = 1
			for (var/entry in L)
				if(istext(entry))
					extra += make_view_variables_var_entry(null, entry, L[entry], level+1)
				else
					extra += make_view_variables_var_entry(null, index, L[index], level+1)
				index++
			extra += "</ul>"
	else
		vtext = "[value]"

	return "<li>[ecm][varname] = <span class='value'>[vtext]</span>[extra]</li>"

//Allows us to mask out some contents when it's not necessary to show them
//For example, organs on humans, as the organs are stored in other lists which will also be present
//So there's really no need to list them twice.
/datum/proc/view_variables_filter_contents(list/L)
	return 0 //Return how many items you removed.

/mob/living/carbon/human/view_variables_filter_contents(list/L)
	. = ..()
	L -= ability_master
	.++

/mob/living/carbon/human/view_variables_filter_contents(list/L)
	. = ..()
	var/len_before = L.len
	L -= organs
	L -= internal_organs
	. += len_before - L.len
